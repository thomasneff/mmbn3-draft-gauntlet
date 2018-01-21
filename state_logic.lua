local input_handler = require "input_handler"
local gui_rendering = require "gui_rendering"



-- TODO: possibly add more states.
local GAME_STATE = {
    RUNNING = 0x00,
    TRANSITION_TO_CHIP_SELECT = 0x01,
    CHIP_SELECT = 0x02,
    TRANSITION_TO_CHIP_REPLACE = 0x03,
    CHIP_REPLACE = 0x04,
    SELECT_BUFF = 0x05
}

local state_logic = {}
local current_state = GAME_STATE.RUNNING
local selected_chip_select = 1
local selected_chip_folder = 1
local should_pause = 0
local frame_count = 0
local gui_change_savestate = nil



function state_logic.on_enter_battle()

    current_state = GAME_STATE.TRANSITION_TO_CHIP_SELECT

    should_pause = 1

end


function state_logic.on_next_round()

end


function reset_selected_chips()
    selected_chip_select = 1
    selected_chip_folder = 1
end


function state_logic.initialize()

    current_state = GAME_STATE.RUNNING
    should_pause = 0
    reset_selected_chips()
    frame_count = 0


end



function state_logic.main_loop()

    input_handler.handle_inputs()
    frame_count = frame_count  + 1


    
    --print ("Current state: " .. current_state)
    if current_state == GAME_STATE.RUNNING then

        -- Do nothing.

    elseif current_state == GAME_STATE.TRANSITION_TO_CHIP_SELECT then
        -- We pause here and make a savestate.
        print("Transition to chip select.")
        reset_selected_chips()
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
            
            current_state = GAME_STATE.RUNNING
            client.unpause()
        end

        if input_handler.inputs_pressed["B"] == true then
            -- Just skip - we didn't want a chip!
            print("B pressed")
            current_state = GAME_STATE.RUNNING
            client.unpause()
        end
        --print(selected_chip_folder)
        gui_rendering.render_folder(nil, selected_chip_folder)
        
        gui.DrawFinish()

        

    elseif current_state == GAME_STATE.SELECT_BUFF then

    else -- Default state, should never happen
        current_state = GAME_STATE.RUNNING
    end
    


    --if should_pause == 1 then
    --    print("PAUSED CLIENT.")
    --    print("GAME STATE = " .. current_state)
        
    --    client.pause()
    --    should_pause = 0
    --end


    emu.yield()
end

return state_logic