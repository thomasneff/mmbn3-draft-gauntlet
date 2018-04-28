local CHIP_DATA = require "defs.chip_data_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local RANDOMIZED_LIBRARY_STARS_FOLDER = require "start_folders.randomized_library_stars_folder"
local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP = require "defs.chip_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"

local MMBN3_FAMFOLDER = {}

function MMBN3_FAMFOLDER.activate()

    new_folder = {}


    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.ZapRing1,     CHIP_CODE.A)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.ZapRing1,     CHIP_CODE.A)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.MetaGel1,     CHIP_CODE.C)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.MetaGel1,     CHIP_CODE.C)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.MetaGel1,     CHIP_CODE.C)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Boomer1,      CHIP_CODE.F)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Boomer1,      CHIP_CODE.F)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Boomer1,      CHIP_CODE.F)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Tornado,      CHIP_CODE.T)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Tornado,      CHIP_CODE.T)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Spice1,       CHIP_CODE.S)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Spice1,       CHIP_CODE.S)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Spice1,       CHIP_CODE.S)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Plasma1,      CHIP_CODE.J)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Plasma1,      CHIP_CODE.J)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Plasma1,      CHIP_CODE.J)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.Burner,       CHIP_CODE.Q)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.LavaStge,     CHIP_CODE.T)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.IceStage,     CHIP_CODE.G)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.GrassStg,     CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.SandStge,     CHIP_CODE.B)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.FirePlus30,   CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.AquaPlus30,   CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.ElecPlus30,   CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.WoodPlus30,   CHIP_CODE.Asterisk)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.FlashMan,     CHIP_CODE.F)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.BubblMan,     CHIP_CODE.B)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.BeastMan,     CHIP_CODE.B)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.FlamMan,      CHIP_CODE.F)
    new_folder[#new_folder + 1] = CHIP.new_chip_with_code(CHIP_ID.PlantMan,     CHIP_CODE.P)




    gauntlet_data.current_folder = deepcopy(new_folder)

end


MMBN3_FAMFOLDER.NAME = "MMBN3 Famous Folder"
MMBN3_FAMFOLDER.DESCRIPTION = "Navis, Stages and Elem+30/Element chips!\n(FlashMan, PlantMan, FlameMan, MetaGel...)"


return MMBN3_FAMFOLDER

