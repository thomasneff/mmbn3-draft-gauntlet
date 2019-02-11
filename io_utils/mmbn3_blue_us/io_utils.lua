local defs = require "defs.generic_defs"
local ENTITY_KIND = require "defs.entity_kind_defs"
local TEXT_TABLE = require "defs.text_table_defs"
--local ENTITY_PALETTE_DEFS = require "defs.entity_palette_defs"
local CHIP_DATA_ADDRESS = require "defs.chip_data_address_defs"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_CODE = require "defs.chip_code_defs"
local deepcopy = require "deepcopy"
local gauntlet_data = require "gauntlet_data"
local bizhawk_io_wrapper = require "io_utils.bizhawk_io_wrapper"

local mmbn3_utils = {}


--function mmbn3_utils.change_megaMan_current_hp(new_value)
    --local megaMan_current_hp_address = 0x020018A0 -- This is the address before battle.
    -- We need the address just before battle.
    --local megaMan_current_hp_address = defs.MEGA_CURRENT_HP_ADDRESS_DURING_BATTLE_3_ENEMIES
    --bizhawk_io_wrapper.writeword(megaMan_current_hp_address, new_value)
    --bizhawk_io_wrapper.writeword(0x020018A0, new_value)
    --bizhawk_io_wrapper.writeword(0x0200F888, new_value)
--end

--function mmbn3_utils.change_megaMan_max_hp(new_value) 
    --local megaMan_max_hp_address = 0x020018A2 -- This is the address before battle.
    -- We need the address IN battle.
    --local megaMan_max_hp_address = defs.MEGA_MAX_HP_ADDRESS_DURING_BATTLE_3_ENEMIES
    --print("Patched HP: ", new_value)
    --bizhawk_io_wrapper.writeword(megaMan_max_hp_address, new_value)
    --bizhawk_io_wrapper.writeword(0x020018A2, new_value)

--end

function mmbn3_utils.change_megaMan_style(new_style) 
    local megaMan_style_address = defs.STYLE_CHANGE_ADDRESS

    -- TODO_REFACTOR: Which address is it?
    megaMan_style_address = 0x02001881
    bizhawk_io_wrapper.writebyte(megaMan_style_address, new_style)
    bizhawk_io_wrapper.writebyte(0x02001881, new_style)
    bizhawk_io_wrapper.writebyte(0x02001894, new_style)
    bizhawk_io_wrapper.writebyte(0x0203B39C, new_style)

    --print("PATCHED MEGAMAN STYLE: ", bizstring.hex(new_style))

    -- REMOVEME: testing other navicust things
    -- bizhawk_io_wrapper.writebyte(0x02005787, 0x19)

end

function mmbn3_utils.set_stage(value) 
    local address = defs.SET_STAGE_ADDRESS
    bizhawk_io_wrapper.writebyte(address, value)
end

function mmbn3_utils.change_number_of_cust_screen_chips(value) 
    local address = defs.NUMBER_OF_CUST_CHIPS_ADDRESS
    
    if value > 10 then
        value = 10
    end

    if value <= 0 then
        value = 1
    end
    --value = 0xF
    --print("CUST SCREENCHIPS: ", value)
    bizhawk_io_wrapper.writebyte(address, value)
end


function write_folder_chip_to_address(address, chip)

    bizhawk_io_wrapper.writeword(address, chip.ID)
    address = address + 2

    bizhawk_io_wrapper.writeword(address, chip.CODE)
    address = address + 2

    return address

end

function patch_chip_data(chip)

    local chip_id = chip.ID
    local chip_data_address = CHIP_DATA_ADDRESS.from_id(chip_id)
    local chip_data = CHIP_DATA[chip_id]

    bizhawk_io_wrapper.writebyte(chip_data_address, chip_data.CODE_1)
    chip_data_address = chip_data_address + 1

    bizhawk_io_wrapper.writebyte(chip_data_address, chip_data.CODE_2)
    chip_data_address = chip_data_address + 1

    bizhawk_io_wrapper.writebyte(chip_data_address, chip_data.CODE_3)
    chip_data_address = chip_data_address + 1

    bizhawk_io_wrapper.writebyte(chip_data_address, chip_data.CODE_4)
    chip_data_address = chip_data_address + 1

    bizhawk_io_wrapper.writebyte(chip_data_address, chip_data.CODE_5)
    chip_data_address = chip_data_address + 1

    bizhawk_io_wrapper.writebyte(chip_data_address, chip_data.CODE_6)
    chip_data_address = chip_data_address + 1

    bizhawk_io_wrapper.writebyte(chip_data_address, chip_data.ELEMENT)
    chip_data_address = chip_data_address + 1

    bizhawk_io_wrapper.writebyte(chip_data_address, chip_data.FAMILY)
    chip_data_address = chip_data_address + 1

    bizhawk_io_wrapper.writebyte(chip_data_address, chip_data.SUBLEVEL)
    chip_data_address = chip_data_address + 1

    bizhawk_io_wrapper.writebyte(chip_data_address, chip_data.LIBRARY_STARS)
    chip_data_address = chip_data_address + 1

    bizhawk_io_wrapper.writebyte(chip_data_address, chip_data.MB)
    chip_data_address = chip_data_address + 1

    bizhawk_io_wrapper.writebyte(chip_data_address, chip_data.ATTACK_TYPE)
    chip_data_address = chip_data_address + 1

    bizhawk_io_wrapper.writeword(chip_data_address, chip_data.DAMAGE)
    chip_data_address = chip_data_address + 2

    bizhawk_io_wrapper.writeword(chip_data_address, chip_data.LIBRARY_NUMBER)
    chip_data_address = chip_data_address + 2

    bizhawk_io_wrapper.writeword(chip_data_address, chip_data.UNKNOWN_STUFF)
    chip_data_address = chip_data_address + 2

    bizhawk_io_wrapper.writebyte(chip_data_address, chip_data.UNKNOWN_STUFF_2)
    chip_data_address = chip_data_address + 1

    bizhawk_io_wrapper.writebyte(chip_data_address, chip_data.CHIP_RANKING)
    chip_data_address = chip_data_address + 1

    bizhawk_io_wrapper.writedword(chip_data_address, chip_data.CHIP_ICON_OFFSET)
    chip_data_address = chip_data_address + 4

    bizhawk_io_wrapper.writedword(chip_data_address, chip_data.CHIP_PICTURE_OFFSET)
    chip_data_address = chip_data_address + 4

    bizhawk_io_wrapper.writedword(chip_data_address, chip_data.CHIP_PICTURE_PALETTE_OFFSET)
    chip_data_address = chip_data_address + 4


end


function shuffle(tbl)
    size = #tbl
    for i = size, 1, -1 do
      local rand = gauntlet_data.math.random_named("FOLDER_SHUFFLING", size)
      tbl[i], tbl[rand] = tbl[rand], tbl[i]
    end
    return tbl
end

-- This changes all chips for the given folder_address to the chips contained in "folder".
function mmbn3_utils.patch_folder(folder, folder_address, gauntlet_data)

    local folder_length = #folder
    local working_address = folder_address

    -- We shuffle before patching to prevent issues with fixed RNG due to loading from the same savestate.
    local shuffled_folder = shuffle(deepcopy(folder))

    -- If we have chips set as regular chips, they should appear in front.

    -- TODO_REFACTOR: Do other games have a mode where the folder appears in order?
    --                If not - we need to change the folder order at a later point or change the permutation the game uses.  

    local reg_indices = {}
    local shuffled_reg_folder = {}
    local shuffle_indices = {}


    for chip_index = 1,folder_length do
        if shuffled_folder[chip_index].REG ~= nil then
            shuffled_reg_folder[#shuffled_reg_folder + 1] = deepcopy(shuffled_folder[chip_index])
            reg_indices[chip_index] = 1
        end

        shuffle_indices[chip_index] = chip_index
    end

    shuffle_indices = shuffle(deepcopy(shuffle_indices))

    for chip_index = 1,folder_length do

        if reg_indices[chip_index] ~= 1 then
            shuffled_reg_folder[#shuffled_reg_folder + 1] = deepcopy(shuffled_folder[chip_index])
        end
       
    end


    -- Alphabet Soup
    local num_replaced_chips = 0

    for i = 1,folder_length do

        if num_replaced_chips >= gauntlet_data.add_random_star_code_before_battle then
            break
        end
        
        if shuffled_reg_folder[shuffle_indices[i]].CODE ~= CHIP_CODE.Asterisk then
            shuffled_reg_folder[shuffle_indices[i]].CODE = CHIP_CODE.Asterisk
            num_replaced_chips = num_replaced_chips + 1
        end
        
    end

    


    
    for chip_index = 1,folder_length do
         -- Now we need to patch the indices in RAM such that the chips come in order the first time around
        bizhawk_io_wrapper.writebyte(defs.SHUFFLED_FOLDER_INDICES_RAM_ADDRESS + (chip_index - 1), chip_index - 1)
    
        -- "Rising Star" buff (first N chips are Asterisk Code)
        if gauntlet_data.rising_star_count >= chip_index then
            shuffled_reg_folder[chip_index].CODE = CHIP_CODE.Asterisk
        end

        working_address = write_folder_chip_to_address(working_address, shuffled_reg_folder[chip_index])

        patch_chip_data(shuffled_reg_folder[chip_index])

    end

end






function mmbn3_utils.patch_battle(start_address, battle_data)

    local working_address = start_address

    -- Write Battle preamble
    bizhawk_io_wrapper.writebyte(working_address, battle_data.LIMITER_START)
    working_address = working_address + 1
    bizhawk_io_wrapper.writebyte(working_address, battle_data.UNKNOWN_ZERO_BYTE_1)
    working_address = working_address + 1
    bizhawk_io_wrapper.writebyte(working_address, battle_data.UNKNOWN_ZERO_BYTE_2)
    working_address = working_address + 1
    bizhawk_io_wrapper.writebyte(working_address, battle_data.UNKNOWN_ZERO_BYTE_3)
    working_address = working_address + 1

    --print(battle_data.ENTITIES)
    -- Write all battle entities
    for key, entity in pairs(battle_data.ENTITIES) do
        --print (entity.BATTLE_DATA)
        --print(working_address)
        entity_data = entity.BATTLE_DATA
        --print(entity)
        bizhawk_io_wrapper.writebyte(working_address, entity_data.TYPE)
        working_address = working_address + 1
        bizhawk_io_wrapper.writebyte(working_address, entity_data.X_POS)
        --print(entity_data.X_POS)
        working_address = working_address + 1
        bizhawk_io_wrapper.writebyte(working_address, entity_data.Y_POS)
        --print(entity_data.Y_POS)
        working_address = working_address + 1
        bizhawk_io_wrapper.writebyte(working_address, entity_data.KIND)
        working_address = working_address + 1
    end
    bizhawk_io_wrapper.writebyte(working_address, battle_data.LIMITER_START)
    return working_address
end

-- This function writes a given standard string to mmbn3, using text tables
-- defined in text_table_defs
function mmbn3_utils.patch_string(start_address, string_arg)

    local current_address = start_address
    for i = 1, #string_arg do

        --Cut off more than 10 chars, as mmbn3 can't display that anyways
        if i > 9 then
            break
        end

        local c = string_arg:sub(i,i)
        --print("Char: " .. c)
        --print("TEXT_TABLE translate: " .. TEXT_TABLE[c])
        bizhawk_io_wrapper.writebyte(current_address, TEXT_TABLE[c])
        current_address = current_address + 1
    end

    bizhawk_io_wrapper.writebyte(current_address, TEXT_TABLE.End_Of_String)


end




function mmbn3_utils.patch_entity_data(entities)

    for key, new_entity in pairs(entities) do

        if new_entity.BATTLE_DATA.KIND == ENTITY_KIND.MegaMan then
            break
        end
    
        -- Patch entity HP and Element, since they both use the same word.
        if new_entity.HP_ADDRESS ~= nil and new_entity.HP_BASE ~= nil then

            -- We don't need bitwise ops here if we just do an if.
            local masked_hp = new_entity.HP_BASE

            if masked_hp > 0x0FFF then
                masked_hp = 0x0FFF
            end
 
            local shifted_element = new_entity.ELEMENT * 0x1000
            local masked_hp_and_element = masked_hp + shifted_element
            bizhawk_io_wrapper.writeword(new_entity.HP_ADDRESS, masked_hp_and_element)
        end

        -- Patch entity Name
        if new_entity.NAME_ADDRESS ~= nil and new_entity.NAME ~= nil then
            mmbn3_utils.patch_string(new_entity.NAME_ADDRESS, new_entity.NAME)
        end

        
        -- Patch AI Values
        if new_entity.AI_ADDRESS ~= nil then
            if new_entity.AI_BYTES ~= nil then
                -- Iterate over AI_BYTES, and add the key (which is the offset) to the address for final address
                for offset, byte in pairs(new_entity.AI_BYTES) do
                    --print("Patching AI: key " .. offset .. " byte " .. byte)
                    bizhawk_io_wrapper.writebyte(new_entity.AI_ADDRESS + offset, byte)
                end
            end      
        end


    end

end

function patch_battle_pointer(pointer_table_address, new_data)

    local working_address = pointer_table_address

    bizhawk_io_wrapper.writedword(pointer_table_address, new_data.ADDRESS)

    working_address = working_address + 4

    bizhawk_io_wrapper.writebyte(working_address, new_data.UNID_BYTE_1)
    working_address = working_address + 1

    bizhawk_io_wrapper.writebyte(working_address, new_data.UNID_BYTE_2)
    working_address = working_address + 1

    bizhawk_io_wrapper.writebyte(working_address, new_data.UNID_BYTE_3)
    working_address = working_address + 1

    bizhawk_io_wrapper.writebyte(working_address, new_data.UNID_BYTE_4)
    working_address = working_address + 1
    
    bizhawk_io_wrapper.writebyte(working_address, new_data.BACKGROUND_TYPE)
    working_address = working_address + 1

    bizhawk_io_wrapper.writebyte(working_address, new_data.BATTLE_MODE)
    working_address = working_address + 1

    bizhawk_io_wrapper.writebyte(working_address, new_data.FOLDER_SHUFFLE)
    working_address = working_address + 1

    bizhawk_io_wrapper.writebyte(working_address, new_data.ALLOW_RUNNING)
    working_address = working_address + 1

    bizhawk_io_wrapper.writebyte(working_address, new_data.BATTLE_STAGE)
    working_address = working_address + 1

    bizhawk_io_wrapper.writebyte(working_address, new_data.UNID_BYTE_8)
    working_address = working_address + 1

    bizhawk_io_wrapper.writebyte(working_address, new_data.UNID_BYTE_9)
    working_address = working_address + 1

    bizhawk_io_wrapper.writebyte(working_address, new_data.UNID_BYTE_10)
    working_address = working_address + 1


end

function mmbn3_utils.change_battle_pointer_data(pointer_table_address, new_data)
    -- We assume that the 'correct' pointer table address is passed, and simply add the offset between them.

    patch_battle_pointer(pointer_table_address, new_data)
    patch_battle_pointer(pointer_table_address + defs.OFFSET_BETWEEN_POINTER_TABLES, new_data)
end



return mmbn3_utils