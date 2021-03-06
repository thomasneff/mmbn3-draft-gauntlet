local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local Perfectionist = {
    NAME = "Perfectionist",
}

PERFECTIONIST_DAMAGE_PER_PERFECT_FIGHT_MULT = 0.05
PERFECTIONIST_DAMAGE_MULT_LIMIT_INCREASE = 0.5

function Perfectionist:activate(current_round)

    self.perfectionist_damage_bonus_mult_old = deepcopy(gauntlet_data.perfectionist_damage_bonus_mult)
    gauntlet_data.perfectionist_damage_bonus_mult.LIMIT = gauntlet_data.perfectionist_damage_bonus_mult.LIMIT + PERFECTIONIST_DAMAGE_MULT_LIMIT_INCREASE
    gauntlet_data.perfectionist_damage_bonus_mult.PERFECT_FIGHT_INCREASE = gauntlet_data.perfectionist_damage_bonus_mult.PERFECT_FIGHT_INCREASE + PERFECTIONIST_DAMAGE_PER_PERFECT_FIGHT_MULT

end


function Perfectionist:deactivate(current_round)

    gauntlet_data.perfectionist_damage_bonus_mult = deepcopy(self.perfectionist_damage_bonus_mult_old)

end

function Perfectionist:get_description(current_round)

    return "For every fight without HP loss, increase Chip\nDamage by " .. tostring((PERFECTIONIST_DAMAGE_PER_PERFECT_FIGHT_MULT) * 100) .. "%, up to +" .. tostring((PERFECTIONIST_DAMAGE_MULT_LIMIT_INCREASE + gauntlet_data.perfectionist_damage_bonus_mult.LIMIT - 1.0) * 100) .. "% (reset on HP loss)!"

end

function Perfectionist:get_brief_description()
    return Perfectionist.NAME .. ": No HP Loss -> +" .. tostring(100 *PERFECTIONIST_DAMAGE_PER_PERFECT_FIGHT_MULT) .. "% dmg, up to +" .. tostring((gauntlet_data.perfectionist_damage_bonus_mult.LIMIT - 1.0) * 100) .. "%,\n  HP Loss -> Reset (current: +" .. tostring(100 * (gauntlet_data.perfectionist_damage_bonus_mult.CURRENT - 1.0)) ..  "%)!"
end

function Perfectionist.new()

    local new_Perfectionist = deepcopy(Perfectionist)
    new_Perfectionist.DESCRIPTION = new_Perfectionist:get_description(1)

    return deepcopy(new_Perfectionist)

end


return Perfectionist