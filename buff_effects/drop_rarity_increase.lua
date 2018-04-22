local gauntlet_data = require "gauntlet_data"
local CHIP_DATA = require "defs.chip_data_defs"
local RARITY_INCREASE = {

    NAME = "X-Hunter",

}

local RARITY_INCREASE_VALUES = {
    [1] = 7, -- Rare
    [2] = 4, -- SuperRare
    [3] = 2  -- UltraRare
}

local HP_LOSS_VALUES = {

    [1] = {20, 40, 80, 120, 120},
    [2] = {50, 100, 200, 300, 300},
    [3] = {70, 140, 280, 420, 420}



}

local RARITY_NAMES = {
    [1] = "Rare",
    [2] = "SuperRare",
    [3] = "UltraRare"
}

function RARITY_INCREASE:activate(current_round)

    self.previous_hp = gauntlet_data.mega_max_hp

    if gauntlet_data.mega_max_hp < 0 then
        gauntlet_data.mega_max_hp = 1
    end

    gauntlet_data.mega_max_hp = gauntlet_data.mega_max_hp - HP_LOSS_VALUES[self.rarity][current_round]

    gauntlet_data.hp_patch_required = 1

    -- Adjust cumulative rarity modifiers.
    -- All rarities before the index need to be reduced by the chance.

    -- 90 -> 85
    -- 95 -> 95
    -- 98 -> 98
    -- 100 -> 100

    -- 90 -> 85
    -- 95 -> 90
    -- 98 -> 98
    -- 100 -> 100

    -- 90 -> 85
    -- 95 -> 90
    -- 98 -> 93
    -- 100 -> 100

    for cumulative_rarity_index = 1,self.rarity do

        gauntlet_data.rarity_mods[cumulative_rarity_index] = gauntlet_data.rarity_mods[cumulative_rarity_index] - RARITY_INCREASE_VALUES[self.rarity]

    end

    self.current_round = current_round

end


function RARITY_INCREASE:deactivate(current_round)

    gauntlet_data.mega_max_hp = self.previous_hp

    gauntlet_data.hp_patch_required = 1
    
    for cumulative_rarity_index = 1,self.rarity do

        gauntlet_data.rarity_mods[cumulative_rarity_index] = gauntlet_data.rarity_mods[cumulative_rarity_index] + RARITY_INCREASE_VALUES[self.rarity]

    end

end

function RARITY_INCREASE:get_description(current_round)


    return "Increases Drop-Chance of " .. tostring(RARITY_NAMES[self.rarity]) ..
     "-Chips by " .. tostring(RARITY_INCREASE_VALUES[self.rarity]) .. "%!\nDecreases MaxHP by " ..  HP_LOSS_VALUES[self.rarity][current_round] .."!"


end

function RARITY_INCREASE:get_brief_description()
    return self.NAME .. ": " .. tostring(RARITY_NAMES[self.rarity]) .. " +".. tostring(RARITY_INCREASE_VALUES[self.rarity]) .. "%, MaxHP -" .. HP_LOSS_VALUES[self.rarity][self.current_round] .."!"
end

function RARITY_INCREASE.new()

    local new_obj = deepcopy(RARITY_INCREASE)
    --new_set_stage.STAGE = randomchoice(STAGES)

    -- Roll type
    new_obj.rarity = math.random(1, 3)




    new_obj.NAME = RARITY_NAMES[new_obj.rarity] .. "-Hunter"
    new_obj.DESCRIPTION = new_obj:get_description(1)

    return deepcopy(new_obj)

end


return RARITY_INCREASE