local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP_ID = require "defs.chip_id_defs"

local AggressiveHealing = {
    NAME = "Aggressive Healing",
}




function AggressiveHealing:activate(current_round)



end


function AggressiveHealing:deactivate(current_round)


end

function AggressiveHealing:get_description(current_round)

    return "Recov-Family chips damage a random enemy\nfor the same amount!"

end

function AggressiveHealing:get_brief_description()
    return AggressiveHealing.NAME .. ": " .. "Recov -> damage random enemy!"
end

function AggressiveHealing:on_chip_use(chip, current_frame, state_logic, gauntlet_data)
    

    local damage = 0


    if chip.ID == CHIP_ID.Recov10 then
        damage = 10 * (1.0 + gauntlet_data.healing_increase_mult)
    elseif chip.ID == CHIP_ID.Recov30 then
        damage = 30 * (1.0 + gauntlet_data.healing_increase_mult)
    elseif chip.ID == CHIP_ID.Recov50 then
        damage = 50 * (1.0 + gauntlet_data.healing_increase_mult)
    elseif chip.ID == CHIP_ID.Recov80 then
        damage = 80 * (1.0 + gauntlet_data.healing_increase_mult)
    elseif chip.ID == CHIP_ID.Recov120 then
        damage = 120 * (1.0 + gauntlet_data.healing_increase_mult)
    elseif chip.ID == CHIP_ID.Recov150 then
        damage = 150 * (1.0 + gauntlet_data.healing_increase_mult)
    elseif chip.ID == CHIP_ID.Recov200 then
        damage = 200 * (1.0 + gauntlet_data.healing_increase_mult)
    elseif chip.ID == CHIP_ID.Recov300 then
        damage = 300 * (1.0 + gauntlet_data.healing_increase_mult)
    end

    damage = math.floor(damage)

    if damage < 1 then
        return
    end

    state_logic.damage_random_enemy(damage)
end


function AggressiveHealing.new()

    local new_AggressiveHealing = deepcopy(AggressiveHealing)
    new_AggressiveHealing.DESCRIPTION = new_AggressiveHealing:get_description(1)
    new_AggressiveHealing.ON_CHIP_USE_CALLBACK = 1

    return deepcopy(new_AggressiveHealing)

end


return AggressiveHealing