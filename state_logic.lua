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
    -- print("6")
    mmbn3_utils.patch_battle(GAUNTLET_BATTLE_POINTERS[battle_pointer_index], new_battle_data)
    -- print("7")
    mmbn3_utils.patch_entity_data(new_battle_data.ENTITIES)
    -- print("8")
    print("Patched Battle ", current_battle)

    current_battle = current_battle + 1
    battle_pointer_index = battle_pointer_index + 1

    
    

end


function state_logic.on_enter_battle()
    
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


function state_logic.randomize_folder()

    for chip_idx = 1,GENERIC_DEFS.NUMBER_OF_CHIPS_IN_FOLDER do

        folder[chip_idx] = CHIP.new_random_chip_with_random_code()

    end
   

end

function state_logic.initialize()

    math.randomseed(os.time())

    savestate.load("initial.State")
    current_round = 0
    current_battle = 1
    battle_pointer_index = 1
    should_pause = 0
    state_logic.reset_selected_chips()
    frame_count = 0

    state_logic.randomize_folder()
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
        gui_change_savestate = memorysavestate.savecorestate()
        client.pause()
        current_state = GAME_STATE.CHIP_SELECT

    elseif current_state == GAME_STATE.CHIP_SELECT then
        -- render chips, select a chip.
        -- TODO: for now, this just switches instantly to CHIP_REPLACE
        current_state = GAME_STATE.TRANSITION_TO_CHIP_REPLACE

    elseif current_state == GAME_STATE.TRANSITION_TO_CHIP_REPLACE then
        -- We already render the folder here, so we can load the savestate to "refresh" the screen.
        -- It sucks and is an ugly hack, but it's the only solution I could find.
        gui_rendering.render_folder(nil, selected_chip_folder)
        memorysavestate.loadcorestate(gui_change_savestate)
        current_state = GAME_STATE.CHIP_REPLACE

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
        end

        if input_handler.inputs_pressed["Right"] == true then
            selected_chip_folder = (selected_chip_folder + num_chips_per_col) % (num_chips_per_folder)
            memorysavestate.loadcorestate(gui_change_savestate)
            if selected_chip_folder == 0 then
                selected_chip_folder = 30
            end
        end

        if input_handler.inputs_pressed["Up"] == true then
            selected_chip_folder = (selected_chip_folder - 1) % (num_chips_per_folder + 1)
            --print ("UP PRESSED")
            memorysavestate.loadcorestate(gui_change_savestate)
            if selected_chip_folder == 0 then
                selected_chip_folder = 30
            end
        end

        if input_handler.inputs_pressed["Down"] == true then
            selected_chip_folder = (selected_chip_folder + 1) % (num_chips_per_folder + 1)
            memorysavestate.loadcorestate(gui_change_savestate)
            if selected_chip_folder == 0 then
                selected_chip_folder = 1
            end
        end

        


        if input_handler.inputs_pressed["A"] == true then
            -- TODO: add chip to folder!
            print("A pressed")
            print("Removed chip TODO for chip TODO!")
            
            current_state = GAME_STATE.TRANSITION_TO_RUNNING
            client.unpause()
        end

        if input_handler.inputs_pressed["B"] == true then
            -- Just skip - we didn't want a chip!
            print("B pressed")
            current_state = GAME_STATE.TRANSITION_TO_RUNNING
            client.unpause()
        end
        --print(selected_chip_folder)
        gui_rendering.render_folder(nil, selected_chip_folder)
        
        gui.DrawFinish()

        

    elseif current_state == GAME_STATE.SELECT_BUFF then

    elseif current_state == GAME_STATE.TRANSITION_TO_RUNNING then

        -- Patch folder with all new stuff.
        state_logic.randomize_folder()
        mmbn3_utils.patch_folder(folder, GENERIC_DEFS.FOLDER_START_ADDRESS_RAM)
        print("Patched folder!")
        current_state = GAME_STATE.RUNNING

    else -- Default state, should never happen
        current_state = GAME_STATE.RUNNING
    end
    


    emu.yield()
end

return state_logic