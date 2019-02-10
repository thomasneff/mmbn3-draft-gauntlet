local ERROR_CHECKED_SPECIFIC_GAME_WRAPPER = require "error_checked_specific_game_wrapper"

-- NOTE: This pointer entry thing (where background / stage / ...) are stored separately might be different for other games
return ERROR_CHECKED_SPECIFIC_GAME_WRAPPER.get_module("defs", GAME_ID, "pointer_entry_generator")