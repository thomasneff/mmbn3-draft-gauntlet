local ERROR_CHECKED_SPECIFIC_GAME_WRAPPER = require "error_checked_specific_game_wrapper"

local bizhawk_io_wrapper = require "io_utils.bizhawk_io_wrapper"

local io_utils = ERROR_CHECKED_SPECIFIC_GAME_WRAPPER.get_module("io_utils", GAME_ID, "io_utils")

-- This mapping is simply done so everything just has to include io_utils.
io_utils.writebyte = bizhawk_io_wrapper.writebyte
io_utils.writeword = bizhawk_io_wrapper.writeword
io_utils.writedword = bizhawk_io_wrapper.writedword
io_utils.readbyte = bizhawk_io_wrapper.readbyte
io_utils.readword = bizhawk_io_wrapper.readword

return io_utils