local ERROR_CHECKED_SPECIFIC_GAME_WRAPPER = require "error_checked_specific_game_wrapper"

-- NOTE: This is already generic, so we use the same file for different games.
--       If different functionality is necessary, change the following import.

-- TODO_REFACTOR: implement tests here that test all buff functions (similar to the chip drop method tests).

return ERROR_CHECKED_SPECIFIC_GAME_WRAPPER.get_module("buff_effects", "mmbn3_blue_us", "buff_groups_data")