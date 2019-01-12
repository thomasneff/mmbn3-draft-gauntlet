local gauntlet_data = require "gauntlet_data"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"
local CHIP = require "defs.chip_defs"
local ELEMENT_DEFS = require "defs.entity_element_defs"
local GENERIC_DEFS = require "defs.generic_defs"

local BOUNTY_EFFICIENCY = {
    NAME = "Bounty: Efficiency",
    REMOVE_AFTER_ACTIVATION = 1,
    DOUBLE_RARITY = 1
}


function shuffle(tbl)
    size = #tbl
    for i = size, 1, -1 do
      local rand = gauntlet_data.math.random_buff_activation(size)
      tbl[i], tbl[rand] = tbl[rand], tbl[i]
    end
    return tbl
end

local REWARD_STRING = "LootBox (Drop)"
local NUM_CHIPS = 5
local NUM_BATTLES = 10
local HP_RATIO = 0.2

function BOUNTY_EFFICIENCY:activate(current_round)
    self.fight_hp_string = ""
    self.last_known_hp = nil
    self.last_max_hp = 0
    self.fight_counter = 0
    self.total_fight_counter = 0
    self.damage_string_list = {}
end

function BOUNTY_EFFICIENCY:deactivate(current_round)

end


function BOUNTY_EFFICIENCY:get_description(current_round)

    return "Finish " .. tostring(NUM_BATTLES) .. " battles using <= " .. tostring(NUM_CHIPS) .. " Chips:\nReward: " .. REWARD_STRING

end

function BOUNTY_EFFICIENCY:get_brief_description()
    if self.total_fight_counter ~= 0 then
        return BOUNTY_EFFICIENCY.NAME .. ": " .. tostring(NUM_BATTLES) .. " battles <= " ..tostring(NUM_CHIPS)  .. " Chips\n-> " .. REWARD_STRING .. " (Total: " .. self.fight_hp_string .. " / " .. tostring(NUM_BATTLES) .. ", Last: " .. self.last_chips_string .. ")"
    else
        return BOUNTY_EFFICIENCY.NAME .. ": " .. tostring(NUM_BATTLES) .. " battles <= " ..tostring(NUM_CHIPS)  .. " Chips\n-> " .. REWARD_STRING
    end
end





function BOUNTY_EFFICIENCY:on_patch_before_battle_start(state_logic, gauntlet_data)

    self.last_round_over_limit = nil
    self.last_known_hp = nil
    self.num_chips = 0


end

function BOUNTY_EFFICIENCY:on_first_cust_screen(state_logic, gauntlet_data)

    self.last_round_over_limit = nil
    self.last_known_hp = nil
    self.num_chips = 0

end


function BOUNTY_EFFICIENCY:on_finish_battle(state_logic, gauntlet_data)

    if self.num_chips > NUM_CHIPS then
        self.last_round_over_limit = 1
    end


    if self.last_round_over_limit == nil then
        self.fight_counter = self.fight_counter + 1
    end

    self.fight_hp_string = tostring(self.fight_counter)
    self.last_chips_string = tostring(math.floor(self.num_chips))


    if self.fight_counter == NUM_BATTLES then
        self.ON_PATCH_BEFORE_BATTLE_START_CALLBACK = nil
        self.FINISH_BATTLE_CALLBACK = nil
        self.UPDATE_CALLBACK = nil
        self.reward_chip = 1
    end

    self.total_fight_counter = self.total_fight_counter + 1
    self.last_known_hp = nil

end


function BOUNTY_EFFICIENCY:on_chip_drop(state_logic, gauntlet_data)

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

function BOUNTY_EFFICIENCY:on_chip_use(state_logic, gauntlet_data)
    self.num_chips = self.num_chips + 1
end


function BOUNTY_EFFICIENCY.new()

    local new_buff = deepcopy(BOUNTY_EFFICIENCY)
    
    
    new_buff.DESCRIPTION = new_buff:get_description(1)
    new_buff.ON_PATCH_BEFORE_BATTLE_START_CALLBACK = 1
    new_buff.FINISH_BATTLE_CALLBACK = 1
    new_buff.ON_CHIP_DROP_CALLBACK = 1
    new_buff.ON_FIRST_CUST_SCREEN_CALLBACK = 1
    new_buff.ON_CHIP_USE_CALLBACK = 1

    return deepcopy(new_buff)

end


return BOUNTY_EFFICIENCY