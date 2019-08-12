local deepcopy = require "deepcopy"
local BASE_DIFFICULTY = require "difficulty_levels.base_difficulty"
local EASY_DIFFICULTY = require "difficulty_levels.easy_difficulty"
local HARD_DIFFICULTY = require "difficulty_levels.hard_difficulty"

-- TODO: Each difficulty should provide a NAME, a DESCRIPTION, and an activate() function.
--       This activate() function simply does everything necessary for the state_logic to advance.
local DIFFICULTY_LEVELS = {
    EASY_DIFFICULTY,
    BASE_DIFFICULTY,
    HARD_DIFFICULTY   
}




return DIFFICULTY_LEVELS