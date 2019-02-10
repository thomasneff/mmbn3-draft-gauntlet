local ERROR_CHECKED_SPECIFIC_GAME_WRAPPER = require "error_checked_specific_game_wrapper"

-- NOTE: This *should* be generic, but might not be due to differences in MegaChip/GigaChip handling and/or library stars
return ERROR_CHECKED_SPECIFIC_GAME_WRAPPER.get_module("loadouts", GAME_ID, "draft_sm_lib_max_1")