local gauntlet_data = require "gauntlet_data"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_ID = require "defs.chip_id_defs"
local ELEMENT_DEFS = require "defs.entity_element_defs"
local ELEMENT_CHIP_DAMAGE_INCREASE = {

    NAME = "Element-Mastery",

}

local ELEMENT_NAMES =
{
    [ELEMENT_DEFS.ELEMENT_NONE] = "Normal",
    [ELEMENT_DEFS.ELEMENT_ELEC] = "Elec",
    [ELEMENT_DEFS.ELEMENT_HEAT] = "Heat",
    [ELEMENT_DEFS.ELEMENT_WOOD] = "Wood",
    [ELEMENT_DEFS.ELEMENT_AQUA] = "Aqua",
}

local DAMAGE_INCREASE_ADD = {20, 40, 60, 80, 100}
local DAMAGE_INCREASE_MULT = {20, 40, 60, 80, 100}

local HP_LOSS_VALUES = {25, 100, 150, 200, 300}


function ELEMENT_CHIP_DAMAGE_INCREASE:activate(current_round)

    -- This is an example for how to modify chip data.
    self.old_chip_data = deepcopy(CHIP_DATA)
    
    for key, chip_data in pairs(CHIP_DATA) do

        if chip_data.ELEMENT == self.ELEMENT then

            if self.ADDITIVE == 1 then
                
                CHIP_DATA[key].DAMAGE = CHIP_DATA[key].DAMAGE + DAMAGE_INCREASE_ADD[current_round]
            else
                CHIP_DATA[key].DAMAGE = math.floor(CHIP_DATA[key].DAMAGE * ((100.0 + DAMAGE_INCREASE_MULT[current_round]) / 100.0))
            end
        end

    end

    self.previous_hp = gauntlet_data.mega_max_hp

    if gauntlet_data.mega_max_hp < 0 then
        gauntlet_data.mega_max_hp = 1
    end

    gauntlet_data.mega_max_hp = gauntlet_data.mega_max_hp - HP_LOSS_VALUES[current_round]

    gauntlet_data.hp_patch_required = 1

    self.current_round = current_round
end

function ELEMENT_CHIP_DAMAGE_INCREASE:deactivate(current_round)

    gauntlet_data.mega_max_hp = self.previous_hp

    gauntlet_data.hp_patch_required = 1

    -- This is an example for how to modify chip data.
    for key, chip_data in pairs(CHIP_DATA) do

        if chip_data.ELEMENT == self.ELEMENT then
            CHIP_DATA[key] = deepcopy(self.old_chip_data[key])
        end

    end

end


function ELEMENT_CHIP_DAMAGE_INCREASE:get_description(current_round)


    if self.ADDITIVE == 0 then
        return "Increases Damage of all " .. ELEMENT_NAMES[self.ELEMENT] .. "-Type Chips by "
                 .. tostring(DAMAGE_INCREASE_MULT[current_round]) .. "%!\nDecreases MaxHP by " ..  HP_LOSS_VALUES[current_round] .."!"
    else

        return "Increases Damage of all " .. ELEMENT_NAMES[self.ELEMENT] .. "-Type Chips by "
                 .. tostring(DAMAGE_INCREASE_ADD[current_round]) .. "!\nDecreases MaxHP by " ..  HP_LOSS_VALUES[current_round] .."!"
    
    end

end

function ELEMENT_CHIP_DAMAGE_INCREASE:get_brief_description()
    local ret = self.NAME .. ": " 

    if self.ADDITIVE == 0 then
        ret = ret .. ELEMENT_NAMES[self.ELEMENT] .. " Chips +"
                 .. tostring(DAMAGE_INCREASE_MULT[self.current_round]) .. "%, MaxHP -" ..  HP_LOSS_VALUES[self.current_round] .."!"
    else

        ret = ret .. ELEMENT_NAMES[self.ELEMENT] .. " Chips +"
                 .. tostring(DAMAGE_INCREASE_ADD[self.current_round]) .. ", MaxHP -" ..  HP_LOSS_VALUES[self.current_round] .."!"
    end

    return ret
end


function ELEMENT_CHIP_DAMAGE_INCREASE.new()

    local new_buff = deepcopy(ELEMENT_CHIP_DAMAGE_INCREASE)
    
    -- TODO: roll element and additive/multiplicative.
    new_buff.ELEMENT = gauntlet_data.math.random_buff_activation(0, 4)
    new_buff.ADDITIVE = gauntlet_data.math.random_buff_activation(0, 1)

    if new_buff.ADDITIVE == 0 then
        new_buff.NAME = ELEMENT_NAMES[new_buff.ELEMENT] .. "-Mastery (%)"
    else

        new_buff.NAME = ELEMENT_NAMES[new_buff.ELEMENT] .. "-Mastery (+)"
    
    end

    
    new_buff.DESCRIPTION = new_buff:get_description(1)
    return deepcopy(new_buff)

end


return ELEMENT_CHIP_DAMAGE_INCREASE