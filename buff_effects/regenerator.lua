local gauntlet_data = require "gauntlet_data"
local CHIP_DATA = require "defs.chip_data_defs"
local REGENERATOR = {

    NAME = "Regenerator",

}

local REGENERATOR_PER_ROUND = {0.05, 0.05, 0.05, 0.05, 0.05}
local DAMAGE_INCREASE_MULT = {-10, -10, -10, -10, -10}


function REGENERATOR:activate(current_round)

    self.mega_regen_after_battle_relative_to_max = gauntlet_data.mega_regen_after_battle_relative_to_max
    gauntlet_data.mega_regen_after_battle_relative_to_max = gauntlet_data.mega_regen_after_battle_relative_to_max + REGENERATOR_PER_ROUND[current_round]


    -- This is an example for how to modify chip data.
    self.old_chip_data = deepcopy(CHIP_DATA)
    
    for key, chip_data in pairs(CHIP_DATA) do
        CHIP_DATA[key].DAMAGE = math.floor(CHIP_DATA[key].DAMAGE * ((100.0 + DAMAGE_INCREASE_MULT[current_round]) / 100.0))
    end

    self.current_round = current_round

end


function REGENERATOR:deactivate(current_round)

    gauntlet_data.mega_regen_after_battle_relative_to_max = self.mega_regen_after_battle_relative_to_max

    -- This is an example for how to modify chip data.
    for key, chip_data in pairs(CHIP_DATA) do

        CHIP_DATA[key] = deepcopy(self.old_chip_data[key])

    end

end

function REGENERATOR:get_description(current_round)

    return "Regenerate " .. tostring(REGENERATOR_PER_ROUND[current_round] * 100)  .. "% of MaxHP after every battle!\nDecreases Chip Damage by " .. -DAMAGE_INCREASE_MULT[current_round] .."%!"


end

function REGENERATOR:get_brief_description()
    return REGENERATOR.NAME .. ": HP +" .. REGENERATOR_PER_ROUND[self.current_round] * gauntlet_data.mega_max_hp .. " per battle, -" .. DAMAGE_INCREASE_MULT[self.current_round] .. "% chip dmg!"
end

function REGENERATOR.new()

    return deepcopy(REGENERATOR)

end


return REGENERATOR