
local ROUND_BASED_LIBRARY_STARS = {}
local ENTITIES = require "defs.entity_defs"
local ENTITY_KIND = require "defs.entity_kind_defs"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP = require "defs.chip_defs"
local randomchoice_key = require "randomchoice_key"
local gauntlet_data = require "gauntlet_data"


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

function ROUND_BASED_LIBRARY_STARS.generate_drops(battle_data, current_round, number_of_drops)

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

        local virus_entity_data = virus_entities[gauntlet_data.math.random_named("CHIP_REWARDS", #virus_entities)]

       
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

    return dropped_chips

end




function ROUND_BASED_LIBRARY_STARS.activate()

    -- Probably doesn't need to do anything, possibly compute some stuff
end


ROUND_BASED_LIBRARY_STARS.NAME = "Tiered Drops"
ROUND_BASED_LIBRARY_STARS.DESCRIPTION = "Every 10 battles, drop rarity increases!"


return ROUND_BASED_LIBRARY_STARS

