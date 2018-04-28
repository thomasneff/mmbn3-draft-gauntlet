local CHIP_DATA = require "defs.chip_data_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local RANDOMIZED_LIBRARY_STARS_FOLDER = require "start_folders.randomized_library_stars_folder"
local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP = require "defs.chip_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"

local MMBN3_PREFOLDER = {}

function MMBN3_PREFOLDER.activate()

    new_folder = {}


    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Ratton1,      CHIP_CODE.A)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Ratton1,      CHIP_CODE.A)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Ratton1,      CHIP_CODE.F)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Ratton1,      CHIP_CODE.F)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.ShotGun,      CHIP_CODE.F)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.ShotGun,      CHIP_CODE.F)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.ShotGun,      CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.VGun,         CHIP_CODE.G)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.VGun,         CHIP_CODE.G)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.VGun,         CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.SideGun,      CHIP_CODE.Y)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.SideGun,      CHIP_CODE.Y)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.SideGun,      CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Spreader,     CHIP_CODE.M)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Spreader,     CHIP_CODE.N)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Spreader,     CHIP_CODE.O)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.DashAtk,      CHIP_CODE.G)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Lance,        CHIP_CODE.H)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.PanlGrab,     CHIP_CODE.Y)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.PanlGrab,     CHIP_CODE.Y)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Guard,        CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Guard,        CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Guard,        CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Guard,        CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Sword,        CHIP_CODE.Y)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.WideSwrd,     CHIP_CODE.Y)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.LongSwrd,     CHIP_CODE.Y)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AtkPlus30,    CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AtkPlus30,    CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AtkPlus30,    CHIP_CODE.Asterisk)



    gauntlet_data.current_folder = deepcopy(new_folder)

end


MMBN3_PREFOLDER.NAME = "MMBN3 N1-Preliminaries Folder"
MMBN3_PREFOLDER.DESCRIPTION = "N1-Preliminaries, even with 2 P.A.s!\n(H-Burst, LifeSwrd, Atk+30, Ratton1...)"


return MMBN3_PREFOLDER

