local ENTITIES = {}
local ENTITY_TYPE = require "defs.entity_type_defs"
local ENTITY_KIND = require "defs.entity_kind_defs"
local ENTITY_AI_ADDRESS = require "defs.entity_ai_address_defs"
local ENTITY_HP_TRANSLATOR = require "defs.entity_hp_defs"
local ENTITY_NAME_ADDRESS_TRANSLATOR = require "defs.entity_name_defs"
local ENTITY_PALETTE_DEFS = require "defs.entity_palette_defs"
local ENTITY_ELEMENT_DEFS = require "defs.entity_element_defs"
local GAUNTLET_DEFS = require "defs.gauntlet_defs"
local deepcopy = require "deepcopy"

--Here, we define all enemies for the other functions to randomize. Also we can define other combinations later on, e.g. if we want to change attack delay and stuff.

local BASE_BATTLE_DATA = {
    KIND = ENTITY_KIND.Virus,
    X_POS = 0x02, -- We use these defaults so we don't have to change Megaman's starting position later on
    Y_POS = 0x02, -- We use these defaults so we don't have to change Megaman's starting position later on
    TYPE = ENTITY_TYPE.Mettaur
}


function new_battle_data(entity_kind, entity_type)

    local new_battle_data = deepcopy(BASE_BATTLE_DATA)

    new_battle_data.KIND = entity_kind
    new_battle_data.TYPE = entity_type

    return new_battle_data

end

-- This returns a new base entity containing battle data, name address and HP address.
-- Unfortunately, damage and AI addresses need to be done manually, which sucks.
function new_base_entity(entity_kind, entity_id)

    local new_base_entity = {}


    local entity_type = ENTITY_TYPE[entity_id]
    new_base_entity.BATTLE_DATA = new_battle_data(entity_kind, entity_type)
    new_base_entity.NAME_ADDRESS = ENTITY_NAME_ADDRESS_TRANSLATOR[entity_id]

    -- This should just return nil for Megaman and do nothing
    new_base_entity.HP_ADDRESS = ENTITY_HP_TRANSLATOR.translate(entity_type)

    new_base_entity.AI_ADDRESS = ENTITY_AI_ADDRESS[entity_id]

    new_base_entity.ELEMENT = ENTITY_ELEMENT_DEFS.ELEMENT_NONE

    return new_base_entity
end

ENTITIES.Megaman                            = new_base_entity(ENTITY_KIND.Megaman, "Megaman")

--All AI Bytes need to be looked up at http://forums.therockmanexezone.com/topic/8907775/1/


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
for i = 11,20 do

    if i ~= 15 and i ~= 20 then
        TIER_2_BATTLES_WITHOUT_BOSSES[i] = i
    end
    
end

local TIER_3_BATTLES_WITHOUT_BOSSES = {}
for i = 21,30 do

    if i ~= 25 and i ~= 30 then
        TIER_3_BATTLES_WITHOUT_BOSSES[i] = i
    end
    
end

local TIER_4_BATTLES_WITHOUT_BOSSES = {}
for i = 31,40 do

    if i ~= 35 and i ~= 40 then
        TIER_4_BATTLES_WITHOUT_BOSSES[i] = i
    end
    
end

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

ENTITIES.HardHead                           = new_base_entity(ENTITY_KIND.Virus, "HardHead")
ENTITIES.HardHead.NAME                      = "HardHead"
ENTITIES.HardHead.HP_BASE                   = 80
ENTITIES.HardHead.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.HardHead.AI_BYTES                  = {}
ENTITIES.HardHead.AI_BYTES[0x00]            = 0xF0                              -- Delay before shooting.
ENTITIES.HardHead.AI_BYTES[0x01]            = 0x3C                              -- Damage hardball.
ENTITIES.HardHead.AI_BYTES[0x02]            = 0x00                              -- Type of ball. 0x00 == break panel, 0x01 == ice ball, 0x02 == lava ball.
ENTITIES.HardHead.AI_BYTES[0x14576]         = 0x32                              -- Delay before shooting (animation). Shared with other HardHead viruses in the same battle.
ENTITIES.HardHead.AI_BYTES[0x14614]         = 0x1E                              -- Delay after attack. Shared with other HardHead viruses in the same battle.
ENTITIES.HardHead.BATTLE_NUMBERS            = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.ColdHead                           = new_base_entity(ENTITY_KIND.Virus, "ColdHead")
ENTITIES.ColdHead.NAME                      = "ColdHead"
ENTITIES.ColdHead.HP_BASE                   = 120
ENTITIES.ColdHead.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_AQUA
ENTITIES.ColdHead.AI_BYTES                  = {}
ENTITIES.ColdHead.AI_BYTES[0x00]            = 0x96                              -- Delay before shooting.
ENTITIES.ColdHead.AI_BYTES[0x01]            = 0x64                              -- Damage hardball.
ENTITIES.ColdHead.AI_BYTES[0x02]            = 0x01                              -- Type of ball. 0x00 == break panel, 0x01 == ice ball, 0x02 == lava ball.
ENTITIES.ColdHead.AI_BYTES[0x14576]         = 0x32                              -- Delay before shooting (animation). Shared with other HardHead viruses in the same battle.
ENTITIES.ColdHead.AI_BYTES[0x14614]         = 0x1E                              -- Delay after attack. Shared with other HardHead viruses in the same battle.
ENTITIES.ColdHead.BATTLE_NUMBERS            = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.HotHead                            = new_base_entity(ENTITY_KIND.Virus, "HotHead")
ENTITIES.HotHead.NAME                       = "HotHead"
ENTITIES.HotHead.HP_BASE                    = 200
ENTITIES.HotHead.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT
ENTITIES.HotHead.AI_BYTES                   = {}
ENTITIES.HotHead.AI_BYTES[0x00]             = 0x5A                              -- Delay before shooting.
ENTITIES.HotHead.AI_BYTES[0x01]             = 0x64                              -- Damage hardball.
ENTITIES.HotHead.AI_BYTES[0x02]             = 0x02                              -- Type of ball. 0x00 == break panel, 0x01 == ice ball, 0x02 == lava ball.
ENTITIES.HotHead.AI_BYTES[0x14576]          = 0x32                              -- Delay before shooting (animation). Shared with other HardHead viruses in the same battle.
ENTITIES.HotHead.AI_BYTES[0x14614]          = 0x1E                              -- Delay after attack. Shared with other HardHead viruses in the same battle.
ENTITIES.HotHead.BATTLE_NUMBERS             = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.HardHeadOmega                      = new_base_entity(ENTITY_KIND.Virus, "HardHeadOmega")
ENTITIES.HardHeadOmega.NAME                 = "HardHead\003"
ENTITIES.HardHeadOmega.HP_BASE              = 300
ENTITIES.HardHeadOmega.ELEMENT              = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.HardHeadOmega.AI_BYTES             = {}
ENTITIES.HardHeadOmega.AI_BYTES[0x00]       = 0xF0                              -- Delay before shooting.
ENTITIES.HardHeadOmega.AI_BYTES[0x01]       = 0xC8                              -- Damage hardball.
ENTITIES.HardHeadOmega.AI_BYTES[0x02]       = 0x00                              -- Type of ball. 0x00 == break panel, 0x01 == ice ball, 0x02 == lava ball.
ENTITIES.HardHeadOmega.AI_BYTES[0x14576]    = 0x32                              -- Delay before shooting (animation). Shared with other HardHead viruses in the same battle.
ENTITIES.HardHeadOmega.AI_BYTES[0x14614]    = 0x1E                              -- Delay after attack. Shared with other HardHead viruses in the same battle.
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
ENTITIES.EarthJelly.NAME                    = "EarthJelly"
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
ENTITIES.Shrimpy2.AI_BYTES[0xA20E]          = 0x10                              -- Delay after attack. This is shared with all other Shrimpy viruses in the same battle.
ENTITIES.Shrimpy2.BATTLE_NUMBERS            = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.Shrimpy3                           = new_base_entity(ENTITY_KIND.Virus, "Shrimpy3")
ENTITIES.Shrimpy3.NAME                      = "Shrimpy3"
ENTITIES.Shrimpy3.HP_BASE                   = 160
ENTITIES.Shrimpy3.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_AQUA
ENTITIES.Shrimpy3.AI_BYTES                  = {}
ENTITIES.Shrimpy3.AI_BYTES[0x00]            = 0x14                              -- Vertical speed.
ENTITIES.Shrimpy3.AI_BYTES[0x01]            = 0x02                              -- Frequency of attacks (higher value == more frequent).
ENTITIES.Shrimpy3.AI_BYTES[0x02]            = 0x5A                              -- Damage by bubble.
ENTITIES.Shrimpy3.AI_BYTES[0xA20E]          = 0x10                              -- Delay after attack. This is shared with all other Shrimpy viruses in the same battle.
ENTITIES.Shrimpy3.BATTLE_NUMBERS            = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.ShrimpyOmega                       = new_base_entity(ENTITY_KIND.Virus, "ShrimpyOmega")
ENTITIES.ShrimpyOmega.NAME                  = "Shrimpy\003"
ENTITIES.ShrimpyOmega.HP_BASE               = 200
ENTITIES.ShrimpyOmega.ELEMENT               = ENTITY_ELEMENT_DEFS.ELEMENT_AQUA
ENTITIES.ShrimpyOmega.AI_BYTES              = {}
ENTITIES.ShrimpyOmega.AI_BYTES[0x00]        = 0x0F                              -- Vertical speed.
ENTITIES.ShrimpyOmega.AI_BYTES[0x01]        = 0x03                              -- Frequency of attacks (higher value == more frequent).
ENTITIES.ShrimpyOmega.AI_BYTES[0x02]        = 0x96                              -- Damage by bubble.
ENTITIES.ShrimpyOmega.AI_BYTES[0xA20E]      = 0x10                              -- Delay after attack. This is shared with all other Shrimpy viruses in the same battle.
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

ENTITIES.BunnyOmega                         = new_base_entity(ENTITY_KIND.Virus, "BunnyOmega") -- This was originally called BunnySP, I like BunnyOmega better ;-)
ENTITIES.BunnyOmega.NAME                    = "Bunny\003"
ENTITIES.BunnyOmega.HP_BASE                 = 220
ENTITIES.BunnyOmega.ELEMENT                 = ENTITY_ELEMENT_DEFS.ELEMENT_ELEC
ENTITIES.BunnyOmega.AI_BYTES                = {}
ENTITIES.BunnyOmega.AI_BYTES[0x00]          = 0x0A                              -- Delay before movement.
ENTITIES.BunnyOmega.AI_BYTES[0x01]          = 0x0F                              -- Delay after attack.
ENTITIES.BunnyOmega.AI_BYTES[0x02]          = 0x96                              -- Damage ElecRing.
ENTITIES.BunnyOmega.BATTLE_NUMBERS          = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

----------------------------------------------------------------------------------------------------------------------------------------------------------

ENTITIES.WindBox                            = new_base_entity(ENTITY_KIND.Virus, "WindBox")
ENTITIES.WindBox.NAME                       = "WindBox"
ENTITIES.WindBox.HP_BASE                    = 100
ENTITIES.WindBox.ELEMENT                    = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.WindBox.AI_BYTES                   = {}
ENTITIES.WindBox.AI_BYTES[0x00]             = 0x01                              -- (??) Always 0x01.
ENTITIES.WindBox.AI_BYTES[0x01]             = 0x00                              -- Wind Type (0x00 == Wind, 0x01 == Fan).
ENTITIES.WindBox.AI_BYTES[0x02]             = 0x0A                              -- (??) Always 0x0A.
ENTITIES.WindBox.BATTLE_NUMBERS             = TIER_1_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.VacuumFan                          = new_base_entity(ENTITY_KIND.Virus, "VacuumFan")
ENTITIES.VacuumFan.NAME                     = "VacuumFan"
ENTITIES.VacuumFan.HP_BASE                  = 100
ENTITIES.VacuumFan.ELEMENT                  = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.VacuumFan.AI_BYTES                 = {}
ENTITIES.VacuumFan.AI_BYTES[0x00]           = 0x01                              -- (??) Always 0x01.
ENTITIES.VacuumFan.AI_BYTES[0x01]           = 0x01                              -- Wind Type (0x00 == Wind, 0x01 == Fan).
ENTITIES.VacuumFan.AI_BYTES[0x02]           = 0x0A                              -- (??) Always 0x0A.
ENTITIES.VacuumFan.BATTLE_NUMBERS           = TIER_2_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.StormBox                           = new_base_entity(ENTITY_KIND.Virus, "StormBox")
ENTITIES.StormBox.NAME                      = "StormBox"
ENTITIES.StormBox.HP_BASE                   = 300
ENTITIES.StormBox.ELEMENT                   = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.StormBox.AI_BYTES                  = {}
ENTITIES.StormBox.AI_BYTES[0x00]            = 0x01                              -- (??) Always 0x01.
ENTITIES.StormBox.AI_BYTES[0x01]            = 0x00                              -- Wind Type (0x00 == Wind, 0x01 == Fan).
ENTITIES.StormBox.AI_BYTES[0x02]            = 0x0A                              -- (??) Always 0x0A.
ENTITIES.StormBox.BATTLE_NUMBERS            = TIER_3_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.

ENTITIES.WindBoxOmega                       = new_base_entity(ENTITY_KIND.Virus, "WindBoxOmega")
ENTITIES.WindBoxOmega.NAME                  = "WindBox\003"
ENTITIES.WindBoxOmega.HP_BASE               = 500
ENTITIES.WindBoxOmega.ELEMENT               = ENTITY_ELEMENT_DEFS.ELEMENT_NONE
ENTITIES.WindBoxOmega.AI_BYTES              = {}
ENTITIES.WindBoxOmega.AI_BYTES[0x00]        = 0x01                              -- (??) Always 0x01.
ENTITIES.WindBoxOmega.AI_BYTES[0x01]        = 0x01                              -- Wind Type (0x00 == Wind, 0x01 == Fan).
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

ENTITIES.PuffBallOmega                      = new_base_entity(ENTITY_KIND.Virus, "PuffBallOmega") -- This was originally called BunnySP, I like BunnyOmega better ;-)
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

ENTITIES.MushyOmega                         = new_base_entity(ENTITY_KIND.Virus, "MushyOmega") -- This was originally called BunnySP, I like BunnyOmega better ;-)
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
ENTITIES.Dominerd.AI_BYTES[0x1603C]         = 0x19                              -- Chip Family
ENTITIES.Dominerd.AI_BYTES[0x1603E]         = 0x00                              -- Chip Subfamily
ENTITIES.Dominerd.AI_BYTES[0x16042]         = 0x00                              -- Chip Damage
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
ENTITIES.Dominerd2.AI_BYTES[0x16030]        = 0x19                              -- Chip Family
ENTITIES.Dominerd2.AI_BYTES[0x16032]        = 0x00                              -- Chip Subfamily
ENTITIES.Dominerd2.AI_BYTES[0x16036]        = 0x00                              -- Chip Damage
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
ENTITIES.Dominerd3.AI_BYTES[0x16024]        = 0x19                              -- Chip Family
ENTITIES.Dominerd3.AI_BYTES[0x16026]        = 0x00                              -- Chip Subfamily
ENTITIES.Dominerd3.AI_BYTES[0x1602A]        = 0x00                              -- Chip Damage
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
ENTITIES.DominerdOmega.AI_BYTES[0x16018]    = 0x19                              -- Chip Family
ENTITIES.DominerdOmega.AI_BYTES[0x1601A]    = 0x00                              -- Chip Subfamily
ENTITIES.DominerdOmega.AI_BYTES[0x1601E]    = 0x00                              -- Chip Damage
ENTITIES.DominerdOmega.BATTLE_NUMBERS       = TIER_4_BATTLES_WITHOUT_BOSSES     -- Battles in which this entity can appear.





-- Crackin' yar panels and stealing yar stuff!
ENTITIES.LolMettaur = deepcopy(ENTITIES.MettaurOmega)
ENTITIES.LolMettaur.HP_BASE = 420
ENTITIES.LolMettaur.NAME = "LolMettaur"
ENTITIES.LolMettaur.BATTLE_NUMBERS = {5, 10, 15, 20, 25, 30, 35, 40}
ENTITIES.LolMettaur.AI_BYTES[0x00]        = 20                                -- Base Damage.
ENTITIES.LolMettaur.AI_BYTES[0x01]        = 0x01                              -- Delay before moving.
ENTITIES.LolMettaur.AI_BYTES[0x02]        = 0x01                              -- Delay before attacking.
ENTITIES.LolMettaur.ELEMENT               = ENTITY_ELEMENT_DEFS.ELEMENT_HEAT

-- Introducing - DodgeDoge!
ENTITIES.DodgeDoge = deepcopy(ENTITIES.Spikey)
ENTITIES.DodgeDoge.HP_BASE = 50
ENTITIES.DodgeDoge.NAME = "DodgeDoge"
ENTITIES.DodgeDoge.BATTLE_NUMBERS = {5, 10, 15, 20, 25, 30, 35, 40}
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
ENTITIES.GEDDONPLZ.AI_BYTES[0x03]            = 0xFF                              -- Number of Geddon1 chips.
ENTITIES.GEDDONPLZ.AI_BYTES[0x04]            = 0x01                              -- Attacks before using Geddon1.
ENTITIES.GEDDONPLZ.AI_BYTES[0x05]            = 0x01                              -- Delay after attack (own field).
ENTITIES.GEDDONPLZ.AI_BYTES[0x06]            = 0x01                              -- Delay after attack (enemy field).
ENTITIES.GEDDONPLZ.AI_BYTES[0x07]            = 0x32                              -- Damage.
ENTITIES.GEDDONPLZ.AI_BYTES[0x08]            = 0xCC                              -- Vertical speed.
ENTITIES.GEDDONPLZ.AI_BYTES[0x1603C]         = 0x21                              -- Chip Family
ENTITIES.GEDDONPLZ.AI_BYTES[0x1603E]         = 0x01                              -- Chip Subfamily
ENTITIES.GEDDONPLZ.AI_BYTES[0x16042]         = 0x00                              -- Chip Damage
ENTITIES.GEDDONPLZ.BATTLE_NUMBERS            = ALL_BATTLES

return ENTITIES