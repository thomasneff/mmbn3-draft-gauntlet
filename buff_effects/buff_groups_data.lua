local deepcopy = require "deepcopy"
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


local BUFF_GROUPS_DATA = {}

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

BUFF_GROUPS[4] = {
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

BUFF_GROUPS_DATA.BUFF_GROUPS = {}


function BUFF_GROUPS_DATA.initialize()

    BUFF_GROUPS_DATA.BUFF_GROUPS = {}
    BUFF_GROUPS_DATA.BUFF_GROUPS = deepcopy(BUFF_GROUPS)

end

return BUFF_GROUPS_DATA