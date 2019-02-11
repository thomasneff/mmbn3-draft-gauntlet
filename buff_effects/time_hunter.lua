local ERROR_CHECKED_SPECIFIC_GAME_WRAPPER = require "error_checked_specific_game_wrapper"

-- NOTE: Should be generic, not sure how other games handle the cust gauge value.
return ERROR_CHECKED_SPECIFIC_GAME_WRAPPER.get_module("buff_effects", "mmbn3_blue_us", "time_hunter")