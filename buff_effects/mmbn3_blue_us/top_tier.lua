local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local GAUNTLET_DEFS = require "defs.gauntlet_defs"

local TopTier = {
    NAME = "Top-Tier",
    --REMOVE_AFTER_ACTIVATION = 1,
    DOUBLE_RARITY = 1
}

local TOP_TIER_CHANCE_INCREASE = 10

function TopTier:activate(current_round)

    gauntlet_data.top_tier_active = 1
    --gauntlet_data.skill_not_luck_bonus_current = 0
    gauntlet_data.top_tier_chance = gauntlet_data.top_tier_chance + TOP_TIER_CHANCE_INCREASE

end


function TopTier:deactivate(current_round)

    gauntlet_data.top_tier_active = 0
    gauntlet_data.top_tier_chance = gauntlet_data.top_tier_chance - TOP_TIER_CHANCE_INCREASE

end

function TopTier:get_description(current_round)

    return "Each drop has a " .. tostring((TOP_TIER_CHANCE_INCREASE)) .. "% chance\nof being a higher tier!"

end

function TopTier:get_brief_description()
    return TopTier.NAME .. ": Drop Tier up! (" .. tostring((TOP_TIER_CHANCE_INCREASE)) .. "% chance)"
end

function TopTier.new()

    local new_TopTier = deepcopy(TopTier)
    new_TopTier.DESCRIPTION = new_TopTier:get_description(1)

    return deepcopy(new_TopTier)

end


return TopTier