local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local GAUNTLET_DEFS = require "defs.gauntlet_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"
local CHIP = require "defs.chip_defs"

local SpeedRunner = {
    NAME = "SpeedRunner",
}

local TIME_LIMIT_SECONDS = 60 * 15 -- 15 Minutes

local REWARD_STRING = "FullCust * (Reg!)"

function SpeedRunner:activate(current_round)

    self.old_folder = deepcopy(gauntlet_data.current_folder)

    self.starting_time = os.clock() 
    self.is_beaten = 0
end


function SpeedRunner:deactivate(current_round)

    gauntlet_data.current_folder = deepcopy(self.old_folder)

end

function SpeedRunner:get_description(current_round)

    return "Beat the next Boss in " .. tostring(TIME_LIMIT_SECONDS / (60)) .. " minutes!\n(Reward: " .. REWARD_STRING .. ")"

end

function SpeedRunner:get_brief_description()
    local ret_string = SpeedRunner.NAME .. ": "

    local current_time = os.clock()
    
    

    local time_left = (self.starting_time + TIME_LIMIT_SECONDS) - current_time

    if self.is_beaten == 1 then
        time_left = self.finishing_time - self.starting_time
    end

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

    if time_left < 0 then
        self.is_beaten = -1
        ret_string = ret_string .. "Boss not beaten in time!\n(Missed reward: " .. REWARD_STRING .. ")"
    elseif self.is_beaten == 0 then
        ret_string = ret_string .. "Beat the next Boss in " .. tostring(minutes_left) .. ":" .. tostring(seconds_left) .. "!\n(Reward: " .. REWARD_STRING .. ")"
    elseif self.is_beaten == 1 then
        ret_string = ret_string .. "Boss beaten in " .. tostring(minutes_left) .. ":" .. tostring(seconds_left) .. "!\n(" .. self.replaced_chips_string  .. " -> " .. REWARD_STRING .. ")"
    end


    return ret_string
end

function SpeedRunner:compute_reward(state_logic, gauntlet_data)

    -- Add Reward to folder.
    

    local shuffle_indices = {}

    for i = 1,#gauntlet_data.current_folder do
        shuffle_indices[i] = i
    end

    shuffle_indices = shuffle(deepcopy(shuffle_indices))
    self.replaced_chips_string = ""
    for chip_idx = 1,1 do

        if chip_idx ~= 1 then
            self.replaced_chips_string = self.replaced_chips_string .. gauntlet_data.current_folder[shuffle_indices[chip_idx]].PRINT_NAME .. ", "
        else
            self.replaced_chips_string = self.replaced_chips_string .. gauntlet_data.current_folder[shuffle_indices[chip_idx]].PRINT_NAME
        end

        gauntlet_data.current_folder[shuffle_indices[chip_idx]] = CHIP.new_chip_with_code(CHIP_ID.FullCust, CHIP_CODE.Asterisk)
        gauntlet_data.current_folder[shuffle_indices[chip_idx]].REG = 1
    end

end

function SpeedRunner:on_finish_battle(state_logic, gauntlet_data)
    
    print("on_finish_battle a")
    if self.is_beaten ~= 0 then
        return
    end

    print("on_finish_battle b")
    local current_time = os.clock()

    local time_left = (self.starting_time + TIME_LIMIT_SECONDS) - current_time

    if time_left < 0 then
        self.is_beaten = -1
        return
    end
    print("Current battle: " .. state_logic.current_battle)
    if (state_logic.current_battle - 1) % GAUNTLET_DEFS.BOSS_BATTLE_INTERVAL == 0 and is_beaten ~= 1 then
        self.finishing_time = current_time
        self.is_beaten = 1

        -- Add reward
        self:compute_reward(state_logic, gauntlet_data)


        return
    end

end

function SpeedRunner.new()

    local new_SpeedRunner = deepcopy(SpeedRunner)
    new_SpeedRunner.DESCRIPTION = new_SpeedRunner:get_description(1)
    new_SpeedRunner.FINISH_BATTLE_CALLBACK = 1

    return deepcopy(new_SpeedRunner)

end


return SpeedRunner