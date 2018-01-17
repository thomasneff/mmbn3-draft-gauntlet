local battle_data_generator = require "battle_data_generator"
local pointer_entry_generator = require "pointer_entry_generator"
local BACKGROUND_TYPE = require "defs.battle_background_defs"
local BATTLE_STAGE = require "defs.battle_stage_defs"
local GAUNTLET_DEFS = require "defs.gauntlet_defs"
local GAUNTLET_BATTLE_POINTERS = require "defs.gauntlet_battle_pointer_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local mmbn3_utils = require "mmbn3_utils"
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

    for battle_idx = 1, GAUNTLET_DEFS.BATTLES_PER_ROUND do
        local new_pointer_entry = pointer_entry_generator.new_from_template(GAUNTLET_BATTLE_POINTERS[battle_idx] + 4, BACKGROUND_TYPE.random() , BATTLE_STAGE.random())
        mmbn3_utils.change_battle_pointer_data(ptr_table_working_address, new_pointer_entry)
        ptr_table_working_address = ptr_table_working_address - GENERIC_DEFS.OFFSET_BETWEEN_POINTER_TABLE_ENTRIES
    end
    print("Patched Battle Stage Setups!")

    -- Potentially do other stuff here. For example, we could set the state to a 'choose-reward' state.

end

function patch_next_battle()

    -- This function changes viruses, stage, AI, basically anything related to the fight when
    -- the fight loads.
    print("Battle ", current_battle, " start")

    local new_battle_data = battle_data_generator.random_from_battle(current_battle)

    mmbn3_utils.patch_battle(GAUNTLET_BATTLE_POINTERS[battle_pointer_index], new_battle_data)
    mmbn3_utils.patch_entity_data(new_battle_data.ENTITIES)

    print("Patched Battle ", current_battle)

    current_battle = current_battle + 1
    battle_pointer_index = battle_pointer_index + 1

    -- When we finished all gauntlet battles, enter the next round.
    if current_battle > GAUNTLET_DEFS.BATTLES_PER_ROUND then
        next_round()
    end

end



-- Setup Callbacks for battle start to patch viruses
local enable_rendering = 0 -- TODO: replace with draft states and stuff
local gui_frame_counter = 0
local entered_battle = 0
local paused = 0

-- Upon start, initialize the current round:
next_round()

-- This gets called whenever a battle is loaded.
function on_enter_battle()
    
    patch_next_battle()
    entered_battle = 1
end

-- This gets called every frame by the emulator to render GUI.
-- This is *also* called when the emulator is paused.
function on_render_frame()

    if enable_rendering == 0 then
        return
    end
    
    gui.text(0, 0, "Frame " .. tostring(gui_frame_counter) .. " Mouse X: " .. tostring(input.get().xmouse) .. " Mouse Y: " .. tostring(input.get().ymouse))

    local num_folder_chips = 30
    local num_chips_per_col = 10
    local num_cols = num_folder_chips / num_chips_per_col
    local base_offset_y = 20
    local base_offset_x = 4
    local offset_per_col = 40
    local offset_per_row = 10
    local x_offset = base_offset_x
    local y_offset = base_offset_y

    for col_idx = 1, num_cols do
        y_offset = base_offset_y
        for chip_idx = 1,num_chips_per_col do
            gui.text(x_offset, y_offset, "Cannon *")
            y_offset = y_offset + offset_per_row
        end
        x_offset = x_offset + offset_per_col
    end
    gui_frame_counter = gui_frame_counter + 1

    --print(input.get())
    if input.get().leftclick == true then
        print("LEFT CLICK!")
        enable_rendering = 0
        paused = 0
        emu.unpause()
    end

end


print("EXEC ADDRESS: ", GENERIC_DEFS.BATTLE_START_ADDRESS )
memory.registerexec(GENERIC_DEFS.BATTLE_START_ADDRESS, on_enter_battle)

--memory.registerread(0x0200F520, on_enter_battle)
gui.register(on_render_frame)

--Write the final limiter character
memory.writebyte(working_address, GENERIC_DEFS.BATTLE_LIMITER)
--emu.pause()
--emu.unpause()
--Main loop to control draft and stuff.


while 1 do

    if entered_battle == 1 then
        entered_battle = 0
        enable_rendering = 1
        paused = 1
    end
    
    --print("Frame " .. tostring(gui_frame_counter))
    
    if paused == 0 then
        emu.frameadvance()
    else
        emu.pause()
    end
end
