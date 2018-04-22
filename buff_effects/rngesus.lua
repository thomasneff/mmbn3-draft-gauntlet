local gauntlet_data = require "gauntlet_data"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_NAMES = require "defs.chip_name_defs"
local CHIP_ID = require "defs.chip_id_defs"

local RARITY_INCREASE = {

    NAME = "RNGesus",
    REMOVE_AFTER_ACTIVATION = 1,
}

local RARITY_INCREASE_VALUE = 9



function RARITY_INCREASE:activate(current_round)


    -- Adjust cumulative rarity modifiers.
    -- All rarities before the index need to be reduced by the chance.

    -- 90 -> 85
    -- 95 -> 95
    -- 98 -> 98
    -- 100 -> 100

    -- 90 -> 85
    -- 95 -> 90
    -- 98 -> 98
    -- 100 -> 100

    -- 90 -> 85
    -- 95 -> 90
    -- 98 -> 93
    -- 100 -> 100

    
    gauntlet_data.force_minibombs_lower_than_ultra_rare = 1 

    for cumulative_rarity_index = 1,3 do

        gauntlet_data.rarity_mods[cumulative_rarity_index] = gauntlet_data.rarity_mods[cumulative_rarity_index] - RARITY_INCREASE_VALUE

    end

end


function RARITY_INCREASE:deactivate(current_round)

    
    gauntlet_data.force_minibombs_lower_than_ultra_rare = 0
    
    for cumulative_rarity_index = 1,3 do

        gauntlet_data.rarity_mods[cumulative_rarity_index] = gauntlet_data.rarity_mods[cumulative_rarity_index] + RARITY_INCREASE_VALUE

    end

end

function RARITY_INCREASE:get_description(current_round)


    return "Increases Drop-Chance of UltraRare-Chips by " .. tostring(RARITY_INCREASE_VALUE) .. "%!\nDrops of other rarities are replaced with " .. CHIP_NAMES[CHIP_ID.MiniBomb] .. "s!"


end

function RARITY_INCREASE:get_brief_description()
    return RARITY_INCREASE.NAME .. ": UltraRare +" .. RARITY_INCREASE_VALUE .. "%, other drops -> ".. CHIP_NAMES[CHIP_ID.MiniBomb] .. "!"
end

function RARITY_INCREASE.new()

    local new_obj = deepcopy(RARITY_INCREASE)
    --new_set_stage.STAGE = randomchoice(STAGES)


    new_obj.DESCRIPTION = new_obj:get_description(1)

    return deepcopy(new_obj)

end


return RARITY_INCREASE