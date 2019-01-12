local gauntlet_data = require "gauntlet_data"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP = require "defs.chip_defs"
local ELEMENT_DEFS = require "defs.entity_element_defs"
local GENERIC_DEFS = require "defs.generic_defs"

local REGCHIP = {
    NAME = "Reg-Chip",
}

function shuffle(tbl)
    size = #tbl
    for i = size, 1, -1 do
      local rand = gauntlet_data.math.random_buff_activation(size)
      tbl[i], tbl[rand] = tbl[rand], tbl[i]
    end
    return tbl
end

function REGCHIP:activate(current_round)

    self.old_folder = deepcopy(gauntlet_data.current_folder)

    if self.regchip_random_index == -1 then
        return
    end
    
    for chip_idx = 1,#self.folder_copy do

        if self.folder_copy[chip_idx].REGCHIP_FLAG ~= nil then
            self.folder_copy[chip_idx].REGCHIP_FLAG = nil
            gauntlet_data.current_folder[chip_idx].REG = 1
        end

    end
    
    


end

function REGCHIP:deactivate(current_round)

    gauntlet_data.current_folder = deepcopy(self.old_folder)


end


function REGCHIP:get_description(current_round)

    return "Sets \"" .. self.replaced_chips_string .. "\" as a regular chip!\n(Will be drawn at the start of battle!)"

end

function REGCHIP:get_brief_description()
    return REGCHIP.NAME .. ": Reg-Chip -> " .. self.replaced_chips_string .. "!"
end


function REGCHIP.new()

    local new_buff = deepcopy(REGCHIP)
    new_buff.folder_copy = deepcopy(gauntlet_data.current_folder)
    
    local all_non_regged_chips_indices = {}

    for chip_idx = 1,#new_buff.folder_copy do

        if new_buff.folder_copy[chip_idx].TACTICIAN == nil and new_buff.folder_copy[chip_idx].REG == nil then
            all_non_regged_chips_indices[#all_non_regged_chips_indices + 1] = chip_idx
        end

    end

    
    if #all_non_regged_chips_indices ~= 0 then
        local random_idx = all_non_regged_chips_indices[math.random(1, #all_non_regged_chips_indices)] 



        -- Re-roll megachips/gigachips for reduced chance of regging them.
        local chip_data = CHIP_DATA[new_buff.folder_copy[random_idx].ID]

        local is_chip_mega = (chip_data.CHIP_RANKING % 4) == 1
        local is_chip_giga = (chip_data.CHIP_RANKING % 4) == 2

        if is_chip_mega or is_chip_giga then
            random_idx = all_non_regged_chips_indices[math.random(1, #all_non_regged_chips_indices)] 
        end

        chip_data = CHIP_DATA[gauntlet_data.current_folder[random_idx].ID]
        is_chip_giga = (chip_data.CHIP_RANKING % 4) == 2

        if is_chip_giga then
            random_idx = all_non_regged_chips_indices[math.random(1, #all_non_regged_chips_indices)] 
        end


        new_buff.regchip_random_index = random_idx
        
        new_buff.replaced_chips_string = gauntlet_data.current_folder[new_buff.regchip_random_index].PRINT_NAME
        new_buff.folder_copy[new_buff.regchip_random_index].REGCHIP_FLAG = 1
    else
        new_buff.regchip_random_index = -1
        new_buff.replaced_chips_string = "nothing"
    end


    
    new_buff.DESCRIPTION = new_buff:get_description(1)


    return deepcopy(new_buff)

end


return REGCHIP