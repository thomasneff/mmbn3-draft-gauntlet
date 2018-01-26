local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local CustomPlus = {
    NAME = "Custom + 1",
}



function CustomPlus:activate(current_round)

    self.old_CustomPlus = gauntlet_data.cust_screen_number_of_chips
    gauntlet_data.cust_screen_number_of_chips = gauntlet_data.cust_screen_number_of_chips + 1

end


function CustomPlus:deactivate(current_round)

    gauntlet_data.cust_screen_number_of_chips = self.old_CustomPlus

end

function CustomPlus:get_description(current_round)

    return "Increase number of Chips in\nCustom Screen by 1!"

end



function CustomPlus.new()

    local new_CustomPlus = deepcopy(CustomPlus)

    new_CustomPlus.DESCRIPTION = new_CustomPlus:get_description(1)

    return deepcopy(new_CustomPlus)

end


return CustomPlus