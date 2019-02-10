local CHIP_DATA = require "defs.chip_data_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP = require "defs.chip_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"

local MMBN3_HADESFOLDER = {}

function MMBN3_HADESFOLDER.activate()

    new_folder = {}


    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Bubbler,      CHIP_CODE.A)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Bubbler,      CHIP_CODE.A)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.HeatShot,     CHIP_CODE.B)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.HeatShot,     CHIP_CODE.B)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.SnglBomb,     CHIP_CODE.O)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.SnglBomb,     CHIP_CODE.O)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.SnglBomb,     CHIP_CODE.O)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.CannBall,     CHIP_CODE.D)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.CannBall,     CHIP_CODE.D)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.CannBall,     CHIP_CODE.D)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Burner,       CHIP_CODE.S)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Burner,       CHIP_CODE.S)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Burner,       CHIP_CODE.S)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Burner,       CHIP_CODE.S)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Boomer1,      CHIP_CODE.H)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Boomer1,      CHIP_CODE.H)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Boomer1,      CHIP_CODE.H)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Boomer1,      CHIP_CODE.H)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.WideSwrd,     CHIP_CODE.Q)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.LongSwrd,     CHIP_CODE.E)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.FireSwrd,     CHIP_CODE.F)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AquaSwrd,     CHIP_CODE.N)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.ElecSwrd,     CHIP_CODE.V)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.BambSwrd,     CHIP_CODE.W)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Recov80,      CHIP_CODE.D)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Recov80,      CHIP_CODE.D)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AtkPlus10,    CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Roll,         CHIP_CODE.R)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.GutsMan,      CHIP_CODE.G)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.GutsManV2,    CHIP_CODE.G)





    gauntlet_data.current_folder = deepcopy(new_folder)

    print("MMBN3 Hades Folder - Patched folder.")

end


MMBN3_HADESFOLDER.NAME = "MMBN3 Hades Folder"
MMBN3_HADESFOLDER.DESCRIPTION = "Elements and Bombs, even with 2 MegaChips!\n(GutsManV1/V2, Roll, Recov80, Elem Swords...)"


return MMBN3_HADESFOLDER

