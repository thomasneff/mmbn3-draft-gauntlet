local ERROR_CHECKED_SPECIFIC_GAME_WRAPPER = require "error_checked_specific_game_wrapper"

-- NOTE: FullCust doesn't exist. Could otherwise be generic.
return ERROR_CHECKED_SPECIFIC_GAME_WRAPPER.get_module("buff_effects", GAME_ID, "speedrunner")