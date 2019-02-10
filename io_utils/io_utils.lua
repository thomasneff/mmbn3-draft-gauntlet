local IO_UTILS = {}

if GAME_ID == GAME_IDS.MMBN3_BLUE_US then
    IO_UTILS = require "io_utils.mmbn3_blue_us.io_utils"
elseif GAME_ID == GAME_IDS.MMBN6_FALZAR_US then
    error("Error (io_utils.lua): MMBN6_FALZAR_US not implemented yet: " .. tostring(GAME_ID))
else
    error("Error (io_utils.lua): unknown GAME_ID: " .. tostring(GAME_ID))
end

return IO_UTILS