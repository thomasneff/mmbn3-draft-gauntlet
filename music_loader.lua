local GENERIC_DEFS = require "defs.generic_defs"
local io_utils = require "io_utils.io_utils"
local randomchoice = require "randomchoice"
local gauntlet_data = require "gauntlet_data"

local base_dir = "song_extractor_cs/out/"
local patch_ext = ".songpatch"
local transpose_offset_ext = ".transposeoffsets"
local bpm_offset_ext = ".bpmoffsets"
local transpose_range = 8
local bpm_shift_range = 20
local use_fixed_music = 0
GENERIC_DEFS.ENABLE_MUSIC_PATCHING = 1

--function file_exists(name)

    --print(io.popen"cd":read'*l')

--    print("Trying to open file: " .. name)

--    local f=io.open(name,"r")
--    if f~=nil then io.close(f) return true else return false end
--end

function try_open_file(path, mode)

    local file = io.open(path, mode)

    print("Trying to open file: " .. path)

    if file == nil then
        file = io.open("Lua/mmbn3_draft_gauntlet/" .. path, mode)
    end

    if file == nil then
        file = io.open("Lua/mmbn3-draft-gauntlet-master/" .. path, mode)
    end

    if file == nil then
        file = io.open("Lua/mmbn3_draft_gauntlet/" .. path, mode)
    end



    if file == nil then
        file = io.open("../lua/" .. path, mode)
    end

    if file == nil then
        file = io.open("../bizhawk/" .. path, mode)
    end

    if file == nil then
        file = io.open("../mmbn3_draft_gauntlet/" .. path, mode)
    end

    if file == nil then
        file = io.open("../mmbn3-draft-gauntlet-master/" .. path, mode)
    end


    if file == nil then
        print("Could not read input file " .. path .. "!")
        return nil
    end

    return file
end


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
    --"mmbcc/1",      -- main theme
    --"mmbcc/12",     -- battle bgm 1
    --"mmbcc/13",     -- battle bgm 2
    "mm_and_bass/0",  -- opening stage
    --"mm_and_bass/1",  -- stage start
    --"mm_and_bass/2",  -- stage select
    --"mm_and_bass/3",  -- player select
    --"mm_and_bass/4",  -- data select
    --"mm_and_bass/5",  -- title
    "mm_and_bass/6",  -- dynamo man stage
    "mm_and_bass/7",  -- cold man stage
    "mm_and_bass/8",  -- ground man stage
    "mm_and_bass/9",  -- tengu man stage
    "mm_and_bass/10", -- astro man stage
    --"mm_and_bass/11", -- pirate man stage -> this glitches out in the second part, not sure why
    "mm_and_bass/12", -- burner man stage
    "mm_and_bass/13", -- magic man stage
    "mm_and_bass/16", -- crystal gate stage
    --"mm_and_bass/18", -- get a weapon
    --"mm_and_bass/19", -- stage clear
    --"mm_and_bass/20", -- king castle
    "mm_and_bass/21", -- shop
    "mm_and_bass/22", -- data base
    --"mm_and_bass/23", -- game over
    --"mm_and_bass/24", -- ending
} 


local FixedMusicList = 
{
    "mmbn3/25",
    "mmbn3/25",
    "mmbn3/25",
    "mmbn3/25",
    "mmbn3/26",
    "mmbn2/27",
    "mmbn4/21",
    "mmbn4/17",
    "mmbn4/17",
    "poke_emerald/511",
}

local FixedMusicTransposeRange = 
{
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    5,
    0,
}

local FixedMusicBPMRange = 
{
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    30,
    0,

}

---local BattleMusicList = 
--{
  --  "poke_emerald/299",       -- cool battle theme (Battle 6)

--}

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
    "mm_and_bass/14", -- king stage
    "mm_and_bass/15", -- wily stage
    "mm_and_bass/17", -- king/wily battle
    "mm_and_bass/25", -- boss battle
    --"mmbcc/14",     -- battle bgm 3

} 


local MusicLoader = 
{
    FinishedLoading = 0,
    StartedLoading = 0,
    BlockSize = 8000,
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


    
    local chosen_file = ""
    if current_round % 5 == 0 then
        chosen_file = BossMusicList[gauntlet_data.math.random_music(1, #BossMusicList)]--randomchoice(BossMusicList)
    else
        chosen_file = BattleMusicList[gauntlet_data.math.random_music(1, #BattleMusicList)]--randomchoice(BattleMusicList)
    end
    
    if use_fixed_music == 1 then
        if FixedMusicList[current_round] ~= nil then
            chosen_file = FixedMusicList[current_round]
            transpose_range = FixedMusicTransposeRange[current_round]
            bpm_shift_range = FixedMusicBPMRange[current_round]
        else
            transpose_range = 8
            bpm_shift_range = 20
        end
    end

    print("Loading music for round " .. tostring(current_round) .. ": " .. chosen_file)

    MusicLoader.FinishedLoading = 0
    MusicLoader.offset = 0
    MusicLoader.patch_str = nil

    local patch_file_name = base_dir .. chosen_file .. patch_ext
    local transpose_offset_file_name = base_dir .. chosen_file .. transpose_offset_ext
    local bpm_offset_file_name = base_dir .. chosen_file .. bpm_offset_ext

    local patch_file = try_open_file(patch_file_name, "rb")
    local transpose_offset_file = try_open_file(transpose_offset_file_name, "r")
    local bpm_offset_file = try_open_file(bpm_offset_file_name, "r")

    if patch_file == nil or 
        transpose_offset_file == nil or
        bpm_offset_file == nil or
        GLOBAL_DISABLE_MUSIC_PATCHING == true then

        print ("Turning off Music Loader, file: " .. chosen_file .. " could not be opened!")

        GENERIC_DEFS.ENABLE_MUSIC_PATCHING = 0
        MusicLoader.FinishedLoading = 1
        return
    end

    
    -- Check if our ROM was patched
    local memory_size = memory.getmemorydomainsize("ROM")
    local required_music_memory_size = (GENERIC_DEFS.MUSIC_PATCH_ADDRESS - 0x08000000) + 0x00200000

    --print("Memory size: " .. memory_size)
    --print("required MUSIC_PATCH_ADDRESS size: " .. required_music_memory_size)

    if memory_size < required_music_memory_size then

        print ("Turning off Music Loader, ROM was not patched to be large enough!")

        GENERIC_DEFS.ENABLE_MUSIC_PATCHING = 0
        MusicLoader.FinishedLoading = 1
        return
    end
    
    

    --local patch_file = assert(io.open(patch_file_name, "rb"))

    MusicLoader.patch_str = patch_file:read("*all")
    --print(#MusicLoader.patch_str)
    patch_file:close()

    --local transpose_offset_file = assert(io.open(transpose_offset_file_name, "r"))

    local transpose_offset_string = ""

    repeat
        local str = transpose_offset_file:read(20*1024)
        if str then
                transpose_offset_string = transpose_offset_string .. str
        end
    until not str

    transpose_offset_file:close()


    transpose_offsets_split = mysplit(transpose_offset_string, '\n')
    transpose_offsets_split[#transpose_offsets_split + 1] = 2147483647


    --local bpm_offset_file = assert(io.open(bpm_offset_file_name, "r"))

    local bpm_offset_string = ""

    repeat
        local str = bpm_offset_file:read(20*1024)
        if str then
            bpm_offset_string = bpm_offset_string .. str
        end
    until not str

    bpm_offset_file:close()


    bpm_offsets_split = mysplit(bpm_offset_string, '\n')
    bpm_offsets_split[#bpm_offsets_split + 1] = 2147483647


    --print(transpose_offsets_split)
    --print(bpm_offsets_split)

    MusicLoader.transpose = gauntlet_data.math.random_music(-transpose_range, transpose_range)--math.random(-transpose_range, transpose_range)
    MusicLoader.bpm_shift = gauntlet_data.math.random_music(-bpm_shift_range, bpm_shift_range)--math.random(-bpm_shift_range, bpm_shift_range)
    print("Music transpose / bpm shifts: " .. tostring(MusicLoader.transpose) .. " / " .. tostring(MusicLoader.bpm_shift))

    MusicLoader.transpose_offsets = {}
    MusicLoader.bpm_offsets = {}


    for k, offset_str in ipairs(transpose_offsets_split) do
        
        local offset = tonumber(offset_str)
        MusicLoader.transpose_offsets[offset] = 1

    end

    for k, offset_str in ipairs(bpm_offsets_split) do
        
        local offset = tonumber(offset_str)
        MusicLoader.bpm_offsets[offset] = 1

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
    local yield_interval = MusicLoader.BlockSize
    --MusicLoader.BlockSize = yield_interval
    
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
            io_utils.writebyte(GENERIC_DEFS.MUSIC_PATCH_ADDRESS + MusicLoader.offset, c + MusicLoader.bpm_shift)
            --print("BPM changed. " .. tostring(offset))
        elseif MusicLoader.transpose_offsets[MusicLoader.offset] ~= nil then
            --print("Transpose change " .. tostring(offset))
            --print(c)
            --print(c + transpose)
            io_utils.writebyte(GENERIC_DEFS.MUSIC_PATCH_ADDRESS + MusicLoader.offset, c + MusicLoader.transpose)
            --print("Transpose changed. " .. tostring(offset))
        else
            io_utils.writebyte(GENERIC_DEFS.MUSIC_PATCH_ADDRESS + MusicLoader.offset, c)
        end
    
        --io_utils.writebyte(GENERIC_DEFS.MUSIC_PATCH_ADDRESS + offset, c)
    
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
