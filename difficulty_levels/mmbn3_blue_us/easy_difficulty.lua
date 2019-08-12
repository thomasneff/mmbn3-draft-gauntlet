local CHIP_DATA = require "defs.chip_data_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local GAUNTLET_DEFS = require "defs.gauntlet_defs"
local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP = require "defs.chip_defs"
local EASY_DIFFICULTY = {}
local io_utils = require "io_utils.io_utils"


--local GAUNTLET_DEFS = {

    --BATTLES_PER_ROUND = 10,
    --MAX_NUMBER_OF_BATTLES = 50,
    --MIN_NUMBER_OF_VIRUSES = 3,
    --NUMBER_OF_VIRUSES_OVERRIDE = {},
    --NON_VIRUS_ENTITY_CHANCE = 4, -- 4 % Chance of non-virus (e.g. RockCube) entities spawning.
    --BOSS_NON_VIRUS_ENTITY_CHANCE = 30, -- 30 % chance of non-virus, rolled 3 times
    --HP_INCREASE_PER_ROUND = {50, 150, 250, 350, 100},
    --NUMBER_OF_DROPPED_BUFFS = 3,
    --NUMBER_OF_DROPPED_CHIPS = 3,
    --ROUNDS_PER_BUFF_DROP = 5,
    --NUMBER_OF_DRAFT_CHIPS = 3,
    --PAUSE_BUFFER_HP_PENALTY = {HP_DECREASE = 1, FRAME_INTERVAL = 2},
    --DROP_COMMON_CUMULATIVE_CHANCE = 70,
    --DROP_RARE_CUMULATIVE_CHANCE = 90,
    --DROP_SUPER_RARE_CUMULATIVE_CHANCE = 97,
    --DROP_ULTRA_RARE_CUMULATIVE_CHANCE = 100,
    --DROP_DARK_CHIP_CHANCE = 5, -- 0.5 Percent.
    --INITIAL_MEGA_CHIP_LIMIT = 5,
    --INITIAL_GIGA_CHIP_LIMIT = 1,
    --MAX_NUMBER_OF_ROUNDS = 5,
    --SNECKO_RANDOMIZE_ASTERISK = 1,
    --STYLE_CHANGE_AFTER_10_BATTLES = 1,
    --BOSS_BATTLE_INTERVAL = 5,
    --SKILL_NOT_LUCK_RARITY_INCREASE = 5,
    --SKILL_NOT_LUCK_RARITY_DISTRIBUTION = {1.0, 0.5, 0.3} -- these are computed so that the rarity is distributed equally on all rarities
--}


function EASY_DIFFICULTY.activate()

    GAUNTLET_DEFS.ROUNDS_PER_BUFF_DROP = 4
    --GAUNTLET_DEFS.HP_INCREASE_PER_ROUND[1] = 150

    gauntlet_data.mega_max_hp = 250
    gauntlet_data.last_known_current_hp = gauntlet_data.mega_max_hp
    gauntlet_data.current_hp = gauntlet_data.mega_max_hp
    

    GAUNTLET_DEFS.INITIAL_MEGA_CHIP_LIMIT = 7
    gauntlet_data.mega_chip_limit = 7
    GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE = 65
    GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE = 85
    GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE = 94
    GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE = 100
    

   
    print("Easy Difficulty activated.")

end


EASY_DIFFICULTY.NAME = "Easy Difficulty"
EASY_DIFFICULTY.DESCRIPTION = "Buff every 4 battles, 250 starting HP\n7 MegaChip limit."


return EASY_DIFFICULTY

