-- NOTE: this is generic as-is, no need to make this game specific for now...?
local ENTITIES = require "defs.entity_defs"
local ENTITY_KIND = require "defs.entity_kind_defs"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP = require "defs.chip_defs"
local randomchoice_key = require "randomchoice_key"
local gauntlet_data = require "gauntlet_data"
-- This aims to implement utility functions to get the dropped chips of a battle.
local CHIP_DROP_UTILS = {}



function library_chips(library_number)

    local library_chip_data = {}

    for key, value in pairs(CHIP_DATA) do
        if value.LIBRARY_STARS == library_number then
            library_chip_data[key] = value
        end
    end

    return library_chip_data
end

function CHIP_DROP_UTILS.dropped_chips_from_battle(battle_data, current_round, number_of_drops)

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

    for drop_index = 1, number_of_drops do

        local virus_entity_data = virus_entities[math.random(#virus_entities)]

        if virus_entity_data.DROP_TABLE ~= nil then
            -- TODO: implement virus chip drops
            --       each DROP_TABLE should contain a CHIP_ID and a CODE_LIST
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

    return dropped_chips

end


return CHIP_DROP_UTILS