local gauntlet_data = require "gauntlet_data"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP = require "defs.chip_defs"
local ELEMENT_DEFS = require "defs.entity_element_defs"
local GENERIC_DEFS = require "defs.generic_defs"

local FOLDERBAK = {

    NAME = "...FoldrBak?!?!",
    REMOVE_AFTER_ACTIVATION = 1,
    DOUBLE_RARITY = 1
}

local HP_REGEN_INCREASE_PER_FRAME = 0.05
local NUMBER_OF_FOLDERBAK_ADDED = {1, 1, 1, 1, 1}

function shuffle(tbl)
    size = #tbl
    for i = size, 1, -1 do
      local rand = gauntlet_data.math.random_buff_activation(size)
      tbl[i], tbl[rand] = tbl[rand], tbl[i]
    end
    return tbl
end

function FOLDERBAK:activate(current_round)


    -- Add Pawns to folder.
    self.old_folder = deepcopy(gauntlet_data.current_folder)

    local shuffle_indices = {}

    for i = 1,#gauntlet_data.current_folder do
        shuffle_indices[i] = i
    end

    shuffle_indices = shuffle(deepcopy(shuffle_indices))
    self.replaced_chips_string = ""
    for chip_idx = 1,1 do

        if chip_idx ~= NUMBER_OF_FOLDERBAK_ADDED[current_round] then
            self.replaced_chips_string = self.replaced_chips_string .. gauntlet_data.current_folder[shuffle_indices[chip_idx]].PRINT_NAME .. ", "
        else
            self.replaced_chips_string = self.replaced_chips_string .. gauntlet_data.current_folder[shuffle_indices[chip_idx]].PRINT_NAME
        end

        gauntlet_data.current_folder[shuffle_indices[chip_idx]] = CHIP.new_chip_with_random_code(CHIP_ID.FoldrBak)

    end

    gauntlet_data.enemies_hp_regen_per_frame = gauntlet_data.enemies_hp_regen_per_frame + HP_REGEN_INCREASE_PER_FRAME


end

function FOLDERBAK:deactivate(current_round)

    gauntlet_data.current_folder = deepcopy(self.old_folder)

    gauntlet_data.enemies_hp_regen_per_frame = gauntlet_data.enemies_hp_regen_per_frame - HP_REGEN_INCREASE_PER_FRAME

end


function FOLDERBAK:get_description(current_round)

    if NUMBER_OF_FOLDERBAK_ADDED[current_round] ~= 1 then
        return "Replaces " .. tostring(NUMBER_OF_FOLDERBAK_ADDED[current_round]) .. " Chips in Folder by FoldrBaks!\nChip-Rarity decreased by "
                 .. tostring(RARITY_DECREASE_VALUE) .. "%!"
    else
        return "Replaces " .. tostring(NUMBER_OF_FOLDERBAK_ADDED[current_round]) .. " Chip in Folder by FoldrBak!\nEnemies regenerate +"
         .. math.floor(60.0 * HP_REGEN_INCREASE_PER_FRAME + 0.5) .. " HP every second!"
    end   

end

function FOLDERBAK:get_brief_description()
    return FOLDERBAK.NAME .. ": FoldrBak -> " .. self.replaced_chips_string .. "\nEnemy HP regen +" .. math.floor(60.0 * HP_REGEN_INCREASE_PER_FRAME + 0.5) .. " / s"
end


function FOLDERBAK.new()

    local new_buff = deepcopy(FOLDERBAK)
    
    new_buff.DESCRIPTION = new_buff:get_description(1)
    return deepcopy(new_buff)

end


return FOLDERBAK