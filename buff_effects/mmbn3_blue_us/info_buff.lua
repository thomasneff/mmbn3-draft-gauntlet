local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local GAUNTLET_DEFS = require "defs.gauntlet_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"
local CHIP = require "defs.chip_defs"

local InfoBuff = {
    NAME = "InfoBuff",
}


function InfoBuff:activate()
    self.starting_time = os.clock() 
end


function InfoBuff:deactivate()

end

function InfoBuff:get_description(current_round)
    return "Will never be displayed."
end

function InfoBuff:get_brief_description(current_round)
    local ret_string = "Buff-Screen: Buffs will be displayed here.\nCurrent Round: " .. current_round .. ", Time: "

    local current_time = os.clock()
    
    

    local time_left = current_time - self.starting_time

    local seconds_total = math.floor(time_left)
    local minutes_left = math.floor(seconds_total / (60))
    local seconds_left = seconds_total % 60

    local seconds_left_string = tostring(seconds_left)
    local minutes_left_string = tostring(minutes_left)

    if seconds_left < 10 then
        seconds_left_string = "0" .. seconds_left_string
    end

    if minutes_left < 10 then
        minutes_left_string = "0" .. minutes_left_string
    end

    ret_string = ret_string .. tostring(minutes_left_string) .. ":" .. tostring(seconds_left_string)

    return ret_string
end

function InfoBuff.new()

    local new_InfoBuff = deepcopy(InfoBuff)
    new_InfoBuff.DESCRIPTION = new_InfoBuff:get_description(1)

    return deepcopy(new_InfoBuff)

end


return InfoBuff