local CHIP_DATA = require "defs.chip_data_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local RANDOMIZED_LIBRARY_STARS_FOLDER = require "start_folders.randomized_library_stars_folder"
local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP = require "defs.chip_defs"
local COMPLETELY_RANDOM = {}

function COMPLETELY_RANDOM.activate()

    new_folder = {}

    for chip_idx = 1,GENERIC_DEFS.NUMBER_OF_CHIPS_IN_FOLDER do

        new_folder[chip_idx] = CHIP.new_random_chip_with_random_code()

    end
    
    gauntlet_data.current_folder = deepcopy(new_folder)

    print("Completely Random - Patched folder.")

end


COMPLETELY_RANDOM.NAME = "Completely Random Folder"
COMPLETELY_RANDOM.DESCRIPTION = "You start with a completely randomized folder!"


return COMPLETELY_RANDOM

