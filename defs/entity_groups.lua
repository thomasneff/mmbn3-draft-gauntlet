local ENTITIES = require "defs.entity_defs"

--Here, we define the groups of entities for the respective difficulty levels.
local ENTITY_GROUPS = {}

ENTITY_GROUPS[0] = {
    ENTITIES.Mettaur,
} 

ENTITY_GROUPS[1] = {
    ENTITIES.LolMettaur,
} 

return ENTITY_GROUPS