local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local SpeedPlus = {
    NAME = "Speed + 3",
}



function SpeedPlus:activate(current_round)

    self.old_SpeedPlus = gauntlet_data.mega_SpeedPlus
    gauntlet_data.mega_SpeedPlus = gauntlet_data.mega_SpeedPlus + 3
    
    if gauntlet_data.mega_SpeedPlus > 6 then
        gauntlet_data.mega_SpeedPlus = 6
    end

end


function SpeedPlus:deactivate(current_round)

    gauntlet_data.mega_SpeedPlus = self.old_SpeedPlus

end

function SpeedPlus:get_description(current_round)

    return "Increase Buster Speed by 3!"

end

function SpeedPlus:get_brief_description()
    return SpeedPlus.NAME .. ": " .. "Buster Speed + 3"
end

function SpeedPlus.new()

    local new_SpeedPlus = deepcopy(SpeedPlus)

    new_SpeedPlus.DESCRIPTION = new_SpeedPlus:get_description(1)

    return deepcopy(new_SpeedPlus)

end


return SpeedPlus