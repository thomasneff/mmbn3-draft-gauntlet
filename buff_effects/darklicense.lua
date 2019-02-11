local ERROR_CHECKED_SPECIFIC_GAME_WRAPPER = require "error_checked_specific_game_wrapper"

-- NOTE: This buff doesn't even exist for other games. This will crash if you import it in buff_groups_data of other games.
return ERROR_CHECKED_SPECIFIC_GAME_WRAPPER.get_module("buff_effects", GAME_ID, "darklicense")