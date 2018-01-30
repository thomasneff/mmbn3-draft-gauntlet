local CHIP_DATA = require "defs.chip_data_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local RANDOMIZED_LIBRARY_STARS_FOLDER = require "start_folders.randomized_library_stars_folder"
local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP = require "defs.chip_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"
local randomchoice_key = require "randomchoice_key"
local DRAFT_STANDARD_MEGA_GIGA = {}

local standard_chips = {}
local mega_chips = {}
local giga_chips = {}


function random_chip_generator(chip_index)

    if chip_index == 10 or chip_index == 20 then

        return CHIP.new_chip_with_random_code(randomchoice_key(mega_chips))

    elseif chip_index == 30 then

        return CHIP.new_chip_with_random_code(randomchoice_key(giga_chips))

    else
        return CHIP.new_chip_with_random_code(randomchoice_key(standard_chips))
    end


    

    

end

function DRAFT_STANDARD_MEGA_GIGA.activate()

    gauntlet_data.folder_draft_chip_list = {}

    for key, value in pairs(CHIP_DATA) do

        if (value.CHIP_RANKING % 4) == 0 then
            
            standard_chips[key] = value
        
        elseif (value.CHIP_RANKING % 4) == 1 then

            mega_chips[key] = value

        elseif (value.CHIP_RANKING % 4) == 2 then

            giga_chips[key] = value

        end

    end


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
    gauntlet_data.folder_draft_chip_generator = random_chip_generator
    print("Draft S/M/G - Patched folder.")
    --print("Length of folder draft chip list:", #gauntlet_data.folder_draft_chip_list)

end


DRAFT_STANDARD_MEGA_GIGA.NAME = "Draft Folder (Mixed)"
DRAFT_STANDARD_MEGA_GIGA.DESCRIPTION = "You pick 30 Chips for your folder!\n(27 Standard, 2 Mega, 1 Giga)!"


return DRAFT_STANDARD_MEGA_GIGA

