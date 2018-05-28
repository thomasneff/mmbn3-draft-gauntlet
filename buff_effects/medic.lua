local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local Medic = {
    NAME = "Medic",
}

local HEALING_INCREASE_MULT = 0.5

function Medic:activate(current_round)
    gauntlet_data.healing_increase_mult = gauntlet_data.healing_increase_mult + HEALING_INCREASE_MULT
end


function Medic:deactivate(current_round)
    gauntlet_data.healing_increase_mult = gauntlet_data.healing_increase_mult - HEALING_INCREASE_MULT
end

function Medic:get_description(current_round)
    return "Healing +" .. tostring(HEALING_INCREASE_MULT * 100) .. "% more effective!"
end

function Medic:get_brief_description()
    return Medic.NAME .. ": " .. "Healing +" .. tostring(HEALING_INCREASE_MULT * 100) .. "%!"
end

function Medic.new()
    local new_Medic = deepcopy(Medic)
    new_Medic.DESCRIPTION = new_Medic:get_description(1)

    return deepcopy(new_Medic)
end


return Medic