local CHIP_DATA = require "defs.chip_data_defs"
local RANDOMIZED_2_STAR_FOLDER = {}
local GENERIC_DEFS = require "defs.generic_defs"
local RANDOMIZED_LIBRARY_STARS_FOLDER = require "start_folders.randomized_library_stars_folder"

function RANDOMIZED_2_STAR_FOLDER.new(code_list)

    if code_list == nil then
        code_list = {0x00, 0x03, 0x06, 0x09, 26}
    end

    return RANDOMIZED_LIBRARY_STARS_FOLDER.new(1, code_list)

end



return RANDOMIZED_2_STAR_FOLDER

