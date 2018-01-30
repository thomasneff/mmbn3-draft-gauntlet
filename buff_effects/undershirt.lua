local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local UnderShirt = {
    NAME = "UnderShirt",
    REMOVE_AFTER_ACTIVATION = 1,
}



function UnderShirt:activate(current_round)

    self.old_UnderShirt = gauntlet_data.mega_UnderShirt
    gauntlet_data.mega_UnderShirt = 1

end


function UnderShirt:deactivate(current_round)

    gauntlet_data.mega_UnderShirt = self.old_UnderShirt

end

function UnderShirt:get_description(current_round)

    return "If your HP is larger than 1,\nsurvive at least with 1 HP!"

end



function UnderShirt.new()

    local new_UnderShirt = deepcopy(UnderShirt)
    new_UnderShirt.DESCRIPTION = new_UnderShirt:get_description(1)

    return deepcopy(new_UnderShirt)

end


return UnderShirt