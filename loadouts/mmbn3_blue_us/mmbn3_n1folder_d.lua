local CHIP_DATA = require "defs.chip_data_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP = require "defs.chip_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"

local MMBN3_N1FOLDER_D = {}

function MMBN3_N1FOLDER_D.activate()

    new_folder = {}


    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Sword,        CHIP_CODE.Y)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Sword,        CHIP_CODE.Y)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Sword,        CHIP_CODE.Y)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Sword,        CHIP_CODE.Y)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.WideSwrd,     CHIP_CODE.L)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.WideSwrd,     CHIP_CODE.L)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.WideSwrd,     CHIP_CODE.L)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.WideSwrd,     CHIP_CODE.L)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.PanlGrab,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.PanlGrab,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AreaGrab,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.SnglBomb,     CHIP_CODE.T)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.CannBall,     CHIP_CODE.P)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AirSwrd,      CHIP_CODE.R)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.ShockWav,     CHIP_CODE.D)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.GutPunch,     CHIP_CODE.C)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.DashAtk,      CHIP_CODE.Z)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Burner,       CHIP_CODE.Q)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Ratton1,      CHIP_CODE.A)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Hammer,       CHIP_CODE.G)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.ZapRing1,     CHIP_CODE.M)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.YoYo1,        CHIP_CODE.F)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Lance,        CHIP_CODE.H)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Boomer1,      CHIP_CODE.J)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Plasma1,      CHIP_CODE.B)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Tornado,      CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Wind,         CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AtkPlus10,    CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.FlashMan,     CHIP_CODE.F)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.BubblMan,    CHIP_CODE.B)

    


    gauntlet_data.current_folder = deepcopy(new_folder)

    print("MMBN3 N1 Folder D - Patched folder.")

end


MMBN3_N1FOLDER_D.NAME = "MMBN3 N1 Folder D"
MMBN3_N1FOLDER_D.DESCRIPTION = "Alphabet Soup, but pretty bad.\n(FlashMan, BubbleMan, Tornado, AreaGrab...)"


return MMBN3_N1FOLDER_D

