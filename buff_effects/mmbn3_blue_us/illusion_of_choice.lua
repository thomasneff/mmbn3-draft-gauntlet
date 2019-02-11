local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local GAUNTLET_DEFS = require "defs.gauntlet_defs"

local IllusionOfChoice = {
    NAME = "Illusion of Choice",
    DOUBLE_RARITY = 1,
    REMOVE_AFTER_ACTIVATION = 1,
}

local ILLUSION_OF_CHOICE_RARITY_BONUS = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE

function IllusionOfChoice:activate(current_round)

    for cumulative_rarity_index = 1,3 do
        gauntlet_data.rarity_mods[cumulative_rarity_index] = gauntlet_data.rarity_mods[cumulative_rarity_index] - 
            math.floor(GAUNTLET_DEFS.SKILL_NOT_LUCK_RARITY_DISTRIBUTION[cumulative_rarity_index] * ILLUSION_OF_CHOICE_RARITY_BONUS)       
    end

    gauntlet_data.illusion_of_choice_active = 1


end


function IllusionOfChoice:deactivate(current_round)

    gauntlet_data.illusion_of_choice_active = 0
    for cumulative_rarity_index = 1,3 do
        gauntlet_data.rarity_mods[cumulative_rarity_index] = gauntlet_data.rarity_mods[cumulative_rarity_index] + 
            math.floor(GAUNTLET_DEFS.SKILL_NOT_LUCK_RARITY_DISTRIBUTION[cumulative_rarity_index] * ILLUSION_OF_CHOICE_RARITY_BONUS)       
    end
end

function IllusionOfChoice:get_description(current_round)

    return "Increase Chip Rarity by " .. tostring(ILLUSION_OF_CHOICE_RARITY_BONUS) .. "%!\nYou can no longer choose replaced chip or skip."
    
end

function IllusionOfChoice:get_brief_description()
    return self.NAME .. ": Rarity +" .. tostring(ILLUSION_OF_CHOICE_RARITY_BONUS) .. "%\nNo skip/choose replacement!"
  
end

function IllusionOfChoice.new()
    local new_IllusionOfChoice = deepcopy(IllusionOfChoice)

    new_IllusionOfChoice.NAME = IllusionOfChoice.NAME
    new_IllusionOfChoice.DESCRIPTION = new_IllusionOfChoice:get_description(1)

    return deepcopy(new_IllusionOfChoice)
end


return IllusionOfChoice