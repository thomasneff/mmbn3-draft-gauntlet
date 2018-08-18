local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local Masamune = {
    NAME = "Masamune",
}

local DAMAGE_BUFF_ADDITIVE = 20
local DAMAGE_BUFF_MULTIPLICATIVE = 0.2

function Masamune:activate(current_round)

    if self.ADDITIVE == 0 then
        gauntlet_data.masamune_damage_additive = gauntlet_data.masamune_damage_additive + DAMAGE_BUFF_ADDITIVE
    else
        gauntlet_data.masamune_damage_multiplicative = gauntlet_data.masamune_damage_multiplicative + DAMAGE_BUFF_MULTIPLICATIVE
    end

end


function Masamune:deactivate(current_round)

    if self.ADDITIVE == 0 then
        gauntlet_data.masamune_damage_additive = gauntlet_data.masamune_damage_additive - DAMAGE_BUFF_ADDITIVE
    else
        gauntlet_data.masamune_damage_multiplicative = gauntlet_data.masamune_damage_multiplicative - DAMAGE_BUFF_MULTIPLICATIVE
    end

end

function Masamune:get_description(current_round)

    if self.ADDITIVE == 0 then
        return "Increases damage based on current HP,\n(more HP = more damage) up to +" .. tostring(math.floor(DAMAGE_BUFF_MULTIPLICATIVE * 100)) .. "%!"
    else
        return "Increases damage based on current HP,\n(more HP = more damage) up to +" .. tostring(DAMAGE_BUFF_ADDITIVE) .. "!"
    end

end

function Masamune:get_brief_description()

    if self.ADDITIVE == 0 then
        return Masamune.NAME .. ": " .. "Current HP -> up to +" .. tostring(math.floor(DAMAGE_BUFF_MULTIPLICATIVE * 100)) .. "% damage!"
    else
        return Masamune.NAME .. ": " .. "Current HP -> up to +" .. tostring(DAMAGE_BUFF_ADDITIVE) .. " damage!"
    end
    
end

function Masamune.new()

    local new_Masamune = deepcopy(Masamune)

    new_Masamune.ADDITIVE = math.random(0, 1)

    new_Masamune.DESCRIPTION = new_Masamune:get_description(1)

    return deepcopy(new_Masamune)

end


return Masamune