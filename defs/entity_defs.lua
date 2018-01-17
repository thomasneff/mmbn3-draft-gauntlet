local ENTITIES = {}
local ENTITY_TYPE = require "defs.entity_type_defs"
local ENTITY_KIND = require "defs.entity_kind_defs"
local ENTITY_AI_ADDRESS = require "defs.entity_ai_address_defs"
local ENTITY_HP_TRANSLATOR = require "defs.entity_hp_defs"
local ENTITY_NAME_ADDRESS_TRANSLATOR = require "defs.entity_name_defs"
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

    return new_base_entity
end

ENTITIES.Megaman = new_base_entity(ENTITY_KIND.Megaman, "Megaman")

ENTITIES.Mettaur = new_base_entity(ENTITY_KIND.Virus, "Mettaur")
ENTITIES.Mettaur.NAME = "Mettaur"
ENTITIES.Mettaur.HP_BASE = 40
ENTITIES.Mettaur.DAMAGE_ADDRESS = ENTITIES.Mettaur.AI_ADDRESS + 0x0
ENTITIES.Mettaur.DAMAGE_BASE = 10
--These AI Bytes need to be looked up at http://forums.therockmanexezone.com/topic/8907775/1/
ENTITIES.Mettaur.AI_BYTES = {}
ENTITIES.Mettaur.AI_BYTES[0x01] = 0x28 -- Delay before moving.
ENTITIES.Mettaur.AI_BYTES[0x02] = 0x1E -- Delay before attacking.
ENTITIES.Mettaur.BATTLE_NUMBERS = {1, 2, 3, 4, 6, 7, 8, 9} -- Battles in which this entity can appear.

ENTITIES.LolMettaur = deepcopy(ENTITIES.Mettaur)
ENTITIES.LolMettaur.HP_BASE = 42
ENTITIES.LolMettaur.NAME = "LolMettaur"
ENTITIES.LolMettaur.BATTLE_NUMBERS = {5, 10}


--ENTITIES.MettaurT = deepcopy(ENTITIES.Mettaur)
--ENTITIES.MettaurT.HP_BASE = 60
--ENTITIES.MettaurT.NAME = "MettaurT"
--ENTITIES.MettaurT.BATTLE_NUMBERS = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}








return ENTITIES