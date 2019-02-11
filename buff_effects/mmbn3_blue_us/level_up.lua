local gauntlet_data = require "gauntlet_data"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_ID_LAST = require "defs.chip_id_defs_last_chip"
local CHIP_CODE = require "defs.chip_code_defs"
local CHIP_NAMES = require "defs.chip_name_defs"
local CHIP_NAME_ADDRESSES = require "defs.chip_name_address_defs"
local io_utils = require "io_utils.io_utils"
local CHIP = require "defs.chip_defs"
local ELEMENT_DEFS = require "defs.entity_element_defs"
local GENERIC_DEFS = require "defs.generic_defs"

local LEVEL_UP = {

    NAME = "Level Up!",

}

local NUMBER_OF_CHIPS_UPGRADED = {2, 2, 2, 2, 3}

function shuffle(tbl)
    size = #tbl
    for i = size, 1, -1 do
      local rand = gauntlet_data.math.random_buff_activation(size)
      tbl[i], tbl[rand] = tbl[rand], tbl[i]
    end
    return tbl
end

function upgrade_chip(chip)

    -- Replace chip with upgraded chip
    local new_chip_id = chip.ID + 1

    if chip.ID == CHIP_ID.DynaWave then
        new_chip_id = CHIP_ID.BigWave
    elseif chip.ID == CHIP_ID.LavaCan3 then
        new_chip_id = CHIP_ID.Volcano
    elseif chip.ID == CHIP_ID.LongSwrd then
        new_chip_id = CHIP_ID.CustSwrd
    elseif chip.ID == CHIP_ID.Burner then
        new_chip_id = CHIP_ID.Burning
    elseif chip.ID == CHIP_ID.DashAtk then
        new_chip_id = CHIP_ID.Condor
    elseif chip.ID == CHIP_ID.Aura then
        new_chip_id = CHIP_ID.LifeAura
    elseif chip.ID == CHIP_ID.LavaStge or
        chip.ID == CHIP_ID.IceStage or
        chip.ID == CHIP_ID.GrassStg or
        chip.ID == CHIP_ID.SandStge or
        chip.ID == CHIP_ID.MetlStge then
        new_chip_id = CHIP_ID.Snctuary
    elseif chip.ID == CHIP_ID.AtkPlus10 then
        new_chip_id = CHIP_ID.AtkPlus30
    elseif chip.ID == CHIP_ID.StandOut then
        new_chip_id = CHIP_ID.Salamndr
    elseif chip.ID == CHIP_ID.WatrLine then
        new_chip_id = CHIP_ID.Fountain
    elseif chip.ID == CHIP_ID.Ligtning then
        new_chip_id = CHIP_ID.Bolt
    elseif chip.ID == CHIP_ID.GaiaSwrd then
        new_chip_id = CHIP_ID.GaiaBlad
    elseif chip.ID == CHIP_ID.NaviPlus20 then
        new_chip_id = CHIP_ID.NaviPlus40
    elseif chip.ID == CHIP_ID.GutsManV4 then
        new_chip_id = CHIP_ID.GutsManV5
    elseif chip.ID == CHIP_ID.ProtoMnV4 then
        new_chip_id = CHIP_ID.ProtoMnV5
    elseif chip.ID == CHIP_ID.FlashMnV4 then
        new_chip_id = CHIP_ID.FlashMnV5
    elseif chip.ID == CHIP_ID.BeastMnV4 then
        new_chip_id = CHIP_ID.BeastMnV5
    elseif chip.ID == CHIP_ID.BubblMnV4 then
        new_chip_id = CHIP_ID.BubblMnV5
    elseif chip.ID == CHIP_ID.DesrtMnV4 then
        new_chip_id = CHIP_ID.DesrtMnV5
    elseif chip.ID == CHIP_ID.PlantMnV4 then
        new_chip_id = CHIP_ID.PlantMnV5
    elseif chip.ID == CHIP_ID.FlamManV4 then
        new_chip_id = CHIP_ID.FlamManV5
    elseif chip.ID == CHIP_ID.DrillMnV4 then
        new_chip_id = CHIP_ID.DrillMnV5
    elseif chip.ID == CHIP_ID.MetalMnV4 then
        new_chip_id = CHIP_ID.MetalMnV5
    elseif chip.ID == CHIP_ID.KingMnV4 then
        new_chip_id = CHIP_ID.KingMnV5
    elseif chip.ID == CHIP_ID.MistMnV4 then
        new_chip_id = CHIP_ID.MistMnV5
    elseif chip.ID == CHIP_ID.BowlManV4 then
        new_chip_id = CHIP_ID.BowlManV5
    elseif chip.ID == CHIP_ID.DarkManV4 then
        new_chip_id = CHIP_ID.DarkManV5
    elseif chip.ID == CHIP_ID.JapanMnV4 then
        new_chip_id = CHIP_ID.JapanMnV5
    elseif chip.ID == CHIP_ID.Bass then
        new_chip_id = CHIP_ID.BassPlus
    end

    return CHIP.new_chip_with_code(new_chip_id, chip.CODE)
end

function is_chip_id_last_chip(chip_id)

    for k, v in pairs(CHIP_ID_LAST) do
        --print("id = " .. tostring(chip_id) .. ", v = " .. tostring(v) .. " eq = " .. tostring(v == chip_id))
        if v == chip_id then
            return true
        end

    end

    return false

end

function LEVEL_UP:activate(current_round)


    
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

        -- Check if chip is not the last of its range
        if not is_chip_id_last_chip(chip.ID) then
            
            self.num_replaced_chips = self.num_replaced_chips + 1

            if self.num_replaced_chips ~= NUMBER_OF_CHIPS_UPGRADED[current_round] then
                self.replaced_chips_string = self.replaced_chips_string .. gauntlet_data.current_folder[shuffle_indices[chip_idx]].PRINT_NAME .. ", "
            else
                self.replaced_chips_string = self.replaced_chips_string .. gauntlet_data.current_folder[shuffle_indices[chip_idx]].PRINT_NAME
            end
            
            gauntlet_data.current_folder[shuffle_indices[chip_idx]] = upgrade_chip(chip)--CHIP.new_chip_with_code(chip.ID, CHIP_CODE.Asterisk)

            if self.num_replaced_chips >= NUMBER_OF_CHIPS_UPGRADED[current_round] then
                break
            end
        end

    end

    self.current_round = current_round


end

function LEVEL_UP:deactivate(current_round)
    gauntlet_data.current_folder = deepcopy(self.old_folder)
end


function LEVEL_UP:get_description(current_round)


    if NUMBER_OF_CHIPS_UPGRADED[current_round] ~= 1 then
        return "Upgrade " .. tostring(NUMBER_OF_CHIPS_UPGRADED[current_round]) .. " Chips in Folder!"
    else
        return "Upgrade " .. tostring(NUMBER_OF_CHIPS_UPGRADED[current_round]) .. " Chip in Folder!"
    end

    
end


function LEVEL_UP:get_brief_description()
    if self.num_replaced_chips >= 3 then
        return LEVEL_UP.NAME .. ": Upgrade ->\n  " .. self.replaced_chips_string
    elseif self.num_replaced_chips > 0 then
        return LEVEL_UP.NAME .. ": Upgrade -> " .. self.replaced_chips_string
    else
        return LEVEL_UP.NAME .. ": Upgrade -> nothing!"
    end
end

function LEVEL_UP.new()

    local new_buff = deepcopy(LEVEL_UP)
    
    new_buff.DESCRIPTION = new_buff:get_description(1)
    return deepcopy(new_buff)

end


return LEVEL_UP