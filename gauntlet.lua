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
local current_battle = 1
local current_battle_generate = 1

local all_battles = {}

for battle_idx = 1,num_battles do

    --Change pointer to fight (this breaks other fights, but whatever)
    
    local new_pointer_entry = pointer_entry_generator.new_from_template(working_address + 4, BACKGROUND_TYPE.random() , BATTLE_STAGE.random())

    mmbn3_utils.change_battle_pointer_data(ptr_table_working_address, new_pointer_entry)
    ptr_table_working_address = ptr_table_working_address + offset_between_ptr_table_entries

    --Generate new battle for this address

    local new_battle_data = battle_data_generator.random_from_battle(current_battle_generate)
    all_battles[battle_idx] = deepcopy(new_battle_data)
    --print(new_battle_data)
    --new_battle_data = battle_data_generator.random_from_round(current_round, 0)
    --Write last battle
    working_address = mmbn3_utils.patch_battle(working_address, new_battle_data)

    
    current_battle_generate = current_battle_generate + 1

    print("Patched ", battle_idx)

end

-- Setup Callbacks for battle start to patch viruses
local enable_rendering = 0 -- TODO: replace with draft states and stuff
local gui_frame_counter = 0
local entered_battle = 0
local paused = 0
function on_enter_battle()
    
    print("Battle ", current_battle, " start - patching viruses!")
    mmbn3_utils.patch_entity_data(all_battles[current_battle].ENTITIES)
    print("Battle ", current_battle, " start - patched viruses!")
    current_battle = current_battle + 1
    entered_battle = 1
end


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
