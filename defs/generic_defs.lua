local ERROR_CHECKED_SPECIFIC_GAME_WRAPPER = require "error_checked_specific_game_wrapper"

-- These are used to define address/value functions that are not implemented yet.
-- For example: Patching of HP might not be supported yet, this will then just print an error but continue.
GENERIC_DEFS_UNDEFINED_ADDRESS = "definitely not an address"
GENERIC_DEFS_UNDEFINED_VALUE = "definitely not a value"

return ERROR_CHECKED_SPECIFIC_GAME_WRAPPER.get_module("defs", GAME_ID, "generic_defs")

