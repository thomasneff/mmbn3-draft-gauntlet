local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local Muramasa = {
    NAME = "Muramasa",
}

local DAMAGE_BUFF_ADDITIVE = 20
local DAMAGE_BUFF_MULTIPLICATIVE = 0.2

function Muramasa:activate(current_round)

    if self.ADDITIVE == 0 then
        gauntlet_data.muramasa_damage_multiplicative = gauntlet_data.muramasa_damage_multiplicative + DAMAGE_BUFF_MULTIPLICATIVE
    else
        gauntlet_data.muramasa_damage_additive = gauntlet_data.muramasa_damage_additive + DAMAGE_BUFF_ADDITIVE
    end

end


function Muramasa:deactivate(current_round)

    if self.ADDITIVE == 0 then
        gauntlet_data.muramasa_damage_multiplicative = gauntlet_data.muramasa_damage_multiplicative - DAMAGE_BUFF_MULTIPLICATIVE
    else
        gauntlet_data.muramasa_damage_additive = gauntlet_data.muramasa_damage_additive - DAMAGE_BUFF_ADDITIVE
    end

end

function Muramasa:get_description(current_round)

    if self.ADDITIVE == 0 then
        return "Increases damage based on missing HP,\n(less HP = more damage) up to +" .. tostring(math.floor(DAMAGE_BUFF_MULTIPLICATIVE * 100)) .. "%!"
    else
        return "Increases damage based on missing HP,\n(less HP = more damage) up to +" .. tostring(DAMAGE_BUFF_ADDITIVE) .. "!"
    end

end

function Muramasa:get_brief_description()

    if self.ADDITIVE == 0 then
        return Muramasa.NAME .. ": " .. "Missing HP -> up to +" .. tostring(math.floor(DAMAGE_BUFF_MULTIPLICATIVE * 100)) .. "% damage!"
    else
        return Muramasa.NAME .. ": " .. "Missing HP -> up to +" .. tostring(DAMAGE_BUFF_ADDITIVE) .. " damage!"
    end
    
end

function Muramasa.new()

    local new_Muramasa = deepcopy(Muramasa)

    new_Muramasa.ADDITIVE = gauntlet_data.math.random_buff_activation(0, 1)

    new_Muramasa.DESCRIPTION = new_Muramasa:get_description(1)

    return deepcopy(new_Muramasa)

end


return Muramasa