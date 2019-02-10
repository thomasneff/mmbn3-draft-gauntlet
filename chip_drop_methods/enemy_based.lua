local ERROR_CHECKED_SPECIFIC_GAME_WRAPPER = require "error_checked_specific_game_wrapper"

-- TODO_REFACTOR: This *should* be generic, but is *not* due to MemeBomb.
return ERROR_CHECKED_SPECIFIC_GAME_WRAPPER.get_module("chip_drop_methods", GAME_ID, "completely_random")