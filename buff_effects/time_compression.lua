local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local TimeCompression = {
    NAME = "TimeCompression",
    DOUBLE_RARITY = 1,
}

local NUMBER_OF_TIMECOMPRESSIONS = 1

function TimeCompression:activate(current_round)
    gauntlet_data.number_of_time_compressions = gauntlet_data.number_of_time_compressions + NUMBER_OF_TIMECOMPRESSIONS
end


function TimeCompression:deactivate(current_round)
    gauntlet_data.number_of_time_compressions = gauntlet_data.number_of_time_compressions - NUMBER_OF_TIMECOMPRESSIONS
end

function TimeCompression:get_description(current_round)

    local substr = tostring(gauntlet_data.time_compression_delay / 60.0) .. " seconds!\n( + "

    if gauntlet_data.time_compression_delay == 60 then
        substr = tostring(gauntlet_data.time_compression_delay / 60.0) .. " second!\n( + "
    end

    if NUMBER_OF_TIMECOMPRESSIONS == 1 then
        return "Upon being hit, rewind  time by " .. substr .. tostring(NUMBER_OF_TIMECOMPRESSIONS) .. " time per fight!)"
    else
        return "Upon being hit, rewind  time by " .. substr .. tostring(NUMBER_OF_TIMECOMPRESSIONS) .. " times per fight!)"
    end
end

function TimeCompression:get_brief_description()
    return TimeCompression.NAME .. ": " .. "Damage taken -> Rewind (" .. tostring(gauntlet_data.time_compression_delay / 60.0) .. " s)\n(" .. tostring(gauntlet_data.number_of_time_compressions) .. " total per fight)"
end

-- TODO: fix number_of_time_compressions

function TimeCompression.new()
    local new_TimeCompression = deepcopy(TimeCompression)
    new_TimeCompression.DESCRIPTION = new_TimeCompression:get_description(1)

    return deepcopy(new_TimeCompression)
end


return TimeCompression