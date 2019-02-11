local gauntlet_data = require "gauntlet_data"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP = require "defs.chip_defs"
local ELEMENT_DEFS = require "defs.entity_element_defs"
local GENERIC_DEFS = require "defs.generic_defs"

local PAWNMINATOR = {

    NAME = "Pawn-Minator",

}

local NUMBER_OF_PAWNS_ADDED = {1, 1, 1, 2, 2}
local RARITY_DECREASE_VALUE = 2

function shuffle(tbl)
    size = #tbl
    for i = size, 1, -1 do
      local rand = gauntlet_data.math.random_buff_activation(size)
      tbl[i], tbl[rand] = tbl[rand], tbl[i]
    end
    return tbl
end

function PAWNMINATOR:activate(current_round)

    -- This is an example for how to modify chip data.
    self.old_chip_data = deepcopy(CHIP_DATA)

    for cumulative_rarity_index = 1,3 do

        gauntlet_data.rarity_mods[cumulative_rarity_index] = gauntlet_data.rarity_mods[cumulative_rarity_index] + RARITY_DECREASE_VALUE

    end


    -- Add Pawns to folder.
    self.old_folder = deepcopy(gauntlet_data.current_folder)

    local shuffle_indices = {}

    for i = 1,#gauntlet_data.current_folder do
        shuffle_indices[i] = i
    end

    shuffle_indices = shuffle(deepcopy(shuffle_indices))
    self.replaced_chips_string = ""
    for chip_idx = 1,NUMBER_OF_PAWNS_ADDED[current_round] do

        if chip_idx ~= NUMBER_OF_PAWNS_ADDED[current_round] then
            self.replaced_chips_string = self.replaced_chips_string .. gauntlet_data.current_folder[shuffle_indices[chip_idx]].PRINT_NAME .. ", "
        else
            self.replaced_chips_string = self.replaced_chips_string .. gauntlet_data.current_folder[shuffle_indices[chip_idx]].PRINT_NAME
        end

        gauntlet_data.current_folder[shuffle_indices[chip_idx]] = CHIP.new_chip_with_random_code(CHIP_ID.Pawn)

    end

end

function PAWNMINATOR:deactivate(current_round)

    
    for cumulative_rarity_index = 1,3 do

        gauntlet_data.rarity_mods[cumulative_rarity_index] = gauntlet_data.rarity_mods[cumulative_rarity_index] - RARITY_DECREASE_VALUE

    end

    gauntlet_data.current_folder = deepcopy(self.old_folder)

end


function PAWNMINATOR:get_description(current_round)

    if NUMBER_OF_PAWNS_ADDED[current_round] ~= 1 then
        return "Replaces " .. tostring(NUMBER_OF_PAWNS_ADDED[current_round]) .. " Chips in Folder by Pawns!\nChip-Rarity decreased by "
                 .. tostring(RARITY_DECREASE_VALUE) .. "%!"
    else
        return "Replaces " .. tostring(NUMBER_OF_PAWNS_ADDED[current_round]) .. " Chip in Folder by Pawn!\nChip-Rarity decreased by "
                 .. tostring(RARITY_DECREASE_VALUE) .. "%!"
    end   

end

function PAWNMINATOR:get_brief_description()
    return PAWNMINATOR.NAME .. ": Rarity -" .. tostring(RARITY_DECREASE_VALUE) .. "%, Pawn -> " .. self.replaced_chips_string
end


function PAWNMINATOR.new()

    local new_buff = deepcopy(PAWNMINATOR)
    
    new_buff.DESCRIPTION = new_buff:get_description(1)
    return deepcopy(new_buff)

end


return PAWNMINATOR