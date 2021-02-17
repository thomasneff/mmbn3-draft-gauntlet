local deepcopy = require "deepcopy"
local COMPLETELY_RANDOM = require "loadouts.completely_random"
local DRAFT_RANDOM = require "loadouts.draft_random"
local DRAFT_BALANCED_RARITY = require "loadouts.draft_balanced_rarity"
local DRAFT_STANDARD_MEGA_MAX_1 = require "loadouts.draft_sm_lib_max_1"
local DRAFT_STANDARD_MEGA_MAX_1_MORE_CODES = require "loadouts.draft_sm_lib_max_1_more_codes"
local MMBN3_START_FOLDER = require "loadouts.mmbn3_blue_us.mmbn3_start_folder"
local MMBN3_EXTRAFOLDER = require "loadouts.mmbn3_blue_us.mmbn3_extrafolder"
local MMBN3_PREFOLDER = require "loadouts.mmbn3_blue_us.mmbn3_prefolder"
local MMBN3_HADESFOLDER = require "loadouts.mmbn3_blue_us.mmbn3_hadesfolder"
local MMBN3_N1FOLDER_A = require "loadouts.mmbn3_blue_us.mmbn3_n1folder_a"
local MMBN3_N1FOLDER_B = require "loadouts.mmbn3_blue_us.mmbn3_n1folder_b"
local MMBN3_N1FOLDER_C = require "loadouts.mmbn3_blue_us.mmbn3_n1folder_c"
local MMBN3_N1FOLDER_D = require "loadouts.mmbn3_blue_us.mmbn3_n1folder_d"
local MMBN3_FAMFOLDER = require "loadouts.mmbn3_blue_us.mmbn3_famfolder"
local MMBN3_APPRENTICEFOLDER = require "loadouts.mmbn3_blue_us.mmbn3_apprenticefolder"
local PA_TEST_FOLDER = require "loadouts.pa_test_folder"
local YOUR_CUSTOM_FOLDER = require "loadouts.your_custom_folder"


local JUST_MONIKA = require "loadouts.just_monika"

-- TODO: Each loadout should provide a NAME, a DESCRIPTION, and an activate() function.
--       This activate() function simply does everything necessary for the state_logic to advance.
local LIST_OF_LOADOUTS = {
    DRAFT_RANDOM,
    DRAFT_BALANCED_RARITY,
    DRAFT_STANDARD_MEGA_MAX_1_MORE_CODES,
    DRAFT_STANDARD_MEGA_MAX_1,
    YOUR_CUSTOM_FOLDER,
    MMBN3_START_FOLDER,
    MMBN3_EXTRAFOLDER,
    MMBN3_PREFOLDER,
    MMBN3_HADESFOLDER,
    MMBN3_N1FOLDER_A,
    MMBN3_N1FOLDER_B,
    MMBN3_N1FOLDER_C,
    MMBN3_N1FOLDER_D,
    MMBN3_FAMFOLDER,
    MMBN3_APPRENTICEFOLDER,
    PA_TEST_FOLDER,
    COMPLETELY_RANDOM,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    JUST_MONIKA,
    
}




return LIST_OF_LOADOUTS