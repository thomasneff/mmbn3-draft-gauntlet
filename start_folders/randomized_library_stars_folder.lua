local CHIP_DATA = require "defs.chip_data_defs"
local RANDOMIZED_STAR_FOLDER = {}
local GENERIC_DEFS = require "defs.generic_defs"
local randomchoice_key = require "randomchoice_key"
local CHIP = require "defs.chip_defs"

function RANDOMIZED_STAR_FOLDER.new(library_stars, code_list)

    local library_chip_data = {}

    for key, value in pairs(CHIP_DATA) do

        if value.LIBRARY_STARS == library_stars then
            
            library_chip_data[key] = value

        end

    end

    local folder = {}
    local num_chips = GENERIC_DEFS.NUMBER_OF_CHIPS_IN_FOLDER

    for chip_idx = 1,num_chips do

        local single_chip_data_ID = randomchoice_key(library_chip_data)
        folder[chip_idx] = CHIP.new_chip_with_random_code_from_list(single_chip_data_ID, code_list)



    end

    return folder

end



return RANDOMIZED_STAR_FOLDER

