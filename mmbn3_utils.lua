local defs = require "defs.generic_defs"
local ENTITY_KIND = require "defs.entity_kind_defs"
local mmbn3_utils = {}


function mmbn3_utils.patch_battle(start_address, battle_data)

    local working_address = start_address

    -- Write Battle preamble
    memory.writebyte(working_address, battle_data.LIMITER_START)
    working_address = working_address + 1
    memory.writebyte(working_address, battle_data.UNKNOWN_ZERO_BYTE_1)
    working_address = working_address + 1
    memory.writebyte(working_address, battle_data.UNKNOWN_ZERO_BYTE_2)
    working_address = working_address + 1
    memory.writebyte(working_address, battle_data.UNKNOWN_ZERO_BYTE_3)
    working_address = working_address + 1

    --print(battle_data.ENTITIES)
    -- Write all battle entities
    for key, entity in pairs(battle_data.ENTITIES) do
        entity_data = entity.BATTLE_DATA
        --print(entity)
        memory.writebyte(working_address, entity_data.TYPE)
        working_address = working_address + 1
        memory.writebyte(working_address, entity_data.X_POS)
        --print(entity_data.X_POS)
        working_address = working_address + 1
        memory.writebyte(working_address, entity_data.Y_POS)
        --print(entity_data.Y_POS)
        working_address = working_address + 1
        memory.writebyte(working_address, entity_data.KIND)
        working_address = working_address + 1
    end
    --memory.writebyte(working_address, battle_data.LIMITER_START)
    return working_address
end


function mmbn3_utils.patch_entity_data(entities)

    for key, new_entity in pairs(entities) do

        if new_entity.BATTLE_DATA.KIND == ENTITY_KIND.Megaman then
            break
        end

        -- Patch entity Damage
        if new_entity.DAMAGE_ADDRESS ~= nil then
            memory.writebyte(new_entity.DAMAGE_ADDRESS, new_entity.BASE_DAMAGE)
        end

        -- Patch entity HP
        if new_entity.HP_ADDRESS ~= nil then
            memory.writeword(new_entity.HP_ADDRESS, new_entity.BASE_HP)
        end

    end

end

function patch_battle_pointer(pointer_table_address, new_data)

    local working_address = pointer_table_address

    memory.writedword(pointer_table_address, new_data.ADDRESS)

    working_address = working_address + 4

    memory.writebyte(working_address, new_data.UNID_BYTE_1)
    working_address = working_address + 1

    memory.writebyte(working_address, new_data.UNID_BYTE_2)
    working_address = working_address + 1

    memory.writebyte(working_address, new_data.UNID_BYTE_3)
    working_address = working_address + 1

    memory.writebyte(working_address, new_data.UNID_BYTE_4)
    working_address = working_address + 1
    
    memory.writebyte(working_address, new_data.BACKGROUND_TYPE)
    working_address = working_address + 1

    memory.writebyte(working_address, new_data.BATTLE_MODE)
    working_address = working_address + 1

    memory.writebyte(working_address, new_data.FOLDER_SHUFFLE)
    working_address = working_address + 1

    memory.writebyte(working_address, new_data.ALLOW_RUNNING)
    working_address = working_address + 1

    memory.writebyte(working_address, new_data.BATTLE_STAGE)
    working_address = working_address + 1

    memory.writebyte(working_address, new_data.UNID_BYTE_8)
    working_address = working_address + 1

    memory.writebyte(working_address, new_data.UNID_BYTE_9)
    working_address = working_address + 1

    memory.writebyte(working_address, new_data.UNID_BYTE_10)
    working_address = working_address + 1


end

function mmbn3_utils.change_battle_pointer_data(pointer_table_address, new_data)
    -- We assume that the 'correct' pointer table address is passed, and simply add the offset between them.

    patch_battle_pointer(pointer_table_address, new_data)
    patch_battle_pointer(pointer_table_address + defs.OFFSET_BETWEEN_POINTER_TABLES, new_data)
end




return mmbn3_utils