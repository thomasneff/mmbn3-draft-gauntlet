local INITIAL_STATE_NAME = {}

if GAME_ID == GAME_IDS.MMBN3_BLUE_US then
    INITIAL_STATE_NAME = "savestates/initial_mmbn3_blue_us.State"
elseif GAME_ID == GAME_IDS.MMBN6_FALZAR_US then
    error("Error (initial_state_name.lua): MMBN6_FALZAR_US not implemented yet: " .. tostring(GAME_ID))
else
    error("Error (initial_state_name.lua): unknown GAME_ID: " .. tostring(GAME_ID))
end

return INITIAL_STATE_NAME