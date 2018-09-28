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
local BUSTER_CHARGEPLUS = require "buff_effects.buster_chargeplus"
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
local REDISTRIBUTE = require "buff_effects.redistribute"
local COLLECTOR = require "buff_effects.collector"
local PROGRAMADVANCE = require "buff_effects.program_advance"
local COPYPASTE = require "buff_effects.copy_paste"
local TOPTIER = require "buff_effects.top_tier"
local LEVELUP = require "buff_effects.level_up"
local MEDIC = require "buff_effects.medic"
local SPIKEDARMOR = require "buff_effects.spiked_armor"
local FOLDERBAK = require "buff_effects.folderbak"
local ILLUSIONOFCHOICE = require "buff_effects.illusion_of_choice"
local REWIND = require "buff_effects.rewind"
local TIMECOMPRESSION = require "buff_effects.time_compression"
local CHIP_USE_BUFF = require "buff_effects.chip_use_buff_template"
local SPEEDRUNNER = require "buff_effects.speedrunner"
local REGCHIP = require "buff_effects.reg_chip"
local AGGRESSIVEHEALING = require "buff_effects.aggressive_healing"
local ELEMENTALIST = require "buff_effects.elementalist"
local COMBOSTACKER = require "buff_effects.combo_stacker"
local ELEMENTALOVERFLOW = require "buff_effects.elemental_overflow"
local DUPLICATOR = require "buff_effects.duplicator"
local MURAMASA = require "buff_effects.muramasa"
local MASAMUNE = require "buff_effects.masamune"
local OVERCUST = require "buff_effects.overcust"
local ANTICUST = require "buff_effects.anticust"
local DUELIST = require "buff_effects.duelist"
local CROWDFAVORITE = require "buff_effects.crowd_favorite"
local TIMEHUNTER = require "buff_effects.time_hunter"
local RISINGSTAR = require "buff_effects.rising_star"
local BACKSTAB = require "buff_effects.backstab"
local PENNIB = require "buff_effects.pen_nib"
local TACTICIAN = require "buff_effects.tactician"
local BOUNTY_YOLO = require "buff_effects.bounty_yolo"
local GAUNTLET = require "buff_effects.gauntlet"
local ALPHABETSOUP = require "buff_effects.alphabet_soup"
local BOUNTY_YUNOHEAL = require "buff_effects.bounty_y_u_no_heal"
local BOUNTY_PROGAMER = require "buff_effects.bounty_pro_gamer"
local BOUNTY_FRAMEPERFECT = require "buff_effects.bounty_frame_perfect"
local BOUNTY_EFFICIENCY = require "buff_effects.bounty_efficiency"

local BUFF_GROUPS_DATA = {}

local BUFF_GROUPS = {

}

BUFF_GROUPS[1] = {
    HP_INCREASE,
    NERF_VIRUS_GROUP,
    SET_STAGE,
    BUSTER_SPEEDPLUS,
    BUSTER_ATTACKPLUS,
    --STYLE_WEAPONLEVELPLUS,
    BUSTER_CHARGEPLUS,
    CUSTOMPLUS,
    SUPERARMOR,
    UNDERSHIRT,
    FASTGAUGE,
    AIRSHOES,
    MEGAPLUS,
    GIGAPLUS,
    BREAKBUSTER,
    BREAKCHARGE,
    FLOATSHOES,
    REFLECT,
    ELEMENT_CHIP_DAMAGE_INCREASE,
    SWORD_CHIP_DAMAGE_INCREASE,
    STANDARD_CHIP_DAMAGE_INCREASE,
    DROP_RARITY_INCREASE,
    --ELEMENT_CHIP_DAMAGE_INCREASE_HP_COST,
    --SWORD_CHIP_DAMAGE_INCREASE_HP_COST,
    SNECKO_EYE,
    PERFECTIONIST,
    REGENERATOR,
    MEMEBOMB,
    RNGESUS,
    PAWNMINATOR,
    SKILLNOTLUCK,
    SHOOTINGSTARS,
    REDISTRIBUTE,
    COLLECTOR,
    PROGRAMADVANCE,
    COPYPASTE,
    TOPTIER,
    LEVELUP,
    MEDIC,
    SPIKEDARMOR,
    FOLDERBAK,
    ILLUSIONOFCHOICE,
    REWIND,
    TIMECOMPRESSION,
    SPEEDRUNNER,
    REGCHIP,
    AGGRESSIVEHEALING,
    ELEMENTALIST,
    COMBOSTACKER,
    ELEMENTALOVERFLOW,
    DUPLICATOR,
    MURAMASA,
    MASAMUNE,
    OVERCUST,
    ANTICUST,
    DUELIST,
    CROWDFAVORITE,
    TIMEHUNTER,
    RISINGSTAR,
    BACKSTAB,
    PENNIB,
    TACTICIAN,
    BOUNTY_YOLO,
    GAUNTLET,
    ALPHABETSOUP,
    BOUNTY_YUNOHEAL,
    BOUNTY_PROGAMER,
    BOUNTY_FRAMEPERFECT,
    BOUNTY_EFFICIENCY
}


if GAUNTLET_DEFS.STYLE_CHANGE_AFTER_10_BATTLES == 0 then
    BUFF_GROUPS[1][#BUFF_GROUPS[1] + 1] = STYLE_CHANGE
else
    print("Removing Style-Change from Buff-Pool.")
end


-- Buff groups for testing.
--BUFF_GROUPS[1] = {
    --MURAMASA,
    --MASAMUNE,
    --OVERCUST,
    --TIMEHUNTER,
    --ANTICUST,
    --DUELIST,
--    BOUNTY_YUNOHEAL,
--    GAUNTLET,
--    BOUNTY_PROGAMER,
--    BOUNTY_FRAMEPERFECT,
--    BOUNTY_EFFICIENCY
--}

BUFF_GROUPS[2] = deepcopy(BUFF_GROUPS[1])
BUFF_GROUPS[3] = deepcopy(BUFF_GROUPS[1])
BUFF_GROUPS[4] = deepcopy(BUFF_GROUPS[1])
BUFF_GROUPS[4][#BUFF_GROUPS[4] + 1] = DARKLICENSE
BUFF_GROUPS[5] = deepcopy(BUFF_GROUPS[4])

BUFF_GROUPS_DATA.STYLE_CHANGE_BUFF = STYLE_CHANGE

BUFF_GROUPS_DATA.BUFF_GROUPS = {}


function BUFF_GROUPS_DATA.initialize()

    BUFF_GROUPS_DATA.BUFF_GROUPS = {}
    BUFF_GROUPS_DATA.BUFF_GROUPS = deepcopy(BUFF_GROUPS)

end

return BUFF_GROUPS_DATA