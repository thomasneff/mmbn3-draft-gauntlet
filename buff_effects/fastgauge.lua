local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local FastGauge = {
    NAME = "FastGauge",
    REMOVE_AFTER_ACTIVATION = 1,
}



function FastGauge:activate(current_round)

    self.old_FastGauge = gauntlet_data.mega_FastGauge
    gauntlet_data.mega_FastGauge = gauntlet_data.mega_FastGauge + 1

end


function FastGauge:deactivate(current_round)

    gauntlet_data.mega_FastGauge = self.old_FastGauge

end

function FastGauge:get_description(current_round)

    return "CustGauge speed increases!"

end



function FastGauge.new()

    local new_FastGauge = deepcopy(FastGauge)

    new_FastGauge.DESCRIPTION = new_FastGauge:get_description(1)

    return deepcopy(new_FastGauge)

end


return FastGauge