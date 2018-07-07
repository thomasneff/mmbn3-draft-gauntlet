local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local Rewind = {
    NAME = "Rewind",
}

local NUMBER_OF_REWINDS = 1

function Rewind:activate(current_round)
    gauntlet_data.number_of_rewinds = gauntlet_data.number_of_rewinds + NUMBER_OF_REWINDS
end


function Rewind:deactivate(current_round)
    gauntlet_data.number_of_rewinds = gauntlet_data.number_of_rewinds - NUMBER_OF_REWINDS
end

function Rewind:get_description(current_round)
    if NUMBER_OF_REWINDS == 1 then
        return "Upon death, reload at the beginning of the fight!\n(" .. tostring(NUMBER_OF_REWINDS) .. " time per run!)"
    else
        return "Upon death, reload at the beginning of the fight!\n(" .. tostring(NUMBER_OF_REWINDS) .. " times per run!)"
    end
end

function Rewind:get_brief_description()
    return Rewind.NAME .. ": " .. "Death -> Reload (" .. tostring(gauntlet_data.number_of_rewinds) .. " left)"
end

function Rewind.new()
    local new_Rewind = deepcopy(Rewind)
    new_Rewind.DESCRIPTION = new_Rewind:get_description(1)

    return deepcopy(new_Rewind)
end


return Rewind