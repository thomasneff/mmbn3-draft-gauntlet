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
gauntlet_data.random_seed = nil
gauntlet_data.fixed_random_seed = nil

gauntlet_data.damage_reduction_additive = 0

gauntlet_data.healing_increase_mult = 0

gauntlet_data.damage_reflect_all_percent = 0
gauntlet_data.damage_reflect_random_percent = 0

gauntlet_data.enemies_hp_regen_per_frame = 0
gauntlet_data.enemies_hp_regen_accum = 0

gauntlet_data.illusion_of_choice_active = 0

gauntlet_data.number_of_rewinds = 0

gauntlet_data.number_of_time_compressions = 0
gauntlet_data.time_compression_delay = 60
gauntlet_data.time_compression_frame_interval = 4

gauntlet_data.backstab_percentage_damage = 0
gauntlet_data.pen_nib_bonus_damage = 0

gauntlet_data.tactician_damage_per_chip = 0.25
gauntlet_data.tactician_unique_id = 0

gauntlet_data.tactician_damage = 0

return gauntlet_data