local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_ID = require "defs.chip_id_defs"
local ELEMENT_DEFS = require "defs.entity_element_defs"

local Elementalist = {
    NAME = "Elementalist",
    REMOVE_AFTER_ACTIVATION = 1,
}




function Elementalist:activate(current_round)



end


function Elementalist:deactivate(current_round)


end

function Elementalist:get_description(current_round)

    return "Using chips of 3 different elements\nin 1 battle phase fills the cust gauge!"

end

function Elementalist:get_brief_description()
    return Elementalist.NAME .. ": " .. "3 elements in turn -> FullCust!"
end

function Elementalist:on_chip_use(chip, current_frame, state_logic, gauntlet_data)
    

    -- Get element of used chip

    local used_element = CHIP_DATA[chip.ID].ELEMENT 

    self.used_chip_elements[used_element] = 1

    local num_elements = 0
    -- Count elements
    for k, v in pairs(self.used_chip_elements) do
        num_elements = num_elements + 1
    end


    if num_elements == 3 then
        -- Reset storage
        self.used_chip_elements = {}


        -- Fill cust gauge
        state_logic.set_cust_gauge_value(0x40)
    end
    

end

function Elementalist:on_cust_screen_confirm(state_logic, gauntlet_data)
    self.used_chip_elements = {}
end

function Elementalist.new()

    local new_Elementalist = deepcopy(Elementalist)
    new_Elementalist.DESCRIPTION = new_Elementalist:get_description(1)
    new_Elementalist.IN_BATTLE_CALLBACKS = 1

    return deepcopy(new_Elementalist)

end


return Elementalist