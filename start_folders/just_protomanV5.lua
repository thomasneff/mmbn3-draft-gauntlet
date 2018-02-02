local CHIP_DATA = require "defs.chip_data_defs"
local JUST_PROTOMANV5 = {}
local GENERIC_DEFS = require "defs.generic_defs"
local RANDOMIZED_LIBRARY_STARS_FOLDER = require "start_folders.randomized_library_stars_folder"
local CHIP = require "defs.chip_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"

function JUST_PROTOMANV5.new(code_list)
    local folder = {}
    for chip_idx = 1,GENERIC_DEFS.NUMBER_OF_CHIPS_IN_FOLDER do

        folder[chip_idx] = CHIP.new_chip_with_code(CHIP_ID.ProtoMnV5, CHIP_CODE.Asterisk)

    end

    return folder

end



return JUST_PROTOMANV5

