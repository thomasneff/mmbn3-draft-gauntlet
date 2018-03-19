local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local SneckoEye = {
    NAME = "Snecko Eye",
    REMOVE_AFTER_ACTIVATION = 1,
}

CUSTOM_INCREASE = 3

function SneckoEye:activate(current_round)

    self.old_SneckoEye = gauntlet_data.snecko_eye_enabled
    gauntlet_data.snecko_eye_enabled = 1
    self.old_CustomPlus = gauntlet_data.cust_screen_number_of_chips
    gauntlet_data.cust_screen_number_of_chips = gauntlet_data.cust_screen_number_of_chips + CUSTOM_INCREASE

end


function SneckoEye:deactivate(current_round)

    gauntlet_data.snecko_eye_enabled = self.old_SneckoEye

    gauntlet_data.cust_screen_number_of_chips = self.old_CustomPlus

end

function SneckoEye:get_description(current_round)

    return "Custom + " .. tostring(CUSTOM_INCREASE) ..  "!\nRandomizes chip codes before battle! (" ..
     tostring(gauntlet_data.snecko_eye_number_of_codes) .. " Codes)"

end



function SneckoEye.new()

    local new_SneckoEye = deepcopy(SneckoEye)
    new_SneckoEye.DESCRIPTION = new_SneckoEye:get_description(1)

    return deepcopy(new_SneckoEye)

end


return SneckoEye