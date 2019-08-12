local CHIP_DATA = require "defs.chip_data_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local GAUNTLET_DEFS = require "defs.gauntlet_defs"
local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP = require "defs.chip_defs"
local io_utils = require "io_utils.io_utils"
local HARD_DIFFICULTY = {}


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


function HARD_DIFFICULTY.activate()

    GAUNTLET_DEFS.INITIAL_MEGA_CHIP_LIMIT = 5
    gauntlet_data.mega_chip_limit = 5
    GAUNTLET_DEFS.ROUNDS_PER_BUFF_DROP = 5
    --GAUNTLET_DEFS.HP_INCREASE_PER_ROUND[1] = 0
    gauntlet_data.mega_max_hp = 100
    gauntlet_data.last_known_current_hp = gauntlet_data.mega_max_hp
    gauntlet_data.current_hp = gauntlet_data.mega_max_hp
    
    --io_utils.writeword(GENERIC_DEFS.MEGA_MAX_HP_ADDRESS_DURING_LOADING, gauntlet_data.mega_max_hp)
    --gauntlet_data.current_hp = gauntlet_data.mega_max_hp
    --io_utils.writeword(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_LOADING, gauntlet_data.current_hp)

    print("Changed mega max hp to 100")

    GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE = 88
    GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE = 95
    GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE = 98
    GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE = 100
   
    print("Hard Difficulty activated.")

end


HARD_DIFFICULTY.NAME = "Hard Difficulty"
HARD_DIFFICULTY.DESCRIPTION = "Buff every 5 battles, 100 starting HP\nworse chip rarity."


return HARD_DIFFICULTY

