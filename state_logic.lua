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
local BUFF_GENERATOR = require "buff_effects.buff_groups"
local gauntlet_data = require "gauntlet_data"

-- TODO: possibly add more states.
local GAME_STATE = {
    RUNNING = 0x00,
    TRANSITION_TO_CHIP_SELECT = 0x01,
    CHIP_SELECT = 0x02,
    TRANSITION_TO_CHIP_REPLACE = 0x03,
    CHIP_REPLACE = 0x04,
    TRANSITION_TO_RUNNING = 0x05,
    TRANSITION_TO_BUFF_SELECT = 0x06,
    BUFF_SELECT = 0x07,
    WAIT_FOR_HP_PATCH = 0x08,
    LOAD_INITIAL = 0x09,
}
local state_logic = {}


state_logic.dropped_chips = {}
state_logic.dropped_buffs = {}
state_logic.initial_state = "initial.State"

gauntlet_data.current_folder = {}
gauntlet_data.mega_max_hp = 100

state_logic.dropped_chips[1] = CHIP.new_chip_with_code(CHIP_ID.Cannon, CHIP_CODE.A)
state_logic.dropped_chips[2] = CHIP.new_chip_with_code(CHIP_ID.Cannon, CHIP_CODE.B)
state_logic.dropped_chips[3] = CHIP.new_chip_with_code(CHIP_ID.Cannon, CHIP_CODE.C)

state_logic.should_redraw = 1

state_logic.hp_patch_frame_counter = 0

state_logic.dropped_chip = CHIP.new_chip_with_code(CHIP_ID.Cannon, CHIP_CODE.A)
state_logic.dropped_chip.ID = -1
state_logic.dropped_chip.PRINT_NAME = ""



state_logic.current_state = GAME_STATE.RUNNING
state_logic.dropped_chip_render_index = 1
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
    -- print("5")
    
    -- print("7")
    
    -- print("8")
    --print("Patched Battle ", state_logic.current_battle)

    
    

    
    

end

local DEBUG = 0
function state_logic.on_battle_end()

    if state_logic.battle_pointer_index > GAUNTLET_DEFS.BATTLES_PER_ROUND then
       state_logic.current_state = GAME_STATE.LOAD_INITIAL 
    end  

end

function state_logic.determine_drops(number_of_drops)

    if state_logic.battle_data[state_logic.current_battle - 1] == nil then

        -- First round. Do we do anything here?
        -- For now, we don't.
        
        
    else

        -- TODO: determine drops from state_logic.battle_data[state_logic.current_battle].ENTITIES entity droptables.
        --TODO: for now, this just randomizes.
        state_logic.randomize_dropped_chips(number_of_drops)

        state_logic.update_dropped_chips_pictures(state_logic.dropped_chips)
        

    end

    

end

function state_logic.on_enter_battle()
    
    

    state_logic.patch_next_battle()
    state_logic.determine_drops(GAUNTLET_DEFS.NUMBER_OF_DROPPED_CHIPS)

    if state_logic.current_state ~= GAME_STATE.TRANSITION_TO_BUFF_SELECT and  
        state_logic.current_state ~= GAME_STATE.BUFF_SELECT then
            state_logic.current_state = GAME_STATE.TRANSITION_TO_CHIP_SELECT
    end

    --print("STATE_ENTER: ", state_logic.current_state)
    --print(print(state_logic.dropped_chip))
    
    
    --state_logic.current_state = GAME_STATE.TRANSITION_TO_CHIP_SELECT

end


function state_logic.on_next_round()
    
    --print ("BEFORE MEGA MAX INCREASE PER ROUND")
    gauntlet_data.mega_max_hp = gauntlet_data.mega_max_hp + GAUNTLET_DEFS.HP_INCREASE_PER_ROUND[state_logic.current_round]
    gauntlet_data.hp_patch_required = 1
    --print(" MEGA MAX HP: ", gauntlet_data.mega_max_hp)
    --print ("BEFORE CHANGE MAX HP")
    
    --print ("BEFORE TRANSITION TO BUFF SELECT")
    state_logic.current_state = GAME_STATE.TRANSITION_TO_BUFF_SELECT

end


function state_logic.reset_selected_chips()
    state_logic.dropped_chip_render_index = 1
    state_logic.folder_chip_render_index = 1
end

function state_logic.randomize_dropped_chips(number_of_dropped_chips)
    state_logic.dropped_chips = {}
    for chip_idx = 1,number_of_dropped_chips do

        state_logic.dropped_chips[chip_idx] = CHIP.new_random_chip_with_random_code()
        --state_logic.dropped_chips[chip_idx] = CHIP.new_chip_with_code(CHIP_ID.Mole1, 0)

    end
   
    
end

function state_logic.randomize_folder()

    for chip_idx = 1,GENERIC_DEFS.NUMBER_OF_CHIPS_IN_FOLDER do

        gauntlet_data.current_folder[chip_idx] = CHIP.new_random_chip_with_random_code()
        --gauntlet_data.current_folder[chip_idx] = CHIP.new_chip_with_code(0x1, 0)

    end
   
    
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

    if chip.ID == -1 then
        return ""
    end

    local string_with_special_chars = CHIP_NAME[chip.ID] .. " " .. CHIP_CODE_REVERSE[chip.CODE]

    return CHIP_NAME_UTILS.replace_special_chars(string_with_special_chars)

end

function state_logic.get_argb_icon(chip)

    if chip.ID == -1 then
        return nil
    end

    local chip_address = CHIP_DATA[chip.ID].CHIP_ICON_OFFSET

    return CHIP_ICON.get_argb_2d_array_for_icon_address(chip_address)

end



function state_logic.update_argb_chip_icons_in_folder()
    
    for chip_idx = 1,GENERIC_DEFS.NUMBER_OF_CHIPS_IN_FOLDER do
        gauntlet_data.current_folder[chip_idx].ARGB_ICON = state_logic.get_argb_icon(gauntlet_data.current_folder[chip_idx])
    end
    

end


function state_logic.update_printable_chip_names_in_folder()

    for chip_idx = 1,GENERIC_DEFS.NUMBER_OF_CHIPS_IN_FOLDER do
        gauntlet_data.current_folder[chip_idx].PRINT_NAME = state_logic.get_printable_chip_name(gauntlet_data.current_folder[chip_idx])
    end

end

function state_logic.update_buff_discriptions()

    -- This updates all buff descriptions for the current round.
    for buff_idx = 1,#state_logic.dropped_buffs do
        state_logic.dropped_buffs[buff_idx].DESCRIPTION = state_logic.dropped_buffs[buff_idx]:get_description(state_logic.current_round)
    end

end


function state_logic.initialize()

    math.randomseed(os.time())

    savestate.load(state_logic.initial_state)
    gauntlet_data.mega_max_hp = 100
    gauntlet_data.hp_patch_required = 0
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
    state_logic.reset_selected_chips()


    state_logic.randomize_folder()
    state_logic.update_printable_chip_names_in_folder()
    state_logic.update_argb_chip_icons_in_folder()
    
    state_logic.current_state = GAME_STATE.RUNNING

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

function state_logic.main_loop()

    if DEBUG == 1 then
        print ("DEBUG: STATE: ", state_logic.current_state)
    end
    input_handler.handle_inputs()


    state_logic.check_reset()


    
    --print ("Current state: " .. state_logic.current_state)
    if state_logic.current_state == GAME_STATE.RUNNING then

        -- Do nothing.

    elseif state_logic.current_state == GAME_STATE.TRANSITION_TO_CHIP_SELECT then
        -- We pause here and make a savestate.
        --print("Transition to chip select.")
        state_logic.gui_change_savestate = memorysavestate.savecorestate()
        state_logic.reset_selected_chips()
        if state_logic.battle_data[state_logic.current_battle - 1] == nil then
            -- We didn't finish a battle yet, therefore no chip.

            state_logic.current_state = GAME_STATE.TRANSITION_TO_CHIP_REPLACE
            --print(state_logic.dropped_chip)
        else

            -- Drop chips!
            -- TODO: actually use chips from a droptable from viruses.

            state_logic.determine_drops(GAUNTLET_DEFS.NUMBER_OF_DROPPED_CHIPS)

            for idx = 1,#state_logic.dropped_chips do
                state_logic.dropped_chips[idx].PRINT_NAME = state_logic.get_printable_chip_name(state_logic.dropped_chips[idx])
            end

            
            
            state_logic.current_state = GAME_STATE.CHIP_SELECT
            

        end
        client.pause()
        state_logic.should_redraw = 1

    elseif state_logic.current_state == GAME_STATE.CHIP_SELECT then
        

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


        if input_handler.inputs_pressed["A"] == true then

            --print("Selected a Chip!")
            
            state_logic.dropped_chip = state_logic.dropped_chips[state_logic.dropped_chip_render_index]

            state_logic.dropped_chip.PRINT_NAME = state_logic.get_printable_chip_name(state_logic.dropped_chip)
            state_logic.dropped_chip.ARGB_ICON = state_logic.get_argb_icon(state_logic.dropped_chip)
            state_logic.current_state = GAME_STATE.TRANSITION_TO_CHIP_REPLACE
            state_logic.should_redraw = 1
        end

        if state_logic.should_redraw == 1 then
            --print("RENDERRRRRR")
            --print("DROPPED CHIPS: ", dropped_chips)
            gui_rendering.render_chip_selection(state_logic.dropped_chips, state_logic.dropped_chip_render_index)
            gui.DrawFinish()
            memorysavestate.loadcorestate(state_logic.gui_change_savestate)
            state_logic.should_redraw = 0
        end



        

    elseif state_logic.current_state == GAME_STATE.TRANSITION_TO_CHIP_REPLACE then
        state_logic.gui_change_savestate = memorysavestate.savecorestate()
        memorysavestate.loadcorestate(state_logic.gui_change_savestate)
        -- print(state_logic.dropped_chip)
        state_logic.current_state = GAME_STATE.CHIP_REPLACE
        state_logic.should_redraw = 1

    elseif state_logic.current_state == GAME_STATE.CHIP_REPLACE then
        --print("IN CHIP_REPLACE")
        -- Render folder, respond to inputs for selected chip. Patch folder for selected chip, then unpause.
        --print(state_logic.current_state)
        -- We render 15 x 2 chips.
        
        local num_chips_per_col = 15
        local num_chips_per_folder = 30
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

            state_logic.current_state = GAME_STATE.TRANSITION_TO_RUNNING
            state_logic.should_redraw = 1
        end

        if input_handler.inputs_pressed["B"] == true then
            -- Just skip - we didn't want a chip!
            --print("B pressed")
            state_logic.current_state = GAME_STATE.TRANSITION_TO_RUNNING
            
            state_logic.should_redraw = 1
        end
        --print(state_logic.folder_chip_render_index)

        if state_logic.should_redraw == 1 then
            gui_rendering.render_folder(gauntlet_data.current_folder, state_logic.folder_chip_render_index, state_logic.dropped_chip)
            gui.DrawFinish()
            memorysavestate.loadcorestate(state_logic.gui_change_savestate)
            state_logic.should_redraw = 0
        end

    elseif state_logic.current_state == GAME_STATE.TRANSITION_TO_BUFF_SELECT then    
        --print ("IN TRANSITION TO BUFF SELECT")
        state_logic.gui_change_savestate = memorysavestate.savecorestate()
        
        --print ("AFTER LOAD_CORE_STATE")
        state_logic.current_state = GAME_STATE.BUFF_SELECT
        state_logic.should_redraw = 1
        --print ("BEFORE DROP BUFFS")
        state_logic.dropped_buffs = BUFF_GENERATOR.random_buffs_from_round(state_logic.current_round, GAUNTLET_DEFS.NUMBER_OF_DROPPED_BUFFS)
        --print ("BEFORE update_buff_discriptions")
        state_logic.update_buff_discriptions()
        --print(state_logic.dropped_chip)
        memorysavestate.loadcorestate(state_logic.gui_change_savestate)
        client.pause()


    elseif state_logic.current_state == GAME_STATE.BUFF_SELECT then
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


        if input_handler.inputs_pressed["A"] == true then

            --print("Selected a Chip!")
            
            local dropped_buff = state_logic.dropped_buffs[state_logic.dropped_buff_render_index]
            dropped_buff:activate(state_logic.current_round)
            state_logic.current_state = GAME_STATE.TRANSITION_TO_CHIP_SELECT
            state_logic.should_redraw = 1
        end

        if state_logic.should_redraw == 1 then

            gui_rendering.render_buff_selection(state_logic.dropped_buffs, state_logic.dropped_buff_render_index)
            gui.DrawFinish()
            memorysavestate.loadcorestate(state_logic.gui_change_savestate)
            state_logic.should_redraw = 0
        end
        
    elseif state_logic.current_state == GAME_STATE.TRANSITION_TO_RUNNING then

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
        --print("Patched folder!")
        client.unpause()
        
        state_logic.current_state = GAME_STATE.WAIT_FOR_HP_PATCH

    elseif state_logic.current_state == GAME_STATE.WAIT_FOR_HP_PATCH then

        if gauntlet_data.hp_patch_required == 0 then
            state_logic.current_state = GAME_STATE.RUNNING
        else

            state_logic.hp_patch_frame_counter = state_logic.hp_patch_frame_counter + 1

            -- We need to wait a few frames to patch the in-battle HP of megaman in RAM. Otherwise we would need a hook way before battle, which I don't want to find right now.
            if state_logic.hp_patch_frame_counter > GENERIC_DEFS.FRAMES_BEFORE_HP_PATCH then
                state_logic.hp_patch_frame_counter = 0
                state_logic.current_state = GAME_STATE.RUNNING
                mmbn3_utils.change_megaman_max_hp(gauntlet_data.mega_max_hp) 
                mmbn3_utils.change_megaman_current_hp(gauntlet_data.mega_max_hp) 
                gauntlet_data.hp_patch_required = 0
                --print("PATCHED HP!")
            end
        end
    elseif state_logic.current_state == GAME_STATE.LOAD_INITIAL then
        -- Simply load initial state again if we beat all rounds.
        savestate.load(state_logic.initial_state)
        client.unpause()
        state_logic.current_state = GAME_STATE.RUNNING
    
    

    else -- Default state, should never happen
        state_logic.current_state = GAME_STATE.RUNNING
    end

    emu.yield()
end

return state_logic