local CHIP_DATA = require "defs.chip_data_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local RANDOMIZED_LIBRARY_STARS_FOLDER = require "start_folders.randomized_library_stars_folder"
local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP = require "defs.chip_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"

local PA_TEST_FOLDER = {}

function PA_TEST_FOLDER.activate()

    new_folder = {}


    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.X)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.Y)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.X)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.Y)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.X)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.Y)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.X)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.Y)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.X)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.Y)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.X)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.Y)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.X)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.Y)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.X)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.Y)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.X)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.Y)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.X)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.Y)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.StepSwrd,       CHIP_CODE.Asterisk)

    gauntlet_data.current_folder = deepcopy(new_folder)

end


PA_TEST_FOLDER.NAME = "P.A. Test Folder"
PA_TEST_FOLDER.DESCRIPTION = "P.A.s to the max!"


return PA_TEST_FOLDER

