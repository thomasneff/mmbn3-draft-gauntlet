local CHIP_DATA = require "defs.chip_data_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local GAUNTLET_DEFS = require "defs.gauntlet_defs"
local RANDOMIZED_LIBRARY_STARS_FOLDER = require "start_folders.randomized_library_stars_folder"
local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP = require "defs.chip_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"
local randomchoice_key = require "randomchoice_key"
local randomchoice = require "randomchoice"
local DRAFT_BALANCED_RARITY = {}

local standard_chips = {}
local mega_chips = {}
local giga_chips = {}
local random_codes = {}

-- TODO:
-- Generate different "classes" of drops, i.e. "Sword", "Recov", "Utility", "Standard", "Mega"
-- For each class, generate drop tables, similar to enemy drops
-- During draft: The chip_index determines the drop class
--               For this class, a random drop is chosen
--               From this drop, a rarity is chosen based on reasonable rarities (e.g. starting rarities)
--               Therefore, each draft round has 3 chips from a given "class".
--               When we draw a chip, we want to override the non-asterisk codes with our allocated random codes


-- Chips
-- Cannon:      Standard
-- AirShot1:    Standard
-- LavaCan1:    Standard    (SR+)
-- ShotGun:     Standard
-- VGun:        Standard 
-- SideGun:     Standard 
-- Spreader:    Standard    (R+)
-- Bubbler:     Standard    (R+)
-- BubV:        Standard    (R+)
-- BublSide:    Standard    (R+)
-- HeatShot:    Standard
-- HeatV:       Standard
-- HeatSide:    Standard
-- MiniBomb:    Standard
-- SnglBomb:    Standard    (R+)
-- DublBomb:    Standard    (SR+)
-- Sword:       Sword       
-- WideSwrd:    Sword       (R+)
-- LongSwrd:    Sword       (R+)
-- FireSwrd:    Sword       (SR+)
-- AquaSwrd:    Sword       (SR+)
-- ElecSwrd:    Sword       (SR+)
-- BambSwrd:    Sword       (SR+)
-- CustSwrd:    Sword       (SR+)
-- AirSwrd:     Sword       (SR+)
-- StepSwrd:    Sword       (SR+)
-- ShockWav:    Standard
-- GutPunch:    Standard
-- DashAtk:     Standard    (R+)
-- ZapRing1:    Standard
-- IceWave1:    Standard    (R+)
-- YoYo1:       Standard    (R+)
-- Arrow1:      Standard    (SR+)
-- Ratton1:     Standard    (R+)
-- Tornado:     Standard    (SR+)
-- Shake1:      Standard    (R+)
-- Hammer:      Standard    (R+)
-- Rope1:       Standard    (R+)
-- Boomer1:     Standard    (R+)
-- RockArm1:    Standard    (R+)
-- Magnum1:     Standard    (SR+)
-- Plasma1:     Standard    (R+)
-- RndmMetr:    Standard    (SR+)
-- Needler:     Standard    (R+)
-- Totem1:      Standard    (SR+)       Healing     (SR+)
-- Sensor1:     Standard    (SR+)
-- MetaGel1:    Standard    (SR+)
-- TimeBomb:    Standard    (SR+)
-- Lance:       Standard    (SR+)
-- Snake:       Standard    (SR+)
-- Guard:       Utility
-- PanlOut1:    Utility
-- PanlOut3:    Utility     (R+)
-- PanlGrab:    Utility
-- AreaGrab:    Utility     (SR+)
-- GrabBack:    Utility     (R+)
-- RockCube:    Utility
-- Prism:       Utility     (SR+)
-- Wind:        Utility
-- Fan:         Utility
-- Fanfare:     Utility     (R+)
-- Recov10:     Healing
-- Recov30:     Healing     (R+)
-- Recov80:     Healing     (SR+)
-- Recov120:    Healing     (UR+)
-- Repair:      Utility     (SR+)
-- FstGauge:    Utility     (SR+)
-- Geddon1:     Utility     (SR+)
-- Geddon2:     Utility     (SR+)
-- Geddon3:     Utility     (SR+)
-- Invis:       Utility     (SR+)
-- Mole1:       Utility     (R+)
-- AirShoes:    Utility     (R+)
-- Barrier:     Utility     
-- HolyPanl:    Utility
-- LavaStge:    Utility     (SR+)
-- IceStage:    Utility     (SR+)
-- GrassStg:    Utility     (SR+)
-- SandStge:    Utility     (SR+)
-- MetlStge:    Utility     (SR+)
-- AntiDmg:     Utility     (SR+)
-- AntiSwrd:    Utility     (SR+)
-- AtkPlus10:   Utility
-- FirePlus30:  Utility     (R+)
-- AquaPlus30:  Utility     (R+)
-- ElecPlus30:  Utility     (R+)
-- WoodPlus30:  Utility     (R+)
-- NaviPlus20:  Utility     (SR+)
-- AtkPlus30:   Mega
-- NaviPlus40:  Mega
-- Roll:        Mega
-- GutsMan:     Mega
-- ProtoMan:    Mega        (SR+)
-- FlashMan:    Mega        (R+)
-- BeastMan:    Mega
-- BubblMan:    Mega        (R+)
-- DesrtMan:    Mega        (R+)
-- PlantMan:    Mega        (SR+)
-- FlamMan:     Mega        (R+)
-- DrillMan:    Mega        (SR+)
-- MetalMan:    Mega
-- KingMan:     Mega        (R+)
-- MistMan:     Mega        (SR+)
-- BowlMan:     Mega        (SR+)
-- DarkMan:     Mega        (SR+)
-- JapanMan:    Mega        (SR+)
-- Punk         Mega        (SR+)



local DRAFT_TABLES = {}

DRAFT_TABLES.Sword = 
{
    {
          [1] = {
            CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
            CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Sword, nil, 0)
          },
          [2] = {
            CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
            CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.WideSwrd, nil, 1)
          },
          [3] = {
            CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
            CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Sword, CHIP_CODE.Asterisk, 2)
          },
          [4] = {
            CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
            CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.WideSwrd, CHIP_CODE.Asterisk, 3)
          }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Sword, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.LongSwrd, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Sword, CHIP_CODE.Asterisk, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.LongSwrd, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.WideSwrd, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.LongSwrd, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.FireSwrd, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.FireSwrd, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Sword, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.LongSwrd, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.AquaSwrd, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.AquaSwrd, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Sword, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.LongSwrd, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.ElecSwrd, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.ElecSwrd, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Sword, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.LongSwrd, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.BambSwrd, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.BambSwrd, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Sword, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.LongSwrd, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.CustSwrd, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.CustSwrd, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Sword, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.LongSwrd, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.AirSwrd, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.AirSwrd, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Sword, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.LongSwrd, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.StepSwrd, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.StepSwrd, CHIP_CODE.Asterisk, 3)
        }
    }
}

DRAFT_TABLES.Healing = 
{
    {
          [1] = {
            CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
            CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Recov10, nil, 0)
          },
          [2] = {
            CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
            CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Recov30, nil, 1)
          },
          [3] = {
            CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
            CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Recov10, CHIP_CODE.Asterisk, 2)
          },
          [4] = {
            CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
            CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Recov30, CHIP_CODE.Asterisk, 3)
          }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Recov10, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Recov30, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Recov80, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Recov120, nil, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Recov10, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Recov30, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Totem1, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Recov80, CHIP_CODE.Asterisk, 3)
        }
    }

}

DRAFT_TABLES.Utility = 
{
    {
          [1] = {
            CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
            CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.PanlOut1, nil, 0)
          },
          [2] = {
            CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
            CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.PanlOut3, nil, 1)
          },
          [3] = {
            CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
            CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.AreaGrab, nil, 2)
          },
          [4] = {
            CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
            CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.AreaGrab, CHIP_CODE.Asterisk, 3)
          }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Guard, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.GrabBack, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Prism, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Prism, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.PanlGrab, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Fanfare, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Repair, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Repair, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.RockCube, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Mole1, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.FstGauge, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.FstGauge, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Wind, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.AirShoes, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Geddon1, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Geddon1, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Fan, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.FirePlus30, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Geddon2, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Geddon2, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Barrier, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.AquaPlus30, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Geddon3, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Geddon3, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.HolyPanl, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.ElecPlus30, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Invis, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Invis, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.AtkPlus10, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.WoodPlus30, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.LavaStge, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.LavaStge, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.PanlOut1, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.PanlOut3, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.IceStage, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.IceStage, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.PanlGrab, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.GrabBack, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.GrassStg, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.GrassStg, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Guard, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Fanfare, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.SandStge, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.SandStge, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.RockCube, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Mole1, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.MetlStge, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.MetlStge, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Barrier, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.AirShoes, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.AntiDmg, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.AntiDmg, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.HolyPanl, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Barrier, CHIP_CODE.Asterisk, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.AntiSwrd, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.AntiSwrd, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.RockCube, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.RockCube, CHIP_CODE.Asterisk, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.NaviPlus20, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.NaviPlus20, CHIP_CODE.Asterisk, 3)
        }
    }


}

DRAFT_TABLES.Standard = 
{
    {
          [1] = {
            CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
            CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.ShotGun, nil, 0)
          },
          [2] = {
            CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
            CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Spreader, nil, 1)
          },
          [3] = {
            CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
            CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.LavaCan1, nil, 2)
          },
          [4] = {
            CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
            CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Spreader, CHIP_CODE.Asterisk, 3)
          }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Cannon, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Bubbler, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.DublBomb, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Bubbler, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.AirShot1, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.BubV, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Arrow1, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.BubV, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.VGun, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.BublSide, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Tornado, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.BublSide, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.SideGun, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.SnglBomb, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Magnum1, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.SnglBomb, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.HeatShot, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.DashAtk, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.RndmMetr, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.DashAtk, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.HeatV, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.IceWave1, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Totem1, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.IceWave1, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.HeatSide, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.YoYo1, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Sensor1, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.YoYo1, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.MiniBomb, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Ratton1, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.MetaGel1, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Ratton1, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.ShockWav, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Shake1, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.TimeBomb, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Shake1, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.GutPunch, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Rope1, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Lance, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Rope1, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.ZapRing1, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Boomer1, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Snake, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Boomer1, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Hammer, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.RockArm1, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Spreader, CHIP_CODE.Asterisk, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.DashAtk, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Plasma1, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Needler1, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.IceWave1, CHIP_CODE.Asterisk, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.LavaCan1, CHIP_CODE.Asterisk, 3)
        }
    }
}

DRAFT_TABLES.Mega = 
{
    {
          [1] = {
            CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
            CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.AtkPlus30, nil, 0)
          },
          [2] = {
            CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
            CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.FlashMan, nil, 1)
          },
          [3] = {
            CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
            CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.PlantMan, nil, 2)
          },
          [4] = {
            CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
            CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.AtkPlus30, CHIP_CODE.Asterisk, 3)
          }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.NaviPlus40, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.BubblMan, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.DrillMan, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.NaviPlus40, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Roll, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.DesrtMan, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.MistMan, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Roll, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.GutsMan, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.FlamMan, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.JapanMan, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.GutsMan, CHIP_CODE.Asterisk, 3)
        }
    },
    {
        [1] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.BeastMan, nil, 0)
        },
        [2] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.KingMan, nil, 1)
        },
        [3] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.Punk, nil, 2)
        },
        [4] = {
          CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
          CHIP_GEN = CHIP.new_chip_generator(CHIP_ID.BeastMan, CHIP_CODE.Asterisk, 3)
        }
    }
}

local DRAFT_TABLE_INDEX_MAP = 
{
    [1]     = DRAFT_TABLES.Standard,
    [2]     = DRAFT_TABLES.Standard,
    [3]     = DRAFT_TABLES.Healing,
    [4]     = DRAFT_TABLES.Standard,
    [5]     = DRAFT_TABLES.Sword,
    [6]     = DRAFT_TABLES.Standard,
    [7]     = DRAFT_TABLES.Standard,
    [8]     = DRAFT_TABLES.Utility,
    [9]     = DRAFT_TABLES.Standard,
    [10]    = DRAFT_TABLES.Mega,
    [11]    = DRAFT_TABLES.Standard,
    [12]    = DRAFT_TABLES.Standard,
    [13]    = DRAFT_TABLES.Healing,
    [14]    = DRAFT_TABLES.Standard,
    [15]    = DRAFT_TABLES.Sword,
    [16]    = DRAFT_TABLES.Standard,
    [17]    = DRAFT_TABLES.Standard,
    [18]    = DRAFT_TABLES.Utility,
    [19]    = DRAFT_TABLES.Standard,
    [20]    = DRAFT_TABLES.Mega,
    [21]    = DRAFT_TABLES.Utility,
    [22]    = DRAFT_TABLES.Sword,
    [23]    = DRAFT_TABLES.Healing,
    [24]    = DRAFT_TABLES.Standard,
    [25]    = DRAFT_TABLES.Sword,
    [26]    = DRAFT_TABLES.Standard,
    [27]    = DRAFT_TABLES.Standard,
    [28]    = DRAFT_TABLES.Utility,
    [29]    = DRAFT_TABLES.Healing,
    [30]    = DRAFT_TABLES.Mega,
}


function test_draft_tables()

    -- go over all chip indices
    for chip_index = 1,30 do

        -- Get draft table
        local draft_table = DRAFT_TABLE_INDEX_MAP[chip_index]

        -- go over all drop tables
        for k, drop_table in pairs(draft_table) do

            -- go over all rarities
            for j, drop_entry in pairs(drop_table) do

                local test_chip = drop_entry.CHIP_GEN()
                print("Test chip: ")
                print(test_chip)

            end

        end


    end

end


function DRAFT_BALANCED_RARITY.random_chip_generator(chip_index)

    --test_draft_tables()

    --print("chip index: " .. tostring(chip_index))

    -- Get a draft table
    local draft_table = DRAFT_TABLE_INDEX_MAP[chip_index]
    --print("draft table: ")
    --print(draft_table)
    -- Get a drop_table
    local drop_table = randomchoice(draft_table)

    --print("drop_table: ")
    --print(drop_table)


    -- Compute rarity and get the generator
    local rng = math.random(100)
    local rarity = 0
    local dropped_chip_generator = nil

    for key, drop_entry in ipairs(drop_table) do

        if rng <= drop_entry.CUMULATIVE_RARITY then

            dropped_chip_generator = drop_entry.CHIP_GEN
            break
        end
        rarity = rarity + 1
    end

    local chip = dropped_chip_generator()
    --print("Generated chip: ")
    --print(chip)

    chip.RARITY = rarity
    if chip.CODE ~= CHIP_CODE.Asterisk then
        chip.CODE = randomchoice(random_codes)
    end

    -- Make sure that no common rarity chip has asterisk code
    while chip.RARITY == 0 and chip.CODE == CHIP_CODE.Asterisk do
        chip.CODE = randomchoice(random_codes)
    end

    --print("Before return")
    return chip
end

function DRAFT_BALANCED_RARITY.activate()

    gauntlet_data.folder_draft_chip_list = {}

    for key, value in pairs(CHIP_DATA) do

        if (value.CHIP_RANKING % 4) == 0 and value.LIBRARY_STARS < 1 then
            
            standard_chips[key] = value
        
        elseif (value.CHIP_RANKING % 4) == 1 and value.LIBRARY_STARS < 3 then

            mega_chips[key] = value

        elseif (value.CHIP_RANKING % 4) == 2 then

            giga_chips[key] = value

        end

    end

    random_codes[1] = math.random(0, 2)
    random_codes[2] = math.random(3, 5)
    random_codes[3] = math.random(6, 8)
    random_codes[4] = math.random(9, 11)
    random_codes[5] = math.random(12, 13)
    random_codes[6] = math.random(14, 15)
    random_codes[7] = math.random(16, 17)
    random_codes[8] = math.random(18, 21)
    random_codes[9] = math.random(22, 23)
    random_codes[10] = math.random(24, 25)
    
    -- Make asterisk code more unlikely
    for i = 11,30 do
      random_codes[i] = random_codes[i - 10]
    end



    random_codes[31] = 26



    gauntlet_data.current_folder = {}

    gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_DRAFT_FOLDER
    gauntlet_data.folder_draft_chip_generator = DRAFT_BALANCED_RARITY.random_chip_generator
    print("Draft Balanced activated.")
    --print("Length of folder draft chip list:", #gauntlet_data.folder_draft_chip_list)

end


DRAFT_BALANCED_RARITY.NAME = "Draft Folder (Balanced / Rarity-Based)"
DRAFT_BALANCED_RARITY.DESCRIPTION = "You pick 30 Chips for your folder!\n(Balanced, with rarities)!"


return DRAFT_BALANCED_RARITY

