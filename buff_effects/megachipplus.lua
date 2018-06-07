local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local MegaChipPlus = {
    NAME = "MegaChips + 2",
}



function MegaChipPlus:activate(current_round)

    self.old_MegaChipPlus = gauntlet_data.mega_chip_limit
    gauntlet_data.mega_chip_limit = gauntlet_data.mega_chip_limit + 2

end


function MegaChipPlus:deactivate(current_round)

    gauntlet_data.mega_chip_limit = self.old_MegaChipPlus

end

function MegaChipPlus:get_description(current_round)

    return "Increase number of possible\nMegaChips in Folder by 2!"

end

function MegaChipPlus:get_brief_description()
    return MegaChipPlus.NAME .. ": MegaChips + 2!"
end

function MegaChipPlus.new()

    local new_MegaChipPlus = deepcopy(MegaChipPlus)

    new_MegaChipPlus.DESCRIPTION = new_MegaChipPlus:get_description(1)

    return deepcopy(new_MegaChipPlus)

end


return MegaChipPlus