local input_handler = require "input_handler"
local gui_rendering = require "gui_rendering"
local battle_data_generator = require "battle_data_generator"
local pointer_entry_generator = require "pointer_entry_generator"
local BACKGROUND_TYPE = require "defs.battle_background_defs"
local BATTLE_STAGE = require "defs.battle_stage_defs"
local GAUNTLET_DEFS = require "defs.gauntlet_defs"
local GAUNTLET_BATTLE_POINTERS = require "defs.gauntlet_battle_pointer_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local mmbn3_utils = require "mmbn3_utils"
local CHIP = require "defs.chip_defs"
local CHIP_NAME_UTILS = require "defs.chip_name_utils"
local CHIP_NAME = require "defs.chip_name_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"
local CHIP_CODE_REVERSE = require "defs.chip_code_reverse_defs"
local CHIP_ICON = require "defs.chip_icon_defs"
local CHIP_PICTURE = require "defs.chip_picture_defs"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_DROP_UTILS = require "defs.chip_drop_utils"
local BUFF_GENERATOR = require "buff_effects.buff_groups"
local START_FOLDER = require "defs.start_folder_defs"
local LOADOUTS = require "loadouts.loadout_defs"
local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

-- TODO: possibly add more states.

local state_logic = {}

state_logic.activated_buffs = {}
state_logic.dropped_chips = {}
state_logic.dropped_buffs = {}
state_logic.initial_state = "initial.State"
state_logic.number_of_activated_buffs = 0
gauntlet_data.current_folder = {}
gauntlet_data.mega_max_hp = 100

state_logic.dropped_chips[1] = CHIP.new_chip_with_code(CHIP_ID.Cannon, CHIP_CODE.A)
state_logic.dropped_chips[2] = CHIP.new_chip_with_code(CHIP_ID.Cannon, CHIP_CODE.B)
state_logic.dropped_chips[3] = CHIP.new_chip_with_code(CHIP_ID.Cannon, CHIP_CODE.C)

state_logic.draft_selection_chips = {}

state_logic.should_redraw = 1

state_logic.hp_patch_frame_counter = 0
state_logic.battle_start_frame_counter = 0

state_logic.dropped_chip = CHIP.new_chip_with_code(CHIP_ID.Cannon, CHIP_CODE.A)
state_logic.dropped_chip.ID = -1
state_logic.dropped_chip.PRINT_NAME = ""
state_logic.loadout_chosen = 0
state_logic.selected_loadout_index = 1


gauntlet_data.current_state = gauntlet_data.GAME_STATE.RUNNING
state_logic.dropped_chip_render_index = 1
state_logic.draft_chip_render_index = 1
state_logic.dropped_buff_render_index = 1
state_logic.folder_chip_render_index = 1


state_logic.gui_change_savestate = nil


state_logic.current_round = 0
state_logic.current_battle = 1
state_logic.battle_pointer_index = 1
state_logic.battle_data = {}

function state_logic.next_round()

    
    -- We just finished the round. We might want to load a savestate? Or just let the user do that.
    state_logic.current_round = state_logic.current_round + 1
    print("Starting Round " .. state_logic.current_round)
    -- Reset all address variables, as we now start from the beginning again.
    state_logic.battle_pointer_index = 1
    local ptr_table_working_address = GENERIC_DEFS.FIRST_GAUNTLET_BATTLE_POINTER_ADDRESS


    -- Patch all battle stage setups. This needs to be done before engaging the gauntlet.
    -- The game loads this probably into RAM, so we could only change that later if we found out the 
    -- respective RAM addresses...
    -- print("4")
    for battle_idx = 1, GAUNTLET_DEFS.BATTLES_PER_ROUND do
        local new_pointer_entry = pointer_entry_generator.new_from_template(GAUNTLET_BATTLE_POINTERS[battle_idx] + 4, BACKGROUND_TYPE.random() , BATTLE_STAGE.random())
        mmbn3_utils.change_battle_pointer_data(ptr_table_working_address, new_pointer_entry)
        ptr_table_working_address = ptr_table_working_address - GENERIC_DEFS.OFFSET_BETWEEN_POINTER_TABLE_ENTRIES
    end
    print("Patched Battle Stage Setups!")

    state_logic.on_next_round()

    -- Potentially do other stuff here. For example, we could set the state to a 'choose-reward' state.

end

function state_logic.patch_next_battle()

    -- This function changes viruses, stage, AI, basically anything related to the fight when
    -- the fight loads.
    print("Battle ", state_logic.current_battle, " start")

    -- When we finished all gauntlet battles, enter the next round.
    if state_logic.battle_pointer_index > GAUNTLET_DEFS.BATTLES_PER_ROUND or 
        state_logic.current_round == 0 then
        --print("3")
        state_logic.next_round()
    end

    --print("MOD: ", state_logic.current_round % GAUNTLET_DEFS.ROUNDS_PER_BUFF_DROP)
    if (state_logic.current_battle - 1) % GAUNTLET_DEFS.ROUNDS_PER_BUFF_DROP == 0 then
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_BUFF_SELECT
    end

    -- print("5")
    
    -- print("7")
    
    -- print("8")
    --print("Patched Battle ", state_logic.current_battle)

    
    

    
    

end

local DEBUG = 0
function state_logic.on_battle_end()

    if state_logic.battle_pointer_index > GAUNTLET_DEFS.BATTLES_PER_ROUND then
       gauntlet_data.current_state = gauntlet_data.GAME_STATE.LOAD_INITIAL 
    end  

end

function state_logic.determine_drops(number_of_drops)

    if state_logic.battle_data[state_logic.current_battle - 1] == nil then

        -- First round. Do we do anything here?
        -- For now, we don't.
        
        
    else

        -- TODO: determine drops from state_logic.battle_data[state_logic.current_battle].ENTITIES entity droptables.
        --TODO: for now, this just randomizes.
        --state_logic.randomize_dropped_chips(number_of_drops)
        state_logic.dropped_chips = CHIP_DROP_UTILS.dropped_chips_from_battle(state_logic.battle_data[state_logic.current_battle - 1], state_logic.current_round, number_of_drops)

        state_logic.update_dropped_chips_pictures(state_logic.dropped_chips)
        

    end

    

end

function state_logic.on_enter_battle()
    
    

    state_logic.patch_next_battle()
    state_logic.determine_drops(GAUNTLET_DEFS.NUMBER_OF_DROPPED_CHIPS)
    state_logic.shuffle_folder()

    if gauntlet_data.current_state ~= gauntlet_data.GAME_STATE.TRANSITION_TO_BUFF_SELECT and  
        gauntlet_data.current_state ~= gauntlet_data.GAME_STATE.BUFF_SELECT then
            gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_CHIP_SELECT
    end


    if state_logic.loadout_chosen == 0 then

        gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_CHOOSE_STARTING_LOADOUT

    end

    --print("STATE_ENTER: ", gauntlet_data.current_state)
    --print(print(state_logic.dropped_chip))
    
    
    --gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_CHIP_SELECT

end


function state_logic.on_next_round()
    
    --print ("BEFORE MEGA MAX INCREASE PER ROUND")
    gauntlet_data.mega_max_hp = gauntlet_data.mega_max_hp + GAUNTLET_DEFS.HP_INCREASE_PER_ROUND[state_logic.current_round]
    gauntlet_data.hp_patch_required = 1
    --print(" MEGA MAX HP: ", gauntlet_data.mega_max_hp)
    --print ("BEFORE CHANGE MAX HP")
    
    --print ("BEFORE TRANSITION TO BUFF SELECT")
    gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_BUFF_SELECT

end


function state_logic.reset_selected_chips()
    state_logic.dropped_chip_render_index = 1
    state_logic.folder_chip_render_index = 1
end

function state_logic.randomize_dropped_chips(number_of_dropped_chips)
    state_logic.dropped_chips = {}
    for chip_idx = 1,number_of_dropped_chips do

        state_logic.dropped_chips[chip_idx] = CHIP.new_random_chip_with_random_code()
        --state_logic.dropped_chips[chip_idx] = CHIP.new_chip_with_code(CHIP_ID.Bolt, 0)

    end
   
    
end

function state_logic.randomize_folder()

    for chip_idx = 1,GENERIC_DEFS.NUMBER_OF_CHIPS_IN_FOLDER do

        gauntlet_data.current_folder[chip_idx] = CHIP.new_random_chip_with_random_code()
        --gauntlet_data.current_folder[chip_idx] = CHIP.new_chip_with_code(0x1, 0)

    end
   
    
end



function state_logic.initialize_folder()

    gauntlet_data.current_folder = {}

    gauntlet_data.current_folder = START_FOLDER.get_random(nil)

    
end


function state_logic.update_dropped_chips_pictures(list_of_chips)

    for chip_idx = 1,#list_of_chips do
        local chip = list_of_chips[chip_idx]
        local chip_address = CHIP_DATA[chip.ID].CHIP_PICTURE_OFFSET
        local chip_palette_address = CHIP_DATA[chip.ID].CHIP_PICTURE_PALETTE_OFFSET
        list_of_chips[chip_idx].ARGB_PICTURE = CHIP_PICTURE.get_argb_2d_array_for_image_address(chip_address, chip_palette_address)

    end

end

function state_logic.get_printable_chip_name(chip)

    if chip == nil then
        return ""
    end

    if chip.ID == -1 then
        return ""
    end

    local string_with_special_chars = CHIP_NAME[chip.ID] .. " " .. CHIP_CODE_REVERSE[chip.CODE]

    return CHIP_NAME_UTILS.replace_special_chars(string_with_special_chars)

end

function state_logic.get_argb_icon(chip)

    if chip == nil then
        return nil
    end


    if chip.ID == -1 then
        return nil
    end

    local chip_address = CHIP_DATA[chip.ID].CHIP_ICON_OFFSET

    return CHIP_ICON.get_argb_2d_array_for_icon_address(chip_address)

end



function state_logic.update_argb_chip_icons_in_folder()
    
    for chip_idx = 1,#gauntlet_data.current_folder do
        gauntlet_data.current_folder[chip_idx].ARGB_ICON = state_logic.get_argb_icon(gauntlet_data.current_folder[chip_idx])
    end
    

end


function state_logic.update_printable_chip_names_in_folder()

    for chip_idx = 1,#gauntlet_data.current_folder do
        gauntlet_data.current_folder[chip_idx].PRINT_NAME = state_logic.get_printable_chip_name(gauntlet_data.current_folder[chip_idx])
    end

end

function state_logic.update_buff_discriptions()

    -- This updates all buff descriptions for the current round.
    for buff_idx = 1,#state_logic.dropped_buffs do
        state_logic.dropped_buffs[buff_idx].DESCRIPTION = state_logic.dropped_buffs[buff_idx]:get_description(state_logic.current_round)
    end

end

function state_logic.undo_activated_buffs()
    
    if state_logic.number_of_activated_buffs == 0 then
        return
    end

    for i = state_logic.number_of_activated_buffs, 1 do
        state_logic.activated_buffs[i]:deactivate(i)
    end

end

function state_logic.shuffle_folder()
    -- This shuffles the folder according to the currently chosen sorting mode

    if gauntlet_data.folder_shuffle_state == 0 then
        -- Alphabetically
        table.sort(gauntlet_data.current_folder, function(a, b)
            return CHIP_NAME[a.ID] < CHIP_NAME[b.ID]
          end)

    elseif gauntlet_data.folder_shuffle_state == 1 then
        -- Code
        table.sort(gauntlet_data.current_folder, function(a, b)
            return a.CODE < b.CODE
          end)

    elseif gauntlet_data.folder_shuffle_state == 2 then
        -- ID
        table.sort(gauntlet_data.current_folder, function(a, b)
            return a.ID < b.ID
          end)

    elseif gauntlet_data.folder_shuffle_state == 3 then
        -- Damage
        table.sort(gauntlet_data.current_folder, function(a, b)
            return CHIP_DATA[a.ID].DAMAGE < CHIP_DATA[b.ID].DAMAGE 
          end)
    end

    
    

end



function state_logic.initialize()

    math.randomseed(os.time())

    savestate.load(state_logic.initial_state)

    -- Undo all activated buffs
    state_logic.undo_activated_buffs()
    state_logic.number_of_activated_buffs = 0
    state_logic.activated_buffs = {}
    gauntlet_data.stage = 0
    gauntlet_data.mega_max_hp = 100
    gauntlet_data.hp_patch_required = 0
    gauntlet_data.folder_shuffle_state = 0
    gauntlet_data.mega_style = 0x00
    gauntlet_data.mega_AirShoes = 0
    gauntlet_data.mega_FastGauge = 0
    gauntlet_data.mega_UnderShirt = 0
    gauntlet_data.mega_SuperArmor = 0
    gauntlet_data.mega_AttackPlus = 0
    gauntlet_data.mega_ChargePlus = 0
    gauntlet_data.mega_SpeedPlus = 0
    gauntlet_data.mega_WeaponLevelPlus = 1
    gauntlet_data.cust_style_number_of_chips = 0
    gauntlet_data.cust_screen_number_of_chips = 5
    gauntlet_data.folder_view = 0
    state_logic.loadout_chosen = 0
    state_logic.selected_loadout_index = 1
    state_logic.dropped_chip = CHIP.new_chip_with_code(CHIP_ID.Cannon, CHIP_CODE.A)
    state_logic.dropped_chip.ID = -1
    state_logic.dropped_chip.PRINT_NAME = state_logic.get_printable_chip_name(state_logic.dropped_chip)
    state_logic.dropped_chip.ARGB_ICON = state_logic.get_argb_icon(state_logic.dropped_chip)
    state_logic.battle_data = {}
    state_logic.dropped_buffs = {}
    state_logic.dropped_buff_render_index = 1
    state_logic.current_round = 0
    state_logic.current_battle = 1
    state_logic.battle_pointer_index = 1
    state_logic.hp_patch_frame_counter = 0
    state_logic.battle_start_frame_counter = 0
    state_logic.reset_selected_chips()
    gauntlet_data.folder_draft_chip_list = {}
    state_logic.draft_selection_chips = {}
    gauntlet_data.folder_draft_chip_generator = {}
    BUFF_GENERATOR.initialize()
    state_logic.initialize_folder()
    state_logic.update_printable_chip_names_in_folder()
    state_logic.update_argb_chip_icons_in_folder()
    
    gauntlet_data.current_state = gauntlet_data.GAME_STATE.RUNNING

    client.unpause()
    -- Upon start, initialize the current round:
    --state_logic.next_round()



end

-- This function checks for the button combination A-B-L-R to reset the script.
function state_logic.check_reset()

    if      input_handler.inputs_held["A"]
        and input_handler.inputs_held["B"]
        and input_handler.inputs_held["L"]
        and input_handler.inputs_held["R"] then


        state_logic.initialize()



    end

end


function state_logic.patch_before_battle_start()

    -- Patch folder with all new stuff.
    -- state_logic.randomize_folder()
    mmbn3_utils.patch_folder(gauntlet_data.current_folder, GENERIC_DEFS.FOLDER_START_ADDRESS_RAM)
        
    local new_battle_data = battle_data_generator.random_from_battle(state_logic.current_battle)

    -- This is used to determine drops.
    state_logic.battle_data[state_logic.current_battle] = new_battle_data


    mmbn3_utils.patch_battle(GAUNTLET_BATTLE_POINTERS[state_logic.battle_pointer_index], new_battle_data)
    mmbn3_utils.patch_entity_data(state_logic.battle_data[state_logic.current_battle].ENTITIES)
    state_logic.current_battle = state_logic.current_battle + 1
    state_logic.battle_pointer_index = state_logic.battle_pointer_index + 1
    state_logic.update_printable_chip_names_in_folder()
    state_logic.update_argb_chip_icons_in_folder()
    
    mmbn3_utils.set_stage(gauntlet_data.stage) 
    
    mmbn3_utils.writebyte(0x02005773, gauntlet_data.mega_AirShoes)
    mmbn3_utils.writebyte(0x02005788, gauntlet_data.mega_FastGauge)
    mmbn3_utils.writebyte(0x02005774, gauntlet_data.mega_UnderShirt)
    mmbn3_utils.writebyte(0x02005771, gauntlet_data.mega_SuperArmor)
    mmbn3_utils.writebyte(0x02005778, gauntlet_data.mega_AttackPlus)
    mmbn3_utils.writebyte(0x0200577A, gauntlet_data.mega_ChargePlus)
    mmbn3_utils.writebyte(0x02005779, gauntlet_data.mega_SpeedPlus)
    mmbn3_utils.writebyte(0x0200577D, gauntlet_data.mega_WeaponLevelPlus)


    mmbn3_utils.change_megaman_max_hp(gauntlet_data.mega_max_hp) 
    -- We need to wait a few frames to patch the in-battle HP of megaman in RAM. Otherwise we would need a hook way before battle, which I don't want to find right now.
    if  gauntlet_data.hp_patch_required == 1 then
        mmbn3_utils.change_megaman_max_hp(gauntlet_data.mega_max_hp) 
        mmbn3_utils.change_megaman_current_hp(gauntlet_data.mega_max_hp) 
        gauntlet_data.hp_patch_required = 0
    end

    mmbn3_utils.change_megaman_style(gauntlet_data.mega_style)

    mmbn3_utils.change_number_of_cust_screen_chips(gauntlet_data.cust_style_number_of_chips + gauntlet_data.cust_screen_number_of_chips)  




end


function state_logic.folder_view_switch_and_sort()

    if input_handler.inputs_pressed["Select"] == true then
        gauntlet_data.folder_view = (gauntlet_data.folder_view + 1) % 2
        state_logic.should_redraw = 1
    end

    if input_handler.inputs_pressed["Start"] == true then
        gauntlet_data.folder_shuffle_state = (gauntlet_data.folder_shuffle_state + 1) % 4
        state_logic.shuffle_folder()
        
        state_logic.should_redraw = 1
    end

end


function state_logic.main_loop()

    if DEBUG == 1 then
        print ("DEBUG: STATE: ", gauntlet_data.current_state)
    end
    input_handler.handle_inputs()


    state_logic.check_reset()


    
    --print ("Current state: " .. gauntlet_data.current_state)
    if gauntlet_data.current_state == gauntlet_data.GAME_STATE.RUNNING then

        -- Do nothing.

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.TRANSITION_TO_CHIP_SELECT then
        -- We pause here and make a savestate.
        print("Transition to chip select.")
        state_logic.gui_change_savestate = memorysavestate.savecorestate()
        state_logic.reset_selected_chips()
        if state_logic.battle_data[state_logic.current_battle - 1] == nil then
            -- We didn't finish a battle yet, therefore no chip.

            gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_CHIP_REPLACE
            --print(state_logic.dropped_chip)
        else

            -- Drop chips!
            -- TODO: actually use chips from a droptable from viruses.

            state_logic.determine_drops(GAUNTLET_DEFS.NUMBER_OF_DROPPED_CHIPS)

            for idx = 1,#state_logic.dropped_chips do
                state_logic.dropped_chips[idx].PRINT_NAME = state_logic.get_printable_chip_name(state_logic.dropped_chips[idx])
                print(bizstring.hex(state_logic.dropped_chips[idx].ID))
                print(state_logic.dropped_chips[idx].PRINT_NAME)
            end

            
            
            gauntlet_data.current_state = gauntlet_data.GAME_STATE.CHIP_SELECT
            

        end
        client.pause()
        state_logic.should_redraw = 1
        

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.CHIP_SELECT then
        

        if input_handler.inputs_pressed["Left"] == true then
            state_logic.dropped_chip_render_index = (state_logic.dropped_chip_render_index - 1) % (#state_logic.dropped_chips)
            if state_logic.dropped_chip_render_index == 0 then
                state_logic.dropped_chip_render_index = (#state_logic.dropped_chips)
            end
            state_logic.should_redraw = 1
        end

        if input_handler.inputs_pressed["Right"] == true then
            state_logic.dropped_chip_render_index = (state_logic.dropped_chip_render_index + 1) % (#state_logic.dropped_chips + 1)
           
            if state_logic.dropped_chip_render_index == 0 then
                state_logic.dropped_chip_render_index = 1
            end
            state_logic.should_redraw = 1
        end

        state_logic.folder_view_switch_and_sort()

        if input_handler.inputs_pressed["A"] == true then

            --print("Selected a Chip!")
            
            state_logic.dropped_chip = state_logic.dropped_chips[state_logic.dropped_chip_render_index]

            state_logic.dropped_chip.PRINT_NAME = state_logic.get_printable_chip_name(state_logic.dropped_chip)
            state_logic.dropped_chip.ARGB_ICON = state_logic.get_argb_icon(state_logic.dropped_chip)
            gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_CHIP_REPLACE
            gauntlet_data.folder_view = 0
            state_logic.should_redraw = 1
        end

        if state_logic.should_redraw == 1 then

            
            if gauntlet_data.folder_view == 0 then
                gui_rendering.render_chip_selection(state_logic.dropped_chips, state_logic.dropped_chip_render_index)
            else
                gui_rendering.render_folder(gauntlet_data.current_folder, nil, nil)
            end


            
            gui.DrawFinish()
            memorysavestate.loadcorestate(state_logic.gui_change_savestate)
            state_logic.should_redraw = 0
        end



        

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.TRANSITION_TO_CHIP_REPLACE then
        state_logic.gui_change_savestate = memorysavestate.savecorestate()
        memorysavestate.loadcorestate(state_logic.gui_change_savestate)
        -- print(state_logic.dropped_chip)
        print("Transition to chip replace.")
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.CHIP_REPLACE
        state_logic.should_redraw = 1

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.CHIP_REPLACE then
        --print("IN CHIP_REPLACE")
        -- Render folder, respond to inputs for selected chip. Patch folder for selected chip, then unpause.
        --print(gauntlet_data.current_state)
        -- We render 15 x 2 chips.
        
        local num_chips_per_col = 15
        local num_chips_per_folder = 30

        if input_handler.inputs_pressed["Start"] == true then
            -- Shuffle folder according to Alpha/Code/ID/Attack
            gauntlet_data.folder_shuffle_state = (gauntlet_data.folder_shuffle_state + 1) % 4
            state_logic.shuffle_folder()
            
            state_logic.should_redraw = 1
        end

        --print (input_handler.inputs_pressed["A"])
        if input_handler.inputs_pressed["Left"] == true then
            state_logic.folder_chip_render_index = (state_logic.folder_chip_render_index - num_chips_per_col) % (num_chips_per_folder)
            if state_logic.folder_chip_render_index == 0 then
                state_logic.folder_chip_render_index = 30
            end
            state_logic.should_redraw = 1
        end

        if input_handler.inputs_pressed["Right"] == true then
            state_logic.folder_chip_render_index = (state_logic.folder_chip_render_index + num_chips_per_col) % (num_chips_per_folder)
            if state_logic.folder_chip_render_index == 0 then
                state_logic.folder_chip_render_index = 30
            end
            state_logic.should_redraw = 1
        end

        if input_handler.inputs_pressed["Up"] == true then
            state_logic.folder_chip_render_index = (state_logic.folder_chip_render_index - 1) % (num_chips_per_folder + 1)
            --print ("UP PRESSED")
            if state_logic.folder_chip_render_index == 0 then
                state_logic.folder_chip_render_index = 30
            end
            state_logic.should_redraw = 1
        end

        if input_handler.inputs_pressed["Down"] == true then
            state_logic.folder_chip_render_index = (state_logic.folder_chip_render_index + 1) % (num_chips_per_folder + 1)
            if state_logic.folder_chip_render_index == 0 then
                state_logic.folder_chip_render_index = 1
            end
            state_logic.should_redraw = 1
        end

        


        if input_handler.inputs_pressed["A"] == true then
            -- TODO: add chip to folder!
            --print("A pressed")
            
            if state_logic.dropped_chip.ID ~= -1 then
                gauntlet_data.current_folder[state_logic.folder_chip_render_index] = state_logic.dropped_chip
            end

            gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_RUNNING
            state_logic.should_redraw = 1
        end

        if input_handler.inputs_pressed["B"] == true then
            -- Just skip - we didn't want a chip!
            --print("B pressed")
            gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_RUNNING
            
            state_logic.should_redraw = 1
        end
        --print(state_logic.folder_chip_render_index)

        if state_logic.should_redraw == 1 then
            gui_rendering.render_folder(gauntlet_data.current_folder, state_logic.folder_chip_render_index, state_logic.dropped_chip)
            gui.DrawFinish()
            memorysavestate.loadcorestate(state_logic.gui_change_savestate)
            state_logic.should_redraw = 0
        end

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.TRANSITION_TO_BUFF_SELECT then    

        state_logic.gui_change_savestate = memorysavestate.savecorestate()
        
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.BUFF_SELECT
        state_logic.should_redraw = 1
        state_logic.dropped_buffs = BUFF_GENERATOR.random_buffs_from_round(state_logic.current_round, GAUNTLET_DEFS.NUMBER_OF_DROPPED_BUFFS)
        state_logic.update_buff_discriptions()
        memorysavestate.loadcorestate(state_logic.gui_change_savestate)
        client.pause()


    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.BUFF_SELECT then
        --print ("IN BUFF_SELECT")
        
        if input_handler.inputs_pressed["Up"] == true then
            state_logic.dropped_buff_render_index = (state_logic.dropped_buff_render_index - 1) % (#state_logic.dropped_buffs)
            
            if state_logic.dropped_buff_render_index == 0 then
                state_logic.dropped_buff_render_index = (#state_logic.dropped_buffs)
            end
            state_logic.should_redraw = 1
        end

        if input_handler.inputs_pressed["Down"] == true then
            state_logic.dropped_buff_render_index = (state_logic.dropped_buff_render_index + 1) % (#state_logic.dropped_buffs + 1)
            if state_logic.dropped_buff_render_index == 0 then
                state_logic.dropped_buff_render_index = 1
            end
            state_logic.should_redraw = 1
        end

        state_logic.folder_view_switch_and_sort()


        if input_handler.inputs_pressed["A"] == true then

            --print("Selected a Chip!")
            
            local dropped_buff = state_logic.dropped_buffs[state_logic.dropped_buff_render_index]
            BUFF_GENERATOR.activate_buff(dropped_buff, state_logic.current_round)
            state_logic.number_of_activated_buffs = state_logic.number_of_activated_buffs + 1
            state_logic.activated_buffs[state_logic.number_of_activated_buffs] = dropped_buff

            gauntlet_data.folder_view = 0
            gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_CHIP_SELECT
            state_logic.should_redraw = 1
        end

        if state_logic.should_redraw == 1 then
            
            if gauntlet_data.folder_view == 0 then
                gui_rendering.render_buff_selection(state_logic.dropped_buffs, state_logic.dropped_buff_render_index)
            else
                gui_rendering.render_folder(gauntlet_data.current_folder, nil, nil)
            end

            
            gui.DrawFinish()
            memorysavestate.loadcorestate(state_logic.gui_change_savestate)
            state_logic.should_redraw = 0
        end
        
    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.TRANSITION_TO_RUNNING then

        state_logic.patch_before_battle_start()
        --mmbn3_utils.change_number_of_cust_screen_chips(gauntlet_data.cust_style_number_of_chips + gauntlet_data.cust_screen_number_of_chips)  
        
        --print("Patched folder!")
        client.unpause()
         --mmbn3_utils.change_megaman_max_hp(gauntlet_data.mega_max_hp) 
        
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.RUNNING
        
    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.LOAD_INITIAL then
        -- Simply load initial state again if we beat all rounds.
        savestate.load(state_logic.initial_state)
        client.unpause()
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.RUNNING
    
    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.TRANSITION_TO_CHOOSE_STARTING_LOADOUT then
        state_logic.gui_change_savestate = memorysavestate.savecorestate()
        
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.CHOOSE_STARTING_LOADOUT
        state_logic.should_redraw = 1
        
        
        memorysavestate.loadcorestate(state_logic.gui_change_savestate)
        client.pause()


    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.CHOOSE_STARTING_LOADOUT then

        -- TODO: render list of starting loadouts. Each loadout should provide a callable function that can set various things.
        

        if input_handler.inputs_pressed["Up"] == true then
            state_logic.selected_loadout_index = (state_logic.selected_loadout_index - 1) % (#LOADOUTS)
            
            if state_logic.selected_loadout_index == 0 then
                state_logic.selected_loadout_index = 1
            end
            state_logic.should_redraw = 1
        end

        if input_handler.inputs_pressed["Down"] == true then
            state_logic.selected_loadout_index = (state_logic.selected_loadout_index + 1) % (#LOADOUTS + 1)
            if state_logic.selected_loadout_index == 0 then
                state_logic.selected_loadout_index = #LOADOUTS
            end
            state_logic.should_redraw = 1
        end

        state_logic.folder_view_switch_and_sort()


        if input_handler.inputs_pressed["A"] == true then

            --print("Selected a Chip!")
            print("Selected Loadout: ", LOADOUTS[state_logic.selected_loadout_index])
            gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_BUFF_SELECT


            LOADOUTS[state_logic.selected_loadout_index].activate()
            state_logic.update_printable_chip_names_in_folder()
            state_logic.update_argb_chip_icons_in_folder()
            --print("Folder after loadout: ", gauntlet_data.current_folder)
            gauntlet_data.folder_view = 0
            state_logic.loadout_chosen = 1
            state_logic.selected_loadout_index = 1
        end

        if state_logic.should_redraw == 1 then
            
            if gauntlet_data.folder_view == 0 then
                gui_rendering.render_loadouts(LOADOUTS, state_logic.selected_loadout_index)
            else
                gui_rendering.render_folder(gauntlet_data.current_folder, nil, nil)
            end

            
            gui.DrawFinish()
            memorysavestate.loadcorestate(state_logic.gui_change_savestate)
            state_logic.should_redraw = 0
        end

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.TRANSITION_TO_DRAFT_FOLDER then
        state_logic.gui_change_savestate = memorysavestate.savecorestate()
        
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.DRAFT_FOLDER
        state_logic.should_redraw = 1
        

        --print("Transition to draft folder!")

        for draft_chip_idx = 1,GAUNTLET_DEFS.NUMBER_OF_DRAFT_CHIPS do

            state_logic.draft_selection_chips[draft_chip_idx] = gauntlet_data.folder_draft_chip_generator(#gauntlet_data.current_folder + 1)
            state_logic.draft_selection_chips[draft_chip_idx].PRINT_NAME = state_logic.get_printable_chip_name(state_logic.draft_selection_chips[draft_chip_idx])
        end
        state_logic.update_argb_chip_icons_in_folder()
        state_logic.update_dropped_chips_pictures(state_logic.draft_selection_chips)
        --print("Folder:", gauntlet_data.current_folder)

        if #gauntlet_data.current_folder == 30 then

            gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_BUFF_SELECT

        end
        
        memorysavestate.loadcorestate(state_logic.gui_change_savestate)
        client.pause()

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.DRAFT_FOLDER then
        

        if input_handler.inputs_pressed["Left"] == true then
            state_logic.draft_chip_render_index = (state_logic.draft_chip_render_index - 1) % (#state_logic.draft_selection_chips)
            if state_logic.draft_chip_render_index == 0 then
                state_logic.draft_chip_render_index = (#state_logic.draft_selection_chips)
            end
            state_logic.should_redraw = 1
        end

        if input_handler.inputs_pressed["Right"] == true then
            state_logic.draft_chip_render_index = (state_logic.draft_chip_render_index + 1) % (#state_logic.draft_selection_chips + 1)
           
            if state_logic.draft_chip_render_index == 0 then
                state_logic.draft_chip_render_index = 1
            end
            state_logic.should_redraw = 1
        end

        state_logic.folder_view_switch_and_sort()

        if input_handler.inputs_pressed["A"] == true then

            --print("Selected a Chip!")
            
            local new_chip = state_logic.draft_selection_chips[state_logic.draft_chip_render_index]

            gauntlet_data.current_folder[#gauntlet_data.current_folder + 1] = deepcopy(new_chip)
            state_logic.update_printable_chip_names_in_folder()
            state_logic.update_argb_chip_icons_in_folder()

            gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_DRAFT_FOLDER
            gauntlet_data.folder_view = 0
            state_logic.should_redraw = 1
            state_logic.draft_chip_render_index = 1
        end

        if state_logic.should_redraw == 1 then

            
            if gauntlet_data.folder_view == 0 then
                gui_rendering.render_chip_selection(state_logic.draft_selection_chips, state_logic.draft_chip_render_index)
            else
                gui_rendering.render_folder(gauntlet_data.current_folder, nil, nil)
            end


            
            gui.DrawFinish()
            memorysavestate.loadcorestate(state_logic.gui_change_savestate)
            state_logic.should_redraw = 0
        end

    else -- Default state, should never happen
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.RUNNING
    end

    emu.yield()
end

return state_logic