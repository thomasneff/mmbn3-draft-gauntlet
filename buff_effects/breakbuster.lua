local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local BreakBuster = {
    NAME = "BreakBuster",
    REMOVE_AFTER_ACTIVATION = 1,
}



function BreakBuster:activate(current_round)

    self.old_BreakBuster = gauntlet_data.mega_BreakBuster
    gauntlet_data.mega_BreakBuster = 1
    self.old_AttackPlus = gauntlet_data.mega_AttackPlus
    gauntlet_data.mega_AttackPlus = gauntlet_data.mega_AttackPlus + 1
    self.old_SpeedPlus = gauntlet_data.mega_SpeedPlus
    gauntlet_data.mega_SpeedPlus = gauntlet_data.mega_SpeedPlus + 1

end


function BreakBuster:deactivate(current_round)

    gauntlet_data.mega_BreakBuster = self.old_BreakBuster
    gauntlet_data.mega_AttackPlus = self.old_AttackPlus
    gauntlet_data.mega_SpeedPlus = self.old_SpeedPlus

end

function BreakBuster:get_description(current_round)

    return "Buster shots pierce, Attack + 1, Speed + 1"

end

function BreakBuster:get_brief_description()
    return BreakBuster.NAME .. ": " .. "Buster pierces, Attack + 1, Speed + 1!"
end

function BreakBuster.new()

    local new_BreakBuster = deepcopy(BreakBuster)
    new_BreakBuster.DESCRIPTION = new_BreakBuster:get_description(1)

    return deepcopy(new_BreakBuster)

end


return BreakBuster