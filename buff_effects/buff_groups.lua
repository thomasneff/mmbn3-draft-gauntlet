local ERROR_CHECKED_SPECIFIC_GAME_WRAPPER = require "error_checked_specific_game_wrapper"

-- This imports the main list of available buffs.
-- This is *required* to be defined and contain at least 3 buffs.
return ERROR_CHECKED_SPECIFIC_GAME_WRAPPER.get_module("buff_effects", GAME_ID, "buff_groups")