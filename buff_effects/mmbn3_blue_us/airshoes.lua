local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local AirShoes = {
    NAME = "AirShoes",
    REMOVE_AFTER_ACTIVATION = 1,
}



function AirShoes:activate(current_round)

    self.old_AirShoes = gauntlet_data.mega_AirShoes
    gauntlet_data.mega_AirShoes = 1
    self.activated_round = current_round

end


function AirShoes:deactivate(current_round)

    gauntlet_data.mega_AirShoes = self.old_AirShoes

end

function AirShoes:get_description(current_round)

    return "Ignore hole panels!"

end

function AirShoes:get_brief_description()
    return AirShoes.NAME .. ": " .. "Ignore holes!"
end

function AirShoes.new()

    local new_AirShoes = deepcopy(AirShoes)

    new_AirShoes.DESCRIPTION = new_AirShoes:get_description(1)

    return deepcopy(new_AirShoes)

end


return AirShoes