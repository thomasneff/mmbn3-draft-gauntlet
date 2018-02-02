local CHIP_DATA = require "defs.chip_data_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local RANDOMIZED_LIBRARY_STARS_FOLDER = require "start_folders.randomized_library_stars_folder"
local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP = require "defs.chip_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"

local JUST_PROTOMANV5 = {}

function JUST_PROTOMANV5.activate()

    new_folder = {}

    for chip_idx = 1,GENERIC_DEFS.NUMBER_OF_CHIPS_IN_FOLDER do

        new_folder[chip_idx] = CHIP.new_chip_with_code(CHIP_ID.ProtoMnV5, CHIP_CODE.Asterisk)

    end
    
    gauntlet_data.current_folder = deepcopy(new_folder)

    print("Just ProtoMnV5.")

end


JUST_PROTOMANV5.NAME = "Just ProtoMnV5."
JUST_PROTOMANV5.DESCRIPTION = "Just ProtoMnV5."


return JUST_PROTOMANV5

