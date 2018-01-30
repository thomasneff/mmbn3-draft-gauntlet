-- Here we store everything that needs to be manipulated by buffs and state logic to avoid circular dependencies.

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
    DRAFT_FOLDER = 0x0D
}


gauntlet_data.current_folder = {}
gauntlet_data.folder_shuffle_state = 0
gauntlet_data.hp_patch_required = 0
gauntlet_data.cust_style_number_of_chips = 0
gauntlet_data.cust_screen_number_of_chips = 5
gauntlet_data.stage = 0
gauntlet_data.mega_max_hp = 100
gauntlet_data.mega_style = 0x00
gauntlet_data.mega_AirShoes = 0
gauntlet_data.mega_FastGauge = 0
gauntlet_data.mega_UnderShirt = 0
gauntlet_data.mega_SuperArmor = 0
gauntlet_data.mega_AttackPlus = 0
gauntlet_data.mega_ChargePlus = 0
gauntlet_data.mega_SpeedPlus = 0
gauntlet_data.mega_WeaponLevelPlus = 1

gauntlet_data.folder_view = 0
gauntlet_data.current_state = gauntlet_data.GAME_STATE.RUNNING
gauntlet_data.folder_draft_chip_list = {}
gauntlet_data.folder_draft_chip_generator = {}

return gauntlet_data