local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local Duelist = {
    NAME = "Duelist",
}

local DAMAGE_BUFF_ADDITIVE = 20
local DAMAGE_NERF_ADDITIVE = -10
local DAMAGE_NERF_MULTIPLICATIVE = -0.1
local DAMAGE_BUFF_MULTIPLICATIVE = 0.2

function Duelist:activate(current_round)

    if self.ADDITIVE == 0 then
        gauntlet_data.damage_per_enemy_count_additive[1] = gauntlet_data.damage_per_enemy_count_additive[1] + DAMAGE_BUFF_ADDITIVE
        gauntlet_data.damage_per_enemy_count_additive[2] = gauntlet_data.damage_per_enemy_count_additive[2] + DAMAGE_NERF_ADDITIVE
        gauntlet_data.damage_per_enemy_count_additive[3] = gauntlet_data.damage_per_enemy_count_additive[3] + DAMAGE_NERF_ADDITIVE
        gauntlet_data.damage_per_enemy_count_additive[4] = gauntlet_data.damage_per_enemy_count_additive[4] + DAMAGE_NERF_ADDITIVE
    else
        gauntlet_data.damage_per_enemy_count_multiplicative[1] = gauntlet_data.damage_per_enemy_count_multiplicative[1] + DAMAGE_BUFF_MULTIPLICATIVE
        gauntlet_data.damage_per_enemy_count_multiplicative[2] = gauntlet_data.damage_per_enemy_count_multiplicative[2] + DAMAGE_NERF_MULTIPLICATIVE
        gauntlet_data.damage_per_enemy_count_multiplicative[3] = gauntlet_data.damage_per_enemy_count_multiplicative[3] + DAMAGE_NERF_MULTIPLICATIVE
        gauntlet_data.damage_per_enemy_count_multiplicative[4] = gauntlet_data.damage_per_enemy_count_multiplicative[4] + DAMAGE_NERF_MULTIPLICATIVE
    end

end


function Duelist:deactivate(current_round)

    if self.ADDITIVE == 0 then
        gauntlet_data.damage_per_enemy_count_additive[1] = gauntlet_data.damage_per_enemy_count_additive[1] - DAMAGE_BUFF_ADDITIVE
        gauntlet_data.damage_per_enemy_count_additive[2] = gauntlet_data.damage_per_enemy_count_additive[2] - DAMAGE_NERF_ADDITIVE
        gauntlet_data.damage_per_enemy_count_additive[3] = gauntlet_data.damage_per_enemy_count_additive[3] - DAMAGE_NERF_ADDITIVE
        gauntlet_data.damage_per_enemy_count_additive[4] = gauntlet_data.damage_per_enemy_count_additive[4] - DAMAGE_NERF_ADDITIVE
    else
        gauntlet_data.damage_per_enemy_count_multiplicative[1] = gauntlet_data.damage_per_enemy_count_multiplicative[1] - DAMAGE_BUFF_MULTIPLICATIVE
        gauntlet_data.damage_per_enemy_count_multiplicative[2] = gauntlet_data.damage_per_enemy_count_multiplicative[2] - DAMAGE_NERF_MULTIPLICATIVE
        gauntlet_data.damage_per_enemy_count_multiplicative[3] = gauntlet_data.damage_per_enemy_count_multiplicative[3] - DAMAGE_NERF_MULTIPLICATIVE
        gauntlet_data.damage_per_enemy_count_multiplicative[4] = gauntlet_data.damage_per_enemy_count_multiplicative[4] - DAMAGE_NERF_MULTIPLICATIVE
    end

end

function Duelist:get_description(current_round)

    if self.ADDITIVE == 0 then
        return "When only 1 enemy is alive, damage +" .. tostring(DAMAGE_BUFF_ADDITIVE) .. ",\notherwise damage " .. tostring(DAMAGE_NERF_ADDITIVE) .. "!"
    else
        return "When only 1 enemy is alive, damage +" .. tostring(math.floor(DAMAGE_BUFF_MULTIPLICATIVE * 100)) .. "%,\notherwise damage " .. tostring(math.floor(DAMAGE_NERF_MULTIPLICATIVE * 100)) .. "%!"
    end

end

function Duelist:get_brief_description()

    if self.ADDITIVE == 0 then
        return Duelist.NAME .. ": " .."1 enemy -> damage +" .. tostring(DAMAGE_BUFF_ADDITIVE) .. ",\notherwise -> damage " .. tostring(DAMAGE_NERF_ADDITIVE) .. "!"
    else
        return Duelist.NAME .. ": " .."1 enemy -> damage +" .. tostring(math.floor(DAMAGE_BUFF_MULTIPLICATIVE * 100)) .. "%,\notherwise -> damage " .. tostring(math.floor(DAMAGE_NERF_MULTIPLICATIVE * 100)) .. "%!"
    end
    
end

function Duelist.new()

    local new_Duelist = deepcopy(Duelist)

    new_Duelist.ADDITIVE = math.random(0, 1)

    new_Duelist.DESCRIPTION = new_Duelist:get_description(1)

    return deepcopy(new_Duelist)

end


return Duelist