local battle_data_generator = require "battle_data_generator"
local pointer_entry_generator = require "pointer_entry_generator"
local BACKGROUND_TYPE = require "defs.battle_background_defs"
local BATTLE_STAGE = require "defs.battle_stage_defs"
local GAUNTLET_DEFS = require "defs.gauntlet_defs"
local GAUNTLET_BATTLE_POINTERS = require "defs.gauntlet_battle_pointer_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local mmbn3_utils = require "mmbn3_utils"
local state_logic = require "state_logic"
math.randomseed(os.time())

local current_round = 0
local current_battle = 1
local battle_pointer_index = 1


function next_round()

    
    -- We just finished the round. We might want to load a savestate? Or just let the user do that.
    current_round = current_round + 1
    print("Starting Round " .. current_round)
    -- Reset all address variables, as we now start from the beginning again.
    battle_pointer_index = 1
    local ptr_table_working_address = GENERIC_DEFS.FIRST_GAUNTLET_BATTLE_POINTER_ADDRESS


    -- Patch all battle stage setups. This needs to be done before engaging the gauntlet.
    -- The game loads this probably into RAM, so we could only change that later if we found out the 
    -- respective RAM addresses...
    -- print("4")
    for battle_idx = 1, GAUNTLET_DEFS.BATTLES_PER_ROUND do
        local new_pointer_entry = pointer_entry_generator.new_from_template(GAUNTLET_BATTLE_POINTERS[battle_idx] + 4, BACKGROUND_TYPE.random() , BATTLE_STAGE.random())
        mmbn3_utils.change_battle_pointer_data(ptr_table_working_address, new_pointer_entry)
        ptr_table_working_address = ptr_table_working_address - GENERIC_DEFS.OFFSET_BETWEEN_POINTER_TABLE_ENTRIES
    end
    print("Patched Battle Stage Setups!")

    state_logic.on_next_round()

    -- Potentially do other stuff here. For example, we could set the state to a 'choose-reward' state.

end

function patch_next_battle()

    -- This function changes viruses, stage, AI, basically anything related to the fight when
    -- the fight loads.
    print("Battle ", current_battle, " start")

    -- When we finished all gauntlet battles, enter the next round.
    if battle_pointer_index > GAUNTLET_DEFS.BATTLES_PER_ROUND then
        --print("3")
        next_round()
    end
    -- print("5")
    local new_battle_data = battle_data_generator.random_from_battle(current_battle)
    -- print("6")
    mmbn3_utils.patch_battle(GAUNTLET_BATTLE_POINTERS[battle_pointer_index], new_battle_data)
    -- print("7")
    mmbn3_utils.patch_entity_data(new_battle_data.ENTITIES)
    -- print("8")
    print("Patched Battle ", current_battle)

    current_battle = current_battle + 1
    battle_pointer_index = battle_pointer_index + 1

    
    

end



-- Setup Callbacks for battle start to patch viruses
local gui_enabled = 0 -- TODO: replace with draft states and stuff
local gui_frame_counter = 0
local entered_battle = 0
local paused = 0


--savestate.loadslot(1)
savestate.load("initial.State")
state_logic.initialize()

client.unpause()
-- Upon start, initialize the current round:
next_round()

-- This gets called whenever a battle is loaded.
function on_enter_battle()
    print("1")
    patch_next_battle()

    state_logic.on_enter_battle()
    entered_battle = 1
end


--For some reason, BizHawk with VBA-Next requires an address that's 4 bytes larger. Whatever.
event.onmemoryexecute(on_enter_battle, GENERIC_DEFS.BATTLE_START_ADDRESS + 4)





while 1 do


    state_logic.main_loop()

    emu.yield()

    
end
