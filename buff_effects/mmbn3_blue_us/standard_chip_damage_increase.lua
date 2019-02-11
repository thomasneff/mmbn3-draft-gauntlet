local gauntlet_data = require "gauntlet_data"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_ID = require "defs.chip_id_defs"
local ELEMENT_DEFS = require "defs.entity_element_defs"
local STANDARD_CHIP_DAMAGE_INCREASE = {

    NAME = "I <3 standard chips.",
    REMOVE_AFTER_ACTIVATION = 1,
}

local DAMAGE_INCREASE_STANDARD = 50
local DAMAGE_INCREASE_MEGA_GIGA = -50

function STANDARD_CHIP_DAMAGE_INCREASE:activate(current_round)

    -- This is an example for how to modify chip data.
    self.old_chip_data = deepcopy(CHIP_DATA)
    
    for key, chip_data in pairs(CHIP_DATA) do

        -- TODO_REFACTOR: mega/giga chip check
        if (chip_data.CHIP_RANKING % 4) == 0 then
            
            CHIP_DATA[key].DAMAGE = math.floor(CHIP_DATA[key].DAMAGE * ((100.0 + DAMAGE_INCREASE_STANDARD) / 100.0))
        
        else

            CHIP_DATA[key].DAMAGE = math.floor(CHIP_DATA[key].DAMAGE * ((100.0 + DAMAGE_INCREASE_MEGA_GIGA) / 100.0))

        end


    end


end

function STANDARD_CHIP_DAMAGE_INCREASE:deactivate(current_round)

    -- This is an example for how to modify chip data.
    for key, chip_data in pairs(CHIP_DATA) do

        CHIP_DATA[key] = deepcopy(self.old_chip_data[key])

    end

end


function STANDARD_CHIP_DAMAGE_INCREASE:get_description(current_round)

 
        return "Increases Damage of all Standard-Chips by "
                 .. tostring(DAMAGE_INCREASE_STANDARD) .. "%!\nDecreases Damage of all other Chips by " .. tostring(-DAMAGE_INCREASE_MEGA_GIGA) .. "%!"
    

end


function STANDARD_CHIP_DAMAGE_INCREASE:get_brief_description()
    return STANDARD_CHIP_DAMAGE_INCREASE.NAME .. ": Std Chips +" .. tostring(DAMAGE_INCREASE_STANDARD) .. "%, " 
        .. " others " .. tostring(DAMAGE_INCREASE_MEGA_GIGA) .. "% dmg!"
end


function STANDARD_CHIP_DAMAGE_INCREASE.new()

    local new_buff = deepcopy(STANDARD_CHIP_DAMAGE_INCREASE)
    
    
    
    new_buff.DESCRIPTION = new_buff:get_description(1)
    return deepcopy(new_buff)

end


return STANDARD_CHIP_DAMAGE_INCREASE