local deepcopy = require "deepcopy"
local GAUNTLET_DEFS = require "defs.gauntlet_defs"


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
local MEGAPLUS = require "buff_effects.megachipplus"
local GIGAPLUS = require "buff_effects.gigachipplus"
local BREAKBUSTER = require "buff_effects.breakbuster"
local BREAKCHARGE = require "buff_effects.breakcharge"
local DARKLICENSE = require "buff_effects.darklicense"
local FLOATSHOES = require "buff_effects.floatshoes"
local REFLECT = require "buff_effects.reflect"
local ELEMENT_CHIP_DAMAGE_INCREASE = require "buff_effects.element_chip_damage_increase"
local SWORD_CHIP_DAMAGE_INCREASE = require "buff_effects.sword_chip_damage_increase"
local STANDARD_CHIP_DAMAGE_INCREASE = require "buff_effects.standard_chip_damage_increase"
local DROP_RARITY_INCREASE = require "buff_effects.drop_rarity_increase"
local ELEMENT_CHIP_DAMAGE_INCREASE_HP_COST = require "buff_effects.element_chip_damage_increase_hp_cost"
local SWORD_CHIP_DAMAGE_INCREASE_HP_COST = require "buff_effects.sword_chip_damage_increase_hp_cost"
local SNECKO_EYE = require "buff_effects.snecko_eye"
local PERFECTIONIST = require "buff_effects.perfectionist"
local REGENERATOR = require "buff_effects.regenerator"
local MEMEBOMB    = require "buff_effects.memebomb"
local RNGESUS = require "buff_effects.rngesus"
local PAWNMINATOR = require "buff_effects.pawnminator"
local SKILLNOTLUCK = require "buff_effects.skill_not_luck"
local SHOOTINGSTARS = require "buff_effects.shooting_stars"

local BUFF_GROUPS_DATA = {}

local BUFF_GROUPS = {

}

BUFF_GROUPS[1] = {
    HP_INCREASE,
    SET_STAGE,
    BUSTER_SPEEDPLUS,
    BUSTER_ATTACKPLUS,
    STYLE_WEAPONLEVELPLUS,
    BUSTER_SPEEDPLUS,
    CUSTOMPLUS,
    SUPERARMOR,
    UNDERSHIRT,
    FASTGAUGE,
    AIRSHOES,
    MEGAPLUS,
    GIGAPLUS,
    BREAKBUSTER,
    BREAKCHARGE,
    DARKLICENSE,
    FLOATSHOES,
    REFLECT,
    ELEMENT_CHIP_DAMAGE_INCREASE,
    NERF_VIRUS_GROUP,
    SWORD_CHIP_DAMAGE_INCREASE,
    STANDARD_CHIP_DAMAGE_INCREASE,
    DROP_RARITY_INCREASE,
    ELEMENT_CHIP_DAMAGE_INCREASE_HP_COST,
    SWORD_CHIP_DAMAGE_INCREASE_HP_COST,
    SNECKO_EYE,
    PERFECTIONIST,
    REGENERATOR,
    MEMEBOMB,
    PAWNMINATOR,
    RNGESUS,
    SKILLNOTLUCK,
    SHOOTINGSTARS
}


if GAUNTLET_DEFS.STYLE_CHANGE_AFTER_10_BATTLES == 0 then
    BUFF_GROUPS[1][#BUFF_GROUPS + 1] = STYLE_CHANGE
else
    print("Removing Style-Change from Buff-Pool.")
end



--BUFF_GROUPS[1] = {
--    MEMEBOMB,
--    MEMEBOMB,
--    SHOOTINGSTARS,
--    SHOOTINGSTARS,
--}

BUFF_GROUPS[2] = deepcopy(BUFF_GROUPS[1])
BUFF_GROUPS[3] = deepcopy(BUFF_GROUPS[1])
BUFF_GROUPS[4] = deepcopy(BUFF_GROUPS[1])
BUFF_GROUPS[5] = deepcopy(BUFF_GROUPS[1])

BUFF_GROUPS_DATA.STYLE_CHANGE_BUFF = STYLE_CHANGE

BUFF_GROUPS_DATA.BUFF_GROUPS = {}


function BUFF_GROUPS_DATA.initialize()

    BUFF_GROUPS_DATA.BUFF_GROUPS = {}
    BUFF_GROUPS_DATA.BUFF_GROUPS = deepcopy(BUFF_GROUPS)

end

return BUFF_GROUPS_DATA