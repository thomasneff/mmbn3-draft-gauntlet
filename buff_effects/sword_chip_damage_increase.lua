local ERROR_CHECKED_SPECIFIC_GAME_WRAPPER = require "error_checked_specific_game_wrapper"

-- NOTE: Other games might simply have a "Sword"-element.
return ERROR_CHECKED_SPECIFIC_GAME_WRAPPER.get_module("buff_effects", GAME_ID, "sword_chip_damage_increase")