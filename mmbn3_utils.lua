local defs = require "defs.generic_defs"
local ENTITY_KIND = require "defs.entity_kind_defs"
local TEXT_TABLE = require "defs.text_table_defs"
local ENTITY_PALETTE_DEFS = require "defs.entity_palette_defs"
local mmbn3_utils = {}

-- This is a wrapper for BizHawk with VBA-Next that automatically selects the correct memory domain.
function writebyteROM(address, value)
    --print("DOMAINS")
    --print(memory.getmemorydomainlist())
    if address >= 0x08000000 then
        address = address - 0x08000000
    end
    --print("Written " .. bizstring.hex(value) .. " to address " .. bizstring.hex(address))
    memory.writebyte(address, value, "ROM")
    --print("Read-Check " .. bizstring.hex(memory.readbyte(address,"ROM")) .. " from address " .. bizstring.hex(address))
end

-- This is a wrapper for BizHawk with VBA-Next that automatically selects the correct memory domain.
function writewordROM(address, value)
    if address >= 0x08000000 then
        address = address - 0x08000000
    end

    memory.write_u16_le(address, value, "ROM")
end

-- This is a wrapper for BizHawk with VBA-Next that automatically selects the correct memory domain.
function writedwordROM(address, value)
    if address >= 0x08000000 then
        address = address - 0x08000000
    end

    memory.write_u32_le(address, value, "ROM")
end


function mmbn3_utils.patch_battle(start_address, battle_data)

    local working_address = start_address

    -- Write Battle preamble
    writebyteROM(working_address, battle_data.LIMITER_START)
    working_address = working_address + 1
    writebyteROM(working_address, battle_data.UNKNOWN_ZERO_BYTE_1)
    working_address = working_address + 1
    writebyteROM(working_address, battle_data.UNKNOWN_ZERO_BYTE_2)
    working_address = working_address + 1
    writebyteROM(working_address, battle_data.UNKNOWN_ZERO_BYTE_3)
    working_address = working_address + 1

    --print(battle_data.ENTITIES)
    -- Write all battle entities
    for key, entity in pairs(battle_data.ENTITIES) do
        --print (entity.BATTLE_DATA)
        --print(working_address)
        entity_data = entity.BATTLE_DATA
        --print(entity)
        writebyteROM(working_address, entity_data.TYPE)
        working_address = working_address + 1
        writebyteROM(working_address, entity_data.X_POS)
        --print(entity_data.X_POS)
        working_address = working_address + 1
        writebyteROM(working_address, entity_data.Y_POS)
        --print(entity_data.Y_POS)
        working_address = working_address + 1
        writebyteROM(working_address, entity_data.KIND)
        working_address = working_address + 1
    end
    writebyteROM(working_address, battle_data.LIMITER_START)
    return working_address
end

-- This function writes a given standard string to mmbn3, using text tables
-- defined in text_table_defs
function write_mmbn3_string(start_address, string_arg)

    local current_address = start_address
    for i = 1, #string_arg do

        --Cut off more than 10 chars, as mmbn3 can't display that anyways
        if i > 9 then
            break
        end

        local c = string_arg:sub(i,i)
        --print("Char: " .. c)
        --print("TEXT_TABLE translate: " .. TEXT_TABLE[c])
        writebyteROM(current_address, TEXT_TABLE[c])
        current_address = current_address + 1
    end

    writebyteROM(current_address, TEXT_TABLE.End_Of_String)


end




function mmbn3_utils.patch_entity_data(entities)

    for key, new_entity in pairs(entities) do

        if new_entity.BATTLE_DATA.KIND == ENTITY_KIND.Megaman then
            break
        end

        -- Patch entity Damage <-- We do this in AI_BYTES now, as entities have multiple sources of damage, and it's just a headache to 
        -- change this.
        if new_entity.DAMAGE_ADDRESS ~= nil then
            writebyteROM(new_entity.DAMAGE_ADDRESS, new_entity.DAMAGE_BASE)
        end

        -- Patch entity HP and Element, since they both use the same word.
        if new_entity.HP_ADDRESS ~= nil then

            -- We don't need bitwise ops here if we just do an if.
            local masked_hp = new_entity.HP_BASE

            if masked_hp > 0x0FFF then
                masked_hp = 0x0FFF
            end
 
            local shifted_element = new_entity.ELEMENT * 0x1000
             local masked_hp_and_element = masked_hp + shifted_element
            writewordROM(new_entity.HP_ADDRESS, masked_hp_and_element)
        end

        -- Patch entity palette level (V1, V2, V3, Omega)
        if new_entity.PALETTE_LEVEL ~= nil then
            writewordROM(new_entity.HP_ADDRESS + ENTITY_PALETTE_DEFS.HP_ADDRESS_PALETTE_OFFSET, new_entity.PALETTE_LEVEL)
        end

        -- Patch entity Name
        if new_entity.NAME_ADDRESS ~= nil then
            write_mmbn3_string(new_entity.NAME_ADDRESS, new_entity.NAME)
        end

        
        -- Patch AI Values
        if new_entity.AI_ADDRESS ~= nil then
            if new_entity.AI_BYTES ~= nil then
                -- Iterate over AI_BYTES, and add the key (which is the offset) to the address for final address
                for offset, byte in pairs(new_entity.AI_BYTES) do
                    --print("Patching AI: key " .. offset .. " byte " .. byte)
                    writebyteROM(new_entity.AI_ADDRESS + offset, byte)
                end
            end      
        end


    end

end

function patch_battle_pointer(pointer_table_address, new_data)

    local working_address = pointer_table_address

    writedwordROM(pointer_table_address, new_data.ADDRESS)

    working_address = working_address + 4

    writebyteROM(working_address, new_data.UNID_BYTE_1)
    working_address = working_address + 1

    writebyteROM(working_address, new_data.UNID_BYTE_2)
    working_address = working_address + 1

    writebyteROM(working_address, new_data.UNID_BYTE_3)
    working_address = working_address + 1

    writebyteROM(working_address, new_data.UNID_BYTE_4)
    working_address = working_address + 1
    
    writebyteROM(working_address, new_data.BACKGROUND_TYPE)
    working_address = working_address + 1

    writebyteROM(working_address, new_data.BATTLE_MODE)
    working_address = working_address + 1

    writebyteROM(working_address, new_data.FOLDER_SHUFFLE)
    working_address = working_address + 1

    writebyteROM(working_address, new_data.ALLOW_RUNNING)
    working_address = working_address + 1

    writebyteROM(working_address, new_data.BATTLE_STAGE)
    working_address = working_address + 1

    writebyteROM(working_address, new_data.UNID_BYTE_8)
    working_address = working_address + 1

    writebyteROM(working_address, new_data.UNID_BYTE_9)
    working_address = working_address + 1

    writebyteROM(working_address, new_data.UNID_BYTE_10)
    working_address = working_address + 1


end

function mmbn3_utils.change_battle_pointer_data(pointer_table_address, new_data)
    -- We assume that the 'correct' pointer table address is passed, and simply add the offset between them.

    patch_battle_pointer(pointer_table_address, new_data)
    patch_battle_pointer(pointer_table_address + defs.OFFSET_BETWEEN_POINTER_TABLES, new_data)
end




return mmbn3_utils