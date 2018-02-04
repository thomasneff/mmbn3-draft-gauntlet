local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local DarkLicense = {
    NAME = "DarkLicense",
    REMOVE_AFTER_ACTIVATION = 1,
}



function DarkLicense:activate(current_round)

    self.old_DarkLicense = gauntlet_data.mega_DarkLicense
    gauntlet_data.mega_DarkLicense = 1

end


function DarkLicense:deactivate(current_round)

    gauntlet_data.mega_DarkLicense = self.old_DarkLicense

end

function DarkLicense:get_description(current_round)

    return "Use DarkChips without Hole!"

end



function DarkLicense.new()

    local new_DarkLicense = deepcopy(DarkLicense)
    new_DarkLicense.DESCRIPTION = new_DarkLicense:get_description(1)

    return deepcopy(new_DarkLicense)

end


return DarkLicense