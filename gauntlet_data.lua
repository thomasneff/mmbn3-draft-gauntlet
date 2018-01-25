-- Here we store everything that needs to be manipulated by buffs and state logic to avoid circular dependencies.

local gauntlet_data = {}
gauntlet_data.current_folder = {}
gauntlet_data.mega_max_hp = 100
gauntlet_data.hp_patch_required = 0
gauntlet_data.mega_style = 0x00
gauntlet_data.cust_style_number_of_chips = 0
gauntlet_data.cust_screen_number_of_chips = 5

return gauntlet_data