local ERROR_CHECKED_SPECIFIC_GAME_WRAPPER = require "error_checked_specific_game_wrapper"

-- Test code for loadouts
local difficulty_levels_modules = ERROR_CHECKED_SPECIFIC_GAME_WRAPPER.get_module("difficulty_levels", GAME_ID, "difficulty_levels_defs")

local test_difficulty_levels = false

if test_difficulty_levels then

    print("Testing difficulty levels (disable in difficulty_levels.difficulty_levels_defs), GAME_ID: " .. GAME_ID)
    local gauntlet_data = require "gauntlet_data"
    gauntlet_data.math.initialize_rng_for_group("MUSIC", 10000)
    gauntlet_data.math.initialize_rng_for_group("IN_BATTLE", 10000)
    gauntlet_data.math.initialize_rng_for_group("BUFF_ACTIVATION", 100000)
    gauntlet_data.math.initialize_rng_for_group("BUFF_SELECTION", 10000)
    gauntlet_data.math.initialize_rng_for_group("DRAFTING", 10000)
    gauntlet_data.math.initialize_rng_for_group("CHIP_REWARDS", 10000)
    gauntlet_data.math.initialize_rng_for_group("LOADOUTS", 10000)
    gauntlet_data.math.initialize_rng_for_group("SNECKO_EYE", 10000)
    gauntlet_data.math.initialize_rng_for_group("ILLUSION_OF_CHOICE", 10000)
    gauntlet_data.math.initialize_rng_for_group("BATTLE_DATA", 10000)
    gauntlet_data.math.initialize_rng_for_group("CHIP_GENERATION", 100000)
    gauntlet_data.math.initialize_rng_for_group("FOLDER_SHUFFLING", 10000)

    for key, value in pairs(difficulty_levels_modules) do
        print("Testing difficulty level " .. key .. ": " .. value.NAME)
        value.activate()
    end

end


return difficulty_levels_modules