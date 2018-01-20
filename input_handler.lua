local deepcopy = require "deepcopy"
local input_handler = {}


-- This stores the inputs, where each input is only active during the frame it was pressed.
input_handler.inputs_pressed = nil

input_handler.inputs_held = {}



-- This handles all the input stuff.
function input_handler.handle_inputs()


    local joypad_readout = joypad.get()

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

    end

end

return input_handler