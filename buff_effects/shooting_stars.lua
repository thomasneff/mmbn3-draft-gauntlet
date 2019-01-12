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

local SHOOTING_STARS = {

    NAME = "Shooting Stars",

}

local NUMBER_OF_STARS_ADDED = {2, 2, 2, 2, 3}

function shuffle(tbl)
    size = #tbl
    for i = size, 1, -1 do
      local rand = gauntlet_data.math.random_buff_activation(size)
      tbl[i], tbl[rand] = tbl[rand], tbl[i]
    end
    return tbl
end

function SHOOTING_STARS:activate(current_round)


    
    self.old_folder = deepcopy(gauntlet_data.current_folder)

    local shuffle_indices = {}

    for i = 1,#gauntlet_data.current_folder do
        shuffle_indices[i] = i
    end

    shuffle_indices = shuffle(deepcopy(shuffle_indices))
    self.replaced_chips_string = ""
    self.num_replaced_chips = 0

    for chip_idx = 1,#gauntlet_data.current_folder do

        local chip = gauntlet_data.current_folder[shuffle_indices[chip_idx]]

        if chip.CODE ~= CHIP_CODE.Asterisk then
            
            self.num_replaced_chips = self.num_replaced_chips + 1

            if self.num_replaced_chips ~= NUMBER_OF_STARS_ADDED[current_round] then
                self.replaced_chips_string = self.replaced_chips_string .. gauntlet_data.current_folder[shuffle_indices[chip_idx]].PRINT_NAME .. ", "
            else
                self.replaced_chips_string = self.replaced_chips_string .. gauntlet_data.current_folder[shuffle_indices[chip_idx]].PRINT_NAME
            end

            gauntlet_data.current_folder[shuffle_indices[chip_idx]] = CHIP.new_chip_with_code(chip.ID, CHIP_CODE.Asterisk)

            if self.num_replaced_chips >= NUMBER_OF_STARS_ADDED[current_round] then
                break
            end
        end

    end

    self.current_round = current_round


end

function SHOOTING_STARS:deactivate(current_round)
    gauntlet_data.current_folder = deepcopy(self.old_folder)
end


function SHOOTING_STARS:get_description(current_round)


    if NUMBER_OF_STARS_ADDED[current_round] ~= 1 then
        return "Changes " .. tostring(NUMBER_OF_STARS_ADDED[current_round]) .. " Chips in Folder to * Code!"
    else
        return "Changes " .. tostring(NUMBER_OF_STARS_ADDED[current_round]) .. " Chip in Folder to * Code!"
    end

    
end


function SHOOTING_STARS:get_brief_description()
    if self.num_replaced_chips >= 3 then
        return SHOOTING_STARS.NAME .. ": * Code ->\n  " .. self.replaced_chips_string
    elseif self.num_replaced_chips > 0 then
        return SHOOTING_STARS.NAME .. ": * Code -> " .. self.replaced_chips_string
    else
        return SHOOTING_STARS.NAME .. ": * Code -> nothing!"
    end
end

function SHOOTING_STARS.new()

    local new_buff = deepcopy(SHOOTING_STARS)
    
    new_buff.DESCRIPTION = new_buff:get_description(1)
    return deepcopy(new_buff)

end


return SHOOTING_STARS