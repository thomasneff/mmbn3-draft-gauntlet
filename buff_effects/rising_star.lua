local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local RisingStar = {
    NAME = "Rising Star",
}

function RisingStar:activate(current_round)

    self.old_rising_star_count = gauntlet_data.rising_star_count
    gauntlet_data.rising_star_count = gauntlet_data.rising_star_count + 1

end


function RisingStar:deactivate(current_round)

    gauntlet_data.rising_star_count = self.old_rising_star_count

end

function RisingStar:get_description(current_round)

    return "The " .. tostring(self.num_stars_at_activation + 1) .. ". Chip drawn in battle is *-Code!"

end

function RisingStar:get_brief_description()
    return RisingStar.NAME .. ": " .. tostring(self.num_stars_at_activation + 1) .. " Chip in battle -> *-Code!"
end

function RisingStar.new()

    local new_RisingStar = deepcopy(RisingStar)

    new_RisingStar.num_stars_at_activation = gauntlet_data.rising_star_count

    new_RisingStar.DESCRIPTION = new_RisingStar:get_description(1)

    return deepcopy(new_RisingStar)

end


return RisingStar