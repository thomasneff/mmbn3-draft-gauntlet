-- Here we store everything that needs to be Manipulated by buffs and state logic to avoid circular dependencies.


local gauntlet_data = {}

gauntlet_data.GAME_STATE = {
    RUNNING = 0x00,
    TRANSITION_TO_CHIP_SELECT = 0x01,
    CHIP_SELECT = 0x02,
    TRANSITION_TO_CHIP_REPLACE = 0x03,
    CHIP_REPLACE = 0x04,
    TRANSITION_TO_RUNNING = 0x05,
    TRANSITION_TO_BUFF_SELECT = 0x06,
    BUFF_SELECT = 0x07,
    WAIT_FOR_HP_PATCH = 0x08,
    LOAD_INITIAL = 0x09,
    TRANSITION_TO_CHOOSE_STARTING_LOADOUT = 0x0A,
    CHOOSE_STARTING_LOADOUT = 0x0B,
    TRANSITION_TO_DRAFT_FOLDER = 0x0C,
    DRAFT_FOLDER = 0x0D,
    TRANSITION_TO_CHOOSE_DROP_METHOD = 0x0E,
    CHOOSE_DROP_METHOD = 0x0F,
    TRANSITION_TO_GAUNTLET_COMPLETE = 0x10,
    GAUNTLET_COMPLETE = 0x11,
    DEFAULT_WAITING_FOR_EVENTS = 0x12,
    TRANSITION_TO_CHOOSE_DIFFICULTY = 0x13,
    CHOOSE_DIFFICULTY = 0x14,    
}


gauntlet_data.current_folder = {}
gauntlet_data.folder_shuffle_state = 0
gauntlet_data.hp_patch_required = 0
gauntlet_data.cust_style_number_of_chips = 0
gauntlet_data.cust_screen_number_of_chips = 5
gauntlet_data.stage = 0
gauntlet_data.mega_max_hp = 100
gauntlet_data.mega_regen_after_battle_relative_to_max = 0
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
gauntlet_data.mega_chip_limit = 5
gauntlet_data.mega_chip_limit_team = 0
gauntlet_data.giga_chip_limit = 1
gauntlet_data.current_number_of_mega_chips = 0
gauntlet_data.current_number_of_giga_chips = 0
gauntlet_data.folder_view = 0
gauntlet_data.current_state = gauntlet_data.GAME_STATE.RUNNING
gauntlet_data.folder_draft_chip_list = {}
gauntlet_data.folder_draft_chip_generator = {}
gauntlet_data.chip_drop_method = {}
gauntlet_data.snecko_eye_enabled = 0
gauntlet_data.snecko_eye_number_of_codes = 7
gauntlet_data.snecko_eye_randomize_asterisk = 1
gauntlet_data.has_mega_been_hit = 0
gauntlet_data.number_of_perfect_fights = 0
gauntlet_data.last_hp = 0
gauntlet_data.perfectionist_damage_bonus_mult = {
    CURRENT = 1.0,
    BASE = 1.0,
    LIMIT = 1.0,
    PERFECT_FIGHT_INCREASE = 0.0

}

gauntlet_data.perfectionist_damage_bonus_add = {
    CURRENT = 0,
    LIMIT = 0,
    BASE = 0,
    PERFECT_FIGHT_INCREASE = 0

}

gauntlet_data.rarity_mods = {
    [1] = 0, -- Common
    [2] = 0, -- Rare
    [3] = 0, -- SuperRare
    [4] = 0, -- UltraRare
}


gauntlet_data.force_minibombs_lower_than_ultra_rare = 0

gauntlet_data.skill_not_luck_active = 0
gauntlet_data.skill_not_luck_bonus_per_battle = 0
gauntlet_data.skill_not_luck_bonus_current = 0
gauntlet_data.skill_not_luck_number_of_fights = 0

gauntlet_data.next_boss = nil

gauntlet_data.statistics_container = nil

gauntlet_data.collector_duplicate_damage_bonus = 0.0
gauntlet_data.collector_active = 0

gauntlet_data.copy_paste_active_number_of_buffs = 0

gauntlet_data.battle_stages = {}

gauntlet_data.top_tier_active = 0
gauntlet_data.top_tier_chance = 0
gauntlet_data.damage_reduction_additive = 0

gauntlet_data.healing_increase_mult = 0

gauntlet_data.damage_reflect_all_percent = 0
gauntlet_data.damage_reflect_random_percent = 0

gauntlet_data.enemies_hp_regen_per_frame = 0
gauntlet_data.enemies_hp_regen_accum = 0

gauntlet_data.illusion_of_choice_active = 0

gauntlet_data.number_of_rewinds = 0

gauntlet_data.number_of_time_compressions = 0
gauntlet_data.current_battle_number_of_time_compressions = 0

gauntlet_data.time_compression_delay = 60
gauntlet_data.time_compression_frame_interval = 4

gauntlet_data.backstab_percentage_damage = 0
gauntlet_data.pen_nib_bonus_damage = 0

gauntlet_data.tactician_damage_per_chip = 0.25
gauntlet_data.tactician_unique_id = 0

gauntlet_data.tactician_damage = 0

gauntlet_data.next_boss_override_counter = 0

gauntlet_data.add_random_star_code_before_battle = 0

gauntlet_data.last_known_current_hp = nil

gauntlet_data.pa_patching_enabled = 1

-- rng seed system
gauntlet_data.random_seed = nil
gauntlet_data.fixed_random_seed = nil

gauntlet_data.rng_value_map = {}
gauntlet_data.math = {}

-- Need: rng_index, last_discrete_rng_index, rng_values[]

function gauntlet_data.math.advance_rng_since_last_advance(name, advance_count)
    gauntlet_data.rng_value_map[name].INDEX = gauntlet_data.rng_value_map[name].LAST_INDEX + advance_count
    gauntlet_data.rng_value_map[name].LAST_INDEX = gauntlet_data.rng_value_map[name].INDEX
end

function gauntlet_data.math.initialize_rng_for_group(name, number_of_values)

    gauntlet_data.rng_value_map[name] = {}

    gauntlet_data.rng_value_map[name].VALUES = {}

    -- 0 is fine here, it gets incremented in random_internal anyways
    gauntlet_data.rng_value_map[name].INDEX = 0
    gauntlet_data.rng_value_map[name].LAST_INDEX = 0

    for i = 1, number_of_values do 
        gauntlet_data.rng_value_map[name].VALUES[#gauntlet_data.rng_value_map[name].VALUES + 1] = math.random()
    end

end

function gauntlet_data.math.random_buff_activation(arg1, arg2)
    return gauntlet_data.math.random_named("BUFF_ACTIVATION", arg1, arg2)
end

function gauntlet_data.math.random_in_battle(arg1, arg2)
    return gauntlet_data.math.random_named("IN_BATTLE", arg1, arg2)
end

function gauntlet_data.math.random_music(arg1, arg2)
    return gauntlet_data.math.random_named("MUSIC", arg1, arg2)
end

function gauntlet_data.math.random_named(name, arg1, arg2)
   
    if name == nil then
        print("NO NAME SUPPLIED!")
        print("ARGS: " .. tostring(arg1) .. ", " .. tostring(arg2))
    end

    if gauntlet_data.rng_value_map[name] == nil then
        error("Error: rng seeding went wrong when accessing precomputed random values for name " .. name .. ", will default to math.random")
        return math.random(arg1, arg2)
    end

    -- get rng index
    local rng_index = gauntlet_data.rng_value_map[name].INDEX;

    if rng_index == nil then
        error("Error: rng seeding went wrong when accessing precomputed random values for name " .. name .. ", will default to math.random")
        return math.random(arg1, arg2)
    end

    -- advance rng index, and compute modulo'd new index
    rng_index = rng_index + 1
    gauntlet_data.rng_value_map[name].INDEX = rng_index

    rng_index = (rng_index % #(gauntlet_data.rng_value_map[name].VALUES)) + 1
    rng_value = gauntlet_data.rng_value_map[name].VALUES[rng_index]

    if arg1 == nil and arg2 == nil then

        -- Standard random, simply get a value from the rng
        return rng_value

    elseif arg1 ~= nil and arg2 == nil then

        -- Return an integer in the range of [1, arg1]
        return math.floor(rng_value * arg1) + 1


    elseif arg1 ~= nil and arg2 ~= nil then

         -- Return an integer in the range of [arg1, arg2]
         return math.floor(rng_value * (arg2 - arg1 + 1)) + arg1

    else
        error("Error, you should not call math.random with arg1 == nil and arg2 ~= nil!")
        return nil
    end

end


return gauntlet_data