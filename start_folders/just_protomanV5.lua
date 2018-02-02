local CHIP_DATA = require "defs.chip_data_defs"
local JUST_MONIKA = {}
local GENERIC_DEFS = require "defs.generic_defs"
local RANDOMIZED_LIBRARY_STARS_FOLDER = require "start_folders.randomized_library_stars_folder"
local CHIP = require "defs.chip_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"

function JUST_MONIKA.new(code_list)
    local folder = {}
    for chip_idx = 1,GENERIC_DEFS.NUMBER_OF_CHIPS_IN_FOLDER/3 do

        folder[#folder + 1] = CHIP.new_chip_with_code(CHIP_ID.ProtoMnV5, CHIP_CODE.Asterisk)

    end

    for chip_idx = 1,GENERIC_DEFS.NUMBER_OF_CHIPS_IN_FOLDER/3 do

        folder[#folder + 1] = CHIP.new_chip_with_code(CHIP_ID.PlantMnV5, CHIP_CODE.Asterisk)

    end

    for chip_idx = 1,GENERIC_DEFS.NUMBER_OF_CHIPS_IN_FOLDER/3 do

        folder[#folder + 1] = CHIP.new_chip_with_code(CHIP_ID.FlashMnV5, CHIP_CODE.Asterisk)

    end

    return folder

end



return JUST_MONIKA

