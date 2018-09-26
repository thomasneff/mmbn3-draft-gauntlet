local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local Backstab = {
    NAME = "Backstab",
    REMOVE_AFTER_ACTIVATION = 1,
    DOUBLE_RARITY = 1,
}

local PERCENTAGE_DAMAGE = 0.20

function Backstab:activate(current_round)

    gauntlet_data.backstab_percentage_damage = gauntlet_data.backstab_percentage_damage + PERCENTAGE_DAMAGE

end


function Backstab:deactivate(current_round)

    gauntlet_data.backstab_percentage_damage = gauntlet_data.backstab_percentage_damage - PERCENTAGE_DAMAGE

end

function Backstab:get_description(current_round)
    return "Bosses start with " .. tostring(math.floor(PERCENTAGE_DAMAGE * 100)) .. "% less HP!"
end

function Backstab:get_brief_description()
    return Backstab.NAME .. ": " .. "Boss HP -" .. tostring(math.floor(PERCENTAGE_DAMAGE * 100)) ..  "%!"
end

function Backstab.new()

    local new_Backstab = deepcopy(Backstab)

    new_Backstab.DESCRIPTION = new_Backstab:get_description(1)

    return deepcopy(new_Backstab)

end


return Backstab