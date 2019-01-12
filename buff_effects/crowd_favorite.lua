local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local CrowdFavorite = {
    NAME = "Crowd Favorite",
}

local DAMAGE_BUFF_ADDITIVE = 30
local DAMAGE_NERF_ADDITIVE = -10
local DAMAGE_NERF_MULTIPLICATIVE = -0.1
local DAMAGE_BUFF_MULTIPLICATIVE = 0.3

function CrowdFavorite:activate(current_round)

    if self.ADDITIVE == 0 then
        gauntlet_data.damage_per_enemy_count_multiplicative[1] = gauntlet_data.damage_per_enemy_count_multiplicative[1] + DAMAGE_NERF_MULTIPLICATIVE
        gauntlet_data.damage_per_enemy_count_multiplicative[2] = gauntlet_data.damage_per_enemy_count_multiplicative[2] + DAMAGE_BUFF_MULTIPLICATIVE
        gauntlet_data.damage_per_enemy_count_multiplicative[3] = gauntlet_data.damage_per_enemy_count_multiplicative[3] + DAMAGE_BUFF_MULTIPLICATIVE
        gauntlet_data.damage_per_enemy_count_multiplicative[4] = gauntlet_data.damage_per_enemy_count_multiplicative[4] + DAMAGE_BUFF_MULTIPLICATIVE
    else
        gauntlet_data.damage_per_enemy_count_additive[1] = gauntlet_data.damage_per_enemy_count_additive[1] + DAMAGE_NERF_ADDITIVE
        gauntlet_data.damage_per_enemy_count_additive[2] = gauntlet_data.damage_per_enemy_count_additive[2] + DAMAGE_BUFF_ADDITIVE
        gauntlet_data.damage_per_enemy_count_additive[3] = gauntlet_data.damage_per_enemy_count_additive[3] + DAMAGE_BUFF_ADDITIVE
        gauntlet_data.damage_per_enemy_count_additive[4] = gauntlet_data.damage_per_enemy_count_additive[4] + DAMAGE_BUFF_ADDITIVE
    end

end


function CrowdFavorite:deactivate(current_round)

    if self.ADDITIVE == 0 then
        gauntlet_data.damage_per_enemy_count_multiplicative[1] = gauntlet_data.damage_per_enemy_count_multiplicative[1] - DAMAGE_NERF_MULTIPLICATIVE
        gauntlet_data.damage_per_enemy_count_multiplicative[2] = gauntlet_data.damage_per_enemy_count_multiplicative[2] - DAMAGE_BUFF_MULTIPLICATIVE
        gauntlet_data.damage_per_enemy_count_multiplicative[3] = gauntlet_data.damage_per_enemy_count_multiplicative[3] - DAMAGE_BUFF_MULTIPLICATIVE
        gauntlet_data.damage_per_enemy_count_multiplicative[4] = gauntlet_data.damage_per_enemy_count_multiplicative[4] - DAMAGE_BUFF_MULTIPLICATIVE
    else
        gauntlet_data.damage_per_enemy_count_additive[1] = gauntlet_data.damage_per_enemy_count_additive[1] - DAMAGE_NERF_ADDITIVE
        gauntlet_data.damage_per_enemy_count_additive[2] = gauntlet_data.damage_per_enemy_count_additive[2] - DAMAGE_BUFF_ADDITIVE
        gauntlet_data.damage_per_enemy_count_additive[3] = gauntlet_data.damage_per_enemy_count_additive[3] - DAMAGE_BUFF_ADDITIVE
        gauntlet_data.damage_per_enemy_count_additive[4] = gauntlet_data.damage_per_enemy_count_additive[4] - DAMAGE_BUFF_ADDITIVE
    end

end

function CrowdFavorite:get_description(current_round)

    if self.ADDITIVE == 0 then
        return "When more than 1 enemy is alive,\ndamage +" .. tostring(DAMAGE_BUFF_ADDITIVE) .. ", otherwise damage " .. tostring(DAMAGE_NERF_ADDITIVE) .. "!"
    else
        return "When more than 1 enemy is alive,\ndamage +" .. tostring(math.floor(DAMAGE_BUFF_MULTIPLICATIVE * 100)) .. "%, otherwise damage " .. tostring(math.floor(DAMAGE_NERF_MULTIPLICATIVE * 100)) .. "%!"
    end

end

function CrowdFavorite:get_brief_description()

    if self.ADDITIVE == 0 then
        return CrowdFavorite.NAME .. ": " .."More than 1 enemy -> damage +" .. tostring(DAMAGE_BUFF_ADDITIVE) .. ",\notherwise -> damage " .. tostring(DAMAGE_NERF_ADDITIVE) .. "!"
    else
        return CrowdFavorite.NAME .. ": " .."More than 1 enemy -> damage +" .. tostring(math.floor(DAMAGE_BUFF_MULTIPLICATIVE * 100)) .. "%,\notherwise -> damage " .. tostring(math.floor(DAMAGE_NERF_MULTIPLICATIVE * 100)) .. "%!"
    end
    
end

function CrowdFavorite.new()

    local new_CrowdFavorite = deepcopy(CrowdFavorite)

    new_CrowdFavorite.ADDITIVE = gauntlet_data.math.random_buff_activation(0, 1)

    new_CrowdFavorite.DESCRIPTION = new_CrowdFavorite:get_description(1)

    return deepcopy(new_CrowdFavorite)

end


return CrowdFavorite