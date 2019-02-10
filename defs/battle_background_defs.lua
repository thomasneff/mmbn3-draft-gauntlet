local BACKGROUND_TYPE = {}

if GAME_ID == GAME_IDS.MMBN3_BLUE_US then
    BACKGROUND_TYPE = require "defs.mmbn3_blue_us.battle_background_defs"
elseif GAME_ID == GAME_IDS.MMBN6_FALZAR_US then
    error("Error (battle_background_defs.lua): MMBN6_FALZAR_US not implemented yet: " .. tostring(GAME_ID))
else
    error("Error (battle_background_defs.lua): unknown GAME_ID: " .. tostring(GAME_ID))
end

return BACKGROUND_TYPE