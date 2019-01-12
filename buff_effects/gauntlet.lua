local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local Gauntlet = {
    NAME = "...Gauntlet?!",
}



function Gauntlet:activate(current_round)

    self.old_Gauntlet = gauntlet_data.mega_chip_limit
    gauntlet_data.mega_chip_limit = gauntlet_data.mega_chip_limit + 3
    gauntlet_data.next_boss_override_counter = gauntlet_data.next_boss_override_counter + 5

end


function Gauntlet:deactivate(current_round)

    gauntlet_data.mega_chip_limit = self.old_Gauntlet
    gauntlet_data.next_boss_override_counter = gauntlet_data.next_boss_override_counter - 5

end

function Gauntlet:get_description(current_round)

    return "Next 5 non-boss battles are boss fights!\nMegaChip-limit + 3!"

end

function Gauntlet:get_brief_description()

    return Gauntlet.NAME .. ": 5 non-boss battles -> MegaChips + 3!\n(" .. tostring(gauntlet_data.next_boss_override_counter) .. " battles left.)"

end

function Gauntlet.new()

    local new_Gauntlet = deepcopy(Gauntlet)

    new_Gauntlet.DESCRIPTION = new_Gauntlet:get_description(1)

    return deepcopy(new_Gauntlet)

end


return Gauntlet