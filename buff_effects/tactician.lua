local gauntlet_data = require "gauntlet_data"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP = require "defs.chip_defs"
local ELEMENT_DEFS = require "defs.entity_element_defs"
local GENERIC_DEFS = require "defs.generic_defs"

local TACTICIAN = {
    NAME = "Tactician",
    REMOVE_AFTER_ACTIVATION = 1,
    DOUBLE_RARITY = 1
}


function shuffle(tbl)
    size = #tbl
    for i = size, 1, -1 do
      local rand = gauntlet_data.math.random_buff_activation(size)
      tbl[i], tbl[rand] = tbl[rand], tbl[i]
    end
    return tbl
end

function TACTICIAN:activate(current_round)

    self.old_folder = deepcopy(gauntlet_data.current_folder)

    if self.tactician_random_index == -1 then
        return
    end
    
    
    self:activate_tactician_chip()

end

function TACTICIAN:deactivate(current_round)

    gauntlet_data.current_folder = deepcopy(self.old_folder)


end


function TACTICIAN:get_description(current_round)

    return "When \"" .. self.replaced_chips_string .. "\" is replaced, +" .. tostring(math.floor(gauntlet_data.tactician_damage_per_chip * 100)) ..
     "% damage\nnext fight!  (Randomized  every activation.)"

end

function TACTICIAN:get_brief_description()
    return TACTICIAN.NAME .. ": Replace " .. self.replaced_chips_string .. " -> +" .. tostring(math.floor(gauntlet_data.tactician_damage_per_chip * 100)) .. "% damage!\n(Next battle only.)"
end

function TACTICIAN:select_tactician_chip()

    local all_non_regged_chips_indices = {}

    for chip_idx = 1,#self.folder_copy do

        if self.folder_copy[chip_idx].TACTICIAN == nil and self.folder_copy[chip_idx].REG == nil then
            all_non_regged_chips_indices[#all_non_regged_chips_indices + 1] = chip_idx
        end

    end

    
    if #all_non_regged_chips_indices ~= 0 then
        local random_idx = all_non_regged_chips_indices[math.random(1, #all_non_regged_chips_indices)] 

        self.tactician_random_index = random_idx
        
        self.replaced_chips_string = self.folder_copy[self.tactician_random_index].PRINT_NAME

        self.folder_copy[self.tactician_random_index].TACTICIAN_FLAG = 1
    else
        self.tactician_random_index = -1
        self.replaced_chips_string = "nothing"
    end

end

function TACTICIAN:activate_tactician_chip()

    for chip_idx = 1,#gauntlet_data.current_folder do

        if self.folder_copy[chip_idx].TACTICIAN_FLAG ~= nil then
            gauntlet_data.current_folder[chip_idx].TACTICIAN = 1
            gauntlet_data.current_folder[chip_idx].TACTICIAN_ID = gauntlet_data.tactician_unique_id

            self.tactician_id = gauntlet_data.tactician_unique_id

            gauntlet_data.tactician_unique_id = gauntlet_data.tactician_unique_id + 1
            self.folder_copy[chip_idx].TACTICIAN_FLAG = nil
        end

    end


end


function TACTICIAN:on_patch_before_battle_start(state_logic, gauntlet_data)

    -- Check if our chosen chip still exists 
    for chip_idx = 1,#gauntlet_data.current_folder do
        if gauntlet_data.current_folder[chip_idx].TACTICIAN_ID == self.tactician_id then
            return
        end
    end

    gauntlet_data.tactician_damage = gauntlet_data.tactician_damage + gauntlet_data.tactician_damage_per_chip
    self.activated = 1

    self:select_tactician_chip()
    self:activate_tactician_chip()

end

function TACTICIAN:on_finish_battle(state_logic, gauntlet_data)
    
    if self.activated == nil then
        return
    end 

    self.activated = nil

    gauntlet_data.tactician_damage = gauntlet_data.tactician_damage - gauntlet_data.tactician_damage_per_chip

end


function TACTICIAN.new()

    local new_buff = deepcopy(TACTICIAN)

    new_buff.folder_copy = deepcopy(gauntlet_data.current_folder)
    
    new_buff:select_tactician_chip()
    
    new_buff.DESCRIPTION = new_buff:get_description(1)
    new_buff.ON_PATCH_BEFORE_BATTLE_START_CALLBACK = 1
    new_buff.FINISH_BATTLE_CALLBACK = 1

    return deepcopy(new_buff)

end


return TACTICIAN