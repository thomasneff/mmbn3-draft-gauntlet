local CHIP_DATA = require "defs.chip_data_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP = require "defs.chip_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"

local MMBN3_N1FOLDER_C = {}

function MMBN3_N1FOLDER_C.activate()

    new_folder = {}


    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.MiniBomb,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.MiniBomb,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.SnglBomb,     CHIP_CODE.H)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.SnglBomb,     CHIP_CODE.H)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.SnglBomb,     CHIP_CODE.H)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.SnglBomb,     CHIP_CODE.H)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.CannBall,     CHIP_CODE.P)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.CannBall,     CHIP_CODE.P)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.CannBall,     CHIP_CODE.P)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.CannBall,     CHIP_CODE.P)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Hammer,       CHIP_CODE.T)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Hammer,       CHIP_CODE.T)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.PanlOut3,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.PanlOut3,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.PanlOut3,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.PanlOut3,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Recov10,      CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Recov30,      CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Recov50,      CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Recov80,      CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.PanlGrab,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.PanlGrab,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AreaGrab,     CHIP_CODE.E)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AreaGrab,     CHIP_CODE.E)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Repair,       CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Snake,        CHIP_CODE.I)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Snake,        CHIP_CODE.I)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Snake,        CHIP_CODE.I)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AtkPlus10,    CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.WoodPlus30,   CHIP_CODE.Asterisk)



    gauntlet_data.current_folder = deepcopy(new_folder)

end


MMBN3_N1FOLDER_C.NAME = "MMBN3 N1 Folder C"
MMBN3_N1FOLDER_C.DESCRIPTION = "Snakes, * Code Chips and Bombs!\n(Snake, PanlOut3, AreaGrab, CannBall, Repair...)"


return MMBN3_N1FOLDER_C

