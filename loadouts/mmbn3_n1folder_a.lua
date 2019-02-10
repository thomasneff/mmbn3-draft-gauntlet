local CHIP_DATA = require "defs.chip_data_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP = require "defs.chip_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"

local MMBN3_N1FOLDER_A = {}

function MMBN3_N1FOLDER_A.activate()

    new_folder = {}


    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.HiCannon,     CHIP_CODE.H)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.HiCannon,     CHIP_CODE.H)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.HiCannon,     CHIP_CODE.I)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.HiCannon,     CHIP_CODE.I)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.HiCannon,     CHIP_CODE.J)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.HiCannon,     CHIP_CODE.J)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.SonicWav,     CHIP_CODE.G)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.SonicWav,     CHIP_CODE.G)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.SonicWav,     CHIP_CODE.G)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.ZapRing1,     CHIP_CODE.A)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.ZapRing1,     CHIP_CODE.A)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Lance,        CHIP_CODE.Z)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Boomer1,      CHIP_CODE.H)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Invis,        CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Invis,        CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Sword,        CHIP_CODE.Y)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.WideSwrd,     CHIP_CODE.Y)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.LongSwrd,     CHIP_CODE.Y)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.LongSwrd,     CHIP_CODE.L)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.LongSwrd,     CHIP_CODE.R)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.FireSwrd,     CHIP_CODE.F)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AquaSwrd,     CHIP_CODE.A)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.ElecSwrd,     CHIP_CODE.E)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.BambSwrd,     CHIP_CODE.W)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.VarSwrd,      CHIP_CODE.C)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AreaGrab,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AreaGrab,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Roll,         CHIP_CODE.R)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.FlashMan,     CHIP_CODE.F)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.BeastMan,     CHIP_CODE.B)





    gauntlet_data.current_folder = deepcopy(new_folder)

end


MMBN3_N1FOLDER_A.NAME = "MMBN3 N1 Folder A"
MMBN3_N1FOLDER_A.DESCRIPTION = "Powerful Alphabet Soup! (Oh, and VarSwrd btw.)\n(Flash/BeastMan, VarSwrd, Invis, AreaGrab...)"


return MMBN3_N1FOLDER_A

