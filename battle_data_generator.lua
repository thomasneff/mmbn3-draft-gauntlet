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

-- This function returns a list of entities for a given kind.
function get_all_entities_with_kind(entity_group, entity_kind)

    local entity_group_of_kind = {}
    local entity_group_of_kind_counter = 1

    for key, entity in pairs(entity_group) do
        if entity.BATTLE_DATA.KIND == entity_kind then
            entity_group_of_kind[entity_group_of_kind_counter] = deepcopy(entity)
            entity_group_of_kind_counter = entity_group_of_kind_counter + 1
        end
    end

    return entity_group_of_kind
end


function is_table_empty(table)
    for _, _ in pairs(table) do
        return false
    end
    return true
end

-- This function takes a game grid, updates it and positions a new entity from a given entity group onto it.
function roll_entity(grid, entity_group, contains_virus_table, entity_kind)


    local new_entity = deepcopy(entity_group[math.random(#entity_group)])

    -- If we request a specific entity kind, get a list for that and roll from it.
    if entity_kind ~= nil then

        local entity_group_of_kind = get_all_entities_with_kind(entity_group, entity_kind) 

        if is_table_empty(entity_group_of_kind) then
            -- Just return a Mettaur.
            print ("No entity of kind", entity_kind, "found in entity group", entity_group, "!")
            new_entity = deepcopy(ENTITIES.Mettaur)
        else
            new_entity = deepcopy(entity_group_of_kind[math.random(#entity_group_of_kind)])
        end

        

    end
    
    print(new_entity.NAME)

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


    if new_entity.BATTLE_DATA.KIND == ENTITY_KIND.Virus then    
        contains_virus_table.VALUE = 1
    end
    --print("X: ", x_pos, "Y: ", y_pos)
    grid[x_pos][y_pos] = 1

    new_entity.BATTLE_DATA.X_POS = x_pos
    new_entity.BATTLE_DATA.Y_POS = y_pos

    return new_entity

end

-- This creates new battle data for a given round and battle.
function battle_data_generator.random_from_battle(current_battle)

    -- Goals: Create a rising difficulty from battle 1 to 10, with a sub-boss at round 5, main boss at round 10.
    --        For that, we need to define virus groups and when they can appear, respectively.
    local new_battle_data = battle_data_generator.new_from_template()

    -- TODO: Improve. For now, get a random entity out of the group of the current difficulty/round
    local number_of_entities = math.random(GAUNTLET_DEFS.MIN_NUMBER_OF_VIRUSES, 4)
    print("Number of entities: ", number_of_entities)

    -- For special battles, override number of viruses
    if GAUNTLET_DEFS.NUMBER_OF_VIRUSES_OVERRIDE[current_battle] ~= nil then
        number_of_entities = GAUNTLET_DEFS.NUMBER_OF_VIRUSES_OVERRIDE[current_battle]
    end

    --print("NUM: ", number_of_entities)
    local battle_entities = {}
    --print(current_battle)
    --print(ENTITY_GROUPS[current_battle])
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

    -- This flag is used to check if we rolled at least one virus.
    local contains_virus_table = {
        VALUE = 0
    }

    -- If we roll number_of_entities == 4, we basically have to roll a virus and a non-virus entity guaranteed.
    local entity_idx_start = 1

    if number_of_entities == 4 then
        --print ("Rolling virus and non-virus first!")
        battle_entities[1] =  roll_entity(grid, entity_group, contains_virus_table, ENTITY_KIND.random_non_virus_entity_kind())
        --print(battle_entities[1])
        battle_entities[2] =  roll_entity(grid, entity_group, contains_virus_table, ENTITY_KIND.Virus)
        --print(battle_entities[2])
        entity_idx_start = 3
    end


    for entity_idx = entity_idx_start,number_of_entities do
        
        -- Roll RNG to determine if we get a virus or non-virus entity
        local entity_kind_rng = math.random(1, 100)
        if entity_kind_rng < GAUNTLET_DEFS.NON_VIRUS_ENTITY_CHANCE then
            new_entity = roll_entity(grid, entity_group, contains_virus_table, ENTITY_KIND.random_non_virus_entity_kind())
        else
            new_entity = roll_entity(grid, entity_group, contains_virus_table, ENTITY_KIND.Virus)
        end


        battle_entities[entity_idx] = new_entity


        --print("Added entity: ", entity_idx, "/", number_of_entities)
        --print(battle_entities[entity_idx].BATTLE_DATA.X_POS)
        --print(battle_entities[entity_idx].BATTLE_DATA.Y_POS)
    end

    -- Add a virus if we only rolled non-virus entities!
    -- We can always do this as 3 viruses + 1 non-virus is fine.
    if contains_virus_table.VALUE == 0 then

        battle_entities[4] = roll_entity(grid, entity_group, contains_virus_table, ENTITY_KIND.Virus)

    end


    new_battle_data.ENTITIES = battle_entities

    return new_battle_data

end

return battle_data_generator



