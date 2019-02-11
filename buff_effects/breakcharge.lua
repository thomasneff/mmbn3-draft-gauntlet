local ERROR_CHECKED_SPECIFIC_GAME_WRAPPER = require "error_checked_specific_game_wrapper"

-- NOTE: This could be generic, but I don't think "BreakBuster" exists outside mmbn3?
return ERROR_CHECKED_SPECIFIC_GAME_WRAPPER.get_module("buff_effects", GAME_ID, "breakcharge")