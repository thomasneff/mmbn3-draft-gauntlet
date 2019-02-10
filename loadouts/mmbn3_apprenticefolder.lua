local CHIP_DATA = require "defs.chip_data_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP = require "defs.chip_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"

local MMBN3_APPRENTICEFOLDER = {}

function MMBN3_APPRENTICEFOLDER.activate()

    new_folder = {}


    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AirShot1,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AirShot1,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AirShot1,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AirShot1,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.RockCube,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.RockCube,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.RockCube,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.GutPunch,     CHIP_CODE.D)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.GutPunch,     CHIP_CODE.D)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.GutPunch,     CHIP_CODE.D)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.GutPunch,     CHIP_CODE.D)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Mine,         CHIP_CODE.D)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Bubbler,      CHIP_CODE.E)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.BubV,         CHIP_CODE.E)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.BublSide,     CHIP_CODE.E)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.HeatShot,     CHIP_CODE.J)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.HeatV,        CHIP_CODE.J)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.HeatSide,     CHIP_CODE.J)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Plasma1,      CHIP_CODE.J)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Plasma1,      CHIP_CODE.J)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Plasma1,      CHIP_CODE.J)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.RndmMetr,     CHIP_CODE.S)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.RndmMetr,     CHIP_CODE.S)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.RndmMetr,     CHIP_CODE.S)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.TimeBomb,     CHIP_CODE.K)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Prism,        CHIP_CODE.K)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Prism,        CHIP_CODE.W)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.MetalMan,     CHIP_CODE.M)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.MetalMnV2,    CHIP_CODE.M)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.MetalMnV3,    CHIP_CODE.M)
    
 
 



    gauntlet_data.current_folder = deepcopy(new_folder)

end


MMBN3_APPRENTICEFOLDER.NAME = "MMBN3 Apprentice Folder"
MMBN3_APPRENTICEFOLDER.DESCRIPTION = "Prism-HeatSprd, Air-Cube, BubSprd combo folder!\n(TimeBomb, MetalManV1/V2/V3, RndmMetr...)"


return MMBN3_APPRENTICEFOLDER

