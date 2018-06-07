local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local WeaponLevelPlus = {
    NAME = "WeaponLevel + 1",
}



function WeaponLevelPlus:activate(current_round)

    self.old_WeaponLevelPlus = gauntlet_data.mega_WeaponLevelPlus
    gauntlet_data.mega_WeaponLevelPlus = gauntlet_data.mega_WeaponLevelPlus + 1

end


function WeaponLevelPlus:deactivate(current_round)

    gauntlet_data.mega_WeaponLevelPlus = self.old_WeaponLevelPlus

end

function WeaponLevelPlus:get_description(current_round)

    return "Increase Element-Style Weapon Level by 1!"

end

function WeaponLevelPlus:get_brief_description()
    return WeaponLevelPlus.NAME .. ": " .. "Style Weapon + 1!"
end

function WeaponLevelPlus.new()

    local new_WeaponLevelPlus = deepcopy(WeaponLevelPlus)

    new_WeaponLevelPlus.DESCRIPTION = new_WeaponLevelPlus:get_description(1)

    return deepcopy(new_WeaponLevelPlus)

end


return WeaponLevelPlus