local gauntlet_data = require "gauntlet_data"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"
local CHIP = require "defs.chip_defs"
local ELEMENT_DEFS = require "defs.entity_element_defs"
local GENERIC_DEFS = require "defs.generic_defs"

local BOUNTY_PRO_GAMER = {
    NAME = "Bounty: Pro-Gamer",
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

local REWARD_STRING = "LootBox (Drop)"
local NUM_CONSECUTIVE_BATTLES = 5
local HP_RATIO = 0.2

function BOUNTY_PRO_GAMER:activate(current_round)
    self.fight_hp_string = ""
    self.last_known_hp = nil
    self.last_max_hp = 0
    self.fight_counter = 0
    self.total_fight_counter = 0
    self.damage_string_list = {}
end

function BOUNTY_PRO_GAMER:deactivate(current_round)

end


function BOUNTY_PRO_GAMER:get_description(current_round)

    return "Take no damage for  " .. tostring(NUM_CONSECUTIVE_BATTLES) .. " consecutive battles:\nReward: " .. REWARD_STRING

end

function BOUNTY_PRO_GAMER:get_brief_description()
    if self.total_fight_counter ~= 0 then
        return BOUNTY_PRO_GAMER.NAME .. ": no damage for  " .. tostring(NUM_CONSECUTIVE_BATTLES) .. " consecutive\nbattles -> " .. REWARD_STRING .. " (Dmg: " .. self.fight_hp_string .. ")"
    else
        return BOUNTY_PRO_GAMER.NAME .. ": no damage for  " .. tostring(NUM_CONSECUTIVE_BATTLES) .. " consecutive\nbattles -> " .. REWARD_STRING
    end
end





function BOUNTY_PRO_GAMER:on_patch_before_battle_start(state_logic, gauntlet_data)

    self.last_round_over_limit = nil
    self.last_known_hp = nil

end


function BOUNTY_PRO_GAMER:on_finish_battle(state_logic, gauntlet_data)
    
    if self.last_round_over_limit ~= nil then
        self.fight_counter = 0
        self.damage = "yes"
    else
        self.fight_counter = self.fight_counter + 1
        self.damage = "no"
    end

    if (self.total_fight_counter + 1) > NUM_CONSECUTIVE_BATTLES then
        -- Just shift all entries backwards and add the new entry

        for idx = 1, (#self.damage_string_list - 1) do
            self.damage_string_list[idx] = self.damage_string_list[idx + 1]
        end

        self.damage_string_list[NUM_CONSECUTIVE_BATTLES] = self.damage
    else
        self.damage_string_list[self.total_fight_counter + 1] = self.damage
    end

    self.fight_hp_string = ""
    for idx = 1, #self.damage_string_list do
        if idx == #self.damage_string_list then
            self.fight_hp_string = self.fight_hp_string .. self.damage_string_list[idx] .. ""
        else
            self.fight_hp_string = self.fight_hp_string .. self.damage_string_list[idx] .. ", "
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

end

function BOUNTY_PRO_GAMER:update(state_logic, gauntlet_data)

    if gauntlet_data.current_hp == nil or gauntlet_data.current_hp == 0 or self.last_round_over_limit ~= nil then
        return
    end
  
    if self.last_known_hp == nil then
        self.last_known_hp = gauntlet_data.current_hp
    else
        if gauntlet_data.current_hp < self.last_known_hp then
            self.last_round_over_limit = 1
        end
        self.last_known_hp = gauntlet_data.current_hp
    end
end

function BOUNTY_PRO_GAMER:on_chip_drop(state_logic, gauntlet_data)

    if self.reward_chip == nil then
        return
    end

    self.ON_CHIP_DROP_CALLBACK = nil


    local lootbox = CHIP.lootbox_chips()

    for chip_idx = 1, #state_logic.dropped_chips do
        
        if lootbox[chip_idx] == nil then
            break
        end

        state_logic.dropped_chips[chip_idx] = lootbox[chip_idx]
        state_logic.dropped_chips[chip_idx].RARITY = 3

    end

end


function BOUNTY_PRO_GAMER.new()

    local new_buff = deepcopy(BOUNTY_PRO_GAMER)
    
    
    new_buff.DESCRIPTION = new_buff:get_description(1)
    new_buff.ON_PATCH_BEFORE_BATTLE_START_CALLBACK = 1
    new_buff.FINISH_BATTLE_CALLBACK = 1
    new_buff.UPDATE_CALLBACK = 1
    new_buff.ON_CHIP_DROP_CALLBACK = 1

    return deepcopy(new_buff)

end


return BOUNTY_PRO_GAMER