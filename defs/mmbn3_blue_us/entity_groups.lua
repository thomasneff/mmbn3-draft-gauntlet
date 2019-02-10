-- NOTE: This is already generic, so we could use the same file for different games.

local ENTITIES = require "defs.entity_defs"


local ENTITY_GROUPS = {}

-- This function iterates over all ENTITIES, and puts the respective entities into their 
-- ENTITY_GROUP bracket. This is indexed by fight number.
-- The assemble function takes into account the BATTLE_NUMBERS entity attributes.
function assemble_groups_from_entity_defs()

    for entity_key, entity_val in pairs(ENTITIES) do

        
        -- Get battle numbers from entity.
        local battle_numbers = entity_val.BATTLE_NUMBERS

        if battle_numbers ~= nil then
            -- For each battle number, add the entity to the respective group.
            for battle_number_idx = 1, #battle_numbers do

                local battle_number = battle_numbers[battle_number_idx]

                if battle_number ~= nil then
                    if ENTITY_GROUPS[battle_number] == nil then
                        ENTITY_GROUPS[battle_number] = {}
                    end  
                    ENTITY_GROUPS[battle_number][#ENTITY_GROUPS[battle_number] + 1] = entity_val
                end

            end
        end


    end
    
    --print(ENTITY_GROUPS)

end

assemble_groups_from_entity_defs()


return ENTITY_GROUPS