local input_handler = require "input_handler"
local gui_rendering = require "gui_rendering"
local battle_data_generator = require "battle_data_generator"
local pointer_entry_generator = require "pointer_entry_generator"
local BACKGROUND_TYPE = require "defs.battle_background_defs"
local BATTLE_STAGE = require "defs.battle_stage_defs"
local GAUNTLET_DEFS = require "defs.gauntlet_defs"
local GAUNTLET_BATTLE_POINTERS = require "defs.gauntlet_battle_pointer_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local mmbn3_utils = require "mmbn3_utils"
local CHIP = require "defs.chip_defs"
local CHIP_NAME_UTILS = require "defs.chip_name_utils"
local CHIP_NAME = require "defs.chip_name_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"
local CHIP_CODE_REVERSE = require "defs.chip_code_reverse_defs"
local CHIP_ICON = require "defs.chip_icon_defs"
local CHIP_PICTURE = require "defs.chip_picture_defs"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_DROP_UTILS = require "defs.chip_drop_utils"
local BUFF_GENERATOR = require "buff_effects.buff_groups"
local START_FOLDER = require "defs.start_folder_defs"
local LOADOUTS = require "loadouts.loadout_defs"
local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP_DROP_METHODS = require "chip_drop_methods.chip_drop_method_defs"
local MusicLoader = require "music_loader"
local json = require "json"
local randomchoice_key = require "randomchoice_key"
local PA_DEFS = require "defs.pa_defs"


-- TODO: possibly add more states.

local state_logic = {}

state_logic.activated_buffs = {}
state_logic.dropped_chips = {}
state_logic.dropped_buffs = {}
state_logic.initial_state = "initial.State"
state_logic.number_of_activated_buffs = 0
gauntlet_data.current_folder = {}
gauntlet_data.mega_max_hp = 100
state_logic.stats_file_name = ""

state_logic.hp_loaded = 0
state_logic.buff_render_offset = 0

state_logic.initial_chip_amount_flag = 0

state_logic.dropped_chips[1] = CHIP.new_chip_with_code(CHIP_ID.Cannon, CHIP_CODE.A)
state_logic.dropped_chips[2] = CHIP.new_chip_with_code(CHIP_ID.Cannon, CHIP_CODE.B)
state_logic.dropped_chips[3] = CHIP.new_chip_with_code(CHIP_ID.Cannon, CHIP_CODE.C)

state_logic.draft_selection_chips = {}

state_logic.should_redraw = 1
gauntlet_data.chip_drop_method = CHIP_DROP_METHODS[1]
state_logic.hp_patch_frame_counter = 0
state_logic.battle_start_frame_counter = 0

state_logic.dropped_chip = CHIP.new_chip_with_code(CHIP_ID.Cannon, CHIP_CODE.A)
state_logic.dropped_chip.ID = -1
state_logic.dropped_chip.PRINT_NAME = ""
gauntlet_data.loadout_chosen = 0
state_logic.selected_loadout_index = 2
state_logic.selected_drop_method_index = 2

gauntlet_data.current_state = gauntlet_data.GAME_STATE.DEFAULT_WAITING_FOR_EVENTS
state_logic.dropped_chip_render_index = 1
state_logic.draft_chip_render_index = 1
state_logic.dropped_buff_render_index = 2
state_logic.folder_chip_render_index = 1
state_logic.pause_frame_counter = 0


state_logic.gui_change_savestate = nil

gauntlet_data.mega_chip_limit = GAUNTLET_DEFS.INITIAL_MEGA_CHIP_LIMIT
gauntlet_data.giga_chip_limit = GAUNTLET_DEFS.INITIAL_GIGA_CHIP_LIMIT

state_logic.current_round = 0
state_logic.current_battle = 1
state_logic.battle_pointer_index = 1
state_logic.battle_data = {}

state_logic.CHIP_DATA_COPY = {}
state_logic.INITIAL_CHIP_DATA = nil

state_logic.in_battle_rng_values = nil
state_logic.battle_enter_lock = 0
state_logic.main_loop_frame_count = 0
state_logic.time_compression_savestates = {}


function state_logic.next_round()

    
    -- We just finished the round. We might want to load a savestate? Or just let the user do that.
    state_logic.current_round = state_logic.current_round + 1

    

    
    -- Reset all address variables, as we now start from the beginning again.
    state_logic.battle_pointer_index = 1

    if state_logic.current_round == (GAUNTLET_DEFS.MAX_NUMBER_OF_ROUNDS + 1) then

        return

    end


    local ptr_table_working_address = GENERIC_DEFS.FIRST_GAUNTLET_BATTLE_POINTER_ADDRESS
    print("Starting Round " .. state_logic.current_round)

    -- Patch all battle stage setups. This needs to be done before engaging the gauntlet.
    -- The game loads this probably into RAM, so we could only change that later if we found out the 
    -- respective RAM addresses...
    -- print("4")
    for battle_idx = 1, GAUNTLET_DEFS.BATTLES_PER_ROUND do
        local new_pointer_entry = pointer_entry_generator.new_from_template(GAUNTLET_BATTLE_POINTERS[battle_idx] + 4, BACKGROUND_TYPE.random() , BATTLE_STAGE.random())
        gauntlet_data.battle_stages[(state_logic.current_round - 1) * GAUNTLET_DEFS.BATTLES_PER_ROUND + battle_idx] = new_pointer_entry.BATTLE_STAGE
        mmbn3_utils.change_battle_pointer_data(ptr_table_working_address, new_pointer_entry)
        ptr_table_working_address = ptr_table_working_address - GENERIC_DEFS.OFFSET_BETWEEN_POINTER_TABLE_ENTRIES
    end
    --print("Patched Battle Stage Setups!")

    state_logic.on_next_round()

    -- Potentially do other stuff here. For example, we could set the state to a 'choose-reward' state.

end

function state_logic.patch_consecutive_program_advances()

    -- early out checks if we can even possibly get a PA: we have to have 3 consecutive chips that are listed in the PA defs

    if (#gauntlet_data.selected_chips < 3) then
        return
    end

    local is_pa_chip_ids = {}
    local is_pa_chip_codes = {}
    local can_contain_a_pa = false

    for chip_idx = 1, (#gauntlet_data.selected_chips - 2) do

        local pa_buffer_ids = {}
        local pa_buffer_codes = {}
        local num_codes = 0
        local num_ids = 0
        for pa_idx = 1,3 do

            local total_idx = chip_idx + pa_idx - 1

            local selected_chip = gauntlet_data.selected_chips[total_idx]

            if selected_chip == nil then
                break
            end

            local pa_chip = PA_DEFS[gauntlet_data.selected_chips[total_idx].ID]

            -- If any of those 3 chips don't form a PA, we're done.
            if pa_chip == nil then
                break
            end

            -- If we have a PA chip, we need to check if the previous chip is same ID and ascending code (except asterisk)
           

            if pa_idx > 1 then
                if pa_buffer_ids[pa_idx - 1] ~= selected_chip.ID then
                    break
                end

                if (pa_buffer_codes[pa_idx - 1] ~= CHIP_CODE.Asterisk) and pa_buffer_codes[pa_idx - 1] >= selected_chip.CODE then
                    break
                end
            end

            pa_buffer_ids[pa_idx] = selected_chip.ID
            pa_buffer_codes[pa_idx] = selected_chip.CODE
            num_codes = num_codes + 1
            num_ids = num_ids + 1

        end

        if num_codes == 3 and num_codes == 3 then
            can_contain_a_pa = true
            break
        end

    end


    if can_contain_a_pa == false then
        return
    end
    

    -- For patching consecutive PAs, we need to:
        -- Check if we have a PA (needs a table to lookup everything, including asterisk code chips and stuff)
        -- Simply patch the 3 PA slots
            -- This has the format of 7 bits starting code, 9 bits PA "chip ID", followed by 1 byte "component" ID.
            -- Therefore we need to patch all of this according to the PA we want to execute.

    -- (For other PAs, this seems to be working fine anyways.)

    -- To patch the correct PA slots, we actually need to sort our first 3 chips by ID, and then patch an according slot since
        -- BN3 performs a search on the stored PAs...

    -- We could simply check if the initial search location is constant, then patch this and the one before/after, and overwrite all the others with min/max?

    -- initial location seems to be 0800D6E8


    -- sort first 3 selected chips according to chip index

    --for chip_idx = 1, #gauntlet_data.selected_chips do

        -- Debug print
        --print("Selected Chip " .. tostring(chip_idx) .. ": " .. gauntlet_data.selected_chips[chip_idx].NAME ..
        -- " (ID: " .. tostring(gauntlet_data.selected_chips[chip_idx].ID) .. ", Code: " .. tostring(gauntlet_data.selected_chips[chip_idx].CODE) .. ")")


    --end

    local sorted_chips = {}

    local contains_pa_chip = 0

    for chip_idx = 1, #gauntlet_data.selected_chips do
       
        if chip_idx < 4 then
            sorted_chips[chip_idx] = deepcopy(gauntlet_data.selected_chips[chip_idx])
            sorted_chips[chip_idx].pa_chip = PA_DEFS[sorted_chips[chip_idx].ID]
            if sorted_chips[chip_idx].pa_chip ~= nil then
                contains_pa_chip = contains_pa_chip + 1
                if sorted_chips[chip_idx].CODE == CHIP_CODE.Asterisk then
                    if gauntlet_data.selected_chips[chip_idx + 1] ~= nil then
                        --print("Asterisk chip followup")

                        -- If the next chip also has asterisk code, we don't do anything and set our ID to something invalid.
                        if gauntlet_data.selected_chips[chip_idx + 1].CODE == CHIP_CODE.Asterisk then
                            sorted_chips[chip_idx].ID = 0
                            sorted_chips[chip_idx].CODE = 1
                        else
                            -- This is a workaround for asterisk chips to correctly set the "initial" PA stuff. 
                            -- TODO: check if this is even working in vanilla (*, B, C for example)
                            sorted_chips[chip_idx].CODE = gauntlet_data.selected_chips[chip_idx + 1].CODE - 1
                        end
                        
                        --print(sorted_chips[chip_idx].CODE)
                    end
                end
                sorted_chips[chip_idx].shifted_code = bit.lshift(sorted_chips[chip_idx].CODE, 9)
                sorted_chips[chip_idx].combined_pa_chip_and_code = bit.bor(sorted_chips[chip_idx].shifted_code, sorted_chips[chip_idx].pa_chip)
            end
        end
        
    end
    
    


    -- TODO: this patching has to be optimized - it leads to audible stuttering upon cust screen confirmation.
    if contains_pa_chip == 0 then
        return
    end

    table.sort(sorted_chips, function(a, b)
        return a.ID < b.ID
    end)
    
    -- Patch all locations from start until end and overwrite them such that the bn3 search algorithm finds our patched PAs
    
    local num_pas = math.floor((GENERIC_DEFS.PA_CONSECUTIVE_END_ADDRESS - GENERIC_DEFS.PA_CONSECUTIVE_START_ADDRESS) / 4)

    for pa_idx = 0, num_pas do


        local pa_address = GENERIC_DEFS.PA_CONSECUTIVE_START_ADDRESS + 4 * pa_idx

            
        local selected_chip_id = 0
        local combined_pa_chip_and_code = 0
            
        if (pa_address < GENERIC_DEFS.PA_CONSECUTIVE_CENTER_ADDRESS) then
            selected_chip_id = 0
                

            if #sorted_chips > 0 then
                selected_chip_id = sorted_chips[1].ID
                combined_pa_chip_and_code = sorted_chips[1].combined_pa_chip_and_code
            end
                
            if combined_pa_chip_and_code == nil then
                combined_pa_chip_and_code = 0
            end

            if selected_chip_id == nil then
                selected_chip_id = 0
            end
                
        elseif (pa_address == GENERIC_DEFS.PA_CONSECUTIVE_CENTER_ADDRESS) then
            selected_chip_id = 128

            if #sorted_chips == 1 then
                selected_chip_id = sorted_chips[1].ID
                combined_pa_chip_and_code = sorted_chips[1].combined_pa_chip_and_code
            elseif #sorted_chips > 1 then
                selected_chip_id = sorted_chips[2].ID
                combined_pa_chip_and_code = sorted_chips[2].combined_pa_chip_and_code
            end

            if combined_pa_chip_and_code == nil then
                combined_pa_chip_and_code = 128
            end

            if selected_chip_id == nil then
                selected_chip_id = 128
            end
        else
            selected_chip_id = 255

            if #sorted_chips == 2 then
                selected_chip_id = sorted_chips[2].ID
                combined_pa_chip_and_code = sorted_chips[2].combined_pa_chip_and_code
            elseif #sorted_chips == 3 then
                selected_chip_id = sorted_chips[3].ID
                combined_pa_chip_and_code = sorted_chips[3].combined_pa_chip_and_code
            end

            if combined_pa_chip_and_code == nil then
                combined_pa_chip_and_code = 255
            end

            if selected_chip_id == nil then
                selected_chip_id = 255
            end
        end

            --print(combined_pa_chip_and_code)
            --print(selected_chip_id)
            --print("Forged PA data: " .. bizstring.hex(combined_pa_chip_and_code))
            -- Write PA chip ID + starting code
        memory.write_u16_le(pa_address - 0x08000000, combined_pa_chip_and_code, "ROM")
    
            -- Write component ID
        memory.writebyte(pa_address + 2 - 0x08000000, selected_chip_id, "ROM")
        
    end

end

function state_logic.on_cust_screen_confirm()
    --print("Cust screen confirmed!")
    gauntlet_data.current_battle_chip_index = 1
  
    

    --CUST_SCREEN_CONFIRM_ADDRESS = 0x0800F7D8,
    --CHIP_USE_ADDRESS = 0x080B4880,
    --IN_BATTLE_NUMBER_OF_CHIPS_ADDRESS = 0x0203728A,
    --CUST_SCREEN_NUMBER_OF_CHIPS_ADDRESS = 0x0200F7F6,
    --IN_BATTLE_HELD_CHIP_IDS_ADDRESS = 0x02034060,
    --IN_BATTLE_HELD_CHIP_DAMAGES_ADDRESS = 0x0203406C,
    --CUST_SCREEN_SELECTED_CHIP_INDICES_ADDRESS = 0x0200F842,
    --IN_BATTLE_CURRENT_CHIP_DAMAGE = 0x02034070,


    -- Read out selected chip indices
    gauntlet_data.selected_chips = {}

    local num_chips = memory.readbyte(GENERIC_DEFS.CUST_SCREEN_NUMBER_OF_CHIPS_ADDRESS - 0x02000000, "EWRAM")

    for chip_idx = 1, num_chips do
        local folder_index = memory.readbyte(GENERIC_DEFS.CUST_SCREEN_SELECTED_CHIP_INDICES_ADDRESS + chip_idx - 1 - 0x02000000, "EWRAM")
        gauntlet_data.selected_chips[chip_idx] = {}
        
        -- As we now have the folder index, we can read chip code and ID.
        gauntlet_data.selected_chips[chip_idx].ID = memory.read_u16_le(GENERIC_DEFS.FOLDER_START_ADDRESS_RAM + (folder_index * 4) - 0x02000000, "EWRAM")
        gauntlet_data.selected_chips[chip_idx].CODE = memory.readbyte(GENERIC_DEFS.FOLDER_START_ADDRESS_RAM + (folder_index * 4) + 2 - 0x02000000, "EWRAM")
        gauntlet_data.selected_chips[chip_idx].NAME = deepcopy(CHIP_NAME[gauntlet_data.selected_chips[chip_idx].ID])
    end

      
    -- Fire events for buffs
    for k, v in pairs(state_logic.activated_buffs) do
        if v.IN_BATTLE_CALLBACKS ~= nil then
            v:on_cust_screen_confirm(state_logic, gauntlet_data)
        end
    end
   
    --gauntlet_data.num_chips_in_battle = num_chips
    
    state_logic.patch_consecutive_program_advances()

    
end

function state_logic.on_battle_phase_start()


    --print("Battle phase start!")

    -- Extract held chip IDs and damage values
    gauntlet_data.battle_phase = 1

    local held_chip_id_addr = GENERIC_DEFS.IN_BATTLE_HELD_CHIP_IDS_ADDRESS - 0x02000000
    local held_chip_damage_addr =  GENERIC_DEFS.IN_BATTLE_HELD_CHIP_DAMAGES_ADDRESS - 0x02000000

    gauntlet_data.held_chips = {}
    gauntlet_data.custgauge_last_frames_storage = 0

    for chip_idx = 1,5 do 

        local chip_id = memory.read_u16_le(held_chip_id_addr + ((chip_idx - 1) * 2), "EWRAM")

        if (chip_id ~= 0xFFFF) then
            
            local chip_damage = memory.read_u16_le(held_chip_damage_addr + ((chip_idx - 1) * 2), "EWRAM")

            local chip = {}
            chip.ID = chip_id
            chip.DAMAGE = chip_damage

            gauntlet_data.held_chips[chip_idx] = deepcopy(chip)

            --print("Chip " .. tostring(chip_idx) .. ": NAME = " .. CHIP_NAME[chip.ID] ..  ", ID = " .. tostring(chip.ID) .. ", DAMAGE = " .. tostring(chip.DAMAGE))
        end

    end


end

function state_logic.on_chip_use()
    --print("Chip used!")

    for k, v in pairs(state_logic.activated_buffs) do
        if v.IN_BATTLE_CALLBACKS ~= nil then
            v:on_chip_use(gauntlet_data.selected_chips[gauntlet_data.current_battle_chip_index], 
                state_logic.main_loop_frame_count, 
                state_logic, 
                gauntlet_data)
        end
    end

    --state_logic.update_printable_chip_names_in_folder()
    --state_logic.update_argb_chip_icons_in_folder()
    gauntlet_data.current_battle_chip_index = gauntlet_data.current_battle_chip_index + 1

end


function state_logic.patch_next_battle()

    -- This function changes viruses, stage, AI, basically anything related to the fight when
    -- the fight loads.
    print("Battle ", state_logic.current_battle, " start")

    -- When we finished all gauntlet battles, enter the next round.
    --if state_logic.battle_pointer_index > GAUNTLET_DEFS.BATTLES_PER_ROUND or 
    --    state_logic.current_round == 0 then
        --print("3")
    --    state_logic.next_round()
    --end

    --print("MOD: ", state_logic.current_round % GAUNTLET_DEFS.ROUNDS_PER_BUFF_DROP)
    if (state_logic.current_battle - 1) % GAUNTLET_DEFS.ROUNDS_PER_BUFF_DROP == 0 then
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_BUFF_SELECT
    end


    

    -- print("5")
    
    -- print("7")
    
    -- print("8")
    --print("Patched Battle ", state_logic.current_battle)

    
    

    
    

end


local DEBUG = 0

function state_logic.recompute_perfect_damage_bonuses()

    local damage_mult =  gauntlet_data.perfectionist_damage_bonus_mult.BASE +  gauntlet_data.perfectionist_damage_bonus_mult.PERFECT_FIGHT_INCREASE * gauntlet_data.number_of_perfect_fights
    
    if damage_mult > gauntlet_data.perfectionist_damage_bonus_mult.LIMIT then
        damage_mult = gauntlet_data.perfectionist_damage_bonus_mult.LIMIT
    end
    
    gauntlet_data.perfectionist_damage_bonus_mult.CURRENT = damage_mult

    --print("Perfectionist multiplier: " .. gauntlet_data.perfectionist_damage_bonus_mult.CURRENT)
    
    local damage_add =  gauntlet_data.perfectionist_damage_bonus_add.BASE +  gauntlet_data.perfectionist_damage_bonus_add.PERFECT_FIGHT_INCREASE * gauntlet_data.number_of_perfect_fights
    
    if damage_add > gauntlet_data.perfectionist_damage_bonus_add.LIMIT then
        damage_add = gauntlet_data.perfectionist_damage_bonus_add.LIMIT
    end
    
    gauntlet_data.perfectionist_damage_bonus_add.CURRENT = damage_add

    if gauntlet_data.skill_not_luck_active == 1 then
        gauntlet_data.skill_not_luck_bonus_current = gauntlet_data.skill_not_luck_bonus_per_battle * gauntlet_data.skill_not_luck_number_of_fights
        print("Skill not luck active, current bonus: " .. gauntlet_data.skill_not_luck_bonus_current)
    end

end

function state_logic.compute_perfect_fight_bonuses()

    if gauntlet_data.has_mega_been_hit == 0 then
        gauntlet_data.number_of_perfect_fights = gauntlet_data.number_of_perfect_fights + 1
        gauntlet_data.skill_not_luck_number_of_fights = gauntlet_data.skill_not_luck_number_of_fights + 1
        print("Perfect Fight!")
    end


    gauntlet_data.has_mega_been_hit = 0

    
    
    state_logic.recompute_perfect_damage_bonuses()

end


function state_logic.compute_temporary_chip_changes()
    

    
    
    -- Restore CHIP_DATA from copy. Copies are always taken when taking a buff, as this is the only possibility where CHIP_DATA is changed directly.
    for key, chip_data in pairs(CHIP_DATA) do
        CHIP_DATA[key] = deepcopy(state_logic.CHIP_DATA_COPY[key])
    end
    
    
    
    -- Apply temporary buffs
    for key, chip_data in pairs(CHIP_DATA) do 
        CHIP_DATA[key].DAMAGE = (CHIP_DATA[key].DAMAGE * gauntlet_data.perfectionist_damage_bonus_mult.CURRENT) + gauntlet_data.perfectionist_damage_bonus_add.CURRENT
    end

    -- Apply collector temporary buffs
    if gauntlet_data.collector_active == 1 then

        -- Get a map from CHIP_ID -> number of duplicates
        local chip_duplicates_map = {}

        for chip_idx = 1,#gauntlet_data.current_folder do
            local chip = gauntlet_data.current_folder[chip_idx]

            if chip_duplicates_map[chip.ID] == nil then
                chip_duplicates_map[chip.ID] = 0
            else
                chip_duplicates_map[chip.ID] = chip_duplicates_map[chip.ID] + 1
            end
        end

        --print("DUPLICATES MAP:")
        --print(chip_duplicates_map)

        -- Apply buffs

        for chip_id, num_duplicates in pairs(chip_duplicates_map) do
            --print(chip_id)
            CHIP_DATA[chip_id].DAMAGE = CHIP_DATA[chip_id].DAMAGE * (1.0 + num_duplicates * gauntlet_data.collector_duplicate_damage_bonus)
        end

    end


end


function state_logic.on_battle_end()

    event.unregisterbyname("on_battle_end")

    if state_logic.battle_pointer_index > GAUNTLET_DEFS.BATTLES_PER_ROUND then
       gauntlet_data.current_state = gauntlet_data.GAME_STATE.LOAD_INITIAL 
    end  

    -- Reset battle enter lock
    state_logic.battle_enter_lock = 0

    -- Compute lost HP

    gauntlet_data.current_hp = memory.read_u16_le(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_LOADING - 0x02000000, "EWRAM")
    state_logic.stats_lost_hp = state_logic.stats_previous_hp - gauntlet_data.current_hp
    state_logic.stats_previous_hp = gauntlet_data.current_hp
    
    if gauntlet_data.current_hp == 0 then
        print("Reset in on_battle_end(), MEGA HP was 0 during battle end loading")
        state_logic.initialize()
        return
    end

    state_logic.compute_perfect_fight_bonuses()
    
    -- Compute buff effects that depend on battle ending
    for k, v in pairs(state_logic.activated_buffs) do
        if v.FINISH_BATTLE_CALLBACK ~= nil then
            v:on_finish_battle(state_logic, gauntlet_data)
        end
    end
    state_logic.update_printable_chip_names_in_folder()
    state_logic.update_argb_chip_icons_in_folder()

    
    event.onmemoryexecute(state_logic.on_enter_battle, GENERIC_DEFS.BATTLE_START_ADDRESS + 4, "on_enter_battle")
    gauntlet_data.num_chips_in_battle = 0
    gauntlet_data.battle_phase = 0
    gauntlet_data.is_cust_screen = 0
    state_logic.hp_loaded = 0
    gauntlet_data.cust_screen_was_opened = 0
end

function state_logic.determine_drops(number_of_drops)

    if state_logic.battle_data[state_logic.current_battle - 1] == nil then

        -- First round. Do we do anything here?
        -- For now, we don't.
        
        
    else

        -- TODO: determine drops from state_logic.battle_data[state_logic.current_battle].ENTITIES entity droptables.
        --TODO: for now, this just randomizes.
        --state_logic.randomize_dropped_chips(number_of_drops)
        state_logic.dropped_chips = gauntlet_data.chip_drop_method.generate_drops(state_logic.battle_data[state_logic.current_battle - 1], state_logic.current_round, number_of_drops)--CHIP_DROP_UTILS.dropped_chips_from_battle(state_logic.battle_data[state_logic.current_battle - 1], state_logic.current_round, number_of_drops)

        state_logic.update_dropped_chips_pictures(state_logic.dropped_chips)
        

    end

    

end

function state_logic.on_enter_battle()
    
    -- Check if this is really the battle start or just a use of FoldrBak
    -- If in the future, somehow, our check with battle_start and battle_end doesn't work, we can use this to check for FoldrBak
    --local r9_val = emu.getregister("R9")
    --local r6_val = emu.getregister("R6")

    --print("r6 = " .. tostring(r6_val) .. ", r9 = " .. tostring(r9_val))

    --if r6_val ~= 1 or r9_val ~= 0x0200AB90 then
    --    return
    --end

    -- We simply check if we are in battle, because then it's guaranteed to be FoldrBak
    event.unregisterbyname("on_enter_battle")

    if state_logic.battle_enter_lock == 1 then
        return
    end

    state_logic.battle_enter_lock = 1
    
    MusicLoader.LoadRandomFile(state_logic.current_battle)



    state_logic.patch_next_battle()
    --state_logic.determine_drops(GAUNTLET_DEFS.NUMBER_OF_DROPPED_CHIPS)
    state_logic.shuffle_folder()
    
    

    if gauntlet_data.current_state ~= gauntlet_data.GAME_STATE.TRANSITION_TO_BUFF_SELECT and  
        gauntlet_data.current_state ~= gauntlet_data.GAME_STATE.BUFF_SELECT then
            gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_CHIP_SELECT
    end


    if gauntlet_data.loadout_chosen == 0 then

        gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_CHOOSE_DROP_METHOD

    end

    --print("STATE_ENTER: ", gauntlet_data.current_state)
    --print(print(state_logic.dropped_chip))
    if state_logic.current_round >= (GAUNTLET_DEFS.MAX_NUMBER_OF_ROUNDS + 1) then

        gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_GAUNTLET_COMPLETE

    end

    event.onmemoryexecute(state_logic.on_battle_end, GENERIC_DEFS.END_OF_GAUNTLET_BATTLE_ADDRESS, "on_battle_end")
    --gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_CHIP_SELECT
    gauntlet_data.num_chips_in_battle = 0
    gauntlet_data.battle_phase = 0
    gauntlet_data.is_cust_screen = 0
    state_logic.hp_loaded = 0

end


function state_logic.on_next_round()
    
    --print ("BEFORE MEGA MAX INCREASE PER ROUND")
    gauntlet_data.mega_max_hp = gauntlet_data.mega_max_hp + GAUNTLET_DEFS.HP_INCREASE_PER_ROUND[state_logic.current_round]
    state_logic.stats_previous_hp = gauntlet_data.mega_max_hp
    
    
    gauntlet_data.hp_patch_required = 1
    --print(" MEGA MAX HP: ", gauntlet_data.mega_max_hp)
    --print ("BEFORE CHANGE MAX HP")
    
    --print ("BEFORE TRANSITION TO BUFF SELECT")
    gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_BUFF_SELECT
    gauntlet_data.cust_screen_was_opened = 0

end


function state_logic.reset_selected_chips()
    state_logic.dropped_chip_render_index = 1
    state_logic.folder_chip_render_index = 1
end

function state_logic.randomize_dropped_chips(number_of_dropped_chips)
    state_logic.dropped_chips = {}
    for chip_idx = 1,number_of_dropped_chips do

        state_logic.dropped_chips[chip_idx] = CHIP.new_random_chip_with_random_code()
        --state_logic.dropped_chips[chip_idx] = CHIP.new_chip_with_code(CHIP_ID.Bolt, 0)

    end
   
    
end

function state_logic.randomize_folder()

    for chip_idx = 1,GENERIC_DEFS.NUMBER_OF_CHIPS_IN_FOLDER do

        gauntlet_data.current_folder[chip_idx] = CHIP.new_random_chip_with_random_code()
        --gauntlet_data.current_folder[chip_idx] = CHIP.new_chip_with_code(0x1, 0)

    end
   
    
end



function state_logic.initialize_folder()

    gauntlet_data.current_folder = {}

    gauntlet_data.current_folder = START_FOLDER.get_random(nil)

    
end


function state_logic.update_dropped_chips_pictures(list_of_chips)

    for chip_idx = 1,#list_of_chips do
        local chip = list_of_chips[chip_idx]
        local chip_address = CHIP_DATA[chip.ID].CHIP_PICTURE_OFFSET
        local chip_palette_address = CHIP_DATA[chip.ID].CHIP_PICTURE_PALETTE_OFFSET
        list_of_chips[chip_idx].ARGB_PICTURE = CHIP_PICTURE.get_argb_2d_array_for_image_address(chip_address, chip_palette_address)

    end

end

function state_logic.get_printable_chip_name(chip)

    if chip == nil then
        return ""
    end

    if chip.ID == -1 then
        return ""
    end


    local string_with_special_chars = CHIP_NAME[chip.ID] .. " " .. CHIP_CODE_REVERSE[chip.CODE]

    return CHIP_NAME_UTILS.replace_special_chars(string_with_special_chars)

end

function state_logic.get_argb_icon(chip)

    if chip == nil then
        return nil
    end


    if chip.ID == -1 then
        return nil
    end

    local chip_address = CHIP_DATA[chip.ID].CHIP_ICON_OFFSET

    return CHIP_ICON.get_argb_2d_array_for_icon_address(chip_address)

end

function state_logic.update_folder_mega_giga_chip_counts()


    -- Upon chip replacement, recompute Mega/GigaChips
    gauntlet_data.current_number_of_giga_chips = 0
    gauntlet_data.current_number_of_mega_chips = 0



    for chip_idx = 1,#gauntlet_data.current_folder do

        

        if (CHIP_DATA[gauntlet_data.current_folder[chip_idx].ID].CHIP_RANKING % 4) == 1 then

            gauntlet_data.current_number_of_mega_chips = gauntlet_data.current_number_of_mega_chips + 1

        elseif (CHIP_DATA[gauntlet_data.current_folder[chip_idx].ID].CHIP_RANKING % 4) == 2 then

            gauntlet_data.current_number_of_giga_chips = gauntlet_data.current_number_of_giga_chips + 1

        end
        
    end

end

function state_logic.update_argb_chip_icons_in_folder()
    
    for chip_idx = 1,#gauntlet_data.current_folder do
        gauntlet_data.current_folder[chip_idx].ARGB_ICON = state_logic.get_argb_icon(gauntlet_data.current_folder[chip_idx])
    end
    

end


function state_logic.update_printable_chip_names_in_folder()

    for chip_idx = 1,#gauntlet_data.current_folder do
        gauntlet_data.current_folder[chip_idx].PRINT_NAME = state_logic.get_printable_chip_name(gauntlet_data.current_folder[chip_idx])
    end

end

function state_logic.update_buff_discriptions()

    -- This updates all buff descriptions for the current round.
    for buff_idx = 1,#state_logic.dropped_buffs do
        state_logic.dropped_buffs[buff_idx].DESCRIPTION = state_logic.dropped_buffs[buff_idx]:get_description(state_logic.current_round)
    end

end

function state_logic.undo_activated_buffs()
    
    if state_logic.number_of_activated_buffs == 0 then
        return
    end
    local buff_it = state_logic.number_of_activated_buffs

    for buff_it = state_logic.number_of_activated_buffs, 1, -1 do

        print("Deactivating ", buff_it)
        state_logic.activated_buffs[buff_it]:deactivate(buff_it)
    
    end
 
end

function state_logic.shuffle_folder()
    -- This shuffles the folder according to the currently chosen sorting mode

    -- Mark the highlighted chip so we can find it later

    if gauntlet_data.current_folder[state_logic.folder_chip_render_index] ~= nil then
        gauntlet_data.current_folder[state_logic.folder_chip_render_index].SPECIAL_SORT_MARK = 1
    end

    if gauntlet_data.folder_shuffle_state == 0 then
        -- Alphabetically
        table.sort(gauntlet_data.current_folder, function(a, b)
            return CHIP_NAME[a.ID] < CHIP_NAME[b.ID]
          end)

    elseif gauntlet_data.folder_shuffle_state == 1 then
        -- Code
        table.sort(gauntlet_data.current_folder, function(a, b)
            return a.CODE < b.CODE
          end)

    elseif gauntlet_data.folder_shuffle_state == 2 then
        -- ID
        table.sort(gauntlet_data.current_folder, function(a, b)
            return a.ID < b.ID
          end)

    elseif gauntlet_data.folder_shuffle_state == 3 then
        -- Damage
        table.sort(gauntlet_data.current_folder, function(a, b)
            return CHIP_DATA[a.ID].DAMAGE < CHIP_DATA[b.ID].DAMAGE 
          end)
    end

    if gauntlet_data.current_folder[state_logic.folder_chip_render_index] ~= nil then
        for k,v in pairs(gauntlet_data.current_folder) do
            if v.SPECIAL_SORT_MARK == 1 then
                state_logic.folder_chip_render_index = k
                v.SPECIAL_SORT_MARK = nil
            end
        end
    end

end

function state_logic.export_run_statistics()
    local file = io.open(state_logic.stats_file_name, "w")
    if file == nil then
        print("Could not save statistics, please create the \"stats\" folder inside the gauntlet folder!")
        return
    end
    local stats_json = json.encode(gauntlet_data.statistics_container)
    file:write(stats_json)
    file:flush()
    file:close()
end

function state_logic.initialize()

    event.unregisterbyname("on_enter_battle")
    event.unregisterbyname("on_battle_end")
    event.unregisterbyname("on_cust_screen_confirm")
    event.unregisterbyname("on_chip_use")
    --event.unregisterbyname("on_battle_phase_start")

    event.unregisterbyname("main_frame_loop")
    event.onframestart(state_logic.main_frame_loop, "main_frame_loop")
    --event.onframeend(state_logic.main_loop, "main_loop2")

    event.onmemoryexecute(state_logic.on_enter_battle, GENERIC_DEFS.BATTLE_START_ADDRESS + 4, "on_enter_battle")
    --event.onmemoryexecute(state_logic.on_battle_end, GENERIC_DEFS.END_OF_GAUNTLET_BATTLE_ADDRESS, "on_battle_end")
    event.onmemoryexecute(state_logic.on_cust_screen_confirm, GENERIC_DEFS.CUST_SCREEN_CONFIRM_ADDRESS + 2, "on_cust_screen_confirm")
    --event.onmemoryexecute(state_logic.on_chip_use, GENERIC_DEFS.CHIP_USE_ADDRESS + 2, "on_chip_use")
    --event.onmemoryexecute(state_logic.on_battle_phase_start, GENERIC_DEFS.BATTLE_PHASE_START_CHIP_IDS_ADDRESS + 2, "on_battle_phase_start")



    if gauntlet_data.statistics_container ~= nil then

        -- Just update it again, don't care if we possibly have duplicate entries.
        state_logic.update_battle_statistics()
        state_logic.export_run_statistics()

    end


    gauntlet_data.statistics_container = {}

    if gauntlet_data.fixed_random_seed == nil then
        math.randomseed(os.time())
        gauntlet_data.random_seed = math.random(2147483647)
    else
        gauntlet_data.random_seed = gauntlet_data.fixed_random_seed
    end

    print("Seed: " .. gauntlet_data.random_seed)
    math.randomseed(gauntlet_data.random_seed)

    -- Generate initial random values for in-battle rng (e.g. random reflect)
    -- This is so that the draft is not changed when damage is taken using these buffs.
    state_logic.in_battle_rng_values = {}
    for i = 1, 1000 do 
        state_logic.in_battle_rng_values[#state_logic.in_battle_rng_values + 1] = math.random()
    end
    state_logic.in_battle_rng_count = 0

    MusicLoader.generateRNGValues()
    --savestate.load(state_logic.initial_state)
    
    state_logic.stats_file_name = "stats/" .. os.date("%Y_%m_%d_%H_%M_%S") .. ".json"
    -- Undo all activated buffs
    state_logic.undo_activated_buffs()
    state_logic.number_of_activated_buffs = 0
    state_logic.activated_buffs = {}
    gauntlet_data.stage = 0
    gauntlet_data.mega_max_hp = 100
    state_logic.stats_previous_hp = gauntlet_data.mega_max_hp + GAUNTLET_DEFS.HP_INCREASE_PER_ROUND[1]
    state_logic.stats_lost_hp = 0
    gauntlet_data.hp_patch_required = 0
    gauntlet_data.folder_shuffle_state = 1
    gauntlet_data.mega_style = 0x00
    gauntlet_data.mega_AirShoes = 0
    gauntlet_data.mega_FastGauge = 0
    gauntlet_data.mega_UnderShirt = 0
    gauntlet_data.mega_SuperArmor = 0
    gauntlet_data.mega_AttackPlus = 0
    gauntlet_data.mega_ChargePlus = 0 -- this is capped at 5, but 50 is instant-charge...?
    gauntlet_data.mega_SpeedPlus = 0 -- this is capped at 6 (Level 7) ingame
    gauntlet_data.mega_FloatShoes = 0
    gauntlet_data.mega_BreakBuster = 0
    gauntlet_data.mega_BreakCharge = 0
    gauntlet_data.mega_DarkLicense = 0
    gauntlet_data.mega_Reflect = 0
    gauntlet_data.mega_WeaponLevelPlus = 1
    gauntlet_data.cust_style_number_of_chips = 0
    gauntlet_data.cust_screen_number_of_chips = 5
    state_logic.initial_chip_amount_flag = 0
    gauntlet_data.mega_chip_limit = GAUNTLET_DEFS.INITIAL_MEGA_CHIP_LIMIT
    gauntlet_data.giga_chip_limit = GAUNTLET_DEFS.INITIAL_GIGA_CHIP_LIMIT
    gauntlet_data.current_number_of_mega_chips = 0
    gauntlet_data.current_number_of_giga_chips = 0
    gauntlet_data.folder_view = 0
    gauntlet_data.chip_drop_method = CHIP_DROP_METHODS[1]
    gauntlet_data.chip_drop_method.activate()
    gauntlet_data.loadout_chosen = 0
    state_logic.selected_loadout_index = 2
    state_logic.dropped_chip = CHIP.new_chip_with_code(CHIP_ID.Cannon, CHIP_CODE.A)
    state_logic.dropped_chip.ID = -1
    state_logic.dropped_chip.PRINT_NAME = state_logic.get_printable_chip_name(state_logic.dropped_chip)
    state_logic.dropped_chip.ARGB_ICON = state_logic.get_argb_icon(state_logic.dropped_chip)
    state_logic.battle_data = {}
    state_logic.dropped_buffs = {}
    state_logic.dropped_buff_render_index = 2
    state_logic.current_round = 0
    state_logic.current_battle = 1
    state_logic.battle_pointer_index = 1
    state_logic.hp_patch_frame_counter = 0
    state_logic.battle_start_frame_counter = 0
    state_logic.selected_drop_method_index = 2
    gauntlet_data.mega_chip_limit_team = 0
    state_logic.reset_selected_chips()
    gauntlet_data.folder_draft_chip_list = {}
    state_logic.draft_selection_chips = {}
    gauntlet_data.folder_draft_chip_generator = {}
    gauntlet_data.skill_not_luck_active = 0
    gauntlet_data.skill_not_luck_bonus_per_battle = 0
    gauntlet_data.skill_not_luck_bonus_current = 0
    gauntlet_data.skill_not_luck_number_of_fights = 0
    gauntlet_data.collector_duplicate_damage_bonus = 0.0
    gauntlet_data.collector_active = 0
    gauntlet_data.top_tier_active = 0
    gauntlet_data.top_tier_chance = 0
    gauntlet_data.damage_reduction_additive = 0
    gauntlet_data.healing_increase_mult = 0
    gauntlet_data.damage_reflect_all_percent = 0
    gauntlet_data.damage_reflect_random_percent = 0
    gauntlet_data.enemies_hp_regen_per_frame = 0
    gauntlet_data.enemies_hp_regen_accum = 0
    gauntlet_data.illusion_of_choice_active = 0
    state_logic.battle_enter_lock = 0
    gauntlet_data.number_of_rewinds = 0
    state_logic.rewind_savestate = nil
    state_logic.main_loop_frame_count = 0
    state_logic.time_compression_savestates = {}
    gauntlet_data.number_of_time_compressions = 0
    gauntlet_data.total_frame_count = 0
    gauntlet_data.muramasa_damage_additive = 0
    gauntlet_data.muramasa_damage_multiplicative = 0
    gauntlet_data.masamune_damage_additive = 0
    gauntlet_data.masamune_damage_multiplicative = 0
    gauntlet_data.cust_damage_additive = 0
    gauntlet_data.cust_damage_multiplicative = 0
    gauntlet_data.reverse_cust_damage_additive = 0
    gauntlet_data.reverse_cust_damage_multiplicative = 0
    gauntlet_data.custgauge_per_frame_change = 0
    gauntlet_data.current_custgauge_value = 0
    gauntlet_data.custgauge_last_frames_storage = 0
    gauntlet_data.custgauge_per_enemy_count = {[0] = 0, [1] = 0, [2] = 0.0, [3] = 0, [4] = 0}
    gauntlet_data.damage_per_enemy_count_multiplicative = {[0] = 0, [1] = 0, [2] = 0, [3] = 0, [4] = 0}
    gauntlet_data.damage_per_enemy_count_additive = {[0] = 0, [1] = 0, [2] = 0, [3] = 0, [4] = 0}
    gauntlet_data.held_chips = nil
    gauntlet_data.battle_paused = 0
    gauntlet_data.rising_star_count = 0
    gauntlet_data.num_chips_in_battle = 0
    gauntlet_data.battle_phase = 0
    gauntlet_data.is_cust_screen = 0
    gauntlet_data.cust_screen_was_opened = 0

    gauntlet_data.next_boss = battle_data_generator.random_boss(GAUNTLET_DEFS.BOSS_BATTLE_INTERVAL)
    
    gauntlet_data.rarity_mods = {
        [1] = 0, -- Common
        [2] = 0, -- Rare
        [3] = 0, -- SuperRare
        [4] = 0, -- UltraRare
    }

    
    gauntlet_data.force_minibombs_lower_than_ultra_rare = 0

    gauntlet_data.snecko_eye_enabled = 0
    gauntlet_data.snecko_eye_number_of_codes = 8
    gauntlet_data.snecko_eye_randomize_asterisk = GAUNTLET_DEFS.SNECKO_RANDOMIZE_ASTERISK

    gauntlet_data.has_mega_been_hit = 0
    gauntlet_data.number_of_perfect_fights = 0
    gauntlet_data.last_hp = 0
    
    gauntlet_data.perfectionist_damage_bonus_mult = {
        CURRENT = 1.0,
        LIMIT = 1.0,
        BASE = 1.0,
        PERFECT_FIGHT_INCREASE = 0.0

    }

    gauntlet_data.perfectionist_damage_bonus_add = {
        CURRENT = 0,
        LIMIT = 0,
        BASE = 0,
        PERFECT_FIGHT_INCREASE = 0

    }

    gauntlet_data.battle_stages = {}

    gauntlet_data.mega_regen_after_battle_relative_to_max = 0

    state_logic.buff_render_offset = 0

    gauntlet_data.copy_paste_active_number_of_buffs = 0
    
    state_logic.CHIP_DATA_COPY = {}

    -- Store initial chip data for soft reset consistency
    if state_logic.INITIAL_CHIP_DATA == nil then
        state_logic.INITIAL_CHIP_DATA = {}
        for key, chip_data in pairs(CHIP_DATA) do
            state_logic.INITIAL_CHIP_DATA[key] = deepcopy(CHIP_DATA[key])
        end

    end

    -- Store INITIAL_CHIP_DATA to CHIP_DATA to reset temporary buffs.
    for key, chip_data in pairs(CHIP_DATA) do
        CHIP_DATA[key] = deepcopy(state_logic.INITIAL_CHIP_DATA[key])
    end

    
    -- Store CHIP_DATA to copy so temporary buffs work fine.
    for key, chip_data in pairs(CHIP_DATA) do
        state_logic.CHIP_DATA_COPY[key] = deepcopy(state_logic.INITIAL_CHIP_DATA[key])
    end

    
    BUFF_GENERATOR.initialize()
    state_logic.initialize_folder()
    state_logic.update_printable_chip_names_in_folder()
    state_logic.update_argb_chip_icons_in_folder()
    
    gauntlet_data.current_state = gauntlet_data.GAME_STATE.LOAD_INITIAL

    client.unpause()
    -- Upon start, initialize the current round:
    --state_logic.next_round()



end

-- This function checks for the button combination A-B-L-R to reset the script.
function state_logic.check_reset()

    if      input_handler.inputs_held["A"]
        and input_handler.inputs_held["B"]
        and input_handler.inputs_held["L"]
        and input_handler.inputs_held["R"] then

        print("Soft-Reset!")
        state_logic.initialize()



    end

end

function state_logic.randomize_snecko_folder_codes(folder)

    for chip_idx = 1,GENERIC_DEFS.NUMBER_OF_CHIPS_IN_FOLDER do

        if (gauntlet_data.snecko_eye_randomize_asterisk == 0 and folder[chip_idx].CODE == CHIP_CODE.Asterisk) then 
        else
            folder[chip_idx].CODE = math.random(CHIP_CODE.A, gauntlet_data.snecko_eye_number_of_codes)
        end
      
    end

end

function state_logic.update_battle_statistics()

    if state_logic.current_battle < 2 then
        return
    end

    gauntlet_data.current_hp = memory.read_u16_le(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_LOADING - 0x02000000, "EWRAM")

    -- Extract only relevant parts

    -- Activated buffs:

    activated_buffs = {}
    dropped_buffs = {}
    dropped_chips = {}
    picked_chip = {}
    current_folder = {}
    entities = {}
    buff_descriptions = {}

    for k, v in pairs(state_logic.activated_buffs) do
        activated_buffs[k] = v.NAME
    end

    for k, v in pairs(state_logic.dropped_buffs) do
        dropped_buffs[k] = v.NAME
    end

    for k, v in pairs(state_logic.dropped_chips) do
        dropped_chips[k] = v.PRINT_NAME
    end

    picked_chip = state_logic.dropped_chip.PRINT_NAME

    for k, v in pairs(gauntlet_data.current_folder) do
        current_folder[k] = v.PRINT_NAME
    end

    for k, v in pairs(state_logic.battle_data[state_logic.current_battle - 1].ENTITIES) do
        if k ~= 0 then
            entities[k] = v.ID
        end  
    end

    for k, v in pairs(state_logic.activated_buffs) do
        buff_descriptions[#buff_descriptions + 1] = v:get_brief_description()
    end


    
    gauntlet_data.statistics_container[#gauntlet_data.statistics_container + 1] = 
    {
        RANDOM_SEED = deepcopy(gauntlet_data.random_seed),
        CURRENT_HP = deepcopy(current_hp),
        ACTIVATED_BUFFS = deepcopy(activated_buffs),
        DROPPED_BUFFS = deepcopy(dropped_buffs),
        DROPPED_CHIPS = deepcopy(dropped_chips),
        PICKED_CHIP = deepcopy(picked_chip),
        CURRENT_FOLDER = deepcopy(current_folder),
        ENTITIES = deepcopy(entities),
        LOST_HP = deepcopy(state_logic.stats_lost_hp),
        REPLACED_CHIP = deepcopy(state_logic.replaced_chip),
        BATTLE_STAGE = deepcopy(gauntlet_data.battle_stages[state_logic.current_battle - 1]),
        ACTIVATED_BUFF_DESCRIPTIONS = deepcopy(buff_descriptions)
    }

    --print(gauntlet_data.statistics_container[#gauntlet_data.statistics_container])
    
    --print(json.encode(gauntlet_data.statistics_container[#gauntlet_data.statistics_container]))

end

function state_logic.patch_before_battle_start()

    -- Patch folder with all new stuff.
    -- state_logic.randomize_folder()

    -- TODO: check if this breaks anything. It shouldn't, as we always only copy after a buff is taken.
    state_logic.compute_temporary_chip_changes()

    -- Update statistics for this round

    state_logic.update_battle_statistics()

    if gauntlet_data.snecko_eye_enabled == 1 then

        -- Randomize folder codes
        state_logic.randomize_snecko_folder_codes(gauntlet_data.current_folder)

    end


    mmbn3_utils.patch_folder(gauntlet_data.current_folder, GENERIC_DEFS.FOLDER_START_ADDRESS_RAM, gauntlet_data)

    local new_battle_data = nil

    if state_logic.current_battle % GAUNTLET_DEFS.BOSS_BATTLE_INTERVAL == 0 then
        new_battle_data = battle_data_generator.random_from_battle(state_logic.current_battle, gauntlet_data.next_boss, gauntlet_data.battle_stages[state_logic.current_battle])
        gauntlet_data.next_boss = battle_data_generator.random_boss(state_logic.current_battle + GAUNTLET_DEFS.BOSS_BATTLE_INTERVAL)
    else
        new_battle_data = battle_data_generator.random_from_battle(state_logic.current_battle, nil, gauntlet_data.battle_stages[state_logic.current_battle])
    end
    

    -- This is used to determine drops.
    state_logic.battle_data[state_logic.current_battle] = new_battle_data


    mmbn3_utils.patch_battle(GAUNTLET_BATTLE_POINTERS[state_logic.battle_pointer_index], new_battle_data)
    mmbn3_utils.patch_entity_data(state_logic.battle_data[state_logic.current_battle].ENTITIES)
    state_logic.current_battle = state_logic.current_battle + 1
    state_logic.battle_pointer_index = state_logic.battle_pointer_index + 1
    state_logic.update_printable_chip_names_in_folder()
    state_logic.update_argb_chip_icons_in_folder()
    
    mmbn3_utils.set_stage(gauntlet_data.stage) 
    
    mmbn3_utils.writebyte(0x02005773, gauntlet_data.mega_AirShoes)
    mmbn3_utils.writebyte(0x02005788, gauntlet_data.mega_FastGauge)
    mmbn3_utils.writebyte(0x02005774, gauntlet_data.mega_UnderShirt)
    mmbn3_utils.writebyte(0x02005771, gauntlet_data.mega_SuperArmor)
    mmbn3_utils.writebyte(0x02005778, gauntlet_data.mega_AttackPlus)
    mmbn3_utils.writebyte(0x0200577A, gauntlet_data.mega_ChargePlus)
    mmbn3_utils.writebyte(0x02005779, gauntlet_data.mega_SpeedPlus)
    mmbn3_utils.writebyte(0x0200577D, gauntlet_data.mega_WeaponLevelPlus)
    mmbn3_utils.writebyte(0x02005772, gauntlet_data.mega_FloatShoes)
    mmbn3_utils.writebyte(0x02005776, gauntlet_data.mega_BreakBuster)
    mmbn3_utils.writebyte(0x0200577E, gauntlet_data.mega_BreakCharge)
    mmbn3_utils.writebyte(0x02005790, gauntlet_data.mega_DarkLicense)
    mmbn3_utils.writebyte(0x0200577F, gauntlet_data.mega_Reflect)


    -- Read current HP and apply regeneration

    if gauntlet_data.mega_regen_after_battle_relative_to_max ~= 0 then

        gauntlet_data.current_hp = memory.read_u16_le(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_LOADING - 0x02000000, "EWRAM")

        

        print("Regenerator current HP before regen " .. tostring(gauntlet_data.current_hp))
        
        gauntlet_data.current_hp = math.floor(gauntlet_data.current_hp + gauntlet_data.mega_max_hp * gauntlet_data.mega_regen_after_battle_relative_to_max)

        

        if gauntlet_data.current_hp > gauntlet_data.mega_max_hp then
            gauntlet_data.current_hp = gauntlet_data.mega_max_hp
        end

        print("Regenerator current HP after regen " .. tostring(gauntlet_data.current_hp))

        memory.write_u16_le(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_LOADING - 0x02000000, gauntlet_data.current_hp, "EWRAM")
    end

    memory.write_u16_le(GENERIC_DEFS.MEGA_MAX_HP_ADDRESS_DURING_LOADING - 0x02000000, gauntlet_data.mega_max_hp, "EWRAM")
    -- We need to wait a few frames to patch the in-battle HP of megaMan in RAM. Otherwise we would need a hook way before battle, which I don't want to find right now.
    if  gauntlet_data.hp_patch_required == 1 then
        memory.write_u16_le(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_LOADING - 0x02000000, gauntlet_data.mega_max_hp, "EWRAM") 
        memory.write_u16_le(GENERIC_DEFS.MEGA_MAX_HP_ADDRESS_DURING_LOADING - 0x02000000, gauntlet_data.mega_max_hp, "EWRAM")
        gauntlet_data.hp_patch_required = 0
        
    end

   

    

    mmbn3_utils.change_megaMan_style(gauntlet_data.mega_style)

    mmbn3_utils.change_number_of_cust_screen_chips(gauntlet_data.cust_style_number_of_chips + gauntlet_data.cust_screen_number_of_chips)  
    state_logic.export_run_statistics()



    state_logic.rewind_savestate = memorysavestate.savecorestate()

    state_logic.main_loop_frame_count = 0


end


function state_logic.folder_view_switch_and_sort()

    if input_handler.inputs_pressed["Select"] == true then
        if gauntlet_data.folder_view == 1 then
            gauntlet_data.folder_view = 0
        else
            gauntlet_data.folder_view = 1
        end
        state_logic.shuffle_folder()
        state_logic.should_redraw = 1
    end

    if input_handler.inputs_pressed["L"] == true or input_handler.inputs_pressed["R"] == true then

        if gauntlet_data.folder_view == 2 then
            gauntlet_data.folder_view = 0
        else
            gauntlet_data.folder_view = 2
        end

        state_logic.shuffle_folder()
        state_logic.should_redraw = 1
    end


    if input_handler.inputs_pressed["Start"] == true and gauntlet_data.folder_view == 1 then
        gauntlet_data.folder_shuffle_state = (gauntlet_data.folder_shuffle_state + 1) % 4
        state_logic.shuffle_folder()
        
        state_logic.should_redraw = 1
    end

end


function state_logic.damage_taken()

    
    gauntlet_data.has_mega_been_hit = 1
    gauntlet_data.number_of_perfect_fights = 0

end

function state_logic.illusion_of_choice_randomize_selected_chip()

    local can_replace = false

    while can_replace == false do
        
        state_logic.folder_chip_render_index = math.random(1, #gauntlet_data.current_folder)

        if state_logic.dropped_chip.ID == -1 then
            print("Dropped chip ID == -1")
            return
        end

        local dropped_chip_data = CHIP_DATA[state_logic.dropped_chip.ID]

        if dropped_chip_data == nil then
            print("Dropped chip data == nil")
            return
        end

        local is_dropped_chip_mega = (dropped_chip_data.CHIP_RANKING % 4) == 1
        local is_dropped_chip_giga = (dropped_chip_data.CHIP_RANKING % 4) == 2
        local folder_chip_data = CHIP_DATA[gauntlet_data.current_folder[state_logic.folder_chip_render_index].ID]
        local is_folder_chip_mega = (folder_chip_data.CHIP_RANKING % 4) == 1
        local is_folder_chip_giga = (folder_chip_data.CHIP_RANKING % 4) == 2

        local replaces_mega_chip = is_folder_chip_mega and is_dropped_chip_mega

        local replaces_giga_chip = is_folder_chip_giga and is_dropped_chip_giga

        if (((dropped_chip_data.CHIP_RANKING % 4) == 1 and gauntlet_data.current_number_of_mega_chips >= gauntlet_data.mega_chip_limit + gauntlet_data.mega_chip_limit_team) 
            or ((dropped_chip_data.CHIP_RANKING % 4) == 2 and gauntlet_data.current_number_of_giga_chips >= gauntlet_data.giga_chip_limit))
            and replaces_mega_chip == false and replaces_giga_chip == false
            then
            -- We do nothing if we can't pick due to Mega/GigaChip limits. We check for replacement of Mega/Giga chips.
            can_replace = false
            --print("Can not replace: " .. tostring(gauntlet_data.current_folder[state_logic.folder_chip_render_index].NAME))
        else       
            can_replace = true
            --print("Can replace: " .. tostring(gauntlet_data.current_folder[state_logic.folder_chip_render_index].NAME))
        end

    end
end

function state_logic.check_buff_render_offset()

    

    if #state_logic.activated_buffs < 9 or gauntlet_data.folder_view ~= 2 then
        return
    end

    if input_handler.inputs_pressed["Up"] == true then

        
        state_logic.buff_render_offset = state_logic.buff_render_offset - 1

        if state_logic.buff_render_offset < 0 then
            state_logic.buff_render_offset = #state_logic.activated_buffs - 8
        end

        if state_logic.buff_render_offset > #state_logic.activated_buffs - 8 then
            state_logic.buff_render_offset = 0
        end
        state_logic.should_redraw = 1
        --print("UP - BUFF RENDER OFFSET: " .. state_logic.buff_render_offset)
    end


    if input_handler.inputs_pressed["Down"] == true then

        state_logic.buff_render_offset = state_logic.buff_render_offset + 1

        if state_logic.buff_render_offset < 0 then
            state_logic.buff_render_offset = #state_logic.activated_buffs - 8
        end

        if state_logic.buff_render_offset > #state_logic.activated_buffs - 8 then
            state_logic.buff_render_offset = 0
        end
        state_logic.should_redraw = 1
        --print("DOWN - BUFF RENDER OFFSET: " .. state_logic.buff_render_offset)

    end

end

function state_logic.on_exit()
    print ("Exiting gauntlet!")
    state_logic.export_run_statistics()
end


function state_logic.on_mega_death()
    if gauntlet_data.number_of_time_compressions > 0 and state_logic.main_loop_frame_count > gauntlet_data.time_compression_delay then
        state_logic.hp_loaded = 0
        state_logic.damage_taken()
        gauntlet_data.number_of_time_compressions = gauntlet_data.number_of_time_compressions - 1
        memorysavestate.loadcorestate(state_logic.time_compression_savestates[((state_logic.main_loop_frame_count + 1) % gauntlet_data.time_compression_delay) + 1])
        print("Time compression saved the death!")
        return
    end


    if gauntlet_data.number_of_rewinds > 0 and state_logic.rewind_savestate ~= nil then
        state_logic.hp_loaded = 0
        gauntlet_data.battle_phase = 0
        gauntlet_data.is_cust_screen = 0
        gauntlet_data.num_chips_in_battle = 0
        gauntlet_data.cust_screen_was_opened = 0
        gauntlet_data.number_of_rewinds = gauntlet_data.number_of_rewinds - 1
        memorysavestate.loadcorestate(state_logic.rewind_savestate)
        print("Rewind!")
        return
    end

    print("Reset in GAME_STATE.RUNNING, number_of_virus_entities = " .. gauntlet_data.number_of_entities)
    print("MEGA_CURRENT_HP_ADDRESS [NUM_ENTITIES] " .. memory.read_u16_le(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_BATTLE[gauntlet_data.number_of_entities] - 0x02000000, "EWRAM"))
    print("MEGA_CURRENT_HP_ADDRESS [1] " .. memory.read_u16_le(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_BATTLE[1] - 0x02000000, "EWRAM"))
    print("MEGA_CURRENT_HP_ADDRESS [2] " .. memory.read_u16_le(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_BATTLE[2] - 0x02000000, "EWRAM"))
    print("MEGA_CURRENT_HP_ADDRESS [3] " .. memory.read_u16_le(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_BATTLE[3] - 0x02000000, "EWRAM"))
    print("MEGA_CURRENT_HP_ADDRESS [4] " .. memory.read_u16_le(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_BATTLE[4] - 0x02000000, "EWRAM"))
    state_logic.initialize()
end


function state_logic.set_cust_gauge_value(value)

    memory.writebyte(GENERIC_DEFS.CUST_GAUGE_VALUE_ADDRESS - 0x02000000, value, "EWRAM")

end

function state_logic.damage_random_enemy(damage)

    -- Compute a random enemy, make sure to use a different rng here
    local rng_val = state_logic.in_battle_rng_values[(state_logic.in_battle_rng_count + 1)]
    state_logic.in_battle_rng_count = state_logic.in_battle_rng_count + 1
    if state_logic.in_battle_rng_count > #state_logic.in_battle_rng_values then
        state_logic.in_battle_rng_count = 0
    end
    local enemy_addresses = GENERIC_DEFS.ENEMY_CURRENT_HP_ADDRESS_DURING_BATTLE[gauntlet_data.number_of_entities]

    local enemy_hp_values = {}
    local enemy_ewram_addresses = {}

    for key, address in pairs(enemy_addresses) do
        local ewram_address = address - 0x02000000
        local enemy_hp_value = memory.read_u16_le(ewram_address, "EWRAM")
        if enemy_hp_value ~= 0 then
            enemy_hp_values[#enemy_hp_values + 1] = enemy_hp_value
            enemy_ewram_addresses[#enemy_ewram_addresses + 1] = ewram_address
        end
    end

    -- Choose a random one
    local chosen_rng_index = math.floor((rng_val * (#enemy_hp_values))) + 1.0
    if chosen_rng_index == 0 then
        chosen_rng_index = 1
    end

    local chosen_ewram_address = enemy_ewram_addresses[chosen_rng_index]

    

    local new_enemy_hp_value = enemy_hp_values[chosen_rng_index] - damage

    if new_enemy_hp_value < 0 then
        new_enemy_hp_value = 0
    end

    -- Write back new HP
    memory.write_u16_le(chosen_ewram_address, new_enemy_hp_value, "EWRAM")

end


function state_logic.damage_all_enemies(damage)

    local enemy_addresses = GENERIC_DEFS.ENEMY_CURRENT_HP_ADDRESS_DURING_BATTLE[gauntlet_data.number_of_entities]

    for key, address in pairs(enemy_addresses) do
        local ewram_address = address - 0x02000000
        local enemy_hp_value = memory.read_u16_le(ewram_address, "EWRAM")
        if enemy_hp_value ~= 0 then
            local new_enemy_hp_value = enemy_hp_value - damage

            if new_enemy_hp_value < 0 then
                new_enemy_hp_value = 0
            end

            -- Write back new HP
            memory.write_u16_le(ewram_address, new_enemy_hp_value, "EWRAM")

        end
    end
end

function state_logic.on_mega_damage_taken()
    --print("Damage taken! (Previous HP: " .. tostring(gauntlet_data.last_hp) .. ", Current HP: " .. tostring(gauntlet_data.current_hp) .. ", Max HP: " .. tostring(gauntlet_data.mega_max_hp) .. ")")
    state_logic.damage_taken()


    if gauntlet_data.number_of_time_compressions > 0 and state_logic.main_loop_frame_count > gauntlet_data.time_compression_delay then
        state_logic.hp_loaded = 0
        gauntlet_data.number_of_time_compressions = gauntlet_data.number_of_time_compressions - 1
        memorysavestate.loadcorestate(state_logic.time_compression_savestates[((state_logic.main_loop_frame_count + 1) % gauntlet_data.time_compression_delay) + 1])
        --print("Time compression saved the damage!")
        return
    end

    local damage_taken = gauntlet_data.last_hp - gauntlet_data.current_hp

    if gauntlet_data.damage_reflect_random_percent ~= 0 then
        state_logic.damage_random_enemy(damage_taken * gauntlet_data.damage_reflect_random_percent)
    end

    if gauntlet_data.damage_reflect_all_percent ~= 0 then
        state_logic.damage_all_enemies(damage_taken * gauntlet_data.damage_reflect_all_percent)
    end


    -- Check for additive reflective healing
    gauntlet_data.current_hp = gauntlet_data.current_hp + math.floor(gauntlet_data.damage_reduction_additive * (gauntlet_data.healing_increase_mult + 1.0))
            
    if gauntlet_data.current_hp > gauntlet_data.last_hp then
        gauntlet_data.current_hp = gauntlet_data.last_hp
    end

    memory.write_u16_le(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_BATTLE[gauntlet_data.number_of_entities] - 0x02000000, gauntlet_data.current_hp, "EWRAM")



end

function state_logic.on_mega_heal()

    -- Compute healing difference
    local heal_diff = gauntlet_data.current_hp - gauntlet_data.last_hp
    gauntlet_data.current_hp = gauntlet_data.current_hp + math.floor(heal_diff * (gauntlet_data.healing_increase_mult))

    if gauntlet_data.current_hp > gauntlet_data.mega_max_hp then
        gauntlet_data.current_hp = gauntlet_data.mega_max_hp
    end

    memory.write_u16_le(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_BATTLE[gauntlet_data.number_of_entities] - 0x02000000, gauntlet_data.current_hp, "EWRAM")


end


function state_logic.on_mega_hp_change()

    if gauntlet_data.current_hp == nil or gauntlet_data.last_hp == nil or gauntlet_data.current_hp == 0 or gauntlet_data.last_hp == 0 then
        return
    end

    if gauntlet_data.current_hp > gauntlet_data.last_hp then
        state_logic.on_mega_heal()
    elseif gauntlet_data.current_hp < gauntlet_data.last_hp then
        state_logic.on_mega_damage_taken()
    end

end

function state_logic.enemy_hp_regen()
    gauntlet_data.enemies_hp_regen_accum = gauntlet_data.enemies_hp_regen_accum + gauntlet_data.enemies_hp_regen_per_frame

    if gauntlet_data.enemies_hp_regen_accum > 1 then

        gauntlet_data.enemies_hp_regen_accum = 0
        
    
        local enemy_addresses = GENERIC_DEFS.ENEMY_CURRENT_HP_ADDRESS_DURING_BATTLE[gauntlet_data.number_of_entities]

        for key, address in pairs(enemy_addresses) do
            local ewram_address = address - 0x02000000
            local enemy_hp_value = memory.read_u16_le(ewram_address, "EWRAM")
            local enemy_max_hp_value = memory.read_u16_le(ewram_address + 2, "EWRAM")
            if enemy_hp_value ~= 0 then

                local new_enemy_hp_value = enemy_hp_value + 1

                if new_enemy_hp_value > enemy_max_hp_value then
                    new_enemy_hp_value = enemy_max_hp_value
                end

                -- Write back new HP
                memory.write_u16_le(ewram_address, new_enemy_hp_value, "EWRAM")

            end
        end

    end

end

function state_logic.in_battle_chip_effects()

    if gauntlet_data.held_chips == nil then
        return
    end

    if #gauntlet_data.held_chips == 0 then
        return
    end

    local additive_damage_increase = 0
    local multiplicative_damage_increase = 0

    -- Muramasa
    additive_damage_increase = additive_damage_increase + math.floor(gauntlet_data.muramasa_damage_additive * (1 - (gauntlet_data.current_hp / gauntlet_data.mega_max_hp)))
    multiplicative_damage_increase = multiplicative_damage_increase + (gauntlet_data.muramasa_damage_multiplicative * (1 - (gauntlet_data.current_hp / gauntlet_data.mega_max_hp)))
    --print("Add1: " .. tostring(additive_damage_increase))
    -- Masamune
    additive_damage_increase = additive_damage_increase + math.floor(gauntlet_data.masamune_damage_additive * ((gauntlet_data.current_hp / gauntlet_data.mega_max_hp)))
    multiplicative_damage_increase = multiplicative_damage_increase + (gauntlet_data.masamune_damage_multiplicative * ((gauntlet_data.current_hp / gauntlet_data.mega_max_hp)))
    --print("Add2: " .. tostring(additive_damage_increase))
    -- OverCust (Works similar to CustSwrd)
    local cust_value = gauntlet_data.current_custgauge_value
    if cust_value == GENERIC_DEFS.MAX_CUST_GAUGE_VALUE then
        cust_value = 0
    end

    --print("Current Cust val: " .. tostring(cust_value))
    --print("Max Cust val: " .. tostring(GENERIC_DEFS.MAX_CUST_GAUGE_VALUE))
    --print("First comp: " .. tostring((cust_value / GENERIC_DEFS.MAX_CUST_GAUGE_VALUE)))
    --print("Second comp: " .. tostring(gauntlet_data.cust_damage_additive * ((cust_value / GENERIC_DEFS.MAX_CUST_GAUGE_VALUE))))
    --print("Third comp: " .. tostring(math.floor(gauntlet_data.cust_damage_additive * ((cust_value / GENERIC_DEFS.MAX_CUST_GAUGE_VALUE)))))


    additive_damage_increase = additive_damage_increase + math.floor(gauntlet_data.cust_damage_additive * ((cust_value / (GENERIC_DEFS.MAX_CUST_GAUGE_VALUE - 1))))
    multiplicative_damage_increase = multiplicative_damage_increase + (gauntlet_data.cust_damage_multiplicative * ((cust_value / (GENERIC_DEFS.MAX_CUST_GAUGE_VALUE - 1))))
    --print("Add3: " .. tostring(additive_damage_increase))
    cust_value = gauntlet_data.current_custgauge_value

    -- AntiCust (Reverse CustSwrd)
    additive_damage_increase = additive_damage_increase + math.floor(gauntlet_data.reverse_cust_damage_additive * (1 - (cust_value / (GENERIC_DEFS.MAX_CUST_GAUGE_VALUE))))
    multiplicative_damage_increase = multiplicative_damage_increase + (gauntlet_data.reverse_cust_damage_multiplicative * (1 - (cust_value / (GENERIC_DEFS.MAX_CUST_GAUGE_VALUE))))
    --print("Add4: " .. tostring(additive_damage_increase))
    -- Duelist / Damage based on number of enemies
    additive_damage_increase = additive_damage_increase + math.floor(gauntlet_data.damage_per_enemy_count_additive[gauntlet_data.number_enemies_alive])
    multiplicative_damage_increase = multiplicative_damage_increase + gauntlet_data.damage_per_enemy_count_multiplicative[gauntlet_data.number_enemies_alive]

    --print("Add5: " .. tostring(additive_damage_increase))
    --print("Mul: " .. tostring(multiplicative_damage_increase))

    -- Now we can patch the current and next chip based on the held chip index
    local held_chip_damage_addr =  GENERIC_DEFS.IN_BATTLE_HELD_CHIP_DAMAGES_ADDRESS - 0x02000000

    local chip_idx = gauntlet_data.current_battle_chip_index

    for chip_idx = gauntlet_data.current_battle_chip_index, (gauntlet_data.current_battle_chip_index + 1) do
        local chip = gauntlet_data.held_chips[chip_idx]

        if (chip ~= nil) then

            local current_chip_damage = chip.DAMAGE
            if (current_chip_damage ~= 0) then

                -- NOTE: this might need changing because of balancing reasons, as this is the ideal order
                local new_chip_damage = (current_chip_damage + additive_damage_increase) * (1.0 + multiplicative_damage_increase)

                if new_chip_damage < 0 then
                    new_chip_damage = 0
                end


                -- Patch new chip damage
                --if new_chip_damage ~= current_chip_damage then
                memory.write_u16_le(held_chip_damage_addr + ((chip_idx - 1) * 2), new_chip_damage, "EWRAM")
                --end

            end

        end

    end

end

function state_logic.get_number_of_alive_enemies()

    local enemy_addresses = GENERIC_DEFS.ENEMY_CURRENT_HP_ADDRESS_DURING_BATTLE[gauntlet_data.number_of_entities]

    local enemy_hp_values = {}
    local enemy_ewram_addresses = {}


    gauntlet_data.number_enemies_alive = 0

    for key, address in pairs(enemy_addresses) do
        local ewram_address = address - 0x02000000
        local enemy_hp_value = memory.read_u16_le(ewram_address, "EWRAM")
        if enemy_hp_value ~= 0 then
            gauntlet_data.number_enemies_alive = gauntlet_data.number_enemies_alive + 1
        end
    end
end

function state_logic.get_current_custgauge_value()

    gauntlet_data.current_custgauge_value = memory.readbyte(GENERIC_DEFS.CUST_GAUGE_VALUE_ADDRESS - 0x02000000, "EWRAM")

end

function state_logic.in_battle_custgauge_effects()

    if gauntlet_data.battle_paused ~= 0 then
        return
    end

    local old_custgauge_value = gauntlet_data.current_custgauge_value

    -- Get new value
    state_logic.get_current_custgauge_value()

    -- Don't do anything when we had zero (the first tick)
    if gauntlet_data.current_custgauge_value == 0 then
        return
    end

    -- Don't jitter around on full cust gauge
    if old_custgauge_value >= GENERIC_DEFS.MAX_CUST_GAUGE_VALUE then
        return
    end

    gauntlet_data.custgauge_last_frames_storage = gauntlet_data.custgauge_last_frames_storage + gauntlet_data.custgauge_per_frame_change
    gauntlet_data.custgauge_last_frames_storage = gauntlet_data.custgauge_last_frames_storage + gauntlet_data.custgauge_per_enemy_count[gauntlet_data.number_enemies_alive]
    local integer_custgauge_part = 0
    
    if gauntlet_data.custgauge_last_frames_storage >= 0 then
        integer_custgauge_part = math.floor(gauntlet_data.custgauge_last_frames_storage)
    else
        integer_custgauge_part = math.ceil(gauntlet_data.custgauge_last_frames_storage)
    end

    

    -- If we can't add anything this frame, return
    if math.abs(integer_custgauge_part) < 1 then
        return
    end


    gauntlet_data.custgauge_last_frames_storage = gauntlet_data.custgauge_last_frames_storage - integer_custgauge_part
    


    gauntlet_data.current_custgauge_value = gauntlet_data.current_custgauge_value + integer_custgauge_part

    --if gauntlet_data.current_custgauge_value <= old_custgauge_value then
        -- We can not get a "locked" or frozen custgauge.
    --    gauntlet_data.current_custgauge_value = old_custgauge_value + 1
    --end

    if gauntlet_data.current_custgauge_value > GENERIC_DEFS.MAX_CUST_GAUGE_VALUE then
        gauntlet_data.current_custgauge_value = GENERIC_DEFS.MAX_CUST_GAUGE_VALUE
    end

    if gauntlet_data.current_custgauge_value ~= old_custgauge_value then
        memory.writebyte(GENERIC_DEFS.CUST_GAUGE_VALUE_ADDRESS - 0x02000000, gauntlet_data.current_custgauge_value, "EWRAM")
    end

end

function state_logic.check_pause_screen()

    gauntlet_data.battle_paused = memory.readbyte(GENERIC_DEFS.IN_BATTLE_PAUSE_ADDRESS - 0x02000000, "EWRAM")
    gauntlet_data.battle_paused = gauntlet_data.battle_paused + memory.readbyte(GENERIC_DEFS.IN_BATTLE_TIMEFREEZE_ADDRESS - 0x02000000, "EWRAM")
    gauntlet_data.battle_paused = gauntlet_data.battle_paused + memory.readbyte(GENERIC_DEFS.IN_BATTLE_TIMEFREEZE_ADDRESS2 - 0x02000000, "EWRAM")

end

function state_logic.check_in_battle_effects()

    state_logic.get_number_of_alive_enemies()

    state_logic.check_pause_screen()
    

    state_logic.in_battle_custgauge_effects()

    

    state_logic.in_battle_chip_effects()

    


end


function state_logic.on_cust_screen_open()
    gauntlet_data.num_chips_in_battle = 0
    gauntlet_data.battle_phase = 0
    gauntlet_data.cust_screen_was_opened = 1
    --print("Cust screen opened")
end

function state_logic.on_cust_screen_closed()
    --gauntlet_data.num_chips_in_battle = memory.readbyte(GENERIC_DEFS.IN_BATTLE_NUMBER_OF_CHIPS_ADDRESS[gauntlet_data.number_of_entities] - 0x02000000, "EWRAM")
    --print("Cust screen closed")
end



function state_logic.check_frame_events()

    -- Here, we check for events that can easily be polled every frame to save expensive event.onmemoryexecute hooks
    -- Check if we are in cust screen

    local is_cust_screen = memory.readbyte(GENERIC_DEFS.IN_BATTLE_IS_CUSTSCREEN_OPEN - 0x02000000, "EWRAM")

    if is_cust_screen == 1 and gauntlet_data.is_cust_screen == 0 then
        state_logic.on_cust_screen_open()
        gauntlet_data.is_cust_screen = is_cust_screen
    end

    if is_cust_screen == 0 and gauntlet_data.is_cust_screen == 1 then
        state_logic.on_cust_screen_closed()
        gauntlet_data.is_cust_screen = is_cust_screen
    end

    

    
    -- Check difference to gauntlet_data.num_chips
    -- TODO: refactor into "on_chip_use parts"
    if gauntlet_data.is_cust_screen == 0 and gauntlet_data.cust_screen_was_opened ~= 0 then 
        -- Check for "on_chip_use"
        local num_chips = memory.readbyte(GENERIC_DEFS.IN_BATTLE_NUMBER_OF_CHIPS_ADDRESS[gauntlet_data.number_of_entities] - 0x02000000, "EWRAM")

        if gauntlet_data.battle_phase == 0 and num_chips ~= 0 then
            state_logic.on_battle_phase_start()
            gauntlet_data.num_chips_in_battle = num_chips
        else
            if num_chips < gauntlet_data.num_chips_in_battle then

                state_logic.on_chip_use()
                -- TODO: what happens if we e.g. have 3 chips, enter the cust screen and then select 0 ?
                --       we need a variable that tells us if we are in the cust screen.
                --       00C0C9 is a flag that's 1 if the cust screen gfx are shown
                --       34420 or 34432 are probably good candidates, they togggle immediately after pressing L/R
                --       we *might* be able to use them for detecting cust confirm
                --       00A5C8, 00A5D8, 00A5E8 seem to be possible candidates for detecting battle phase start
                --       otherwise we can detect battle phase start by checking when 006CAC goes from 1 -> 0
                gauntlet_data.num_chips_in_battle = num_chips
            end
        end

        
    end

    

    

end

function state_logic.main_frame_loop()

    -- This loop runs at the GBA framerate. 
    --print ("Current state: " .. gauntlet_data.current_state)
    if gauntlet_data.current_state == gauntlet_data.GAME_STATE.RUNNING then

        gauntlet_data.number_of_entities = (state_logic.battle_data[state_logic.current_battle - 1].NUM_ENTITIES)

        state_logic.check_frame_events()

        if gauntlet_data.number_of_time_compressions > 0 and gauntlet_data.battle_phase ~= 0 then
            -- We compute the savestate only every x frames to save computing power
            if (state_logic.main_loop_frame_count % gauntlet_data.time_compression_frame_interval) == 0 then
                state_logic.time_compression_savestates[(state_logic.main_loop_frame_count % gauntlet_data.time_compression_delay) + 1] = memorysavestate.savecorestate()
            else
                state_logic.time_compression_savestates[(state_logic.main_loop_frame_count % gauntlet_data.time_compression_delay) + 1] = state_logic.time_compression_savestates[((state_logic.main_loop_frame_count - 1) % gauntlet_data.time_compression_delay) + 1]
            end
        end
        
        -- Check if mega gets hit for certain buffs
        
        
        --print("Number of entities in battle: " .. tostring(gauntlet_data.number_of_entities))
        
        gauntlet_data.current_hp = memory.read_u16_le(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_BATTLE[gauntlet_data.number_of_entities] - 0x02000000, "EWRAM")

        if gauntlet_data.current_hp ~= 0 and gauntlet_data.battle_phase ~= 0 then
            state_logic.hp_loaded = 1
        end
        
        -- If we died - reset
        if gauntlet_data.current_hp == 0 and state_logic.hp_loaded == 1 then
            state_logic.on_mega_death()
            return
        end


        if gauntlet_data.current_hp ~= gauntlet_data.last_hp and gauntlet_data.current_hp ~= 0 and gauntlet_data.last_hp ~= nil and gauntlet_data.last_hp ~= 0 then
            state_logic.on_mega_hp_change()
        end

       

       
        -- Set last HP for next frame
        if gauntlet_data.current_hp ~= nil and gauntlet_data.current_hp ~= 0 then
            gauntlet_data.last_hp = gauntlet_data.current_hp
        end

        state_logic.check_in_battle_effects()

        -- Check enemy HP regen
        if gauntlet_data.enemies_hp_regen_per_frame ~= 0 and gauntlet_data.battle_paused ~= 0 then
            state_logic.enemy_hp_regen()
        end



        state_logic.main_loop_frame_count = state_logic.main_loop_frame_count + 1

    end

    if MusicLoader.LoadBlock() == 1 then
        state_logic.should_redraw = 1
    end
end

function state_logic.main_loop()
    gauntlet_data.total_frame_count = gauntlet_data.total_frame_count + 1
    if DEBUG == 1 then
        print ("DEBUG: STATE: ", gauntlet_data.current_state)
    end
    input_handler.handle_inputs()


    state_logic.check_reset()

    --state_logic.main_frame_loop()
    

   
    if gauntlet_data.current_state == gauntlet_data.GAME_STATE.TRANSITION_TO_CHIP_SELECT then
        -- We pause here and make a savestate.
        --print("Transition to chip select.")
        state_logic.gui_change_savestate = memorysavestate.savecorestate()
        state_logic.reset_selected_chips()
        if state_logic.battle_data[state_logic.current_battle - 1] == nil then
            -- We didn't finish a battle yet, therefore no chip.

            gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_CHIP_REPLACE
            --print(state_logic.dropped_chip)
        else

            -- Drop chips!
            -- TODO: actually use chips from a droptable from viruses.

            state_logic.determine_drops(GAUNTLET_DEFS.NUMBER_OF_DROPPED_CHIPS)

            for idx = 1,#state_logic.dropped_chips do
                state_logic.dropped_chips[idx].PRINT_NAME = state_logic.get_printable_chip_name(state_logic.dropped_chips[idx])
                --print(bizstring.hex(state_logic.dropped_chips[idx].ID))
                --print(state_logic.dropped_chips[idx].PRINT_NAME)
            end

            
            
            gauntlet_data.current_state = gauntlet_data.GAME_STATE.CHIP_SELECT
            

        end
        client.pause()
        state_logic.should_redraw = 1
        state_logic.dropped_buff_render_index = 2
        
        -- Before we display chips, compute temporary damage bonuses.
        -- This is also the point where we should take our copy of our chip data (taken directly before the battle starts) and overwrite it.
        state_logic.compute_temporary_chip_changes(gauntlet_data.current_folder)
        

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.CHIP_SELECT then
        
        state_logic.folder_view_switch_and_sort()

        state_logic.check_buff_render_offset()

        if gauntlet_data.folder_view == 0 then 

            if input_handler.inputs_pressed["Left"] == true then
                state_logic.dropped_chip_render_index = (state_logic.dropped_chip_render_index - 1) % (#state_logic.dropped_chips)
                if state_logic.dropped_chip_render_index == 0 then
                    state_logic.dropped_chip_render_index = (#state_logic.dropped_chips)
                end
                state_logic.should_redraw = 1
            end

            if input_handler.inputs_pressed["Right"] == true then
                state_logic.dropped_chip_render_index = (state_logic.dropped_chip_render_index + 1) % (#state_logic.dropped_chips + 1)
            
                if state_logic.dropped_chip_render_index == 0 then
                    state_logic.dropped_chip_render_index = 1
                end
                state_logic.should_redraw = 1
            end

            if input_handler.inputs_pressed["A"] == true then

                --print("Selected a Chip!")
                
                state_logic.dropped_chip = state_logic.dropped_chips[state_logic.dropped_chip_render_index]


                state_logic.dropped_chip.PRINT_NAME = state_logic.get_printable_chip_name(state_logic.dropped_chip)
                state_logic.dropped_chip.ARGB_ICON = state_logic.get_argb_icon(state_logic.dropped_chip)
                gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_CHIP_REPLACE
                gauntlet_data.folder_view = 0
                state_logic.should_redraw = 1
            end

        end
        

        if state_logic.should_redraw == 1 then

            
            if gauntlet_data.folder_view == 0 then
                gui_rendering.render_chip_selection(state_logic.dropped_chips, state_logic.dropped_chip_render_index)
            elseif gauntlet_data.folder_view == 1 then
                gui_rendering.render_folder(gauntlet_data.current_folder, nil, nil, gauntlet_data, MusicLoader.FinishedLoading)
            elseif gauntlet_data.folder_view == 2 then
                gui_rendering.render_buffs(state_logic.activated_buffs, MusicLoader.FinishedLoading, state_logic.buff_render_offset)
            end


            
            gui.DrawFinish()
            memorysavestate.loadcorestate(state_logic.gui_change_savestate)
            state_logic.should_redraw = 0
        end



        

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.TRANSITION_TO_CHIP_REPLACE then
        state_logic.gui_change_savestate = memorysavestate.savecorestate()
        memorysavestate.loadcorestate(state_logic.gui_change_savestate)
        --print(state_logic.dropped_chip)
        --print("Transition to chip replace.")
        if gauntlet_data.illusion_of_choice_active == 1 then
            state_logic.illusion_of_choice_randomize_selected_chip()
        end
        

        state_logic.shuffle_folder()
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.CHIP_REPLACE
        state_logic.should_redraw = 1

        -- TODO: special case when no chip has dropped yet for gauntlet_data.illusion_of_choice_active
        -- TODO: keep cursor when sorting

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.CHIP_REPLACE then
        --print("IN CHIP_REPLACE")
        -- Render folder, respond to inputs for selected chip. Patch folder for selected chip, then unpause.
        --print(gauntlet_data.current_state)
        -- We render 15 x 2 chips.
        
        local num_chips_per_col = 15
        local num_chips_per_folder = 30

        

        if input_handler.inputs_pressed["L"] == true or input_handler.inputs_pressed["R"] == true then

            if gauntlet_data.folder_view == 2 then
                gauntlet_data.folder_view = 0
            else
                gauntlet_data.folder_view = 2
            end
    
            state_logic.shuffle_folder()
            state_logic.should_redraw = 1
        end


        if gauntlet_data.folder_view == 0 or gauntlet_data.folder_view == 1 then

            
            if input_handler.inputs_pressed["Start"] == true then
                -- Shuffle folder according to Alpha/Code/ID/Attack
                gauntlet_data.folder_shuffle_state = (gauntlet_data.folder_shuffle_state + 1) % 4
                state_logic.shuffle_folder()
                
                state_logic.should_redraw = 1
            end

            if gauntlet_data.illusion_of_choice_active == 0 then
                --print (input_handler.inputs_pressed["A"])
                if input_handler.inputs_pressed["Left"] == true then
                    state_logic.folder_chip_render_index = (state_logic.folder_chip_render_index - num_chips_per_col) % (num_chips_per_folder)
                    if state_logic.folder_chip_render_index == 0 then
                        state_logic.folder_chip_render_index = 30
                    end
                    state_logic.should_redraw = 1
                end

                if input_handler.inputs_pressed["Right"] == true then
                    state_logic.folder_chip_render_index = (state_logic.folder_chip_render_index + num_chips_per_col) % (num_chips_per_folder)
                    if state_logic.folder_chip_render_index == 0 then
                        state_logic.folder_chip_render_index = 30
                    end
                    state_logic.should_redraw = 1
                end

                if input_handler.inputs_pressed["Up"] == true then
                    state_logic.folder_chip_render_index = (state_logic.folder_chip_render_index - 1) % (num_chips_per_folder + 1)
                    --print ("UP PRESSED")
                    if state_logic.folder_chip_render_index == 0 then
                        state_logic.folder_chip_render_index = 30
                    end
                    state_logic.should_redraw = 1
                end

                if input_handler.inputs_pressed["Down"] == true then
                    state_logic.folder_chip_render_index = (state_logic.folder_chip_render_index + 1) % (num_chips_per_folder + 1)
                    if state_logic.folder_chip_render_index == 0 then
                        state_logic.folder_chip_render_index = 1
                    end
                    state_logic.should_redraw = 1
                end
            end
            

            -- If MusicLoader is still loading, we simply do not handle the event
            if input_handler.inputs_pressed["A"] == true and (MusicLoader.FinishedLoading == 1 or GENERIC_DEFS.ENABLE_MUSIC_PATCHING == 0) then

                

                -- TODO: add chip to folder!
                --print("A pressed")
            
                if state_logic.dropped_chip.ID ~= -1 then

                    local dropped_chip_data = CHIP_DATA[state_logic.dropped_chip.ID]
                    local is_dropped_chip_mega = (dropped_chip_data.CHIP_RANKING % 4) == 1
                    local is_dropped_chip_giga = (dropped_chip_data.CHIP_RANKING % 4) == 2
                    local folder_chip_data = CHIP_DATA[gauntlet_data.current_folder[state_logic.folder_chip_render_index].ID]
                    local is_folder_chip_mega = (folder_chip_data.CHIP_RANKING % 4) == 1
                    local is_folder_chip_giga = (folder_chip_data.CHIP_RANKING % 4) == 2

                    local replaces_mega_chip = is_folder_chip_mega and is_dropped_chip_mega

                    local replaces_giga_chip = is_folder_chip_giga and is_dropped_chip_giga

                    if (((dropped_chip_data.CHIP_RANKING % 4) == 1 and gauntlet_data.current_number_of_mega_chips >= gauntlet_data.mega_chip_limit + gauntlet_data.mega_chip_limit_team) 
                        or ((dropped_chip_data.CHIP_RANKING % 4) == 2 and gauntlet_data.current_number_of_giga_chips >= gauntlet_data.giga_chip_limit))
                        
                        and replaces_mega_chip == false and replaces_giga_chip == false
                        then
                    
                        -- We do nothing if we can't pick due to Mega/GigaChip limits. We check for replacement of Mega/Giga chips.

                    else        
                        

                        state_logic.replaced_chip = deepcopy(gauntlet_data.current_folder[state_logic.folder_chip_render_index].PRINT_NAME)
                        gauntlet_data.current_folder[state_logic.folder_chip_render_index] = state_logic.dropped_chip
                        gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_RUNNING
                        state_logic.should_redraw = 1

                        state_logic.update_folder_mega_giga_chip_counts()
                        gauntlet_data.folder_view = 0
                        
                    end

                else
                    state_logic.replaced_chip = "Skipped Chip"
                    gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_RUNNING
                    gauntlet_data.folder_view = 0
                    state_logic.should_redraw = 1
                end
            end
            
            if (gauntlet_data.illusion_of_choice_active == 0) or (gauntlet_data.illusion_of_choice_active and state_logic.dropped_chip.ID == -1) then
                if input_handler.inputs_pressed["B"] == true and (MusicLoader.FinishedLoading == 1 or GENERIC_DEFS.ENABLE_MUSIC_PATCHING == 0)  then
                    -- Just skip - we didn't want a chip!
                    --print("B pressed")
                    gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_RUNNING
                    state_logic.replaced_chip = "Skipped Chip"
                    
                    state_logic.should_redraw = 1
                end
            end
        end
        --print(state_logic.folder_chip_render_index)

        state_logic.check_buff_render_offset()

        if state_logic.should_redraw == 1 then


            
            
            if gauntlet_data.folder_view == 0 then
                gui_rendering.render_folder(gauntlet_data.current_folder, state_logic.folder_chip_render_index, state_logic.dropped_chip, gauntlet_data, MusicLoader.FinishedLoading)
            elseif gauntlet_data.folder_view == 1 then
                gui_rendering.render_folder(gauntlet_data.current_folder, state_logic.folder_chip_render_index, state_logic.dropped_chip, gauntlet_data, MusicLoader.FinishedLoading)
            elseif gauntlet_data.folder_view == 2 then
                gui_rendering.render_buffs(state_logic.activated_buffs, MusicLoader.FinishedLoading, state_logic.buff_render_offset)
            end
            
            
            
            gui.DrawFinish()
            memorysavestate.loadcorestate(state_logic.gui_change_savestate)
            state_logic.should_redraw = 0
        end

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.TRANSITION_TO_BUFF_SELECT then    

        state_logic.gui_change_savestate = memorysavestate.savecorestate()
        state_logic.dropped_buff_render_index = 2
        --print("TRANSITION TO BUFF SELECT")
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.BUFF_SELECT
        state_logic.should_redraw = 1
        state_logic.shuffle_folder()
        state_logic.dropped_buffs = BUFF_GENERATOR.random_buffs_from_round(state_logic.current_round, GAUNTLET_DEFS.NUMBER_OF_DROPPED_BUFFS, state_logic.current_battle)
        state_logic.update_buff_discriptions()
        memorysavestate.loadcorestate(state_logic.gui_change_savestate)
        client.pause()

        -- Determine number of Mega/Giga chips in folder.
        state_logic.update_folder_mega_giga_chip_counts()
        
        

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.BUFF_SELECT then
        --print ("IN BUFF_SELECT")

        state_logic.folder_view_switch_and_sort()
        state_logic.check_buff_render_offset()

        if gauntlet_data.folder_view == 0 then
        
            if input_handler.inputs_pressed["Up"] == true then
                state_logic.dropped_buff_render_index = (state_logic.dropped_buff_render_index - 1) % (#state_logic.dropped_buffs)
                
                if state_logic.dropped_buff_render_index == 0 then
                    state_logic.dropped_buff_render_index = (#state_logic.dropped_buffs)
                end
                state_logic.should_redraw = 1
            end

            if input_handler.inputs_pressed["Down"] == true then
                state_logic.dropped_buff_render_index = (state_logic.dropped_buff_render_index + 1) % (#state_logic.dropped_buffs + 1)
                if state_logic.dropped_buff_render_index == 0 then
                    state_logic.dropped_buff_render_index = 1
                end
                state_logic.should_redraw = 1
            end

            


            if input_handler.inputs_pressed["A"] == true then

                --print("Selected a Chip!")
                
                -- Restore CHIP_DATA to copy so temporary buffs work fine.
                for key, chip_data in pairs(CHIP_DATA) do
                    CHIP_DATA[key] = deepcopy(state_logic.CHIP_DATA_COPY[key])
                end
                
                if gauntlet_data.copy_paste_active_number_of_buffs == 0 then
                    local dropped_buff = state_logic.dropped_buffs[state_logic.dropped_buff_render_index]
                    BUFF_GENERATOR.activate_buff(dropped_buff, state_logic.current_round)

                    -- Copy (potentially new) CHIP_DATA to copy so temporary buffs work fine.
                    for key, chip_data in pairs(CHIP_DATA) do
                        state_logic.CHIP_DATA_COPY[key] = deepcopy(CHIP_DATA[key])
                    end

                    state_logic.number_of_activated_buffs = state_logic.number_of_activated_buffs + 1
                    state_logic.activated_buffs[state_logic.number_of_activated_buffs] = dropped_buff
                else
                    local dropped_buff = deepcopy(state_logic.dropped_buffs[state_logic.dropped_buff_render_index])
                    local dropped_buff_copy = deepcopy(dropped_buff)
                    BUFF_GENERATOR.activate_buff(dropped_buff, state_logic.current_round)
                    state_logic.update_printable_chip_names_in_folder()
                    BUFF_GENERATOR.activate_buff(dropped_buff_copy, state_logic.current_round)

                    -- Copy (potentially new) CHIP_DATA to copy so temporary buffs work fine.
                    for key, chip_data in pairs(CHIP_DATA) do
                        state_logic.CHIP_DATA_COPY[key] = deepcopy(CHIP_DATA[key])
                    end

                    state_logic.number_of_activated_buffs = state_logic.number_of_activated_buffs + 1
                    state_logic.activated_buffs[state_logic.number_of_activated_buffs] = dropped_buff
                    state_logic.number_of_activated_buffs = state_logic.number_of_activated_buffs + 1
                    state_logic.activated_buffs[state_logic.number_of_activated_buffs] = dropped_buff_copy

                    gauntlet_data.copy_paste_active_number_of_buffs = gauntlet_data.copy_paste_active_number_of_buffs - 1
                end

                gauntlet_data.folder_view = 0
                gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_CHIP_SELECT
                --gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_BUFF_SELECT
                state_logic.should_redraw = 1
                
                -- In case we picked another perfectionist - recompute the damage buffs for visualization.
                state_logic.recompute_perfect_damage_bonuses()
                state_logic.update_printable_chip_names_in_folder()
                state_logic.update_argb_chip_icons_in_folder()
                state_logic.update_folder_mega_giga_chip_counts()
            end

        end

        if state_logic.should_redraw == 1 then


            if gauntlet_data.folder_view == 0 then
                gui_rendering.render_items(state_logic.dropped_buffs, state_logic.dropped_buff_render_index)
            elseif gauntlet_data.folder_view == 1 then
                gui_rendering.render_folder(gauntlet_data.current_folder, nil, nil, gauntlet_data, MusicLoader.FinishedLoading)
            elseif gauntlet_data.folder_view == 2 then
                gui_rendering.render_buffs(state_logic.activated_buffs, MusicLoader.FinishedLoading, state_logic.buff_render_offset)
            end

            
            gui.DrawFinish()
            memorysavestate.loadcorestate(state_logic.gui_change_savestate)
            state_logic.should_redraw = 0
        end
        
    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.TRANSITION_TO_RUNNING then

        state_logic.patch_before_battle_start()
        state_logic.hp_loaded = 0
        --mmbn3_utils.change_number_of_cust_screen_chips(gauntlet_data.cust_style_number_of_chips + gauntlet_data.cust_screen_number_of_chips)  
        
        --print("Patched folder!")
        client.unpause()
         --mmbn3_utils.change_megaMan_max_hp(gauntlet_data.mega_max_hp) 
        
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.RUNNING
        
    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.LOAD_INITIAL then
        -- Simply load initial state again if we beat all rounds.
        savestate.load(state_logic.initial_state)
        state_logic.next_round()
        client.unpause()
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.DEFAULT_WAITING_FOR_EVENTS
    
    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.TRANSITION_TO_CHOOSE_STARTING_LOADOUT then
        state_logic.gui_change_savestate = memorysavestate.savecorestate()
        
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.CHOOSE_STARTING_LOADOUT
        state_logic.should_redraw = 1
        
        
        memorysavestate.loadcorestate(state_logic.gui_change_savestate)
        client.pause()


    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.CHOOSE_STARTING_LOADOUT then

        -- TODO: render list of starting loadouts. Each loadout should provide a callable function that can set various things.
        state_logic.folder_view_switch_and_sort()
        state_logic.check_buff_render_offset()


        if gauntlet_data.folder_view == 0 then

            if input_handler.inputs_pressed["Up"] == true then
                state_logic.selected_loadout_index = (state_logic.selected_loadout_index - 1) % (#LOADOUTS)
                
                if state_logic.selected_loadout_index == 0 then
                    state_logic.selected_loadout_index = #LOADOUTS
                end
                state_logic.should_redraw = 1
            end

            if input_handler.inputs_pressed["Down"] == true then
                state_logic.selected_loadout_index = (state_logic.selected_loadout_index + 1) % (#LOADOUTS + 1)
                if state_logic.selected_loadout_index == 0 then
                    state_logic.selected_loadout_index = 1
                end
                state_logic.should_redraw = 1
            end

            


            if input_handler.inputs_pressed["A"] == true then

                --print("Selected a Chip!")
                --print("Selected Loadout: ", LOADOUTS[state_logic.selected_loadout_index])
                gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_BUFF_SELECT


                LOADOUTS[state_logic.selected_loadout_index].activate()

                
                state_logic.update_printable_chip_names_in_folder()
                state_logic.update_argb_chip_icons_in_folder()
                state_logic.update_folder_mega_giga_chip_counts()
                --print("Folder after loadout: ", gauntlet_data.current_folder)
                gauntlet_data.folder_view = 0
                gauntlet_data.loadout_chosen = 1
                state_logic.selected_loadout_index = 2
                
                
            end

        end

        if state_logic.should_redraw == 1 then
            
            if gauntlet_data.folder_view == 0 then
                gui_rendering.render_items(LOADOUTS, state_logic.selected_loadout_index)
            elseif gauntlet_data.folder_view == 1 then
                gui_rendering.render_folder(gauntlet_data.current_folder, nil, nil, gauntlet_data, MusicLoader.FinishedLoading)
            elseif gauntlet_data.folder_view == 2 then
                gui_rendering.render_buffs(state_logic.activated_buffs, MusicLoader.FinishedLoading, state_logic.buff_render_offset)
            end

            
            gui.DrawFinish()
            memorysavestate.loadcorestate(state_logic.gui_change_savestate)
            state_logic.should_redraw = 0
        end

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.TRANSITION_TO_CHOOSE_DROP_METHOD then
        state_logic.gui_change_savestate = memorysavestate.savecorestate()
        
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.CHOOSE_DROP_METHOD
        state_logic.should_redraw = 1
        
        
        memorysavestate.loadcorestate(state_logic.gui_change_savestate)
        client.pause()

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.CHOOSE_DROP_METHOD then

        -- TODO: render list of starting loadouts. Each loadout should provide a callable function that can set various things.
        state_logic.folder_view_switch_and_sort()
        state_logic.check_buff_render_offset()

        if gauntlet_data.folder_view == 0 then

            if input_handler.inputs_pressed["Up"] == true then
                state_logic.selected_drop_method_index = (state_logic.selected_drop_method_index - 1) % (#CHIP_DROP_METHODS)
                
                if state_logic.selected_drop_method_index == 0 then
                    state_logic.selected_drop_method_index = #CHIP_DROP_METHODS
                end
                state_logic.should_redraw = 1
            end

            if input_handler.inputs_pressed["Down"] == true then
                state_logic.selected_drop_method_index = (state_logic.selected_drop_method_index + 1) % (#CHIP_DROP_METHODS + 1)
                if state_logic.selected_drop_method_index == 0 then
                    state_logic.selected_drop_method_index = 1
                end
                state_logic.should_redraw = 1
            end

            


            if input_handler.inputs_pressed["A"] == true then

                --print("Selected a Chip!")
                --print("Selected drop method: ", CHIP_DROP_METHODS[state_logic.selected_drop_method_index])
                gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_CHOOSE_STARTING_LOADOUT


                gauntlet_data.chip_drop_method = CHIP_DROP_METHODS[state_logic.selected_drop_method_index]
                gauntlet_data.chip_drop_method.activate()

                
                --print("Folder after loadout: ", gauntlet_data.current_folder)
                gauntlet_data.folder_view = 0
                state_logic.selected_drop_method_index = 2
            end

        end

        if state_logic.should_redraw == 1 then


            if gauntlet_data.folder_view == 0 then
                gui_rendering.render_items(CHIP_DROP_METHODS, state_logic.selected_drop_method_index)
            elseif gauntlet_data.folder_view == 1 then
                gui_rendering.render_folder(gauntlet_data.current_folder, nil, nil, gauntlet_data, MusicLoader.FinishedLoading)
            elseif gauntlet_data.folder_view == 2 then
                gui_rendering.render_buffs(state_logic.activated_buffs, MusicLoader.FinishedLoading, state_logic.buff_render_offset)
            end

            
            gui.DrawFinish()
            memorysavestate.loadcorestate(state_logic.gui_change_savestate)
            state_logic.should_redraw = 0
        end

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.TRANSITION_TO_DRAFT_FOLDER then
        state_logic.gui_change_savestate = memorysavestate.savecorestate()
        
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.DRAFT_FOLDER
        state_logic.should_redraw = 1
        

        --print("Transition to draft folder!")

        --print("After folder draft generator")
        state_logic.update_argb_chip_icons_in_folder()
        
        --print("Folder:", gauntlet_data.current_folder)

        if #gauntlet_data.current_folder == 30 then
            gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_BUFF_SELECT
        else
            for draft_chip_idx = 1,GAUNTLET_DEFS.NUMBER_OF_DRAFT_CHIPS do
                --print("idx ", draft_chip_idx)
                state_logic.draft_selection_chips[draft_chip_idx] = gauntlet_data.folder_draft_chip_generator(#gauntlet_data.current_folder + 1)
                --print("idxx ", draft_chip_idx)
                state_logic.draft_selection_chips[draft_chip_idx].PRINT_NAME = state_logic.get_printable_chip_name(state_logic.draft_selection_chips[draft_chip_idx])
            end
            state_logic.update_dropped_chips_pictures(state_logic.draft_selection_chips)
        end
        
        state_logic.update_argb_chip_icons_in_folder()
        memorysavestate.loadcorestate(state_logic.gui_change_savestate)
        client.pause()
        

        
        

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.DRAFT_FOLDER then
        
        state_logic.folder_view_switch_and_sort()
        state_logic.check_buff_render_offset()

        if gauntlet_data.folder_view == 0 then

            if input_handler.inputs_pressed["Left"] == true then
                state_logic.draft_chip_render_index = (state_logic.draft_chip_render_index - 1) % (#state_logic.draft_selection_chips)
                if state_logic.draft_chip_render_index == 0 then
                    state_logic.draft_chip_render_index = (#state_logic.draft_selection_chips)
                end
                state_logic.should_redraw = 1
            end

            if input_handler.inputs_pressed["Right"] == true then
                state_logic.draft_chip_render_index = (state_logic.draft_chip_render_index + 1) % (#state_logic.draft_selection_chips + 1)
            
                if state_logic.draft_chip_render_index == 0 then
                    state_logic.draft_chip_render_index = 1
                end
                state_logic.should_redraw = 1
            end

            

            if input_handler.inputs_pressed["A"] == true then

                --print("Selected a Chip!")
                
                local new_chip = state_logic.draft_selection_chips[state_logic.draft_chip_render_index]

                gauntlet_data.current_folder[#gauntlet_data.current_folder + 1] = deepcopy(new_chip)
                state_logic.update_printable_chip_names_in_folder()
                state_logic.update_argb_chip_icons_in_folder()

                gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_DRAFT_FOLDER
                gauntlet_data.folder_view = 0
                state_logic.should_redraw = 1
                state_logic.draft_chip_render_index = 1
            end

        end

        if state_logic.should_redraw == 1 then

            if gauntlet_data.folder_view == 0 then
                gui_rendering.render_chip_selection(state_logic.draft_selection_chips, state_logic.draft_chip_render_index)
            elseif gauntlet_data.folder_view == 1 then
                gui_rendering.render_folder(gauntlet_data.current_folder, nil, nil, gauntlet_data, MusicLoader.FinishedLoading)
            elseif gauntlet_data.folder_view == 2 then
                gui_rendering.render_buffs(state_logic.activated_buffs, MusicLoader.FinishedLoading, state_logic.buff_render_offset)
            end
            
            gui.DrawFinish()
            memorysavestate.loadcorestate(state_logic.gui_change_savestate)
            state_logic.should_redraw = 0
        end

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.TRANSITION_TO_GAUNTLET_COMPLETE then
        state_logic.gui_change_savestate = memorysavestate.savecorestate()
        
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.GAUNTLET_COMPLETE
        state_logic.should_redraw = 1
        
        memorysavestate.loadcorestate(state_logic.gui_change_savestate)
        client.pause()

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.GAUNTLET_COMPLETE then

        if state_logic.should_redraw == 1 then

            
            gui_rendering.render_gauntlet_complete()

            gui.DrawFinish()
            memorysavestate.loadcorestate(state_logic.gui_change_savestate)
            state_logic.should_redraw = 0
        end
        

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.RUNNING then
        
    else-- Default state, should never happen
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.DEFAULT_WAITING_FOR_EVENTS
    end

    

    -- Pause-Buffer penalty  0x02001889
    -- Would need to check for first cust-screen open to prevent invalid triggers at the start of battle.
    --local is_paused = memory.readbyte(GENERIC_DEFS.GAME_PAUSED_ADDRESS - 0x02000000, "EWRAM")
    --local is_cust_open = memory.readbyte(0x0200C0C9 - 0x02000000, "EWRAM")
    
    -- if is_paused == 1 and is_cust_open == 0 then

    --   state_logic.pause_frame_counter =  state_logic.pause_frame_counter + 1
    --    if state_logic.pause_frame_counter >=  GAUNTLET_DEFS.PAUSE_BUFFER_HP_PENALTY.FRAME_INTERVAL then

    --        state_logic.pause_frame_counter = 0
            -- Get current HP
    --       local current_hp = memory.read_u16_le(0x02037510 - 0x02000000, "EWRAM")

    --        current_hp = current_hp - GAUNTLET_DEFS.PAUSE_BUFFER_HP_PENALTY.HP_DECREASE
            
    --        memory.write_u16_le(0x02037510 - 0x02000000, current_hp, "EWRAM")

    --    end
        

    --end

    -- MusicLoader block loading

    if MusicLoader.LoadBlock() == 1 then
        state_logic.should_redraw = 1
    end

    --emu.yield()
end

return state_logic