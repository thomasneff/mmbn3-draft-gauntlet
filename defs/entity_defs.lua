local ENTITIES = {}
local ENTITY_TYPE = require "defs.entity_type_defs"
local ENTITY_KIND = require "defs.entity_kind_defs"
local ENTITY_AI_ADDRESS = require "defs.entity_ai_address_defs"
local ENTITY_HP_TRANSLATOR = require "defs.entity_hp_defs"

--Here, we define all enemies for the other functions to randomize. Also we can define own other combinations later on, e.g. if we want to change attack delay and stuff.

ENTITIES.Megaman = {
    BATTLE_DATA = {
        KIND = ENTITY_KIND.Megaman,
        X_POS = 0x02,
        Y_POS = 0x02,
        TYPE = ENTITY_TYPE.Megaman
    }
    
    --DAMAGE_ADDRESS = TypeToDamageAddress(Mettaur1)
    --DAMAGE = 


}

ENTITIES.Mettaur = {
    BATTLE_DATA = {
        KIND = ENTITY_KIND.Virus,
        X_POS = 0x05,
        Y_POS = 0x05,
        TYPE = ENTITY_TYPE.Mettaur
    },

    HP_ADDRESS = ENTITY_HP_TRANSLATOR.translate(ENTITY_TYPE.Mettaur),
    DAMAGE_ADDRESS = ENTITY_AI_ADDRESS.Mettaur + 0x0,
    BASE_HP = 40,
    BASE_DAMAGE = 10,
}

ENTITIES.LolMettaur = copytable(ENTITIES.Mettaur)
ENTITIES.LolMettaur.BASE_HP = 3000










return ENTITIES