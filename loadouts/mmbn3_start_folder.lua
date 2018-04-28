local CHIP_DATA = require "defs.chip_data_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local RANDOMIZED_LIBRARY_STARS_FOLDER = require "start_folders.randomized_library_stars_folder"
local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP = require "defs.chip_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"

local MMBN3_START_FOLDER = {}

function MMBN3_START_FOLDER.activate()

    new_folder = {}


    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Cannon,       CHIP_CODE.A)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Cannon,       CHIP_CODE.A)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Cannon,       CHIP_CODE.B)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Cannon,       CHIP_CODE.B)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.ShotGun,      CHIP_CODE.J)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.ShotGun,      CHIP_CODE.J)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.ShotGun,      CHIP_CODE.J)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.VGun,         CHIP_CODE.D)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.VGun,         CHIP_CODE.D)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.VGun,         CHIP_CODE.D)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.SideGun,      CHIP_CODE.S)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AirShot1,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AirShot1,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AirShot1,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.MiniBomb,     CHIP_CODE.B)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.MiniBomb,     CHIP_CODE.B)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.MiniBomb,     CHIP_CODE.S)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Sword,        CHIP_CODE.L)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Sword,        CHIP_CODE.L)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Sword,        CHIP_CODE.L)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.WideSwrd,     CHIP_CODE.L)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.PanlOut1,     CHIP_CODE.B)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.PanlOut1,     CHIP_CODE.B)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AreaGrab,     CHIP_CODE.L)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Recov10,      CHIP_CODE.A)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Recov10,      CHIP_CODE.A)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Recov10,      CHIP_CODE.L)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Recov10,      CHIP_CODE.L)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AtkPlus10,    CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AtkPlus10,    CHIP_CODE.Asterisk)


    gauntlet_data.current_folder = deepcopy(new_folder)

end


MMBN3_START_FOLDER.NAME = "MMBN3 Starting Folder"
MMBN3_START_FOLDER.DESCRIPTION = "Re-live the nostalgic memories of MMBN3!\n(Cannon, ShotGun, V-Gun, Sword...)"


return MMBN3_START_FOLDER

