local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local FloatShoes = {
    NAME = "FloatShoes",
    REMOVE_AFTER_ACTIVATION = 1,
}



function FloatShoes:activate(current_round)

    self.old_FloatShoes = gauntlet_data.mega_FloatShoes
    gauntlet_data.mega_FloatShoes = 0x02

end


function FloatShoes:deactivate(current_round)

    gauntlet_data.mega_FloatShoes = self.old_FloatShoes

end

function FloatShoes:get_description(current_round)

    return "Ignore negative panel effects!\n(Except Poison)"

end

function FloatShoes:get_brief_description()
    return FloatShoes.NAME .. ": " .. "Ignore Ice/Magma/Cracked panels!"
end

function FloatShoes.new()

    local new_FloatShoes = deepcopy(FloatShoes)
    new_FloatShoes.DESCRIPTION = new_FloatShoes:get_description(1)

    return deepcopy(new_FloatShoes)

end


return FloatShoes