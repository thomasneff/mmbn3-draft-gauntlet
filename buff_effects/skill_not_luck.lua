local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local GAUNTLET_DEFS = require "defs.gauntlet_defs"

local SkillNotLuck = {
    NAME = "Skill, Not Luck!",
    REMOVE_AFTER_ACTIVATION = 1,
    DOUBLE_RARITY = 1
}


function SkillNotLuck:activate(current_round)

    gauntlet_data.skill_not_luck_active = 1
    gauntlet_data.skill_not_luck_bonus_current = 0
    gauntlet_data.skill_not_luck_bonus_per_battle = gauntlet_data.skill_not_luck_bonus_per_battle + GAUNTLET_DEFS.SKILL_NOT_LUCK_RARITY_INCREASE

end


function SkillNotLuck:deactivate(current_round)

    gauntlet_data.skill_not_luck_active = 0
    gauntlet_data.skill_not_luck_bonus_current = 0

end

function SkillNotLuck:get_description(current_round)

    return "For every fight without damage taken, increase\nRarity by " .. tostring((GAUNTLET_DEFS.SKILL_NOT_LUCK_RARITY_INCREASE)) .. "%, reset on SuperRare/UltraRare drops!"

end

function SkillNotLuck:get_brief_description()
    return SkillNotLuck.NAME .. ": No HP Loss -> +" .. tostring((GAUNTLET_DEFS.SKILL_NOT_LUCK_RARITY_INCREASE)) .. "% Rarity,\n  SuperRare/UltraRare -> Reset (current: +" .. tostring(gauntlet_data.skill_not_luck_bonus_current) ..  "%)!"
end

function SkillNotLuck.new()

    local new_SkillNotLuck = deepcopy(SkillNotLuck)
    new_SkillNotLuck.DESCRIPTION = new_SkillNotLuck:get_description(1)

    return deepcopy(new_SkillNotLuck)

end


return SkillNotLuck