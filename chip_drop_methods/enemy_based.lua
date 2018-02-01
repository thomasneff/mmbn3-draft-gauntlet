
local ENEMY_BASED = {}
local ENTITIES = require "defs.entity_defs"
local ENTITY_KIND = require "defs.entity_kind_defs"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP = require "defs.chip_defs"
local randomchoice_key = require "randomchoice_key"


function library_chips(library_number)

    local library_chip_data = {}

    for key, value in pairs(CHIP_DATA) do
        if value.LIBRARY_STARS == library_number then
            library_chip_data[key] = value
        end
    end

    return library_chip_data
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

    -- Now that we got all Virus-entities, we can randomly select one, and roll from its drop table (if it exists)
    local dropped_chips = {}
    local virus_index = 0
    for drop_index = 1, number_of_drops do


        -- We iterate over all viruses to make sure they can all drop stuff :)
        local virus_entity_data = virus_entities[(virus_index % #virus_entities) + 1]
        virus_index = virus_index + 1
        --print(virus_entity_data)
        --print(virus_entity_data.DROP_TABLE)
        if virus_entity_data.DROP_TABLE ~= nil then
            
            local rng = math.random(100)

            for key, drop_entry in ipairs(virus_entity_data.DROP_TABLE) do

                if drop_entry.CUMULATIVE_RARITY >= rng then
                    --print("Dropping " .. key .. " drop-table chip!")
                    dropped_chips[drop_index] = drop_entry.CHIP_GEN()
                    break
                end

            end


        else

            -- If there is no drop table, we drop randomly based on the current round.
            -- We roll first and decide to vary the current round by +-1 to get more chip variety.

            local rng = math.random(100)
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
            local random_chip_id = randomchoice_key(current_round_chips)
            --print("RAND ID: ", random_chip_id)
            dropped_chips[drop_index] = CHIP.new_chip_with_random_code(random_chip_id)

        end
        

    end

    return dropped_chips

end




function ENEMY_BASED.activate()

    -- Probably doesn't need to do anything, possibly compute some stuff
end


ENEMY_BASED.NAME = "Enemy-Based Drops"
ENEMY_BASED.DESCRIPTION = "Drop Chips based on defeated Viruses!"


return ENEMY_BASED

