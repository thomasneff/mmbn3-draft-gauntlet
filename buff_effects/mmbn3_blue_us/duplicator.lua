local gauntlet_data = require "gauntlet_data"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP = require "defs.chip_defs"
local ELEMENT_DEFS = require "defs.entity_element_defs"
local GENERIC_DEFS = require "defs.generic_defs"

local Duplicator = {
    NAME = "Duplicator",
}

function shuffle(tbl)
    size = #tbl
    for i = size, 1, -1 do
      local rand = gauntlet_data.math.random_buff_activation(size)
      tbl[i], tbl[rand] = tbl[rand], tbl[i]
    end
    return tbl
end

function Duplicator:activate(current_round)

    self.old_folder = deepcopy(gauntlet_data.current_folder)

    if self.Duplicator_random_index == -1 then
        return
    end

    local replaced_idx = nil
    local copied_idx = nil

    for chip_idx = 1,#self.folder_copy do

        if self.folder_copy[chip_idx].COPY_FLAG ~= nil then
            self.folder_copy[chip_idx].COPY_FLAG = nil
            copied_idx = chip_idx
        end

        if self.folder_copy[chip_idx].REPLACE_FLAG ~= nil then
            self.folder_copy[chip_idx].REPLACE_FLAG = nil
            replaced_idx = chip_idx
        end

    end
    
    --gauntlet_data.current_folder[self.Duplicator_random_index].REG = 1
    gauntlet_data.current_folder[replaced_idx] = deepcopy(gauntlet_data.current_folder[copied_idx])

end

function Duplicator:deactivate(current_round)

    gauntlet_data.current_folder = deepcopy(self.old_folder)


end


function Duplicator:get_description(current_round)

    if self.show_replacement == 1 then
        return "Replaces \"" .. self.replaced_chips_string .. "\" in your folder\nwith a copy of a random other chip in your folder!" 
    else
        return "Copies \"" .. self.copied_chips_string .. "\" in your folder\nand replaces a random other chip in your folder!" 
    end
    

end

function Duplicator:get_brief_description()
    return Duplicator.NAME .. ": Copy " .. self.copied_chips_string .. " -> " .. self.replaced_chips_string .. "!"
end


function Duplicator.new()

    local new_buff = deepcopy(Duplicator)
    
    new_buff.show_replacement = gauntlet_data.math.random_buff_activation(0, 1)
    new_buff.folder_copy = deepcopy(gauntlet_data.current_folder)
    
    if new_buff.show_replacement == 0 then
        local random_idx = gauntlet_data.math.random_buff_activation(1, #new_buff.folder_copy)

        -- Re-roll megachips/gigachips for reduced chance of regging them.
        local chip_data = CHIP_DATA[new_buff.folder_copy[random_idx].ID]
        
        -- TODO_REFACTOR: refactor into separate check logic. Maybe even include in chip_data?
        local is_chip_mega = (chip_data.CHIP_RANKING % 4) == 1
        local is_chip_giga = (chip_data.CHIP_RANKING % 4) == 2

        if is_chip_mega or is_chip_giga then
            random_idx = gauntlet_data.math.random_buff_activation(1, #new_buff.folder_copy)
        end

        chip_data = CHIP_DATA[new_buff.folder_copy[random_idx].ID]
        is_chip_giga = (chip_data.CHIP_RANKING % 4) == 2

        if is_chip_giga then
            random_idx = gauntlet_data.math.random_buff_activation(1, #new_buff.folder_copy)
        end


        new_buff.copied_idx = random_idx
        
        new_buff.copied_chips_string = new_buff.folder_copy[new_buff.copied_idx].PRINT_NAME
        new_buff.replaced_idx = gauntlet_data.math.random_buff_activation(1, #new_buff.folder_copy)
        while(new_buff.replaced_idx == new_buff.copied_idx) do
            new_buff.replaced_idx = gauntlet_data.math.random_buff_activation(1, #new_buff.folder_copy)
        end

        new_buff.replaced_chips_string = new_buff.folder_copy[new_buff.replaced_idx].PRINT_NAME

        new_buff.folder_copy[new_buff.copied_idx].COPY_FLAG = 1
        new_buff.folder_copy[new_buff.replaced_idx].REPLACE_FLAG = 1

    else
        new_buff.replaced_idx = gauntlet_data.math.random_buff_activation(1, #new_buff.folder_copy)
        new_buff.replaced_chips_string = new_buff.folder_copy[new_buff.replaced_idx].PRINT_NAME

        new_buff.copied_idx = gauntlet_data.math.random_buff_activation(1, #new_buff.folder_copy)
        while(new_buff.replaced_idx == new_buff.copied_idx) do
            new_buff.copied_idx = gauntlet_data.math.random_buff_activation(1, #new_buff.folder_copy)
        end

        new_buff.copied_chips_string = new_buff.folder_copy[new_buff.copied_idx].PRINT_NAME

        new_buff.folder_copy[new_buff.copied_idx].COPY_FLAG = 1
        new_buff.folder_copy[new_buff.replaced_idx].REPLACE_FLAG = 1
    end


    
    new_buff.DESCRIPTION = new_buff:get_description(1)


    return deepcopy(new_buff)

end


return Duplicator