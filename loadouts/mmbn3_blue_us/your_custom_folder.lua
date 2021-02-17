local CHIP_DATA = require "defs.chip_data_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP = require "defs.chip_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"

local YOUR_CUSTOM_FOLDER = {}

function YOUR_CUSTOM_FOLDER.activate()

    new_folder = {}

    -- Hey! Feel free to replace this with whatever chips you want.
    -- You can find the chip definitions/names in defs/mmbn3_blue_us/chip_id_defs .
    -- Chip codes should be self-explanatory, except for CHIP_CODE.Asterisk for *-Code chips.
    -- I have no Idea what happens if you try to add more or less than 30 chips, but it'll likely break somewhere, so caution.

    -- If you want to add an additional loadout and not just modify this one, you'll need to do the following:
    -- 1.) Copy a "base" file within the loadouts folder and replace the name in ERROR_CHECKED_SPECIFIC_GAME_WRAPPER.get_module() with your new loadout name
    -- 2.) Copy an existing loadout from the loadouts/mmbn3_blue_us/ folder and replace its Name with your chosen name
    -- 3.) Add your new folder to the list in loadouts/mmbn3_blue_us/loadout_defs.lua by adding a "require" statement at the top and adding to the LIST_OF_LOADOUTS. 

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
    print("Your Custom Folder - Patched folder.")

end


YOUR_CUSTOM_FOLDER.NAME = "Your Custom Folder"
YOUR_CUSTOM_FOLDER.DESCRIPTION = "Replace the chips with whatever you want in\nloadouts/mmbn3_blue_us/your_custom_folder.lua !"


return YOUR_CUSTOM_FOLDER

