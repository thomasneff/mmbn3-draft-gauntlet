local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local GigaChipPlus = {
    NAME = "GigaChips + 1",
}



function GigaChipPlus:activate(current_round)

    self.old_GigaChipPlus = gauntlet_data.giga_chip_limit
    gauntlet_data.giga_chip_limit = gauntlet_data.giga_chip_limit + 1

end


function GigaChipPlus:deactivate(current_round)

    gauntlet_data.giga_chip_limit = self.old_GigaChipPlus

end

function GigaChipPlus:get_description(current_round)

    return "Increase number of possible\nGigaChips in Folder by 1!"

end



function GigaChipPlus.new()

    local new_GigaChipPlus = deepcopy(GigaChipPlus)

    new_GigaChipPlus.DESCRIPTION = new_GigaChipPlus:get_description(1)

    return deepcopy(new_GigaChipPlus)

end


return GigaChipPlus