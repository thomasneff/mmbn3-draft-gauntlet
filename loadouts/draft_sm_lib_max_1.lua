local CHIP_DATA = require "defs.chip_data_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local RANDOMIZED_LIBRARY_STARS_FOLDER = require "start_folders.randomized_library_stars_folder"
local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP = require "defs.chip_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"
local randomchoice_key = require "randomchoice_key"
local DRAFT_STANDARD_MEGA_MAX_1 = {}

local standard_chips = {}
local mega_chips = {}
local giga_chips = {}
local random_codes = {}

function random_chip_generator(chip_index)

    if chip_index == 10 or chip_index == 20 or chip_index == 30 then
        -- MegaChip codes are randomized so you have to either get lucky or commit to MegaChips during battle.
        local chip = CHIP.new_chip_with_random_code(randomchoice_key(mega_chips))
        
        return chip
    else
        
        local chip = CHIP.new_chip_with_random_code_from_list(randomchoice_key(standard_chips), random_codes)
        
        return chip
    end


    

    

end

function DRAFT_STANDARD_MEGA_MAX_1.activate()

    gauntlet_data.folder_draft_chip_list = {}

    for key, value in pairs(CHIP_DATA) do

        if (value.CHIP_RANKING % 4) == 0 and value.LIBRARY_STARS < 1 then
            
            standard_chips[key] = value
        
        elseif (value.CHIP_RANKING % 4) == 1 and value.LIBRARY_STARS < 3 then

            mega_chips[key] = value

        elseif (value.CHIP_RANKING % 4) == 2 then

            giga_chips[key] = value

        end

    end

    random_codes[1] = math.random(0, 4)
    random_codes[2] = math.random(5, 9)
    random_codes[3] = math.random(10, 13)
    random_codes[4] = math.random(14, 18)
    random_codes[5] = math.random(19, 22)
    random_codes[6] = math.random(23, 25)
    random_codes[7] = 26


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
    print("Draft S/M - Patched folder.")
    --print("Length of folder draft chip list:", #gauntlet_data.folder_draft_chip_list)

end


DRAFT_STANDARD_MEGA_MAX_1.NAME = "Draft Folder (Mixed, 1 Star, 6 Codes +  * )"
DRAFT_STANDARD_MEGA_MAX_1.DESCRIPTION = "You pick 30 Chips for your folder!\n(27 Standard, 3 Mega)!"


return DRAFT_STANDARD_MEGA_MAX_1

