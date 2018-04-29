local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local Collector = {
    NAME = "Collector",
}

COLLECTOR_DAMAGE_PER_DUPLICATE_MULT = 0.05


function Collector:activate(current_round)

    self.collector_duplicate_damage_bonus = deepcopy(gauntlet_data.collector_duplicate_damage_bonus)
    gauntlet_data.collector_active = 1
    gauntlet_data.collector_duplicate_damage_bonus = gauntlet_data.collector_duplicate_damage_bonus + COLLECTOR_DAMAGE_PER_DUPLICATE_MULT

end


function Collector:deactivate(current_round)

    gauntlet_data.collector_duplicate_damage_bonus = deepcopy(self.collector_duplicate_damage_bonus)

end

function Collector:get_description(current_round)

    return "For every duplicate Chip, increase that Chip\nDamage by " .. tostring((COLLECTOR_DAMAGE_PER_DUPLICATE_MULT) * 100) .. "%!"

end

function Collector:get_brief_description()
    return Collector.NAME .. ": Chip duplicates -> +" .. tostring(100 * self.collector_duplicate_damage_bonus) .. "% damage!"
end

function Collector.new()

    local new_Collector = deepcopy(Collector)
    new_Collector.DESCRIPTION = new_Collector:get_description(1)

    return deepcopy(new_Collector)

end


return Collector