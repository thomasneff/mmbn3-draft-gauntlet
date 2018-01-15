local battle_data_generator = require "battle_data_generator"
local pointer_entry_generator = require "pointer_entry_generator"
local BACKGROUND_TYPE = require "defs.battle_background_defs"
local BATTLE_STAGE = require "defs.battle_stage_defs"
local GAUNTLET_DEFS = require "defs.gauntlet_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local mmbn3_utils = require "mmbn3_utils"
math.randomseed(os.time())



-- The Gauntlet Battles are ordered in reverse - the first fight is at the lowest address. We will simply overwrite all other fights and see what happens.

local num_battles = GAUNTLET_DEFS.NUMBER_OF_BATTLES
local last_fight_address = GENERIC_DEFS.LAST_GAUNTLET_BATTLE_ADDRESS
local working_address = last_fight_address

local ptr_table_last_entry = GENERIC_DEFS.LAST_GAUNTLET_BATTLE_POINTER_ADDRESS
local ptr_table_working_address = ptr_table_last_entry
local offset_between_ptr_table_entries = GENERIC_DEFS.OFFSET_BETWEEN_POINTER_TABLE_ENTRIES
local current_round = 0
local current_battle = 0


local all_battles = {}

for battle_idx = 1,num_battles do

    --Change pointer to fight (this breaks other fights, but whatever)
    
    local new_pointer_entry = pointer_entry_generator.new_from_template(working_address + 4, BACKGROUND_TYPE.random() , BATTLE_STAGE.random())

    mmbn3_utils.change_battle_pointer_data(ptr_table_working_address, new_pointer_entry)
    ptr_table_working_address = ptr_table_working_address + offset_between_ptr_table_entries

    --Generate new battle for this address

    local new_battle_data = battle_data_generator.random_from_round(current_round, 0)
    all_battles[battle_idx] = deepcopy(new_battle_data)
    --print(new_battle_data)
    --new_battle_data = battle_data_generator.random_from_round(current_round, 0)
    --Write last battle
    working_address = mmbn3_utils.patch_battle(working_address, new_battle_data)

    current_round = math.random(0, 1)


    print("Patched ", battle_idx)

end

-- Setup Callbacks for battle start to patch viruses

function on_enter_battle()
    current_battle = current_battle + 1
    mmbn3_utils.patch_entity_data(all_battles[current_battle].ENTITIES)
    print("Battle ", current_battle, " start - patched viruses!")

end


memory.registerexec(GENERIC_DEFS.BATTLE_START_ADDRESS, on_enter_battle)

--Write the final limiter character
memory.writebyte(working_address, GENERIC_DEFS.BATTLE_LIMITER)
