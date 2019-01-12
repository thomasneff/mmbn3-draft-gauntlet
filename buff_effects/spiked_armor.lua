local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local SpikedArmor = {
    NAME = "Spiked Armor",
}

local REFLECT_RANDOM_PERCENT = 1.0
local REFLECT_ALL_PERCENT = 0.5

function SpikedArmor:activate(current_round)

    if self.ALL == 1 then
        gauntlet_data.damage_reflect_all_percent = gauntlet_data.damage_reflect_all_percent + REFLECT_ALL_PERCENT
    else
        gauntlet_data.damage_reflect_random_percent = gauntlet_data.damage_reflect_random_percent + REFLECT_RANDOM_PERCENT
    end

end


function SpikedArmor:deactivate(current_round)
    if self.ALL == 1 then
        gauntlet_data.damage_reflect_all_percent = gauntlet_data.damage_reflect_all_percent - REFLECT_ALL_PERCENT
    else
        gauntlet_data.damage_reflect_random_percent = gauntlet_data.damage_reflect_random_percent - REFLECT_RANDOM_PERCENT
    end
end

function SpikedArmor:get_description(current_round)
    if self.ALL == 1 then
        return "Reflect +" .. tostring(REFLECT_ALL_PERCENT * 100) .. "% of damage taken\nto all enemies!"
    else
        return "Reflect +" .. tostring(REFLECT_RANDOM_PERCENT * 100) .. "% of damage taken\nto a random enemy!"
    end
    
end

function SpikedArmor:get_brief_description()
    if self.ALL == 1 then
        return self.NAME .. ": " .. "Reflect +" .. tostring(REFLECT_ALL_PERCENT * 100) .. "%\ndamage taken (All)!"
    else
        return self.NAME .. ": " .. "Reflect +" .. tostring(REFLECT_RANDOM_PERCENT * 100) .. "%\ndamage taken (Random)!"
    end

   
end

function SpikedArmor.new()
    local new_SpikedArmor = deepcopy(SpikedArmor)

    new_SpikedArmor.ALL = gauntlet_data.math.random_buff_activation(0, 1)

    if new_SpikedArmor.ALL == 1 then
        new_SpikedArmor.NAME = SpikedArmor.NAME .. " (All)"
    else
        new_SpikedArmor.NAME = SpikedArmor.NAME .. " (Random)"
    end

    new_SpikedArmor.DESCRIPTION = new_SpikedArmor:get_description(1)

    return deepcopy(new_SpikedArmor)
end


return SpikedArmor