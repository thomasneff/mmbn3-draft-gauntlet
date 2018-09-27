local gauntlet_data = require "gauntlet_data"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"
local CHIP = require "defs.chip_defs"
local ELEMENT_DEFS = require "defs.entity_element_defs"
local GENERIC_DEFS = require "defs.generic_defs"

local BOUNTY_Y_U_NO_HEAL = {
    NAME = "Bounty: Y U NO HEAL",
    REMOVE_AFTER_ACTIVATION = 1,
    DOUBLE_RARITY = 1
}


function shuffle(tbl)
    size = #tbl
    for i = size, 1, -1 do
      local rand = math.random(size)
      tbl[i], tbl[rand] = tbl[rand], tbl[i]
    end
    return tbl
end

local REWARD_STRING = "AntiDmg * (Drop)"
local NUM_CONSECUTIVE_BATTLES = 5
local HP_RATIO = 0.2

function BOUNTY_Y_U_NO_HEAL:activate(current_round)
    self.fight_hp_string = ""
    self.last_known_hp = nil
    self.last_max_hp = 0
    self.fight_counter = 0
    self.total_fight_counter = 0
    self.healed_string_list = {}
end

function BOUNTY_Y_U_NO_HEAL:deactivate(current_round)

end


function BOUNTY_Y_U_NO_HEAL:get_description(current_round)

    return "Don't heal for  " .. tostring(NUM_CONSECUTIVE_BATTLES) .. " consecutive battles:\nReward: " .. REWARD_STRING

end

function BOUNTY_Y_U_NO_HEAL:get_brief_description()
    if self.total_fight_counter ~= 0 then
        return BOUNTY_Y_U_NO_HEAL.NAME .. ": don't heal for  " .. tostring(NUM_CONSECUTIVE_BATTLES) .. " consecutive\nbattles -> " .. REWARD_STRING .. " (Heal: " .. self.fight_hp_string .. ")"
    else
        return BOUNTY_Y_U_NO_HEAL.NAME .. ": don't heal for  " .. tostring(NUM_CONSECUTIVE_BATTLES) .. " consecutive\nbattles -> " .. REWARD_STRING
    end
end





function BOUNTY_Y_U_NO_HEAL:on_patch_before_battle_start(state_logic, gauntlet_data)

    self.last_round_over_limit = nil
    self.last_known_hp = nil
    self.last_max_hp = 0

end


function BOUNTY_Y_U_NO_HEAL:on_finish_battle(state_logic, gauntlet_data)
    
    if self.last_round_over_limit ~= nil then
        self.fight_counter = 0
        self.healed = "yes"
    else
        self.fight_counter = self.fight_counter + 1
        self.healed = "no"
    end

    if (self.total_fight_counter + 1) > NUM_CONSECUTIVE_BATTLES then
        -- Just shift all entries backwards and add the new entry

        for idx = 1, (#self.healed_string_list - 1) do
            self.healed_string_list[idx] = self.healed_string_list[idx + 1]
        end

        self.healed_string_list[NUM_CONSECUTIVE_BATTLES] = self.healed
    else
        self.healed_string_list[self.total_fight_counter + 1] = self.healed
    end

    self.fight_hp_string = ""
    for idx = 1, #self.healed_string_list do
        if idx == #self.healed_string_list then
            self.fight_hp_string = self.fight_hp_string .. self.healed_string_list[idx] .. ""
        else
            self.fight_hp_string = self.fight_hp_string .. self.healed_string_list[idx] .. ", "
        end
    end

    if self.fight_counter == NUM_CONSECUTIVE_BATTLES then
        self.ON_PATCH_BEFORE_BATTLE_START_CALLBACK = nil
        self.FINISH_BATTLE_CALLBACK = nil
        self.UPDATE_CALLBACK = nil
        self.reward_chip = 1
    end

    self.total_fight_counter = self.total_fight_counter + 1
    self.last_known_hp = nil
    self.last_max_hp = 0

end

function BOUNTY_Y_U_NO_HEAL:update(state_logic, gauntlet_data)

    if gauntlet_data.current_hp == nil or gauntlet_data.current_hp == 0 or self.last_round_over_limit ~= nil then
        return
    end

    if gauntlet_data.current_hp > self.last_max_hp then
        self.last_max_hp = gauntlet_data.current_hp
    end

    

    if self.last_known_hp == nil then
        self.last_known_hp = gauntlet_data.current_hp
    else
        if gauntlet_data.current_hp > self.last_known_hp then
            self.last_round_over_limit = 1
        end
        self.last_known_hp = gauntlet_data.current_hp
    end
end

function BOUNTY_Y_U_NO_HEAL:on_chip_drop(state_logic, gauntlet_data)

    if self.reward_chip == nil then
        return
    end

    self.ON_CHIP_DROP_CALLBACK = nil

    local random_idx = math.random(1, #state_logic.dropped_chips)

    state_logic.dropped_chips[random_idx] = CHIP.new_chip_with_code(CHIP_ID.AntiDmg, CHIP_CODE.Asterisk)
    state_logic.dropped_chips[random_idx].RARITY = 3

end


function BOUNTY_Y_U_NO_HEAL.new()

    local new_buff = deepcopy(BOUNTY_Y_U_NO_HEAL)
    
    
    new_buff.DESCRIPTION = new_buff:get_description(1)
    new_buff.ON_PATCH_BEFORE_BATTLE_START_CALLBACK = 1
    new_buff.FINISH_BATTLE_CALLBACK = 1
    new_buff.UPDATE_CALLBACK = 1
    new_buff.ON_CHIP_DROP_CALLBACK = 1

    return deepcopy(new_buff)

end


return BOUNTY_Y_U_NO_HEAL