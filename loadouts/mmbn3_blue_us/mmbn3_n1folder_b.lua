local CHIP_DATA = require "defs.chip_data_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP = require "defs.chip_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"

local MMBN3_N1FOLDER_B = {}

function MMBN3_N1FOLDER_B.activate()

    new_folder = {}


    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Cannon,       CHIP_CODE.A)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Cannon,       CHIP_CODE.B)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Cannon,       CHIP_CODE.B)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Cannon,       CHIP_CODE.C)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AirShot1,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AirShot1,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AirShot1,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AirShot1,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Bubbler,      CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Bubbler,      CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Bubbler,      CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Bubbler,      CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.HeatShot,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.HeatShot,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.HeatShot,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.HeatShot,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.ZapRing1,     CHIP_CODE.A)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.ZapRing1,     CHIP_CODE.M)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.ZapRing1,     CHIP_CODE.P)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.ZapRing1,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.YoYo1,        CHIP_CODE.C)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.YoYo1,        CHIP_CODE.E)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.YoYo1,        CHIP_CODE.G)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.YoYo1,        CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Recov30,      CHIP_CODE.F)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Recov30,      CHIP_CODE.H)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Recov30,      CHIP_CODE.M)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Recov80,      CHIP_CODE.D)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Roll,         CHIP_CODE.R)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.GutsMan,      CHIP_CODE.G)






    gauntlet_data.current_folder = deepcopy(new_folder)

    print("MMBN3 N1 Folder B - Patched folder.")

end


MMBN3_N1FOLDER_B.NAME = "MMBN3 N1 Folder B"
MMBN3_N1FOLDER_B.DESCRIPTION = "Lots of * Code Chips and Recovery!\n(Bubbler, HeatShot, Roll, GutsMan, Z-Cannon...)"


return MMBN3_N1FOLDER_B

