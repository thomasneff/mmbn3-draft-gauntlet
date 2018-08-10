local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_ID = require "defs.chip_id_defs"
local ELEMENT_DEFS = require "defs.entity_element_defs"
local GENERIC_DEFS = require "defs.generic_defs"

local ElementalOverflow = {
    NAME = "Elemental-Overflow",
}

local ELEMENT_NAMES =
{
    [ELEMENT_DEFS.ELEMENT_NONE] = "Normal",
    [ELEMENT_DEFS.ELEMENT_ELEC] = "Elec",
    [ELEMENT_DEFS.ELEMENT_HEAT] = "Heat",
    [ELEMENT_DEFS.ELEMENT_WOOD] = "Wood",
    [ELEMENT_DEFS.ELEMENT_AQUA] = "Aqua",
}




local HEAL_PER_ROUND = {50, 100, 150, 200, 300}

function ElementalOverflow:activate(current_round)

    self.current_round = current_round

end


function ElementalOverflow:deactivate(current_round)


end

function ElementalOverflow:get_description(current_round)

    return "Using 3 " .. ELEMENT_NAMES[self.ELEMENT] .. "-Chips in 1 battle phase\nheals you for " .. HEAL_PER_ROUND[current_round] .. " HP!"

end

function ElementalOverflow:get_brief_description()
    return ElementalOverflow.NAME .. ": " .. "3 " ..  ELEMENT_NAMES[self.ELEMENT] .. "-Chips in turn -> +" .. HEAL_PER_ROUND[self.current_round] .. "HP!"
end

function ElementalOverflow:on_chip_use(chip, current_frame, state_logic, gauntlet_data)
    
    -- Get element of used chip

    local used_element = CHIP_DATA[chip.ID].ELEMENT 

    if self.used_chip_elements[used_element] == nil then
        self.used_chip_elements[used_element] = 1
    else
        self.used_chip_elements[used_element] = self.used_chip_elements[used_element] + 1
        if self.used_chip_elements[used_element] >= 3 and used_element == self.ELEMENT then
            self.used_chip_elements[used_element] = 0
            gauntlet_data.current_hp = gauntlet_data.current_hp + HEAL_PER_ROUND[self.current_round]
            if gauntlet_data.current_hp > gauntlet_data.mega_max_hp then
                gauntlet_data.current_hp = gauntlet_data.mega_max_hp
            end
            memory.write_u16_le(GENERIC_DEFS.MEGA_CURRENT_HP_ADDRESS_DURING_BATTLE[gauntlet_data.number_of_entities] - 0x02000000, gauntlet_data.current_hp, "EWRAM")
        end
    end

    
end

function ElementalOverflow:on_cust_screen_confirm(state_logic, gauntlet_data)
    self.used_chips = {}
    self.used_chip_elements = {}
end

function ElementalOverflow.new()

    local new_ElementalOverflow = deepcopy(ElementalOverflow)

    new_ElementalOverflow.ELEMENT = math.random(1, 4)
    new_ElementalOverflow.NAME = ELEMENT_NAMES[new_ElementalOverflow.ELEMENT] .. "-Overflow"
    new_ElementalOverflow.DESCRIPTION = new_ElementalOverflow:get_description(1)
    new_ElementalOverflow.IN_BATTLE_CALLBACKS = 1
    

    return deepcopy(new_ElementalOverflow)

end


return ElementalOverflow