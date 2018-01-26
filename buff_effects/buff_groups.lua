local HP_INCREASE = require "buff_effects.hp_increase"
local CANNON_DAMAGE_INCREASE = require "buff_effects.cannon_damage_increase"
local NERF_VIRUS_GROUP = require "buff_effects.nerf_virus_group"
local STYLE_CHANGE = require "buff_effects.style_change"
local SET_STAGE = require "buff_effects.set_stage"
local deepcopy = require "deepcopy"
local randomchoice = require "randomchoice"
-- Similar to entity groups, we define which buffs can appear randomly.
-- TODO: possibly add specific probabilities?
local BUFF_GROUPS = {

}

BUFF_GROUPS[1] = {
    HP_INCREASE,
    CANNON_DAMAGE_INCREASE,
    NERF_VIRUS_GROUP,
    STYLE_CHANGE,
    SET_STAGE,
}

BUFF_GROUPS[2] = {
    HP_INCREASE,
    CANNON_DAMAGE_INCREASE,
    NERF_VIRUS_GROUP,
    STYLE_CHANGE,
    SET_STAGE,
}

BUFF_GROUPS[3] = {
    HP_INCREASE,
    CANNON_DAMAGE_INCREASE,
    NERF_VIRUS_GROUP,
    STYLE_CHANGE,
    SET_STAGE,
}

BUFF_GROUPS[3] = {
    HP_INCREASE,
    CANNON_DAMAGE_INCREASE,
    NERF_VIRUS_GROUP,
    STYLE_CHANGE,
    SET_STAGE,
}


local buff_generator = {}

function buff_generator.random_buffs_from_round(current_round, number_of_buffs)

    local buffs = {}
    local buff_group = BUFF_GROUPS[current_round]
    --print("BUFFS: ", number_of_buffs)
    --print("BUFF GROUP: ", buff_group)
    for i = 1,number_of_buffs do

        buffs[i] = buff_group[math.random(#buff_group)].new()
        --print("BUFFS[i]", buffs[i])
    end

    return buffs
end

return buff_generator
