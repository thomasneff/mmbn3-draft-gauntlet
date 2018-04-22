local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local Perfectionist = {
    NAME = "Perfectionist",
    REMOVE_AFTER_ACTIVATION = 1,
}

PERFECTIONIST_DAMAGE_PER_PERFECT_FIGHT_MULT = 0.05
PERFECTIONIST_DAMAGE_MULT_LIMIT_INCREASE = 0.5

function Perfectionist:activate(current_round)

    self.temporary_damage_bonus_mult_old = deepcopy(gauntlet_data.temporary_damage_bonus_mult)
    gauntlet_data.temporary_damage_bonus_mult.LIMIT = gauntlet_data.temporary_damage_bonus_mult.LIMIT + PERFECTIONIST_DAMAGE_MULT_LIMIT_INCREASE
    gauntlet_data.temporary_damage_bonus_mult.PERFECT_FIGHT_INCREASE = gauntlet_data.temporary_damage_bonus_mult.PERFECT_FIGHT_INCREASE + PERFECTIONIST_DAMAGE_PER_PERFECT_FIGHT_MULT

end


function Perfectionist:deactivate(current_round)

    gauntlet_data.temporary_damage_bonus_mult = deepcopy(self.temporary_damage_bonus_mult_old)

end

function Perfectionist:get_description(current_round)

    return "For every fight without damage taken,\nincrease Chip damage by " .. tostring((PERFECTIONIST_DAMAGE_PER_PERFECT_FIGHT_MULT) * 100) .. "%, up to +" .. tostring((PERFECTIONIST_DAMAGE_MULT_LIMIT_INCREASE + gauntlet_data.temporary_damage_bonus_mult.LIMIT - 1.0) * 100) .. "%!"

end

function Perfectionist:get_brief_description()
    return Perfectionist.NAME .. ": No HP Loss -> +" .. tostring(100 *PERFECTIONIST_DAMAGE_PER_PERFECT_FIGHT_MULT) .. "% dmg, up to +" .. tostring((gauntlet_data.temporary_damage_bonus_mult.LIMIT - 1.0) * 100) .. "%!"
end

function Perfectionist.new()

    local new_Perfectionist = deepcopy(Perfectionist)
    new_Perfectionist.DESCRIPTION = new_Perfectionist:get_description(1)

    return deepcopy(new_Perfectionist)

end


return Perfectionist