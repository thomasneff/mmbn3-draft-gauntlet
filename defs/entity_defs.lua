local ENTITIES = {}
local ENTITY_TYPE = require "defs.entity_type_defs"
local ENTITY_KIND = require "defs.entity_kind_defs"
local ENTITY_AI_ADDRESS = require "defs.entity_ai_address_defs"
local ENTITY_HP_TRANSLATOR = require "defs.entity_hp_defs"
local ENTITY_NAME_ADDRESS_TRANSLATOR = require "defs.entity_name_defs"
local ENTITY_PALETTE_DEFS = require "defs.entity_palette_defs"
local ENTITY_ELEMENT_DEFS = require "defs.entity_element_defs"
local GAUNTLET_DEFS = require "defs.gauntlet_defs"
local TIME_FREEZE_CHIP_DEFS = require "defs.time_freeze_chip_defs"
local CHIP_DEFS = require "defs.chip_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"
local deepcopy = require "deepcopy"

--Here, we define all enemies for the other functions to randomize. Also we can define other combinations later on, e.g. if we want to change attack delay and stuff.

local BASE_BATTLE_DATA = {
    KIND = ENTITY_KIND.Virus,
    X_POS = 0x02, -- We use these defaults so we don't have to change MegaMan's starting position later on
    Y_POS = 0x02, -- We use these defaults so we don't have to change MegaMan's starting position later on
    TYPE = ENTITY_TYPE.Mettaur
}


function new_battle_data(entity_kind, entity_type)

    local new_battle_data = deepcopy(BASE_BATTLE_DATA)

    new_battle_data.KIND = entity_kind
    new_battle_data.TYPE = entity_type

    return new_battle_data

end

-- This returns a new base entity containing battle data, name address and HP address.
-- Unfortunately, damage and AI addresses need to be done Manually, which sucks.
function new_base_entity(entity_kind, entity_id)

    local new_base_entity = {}


    local entity_type = ENTITY_TYPE[entity_id]
    new_base_entity.BATTLE_DATA = new_battle_data(entity_kind, entity_type)
    new_base_entity.NAME_ADDRESS = ENTITY_NAME_ADDRESS_TRANSLATOR[entity_id]

    -- This should just return nil for MegaMan and do nothing
    new_base_entity.HP_ADDRESS = ENTITY_HP_TRANSLATOR.translate(entity_type)

    new_base_entity.AI_ADDRESS = ENTITY_AI_ADDRESS[entity_id]

    new_base_entity.ELEMENT = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
    new_base_entity.ID      = entity_id

    return new_base_entity
end

ENTITIES.MegaMan                            = new_base_entity(ENTITY_KIND.MegaMan, "MegaMan")

--All AI Bytes need to be looked up at http://forums.therockManexezone.com/topic/8907775/1/


local ALL_BATTLES = {}
for i = 1,GAUNTLET_DEFS.NUMBER_OF_BATTLES do
    ALL_BATTLES[i] = i
end

local TIER_1_BATTLES_WITHOUT_BOSSES = {}
for i = 1,10 do

    if i ~= 5 and i ~= 10 then
        TIER_1_BATTLES_WITHOUT_BOSSES[i] = i
    end
    
end


local TIER_2_BATTLES_WITHOUT_BOSSES = {}
for i = 1,10 do

    if i ~= 5 and i ~= 10 then
        TIER_2_BATTLES_WITHOUT_BOSSES[i] = i + 10
    end
    
end

local TIER_3_BATTLES_WITHOUT_BOSSES = {}
for i = 1,10 do

    if i ~= 5 and i ~= 10 then
        TIER_3_BATTLES_WITHOUT_BOSSES[i] = i + 20
    end
    
end

local TIER_4_BATTLES_WITHOUT_BOSSES = {}
for i = 1,10 do

    if i ~= 5 and i ~= 10 then
        TIER_4_BATTLES_WITHOUT_BOSSES[i] = i + 30
    end
    
end

local TIER_1_MINIBOSS_BATTLES = {5}
local TIER_2_MINIBOSS_BATTLES = {15}
local TIER_3_MINIBOSS_BATTLES = {25}
local TIER_4_MINIBOSS_BATTLES = {35}
--local TIER_5_MINIBOSS_BATTLES = {5}

local TIER_1_BOSS_BATTLES = {10}
local TIER_2_BOSS_BATTLES = {20}
local TIER_3_BOSS_BATTLES = {30}
local TIER_4_BOSS_BATTLES = {40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50}



----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Non-Virus Entities --
----------------------------------------------------------------------------------------------------------------------------------------------------------
ENTITIES.RockCube                           = new_base_entity(ENTITY_KIND.RockCube,     "RockCube")
ENTITIES.RockCube.BATTLE_NUMBERS            = ALL_BATTLES                       -- Battles in which this entity can appear.
ENTITIES.RockCube.NAME                      = "RockCube"
ENTITIES.RockCube.BATTLE_DATA.TYPE          = 0x00

ENTITIES.MetalCube                          = new_base_entity(ENTITY_KIND.MetalCube,    "MetalCube")
ENTITIES.MetalCube.BATTLE_NUMBERS           = ALL_BATTLES                       -- Battles in which this entity can appear.
ENTITIES.MetalCube.NAME                     = "MetalCube"
ENTITIES.MetalCube.BATTLE_DATA.TYPE         = 0x00

ENTITIES.IceCube                            = new_base_entity(ENTITY_KIND.IceCube,      "IceCube")
ENTITIES.IceCube.BATTLE_NUMBERS             = ALL_BATTLES                       -- Battles in which this entity can appear.
ENTITIES.IceCube.NAME                       = "IceCube"
ENTITIES.IceCube.BATTLE_DATA.TYPE           = 0x00

ENTITIES.Guardian                           = new_base_entity(ENTITY_KIND.Guardian,     "Guardian")
ENTITIES.Guardian.BATTLE_NUMBERS            = ALL_BATTLES                       -- Battles in which this entity can appear.
ENTITIES.Guardian.NAME                      = "Guardian"
ENTITIES.Guardian.BATTLE_DATA.TYPE          = 0x00

ENTITIES.BlackBomb                          = new_base_entity(ENTITY_KIND.BlackBomb,    "BlackBomb")
ENTITIES.BlackBomb.BATTLE_NUMBERS           = ALL_BATTLES                       -- Battles in which this entity can appear.
ENTITIES.BlackBomb.NAME                     = "BlackBomb"
ENTITIES.BlackBomb.BATTLE_DATA.TYPE         = 0x00





----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Viruses --
----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Mettaur                            = new_base_entity(ENTITY_KIND.Virus, "Mettaur")
ENTITIES.Mettaur.NAME                       = "Mettaur"
ENTITIES.Mettaur.HP_BASE                    = 40
ENTITIES.Mettaur.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Mettaur.AI_BYTES                   = {}
ENTITIES.Mettaur.AI_BYTES[0x00]             = 0x0A                              -- Base Damage.
ENTITIES.Mettaur.AI_BYTES[0x01]             = 0x28                              -- Delay before moving.
ENTITIES.Mettaur.AI_BYTES[0x02]             = 0x1E                              -- Delay before attacking.
ENTITIES.Mettaur.BATTLE_NUMBERS             = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Mettaur2                           = new_base_entity(ENTITY_KIND.Virus, "Mettaur2")
ENTITIES.Mettaur2.NAME                      = "Mettaur2"
ENTITIES.Mettaur2.HP_BASE                   = 60
ENTITIES.Mettaur2.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Mettaur2.AI_BYTES                  = {}
ENTITIES.Mettaur2.AI_BYTES[0x00]            = 0x28                              -- Base Damage.
ENTITIES.Mettaur2.AI_BYTES[0x01]            = 0x0F                              -- Delay before moving.
ENTITIES.Mettaur2.AI_BYTES[0x02]            = 0x08                              -- Delay before attacking.
ENTITIES.Mettaur2.BATTLE_NUMBERS            = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Mettaur3                           = new_base_entity(ENTITY_KIND.Virus, "Mettaur3")
ENTITIES.Mettaur3.NAME                      = "Mettaur3"
ENTITIES.Mettaur3.HP_BASE                   = 120
ENTITIES.Mettaur3.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Mettaur3.AI_BYTES                  = {}
ENTITIES.Mettaur3.AI_BYTES[0x00]            = 0x50                              -- Base Damage.
ENTITIES.Mettaur3.AI_BYTES[0x01]            = 0x0A                              -- Delay before moving.
ENTITIES.Mettaur3.AI_BYTES[0x02]            = 0x05                              -- Delay before attacking.
ENTITIES.Mettaur3.BATTLE_NUMBERS            = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.MettaurOmega                       = new_base_entity(ENTITY_KIND.Virus, "MettaurOmega")
ENTITIES.MettaurOmega.NAME                  = "Mettaur\003"
ENTITIES.MettaurOmega.HP_BASE               = 160
ENTITIES.MettaurOmega.ELEMENT               = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.MettaurOmega.AI_BYTES              = {}
ENTITIES.MettaurOmega.AI_BYTES[0x00]        = 0x96                              -- Base Damage.
ENTITIES.MettaurOmega.AI_BYTES[0x01]        = 0x08                              -- Delay before moving.
ENTITIES.MettaurOmega.AI_BYTES[0x02]        = 0x03                              -- Delay before attacking.
ENTITIES.MettaurOmega.BATTLE_NUMBERS        = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Canodumb                           = new_base_entity(ENTITY_KIND.Virus, "Canodumb")
ENTITIES.Canodumb.NAME                      = "Canodumb"
ENTITIES.Canodumb.HP_BASE                   = 60
ENTITIES.Canodumb.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Canodumb.AI_BYTES                  = {}
ENTITIES.Canodumb.AI_BYTES[0x00]            = 0x28                              -- Delay before aiming.
ENTITIES.Canodumb.AI_BYTES[0x01]            = 0x0A                              -- Base Damage.
ENTITIES.Canodumb.AI_BYTES[0x2A5A8]         = 0x0C                              -- Aim speed delay.
ENTITIES.Canodumb.BATTLE_NUMBERS            = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Canodumb2                          = new_base_entity(ENTITY_KIND.Virus, "Canodumb2")
ENTITIES.Canodumb2.NAME                     = "Canodumb2"
ENTITIES.Canodumb2.HP_BASE                  = 90
ENTITIES.Canodumb2.ELEMENT                  = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Canodumb2.AI_BYTES                 = {}
ENTITIES.Canodumb2.AI_BYTES[0x00]           = 0x28                              -- Delay before aiming.
ENTITIES.Canodumb2.AI_BYTES[0x01]           = 0x32                              -- Base Damage.
ENTITIES.Canodumb2.AI_BYTES[0x2A5A7]        = 0x09                              -- Aim speed delay.
ENTITIES.Canodumb2.BATTLE_NUMBERS           = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Canodumb3                          = new_base_entity(ENTITY_KIND.Virus, "Canodumb3")
ENTITIES.Canodumb3.NAME                     = "Canodumb3"
ENTITIES.Canodumb3.HP_BASE                  = 130
ENTITIES.Canodumb3.ELEMENT                  = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Canodumb3.AI_BYTES                 = {}
ENTITIES.Canodumb3.AI_BYTES[0x00]           = 0x28                              -- Delay before aiming.
ENTITIES.Canodumb3.AI_BYTES[0x01]           = 0x64                              -- Base Damage.
ENTITIES.Canodumb3.AI_BYTES[0x2A5A6]        = 0x06                              -- Aim speed delay.
ENTITIES.Canodumb3.BATTLE_NUMBERS           = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.CanodumbOmega                      = new_base_entity(ENTITY_KIND.Virus, "CanodumbOmega")
ENTITIES.CanodumbOmega.NAME                 = "Canodumb\003"
ENTITIES.CanodumbOmega.HP_BASE              = 180
ENTITIES.CanodumbOmega.ELEMENT              = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.CanodumbOmega.AI_BYTES             = {}
ENTITIES.CanodumbOmega.AI_BYTES[0x00]       = 0x28                              -- Delay before aiming.
ENTITIES.CanodumbOmega.AI_BYTES[0x01]       = 0xC8                              -- Base Damage.
ENTITIES.CanodumbOmega.AI_BYTES[0x2A5A5]    = 0x03                              -- Aim speed delay.
ENTITIES.CanodumbOmega.BATTLE_NUMBERS       = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Fishy                              = new_base_entity(ENTITY_KIND.Virus, "Fishy")
ENTITIES.Fishy.NAME                         = "Fishy"
ENTITIES.Fishy.HP_BASE                      = 90
ENTITIES.Fishy.ELEMENT                      = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Fishy.AI_BYTES                     = {}
ENTITIES.Fishy.AI_BYTES[0x00]               = 0x01                              -- Number of Charges.
ENTITIES.Fishy.AI_BYTES[0x01]               = 0x1E                              -- ??? (Always 0x1E).
ENTITIES.Fishy.AI_BYTES[0x02]               = 0x1E                              -- Contact and Fire Ring damage (two bytes).
ENTITIES.Fishy.AI_BYTES[0x03]               = 0x00                              -- Contact and Fire Ring damage (two bytes) <-- This is always zero.
ENTITIES.Fishy.AI_BYTES[0x04]               = 0x00                              -- Speed of Attack (Byte 1).
ENTITIES.Fishy.AI_BYTES[0x05]               = 0x00                              -- Speed of Attack (Byte 2).
ENTITIES.Fishy.AI_BYTES[0x06]               = 0xFC                              -- Speed of Attack (Byte 3), lowest this will go to is 0xF3 for maximum speed.
ENTITIES.Fishy.AI_BYTES[0x07]               = 0xFF                              -- Speed of Attack (Byte 4).
ENTITIES.Fishy.BATTLE_NUMBERS               = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Fishy2                             = new_base_entity(ENTITY_KIND.Virus, "Fishy2")
ENTITIES.Fishy2.NAME                        = "Fishy2"
ENTITIES.Fishy2.HP_BASE                     = 150
ENTITIES.Fishy2.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT
ENTITIES.Fishy2.AI_BYTES                    = {}
ENTITIES.Fishy2.AI_BYTES[0x00]              = 0x00                              -- Number of Charges.
ENTITIES.Fishy2.AI_BYTES[0x01]              = 0x1E                              -- ??? (Always 0x1E).
ENTITIES.Fishy2.AI_BYTES[0x02]              = 0x3C                              -- Contact and Fire Ring damage (two bytes).
ENTITIES.Fishy2.AI_BYTES[0x03]              = 0x00                              -- Contact and Fire Ring damage (two bytes) <-- This is always zero.
ENTITIES.Fishy2.AI_BYTES[0x04]              = 0x00                              -- Speed of Attack (Byte 1).
ENTITIES.Fishy2.AI_BYTES[0x05]              = 0x80                              -- Speed of Attack (Byte 2).
ENTITIES.Fishy2.AI_BYTES[0x06]              = 0xFA                              -- Speed of Attack (Byte 3), lowest this will go to is 0xF3 for maximum speed.
ENTITIES.Fishy2.AI_BYTES[0x07]              = 0xFF                              -- Speed of Attack (Byte 4).
ENTITIES.Fishy2.BATTLE_NUMBERS              = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Fishy3                             = new_base_entity(ENTITY_KIND.Virus, "Fishy3")
ENTITIES.Fishy3.NAME                        = "Fishy3"
ENTITIES.Fishy3.HP_BASE                     = 300
ENTITIES.Fishy3.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Fishy3.AI_BYTES                    = {}
ENTITIES.Fishy3.AI_BYTES[0x00]              = 0x02                              -- Number of Charges.
ENTITIES.Fishy3.AI_BYTES[0x01]              = 0x1E                              -- ??? (Always 0x1E).
ENTITIES.Fishy3.AI_BYTES[0x02]              = 0x5A                              -- Contact and Fire Ring damage (two bytes).
ENTITIES.Fishy3.AI_BYTES[0x03]              = 0x00                              -- Contact and Fire Ring damage (two bytes) <-- This is always zero.
ENTITIES.Fishy3.AI_BYTES[0x04]              = 0x00                              -- Speed of Attack (Byte 1).
ENTITIES.Fishy3.AI_BYTES[0x05]              = 0x80                              -- Speed of Attack (Byte 2).
ENTITIES.Fishy3.AI_BYTES[0x06]              = 0xF9                              -- Speed of Attack (Byte 3), lowest this will go to is 0xF3 for maximum speed.
ENTITIES.Fishy3.AI_BYTES[0x07]              = 0xFF                              -- Speed of Attack (Byte 4).
ENTITIES.Fishy3.BATTLE_NUMBERS              = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.FishyOmega                         = new_base_entity(ENTITY_KIND.Virus, "FishyOmega")
ENTITIES.FishyOmega.NAME                    = "Fishy\003"
ENTITIES.FishyOmega.HP_BASE                 = 300
ENTITIES.FishyOmega.ELEMENT                 = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.FishyOmega.AI_BYTES                = {}
ENTITIES.FishyOmega.AI_BYTES[0x00]          = 0x04                              -- Number of Charges.
ENTITIES.FishyOmega.AI_BYTES[0x01]          = 0x1E                              -- ??? (Always 0x1E).
ENTITIES.FishyOmega.AI_BYTES[0x02]          = 0x96                              -- Contact and Fire Ring damage (two bytes).
ENTITIES.FishyOmega.AI_BYTES[0x03]          = 0x00                              -- Contact and Fire Ring damage (two bytes) <-- This is always zero.
ENTITIES.FishyOmega.AI_BYTES[0x04]          = 0x00                              -- Speed of Attack (Byte 1).
ENTITIES.FishyOmega.AI_BYTES[0x05]          = 0x00                              -- Speed of Attack (Byte 2).
ENTITIES.FishyOmega.AI_BYTES[0x06]          = 0xF8                              -- Speed of Attack (Byte 3), lowest this will go to is 0xF3 for maximum speed.
ENTITIES.FishyOmega.AI_BYTES[0x07]          = 0xFF                              -- Speed of Attack (Byte 4).
ENTITIES.FishyOmega.BATTLE_NUMBERS          = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Swordy                             = new_base_entity(ENTITY_KIND.Virus, "Swordy")
ENTITIES.Swordy.NAME                        = "Swordy"
ENTITIES.Swordy.HP_BASE                     = 90
ENTITIES.Swordy.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Swordy.AI_BYTES                    = {}
ENTITIES.Swordy.AI_BYTES[0x00]              = 0x28                              -- Delay before moving horizontally.
ENTITIES.Swordy.AI_BYTES[0x01]              = 0x28                              -- Delay before moving vertically.
ENTITIES.Swordy.AI_BYTES[0x02]              = 0x2C                              -- Vertical speed delay.
ENTITIES.Swordy.AI_BYTES[0x03]              = 0x1E                              -- Damage done by sword.
ENTITIES.Swordy.AI_BYTES[0x1A852E]          = 0x26                              -- Delay after attack. This is shared with all other Swordy viruses in the same battle.
ENTITIES.Swordy.BATTLE_NUMBERS              = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Swordy2                            = new_base_entity(ENTITY_KIND.Virus, "Swordy2")
ENTITIES.Swordy2.NAME                       = "Swordy2"
ENTITIES.Swordy2.HP_BASE                    = 140
ENTITIES.Swordy2.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT
ENTITIES.Swordy2.AI_BYTES                   = {}
ENTITIES.Swordy2.AI_BYTES[0x00]             = 0x28                              -- Delay before moving horizontally.
ENTITIES.Swordy2.AI_BYTES[0x01]             = 0x0A                              -- Delay before moving vertically.
ENTITIES.Swordy2.AI_BYTES[0x02]             = 0x21                              -- Vertical speed delay.
ENTITIES.Swordy2.AI_BYTES[0x03]             = 0x3C                              -- Damage done by sword.
ENTITIES.Swordy2.AI_BYTES[0x1A852A]         = 0x26                              -- Delay after attack. This is shared with all other Swordy viruses in the same battle.
ENTITIES.Swordy2.BATTLE_NUMBERS             = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Swordy3                            = new_base_entity(ENTITY_KIND.Virus, "Swordy3")
ENTITIES.Swordy3.NAME                       = "Swordy3"
ENTITIES.Swordy3.HP_BASE                    = 220
ENTITIES.Swordy3.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_AQUA
ENTITIES.Swordy3.AI_BYTES                   = {}
ENTITIES.Swordy3.AI_BYTES[0x00]             = 0x28                              -- Delay before moving horizontally.
ENTITIES.Swordy3.AI_BYTES[0x01]             = 0x19                              -- Delay before moving vertically.
ENTITIES.Swordy3.AI_BYTES[0x02]             = 0x1C                              -- Vertical speed delay.
ENTITIES.Swordy3.AI_BYTES[0x03]             = 0x64                              -- Damage done by sword.
ENTITIES.Swordy3.AI_BYTES[0x1A8526]         = 0x26                              -- Delay after attack. This is shared with all other Swordy viruses in the same battle.
ENTITIES.Swordy3.BATTLE_NUMBERS             = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.SwordyOmega                        = new_base_entity(ENTITY_KIND.Virus, "SwordyOmega")
ENTITIES.SwordyOmega.NAME                   = "Swordy\003"
ENTITIES.SwordyOmega.HP_BASE                = 320
ENTITIES.SwordyOmega.ELEMENT                = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.SwordyOmega.AI_BYTES               = {}
ENTITIES.SwordyOmega.AI_BYTES[0x00]         = 0x28                              -- Delay before moving horizontally.
ENTITIES.SwordyOmega.AI_BYTES[0x01]         = 0x0A                              -- Delay before moving vertically.
ENTITIES.SwordyOmega.AI_BYTES[0x02]         = 0x0F                              -- Vertical speed delay.
ENTITIES.SwordyOmega.AI_BYTES[0x03]         = 0xC8                              -- Damage done by sword.
ENTITIES.SwordyOmega.AI_BYTES[0x1A8522]     = 0x26                              -- Delay after attack. This is shared with all other Swordy viruses in the same battle.
ENTITIES.SwordyOmega.BATTLE_NUMBERS         = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Ratty                              = new_base_entity(ENTITY_KIND.Virus, "Ratty")
ENTITIES.Ratty.NAME                         = "Ratty"
ENTITIES.Ratty.HP_BASE                      = 40
ENTITIES.Ratty.ELEMENT                      = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Ratty.AI_BYTES                     = {}
ENTITIES.Ratty.AI_BYTES[0x00]               = 0x0C                              -- Delay before movement.
ENTITIES.Ratty.AI_BYTES[0x01]               = 0x01                              -- Delay before movement (berserk).
ENTITIES.Ratty.AI_BYTES[0x02]               = 0x3C                              -- Delay after attack.
ENTITIES.Ratty.AI_BYTES[0x03]               = 0x1E                              -- Delay after attack (berserk).
ENTITIES.Ratty.AI_BYTES[0x04]               = 0x04                              -- Ratton's HP.
ENTITIES.Ratty.AI_BYTES[0x05]               = 0x14                              -- Ratton's damage.
ENTITIES.Ratty.AI_BYTES[0x06]               = 0x03                              -- Movement speed.
ENTITIES.Ratty.AI_BYTES[0x07]               = 0x06                              -- Movements before attack.
ENTITIES.Ratty.BATTLE_NUMBERS               = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Ratty2                             = new_base_entity(ENTITY_KIND.Virus, "Ratty2")
ENTITIES.Ratty2.NAME                        = "Ratty2"
ENTITIES.Ratty2.HP_BASE                     = 100
ENTITIES.Ratty2.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Ratty2.AI_BYTES                    = {}
ENTITIES.Ratty2.AI_BYTES[0x00]              = 0x0C                              -- Delay before movement.
ENTITIES.Ratty2.AI_BYTES[0x01]              = 0x01                              -- Delay before movement (berserk).
ENTITIES.Ratty2.AI_BYTES[0x02]              = 0x28                              -- Delay after attack.
ENTITIES.Ratty2.AI_BYTES[0x03]              = 0x14                              -- Delay after attack (berserk).
ENTITIES.Ratty2.AI_BYTES[0x04]              = 0x0A                              -- Ratton's HP.
ENTITIES.Ratty2.AI_BYTES[0x05]              = 0x32                              -- Ratton's damage.
ENTITIES.Ratty2.AI_BYTES[0x06]              = 0x04                              -- Movement speed.
ENTITIES.Ratty2.AI_BYTES[0x07]              = 0x05                              -- Movements before attack.
ENTITIES.Ratty2.BATTLE_NUMBERS              = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Ratty3                             = new_base_entity(ENTITY_KIND.Virus, "Ratty3")
ENTITIES.Ratty3.NAME                        = "Ratty3"
ENTITIES.Ratty3.HP_BASE                     = 160
ENTITIES.Ratty3.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Ratty3.AI_BYTES                    = {}
ENTITIES.Ratty3.AI_BYTES[0x00]              = 0x0C                              -- Delay before movement.
ENTITIES.Ratty3.AI_BYTES[0x01]              = 0x01                              -- Delay before movement (berserk).
ENTITIES.Ratty3.AI_BYTES[0x02]              = 0x28                              -- Delay after attack.
ENTITIES.Ratty3.AI_BYTES[0x03]              = 0x14                              -- Delay after attack (berserk).
ENTITIES.Ratty3.AI_BYTES[0x04]              = 0x28                              -- Ratton's HP.
ENTITIES.Ratty3.AI_BYTES[0x05]              = 0x50                              -- Ratton's damage.
ENTITIES.Ratty3.AI_BYTES[0x06]              = 0x05                              -- Movement speed.
ENTITIES.Ratty3.AI_BYTES[0x07]              = 0x04                              -- Movements before attack.
ENTITIES.Ratty3.BATTLE_NUMBERS              = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.RattyOmega                         = new_base_entity(ENTITY_KIND.Virus, "RattyOmega")
ENTITIES.RattyOmega.NAME                    = "Ratty\003"
ENTITIES.RattyOmega.HP_BASE                 = 230
ENTITIES.RattyOmega.ELEMENT                 = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.RattyOmega.AI_BYTES                = {}
ENTITIES.RattyOmega.AI_BYTES[0x00]          = 0x0C                              -- Delay before movement.
ENTITIES.RattyOmega.AI_BYTES[0x01]          = 0x01                              -- Delay before movement (berserk).
ENTITIES.RattyOmega.AI_BYTES[0x02]          = 0x28                              -- Delay after attack.
ENTITIES.RattyOmega.AI_BYTES[0x03]          = 0x14                              -- Delay after attack (berserk).
ENTITIES.RattyOmega.AI_BYTES[0x04]          = 0x50                              -- Ratton's HP.
ENTITIES.RattyOmega.AI_BYTES[0x05]          = 0x96                              -- Ratton's damage.
ENTITIES.RattyOmega.AI_BYTES[0x06]          = 0x05                              -- Movement speed.
ENTITIES.RattyOmega.AI_BYTES[0x07]          = 0x03                              -- Movements before attack.
ENTITIES.RattyOmega.BATTLE_NUMBERS          = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

local HardHead_BallType = 
{
    BREAK_BALL = 0x00,
    ICE_BALL = 0x01,
    LAVA_BALL = 0x02,
}


ENTITIES.HardHead                           = new_base_entity(ENTITY_KIND.Virus, "HardHead")
ENTITIES.HardHead.NAME                      = "HardHead"
ENTITIES.HardHead.HP_BASE                   = 80
ENTITIES.HardHead.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
--ENTITIES.HardHead.AI_BYTES                  = {}
--ENTITIES.HardHead.AI_BYTES[0x00]            = 0xF0                              -- Delay before shooting.
--ENTITIES.HardHead.AI_BYTES[0x01]            = 0x3C                              -- Damage hardball.
--ENTITIES.HardHead.AI_BYTES[0x02]            = HardHead_BallType.BREAK_BALL      -- Type of ball. 0x00 == break panel, 0x01 == ice ball, 0x02 == lava ball.
--ENTITIES.HardHead.AI_BYTES[0x14576]         = 0x32                              -- Delay before shooting (animation). Shared with other HardHead viruses in the same battle.
--ENTITIES.HardHead.AI_BYTES[0x14614]         = 0x1E                              -- Delay after attack. Shared with other HardHead viruses in the same battle.
ENTITIES.HardHead.BATTLE_NUMBERS            = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.ColdHead                           = new_base_entity(ENTITY_KIND.Virus, "ColdHead")
ENTITIES.ColdHead.NAME                      = "ColdHead"
ENTITIES.ColdHead.HP_BASE                   = 120
ENTITIES.ColdHead.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_AQUA
--ENTITIES.ColdHead.AI_BYTES                  = {}
--ENTITIES.ColdHead.AI_BYTES[0x00]            = 0x96                              -- Delay before shooting.
--ENTITIES.ColdHead.AI_BYTES[0x01]            = 0x64                              -- Damage hardball.
--ENTITIES.ColdHead.AI_BYTES[0x02]            = HardHead_BallType.ICE_BALL        -- Type of ball. 0x00 == break panel, 0x01 == ice ball, 0x02 == lava ball.
--ENTITIES.ColdHead.AI_BYTES[0x14573]         = 0x32                              -- Delay before shooting (animation). Shared with other HardHead viruses in the same battle.
--ENTITIES.ColdHead.AI_BYTES[0x14611]         = 0x1E                              -- Delay after attack. Shared with other HardHead viruses in the same battle.
ENTITIES.ColdHead.BATTLE_NUMBERS            = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.HotHead                            = new_base_entity(ENTITY_KIND.Virus, "HotHead")
ENTITIES.HotHead.NAME                       = "HotHead"
ENTITIES.HotHead.HP_BASE                    = 200
ENTITIES.HotHead.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT
--ENTITIES.HotHead.AI_BYTES                   = {}
--ENTITIES.HotHead.AI_BYTES[0x00]             = 0x5A                              -- Delay before shooting.
--ENTITIES.HotHead.AI_BYTES[0x01]             = 0x64                              -- Damage hardball.
--ENTITIES.HotHead.AI_BYTES[0x02]             = HardHead_BallType.LAVA_BALL       -- Type of ball. 0x00 == break panel, 0x01 == ice ball, 0x02 == lava ball.
--ENTITIES.HotHead.AI_BYTES[0x14570]          = 0x32                              -- Delay before shooting (animation). Shared with other HardHead viruses in the same battle.
--ENTITIES.HotHead.AI_BYTES[0x1460E]          = 0x1E                              -- Delay after attack. Shared with other HardHead viruses in the same battle.
ENTITIES.HotHead.BATTLE_NUMBERS             = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.HardHeadOmega                      = new_base_entity(ENTITY_KIND.Virus, "HardHeadOmega")
ENTITIES.HardHeadOmega.NAME                 = "HardHead\003"
ENTITIES.HardHeadOmega.HP_BASE              = 300
ENTITIES.HardHeadOmega.ELEMENT              = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
--ENTITIES.HardHeadOmega.AI_BYTES             = {}
--ENTITIES.HardHeadOmega.AI_BYTES[0x00]       = 0xF0                              -- Delay before shooting.
--ENTITIES.HardHeadOmega.AI_BYTES[0x01]       = 0xC8                              -- Damage hardball.
--ENTITIES.HardHeadOmega.AI_BYTES[0x02]       = HardHead_BallType.BREAK_BALL      -- Type of ball. 0x00 == break panel, 0x01 == ice ball, 0x02 == lava ball.
--ENTITIES.HardHeadOmega.AI_BYTES[0x1456D]    = 0x32                              -- Delay before shooting (animation). Shared with other HardHead viruses in the same battle.
--ENTITIES.HardHeadOmega.AI_BYTES[0x1460B]    = 0x1E                              -- Delay after attack. Shared with other HardHead viruses in the same battle.
ENTITIES.HardHeadOmega.BATTLE_NUMBERS       = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Jelly                              = new_base_entity(ENTITY_KIND.Virus, "Jelly")
ENTITIES.Jelly.NAME                         = "Jelly"
ENTITIES.Jelly.HP_BASE                      = 170
ENTITIES.Jelly.ELEMENT                      = ENTITY_ELEMENT_DEFS.ELEMENT_AQUA
ENTITIES.Jelly.AI_BYTES                     = {}
ENTITIES.Jelly.AI_BYTES[0x00]               = 0x04                              -- Number of risings before attack.
ENTITIES.Jelly.AI_BYTES[0x01]               = 0x32                              -- Damage by wave.
ENTITIES.Jelly.BATTLE_NUMBERS               = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.HeatJelly                          = new_base_entity(ENTITY_KIND.Virus, "HeatJelly")
ENTITIES.HeatJelly.NAME                     = "HeatJelly"
ENTITIES.HeatJelly.HP_BASE                  = 220
ENTITIES.HeatJelly.ELEMENT                  = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT
ENTITIES.HeatJelly.AI_BYTES                 = {}
ENTITIES.HeatJelly.AI_BYTES[0x00]           = 0x03                              -- Number of risings before attack.
ENTITIES.HeatJelly.AI_BYTES[0x01]           = 0x64                              -- Damage by wave.
ENTITIES.HeatJelly.BATTLE_NUMBERS           = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.EarthJelly                         = new_base_entity(ENTITY_KIND.Virus, "EarthJelly")
ENTITIES.EarthJelly.NAME                    = "ErthJelly"
ENTITIES.EarthJelly.HP_BASE                 = 270
ENTITIES.EarthJelly.ELEMENT                 = ENTITY_ELEMENT_DEFS.ELEMENT_WOOD
ENTITIES.EarthJelly.AI_BYTES                = {}
ENTITIES.EarthJelly.AI_BYTES[0x00]          = 0x03                              -- Number of risings before attack.
ENTITIES.EarthJelly.AI_BYTES[0x01]          = 0x96                              -- Damage by wave.
ENTITIES.EarthJelly.BATTLE_NUMBERS          = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.JellyOmega                         = new_base_entity(ENTITY_KIND.Virus, "JellyOmega")
ENTITIES.JellyOmega.NAME                    = "Jelly\003"
ENTITIES.JellyOmega.HP_BASE                 = 370
ENTITIES.JellyOmega.ELEMENT                 = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.JellyOmega.AI_BYTES                = {}
ENTITIES.JellyOmega.AI_BYTES[0x00]          = 0x02                              -- Number of risings before attack.
ENTITIES.JellyOmega.AI_BYTES[0x01]          = 0xC8                              -- Damage by wave.
ENTITIES.JellyOmega.BATTLE_NUMBERS          = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Shrimpy                            = new_base_entity(ENTITY_KIND.Virus, "Shrimpy")
ENTITIES.Shrimpy.NAME                       = "Shrimpy"
ENTITIES.Shrimpy.HP_BASE                    = 100
ENTITIES.Shrimpy.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_AQUA
ENTITIES.Shrimpy.AI_BYTES                   = {}
ENTITIES.Shrimpy.AI_BYTES[0x00]             = 0x1E                              -- Vertical speed.
ENTITIES.Shrimpy.AI_BYTES[0x01]             = 0x00                              -- Frequency of attacks (higher value == more frequent).
ENTITIES.Shrimpy.AI_BYTES[0x02]             = 0x1E                              -- Damage by bubble.
ENTITIES.Shrimpy.AI_BYTES[0xA20E]           = 0x10                              -- Delay after attack. This is shared with all other Shrimpy viruses in the same battle.
ENTITIES.Shrimpy.BATTLE_NUMBERS             = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Shrimpy2                           = new_base_entity(ENTITY_KIND.Virus, "Shrimpy2")
ENTITIES.Shrimpy2.NAME                      = "Shrimpy2"
ENTITIES.Shrimpy2.HP_BASE                   = 130
ENTITIES.Shrimpy2.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_AQUA
ENTITIES.Shrimpy2.AI_BYTES                  = {}
ENTITIES.Shrimpy2.AI_BYTES[0x00]            = 0x18                              -- Vertical speed.
ENTITIES.Shrimpy2.AI_BYTES[0x01]            = 0x01                              -- Frequency of attacks (higher value == more frequent).
ENTITIES.Shrimpy2.AI_BYTES[0x02]            = 0x3C                              -- Damage by bubble.
ENTITIES.Shrimpy2.AI_BYTES[0xA20B]          = 0x10                              -- Delay after attack. This is shared with all other Shrimpy viruses in the same battle.
ENTITIES.Shrimpy2.BATTLE_NUMBERS            = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Shrimpy3                           = new_base_entity(ENTITY_KIND.Virus, "Shrimpy3")
ENTITIES.Shrimpy3.NAME                      = "Shrimpy3"
ENTITIES.Shrimpy3.HP_BASE                   = 160
ENTITIES.Shrimpy3.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_AQUA
ENTITIES.Shrimpy3.AI_BYTES                  = {}
ENTITIES.Shrimpy3.AI_BYTES[0x00]            = 0x14                              -- Vertical speed.
ENTITIES.Shrimpy3.AI_BYTES[0x01]            = 0x02                              -- Frequency of attacks (higher value == more frequent).
ENTITIES.Shrimpy3.AI_BYTES[0x02]            = 0x5A                              -- Damage by bubble.
ENTITIES.Shrimpy3.AI_BYTES[0xA208]          = 0x10                              -- Delay after attack. This is shared with all other Shrimpy viruses in the same battle.
ENTITIES.Shrimpy3.BATTLE_NUMBERS            = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.ShrimpyOmega                       = new_base_entity(ENTITY_KIND.Virus, "ShrimpyOmega")
ENTITIES.ShrimpyOmega.NAME                  = "Shrimpy\003"
ENTITIES.ShrimpyOmega.HP_BASE               = 200
ENTITIES.ShrimpyOmega.ELEMENT               = ENTITY_ELEMENT_DEFS.ELEMENT_AQUA
ENTITIES.ShrimpyOmega.AI_BYTES              = {}
ENTITIES.ShrimpyOmega.AI_BYTES[0x00]        = 0x0F                              -- Vertical speed.
ENTITIES.ShrimpyOmega.AI_BYTES[0x01]        = 0x03                              -- Frequency of attacks (higher value == more frequent).
ENTITIES.ShrimpyOmega.AI_BYTES[0x02]        = 0x96                              -- Damage by bubble.
ENTITIES.ShrimpyOmega.AI_BYTES[0xA205]      = 0x10                              -- Delay after attack. This is shared with all other Shrimpy viruses in the same battle.
ENTITIES.ShrimpyOmega.BATTLE_NUMBERS        = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Spikey                             = new_base_entity(ENTITY_KIND.Virus, "Spikey")
ENTITIES.Spikey.NAME                        = "Spikey"
ENTITIES.Spikey.HP_BASE                     = 90
ENTITIES.Spikey.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT
ENTITIES.Spikey.AI_BYTES                    = {}
ENTITIES.Spikey.AI_BYTES[0x00]              = 0x3C                              -- Movement delay 1.
ENTITIES.Spikey.AI_BYTES[0x01]              = 0x32                              -- Movement delay 2.
ENTITIES.Spikey.AI_BYTES[0x02]              = 0x28                              -- Movement delay 3.
ENTITIES.Spikey.AI_BYTES[0x03]              = 0x1E                              -- Movement delay 4.
ENTITIES.Spikey.AI_BYTES[0x04]              = 0x3C                              -- Delay after attack.
ENTITIES.Spikey.AI_BYTES[0x05]              = 0x1E                              -- Damage fire.
ENTITIES.Spikey.AI_BYTES[0x06]              = 0x05                              -- Movements before attack.
ENTITIES.Spikey.AI_BYTES[0x07]              = 0x10                              -- Fireball speed delay.
ENTITIES.Spikey.BATTLE_NUMBERS              = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Spikey2                            = new_base_entity(ENTITY_KIND.Virus, "Spikey2")
ENTITIES.Spikey2.NAME                       = "Spikey2"
ENTITIES.Spikey2.HP_BASE                    = 140
ENTITIES.Spikey2.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT
ENTITIES.Spikey2.AI_BYTES                   = {}
ENTITIES.Spikey2.AI_BYTES[0x00]             = 0x32                              -- Movement delay 1.
ENTITIES.Spikey2.AI_BYTES[0x01]             = 0x28                              -- Movement delay 2.
ENTITIES.Spikey2.AI_BYTES[0x02]             = 0x1E                              -- Movement delay 3.
ENTITIES.Spikey2.AI_BYTES[0x03]             = 0x14                              -- Movement delay 4.
ENTITIES.Spikey2.AI_BYTES[0x04]             = 0x3C                              -- Delay after attack.
ENTITIES.Spikey2.AI_BYTES[0x05]             = 0x3C                              -- Damage fire.
ENTITIES.Spikey2.AI_BYTES[0x06]             = 0x04                              -- Movements before attack.
ENTITIES.Spikey2.AI_BYTES[0x07]             = 0x0A                              -- Fireball speed delay.
ENTITIES.Spikey2.BATTLE_NUMBERS             = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Spikey3                            = new_base_entity(ENTITY_KIND.Virus, "Spikey3")
ENTITIES.Spikey3.NAME                       = "Spikey3"
ENTITIES.Spikey3.HP_BASE                    = 190
ENTITIES.Spikey3.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT
ENTITIES.Spikey3.AI_BYTES                   = {}
ENTITIES.Spikey3.AI_BYTES[0x00]             = 0x2D                              -- Movement delay 1.
ENTITIES.Spikey3.AI_BYTES[0x01]             = 0x1E                              -- Movement delay 2.
ENTITIES.Spikey3.AI_BYTES[0x02]             = 0x14                              -- Movement delay 3.
ENTITIES.Spikey3.AI_BYTES[0x03]             = 0x0F                              -- Movement delay 4.
ENTITIES.Spikey3.AI_BYTES[0x04]             = 0x3C                              -- Delay after attack.
ENTITIES.Spikey3.AI_BYTES[0x05]             = 0x5A                              -- Damage fire.
ENTITIES.Spikey3.AI_BYTES[0x06]             = 0x03                              -- Movements before attack.
ENTITIES.Spikey3.AI_BYTES[0x07]             = 0x05                              -- Fireball speed delay.
ENTITIES.Spikey3.BATTLE_NUMBERS             = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.SpikeyOmega                        = new_base_entity(ENTITY_KIND.Virus, "SpikeyOmega")
ENTITIES.SpikeyOmega.NAME                   = "Spikey\003"
ENTITIES.SpikeyOmega.HP_BASE                = 260
ENTITIES.SpikeyOmega.ELEMENT                = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT
ENTITIES.SpikeyOmega.AI_BYTES               = {}
ENTITIES.SpikeyOmega.AI_BYTES[0x00]         = 0x1E                              -- Movement delay 1.
ENTITIES.SpikeyOmega.AI_BYTES[0x01]         = 0x12                              -- Movement delay 2.
ENTITIES.SpikeyOmega.AI_BYTES[0x02]         = 0x0D                              -- Movement delay 3.
ENTITIES.SpikeyOmega.AI_BYTES[0x03]         = 0x0A                              -- Movement delay 4.
ENTITIES.SpikeyOmega.AI_BYTES[0x04]         = 0x3C                              -- Delay after attack.
ENTITIES.SpikeyOmega.AI_BYTES[0x05]         = 0x96                              -- Damage fire.
ENTITIES.SpikeyOmega.AI_BYTES[0x06]         = 0x03                              -- Movements before attack.
ENTITIES.SpikeyOmega.AI_BYTES[0x07]         = 0x03                              -- Fireball speed delay.
ENTITIES.SpikeyOmega.BATTLE_NUMBERS         = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Bunny                              = new_base_entity(ENTITY_KIND.Virus, "Bunny")
ENTITIES.Bunny.NAME                         = "Bunny"
ENTITIES.Bunny.HP_BASE                      = 40
ENTITIES.Bunny.ELEMENT                      = ENTITY_ELEMENT_DEFS.ELEMENT_ELEC
ENTITIES.Bunny.AI_BYTES                     = {}
ENTITIES.Bunny.AI_BYTES[0x00]               = 0x1E                              -- Delay before movement.
ENTITIES.Bunny.AI_BYTES[0x01]               = 0x32                              -- Delay after attack.
ENTITIES.Bunny.AI_BYTES[0x02]               = 0x0F                              -- Damage ElecRing.
ENTITIES.Bunny.BATTLE_NUMBERS               = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.TuffBunny                          = new_base_entity(ENTITY_KIND.Virus, "TuffBunny")
ENTITIES.TuffBunny.NAME                     = "TuffBunny"
ENTITIES.TuffBunny.HP_BASE                  = 60
ENTITIES.TuffBunny.ELEMENT                  = ENTITY_ELEMENT_DEFS.ELEMENT_ELEC
ENTITIES.TuffBunny.AI_BYTES                 = {}
ENTITIES.TuffBunny.AI_BYTES[0x00]           = 0x16                              -- Delay before movement.
ENTITIES.TuffBunny.AI_BYTES[0x01]           = 0x28                              -- Delay after attack.
ENTITIES.TuffBunny.AI_BYTES[0x02]           = 0x3C                              -- Damage ElecRing.
ENTITIES.TuffBunny.BATTLE_NUMBERS           = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.MegaBunny                          = new_base_entity(ENTITY_KIND.Virus, "MegaBunny")
ENTITIES.MegaBunny.NAME                     = "MegaBunny"
ENTITIES.MegaBunny.HP_BASE                  = 160
ENTITIES.MegaBunny.ELEMENT                  = ENTITY_ELEMENT_DEFS.ELEMENT_ELEC
ENTITIES.MegaBunny.AI_BYTES                 = {}
ENTITIES.MegaBunny.AI_BYTES[0x00]           = 0x0E                              -- Delay before movement.
ENTITIES.MegaBunny.AI_BYTES[0x01]           = 0x1E                              -- Delay after attack.
ENTITIES.MegaBunny.AI_BYTES[0x02]           = 0x5A                              -- Damage ElecRing.
ENTITIES.MegaBunny.BATTLE_NUMBERS           = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.BunnyOmega                         = new_base_entity(ENTITY_KIND.Virus, "BunnyOmega") 
ENTITIES.BunnyOmega.NAME                    = "Bunny\003"
ENTITIES.BunnyOmega.HP_BASE                 = 220
ENTITIES.BunnyOmega.ELEMENT                 = ENTITY_ELEMENT_DEFS.ELEMENT_ELEC
ENTITIES.BunnyOmega.AI_BYTES                = {}
ENTITIES.BunnyOmega.AI_BYTES[0x00]          = 0x0A                              -- Delay before movement.
ENTITIES.BunnyOmega.AI_BYTES[0x01]          = 0x0F                              -- Delay after attack.
ENTITIES.BunnyOmega.AI_BYTES[0x02]          = 0x96                              -- Damage ElecRing.
ENTITIES.BunnyOmega.BATTLE_NUMBERS          = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

local WindBox_WindType = 
{
    WIND = 0x00,
    FAN = 0x01,
}


ENTITIES.WindBox                            = new_base_entity(ENTITY_KIND.Virus, "WindBox")
ENTITIES.WindBox.NAME                       = "WindBox"
ENTITIES.WindBox.HP_BASE                    = 100
ENTITIES.WindBox.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.WindBox.AI_BYTES                   = {}
ENTITIES.WindBox.AI_BYTES[0x00]             = 0x01                              -- (??) Always 0x01.
ENTITIES.WindBox.AI_BYTES[0x01]             = WindBox_WindType.WIND             -- Wind Type (0x00 == Wind, 0x01 == Fan).
ENTITIES.WindBox.AI_BYTES[0x02]             = 0x0A                              -- (??) Always 0x0A.
ENTITIES.WindBox.BATTLE_NUMBERS             = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.VacuumFan                          = new_base_entity(ENTITY_KIND.Virus, "VacuumFan")
ENTITIES.VacuumFan.NAME                     = "VacuumFan"
ENTITIES.VacuumFan.HP_BASE                  = 100
ENTITIES.VacuumFan.ELEMENT                  = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.VacuumFan.AI_BYTES                 = {}
ENTITIES.VacuumFan.AI_BYTES[0x00]           = 0x01                              -- (??) Always 0x01.
ENTITIES.VacuumFan.AI_BYTES[0x01]           = WindBox_WindType.FAN              -- Wind Type (0x00 == Wind, 0x01 == Fan).
ENTITIES.VacuumFan.AI_BYTES[0x02]           = 0x0A                              -- (??) Always 0x0A.
ENTITIES.VacuumFan.BATTLE_NUMBERS           = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.StormBox                           = new_base_entity(ENTITY_KIND.Virus, "StormBox")
ENTITIES.StormBox.NAME                      = "StormBox"
ENTITIES.StormBox.HP_BASE                   = 300
ENTITIES.StormBox.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.StormBox.AI_BYTES                  = {}
ENTITIES.StormBox.AI_BYTES[0x00]            = 0x01                              -- (??) Always 0x01.
ENTITIES.StormBox.AI_BYTES[0x01]            = WindBox_WindType.WIND             -- Wind Type (0x00 == Wind, 0x01 == Fan).
ENTITIES.StormBox.AI_BYTES[0x02]            = 0x0A                              -- (??) Always 0x0A.
ENTITIES.StormBox.BATTLE_NUMBERS            = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.WindBoxOmega                       = new_base_entity(ENTITY_KIND.Virus, "WindBoxOmega")
ENTITIES.WindBoxOmega.NAME                  = "WindBox\003"
ENTITIES.WindBoxOmega.HP_BASE               = 500
ENTITIES.WindBoxOmega.ELEMENT               = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.WindBoxOmega.AI_BYTES              = {}
ENTITIES.WindBoxOmega.AI_BYTES[0x00]        = 0x01                              -- (??) Always 0x01.
ENTITIES.WindBoxOmega.AI_BYTES[0x01]        = WindBox_WindType.FAN             -- Wind Type (0x00 == Wind, 0x01 == Fan).
ENTITIES.WindBoxOmega.AI_BYTES[0x02]        = 0x0A                              -- (??) Always 0x0A.
ENTITIES.WindBoxOmega.BATTLE_NUMBERS        = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.PuffBall                           = new_base_entity(ENTITY_KIND.Virus, "PuffBall")
ENTITIES.PuffBall.NAME                      = "PuffBall"
ENTITIES.PuffBall.HP_BASE                   = 120
ENTITIES.PuffBall.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_WOOD
ENTITIES.PuffBall.AI_BYTES                  = {}
ENTITIES.PuffBall.AI_BYTES[0x00]            = 0x3C                              -- Movement delay 1.
ENTITIES.PuffBall.AI_BYTES[0x01]            = 0x32                              -- Movement delay 2.
ENTITIES.PuffBall.AI_BYTES[0x02]            = 0x32                              -- Damage by contact with mask.
ENTITIES.PuffBall.AI_BYTES[0x03]            = 0x4B                              -- Duration of poison mask.
ENTITIES.PuffBall.BATTLE_NUMBERS            = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.PoofBall                           = new_base_entity(ENTITY_KIND.Virus, "PoofBall")
ENTITIES.PoofBall.NAME                      = "PoofBall"
ENTITIES.PoofBall.HP_BASE                   = 220
ENTITIES.PoofBall.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_WOOD
ENTITIES.PoofBall.AI_BYTES                  = {}
ENTITIES.PoofBall.AI_BYTES[0x00]            = 0x3C                              -- Movement delay 1.
ENTITIES.PoofBall.AI_BYTES[0x01]            = 0x28                              -- Movement delay 2.
ENTITIES.PoofBall.AI_BYTES[0x02]            = 0x50                              -- Damage by contact with mask.
ENTITIES.PoofBall.AI_BYTES[0x03]            = 0x78                              -- Duration of poison mask.
ENTITIES.PoofBall.BATTLE_NUMBERS            = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.GoofBall                           = new_base_entity(ENTITY_KIND.Virus, "GoofBall")
ENTITIES.GoofBall.NAME                      = "GoofBall"
ENTITIES.GoofBall.HP_BASE                   = 280
ENTITIES.GoofBall.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_WOOD
ENTITIES.GoofBall.AI_BYTES                  = {}
ENTITIES.GoofBall.AI_BYTES[0x00]            = 0x3C                              -- Movement delay 1.
ENTITIES.GoofBall.AI_BYTES[0x01]            = 0x1E                              -- Movement delay 2.
ENTITIES.GoofBall.AI_BYTES[0x02]            = 0x78                              -- Damage by contact with mask.
ENTITIES.GoofBall.AI_BYTES[0x03]            = 0x96                              -- Duration of poison mask.
ENTITIES.GoofBall.BATTLE_NUMBERS            = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.PuffBallOmega                      = new_base_entity(ENTITY_KIND.Virus, "PuffBallOmega")
ENTITIES.PuffBallOmega.NAME                 = "PuffBall\003"
ENTITIES.PuffBallOmega.HP_BASE              = 400
ENTITIES.PuffBallOmega.ELEMENT              = ENTITY_ELEMENT_DEFS.ELEMENT_WOOD
ENTITIES.PuffBallOmega.AI_BYTES             = {}
ENTITIES.PuffBallOmega.AI_BYTES[0x00]       = 0x3C                              -- Movement delay 1.
ENTITIES.PuffBallOmega.AI_BYTES[0x01]       = 0x19                              -- Movement delay 2.
ENTITIES.PuffBallOmega.AI_BYTES[0x02]       = 0xC8                              -- Damage by contact with mask.
ENTITIES.PuffBallOmega.AI_BYTES[0x03]       = 0x96                              -- Duration of poison mask.
ENTITIES.PuffBallOmega.BATTLE_NUMBERS       = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Mushy                              = new_base_entity(ENTITY_KIND.Virus, "Mushy")
ENTITIES.Mushy.NAME                         = "Mushy"
ENTITIES.Mushy.HP_BASE                      = 50
ENTITIES.Mushy.ELEMENT                      = ENTITY_ELEMENT_DEFS.ELEMENT_WOOD
ENTITIES.Mushy.AI_BYTES                     = {}
ENTITIES.Mushy.AI_BYTES[0x00]               = 0x1E                              -- Movement delay 1.
ENTITIES.Mushy.AI_BYTES[0x01]               = 0x0F                              -- (??).
ENTITIES.Mushy.AI_BYTES[0x02]               = 0x32                              -- Damage by contact and spice.
ENTITIES.Mushy.AI_BYTES[0x03]               = 0x00                              -- (??).
ENTITIES.Mushy.BATTLE_NUMBERS               = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Mashy                              = new_base_entity(ENTITY_KIND.Virus, "Mashy")
ENTITIES.Mashy.NAME                         = "Mashy"
ENTITIES.Mashy.HP_BASE                      = 100
ENTITIES.Mashy.ELEMENT                      = ENTITY_ELEMENT_DEFS.ELEMENT_WOOD
ENTITIES.Mashy.AI_BYTES                     = {}
ENTITIES.Mashy.AI_BYTES[0x00]               = 0x16                              -- Movement delay 1.
ENTITIES.Mashy.AI_BYTES[0x01]               = 0x0F                              -- (??).
ENTITIES.Mashy.AI_BYTES[0x02]               = 0x50                              -- Damage by contact and spice.
ENTITIES.Mashy.AI_BYTES[0x03]               = 0x00                              -- (??).
ENTITIES.Mashy.BATTLE_NUMBERS               = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Moshy                              = new_base_entity(ENTITY_KIND.Virus, "Moshy")
ENTITIES.Moshy.NAME                         = "Moshy"
ENTITIES.Moshy.HP_BASE                      = 160
ENTITIES.Moshy.ELEMENT                      = ENTITY_ELEMENT_DEFS.ELEMENT_WOOD
ENTITIES.Moshy.AI_BYTES                     = {}
ENTITIES.Moshy.AI_BYTES[0x00]               = 0x10                              -- Movement delay 1.
ENTITIES.Moshy.AI_BYTES[0x01]               = 0x0F                              -- (??).
ENTITIES.Moshy.AI_BYTES[0x02]               = 0x78                              -- Damage by contact and spice.
ENTITIES.Moshy.AI_BYTES[0x03]               = 0x01                              -- (??).
ENTITIES.Moshy.BATTLE_NUMBERS               = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.MushyOmega                         = new_base_entity(ENTITY_KIND.Virus, "MushyOmega") 
ENTITIES.MushyOmega.NAME                    = "Mushy\003"
ENTITIES.MushyOmega.HP_BASE                 = 200
ENTITIES.MushyOmega.ELEMENT                 = ENTITY_ELEMENT_DEFS.ELEMENT_WOOD
ENTITIES.MushyOmega.AI_BYTES                = {}
ENTITIES.MushyOmega.AI_BYTES[0x00]          = 0x0A                              -- Movement delay 1.
ENTITIES.MushyOmega.AI_BYTES[0x01]          = 0x0F                              -- (??).
ENTITIES.MushyOmega.AI_BYTES[0x02]          = 0xC8                              -- Damage by contact and spice.
ENTITIES.MushyOmega.AI_BYTES[0x03]          = 0x01                              -- (??).
ENTITIES.MushyOmega.BATTLE_NUMBERS          = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Dominerd                           = new_base_entity(ENTITY_KIND.Virus, "Dominerd")
ENTITIES.Dominerd.NAME                      = "Dominerd"
ENTITIES.Dominerd.HP_BASE                   = 100
ENTITIES.Dominerd.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Dominerd.AI_BYTES                  = {}
ENTITIES.Dominerd.AI_BYTES[0x00]            = 0x14                              -- Delay before counter.
ENTITIES.Dominerd.AI_BYTES[0x01]            = 0x0A                              -- Delay before attack without counter.
ENTITIES.Dominerd.AI_BYTES[0x02]            = 0x50                              -- Vertical boundaries?
ENTITIES.Dominerd.AI_BYTES[0x03]            = 0x00                              -- Number of Geddon1 chips.
ENTITIES.Dominerd.AI_BYTES[0x04]            = 0x03                              -- Attacks before using Geddon1.
ENTITIES.Dominerd.AI_BYTES[0x05]            = 0x10                              -- Delay after attack (own field).
ENTITIES.Dominerd.AI_BYTES[0x06]            = 0x06                              -- Delay after attack (enemy field).
ENTITIES.Dominerd.AI_BYTES[0x07]            = 0x32                              -- Damage.
ENTITIES.Dominerd.AI_BYTES[0x08]            = 0xCC                              -- Vertical speed.
ENTITIES.Dominerd.AI_BYTES[0x1603C]         = TIME_FREEZE_CHIP_DEFS.Geddon.FAMILY      -- Chip Family. This is shared between other Dominerd viruses in the same battle.
ENTITIES.Dominerd.AI_BYTES[0x1603E]         = TIME_FREEZE_CHIP_DEFS.Geddon.SUBFAMILY   -- Chip Subfamily. This is shared between other Dominerd viruses in the same battle.
ENTITIES.Dominerd.AI_BYTES[0x16042]         = 0x00                              -- Chip Damage. This is shared between other Dominerd viruses in the same battle.
ENTITIES.Dominerd.BATTLE_NUMBERS            = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Dominerd2                          = new_base_entity(ENTITY_KIND.Virus, "Dominerd2")
ENTITIES.Dominerd2.NAME                     = "Dominerd2"
ENTITIES.Dominerd2.HP_BASE                  = 170
ENTITIES.Dominerd2.ELEMENT                  = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Dominerd2.AI_BYTES                 = {}
ENTITIES.Dominerd2.AI_BYTES[0x00]           = 0x0A                              -- Delay before counter.
ENTITIES.Dominerd2.AI_BYTES[0x01]           = 0x3C                              -- Delay before attack without counter.
ENTITIES.Dominerd2.AI_BYTES[0x02]           = 0x30                              -- Vertical boundaries?
ENTITIES.Dominerd2.AI_BYTES[0x03]           = 0x00                              -- Number of Geddon1 chips.
ENTITIES.Dominerd2.AI_BYTES[0x04]           = 0x03                              -- Attacks before using Geddon1.
ENTITIES.Dominerd2.AI_BYTES[0x05]           = 0x0E                              -- Delay after attack (own field).
ENTITIES.Dominerd2.AI_BYTES[0x06]           = 0x00                              -- Delay after attack (enemy field).
ENTITIES.Dominerd2.AI_BYTES[0x07]           = 0x64                              -- Damage.
ENTITIES.Dominerd2.AI_BYTES[0x08]           = 0x00                              -- Vertical speed.
ENTITIES.Dominerd2.AI_BYTES[0x16030]        = TIME_FREEZE_CHIP_DEFS.Geddon.FAMILY      -- Chip Family. This is shared between other Dominerd viruses in the same battle.
ENTITIES.Dominerd2.AI_BYTES[0x16032]        = TIME_FREEZE_CHIP_DEFS.Geddon.SUBFAMILY   -- Chip Subfamily. This is shared between other Dominerd viruses in the same battle.
ENTITIES.Dominerd2.AI_BYTES[0x16036]        = 0x00                              -- Chip Damage. This is shared between other Dominerd viruses in the same battle.
ENTITIES.Dominerd2.BATTLE_NUMBERS           = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Dominerd3                          = new_base_entity(ENTITY_KIND.Virus, "Dominerd3")
ENTITIES.Dominerd3.NAME                     = "Dominerd3"
ENTITIES.Dominerd3.HP_BASE                  = 220
ENTITIES.Dominerd3.ELEMENT                  = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Dominerd3.AI_BYTES                 = {}
ENTITIES.Dominerd3.AI_BYTES[0x00]           = 0x04                              -- Delay before counter.
ENTITIES.Dominerd3.AI_BYTES[0x01]           = 0x3C                              -- Delay before attack without counter.
ENTITIES.Dominerd3.AI_BYTES[0x02]           = 0x22                              -- Vertical boundaries?
ENTITIES.Dominerd3.AI_BYTES[0x03]           = 0x01                              -- Number of Geddon1 chips.
ENTITIES.Dominerd3.AI_BYTES[0x04]           = 0x01                              -- Attacks before using Geddon1.
ENTITIES.Dominerd3.AI_BYTES[0x05]           = 0x07                              -- Delay after attack (own field).
ENTITIES.Dominerd3.AI_BYTES[0x06]           = 0x00                              -- Delay after attack (enemy field).
ENTITIES.Dominerd3.AI_BYTES[0x07]           = 0x96                              -- Damage.
ENTITIES.Dominerd3.AI_BYTES[0x08]           = 0x33                              -- Vertical speed.
ENTITIES.Dominerd3.AI_BYTES[0x16024]        = TIME_FREEZE_CHIP_DEFS.Geddon.FAMILY      -- Chip Family. This is shared between other Dominerd viruses in the same battle.
ENTITIES.Dominerd3.AI_BYTES[0x16026]        = TIME_FREEZE_CHIP_DEFS.Geddon.SUBFAMILY   -- Chip Subfamily. This is shared between other Dominerd viruses in the same battle.
ENTITIES.Dominerd3.AI_BYTES[0x1602A]        = 0x00                              -- Chip Damage. This is shared between other Dominerd viruses in the same battle.
ENTITIES.Dominerd3.BATTLE_NUMBERS           = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.DominerdOmega                      = new_base_entity(ENTITY_KIND.Virus, "DominerdOmega")
ENTITIES.DominerdOmega.NAME                 = "Dominerd\003"
ENTITIES.DominerdOmega.HP_BASE              = 300
ENTITIES.DominerdOmega.ELEMENT              = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.DominerdOmega.AI_BYTES             = {}
ENTITIES.DominerdOmega.AI_BYTES[0x00]       = 0x04                              -- Delay before counter.
ENTITIES.DominerdOmega.AI_BYTES[0x01]       = 0x0A                              -- Delay before attack without counter.
ENTITIES.DominerdOmega.AI_BYTES[0x02]       = 0x22                              -- Vertical boundaries?
ENTITIES.DominerdOmega.AI_BYTES[0x03]       = 0x01                              -- Number of Geddon1 chips.
ENTITIES.DominerdOmega.AI_BYTES[0x04]       = 0x03                              -- Attacks before using Geddon1.
ENTITIES.DominerdOmega.AI_BYTES[0x05]       = 0x10                              -- Delay after attack (own field).
ENTITIES.DominerdOmega.AI_BYTES[0x06]       = 0x03                              -- Delay after attack (enemy field).
ENTITIES.DominerdOmega.AI_BYTES[0x07]       = 0xC8                              -- Damage.
ENTITIES.DominerdOmega.AI_BYTES[0x08]       = 0x33                              -- Vertical speed.
ENTITIES.DominerdOmega.AI_BYTES[0x16018]    = TIME_FREEZE_CHIP_DEFS.Geddon.FAMILY      -- Chip Family. This is shared between other Dominerd viruses in the same battle.
ENTITIES.DominerdOmega.AI_BYTES[0x1601A]    = TIME_FREEZE_CHIP_DEFS.Geddon.SUBFAMILY   -- Chip Subfamily. This is shared between other Dominerd viruses in the same battle.
ENTITIES.DominerdOmega.AI_BYTES[0x1601E]    = 0x00                              -- Chip Damage. This is shared between other Dominerd viruses in the same battle.
ENTITIES.DominerdOmega.BATTLE_NUMBERS       = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Yort                               = new_base_entity(ENTITY_KIND.Virus, "Yort")
ENTITIES.Yort.NAME                          = "Yort"
ENTITIES.Yort.HP_BASE                       = 120
ENTITIES.Yort.ELEMENT                       = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Yort.AI_BYTES                      = {}
ENTITIES.Yort.AI_BYTES[0x00]                = 0x1E                              -- Movement variable 1.
ENTITIES.Yort.AI_BYTES[0x01]                = 0x01                              -- Delay after attack.
ENTITIES.Yort.AI_BYTES[0x02]                = 0x14                              -- Damage by single hit (Byte 1).
ENTITIES.Yort.AI_BYTES[0x03]                = 0x00                              -- Damage by single hit (Byte 2).
ENTITIES.Yort.AI_BYTES[0x04]                = 0xCC                              -- Movement variable 2  (Byte 1).
ENTITIES.Yort.AI_BYTES[0x05]                = 0xCC                              -- Movement variable 2  (Byte 2).
ENTITIES.Yort.AI_BYTES[0x06]                = 0x00                              -- Movement variable 2  (Byte 3).
ENTITIES.Yort.AI_BYTES[0x07]                = 0x00                              -- Movement variable 2  (Byte 4).
ENTITIES.Yort.BATTLE_NUMBERS                = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Yurt                               = new_base_entity(ENTITY_KIND.Virus, "Yurt")
ENTITIES.Yurt.NAME                          = "Yurt"
ENTITIES.Yurt.HP_BASE                       = 160
ENTITIES.Yurt.ELEMENT                       = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Yurt.AI_BYTES                      = {}
ENTITIES.Yurt.AI_BYTES[0x00]                = 0x14                              -- Movement variable 1.
ENTITIES.Yurt.AI_BYTES[0x01]                = 0x01                              -- Delay after attack.
ENTITIES.Yurt.AI_BYTES[0x02]                = 0x28                              -- Damage by single hit (Byte 1).
ENTITIES.Yurt.AI_BYTES[0x03]                = 0x00                              -- Damage by single hit (Byte 2).
ENTITIES.Yurt.AI_BYTES[0x04]                = 0x33                              -- Movement variable 2  (Byte 1).
ENTITIES.Yurt.AI_BYTES[0x05]                = 0x33                              -- Movement variable 2  (Byte 2).
ENTITIES.Yurt.AI_BYTES[0x06]                = 0x01                              -- Movement variable 2  (Byte 3).
ENTITIES.Yurt.AI_BYTES[0x07]                = 0x00                              -- Movement variable 2  (Byte 4).
ENTITIES.Yurt.BATTLE_NUMBERS                = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Yart                               = new_base_entity(ENTITY_KIND.Virus, "Yart")
ENTITIES.Yart.NAME                          = "Yart"
ENTITIES.Yart.HP_BASE                       = 210
ENTITIES.Yart.ELEMENT                       = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Yart.AI_BYTES                      = {}
ENTITIES.Yart.AI_BYTES[0x00]                = 0x0F                              -- Movement variable 1.
ENTITIES.Yart.AI_BYTES[0x01]                = 0x01                              -- Delay after attack.
ENTITIES.Yart.AI_BYTES[0x02]                = 0x3C                              -- Damage by single hit (Byte 1).
ENTITIES.Yart.AI_BYTES[0x03]                = 0x00                              -- Damage by single hit (Byte 2).
ENTITIES.Yart.AI_BYTES[0x04]                = 0x99                              -- Movement variable 2  (Byte 1).
ENTITIES.Yart.AI_BYTES[0x05]                = 0x99                              -- Movement variable 2  (Byte 2).
ENTITIES.Yart.AI_BYTES[0x06]                = 0x01                              -- Movement variable 2  (Byte 3).
ENTITIES.Yart.AI_BYTES[0x07]                = 0x00                              -- Movement variable 2  (Byte 4).
ENTITIES.Yart.BATTLE_NUMBERS                = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.YortOmega                          = new_base_entity(ENTITY_KIND.Virus, "YortOmega")
ENTITIES.YortOmega.NAME                     = "Yort\003"
ENTITIES.YortOmega.HP_BASE                  = 320
ENTITIES.YortOmega.ELEMENT                  = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.YortOmega.AI_BYTES                 = {}
ENTITIES.YortOmega.AI_BYTES[0x00]           = 0x0C                              -- Movement variable 1.
ENTITIES.YortOmega.AI_BYTES[0x01]           = 0x01                              -- Delay after attack.
ENTITIES.YortOmega.AI_BYTES[0x02]           = 0x50                              -- Damage by single hit (Byte 1).
ENTITIES.YortOmega.AI_BYTES[0x03]           = 0x00                              -- Damage by single hit (Byte 2).
ENTITIES.YortOmega.AI_BYTES[0x04]           = 0x00                              -- Movement variable 2  (Byte 1).
ENTITIES.YortOmega.AI_BYTES[0x05]           = 0x00                              -- Movement variable 2  (Byte 2).
ENTITIES.YortOmega.AI_BYTES[0x06]           = 0x02                              -- Movement variable 2  (Byte 3).
ENTITIES.YortOmega.AI_BYTES[0x07]           = 0x00                              -- Movement variable 2  (Byte 4).
ENTITIES.YortOmega.BATTLE_NUMBERS           = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Shadow                             = new_base_entity(ENTITY_KIND.Virus, "Shadow")
ENTITIES.Shadow.NAME                        = "Shadow"
ENTITIES.Shadow.HP_BASE                     = 130
ENTITIES.Shadow.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Shadow.AI_BYTES                    = {}
ENTITIES.Shadow.AI_BYTES[0x00]              = 0x03                              -- Number of attacks.
ENTITIES.Shadow.AI_BYTES[0x01]              = 0x78                              -- Delay between attacks.
ENTITIES.Shadow.AI_BYTES[0x02]              = 0x32                              -- Damage.
ENTITIES.Shadow.AI_BYTES[0x17DF0]           = 0x28                              -- Delay before sword 1-2. This is shared with other Shadow viruses in the same battle.
ENTITIES.Shadow.AI_BYTES[0x17E1E]           = 0x0C                              -- Vertical attack duration (0x0C == 1 panel, 0x18 == 2 panels). This is shared with other Shadow viruses in the same battle.
ENTITIES.Shadow.AI_BYTES[0x17D24]           = 0x1E                              -- Delay before axe. This is shared with other Shadow viruses in the same battle.
--ENTITIES.Shadow.BATTLE_NUMBERS              = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.
--TODO: find some way to intelligently implement Shadow viruses early
ENTITIES.RedDevil                           = new_base_entity(ENTITY_KIND.Virus, "RedDevil")
ENTITIES.RedDevil.NAME                      = "RedDevil"
ENTITIES.RedDevil.HP_BASE                   = 170
ENTITIES.RedDevil.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.RedDevil.AI_BYTES                  = {}
ENTITIES.RedDevil.AI_BYTES[0x00]            = 0x06                              -- Number of attacks.
ENTITIES.RedDevil.AI_BYTES[0x01]            = 0x5A                              -- Delay between attacks.
ENTITIES.RedDevil.AI_BYTES[0x02]            = 0x64                              -- Damage.
ENTITIES.RedDevil.AI_BYTES[0x17DED]         = 0x28                              -- Delay before sword 1-2. This is shared with other RedDevil viruses in the same battle.
ENTITIES.RedDevil.AI_BYTES[0x17E1B]         = 0x0C                              -- Vertical attack duration (0x0C == 1 panel, 0x18 == 2 panels). This is shared with other RedDevil viruses in the same battle.
ENTITIES.RedDevil.AI_BYTES[0x17D21]         = 0x1E                              -- Delay before axe. This is shared with other RedDevil viruses in the same battle.
--ENTITIES.RedDevil.BATTLE_NUMBERS            = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.
--TODO: find some way to intelligently implement Shadow viruses early
ENTITIES.BlueDemon                          = new_base_entity(ENTITY_KIND.Virus, "BlueDemon")
ENTITIES.BlueDemon.NAME                     = "BlueDemon"
ENTITIES.BlueDemon.HP_BASE                  = 210
ENTITIES.BlueDemon.ELEMENT                  = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.BlueDemon.AI_BYTES                 = {}
ENTITIES.BlueDemon.AI_BYTES[0x00]           = 0x09                              -- Number of attacks.
ENTITIES.BlueDemon.AI_BYTES[0x01]           = 0x3C                              -- Delay between attacks.
ENTITIES.BlueDemon.AI_BYTES[0x02]           = 0x96                              -- Damage.
ENTITIES.BlueDemon.AI_BYTES[0x17DEA]        = 0x28                              -- Delay before sword 1-2. This is shared with other BlueDemon viruses in the same battle.
ENTITIES.BlueDemon.AI_BYTES[0x17E18]        = 0x0C                              -- Vertical attack duration (0x0C == 1 panel, 0x18 == 2 panels). This is shared with other BlueDemon viruses in the same battle.
ENTITIES.BlueDemon.AI_BYTES[0x17D1E]        = 0x1E                              -- Delay before axe. This is shared with other BlueDemon viruses in the same battle.
ENTITIES.BlueDemon.BATTLE_NUMBERS           = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.ShadowOmega                        = new_base_entity(ENTITY_KIND.Virus, "ShadowOmega")
ENTITIES.ShadowOmega.NAME                   = "Shadow\003"
ENTITIES.ShadowOmega.HP_BASE                = 250
ENTITIES.ShadowOmega.ELEMENT                = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.ShadowOmega.AI_BYTES               = {}
ENTITIES.ShadowOmega.AI_BYTES[0x00]         = 0x0C                              -- Number of attacks.
ENTITIES.ShadowOmega.AI_BYTES[0x01]         = 0x2D                              -- Delay between attacks.
ENTITIES.ShadowOmega.AI_BYTES[0x02]         = 0xC8                              -- Damage.
ENTITIES.ShadowOmega.AI_BYTES[0x17DE7]      = 0x28                              -- Delay before sword 1-2. This is shared with other Shadow viruses in the same battle.
ENTITIES.ShadowOmega.AI_BYTES[0x17E15]      = 0x0C                              -- Vertical attack duration (0x0C == 1 panel, 0x18 == 2 panels). This is shared with other Shadow viruses in the same battle.
ENTITIES.ShadowOmega.AI_BYTES[0x17D1B]      = 0x1E                              -- Delay before axe. This is shared with other Shadow viruses in the same battle.
ENTITIES.ShadowOmega.BATTLE_NUMBERS         = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

local BrushMan_PanelType = 
{
    NONE = 0x00,
    BROKEN = 0x01,
    NORMAL = 0x02,
    CRACKED = 0x03,
    POISON = 0x04,
    METAL = 0x05,
    GRASS = 0x06,
    ICE = 0x07,
    LAVA = 0x08,
    HOLY = 0x09,
    SAND = 0x0A
}

ENTITIES.BrushMan                           = new_base_entity(ENTITY_KIND.Virus, "BrushMan")
ENTITIES.BrushMan.NAME                      = "BrushMan"
ENTITIES.BrushMan.HP_BASE                   = 120
ENTITIES.BrushMan.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.BrushMan.AI_BYTES                  = {}
ENTITIES.BrushMan.AI_BYTES[0x00]            = 0x78                              -- Delay before attack / movement.
ENTITIES.BrushMan.AI_BYTES[0x01]            = 0x01                              -- Number of holy panels in a row (own field).
ENTITIES.BrushMan.AI_BYTES[0x02]            = BrushMan_PanelType.POISON         -- Type of panel 1 (enemy field).
ENTITIES.BrushMan.AI_BYTES[0x03]            = BrushMan_PanelType.SAND           -- Type of panel 2 (enemy field).
ENTITIES.BrushMan.AI_BYTES[0x04]            = 0x32                              -- Contact damage.
ENTITIES.BrushMan.BATTLE_NUMBERS            = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.BrushMan2                          = new_base_entity(ENTITY_KIND.Virus, "BrushMan2")
ENTITIES.BrushMan2.NAME                     = "BrushMan2"
ENTITIES.BrushMan2.HP_BASE                  = 170
ENTITIES.BrushMan2.ELEMENT                  = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.BrushMan2.AI_BYTES                 = {}
ENTITIES.BrushMan2.AI_BYTES[0x00]           = 0x5A                              -- Delay before attack / movement.
ENTITIES.BrushMan2.AI_BYTES[0x01]           = 0x01                              -- Number of holy panels in a row (own field).
ENTITIES.BrushMan2.AI_BYTES[0x02]           = BrushMan_PanelType.LAVA           -- Type of panel 1 (enemy field).
ENTITIES.BrushMan2.AI_BYTES[0x03]           = BrushMan_PanelType.ICE            -- Type of panel 2 (enemy field).
ENTITIES.BrushMan2.AI_BYTES[0x04]           = 0x64                              -- Contact damage.
ENTITIES.BrushMan2.BATTLE_NUMBERS           = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.BrushMan3                          = new_base_entity(ENTITY_KIND.Virus, "BrushMan3")
ENTITIES.BrushMan3.NAME                     = "BrushMan3"
ENTITIES.BrushMan3.HP_BASE                  = 220
ENTITIES.BrushMan3.ELEMENT                  = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.BrushMan3.AI_BYTES                 = {}
ENTITIES.BrushMan3.AI_BYTES[0x00]           = 0x3C                              -- Delay before attack / movement.
ENTITIES.BrushMan3.AI_BYTES[0x01]           = 0x02                              -- Number of holy panels in a row (own field).
ENTITIES.BrushMan3.AI_BYTES[0x02]           = BrushMan_PanelType.POISON         -- Type of panel 1 (enemy field).
ENTITIES.BrushMan3.AI_BYTES[0x03]           = BrushMan_PanelType.LAVA           -- Type of panel 2 (enemy field).
ENTITIES.BrushMan3.AI_BYTES[0x04]           = 0x96                              -- Contact damage.
ENTITIES.BrushMan3.BATTLE_NUMBERS           = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.BrushManOmega                      = new_base_entity(ENTITY_KIND.Virus, "BrushManOmega")
ENTITIES.BrushManOmega.NAME                 = "BrushMan\003"
ENTITIES.BrushManOmega.HP_BASE              = 300
ENTITIES.BrushManOmega.ELEMENT              = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.BrushManOmega.AI_BYTES             = {}
ENTITIES.BrushManOmega.AI_BYTES[0x00]       = 0x28                              -- Delay before attack / movement.
ENTITIES.BrushManOmega.AI_BYTES[0x01]       = 0x02                              -- Number of holy panels in a row (own field).
ENTITIES.BrushManOmega.AI_BYTES[0x02]       = BrushMan_PanelType.POISON         -- Type of panel 1 (enemy field).
ENTITIES.BrushManOmega.AI_BYTES[0x03]       = BrushMan_PanelType.POISON         -- Type of panel 2 (enemy field).
ENTITIES.BrushManOmega.AI_BYTES[0x04]       = 0xC8                              -- Contact damage.
ENTITIES.BrushManOmega.BATTLE_NUMBERS       = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

local Scutz_AuraType = 
{
    AURA_100 = 0x00,
    AURA_200 = 0x01,
    AURA_300 = 0x02
}

ENTITIES.Scutz                              = new_base_entity(ENTITY_KIND.Virus, "Scutz")
ENTITIES.Scutz.NAME                         = "Scutz"
ENTITIES.Scutz.HP_BASE                      = 300
ENTITIES.Scutz.ELEMENT                      = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT
ENTITIES.Scutz.AI_BYTES                     = {}
ENTITIES.Scutz.AI_BYTES[0x00]               = 0x28                              -- Delay after attack.
ENTITIES.Scutz.AI_BYTES[0x01]               = 0x04                              -- (??), either 0x00 or 0x04.
ENTITIES.Scutz.AI_BYTES[0x02]               = 0x3C                              -- Delay before attack.
ENTITIES.Scutz.AI_BYTES[0x03]               = Scutz_AuraType.AURA_100           -- Type of aura.
ENTITIES.Scutz.AI_BYTES[0x04]               = 0xC8                              -- Damage (Byte 1).
ENTITIES.Scutz.AI_BYTES[0x05]               = 0x00                              -- Damage (Byte 2).
ENTITIES.Scutz.AI_BYTES[0x06]               = 0x1E                              -- Vertical boundaries (Byte 1).
ENTITIES.Scutz.AI_BYTES[0x07]               = 0x00                              -- Vertical boundaries (Byte 2).
ENTITIES.Scutz.AI_BYTES[0x08]               = 0xCC                              -- Movement variable (Byte 1).
ENTITIES.Scutz.AI_BYTES[0x09]               = 0xCC                              -- Movement variable (Byte 2).
ENTITIES.Scutz.AI_BYTES[0x0A]               = 0x00                              -- Movement variable (Byte 3).
ENTITIES.Scutz.AI_BYTES[0x0B]               = 0x00                              -- Movement variable (Byte 4).
ENTITIES.Scutz.AI_BYTES[0x336B4]            = 0x21                              -- Vine speed delay.
ENTITIES.Scutz.BATTLE_NUMBERS               = {27, 28, 29, 31, 32, 33, 34, 36, 37, 38, 39}     -- Battles in which this entity can appear.

ENTITIES.Scuttle                            = new_base_entity(ENTITY_KIND.Virus, "Scuttle")
ENTITIES.Scuttle.NAME                       = "Scuttle"
ENTITIES.Scuttle.HP_BASE                    = 300
ENTITIES.Scuttle.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_AQUA
ENTITIES.Scuttle.AI_BYTES                   = {}
ENTITIES.Scuttle.AI_BYTES[0x00]             = 0x28                              -- Delay after attack.
ENTITIES.Scuttle.AI_BYTES[0x01]             = 0x00                              -- (??), either 0x00 or 0x04.
ENTITIES.Scuttle.AI_BYTES[0x02]             = 0x5A                              -- Delay before attack.
ENTITIES.Scuttle.AI_BYTES[0x03]             = Scutz_AuraType.AURA_100           -- Type of aura.
ENTITIES.Scuttle.AI_BYTES[0x04]             = 0xC8                              -- Damage (Byte 1).
ENTITIES.Scuttle.AI_BYTES[0x05]             = 0x00                              -- Damage (Byte 2).
ENTITIES.Scuttle.AI_BYTES[0x06]             = 0x14                              -- Vertical boundaries (Byte 1).
ENTITIES.Scuttle.AI_BYTES[0x07]             = 0x00                              -- Vertical boundaries (Byte 2).
ENTITIES.Scuttle.AI_BYTES[0x08]             = 0x33                              -- Movement variable (Byte 1).
ENTITIES.Scuttle.AI_BYTES[0x09]             = 0x33                              -- Movement variable (Byte 2).
ENTITIES.Scuttle.AI_BYTES[0x0A]             = 0x01                              -- Movement variable (Byte 3).
ENTITIES.Scuttle.AI_BYTES[0x0B]             = 0x00                              -- Movement variable (Byte 4).
ENTITIES.Scuttle.AI_BYTES[0x336A8]          = 0x21                              -- Vine speed delay.
ENTITIES.Scuttle.BATTLE_NUMBERS             = {27, 28, 29, 31, 32, 33, 34, 36, 37, 38, 39}     -- Battles in which this entity can appear.

ENTITIES.Scuttler                           = new_base_entity(ENTITY_KIND.Virus, "Scuttler")
ENTITIES.Scuttler.NAME                      = "Scuttler"
ENTITIES.Scuttler.HP_BASE                   = 300
ENTITIES.Scuttler.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_ELEC
ENTITIES.Scuttler.AI_BYTES                  = {}
ENTITIES.Scuttler.AI_BYTES[0x00]            = 0x28                              -- Delay after attack.
ENTITIES.Scuttler.AI_BYTES[0x01]            = 0x04                              -- (??), either 0x00 or 0x04.
ENTITIES.Scuttler.AI_BYTES[0x02]            = 0x78                              -- Delay before attack.
ENTITIES.Scuttler.AI_BYTES[0x03]            = Scutz_AuraType.AURA_100           -- Type of aura.
ENTITIES.Scuttler.AI_BYTES[0x04]            = 0xC8                              -- Damage (Byte 1).
ENTITIES.Scuttler.AI_BYTES[0x05]            = 0x00                              -- Damage (Byte 2).
ENTITIES.Scuttler.AI_BYTES[0x06]            = 0x28                              -- Vertical boundaries (Byte 1).
ENTITIES.Scuttler.AI_BYTES[0x07]            = 0x00                              -- Vertical boundaries (Byte 2).
ENTITIES.Scuttler.AI_BYTES[0x08]            = 0x99                              -- Movement variable (Byte 1).
ENTITIES.Scuttler.AI_BYTES[0x09]            = 0x99                              -- Movement variable (Byte 2).
ENTITIES.Scuttler.AI_BYTES[0x0A]            = 0x00                              -- Movement variable (Byte 3).
ENTITIES.Scuttler.AI_BYTES[0x0B]            = 0x00                              -- Movement variable (Byte 4).
ENTITIES.Scuttler.AI_BYTES[0x3369C]         = 0x21                              -- Vine speed delay.
ENTITIES.Scuttler.BATTLE_NUMBERS            = {27, 28, 29, 31, 32, 33, 34, 36, 37, 38, 39}     -- Battles in which this entity can appear.

ENTITIES.Scuttzer                           = new_base_entity(ENTITY_KIND.Virus, "Scuttzer")
ENTITIES.Scuttzer.NAME                      = "Scuttzer"
ENTITIES.Scuttzer.HP_BASE                   = 300
ENTITIES.Scuttzer.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_WOOD
ENTITIES.Scuttzer.AI_BYTES                  = {}
ENTITIES.Scuttzer.AI_BYTES[0x00]            = 0x28                              -- Delay after attack.
ENTITIES.Scuttzer.AI_BYTES[0x01]            = 0x04                              -- (??), either 0x00 or 0x04.
ENTITIES.Scuttzer.AI_BYTES[0x02]            = 0x3C                              -- Delay before attack.
ENTITIES.Scuttzer.AI_BYTES[0x03]            = Scutz_AuraType.AURA_100           -- Type of aura.
ENTITIES.Scuttzer.AI_BYTES[0x04]            = 0xC8                              -- Damage (Byte 1).
ENTITIES.Scuttzer.AI_BYTES[0x05]            = 0x00                              -- Damage (Byte 2).
ENTITIES.Scuttzer.AI_BYTES[0x06]            = 0x18                              -- Vertical boundaries (Byte 1).
ENTITIES.Scuttzer.AI_BYTES[0x07]            = 0x00                              -- Vertical boundaries (Byte 2).
ENTITIES.Scuttzer.AI_BYTES[0x08]            = 0x00                              -- Movement variable (Byte 1).
ENTITIES.Scuttzer.AI_BYTES[0x09]            = 0x00                              -- Movement variable (Byte 2).
ENTITIES.Scuttzer.AI_BYTES[0x0A]            = 0x01                              -- Movement variable (Byte 3).
ENTITIES.Scuttzer.AI_BYTES[0x0B]            = 0x00                              -- Movement variable (Byte 4).
ENTITIES.Scuttzer.AI_BYTES[0x33690]         = 0x21                              -- Vine speed delay.
ENTITIES.Scuttzer.BATTLE_NUMBERS            = {27, 28, 29, 31, 32, 33, 34, 36, 37, 38, 39}     -- Battles in which this entity can appear.

ENTITIES.Scuttlest                          = new_base_entity(ENTITY_KIND.Virus, "Scuttlest")
ENTITIES.Scuttlest.NAME                     = "Scuttlest"
ENTITIES.Scuttlest.HP_BASE                  = 200
ENTITIES.Scuttlest.ELEMENT                  = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Scuttlest.AI_BYTES                 = {}
ENTITIES.Scuttlest.AI_BYTES[0x00]           = 0x28                              -- Delay after attack.
ENTITIES.Scuttlest.AI_BYTES[0x01]           = 0x00                              -- (??), either 0x00 or 0x04.
ENTITIES.Scuttlest.AI_BYTES[0x02]           = 0x3C                              -- Delay before attack.
ENTITIES.Scuttlest.AI_BYTES[0x03]           = Scutz_AuraType.AURA_200           -- Type of aura.
ENTITIES.Scuttlest.AI_BYTES[0x04]           = 0xC8                              -- Damage (Byte 1).
ENTITIES.Scuttlest.AI_BYTES[0x05]           = 0x00                              -- Damage (Byte 2).
ENTITIES.Scuttlest.AI_BYTES[0x06]           = 0x0F                              -- Vertical boundaries (Byte 1).
ENTITIES.Scuttlest.AI_BYTES[0x07]           = 0x00                              -- Vertical boundaries (Byte 2).
ENTITIES.Scuttlest.AI_BYTES[0x08]           = 0x99                              -- Movement variable (Byte 1).
ENTITIES.Scuttlest.AI_BYTES[0x09]           = 0x99                              -- Movement variable (Byte 2).
ENTITIES.Scuttlest.AI_BYTES[0x0A]           = 0x01                              -- Movement variable (Byte 3).
ENTITIES.Scuttlest.AI_BYTES[0x0B]           = 0x00                              -- Movement variable (Byte 4).
ENTITIES.Scuttlest.AI_BYTES[0x33684]        = 0x21                              -- Vine speed delay.
ENTITIES.Scuttlest.BATTLE_NUMBERS           = {27, 28, 29, 31, 32, 33, 34, 36, 37, 38, 39}     -- Battles in which this entity can appear.

ENTITIES.ScuttleOmega                       = new_base_entity(ENTITY_KIND.Virus, "ScuttleOmega")
ENTITIES.ScuttleOmega.NAME                  = "Scuttle\003"
ENTITIES.ScuttleOmega.HP_BASE               = 400
ENTITIES.ScuttleOmega.ELEMENT               = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.ScuttleOmega.AI_BYTES              = {}
ENTITIES.ScuttleOmega.AI_BYTES[0x00]        = 0x28                              -- Delay after attack.
ENTITIES.ScuttleOmega.AI_BYTES[0x01]        = 0x00                              -- (??), either 0x00 or 0x04.
ENTITIES.ScuttleOmega.AI_BYTES[0x02]        = 0x3C                              -- Delay before attack.
ENTITIES.ScuttleOmega.AI_BYTES[0x03]        = Scutz_AuraType.AURA_200           -- Type of aura.
ENTITIES.ScuttleOmega.AI_BYTES[0x04]        = 0x2C                              -- Damage (Byte 1).
ENTITIES.ScuttleOmega.AI_BYTES[0x05]        = 0x01                              -- Damage (Byte 2).
ENTITIES.ScuttleOmega.AI_BYTES[0x06]        = 0x0F                              -- Vertical boundaries (Byte 1).
ENTITIES.ScuttleOmega.AI_BYTES[0x07]        = 0x00                              -- Vertical boundaries (Byte 2).
ENTITIES.ScuttleOmega.AI_BYTES[0x08]        = 0x99                              -- Movement variable (Byte 1).
ENTITIES.ScuttleOmega.AI_BYTES[0x09]        = 0x99                              -- Movement variable (Byte 2).
ENTITIES.ScuttleOmega.AI_BYTES[0x0A]        = 0x01                              -- Movement variable (Byte 3).
ENTITIES.ScuttleOmega.AI_BYTES[0x0B]        = 0x00                              -- Movement variable (Byte 4).
ENTITIES.ScuttleOmega.AI_BYTES[0x33678]     = 0x21                              -- Vine speed delay.
ENTITIES.ScuttleOmega.BATTLE_NUMBERS        = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Beetle                             = new_base_entity(ENTITY_KIND.Virus, "Beetle")
ENTITIES.Beetle.NAME                        = "Beetle"
ENTITIES.Beetle.HP_BASE                     = 90
ENTITIES.Beetle.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Beetle.AI_BYTES                    = {}
ENTITIES.Beetle.AI_BYTES[0x00]              = 0x0A                              -- (??).
ENTITIES.Beetle.AI_BYTES[0x01]              = 0x19                              -- Horizontal speed.
ENTITIES.Beetle.AI_BYTES[0x02]              = 0x0F                              -- Vertical boundaries.
ENTITIES.Beetle.AI_BYTES[0x03]              = 0x14                              -- Damage bomb.
ENTITIES.Beetle.AI_BYTES[0x04]              = 0x01                              -- Number of bombs shot.
ENTITIES.Beetle.AI_BYTES[0x08]              = 0x99                              -- Movement variable (Byte 1).
ENTITIES.Beetle.AI_BYTES[0x09]              = 0x99                              -- Movement variable (Byte 2).
ENTITIES.Beetle.AI_BYTES[0x0A]              = 0x01                              -- Movement variable (Byte 3).
ENTITIES.Beetle.AI_BYTES[0x0B]              = 0x00                              -- Movement variable (Byte 4).
ENTITIES.Beetle.AI_BYTES[0xBE2A]            = 0x3C                              -- Delay after attack. This is shared with all other Beetle viruses in the same battle.
ENTITIES.Beetle.BATTLE_NUMBERS              = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Deetle                             = new_base_entity(ENTITY_KIND.Virus, "Deetle")
ENTITIES.Deetle.NAME                        = "Deetle"
ENTITIES.Deetle.HP_BASE                     = 130
ENTITIES.Deetle.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Deetle.AI_BYTES                    = {}
ENTITIES.Deetle.AI_BYTES[0x00]              = 0x0A                              -- (??).
ENTITIES.Deetle.AI_BYTES[0x01]              = 0x16                              -- Horizontal speed.
ENTITIES.Deetle.AI_BYTES[0x02]              = 0x0D                              -- Vertical boundaries.
ENTITIES.Deetle.AI_BYTES[0x03]              = 0x32                              -- Damage bomb.
ENTITIES.Deetle.AI_BYTES[0x04]              = 0x02                              -- Number of bombs shot.
ENTITIES.Deetle.AI_BYTES[0x08]              = 0xCC                              -- Movement variable (Byte 1).
ENTITIES.Deetle.AI_BYTES[0x09]              = 0xCC                              -- Movement variable (Byte 2).
ENTITIES.Deetle.AI_BYTES[0x0A]              = 0x01                              -- Movement variable (Byte 3).
ENTITIES.Deetle.AI_BYTES[0x0B]              = 0x00                              -- Movement variable (Byte 4).
ENTITIES.Deetle.AI_BYTES[0xBE1E]            = 0x3C                              -- Delay after attack. This is shared with all other Beetle viruses in the same battle.
ENTITIES.Deetle.BATTLE_NUMBERS              = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Geetle                             = new_base_entity(ENTITY_KIND.Virus, "Geetle")
ENTITIES.Geetle.NAME                        = "Geetle"
ENTITIES.Geetle.HP_BASE                     = 170
ENTITIES.Geetle.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Geetle.AI_BYTES                    = {}
ENTITIES.Geetle.AI_BYTES[0x00]              = 0x0A                              -- (??).
ENTITIES.Geetle.AI_BYTES[0x01]              = 0x14                              -- Horizontal speed.
ENTITIES.Geetle.AI_BYTES[0x02]              = 0x0C                              -- Vertical boundaries.
ENTITIES.Geetle.AI_BYTES[0x03]              = 0x50                              -- Damage bomb.
ENTITIES.Geetle.AI_BYTES[0x04]              = 0x03                              -- Number of bombs shot.
ENTITIES.Geetle.AI_BYTES[0x08]              = 0x00                              -- Movement variable (Byte 1).
ENTITIES.Geetle.AI_BYTES[0x09]              = 0x00                              -- Movement variable (Byte 2).
ENTITIES.Geetle.AI_BYTES[0x0A]              = 0x02                              -- Movement variable (Byte 3).
ENTITIES.Geetle.AI_BYTES[0x0B]              = 0x00                              -- Movement variable (Byte 4).
ENTITIES.Geetle.AI_BYTES[0xBE12]            = 0x3C                              -- Delay after attack. This is shared with all other Beetle viruses in the same battle.
ENTITIES.Geetle.BATTLE_NUMBERS              = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.BeetleOmega                        = new_base_entity(ENTITY_KIND.Virus, "BeetleOmega")
ENTITIES.BeetleOmega.NAME                   = "Beetle\003"
ENTITIES.BeetleOmega.HP_BASE                = 220
ENTITIES.BeetleOmega.ELEMENT                = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.BeetleOmega.AI_BYTES               = {}
ENTITIES.BeetleOmega.AI_BYTES[0x00]         = 0x0A                              -- (??).
ENTITIES.BeetleOmega.AI_BYTES[0x01]         = 0x10                              -- Horizontal speed.
ENTITIES.BeetleOmega.AI_BYTES[0x02]         = 0x0A                              -- Vertical boundaries.
ENTITIES.BeetleOmega.AI_BYTES[0x03]         = 0x8C                              -- Damage bomb.
ENTITIES.BeetleOmega.AI_BYTES[0x04]         = 0x03                              -- Number of bombs shot.
ENTITIES.BeetleOmega.AI_BYTES[0x08]         = 0x66                              -- Movement variable (Byte 1).
ENTITIES.BeetleOmega.AI_BYTES[0x09]         = 0x66                              -- Movement variable (Byte 2).
ENTITIES.BeetleOmega.AI_BYTES[0x0A]         = 0x02                              -- Movement variable (Byte 3).
ENTITIES.BeetleOmega.AI_BYTES[0x0B]         = 0x00                              -- Movement variable (Byte 4).
ENTITIES.BeetleOmega.AI_BYTES[0xBE06]       = 0x3C                              -- Delay after attack. This is shared with all other Beetle viruses in the same battle.
ENTITIES.BeetleOmega.BATTLE_NUMBERS         = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Metrid                             = new_base_entity(ENTITY_KIND.Virus, "Metrid")
ENTITIES.Metrid.NAME                        = "Metrid"
ENTITIES.Metrid.HP_BASE                     = 150
ENTITIES.Metrid.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT
ENTITIES.Metrid.AI_BYTES                    = {}
ENTITIES.Metrid.AI_BYTES[0x00]              = 0x07                              -- Number of meteors 1.
ENTITIES.Metrid.AI_BYTES[0x01]              = 0x05                              -- Number of meteors 2.
ENTITIES.Metrid.AI_BYTES[0x02]              = 0x04                              -- Number of meteors 3.
ENTITIES.Metrid.AI_BYTES[0x03]              = 0x28                              -- Damage meteor.
ENTITIES.Metrid.AI_BYTES[0x04]              = 0x00                              -- (??).
ENTITIES.Metrid.AI_BYTES[0x05]              = 0x05                              -- Movements before attack.
ENTITIES.Metrid.AI_BYTES[0x06]              = 0x1E                              -- Delay before movement.
ENTITIES.Metrid.AI_BYTES[0x07]              = 0x1E                              -- Delay between meteors.
ENTITIES.Metrid.AI_BYTES[0x08]              = 0x01                              -- (??).
ENTITIES.Metrid.BATTLE_NUMBERS              = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Metrod                             = new_base_entity(ENTITY_KIND.Virus, "Metrod")
ENTITIES.Metrod.NAME                        = "Metrod"
ENTITIES.Metrod.HP_BASE                     = 200
ENTITIES.Metrod.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT
ENTITIES.Metrod.AI_BYTES                    = {}
ENTITIES.Metrod.AI_BYTES[0x00]              = 0x05                              -- Number of meteors 1.
ENTITIES.Metrod.AI_BYTES[0x01]              = 0x06                              -- Number of meteors 2.
ENTITIES.Metrod.AI_BYTES[0x02]              = 0x08                              -- Number of meteors 3.
ENTITIES.Metrod.AI_BYTES[0x03]              = 0x50                              -- Damage meteor.
ENTITIES.Metrod.AI_BYTES[0x04]              = 0x01                              -- (??).
ENTITIES.Metrod.AI_BYTES[0x05]              = 0x05                              -- Movements before attack.
ENTITIES.Metrod.AI_BYTES[0x06]              = 0x18                              -- Delay before movement.
ENTITIES.Metrod.AI_BYTES[0x07]              = 0x19                              -- Delay between meteors.
ENTITIES.Metrod.AI_BYTES[0x08]              = 0x03                              -- (??).
ENTITIES.Metrod.BATTLE_NUMBERS              = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Metrodo                            = new_base_entity(ENTITY_KIND.Virus, "Metrodo")
ENTITIES.Metrodo.NAME                       = "Metrodo"
ENTITIES.Metrodo.HP_BASE                    = 250
ENTITIES.Metrodo.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT
ENTITIES.Metrodo.AI_BYTES                   = {}
ENTITIES.Metrodo.AI_BYTES[0x00]             = 0x10                              -- Number of meteors 1.
ENTITIES.Metrodo.AI_BYTES[0x01]             = 0x0A                              -- Number of meteors 2.
ENTITIES.Metrodo.AI_BYTES[0x02]             = 0x12                              -- Number of meteors 3.
ENTITIES.Metrodo.AI_BYTES[0x03]             = 0x78                              -- Damage meteor.
ENTITIES.Metrodo.AI_BYTES[0x04]             = 0x02                              -- (??).
ENTITIES.Metrodo.AI_BYTES[0x05]             = 0x09                              -- Movements before attack.
ENTITIES.Metrodo.AI_BYTES[0x06]             = 0x12                              -- Delay before movement.
ENTITIES.Metrodo.AI_BYTES[0x07]             = 0x14                              -- Delay between meteors.
ENTITIES.Metrodo.AI_BYTES[0x08]             = 0x02                              -- (??).
ENTITIES.Metrodo.BATTLE_NUMBERS             = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.MetridOmega                        = new_base_entity(ENTITY_KIND.Virus, "MetridOmega")
ENTITIES.MetridOmega.NAME                   = "Metrid\003"
ENTITIES.MetridOmega.HP_BASE                = 300
ENTITIES.MetridOmega.ELEMENT                = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT
ENTITIES.MetridOmega.AI_BYTES               = {}
ENTITIES.MetridOmega.AI_BYTES[0x00]         = 0x07                              -- Number of meteors 1.
ENTITIES.MetridOmega.AI_BYTES[0x01]         = 0x05                              -- Number of meteors 2.
ENTITIES.MetridOmega.AI_BYTES[0x02]         = 0x04                              -- Number of meteors 3.
ENTITIES.MetridOmega.AI_BYTES[0x03]         = 0x28                              -- Damage meteor.
ENTITIES.MetridOmega.AI_BYTES[0x04]         = 0x00                              -- (??).
ENTITIES.MetridOmega.AI_BYTES[0x05]         = 0x05                              -- Movements before attack.
ENTITIES.MetridOmega.AI_BYTES[0x06]         = 0x1E                              -- Delay before movement.
ENTITIES.MetridOmega.AI_BYTES[0x07]         = 0x1E                              -- Delay between meteors.
ENTITIES.MetridOmega.AI_BYTES[0x08]         = 0x01                              -- (??).
ENTITIES.MetridOmega.BATTLE_NUMBERS         = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.SnowBlow                           = new_base_entity(ENTITY_KIND.Virus, "SnowBlow")
ENTITIES.SnowBlow.NAME                      = "SnowBlow"
ENTITIES.SnowBlow.HP_BASE                   = 100
ENTITIES.SnowBlow.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.SnowBlow.AI_BYTES                  = {}
ENTITIES.SnowBlow.AI_BYTES[0x00]            = 0x5A                              -- Delay before attack.
ENTITIES.SnowBlow.AI_BYTES[0x01]            = 0x96                              -- Duration of blow.
ENTITIES.SnowBlow.AI_BYTES[0x02]            = 0x1E                              -- Damage tornado (Byte 1).
ENTITIES.SnowBlow.AI_BYTES[0x03]            = 0x00                              -- Damage tornado (Byte 2).
ENTITIES.SnowBlow.AI_BYTES[0x04]            = 0x33                              -- Tornado speed (Byte 1).
ENTITIES.SnowBlow.AI_BYTES[0x05]            = 0x33                              -- Tornado speed (Byte 2).
ENTITIES.SnowBlow.AI_BYTES[0x06]            = 0x01                              -- Tornado speed (Byte 3).
ENTITIES.SnowBlow.AI_BYTES[0x07]            = 0x00                              -- Tornado speed (Byte 4).
ENTITIES.SnowBlow.BATTLE_NUMBERS            = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.LowBlow                            = new_base_entity(ENTITY_KIND.Virus, "LowBlow")
ENTITIES.LowBlow.NAME                       = "LowBlow"
ENTITIES.LowBlow.HP_BASE                    = 140
ENTITIES.LowBlow.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.LowBlow.AI_BYTES                   = {}
ENTITIES.LowBlow.AI_BYTES[0x00]             = 0x3C                              -- Delay before attack.
ENTITIES.LowBlow.AI_BYTES[0x01]             = 0x78                              -- Duration of blow.
ENTITIES.LowBlow.AI_BYTES[0x02]             = 0x3C                              -- Damage tornado (Byte 1).
ENTITIES.LowBlow.AI_BYTES[0x03]             = 0x00                              -- Damage tornado (Byte 2).
ENTITIES.LowBlow.AI_BYTES[0x04]             = 0x00                              -- Tornado speed (Byte 1).
ENTITIES.LowBlow.AI_BYTES[0x05]             = 0x80                              -- Tornado speed (Byte 2).
ENTITIES.LowBlow.AI_BYTES[0x06]             = 0x01                              -- Tornado speed (Byte 3).
ENTITIES.LowBlow.AI_BYTES[0x07]             = 0x00                              -- Tornado speed (Byte 4).
ENTITIES.LowBlow.BATTLE_NUMBERS             = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.MoBlow                             = new_base_entity(ENTITY_KIND.Virus, "MoBlow")
ENTITIES.MoBlow.NAME                        = "MoBlow"
ENTITIES.MoBlow.HP_BASE                     = 180
ENTITIES.MoBlow.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.MoBlow.AI_BYTES                    = {}
ENTITIES.MoBlow.AI_BYTES[0x00]              = 0x1E                              -- Delay before attack.
ENTITIES.MoBlow.AI_BYTES[0x01]              = 0x5A                              -- Duration of blow.
ENTITIES.MoBlow.AI_BYTES[0x02]              = 0x5A                              -- Damage tornado (Byte 1).
ENTITIES.MoBlow.AI_BYTES[0x03]              = 0x00                              -- Damage tornado (Byte 2).
ENTITIES.MoBlow.AI_BYTES[0x04]              = 0xCC                              -- Tornado speed (Byte 1).
ENTITIES.MoBlow.AI_BYTES[0x05]              = 0xCC                              -- Tornado speed (Byte 2).
ENTITIES.MoBlow.AI_BYTES[0x06]              = 0x01                              -- Tornado speed (Byte 3).
ENTITIES.MoBlow.AI_BYTES[0x07]              = 0x00                              -- Tornado speed (Byte 4).
ENTITIES.MoBlow.BATTLE_NUMBERS              = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.SnowBlowOmega                      = new_base_entity(ENTITY_KIND.Virus, "SnowBlowOmega")
ENTITIES.SnowBlowOmega.NAME                 = "SnowBlow\003"
ENTITIES.SnowBlowOmega.HP_BASE              = 300
ENTITIES.SnowBlowOmega.ELEMENT              = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.SnowBlowOmega.AI_BYTES             = {}
ENTITIES.SnowBlowOmega.AI_BYTES[0x00]       = 0x1E                              -- Delay before attack.
ENTITIES.SnowBlowOmega.AI_BYTES[0x01]       = 0x3C                              -- Duration of blow.
ENTITIES.SnowBlowOmega.AI_BYTES[0x02]       = 0x78                              -- Damage tornado (Byte 1).
ENTITIES.SnowBlowOmega.AI_BYTES[0x03]       = 0x00                              -- Damage tornado (Byte 2).
ENTITIES.SnowBlowOmega.AI_BYTES[0x04]       = 0x00                              -- Tornado speed (Byte 1).
ENTITIES.SnowBlowOmega.AI_BYTES[0x05]       = 0x00                              -- Tornado speed (Byte 2).
ENTITIES.SnowBlowOmega.AI_BYTES[0x06]       = 0x02                              -- Tornado speed (Byte 3).
ENTITIES.SnowBlowOmega.AI_BYTES[0x07]       = 0x00                              -- Tornado speed (Byte 4).
ENTITIES.SnowBlowOmega.BATTLE_NUMBERS       = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.KillerEye                          = new_base_entity(ENTITY_KIND.Virus, "KillerEye")
ENTITIES.KillerEye.NAME                     = "KillrEye"
ENTITIES.KillerEye.HP_BASE                  = 140
ENTITIES.KillerEye.ELEMENT                  = ENTITY_ELEMENT_DEFS.ELEMENT_ELEC
ENTITIES.KillerEye.AI_BYTES                 = {}
ENTITIES.KillerEye.AI_BYTES[0x00]           = 0x78                              -- Time it aims in 1 direction.
ENTITIES.KillerEye.AI_BYTES[0x01]           = 0x32                              -- Damage sensor.
ENTITIES.KillerEye.AI_BYTES[0x1D190]        = 0x1E                              -- Delay before sensor. This is shared with other Sensor viruses in the same battle.
ENTITIES.KillerEye.AI_BYTES[0x1D3A6]        = 0x3C                              -- Delay after sensor. This is shared with other Sensor viruses in the same battle.
ENTITIES.KillerEye.BATTLE_NUMBERS           = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.DemonEye                           = new_base_entity(ENTITY_KIND.Virus, "DemonEye")
ENTITIES.DemonEye.NAME                      = "DemonEye"
ENTITIES.DemonEye.HP_BASE                   = 190
ENTITIES.DemonEye.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_ELEC
ENTITIES.DemonEye.AI_BYTES                  = {}
ENTITIES.DemonEye.AI_BYTES[0x00]            = 0x3C                              -- Time it aims in 1 direction.
ENTITIES.DemonEye.AI_BYTES[0x01]            = 0x64                              -- Damage sensor.
ENTITIES.DemonEye.AI_BYTES[0x1D18E]         = 0x1E                              -- Delay before sensor. This is shared with other Sensor viruses in the same battle.
ENTITIES.DemonEye.AI_BYTES[0x1D3A4]         = 0x3C                              -- Delay after sensor. This is shared with other Sensor viruses in the same battle.
ENTITIES.DemonEye.BATTLE_NUMBERS            = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.JokerEye                           = new_base_entity(ENTITY_KIND.Virus, "JokerEye")
ENTITIES.JokerEye.NAME                      = "JokerEye"
ENTITIES.JokerEye.HP_BASE                   = 240
ENTITIES.JokerEye.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_ELEC
ENTITIES.JokerEye.AI_BYTES                  = {}
ENTITIES.JokerEye.AI_BYTES[0x00]            = 0xB4                              -- Time it aims in 1 direction.
ENTITIES.JokerEye.AI_BYTES[0x01]            = 0x96                              -- Damage sensor.
ENTITIES.JokerEye.AI_BYTES[0x1D18C]         = 0x1E                              -- Delay before sensor. This is shared with other Sensor viruses in the same battle.
ENTITIES.JokerEye.AI_BYTES[0x1D3A2]         = 0x3C                              -- Delay after sensor. This is shared with other Sensor viruses in the same battle.
ENTITIES.JokerEye.BATTLE_NUMBERS            = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.KillerEyeOmega                     = new_base_entity(ENTITY_KIND.Virus, "KillerEyeOmega")
ENTITIES.KillerEyeOmega.NAME                = "KillrEye\003"
ENTITIES.KillerEyeOmega.HP_BASE             = 300
ENTITIES.KillerEyeOmega.ELEMENT             = ENTITY_ELEMENT_DEFS.ELEMENT_ELEC
ENTITIES.KillerEyeOmega.AI_BYTES            = {}
ENTITIES.KillerEyeOmega.AI_BYTES[0x00]      = 0x78                              -- Time it aims in 1 direction.
ENTITIES.KillerEyeOmega.AI_BYTES[0x01]      = 0xC8                              -- Damage sensor.
ENTITIES.KillerEyeOmega.AI_BYTES[0x1D18A]   = 0x1E                              -- Delay before sensor. This is shared with other Sensor viruses in the same battle.
ENTITIES.KillerEyeOmega.AI_BYTES[0x1D3A0]   = 0x3C                              -- Delay after sensor. This is shared with other Sensor viruses in the same battle.
ENTITIES.KillerEyeOmega.BATTLE_NUMBERS      = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Momogra                            = new_base_entity(ENTITY_KIND.Virus, "Momogra")
ENTITIES.Momogra.NAME                       = "Momogra"
ENTITIES.Momogra.HP_BASE                    = 60
ENTITIES.Momogra.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Momogra.AI_BYTES                   = {}
ENTITIES.Momogra.AI_BYTES[0x00]             = 0x04                              -- Movements before attack.
ENTITIES.Momogra.AI_BYTES[0x01]             = 0x46                              -- Delay before movement.
ENTITIES.Momogra.AI_BYTES[0x02]             = 0x28                              -- Damage attack.
ENTITIES.Momogra.BATTLE_NUMBERS             = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Momogro                            = new_base_entity(ENTITY_KIND.Virus, "Momogro")
ENTITIES.Momogro.NAME                       = "Momogro"
ENTITIES.Momogro.HP_BASE                    = 130
ENTITIES.Momogro.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Momogro.AI_BYTES                   = {}
ENTITIES.Momogro.AI_BYTES[0x00]             = 0x05                              -- Movements before attack.
ENTITIES.Momogro.AI_BYTES[0x01]             = 0x3C                              -- Delay before movement.
ENTITIES.Momogro.AI_BYTES[0x02]             = 0x50                              -- Damage attack.
ENTITIES.Momogro.BATTLE_NUMBERS             = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Momogre                            = new_base_entity(ENTITY_KIND.Virus, "Momogre")
ENTITIES.Momogre.NAME                       = "Momogre"
ENTITIES.Momogre.HP_BASE                    = 180
ENTITIES.Momogre.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Momogre.AI_BYTES                   = {}
ENTITIES.Momogre.AI_BYTES[0x00]             = 0x08                              -- Movements before attack.
ENTITIES.Momogre.AI_BYTES[0x01]             = 0x32                              -- Delay before movement.
ENTITIES.Momogre.AI_BYTES[0x02]             = 0x78                              -- Damage attack.
ENTITIES.Momogre.BATTLE_NUMBERS             = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.MomograOmega                       = new_base_entity(ENTITY_KIND.Virus, "MomograOmega")
ENTITIES.MomograOmega.NAME                  = "Momogra\003"
ENTITIES.MomograOmega.HP_BASE               = 250
ENTITIES.MomograOmega.ELEMENT               = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.MomograOmega.AI_BYTES              = {}
ENTITIES.MomograOmega.AI_BYTES[0x00]        = 0x0A                              -- Movements before attack.
ENTITIES.MomograOmega.AI_BYTES[0x01]        = 0x28                              -- Delay before movement.
ENTITIES.MomograOmega.AI_BYTES[0x02]        = 0xC8                              -- Damage attack.
ENTITIES.MomograOmega.BATTLE_NUMBERS        = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Basher                             = new_base_entity(ENTITY_KIND.Virus, "Basher")
ENTITIES.Basher.NAME                        = "Basher"
ENTITIES.Basher.HP_BASE                     = 150
ENTITIES.Basher.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT
ENTITIES.Basher.AI_BYTES                    = {}
ENTITIES.Basher.AI_BYTES[0x00]              = 0x32                              -- Delay before aim.
ENTITIES.Basher.AI_BYTES[0x01]              = 0x32                              -- Damage attack.
ENTITIES.Basher.AI_BYTES[0x36FC8]           = 0x14                              -- Frames between aims. This is shared with other Basher viruses in the same battle.
ENTITIES.Basher.BATTLE_NUMBERS              = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Smasher                            = new_base_entity(ENTITY_KIND.Virus, "Smasher")
ENTITIES.Smasher.NAME                       = "Smasher"
ENTITIES.Smasher.HP_BASE                    = 200
ENTITIES.Smasher.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT
ENTITIES.Smasher.AI_BYTES                   = {}
ENTITIES.Smasher.AI_BYTES[0x00]             = 0x32                              -- Delay before aim.
ENTITIES.Smasher.AI_BYTES[0x01]             = 0x64                              -- Damage attack.
ENTITIES.Smasher.AI_BYTES[0x36FC6]          = 0x28                              -- Frames between aims. This is shared with other Basher viruses in the same battle.
ENTITIES.Smasher.BATTLE_NUMBERS             = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Trasher                            = new_base_entity(ENTITY_KIND.Virus, "Trasher")
ENTITIES.Trasher.NAME                       = "Trasher"
ENTITIES.Trasher.HP_BASE                    = 250
ENTITIES.Trasher.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT
ENTITIES.Trasher.AI_BYTES                   = {}
ENTITIES.Trasher.AI_BYTES[0x00]             = 0x32                              -- Delay before aim.
ENTITIES.Trasher.AI_BYTES[0x01]             = 0x96                              -- Damage attack.
ENTITIES.Trasher.AI_BYTES[0x36FC4]          = 0x28                              -- Frames between aims. This is shared with other Basher viruses in the same battle.
ENTITIES.Trasher.BATTLE_NUMBERS             = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.BasherOmega                        = new_base_entity(ENTITY_KIND.Virus, "BasherOmega")
ENTITIES.BasherOmega.NAME                   = "Basher\003"
ENTITIES.BasherOmega.HP_BASE                = 300
ENTITIES.BasherOmega.ELEMENT                = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT
ENTITIES.BasherOmega.AI_BYTES               = {}
ENTITIES.BasherOmega.AI_BYTES[0x00]         = 0x32                              -- Delay before aim.
ENTITIES.BasherOmega.AI_BYTES[0x01]         = 0xC8                              -- Damage attack.
ENTITIES.BasherOmega.AI_BYTES[0x36FC2]      = 0x28                              -- Frames between aims. This is shared with other Basher viruses in the same battle.
ENTITIES.BasherOmega.BATTLE_NUMBERS         = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Heavy                              = new_base_entity(ENTITY_KIND.Virus, "Heavy")
ENTITIES.Heavy.NAME                         = "Heavy"
ENTITIES.Heavy.HP_BASE                      = 100
ENTITIES.Heavy.ELEMENT                      = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Heavy.AI_BYTES                     = {}
ENTITIES.Heavy.AI_BYTES[0x00]               = 0x19                              -- Vertical speed delay (enemy side).
ENTITIES.Heavy.AI_BYTES[0x01]               = 0x3C                              -- Vertical speed delay (megaMan side).
ENTITIES.Heavy.AI_BYTES[0x02]               = 0x01                              -- Delay before vertical movement.
ENTITIES.Heavy.AI_BYTES[0x03]               = 0x01                              -- (??) always 0x01.
ENTITIES.Heavy.AI_BYTES[0x04]               = 0x1E                              -- Damage by contact.
ENTITIES.Heavy.BATTLE_NUMBERS               = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Heavier                            = new_base_entity(ENTITY_KIND.Virus, "Heavier")
ENTITIES.Heavier.NAME                       = "Heavier"
ENTITIES.Heavier.HP_BASE                    = 150
ENTITIES.Heavier.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Heavier.AI_BYTES                   = {}
ENTITIES.Heavier.AI_BYTES[0x00]             = 0x14                              -- Vertical speed delay (enemy side).
ENTITIES.Heavier.AI_BYTES[0x01]             = 0x32                              -- Vertical speed delay (megaMan side).
ENTITIES.Heavier.AI_BYTES[0x02]             = 0x01                              -- Delay before vertical movement.
ENTITIES.Heavier.AI_BYTES[0x03]             = 0x01                              -- (??) always 0x01.
ENTITIES.Heavier.AI_BYTES[0x04]             = 0x3C                              -- Damage by contact.
ENTITIES.Heavier.BATTLE_NUMBERS             = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Heaviest                           = new_base_entity(ENTITY_KIND.Virus, "Heaviest")
ENTITIES.Heaviest.NAME                      = "Heaviest"
ENTITIES.Heaviest.HP_BASE                   = 200
ENTITIES.Heaviest.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Heaviest.AI_BYTES                  = {}
ENTITIES.Heaviest.AI_BYTES[0x00]            = 0x0F                              -- Vertical speed delay (enemy side).
ENTITIES.Heaviest.AI_BYTES[0x01]            = 0x28                              -- Vertical speed delay (megaMan side).
ENTITIES.Heaviest.AI_BYTES[0x02]            = 0x01                              -- Delay before vertical movement.
ENTITIES.Heaviest.AI_BYTES[0x03]            = 0x01                              -- (??) always 0x01.
ENTITIES.Heaviest.AI_BYTES[0x04]            = 0x5A                              -- Damage by contact.
ENTITIES.Heaviest.BATTLE_NUMBERS            = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.HeavyOmega                         = new_base_entity(ENTITY_KIND.Virus, "HeavyOmega")
ENTITIES.HeavyOmega.NAME                    = "Heavy\003"
ENTITIES.HeavyOmega.HP_BASE                 = 300
ENTITIES.HeavyOmega.ELEMENT                 = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.HeavyOmega.AI_BYTES                = {}
ENTITIES.HeavyOmega.AI_BYTES[0x00]          = 0x0A                              -- Vertical speed delay (enemy side).
ENTITIES.HeavyOmega.AI_BYTES[0x01]          = 0x1E                              -- Vertical speed delay (megaMan side).
ENTITIES.HeavyOmega.AI_BYTES[0x02]          = 0x01                              -- Delay before vertical movement.
ENTITIES.HeavyOmega.AI_BYTES[0x03]          = 0x01                              -- (??) always 0x01.
ENTITIES.HeavyOmega.AI_BYTES[0x04]          = 0x96                              -- Damage by contact.
ENTITIES.HeavyOmega.BATTLE_NUMBERS          = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Pengi                              = new_base_entity(ENTITY_KIND.Virus, "Pengi")
ENTITIES.Pengi.NAME                         = "Pengi"
ENTITIES.Pengi.HP_BASE                      = 80
ENTITIES.Pengi.ELEMENT                      = ENTITY_ELEMENT_DEFS.ELEMENT_AQUA
ENTITIES.Pengi.AI_BYTES                     = {}
ENTITIES.Pengi.AI_BYTES[0x00]               = 0x0A                              -- (??).
ENTITIES.Pengi.AI_BYTES[0x01]               = 0x1E                              -- Horizontal speed delay.
ENTITIES.Pengi.AI_BYTES[0x02]               = 0x12                              -- Vertical speed delay.
ENTITIES.Pengi.AI_BYTES[0x03]               = 0x1E                              -- Damage attack.
ENTITIES.Pengi.AI_BYTES[0x04]               = 0x50                              -- Delay after attack.
ENTITIES.Pengi.AI_BYTES[0x05]               = 0x19                              -- Delay speed of attack.
ENTITIES.Pengi.AI_BYTES[0x06]               = 0x00                              -- Number of IceStage chips carrying.
ENTITIES.Pengi.AI_BYTES[0x07]               = 0x00                              -- (??) always 0x00.
ENTITIES.Pengi.AI_BYTES[0x08]               = 0x55                              -- Movement variable (Byte 1).
ENTITIES.Pengi.AI_BYTES[0x09]               = 0x55                              -- Movement variable (Byte 2).
ENTITIES.Pengi.AI_BYTES[0x0A]               = 0x01                              -- Movement variable (Byte 3).
ENTITIES.Pengi.AI_BYTES[0x0B]               = 0x00                              -- Movement variable (Byte 4).
ENTITIES.Pengi.BATTLE_NUMBERS               = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Penga                              = new_base_entity(ENTITY_KIND.Virus, "Penga")
ENTITIES.Penga.NAME                         = "Penga"
ENTITIES.Penga.HP_BASE                      = 100
ENTITIES.Penga.ELEMENT                      = ENTITY_ELEMENT_DEFS.ELEMENT_AQUA
ENTITIES.Penga.AI_BYTES                     = {}
ENTITIES.Penga.AI_BYTES[0x00]               = 0x0A                              -- (??).
ENTITIES.Penga.AI_BYTES[0x01]               = 0x18                              -- Horizontal speed delay.
ENTITIES.Penga.AI_BYTES[0x02]               = 0x0E                              -- Vertical speed delay.
ENTITIES.Penga.AI_BYTES[0x03]               = 0x3C                              -- Damage attack.
ENTITIES.Penga.AI_BYTES[0x04]               = 0x3C                              -- Delay after attack.
ENTITIES.Penga.AI_BYTES[0x05]               = 0x14                              -- Delay speed of attack.
ENTITIES.Penga.AI_BYTES[0x06]               = 0x00                              -- Number of IceStage chips carrying.
ENTITIES.Penga.AI_BYTES[0x07]               = 0x00                              -- (??) always 0x00.
ENTITIES.Penga.AI_BYTES[0x08]               = 0xAA                              -- Movement variable (Byte 1).
ENTITIES.Penga.AI_BYTES[0x09]               = 0xAA                              -- Movement variable (Byte 2).
ENTITIES.Penga.AI_BYTES[0x0A]               = 0x01                              -- Movement variable (Byte 3).
ENTITIES.Penga.AI_BYTES[0x0B]               = 0x00                              -- Movement variable (Byte 4).
ENTITIES.Penga.BATTLE_NUMBERS               = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Pengon                             = new_base_entity(ENTITY_KIND.Virus, "Pengon")
ENTITIES.Pengon.NAME                        = "Pengon"
ENTITIES.Pengon.HP_BASE                     = 130
ENTITIES.Pengon.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_AQUA
ENTITIES.Pengon.AI_BYTES                    = {}
ENTITIES.Pengon.AI_BYTES[0x00]              = 0x0A                              -- (??).
ENTITIES.Pengon.AI_BYTES[0x01]              = 0x16                              -- Horizontal speed delay.
ENTITIES.Pengon.AI_BYTES[0x02]              = 0x0D                              -- Vertical speed delay.
ENTITIES.Pengon.AI_BYTES[0x03]              = 0x5A                              -- Damage attack.
ENTITIES.Pengon.AI_BYTES[0x04]              = 0x32                              -- Delay after attack.
ENTITIES.Pengon.AI_BYTES[0x05]              = 0x0F                              -- Delay speed of attack.
ENTITIES.Pengon.AI_BYTES[0x06]              = 0x01                              -- Number of IceStage chips carrying.
ENTITIES.Pengon.AI_BYTES[0x07]              = 0x00                              -- (??) always 0x00.
ENTITIES.Pengon.AI_BYTES[0x08]              = 0xCC                              -- Movement variable (Byte 1).
ENTITIES.Pengon.AI_BYTES[0x09]              = 0xCC                              -- Movement variable (Byte 2).
ENTITIES.Pengon.AI_BYTES[0x0A]              = 0x01                              -- Movement variable (Byte 3).
ENTITIES.Pengon.AI_BYTES[0x0B]              = 0x00                              -- Movement variable (Byte 4).
ENTITIES.Pengon.BATTLE_NUMBERS              = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.PengiOmega                         = new_base_entity(ENTITY_KIND.Virus, "PengiOmega")
ENTITIES.PengiOmega.NAME                    = "Pengi\003"
ENTITIES.PengiOmega.HP_BASE                 = 260
ENTITIES.PengiOmega.ELEMENT                 = ENTITY_ELEMENT_DEFS.ELEMENT_AQUA
ENTITIES.PengiOmega.AI_BYTES                = {}
ENTITIES.PengiOmega.AI_BYTES[0x00]          = 0x0A                              -- (??).
ENTITIES.PengiOmega.AI_BYTES[0x01]          = 0x11                              -- Horizontal speed delay.
ENTITIES.PengiOmega.AI_BYTES[0x02]          = 0x0A                              -- Vertical speed delay.
ENTITIES.PengiOmega.AI_BYTES[0x03]          = 0x96                              -- Damage attack.
ENTITIES.PengiOmega.AI_BYTES[0x04]          = 0x28                              -- Delay after attack.
ENTITIES.PengiOmega.AI_BYTES[0x05]          = 0x0A                              -- Delay speed of attack.
ENTITIES.PengiOmega.AI_BYTES[0x06]          = 0x02                              -- Number of IceStage chips carrying.
ENTITIES.PengiOmega.AI_BYTES[0x07]          = 0x00                              -- (??) always 0x00.
ENTITIES.PengiOmega.AI_BYTES[0x08]          = 0x00                              -- Movement variable (Byte 1).
ENTITIES.PengiOmega.AI_BYTES[0x09]          = 0x40                              -- Movement variable (Byte 2).
ENTITIES.PengiOmega.AI_BYTES[0x0A]          = 0x02                              -- Movement variable (Byte 3).
ENTITIES.PengiOmega.AI_BYTES[0x0B]          = 0x00                              -- Movement variable (Byte 4).
ENTITIES.PengiOmega.BATTLE_NUMBERS          = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Viney                              = new_base_entity(ENTITY_KIND.Virus, "Viney")
ENTITIES.Viney.NAME                         = "Viney"
ENTITIES.Viney.HP_BASE                      = 120
ENTITIES.Viney.ELEMENT                      = ENTITY_ELEMENT_DEFS.ELEMENT_WOOD
ENTITIES.Viney.AI_BYTES                     = {}
ENTITIES.Viney.AI_BYTES[0x00]               = 0xF0                              -- Delay before attack.
ENTITIES.Viney.AI_BYTES[0x01]               = 0x3C                              -- Damage by contact with vine.
--ENTITIES.Viney.AI_BYTES[0x33800]            = 0x1E                              -- Vine's speed delay.
ENTITIES.Viney.BATTLE_NUMBERS               = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Viner                              = new_base_entity(ENTITY_KIND.Virus, "Viner")
ENTITIES.Viner.NAME                         = "Viner"
ENTITIES.Viner.HP_BASE                      = 160
ENTITIES.Viner.ELEMENT                      = ENTITY_ELEMENT_DEFS.ELEMENT_WOOD
ENTITIES.Viner.AI_BYTES                     = {}
ENTITIES.Viner.AI_BYTES[0x00]               = 0x96                              -- Delay before attack.
ENTITIES.Viner.AI_BYTES[0x01]               = 0x64                              -- Damage by contact with vine.
--ENTITIES.Viner.AI_BYTES[0x33800]            = 0x14                              -- Vine's speed delay.
ENTITIES.Viner.BATTLE_NUMBERS               = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Vinert                             = new_base_entity(ENTITY_KIND.Virus, "Vinert")
ENTITIES.Vinert.NAME                        = "Vinert"
ENTITIES.Vinert.HP_BASE                     = 200
ENTITIES.Vinert.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_WOOD
ENTITIES.Vinert.AI_BYTES                    = {}
ENTITIES.Vinert.AI_BYTES[0x00]              = 0x5A                              -- Delay before attack.
ENTITIES.Vinert.AI_BYTES[0x01]              = 0x78                              -- Damage by contact with vine.
--ENTITIES.Vinert.AI_BYTES[0x33800]           = 0x0A                              -- Vine's speed delay.
ENTITIES.Vinert.BATTLE_NUMBERS              = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.VineyOmega                         = new_base_entity(ENTITY_KIND.Virus, "VineyOmega")
ENTITIES.VineyOmega.NAME                    = "Viney\003"
ENTITIES.VineyOmega.HP_BASE                 = 300
ENTITIES.VineyOmega.ELEMENT                 = ENTITY_ELEMENT_DEFS.ELEMENT_WOOD
ENTITIES.VineyOmega.AI_BYTES                = {}
ENTITIES.VineyOmega.AI_BYTES[0x00]          = 0xF0                              -- Delay before attack.
ENTITIES.VineyOmega.AI_BYTES[0x01]          = 0xC8                              -- Damage by contact with vine.
--ENTITIES.VineyOmega.AI_BYTES[0x33800]       = 0x05                              -- Vine's speed delay.
ENTITIES.VineyOmega.BATTLE_NUMBERS          = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Slimer                             = new_base_entity(ENTITY_KIND.Virus, "Slimer")
ENTITIES.Slimer.NAME                        = "Slimer"
ENTITIES.Slimer.HP_BASE                     = 90
ENTITIES.Slimer.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_AQUA
ENTITIES.Slimer.AI_BYTES                    = {}
ENTITIES.Slimer.AI_BYTES[0x00]              = 0xB4                              -- Delay before movement.
ENTITIES.Slimer.AI_BYTES[0x01]              = 0x1E                              -- Damage contact.
ENTITIES.Slimer.AI_BYTES[0x03]              = 0x78                              -- Delay after contact.
ENTITIES.Slimer.BATTLE_NUMBERS              = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Slimey                             = new_base_entity(ENTITY_KIND.Virus, "Slimey")
ENTITIES.Slimey.NAME                        = "Slimey"
ENTITIES.Slimey.HP_BASE                     = 150
ENTITIES.Slimey.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_AQUA
ENTITIES.Slimey.AI_BYTES                    = {}
ENTITIES.Slimey.AI_BYTES[0x00]              = 0x8C                              -- Delay before movement.
ENTITIES.Slimey.AI_BYTES[0x01]              = 0x3C                              -- Damage contact.
ENTITIES.Slimey.AI_BYTES[0x03]              = 0x64                              -- Delay after contact.
ENTITIES.Slimey.BATTLE_NUMBERS              = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Slimest                            = new_base_entity(ENTITY_KIND.Virus, "Slimest")
ENTITIES.Slimest.NAME                       = "Slimest"
ENTITIES.Slimest.HP_BASE                    = 220
ENTITIES.Slimest.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_AQUA
ENTITIES.Slimest.AI_BYTES                   = {}
ENTITIES.Slimest.AI_BYTES[0x00]             = 0x64                              -- Delay before movement.
ENTITIES.Slimest.AI_BYTES[0x01]             = 0x5A                              -- Damage contact.
ENTITIES.Slimest.AI_BYTES[0x03]             = 0x50                              -- Delay after contact.
ENTITIES.Slimest.BATTLE_NUMBERS             = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.SlimerOmega                        = new_base_entity(ENTITY_KIND.Virus, "SlimerOmega")
ENTITIES.SlimerOmega.NAME                   = "Slimer\003"
ENTITIES.SlimerOmega.HP_BASE                = 300
ENTITIES.SlimerOmega.ELEMENT                = ENTITY_ELEMENT_DEFS.ELEMENT_AQUA
ENTITIES.SlimerOmega.AI_BYTES               = {}
ENTITIES.SlimerOmega.AI_BYTES[0x00]         = 0x3C                              -- Delay before movement.
ENTITIES.SlimerOmega.AI_BYTES[0x01]         = 0x96                              -- Damage contact.
ENTITIES.SlimerOmega.AI_BYTES[0x03]         = 0x3C                              -- Delay after contact.
ENTITIES.SlimerOmega.BATTLE_NUMBERS         = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.EleBee                             = new_base_entity(ENTITY_KIND.Virus, "EleBee")
ENTITIES.EleBee.NAME                        = "EleBee"
ENTITIES.EleBee.HP_BASE                     = 90
ENTITIES.EleBee.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_ELEC
ENTITIES.EleBee.AI_BYTES                    = {}
ENTITIES.EleBee.AI_BYTES[0x00]              = 0x1E                              -- Damage charge.
ENTITIES.EleBee.AI_BYTES[0x01]              = 0x1E                              -- Delay before movement.
ENTITIES.EleBee.AI_BYTES[0x03]              = 0x14                              -- Delay disappearing between movements.
ENTITIES.EleBee.AI_BYTES[0x04]              = 0x06                              -- Movements before attack.
ENTITIES.EleBee.BATTLE_NUMBERS              = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.EleWasp                            = new_base_entity(ENTITY_KIND.Virus, "EleWasp")
ENTITIES.EleWasp.NAME                       = "EleWasp"
ENTITIES.EleWasp.HP_BASE                    = 130
ENTITIES.EleWasp.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_ELEC
ENTITIES.EleWasp.AI_BYTES                   = {}
ENTITIES.EleWasp.AI_BYTES[0x00]             = 0x3C                              -- Damage charge.
ENTITIES.EleWasp.AI_BYTES[0x01]             = 0x18                              -- Delay before movement.
ENTITIES.EleWasp.AI_BYTES[0x03]             = 0x1E                              -- Delay disappearing between movements.
ENTITIES.EleWasp.AI_BYTES[0x04]             = 0x05                              -- Movements before attack.
ENTITIES.EleWasp.BATTLE_NUMBERS             = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.EleHornet                          = new_base_entity(ENTITY_KIND.Virus, "EleHornet")
ENTITIES.EleHornet.NAME                     = "EleHornet"
ENTITIES.EleHornet.HP_BASE                  = 170
ENTITIES.EleHornet.ELEMENT                  = ENTITY_ELEMENT_DEFS.ELEMENT_ELEC
ENTITIES.EleHornet.AI_BYTES                 = {}
ENTITIES.EleHornet.AI_BYTES[0x00]           = 0x5A                              -- Damage charge.
ENTITIES.EleHornet.AI_BYTES[0x01]           = 0x12                              -- Delay before movement.
ENTITIES.EleHornet.AI_BYTES[0x03]           = 0x2D                              -- Delay disappearing between movements.
ENTITIES.EleHornet.AI_BYTES[0x04]           = 0x04                              -- Movements before attack.
ENTITIES.EleHornet.BATTLE_NUMBERS           = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.EleBeeOmega                        = new_base_entity(ENTITY_KIND.Virus, "EleBeeOmega")
ENTITIES.EleBeeOmega.NAME                   = "EleBee\003"
ENTITIES.EleBeeOmega.HP_BASE                = 230
ENTITIES.EleBeeOmega.ELEMENT                = ENTITY_ELEMENT_DEFS.ELEMENT_ELEC
ENTITIES.EleBeeOmega.AI_BYTES               = {}
ENTITIES.EleBeeOmega.AI_BYTES[0x00]         = 0x96                              -- Damage charge.
ENTITIES.EleBeeOmega.AI_BYTES[0x01]         = 0x0C                              -- Delay before movement.
ENTITIES.EleBeeOmega.AI_BYTES[0x03]         = 0x39                              -- Delay disappearing between movements.
ENTITIES.EleBeeOmega.AI_BYTES[0x04]         = 0x04                              -- Movements before attack.
ENTITIES.EleBeeOmega.BATTLE_NUMBERS         = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Needler                            = new_base_entity(ENTITY_KIND.Virus, "Needler")
ENTITIES.Needler.NAME                       = "Needler"
ENTITIES.Needler.HP_BASE                    = 90
ENTITIES.Needler.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Needler.AI_BYTES                   = {}
ENTITIES.Needler.AI_BYTES[0x00]             = 0x3C                              -- Delay between needles.
ENTITIES.Needler.AI_BYTES[0x01]             = 0x1E                              -- Damage.
ENTITIES.Needler.AI_BYTES[0x02]             = 0x0A                              -- Number of needles before charge.
ENTITIES.Needler.AI_BYTES[0x03]             = 0x00                              -- (??).
ENTITIES.Needler.AI_BYTES[0x04]             = 0x00                              -- Speed of horizontal needle (Byte 1).
ENTITIES.Needler.AI_BYTES[0x05]             = 0x00                              -- Speed of horizontal needle (Byte 2).
ENTITIES.Needler.AI_BYTES[0x06]             = 0x06                              -- Speed of horizontal needle (Byte 3).
ENTITIES.Needler.AI_BYTES[0x07]             = 0x00                              -- Speed of horizontal needle (Byte 4).
ENTITIES.Needler.AI_BYTES[0x08]             = 0x00                              -- Speed of vertical needle (Byte 1).
ENTITIES.Needler.AI_BYTES[0x09]             = 0x00                              -- Speed of vertical needle (Byte 2).
ENTITIES.Needler.AI_BYTES[0x0A]             = 0x03                              -- Speed of vertical needle (Byte 3).
ENTITIES.Needler.AI_BYTES[0x0B]             = 0x00                              -- Speed of vertical needle (Byte 4).
ENTITIES.Needler.AI_BYTES[0x0C]             = 0x00                              -- Speed of charge (Byte 1).
ENTITIES.Needler.AI_BYTES[0x0D]             = 0x00                              -- Speed of charge (Byte 2).
ENTITIES.Needler.AI_BYTES[0x0E]             = 0x04                              -- Speed of charge (Byte 3).
ENTITIES.Needler.AI_BYTES[0x0F]             = 0x00                              -- Speed of charge (Byte 4).
ENTITIES.Needler.BATTLE_NUMBERS             = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Nailer                             = new_base_entity(ENTITY_KIND.Virus, "Nailer")
ENTITIES.Nailer.NAME                        = "Nailer"
ENTITIES.Nailer.HP_BASE                     = 140
ENTITIES.Nailer.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Nailer.AI_BYTES                    = {}
ENTITIES.Nailer.AI_BYTES[0x00]              = 0x32                              -- Delay between needles.
ENTITIES.Nailer.AI_BYTES[0x01]              = 0x3C                              -- Damage.
ENTITIES.Nailer.AI_BYTES[0x02]              = 0x18                              -- Number of needles before charge.
ENTITIES.Nailer.AI_BYTES[0x03]              = 0x00                              -- (??).
ENTITIES.Nailer.AI_BYTES[0x04]              = 0x00                              -- Speed of horizontal needle (Byte 1).
ENTITIES.Nailer.AI_BYTES[0x05]              = 0x00                              -- Speed of horizontal needle (Byte 2).
ENTITIES.Nailer.AI_BYTES[0x06]              = 0x07                              -- Speed of horizontal needle (Byte 3).
ENTITIES.Nailer.AI_BYTES[0x07]              = 0x00                              -- Speed of horizontal needle (Byte 4).
ENTITIES.Nailer.AI_BYTES[0x08]              = 0x00                              -- Speed of vertical needle (Byte 1).
ENTITIES.Nailer.AI_BYTES[0x09]              = 0x00                              -- Speed of vertical needle (Byte 2).
ENTITIES.Nailer.AI_BYTES[0x0A]              = 0x03                              -- Speed of vertical needle (Byte 3).
ENTITIES.Nailer.AI_BYTES[0x0B]              = 0x00                              -- Speed of vertical needle (Byte 4).
ENTITIES.Nailer.AI_BYTES[0x0C]              = 0x00                              -- Speed of charge (Byte 1).
ENTITIES.Nailer.AI_BYTES[0x0D]              = 0x80                              -- Speed of charge (Byte 2).
ENTITIES.Nailer.AI_BYTES[0x0E]              = 0x04                              -- Speed of charge (Byte 3).
ENTITIES.Nailer.AI_BYTES[0x0F]              = 0x00                              -- Speed of charge (Byte 4).
ENTITIES.Nailer.BATTLE_NUMBERS              = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Spiker                             = new_base_entity(ENTITY_KIND.Virus, "Spiker")
ENTITIES.Spiker.NAME                        = "Spiker"
ENTITIES.Spiker.HP_BASE                     = 200
ENTITIES.Spiker.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Spiker.AI_BYTES                    = {}
ENTITIES.Spiker.AI_BYTES[0x00]              = 0x2C                              -- Delay between needles.
ENTITIES.Spiker.AI_BYTES[0x01]              = 0x64                              -- Damage.
ENTITIES.Spiker.AI_BYTES[0x02]              = 0x06                              -- Number of needles before charge.
ENTITIES.Spiker.AI_BYTES[0x03]              = 0x00                              -- (??).
ENTITIES.Spiker.AI_BYTES[0x04]              = 0x00                              -- Speed of horizontal needle (Byte 1).
ENTITIES.Spiker.AI_BYTES[0x05]              = 0x00                              -- Speed of horizontal needle (Byte 2).
ENTITIES.Spiker.AI_BYTES[0x06]              = 0x08                              -- Speed of horizontal needle (Byte 3).
ENTITIES.Spiker.AI_BYTES[0x07]              = 0x00                              -- Speed of horizontal needle (Byte 4).
ENTITIES.Spiker.AI_BYTES[0x08]              = 0x00                              -- Speed of vertical needle (Byte 1).
ENTITIES.Spiker.AI_BYTES[0x09]              = 0x00                              -- Speed of vertical needle (Byte 2).
ENTITIES.Spiker.AI_BYTES[0x0A]              = 0x03                              -- Speed of vertical needle (Byte 3).
ENTITIES.Spiker.AI_BYTES[0x0B]              = 0x00                              -- Speed of vertical needle (Byte 4).
ENTITIES.Spiker.AI_BYTES[0x0C]              = 0x00                              -- Speed of charge (Byte 1).
ENTITIES.Spiker.AI_BYTES[0x0D]              = 0x00                              -- Speed of charge (Byte 2).
ENTITIES.Spiker.AI_BYTES[0x0E]              = 0x05                              -- Speed of charge (Byte 3).
ENTITIES.Spiker.AI_BYTES[0x0F]              = 0x00                              -- Speed of charge (Byte 4).
ENTITIES.Spiker.BATTLE_NUMBERS              = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.NeedlerOmega                       = new_base_entity(ENTITY_KIND.Virus, "NeedlerOmega")
ENTITIES.NeedlerOmega.NAME                  = "Needler\003"
ENTITIES.NeedlerOmega.HP_BASE               = 400
ENTITIES.NeedlerOmega.ELEMENT               = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.NeedlerOmega.AI_BYTES              = {}
ENTITIES.NeedlerOmega.AI_BYTES[0x00]        = 0x28                              -- Delay between needles.
ENTITIES.NeedlerOmega.AI_BYTES[0x01]        = 0xC8                              -- Damage.
ENTITIES.NeedlerOmega.AI_BYTES[0x02]        = 0x04                              -- Number of needles before charge.
ENTITIES.NeedlerOmega.AI_BYTES[0x03]        = 0x00                              -- (??).
ENTITIES.NeedlerOmega.AI_BYTES[0x04]        = 0x00                              -- Speed of horizontal needle (Byte 1).
ENTITIES.NeedlerOmega.AI_BYTES[0x05]        = 0x00                              -- Speed of horizontal needle (Byte 2).
ENTITIES.NeedlerOmega.AI_BYTES[0x06]        = 0x08                              -- Speed of horizontal needle (Byte 3).
ENTITIES.NeedlerOmega.AI_BYTES[0x07]        = 0x00                              -- Speed of horizontal needle (Byte 4).
ENTITIES.NeedlerOmega.AI_BYTES[0x08]        = 0x00                              -- Speed of vertical needle (Byte 1).
ENTITIES.NeedlerOmega.AI_BYTES[0x09]        = 0x00                              -- Speed of vertical needle (Byte 2).
ENTITIES.NeedlerOmega.AI_BYTES[0x0A]        = 0x03                              -- Speed of vertical needle (Byte 3).
ENTITIES.NeedlerOmega.AI_BYTES[0x0B]        = 0x00                              -- Speed of vertical needle (Byte 4).
ENTITIES.NeedlerOmega.AI_BYTES[0x0C]        = 0x00                              -- Speed of charge (Byte 1).
ENTITIES.NeedlerOmega.AI_BYTES[0x0D]        = 0x80                              -- Speed of charge (Byte 2).
ENTITIES.NeedlerOmega.AI_BYTES[0x0E]        = 0x05                              -- Speed of charge (Byte 3).
ENTITIES.NeedlerOmega.AI_BYTES[0x0F]        = 0x00                              -- Speed of charge (Byte 4).
ENTITIES.NeedlerOmega.BATTLE_NUMBERS        = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Trumpy                             = new_base_entity(ENTITY_KIND.Virus, "Trumpy")
ENTITIES.Trumpy.NAME                        = "Trumpy"
ENTITIES.Trumpy.HP_BASE                     = 90
ENTITIES.Trumpy.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Trumpy.AI_BYTES                    = {}
ENTITIES.Trumpy.AI_BYTES[0x00]              = 0x14                              -- Delay between movement.
ENTITIES.Trumpy.AI_BYTES[0x01]              = 0x64                              -- Delay after attack
ENTITIES.Trumpy.AI_BYTES[0x02]              = 0x55                              -- Duration of fanfare.
ENTITIES.Trumpy.AI_BYTES[0x03]              = 0x01                              -- (??).
ENTITIES.Trumpy.BATTLE_NUMBERS              = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Tuby                               = new_base_entity(ENTITY_KIND.Virus, "Tuby")
ENTITIES.Tuby.NAME                          = "Tuby"
ENTITIES.Tuby.HP_BASE                       = 150
ENTITIES.Tuby.ELEMENT                       = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Tuby.AI_BYTES                      = {}
ENTITIES.Tuby.AI_BYTES[0x00]                = 0x14                              -- Delay between movement.
ENTITIES.Tuby.AI_BYTES[0x01]                = 0x28                              -- Delay after attack
ENTITIES.Tuby.AI_BYTES[0x02]                = 0x55                              -- Duration of fanfare.
ENTITIES.Tuby.AI_BYTES[0x03]                = 0x03                              -- (??).
ENTITIES.Tuby.BATTLE_NUMBERS                = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Tromby                             = new_base_entity(ENTITY_KIND.Virus, "Tromby")
ENTITIES.Tromby.NAME                        = "Tromby"
ENTITIES.Tromby.HP_BASE                     = 200
ENTITIES.Tromby.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Tromby.AI_BYTES                    = {}
ENTITIES.Tromby.AI_BYTES[0x00]              = 0x14                              -- Delay between movement.
ENTITIES.Tromby.AI_BYTES[0x01]              = 0x28                              -- Delay after attack
ENTITIES.Tromby.AI_BYTES[0x02]              = 0x55                              -- Duration of fanfare.
ENTITIES.Tromby.AI_BYTES[0x03]              = 0x23                              -- (??).
ENTITIES.Tromby.BATTLE_NUMBERS              = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.TrumpyOmega                        = new_base_entity(ENTITY_KIND.Virus, "TrumpyOmega")
ENTITIES.TrumpyOmega.NAME                   = "Trumpy\003"
ENTITIES.TrumpyOmega.HP_BASE                = 300
ENTITIES.TrumpyOmega.ELEMENT                = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.TrumpyOmega.AI_BYTES               = {}
ENTITIES.TrumpyOmega.AI_BYTES[0x00]         = 0x02                              -- Delay between movement.
ENTITIES.TrumpyOmega.AI_BYTES[0x01]         = 0x28                              -- Delay after attack
ENTITIES.TrumpyOmega.AI_BYTES[0x02]         = 0xAA                              -- Duration of fanfare.
ENTITIES.TrumpyOmega.AI_BYTES[0x03]         = 0x01                              -- (??).
ENTITIES.TrumpyOmega.BATTLE_NUMBERS         = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

local AlphaBug_Effect = 
{
  NOTHING = 0x00,
  PARALYZE = 0x10,
  CONFUSE = 0x20,
  VINE = 0x30,
}


ENTITIES.QuestionMarkRed                    = new_base_entity(ENTITY_KIND.Virus, "QuestionMarkRed")
ENTITIES.QuestionMarkRed.NAME               = "????"
ENTITIES.QuestionMarkRed.HP_BASE            = 100
ENTITIES.QuestionMarkRed.ELEMENT            = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.QuestionMarkRed.AI_BYTES           = {}
ENTITIES.QuestionMarkRed.AI_BYTES[0x00]     = 0x64                              -- Delay before movement.
ENTITIES.QuestionMarkRed.AI_BYTES[0x01]     = 0x02                              -- Movements before attack.
ENTITIES.QuestionMarkRed.AI_BYTES[0x02]     = 0x32                              -- Damage attack.
ENTITIES.QuestionMarkRed.AI_BYTES[0x03]     = 0x06                              -- Regen delay speed.
ENTITIES.QuestionMarkRed.AI_BYTES[0x04]     = AlphaBug_Effect.PARALYZE + 0x01   -- Attack effect + duration. Long durations pretty much kill you instantly.
ENTITIES.QuestionMarkRed.AI_BYTES[0x05]     = 0x02                              -- Sucking HP delay.
ENTITIES.QuestionMarkRed.AI_BYTES[0x06]     = 0x01                              -- (??).
ENTITIES.QuestionMarkRed.BATTLE_NUMBERS     = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.QuestionMarkBlue                   = new_base_entity(ENTITY_KIND.Virus, "QuestionMarkBlue")
ENTITIES.QuestionMarkBlue.NAME              = "????!"
ENTITIES.QuestionMarkBlue.HP_BASE           = 140
ENTITIES.QuestionMarkBlue.ELEMENT           = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.QuestionMarkBlue.AI_BYTES          = {}
ENTITIES.QuestionMarkBlue.AI_BYTES[0x00]    = 0x50                              -- Delay before movement.
ENTITIES.QuestionMarkBlue.AI_BYTES[0x01]    = 0x02                              -- Movements before attack.
ENTITIES.QuestionMarkBlue.AI_BYTES[0x02]    = 0x46                              -- Damage attack.
ENTITIES.QuestionMarkBlue.AI_BYTES[0x03]    = 0x06                              -- Regen delay speed.
ENTITIES.QuestionMarkBlue.AI_BYTES[0x04]    = AlphaBug_Effect.PARALYZE + 0x01   -- Attack effect.
ENTITIES.QuestionMarkBlue.AI_BYTES[0x05]    = 0x01                              -- Sucking HP delay.
ENTITIES.QuestionMarkBlue.AI_BYTES[0x06]    = 0x01                              -- (??).
ENTITIES.QuestionMarkBlue.BATTLE_NUMBERS    = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.AlphaBug                           = new_base_entity(ENTITY_KIND.Virus, "AlphaBug")
ENTITIES.AlphaBug.NAME                      = "AlphaBug"
ENTITIES.AlphaBug.HP_BASE                   = 180
ENTITIES.AlphaBug.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.AlphaBug.AI_BYTES                  = {}
ENTITIES.AlphaBug.AI_BYTES[0x00]            = 0x3C                              -- Delay before movement.
ENTITIES.AlphaBug.AI_BYTES[0x01]            = 0x02                              -- Movements before attack.
ENTITIES.AlphaBug.AI_BYTES[0x02]            = 0x5A                              -- Damage attack.
ENTITIES.AlphaBug.AI_BYTES[0x03]            = 0x05                              -- Regen delay speed.
ENTITIES.AlphaBug.AI_BYTES[0x04]            = AlphaBug_Effect.PARALYZE + 0x02   -- Attack effect.
ENTITIES.AlphaBug.AI_BYTES[0x05]            = 0x01                              -- Sucking HP delay.
ENTITIES.AlphaBug.AI_BYTES[0x06]            = 0x01                              -- (??).
ENTITIES.AlphaBug.BATTLE_NUMBERS            = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.AlphaBugOmega                      = new_base_entity(ENTITY_KIND.Virus, "AlphaBugOmega")
ENTITIES.AlphaBugOmega.NAME                 = "AlphaBug\003"
ENTITIES.AlphaBugOmega.HP_BASE              = 300
ENTITIES.AlphaBugOmega.ELEMENT              = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.AlphaBugOmega.AI_BYTES             = {}
ENTITIES.AlphaBugOmega.AI_BYTES[0x00]       = 0x28                              -- Delay before movement.
ENTITIES.AlphaBugOmega.AI_BYTES[0x01]       = 0x02                              -- Movements before attack.
ENTITIES.AlphaBugOmega.AI_BYTES[0x02]       = 0x96                              -- Damage attack.
ENTITIES.AlphaBugOmega.AI_BYTES[0x03]       = 0x04                              -- Regen delay speed.
ENTITIES.AlphaBugOmega.AI_BYTES[0x04]       = AlphaBug_Effect.PARALYZE + 0x02   -- Attack effect.
ENTITIES.AlphaBugOmega.AI_BYTES[0x05]       = 0x01                              -- Sucking HP delay.
ENTITIES.AlphaBugOmega.AI_BYTES[0x06]       = 0x01                              -- (??).
ENTITIES.AlphaBugOmega.BATTLE_NUMBERS       = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Quaker                             = new_base_entity(ENTITY_KIND.Virus, "Quaker")
ENTITIES.Quaker.NAME                        = "Quaker"
ENTITIES.Quaker.HP_BASE                     = 80
ENTITIES.Quaker.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Quaker.AI_BYTES                    = {}
ENTITIES.Quaker.AI_BYTES[0x00]              = 0x1E                              -- Delay before jump.
ENTITIES.Quaker.AI_BYTES[0x01]              = 0x0F                              -- Damage shockwave.
ENTITIES.Quaker.AI_BYTES[0xC1BE]            = 0x14                              -- Delay before acting. This is shared with all other Quaker viruses in the same battle.
ENTITIES.Quaker.BATTLE_NUMBERS              = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Shaker                             = new_base_entity(ENTITY_KIND.Virus, "Shaker")
ENTITIES.Shaker.NAME                        = "Shaker"
ENTITIES.Shaker.HP_BASE                     = 140
ENTITIES.Shaker.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Shaker.AI_BYTES                    = {}
ENTITIES.Shaker.AI_BYTES[0x00]              = 0x14                              -- Delay before jump.
ENTITIES.Shaker.AI_BYTES[0x01]              = 0x28                              -- Damage shockwave.
ENTITIES.Shaker.AI_BYTES[0xC1BC]            = 0x14                              -- Delay before acting. This is shared with all other Quaker viruses in the same battle.
ENTITIES.Shaker.BATTLE_NUMBERS              = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Breaker                            = new_base_entity(ENTITY_KIND.Virus, "Breaker")
ENTITIES.Breaker.NAME                       = "Breaker"
ENTITIES.Breaker.HP_BASE                    = 240
ENTITIES.Breaker.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Breaker.AI_BYTES                   = {}
ENTITIES.Breaker.AI_BYTES[0x00]             = 0x0A                              -- Delay before jump.
ENTITIES.Breaker.AI_BYTES[0x01]             = 0x50                              -- Damage shockwave.
ENTITIES.Breaker.AI_BYTES[0xC1BA]           = 0x14                              -- Delay before acting. This is shared with all other Quaker viruses in the same battle.
ENTITIES.Breaker.BATTLE_NUMBERS             = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.QuakerOmega                        = new_base_entity(ENTITY_KIND.Virus, "QuakerOmega")
ENTITIES.QuakerOmega.NAME                   = "Quaker\003"
ENTITIES.QuakerOmega.HP_BASE                = 360
ENTITIES.QuakerOmega.ELEMENT                = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.QuakerOmega.AI_BYTES               = {}
ENTITIES.QuakerOmega.AI_BYTES[0x00]         = 0x05                              -- Delay before jump.
ENTITIES.QuakerOmega.AI_BYTES[0x01]         = 0x96                              -- Damage shockwave.
ENTITIES.QuakerOmega.AI_BYTES[0xC1B8]       = 0x14                              -- Delay before acting. This is shared with all other Quaker viruses in the same battle.
ENTITIES.QuakerOmega.BATTLE_NUMBERS         = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.N_O                                = new_base_entity(ENTITY_KIND.Virus, "N_O")
ENTITIES.N_O.NAME                           = "N.O"
ENTITIES.N_O.HP_BASE                        = 120
ENTITIES.N_O.ELEMENT                        = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.N_O.AI_BYTES                       = {}
ENTITIES.N_O.AI_BYTES[0x00]                 = 0x0C                              -- Delay speed movement.
ENTITIES.N_O.AI_BYTES[0x01]                 = 0x10                              -- Delay before movement.
ENTITIES.N_O.AI_BYTES[0x02]                 = 0x32                              -- Delay before attacks.
ENTITIES.N_O.AI_BYTES[0x03]                 = 0x32                              -- Damage attack.
ENTITIES.N_O.AI_BYTES[0x04]                 = 0x01                              -- (??).
ENTITIES.N_O.AI_BYTES[0x05]                 = 0x05                              -- Attack speed delay.
--ENTITIES.N_O.BATTLE_NUMBERS                 = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.N_O_2                              = new_base_entity(ENTITY_KIND.Virus, "N_O_2")
ENTITIES.N_O_2.NAME                         = "N.O-2"
ENTITIES.N_O_2.HP_BASE                      = 160
ENTITIES.N_O_2.ELEMENT                      = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.N_O_2.AI_BYTES                     = {}
ENTITIES.N_O_2.AI_BYTES[0x00]               = 0x08                              -- Delay speed movement.
ENTITIES.N_O_2.AI_BYTES[0x01]               = 0x0C                              -- Delay before movement.
ENTITIES.N_O_2.AI_BYTES[0x02]               = 0x28                              -- Delay before attacks.
ENTITIES.N_O_2.AI_BYTES[0x03]               = 0x50                              -- Damage attack.
ENTITIES.N_O_2.AI_BYTES[0x04]               = 0x01                              -- (??).
ENTITIES.N_O_2.AI_BYTES[0x05]               = 0x05                              -- Attack speed delay.
--ENTITIES.N_O_2.BATTLE_NUMBERS               = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.N_O_3                              = new_base_entity(ENTITY_KIND.Virus, "N_O_3")
ENTITIES.N_O_3.NAME                         = "N.O-3"
ENTITIES.N_O_3.HP_BASE                      = 200
ENTITIES.N_O_3.ELEMENT                      = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.N_O_3.AI_BYTES                     = {}
ENTITIES.N_O_3.AI_BYTES[0x00]               = 0x06                              -- Delay speed movement.
ENTITIES.N_O_3.AI_BYTES[0x01]               = 0x08                              -- Delay before movement.
ENTITIES.N_O_3.AI_BYTES[0x02]               = 0x1E                              -- Delay before attacks.
ENTITIES.N_O_3.AI_BYTES[0x03]               = 0x78                              -- Damage attack.
ENTITIES.N_O_3.AI_BYTES[0x04]               = 0x01                              -- (??).
ENTITIES.N_O_3.AI_BYTES[0x05]               = 0x05                              -- Attack speed delay.
ENTITIES.N_O_3.BATTLE_NUMBERS               = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.N_O_Omega                          = new_base_entity(ENTITY_KIND.Virus, "N_O_Omega")
ENTITIES.N_O_Omega.NAME                     = "N.O-\003"
ENTITIES.N_O_Omega.HP_BASE                  = 300
ENTITIES.N_O_Omega.ELEMENT                  = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.N_O_Omega.AI_BYTES                 = {}
ENTITIES.N_O_Omega.AI_BYTES[0x00]           = 0x05                              -- Delay speed movement.
ENTITIES.N_O_Omega.AI_BYTES[0x01]           = 0x04                              -- Delay before movement.
ENTITIES.N_O_Omega.AI_BYTES[0x02]           = 0x14                              -- Delay before attacks.
ENTITIES.N_O_Omega.AI_BYTES[0x03]           = 0xC8                              -- Damage attack.
ENTITIES.N_O_Omega.AI_BYTES[0x04]           = 0x02                              -- (??).
ENTITIES.N_O_Omega.AI_BYTES[0x05]           = 0x03                              -- Attack speed delay.
ENTITIES.N_O_Omega.BATTLE_NUMBERS           = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.EleBall                            = new_base_entity(ENTITY_KIND.Virus, "EleBall")
ENTITIES.EleBall.NAME                       = "EleBall"
ENTITIES.EleBall.HP_BASE                    = 80
ENTITIES.EleBall.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_ELEC
ENTITIES.EleBall.AI_BYTES                   = {}
ENTITIES.EleBall.AI_BYTES[0x00]             = 0x14                              -- Damage.
ENTITIES.EleBall.AI_BYTES[0x01]             = 0x10                              -- (??).
ENTITIES.EleBall.AI_BYTES[0x02]             = 0x18                              -- Delay before attack.
ENTITIES.EleBall.AI_BYTES[0x03]             = 0x0F                              -- Attack speed delay.
ENTITIES.EleBall.AI_BYTES[0x04]             = 0x78                              -- Duration of attack.
ENTITIES.EleBall.AI_BYTES[0x05]             = 0x32                              -- Delay after attack.
ENTITIES.EleBall.AI_BYTES[0x06]             = 0x32                              -- Delay speed movement.
ENTITIES.EleBall.BATTLE_NUMBERS             = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.EleSphere                          = new_base_entity(ENTITY_KIND.Virus, "EleSphere")
ENTITIES.EleSphere.NAME                     = "EleSphere"
ENTITIES.EleSphere.HP_BASE                  = 150
ENTITIES.EleSphere.ELEMENT                  = ENTITY_ELEMENT_DEFS.ELEMENT_ELEC
ENTITIES.EleSphere.AI_BYTES                 = {}
ENTITIES.EleSphere.AI_BYTES[0x00]           = 0x32                              -- Damage.
ENTITIES.EleSphere.AI_BYTES[0x01]           = 0x11                              -- (??).
ENTITIES.EleSphere.AI_BYTES[0x02]           = 0x16                              -- Delay before attack.
ENTITIES.EleSphere.AI_BYTES[0x03]           = 0x0C                              -- Attack speed delay.
ENTITIES.EleSphere.AI_BYTES[0x04]           = 0x78                              -- Duration of attack.
ENTITIES.EleSphere.AI_BYTES[0x05]           = 0x32                              -- Delay after attack.
ENTITIES.EleSphere.AI_BYTES[0x06]           = 0x14                              -- Delay speed movement.
ENTITIES.EleSphere.BATTLE_NUMBERS           = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.EleGlobe                           = new_base_entity(ENTITY_KIND.Virus, "EleGlobe")
ENTITIES.EleGlobe.NAME                      = "EleGlobe"
ENTITIES.EleGlobe.HP_BASE                   = 200
ENTITIES.EleGlobe.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_ELEC
ENTITIES.EleGlobe.AI_BYTES                  = {}
ENTITIES.EleGlobe.AI_BYTES[0x00]            = 0x50                              -- Damage.
ENTITIES.EleGlobe.AI_BYTES[0x01]            = 0x12                              -- (??).
ENTITIES.EleGlobe.AI_BYTES[0x02]            = 0x14                              -- Delay before attack.
ENTITIES.EleGlobe.AI_BYTES[0x03]            = 0x0A                              -- Attack speed delay.
ENTITIES.EleGlobe.AI_BYTES[0x04]            = 0x78                              -- Duration of attack.
ENTITIES.EleGlobe.AI_BYTES[0x05]            = 0x32                              -- Delay after attack.
ENTITIES.EleGlobe.AI_BYTES[0x06]            = 0x11                              -- Delay speed movement.
ENTITIES.EleGlobe.BATTLE_NUMBERS            = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.EleBallOmega                       = new_base_entity(ENTITY_KIND.Virus, "EleBallOmega")
ENTITIES.EleBallOmega.NAME                  = "EleBall\003"
ENTITIES.EleBallOmega.HP_BASE               = 200
ENTITIES.EleBallOmega.ELEMENT               = ENTITY_ELEMENT_DEFS.ELEMENT_ELEC
ENTITIES.EleBallOmega.AI_BYTES              = {}
ENTITIES.EleBallOmega.AI_BYTES[0x00]        = 0xA0                              -- Damage.
ENTITIES.EleBallOmega.AI_BYTES[0x01]        = 0x12                              -- (??).
ENTITIES.EleBallOmega.AI_BYTES[0x02]        = 0x10                              -- Delay before attack.
ENTITIES.EleBallOmega.AI_BYTES[0x03]        = 0x08                              -- Attack speed delay.
ENTITIES.EleBallOmega.AI_BYTES[0x04]        = 0x78                              -- Duration of attack.
ENTITIES.EleBallOmega.AI_BYTES[0x05]        = 0x32                              -- Delay after attack.
ENTITIES.EleBallOmega.AI_BYTES[0x06]        = 0x0D                              -- Delay speed movement.
ENTITIES.EleBallOmega.BATTLE_NUMBERS        = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Volcano                            = new_base_entity(ENTITY_KIND.Virus, "Volcano")
ENTITIES.Volcano.NAME                       = "Volcano"
ENTITIES.Volcano.HP_BASE                    = 130
ENTITIES.Volcano.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT
ENTITIES.Volcano.AI_BYTES                   = {}
ENTITIES.Volcano.AI_BYTES[0x00]             = 0x28                              -- Time before attack.
ENTITIES.Volcano.AI_BYTES[0x01]             = 0x18                              -- Movement variable 1.
ENTITIES.Volcano.AI_BYTES[0x02]             = 0x28                              -- Damage lavaball.
ENTITIES.Volcano.AI_BYTES[0x03]             = 0x00                              -- (Number of lavaballs) - 1.
ENTITIES.Volcano.AI_BYTES[0x04]             = 0x00                              -- Movement variable 2 (Byte 1).
ENTITIES.Volcano.AI_BYTES[0x05]             = 0x00                              -- Movement variable 2 (Byte 2).
ENTITIES.Volcano.AI_BYTES[0x06]             = 0x01                              -- Movement variable 2 (Byte 3).
ENTITIES.Volcano.AI_BYTES[0x07]             = 0x00                              -- Movement variable 2 (Byte 4).
ENTITIES.Volcano.AI_BYTES[0x16FA6]          = 0x3C                              -- Initial delay. This is shared with all other Volcano viruses in the same battle.
ENTITIES.Volcano.BATTLE_NUMBERS             = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Volcaner                           = new_base_entity(ENTITY_KIND.Virus, "Volcaner")
ENTITIES.Volcaner.NAME                      = "Volcaner"
ENTITIES.Volcaner.HP_BASE                   = 180
ENTITIES.Volcaner.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT
ENTITIES.Volcaner.AI_BYTES                  = {}
ENTITIES.Volcaner.AI_BYTES[0x00]            = 0x1E                              -- Time before attack.
ENTITIES.Volcaner.AI_BYTES[0x01]            = 0x21                              -- Movement variable 1.
ENTITIES.Volcaner.AI_BYTES[0x02]            = 0x50                              -- Damage lavaball.
ENTITIES.Volcaner.AI_BYTES[0x03]            = 0x00                              -- (Number of lavaballs) - 1.
ENTITIES.Volcaner.AI_BYTES[0x04]            = 0x33                              -- Movement variable 2 (Byte 1).
ENTITIES.Volcaner.AI_BYTES[0x05]            = 0x33                              -- Movement variable 2 (Byte 2).
ENTITIES.Volcaner.AI_BYTES[0x06]            = 0x01                              -- Movement variable 2 (Byte 3).
ENTITIES.Volcaner.AI_BYTES[0x07]            = 0x00                              -- Movement variable 2 (Byte 4).
ENTITIES.Volcaner.AI_BYTES[0x16F9E]         = 0x3C                              -- Initial delay. This is shared with all other Volcano viruses in the same battle.
ENTITIES.Volcaner.BATTLE_NUMBERS            = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Volcanest                          = new_base_entity(ENTITY_KIND.Virus, "Volcanest")
ENTITIES.Volcanest.NAME                     = "Volcanest"
ENTITIES.Volcanest.HP_BASE                  = 230
ENTITIES.Volcanest.ELEMENT                  = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT
ENTITIES.Volcanest.AI_BYTES                 = {}
ENTITIES.Volcanest.AI_BYTES[0x00]           = 0x2D                              -- Time before attack.
ENTITIES.Volcanest.AI_BYTES[0x01]           = 0x10                              -- Movement variable 1.
ENTITIES.Volcanest.AI_BYTES[0x02]           = 0x78                              -- Damage lavaball.
ENTITIES.Volcanest.AI_BYTES[0x03]           = 0x01                              -- (Number of lavaballs) - 1.
ENTITIES.Volcanest.AI_BYTES[0x04]           = 0x00                              -- Movement variable 2 (Byte 1).
ENTITIES.Volcanest.AI_BYTES[0x05]           = 0x80                              -- Movement variable 2 (Byte 2).
ENTITIES.Volcanest.AI_BYTES[0x06]           = 0x01                              -- Movement variable 2 (Byte 3).
ENTITIES.Volcanest.AI_BYTES[0x07]           = 0x00                              -- Movement variable 2 (Byte 4).
ENTITIES.Volcanest.AI_BYTES[0x16F96]        = 0x3C                              -- Initial delay. This is shared with all other Volcano viruses in the same battle.
ENTITIES.Volcanest.BATTLE_NUMBERS           = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.VolcanoOmega                       = new_base_entity(ENTITY_KIND.Virus, "VolcanoOmega")
ENTITIES.VolcanoOmega.NAME                  = "Volcano\003"
ENTITIES.VolcanoOmega.HP_BASE               = 330
ENTITIES.VolcanoOmega.ELEMENT               = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT
ENTITIES.VolcanoOmega.AI_BYTES              = {}
ENTITIES.VolcanoOmega.AI_BYTES[0x00]        = 0x2D                              -- Time before attack.
ENTITIES.VolcanoOmega.AI_BYTES[0x01]        = 0x16                              -- Movement variable 1.
ENTITIES.VolcanoOmega.AI_BYTES[0x02]        = 0xC8                              -- Damage lavaball.
ENTITIES.VolcanoOmega.AI_BYTES[0x03]        = 0x01                              -- (Number of lavaballs) - 1.
ENTITIES.VolcanoOmega.AI_BYTES[0x04]        = 0xCC                              -- Movement variable 2 (Byte 1).
ENTITIES.VolcanoOmega.AI_BYTES[0x05]        = 0xCC                              -- Movement variable 2 (Byte 2).
ENTITIES.VolcanoOmega.AI_BYTES[0x06]        = 0x01                              -- Movement variable 2 (Byte 3).
ENTITIES.VolcanoOmega.AI_BYTES[0x07]        = 0x00                              -- Movement variable 2 (Byte 4).
ENTITIES.VolcanoOmega.AI_BYTES[0x16F8E]     = 0x3C                              -- Initial delay. This is shared with all other Volcano viruses in the same battle.
ENTITIES.VolcanoOmega.BATTLE_NUMBERS        = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Totem                              = new_base_entity(ENTITY_KIND.Virus, "Totem")
ENTITIES.Totem.NAME                         = "Totem"
ENTITIES.Totem.HP_BASE                      = 100
ENTITIES.Totem.ELEMENT                      = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT
ENTITIES.Totem.AI_BYTES                     = {}
ENTITIES.Totem.AI_BYTES[0x00]               = 0x32                              -- Delay between attacks.
ENTITIES.Totem.AI_BYTES[0x01]               = 0x32                              -- Damage fire.
ENTITIES.Totem.AI_BYTES[0x02]               = 0x4B                              -- HP healed.
ENTITIES.Totem.AI_BYTES[0x03]               = 0x7E                              -- Name of the chip when healing.
ENTITIES.Totem.AI_BYTES[0x04]               = 0x03                              -- Don't touch (always 0x03).
ENTITIES.Totem.AI_BYTES[0x05]               = 0x00                              -- Leave at 0x00.
ENTITIES.Totem.AI_BYTES[0x06]               = 0xB4                              -- Duration of attack.
ENTITIES.Totem.AI_BYTES[0x07]               = 0x3C                              -- Delay before each flame appears.
ENTITIES.Totem.BATTLE_NUMBERS               = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Totam                              = new_base_entity(ENTITY_KIND.Virus, "Totam")
ENTITIES.Totam.NAME                         = "Totam"
ENTITIES.Totam.HP_BASE                      = 160
ENTITIES.Totam.ELEMENT                      = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT
ENTITIES.Totam.AI_BYTES                     = {}
ENTITIES.Totam.AI_BYTES[0x00]               = 0x32                              -- Delay between attacks.
ENTITIES.Totam.AI_BYTES[0x01]               = 0x64                              -- Damage fire.
ENTITIES.Totam.AI_BYTES[0x02]               = 0x64                              -- HP healed.
ENTITIES.Totam.AI_BYTES[0x03]               = 0x7F                              -- Name of the chip when healing.
ENTITIES.Totam.AI_BYTES[0x04]               = 0x03                              -- Don't touch (always 0x03).
ENTITIES.Totam.AI_BYTES[0x05]               = 0x00                              -- Leave at 0x00.
ENTITIES.Totam.AI_BYTES[0x06]               = 0xB4                              -- Duration of attack.
ENTITIES.Totam.AI_BYTES[0x07]               = 0x3C                              -- Delay before each flame appears.
ENTITIES.Totam.BATTLE_NUMBERS               = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Totun                              = new_base_entity(ENTITY_KIND.Virus, "Totun")
ENTITIES.Totun.NAME                         = "Totun"
ENTITIES.Totun.HP_BASE                      = 250
ENTITIES.Totun.ELEMENT                      = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT
ENTITIES.Totun.AI_BYTES                     = {}
ENTITIES.Totun.AI_BYTES[0x00]               = 0x19                              -- Delay between attacks.
ENTITIES.Totun.AI_BYTES[0x01]               = 0x96                              -- Damage fire.
ENTITIES.Totun.AI_BYTES[0x02]               = 0x96                              -- HP healed.
ENTITIES.Totun.AI_BYTES[0x03]               = 0x80                              -- Name of the chip when healing.
ENTITIES.Totun.AI_BYTES[0x04]               = 0x03                              -- Don't touch (always 0x03).
ENTITIES.Totun.AI_BYTES[0x05]               = 0x00                              -- Leave at 0x00.
ENTITIES.Totun.AI_BYTES[0x06]               = 0x96                              -- Duration of attack.
ENTITIES.Totun.AI_BYTES[0x07]               = 0x32                              -- Delay before each flame appears.
ENTITIES.Totun.BATTLE_NUMBERS               = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.TotemOmega                         = new_base_entity(ENTITY_KIND.Virus, "TotemOmega")
ENTITIES.TotemOmega.NAME                    = "Totem\003"
ENTITIES.TotemOmega.HP_BASE                 = 300
ENTITIES.TotemOmega.ELEMENT                 = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT
ENTITIES.TotemOmega.AI_BYTES                = {}
ENTITIES.TotemOmega.AI_BYTES[0x00]          = 0x19                              -- Delay between attacks.
ENTITIES.TotemOmega.AI_BYTES[0x01]          = 0xC8                              -- Damage fire.
ENTITIES.TotemOmega.AI_BYTES[0x02]          = 0x96                              -- HP healed.
ENTITIES.TotemOmega.AI_BYTES[0x03]          = 0x80                              -- Name of the chip when healing.
ENTITIES.TotemOmega.AI_BYTES[0x04]          = 0x03                              -- Don't touch (always 0x03).
ENTITIES.TotemOmega.AI_BYTES[0x05]          = 0x00                              -- Leave at 0x00.
ENTITIES.TotemOmega.AI_BYTES[0x06]          = 0x96                              -- Duration of attack.
ENTITIES.TotemOmega.AI_BYTES[0x07]          = 0x32                              -- Delay before each flame appears.
ENTITIES.TotemOmega.BATTLE_NUMBERS          = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Twins                              = new_base_entity(ENTITY_KIND.Virus, "Twins")
ENTITIES.Twins.NAME                         = "Twins"
ENTITIES.Twins.HP_BASE                      = 100
ENTITIES.Twins.ELEMENT                      = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Twins.AI_BYTES                     = {}
ENTITIES.Twins.AI_BYTES[0x00]               = 0xB4                              -- (??). Probably some kind of delay.
ENTITIES.Twins.AI_BYTES[0x01]               = 0x1E                              -- Damage.
ENTITIES.Twins.AI_BYTES[0x02]               = 0x78                              -- (??). Probably some kind of delay.
ENTITIES.Twins.BATTLE_NUMBERS               = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Twinner                            = new_base_entity(ENTITY_KIND.Virus, "Twinner")
ENTITIES.Twinner.NAME                       = "Twinner"
ENTITIES.Twinner.HP_BASE                    = 150
ENTITIES.Twinner.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Twinner.AI_BYTES                   = {}
ENTITIES.Twinner.AI_BYTES[0x00]             = 0x8C                              -- (??). Probably some kind of delay.
ENTITIES.Twinner.AI_BYTES[0x01]             = 0x3C                              -- Damage.
ENTITIES.Twinner.AI_BYTES[0x02]             = 0x64                              -- (??). Probably some kind of delay.
ENTITIES.Twinner.BATTLE_NUMBERS             = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Twinnest                           = new_base_entity(ENTITY_KIND.Virus, "Twinnest")
ENTITIES.Twinnest.NAME                      = "Twinnest"
ENTITIES.Twinnest.HP_BASE                   = 200
ENTITIES.Twinnest.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.Twinnest.AI_BYTES                  = {}
ENTITIES.Twinnest.AI_BYTES[0x00]            = 0x64                              -- (??). Probably some kind of delay.
ENTITIES.Twinnest.AI_BYTES[0x01]            = 0x5A                              -- Damage.
ENTITIES.Twinnest.AI_BYTES[0x02]            = 0x50                              -- (??). Probably some kind of delay.
ENTITIES.Twinnest.BATTLE_NUMBERS            = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.TwinsOmega                         = new_base_entity(ENTITY_KIND.Virus, "TwinsOmega")
ENTITIES.TwinsOmega.NAME                    = "Twins\003"
ENTITIES.TwinsOmega.HP_BASE                 = 300
ENTITIES.TwinsOmega.ELEMENT                 = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.TwinsOmega.AI_BYTES                = {}
ENTITIES.TwinsOmega.AI_BYTES[0x00]          = 0x3C                              -- (??). Probably some kind of delay.
ENTITIES.TwinsOmega.AI_BYTES[0x01]          = 0x96                              -- Damage.
ENTITIES.TwinsOmega.AI_BYTES[0x02]          = 0x3C                              -- (??). Probably some kind of delay.
ENTITIES.TwinsOmega.BATTLE_NUMBERS          = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Boomer                             = new_base_entity(ENTITY_KIND.Virus, "Boomer")
ENTITIES.Boomer.NAME                        = "Boomer"
ENTITIES.Boomer.HP_BASE                     = 70
ENTITIES.Boomer.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_WOOD
ENTITIES.Boomer.AI_BYTES                    = {}
ENTITIES.Boomer.AI_BYTES[0x00]              = 0x3C                              -- Vertical movement speed delay.
ENTITIES.Boomer.AI_BYTES[0x01]              = 0x00                              -- Number of PanelGrab chips.
ENTITIES.Boomer.AI_BYTES[0x02]              = 0x00                              -- Number of attacks before using PanelGrab.
ENTITIES.Boomer.AI_BYTES[0x03]              = 0x1E                              -- Damage boomerang.
ENTITIES.Boomer.AI_BYTES[0x04]              = 0x78                              -- Delay after attack.
ENTITIES.Boomer.AI_BYTES[0x05]              = 0x05                              -- Speed of attack.
ENTITIES.Boomer.AI_BYTES[0x06]              = 0x00                              -- Not read.
ENTITIES.Boomer.AI_BYTES[0x07]              = 0x00                              -- Not read.
ENTITIES.Boomer.BATTLE_NUMBERS              = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Gloomer                            = new_base_entity(ENTITY_KIND.Virus, "Gloomer")
ENTITIES.Gloomer.NAME                       = "Gloomer"
ENTITIES.Gloomer.HP_BASE                    = 140
ENTITIES.Gloomer.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_WOOD
ENTITIES.Gloomer.AI_BYTES                   = {}
ENTITIES.Gloomer.AI_BYTES[0x00]             = 0x28                              -- Vertical movement speed delay.
ENTITIES.Gloomer.AI_BYTES[0x01]             = 0x01                              -- Number of PanelGrab chips.
ENTITIES.Gloomer.AI_BYTES[0x02]             = 0x03                              -- Number of attacks before using PanelGrab.
ENTITIES.Gloomer.AI_BYTES[0x03]             = 0x3C                              -- Damage boomerang.
ENTITIES.Gloomer.AI_BYTES[0x04]             = 0x78                              -- Delay after attack.
ENTITIES.Gloomer.AI_BYTES[0x05]             = 0x06                              -- Speed of attack.
ENTITIES.Gloomer.AI_BYTES[0x06]             = 0x00                              -- Not read.
ENTITIES.Gloomer.AI_BYTES[0x07]             = 0x00                              -- Not read.
ENTITIES.Gloomer.BATTLE_NUMBERS             = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Doomer                             = new_base_entity(ENTITY_KIND.Virus, "Doomer")
ENTITIES.Doomer.NAME                        = "Doomer"
ENTITIES.Doomer.HP_BASE                     = 180
ENTITIES.Doomer.ELEMENT                     = ENTITY_ELEMENT_DEFS.ELEMENT_WOOD
ENTITIES.Doomer.AI_BYTES                    = {}
ENTITIES.Doomer.AI_BYTES[0x00]              = 0x1E                              -- Vertical movement speed delay.
ENTITIES.Doomer.AI_BYTES[0x01]              = 0x02                              -- Number of PanelGrab chips.
ENTITIES.Doomer.AI_BYTES[0x02]              = 0x03                              -- Number of attacks before using PanelGrab.
ENTITIES.Doomer.AI_BYTES[0x03]              = 0x5A                              -- Damage boomerang.
ENTITIES.Doomer.AI_BYTES[0x04]              = 0x78                              -- Delay after attack.
ENTITIES.Doomer.AI_BYTES[0x05]              = 0x07                              -- Speed of attack.
ENTITIES.Doomer.AI_BYTES[0x06]              = 0x00                              -- Not read.
ENTITIES.Doomer.AI_BYTES[0x07]              = 0x00                              -- Not read.
ENTITIES.Doomer.BATTLE_NUMBERS              = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.BoomerOmega                        = new_base_entity(ENTITY_KIND.Virus, "BoomerOmega")
ENTITIES.BoomerOmega.NAME                   = "Boomer\003"
ENTITIES.BoomerOmega.HP_BASE                = 320
ENTITIES.BoomerOmega.ELEMENT                = ENTITY_ELEMENT_DEFS.ELEMENT_WOOD
ENTITIES.BoomerOmega.AI_BYTES               = {}
ENTITIES.BoomerOmega.AI_BYTES[0x00]         = 0x18                              -- Vertical movement speed delay.
ENTITIES.BoomerOmega.AI_BYTES[0x01]         = 0x02                              -- Number of PanelGrab chips.
ENTITIES.BoomerOmega.AI_BYTES[0x02]         = 0x02                              -- Number of attacks before using PanelGrab.
ENTITIES.BoomerOmega.AI_BYTES[0x03]         = 0x96                              -- Damage boomerang.
ENTITIES.BoomerOmega.AI_BYTES[0x04]         = 0x78                              -- Delay after attack.
ENTITIES.BoomerOmega.AI_BYTES[0x05]         = 0x08                              -- Speed of attack.
ENTITIES.BoomerOmega.AI_BYTES[0x06]         = 0x00                              -- Not read.
ENTITIES.BoomerOmega.AI_BYTES[0x07]         = 0x00                              -- Not read.
ENTITIES.BoomerOmega.BATTLE_NUMBERS         = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Navis --
----------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.FlashMan                           = new_base_entity(ENTITY_KIND.Virus, "FlashMan")
ENTITIES.FlashMan.NAME                      = "FlashMan"
ENTITIES.FlashMan.HP_BASE                   = 300
ENTITIES.FlashMan.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_ELEC
ENTITIES.FlashMan.AI_BYTES                  = {}
ENTITIES.FlashMan.AI_BYTES[0x00]            = 0x0A                              -- (??).
ENTITIES.FlashMan.AI_BYTES[0x01]            = 0x78                              -- Delay before FlashBulb explosion.
ENTITIES.FlashMan.AI_BYTES[0x02]            = 0x0A                              -- Damage FlashTower.
ENTITIES.FlashMan.AI_BYTES[0x03]            = 0x0F                              -- Damage FlashAttack.
ENTITIES.FlashMan.AI_BYTES[0x04]            = 0x05                              -- Bulb's HP.
ENTITIES.FlashMan.AI_BYTES[0x05]            = 0x10                              -- Delay before move 1.
ENTITIES.FlashMan.AI_BYTES[0x06]            = 0x3C                              -- Delay before move 2.
ENTITIES.FlashMan.AI_BYTES[0x07]            = 0x64                              -- Delay after FlashTower.
ENTITIES.FlashMan.AI_BYTES[0x08]            = 0x3C                              -- Delay after FlashAttack.
ENTITIES.FlashMan.AI_BYTES[0x09]            = 0x3C                              -- Delay after FlashBulb.
ENTITIES.FlashMan.AI_BYTES[0x0A]            = 0x00                              -- Number of AreaGrab chips.
ENTITIES.FlashMan.AI_BYTES[0x0B]            = 0x0F                              -- FlashTower speed delay.
ENTITIES.FlashMan.AI_BYTES[0x7E9C]          = 0x24                              -- Delay before FlashAttack.
ENTITIES.FlashMan.AI_BYTES[0x7E98]          = 0x08                              -- Delay before FlashAttack hits.
ENTITIES.FlashMan.BATTLE_NUMBERS            = TIER_1_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

-- TODO: All other Navis are not AI-Documented yet. If necessary (e.g. for making a modded Version), look up the stuff from http://forums.therockManexezone.com/topic/8907775/1/
ENTITIES.FlashManAlpha                      = new_base_entity(ENTITY_KIND.Virus, "FlashManAlpha")
ENTITIES.FlashManAlpha.BATTLE_NUMBERS       = TIER_2_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.FlashManBeta                       = new_base_entity(ENTITY_KIND.Virus, "FlashManBeta")
ENTITIES.FlashManBeta.BATTLE_NUMBERS        = TIER_3_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.FlashManOmega                      = new_base_entity(ENTITY_KIND.Virus, "FlashManOmega")
ENTITIES.FlashManOmega.BATTLE_NUMBERS       = TIER_4_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.BeastMan                           = new_base_entity(ENTITY_KIND.Virus, "BeastMan")
ENTITIES.BeastMan.BATTLE_NUMBERS            = TIER_1_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.BeastManAlpha                      = new_base_entity(ENTITY_KIND.Virus, "BeastManAlpha")
ENTITIES.BeastManAlpha.BATTLE_NUMBERS       = TIER_2_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.BeastManBeta                       = new_base_entity(ENTITY_KIND.Virus, "BeastManBeta")
ENTITIES.BeastManBeta.BATTLE_NUMBERS        = TIER_3_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.BeastManOmega                      = new_base_entity(ENTITY_KIND.Virus, "BeastManOmega")
ENTITIES.BeastManOmega.BATTLE_NUMBERS       = TIER_4_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.BubbleMan                          = new_base_entity(ENTITY_KIND.Virus, "BubbleMan")
ENTITIES.BubbleMan.BATTLE_NUMBERS           = TIER_1_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.BubbleManAlpha                     = new_base_entity(ENTITY_KIND.Virus, "BubbleManAlpha")
ENTITIES.BubbleManAlpha.BATTLE_NUMBERS      = TIER_2_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.BubbleManBeta                      = new_base_entity(ENTITY_KIND.Virus, "BubbleManBeta")
ENTITIES.BubbleManBeta.BATTLE_NUMBERS       = TIER_3_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.BubbleManOmega                     = new_base_entity(ENTITY_KIND.Virus, "BubbleManOmega")
ENTITIES.BubbleManOmega.BATTLE_NUMBERS      = TIER_4_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.DesertMan                          = new_base_entity(ENTITY_KIND.Virus, "DesertMan")
ENTITIES.DesertMan.BATTLE_NUMBERS           = TIER_1_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.DesertManAlpha                     = new_base_entity(ENTITY_KIND.Virus, "DesertManAlpha")
ENTITIES.DesertManAlpha.BATTLE_NUMBERS      = TIER_2_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.DesertManBeta                      = new_base_entity(ENTITY_KIND.Virus, "DesertManBeta")
ENTITIES.DesertManBeta.BATTLE_NUMBERS       = TIER_3_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.DesertManOmega                     = new_base_entity(ENTITY_KIND.Virus, "DesertManOmega")
ENTITIES.DesertManOmega.BATTLE_NUMBERS      = TIER_4_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.PlantMan                           = new_base_entity(ENTITY_KIND.Virus, "PlantMan")
ENTITIES.PlantMan.BATTLE_NUMBERS            = TIER_1_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.PlantManAlpha                      = new_base_entity(ENTITY_KIND.Virus, "PlantManAlpha")
ENTITIES.PlantManAlpha.BATTLE_NUMBERS       = TIER_2_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.PlantManBeta                       = new_base_entity(ENTITY_KIND.Virus, "PlantManBeta")
ENTITIES.PlantManBeta.BATTLE_NUMBERS        = TIER_3_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.PlantManOmega                      = new_base_entity(ENTITY_KIND.Virus, "PlantManOmega")
ENTITIES.PlantManOmega.BATTLE_NUMBERS       = TIER_4_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.FlameMan                           = new_base_entity(ENTITY_KIND.Virus, "FlameMan")
ENTITIES.FlameMan.BATTLE_NUMBERS            = TIER_1_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.FlameManAlpha                      = new_base_entity(ENTITY_KIND.Virus, "FlameManAlpha")
ENTITIES.FlameManAlpha.BATTLE_NUMBERS       = TIER_2_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.FlameManBeta                       = new_base_entity(ENTITY_KIND.Virus, "FlameManBeta")
ENTITIES.FlameManBeta.BATTLE_NUMBERS        = TIER_3_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.FlameManOmega                      = new_base_entity(ENTITY_KIND.Virus, "FlameManOmega")
ENTITIES.FlameManOmega.BATTLE_NUMBERS       = TIER_4_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.DrillMan                           = new_base_entity(ENTITY_KIND.Virus, "DrillMan")
ENTITIES.DrillMan.BATTLE_NUMBERS            = TIER_1_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.DrillManAlpha                      = new_base_entity(ENTITY_KIND.Virus, "DrillManAlpha")
ENTITIES.DrillManAlpha.BATTLE_NUMBERS       = TIER_2_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.DrillManBeta                       = new_base_entity(ENTITY_KIND.Virus, "DrillManBeta")
ENTITIES.DrillManBeta.BATTLE_NUMBERS        = TIER_3_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.DrillManOmega                      = new_base_entity(ENTITY_KIND.Virus, "DrillManOmega")
ENTITIES.DrillManOmega.BATTLE_NUMBERS       = TIER_4_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Alpha                              = new_base_entity(ENTITY_KIND.Virus, "Alpha")
ENTITIES.Alpha.BATTLE_NUMBERS               = TIER_3_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.AlphaOmega                         = new_base_entity(ENTITY_KIND.Virus, "AlphaOmega")
ENTITIES.AlphaOmega.BATTLE_NUMBERS          = TIER_4_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.GutsMan                            = new_base_entity(ENTITY_KIND.Virus, "GutsMan")
ENTITIES.GutsMan.BATTLE_NUMBERS             = TIER_1_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.GutsManAlpha                       = new_base_entity(ENTITY_KIND.Virus, "GutsManAlpha")
ENTITIES.GutsManAlpha.BATTLE_NUMBERS        = TIER_2_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.GutsManBeta                        = new_base_entity(ENTITY_KIND.Virus, "GutsManBeta")
ENTITIES.GutsManBeta.BATTLE_NUMBERS         = TIER_3_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.GutsManOmega                       = new_base_entity(ENTITY_KIND.Virus, "GutsManOmega")
ENTITIES.GutsManOmega.BATTLE_NUMBERS        = TIER_4_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.ProtoMan                           = new_base_entity(ENTITY_KIND.Virus, "ProtoMan")
ENTITIES.ProtoMan.BATTLE_NUMBERS            = TIER_1_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.ProtoManAlpha                      = new_base_entity(ENTITY_KIND.Virus, "ProtoManAlpha")
ENTITIES.ProtoManAlpha.BATTLE_NUMBERS       = TIER_2_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.ProtoManBeta                       = new_base_entity(ENTITY_KIND.Virus, "ProtoManBeta")
ENTITIES.ProtoManBeta.BATTLE_NUMBERS        = TIER_3_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.ProtoManOmega                      = new_base_entity(ENTITY_KIND.Virus, "ProtoManOmega")
ENTITIES.ProtoManOmega.BATTLE_NUMBERS       = TIER_4_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.MetalMan                           = new_base_entity(ENTITY_KIND.Virus, "MetalMan")
ENTITIES.MetalMan.BATTLE_NUMBERS            = TIER_1_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.MetalManAlpha                      = new_base_entity(ENTITY_KIND.Virus, "MetalManAlpha")
ENTITIES.MetalManAlpha.BATTLE_NUMBERS       = TIER_2_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.MetalManBeta                       = new_base_entity(ENTITY_KIND.Virus, "MetalManBeta")
ENTITIES.MetalManBeta.BATTLE_NUMBERS        = TIER_3_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.MetalManOmega                      = new_base_entity(ENTITY_KIND.Virus, "MetalManOmega")
ENTITIES.MetalManOmega.BATTLE_NUMBERS       = TIER_4_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Punk                               = new_base_entity(ENTITY_KIND.Virus, "Punk")
ENTITIES.Punk.BATTLE_NUMBERS                = TIER_1_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.PunkAlpha                          = new_base_entity(ENTITY_KIND.Virus, "PunkAlpha")
ENTITIES.PunkAlpha.BATTLE_NUMBERS           = TIER_2_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.PunkBeta                           = new_base_entity(ENTITY_KIND.Virus, "PunkBeta")
ENTITIES.PunkBeta.BATTLE_NUMBERS            = TIER_3_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.PunkOmega                          = new_base_entity(ENTITY_KIND.Virus, "PunkOmega")
ENTITIES.PunkOmega.BATTLE_NUMBERS           = TIER_4_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.KingMan                            = new_base_entity(ENTITY_KIND.Virus, "KingMan")
ENTITIES.KingMan.BATTLE_NUMBERS             = TIER_1_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.KingManAlpha                       = new_base_entity(ENTITY_KIND.Virus, "KingManAlpha")
ENTITIES.KingManAlpha.BATTLE_NUMBERS        = TIER_2_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.KingManBeta                        = new_base_entity(ENTITY_KIND.Virus, "KingManBeta")
ENTITIES.KingManBeta.BATTLE_NUMBERS         = TIER_3_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.KingManOmega                       = new_base_entity(ENTITY_KIND.Virus, "KingManOmega")
ENTITIES.KingManOmega.BATTLE_NUMBERS        = TIER_4_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.MistMan                            = new_base_entity(ENTITY_KIND.Virus, "MistMan")
ENTITIES.MistMan.BATTLE_NUMBERS             = TIER_1_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.MistManAlpha                       = new_base_entity(ENTITY_KIND.Virus, "MistManAlpha")
ENTITIES.MistManAlpha.BATTLE_NUMBERS        = TIER_2_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.MistManBeta                        = new_base_entity(ENTITY_KIND.Virus, "MistManBeta")
ENTITIES.MistManBeta.BATTLE_NUMBERS         = TIER_3_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.MistManOmega                       = new_base_entity(ENTITY_KIND.Virus, "MistManOmega")
ENTITIES.MistManOmega.BATTLE_NUMBERS        = TIER_4_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.BowlMan                            = new_base_entity(ENTITY_KIND.Virus, "BowlMan")
ENTITIES.BowlMan.BATTLE_NUMBERS             = TIER_1_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.BowlManAlpha                       = new_base_entity(ENTITY_KIND.Virus, "BowlManAlpha")
ENTITIES.BowlManAlpha.BATTLE_NUMBERS        = TIER_2_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.BowlManBeta                        = new_base_entity(ENTITY_KIND.Virus, "BowlManBeta")
ENTITIES.BowlManBeta.BATTLE_NUMBERS         = TIER_3_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.BowlManOmega                       = new_base_entity(ENTITY_KIND.Virus, "BowlManOmega")
ENTITIES.BowlManOmega.BATTLE_NUMBERS        = TIER_4_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.DarkMan                            = new_base_entity(ENTITY_KIND.Virus, "DarkMan")
ENTITIES.DarkMan.BATTLE_NUMBERS             = TIER_2_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.DarkManAlpha                       = new_base_entity(ENTITY_KIND.Virus, "DarkManAlpha")
ENTITIES.DarkManAlpha.BATTLE_NUMBERS        = TIER_3_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.DarkManBeta                        = new_base_entity(ENTITY_KIND.Virus, "DarkManBeta")
ENTITIES.DarkManBeta.BATTLE_NUMBERS         = TIER_4_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.DarkManOmega                       = new_base_entity(ENTITY_KIND.Virus, "DarkManOmega")
ENTITIES.DarkManOmega.BATTLE_NUMBERS        = TIER_4_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.JapanMan                           = new_base_entity(ENTITY_KIND.Virus, "JapanMan")
ENTITIES.JapanMan.BATTLE_NUMBERS            = TIER_2_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.JapanManAlpha                      = new_base_entity(ENTITY_KIND.Virus, "JapanManAlpha")
ENTITIES.JapanManAlpha.BATTLE_NUMBERS       = TIER_3_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.JapanManBeta                       = new_base_entity(ENTITY_KIND.Virus, "JapanManBeta")
ENTITIES.JapanManBeta.BATTLE_NUMBERS        = TIER_4_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.JapanManOmega                      = new_base_entity(ENTITY_KIND.Virus, "JapanManOmega")
ENTITIES.JapanManOmega.BATTLE_NUMBERS       = TIER_4_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Serenade                           = new_base_entity(ENTITY_KIND.Virus, "Serenade")
ENTITIES.Serenade.BATTLE_NUMBERS            = TIER_3_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.SerenadeAlpha                      = new_base_entity(ENTITY_KIND.Virus, "SerenadeAlpha")
ENTITIES.SerenadeAlpha.BATTLE_NUMBERS       = TIER_3_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.SerenadeBeta                       = new_base_entity(ENTITY_KIND.Virus, "SerenadeBeta")
ENTITIES.SerenadeBeta.BATTLE_NUMBERS        = TIER_4_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.SerenadeOmega                      = new_base_entity(ENTITY_KIND.Virus, "SerenadeOmega")
ENTITIES.SerenadeOmega.BATTLE_NUMBERS       = TIER_4_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.Bass                               = new_base_entity(ENTITY_KIND.Virus, "Bass")
ENTITIES.Bass.BATTLE_NUMBERS                = TIER_3_BOSS_BATTLES               -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.BassGS                             = new_base_entity(ENTITY_KIND.Virus, "BassGS")
ENTITIES.BassGS.BATTLE_NUMBERS              = TIER_4_MINIBOSS_BATTLES           -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.BassOmega                          = new_base_entity(ENTITY_KIND.Virus, "BassOmega")
ENTITIES.BassOmega.BATTLE_NUMBERS           = TIER_4_BOSS_BATTLES               -- Battles in which this entity can appear.


























--[[ Crackin' yar panels and stealing yar stuff!
ENTITIES.LolMettaur = deepcopy(ENTITIES.MettaurOmega)
ENTITIES.LolMettaur.HP_BASE = 420
ENTITIES.LolMettaur.NAME = "LolMettr"
ENTITIES.LolMettaur.BATTLE_NUMBERS = {10, 15, 20, 25, 30, 35, 40}
ENTITIES.LolMettaur.AI_BYTES[0x00]        = 20                                -- Base Damage.
ENTITIES.LolMettaur.AI_BYTES[0x01]        = 0x01                              -- Delay before moving.
ENTITIES.LolMettaur.AI_BYTES[0x02]        = 0x01                              -- Delay before attacking.
ENTITIES.LolMettaur.ELEMENT               = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT

-- Introducing - DodgeDoge!
ENTITIES.DodgeDoge = deepcopy(ENTITIES.Spikey)
ENTITIES.DodgeDoge.HP_BASE = 50
ENTITIES.DodgeDoge.NAME = "DodgeDoge"
ENTITIES.DodgeDoge.BATTLE_NUMBERS = {10, 15, 20, 25, 30, 35, 40}
ENTITIES.DodgeDoge.AI_BYTES[0x00]              = 0x01                              -- Movement delay 1.
ENTITIES.DodgeDoge.AI_BYTES[0x01]              = 0x01                              -- Movement delay 2.
ENTITIES.DodgeDoge.AI_BYTES[0x02]              = 0x01                              -- Movement delay 3.
ENTITIES.DodgeDoge.AI_BYTES[0x03]              = 0x01                              -- Movement delay 4.
ENTITIES.DodgeDoge.AI_BYTES[0x04]              = 0x01                              -- Delay after attack.
ENTITIES.DodgeDoge.AI_BYTES[0x05]              = 0x1E                              -- Damage fire.
ENTITIES.DodgeDoge.AI_BYTES[0x06]              = 0x20                              -- Movements before attack.
ENTITIES.DodgeDoge.AI_BYTES[0x07]              = 0x01                              -- Fireball speed delay.




-- DOMINERD Chip TEST, REMOVEME
ENTITIES.GEDDONPLZ = deepcopy(ENTITIES.Dominerd)
ENTITIES.GEDDONPLZ.NAME = "GeddonPlz"
ENTITIES.GEDDONPLZ.AI_BYTES[0x00]            = 0x01                              -- Delay before counter.
ENTITIES.GEDDONPLZ.AI_BYTES[0x01]            = 0x01                              -- Delay before attack without counter.
ENTITIES.GEDDONPLZ.AI_BYTES[0x02]            = 0x50                              -- Vertical boundaries?
ENTITIES.GEDDONPLZ.AI_BYTES[0x03]            = 0x01                              -- Number of Geddon1 chips.
ENTITIES.GEDDONPLZ.AI_BYTES[0x04]            = 0x01                              -- Attacks before using Geddon1.
ENTITIES.GEDDONPLZ.AI_BYTES[0x05]            = 0x01                              -- Delay after attack (own field).
ENTITIES.GEDDONPLZ.AI_BYTES[0x06]            = 0x01                              -- Delay after attack (enemy field).
ENTITIES.GEDDONPLZ.AI_BYTES[0x07]            = 0x32                              -- Damage.
ENTITIES.GEDDONPLZ.AI_BYTES[0x08]            = 0xCC                              -- Vertical speed.
ENTITIES.GEDDONPLZ.AI_BYTES[0x1603C]         = TIME_FREEZE_CHIP_DEFS.GelRain.FAMILY                 -- Chip Family. This is shared between other Dominerd viruses in the same battle.
ENTITIES.GEDDONPLZ.AI_BYTES[0x1603E]         = TIME_FREEZE_CHIP_DEFS.GelRain.SUBFAMILY                             -- Chip Subfamily. This is shared between other Dominerd viruses in the same battle.
ENTITIES.GEDDONPLZ.AI_BYTES[0x16042]         = 20                              -- Chip Damage. This is shared between other Dominerd viruses in the same battle.
ENTITIES.GEDDONPLZ.BATTLE_NUMBERS = {5, 10, 15, 20, 25, 30, 35, 40}--]]































-------------------------------------------------------------------------------
-- DROP_TABLES
-------------------------------------------------------------------------------
ENTITIES.MegaMan.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_random_chip_with_random_code_generator()
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_random_chip_with_random_code_generator()
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_random_chip_with_random_code_generator()
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_random_chip_with_random_code_generator()
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Mettaur.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Guard, CHIP_CODE.Asterisk)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ShockWav)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ShockWav, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.SonicWav)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Mettaur2.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.SonicWav)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.SonicWav)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.SonicWav, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DynaWave)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Mettaur3.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DynaWave)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DynaWave)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DynaWave, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BigWave)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.MettaurOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BigWave)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Mettaur)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BigWave, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Geddon1, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Canodumb.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Cannon)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Cannon)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Cannon, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HiCannon)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Canodumb2.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HiCannon)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HiCannon)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HiCannon, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MCannon)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Canodumb3.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MCannon)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MCannon)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MCannon, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MCannon, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.CanodumbOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MCannon, CHIP_CODE.Asterisk)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ZCanon1)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AtkPlus30, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ZCanon1, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Fishy.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DashAtk)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DashAtk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DashAtk, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Condor)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Fishy2.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Burner)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Burner, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Burning)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Burning, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Fishy3.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Condor)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Burning)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Condor, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Condor, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.FishyOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Condor)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Burning, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Condor, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Tornado, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Swordy.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LongSwrd)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.WideSwrd)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LongSwrd, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AreaGrab, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Swordy2.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FireSwrd)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BambSwrd)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FireSwrd, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BambSwrd, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Swordy3.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AquaSwrd)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ElecSwrd)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AquaSwrd, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ElecSwrd, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.SwordyOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AirSwrd, CHIP_CODE.Asterisk)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.CustSwrd, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HeroSwrd, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.VarSwrd, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Ratty.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Ratton1)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Ratton1)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Ratton1, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Ratton2)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Ratty2.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Ratton2)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Ratton2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Ratton2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Ratton3)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Ratty3.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Ratton3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Ratton3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Ratton3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FireRatn, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.RattyOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Ratton3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Ratton3, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FireRatn, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HyperRat)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.HardHead.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.CannBall)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.CannBall)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.CannBall, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.IceBall)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.ColdHead.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.IceBall)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.IceBall)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.IceBall, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Barrier, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.HotHead.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LavaBall)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LavaBall)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LavaBall, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Barr100, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.HardHeadOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.CannBall, CHIP_CODE.Asterisk)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LavaBall, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Prism, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Barr200, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Jelly.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Wave)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Wave)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Wave, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.RedWave)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.HeatJelly.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.RedWave)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.RedWave)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.RedWave, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MudWave)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.EarthJelly.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MudWave)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MudWave)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MudWave, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Jelly)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.JellyOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Jelly)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MudWave, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Jelly, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AquaPlus30, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Shrimpy.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Bubbler)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Bubbler)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Bubbler, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BubV)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Shrimpy2.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BubV)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BubV)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BubV, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BublSide)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Shrimpy3.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BublSide)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BublSide)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BublSide, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Geyser, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.ShrimpyOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BublSide)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BublSide, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Geyser, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BubSprd)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Spikey.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HeatShot)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HeatShot)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HeatShot, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HeatV)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Spikey2.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HeatV)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HeatV)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HeatV, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HeatSide)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Spikey3.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HeatSide)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HeatSide)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HeatSide, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Spikey)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.SpikeyOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HeatSide)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HeatSide, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Spikey, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BlkBomb3, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Bunny.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ZapRing1)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ZapRing1)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ZapRing1, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ZapRing2)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.TuffBunny.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ZapRing2)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ZapRing2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ZapRing2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ZapRing3)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.MegaBunny.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ZapRing3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ZapRing3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ZapRing3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Bunny)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.BunnyOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ZapRing3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ZapRing3, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Bunny, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ElecPlus30, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.WindBox.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Wind, CHIP_CODE.Asterisk)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Wind, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Tornado)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.NrthWind)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.VacuumFan.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Fan, CHIP_CODE.Asterisk)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Fan, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Tornado)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.NrthWind)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.StormBox.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Wind, CHIP_CODE.Asterisk)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Wind, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Tornado, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.NrthWind, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.WindBoxOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AirSwrd)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Tornado)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Tornado, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.NrthWind, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.PuffBall.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.PoisMask)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.PoisMask)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.PoisMask, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.PoisFace)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.PoofBall.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.PoisFace)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Snake)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.PoisFace, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Geddon3)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.GoofBall.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.PoisFace)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.PoisFace, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Geddon3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AreaGrab, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.PuffBallOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.PoisFace, CHIP_CODE.Asterisk)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.PoisFace, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Geddon3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Anubis)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Mushy.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Spice1)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Spice1)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Spice1, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.GrassStg)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Mashy.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Spice2)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Spice2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Spice2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.GrassStg)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Moshy.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Spice3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Lance)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Spice3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.GrassStg, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.MushyOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Mushy)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Spice3, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Mushy, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.WoodPlus30, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Dominerd.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.CrsShld1)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.CrsShld1)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.CrsShld1, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.CrsShld2)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Dominerd2.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.CrsShld2)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.CrsShld2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.CrsShld2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.CrsShld3)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Dominerd3.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.CrsShld3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AntiDmg)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.CrsShld3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Geddon1, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.DominerdOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.CrsShld3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.CrsShld3, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AntiDmg, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.EverCurse)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Yort.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.YoYo1)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.YoYo1)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.YoYo1, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.YoYo2)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Yurt.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.YoYo2)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.YoYo2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.YoYo2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.YoYo3)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Yart.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.YoYo3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.YoYo3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.YoYo3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AtkPlus10, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.YortOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.YoYo3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.YoYo3, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ZYoyo1)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ZYoyo2)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Shadow.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Shadow)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Hole)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Hole, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AntiSwrd)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.RedDevil.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Shadow)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Hole, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AntiSwrd)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Invis)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.BlueDemon.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Hole, CHIP_CODE.Asterisk)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Shadow, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AntiSwrd, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Invis, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.ShadowOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Shadow, CHIP_CODE.Asterisk)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AntiSwrd, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Invis, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Muramasa, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.BrushMan.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HolyPanl)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HolyPanl)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HolyPanl, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LavaStge, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.BrushMan2.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HolyPanl)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HolyPanl)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HolyPanl, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.SandStge, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.BrushMan3.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HolyPanl)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HolyPanl, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov300)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Snctuary)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.BrushManOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HolyPanl, CHIP_CODE.Asterisk)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HolyPanl, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov300, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Snctuary, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Scutz.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Barr200)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Aura)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LifeAura)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Salamndr, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Scuttle.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Barr200)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Aura)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LifeAura)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Fountain, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Scuttler.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Barr200)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Aura)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LifeAura)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Bolt, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Scuttzer.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Barr200)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Aura)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LifeAura)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.GaiaBlad, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Scuttlest.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Scuttlst)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LifeAura)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Aura, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Scuttlst, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.ScuttleOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Scuttlst, CHIP_CODE.Asterisk)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LifeAura, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DarkAura)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Barr500)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Beetle.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.SnglBomb)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.SnglBomb)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.SnglBomb, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DublBomb)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Deetle.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DublBomb)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DublBomb)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DublBomb, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.TrplBomb)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Geetle.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.TrplBomb)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.TrplBomb)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.TrplBomb, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AirShoes)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.BeetleOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.TrplBomb)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.TrplBomb, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.TrplBomb, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AirShoes, CHIP_CODE.Asterisk) -- TODO: find something more creative, this Virus sucks
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Metrid.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.RndmMetr)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.RndmMetr)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.RndmMetr, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HoleMetr)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Metrod.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HoleMetr)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HoleMetr)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.HoleMetr, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ShotMetr)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Metrodo.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ShotMetr)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ShotMetr)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ShotMetr, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Meteors)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.MetridOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ShotMetr)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ShotMetr, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Meteors)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Meteors, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.SnowBlow.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AirStrm1)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AirStrm1)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AirStrm1, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AirStrm2)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.LowBlow.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AirStrm2)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AirStrm2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AirStrm2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AirStrm3)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.MoBlow.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AirStrm3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AirStrm3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AirStrm3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Tornado, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.SnowBlowOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AirStrm3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AirStrm3, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Tornado, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AtkPlus30, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.KillerEye.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Sensor1)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Sensor1)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Sensor1, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Sensor2)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.DemonEye.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Sensor2)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Sensor2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Sensor2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Sensor3)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.JokerEye.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Sensor3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Sensor3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Sensor3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.KillrEye)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.KillerEyeOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Sensor1, CHIP_CODE.Asterisk)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Sensor2, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Sensor3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.KillrEye, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Momogra.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Mole1)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Mole1)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Mole1, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Mole2)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Momogro.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Mole2)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Mole2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Mole2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Mole3)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Momogre.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Mole3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Mole3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Mole3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Momogra)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.MomograOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Mole3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Momogra, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Mole3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Mole3, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Basher.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Magnum1)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Magnum1)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Magnum1, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Magnum2)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Smasher.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Magnum2)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Magnum2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Magnum2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Magnum3)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Trasher.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Magnum3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Magnum3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Magnum3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Mine)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.BasherOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Magnum3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Magnum3, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Mine, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FirePlus30, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Heavy.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Shake1)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Shake1)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Shake1, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Shake2)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Heavier.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Shake2)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Shake2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Shake2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Shake3)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Heaviest.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Shake3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Shake3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Shake3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.TimeBomb)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.HeavyOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Shake3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Shake3, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.TimeBomb, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Knight, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Pengi.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.IceWave1)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.IceWave1)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.IceWave1, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.IceStage, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Penga.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.IceWave2)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.IceWave2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.IceWave2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.IceStage, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Pengon.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.IceWave3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.IceWave3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.IceWave3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.IceStage, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.PengiOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.IceWave3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.IceWave3, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.IceStage, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AquaPlus, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Viney.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Rope1)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Rope1)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Rope1, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Rope2)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Viner.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Rope2)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Rope2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Rope2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Rope3)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Vinert.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Rope3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Rope3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Rope3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.OldWood)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.VineyOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Rope3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Rope3, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.OldWood, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.WoodPlus30, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Slimer.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetaGel1)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetaGel1)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetaGel1, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetaGel2)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Slimey.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetaGel2)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetaGel2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetaGel2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetaGel3)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Slimest.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetaGel3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetaGel3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetaGel3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.GrabRvng, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.SlimerOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetaGel3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetaGel3, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.GrabRvng, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AquaPlus30, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.EleBee.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Arrow1)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Arrow1)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Arrow1, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Arrow2)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.EleWasp.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Arrow2)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Arrow2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Arrow2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Arrow3)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.EleHornet.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Arrow3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Arrow3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Arrow3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.RockCube, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.EleBeeOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Arrow3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Arrow3, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.RockCube, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ElecPlus30, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Needler.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Needler1)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Needler1)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Needler1, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Needler2)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Nailer.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Needler2)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Needler2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Needler2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Needler3)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Spiker.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Needler3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Needler3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Needler3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.GodStone)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.NeedlerOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Needler3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Needler3, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.GodStone, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov300, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Trumpy.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Fanfare)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Fanfare)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Fanfare, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Discord)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Tuby.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Discord)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Discord)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Discord, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Timpani)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Tromby.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Timpani)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Timpani)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Timpani, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov300, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.TrumpyOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Fanfare, CHIP_CODE.Asterisk)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Discord, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Timpani, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov300, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.QuestionMarkRed.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov50)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov80)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov80, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AntiDmg, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.QuestionMarkBlue.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov80)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov120)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov120, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AntiDmg, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.AlphaBug.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov120)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov150)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov150, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AntiDmg, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.AlphaBugOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov150)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov300)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov300, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AntiDmg, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Quaker.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.RockArm1)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.RockArm1)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.RockArm1, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.RockArm2)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Shaker.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.RockArm2)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.RockArm2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.RockArm2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.RockArm3)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Breaker.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.RockArm3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.RockArm3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.RockArm3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Geddon1, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.QuakerOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.RockArm3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.RockArm3, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.RockArm3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Geddon1, CHIP_CODE.Asterisk) -- TODO: Also very uncreative
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.N_O.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.NoBeam1)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.NoBeam1)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.NoBeam1, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.NoBeam2)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.N_O_2.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.NoBeam2)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.NoBeam2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.NoBeam2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.NoBeam3)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.N_O_3.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.NoBeam3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.NoBeam3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.NoBeam3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov300)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.N_O_Omega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.NoBeam3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.NoBeam3, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.NoBeam3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov300, CHIP_CODE.Asterisk) -- TODO: Also pretty uncreative
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.EleBall.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Plasma1)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Plasma1)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Plasma1, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Plasma2)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.EleSphere.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Plasma2)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Plasma2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Plasma2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Plasma3)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.EleGlobe.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Plasma3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Plasma3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Plasma3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ElecPlus30)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.EleBallOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Plasma3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Plasma3, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Plasma3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ElecPlus30, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Volcano.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LavaCan1)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LavaCan1)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LavaCan1, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LavaCan2)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Volcaner.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LavaCan2)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LavaCan2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LavaCan2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LavaCan3)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Volcanest.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LavaCan3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LavaCan3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LavaCan3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Volcano)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.VolcanoOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LavaCan3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LavaCan3, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Volcano, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FirePlus30, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Totem.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Totem1)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Totem1)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Totem1, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Totem2)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Totam.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Totem2)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Totem2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Totem2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Totem3)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Totun.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Totem3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Totem3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Totem3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov300)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.TotemOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Totem3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Totem3, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov300, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FirePlus30, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Twins.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Team1)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Team1)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Team1, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Team2)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Twinner.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Team2)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Team2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Team2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov200, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Twinnest.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Team1, CHIP_CODE.Asterisk)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Team2, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov200, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov300, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.TwinsOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Team1, CHIP_CODE.Asterisk)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov200, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov200, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Recov300, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Boomer.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Boomer1)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Boomer1)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Boomer1, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Boomer2)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Gloomer.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Boomer2)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Boomer2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Boomer2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Boomer3)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Doomer.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Boomer3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Boomer3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Boomer3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AreaGrab, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.BoomerOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Boomer3)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Boomer3, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AreaGrab, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.WoodPlus30, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.FlashMan.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlashMan, CHIP_CODE.F)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlashMnV2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlashMan, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlashMnV2, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.FlashManAlpha.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlashMnV2, CHIP_CODE.F)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlashMnV3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlashMnV2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlashMnV3, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.FlashManBeta.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlashMnV3, CHIP_CODE.F)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlashMnV4)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlashMnV3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlashMnV4, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.FlashManOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlashMnV5, CHIP_CODE.F)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlashMnV5)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlashMnV5, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FullCust, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.BeastMan.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BeastMan, CHIP_CODE.B)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BeastMnV2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BeastMan, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BeastMnV2, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.BeastManAlpha.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BeastMnV2, CHIP_CODE.B)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BeastMnV3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BeastMnV2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BeastMnV3, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.BeastManBeta.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BeastMnV3, CHIP_CODE.B)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BeastMnV4)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BeastMnV3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BeastMnV4, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.BeastManOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BeastMnV5, CHIP_CODE.B)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BeastMnV5)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BeastMnV5, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FullCust, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.BubbleMan.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BubblMan, CHIP_CODE.B)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BubblMnV2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BubblMan, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BubblMnV2, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.BubbleManAlpha.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BubblMnV2, CHIP_CODE.B)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BubblMnV3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BubblMnV2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BubblMnV3, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.BubbleManBeta.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BubblMnV3, CHIP_CODE.B)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BubblMnV4)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BubblMnV3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BubblMnV4, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.BubbleManOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BubblMnV5, CHIP_CODE.B)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BubblMnV5)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BubblMnV5, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FullCust, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.DesertMan.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DesrtMan, CHIP_CODE.D)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DesrtMnV2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DesrtMan, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DesrtMnV2, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.DesertManAlpha.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DesrtMnV2, CHIP_CODE.D)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DesrtMnV3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DesrtMnV2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DesrtMnV3, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.DesertManBeta.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DesrtMnV3, CHIP_CODE.D)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DesrtMnV4)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DesrtMnV3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DesrtMnV4, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.DesertManOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DesrtMnV5, CHIP_CODE.D)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DesrtMnV5)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DesrtMnV5, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FullCust, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.PlantMan.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.PlantMan, CHIP_CODE.P)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.PlantMnV2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.PlantMan, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.PlantMnV2, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.PlantManAlpha.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.PlantMnV2, CHIP_CODE.P)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.PlantMnV3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.PlantMnV2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.PlantMnV3, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.PlantManBeta.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.PlantMnV3, CHIP_CODE.P)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.PlantMnV4)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.PlantMnV3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.PlantMnV4, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.PlantManOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.PlantMnV5, CHIP_CODE.P)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.PlantMnV5)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.PlantMnV5, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FullCust, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.FlameMan.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlamMan, CHIP_CODE.F)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlamManV2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlamMan, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlamManV2, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.FlameManAlpha.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlamManV2, CHIP_CODE.F)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlamManV3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlamManV2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlamManV3, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.FlameManBeta.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlamManV3, CHIP_CODE.F)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlamManV4)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlamManV3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlamManV4, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.FlameManOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlamManV5, CHIP_CODE.F)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlamManV5)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FlamManV5, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FullCust, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.DrillMan.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DrillMan, CHIP_CODE.D)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DrillMnV2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DrillMan, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DrillMnV2, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.DrillManAlpha.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DrillMnV2, CHIP_CODE.D)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DrillMnV3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DrillMnV2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DrillMnV3, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.DrillManBeta.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DrillMnV3, CHIP_CODE.D)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DrillMnV4)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DrillMnV3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DrillMnV4, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.DrillManOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DrillMnV5, CHIP_CODE.D)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DrillMnV5)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DrillMnV5, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FullCust, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Alpha.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Guardian)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.NaviRcycl, CHIP_CODE.Z)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Guardian, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.NaviRcycl, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.AlphaOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FullCust, CHIP_CODE.Asterisk)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AlphArmSigma, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AlphArmOmega, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FoldrBak, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.GutsMan.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.GutsMan, CHIP_CODE.G)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.GutPunch, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.GutsMan, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.GutsManV2, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.GutsManAlpha.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.GutsManV2, CHIP_CODE.G)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.GutStrgt, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.GutsManV2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.GutsManV3, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.GutsManBeta.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.GutsManV3, CHIP_CODE.G)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.GutImpct, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.GutsManV3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.GutsManV4, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.GutsManOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.GutsManV5, CHIP_CODE.G)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.GutsManV5)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.GutsManV5, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FullCust, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.ProtoMan.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ProtoMan, CHIP_CODE.B)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ProtoMnV2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ProtoMan, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ProtoMnV2, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.ProtoManAlpha.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ProtoMnV2, CHIP_CODE.B)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ProtoMnV3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ProtoMnV2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ProtoMnV3, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.ProtoManBeta.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ProtoMnV3, CHIP_CODE.B)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ProtoMnV4)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ProtoMnV3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ProtoMnV4, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.ProtoManOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ProtoMnV5, CHIP_CODE.B)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DeltaRay, CHIP_CODE.Z)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.ProtoMnV5, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DeltaRay, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.MetalMan.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetalMan, CHIP_CODE.M)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetalMnV2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetalMan, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetalMnV2, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.MetalManAlpha.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetalMnV2, CHIP_CODE.M)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetalMnV3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetalMnV2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetalMnV3, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.MetalManBeta.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetalMnV3, CHIP_CODE.M)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetalMnV4)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetalMnV3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetalMnV4, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.MetalManOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetalMnV5, CHIP_CODE.M)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetalMnV5)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MetalMnV5, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FullCust, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Punk.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Punk, CHIP_CODE.P)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Punk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Punk, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.NaviPlus40, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.PunkAlpha.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Punk, CHIP_CODE.P)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Punk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Punk, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.NaviPlus40, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.PunkBeta.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Punk, CHIP_CODE.P)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Punk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Punk, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.NaviPlus40, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.PunkOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Punk, CHIP_CODE.P)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Punk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Punk, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.NaviPlus40, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.KingMan.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.KingMan, CHIP_CODE.K)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Pawn)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.KingMan, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.KingManV2, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.KingManAlpha.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.KingManV2, CHIP_CODE.K)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Pawn)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.KingManV2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.KingManV3, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.KingManBeta.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.KingManV3, CHIP_CODE.K)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Pawn)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.KingManV3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.KingManV4, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.KingManOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.KingMnV5, CHIP_CODE.K)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Pawn, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.KingMnV5, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FullCust, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.MistMan.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MistMan, CHIP_CODE.M)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MistManV2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MistMan, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MistManV2, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.MistManAlpha.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MistManV2, CHIP_CODE.M)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MistManV3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MistManV2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MistManV3, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.MistManBeta.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MistManV3, CHIP_CODE.M)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MistManV4)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MistManV3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MistManV4, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.MistManOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MistMnV5, CHIP_CODE.M)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MistMnV5)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.MistMnV5, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FullCust, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.BowlMan.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BowlMan, CHIP_CODE.B)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BowlManV2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BowlMan, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BowlManV2, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.BowlManAlpha.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BowlManV2, CHIP_CODE.B)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BowlManV3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BowlManV2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BowlManV3, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.BowlManBeta.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BowlManV3, CHIP_CODE.B)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BowlManV4)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BowlManV3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BowlManV4, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.BowlManOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BowlManV5, CHIP_CODE.B)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BowlManV5)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BowlManV5, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FullCust, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.DarkMan.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DarkMan, CHIP_CODE.D)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DarkManV2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DarkMan, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DarkManV2, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.DarkManAlpha.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DarkManV2, CHIP_CODE.D)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DarkManV3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DarkManV2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DarkManV3, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.DarkManBeta.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DarkManV3, CHIP_CODE.D)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DarkManV4)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DarkManV3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DarkManV4, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.DarkManOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DarkManV5, CHIP_CODE.D)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DarkManV5)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DarkManV5, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FullCust, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.JapanMan.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.JapanMan, CHIP_CODE.Y)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.JapanMnV2)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.JapanMan, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.JapanMnV2, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.JapanManAlpha.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.JapanMnV2, CHIP_CODE.Y)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.JapanMnV3)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.JapanMnV2, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.JapanMnV3, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.JapanManBeta.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.JapanMnV3, CHIP_CODE.Y)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.JapanMnV4)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.JapanMnV3, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.JapanMnV4, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.JapanManOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.JapanMnV5, CHIP_CODE.Y)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.JapanMnV5)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.JapanMnV5, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FullCust, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Serenade.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.NaviPlus40, CHIP_CODE.Asterisk)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DarkAura, CHIP_CODE.A)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Serenade, CHIP_CODE.S)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Serenade, CHIP_CODE.S)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.SerenadeAlpha.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.AtkPlus30, CHIP_CODE.Asterisk)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DarkAura, CHIP_CODE.A)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Serenade, CHIP_CODE.S)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Serenade, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.SerenadeBeta.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DarkAura, CHIP_CODE.A)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Serenade, CHIP_CODE.S)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DarkAura, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Serenade, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.SerenadeOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.DarkAura, CHIP_CODE.Asterisk)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Serenade, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FoldrBak, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FoldrBak, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.Bass.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LifeAura, CHIP_CODE.D)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LifeAura, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Bass, CHIP_CODE.X)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BassPlus, CHIP_CODE.X)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.BassGS.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.LifeAura, CHIP_CODE.Asterisk)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.Bass, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BassPlus, CHIP_CODE.Asterisk)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FoldrBak, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
ENTITIES.BassOmega.DROP_TABLE =
{
  [1] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BassPlus, CHIP_CODE.Asterisk)
  },
  [2] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.FoldrBak, CHIP_CODE.Asterisk)
  },
  [3] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BassGS, CHIP_CODE.X)
  },
  [4] = {
    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,
    CHIP_GEN = CHIP_DEFS.new_chip_generator(CHIP_ID.BassGS, CHIP_CODE.Asterisk)
  }
}
-------------------------------------------------------------------------------





































return ENTITIES