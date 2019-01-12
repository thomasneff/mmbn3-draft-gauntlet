local gauntlet_data = require "gauntlet_data"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"
local CHIP_NAMES = require "defs.chip_name_defs"
local CHIP_NAME_ADDRESSES = require "defs.chip_name_address_defs"
local mmbn3_utils = require "mmbn3_utils"
local CHIP = require "defs.chip_defs"
local ELEMENT_DEFS = require "defs.entity_element_defs"
local GENERIC_DEFS = require "defs.generic_defs"

local REDISTRIBUTE = {

    NAME = "Re-Distribute",

}


function shuffle(tbl)
    size = #tbl
    for i = size, 1, -1 do
      local rand = gauntlet_data.math.random_buff_activation(size)
      tbl[i], tbl[rand] = tbl[rand], tbl[i]
    end
    return tbl
end

function REDISTRIBUTE:activate(current_round)


    
    self.old_folder = deepcopy(gauntlet_data.current_folder)

    local shuffle_indices = {}

    for i = 1,#gauntlet_data.current_folder do
        shuffle_indices[i] = i
    end

    shuffle_indices = shuffle(deepcopy(shuffle_indices))
   

    for chip_idx = 1,#gauntlet_data.current_folder do

        local chip = gauntlet_data.current_folder[shuffle_indices[chip_idx]]
        gauntlet_data.current_folder[chip_idx].CODE = chip.CODE

    end

    self.current_round = current_round


end

function REDISTRIBUTE:deactivate(current_round)
    gauntlet_data.current_folder = deepcopy(self.old_folder)
end


function REDISTRIBUTE:get_description(current_round) 
    return "Shuffles all Chip Codes in the current Folder!"  
end


function REDISTRIBUTE:get_brief_description()
    return REDISTRIBUTE.NAME .. ": Shuffled all Codes!"
end

function REDISTRIBUTE.new()

    local new_buff = deepcopy(REDISTRIBUTE)
    
    new_buff.DESCRIPTION = new_buff:get_description(1)
    return deepcopy(new_buff)

end


return REDISTRIBUTE