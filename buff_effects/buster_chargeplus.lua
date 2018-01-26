local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local ChargePlus = {
    NAME = "Charge + 1",
}



function ChargePlus:activate(current_round)

    self.old_ChargePlus = gauntlet_data.mega_ChargePlus
    gauntlet_data.mega_ChargePlus = gauntlet_data.mega_ChargePlus + 1

end


function ChargePlus:deactivate(current_round)

    gauntlet_data.mega_ChargePlus = self.old_ChargePlus

end

function ChargePlus:get_description(current_round)

    return "Increase Buster Charge by 1!"

end



function ChargePlus.new()

    local new_ChargePlus = deepcopy(ChargePlus)

    new_ChargePlus.DESCRIPTION = new_ChargePlus:get_description(1)

    return deepcopy(new_ChargePlus)

end


return ChargePlus