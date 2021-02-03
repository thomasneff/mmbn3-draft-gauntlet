local deepcopy = require "deepcopy"
local input_handler = {}


-- This stores the inputs, where each input is only active during the frame it was pressed.
input_handler.inputs_pressed = nil

input_handler.inputs_held = {}

input_handler.inputs_delta = {}

input_handler.previous_inputs = {}

input_handler.has_delta = false

input_handler.current_input_state = nil

-- This handles all the input stuff.
function input_handler.handle_inputs()


    input_handler.inputs_delta = {}
    
    input_handler.has_delta = false
    
    if input_handler.current_input_state == nil then
        input_handler.current_input_state = joypad.get()
    end

    local joypad_readout = input_handler.current_input_state

    if input_handler.inputs_pressed == nil then

        input_handler.inputs_pressed = deepcopy(joypad_readout)

    end

    -- Make sure that inputs_pressed only contains "True" for a single frame.
    for key, value in pairs(input_handler.inputs_pressed) do

        input_handler.inputs_pressed[key] = false

    end


    for key, value in pairs(joypad_readout) do
 
        if value == true and input_handler.inputs_held[key] == false then

            input_handler.inputs_pressed[key] = true

        end

        input_handler.inputs_held[key] = value

        if value ~= input_handler.previous_inputs[key] then
            input_handler.inputs_delta[key] = value
            input_handler.has_delta = true
        end

    end

    input_handler.previous_inputs = deepcopy(joypad_readout)

end

return input_handler