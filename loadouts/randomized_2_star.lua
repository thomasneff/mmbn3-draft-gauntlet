local CHIP_DATA = require "defs.chip_data_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local RANDOMIZED_LIBRARY_STARS_FOLDER = require "start_folders.randomized_library_stars_folder"
local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local RANDOMIZED_2_STAR_FOLDER = {}

function RANDOMIZED_2_STAR_FOLDER.activate()

    
    code_list = {0x00, 0x03, 0x06, 0x09, 26}
    
    new_folder = RANDOMIZED_LIBRARY_STARS_FOLDER.new(1, code_list)
    
    gauntlet_data.current_folder = deepcopy(new_folder)

    

end


RANDOMIZED_2_STAR_FOLDER.NAME = "Randomized 2-Star Folder"
RANDOMIZED_2_STAR_FOLDER.DESCRIPTION = "You start with a randomized folder\ncontaining 2-Star Chips of Codes A, D, G, J, *!"


return RANDOMIZED_2_STAR_FOLDER

