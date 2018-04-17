local state_logic = require "state_logic"
local GENERIC_DEFS = require "defs.generic_defs"
local mmbn3_utils = require "mmbn3_utils"

local base_dir = "song_extractor/out/mmbn3/"
local song_name = "7"
local patch_ext = ".songpatch"
local offset_ext = ".offsets"

local transpose_offset = 1
local bpm_offset = 3

local transpose = 0
local bpm_shift = 0

local patch_file_name = base_dir .. song_name .. patch_ext
local offset_file_name = base_dir .. song_name .. offset_ext

print(patch_file_name)
print(offset_file_name)



local patch_file = assert(io.open(patch_file_name, "rb"))
local offset_file = assert(io.open(offset_file_name, "r"))

local block = 1
print("before")
local patch_str = patch_file:read("*all")
print(#patch_str)


print("after")



--local patch_bytes = {}
--repeat
--   local str = patch_file:read(20*1024)
--   for c in (str or ''):gmatch'.' do
--      patch_bytes[#patch_bytes+1] = c:byte()
--   end
--until not str
patch_file:close()
print(#patch_str) 


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
offsets_split[#offsets_split + 1] = 2147483647

print(offsets_split)

--offset_file:close()
print("HEYS")

local transpose_offsets = {}
local bpm_offsets = {}


for k, offset_str in ipairs(offsets_split) do
    
    local offset = tonumber(offset_str)
    transpose_offsets[offset + transpose_offset] = 1

    if k == 1 then
        bpm_offsets[offset + bpm_offset] = 1
    end
end


--end
--local offset = 0
--patch_str:gsub(".", function(c)
    -- do something with c
    
--   if bpm_offsets[offset] ~= nil then
--        mmbn3_utils.writebyte(GENERIC_DEFS.MUSIC_PATCH_ADDRESS + offset, string.byte(c) + bpm_shift)
--    elseif bpm_offsets[offset] ~= nil then
--        mmbn3_utils.writebyte(GENERIC_DEFS.MUSIC_PATCH_ADDRESS + offset, string.byte(c) + transpose)
--    else
--        mmbn3_utils.writebyte(GENERIC_DEFS.MUSIC_PATCH_ADDRESS + offset, string.byte(c))
--    end
   

--    offset = offset + 1
--end)

--for i=1,#patch_bytes do

--    local byte = tonumber(patch_bytes[i])

    --if not byte then break end

   -- print(byte)
--    mmbn3_utils.writebyte(GENERIC_DEFS.MUSIC_PATCH_ADDRESS + (i - 1), byte)

--end

print(transpose_offsets)
print(bpm_offsets)

local offset = 0

print("Starting to load music!")

local info_interval = math.floor((#patch_str / 25) + 0.5)
local yield_interval =#patch_str-- math.floor((#patch_str / 1000) + 0.5)

print("Interval: " .. tostring(info_interval))

for i = 1,(#patch_str+1) do

    if offset >= #patch_str then
        --print("DONE!")
        break
    end

    c = string.byte(patch_str:sub(offset + 1, offset + 1))

    --print(c)
    --emu.yield()

    --if bpm_offsets[offset] ~= nil then
        --print("BPM change " .. tostring(offset))
        --print(c)
        --print(c + bpm_shift)
        --mmbn3_utils.writebyte(GENERIC_DEFS.MUSIC_PATCH_ADDRESS + offset, c + bpm_shift)
        --print("BPM changed. " .. tostring(offset))
    --elseif transpose_offsets[offset] ~= nil then
        --print("Transpose change " .. tostring(offset))
        --print(c)
        --print(c + transpose)
        --mmbn3_utils.writebyte(GENERIC_DEFS.MUSIC_PATCH_ADDRESS + offset, c + transpose)
        --print("Transpose changed. " .. tostring(offset))
    --else
        mmbn3_utils.writebyte(GENERIC_DEFS.MUSIC_PATCH_ADDRESS + offset, c)
    --end

    --mmbn3_utils.writebyte(GENERIC_DEFS.MUSIC_PATCH_ADDRESS + offset, c)

    offset = offset + 1


    if (offset + 1) % info_interval == 0 then
        print("Music loading " .. tostring(math.floor((offset / (1.0 * #patch_str) * 100.0) + 0.5)) .. "% done.")
    end

    if (offset + 1) % yield_interval == 0 then
        emu.yield()
    end

end



while 1 do

    --if offset >= #patch_str then

    --else
    --    for i = 1,iters_per_run do

    --        if offset >= #patch_str then
    --            print("DONE!")
    --            break
    --        end

    --        c = string.byte(patch_str:sub(offset + 1, offset + 1))

    --        if bpm_offsets[offset] ~= nil then
    --            print("BPM change" .. tostring(offset))
    --            print(c)
    --            print(c + bpm_shift)
    --            mmbn3_utils.writebyte(GENERIC_DEFS.MUSIC_PATCH_ADDRESS + offset, c + bpm_shift)
    --            print("BPM changed." .. tostring(offset))
    --        elseif transpose_offsets[offset] ~= nil then
    --            print("Transpose change" .. tostring(offset))
    --            print(c)
    --            print(c + transpose)
    --            mmbn3_utils.writebyte(GENERIC_DEFS.MUSIC_PATCH_ADDRESS + offset, c + transpose)
    --            print("Transpose changed. " .. tostring(offset))
    --        else
    --            mmbn3_utils.writebyte(GENERIC_DEFS.MUSIC_PATCH_ADDRESS + offset, c)
    --        end
        
    
    --        offset = offset + 1
    --    end

    --    if offset % (100 * iters_per_run) == 0 then
    --        print("Music loading " .. tostring((offset / (1.0 * #patch_str)) * 100.0) .. "% done.")
    --    end
    --end
    

    emu.yield()

    
end



