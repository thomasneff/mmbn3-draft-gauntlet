local gauntlet_data = require "gauntlet_data"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP = require "defs.chip_defs"
local ELEMENT_DEFS = require "defs.entity_element_defs"
local GENERIC_DEFS = require "defs.generic_defs"

local MEMEBOMB = {

    NAME = "MemeBomb",

}

local DAMAGE_INCREASE_ADD = {200, 250, 250, 300, 300}
local NUMBER_OF_BOMBS_ADDED = {2, 2, 3, 3, 4}

function shuffle(tbl)
    size = #tbl
    for i = size, 1, -1 do
      local rand = math.random(size)
      tbl[i], tbl[rand] = tbl[rand], tbl[i]
    end
    return tbl
end

function MEMEBOMB:activate(current_round)

    -- This is an example for how to modify chip data.
    self.old_chip_data = deepcopy(CHIP_DATA)

    for key, chip_data in pairs(CHIP_DATA) do

        if  key == CHIP_ID.MiniBomb then
            --print("increasing damage")
            CHIP_DATA[key].DAMAGE = CHIP_DATA[key].DAMAGE + DAMAGE_INCREASE_ADD[current_round]

        end

    end


    -- Add MiniBombs to folder.
    self.old_folder = deepcopy(gauntlet_data.current_folder)

    local shuffle_indices = {}

    for i = 1,GENERIC_DEFS.NUMBER_OF_CHIPS_IN_FOLDER do
        shuffle_indices[i] = i
    end

    shuffle_indices = shuffle(deepcopy(shuffle_indices))
    
    for chip_idx = 1,NUMBER_OF_BOMBS_ADDED[current_round] do
        --TODO: randomize the replacement indices.
        gauntlet_data.current_folder[shuffle_indices[chip_idx]] = CHIP.new_chip_with_random_code(CHIP_ID.MiniBomb)

    end

end

function MEMEBOMB:deactivate(current_round)

    -- This is an example for how to modify chip data.
    for key, chip_data in pairs(CHIP_DATA) do

        if  key == CHIP_ID.MiniBomb then
            CHIP_DATA[key] = deepcopy(self.old_chip_data[key])
        end

    end

    gauntlet_data.current_folder = deepcopy(self.old_folder)

end


function MEMEBOMB:get_description(current_round)


    
    return "Replaces " .. tostring(NUMBER_OF_BOMBS_ADDED[current_round]) .. " Chips in Folder by MiniBombs!\nMiniBombs do +"
                 .. tostring(DAMAGE_INCREASE_ADD[current_round]) .. " damage!"


end




function MEMEBOMB.new()

    local new_buff = deepcopy(MEMEBOMB)
    
    new_buff.DESCRIPTION = new_buff:get_description(1)
    return deepcopy(new_buff)

end


return MEMEBOMB