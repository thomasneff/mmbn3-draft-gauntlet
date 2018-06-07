local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local AttackPlus = {
    NAME = "Attack Up!",
}



function AttackPlus:activate(current_round)

    self.old_AttackPlus = gauntlet_data.mega_AttackPlus
    gauntlet_data.mega_AttackPlus = gauntlet_data.mega_AttackPlus + 2

    self.old_WeaponLevelPlus = gauntlet_data.mega_WeaponLevelPlus
    gauntlet_data.mega_WeaponLevelPlus = gauntlet_data.mega_WeaponLevelPlus + 1

end


function AttackPlus:deactivate(current_round)

    gauntlet_data.mega_AttackPlus = self.old_AttackPlus
    gauntlet_data.mega_WeaponLevelPlus = self.old_WeaponLevelPlus

end

function AttackPlus:get_description(current_round)

    return "Increase Buster Attack by 2!\nIncrease Element-Style Weapon Level by 1!"

end

function AttackPlus:get_brief_description()
    return AttackPlus.NAME .. ": " .. "Buster Attack + 2, Style Weapon + 1!"
end

function AttackPlus.new()

    local new_AttackPlus = deepcopy(AttackPlus)

    new_AttackPlus.DESCRIPTION = new_AttackPlus:get_description(1)

    return deepcopy(new_AttackPlus)

end


return AttackPlus