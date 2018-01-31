local deepcopy = require "deepcopy"

local COMPLETELY_RANDOM = require "chip_drop_methods.completely_random"
local ROUND_BASED_LIBRARY_STARS = require "chip_drop_methods.round_based_library_stars"
local ENEMY_BASED = require "chip_drop_methods.enemy_based"

local LIST_OF_CHIP_DROP_METHODS = {
    ROUND_BASED_LIBRARY_STARS,
    ENEMY_BASED,
    COMPLETELY_RANDOM
}




return LIST_OF_CHIP_DROP_METHODS