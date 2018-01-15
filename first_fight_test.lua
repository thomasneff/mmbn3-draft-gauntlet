-- Offsets:
local defs = require "defs"


local example_fight_data = {
    LIMITER_START = defs.BATTLE_LIMITER,
    UNKNOWN_ZERO_BYTE_1 = 0x00,
    UNKNOWN_ZERO_BYTE_2 = 0x00,
    UNKNOWN_ZERO_BYTE_3 = 0x00,
    ENTITIES = {
        {
            TYPE = defs.ENTITY_TYPE.Megaman,
            X_POS = 0x02,
            Y_POS = 0x02,
            KIND = defs.ENTITY_KIND.Megaman
        },
        {
            TYPE = defs.ENTITY_TYPE.Mettaur,
            X_POS = 0x05,
            Y_POS = 0x01,
            KIND = defs.ENTITY_KIND.Virus
        },
        {
            TYPE = defs.ENTITY_TYPE.Mettaur,
            X_POS = 0x05,
            Y_POS = 0x02,
            KIND = defs.ENTITY_KIND.Rock
        },
        {
            TYPE = defs.ENTITY_TYPE.Mettaur,
            X_POS = 0x06,
            Y_POS = 0x02,
            KIND = defs.ENTITY_KIND.Virus
        },
        {
            TYPE = defs.ENTITY_TYPE.Mettaur,
            X_POS = 0x05,
            Y_POS = 0x03,
            KIND = defs.ENTITY_KIND.Virus
        },
    }




    
}

function patch_battle(start_address, battle_data)

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
    -- Write all battle entities
    for key, entity in pairs(battle_data.ENTITIES) do
        memory.writebyte(working_address, entity.TYPE)
        working_address = working_address + 1
        memory.writebyte(working_address, entity.X_POS)
        working_address = working_address + 1
        memory.writebyte(working_address, entity.Y_POS)
        working_address = working_address + 1
        memory.writebyte(working_address, entity.KIND)
        working_address = working_address + 1
    end
    --memory.writebyte(working_address, battle_data.LIMITER_START)
    return working_address
end

--B4 AA 01 08 00 00 00 00 16 05 01 01 00 00
-- UNID_

local example_fight_pointer_entry = {
  -- Important - this address starts at the first entity (Megaman, typically)
  ADDRESS = 0x0801AA60,

  UNID_BYTE_1 = 0x00, -- freezes game if != 0
  UNID_BYTE_2 = 0x00, -- freezes game if != 0
  UNID_BYTE_3 = 0x00, -- freezes game if != 0
  UNID_BYTE_4 = 0x00, -- freezes game if != 0
  UNID_BYTE_5 = 0x16, -- Changes Background
  UNID_BYTE_6 = 0x05,
  UNID_BYTE_7 = 0x01,
  UNID_BYTE_8 = 0x01,
  UNID_BYTE_9 = 0x00,
  UNID_BYTE_10 = 0x00

}

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
    
    memory.writebyte(working_address, new_data.UNID_BYTE_5)
    working_address = working_address + 1

    memory.writebyte(working_address, new_data.UNID_BYTE_6)
    working_address = working_address + 1

    memory.writebyte(working_address, new_data.UNID_BYTE_7)
    working_address = working_address + 1

    memory.writebyte(working_address, new_data.UNID_BYTE_8)
    working_address = working_address + 1

    memory.writebyte(working_address, new_data.UNID_BYTE_9)
    working_address = working_address + 1

    memory.writebyte(working_address, new_data.UNID_BYTE_10)
    working_address = working_address + 1


end

function change_battle_pointer_data(pointer_table_address, new_data)
    -- We assume that the 'correct' pointer table address is passed, and simply add the offset between them.
    local offset_between_tables = 0xB24

    patch_battle_pointer(pointer_table_address, new_data)
    patch_battle_pointer(pointer_table_address + offset_between_tables, new_data)
end



-- The Gauntlet Battles are ordered in reverse - the first fight is at the lowest address. We will simply overwrite all other fights and see what happens.
--local num_battles = 10
--local last_fight_offset = 0x0801AA10
local num_battles = 10
local last_fight_address = 0x0801AA10
local working_address = last_fight_address
--local offset_between_fights = 24
--local ptr_table_address = 0x0812DD0C
local ptr_table_last_entry = 0x0812DC7C
local ptr_table_working_address = 0x0812DC7C
local offset_between_ptr_table_entries = 0x10

for battle_idx = 1,num_battles do
    
    --print("Working address: ", working_address)
    --print("Example fight data: ", example_fight_data)


    --Change pointer to fight (this breaks other fights, but whatever)
    example_fight_pointer_entry.ADDRESS = working_address + 0x04
    change_battle_pointer_data(ptr_table_working_address, example_fight_pointer_entry)
    ptr_table_working_address = ptr_table_working_address + offset_between_ptr_table_entries

    --TODO: change battle data

    --Write last battle
    working_address = patch_battle(working_address, example_fight_data)



    print("Patched ", battle_idx)

end

--Write the final limiter character
memory.writebyte(working_address, defs.BATTLE_LIMITER)



-- Simple test to see if any of the zeroes in the ptr table do anything. And which ptr table is relevant.
-- local ptr_table_address = 0x0812DD0C
-- This replaces the first battle by the second.
-- memory.writebyte(ptr_table_address, 0xA8)

-- There are 2 copies of the pointer table, just in case we patch both.
-- ptr_table_address = 0x0812E830
-- memory.writebyte(ptr_table_address, 0xA8)


--B4 AA 01 08 00 00 00 00 16 05 01 01 00 00 <-- this one is music I think
--B4 AA 01 08 00 00 00 00 16 05 01 01 00 00
--14 AA 01 08 00 00 00 00 16 05 01 01 00 00
--14 AA 01 08 00 00 00 00 16 05 01 01 00 00