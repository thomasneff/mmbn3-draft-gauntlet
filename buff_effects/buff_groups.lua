local HP_INCREASE = require "buff_effects.hp_increase"
local CANNON_DAMAGE_INCREASE = require "buff_effects.cannon_damage_increase"
local NERF_VIRUS_GROUP = require "buff_effects.nerf_virus_group"
local STYLE_CHANGE = require "buff_effects.style_change"
local SET_STAGE = require "buff_effects.set_stage"
local BUSTER_SPEEDPLUS = require "buff_effects.buster_speedplus"
local BUSTER_ATTACKPLUS = require "buff_effects.buster_attackplus"
local STYLE_WEAPONLEVELPLUS = require "buff_effects.style_weaponlevelplus"
local BUSTER_SPEEDPLUS = require "buff_effects.buster_speedplus"
local CUSTOMPLUS = require "buff_effects.customplus"
local SUPERARMOR = require "buff_effects.superarmor"
local UNDERSHIRT = require "buff_effects.undershirt"
local FASTGAUGE = require "buff_effects.fastgauge"
local AIRSHOES = require "buff_effects.airshoes"


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
    BUSTER_SPEEDPLUS,
    BUSTER_ATTACKPLUS,
    STYLE_WEAPONLEVELPLUS,
    BUSTER_SPEEDPLUS,
    CUSTOMPLUS,
    SUPERARMOR,
    UNDERSHIRT,
    FASTGAUGE,
    AIRSHOES
}

BUFF_GROUPS[2] = {
    HP_INCREASE,
    CANNON_DAMAGE_INCREASE,
    NERF_VIRUS_GROUP,
    STYLE_CHANGE,
    SET_STAGE,
    BUSTER_SPEEDPLUS,
    BUSTER_ATTACKPLUS,
    STYLE_WEAPONLEVELPLUS,
    BUSTER_SPEEDPLUS,
    CUSTOMPLUS,
    SUPERARMOR,
    UNDERSHIRT,
    FASTGAUGE,
    AIRSHOES
}

BUFF_GROUPS[3] = {
    HP_INCREASE,
    CANNON_DAMAGE_INCREASE,
    NERF_VIRUS_GROUP,
    STYLE_CHANGE,
    SET_STAGE,
    BUSTER_SPEEDPLUS,
    BUSTER_ATTACKPLUS,
    STYLE_WEAPONLEVELPLUS,
    BUSTER_SPEEDPLUS,
    CUSTOMPLUS,
    SUPERARMOR,
    UNDERSHIRT,
    FASTGAUGE,
    AIRSHOES
}

BUFF_GROUPS[3] = {
    HP_INCREASE,
    CANNON_DAMAGE_INCREASE,
    NERF_VIRUS_GROUP,
    STYLE_CHANGE,
    SET_STAGE,
    BUSTER_SPEEDPLUS,
    BUSTER_ATTACKPLUS,
    STYLE_WEAPONLEVELPLUS,
    BUSTER_SPEEDPLUS,
    CUSTOMPLUS,
    SUPERARMOR,
    UNDERSHIRT,
    FASTGAUGE,
    AIRSHOES
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
