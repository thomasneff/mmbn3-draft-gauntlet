local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local BreakCharge = {
    NAME = "BreakCharge",
    REMOVE_AFTER_ACTIVATION = 1,
}



function BreakCharge:activate(current_round)

    self.old_BreakCharge = gauntlet_data.mega_BreakCharge
    gauntlet_data.mega_BreakCharge = 1

end


function BreakCharge:deactivate(current_round)

    gauntlet_data.mega_BreakCharge = self.old_BreakCharge

end

function BreakCharge:get_description(current_round)

    return "Charge shots pierce armor!"

end



function BreakCharge.new()

    local new_BreakCharge = deepcopy(BreakCharge)
    new_BreakCharge.DESCRIPTION = new_BreakCharge:get_description(1)

    return deepcopy(new_BreakCharge)

end


return BreakCharge