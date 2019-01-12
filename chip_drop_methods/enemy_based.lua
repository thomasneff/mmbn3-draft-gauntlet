
local ENEMY_BASED = {}
local ENTITIES = require "defs.entity_defs"
local ENTITY_KIND = require "defs.entity_kind_defs"
local ENTITY_TYPE = require "defs.entity_type_defs"
local ENTITY_TYPE_LAST_ENTITY = require "defs.entity_type_defs_last_entity"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP = require "defs.chip_defs"
local randomchoice_key = require "randomchoice_key"
local GAUNTLET_DEFS = require "defs.gauntlet_defs"
local gauntlet_data = require "gauntlet_data"
local CHIP_ID = require "defs.chip_id_defs"
local deepcopy = require "deepcopy"

function library_chips(library_number)

    local library_chip_data = {}

    for key, value in pairs(CHIP_DATA) do
        if value.LIBRARY_STARS == library_number then
            library_chip_data[key] = value
        end
    end

    return library_chip_data
end

function get_next_entity_tier(entity)

    --print("get_next_entity_tier " .. entity.ID)
    -- If this entity is the last of its family, just return it, we can't increase the tier
    if ENTITY_TYPE_LAST_ENTITY[entity.ID] ~= nil then
        return entity
    end

    -- Find position in ENTITY_TYPE, increase it by one
    local new_entity_type = ENTITY_TYPE[entity.ID] + 1

    -- Find ID of new entity
    local new_entity_id = entity.ID

    for id, type in pairs(ENTITY_TYPE) do
        if type == new_entity_type then
            new_entity_id = id
            break
        end
    end

    --print("found new entity " .. new_entity_id)
    -- Return a copy of the new entity
    return deepcopy(ENTITIES[new_entity_id])
    
end


local library_chip_data = {}

function ENEMY_BASED.generate_drops(battle_data, current_round, number_of_drops)

    -- TODO: access the drop table of each entity that is a Virus, compute random values, determine drops.
    --       we might want to balance out the drops so each virus drops one chip? For now - random.

    --       If the drop table does not exist, drop based on Library Stars.

    local virus_entities = {}
    local counter = 1

    for key, value in pairs(battle_data.ENTITIES) do

        if value.BATTLE_DATA.KIND == ENTITY_KIND.Virus then
            virus_entities[counter] = value
            
            counter = counter + 1
        end

    end

    --print(virus_entities)

    --print("ENEMY BASED, before SKILL_NOT_LUCK")
    --print(gauntlet_data.rarity_mods)

    -- Check for skill_not_luck buff
    if gauntlet_data.skill_not_luck_active == 1 then
        for cumulative_rarity_index = 1,3 do
            gauntlet_data.rarity_mods[cumulative_rarity_index] = gauntlet_data.rarity_mods[cumulative_rarity_index] - 
                math.floor(GAUNTLET_DEFS.SKILL_NOT_LUCK_RARITY_DISTRIBUTION[cumulative_rarity_index] * gauntlet_data.skill_not_luck_bonus_current)       
        end
    end

    --print("ENEMY BASED, after SKILL_NOT_LUCK")
    --print(gauntlet_data.rarity_mods)

    -- Now that we got all Virus-entities, we can randomly select one, and roll from its drop table (if it exists)
    local dropped_chips = {}
    local virus_index = 0
    local dropped_super_or_ultra_rare = 0
    for drop_index = 1, number_of_drops do


        -- We iterate over all viruses to make sure they can all drop stuff :)
        local virus_entity_data = virus_entities[(virus_index % #virus_entities) + 1]
        virus_index = virus_index + 1
        --print(virus_entity_data)
        --print(virus_entity_data.DROP_TABLE)
        if virus_entity_data.DROP_TABLE ~= nil then

            local dark_rng = gauntlet_data.math.random_named("CHIP_REWARDS", 1000)
            if dark_rng <= GAUNTLET_DEFS.DROP_DARK_CHIP_CHANCE then
            
                dropped_chips[drop_index] = CHIP.new_random_chip_with_random_code()
                dropped_chips[drop_index].RARITY = 4

            else

                local rng = gauntlet_data.math.random_named("CHIP_REWARDS", 100)
                local rarity = 0

                -- TODO: (for Top-Tier): find entity type with ID + 1 (except LAST_ENTITY)

                if gauntlet_data.top_tier_active == 1 then
                    local top_tier_rng = gauntlet_data.math.random_named("CHIP_REWARDS", 100)
                    
                    if top_tier_rng < gauntlet_data.top_tier_chance then

                        -- Find next virus "tier" and replace virus_entity data with it
                        virus_entity_data = get_next_entity_tier(virus_entity_data)
                    end
                end

                for key, drop_entry in ipairs(virus_entity_data.DROP_TABLE) do

                    if rng <= drop_entry.CUMULATIVE_RARITY + gauntlet_data.rarity_mods[rarity + 1] then
                        --print("Dropping " .. key .. " drop-table chip!")
                        dropped_chips[drop_index] = drop_entry.CHIP_GEN()
                        dropped_chips[drop_index].RARITY = rarity

                        if rarity >= 2 then
                            dropped_super_or_ultra_rare = 1
                        end

                        if gauntlet_data.force_minibombs_lower_than_ultra_rare == 1 and rarity < 3 then
                            -- Replace with MiniBombs
                            dropped_chips[drop_index] = CHIP.new_chip_with_random_code(CHIP_ID.MiniBomb)
                        end

                        break
                    end
                    rarity = rarity + 1
                end

            end
            
            


        else

            -- If there is no drop table, we drop randomly based on the current round.
            -- We roll first and decide to vary the current round by +-1 to get more chip variety.

            local rng = gauntlet_data.math.random_named("CHIP_REWARDS", 100)
            local library_stars = (current_round - 1)

            if rng <= 10 then
                library_stars = library_stars - 1
            elseif rng <= 20 then
                library_stars = library_stars + 1
            end

            if library_stars < 0 then
                library_stars = 0
            elseif library_stars > 4 then
                library_stars = 4
            end


            local current_round_chips = library_chips(library_stars)
            --print(current_round_chips)
            local random_chip_id = randomchoice_key(current_round_chips, "CHIP_REWARDS")
            --print("RAND ID: ", random_chip_id)
            dropped_chips[drop_index] = CHIP.new_chip_with_random_code(random_chip_id)

        end
        

    end

    -- Check for skill_not_luck buff
    if gauntlet_data.skill_not_luck_active == 1 then
        for cumulative_rarity_index = 1,3 do
            gauntlet_data.rarity_mods[cumulative_rarity_index] = gauntlet_data.rarity_mods[cumulative_rarity_index] + 
                math.floor(GAUNTLET_DEFS.SKILL_NOT_LUCK_RARITY_DISTRIBUTION[cumulative_rarity_index] * gauntlet_data.skill_not_luck_bonus_current)  
        end
    end
    --print("ENEMY BASED, after SKILL_NOT_LUCK RESET")
    --print(gauntlet_data.rarity_mods)
    -- Reset skill_not_luck if UltraRare dropped

    if dropped_super_or_ultra_rare == 1 then
        gauntlet_data.skill_not_luck_bonus_current = 0
        gauntlet_data.skill_not_luck_number_of_fights = 0
        --print("RESET SKILL_NOT_LUCK because ULTRARARE")
    end

    
    return dropped_chips

end




function ENEMY_BASED.activate()

    -- Probably doesn't need to do anything, possibly compute some stuff
end


ENEMY_BASED.NAME = "Enemy-Based Drops"
ENEMY_BASED.DESCRIPTION = "Drop Chips based on defeated Viruses!"


return ENEMY_BASED

