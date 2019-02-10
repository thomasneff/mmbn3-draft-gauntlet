local ERROR_CHECKED_SPECIFIC_GAME_WRAPPER = require "error_checked_specific_game_wrapper"

-- NOTE: chip_defs is pretty generic (apart from lootbox drops), so we might just use the same one for all games?
--       Could also define lootbox in a generic thingy and use the same chip_defs for all.
return ERROR_CHECKED_SPECIFIC_GAME_WRAPPER.get_module("defs", GAME_ID, "chip_defs")