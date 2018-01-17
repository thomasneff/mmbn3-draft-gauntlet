local defs = require "defs.generic_defs"
local ENTITY_TYPE = require "defs.entity_type_defs"
local ENTITY_KIND = require "defs.entity_kind_defs"
local ENTITY_GROUPS = require "defs.entity_groups"
local ENTITIES = require "defs.entity_defs"
local GAUNTLET_DEFS = require "defs.gauntlet_defs"

local battle_data_template = {
    LIMITER_START = defs.BATTLE_LIMITER,
    UNKNOWN_ZERO_BYTE_1 = 0x00,
    UNKNOWN_ZERO_BYTE_2 = 0x00,
    UNKNOWN_ZERO_BYTE_3 = 0x00,
    ENTITIES = {
        {
            BATTLE_DATA = {
                TYPE = ENTITY_TYPE.Megaman,
                X_POS = 0x02,
                Y_POS = 0x02,
                KIND = ENTITY_KIND.Megaman
            }
            
        },
        {
            BATTLE_DATA = {
                TYPE = ENTITY_TYPE.Mettaur,
                X_POS = 0x05,
                Y_POS = 0x01,
                KIND = ENTITY_KIND.Virus
            }
        },
        {
            BATTLE_DATA = {
                TYPE = ENTITY_TYPE.Mettaur,
                X_POS = 0x05,
                Y_POS = 0x02,
                KIND = ENTITY_KIND.Rock
            }
        },
        {
            BATTLE_DATA = {
                TYPE = ENTITY_TYPE.Mettaur,
                X_POS = 0x06,
                Y_POS = 0x02,
                KIND = ENTITY_KIND.Virus
            }
        },
        {
            BATTLE_DATA = {
                TYPE = ENTITY_TYPE.Mettaur,
                X_POS = 0x05,
                Y_POS = 0x03,
                KIND = ENTITY_KIND.Virus
            }
        },
    }
 
}

local battle_data_generator = {}

function battle_data_generator.new_from_template()

    return deepcopy(battle_data_template)

end


function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
-- This creates new battle data for a given round and battle.
function battle_data_generator.random_from_battle(current_battle)

    -- Goals: Create a rising difficulty from battle 1 to 10, with a sub-boss at round 5, main boss at round 10.
    --        For that, we need to define virus groups and when they can appear, respectively.
    local new_battle_data = battle_data_generator.new_from_template()

    -- TODO: Improve. For now, get a random entity out of the group of the current difficulty/round
    local number_of_entities = math.random(GAUNTLET_DEFS.MIN_NUMBER_OF_VIRUSES, 3)

    -- For special battles, override number of viruses
    if GAUNTLET_DEFS.NUMBER_OF_VIRUSES_OVERRIDE[current_battle] ~= nil then
        number_of_entities = GAUNTLET_DEFS.NUMBER_OF_VIRUSES_OVERRIDE[current_battle]
    end

    --print("NUM: ", number_of_entities)
    local battle_entities = {}
    --print(current_battle)
    print(ENTITY_GROUPS[current_battle])
    local entity_group = deepcopy(ENTITY_GROUPS[current_battle])
    battle_entities[0] = ENTITIES.Megaman
    

    -- Create a grid of entity positions so we don't position enemies at the same spot.
    local grid = {}
    for i = 1, 6 do
        grid[i] = {}

        for j = 1, 3 do
            grid[i][j] = 0
        end
    end

    for entity_idx = 1,number_of_entities do
        local new_entity = deepcopy(entity_group[math.random(#entity_group)])
        

        -- Randomize entity position
        local found_random_pos = 1
        local x_pos = 0
        local y_pos = 0
        
        while found_random_pos == 1 do
            found_random_pos = 0
            x_pos = math.random(4, 6)
            y_pos = math.random(1, 3)

            found_random_pos = grid[x_pos][y_pos]
        end


        --print("X: ", x_pos, "Y: ", y_pos)
        grid[x_pos][y_pos] = 1

        new_entity.BATTLE_DATA.X_POS = x_pos
        new_entity.BATTLE_DATA.Y_POS = y_pos


        battle_entities[entity_idx] = new_entity


        --print("Added entity: ", entity_idx, "/", number_of_entities)
        --print(battle_entities[entity_idx].BATTLE_DATA.X_POS)
        --print(battle_entities[entity_idx].BATTLE_DATA.Y_POS)
    end

    new_battle_data.ENTITIES = battle_entities

    return new_battle_data

end

return battle_data_generator



