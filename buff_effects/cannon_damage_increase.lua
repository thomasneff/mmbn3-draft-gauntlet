local gauntlet_data = require "gauntlet_data"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_ID = require "defs.chip_id_defs"

local CANNON_DAMAGE_INCREASE = {

    NAME = "Cannonier",

}


local DAMAGE_INCREASE_PER_ROUND = {10, 20, 30, 40}

function CANNON_DAMAGE_INCREASE:activate(current_round)

    -- This is an example for how to modify chip data.
    CHIP_DATA[CHIP_ID.Cannon].DAMAGE = CHIP_DATA[CHIP_ID.Cannon].DAMAGE + DAMAGE_INCREASE_PER_ROUND[current_round]
    CHIP_DATA[CHIP_ID.HiCannon].DAMAGE = CHIP_DATA[CHIP_ID.HiCannon].DAMAGE + DAMAGE_INCREASE_PER_ROUND[current_round]
    CHIP_DATA[CHIP_ID.MCannon].DAMAGE = CHIP_DATA[CHIP_ID.MCannon].DAMAGE + DAMAGE_INCREASE_PER_ROUND[current_round]
    CHIP_DATA[CHIP_ID.ZCanon1].DAMAGE = CHIP_DATA[CHIP_ID.ZCanon1].DAMAGE + DAMAGE_INCREASE_PER_ROUND[current_round]
    CHIP_DATA[CHIP_ID.ZCanon2].DAMAGE = CHIP_DATA[CHIP_ID.ZCanon2].DAMAGE + DAMAGE_INCREASE_PER_ROUND[current_round]
    CHIP_DATA[CHIP_ID.ZCanon3].DAMAGE = CHIP_DATA[CHIP_ID.ZCanon3].DAMAGE + DAMAGE_INCREASE_PER_ROUND[current_round]


end

function CANNON_DAMAGE_INCREASE:deactivate(current_round)

    -- This is an example for how to modify chip data.
    CHIP_DATA[CHIP_ID.Cannon].DAMAGE = CHIP_DATA[CHIP_ID.Cannon].DAMAGE - DAMAGE_INCREASE_PER_ROUND[current_round]
    CHIP_DATA[CHIP_ID.HiCannon].DAMAGE = CHIP_DATA[CHIP_ID.HiCannon].DAMAGE - DAMAGE_INCREASE_PER_ROUND[current_round]
    CHIP_DATA[CHIP_ID.MCannon].DAMAGE = CHIP_DATA[CHIP_ID.MCannon].DAMAGE - DAMAGE_INCREASE_PER_ROUND[current_round]
    CHIP_DATA[CHIP_ID.ZCanon1].DAMAGE = CHIP_DATA[CHIP_ID.ZCanon1].DAMAGE - DAMAGE_INCREASE_PER_ROUND[current_round]
    CHIP_DATA[CHIP_ID.ZCanon2].DAMAGE = CHIP_DATA[CHIP_ID.ZCanon2].DAMAGE - DAMAGE_INCREASE_PER_ROUND[current_round]
    CHIP_DATA[CHIP_ID.ZCanon3].DAMAGE = CHIP_DATA[CHIP_ID.ZCanon3].DAMAGE - DAMAGE_INCREASE_PER_ROUND[current_round]

end


function CANNON_DAMAGE_INCREASE:get_description(current_round)

    return "Increases Damage of all Cannon-Type\nChips by " .. tostring(DAMAGE_INCREASE_PER_ROUND[current_round]) .. "."


end




function CANNON_DAMAGE_INCREASE.new()

    return deepcopy(CANNON_DAMAGE_INCREASE)

end


return CANNON_DAMAGE_INCREASE