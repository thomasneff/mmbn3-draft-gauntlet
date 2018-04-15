local state_logic = require "state_logic"
local GENERIC_DEFS = require "defs.generic_defs"
local mmbn3_utils = require "mmbn3_utils"

local base_dir = "song_extractor/out/ff5/"
local song_name = "8"
local patch_ext = ".songpatch"
local offset_ext = ".offsets"

local transpose_offset = 1
local bpm_offset = 3

local transpose = 1
local bpm_shift = 0

local patch_file_name = base_dir .. song_name .. patch_ext
local offset_file_name = base_dir .. song_name .. offset_ext

print(patch_file_name)
print(offset_file_name)

local patch_file = assert(io.open(patch_file_name, "rb"))
local offset_file = assert(io.open(offset_file_name, "r"))

local block = 1


local patch_bytes = {}
repeat
   local str = patch_file:read(20*1024)
   for c in (str or ''):gmatch'.' do
      patch_bytes[#patch_bytes+1] = c:byte()
   end
until not str
patch_file:close()
print(#patch_bytes) 


local offset_bytes = {}
local offset_string = ""
repeat
   local str = offset_file:read(20*1024)
   if str then
        offset_string = offset_string .. str
   end
   --for c in (str or ''):gmatch'.' do
   -- offset_bytes[#offset_bytes+1] = c:byte()
   --end
until not str
offset_file:close()
print(#offset_string) 

print("HEYS a")


function mysplit(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            t[i] = str
            i = i + 1
    end
    return t
end

offsets_split = mysplit(offset_string, '\n')

print(offsets_split)

--offset_file:close()
print("HEYS")

for k, offset_str in ipairs(offsets_split) do
    
    local offset = tonumber(offset_str)
    patch_bytes[offset + transpose_offset + 1] = patch_bytes[offset + transpose_offset + 1] + transpose

    if k == 1 then
        patch_bytes[offset + bpm_offset + 1] = patch_bytes[offset + bpm_offset + 1] + bpm_shift
    end


end



for i=1,#patch_bytes do

    local byte = tonumber(patch_bytes[i])

    --if not byte then break end

   -- print(byte)
    mmbn3_utils.writebyte(GENERIC_DEFS.MUSIC_PATCH_ADDRESS + (i - 1), byte)

end



