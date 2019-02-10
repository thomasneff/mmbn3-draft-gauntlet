local ERROR_CHECKED_SPECIFIC_GAME_WRAPPER = require "error_checked_specific_game_wrapper"

-- NOTE: This is already generic, so we use the same file for different games.
--       If different functionality is necessary, change the following import.

local drop_method_module = ERROR_CHECKED_SPECIFIC_GAME_WRAPPER.get_module("chip_drop_methods", "mmbn3_blue_us", "chip_drop_method_defs")


local test_drop_methods = false

if test_drop_methods then

    print("Testing Chip Drop Methods (disable in chip_drop_methods.chip_drop_method_defs), GAME_ID: " .. GAME_ID)
    local gauntlet_data = require "gauntlet_data"
    local battle_data_generator = require "defs.battle_data_generator"
    local GAUNTLET_DEFS = require "defs.gauntlet_defs"
    local BATTLE_STAGE = require "defs.battle_stage_defs"
    local CHIP_NAME = require "defs.chip_name_defs"
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

    for key, value in pairs(drop_method_module) do
        print("Testing chip drop method " .. key .. ": " .. value.NAME)
        value.activate()

        for current_battle = 1, GAUNTLET_DEFS.MAX_NUMBER_OF_BATTLES do
            print("Battle: " .. tostring(current_battle))
            local battle_data = battle_data_generator.random_from_battle(current_battle, specific_entity, BATTLE_STAGE.random())
            local number_of_drops = GAUNTLET_DEFS.NUMBER_OF_DROPPED_CHIPS
            local drops = value.generate_drops(battle_data, math.floor(current_battle / GAUNTLET_DEFS.BATTLES_PER_ROUND), number_of_drops)
            print("Drops: ")

            for key, value in pairs(drops) do
                print("NAME: " .. CHIP_NAME[value.ID])
                print(value)
            end

        end

    end

end

return drop_method_module