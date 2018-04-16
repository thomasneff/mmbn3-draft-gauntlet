local GENERIC_DEFS = require "defs.generic_defs"
local mmbn3_utils = require "mmbn3_utils"
local randomchoice = require "randomchoice"

local base_dir = "song_extractor/out/"
local song_name = "17"
local patch_ext = ".songpatch"
local offset_ext = ".offsets"
local transpose_range = 4
local bpm_shift_range = 10

local BattleMusicList = 
{
    "mmbn/0",       -- main theme
    "mmbn/8",       -- fire field
    "mmbn/9",       -- boundless network
    "mmbn/12",      -- elecrical crisis
    "mmbn/14",      -- battle theme
    "mmbn2/0",      -- main theme
    "mmbn2/12",     -- decision is inside of me
    "mmbn2/18",     -- smoky field
    "mmbn2/19",     -- time limit
    "mmbn2/23",     -- you can't go back
    "mmbn2/24",     -- internet world
    "mmbn2/27",     -- virus busting
    "mmbn3/0",      -- main theme
    "mmbn3/10",     -- n1 grand prix
    "mmbn3/19",     -- save a life
    "mmbn3/21",     -- final transmission
    "mmbn3/22",     -- network is spreading
    "mmbn3/23",     -- dangerous black
    "mmbn3/24",     -- shine in the dark
    "mmbn3/25",     -- shooting enemy
    "mmbn3/37",     -- navi customizer
    "mmbn4/0",      -- main theme
    "mmbn4/15",     -- invisible wing
    "mmbn4/17",     -- save our planet
    "mmbn4/18",     -- global network
    "mmbn4/20",     -- cyber battle
    "mmbn4_5/64",   -- life in the network
    "mmbn4_5/98",   -- battlefield
    "mmbn5/1",      -- main theme
    "mmbn5/18",     -- a total war
    "mmbn5/21",     -- battle start!
    "mmbn5/34",     -- liberate mission
    "mmbn6/1",      -- main theme
    "mmbn6/10",     -- break the storm
    "mmbn6/14",     -- hero!
    "mmbn6/16",     -- blast speed
    "mmbn6/19",     -- digital strider
    "mmbn6/21",     -- battle field
    "mmbn6/32",     -- two of braves
    "mmbcc/1",      -- main theme
    "mmbcc/12",     -- battle bgm 1
    "mmbcc/13",     -- battle bgm 2
} 

local BossMusicList = 
{
    "mmbn/15",      -- boss battle theme
    "mmbn/16",      -- vs. life virus
    "mmbn2/28",     -- battle spirit
    "mmbn2/29",     -- vs. gospel
    "mmbn3/26",     -- boss battle
    "mmbn3/27",     -- vs. alpha
    "mmbn3/28",     -- great battlers
    "mmbn4/21",     -- fighting oneself
    "mmbn4/22",     -- vs. duo
    "mmbn4/23",     -- battle pressure
    "mmbn4_5/89",   -- tournament battle
    "mmbn4_5/99",   -- the fighter's soul
    "mmbn5/22",     -- powerful enemy
    "mmbn5/23",     -- vs. nebula gray
    "mmbn6/22",     -- surge of power!
    "mmbn6/23",     -- decisive battle, cyber beasts!
    "mmbn6/34",     -- ??? (seriously, I didn't find this in the rockman.exe sound box)
    "mmbcc/14",     -- battle bgm 3

} 


local MusicLoader = 
{
    FinishedLoading = 0,
    StartedLoading = 0,
    BlockSize = 10000,
    transpose_offset = 1,
    bpm_offset = 3,
    transpose = 4,
    bpm_shift = 10,
    offset = 0,
    patch_str = nil
}

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



function MusicLoader.LoadRandomFile(current_round)

    if GENERIC_DEFS.ENABLE_MUSIC_PATCHING == 0 then
        MusicLoader.FinishedLoading = 1
        return
    end

    if MusicLoader.StartedLoading == 1 then
        return
    end


    print("Loading music for round " .. tostring(current_round))
    local chosen_file = ""
    if current_round % 5 == 0 then
        chosen_file = randomchoice(BossMusicList)
    else
        chosen_file = randomchoice(BattleMusicList)
    end

    MusicLoader.FinishedLoading = 0
    MusicLoader.offset = 0
    MusicLoader.patch_str = nil

    local patch_file_name = base_dir .. chosen_file .. patch_ext
    local offset_file_name = base_dir .. chosen_file .. offset_ext

    local patch_file = assert(io.open(patch_file_name, "rb"))
    local offset_file = assert(io.open(offset_file_name, "r"))
    MusicLoader.patch_str = patch_file:read("*all")
    print(#MusicLoader.patch_str)
    patch_file:close()

    local offset_file = assert(io.open(offset_file_name, "r"))

    offset_bytes = {}
    local offset_string = ""

    repeat
        local str = offset_file:read(20*1024)
        if str then
                offset_string = offset_string .. str
        end
    until not str

    offset_file:close()

    print(#offset_string) 

    offsets_split = mysplit(offset_string, '\n')
    offsets_split[#offsets_split + 1] = 2147483647

    print(offsets_split)

    MusicLoader.transpose = math.random(-transpose_range, transpose_range)
    MusicLoader.bpm_shift = math.random(-bpm_shift_range, bpm_shift_range)


    MusicLoader.transpose_offsets = {}
    MusicLoader.bpm_offsets = {}


    for k, offset_str in ipairs(offsets_split) do
        
        local offset = tonumber(offset_str)
        MusicLoader.transpose_offsets[offset + MusicLoader.transpose_offset] = 1

        if k == 1 then
            MusicLoader.bpm_offsets[offset + MusicLoader.bpm_offset] = 1
        end
    end

    MusicLoader.StartedLoading = 1
end


function MusicLoader.LoadBlock()

    if GENERIC_DEFS.ENABLE_MUSIC_PATCHING == 0 then
        MusicLoader.FinishedLoading = 1
        return
    end

    if MusicLoader.FinishedLoading == 1 then
        return
    end

    if MusicLoader.patch_str == nil then
        return
    end

    if MusicLoader.offset == 0 then
        print("Starting to load music!")

    end

    local info_interval = math.floor((#MusicLoader.patch_str / 25) + 0.5)
    local yield_interval = math.floor((#MusicLoader.patch_str / 1000) + 0.5)
    MusicLoader.BlockSize = yield_interval
    
    --print("Interval: " .. tostring(info_interval))
    
    for i = 1,MusicLoader.BlockSize do
    
        if MusicLoader.offset >= #MusicLoader.patch_str then
            print("Loading done!")
            MusicLoader.FinishedLoading = 1
            MusicLoader.StartedLoading = 0
            return 1
        end
    
        c = string.byte(MusicLoader.patch_str:sub(MusicLoader.offset + 1, MusicLoader.offset + 1))
    
        --print(c)
        --emu.yield()
    
        if MusicLoader.bpm_offsets[MusicLoader.offset] ~= nil then
            --print("BPM change " .. tostring(offset))
            --print(c)
            --print(c + bpm_shift)
            mmbn3_utils.writebyte(GENERIC_DEFS.MUSIC_PATCH_ADDRESS + MusicLoader.offset, c + MusicLoader.bpm_shift)
            --print("BPM changed. " .. tostring(offset))
        elseif MusicLoader.transpose_offsets[MusicLoader.offset] ~= nil then
            --print("Transpose change " .. tostring(offset))
            --print(c)
            --print(c + transpose)
            mmbn3_utils.writebyte(GENERIC_DEFS.MUSIC_PATCH_ADDRESS + MusicLoader.offset, c + MusicLoader.transpose)
            --print("Transpose changed. " .. tostring(offset))
        else
            mmbn3_utils.writebyte(GENERIC_DEFS.MUSIC_PATCH_ADDRESS + MusicLoader.offset, c)
        end
    
        --mmbn3_utils.writebyte(GENERIC_DEFS.MUSIC_PATCH_ADDRESS + offset, c)
    
        MusicLoader.offset = MusicLoader.offset + 1
    
    
        if (MusicLoader.offset + 1) % info_interval == 0 then
            print("Music loading " .. tostring(math.floor((MusicLoader.offset / (1.0 * #MusicLoader.patch_str) * 100.0) + 0.5)) .. "% done.")
        end

    end

    if MusicLoader.offset >= #MusicLoader.patch_str then
        print("Loading done!")
        MusicLoader.FinishedLoading = 1
        MusicLoader.StartedLoading = 0
        return 1
    end
    

end






return MusicLoader
