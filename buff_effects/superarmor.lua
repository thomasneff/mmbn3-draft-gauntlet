local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local SuperArmor = {
    NAME = "SuperArmor",
    REMOVE_AFTER_ACTIVATION = 1,
}



function SuperArmor:activate(current_round)

    self.old_SuperArmor = gauntlet_data.mega_SuperArmor
    gauntlet_data.mega_SuperArmor = 1


end


function SuperArmor:deactivate(current_round)

    gauntlet_data.mega_SuperArmor = self.old_SuperArmor

end

function SuperArmor:get_description(current_round)

    return "Don't get interrupted\nwhen taking damage!"

end



function SuperArmor.new()

    local new_SuperArmor = deepcopy(SuperArmor)

    new_SuperArmor.DESCRIPTION = new_SuperArmor:get_description(1)

    return deepcopy(new_SuperArmor)

end


return SuperArmor