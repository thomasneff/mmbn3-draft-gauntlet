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
-- TODO: possibly add more states.

local state_logic = {}

state_logic.activated_buffs = {}
state_logic.dropped_chips = {}
state_logic.dropped_buffs = {}
state_logic.initial_state = "initial.State"
state_logic.number_of_activated_buffs = 0
gauntlet_data.current_folder = {}
gauntlet_data.mega_max_hp = 100

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
state_logic.loadout_chosen = 0
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
        mmbn3_utils.change_battle_pointer_data(ptr_table_working_address, new_pointer_entry)
        ptr_table_working_address = ptr_table_working_address - GENERIC_DEFS.OFFSET_BETWEEN_POINTER_TABLE_ENTRIES
    end
    --print("Patched Battle Stage Setups!")

    state_logic.on_next_round()

    -- Potentially do other stuff here. For example, we could set the state to a 'choose-reward' state.

end

function state_logic.patch_next_battle()

    -- This function changes viruses, stage, AI, basically anything related to the fight when
    -- the fight loads.
    print("Battle ", state_logic.current_battle, " start")

    -- When we finished all gauntlet battles, enter the next round.
    if state_logic.battle_pointer_index > GAUNTLET_DEFS.BATTLES_PER_ROUND or 
        state_logic.current_round == 0 then
        --print("3")
        state_logic.next_round()
    end

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

function state_logic.compute_perfect_fight_bonuses()

    if gauntlet_data.has_mega_been_hit == 0 then
        gauntlet_data.number_of_perfect_fights = gauntlet_data.number_of_perfect_fights + 1
    end

    gauntlet_data.has_mega_been_hit = 0

    -- TODO: compute buff bonuses depending on perfect fights
    print("Perfect Fight!")

    if gauntlet_data.skill_not_luck_active == 1 then
        gauntlet_data.skill_not_luck_bonus_current = gauntlet_data.skill_not_luck_bonus_current + gauntlet_data.skill_not_luck_bonus_per_battle
        print("Skill not luck active, current bonus: " .. gauntlet_data.skill_not_luck_bonus_current)
    end
    
    
    local damage_mult =  gauntlet_data.temporary_damage_bonus_mult.BASE +  gauntlet_data.temporary_damage_bonus_mult.PERFECT_FIGHT_INCREASE * gauntlet_data.number_of_perfect_fights
    
    if damage_mult > gauntlet_data.temporary_damage_bonus_mult.LIMIT then
        damage_mult = gauntlet_data.temporary_damage_bonus_mult.LIMIT
    end
    
    gauntlet_data.temporary_damage_bonus_mult.CURRENT = damage_mult
    
    local damage_add =  gauntlet_data.temporary_damage_bonus_add.BASE +  gauntlet_data.temporary_damage_bonus_add.PERFECT_FIGHT_INCREASE * gauntlet_data.number_of_perfect_fights
    
    if damage_add > gauntlet_data.temporary_damage_bonus_add.LIMIT then
        damage_add = gauntlet_data.temporary_damage_bonus_add.LIMIT
    end
    
    gauntlet_data.temporary_damage_bonus_add.CURRENT = damage_add
    

end


function state_logic.compute_temporary_chip_changes()
    

    
    
    -- Restore CHIP_DATA from copy. Copies are always taken when taking a buff, as this is the only possibility where CHIP_DATA is changed directly.
    for key, chip_data in pairs(CHIP_DATA) do
        CHIP_DATA[key] = deepcopy(state_logic.CHIP_DATA_COPY[key])
    end
    
     
    
    -- Apply temporary buffs
    for key, chip_data in pairs(CHIP_DATA) do 
        CHIP_DATA[key].DAMAGE = (CHIP_DATA[key].DAMAGE * gauntlet_data.temporary_damage_bonus_mult.CURRENT) + gauntlet_data.temporary_damage_bonus_add.CURRENT
    end


end


function state_logic.on_battle_end()

    if state_logic.battle_pointer_index > GAUNTLET_DEFS.BATTLES_PER_ROUND then
       gauntlet_data.current_state = gauntlet_data.GAME_STATE.LOAD_INITIAL 
    end  

    state_logic.compute_perfect_fight_bonuses()
    
    
    
    
    
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
    
    MusicLoader.LoadRandomFile(state_logic.current_battle)



    state_logic.patch_next_battle()
    --state_logic.determine_drops(GAUNTLET_DEFS.NUMBER_OF_DROPPED_CHIPS)
    state_logic.shuffle_folder()
    
    

    if gauntlet_data.current_state ~= gauntlet_data.GAME_STATE.TRANSITION_TO_BUFF_SELECT and  
        gauntlet_data.current_state ~= gauntlet_data.GAME_STATE.BUFF_SELECT then
            gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_CHIP_SELECT
    end


    if state_logic.loadout_chosen == 0 then

        gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_CHOOSE_DROP_METHOD

    end

    --print("STATE_ENTER: ", gauntlet_data.current_state)
    --print(print(state_logic.dropped_chip))
    if state_logic.current_round >= (GAUNTLET_DEFS.MAX_NUMBER_OF_ROUNDS + 1) then

        gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_GAUNTLET_COMPLETE

    end
    
    --gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_CHIP_SELECT

end


function state_logic.on_next_round()
    
    --print ("BEFORE MEGA MAX INCREASE PER ROUND")
    gauntlet_data.mega_max_hp = gauntlet_data.mega_max_hp + GAUNTLET_DEFS.HP_INCREASE_PER_ROUND[state_logic.current_round]
    gauntlet_data.hp_patch_required = 1
    --print(" MEGA MAX HP: ", gauntlet_data.mega_max_hp)
    --print ("BEFORE CHANGE MAX HP")
    
    --print ("BEFORE TRANSITION TO BUFF SELECT")
    gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_BUFF_SELECT

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

    
    

end



function state_logic.initialize()

    math.randomseed(os.time())

    savestate.load(state_logic.initial_state)

    -- Undo all activated buffs
    state_logic.undo_activated_buffs()
    state_logic.number_of_activated_buffs = 0
    state_logic.activated_buffs = {}
    gauntlet_data.stage = 0
    gauntlet_data.mega_max_hp = 100
    gauntlet_data.hp_patch_required = 0
    gauntlet_data.folder_shuffle_state = 1
    gauntlet_data.mega_style = 0x00
    gauntlet_data.mega_AirShoes = 0
    gauntlet_data.mega_FastGauge = 0
    gauntlet_data.mega_UnderShirt = 0
    gauntlet_data.mega_SuperArmor = 0
    gauntlet_data.mega_AttackPlus = 0
    gauntlet_data.mega_ChargePlus = 0
    gauntlet_data.mega_SpeedPlus = 0
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
    state_logic.loadout_chosen = 0
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
    gauntlet_data.skill_not_luck_bonus_per_battle = 5
    gauntlet_data.skill_not_luck_bonus_current = 0

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
    
    gauntlet_data.temporary_damage_bonus_mult = {
        CURRENT = 1.0,
        LIMIT = 1.0,
        BASE = 1.0,
        PERFECT_FIGHT_INCREASE = 0.0

    }

    gauntlet_data.temporary_damage_bonus_add = {
        CURRENT = 0,
        LIMIT = 0,
        BASE = 0,
        PERFECT_FIGHT_INCREASE = 0

    }

    gauntlet_data.mega_regen_after_battle_relative_to_max = 0
    
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
    
    gauntlet_data.current_state = gauntlet_data.GAME_STATE.DEFAULT_WAITING_FOR_EVENTS

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


function state_logic.patch_before_battle_start()

    -- Patch folder with all new stuff.
    -- state_logic.randomize_folder()

    if gauntlet_data.snecko_eye_enabled == 1 then

        -- Randomize folder codes
        state_logic.randomize_snecko_folder_codes(gauntlet_data.current_folder)

    end


    mmbn3_utils.patch_folder(gauntlet_data.current_folder, GENERIC_DEFS.FOLDER_START_ADDRESS_RAM)

    local new_battle_data = nil

    if state_logic.current_battle % GAUNTLET_DEFS.BOSS_BATTLE_INTERVAL == 0 then
        new_battle_data = battle_data_generator.random_from_battle(state_logic.current_battle, gauntlet_data.next_boss)
        gauntlet_data.next_boss = battle_data_generator.random_boss(state_logic.current_battle + GAUNTLET_DEFS.BOSS_BATTLE_INTERVAL)
    else
        new_battle_data = battle_data_generator.random_from_battle(state_logic.current_battle, nil)
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

        local current_hp = memory.read_u16_le(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_LOADING - 0x02000000, "EWRAM")

        

        print("Regenerator current HP before regen " .. tostring(current_hp))
        
        current_hp = math.floor(current_hp + gauntlet_data.mega_max_hp * gauntlet_data.mega_regen_after_battle_relative_to_max)

        

        if current_hp > gauntlet_data.mega_max_hp then
            current_hp = gauntlet_data.mega_max_hp
        end

        print("Regenerator current HP after regen " .. tostring(current_hp))

        memory.write_u16_le(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_LOADING - 0x02000000, current_hp, "EWRAM")
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


    if input_handler.inputs_pressed["Start"] == true then
        gauntlet_data.folder_shuffle_state = (gauntlet_data.folder_shuffle_state + 1) % 4
        state_logic.shuffle_folder()
        
        state_logic.should_redraw = 1
    end

end


function state_logic.damage_taken()

    
    gauntlet_data.has_mega_been_hit = 1
    gauntlet_data.number_of_perfect_fights = 0

end

function state_logic.main_loop()

    if DEBUG == 1 then
        print ("DEBUG: STATE: ", gauntlet_data.current_state)
    end
    input_handler.handle_inputs()


    state_logic.check_reset()


    
    --print ("Current state: " .. gauntlet_data.current_state)
    if gauntlet_data.current_state == gauntlet_data.GAME_STATE.RUNNING then

        -- Check if mega gets hit for certain buffs
        
        local number_of_entities = #(state_logic.battle_data[state_logic.current_battle - 1].ENTITIES)
        --print("Number of entities in battle: " .. tostring(number_of_entities))
        
        local current_hp = memory.read_u16_le(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_BATTLE[number_of_entities] - 0x02000000, "EWRAM")
        
        if current_hp < gauntlet_data.last_hp and current_hp ~= 0 then
            print("Damage taken! (Previous HP: " .. tostring(gauntlet_data.last_hp) .. ", Current HP: " .. tostring(current_hp) .. ", Max HP: " .. tostring(gauntlet_data.mega_max_hp) .. ")")
            state_logic.damage_taken()

        end

        gauntlet_data.last_hp = current_hp


    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.TRANSITION_TO_CHIP_SELECT then
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

        state_logic.folder_view_switch_and_sort()

        if input_handler.inputs_pressed["A"] == true then

            --print("Selected a Chip!")
            
            state_logic.dropped_chip = state_logic.dropped_chips[state_logic.dropped_chip_render_index]


            state_logic.dropped_chip.PRINT_NAME = state_logic.get_printable_chip_name(state_logic.dropped_chip)
            state_logic.dropped_chip.ARGB_ICON = state_logic.get_argb_icon(state_logic.dropped_chip)
            gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_CHIP_REPLACE
            gauntlet_data.folder_view = 0
            state_logic.should_redraw = 1
        end

        if state_logic.should_redraw == 1 then

            
            if gauntlet_data.folder_view == 0 then
                gui_rendering.render_chip_selection(state_logic.dropped_chips, state_logic.dropped_chip_render_index)
            elseif gauntlet_data.folder_view == 1 then
                gui_rendering.render_folder(gauntlet_data.current_folder, nil, nil, gauntlet_data, MusicLoader.FinishedLoading)
            elseif gauntlet_data.folder_view == 2 then
                gui_rendering.render_buffs(state_logic.activated_buffs, MusicLoader.FinishedLoading)
            end


            
            gui.DrawFinish()
            memorysavestate.loadcorestate(state_logic.gui_change_savestate)
            state_logic.should_redraw = 0
        end



        

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.TRANSITION_TO_CHIP_REPLACE then
        state_logic.gui_change_savestate = memorysavestate.savecorestate()
        memorysavestate.loadcorestate(state_logic.gui_change_savestate)
        -- print(state_logic.dropped_chip)
        --print("Transition to chip replace.")
        state_logic.shuffle_folder()
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.CHIP_REPLACE
        state_logic.should_redraw = 1

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.CHIP_REPLACE then
        --print("IN CHIP_REPLACE")
        -- Render folder, respond to inputs for selected chip. Patch folder for selected chip, then unpause.
        --print(gauntlet_data.current_state)
        -- We render 15 x 2 chips.
        
        local num_chips_per_col = 15
        local num_chips_per_folder = 30

        if input_handler.inputs_pressed["Start"] == true then
            -- Shuffle folder according to Alpha/Code/ID/Attack
            gauntlet_data.folder_shuffle_state = (gauntlet_data.folder_shuffle_state + 1) % 4
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
                    

                    
                    gauntlet_data.current_folder[state_logic.folder_chip_render_index] = state_logic.dropped_chip
                    gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_RUNNING
                    state_logic.should_redraw = 1

                    state_logic.update_folder_mega_giga_chip_counts()
                    gauntlet_data.folder_view = 0
                    
                end

            else
                gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_RUNNING
                gauntlet_data.folder_view = 0
                state_logic.should_redraw = 1
            end
        end

        if input_handler.inputs_pressed["B"] == true and (MusicLoader.FinishedLoading == 1 or GENERIC_DEFS.ENABLE_MUSIC_PATCHING == 0)  then
            -- Just skip - we didn't want a chip!
            --print("B pressed")
            gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_RUNNING
            
            state_logic.should_redraw = 1
        end
        --print(state_logic.folder_chip_render_index)

        if state_logic.should_redraw == 1 then


            
            
            if gauntlet_data.folder_view == 0 then
                gui_rendering.render_folder(gauntlet_data.current_folder, state_logic.folder_chip_render_index, state_logic.dropped_chip, gauntlet_data, MusicLoader.FinishedLoading)
            elseif gauntlet_data.folder_view == 1 then
                gui_rendering.render_folder(gauntlet_data.current_folder, state_logic.folder_chip_render_index, state_logic.dropped_chip, gauntlet_data, MusicLoader.FinishedLoading)
            elseif gauntlet_data.folder_view == 2 then
                gui_rendering.render_buffs(state_logic.activated_buffs, MusicLoader.FinishedLoading)
            end
            
            
            
            gui.DrawFinish()
            memorysavestate.loadcorestate(state_logic.gui_change_savestate)
            state_logic.should_redraw = 0
        end

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.TRANSITION_TO_BUFF_SELECT then    

        state_logic.gui_change_savestate = memorysavestate.savecorestate()
        --print("TRANSITION TO BUFF SELECT")
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.BUFF_SELECT
        state_logic.should_redraw = 1
        state_logic.dropped_buffs = BUFF_GENERATOR.random_buffs_from_round(state_logic.current_round, GAUNTLET_DEFS.NUMBER_OF_DROPPED_BUFFS, state_logic.current_battle)
        state_logic.update_buff_discriptions()
        memorysavestate.loadcorestate(state_logic.gui_change_savestate)
        client.pause()

        -- Determine number of Mega/Giga chips in folder.
        if state_logic.initial_chip_amount_flag == 0 then

            for key, chip in pairs(gauntlet_data.current_folder) do

                if (CHIP_DATA[chip.ID].CHIP_RANKING % 4) == 1 then
        
                    gauntlet_data.current_number_of_mega_chips = gauntlet_data.current_number_of_mega_chips + 1
        
                elseif (CHIP_DATA[chip.ID].CHIP_RANKING % 4) == 2 then
        
                    gauntlet_data.current_number_of_giga_chips = gauntlet_data.current_number_of_giga_chips + 1
        
                end
            
            end

            state_logic.initial_chip_amount_flag = 1
        end
    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.BUFF_SELECT then
        --print ("IN BUFF_SELECT")
        
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

        state_logic.folder_view_switch_and_sort()


        if input_handler.inputs_pressed["A"] == true then

            --print("Selected a Chip!")
            
            -- Restore CHIP_DATA to copy so temporary buffs work fine.
            for key, chip_data in pairs(CHIP_DATA) do
                state_logic.CHIP_DATA_COPY[key] = deepcopy(CHIP_DATA[key])
            end
            
            
            local dropped_buff = state_logic.dropped_buffs[state_logic.dropped_buff_render_index]
            BUFF_GENERATOR.activate_buff(dropped_buff, state_logic.current_round)

            -- Copy (potentially new) CHIP_DATA to copy so temporary buffs work fine.
            for key, chip_data in pairs(CHIP_DATA) do
                state_logic.CHIP_DATA_COPY[key] = deepcopy(CHIP_DATA[key])
            end

            state_logic.number_of_activated_buffs = state_logic.number_of_activated_buffs + 1
            state_logic.activated_buffs[state_logic.number_of_activated_buffs] = dropped_buff

            gauntlet_data.folder_view = 0
            gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_CHIP_SELECT
            state_logic.should_redraw = 1
            state_logic.update_printable_chip_names_in_folder()
            state_logic.update_argb_chip_icons_in_folder()
            state_logic.update_folder_mega_giga_chip_counts()
        end

        if state_logic.should_redraw == 1 then


            if gauntlet_data.folder_view == 0 then
                gui_rendering.render_items(state_logic.dropped_buffs, state_logic.dropped_buff_render_index)
            elseif gauntlet_data.folder_view == 1 then
                gui_rendering.render_folder(gauntlet_data.current_folder, nil, nil, gauntlet_data, MusicLoader.FinishedLoading)
            elseif gauntlet_data.folder_view == 2 then
                gui_rendering.render_buffs(state_logic.activated_buffs, MusicLoader.FinishedLoading)
            end

            
            gui.DrawFinish()
            memorysavestate.loadcorestate(state_logic.gui_change_savestate)
            state_logic.should_redraw = 0
        end
        
    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.TRANSITION_TO_RUNNING then

        state_logic.patch_before_battle_start()
        --mmbn3_utils.change_number_of_cust_screen_chips(gauntlet_data.cust_style_number_of_chips + gauntlet_data.cust_screen_number_of_chips)  
        
        --print("Patched folder!")
        client.unpause()
         --mmbn3_utils.change_megaMan_max_hp(gauntlet_data.mega_max_hp) 
        
        gauntlet_data.current_state = gauntlet_data.GAME_STATE.RUNNING
        
    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.LOAD_INITIAL then
        -- Simply load initial state again if we beat all rounds.
        savestate.load(state_logic.initial_state)
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

        state_logic.folder_view_switch_and_sort()


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
            state_logic.loadout_chosen = 1
            state_logic.selected_loadout_index = 2
            
        end

        if state_logic.should_redraw == 1 then
            
            if gauntlet_data.folder_view == 0 then
                gui_rendering.render_items(LOADOUTS, state_logic.selected_loadout_index)
            elseif gauntlet_data.folder_view == 1 then
                gui_rendering.render_folder(gauntlet_data.current_folder, nil, nil, gauntlet_data, MusicLoader.FinishedLoading)
            elseif gauntlet_data.folder_view == 2 then
                gui_rendering.render_buffs(state_logic.activated_buffs, MusicLoader.FinishedLoading)
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

        state_logic.folder_view_switch_and_sort()


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

        if state_logic.should_redraw == 1 then


            if gauntlet_data.folder_view == 0 then
                gui_rendering.render_items(CHIP_DROP_METHODS, state_logic.selected_drop_method_index)
            elseif gauntlet_data.folder_view == 1 then
                gui_rendering.render_folder(gauntlet_data.current_folder, nil, nil, gauntlet_data, MusicLoader.FinishedLoading)
            elseif gauntlet_data.folder_view == 2 then
                gui_rendering.render_buffs(state_logic.activated_buffs, MusicLoader.FinishedLoading)
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
        

        for draft_chip_idx = 1,GAUNTLET_DEFS.NUMBER_OF_DRAFT_CHIPS do
            --print("idx ", draft_chip_idx)
            state_logic.draft_selection_chips[draft_chip_idx] = gauntlet_data.folder_draft_chip_generator(#gauntlet_data.current_folder + 1)
            --print("idxx ", draft_chip_idx)
            state_logic.draft_selection_chips[draft_chip_idx].PRINT_NAME = state_logic.get_printable_chip_name(state_logic.draft_selection_chips[draft_chip_idx])
        end

        --print("After folder draft generator")
        state_logic.update_argb_chip_icons_in_folder()
        state_logic.update_dropped_chips_pictures(state_logic.draft_selection_chips)
        --print("Folder:", gauntlet_data.current_folder)

        if #gauntlet_data.current_folder == 30 then

            gauntlet_data.current_state = gauntlet_data.GAME_STATE.TRANSITION_TO_BUFF_SELECT

        end
        
        memorysavestate.loadcorestate(state_logic.gui_change_savestate)
        client.pause()

    elseif gauntlet_data.current_state == gauntlet_data.GAME_STATE.DRAFT_FOLDER then
        

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

        state_logic.folder_view_switch_and_sort()

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

        if state_logic.should_redraw == 1 then

            if gauntlet_data.folder_view == 0 then
                gui_rendering.render_chip_selection(state_logic.draft_selection_chips, state_logic.draft_chip_render_index)
            elseif gauntlet_data.folder_view == 1 then
                gui_rendering.render_folder(gauntlet_data.current_folder, nil, nil, gauntlet_data, MusicLoader.FinishedLoading)
            elseif gauntlet_data.folder_view == 2 then
                gui_rendering.render_buffs(state_logic.activated_buffs, MusicLoader.FinishedLoading)
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
        

    else -- Default state, should never happen
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

    emu.yield()
end

return state_logic