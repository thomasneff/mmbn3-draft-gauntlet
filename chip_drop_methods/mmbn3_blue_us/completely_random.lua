local CHIP = require "defs.chip_defs"


local COMPLETELY_RANDOM_DROPS = {}


function COMPLETELY_RANDOM_DROPS.generate_drops(battle_data, current_round, number_of_drops)


    local dropped_chips = {}


    for i = 1,number_of_drops do
        dropped_chips[i] = CHIP.new_random_chip_with_random_code()
    end


    return dropped_chips

end

function COMPLETELY_RANDOM_DROPS.activate()
    

end


COMPLETELY_RANDOM_DROPS.NAME = "Completely Random Drops"
COMPLETELY_RANDOM_DROPS.DESCRIPTION = "Drops are completely random!"


return COMPLETELY_RANDOM_DROPS

