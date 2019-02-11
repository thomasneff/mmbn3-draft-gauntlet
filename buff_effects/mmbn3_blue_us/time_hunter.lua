local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local TimeHunter = {
    NAME = "Time Hunter",
}

local CUST_BUFF_PER_FRAME = 0.1
local CUST_NERF_PER_FRAME = -0.05

function TimeHunter:activate(current_round)

    gauntlet_data.custgauge_per_enemy_count[1] = gauntlet_data.custgauge_per_enemy_count[1] + CUST_BUFF_PER_FRAME
    gauntlet_data.custgauge_per_enemy_count[2] = gauntlet_data.custgauge_per_enemy_count[2] + CUST_NERF_PER_FRAME
    gauntlet_data.custgauge_per_enemy_count[3] = gauntlet_data.custgauge_per_enemy_count[3] + CUST_NERF_PER_FRAME
    gauntlet_data.custgauge_per_enemy_count[4] = gauntlet_data.custgauge_per_enemy_count[4] + CUST_NERF_PER_FRAME

end


function TimeHunter:deactivate(current_round)

    gauntlet_data.custgauge_per_enemy_count[1] = gauntlet_data.custgauge_per_enemy_count[1] - CUST_BUFF_PER_FRAME
    gauntlet_data.custgauge_per_enemy_count[2] = gauntlet_data.custgauge_per_enemy_count[2] - CUST_NERF_PER_FRAME
    gauntlet_data.custgauge_per_enemy_count[3] = gauntlet_data.custgauge_per_enemy_count[3] - CUST_NERF_PER_FRAME
    gauntlet_data.custgauge_per_enemy_count[4] = gauntlet_data.custgauge_per_enemy_count[4] - CUST_NERF_PER_FRAME

end

function TimeHunter:get_description(current_round)

    return "When only 1 enemy is alive,\nincrease CustGauge speed!"

end

function TimeHunter:get_brief_description()

    return TimeHunter.NAME .. ": " .."1 enemy -> CustGauge speed increase!"
    
end

function TimeHunter.new()

    local new_TimeHunter = deepcopy(TimeHunter)

    new_TimeHunter.DESCRIPTION = new_TimeHunter:get_description(1)

    return deepcopy(new_TimeHunter)

end


return TimeHunter