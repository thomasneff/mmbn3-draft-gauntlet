

local ENTITY_HP_TRANSLATOR = {}

function ENTITY_HP_TRANSLATOR.translate(entity_type)

    if entity_type == nil then
        return nil
    end

    local OFFSET_BETWEEN_VIRUS_HP_DATA = 0x08 -- 8 bytes between each HP value.
    local BASE_OFFSET_HP_DATA = 0x08019620 - OFFSET_BETWEEN_VIRUS_HP_DATA -- We subtract one block because we need to skip "MegaMan" and start at Mettaur
    -- This translates the entity type into the address where the HP values are stored.

    return BASE_OFFSET_HP_DATA + OFFSET_BETWEEN_VIRUS_HP_DATA * entity_type

end


return ENTITY_HP_TRANSLATOR