local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_ID = require "defs.chip_id_defs"
local ELEMENT_DEFS = require "defs.entity_element_defs"
local GENERIC_DEFS = require "defs.generic_defs"

local ElementalOverflow = {
    NAME = "Elemental-Overflow",
    REMOVE_AFTER_ACTIVATION = 1,
}

local ELEMENT_NAMES =
{
    [ELEMENT_DEFS.ELEMENT_NONE] = "Normal",
    [ELEMENT_DEFS.ELEMENT_ELEC] = "Elec",
    [ELEMENT_DEFS.ELEMENT_HEAT] = "Heat",
    [ELEMENT_DEFS.ELEMENT_WOOD] = "Wood",
    [ELEMENT_DEFS.ELEMENT_AQUA] = "Aqua",
}



function ElementalOverflow:activate(current_round)

    self.current_round = current_round

end


function ElementalOverflow:deactivate(current_round)


end

function ElementalOverflow:get_description(current_round)

    return "Using 3 " .. ELEMENT_NAMES[self.ELEMENT] .. "-Chips in 1 battle phase\nheals you for 1/3 of your Max HP!"

end

function ElementalOverflow:get_brief_description()
    return ElementalOverflow.NAME .. ": " .. "3 " ..  ELEMENT_NAMES[self.ELEMENT] .. "-Chips in turn -> heal 1/3 Max HP!"
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
            gauntlet_data.current_hp = math.floor(gauntlet_data.current_hp + gauntlet_data.mega_max_hp / 3)
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

    new_ElementalOverflow.ELEMENT = gauntlet_data.math.random_buff_activation(1, 4)
    new_ElementalOverflow.NAME = ELEMENT_NAMES[new_ElementalOverflow.ELEMENT] .. "-Overflow"
    new_ElementalOverflow.DESCRIPTION = new_ElementalOverflow:get_description(1)
    new_ElementalOverflow.ON_CUST_SCREEN_CONFIRM_CALLBACK = 1
    new_ElementalOverflow.ON_CHIP_USE_CALLBACK = 1
    

    return deepcopy(new_ElementalOverflow)

end


return ElementalOverflow