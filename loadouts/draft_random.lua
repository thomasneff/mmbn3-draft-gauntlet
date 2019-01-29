local CHIP_DATA = require "defs.chip_data_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local RANDOMIZED_LIBRARY_STARS_FOLDER = require "start_folders.randomized_library_stars_folder"
local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP = require "defs.chip_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"
local DRAFT_RANDOM = {}

function DRAFT_RANDOM.random_chip_generator(chip_index)

    return CHIP.new_random_chip_with_random_code()

end

function DRAFT_RANDOM.activate()

    gauntlet_data.folder_draft_chip_list = {}


    -- Add all combination of chips and codes.
    --[[for key, id in pairs(CHIP_ID) do

        for key2, code in pairs(CHIP_CODE) do


            local new_chip = {
                ID = id,
                CODE = code                
            }

            gauntlet_data.folder_draft_chip_list[#gauntlet_data.folder_draft_chip_list + 1] = new_chip

        end
    end]]

    gauntlet_data.current_folder = {}

    gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_DRAFT_FOLDER
    gauntlet_data.folder_draft_chip_generator = DRAFT_RANDOM.random_chip_generator
    print("Draft Random - Patched folder.")
    --print("Length of folder draft chip list:", #gauntlet_data.folder_draft_chip_list)

end


DRAFT_RANDOM.NAME = "Draft Folder (Random)"
DRAFT_RANDOM.DESCRIPTION = "You pick 30 Chips for your folder,\nfrom all Chips in the game!"


return DRAFT_RANDOM

