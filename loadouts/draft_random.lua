local ERROR_CHECKED_SPECIFIC_GAME_WRAPPER = require "error_checked_specific_game_wrapper"

-- NOTE: This is already generic, so we use the same file for different games.
--       If different functionality is necessary, change the following import.
return ERROR_CHECKED_SPECIFIC_GAME_WRAPPER.get_module("loadouts", "mmbn3_blue_us", "draft_random")