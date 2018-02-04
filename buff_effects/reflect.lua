local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local Reflect = {
    NAME = "Reflect",
    REMOVE_AFTER_ACTIVATION = 1,
}



function Reflect:activate(current_round)

    self.old_Reflect = gauntlet_data.mega_Reflect
    gauntlet_data.mega_Reflect = 0x06

end


function Reflect:deactivate(current_round)

    gauntlet_data.mega_Reflect = self.old_Reflect

end

function Reflect:get_description(current_round)

    return "Reflect with B + Left!"

end



function Reflect.new()

    local new_Reflect = deepcopy(Reflect)
    new_Reflect.DESCRIPTION = new_Reflect:get_description(1)

    return deepcopy(new_Reflect)

end


return Reflect