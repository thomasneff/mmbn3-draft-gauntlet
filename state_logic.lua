local input_handler = require "input_handler"
local gui_rendering = require "gui_rendering"
local battle_data_generator = require "defs.battle_data_generator"
local pointer_entry_generator = require "defs.pointer_entry_generator"
local BACKGROUND_TYPE = require "defs.battle_background_defs"
local BATTLE_STAGE = require "defs.battle_stage_defs"
local GAUNTLET_DEFS = require "defs.gauntlet_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local io_utils = require "io_utils.io_utils"
local CHIP = require "defs.chip_defs"
local CHIP_NAME_UTILS = require "defs.chip_name_utils"
local CHIP_NAME = require "defs.chip_name_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"
local CHIP_CODE_REVERSE = require "defs.chip_code_reverse_defs"
local CHIP_ICON = require "defs.chip_icon_defs"
local CHIP_PICTURE = require "defs.chip_picture_defs"
local CHIP_DATA = require "defs.chip_data_defs"
-- TODO_REFACTOR: buff_effects folder is the only one left :D
local BUFF_GENERATOR = require "buff_effects.buff_groups"
local INFO_BUFF = require "buff_effects.info_buff"
local LOADOUTS = require "loadouts.loadout_defs"
local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP_DROP_METHODS = require "chip_drop_methods.chip_drop_method_defs"
local MusicLoader = require "music_loader"
local json = require "json"
local randomchoice_key = require "randomchoice_key"
local PA_DEFS = require "defs.pa_defs"
local INITIAL_STATE_NAME = require "savestates.initial_state_name"
local DIFFICULTY_LEVELS = require "difficulty_levels.difficulty_levels_defs"

-- TODO: possibly add more states.

local state_logic = {}

local DEBUG_STATE_LOGIC = 0

function state_logic.next_round()

    
    -- We just finished the round. We might want to load a savestate? Or just let the user do that.
    state_logic.current_round = state_logic.current_round + 1

    -- Reset all address variables, as we now start from the beginning again.
    state_logic.battle_pointer_index = 1

    if state_logic.current_round == (GAUNTLET_DEFS.MAX_NUMBER_OF_ROUNDS + 1) then
        return
    end

    
    print("Starting Round " .. state_logic.current_round)

    -- Patch all battle stage setups. This needs to be done before engaging the gauntlet.
    -- The game loads this probably into RAM, so we could only change that later if we found out the 
    -- respective RAM addresses...
    -- print("4")
    
    --print("Patched Battle Stage Setups!")

    state_logic.on_next_round()

    -- Potentially do other stuff here. For example, we could set the state to a 'choose-reward' state.

end

function state_logic.patch_consecutive_program_advances()

    -- early out checks if we can even possibly get a PA: we have to have 3 consecutive chips that are listed in the PA defs
    
    -- We simply exit out if we don't want/need PA patching, which might be the case for newer games.
    if (gauntlet_data.pa_patching_enabled ~= 1) then
        return
    end

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
        io_utils.writeword(pa_address, combined_pa_chip_and_code)
    
        -- Write component ID
        io_utils.writebyte(pa_address + 2, selected_chip_id)
        
    end

end

function state_logic.on_cust_screen_confirm()

    if DEBUG_STATE_LOGIC == 1 then
        print("on_cust_screen_confirm")
    end

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

    --if gauntlet_data.number_of_chosen_cust_chips == 0xFF then
    --    print("gauntlet_data.number_of_chosen_cust_chips == 0xFF")
    --    assert(nil)
    --end
    
    gauntlet_data.number_of_chosen_cust_chips = io_utils.readbyte(GENERIC_DEFS.CUST_SCREEN_NUMBER_OF_CHIPS_ADDRESS)

    for chip_idx = 1, gauntlet_data.number_of_chosen_cust_chips do
        local folder_index = io_utils.readbyte(GENERIC_DEFS.CUST_SCREEN_SELECTED_CHIP_INDICES_ADDRESS + chip_idx - 1)
        gauntlet_data.selected_chips[chip_idx] = {}
        
        -- As we now have the folder index, we can read chip code and ID.
        -- TODO_REFACTOR: check if this structure is the same in other games... 
        gauntlet_data.selected_chips[chip_idx].ID = io_utils.readword(GENERIC_DEFS.FOLDER_START_ADDRESS_RAM + (folder_index * 4))
        gauntlet_data.selected_chips[chip_idx].CODE = io_utils.readbyte(GENERIC_DEFS.FOLDER_START_ADDRESS_RAM + (folder_index * 4) + 2)
        gauntlet_data.selected_chips[chip_idx].NAME = deepcopy(CHIP_NAME[gauntlet_data.selected_chips[chip_idx].ID])
    end

      
    -- Fire events for buffs
    for k, v in pairs(state_logic.activated_buffs) do
        if v.ON_CUST_SCREEN_CONFIRM_CALLBACK ~= nil then
            v:on_cust_screen_confirm(state_logic, gauntlet_data)
        end
    end
   
    --gauntlet_data.num_chips_in_battle = num_chips
    
    state_logic.patch_consecutive_program_advances()

    --event.unregisterbyname("on_cust_screen_confirm")
end

function state_logic.init_time_compression()

    state_logic.time_compression_savestates[1] = memorysavestate.savecorestate()
    for i = 1,gauntlet_data.time_compression_delay do
        state_logic.time_compression_savestates[(i % gauntlet_data.time_compression_delay) + 1] = state_logic.time_compression_savestates[((i - 1) % gauntlet_data.time_compression_delay) + 1]
    end

end

function state_logic.on_battle_phase_start()

    if DEBUG_STATE_LOGIC == 1 then
        print("on_battle_phase_start")
    end
    --print("Battle phase start!")

    -- Extract held chip IDs and damage values
    gauntlet_data.battle_phase = 1

    -- Initialize time compression savestates
    state_logic.init_time_compression()
    
    local held_chip_id_addr = GENERIC_DEFS.IN_BATTLE_HELD_CHIP_IDS_ADDRESS
    local held_chip_damage_addr =  GENERIC_DEFS.IN_BATTLE_HELD_CHIP_DAMAGES_ADDRESS

    gauntlet_data.held_chips = {}
    gauntlet_data.custgauge_last_frames_storage = 0

    -- TODO_REFACTOR: check if held chips work the same way...
    for chip_idx = 1,5 do 

        local chip_id = io_utils.readword(held_chip_id_addr + ((chip_idx - 1) * 2))

        if (chip_id ~= 0xFFFF) then
            
            local chip_damage = io_utils.readword(held_chip_damage_addr + ((chip_idx - 1) * 2))

            local chip = {}
            chip.ID = chip_id
            chip.DAMAGE = chip_damage

            gauntlet_data.held_chips[chip_idx] = deepcopy(chip)

            --print("Chip " .. tostring(chip_idx) .. ": NAME = " .. CHIP_NAME[chip.ID] ..  ", ID = " .. tostring(chip.ID) .. ", DAMAGE = " .. tostring(chip.DAMAGE))
        end

    end

    

    state_logic.check_in_battle_effects()


end

function state_logic.on_chip_use()
    --print("Chip used!")

    --if DEBUG_STATE_LOGIC == 1 then
    --    print("on_chip_use: " .. CHIP_NAME[gauntlet_data.held_chips[gauntlet_data.current_battle_chip_index].ID])
    --end

    for k, v in pairs(state_logic.activated_buffs) do
        if v.ON_CHIP_USE_CALLBACK ~= nil then
            v:on_chip_use(gauntlet_data.held_chips[gauntlet_data.current_battle_chip_index], 
                state_logic.main_loop_frame_count, 
                state_logic, 
                gauntlet_data)
        end
    end

    -- TODO: bug when holding a chip for more than 1 phase ?
    gauntlet_data.held_chips[gauntlet_data.current_battle_chip_index].ID = 0xFFFF
    gauntlet_data.held_chips[gauntlet_data.current_battle_chip_index].DAMAGE = 0x0000
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

end


local DEBUG = 0

function state_logic.recompute_perfect_damage_bonuses()

    local damage_mult =  gauntlet_data.perfectionist_damage_bonus_mult.BASE +  gauntlet_data.perfectionist_damage_bonus_mult.PERFECT_FIGHT_INCREASE * gauntlet_data.number_of_perfect_fights
    
    if damage_mult > gauntlet_data.perfectionist_damage_bonus_mult.LIMIT then
        damage_mult = gauntlet_data.perfectionist_damage_bonus_mult.LIMIT
    end
    
    gauntlet_data.perfectionist_damage_bonus_mult.CURRENT = damage_mult

    --print("Perfectionist multiplier: " .. gauntlet_data.perfectionist_damage_bonus_mult.CURRENT)
    if DEBUG_STATE_LOGIC == 1 then
        print("Perfectionist multiplier: " .. gauntlet_data.perfectionist_damage_bonus_mult.CURRENT)
    end
    
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
    
    -- TODO_REFACTOR: make sure that any CHIP_DATA refactoring doesn't break this.
    -- TODO_REFACTOR: CHIP_DATA should also work if some elements are left nil, I guess
    -- Restore CHIP_DATA from copy. Copies are always taken when taking a buff, as this is the only possibility where CHIP_DATA is changed directly.
    for key, chip_data in pairs(CHIP_DATA) do
        CHIP_DATA[key] = deepcopy(state_logic.CHIP_DATA_COPY[key])
    end
    
    
    -- Tactician
    local multiplicative_damage_increase = gauntlet_data.tactician_damage + gauntlet_data.perfectionist_damage_bonus_mult.CURRENT
    
    -- Apply temporary buffs
    for key, chip_data in pairs(CHIP_DATA) do 
        CHIP_DATA[key].DAMAGE = (CHIP_DATA[key].DAMAGE * multiplicative_damage_increase) + gauntlet_data.perfectionist_damage_bonus_add.CURRENT
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

function state_logic.load_encounter_data()

    print("Loading encounter data for battle " .. tostring(state_logic.current_battle))
    local ptr_table_working_address = GENERIC_DEFS.FIRST_GAUNTLET_BATTLE_POINTER_ADDRESS
    --for battle_idx = 1, GAUNTLET_DEFS.BATTLES_PER_ROUND do
    -- TODO_REFACTOR: why is this address + 4? I forgot, but that might be important for the other games...
    local new_pointer_entry = pointer_entry_generator.new_from_template(GENERIC_DEFS.FIRST_GAUNTLET_BATTLE_ADDRESS + 4, BACKGROUND_TYPE.random() , BATTLE_STAGE.random())
    gauntlet_data.battle_stages[state_logic.current_battle] = new_pointer_entry.BATTLE_STAGE
    io_utils.change_battle_pointer_data(ptr_table_working_address, new_pointer_entry)
    --ptr_table_working_address = ptr_table_working_address - GENERIC_DEFS.OFFSET_BETWEEN_POINTER_TABLE_ENTRIES
    --end
    
end

function state_logic.on_battle_end()

    --event.unregisterbyname("on_battle_end")
    if DEBUG_STATE_LOGIC == 1 then
        print("on_battle_end")
    end

    input_handler.current_input_state = nil
    state_logic.do_not_pause = false

    if gauntlet_data.main_player == 1 then
        local payload = {}
        payload.SKIP_BATTLE_IF_THIS_ARRIVES = 1
        -- Enter current menu inputs into network buffer
        if state_logic.network_handler.is_connected then
            state_logic.network_handler.produce_send_buffer(json.encode(payload) .. "\n")
        end

    end

    if state_logic.network_handler.is_connected then
        print("Swapping main player: ")
        gauntlet_data.main_player = 1 - gauntlet_data.main_player
        print("Main player: ", gauntlet_data.main_player)
        gauntlet_data.sub_player_delay_counter = 0
    end



    -- We advance chip generation rng here
    gauntlet_data.math.advance_rng_since_last_advance("CHIP_GENERATION", 229);

    if state_logic.battle_pointer_index > GAUNTLET_DEFS.BATTLES_PER_ROUND then
       gauntlet_data.current_state = gauntlet_data.GAME_STATE.LOAD_INITIAL 
       state_logic.next_round()
    end  

    -- Reset battle enter lock
    state_logic.battle_enter_lock = 0

    -- Compute lost HP
    -- TODO_REFACTOR: verify that this is consistent between games, if the offset is chosen accordingly
    gauntlet_data.current_hp = io_utils.readword(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_LOADING)
    state_logic.stats_lost_hp = state_logic.stats_previous_hp - gauntlet_data.current_hp
    state_logic.stats_previous_hp = gauntlet_data.current_hp
    
    if gauntlet_data.current_hp == 0 then
        print("Reset in on_battle_end(), MEGA HP was 0 during battle end loading")
        --state_logic.initialize()
        state_logic.reset = true
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

    
    --event.onmemoryexecute(state_logic.on_enter_battle, GENERIC_DEFS.BATTLE_START_ADDRESS + 4, "on_enter_battle")
    gauntlet_data.num_chips_in_battle = 0
    gauntlet_data.battle_phase = 0
    gauntlet_data.is_cust_screen = 0
    state_logic.hp_loaded = 0
    gauntlet_data.cust_screen_was_opened = 0

    gauntlet_data.hp_patch_required = 1

    if state_logic.network_handler.is_connected then
        gauntlet_data.networked_music_loaded = 0

        print("SET NETWORKED MUSIC LOADED: ", gauntlet_data.networked_music_loaded)

        gauntlet_data.networked_music_loaded_sent = false
    end

    gauntlet_data.current_state = gauntlet_data.GAME_STATE.LOAD_INITIAL
end

function state_logic.determine_drops(number_of_drops)

    if state_logic.battle_data[state_logic.current_battle - 1] == nil then
        -- First round. Do we do anything here?
        -- For now, we don't.
    else
        -- TODO: determine drops from state_logic.battle_data[state_logic.current_battle].ENTITIES entity droptables.
        -- TODO: for now, this just randomizes.
        -- state_logic.randomize_dropped_chips(number_of_drops)
        state_logic.dropped_chips = gauntlet_data.chip_drop_method.generate_drops(state_logic.battle_data[state_logic.current_battle - 1], state_logic.current_round, number_of_drops)

        -- Compute buff effects that depend on battle ending
        for k, v in pairs(state_logic.activated_buffs) do
            if v.ON_CHIP_DROP_CALLBACK ~= nil then
                v:on_chip_drop(state_logic, gauntlet_data)
            end
        end

        state_logic.update_dropped_chips_pictures(state_logic.dropped_chips)
    end
end

function state_logic.on_enter_battle()
    
    if DEBUG_STATE_LOGIC == 1 then
        print("on_enter_battle")
    end


    -- Check if this is really the battle start or just a use of FoldrBak
    -- If in the future, somehow, our check with battle_start and battle_end doesn't work, we can use this to check for FoldrBak
    --local r9_val = emu.getregister("R9")
    --local r6_val = emu.getregister("R6")

    --print("r6 = " .. tostring(r6_val) .. ", r9 = " .. tostring(r9_val))

    --if r6_val ~= 1 or r9_val ~= 0x0200AB90 then
    --    return
    --end

    -- We simply check if we are in battle, because then it's guaranteed to be FoldrBak
    --event.unregisterbyname("on_enter_battle")

    if state_logic.battle_enter_lock == 1 then
        print("FolderBak used!")
        io_utils.patch_folder_in_battle(gauntlet_data.current_folder, GENERIC_DEFS.FOLDER_START_ADDRESS_RAM, gauntlet_data)
        --client.pause()
        -- If this happens, we need to shuffle our folder and re-write the indices, otherwise folders with less than 20 chips will break.

        return
    end

    state_logic.battle_enter_lock = 1

    
    -- Also write an additional file with another (synced) random number so that the additional music player tool works for draft music.
    local random_number = gauntlet_data.math.random_music(1, 999999999)
    
    local file = state_logic.try_open_file("Lua/mmbn3_draft_gauntlet/gauntlet_draft_music.txt", "w")
    if file ~= nil then
        print("Writing random music txt: " .. random_number)
        file:write(random_number)
        file:flush()
        file:close()
    end
    
    
    
    gauntlet_data.music_loading_started = 0
    MusicLoader.StartedLoading = 0
    MusicLoader.FinishedLoading = 0
    MusicLoader.LoadRandomFile(state_logic.current_battle)
    gauntlet_data.music_loading_started = 1


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
    if state_logic.current_battle >= (GAUNTLET_DEFS.MAX_NUMBER_OF_BATTLES + 1) then
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_GAUNTLET_COMPLETE
    end

    --event.onmemoryexecute(state_logic.on_battle_end, GENERIC_DEFS.END_OF_GAUNTLET_BATTLE_ADDRESS, "on_battle_end")
    --gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_CHIP_SELECT
    gauntlet_data.num_chips_in_battle = 0
    gauntlet_data.battle_phase = 0
    gauntlet_data.is_cust_screen = 0
    state_logic.hp_loaded = 0

end


function state_logic.on_next_round()

    if DEBUG_STATE_LOGIC == 1 then
        print("on_next_round")
    end
    
    --print ("BEFORE MEGA MAX INCREASE PER ROUND")
    gauntlet_data.mega_max_hp = gauntlet_data.mega_max_hp + GAUNTLET_DEFS.HP_INCREASE_PER_ROUND[state_logic.current_round]
    gauntlet_data.last_known_current_hp = gauntlet_data.mega_max_hp
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

    for chip_idx = 1,#gauntlet_data.current_folder do
        gauntlet_data.current_folder[chip_idx] = CHIP.new_random_chip_with_random_code()
        --gauntlet_data.current_folder[chip_idx] = CHIP.new_chip_with_code(0x1, 0)
    end
   
    
end



function state_logic.initialize_folder()

    gauntlet_data.current_folder = {}

    -- NOTE: not sure if this is necessary anymore. Removed for now.
    --gauntlet_data.current_folder = START_FOLDER.get_random(nil)

    
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

    if gauntlet_data.chip_icon_cache[chip.ID] ~= nil then
        return gauntlet_data.chip_icon_cache[chip.ID]
    end

    local chip_address = CHIP_DATA[chip.ID].CHIP_ICON_OFFSET

    gauntlet_data.chip_icon_cache[chip.ID] = deepcopy(CHIP_ICON.get_argb_2d_array_for_icon_address(chip_address))

    return gauntlet_data.chip_icon_cache[chip.ID]

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
    
    if state_logic.number_of_activated_buffs == nil then
        state_logic.number_of_activated_buffs = 0
        state_logic.activated_buffs = {}
        return
    end

    print("Undo activated buffs: ", state_logic.number_of_activated_buffs)

    if state_logic.number_of_activated_buffs == 0 then
        return
    end

    local buff_it = state_logic.number_of_activated_buffs

    for buff_it = state_logic.number_of_activated_buffs, 1, -1 do

        print("Deactivating: ", buff_it)
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

function state_logic.try_open_file(path, mode)

    local file = io.open(path, mode)

    print("Trying to open file: " .. path)

    if file == nil then
        file = io.open("Lua/mmbn3_draft_gauntlet/" .. path, mode)
    end

    if file == nil then
        file = io.open("Lua/mmbn3-draft-gauntlet-master/" .. path, mode)
    end

    if file == nil then
        file = io.open("Lua/mmbn3_draft_gauntlet/" .. path, mode)
    end

    if file == nil then
        file = io.open("../lua/" .. path, mode)
    end

    if file == nil then
        file = io.open("../bizhawk/" .. path, mode)
    end

    if file == nil then
        file = io.open("../mmbn3_draft_gauntlet/" .. path, mode)
    end

    if file == nil then
        file = io.open("../mmbn3-draft-gauntlet-master/" .. path, mode)
    end


    if file == nil then
        print("Could not read input file " .. path .. "!")
        return nil
    end

    return file
end

function state_logic.export_run_statistics()

    local file = state_logic.try_open_file(state_logic.stats_file_name, "w")
    if file == nil then
        return
    end

    print("Saving statistics to file: " .. state_logic.stats_file_name)
    local stats_json = json.encode(gauntlet_data.statistics_container)
    file:write(stats_json)
    file:flush()
    file:close()

    -- Export run inputs

    print("Saving run inputs to file: " .. state_logic.recorded_inputs_file_name)

    file = state_logic.try_open_file(state_logic.recorded_inputs_file_name, "w")
    if file == nil then
        return
    end
    gauntlet_data.recorded_input_deltas[1].RANDOM_SEED = gauntlet_data.random_seed
    local inputs_json = json.encode(gauntlet_data.recorded_input_deltas)
    file:write(inputs_json)
    file:flush()
    file:close()
end

function state_logic.random_seeding_test()
    print("Testing new random seeding: ")

    print("invalid name: " .. tostring(gauntlet_data.math.random_named("asdf", 0, 1)))

    print("Initializting group 'testing' with 5000 random values")
    gauntlet_data.math.initialize_rng_for_group("testing", 5000)

    print("invalid args: " .. tostring(gauntlet_data.math.random_named("testing", nil, 1)))

    print("Printing 10 random numbers, then advancing rng by 50 so we are on a nice boundary again")

    for i = 1,10 do
        print(tostring(gauntlet_data.math.random_named("testing")))
    end

    gauntlet_data.math.advance_rng_since_last_advance("testing", 50)

    print("New index: " .. tostring(gauntlet_data.rng_value_map["testing"].INDEX))
    print("New last_index: " .. tostring(gauntlet_data.rng_value_map["testing"].LAST_INDEX))

    print("Printing 30 random integers between 5 and 10, then advancing rng by 50 so we are on a nice boundary again")

    for i = 1,30 do
        print(tostring(gauntlet_data.math.random_named("testing", 5, 10)))
    end
    
    gauntlet_data.math.advance_rng_since_last_advance("testing", 50)
    
    print("New index: " .. tostring(gauntlet_data.rng_value_map["testing"].INDEX))
    print("New last_index: " .. tostring(gauntlet_data.rng_value_map["testing"].LAST_INDEX))

    print("Printing 30 random integers between 1 and 7, then advancing rng by 50 so we are on a nice boundary again")

    for i = 1,30 do
        print(tostring(gauntlet_data.math.random_named("testing", 7)))
    end
        
    gauntlet_data.math.advance_rng_since_last_advance("testing", 50)
        
    print("New index: " .. tostring(gauntlet_data.rng_value_map["testing"].INDEX))
    print("New last_index: " .. tostring(gauntlet_data.rng_value_map["testing"].LAST_INDEX))

end

function state_logic.load_prerecorded_inputs()

    if gauntlet_data.prerecorded_inputs_file == nil then
        return
    end

    local file = state_logic.try_open_file(gauntlet_data.prerecorded_inputs_file, "r")
    if file == nil then
        return
    end

    local prerecorded_input_str = file:read("*all")

    gauntlet_data.prerecorded_inputs = json.decode(prerecorded_input_str)

    file:close()
end

function state_logic.initialize()

    if DEBUG_STATE_LOGIC == 1 then
        print("initialize")
    end

    gauntlet_data.current_state = gauntlet_data.GAME_STATE.DEFAULT_WAITING_FOR_EVENTS
    gauntlet_data.current_input = nil
    state_logic.reset = false
    state_logic.network_reset = false
    

    gauntlet_data.music_loading_started = 0
    state_logic.network_handler.reset_buffers()

    if gauntlet_data.main_player == nil then

        gauntlet_data.main_player = 1

        if state_logic.network_handler.is_connected == true and state_logic.network_handler.is_host == false then
            gauntlet_data.main_player = 0
        end


    
    else

        if state_logic.network_handler.is_connected then

            print("Swapping main player: ")
            gauntlet_data.main_player = 1 - gauntlet_data.main_player
            print("Main player: ", gauntlet_data.main_player)
        end

    end

    
    input_handler.reset_all()
    

    if state_logic.network_handler.is_connected then
        gauntlet_data.networked_music_loaded = 0
    
        print("SET NETWORKED MUSIC LOADED: ", gauntlet_data.networked_music_loaded)

        gauntlet_data.networked_music_loaded_sent = false
    end

    gauntlet_data.current_input = nil

    event.unregisterbyname("main_frame_loop")
    event.unregisterbyname("on_enter_battle")
    event.unregisterbyname("on_battle_end")
    event.unregisterbyname("on_cust_screen_confirm")

    gauntlet_data.recorded_input_deltas = {}
    gauntlet_data.prerecorded_inputs = nil
    gauntlet_data.prerecorded_inputs_index = 1
    -- Load prerecorded inputs, if they exist
    state_logic.load_prerecorded_inputs()


    --event.unregisterbyname("on_chip_use")
    --event.unregisterbyname("on_battle_phase_start")

    event.onframestart(state_logic.main_frame_loop, "main_frame_loop")
    
    event.onframeend(state_logic.on_frame_end, "on_frame_end")
    --event.onframeend(state_logic.main_loop, "main_loop2")

    event.onmemoryexecute(state_logic.on_enter_battle, GENERIC_DEFS.BATTLE_START_ADDRESS + 4, "on_enter_battle")
    event.onmemoryexecute(state_logic.on_battle_end, GENERIC_DEFS.END_OF_GAUNTLET_BATTLE_ADDRESS, "on_battle_end")
    event.onmemoryexecute(state_logic.on_cust_screen_confirm, GENERIC_DEFS.CUST_SCREEN_CONFIRM_ADDRESS + 2, "on_cust_screen_confirm")
    --event.onmemoryexecute(state_logic.on_chip_use, GENERIC_DEFS.CHIP_USE_ADDRESS + 2, "on_chip_use")
    --event.onmemoryexecute(state_logic.on_battle_phase_start, GENERIC_DEFS.BATTLE_PHASE_START_CHIP_IDS_ADDRESS + 2, "on_battle_phase_start")


    -- TODO: check for duplicate / unnecessary initializations...
    state_logic.dropped_chips = {}
    state_logic.dropped_buffs = {}
    state_logic.initial_state = INITIAL_STATE_NAME
    
    gauntlet_data.current_folder = {}
    gauntlet_data.mega_max_hp = 100
    
    
    state_logic.stats_file_name = "stats/" .. os.date("%Y_%m_%d_%H_%M_%S") .. ".json"
    
    state_logic.recorded_inputs_file_name = "stats/" .. os.date("%Y_%m_%d_%H_%M_%S") .. "_inputs.json"

    state_logic.hp_loaded = 0
    state_logic.buff_render_offset = 0

    state_logic.initial_chip_amount_flag = 0

    state_logic.draft_selection_chips = {}

    state_logic.should_redraw = 1
    gauntlet_data.chip_drop_method = CHIP_DROP_METHODS[1]
    gauntlet_data.difficulty = DIFFICULTY_LEVELS[1]
    state_logic.hp_patch_frame_counter = 0
    state_logic.battle_start_frame_counter = 0

    state_logic.dropped_chips[1] = CHIP.get_default_chip()
    state_logic.dropped_chips[2] = CHIP.get_default_chip()
    state_logic.dropped_chips[3] = CHIP.get_default_chip()
    state_logic.dropped_chip = CHIP.get_default_chip()
    state_logic.dropped_chip.ID = -1
    state_logic.dropped_chip.PRINT_NAME = ""
    gauntlet_data.loadout_chosen = 0
    state_logic.selected_loadout_index = 2
    state_logic.selected_drop_method_index = 2
    state_logic.selected_difficulty_index = 2

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

    state_logic.battle_enter_lock = 0
    state_logic.main_loop_frame_count = 0
    state_logic.time_compression_savestates = {}


    gauntlet_data.statistics_container = {}

    if state_logic.network_handler.random_seed ~= nil then
        gauntlet_data.random_seed = state_logic.network_handler.random_seed
    end

    if gauntlet_data.prerecorded_inputs ~= nil then
        gauntlet_data.random_seed = gauntlet_data.prerecorded_inputs[1].RANDOM_SEED
    end
    
    if gauntlet_data.fixed_random_seed == nil and state_logic.network_handler.random_seed == nil then
        math.randomseed(os.time())
        gauntlet_data.random_seed = math.random(2147483647)
    elseif gauntlet_data.fixed_random_seed ~= nil then
        gauntlet_data.random_seed = gauntlet_data.fixed_random_seed
    end

    print("Seed: " .. tostring(gauntlet_data.random_seed))
    math.randomseed(gauntlet_data.random_seed)
    

    -- Generate initial random values for in-battle rng (e.g. random reflect)
    -- This is so that the draft is not changed when damage is taken using these buffs.

    --state_logic.random_seeding_test()

    gauntlet_data.math.initialize_rng_for_group("MUSIC", 10000)
    gauntlet_data.math.initialize_rng_for_group("IN_BATTLE", 10000)
    gauntlet_data.math.initialize_rng_for_group("BUFF_ACTIVATION", 100000)
    gauntlet_data.math.initialize_rng_for_group("BUFF_SELECTION", 10000)
    gauntlet_data.math.initialize_rng_for_group("DRAFTING", 10000)
    gauntlet_data.math.initialize_rng_for_group("CHIP_REWARDS", 10000)
    gauntlet_data.math.initialize_rng_for_group("LOADOUTS", 10000)
    gauntlet_data.math.initialize_rng_for_group("SNECKO_EYE", 10000)
    gauntlet_data.math.initialize_rng_for_group("ILLUSION_OF_CHOICE", 10000)
    gauntlet_data.math.initialize_rng_for_group("BATTLE_DATA", 10000)
    gauntlet_data.math.initialize_rng_for_group("CHIP_GENERATION", 100000)
    gauntlet_data.math.initialize_rng_for_group("FOLDER_SHUFFLING", 10000)
    gauntlet_data.math.initialize_rng_for_group("SPECTATOR_CHIP", 10000)

    if state_logic.network_handler.random_seed ~= nil then
        state_logic.network_handler.random_seed = math.random(state_logic.network_handler.random_seed)
    end

    if state_logic.network_handler.is_connected and gauntlet_data.main_player == 0 then
        -- Make sure to offset the RNG by one, so that the spectator chips are actually different between players
        gauntlet_data.math.random_spectator_chip(1, #gauntlet_data.current_folder)
    end

    --MusicLoader.generateRNGValues()
    --savestate.load(state_logic.initial_state)


    -- Undo all activated buffs
    state_logic.undo_activated_buffs()
    state_logic.number_of_activated_buffs = 0
    state_logic.activated_buffs = {}
    -- Add the info buff
    state_logic.number_of_activated_buffs = state_logic.number_of_activated_buffs + 1
    state_logic.activated_buffs[state_logic.number_of_activated_buffs] = INFO_BUFF.new()
    state_logic.activated_buffs[state_logic.number_of_activated_buffs]:activate()

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
    gauntlet_data.difficulty = DIFFICULTY_LEVELS[1]
    gauntlet_data.difficulty.activate()
    gauntlet_data.loadout_chosen = 0
    state_logic.selected_loadout_index = 2
    state_logic.dropped_chip = CHIP.get_default_chip()
    state_logic.dropped_chip.ID = -1
    state_logic.dropped_chip.PRINT_NAME = state_logic.get_printable_chip_name(state_logic.dropped_chip)
    state_logic.dropped_chip.ARGB_ICON = state_logic.get_argb_icon(state_logic.dropped_chip)
    state_logic.battle_data = {}
    state_logic.dropped_buffs = {}
    state_logic.dropped_buff_render_index = 2
    state_logic.current_round = 0
    --state_logic.current_battle = 1
    state_logic.battle_pointer_index = 1
    state_logic.hp_patch_frame_counter = 0
    state_logic.battle_start_frame_counter = 0
    state_logic.selected_drop_method_index = 2
    state_logic.selected_difficulty_index = 2
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
    gauntlet_data.current_battle_number_of_time_compressions = 0
    gauntlet_data.total_frame_count = 0
    gauntlet_data.total_gba_frame_count = 0
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
    gauntlet_data.number_of_chosen_cust_chips = 0xFF
    gauntlet_data.backstab_percentage_damage = 0
    gauntlet_data.pen_nib_bonus_damage = 0
    gauntlet_data.tactician_unique_id = 0
    gauntlet_data.tactician_damage = 0
    gauntlet_data.next_boss_override_counter = 0
    gauntlet_data.add_random_star_code_before_battle = 0
    gauntlet_data.last_known_current_hp = nil
    gauntlet_data.pa_patching_enabled = GENERIC_DEFS.PA_PATCHING_ENABLED


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

    CHIP_ICON.generate_image_cache(CHIP_DATA, CHIP_ID)
    CHIP_PICTURE.generate_image_cache(CHIP_DATA, CHIP_ID)

    state_logic.next_round()

    BUFF_GENERATOR.initialize()

    state_logic.initialize_folder()

    state_logic.update_printable_chip_names_in_folder()

    state_logic.update_argb_chip_icons_in_folder()

    gauntlet_data.current_state = gauntlet_data.GAME_STATE.LOAD_INITIAL
    
    input_handler.reset_all()

    state_logic.unpause_emu()
    -- Upon start, initialize the current round:
    --state_logic.next_round()


end

-- This function checks for the button combination A-B-L-R to reset the script.
function state_logic.check_reset()

    -- This convoluted way of checking makes sure that it only activates once, when the last button is pressed
    local soft_reset = false
             
    soft_reset = soft_reset or (input_handler.inputs_pressed["A"]
                            and input_handler.inputs_held["B"]
                            and input_handler.inputs_held["L"]
                            and input_handler.inputs_held["R"])

    soft_reset = soft_reset or (input_handler.inputs_held["A"]
                            and input_handler.inputs_pressed["B"]
                            and input_handler.inputs_held["L"]
                            and input_handler.inputs_held["R"])
                           
    soft_reset = soft_reset or (input_handler.inputs_held["A"]
                            and input_handler.inputs_held["B"]
                            and input_handler.inputs_pressed["L"]
                            and input_handler.inputs_held["R"])

    soft_reset = soft_reset or (input_handler.inputs_held["A"]
                            and input_handler.inputs_held["B"]
                            and input_handler.inputs_held["L"]
                            and input_handler.inputs_pressed["R"])                  

    if soft_reset or state_logic.reset or state_logic.network_reset then
        print("Soft-Reset!")
        --print("soft_reset: ", soft_reset)
        --print("state_logic.reset: ", state_logic.reset)


        soft_reset = false
        state_logic.reset = false

        if state_logic.network_handler.is_connected and gauntlet_data.main_player == 1 and state_logic.network_reset == false then
            local send_data = {}
            send_data.SOFT_RESET = 1
            send_data.GBA_FRAME = gauntlet_data.total_gba_frame_count
            send_data.MENU_FRAME = gauntlet_data.total_frame_count
            

            state_logic.network_handler.produce_send_buffer(json.encode(send_data) .. "\n")

            --print("Sent soft reset: ")
            --print(send_data)

            -- Send network buffer values, if they exist, because we reset the network buffers just a couple of instructions later.
            while state_logic.network_handler.consume_send_buffer() do
            
            end
        end

        state_logic.network_reset = false

        gauntlet_data.current_input = nil

        if gauntlet_data.statistics_container ~= nil then

            -- Just update it again, don't care if we possibly have duplicate entries.
            --state_logic.update_battle_statistics()
            state_logic.export_run_statistics()

        end

        local current_time = os.time()

        if state_logic.last_soft_reset ~= nil and current_time - state_logic.last_soft_reset < 2 then
            return false
        end

        state_logic.last_soft_reset = os.time()
        state_logic.initialize()

        return true
    end

    return false
end

function state_logic.randomize_snecko_folder_codes(folder)

    if DEBUG_STATE_LOGIC == 1 then
        print("randomize_snecko_folder_codes")
    end

    for chip_idx = 1,#folder do

        if (gauntlet_data.snecko_eye_randomize_asterisk == 0 and folder[chip_idx].CODE == CHIP_CODE.Asterisk) then 
        else
            folder[chip_idx].CODE = gauntlet_data.math.random_named("SNECKO_EYE", CHIP_CODE.A, gauntlet_data.snecko_eye_number_of_codes)
        end
      
    end

end

function state_logic.update_battle_statistics()

    if DEBUG_STATE_LOGIC == 1 then
        print("update_battle_statistics")
    end

    if state_logic.current_battle < 2 then
        return
    end

    gauntlet_data.current_hp = io_utils.readword(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_LOADING)

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

    if state_logic.battle_data[state_logic.current_battle - 1] ~= nil then
        for k, v in pairs(state_logic.battle_data[state_logic.current_battle - 1].ENTITIES) do
            if k ~= 0 then
                entities[k] = v.ID
            end  
        end
    end

    for k, v in pairs(state_logic.activated_buffs) do
        buff_descriptions[#buff_descriptions + 1] = v:get_brief_description(state_logic.current_battle)
    end


    
    gauntlet_data.statistics_container[#gauntlet_data.statistics_container + 1] = 
    {
        GAME_ID = GAME_ID,
        RANDOM_SEED = deepcopy(gauntlet_data.random_seed),
        CURRENT_HP = deepcopy(gauntlet_data.current_hp),
        ACTIVATED_BUFFS = deepcopy(activated_buffs),
        DROPPED_BUFFS = deepcopy(dropped_buffs),
        DROPPED_CHIPS = deepcopy(dropped_chips),
        PICKED_CHIP = deepcopy(picked_chip),
        CURRENT_FOLDER = deepcopy(current_folder),
        ENTITIES = deepcopy(entities),
        LOST_HP = deepcopy(state_logic.stats_lost_hp),
        REPLACED_CHIP = deepcopy(state_logic.replaced_chip),
        BATTLE_STAGE = deepcopy(gauntlet_data.battle_stages[state_logic.current_battle - 1]),
        ACTIVATED_BUFF_DESCRIPTIONS = deepcopy(buff_descriptions),
        DIFFICULTY = deepcopy(gauntlet_data.difficulty.NAME)
    }

    --print(gauntlet_data.statistics_container[#gauntlet_data.statistics_container])
    
    --print(json.encode(gauntlet_data.statistics_container[#gauntlet_data.statistics_container]))

end

function state_logic.patch_before_battle_start()

    if DEBUG_STATE_LOGIC == 1 then
        print("patch_before_battle_start")
    end

    
    input_handler.current_input_state = nil
    gauntlet_data.total_gba_frame_count = 0

    
    -- Also write an additional file with another (synced) random number so that the additional music player tool works for draft music.
    local random_number = 0
    
    local file = state_logic.try_open_file("gauntlet_draft_music.txt", "w")
    if file ~= nil then
        print("Resetting random music txt: " .. random_number)
        file:write(random_number)
        file:flush()
        file:close()
    else
        print("RESET DRAFT MUSIC TXT NIL!")
    end
    

    -- Patch folder with all new stuff.
    -- state_logic.randomize_folder()

    -- Fire events for buffs
    for k, v in pairs(state_logic.activated_buffs) do
        if v.ON_PATCH_BEFORE_BATTLE_START_CALLBACK ~= nil then
            v:on_patch_before_battle_start(state_logic, gauntlet_data)
        end
    end

    -- TODO: check if this breaks anything. It shouldn't, as we always only copy after a buff is taken.
    state_logic.compute_temporary_chip_changes()

    -- Update statistics for this round

    state_logic.update_battle_statistics()

    if gauntlet_data.snecko_eye_enabled == 1 then

        -- Randomize folder codes
        state_logic.randomize_snecko_folder_codes(gauntlet_data.current_folder)

    end

    io_utils.patch_folder(gauntlet_data.current_folder, GENERIC_DEFS.FOLDER_START_ADDRESS_RAM, gauntlet_data)

    
    -- Get spectator chip

    if state_logic.network_handler.is_connected and gauntlet_data.main_player == 0 then
        gauntlet_data.spectator_chip = gauntlet_data.current_folder[gauntlet_data.math.random_spectator_chip(1, #gauntlet_data.current_folder)]
        -- Call the random_spectator_chip twice to keep the offset between players and have different spec chips.
        gauntlet_data.math.random_spectator_chip(1, #gauntlet_data.current_folder)
        gauntlet_data.spectator_chip.PRINT_NAME = state_logic.get_printable_chip_name(gauntlet_data.spectator_chip)
        gauntlet_data.spectator_chip.ARGB_ICON = state_logic.get_argb_icon(gauntlet_data.spectator_chip)
        --print("Spectator Chip: ")
        --print(gauntlet_data.spectator_chip)
        gauntlet_data.spectator_chip_sent = false
    else
        gauntlet_data.spectator_chip = nil
    end


    local new_battle_data = nil

    if state_logic.current_battle % GAUNTLET_DEFS.BOSS_BATTLE_INTERVAL == 0 then
        new_battle_data = battle_data_generator.random_from_battle(state_logic.current_battle, gauntlet_data.next_boss, gauntlet_data.battle_stages[state_logic.current_battle])
        gauntlet_data.next_boss = battle_data_generator.random_boss(math.floor((state_logic.current_battle + GAUNTLET_DEFS.BOSS_BATTLE_INTERVAL) / GAUNTLET_DEFS.BOSS_BATTLE_INTERVAL) * GAUNTLET_DEFS.BOSS_BATTLE_INTERVAL)
    else
        if gauntlet_data.next_boss_override_counter > 0 then
            gauntlet_data.next_boss_override_counter = gauntlet_data.next_boss_override_counter - 1
            new_battle_data = battle_data_generator.random_from_battle(state_logic.current_battle, gauntlet_data.next_boss, gauntlet_data.battle_stages[state_logic.current_battle])
            gauntlet_data.next_boss = battle_data_generator.random_boss(math.floor((state_logic.current_battle + GAUNTLET_DEFS.BOSS_BATTLE_INTERVAL) / GAUNTLET_DEFS.BOSS_BATTLE_INTERVAL) * GAUNTLET_DEFS.BOSS_BATTLE_INTERVAL)
        else
            new_battle_data = battle_data_generator.random_from_battle(state_logic.current_battle, nil, gauntlet_data.battle_stages[state_logic.current_battle])
        end

    end
    
    
    -- This is used to determine drops.
    state_logic.battle_data[state_logic.current_battle] = new_battle_data


    io_utils.patch_battle(GENERIC_DEFS.FIRST_GAUNTLET_BATTLE_ADDRESS, new_battle_data)
    io_utils.patch_entity_data(state_logic.battle_data[state_logic.current_battle].ENTITIES)
    state_logic.current_battle = state_logic.current_battle + 1
    state_logic.battle_pointer_index = state_logic.battle_pointer_index + 1
    state_logic.update_printable_chip_names_in_folder()
    state_logic.update_argb_chip_icons_in_folder()
    
    io_utils.set_stage(gauntlet_data.stage) 
    
    -- TODO_REFACTOR: create an io_utils method that performs a nil check on the address and ignores the value if the address is nil
    -- TODO_REFACTOR: only call writebyte/write_u16/etc. from io_utils in all files.
    io_utils.writebyte(GENERIC_DEFS.AIRSHOES_ADDRESS, gauntlet_data.mega_AirShoes)
    io_utils.writebyte(GENERIC_DEFS.FASTGAUGE_ADDRESS, gauntlet_data.mega_FastGauge)
    io_utils.writebyte(GENERIC_DEFS.UNDERSHIRT_ADDRESS, gauntlet_data.mega_UnderShirt)
    io_utils.writebyte(GENERIC_DEFS.SUPERARMOR_ADDRESS, gauntlet_data.mega_SuperArmor)
    io_utils.writebyte(GENERIC_DEFS.ATTACKPLUS_ADDRESS, gauntlet_data.mega_AttackPlus)
    io_utils.writebyte(GENERIC_DEFS.CHARGEPLUS_ADDRESS, gauntlet_data.mega_ChargePlus)
    io_utils.writebyte(GENERIC_DEFS.SPEEDPLUS_ADDRESS, gauntlet_data.mega_SpeedPlus)
    io_utils.writebyte(GENERIC_DEFS.WEAPONLEVELPLUS_ADDRESS, gauntlet_data.mega_WeaponLevelPlus)
    io_utils.writebyte(GENERIC_DEFS.FLOATSHOES_ADDRESS, gauntlet_data.mega_FloatShoes)
    io_utils.writebyte(GENERIC_DEFS.BREAKBUSTER_ADDRESS, gauntlet_data.mega_BreakBuster)
    io_utils.writebyte(GENERIC_DEFS.BREAKCHARGE_ADDRESS, gauntlet_data.mega_BreakCharge)
    io_utils.writebyte(GENERIC_DEFS.DARKLICENSE_ADDRESS, gauntlet_data.mega_DarkLicense)
    io_utils.writebyte(GENERIC_DEFS.REFLECT_ADDRESS, gauntlet_data.mega_Reflect)

    -- Set the current HP to the last known value
    io_utils.writeword(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_LOADING, gauntlet_data.last_known_current_hp)

    -- Read current HP and apply regeneration
    if gauntlet_data.mega_regen_after_battle_relative_to_max ~= 0 then

        gauntlet_data.current_hp = io_utils.readword(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_LOADING)

        print("Regenerator current HP before regen " .. tostring(gauntlet_data.current_hp))

        gauntlet_data.current_hp = math.floor(gauntlet_data.current_hp + gauntlet_data.mega_max_hp * gauntlet_data.mega_regen_after_battle_relative_to_max)

        if gauntlet_data.current_hp > gauntlet_data.mega_max_hp then
            gauntlet_data.current_hp = gauntlet_data.mega_max_hp
        end

        print("Regenerator current HP after regen " .. tostring(gauntlet_data.current_hp))

        io_utils.writeword(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_LOADING, gauntlet_data.current_hp)
    end

    io_utils.writeword(GENERIC_DEFS.MEGA_MAX_HP_ADDRESS_DURING_LOADING, gauntlet_data.mega_max_hp)
    --print("Wrote hp: " .. tostring(gauntlet_data.mega_max_hp))
    -- TODO_REFACTOR: of course this is its own function...
    io_utils.change_megaMan_style(gauntlet_data.mega_style)

    io_utils.change_number_of_cust_screen_chips(gauntlet_data.cust_style_number_of_chips + gauntlet_data.cust_screen_number_of_chips)  
    state_logic.export_run_statistics()

    state_logic.rewind_savestate = memorysavestate.savecorestate()

    state_logic.main_loop_frame_count = 0

    -- Reset time compression counter
    --print("set number of time compressions to " .. gauntlet_data.number_of_time_compressions)
    gauntlet_data.current_battle_number_of_time_compressions = gauntlet_data.number_of_time_compressions

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

    if DEBUG_STATE_LOGIC == 1 then
        print("damage_taken")
    end
    
    gauntlet_data.has_mega_been_hit = 1
    gauntlet_data.number_of_perfect_fights = 0

end

function state_logic.illusion_of_choice_randomize_selected_chip()

    if DEBUG_STATE_LOGIC == 1 then
        print("illusion_of_choice_randomize_selected_chip")
    end

    local can_replace = false

    while can_replace == false do
        
        state_logic.folder_chip_render_index = gauntlet_data.math.random_named("ILLUSION_OF_CHOICE", 1, #gauntlet_data.current_folder)

        if state_logic.dropped_chip.ID == -1 then
            print("Dropped chip ID == -1")
            return
        end

        local dropped_chip_data = CHIP_DATA[state_logic.dropped_chip.ID]

        if dropped_chip_data == nil then
            print("Dropped chip data == nil")
            return
        end

        -- TODO_REFACTOR: make sure CHIP_RANKING is the same in all games / refactor into a better API, I guess
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
    if gauntlet_data.current_battle_number_of_time_compressions > 0 and state_logic.main_loop_frame_count > gauntlet_data.time_compression_delay then
        state_logic.hp_loaded = 0
        --state_logic.damage_taken()
        gauntlet_data.current_battle_number_of_time_compressions = gauntlet_data.current_battle_number_of_time_compressions - 1
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

    -- TODO_REFACTOR: make sure MEGA_CURRENT_HP_ADDRESS_DURING_BATTLE behaves the same way in all games / refactor into a better API
    print("Reset in GAME_STATE.RUNNING, number_of_virus_entities = " .. gauntlet_data.number_of_entities)
    print("MEGA_CURRENT_HP_ADDRESS [NUM_ENTITIES] " .. io_utils.readword(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_BATTLE[gauntlet_data.number_of_entities]))
    print("MEGA_CURRENT_HP_ADDRESS [1] " .. io_utils.readword(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_BATTLE[1]))
    print("MEGA_CURRENT_HP_ADDRESS [2] " .. io_utils.readword(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_BATTLE[2]))
    print("MEGA_CURRENT_HP_ADDRESS [3] " .. io_utils.readword(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_BATTLE[3]))
    print("MEGA_CURRENT_HP_ADDRESS [4] " .. io_utils.readword(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_BATTLE[4]))
    


    --state_logic.initialize()

    state_logic.reset = true
end


function state_logic.set_cust_gauge_value(value)
    io_utils.writebyte(GENERIC_DEFS.CUST_GAUGE_VALUE_ADDRESS, value)
end

function state_logic.damage_random_enemy(damage)

    if DEBUG_STATE_LOGIC == 1 then
        print("damage_random_enemy")
    end

    -- TODO_REFACTOR: make sure this behaves the same way in all games / refactor into a better API
    local enemy_addresses = GENERIC_DEFS.ENEMY_CURRENT_HP_ADDRESS_DURING_BATTLE[gauntlet_data.number_of_entities]

    local enemy_hp_values = {}
    local enemy_ewram_addresses = {}

    for key, address in pairs(enemy_addresses) do
        local ewram_address = address
        local enemy_hp_value = io_utils.readword(ewram_address)
        if enemy_hp_value ~= 0 then
            enemy_hp_values[#enemy_hp_values + 1] = enemy_hp_value
            enemy_ewram_addresses[#enemy_ewram_addresses + 1] = ewram_address
        end
    end

    -- Choose a random one
    local chosen_rng_index = gauntlet_data.math.random_in_battle(1, #enemy_hp_values)
    --print("Chosen RNG Index in battle: " .. tostring(chosen_rng_index))
    if chosen_rng_index == 0 then
        chosen_rng_index = 1
    end

    local chosen_ewram_address = enemy_ewram_addresses[chosen_rng_index]

    

    local new_enemy_hp_value = enemy_hp_values[chosen_rng_index] - damage

    if new_enemy_hp_value < 0 then
        new_enemy_hp_value = 0
    end

    -- Write back new HP
    io_utils.writeword(chosen_ewram_address, new_enemy_hp_value)

end


function state_logic.damage_all_enemies(damage)

    if DEBUG_STATE_LOGIC == 1 then
        print("damage_all_enemies")
    end

    -- TODO_REFACTOR: make sure this behaves the same way in all games / refactor into a better API
    local enemy_addresses = GENERIC_DEFS.ENEMY_CURRENT_HP_ADDRESS_DURING_BATTLE[gauntlet_data.number_of_entities]

    for key, address in pairs(enemy_addresses) do
        local ewram_address = address
        local enemy_hp_value = io_utils.readword(ewram_address)
        if enemy_hp_value ~= 0 then
            local new_enemy_hp_value = enemy_hp_value - damage

            if new_enemy_hp_value < 0 then
                new_enemy_hp_value = 0
            end

            -- Write back new HP
            io_utils.writeword(ewram_address, new_enemy_hp_value)

        end
    end
end

function state_logic.on_mega_damage_taken()
    --print("Damage taken! (Previous HP: " .. tostring(gauntlet_data.last_hp) .. ", Current HP: " .. tostring(gauntlet_data.current_hp) .. ", Max HP: " .. tostring(gauntlet_data.mega_max_hp) .. ")")
    if DEBUG_STATE_LOGIC == 1 then
        print("on_mega_damage_taken")
    end

    if gauntlet_data.current_battle_number_of_time_compressions > 0 and state_logic.main_loop_frame_count > gauntlet_data.time_compression_delay then
        state_logic.hp_loaded = 0
        gauntlet_data.current_battle_number_of_time_compressions = gauntlet_data.current_battle_number_of_time_compressions - 1
        --print("Time Compression: index: " .. tostring(((state_logic.main_loop_frame_count + 1) % gauntlet_data.time_compression_delay) + 1))
        --print("Time Compression: num savestates: " .. tostring(#state_logic.time_compression_savestates))
        --print("Time Compression: delay: " .. tostring(gauntlet_data.time_compression_delay))
        --print("Time Compression: frame count: " .. tostring(state_logic.main_loop_frame_count))
        memorysavestate.loadcorestate(state_logic.time_compression_savestates[((state_logic.main_loop_frame_count + 1) % gauntlet_data.time_compression_delay) + 1])
        --print("Time compression saved the damage!")
        return
    end

    -- Trigger this after time compression so that it saves perfectionist.
    state_logic.damage_taken()


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

    -- TODO_REFACTOR: make sure this behaves the same way in all games / refactor into a better API
    io_utils.writeword(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_BATTLE[gauntlet_data.number_of_entities], gauntlet_data.current_hp)

end

function state_logic.on_mega_heal()

    if DEBUG_STATE_LOGIC == 1 then
        print("on_mega_heal")
    end

    -- Compute healing difference
    local heal_diff = gauntlet_data.current_hp - gauntlet_data.last_hp
    gauntlet_data.current_hp = gauntlet_data.current_hp + math.floor(heal_diff * (gauntlet_data.healing_increase_mult))

    if gauntlet_data.current_hp > gauntlet_data.mega_max_hp then
        gauntlet_data.current_hp = gauntlet_data.mega_max_hp
    end


    -- TODO_REFACTOR: make sure this behaves the same way in all games / refactor into a better API
    io_utils.writeword(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_BATTLE[gauntlet_data.number_of_entities], gauntlet_data.current_hp)

end


function state_logic.on_mega_hp_change()

    if DEBUG_STATE_LOGIC == 1 then
        print("on_mega_hp_change")
    end

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

    if DEBUG_STATE_LOGIC == 1 then
        print("enemy_hp_regen")
    end

    gauntlet_data.enemies_hp_regen_accum = gauntlet_data.enemies_hp_regen_accum + gauntlet_data.enemies_hp_regen_per_frame

    if gauntlet_data.enemies_hp_regen_accum > 1 then

        gauntlet_data.enemies_hp_regen_accum = 0
        
        -- TODO_REFACTOR: make sure this behaves the same way in all games / refactor into a better API
        local enemy_addresses = GENERIC_DEFS.ENEMY_CURRENT_HP_ADDRESS_DURING_BATTLE[gauntlet_data.number_of_entities]

        for key, address in pairs(enemy_addresses) do
            local ewram_address = address
            local enemy_hp_value = io_utils.readword(ewram_address)
            local enemy_max_hp_value = io_utils.readword(ewram_address + 2)
            if enemy_hp_value ~= 0 then

                local new_enemy_hp_value = enemy_hp_value + 1

                if new_enemy_hp_value > enemy_max_hp_value then
                    new_enemy_hp_value = enemy_max_hp_value
                end

                -- Write back new HP
                io_utils.writeword(ewram_address, new_enemy_hp_value)

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

    -- Pen Nib
    multiplicative_damage_increase = multiplicative_damage_increase + gauntlet_data.pen_nib_bonus_damage

    

    --print("Add5: " .. tostring(additive_damage_increase))
    --print("Mul: " .. tostring(multiplicative_damage_increase))

    -- Now we can patch the current and next chip based on the held chip index
    

    local held_chip_id_addr = GENERIC_DEFS.IN_BATTLE_HELD_CHIP_IDS_ADDRESS
    local held_chip_damage_addr =  GENERIC_DEFS.IN_BATTLE_HELD_CHIP_DAMAGES_ADDRESS

    local chip_idx = gauntlet_data.current_battle_chip_index

    for chip_idx = 1, #gauntlet_data.held_chips do
        local chip = gauntlet_data.held_chips[chip_idx]

        if (chip ~= nil) then

            local current_chip_damage = chip.DAMAGE
            local current_chip_id = chip.ID
            if (current_chip_id ~= 0) then

                -- NOTE: this might need changing because of balancing reasons, as this is the ideal order
                local new_chip_damage = (current_chip_damage + additive_damage_increase) * (1.0 + multiplicative_damage_increase)

                --print("Chip ", chip, "New chip damage: ", new_chip_damage)

                if new_chip_damage < 0 then
                    new_chip_damage = 0
                end


                -- Patch new chip damage
                --if new_chip_damage ~= current_chip_damage then

                -- TODO_REFACTOR: make sure this behaves the same way in all games / refactor into a better API
                
                io_utils.writeword(held_chip_id_addr + ((chip_idx - 1) * 2), current_chip_id)
                io_utils.writeword(held_chip_damage_addr + ((chip_idx - 1) * 2), new_chip_damage)
                
    
                if gauntlet_data.update_held_chip_data == true then
                    io_utils.writebyte(GENERIC_DEFS.IN_BATTLE_NUMBER_OF_CHIPS_ADDRESS[gauntlet_data.number_of_entities], #gauntlet_data.held_chips - (gauntlet_data.current_battle_chip_index - 1))

                    -- Also patch the offset pointer in case we increase/decrease the held chips
                    io_utils.writebyte(GENERIC_DEFS.IN_BATTLE_CURRENT_CHIP_OFFSET_ADDRESS,  math.max(2 * (gauntlet_data.current_battle_chip_index - 1), 0))
                    gauntlet_data.update_held_chip_data = false
                end

                --end

            end

        end

    end

    
    

end

function state_logic.get_number_of_alive_enemies()

    -- TODO_REFACTOR: make sure this behaves the same way in all games / refactor into a better API
    local enemy_addresses = GENERIC_DEFS.ENEMY_CURRENT_HP_ADDRESS_DURING_BATTLE[gauntlet_data.number_of_entities]

    local enemy_hp_values = {}
    local enemy_ewram_addresses = {}


    gauntlet_data.number_enemies_alive = 0

    for key, address in pairs(enemy_addresses) do
        local ewram_address = address
        local enemy_hp_value = io_utils.readword(ewram_address)
        if enemy_hp_value ~= 0 then
            gauntlet_data.number_enemies_alive = gauntlet_data.number_enemies_alive + 1
        end
    end
end

function state_logic.get_current_custgauge_value()
    gauntlet_data.current_custgauge_value = io_utils.readbyte(GENERIC_DEFS.CUST_GAUGE_VALUE_ADDRESS)
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
        -- TODO_REFACTOR: make sure this behaves the same way in all games / refactor into a better API
        io_utils.writebyte(GENERIC_DEFS.CUST_GAUGE_VALUE_ADDRESS, gauntlet_data.current_custgauge_value)
    end

end

function state_logic.check_pause_screen()

    gauntlet_data.battle_paused = io_utils.readbyte(GENERIC_DEFS.IN_BATTLE_PAUSE_ADDRESS)
    gauntlet_data.battle_paused = gauntlet_data.battle_paused + io_utils.readbyte(GENERIC_DEFS.IN_BATTLE_TIMEFREEZE_ADDRESS)
    gauntlet_data.battle_paused = gauntlet_data.battle_paused + io_utils.readbyte(GENERIC_DEFS.IN_BATTLE_TIMEFREEZE_ADDRESS2)

end

function state_logic.check_in_battle_effects()

    state_logic.get_number_of_alive_enemies()

    state_logic.check_pause_screen()

    state_logic.in_battle_custgauge_effects()

    state_logic.in_battle_chip_effects()

end

function state_logic.on_first_cust_screen()

    if DEBUG_STATE_LOGIC == 1 then
        print("on_first_cust_screen")
    end
    --print ("First cust screen: " .. tostring(gauntlet_data.backstab_percentage_damage) .. ", " .. tostring(state_logic.current_battle - 1))

    if gauntlet_data.backstab_percentage_damage ~= 0 and (state_logic.current_battle - 1 ) % GAUNTLET_DEFS.BOSS_BATTLE_INTERVAL == 0 then

        -- TODO_REFACTOR: make sure this behaves the same in all games / refactor into a better API
        local enemy_addresses = GENERIC_DEFS.ENEMY_CURRENT_HP_ADDRESS_DURING_BATTLE[gauntlet_data.number_of_entities]

        local enemy_hp_values = {}
        local enemy_ewram_addresses = {}

        for key, address in pairs(enemy_addresses) do
            local ewram_address = address
            local enemy_hp_value = io_utils.readword(ewram_address)
            if enemy_hp_value ~= 0 then
                enemy_hp_values[#enemy_hp_values + 1] = enemy_hp_value
                enemy_ewram_addresses[#enemy_ewram_addresses + 1] = ewram_address
            end
        end

        --print ("damaging random enemy: " .. tostring(enemy_hp_values[1] * gauntlet_data.backstab_percentage_damage))
        -- Get enemy address
        state_logic.damage_random_enemy(enemy_hp_values[1] * gauntlet_data.backstab_percentage_damage)
    end

    -- Fire events for buffs
    for k, v in pairs(state_logic.activated_buffs) do
        if v.ON_FIRST_CUST_SCREEN_CALLBACK ~= nil then
            v:on_first_cust_screen(state_logic, gauntlet_data)
        end
    end


end

function state_logic.on_cust_screen_open()

    if DEBUG_STATE_LOGIC == 1 then
        print("on_cust_screen_open")
    end

    gauntlet_data.num_chips_in_battle = 0
    gauntlet_data.battle_phase = 0

    if gauntlet_data.cust_screen_was_opened == nil or gauntlet_data.cust_screen_was_opened == 0 then
        state_logic.on_first_cust_screen()
    end

    gauntlet_data.cust_screen_was_opened = 1
    gauntlet_data.current_custgauge_value = 0
    -- This is a canary value to make sure we can detect the cust screen confirm
    --memory.writebyte(GENERIC_DEFS.CUST_SCREEN_NUMBER_OF_CHIPS_ADDRESS - 0x02000000, 0xFF, "EWRAM")
    gauntlet_data.number_of_chosen_cust_chips = 0xFF

    --event.onmemoryexecute(state_logic.on_cust_screen_confirm, GENERIC_DEFS.CUST_SCREEN_CONFIRM_ADDRESS + 2, "on_cust_screen_confirm")

    --print("Cust screen opened")
end

function state_logic.on_cust_screen_closed()

    if DEBUG_STATE_LOGIC == 1 then
        print("on_cust_screen_closed")
    end

    --gauntlet_data.num_chips_in_battle = memory.readbyte(GENERIC_DEFS.IN_BATTLE_NUMBER_OF_CHIPS_ADDRESS[gauntlet_data.number_of_entities] - 0x02000000, "EWRAM")
    --print("Cust screen closed")

end



function state_logic.check_frame_events()

    -- Here, we check for events that can easily be polled every frame to save expensive event.onmemoryexecute hooks
    -- Check if we are in cust screen
    local is_cust_screen = io_utils.readbyte(GENERIC_DEFS.IN_BATTLE_IS_CUSTSCREEN_OPEN)

    if is_cust_screen == 1 and gauntlet_data.is_cust_screen == 0 then
        state_logic.on_cust_screen_open()
        gauntlet_data.is_cust_screen = is_cust_screen
    end

    if is_cust_screen == 0 and gauntlet_data.is_cust_screen == 1 then
        state_logic.on_cust_screen_closed()
        gauntlet_data.is_cust_screen = is_cust_screen
    end


    
    -- Check for cust screen confirm (this is commented out because it doesn't work with PA patching unfortunately, may need to look into it again)
    --if gauntlet_data.is_cust_screen == 1 and gauntlet_data.cust_screen_was_opened ~= 0 then

    --   local num_chips = memory.readbyte(GENERIC_DEFS.CUST_SCREEN_NUMBER_OF_CHIPS_ADDRESS - 0x02000000, "EWRAM")

        
    --    if num_chips ~= 0xFF and gauntlet_data.number_of_chosen_cust_chips == 0xFF then
            --print("ON CUST SCREEN CONFIRM")
    --        gauntlet_data.number_of_chosen_cust_chips = num_chips
    --        state_logic.on_cust_screen_confirm()
    --    end

    --end

    
    -- Check difference to gauntlet_data.num_chips
    -- TODO: refactor into "on_chip_use parts"
    if gauntlet_data.is_cust_screen == 0 and gauntlet_data.cust_screen_was_opened ~= 0 then 
        
        -- Check for "on_chip_use"
        -- TODO_REFACTOR: make sure this behaves the same in all games / refactor into a better API
        local num_chips = io_utils.readbyte(GENERIC_DEFS.IN_BATTLE_NUMBER_OF_CHIPS_ADDRESS[gauntlet_data.number_of_entities])

        if gauntlet_data.battle_phase == 0 then
            state_logic.on_battle_phase_start()

            if num_chips ~= 0 then
                gauntlet_data.num_chips_in_battle = num_chips
            end

        end

        

        if gauntlet_data.battle_phase ~= 0 then
            --print("num chips: " .. tostring(num_chips) .. ", in_battle: " .. tostring(gauntlet_data.num_chips_in_battle))
            state_logic.during_battle_phase(num_chips)
        end

        
    end


    
    

    if state_logic.network_handler.is_connected == true and gauntlet_data.main_player == 1 and gauntlet_data.current_input ~= nil and gauntlet_data.current_input.SPECTATOR_CHIP ~= nil then

        --print("We received a spectator chip as host!")
        --print(gauntlet_data.current_input.SPECTATOR_CHIP)

        if gauntlet_data.battle_phase == 0 then
            --local send_data = {}
            --send_data.NO_SPEC_CHIP = 1

            gauntlet_data.NO_SPEC_CHIP = 1

            -- Return a message that says that we're not able to use the chip
            --state_logic.network_handler.produce_send_buffer(json.encode(send_data) .. "\n")
            
            --gauntlet_data.current_input = nil
        else

            -- Yay, we're in the battle phase! 
            -- We can actually patch the spectator chip
            
            gauntlet_data.spectator_chip = gauntlet_data.current_input.SPECTATOR_CHIP
            state_logic.patch_spectator_chip()
            local current_pad = joypad.get()
            current_pad.A = true
            input_handler.inputs_delta.A = true

            joypad.set(current_pad)
            -- Send 

            --gauntlet_data.current_input = nil
        end


    end

    if state_logic.network_handler.is_connected == true and gauntlet_data.main_player == 0 and gauntlet_data.current_input ~= nil and gauntlet_data.current_input.NO_SPEC_CHIP ~= nil then

        print("Spectator chip not usable - resetting!")
        gauntlet_data.current_input.NO_SPEC_CHIP = nil
        gauntlet_data.spectator_chip_sent = false
    end

    if state_logic.network_handler.is_connected == true and gauntlet_data.main_player == 0 and gauntlet_data.use_spectator_chip == true then

        --print("Spectator chip used by server on this frame, using it on the client!")
        state_logic.patch_spectator_chip()

        gauntlet_data.use_spectator_chip = false

        gauntlet_data.spectator_chip_sent = false
    end


end

function state_logic.patch_spectator_chip()
        --print("Pressed A")
        --print(gauntlet_data.spectator_chip)
        --print(gauntlet_data.held_chips)

        if gauntlet_data.spectator_chip ~= nil then


            if gauntlet_data.current_battle_chip_index > 1 then
                -- We have already used a chip, we can simply overwrite the previous one
                gauntlet_data.current_battle_chip_index = gauntlet_data.current_battle_chip_index - 1
                gauntlet_data.held_chips[gauntlet_data.current_battle_chip_index] = {}
                gauntlet_data.held_chips[gauntlet_data.current_battle_chip_index].ID = gauntlet_data.spectator_chip.ID
                gauntlet_data.held_chips[gauntlet_data.current_battle_chip_index].DAMAGE = CHIP_DATA[gauntlet_data.spectator_chip.ID].DAMAGE
                
                --print("Patched spectator chip: " .. CHIP_NAME[gauntlet_data.held_chips[gauntlet_data.current_battle_chip_index].ID] .. " ; " .. gauntlet_data.held_chips[gauntlet_data.current_battle_chip_index].ID .. " ; " .. gauntlet_data.held_chips[gauntlet_data.current_battle_chip_index].DAMAGE)
                
                gauntlet_data.spectator_chip = nil

                gauntlet_data.update_held_chip_data = true

                gauntlet_data.num_chips_in_battle = gauntlet_data.num_chips_in_battle + 1

            elseif #gauntlet_data.held_chips < 5 then
                -- We have less then 5 chips in total, we can simply move them forward and add the new chip in the current position
                --print("Changing held chips")

                --print("before: ")
                --for key, value in pairs(gauntlet_data.held_chips) do
                --    print(key, value)
                --end

                if #gauntlet_data.held_chips ~= 0 then
                    

                    for chip_idx = #gauntlet_data.held_chips + 1, gauntlet_data.current_battle_chip_index + 1, -1 do
                        gauntlet_data.held_chips[chip_idx] = deepcopy(gauntlet_data.held_chips[chip_idx - 1])
                    end

                end

                gauntlet_data.held_chips[gauntlet_data.current_battle_chip_index] = {}
                gauntlet_data.held_chips[gauntlet_data.current_battle_chip_index].ID = gauntlet_data.spectator_chip.ID
                gauntlet_data.held_chips[gauntlet_data.current_battle_chip_index].DAMAGE = CHIP_DATA[gauntlet_data.spectator_chip.ID].DAMAGE

                --print("Patched spectator chip: " .. CHIP_NAME[gauntlet_data.held_chips[gauntlet_data.current_battle_chip_index].ID] .. " ; " .. gauntlet_data.held_chips[gauntlet_data.current_battle_chip_index].ID .. " ; " .. gauntlet_data.held_chips[gauntlet_data.current_battle_chip_index].DAMAGE)      
               

                --gauntlet_data.num_chips_in_battle = #gauntlet_data.held_chips - (gauntlet_data.current_battle_chip_index - 1)

                gauntlet_data.spectator_chip = nil

                gauntlet_data.update_held_chip_data = true

                if gauntlet_data.current_battle_chip_index == 1 then
                    gauntlet_data.num_chips_in_battle = gauntlet_data.num_chips_in_battle + 1
                end

                --print("after: ")
                --for key, value in pairs(gauntlet_data.held_chips) do
                --    print(key, value)
                --end

                
            else
                -- We can't use the chip.

            end


        end

end

function state_logic.during_battle_phase(num_chips)

    if num_chips < gauntlet_data.num_chips_in_battle or gauntlet_data.trigger_on_chip_use == true then

        state_logic.on_chip_use()
        -- TODO: what happens if we e.g. have 3 chips, enter the cust screen and then select 0 ?
        --       we need a variable that tells us if we are in the cust screen.
        --       00C0C9 is a flag that's 1 if the cust screen gfx are shown
        --       34420 or 34432 are probably good candidates, they togggle immediately after pressing L/R
        --       we *might* be able to use them for detecting cust confirm
        --       00A5C8, 00A5D8, 00A5E8 seem to be possible candidates for detecting battle phase start
        --       00A588, 00A598, 00A5A8, 00A5B8
        --       00F802 seems like a good candidate for cust confirm, contains number of selected chips directly after confirming
        --       otherwise we can detect battle phase start by checking when 006CAC goes from 1 -> 0
        gauntlet_data.num_chips_in_battle = num_chips
        gauntlet_data.trigger_on_chip_use = false
    end

    
    
    if gauntlet_data.current_inputs.A == true and gauntlet_data.main_player == 0 and gauntlet_data.anything_from_networked_inputs == false and gauntlet_data.anything_from_last_networked_inputs == false then
        -- This sucks, but it's the only reasonable way to get inputs from the spectator while it receives inputs from the controller
        -- The main reason I have to do this is because Bizhawk doesn't clear the joypad inputs between frames (apparently?!) when you set them via code.
        -- It takes 2 frames for them to be cleared.
        -- This way, we can input commands from the spectator if there is no input this or last frame from the controller.
        --print("A pressed!")

        -- TODO:
        -- We want the spectator to have 1 random chip from the folder, which gets used on the controller side when A is pressed.
        -- GUI needs to show chip name + icon overlay on spectator side.
        -- The chip needs to be determined randomly. This is done on the spectator side when the battle starts after replacing the folder chips. 
        -- Once the client presses the button, it sends a message with a "CHIP_USE" entry to the controller.
        -- The controller gets this message (it also reads messages during the game loop).
        -- After getting the message, the controller executes the code (probably by replacing the current chip, using it, and then adding it back again? might need to patch number of chips in hand...)
        -- It then sends a message back to the client with "CHIP_USE" entry, which the client executes in identical fashion on the same frame.
        -- Main difficulty: figure out if we can add/change chip hand dynamically. Adding a chip and using it, with it simply failing if the hand contains 5 chips (which we can check on the client)
        -- During that frame, we have to force the "A" button since we use the chip. 
        -- Issues: what if we're stunlocked -> we can't use the chip. Is this an issue though? Then it'll be just a slot-in and might still be useful?
        -- gauntlet_data.held_chips = {} is useful. need to figure out where the sprite data is stored though.
    end

    -- gauntlet_data.main_player == 0 and 
    if gauntlet_data.spectator_chip ~= nil and gauntlet_data.spectator_chip_sent == false and gauntlet_data.main_player == 0 and gauntlet_data.current_inputs.A == true and gauntlet_data.anything_from_networked_inputs == false and gauntlet_data.anything_from_last_networked_inputs == false then
        
        --state_logic.patch_spectator_chip()

        -- TODO: send message to server, who then does the thing

        if #gauntlet_data.held_chips < 5 or gauntlet_data.current_battle_chip_index > 1 then
            local send_data = {}
            send_data.SPECTATOR_CHIP = {}

            send_data.SPECTATOR_CHIP.ID = deepcopy(gauntlet_data.spectator_chip.ID)
            send_data.SPECTATOR_CHIP.DAMAGE = deepcopy(gauntlet_data.spectator_chip.DAMAGE)
            
            -- deepcopy(gauntlet_data.spectator_chip)

            state_logic.network_handler.produce_send_buffer(json.encode(send_data) .. "\n")

            gauntlet_data.spectator_chip_sent = true
        end
    end



end


function state_logic.pause_emu()

    if state_logic.do_not_pause == true then
        return
    end

    client.pause()
    state_logic.emu_paused = true
end

function state_logic.unpause_emu()

    if state_logic.emu_paused == true then
        client.unpause()
        state_logic.emu_paused = false
    end
end

function state_logic.on_frame_end()

    if gauntlet_data.current_state == gauntlet_data.GAME_STATE.RUNNING then

        if emu.islagged() then
            -- If we have a lag frame, we *must* skip the main loop in order to not increment the in-game frame count.
            return
        end

        -- We only run frame-by-frame. We cannot use emu.frameadvance() because this conflicts with our yield main loop... :/
        if state_logic.network_handler.is_connected and gauntlet_data.main_player == 0 and state_logic.do_not_pause ~= true then

            -- Only pause if we do not have at least another frame in the buffer that is correct.
            --print("on_frame_end")
            local ret_data = state_logic.apply_networked_inputs_ingame()

            if state_logic.unpause_once_ingame == true then
                state_logic.unpause_once_ingame = false
            else
                -- Only pause client if we didn't get matching inputs for the next frame.
                state_logic.pause_emu()
                --print("after pause")

                --print("inputs: ")
                --print(gauntlet_data.current_input)
                --print("current frame: ")
                --print(gauntlet_data.total_gba_frame_count)

                client.exactsleep(100)
                --print("after exactsleep")
                -- We also sleep for 100 ms so that the client has time to buffer.
            end

            
            if ret_data ~= nil then
                --print("Received actual ret data when reading next frames' data - rewinding")
                state_logic.network_handler.rewind_receive_buffer_consumer_index()
                gauntlet_data.current_input = nil
            end


            --client.pause()
        end

    end

end

function state_logic.main_frame_loop()


    -- This loop runs at the GBA framerate.

    if gauntlet_data.current_state == gauntlet_data.GAME_STATE.RUNNING then

        if emu.islagged() then
            -- If we have a lag frame, we *must* skip the main loop in order to not increment the in-game frame count.
            return
        end

            
        --if state_logic.network_handler.is_connected and gauntlet_data.main_player == 0 then
            
            --gauntlet_data.sub_player_delay_counter = gauntlet_data.sub_player_delay_counter + 1

            --if gauntlet_data.sub_player_delay_counter < gauntlet_data.sub_player_ingame_delay_frames then
                -- Reload rewind savestate until we "delayed enough"
                --print("reloading savestate")
                
                --memorysavestate.loadcorestate(state_logic.rewind_savestate)
                --return
            --end
        --end

        
        state_logic.apply_prerecorded_inputs_ingame()

        gauntlet_data.current_inputs = joypad.get()

        if state_logic.network_handler.is_connected == false then
            if gauntlet_data.prerecorded_inputs == nil then
                input_handler.current_input_state = gauntlet_data.current_inputs
            end
        else
            if gauntlet_data.main_player == 1 then
                input_handler.current_input_state = gauntlet_data.current_inputs
            end
        end

        gauntlet_data.anything_pressed = false

        for key, value in pairs(gauntlet_data.current_inputs) do
            if value == true then
                gauntlet_data.anything_pressed = true
                break
            end
        end
        
        gauntlet_data.anything_from_last_networked_inputs = false

        if input_handler.current_input_state ~= nil and gauntlet_data.main_player == 0 then
            for key, value in pairs(input_handler.current_input_state) do
                if value == true then
                    gauntlet_data.anything_from_last_networked_inputs = true
                    break
                end
            end
        end

        --state_logic.apply_networked_inputs_ingame()

        if gauntlet_data.main_player == 0 then
            if state_logic.apply_current_networked_input_ingame() == false then
                --print("WE RETURNED TRUE AFTER APPLYING NETWORKED INPUT!")
                return
            else
                --print("WE RETURNED FALSE")
            end
        end

        
        gauntlet_data.anything_from_networked_inputs = false

        if input_handler.current_input_state ~= nil and gauntlet_data.main_player == 0 then
 

            for key, value in pairs(input_handler.current_input_state) do
                if value == true then
                    gauntlet_data.anything_from_networked_inputs = true
                    break
                end
            end

            if gauntlet_data.anything_from_networked_inputs == true or gauntlet_data.anything_pressed == true then
                joypad.set(input_handler.current_input_state)
            end
        end
        

        -- TODO: check if we're using recorded, networked or raw inputs
        input_handler.handle_inputs()

        
        if state_logic.check_reset() then
            return
        end


        gauntlet_data.number_of_entities = (state_logic.battle_data[state_logic.current_battle - 1].NUM_ENTITIES)

        state_logic.check_frame_events()


        local recorded_input_table = deepcopy(input_handler.inputs_delta)

        recorded_input_table.GBA_FRAME = gauntlet_data.total_gba_frame_count

        if input_handler.has_delta == true then
            gauntlet_data.recorded_input_deltas[#gauntlet_data.recorded_input_deltas + 1] = recorded_input_table
        end

        
        -- Enter current menu inputs into network buffer
        if gauntlet_data.main_player == 1 then
            

            if gauntlet_data.current_input ~= nil and gauntlet_data.current_input.SPECTATOR_CHIP ~= nil and gauntlet_data.NO_SPEC_CHIP == nil then
                -- We used the spec chip this frame - send it to the client
                recorded_input_table.SPECTATOR_CHIP = gauntlet_data.current_input.SPECTATOR_CHIP
                gauntlet_data.spectator_chip = nil
                --print("Used spec chip this frame, sending to client")
            end

            if gauntlet_data.NO_SPEC_CHIP ~= nil then
                -- We were not able to use the spec chip
                recorded_input_table.NO_SPEC_CHIP = 1
                gauntlet_data.NO_SPEC_CHIP = nil
                print("No spec chip this frame, sending to client")
            end
            
            --print("sending: ")
            --print(recorded_input_table)
            --print(" at frame " .. gauntlet_data.total_gba_frame_count)

            gauntlet_data.current_input = nil

            -- We always send messages, because we also need them so the spectator can sync.
            --if input_handler.has_delta == true or recorded_input_table.SPECTATOR_CHIP ~= nil or recorded_input_table.NO_SPEC_CHIP ~= nil then
            --print("Sending:")
            local payload = json.encode(recorded_input_table) .. "\n"
            --print(payload)
            state_logic.network_handler.produce_send_buffer(payload)
            --end
        end


        if gauntlet_data.current_battle_number_of_time_compressions > 0 and gauntlet_data.battle_phase ~= 0 then
            -- We compute the savestate only every x frames to save computing power
            if (state_logic.main_loop_frame_count % gauntlet_data.time_compression_frame_interval) == 0 then
                state_logic.time_compression_savestates[(state_logic.main_loop_frame_count % gauntlet_data.time_compression_delay) + 1] = memorysavestate.savecorestate()
            else
                state_logic.time_compression_savestates[(state_logic.main_loop_frame_count % gauntlet_data.time_compression_delay) + 1] = state_logic.time_compression_savestates[((state_logic.main_loop_frame_count - 1) % gauntlet_data.time_compression_delay) + 1]
            end
        end
        
        -- Check if mega gets hit for certain buffs
        
        
        --print("Number of entities in battle: " .. tostring(gauntlet_data.number_of_entities))
        -- TODO_REFACTOR: make sure this behaves the same in all games / refactor into a better API
        gauntlet_data.current_hp = io_utils.readword(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_BATTLE[gauntlet_data.number_of_entities])

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
            gauntlet_data.last_known_current_hp = gauntlet_data.current_hp
        end

        state_logic.check_in_battle_effects()

        -- Check enemy HP regen
        -- TODO_REFACTOR: this is currently a special if for the single buff that trades pausing for enemy HP regen...
        if gauntlet_data.enemies_hp_regen_per_frame ~= 0 and gauntlet_data.battle_paused == 0 then
            state_logic.enemy_hp_regen()
        end

    
        --print("gauntlet_data.total_gba_frame_count ", gauntlet_data.total_gba_frame_count)
        --print("lag frame? ", emu.islagged())
        state_logic.main_loop_frame_count = state_logic.main_loop_frame_count + 1

        -- Fire events for buffs
        for k, v in pairs(state_logic.activated_buffs) do
            if v.UPDATE_CALLBACK ~= nil then
                v:update(state_logic, gauntlet_data)
            end
        end

        --print("GBA count before: " .. gauntlet_data.total_gba_frame_count)

        gauntlet_data.total_gba_frame_count = gauntlet_data.total_gba_frame_count + 1
        
        --print("GBA count after: " .. gauntlet_data.total_gba_frame_count)


    end

    if MusicLoader.LoadBlock() == 1 then
        state_logic.should_redraw = 1
    end

end

local start_frame = 0
local start_time = 0

function state_logic.apply_prerecorded_inputs_menu()

    
    if gauntlet_data.current_state ~= gauntlet_data.GAME_STATE.RUNNING then

        -- If we have recorded inputs, we set them

        if gauntlet_data.prerecorded_inputs ~= nil then

            --print("prerecorded index: " .. tostring(gauntlet_data.prerecorded_inputs_index))

            -- Get next (MENU) input frame and play it back if the frame number is lower
            local current_input_table = gauntlet_data.prerecorded_inputs[gauntlet_data.prerecorded_inputs_index]

            
            if input_handler.current_input_state == nil then
                input_handler.current_input_state = joypad.get()
                for key, value in pairs(input_handler.current_input_state) do
                    input_handler.current_input_state[key] = false
                end
            end


            if current_input_table ~= nil then

                if current_input_table.MENU_FRAME ~= nil then

                    if gauntlet_data.total_frame_count >= current_input_table.MENU_FRAME then

                        for key, value in pairs(current_input_table) do

                            if input_handler.current_input_state[key] ~= nil then
                                input_handler.current_input_state[key] = value
                            end

                        end

                        gauntlet_data.prerecorded_inputs_index = gauntlet_data.prerecorded_inputs_index + 1
                    end
                    
                end

            end


        end
    end

end

function state_logic.apply_prerecorded_inputs_ingame()

    if gauntlet_data.current_state == gauntlet_data.GAME_STATE.RUNNING then

        -- If we have recorded inputs, we set them

        if gauntlet_data.prerecorded_inputs ~= nil then

            
            if input_handler.current_input_state == nil then
                input_handler.current_input_state = joypad.get()
                for key, value in pairs(input_handler.current_input_state) do
                    input_handler.current_input_state[key] = false
                end
            end

            -- Get next (MENU) input frame and play it back if the frame number is lower
            local current_input_table = gauntlet_data.prerecorded_inputs[gauntlet_data.prerecorded_inputs_index]

            if current_input_table ~= nil then

                if current_input_table.GBA_FRAME ~= nil then

                    if gauntlet_data.total_gba_frame_count >= current_input_table.GBA_FRAME then

                        if input_handler.current_input_state == nil then
                            input_handler.current_input_state = joypad.get()
                            for key, value in pairs(input_handler.current_input_state) do
                                input_handler.current_input_state[key] = false
                            end
                        end

                        for key, value in pairs(current_input_table) do

                            if input_handler.current_input_state[key] ~= nil then
                                input_handler.current_input_state[key] = value
                            end

                        end

                        gauntlet_data.prerecorded_inputs_index = gauntlet_data.prerecorded_inputs_index + 1
                    end
                    
                end

            end

            
            --joypad.set(input_handler.current_input_state)

        end
    end

end

function state_logic.apply_current_networked_input_menu()
    if input_handler.current_input_state == nil then
        input_handler.current_input_state = joypad.get()
        for key, value in pairs(input_handler.current_input_state) do
            input_handler.current_input_state[key] = false
        end
    end

    -- Try to use the inputs
    if gauntlet_data.current_input ~= nil then

        if gauntlet_data.current_input.SOFT_RESET == 1 then
            --state_logic.reset = true
            
            state_logic.network_reset = true
            gauntlet_data.current_input = nil
            return
        end

        local is_in_transition_state = (gauntlet_data.current_input.CURRENT_STATE == gauntlet_data.GAME_STATE.TRANSITION_TO_CHIP_SELECT) 
                                or (gauntlet_data.current_input.CURRENT_STATE == gauntlet_data.GAME_STATE.TRANSITION_TO_CHIP_REPLACE) 
                                or (gauntlet_data.current_input.CURRENT_STATE == gauntlet_data.GAME_STATE.TRANSITION_TO_RUNNING) 
                                or (gauntlet_data.current_input.CURRENT_STATE == gauntlet_data.GAME_STATE.TRANSITION_TO_BUFF_SELECT)         
                                or (gauntlet_data.current_input.CURRENT_STATE == gauntlet_data.GAME_STATE.LOAD_INITIAL)       
                                or (gauntlet_data.current_input.CURRENT_STATE == gauntlet_data.GAME_STATE.TRANSITION_TO_CHOOSE_STARTING_LOADOUT)       
                                or (gauntlet_data.current_input.CURRENT_STATE == gauntlet_data.GAME_STATE.TRANSITION_TO_DRAFT_FOLDER)
                                or (gauntlet_data.current_input.CURRENT_STATE == gauntlet_data.GAME_STATE.TRANSITION_TO_CHOOSE_DROP_METHOD)
                                or (gauntlet_data.current_input.CURRENT_STATE == gauntlet_data.GAME_STATE.TRANSITION_TO_GAUNTLET_COMPLETE)
                                or (gauntlet_data.current_input.CURRENT_STATE == gauntlet_data.GAME_STATE.DEFAULT_WAITING_FOR_EVENTS)
                                or (gauntlet_data.current_input.CURRENT_STATE == gauntlet_data.GAME_STATE.TRANSITION_TO_CHOOSE_DIFFICULTY)


        -- Check if the input contains only "false" inputs -> we can apply those at any time
        local only_false = true

        for key, value in pairs(gauntlet_data.current_input) do

            if value == true then
                only_false = false
                break
            end

        end

        -- We do not want to apply "true" (-> pressed) inputs while we're in transition states *if* the CURRENT_STATE *does not match*.
        local true_inputs_in_transition_states = (only_false == false) and is_in_transition_state

        if true_inputs_in_transition_states and (gauntlet_data.current_input.CURRENT_STATE ~= gauntlet_data.current_state) then
            -- We skip the input
            gauntlet_data.current_input = nil
            return  
        end

        -- We received a true input that is not in a transition state - we might be in a transition state ourselves - wait and hopefully it'll resolve.
        if only_false == false and (is_in_transition_state == false) and (gauntlet_data.current_input.CURRENT_STATE ~= gauntlet_data.current_state) then
            print("Error: we have an input that we cannot match to the required state!")
            print(gauntlet_data.current_input)
            print(gauntlet_data.current_state)
            
            state_logic.network_handler.rewind_receive_buffer_consumer_index()
            gauntlet_data.current_input = nil
            return
        end
        


        if (gauntlet_data.current_input.MENU_FRAME ~= nil) and ((gauntlet_data.current_input.CURRENT_STATE == gauntlet_data.current_state) or is_in_transition_state or only_false) then
            
            print("applying: ")
            print(gauntlet_data.current_input)
            print(gauntlet_data.current_state)
            --print(" at frame " .. gauntlet_data.total_gba_frame_count)

            for key, value in pairs(gauntlet_data.current_input) do

                if input_handler.current_input_state[key] ~= nil then
                    input_handler.current_input_state[key] = value
                end

            end
            
            --print("Input handler state: ", input_handler.current_input_state)
            gauntlet_data.current_input = nil

        else

        end



    end

    return true
end

function state_logic.apply_current_networked_input_ingame()

    if input_handler.current_input_state == nil then
        input_handler.current_input_state = joypad.get()
        for key, value in pairs(input_handler.current_input_state) do
            input_handler.current_input_state[key] = false
        end
    end

    -- Try to use the inputs
    if gauntlet_data.current_input ~= nil then

        if gauntlet_data.current_input.SOFT_RESET == 1 then
            state_logic.network_reset = true
            gauntlet_data.current_input = nil
            return
        end

        if (gauntlet_data.current_input.GBA_FRAME ~= nil and (gauntlet_data.current_input.GBA_FRAME == gauntlet_data.total_gba_frame_count)) then
            
            --print("applying: ")
            --print(gauntlet_data.current_input)
            --print(" at frame " .. gauntlet_data.total_gba_frame_count)

            for key, value in pairs(gauntlet_data.current_input) do

                if input_handler.current_input_state[key] ~= nil then
                    input_handler.current_input_state[key] = value
                end

            end

            if gauntlet_data.current_input.SPECTATOR_CHIP ~= nil then
                gauntlet_data.use_spectator_chip = true
                --print("Received spectator chip: ")
                --print(gauntlet_data.current_input.SPECTATOR_CHIP)
            end

            -- TODO: figure this out if we have an input here we need to unpause, but don't unpause *twice* for the same input.
            --state_logic.unpause_once_ingame == true
            
            gauntlet_data.current_input = nil

        else
            --print("NOT applying: ")
            --print(gauntlet_data.current_input)
            --print(gauntlet_data.total_gba_frame_count)
            --client.pause()

            print("ERROR: we received a message from the host that we cannot apply because the frame count doesnt match!")
            print(gauntlet_data.current_input)
            print(gauntlet_data.total_gba_frame_count)
        end

        
    else
        -- Current input is nil - we haven't received a message. Pause the emulator
        
        return false

    end

    return true

end

function state_logic.apply_current_networked_input()

    if input_handler.current_input_state == nil then
        input_handler.current_input_state = joypad.get()
        for key, value in pairs(input_handler.current_input_state) do
            input_handler.current_input_state[key] = false
        end
    end

    -- Try to use the inputs
    if gauntlet_data.current_input ~= nil then

        if gauntlet_data.current_input.SOFT_RESET == 1 then
            state_logic.network_reset = true
            gauntlet_data.current_input = nil
            return
        end

        if (gauntlet_data.current_input.MENU_FRAME ~= nil) or (gauntlet_data.current_input.GBA_FRAME ~= nil and (gauntlet_data.current_input.GBA_FRAME == gauntlet_data.total_gba_frame_count)) then
            
            --print("applying: ")
            --print(gauntlet_data.current_input)
            --print(" at frame " .. gauntlet_data.total_gba_frame_count)

            for key, value in pairs(gauntlet_data.current_input) do

                if input_handler.current_input_state[key] ~= nil then
                    input_handler.current_input_state[key] = value
                end

            end

            if gauntlet_data.current_input.SPECTATOR_CHIP ~= nil then
                gauntlet_data.use_spectator_chip = true
                --print("Received spectator chip: ")
                --print(gauntlet_data.current_input.SPECTATOR_CHIP)
            end
            
            gauntlet_data.current_input = nil
            --client.unpause()

        else
            --print("NOT applying: ")
            --print(gauntlet_data.current_input)
            --print(gauntlet_data.total_gba_frame_count)
            --client.pause()

            print("ERROR: we received a message from the host that we cannot apply because the frame count doesnt match!")
            print(gauntlet_data.current_input)
            print(gauntlet_data.total_gba_frame_count)
        end

        
    else
        -- Current input is nil - we haven't received a message. Pause the emulator
        print("Pausing the emulator - we don't have an input.")
        state_logic.pause_emu()
        return false

    end

    return true
end


function state_logic.apply_networked_inputs_menu()
    if state_logic.network_handler.is_connected then
        -- Get inputs from network

        if gauntlet_data.current_input == nil then
            local data = state_logic.network_handler.consume_receive_buffer()

            if data ~= nil then
                gauntlet_data.current_input = json.decode(data)
                

                if gauntlet_data.current_input.MUSIC_LOADED ~= nil then
                    gauntlet_data.networked_music_loaded = gauntlet_data.current_input.MUSIC_LOADED
                    print("Set networked music loaded: ", gauntlet_data.networked_music_loaded)
                end

                if gauntlet_data.current_input.SOFT_RESET ~= nil then
                    state_logic.network_reset = true
                end


                --if gauntlet_data.networked_music_loaded == 1 then
                --    print("Received music loaded!", gauntlet_data.current_input)
                --end

               --print("Received current data (menu): ")
               --print(gauntlet_data.current_input)
               --print("Current state: " .. gauntlet_data.current_state)
            end

            
            -- TODO: this is definitely a potential issue with the "lockstep" networking
            -- If we received a packet with contents that don't contain a menu frame for some reason, discard it
            if gauntlet_data.current_input ~= nil and gauntlet_data.current_input.MENU_FRAME == nil then

                -- If we received something that contains a GBA_FRAME, we need to be careful to make sure that we still apply them correctly.
                if gauntlet_data.current_input.GBA_FRAME ~= nil then
                    print("Received a GBA Frame while not yet in-game or still in menu. Rewinding message consume pointer and ignoring this input for now")
                    print("Current state: " .. gauntlet_data.current_state)
                    print(gauntlet_data.current_input)
                    print(gauntlet_data.total_gba_frame_count)

                    if gauntlet_data.current_input.GBA_FRAME ~= 0 then
                        print("Received a frame from previous battle for some reason, discarding it!")
                    else
                        state_logic.network_handler.rewind_receive_buffer_consumer_index()
                    end

                    gauntlet_data.current_input = nil
                    return nil
                end

                -- All the other inputs (potential specatator chips) are discarded
                gauntlet_data.current_input = nil
                return nil
            end


        
            if gauntlet_data.main_player == 0 then
                state_logic.apply_current_networked_input_menu()
            end

            return data

        end

    end

    return nil
end

function state_logic.apply_networked_inputs_ingame()
    local data = nil

    if state_logic.network_handler.is_connected then
        -- Get inputs from network

        if gauntlet_data.current_input == nil then
            data = state_logic.network_handler.consume_receive_buffer()

            if data ~= nil then
                
                gauntlet_data.current_input = json.decode(data)

                
                if gauntlet_data.current_input == nil then
                    print("Received: ")
                    print(gauntlet_data.current_input)
                    print(data)
                    return nil
                end
                --

                if gauntlet_data.current_input.SOFT_RESET ~= nil then
                    state_logic.network_reset = true
                end


                if gauntlet_data.current_input.GBA_FRAME ~= nil and gauntlet_data.current_input.GBA_FRAME < gauntlet_data.total_gba_frame_count then
                    print("ERROR - received data for a frame that is in the past! ")
                    print(gauntlet_data.current_input)
                    print(gauntlet_data.current_input)
                    print(gauntlet_data.current_input)
                    print(gauntlet_data.current_input)
                    print(gauntlet_data.current_input)
                    print(gauntlet_data.total_gba_frame_count)
                end

                if gauntlet_data.current_input.GBA_FRAME ~= nil and gauntlet_data.current_input.GBA_FRAME == gauntlet_data.total_gba_frame_count then
                    --print("Advancing frame: ")
                    --print(gauntlet_data.current_input)
                    --emu.yield()
                    state_logic.unpause_once_ingame = true
                end

                if gauntlet_data.current_input.SKIP_BATTLE_IF_THIS_ARRIVES then
                    print("Other player is done with battle - not pausing anymore in case there would be frames missing.")
                    state_logic.do_not_pause = true
                    gauntlet_data.current_input = nil
                    client.unpause()
                    return nil
                end

                if gauntlet_data.current_input.MENU_FRAME ~= nil and gauntlet_data.current_input.SOFT_RESET == nil then
                    -- Receiving a menu frame while we're ingame would be weird

                    --print("Warning: received a MENU FRAME while ingame. This might have frozen the UI / desynced the server and client. Most likely doesn't have any consequences.")

                    --print(gauntlet_data.current_input)
                    gauntlet_data.current_input = nil

                end

                --print("Received current data (ingame): ")
                --print(gauntlet_data.current_input)
                --print(gauntlet_data.total_gba_frame_count)
            end

        end
     
    end

    return data

end

function state_logic.main_loop()

    -- This loop runs at emulator frame rate


    local current_time = os.time()

    if (current_time - start_time) > 1 then
        --print ("FPS: ", (gauntlet_data.total_frame_count - start_frame) / (current_time - start_time))
        start_time = current_time
        start_frame = gauntlet_data.total_frame_count
    end

    --print(gauntlet_data.main_player)
    if gauntlet_data.main_player == 0 then
        --print("ASDF")
        --print("ASDF")
        --print("ASDF")
        --print(gauntlet_data.current_input)
        --print(gauntlet_data.current_state)
        --print("ASDF")
    end

    --print("THIS SHOULD ALWAYS RUN...")


    --

    if DEBUG == 1 then
        print ("DEBUG: STATE: ", gauntlet_data.current_state)
    end


    --if gauntlet_data.current_state ~= gauntlet_data.GAME_STATE.RUNNING then

    -- If we have recorded inputs, we set them

    if gauntlet_data.current_state ~= gauntlet_data.GAME_STATE.RUNNING then

        
        state_logic.apply_prerecorded_inputs_menu()

        if state_logic.network_handler.is_connected == false then
            if gauntlet_data.prerecorded_inputs == nil then
                input_handler.current_input_state = joypad.get()
            end
        else
            if gauntlet_data.main_player == 1 then
                input_handler.current_input_state = joypad.get()
            end
        end

        local ret_data = state_logic.apply_networked_inputs_menu()

        --if ret_data ~= nil then
        --    print("before handle_inputs inputs pressed")
        --    print(input_handler.inputs_pressed)
        --    print("inputs held")
        --    print(input_handler.inputs_held)
        --    print("current input state")
        --    print(input_handler.current_input_state)
        --end

        -- TODO: check if we're using recorded, networked or raw inputs
        input_handler.handle_inputs()

        if state_logic.network_handler.is_connected and gauntlet_data.main_player == 0 then

            for key, value in pairs(input_handler.current_input_state) do

                -- Override some of the input handler logic that might mess up our networked inputs for some configurations.
                if value == true then
                    input_handler.inputs_pressed[key] = value
                end
            end

            input_handler.current_input_state = nil
            
        end
        
        --if ret_data ~= nil then
        --    print("after handle_inputs inputs pressed")
        --    print(input_handler.inputs_pressed)
        --    print("inputs held")
        --    print(input_handler.inputs_held)
        --    print("current input state")
        --    print(input_handler.current_input_state)
        --end


        -- This input delta recording should only run in the "menu". This will be replayed differently compared to the in-game inputs.

        local recorded_input_table = deepcopy(input_handler.inputs_delta)

        if state_logic.network_handler.is_connected then 

            if MusicLoader.FinishedLoading == 1 and gauntlet_data.music_loading_started == 1 and gauntlet_data.networked_music_loaded_sent ~= true then
                recorded_input_table.MUSIC_LOADED = MusicLoader.FinishedLoading
                gauntlet_data.networked_music_loaded_sent = true
                print("Sending MUSIC LOADED: ")
                print(recorded_input_table)
            end

        end
    
        if input_handler.has_delta == true or recorded_input_table.MUSIC_LOADED ~= nil then
            recorded_input_table.MENU_FRAME = gauntlet_data.total_frame_count
            recorded_input_table.CURRENT_STATE = gauntlet_data.current_state
            gauntlet_data.recorded_input_deltas[#gauntlet_data.recorded_input_deltas + 1] = recorded_input_table

            -- Also always send music back if we're not the main player and received inputs
            if MusicLoader.FinishedLoading == 1 and gauntlet_data.music_loading_started == 1 and gauntlet_data.main_player == 0 then
                recorded_input_table.MUSIC_LOADED = MusicLoader.FinishedLoading
                gauntlet_data.networked_music_loaded_sent = true
                print("Sending MUSIC LOADED: ")
                print(recorded_input_table)
            end

            -- Enter current menu inputs into network buffer
            if gauntlet_data.main_player == 1 or recorded_input_table.MUSIC_LOADED ~= nil and state_logic.network_handler.is_connected then
                print("Sent current data (menu): ")
                print(recorded_input_table)
                print("Current state: " .. gauntlet_data.current_state)
                state_logic.network_handler.produce_send_buffer(json.encode(recorded_input_table) .. "\n")
            end

        end
        
           
        

        --end
        
    end


    
    gauntlet_data.total_frame_count = gauntlet_data.total_frame_count + 1


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
        state_logic.pause_emu()
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
                --print("Current battle: ", state_logic.current_battle)
                gui_rendering.render_buffs(state_logic.activated_buffs, MusicLoader.FinishedLoading, state_logic.buff_render_offset, state_logic.current_battle)
            end


            
            --gui.DrawFinish()
            --memorysavestate.loadcorestate(state_logic.gui_change_savestate)
            --state_logic.should_redraw = 0
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
        local num_chips_per_folder = GENERIC_DEFS.NUMBER_OF_CHIPS_IN_FOLDER

        

        if input_handler.inputs_pressed["L"] == true or input_handler.inputs_pressed["R"] == true then

            -- TODO_REFACTOR: use names/enums for folder_view types...
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
                        state_logic.folder_chip_render_index = num_chips_per_folder
                    end
                    state_logic.should_redraw = 1
                end

                if input_handler.inputs_pressed["Right"] == true then
                    state_logic.folder_chip_render_index = (state_logic.folder_chip_render_index + num_chips_per_col) % (num_chips_per_folder)
                    if state_logic.folder_chip_render_index == 0 then
                        state_logic.folder_chip_render_index = num_chips_per_folder
                    end
                    state_logic.should_redraw = 1
                end

                if input_handler.inputs_pressed["Up"] == true then
                    state_logic.folder_chip_render_index = (state_logic.folder_chip_render_index - 1) % (num_chips_per_folder + 1)
                    --print ("UP PRESSED")
                    if state_logic.folder_chip_render_index == 0 then
                        state_logic.folder_chip_render_index = num_chips_per_folder
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

            --print(input_handler.inputs_pressed)
            --print(input_handler.inputs_held)

            --print(gauntlet_data.networked_music_loaded)

            local networked_music_done = true

            if state_logic.network_handler.is_connected then
                --print("is connected")
                if gauntlet_data.networked_music_loaded ~= 1 then
                    networked_music_done = false
                    --print("Not done for some reason:")
                    --print(gauntlet_data.networked_music_loaded)
                else
                    
                end
            else
                --print("WTF not connected ?!")
                --print(gauntlet_data.networked_music_loaded)
            end

            if networked_music_done then
                --print("Networked music done: ")
                --print(gauntlet_data.networked_music_loaded)
                --print(gauntlet_data.music_loading_started)
            else
                --print("Networked music not done: ")
                --print(gauntlet_data.networked_music_loaded)
                --print(gauntlet_data.music_loading_started)
            end
            

            if input_handler.inputs_pressed["A"] == true and ((MusicLoader.FinishedLoading == 1 and gauntlet_data.music_loading_started == 1) or GENERIC_DEFS.ENABLE_MUSIC_PATCHING == 0) and networked_music_done then
                

                -- TODO: add chip to folder!
                --print("A pressed - replacing chip")
            
                if state_logic.dropped_chip.ID ~= -1 then

                    -- TODO_REFACTOR: make sure CHIP_RANKING is the same in all games / refactor to a better API
                    local dropped_chip_data = CHIP_DATA[state_logic.dropped_chip.ID]
                    local is_dropped_chip_mega = (dropped_chip_data.CHIP_RANKING % 4) == 1
                    local is_dropped_chip_giga = (dropped_chip_data.CHIP_RANKING % 4) == 2

                    local folder_chip_data = nil
                    local is_folder_chip_mega = false
                    local is_folder_chip_giga = false


                    if gauntlet_data.current_folder[state_logic.folder_chip_render_index] ~= nil then
                        local folder_chip_data = CHIP_DATA[gauntlet_data.current_folder[state_logic.folder_chip_render_index].ID]
                        is_folder_chip_mega = (folder_chip_data.CHIP_RANKING % 4) == 1
                        is_folder_chip_giga = (folder_chip_data.CHIP_RANKING % 4) == 2
                    end

                    local replaces_mega_chip = is_folder_chip_mega and is_dropped_chip_mega

                    local replaces_giga_chip = is_folder_chip_giga and is_dropped_chip_giga

                    if (((dropped_chip_data.CHIP_RANKING % 4) == 1 and gauntlet_data.current_number_of_mega_chips >= gauntlet_data.mega_chip_limit + gauntlet_data.mega_chip_limit_team) 
                        or ((dropped_chip_data.CHIP_RANKING % 4) == 2 and gauntlet_data.current_number_of_giga_chips >= gauntlet_data.giga_chip_limit))
                        
                        and replaces_mega_chip == false and replaces_giga_chip == false
                        then
                    
                        -- We do nothing if we can't pick due to Mega/GigaChip limits. We check for replacement of Mega/Giga chips.
                        print("Cannot replace due to mega/giga chip limit!")
                    else        
                        
                        state_logic.replaced_chip = "Empty Chip"

                        if gauntlet_data.current_folder[state_logic.folder_chip_render_index] ~= nil then
                            state_logic.replaced_chip = deepcopy(gauntlet_data.current_folder[state_logic.folder_chip_render_index].PRINT_NAME)
                            gauntlet_data.current_folder[state_logic.folder_chip_render_index] = state_logic.dropped_chip
                        else
                            gauntlet_data.current_folder[#gauntlet_data.current_folder + 1] = state_logic.dropped_chip
                        end

                        gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_RUNNING
                        state_logic.should_redraw = 1

                        state_logic.update_folder_mega_giga_chip_counts()
                        -- TODO_REFACTOR: folder_view enum
                        gauntlet_data.folder_view = 0
                        
                    end

                else
                    state_logic.replaced_chip = "Skipped Chip"
                    gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_RUNNING
                    -- TODO_REFACTOR: folder_view enum
                    gauntlet_data.folder_view = 0
                    state_logic.should_redraw = 1
                end
            end
            
            if (gauntlet_data.illusion_of_choice_active == 0) or (gauntlet_data.illusion_of_choice_active == 1 and state_logic.dropped_chip.ID == -1) then
            
                --print("illusion of choice check passes")

                --print("Input handler B ", input_handler.inputs_pressed["B"])
                --print("Finished loading", MusicLoader.FinishedLoading)
                --print("networked loaded ", gauntlet_data.networked_music_loaded)
                --print("main player", gauntlet_data.main_player)

                if input_handler.inputs_pressed["B"] == true and ((MusicLoader.FinishedLoading == 1 and gauntlet_data.music_loading_started == 1) or GENERIC_DEFS.ENABLE_MUSIC_PATCHING == 0) and networked_music_done then
                    -- Just skip - we didn't want a chip!
                    --print("B pressed - skipping chip")
                    gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_RUNNING
                    state_logic.replaced_chip = "Skipped Chip"
                    
                    state_logic.should_redraw = 1
                end
            end
        end
        --print(state_logic.folder_chip_render_index)

        state_logic.check_buff_render_offset()

        if state_logic.should_redraw == 1 then


            
            -- TODO_REFACTOR: folder_view enum
            if gauntlet_data.folder_view == 0 then
                gui_rendering.render_folder(gauntlet_data.current_folder, state_logic.folder_chip_render_index, state_logic.dropped_chip, gauntlet_data, MusicLoader.FinishedLoading)
            elseif gauntlet_data.folder_view == 1 then
                gui_rendering.render_folder(gauntlet_data.current_folder, state_logic.folder_chip_render_index, state_logic.dropped_chip, gauntlet_data, MusicLoader.FinishedLoading)
            elseif gauntlet_data.folder_view == 2 then
                --print("current_battle: ", state_logic.current_battle)
                gui_rendering.render_buffs(state_logic.activated_buffs, MusicLoader.FinishedLoading, state_logic.buff_render_offset, state_logic.current_battle)
            end
            
            
            
            --gui.DrawFinish()
            --memorysavestate.loadcorestate(state_logic.gui_change_savestate)
            --state_logic.should_redraw = 0
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
        --memorysavestate.loadcorestate(state_logic.gui_change_savestate)
        state_logic.pause_emu()

        -- Determine number of Mega/Giga chips in folder.
        state_logic.update_folder_mega_giga_chip_counts()
        
        

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.BUFF_SELECT then
        --print ("IN BUFF_SELECT")

        state_logic.folder_view_switch_and_sort()
        state_logic.check_buff_render_offset()
        -- TODO_REFACTOR: folder_view enum
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

                -- We advance the rng here for buff activations to be consistent
                gauntlet_data.math.advance_rng_since_last_advance("BUFF_ACTIVATION", 229);
                -- TODO_REFACTOR: folder_view enum
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

            -- TODO_REFACTOR: folder_view enum
            if gauntlet_data.folder_view == 0 then
                gui_rendering.render_items(state_logic.dropped_buffs, state_logic.dropped_buff_render_index)
            elseif gauntlet_data.folder_view == 1 then
                gui_rendering.render_folder(gauntlet_data.current_folder, nil, nil, gauntlet_data, MusicLoader.FinishedLoading)
            elseif gauntlet_data.folder_view == 2 then
                gui_rendering.render_buffs(state_logic.activated_buffs, MusicLoader.FinishedLoading, state_logic.buff_render_offset, state_logic.current_battle)
            end

            
            --gui.DrawFinish()
            --memorysavestate.loadcorestate(state_logic.gui_change_savestate)
            --state_logic.should_redraw = 0
        end
        
    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.TRANSITION_TO_RUNNING then

        gauntlet_data.current_input = nil

        state_logic.patch_before_battle_start()
        state_logic.hp_loaded = 0
        --io_utils.change_number_of_cust_screen_chips(gauntlet_data.cust_style_number_of_chips + gauntlet_data.cust_screen_number_of_chips)  
        
        --print("Patched folder!")
        
         --io_utils.change_megaMan_max_hp(gauntlet_data.mega_max_hp) 

        if state_logic.network_handler.is_connected and gauntlet_data.main_player == 0 then
            -- We use manual frame advances for the client (but not actually emu.frameadvance because it fucks up everything)
            state_logic.pause_emu()
        else
            state_logic.unpause_emu()
        end

        
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.RUNNING
        
    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.LOAD_INITIAL then

        --print('test!')

        -- Simply load initial state again if we beat all rounds.
        savestate.load(state_logic.initial_state)

        state_logic.load_encounter_data()
        --state_logic.next_round()
        state_logic.unpause_emu()
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.DEFAULT_WAITING_FOR_EVENTS
    
    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.TRANSITION_TO_CHOOSE_STARTING_LOADOUT then
        state_logic.gui_change_savestate = memorysavestate.savecorestate()
        
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.CHOOSE_STARTING_LOADOUT
        state_logic.should_redraw = 1
        
        
        --memorysavestate.loadcorestate(state_logic.gui_change_savestate)
        state_logic.pause_emu()


    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.CHOOSE_STARTING_LOADOUT then

        -- TODO: render list of starting loadouts. Each loadout should provide a callable function that can set various things.
        state_logic.folder_view_switch_and_sort()
        state_logic.check_buff_render_offset()

        
        if state_logic.should_redraw == 1 then
            -- TODO_REFACTOR: folder_view enum
            if gauntlet_data.folder_view == 0 then
                gui_rendering.render_items(LOADOUTS, state_logic.selected_loadout_index)
            elseif gauntlet_data.folder_view == 1 then
                gui_rendering.render_folder(gauntlet_data.current_folder, nil, nil, gauntlet_data, MusicLoader.FinishedLoading)
            elseif gauntlet_data.folder_view == 2 then
                gui_rendering.render_buffs(state_logic.activated_buffs, MusicLoader.FinishedLoading, state_logic.buff_render_offset, state_logic.current_battle)
            end

            
            --gui.DrawFinish()
            --memorysavestate.loadcorestate(state_logic.gui_change_savestate)
            --state_logic.should_redraw = 0
        end

        -- TODO_REFACTOR: folder_view enum    
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


    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.TRANSITION_TO_CHOOSE_DROP_METHOD then
        state_logic.gui_change_savestate = memorysavestate.savecorestate()
        
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.CHOOSE_DROP_METHOD
        state_logic.should_redraw = 1
        
        
        --memorysavestate.loadcorestate(state_logic.gui_change_savestate)
        state_logic.pause_emu()

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.CHOOSE_DROP_METHOD then

        -- TODO: render list of starting loadouts. Each loadout should provide a callable function that can set various things.
        state_logic.folder_view_switch_and_sort()
        state_logic.check_buff_render_offset()
        -- TODO_REFACTOR: folder_view enum
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
                gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_CHOOSE_DIFFICULTY


                gauntlet_data.chip_drop_method = CHIP_DROP_METHODS[state_logic.selected_drop_method_index]
                gauntlet_data.chip_drop_method.activate()

                
                --print("Folder after loadout: ", gauntlet_data.current_folder)
                gauntlet_data.folder_view = 0
                state_logic.selected_drop_method_index = 2
            end

        end

        if state_logic.should_redraw == 1 then

            -- TODO_REFACTOR: folder_view enum
            if gauntlet_data.folder_view == 0 then
                gui_rendering.render_items(CHIP_DROP_METHODS, state_logic.selected_drop_method_index)
            elseif gauntlet_data.folder_view == 1 then
                gui_rendering.render_folder(gauntlet_data.current_folder, nil, nil, gauntlet_data, MusicLoader.FinishedLoading)
            elseif gauntlet_data.folder_view == 2 then
                gui_rendering.render_buffs(state_logic.activated_buffs, MusicLoader.FinishedLoading, state_logic.buff_render_offset, state_logic.current_battle)
            end

            
            --gui.DrawFinish()
            --memorysavestate.loadcorestate(state_logic.gui_change_savestate)
            --state_logic.should_redraw = 0
        end

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.TRANSITION_TO_CHOOSE_DIFFICULTY then
        state_logic.gui_change_savestate = memorysavestate.savecorestate()
        
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.CHOOSE_DIFFICULTY
        state_logic.should_redraw = 1
        
        
        --memorysavestate.loadcorestate(state_logic.gui_change_savestate)
        state_logic.pause_emu()

        gauntlet_data.current_input = nil

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.CHOOSE_DIFFICULTY then

        -- TODO: render list of starting loadouts. Each loadout should provide a callable function that can set various things.
        state_logic.folder_view_switch_and_sort()
        state_logic.check_buff_render_offset()
        -- TODO_REFACTOR: folder_view enum
        if gauntlet_data.folder_view == 0 then

            if input_handler.inputs_pressed["Up"] == true then
                state_logic.selected_difficulty_index = (state_logic.selected_difficulty_index - 1) % (#DIFFICULTY_LEVELS)
                
                if state_logic.selected_difficulty_index == 0 then
                    state_logic.selected_difficulty_index = #DIFFICULTY_LEVELS
                end
                state_logic.should_redraw = 1
            end

            if input_handler.inputs_pressed["Down"] == true then
                state_logic.selected_difficulty_index = (state_logic.selected_difficulty_index + 1) % (#DIFFICULTY_LEVELS + 1)
                if state_logic.selected_difficulty_index == 0 then
                    state_logic.selected_difficulty_index = 1
                end
                state_logic.should_redraw = 1
            end

            


            if input_handler.inputs_pressed["A"] == true then

                --print("Selected a Chip!")
                --print("Selected drop method: ", CHIP_DROP_METHODS[state_logic.selected_drop_method_index])
                gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_CHOOSE_STARTING_LOADOUT


                gauntlet_data.difficulty = DIFFICULTY_LEVELS[state_logic.selected_difficulty_index]
                gauntlet_data.difficulty.activate()

                
                --print("Folder after loadout: ", gauntlet_data.current_folder)
                gauntlet_data.folder_view = 0
                state_logic.selected_difficulty_index = 2
            end

        end

        if state_logic.should_redraw == 1 then

            -- TODO_REFACTOR: folder_view enum
            if gauntlet_data.folder_view == 0 then
                gui_rendering.render_items(DIFFICULTY_LEVELS, state_logic.selected_difficulty_index)
            elseif gauntlet_data.folder_view == 1 then
                gui_rendering.render_folder(gauntlet_data.current_folder, nil, nil, gauntlet_data, MusicLoader.FinishedLoading)
            elseif gauntlet_data.folder_view == 2 then
                gui_rendering.render_buffs(state_logic.activated_buffs, MusicLoader.FinishedLoading, state_logic.buff_render_offset, state_logic.current_battle)
            end

            
            --gui.DrawFinish()
            --memorysavestate.loadcorestate(state_logic.gui_change_savestate)
            --state_logic.should_redraw = 0
        end

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.TRANSITION_TO_DRAFT_FOLDER then
        state_logic.gui_change_savestate = memorysavestate.savecorestate()
        
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.DRAFT_FOLDER
        state_logic.should_redraw = 1
        

        --print("Transition to draft folder!")

        --print("After folder draft generator")
        state_logic.update_argb_chip_icons_in_folder()
        
        --print("Folder:", gauntlet_data.current_folder)
        
        if #gauntlet_data.current_folder == GENERIC_DEFS.NUMBER_OF_CHIPS_IN_FOLDER then
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
        --memorysavestate.loadcorestate(state_logic.gui_change_savestate)
        state_logic.pause_emu()
        

        
        

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.DRAFT_FOLDER then
        
        state_logic.folder_view_switch_and_sort()
        state_logic.check_buff_render_offset()
        -- TODO_REFACTOR: folder_view enum
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
                gui_rendering.render_buffs(state_logic.activated_buffs, MusicLoader.FinishedLoading, state_logic.buff_render_offset, state_logic.current_battle)
            end
            
            --gui.DrawFinish()
            --memorysavestate.loadcorestate(state_logic.gui_change_savestate)
            --state_logic.should_redraw = 0
        end

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.TRANSITION_TO_GAUNTLET_COMPLETE then
        state_logic.gui_change_savestate = memorysavestate.savecorestate()
        
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.GAUNTLET_COMPLETE
        state_logic.should_redraw = 1
        
        --memorysavestate.loadcorestate(state_logic.gui_change_savestate)
        state_logic.pause_emu()

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.GAUNTLET_COMPLETE then

        if state_logic.should_redraw == 1 then

            
            gui_rendering.render_gauntlet_complete()

           -- gui.DrawFinish()
            --memorysavestate.loadcorestate(state_logic.gui_change_savestate)
            --state_logic.should_redraw = 0
        end
        

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.RUNNING then


        if gauntlet_data.spectator_chip_sent == false and gauntlet_data.spectator_chip ~= nil and state_logic.network_handler.is_connected == true then
            gui_rendering.render_spectator_chip(gauntlet_data.spectator_chip)
        end

        -- TODO: we render the chip icon over the existing icons because with the spectator replacement the icons are broken and I'm too lazy to check for a proper solution
        --       we only do this *if*
        --       we're in the battle phase
        --       we're not in time freeze (IN_BATTLE_TIMEFREEZE_ADDRESS)
        --       we simply render the currently held chip at mega man's position (with an offset) (IN_BATTLE_MEGA_MAN_POSITION_ADDRESS)

        
        if emu.islagged() ~= true then

            if gauntlet_data.held_chips ~= nil then

                    
                local is_timefreeze = io_utils.readbyte(GENERIC_DEFS.IN_BATTLE_TIMEFREEZE_ADDRESS)
                local is_after_battle = io_utils.readbyte(GENERIC_DEFS.IN_BATTLE_AFTER_BATTLE_ADDRESS) 

                --print("Render check: ", gauntlet_data.battle_phase, is_timefreeze, gauntlet_data.current_battle_chip_index, #gauntlet_data.held_chips)
                if gauntlet_data.battle_phase == 1 and is_after_battle == 0 and is_timefreeze == 0 and gauntlet_data.current_battle_chip_index <= #gauntlet_data.held_chips and #gauntlet_data.held_chips ~= 0 then
                
                    if gauntlet_data.held_chips ~= nil and gauntlet_data.current_battle_chip_index ~= nil and gauntlet_data.held_chips[gauntlet_data.current_battle_chip_index] ~= nil then

                        --print("Held chips: ")
                        --print(gauntlet_data.held_chips)

                        -- Read mega man's x and y positions
                        local mega_x = io_utils.readbyte(GENERIC_DEFS.IN_BATTLE_MEGA_MAN_POSITION_ADDRESS[gauntlet_data.number_of_entities]) - 1
                        local mega_y = io_utils.readbyte(GENERIC_DEFS.IN_BATTLE_MEGA_MAN_POSITION_ADDRESS[gauntlet_data.number_of_entities] + 1) - 1

                        --print("mega x", mega_x, "mega y", mega_y)

                        gauntlet_data.held_chips[gauntlet_data.current_battle_chip_index].ARGB_ICON = state_logic.get_argb_icon(gauntlet_data.held_chips[gauntlet_data.current_battle_chip_index])
                        
                        gui_rendering.render_chip_icon_in_battle(gauntlet_data.held_chips[gauntlet_data.current_battle_chip_index], 17 + 40 * mega_x, 28 + 24 * mega_y)

                    end

                    

                end

            end

            -- Run the ingame network input receiver code
            --
            
            gauntlet_data.music_loading_started = 0
            
            --print("Running before apply_networked_inputs_ingame")
        
            state_logic.apply_networked_inputs_ingame()
        end
        

    else-- Default state, should never happen
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.DEFAULT_WAITING_FOR_EVENTS
        --print("TEST ABC")
        state_logic.emu_paused = true
        state_logic.unpause_emu()
    end

    

    
    if state_logic.check_reset() then
        return
    end


    -- Send network buffer values, if they exist

    if emu.islagged() ~= true then

        while state_logic.network_handler.consume_send_buffer() do
        
        end

        -- Receive network buffer values, if they exist
        while state_logic.network_handler.produce_receive_buffer() do

        end

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


    if state_logic.unpause_once_ingame == true then
        state_logic.unpause_once_ingame = false
        state_logic.unpause_emu()
    end

    --emu.yield()
end

return state_logic