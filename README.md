# mmbn3-draft-gauntlet
Lua scripts and notes for modding the first Monolith Gauntlet battle in Secret Area 1 in Megaman Battle Network 3: Blue [US]. Just some fun tinkering around. Requires BizHawk with the VBA-Next core to run the scripts.


# json.lua
Credits to json.lua go to https://github.com/rxi (Respective License: LICENSE_JSON_LUA)

# How-To / Usage

Download BizHawk from https://github.com/TASVideos/BizHawk/releases

Download the latest release of the Gauntlet files in the release section ( https://github.com/thomasneff/mmbn3-draft-gauntlet/releases )

Extract all files of this repository to a directory of your choice (I will refer to that directory from now on as GAUNTLET_FOLDER)

Get "gbabios.rom" and make sure to put it in the "Firmware" directory inside your BizHawk directory

Start BizHawk (EmuHawk.exe)

Switch GBA Core to "VBA-Next" (Config -> Cores -> GBA -> "VBA-Next")

Load Megaman Battle Network 3: Blue [US] in BizHawk

Open the BizHawk Lua Console (Tools -> Lua Console)

In the Lua Console, open the script "gauntlet.lua" (Script -> Open Script -> open GAUNTLET_FOLDER/gauntlet.lua)

(If it didn't start automatically) Doubleclick the "gauntlet" script in the Lua Console list of scripts

The paused icon should change to a running icon, and the gauntlet will load


# Controls during Menus / between Battles

Directions: Cursor / Highlighted Object

A: Confirm

B: Skip (in Chip Replacement View)

L/R: Show active Buffs

Start: Sort Folder View

Select: Show Folder View (if in any other view)

# Music Replacement

This Gauntlet mod contains the option of automatically replacing the in-game battle music by music extracted from other GBA games.
This is done by extracting the data for all instruments and samples using the "SongExtractor" tool in the directory "songextractor_cs".
For this to work, you need to do the following:

Patch the ROM to increase its size to contain the additional music, using the "RomPatcher" tool found in the "rom_patch" directory. Keep in mind that using the patched rom without Music Patching enabled / used will result in missing battle music. If you don't want to use Music Patching, simply use the regular Megaman Battle Network 3: Blue [US] rom.

(From now on, to use Music Patching, use the patched ROM with BizHawk.)

To extract music, the "SongExtractor" tool can be used when the "Song Table Address" is known. This address can be found out by using the "Sappy2006" tool, which you can find on romhacking sites.

If you load a ROM into Sappy2006 and it detects it, you can simply use the Song Table Address with the "SongExtractor.exe" in "songextractor_cs". as follows:
```
"SongExtractor.exe mmbn3.gba 0x00148C6C 0 200 800000"
```

Where 0x00148C6C would be the Song Table Address for Megaman Battle Network 3: Blue [US], 0 is the first song index to extract, 200 is the last song index to extract, and 800000 is the offset where the song will be placed during runtime (which you can leave at 800000).

When used correctly, SongExtractor should produce an out/GameName/ directory, where files for every song are extracted. Several SongTable offsets are defined in GAUNTLET_FOLDER/song_extractor_cs/song_tables.txt . The batch file GAUNTLET_FOLDER/song_extractor_cs/extract_all.bat shows example usages for extracting songs of all Battle Network games.

To use them in the Gauntlet, you can modify the "music_loader.lua" script in GAUNTLET_FOLDER/music_loader.lua . In there, you can change the directories of your music files (or leave them as default), change the amount of music transposition / tempo shift that gets randomly applied and the music tracks used for regular battles and boss battles.

## Enabling / Disabling Music Replacement
In GAUNTLET_FOLDER/music_loader.lua:
```
GENERIC_DEFS.ENABLE_MUSIC_PATCHING = 1
```
Setting this value to 0 results in no Music Patching. Music Patching is also automatically disabled if any of the defined song files can not be loaded / are missing.

## Transposing Music
In GAUNTLET_FOLDER/music_loader.lua:
```
local transpose_range = 8
```
Changing this variable changes the range of semitones each song can randomly be transposed by.

## Changing Music Tempo
In GAUNTLET_FOLDER/music_loader.lua:
```
local bpm_shift_range = 20
```
Changing this variable changes the range of tempos each song can randomly be shifted by.

## Changing Standard Battle Music
In GAUNTLET_FOLDER/music_loader.lua:
```
local BattleMusicList = 
{
    "mmbn/0",       -- main theme
    "mmbn/8",       -- fire field
    "mmbn/9",       -- boundless network
    "mmbn/12",      -- elecrical crisis
    "mmbn/14",      -- battle theme
    "mmbn2/0",      -- main theme
    ...
    ...
...
```
Changing / adding entries to this list will add the possibility for these songs to be picked during regular battles.

## Changing Boss Battle Music
In GAUNTLET_FOLDER/music_loader.lua:
```
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
    ...
    ...
...
```
Changing / adding entries to this list will add the possibility for these songs to be picked during boss battles.

# Recap of all things necessary to play WITH Music Patching
1. Download BizHawk ( https://github.com/TASVideos/BizHawk/releases )
2. Download and extract newest Release of MMBN3 Gauntlet ( https://github.com/thomasneff/mmbn3-draft-gauntlet/releases )
3. Get gbabios.rom for BizHawk
4. Switch BizHawk to VBA-Next (Config -> Cores -> GBA -> "VBA-Next")
5. Patch MMBN3 Blue [US] with GAUNTLET_FOLDER/rom_patcher/RomPatcher.exe (RomPatcher.exe mmbn3.gba)
6. Extract Songs from GBA files using GAUNTLET_FOLDER/song_extractor_cs/SongExtractor.exe (SongExtractor.exe rom_path song_table_address first_song_index last_song_index 800000)
7. Modify GAUNTLET_FOLDER/music_loader.lua to use your extracted songs or change music randomization!