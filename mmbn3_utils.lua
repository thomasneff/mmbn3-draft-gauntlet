local defs = require "defs.generic_defs"
local ENTITY_KIND = require "defs.entity_kind_defs"
local TEXT_TABLE = require "defs.text_table_defs"
local ENTITY_PALETTE_DEFS = require "defs.entity_palette_defs"
local CHIP_DATA_ADDRESS = require "defs.chip_data_address_defs"
local CHIP_DATA = require "defs.chip_data_defs"
local mmbn3_utils = {}

-- This is a wrapper for BizHawk with VBA-Next that automatically selects the correct memory domain.
function mmbn3_utils.writebyte(address, value)
    --print("DOMAINS")
    --print(memory.getmemorydomainlist())

    if address >= 0x08000000 then
        address = address - 0x08000000
        memory.writebyte(address, value, "ROM")
    elseif address >= 0x02000000 then
        address = address - 0x02000000
        memory.writebyte(address, value, "EWRAM")
    end
    --print("Written " .. bizstring.hex(value) .. " to address " .. bizstring.hex(address))
    
    --print("Read-Check " .. bizstring.hex(memory.readbyte(address,"ROM")) .. " from address " .. bizstring.hex(address))
end

-- This is a wrapper for BizHawk with VBA-Next that automatically selects the correct memory domain.
function mmbn3_utils.writeword(address, value)
    if address >= 0x08000000 then
        address = address - 0x08000000
        memory.write_u16_le(address, value, "ROM")
    elseif address >= 0x02000000 then
        address = address - 0x02000000
        memory.write_u16_le(address, value, "EWRAM")    
    end

    
end

-- This is a wrapper for BizHawk with VBA-Next that automatically selects the correct memory domain.
function mmbn3_utils.writedword(address, value)

    if address >= 0x08000000 then
        address = address - 0x08000000
        memory.write_u32_le(address, value, "ROM")
    elseif address >= 0x02000000 then
        address = address - 0x02000000
        memory.write_u32_le(address, value, "EWRAM")
    end

end

function mmbn3_utils.change_megaman_current_hp(new_value)
    --local megaman_current_hp_address = 0x020018A0 -- This is the address before battle.
    -- We need the address just before battle.
    local megaman_current_hp_address = defs.MEGA_CURRENT_HP_ADDRESS
    mmbn3_utils.writeword(megaman_current_hp_address, new_value)
end

function mmbn3_utils.change_megaman_max_hp(new_value) 
    --local megaman_max_hp_address = 0x020018A2 -- This is the address before battle.
    -- We need the address IN battle.
    local megaman_max_hp_address = defs.MEGA_MAX_HP_ADDRESS
    mmbn3_utils.writeword(megaman_max_hp_address, new_value)

end

function mmbn3_utils.change_megaman_style(new_style) 
    local megaman_style_address = defs.STYLE_CHANGE_ADDRESS
    megaman_style_address = 0x02001881
    mmbn3_utils.writebyte(megaman_style_address, new_style)
    mmbn3_utils.writebyte(0x02001881, new_style)
    mmbn3_utils.writebyte(0x02001894, new_style)
    mmbn3_utils.writebyte(0x0203B39C, new_style)

    print("PATCHED MEGAMAN STYLE: ", bizstring.hex(new_style))

    -- REMOVEME: testing other navicust things
    -- mmbn3_utils.writebyte(0x02005787, 0x19)

end

function mmbn3_utils.set_stage(value) 
    local address = defs.SET_STAGE_ADDRESS
    mmbn3_utils.writebyte(address, value)

end

function mmbn3_utils.change_number_of_cust_screen_chips(value) 
    local address = defs.NUMBER_OF_CUST_CHIPS_ADDRESS
    --value = 0xF
    --print("CUST SCCREENCHIPS: ", value)
    mmbn3_utils.writebyte(address, value)

    
    
end


function write_folder_chip_to_address(address, chip)

    mmbn3_utils.writeword(address, chip.ID)
    address = address + 2

    mmbn3_utils.writeword(address, chip.CODE)
    address = address + 2

    return address

end

function patch_chip_data(chip)

    local chip_id = chip.ID
    local chip_data_address = CHIP_DATA_ADDRESS.from_id(chip_id)
    local chip_data = CHIP_DATA[chip_id]

    mmbn3_utils.writebyte(chip_data_address, chip_data.CODE_1)
    chip_data_address = chip_data_address + 1

    mmbn3_utils.writebyte(chip_data_address, chip_data.CODE_2)
    chip_data_address = chip_data_address + 1

    mmbn3_utils.writebyte(chip_data_address, chip_data.CODE_3)
    chip_data_address = chip_data_address + 1

    mmbn3_utils.writebyte(chip_data_address, chip_data.CODE_4)
    chip_data_address = chip_data_address + 1

    mmbn3_utils.writebyte(chip_data_address, chip_data.CODE_5)
    chip_data_address = chip_data_address + 1

    mmbn3_utils.writebyte(chip_data_address, chip_data.CODE_6)
    chip_data_address = chip_data_address + 1

    mmbn3_utils.writebyte(chip_data_address, chip_data.ELEMENT)
    chip_data_address = chip_data_address + 1

    mmbn3_utils.writebyte(chip_data_address, chip_data.FAMILY)
    chip_data_address = chip_data_address + 1

    mmbn3_utils.writebyte(chip_data_address, chip_data.SUBLEVEL)
    chip_data_address = chip_data_address + 1

    mmbn3_utils.writebyte(chip_data_address, chip_data.LIBRARY_STARS)
    chip_data_address = chip_data_address + 1

    mmbn3_utils.writebyte(chip_data_address, chip_data.MB)
    chip_data_address = chip_data_address + 1

    mmbn3_utils.writebyte(chip_data_address, chip_data.ATTACK_TYPE)
    chip_data_address = chip_data_address + 1

    mmbn3_utils.writeword(chip_data_address, chip_data.DAMAGE)
    chip_data_address = chip_data_address + 2

    mmbn3_utils.writeword(chip_data_address, chip_data.LIBRARY_NUMBER)
    chip_data_address = chip_data_address + 2

    mmbn3_utils.writeword(chip_data_address, chip_data.UNKNOWN_STUFF)
    chip_data_address = chip_data_address + 2

    mmbn3_utils.writebyte(chip_data_address, chip_data.UNKNOWN_STUFF_2)
    chip_data_address = chip_data_address + 1

    mmbn3_utils.writebyte(chip_data_address, chip_data.CHIP_RANKING)
    chip_data_address = chip_data_address + 1

    mmbn3_utils.writedword(chip_data_address, chip_data.CHIP_ICON_OFFSET)
    chip_data_address = chip_data_address + 4

    mmbn3_utils.writedword(chip_data_address, chip_data.CHIP_PICTURE_OFFSET)
    chip_data_address = chip_data_address + 4

    mmbn3_utils.writedword(chip_data_address, chip_data.CHIP_PICTURE_PALETTE_OFFSET)
    chip_data_address = chip_data_address + 4


end


function shuffle(tbl)
    size = #tbl
    for i = size, 1, -1 do
      local rand = math.random(size)
      tbl[i], tbl[rand] = tbl[rand], tbl[i]
    end
    return tbl
  end

-- This changes all chips for the given folder_address to the chips contained in "folder".
function mmbn3_utils.patch_folder(folder, folder_address)




    local folder_length = #folder
    local working_address = folder_address

    -- We shuffle before patching to prevent issues with fixed RNG due to loading from the same savestate.
    local shuffled_folder = shuffle(folder)

    for chip_index = 1,folder_length do

        working_address = write_folder_chip_to_address(working_address, shuffled_folder[chip_index])

        patch_chip_data(shuffled_folder[chip_index])

    end

end






function mmbn3_utils.patch_battle(start_address, battle_data)

    local working_address = start_address

    -- Write Battle preamble
    mmbn3_utils.writebyte(working_address, battle_data.LIMITER_START)
    working_address = working_address + 1
    mmbn3_utils.writebyte(working_address, battle_data.UNKNOWN_ZERO_BYTE_1)
    working_address = working_address + 1
    mmbn3_utils.writebyte(working_address, battle_data.UNKNOWN_ZERO_BYTE_2)
    working_address = working_address + 1
    mmbn3_utils.writebyte(working_address, battle_data.UNKNOWN_ZERO_BYTE_3)
    working_address = working_address + 1

    --print(battle_data.ENTITIES)
    -- Write all battle entities
    for key, entity in pairs(battle_data.ENTITIES) do
        --print (entity.BATTLE_DATA)
        --print(working_address)
        entity_data = entity.BATTLE_DATA
        --print(entity)
        mmbn3_utils.writebyte(working_address, entity_data.TYPE)
        working_address = working_address + 1
        mmbn3_utils.writebyte(working_address, entity_data.X_POS)
        --print(entity_data.X_POS)
        working_address = working_address + 1
        mmbn3_utils.writebyte(working_address, entity_data.Y_POS)
        --print(entity_data.Y_POS)
        working_address = working_address + 1
        mmbn3_utils.writebyte(working_address, entity_data.KIND)
        working_address = working_address + 1
    end
    mmbn3_utils.writebyte(working_address, battle_data.LIMITER_START)
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
        mmbn3_utils.writebyte(current_address, TEXT_TABLE[c])
        current_address = current_address + 1
    end

    mmbn3_utils.writebyte(current_address, TEXT_TABLE.End_Of_String)


end




function mmbn3_utils.patch_entity_data(entities)

    for key, new_entity in pairs(entities) do

        if new_entity.BATTLE_DATA.KIND == ENTITY_KIND.Megaman then
            break
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
            mmbn3_utils.writeword(new_entity.HP_ADDRESS, masked_hp_and_element)
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
                    mmbn3_utils.writebyte(new_entity.AI_ADDRESS + offset, byte)
                end
            end      
        end


    end

end

function patch_battle_pointer(pointer_table_address, new_data)

    local working_address = pointer_table_address

    mmbn3_utils.writedword(pointer_table_address, new_data.ADDRESS)

    working_address = working_address + 4

    mmbn3_utils.writebyte(working_address, new_data.UNID_BYTE_1)
    working_address = working_address + 1

    mmbn3_utils.writebyte(working_address, new_data.UNID_BYTE_2)
    working_address = working_address + 1

    mmbn3_utils.writebyte(working_address, new_data.UNID_BYTE_3)
    working_address = working_address + 1

    mmbn3_utils.writebyte(working_address, new_data.UNID_BYTE_4)
    working_address = working_address + 1
    
    mmbn3_utils.writebyte(working_address, new_data.BACKGROUND_TYPE)
    working_address = working_address + 1

    mmbn3_utils.writebyte(working_address, new_data.BATTLE_MODE)
    working_address = working_address + 1

    mmbn3_utils.writebyte(working_address, new_data.FOLDER_SHUFFLE)
    working_address = working_address + 1

    mmbn3_utils.writebyte(working_address, new_data.ALLOW_RUNNING)
    working_address = working_address + 1

    mmbn3_utils.writebyte(working_address, new_data.BATTLE_STAGE)
    working_address = working_address + 1

    mmbn3_utils.writebyte(working_address, new_data.UNID_BYTE_8)
    working_address = working_address + 1

    mmbn3_utils.writebyte(working_address, new_data.UNID_BYTE_9)
    working_address = working_address + 1

    mmbn3_utils.writebyte(working_address, new_data.UNID_BYTE_10)
    working_address = working_address + 1


end

function mmbn3_utils.change_battle_pointer_data(pointer_table_address, new_data)
    -- We assume that the 'correct' pointer table address is passed, and simply add the offset between them.

    patch_battle_pointer(pointer_table_address, new_data)
    patch_battle_pointer(pointer_table_address + defs.OFFSET_BETWEEN_POINTER_TABLES, new_data)
end



return mmbn3_utils