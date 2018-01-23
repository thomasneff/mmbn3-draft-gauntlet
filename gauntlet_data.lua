-- Here we store everything that needs to be manipulated by buffs and state logic to avoid circular dependencies.

local gauntlet_data = {}
gauntlet_data.current_folder = {}
gauntlet_data.mega_max_hp = 100
gauntlet_data.hp_patch_required = 0


return gauntlet_data