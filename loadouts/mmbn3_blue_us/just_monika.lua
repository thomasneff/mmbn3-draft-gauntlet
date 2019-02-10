local CHIP_DATA = require "defs.chip_data_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP = require "defs.chip_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"

local JUST_MONIKA = {}

function JUST_MONIKA.activate()

    new_folder = {}


    for chip_idx = 1,GENERIC_DEFS.NUMBER_OF_CHIPS_IN_FOLDER/5 do

        new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.ProtoMnV5, CHIP_CODE.Asterisk)
        
    end

    for chip_idx = 1,GENERIC_DEFS.NUMBER_OF_CHIPS_IN_FOLDER/5 do

        new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.PlantMnV5, CHIP_CODE.Asterisk)

    end

    for chip_idx = 1,GENERIC_DEFS.NUMBER_OF_CHIPS_IN_FOLDER/5 do

        new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.FlashMnV5, CHIP_CODE.Asterisk)

    end

    for chip_idx = 1,GENERIC_DEFS.NUMBER_OF_CHIPS_IN_FOLDER/5 do

        new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.FoldrBak, CHIP_CODE.Asterisk)

    end

    for chip_idx = 1,GENERIC_DEFS.NUMBER_OF_CHIPS_IN_FOLDER/5 do

        new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.BassGS, CHIP_CODE.Asterisk)

    end


    
    gauntlet_data.current_folder = deepcopy(new_folder)

    print("Just Monika. - Patched folder.")

end


JUST_MONIKA.NAME = "Just Monika."
JUST_MONIKA.DESCRIPTION = "Just Monika."


return JUST_MONIKA

