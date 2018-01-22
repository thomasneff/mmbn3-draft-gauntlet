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
local CHIP_DATA = require "defs.chip_data_defs"

-- TODO: possibly add more states.
local GAME_STATE = {
    RUNNING = 0x00,
    TRANSITION_TO_CHIP_SELECT = 0x01,
    CHIP_SELECT = 0x02,
    TRANSITION_TO_CHIP_REPLACE = 0x03,
    CHIP_REPLACE = 0x04,
    TRANSITION_TO_RUNNING = 0x05,
    SELECT_BUFF = 0x06
}

local folder = {}
local dropped_chips = {}

dropped_chips[1] = CHIP.new_chip_with_code(CHIP_ID.Cannon, CHIP_CODE.A)
dropped_chips[2] = CHIP.new_chip_with_code(CHIP_ID.Cannon, CHIP_CODE.B)
dropped_chips[3] = CHIP.new_chip_with_code(CHIP_ID.Cannon, CHIP_CODE.C)

local should_redraw = 1


local selected_dropped_chip = CHIP.new_chip_with_code(CHIP_ID.Cannon, CHIP_CODE.A)
selected_dropped_chip.ID = -1
selected_dropped_chip.PRINT_NAME = ""


local state_logic = {}
local current_state = GAME_STATE.RUNNING
local selected_chip_select = 1
local selected_chip_folder = 1
local should_pause = 0
local frame_count = 0
local gui_change_savestate = nil


local current_round = 0
local current_battle = 1
local battle_pointer_index = 1
local battle_data = {}

function state_logic.next_round()

    
    -- We just finished the round. We might want to load a savestate? Or just let the user do that.
    current_round = current_round + 1
    print("Starting Round " .. current_round)
    -- Reset all address variables, as we now start from the beginning again.
    battle_pointer_index = 1
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
    print("Battle ", current_battle, " start")

    -- When we finished all gauntlet battles, enter the next round.
    if battle_pointer_index > GAUNTLET_DEFS.BATTLES_PER_ROUND then
        --print("3")
        next_round()
    end
    -- print("5")
    local new_battle_data = battle_data_generator.random_from_battle(current_battle)

    -- This is used to determine drops.
    battle_data[current_battle] = new_battle_data

    -- print("6")
    mmbn3_utils.patch_battle(GAUNTLET_BATTLE_POINTERS[battle_pointer_index], new_battle_data)
    -- print("7")
    mmbn3_utils.patch_entity_data(new_battle_data.ENTITIES)
    -- print("8")
    print("Patched Battle ", current_battle)

    current_battle = current_battle + 1
    battle_pointer_index = battle_pointer_index + 1

    
    

end


function state_logic.determine_drops()

    if battle_data[current_battle] == nil then

        -- First round. Do we do anything here?
        -- For now, we don't.

    else

        -- TODO: determine drops from battle_data[current_battle].ENTITIES entity droptables.

    end

end

function state_logic.on_enter_battle()
    
    state_logic.determine_drops()

    state_logic.patch_next_battle()
    
    current_state = GAME_STATE.TRANSITION_TO_CHIP_SELECT
    

    should_pause = 1

end


function state_logic.on_next_round()

end


function state_logic.reset_selected_chips()
    selected_chip_select = 1
    selected_chip_folder = 1
end

function state_logic.randomize_dropped_chips(number_of_dropped_chips)
    dropped_chips = {}
    for chip_idx = 1,number_of_dropped_chips do

        dropped_chips[chip_idx] = CHIP.new_random_chip_with_random_code()

    end
   
    
end

function state_logic.randomize_folder()

    for chip_idx = 1,GENERIC_DEFS.NUMBER_OF_CHIPS_IN_FOLDER do

        folder[chip_idx] = CHIP.new_random_chip_with_random_code()

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
        folder[chip_idx].ARGB_ICON = state_logic.get_argb_icon(folder[chip_idx])
    end
    

end


function state_logic.update_printable_chip_names_in_folder()

    for chip_idx = 1,GENERIC_DEFS.NUMBER_OF_CHIPS_IN_FOLDER do
        folder[chip_idx].PRINT_NAME = state_logic.get_printable_chip_name(folder[chip_idx])
    end

end


function state_logic.initialize()

    math.randomseed(os.time())

    savestate.load("initial.State")

    selected_dropped_chip = CHIP.new_chip_with_code(CHIP_ID.Cannon, CHIP_CODE.A)
    --selected_dropped_chip.ID = -1
    selected_dropped_chip.PRINT_NAME = state_logic.get_printable_chip_name(selected_dropped_chip)
    selected_dropped_chip.ARGB_ICON = state_logic.get_argb_icon(selected_dropped_chip)
    battle_data = {}
    current_round = 0
    current_battle = 1
    battle_pointer_index = 1
    should_pause = 0
    state_logic.reset_selected_chips()
    frame_count = 0

    state_logic.randomize_folder()
    state_logic.update_printable_chip_names_in_folder()
    state_logic.update_argb_chip_icons_in_folder()
    
    current_state = GAME_STATE.RUNNING

    client.unpause()
    -- Upon start, initialize the current round:
    state_logic.next_round()



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

    input_handler.handle_inputs()
    frame_count = frame_count  + 1

    state_logic.check_reset()


    
    --print ("Current state: " .. current_state)
    if current_state == GAME_STATE.RUNNING then

        -- Do nothing.

    elseif current_state == GAME_STATE.TRANSITION_TO_CHIP_SELECT then
        -- We pause here and make a savestate.
        print("Transition to chip select.")
        state_logic.reset_selected_chips()

        -- Drop chips!
        -- TODO: for now, this just uses randomized chips.

        state_logic.randomize_dropped_chips(3)

        for idx = 1,#dropped_chips do
            dropped_chips[idx].PRINT_NAME = state_logic.get_printable_chip_name(dropped_chips[idx])
        end

        gui_change_savestate = memorysavestate.savecorestate()
        client.pause()
        current_state = GAME_STATE.CHIP_SELECT
        should_redraw = 1

    elseif current_state == GAME_STATE.CHIP_SELECT then
        

         if input_handler.inputs_pressed["Left"] == true then
            selected_chip_select = (selected_chip_select - 1) % (#dropped_chips)
            memorysavestate.loadcorestate(gui_change_savestate)
            if selected_chip_select == 0 then
                selected_chip_select = (#dropped_chips)
            end
            should_redraw = 1
        end

        if input_handler.inputs_pressed["Right"] == true then
            selected_chip_select = (selected_chip_select + 1) % (#dropped_chips + 1)
            memorysavestate.loadcorestate(gui_change_savestate)
            if selected_chip_select == 0 then
                selected_chip_select = 1
            end
            should_redraw = 1
        end


        if input_handler.inputs_pressed["A"] == true then

            print("Selected a Chip!")
            
            selected_dropped_chip = dropped_chips[selected_chip_select]

            selected_dropped_chip.PRINT_NAME = state_logic.get_printable_chip_name(selected_dropped_chip)
            selected_dropped_chip.ARGB_ICON = state_logic.get_argb_icon(selected_dropped_chip)
            current_state = GAME_STATE.TRANSITION_TO_CHIP_REPLACE
            should_redraw = 1
        end

        if should_redraw == 1 then
            --print("RENDERRRRRR")
            --print("DROPPED CHIPS: ", dropped_chips)
            gui_rendering.render_chip_selection(dropped_chips, selected_chip_select)
            gui.DrawFinish()
            should_redraw = 0
        end



        

    elseif current_state == GAME_STATE.TRANSITION_TO_CHIP_REPLACE then

        memorysavestate.loadcorestate(gui_change_savestate)
        current_state = GAME_STATE.CHIP_REPLACE
        should_redraw = 1

    elseif current_state == GAME_STATE.CHIP_REPLACE then
        --print("IN CHIP_REPLACE")
        -- Render folder, respond to inputs for selected chip. Patch folder for selected chip, then unpause.
        --print(current_state)
        -- We render 15 x 2 chips.
        local num_chips_per_col = 15
        local num_chips_per_folder = 30
        --print (input_handler.inputs_pressed["A"])
        if input_handler.inputs_pressed["Left"] == true then
            selected_chip_folder = (selected_chip_folder - num_chips_per_col) % (num_chips_per_folder)
            memorysavestate.loadcorestate(gui_change_savestate)
            if selected_chip_folder == 0 then
                selected_chip_folder = 30
            end
            should_redraw = 1
        end

        if input_handler.inputs_pressed["Right"] == true then
            selected_chip_folder = (selected_chip_folder + num_chips_per_col) % (num_chips_per_folder)
            memorysavestate.loadcorestate(gui_change_savestate)
            if selected_chip_folder == 0 then
                selected_chip_folder = 30
            end
            should_redraw = 1
        end

        if input_handler.inputs_pressed["Up"] == true then
            selected_chip_folder = (selected_chip_folder - 1) % (num_chips_per_folder + 1)
            --print ("UP PRESSED")
            memorysavestate.loadcorestate(gui_change_savestate)
            if selected_chip_folder == 0 then
                selected_chip_folder = 30
            end
            should_redraw = 1
        end

        if input_handler.inputs_pressed["Down"] == true then
            selected_chip_folder = (selected_chip_folder + 1) % (num_chips_per_folder + 1)
            memorysavestate.loadcorestate(gui_change_savestate)
            if selected_chip_folder == 0 then
                selected_chip_folder = 1
            end
            should_redraw = 1
        end

        


        if input_handler.inputs_pressed["A"] == true then
            -- TODO: add chip to folder!
            print("A pressed")
            

            folder[selected_chip_folder] = selected_dropped_chip

            current_state = GAME_STATE.TRANSITION_TO_RUNNING
            client.unpause()
            should_redraw = 1
        end

        if input_handler.inputs_pressed["B"] == true then
            -- Just skip - we didn't want a chip!
            print("B pressed")
            current_state = GAME_STATE.TRANSITION_TO_RUNNING
            client.unpause()
            should_redraw = 1
        end
        --print(selected_chip_folder)

        if should_redraw == 1 then
            gui_rendering.render_folder(folder, selected_chip_folder, selected_dropped_chip)
            gui.DrawFinish()
            should_redraw = 0
        end

        

    elseif current_state == GAME_STATE.SELECT_BUFF then
        
    elseif current_state == GAME_STATE.TRANSITION_TO_RUNNING then

        -- Patch folder with all new stuff.
        -- state_logic.randomize_folder()
        mmbn3_utils.patch_folder(folder, GENERIC_DEFS.FOLDER_START_ADDRESS_RAM)
        state_logic.update_printable_chip_names_in_folder()
        state_logic.update_argb_chip_icons_in_folder()
        print("Patched folder!")
        current_state = GAME_STATE.RUNNING

    else -- Default state, should never happen
        current_state = GAME_STATE.RUNNING
    end

    emu.yield()
end

return state_logic