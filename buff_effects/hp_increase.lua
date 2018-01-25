local gauntlet_data = require "gauntlet_data"

local HP_INCREASE = {

    NAME = "Tank",

}

local HP_INCREASE_PER_ROUND = {50, 100, 200, 400}

function HP_INCREASE:activate(current_round)

    gauntlet_data.mega_max_hp = gauntlet_data.mega_max_hp + HP_INCREASE_PER_ROUND[current_round]
    gauntlet_data.hp_patch_required = 1

end


function HP_INCREASE:deactivate(current_round)

    gauntlet_data.mega_max_hp = gauntlet_data.mega_max_hp - HP_INCREASE_PER_ROUND[current_round]
    gauntlet_data.hp_patch_required = 1

end

function HP_INCREASE:get_description(current_round)

    return "Increases HP by " .. tostring(HP_INCREASE_PER_ROUND[current_round]) .. "."


end



function HP_INCREASE.new()

    return deepcopy(HP_INCREASE)

end


return HP_INCREASE