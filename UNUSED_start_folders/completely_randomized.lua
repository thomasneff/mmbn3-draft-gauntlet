local CHIP_DATA = require "defs.chip_data_defs"
local COMPLETELY_RANDOMIZED_FOLDER = {}
local GENERIC_DEFS = require "defs.generic_defs"
local RANDOMIZED_LIBRARY_STARS_FOLDER = require "start_folders.randomized_library_stars_folder"
local CHIP = require "defs.chip_defs"

function COMPLETELY_RANDOMIZED_FOLDER.new(code_list)
    local folder = {}
    for chip_idx = 1,GENERIC_DEFS.NUMBER_OF_CHIPS_IN_FOLDER do

        folder[chip_idx] = CHIP.new_random_chip_with_random_code()

    end

    return folder

end



return COMPLETELY_RANDOMIZED_FOLDER

