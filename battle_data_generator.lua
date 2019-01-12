local defs = require "defs.generic_defs"
local gauntlet_data = require "gauntlet_data"
local ENTITY_TYPE = require "defs.entity_type_defs"
local ENTITY_KIND = require "defs.entity_kind_defs"
local ENTITY_GROUPS = require "defs.entity_groups"
local ENTITIES = require "defs.entity_defs"
local GAUNTLET_DEFS = require "defs.gauntlet_defs"
local BATTLE_STAGE_DEFS = require "defs.battle_stage_defs"

local number_of_twins_viruses = 0

local battle_data_template = {
    LIMITER_START = defs.BATTLE_LIMITER,
    UNKNOWN_ZERO_BYTE_1 = 0x00,
    UNKNOWN_ZERO_BYTE_2 = 0x00,
    UNKNOWN_ZERO_BYTE_3 = 0x00,
    ENTITIES = {
        {
            BATTLE_DATA = {
                TYPE = ENTITY_TYPE.MegaMan,
                X_POS = 0x02,
                Y_POS = 0x02,
                KIND = ENTITY_KIND.MegaMan
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

-- This function returns a list of entities for a given kind.
function get_all_entities_with_types(entity_group, entity_types)

    local entity_group_of_type = {}
    local entity_group_of_type_counter = 1

    for key, entity in pairs(entity_group) do

        for i, type in pairs(entity_types) do

            if entity.BATTLE_DATA.TYPE == type then
                entity_group_of_type[entity_group_of_type_counter] = deepcopy(entity)
                entity_group_of_type_counter = entity_group_of_type_counter + 1
            end
        
        end

    end

    return entity_group_of_type
end


function is_table_empty(table)
    for _, _ in pairs(table) do
        return false
    end
    return true
end

function is_twins_virus(entity)
    return entity.BATTLE_DATA.TYPE == ENTITY_TYPE.Twins 
        or entity.BATTLE_DATA.TYPE == ENTITY_TYPE.Twinner 
        or entity.BATTLE_DATA.TYPE == ENTITY_TYPE.Twinnest
        or entity.BATTLE_DATA.TYPE == ENTITY_TYPE.TwinsOmega
end



-- local ent_cnt = 1
-- This function takes a game grid, updates it and positions a new entity from a given entity group onto it.
function roll_entity(grid, entity_group, contains_virus_table, entity_kind, specific_entity, battle_stage)


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
    


    -- Special code for handling the "Twins" family of viruses.
    -- There should be at least 2 of them, and they have to be the only virus type.
    -- Otherwise, their AI screws up and they don't do anything.

    if number_of_twins_viruses >= 1 then

        -- Guarantee a roll of another twins virus from entity group.
        local twins_types = 
        {
            ENTITY_TYPE.Twins, 
            ENTITY_TYPE.Twinner, 
            ENTITY_TYPE.Twinnest,
            ENTITY_TYPE.TwinsOmega
        }

        local entity_group_of_type = get_all_entities_with_types(entity_group, twins_types)

        if is_table_empty(entity_group_of_type) then
            -- Just return a Twins.
            print ("No entity of types ", twins_types, "found in entity group", entity_group, "!")
            new_entity = deepcopy(ENTITIES.Twins)
        else
            new_entity = deepcopy(entity_group_of_type[math.random(#entity_group_of_type)])
        end


    end


    --if ent_cnt == 1 then
    --    new_entity = deepcopy(ENTITIES.ShrimpyOmega)
    --    ent_cnt = 2
    --elseif ent_cnt == 2 then
    --    new_entity = deepcopy(ENTITIES.ShrimpyOmega)
    --    ent_cnt = 3
    --elseif ent_cnt == 3 then
    --    new_entity = deepcopy(ENTITIES.SpikeyOmega)
    --    ent_cnt = 4
    --else
    --    new_entity = deepcopy(ENTITIES.Guardian)
    --    ent_cnt = 1
    --end
    
    if specific_entity ~= nil then
        new_entity = specific_entity
    end

    print(new_entity.NAME)
    
    if is_twins_virus(new_entity) then

        number_of_twins_viruses = number_of_twins_viruses + 1

    end 


    -- Randomize entity position
    -- TODO: check that BlackBomb is not on Lava Panel (to prevent insta-kill scenarios)

    

    local found_random_pos = 1
    local x_pos = 0
    local y_pos = 0
        
    while found_random_pos == 1 do
        found_random_pos = 0
        if new_entity.BATTLE_DATA.KIND == ENTITY_KIND.Virus then
            x_pos = gauntlet_data.math.random_named("BATTLE_DATA", 4, 6)
            y_pos = gauntlet_data.math.random_named("BATTLE_DATA", 1, 3)
        else
            x_pos = gauntlet_data.math.random_named("BATTLE_DATA", 1, 6)
            y_pos = gauntlet_data.math.random_named("BATTLE_DATA", 1, 3)
        end

        found_random_pos = grid[x_pos][y_pos]

        if (BATTLE_STAGE_DEFS.is_lava_panel(x_pos, y_pos, battle_stage)) and new_entity.BATTLE_DATA.KIND == ENTITY_KIND.BlackBomb then
            found_random_pos = 1
        end
    end


    if new_entity.BATTLE_DATA.TYPE == ENTITY_TYPE.Alpha or
       new_entity.BATTLE_DATA.TYPE == ENTITY_TYPE.AlphaOmega then

        x_pos = 5
        y_pos = 2

    end
    if new_entity.BATTLE_DATA.KIND == ENTITY_KIND.Virus then    
        contains_virus_table.VALUE = contains_virus_table.VALUE + 1
    end
    --print("X: ", x_pos, "Y: ", y_pos)
    grid[x_pos][y_pos] = 1

    new_entity.BATTLE_DATA.X_POS = x_pos
    new_entity.BATTLE_DATA.Y_POS = y_pos

    return new_entity

end

function battle_data_generator.random_boss(next_boss_round)

    local entity_group = deepcopy(ENTITY_GROUPS[next_boss_round])

    local entity_group_of_kind = get_all_entities_with_kind(entity_group, ENTITY_KIND.Virus) 

    local boss_entity = deepcopy(entity_group_of_kind[math.random(#entity_group_of_kind)])

    return boss_entity
    

end

-- This creates new battle data for a given round and battle.
function battle_data_generator.random_from_battle(current_battle, specific_entity, battle_stage)
    --ent_cnt = 1
    -- Goals: Create a rising difficulty from battle 1 to 10, with a sub-boss at round 5, main boss at round 10.
    --        For that, we need to define virus groups and when they can appear, respectively.
    local new_battle_data = battle_data_generator.new_from_template()



    number_of_twins_viruses = 0

    -- TODO: Improve. For now, get a random entity out of the group of the current difficulty/round
    local number_of_entities = gauntlet_data.math.random_named("BATTLE_DATA", GAUNTLET_DEFS.MIN_NUMBER_OF_VIRUSES, 4)
    

    -- For special battles, override number of viruses
    if GAUNTLET_DEFS.NUMBER_OF_VIRUSES_OVERRIDE[current_battle] ~= nil then
        number_of_entities = GAUNTLET_DEFS.NUMBER_OF_VIRUSES_OVERRIDE[current_battle]
    end

    if specific_entity ~= nil then
        number_of_entities = 1
    end

    print("Number of entities: ", number_of_entities)
    print("Stage for battle: ", battle_stage)

    --print("NUM: ", number_of_entities)
    local battle_entities = {}
    --print(current_battle)
    --print(ENTITY_GROUPS[current_battle])
    local entity_group = deepcopy(ENTITY_GROUPS[current_battle])
    battle_entities[0] = deepcopy(ENTITIES.MegaMan)
    

    -- Create a grid of entity positions so we don't position enemies at the same spot.
    local grid = {}
    for i = 1, 6 do
        grid[i] = {}

        for j = 1, 3 do
            grid[i][j] = 0
        end
    end
    

    -- Set MegaMan as flagged, if he doesn't start on a lava/poison panel.
    local found_random_pos = 0
    local x_pos = 2
    local y_pos = 2


    local is_metalman = false
    if specific_entity ~= nil then

        is_metalman = specific_entity.ID == "MetalMan" or specific_entity.ID == "MetalManAlpha" or specific_entity.ID == "MetalManBeta" or specific_entity.ID == "MetalManOmega"

        if is_metalman then

            -- Define places where MetalGear will be spawned
            grid[1][2] = 1
            grid[6][2] = 1

            -- Define MetalMan spawn
            grid[4][2] = 1

            -- Define other default MegaMan spawn
            x_pos = 3
            y_pos = 2

        end

    end

    if  BATTLE_STAGE_DEFS.is_poison_panel(x_pos, y_pos, battle_stage) or
        BATTLE_STAGE_DEFS.is_lava_panel(x_pos, y_pos, battle_stage) then
        found_random_pos = 1
    end
        
    while found_random_pos == 1 do
        found_random_pos = 0
        x_pos = gauntlet_data.math.random_named("BATTLE_DATA", 1, 3)
        y_pos = gauntlet_data.math.random_named("BATTLE_DATA", 1, 3)

        if  BATTLE_STAGE_DEFS.is_poison_panel(x_pos, y_pos, battle_stage) or
            BATTLE_STAGE_DEFS.is_lava_panel(x_pos, y_pos, battle_stage) then
            found_random_pos = 1
        end

        if grid[x_pos][y_pos] == 1 then
            found_random_pos = 1
        end
    end

    grid[x_pos][y_pos] = 1
    battle_entities[0].BATTLE_DATA.X_POS = x_pos
    battle_entities[0].BATTLE_DATA.Y_POS = y_pos
    

    -- This flag is used to check if we rolled at least one virus.
    local contains_virus_table = {
        VALUE = 0
    }

    -- If we roll number_of_entities == 4, we basically have to roll a virus and a non-virus entity guaranteed.
    local entity_idx_start = 1

  
    local num_virus_entities = 0

    if number_of_entities == 4 then
        --print ("Rolling virus and non-virus first!")
        battle_entities[1] =  roll_entity(grid, entity_group, contains_virus_table, ENTITY_KIND.random_non_virus_entity_kind(), nil, battle_stage)
        --print(battle_entities[1])
        battle_entities[2] =  roll_entity(grid, entity_group, contains_virus_table, ENTITY_KIND.Virus, nil, battle_stage)
        num_virus_entities = num_virus_entities + 1
        --print(battle_entities[2])
        entity_idx_start = 3
    end

    


    for entity_idx = entity_idx_start,number_of_entities do
        
        -- Roll RNG to determine if we get a virus or non-virus entity
        local entity_kind_rng = gauntlet_data.math.random_named("BATTLE_DATA", 1, 100)
        if entity_kind_rng < GAUNTLET_DEFS.NON_VIRUS_ENTITY_CHANCE and specific_entity == nil then
            new_entity = roll_entity(grid, entity_group, contains_virus_table, ENTITY_KIND.random_non_virus_entity_kind(), nil, battle_stage)
        else
            num_virus_entities = num_virus_entities + 1
            if specific_entity == nil then
                new_entity = roll_entity(grid, entity_group, contains_virus_table, ENTITY_KIND.Virus, nil, battle_stage)
            else
                new_entity = roll_entity(grid, entity_group, contains_virus_table, ENTITY_KIND.Virus, specific_entity, battle_stage)
            end
        end


        battle_entities[entity_idx] = new_entity


        --print("Added entity: ", entity_idx, "/", number_of_entities)
        --print(battle_entities[entity_idx].BATTLE_DATA.X_POS)
        --print(battle_entities[entity_idx].BATTLE_DATA.Y_POS)
    end


    -- If we have a specific entity, we can roll up to 3 non virus entities
    if specific_entity ~= nil then

        
        for entity_idx = 2,4 do
        
            -- Roll RNG to determine if we get a virus or non-virus entity
            if not is_metalman then
                local entity_kind_rng = gauntlet_data.math.random_named("BATTLE_DATA", 1, 100)
                if entity_kind_rng < GAUNTLET_DEFS.BOSS_NON_VIRUS_ENTITY_CHANCE then
                    new_entity = roll_entity(grid, entity_group, contains_virus_table, ENTITY_KIND.random_non_virus_entity_kind(), nil, battle_stage)
                
                    battle_entities[#battle_entities + 1] = new_entity
                end
            end
    
            --print("Added entity: ", entity_idx, "/", number_of_entities)
            --print(battle_entities[entity_idx].BATTLE_DATA.X_POS)
            --print(battle_entities[entity_idx].BATTLE_DATA.Y_POS)
        end

        if is_metalman then

            battle_entities[#battle_entities].BATTLE_DATA.X_POS = 4
            battle_entities[#battle_entities].BATTLE_DATA.Y_POS = 2

            new_entity = roll_entity(grid, entity_group, contains_virus_table, ENTITY_KIND.MetalGear, nil, battle_stage)
            new_entity.BATTLE_DATA.X_POS = 1
            new_entity.BATTLE_DATA.Y_POS = 2  
            battle_entities[#battle_entities + 1] = new_entity

            new_entity = roll_entity(grid, entity_group, contains_virus_table, ENTITY_KIND.MetalGear, nil, battle_stage)
            new_entity.BATTLE_DATA.X_POS = 6
            new_entity.BATTLE_DATA.Y_POS = 2  
            battle_entities[#battle_entities + 1] = new_entity
            local entity_kind_rng = gauntlet_data.math.random_named("BATTLE_DATA", 1, 100)
            if entity_kind_rng < GAUNTLET_DEFS.BOSS_NON_VIRUS_ENTITY_CHANCE then
                new_entity = roll_entity(grid, entity_group, contains_virus_table, ENTITY_KIND.random_non_virus_entity_kind(), nil, battle_stage)
                battle_entities[#battle_entities + 1] = new_entity
            end

        end

    end


    if number_of_twins_viruses == 1 and contains_virus_table.VALUE == 1 then

        -- When we have only a single virus (Twins miniboss..?),
        -- we simply add another virus, which is forced to be a Twins virus
        battle_entities[#battle_entities + 1] = roll_entity(grid, entity_group, contains_virus_table, ENTITY_KIND.Virus, nil, battle_stage)
        num_virus_entities = num_virus_entities + 1

    
    elseif number_of_twins_viruses >= 1 and contains_virus_table.VALUE >= 1 then

        -- Otherwise, if we have at least 2 viruses, we simply replace all non-Twins viruses with Twins-viruses.
        -- This can only happen if we roll a non-Twins virus before a Twins-virus.
        for idx, entity in pairs(battle_entities) do

            if is_twins_virus(entity) == false and entity.BATTLE_DATA.KIND == ENTITY_KIND.Virus then

                -- We replace the virus with a twins virus.
                -- This screws up the grid, but we have enough space anyways
                battle_entities[idx] = roll_entity(grid, entity_group, contains_virus_table, ENTITY_KIND.Virus, nil, battle_stage)

            end

        end


    end

    -- Add a virus if we only rolled non-virus entities!
    -- We can always do this as 3 viruses + 1 non-virus is fine.
    if contains_virus_table.VALUE == 0 then

        if specific_entity == nil then
            battle_entities[4] = roll_entity(grid, entity_group, contains_virus_table, ENTITY_KIND.Virus, nil, battle_stage)
        else
            battle_entities[4] = roll_entity(grid, entity_group, contains_virus_table, ENTITY_KIND.Virus, specific_entity, battle_stage)
        end
        num_virus_entities = num_virus_entities + 1

    end

    new_battle_data.NUM_ENTITIES = num_virus_entities
    new_battle_data.ENTITIES = battle_entities

    --local canodumb2_group = 
    --{
    --    ENTITIES.Canodumb2
    --}

    --local twinner_group = 
    --{
    --    ENTITIES.Twinner
    --}


    --battle_entities[1] =  roll_entity(grid, entity_group, contains_virus_table, ENTITY_KIND.MetalCube, nil, battle_stage)
        --print(battle_entities[1])
    --battle_entities[2] =  roll_entity(grid, canodumb2_group, contains_virus_table, ENTITY_KIND.Virus, nil, battle_stage)
    --battle_entities[2] =  roll_entity(grid, twinner_group, contains_virus_table, ENTITY_KIND.Virus, nil, battle_stage)
    --battle_entities[3] =  roll_entity(grid, twinner_group, contains_virus_table, ENTITY_KIND.Virus, nil, battle_stage)
    --battle_entities[4] =  roll_entity(grid, twinner_group, contains_virus_table, ENTITY_KIND.Virus, nil, battle_stage)

    --new_battle_data.NUM_ENTITIES = 3
    --new_battle_data.ENTITIES = battle_entities

    return new_battle_data

end

return battle_data_generator



