local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local ChargePlus = {
    NAME = "Charge + 3",
}



function ChargePlus:activate(current_round)

    self.old_ChargePlus = gauntlet_data.mega_ChargePlus
    gauntlet_data.mega_ChargePlus = gauntlet_data.mega_ChargePlus + 3

    if gauntlet_data.mega_ChargePlus > 4 then
        gauntlet_data.mega_ChargePlus = 4
    end

end


function ChargePlus:deactivate(current_round)

    gauntlet_data.mega_ChargePlus = self.old_ChargePlus

end

function ChargePlus:get_description(current_round)

    return "Increase Buster Charge by 3!"

end

function ChargePlus:get_brief_description()
    return ChargePlus.NAME .. ": " .. "Buster Charge + 3"
end

function ChargePlus.new()

    local new_ChargePlus = deepcopy(ChargePlus)

    new_ChargePlus.DESCRIPTION = new_ChargePlus:get_description(1)

    return deepcopy(new_ChargePlus)

end


return ChargePlus