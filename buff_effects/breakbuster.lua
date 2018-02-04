local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local BreakBuster = {
    NAME = "BreakBuster",
    REMOVE_AFTER_ACTIVATION = 1,
}



function BreakBuster:activate(current_round)

    self.old_BreakBuster = gauntlet_data.mega_BreakBuster
    gauntlet_data.mega_BreakBuster = 1

end


function BreakBuster:deactivate(current_round)

    gauntlet_data.mega_BreakBuster = self.old_BreakBuster

end

function BreakBuster:get_description(current_round)

    return "Buster shots pierce armor!"

end



function BreakBuster.new()

    local new_BreakBuster = deepcopy(BreakBuster)
    new_BreakBuster.DESCRIPTION = new_BreakBuster:get_description(1)

    return deepcopy(new_BreakBuster)

end


return BreakBuster