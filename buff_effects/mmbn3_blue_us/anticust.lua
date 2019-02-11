local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local AntiCust = {
    NAME = "AntiCust",
}

local DAMAGE_BUFF_ADDITIVE = 20
local DAMAGE_BUFF_MULTIPLICATIVE = 0.2

function AntiCust:activate(current_round)

    if self.ADDITIVE == 0 then
        gauntlet_data.reverse_cust_damage_multiplicative = gauntlet_data.reverse_cust_damage_multiplicative + DAMAGE_BUFF_MULTIPLICATIVE
    else
        gauntlet_data.reverse_cust_damage_additive = gauntlet_data.reverse_cust_damage_additive + DAMAGE_BUFF_ADDITIVE
    end

end


function AntiCust:deactivate(current_round)

    if self.ADDITIVE == 0 then
        gauntlet_data.reverse_cust_damage_multiplicative = gauntlet_data.reverse_cust_damage_multiplicative - DAMAGE_BUFF_MULTIPLICATIVE
    else
        gauntlet_data.reverse_cust_damage_additive = gauntlet_data.reverse_cust_damage_additive - DAMAGE_BUFF_ADDITIVE
    end

end

function AntiCust:get_description(current_round)

    if self.ADDITIVE == 0 then
        return "Increases damage based on CustGauge,\n(less Cust = more damage) up to +" .. tostring(math.floor(DAMAGE_BUFF_MULTIPLICATIVE * 100)) .. "%!"
    else
        return "Increases damage based on CustGauge,\n(less Cust = more damage) up to +" .. tostring(DAMAGE_BUFF_ADDITIVE) .. "!"
    end

end

function AntiCust:get_brief_description()

    if self.ADDITIVE == 0 then
        return AntiCust.NAME .. ": " .. "Missing CustGauge -> up to +" .. tostring(math.floor(DAMAGE_BUFF_MULTIPLICATIVE * 100)) .. "% damage!"
    else
        return AntiCust.NAME .. ": " .. "Missing CustGauge -> up to +" .. tostring(DAMAGE_BUFF_ADDITIVE) .. " damage!"
    end
    
end

function AntiCust.new()

    local new_AntiCust = deepcopy(AntiCust)

    new_AntiCust.ADDITIVE = gauntlet_data.math.random_buff_activation(0, 1)

    new_AntiCust.DESCRIPTION = new_AntiCust:get_description(1)

    return deepcopy(new_AntiCust)

end


return AntiCust