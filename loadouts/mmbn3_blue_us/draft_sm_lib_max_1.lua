local CHIP_DATA = require "defs.chip_data_defs"
local GENERIC_DEFS = require "defs.generic_defs"
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

function DRAFT_STANDARD_MEGA_MAX_1.random_chip_generator(chip_index)



    
    if chip_index == 10 or chip_index == 20 or chip_index == 30 then
        -- MegaChip codes are randomized so you have to either get lucky or commit to MegaChips during battle.
        local chip = CHIP.new_chip_with_random_code(randomchoice_key(mega_chips, "DRAFTING"))
        
        return chip
    else
        --print(standard_chips)
        local chip = CHIP.new_chip_with_random_code_from_list(randomchoice_key(standard_chips, "DRAFTING"), random_codes)
        
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

    random_codes[1] = gauntlet_data.math.random_named("DRAFTING", 0, 4)
    random_codes[2] = gauntlet_data.math.random_named("DRAFTING", 5, 9)
    random_codes[3] = gauntlet_data.math.random_named("DRAFTING", 10, 13)
    random_codes[4] = gauntlet_data.math.random_named("DRAFTING", 14, 18)
    random_codes[5] = gauntlet_data.math.random_named("DRAFTING", 19, 22)
    random_codes[6] = gauntlet_data.math.random_named("DRAFTING", 23, 25)
    random_codes[7] = random_codes[1]
    random_codes[8] = random_codes[2]
    random_codes[9] = random_codes[3]
    random_codes[10] = random_codes[4]
    random_codes[11] = random_codes[5]
    random_codes[12] = random_codes[6]
    -- Asterisk is more unlikely.
    random_codes[13] = 26


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
    gauntlet_data.folder_draft_chip_generator = DRAFT_STANDARD_MEGA_MAX_1.random_chip_generator
    print("Draft Folder (Mixed, 1 Star, 6 Codes +  * ) - Patched folder.")
    --print("Length of folder draft chip list:", #gauntlet_data.folder_draft_chip_list)

end


DRAFT_STANDARD_MEGA_MAX_1.NAME = "Draft Folder (Mixed, 1 Star, 6 Codes +  * )"
DRAFT_STANDARD_MEGA_MAX_1.DESCRIPTION = "You pick 30 Chips for your folder!\n(27 Standard, 3 Mega)!"


return DRAFT_STANDARD_MEGA_MAX_1

