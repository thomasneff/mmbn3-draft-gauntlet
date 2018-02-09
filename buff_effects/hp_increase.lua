local gauntlet_data = require "gauntlet_data"
local CHIP_DATA = require "defs.chip_data_defs"
local HP_INCREASE = {

    NAME = "Tank",

}

local HP_INCREASE_PER_ROUND = {50, 100, 200, 300, 400}
local DAMAGE_INCREASE_MULT = {-10, -10, -10, -10, -10}


function HP_INCREASE:activate(current_round)

    gauntlet_data.mega_max_hp = gauntlet_data.mega_max_hp + HP_INCREASE_PER_ROUND[current_round]
    gauntlet_data.hp_patch_required = 1

    -- This is an example for how to modify chip data.
    self.old_chip_data = deepcopy(CHIP_DATA)
    
    for key, chip_data in pairs(CHIP_DATA) do
        CHIP_DATA[key].DAMAGE = math.floor(CHIP_DATA[key].DAMAGE * ((100.0 + DAMAGE_INCREASE_MULT[current_round]) / 100.0))
    end

end


function HP_INCREASE:deactivate(current_round)

    gauntlet_data.mega_max_hp = gauntlet_data.mega_max_hp - HP_INCREASE_PER_ROUND[current_round]
    gauntlet_data.hp_patch_required = 1

    -- This is an example for how to modify chip data.
    for key, chip_data in pairs(CHIP_DATA) do

        if chip_data.ELEMENT == self.ELEMENT then
            CHIP_DATA[key] = deepcopy(self.old_chip_data[key])
        end

    end

end

function HP_INCREASE:get_description(current_round)

    return "Increases HP by " .. tostring(HP_INCREASE_PER_ROUND[current_round]) .. ",\nDecreases Chip Damage by " .. -DAMAGE_INCREASE_MULT[current_round] .."%!"


end



function HP_INCREASE.new()

    return deepcopy(HP_INCREASE)

end


return HP_INCREASE