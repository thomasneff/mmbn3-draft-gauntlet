local ERROR_CHECKED_SPECIFIC_GAME_WRAPPER = require "error_checked_specific_game_wrapper"

-- NOTE: No idea if there is a FastGauge in other games - the logic is generic, however.
return ERROR_CHECKED_SPECIFIC_GAME_WRAPPER.get_module("buff_effects", "mmbn3_blue_us", "fastgauge")