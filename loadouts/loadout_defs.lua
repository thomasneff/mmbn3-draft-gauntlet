local deepcopy = require "deepcopy"
local RANDOMIZED_1_STAR = require "loadouts.randomized_1_star"
local RANDOMIZED_2_STAR = require "loadouts.randomized_2_star"
local COMPLETELY_RANDOM = require "loadouts.completely_random"
local DRAFT_RANDOM = require "loadouts.draft_random"
local DRAFT_STANDARD_MEGA_GIGA = require "loadouts.draft_standard_mega_giga"
local DRAFT_STANDARD_MEGA_MAX_1 = require "loadouts.draft_sm_lib_max_1"
-- TODO: Each loadout should provide a NAME, a DESCRIPTION, and an activate() function.
--       This activate() function simply does everything necessary for the state_logic to advance.
local LIST_OF_LOADOUTS = {
    DRAFT_RANDOM,
    DRAFT_STANDARD_MEGA_MAX_1,
    COMPLETELY_RANDOM,
    RANDOMIZED_1_STAR,
    RANDOMIZED_2_STAR,   
}




return LIST_OF_LOADOUTS