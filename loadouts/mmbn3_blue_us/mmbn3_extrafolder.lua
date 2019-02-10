local CHIP_DATA = require "defs.chip_data_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP = require "defs.chip_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"

local MMBN3_EXTRAFOLDER = {}

function MMBN3_EXTRAFOLDER.activate()

    new_folder = {}


    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Cannon,       CHIP_CODE.A)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Cannon,       CHIP_CODE.A)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Cannon,       CHIP_CODE.A)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Cannon,       CHIP_CODE.A)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.ShotGun,      CHIP_CODE.J)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.ShotGun,      CHIP_CODE.J)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.ShotGun,      CHIP_CODE.J)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.ShotGun,      CHIP_CODE.J)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.VGun,         CHIP_CODE.D)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.VGun,         CHIP_CODE.D)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.VGun,         CHIP_CODE.D)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.VGun,         CHIP_CODE.D)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.SideGun,      CHIP_CODE.S)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.SideGun,      CHIP_CODE.S)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.SideGun,      CHIP_CODE.S)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.SideGun,      CHIP_CODE.S)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AirShot1,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AirShot1,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AirShot1,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AirShot1,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.MiniBomb,     CHIP_CODE.B)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.MiniBomb,     CHIP_CODE.B)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.MiniBomb,     CHIP_CODE.B)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.MiniBomb,     CHIP_CODE.B)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Sword,        CHIP_CODE.L)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Sword,        CHIP_CODE.L)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Sword,        CHIP_CODE.L)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Sword,        CHIP_CODE.L)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.WideSwrd,     CHIP_CODE.L)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AreaGrab,     CHIP_CODE.L)



    gauntlet_data.current_folder = deepcopy(new_folder)

    print("MMBN3 Extra Folder - Patched folder.")

end


MMBN3_EXTRAFOLDER.NAME = "MMBN3 Extra Folder"
MMBN3_EXTRAFOLDER.DESCRIPTION = "Like the starting folder, but with better flow!\n(Cannon, ShotGun, V-Gun, Sword...)"


return MMBN3_EXTRAFOLDER

