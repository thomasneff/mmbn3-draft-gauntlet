local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local OverCust = {
    NAME = "OverCust",
}

local DAMAGE_BUFF_ADDITIVE = 20
local DAMAGE_BUFF_MULTIPLICATIVE = 0.2

function OverCust:activate(current_round)

    if self.ADDITIVE == 0 then
        gauntlet_data.cust_damage_additive = gauntlet_data.cust_damage_additive + DAMAGE_BUFF_ADDITIVE
    else
        gauntlet_data.cust_damage_multiplicative = gauntlet_data.cust_damage_multiplicative + DAMAGE_BUFF_MULTIPLICATIVE
    end

end


function OverCust:deactivate(current_round)

    if self.ADDITIVE == 0 then
        gauntlet_data.cust_damage_additive = gauntlet_data.cust_damage_additive - DAMAGE_BUFF_ADDITIVE
    else
        gauntlet_data.cust_damage_multiplicative = gauntlet_data.cust_damage_multiplicative - DAMAGE_BUFF_MULTIPLICATIVE
    end

end

function OverCust:get_description(current_round)

    if self.ADDITIVE == 0 then
        return "Increases damage based on CustGauge,\n(more Cust = more damage) up to +" .. tostring(math.floor(DAMAGE_BUFF_MULTIPLICATIVE * 100)) .. "%!"
    else
        return "Increases damage based on CustGauge,\n(more Cust = more damage) up to +" .. tostring(DAMAGE_BUFF_ADDITIVE) .. "!"
    end

end

function OverCust:get_brief_description()

    if self.ADDITIVE == 0 then
        return OverCust.NAME .. ": " .. "Current CustGauge -> up to +" .. tostring(math.floor(DAMAGE_BUFF_MULTIPLICATIVE * 100)) .. "% damage!"
    else
        return OverCust.NAME .. ": " .. "Current CustGauge -> up to +" .. tostring(DAMAGE_BUFF_ADDITIVE) .. " damage!"
    end
    
end

function OverCust.new()

    local new_OverCust = deepcopy(OverCust)

    new_OverCust.ADDITIVE = math.random(0, 1)

    new_OverCust.DESCRIPTION = new_OverCust:get_description(1)

    return deepcopy(new_OverCust)

end


return OverCust