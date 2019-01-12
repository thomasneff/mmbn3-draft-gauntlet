local gauntlet_data = require "gauntlet_data"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"
local CHIP = require "defs.chip_defs"
local ELEMENT_DEFS = require "defs.entity_element_defs"
local GENERIC_DEFS = require "defs.generic_defs"

local ALPHABET_SOUP = {
    NAME = "Alphabet Soup",
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

local NUM_CONVERTED_STAR_CODE_CHIPS = 5
local NUM_REQUIRED_CODES = 10


function ALPHABET_SOUP:activate(current_round)
    
end

function ALPHABET_SOUP:deactivate(current_round)

end


function ALPHABET_SOUP:get_description(current_round)
    return "When having >= " .. tostring(NUM_REQUIRED_CODES) .. " different Chip codes, convert\n".. tostring(NUM_CONVERTED_STAR_CODE_CHIPS) ..  " random Chips to *-Code for the next battle only."
end

function ALPHABET_SOUP:get_brief_description()
    local sum_codes = determine_number_of_codes(gauntlet_data)

    return ALPHABET_SOUP.NAME .. ": >= " .. tostring(NUM_REQUIRED_CODES) .. " codes; " .. tostring(NUM_CONVERTED_STAR_CODE_CHIPS) .. " Chips -> *-Code\n(next battle only) (Current: " .. tostring(sum_codes) .. " / " .. tostring(NUM_REQUIRED_CODES) .. ")"
end


function determine_number_of_codes(gauntlet_data)

    local code_lookup = {}

    for chip_code = CHIP_CODE.A, CHIP_CODE.Asterisk do
        code_lookup[chip_code] = 0
    end

    for chip_idx = 1,#gauntlet_data.current_folder do
        code_lookup[gauntlet_data.current_folder[chip_idx].CODE] = 1
    end
    

    local sum_codes = 0

    for chip_code = CHIP_CODE.A, CHIP_CODE.Asterisk do
        sum_codes = sum_codes + code_lookup[chip_code]
    end

    return sum_codes

end


function ALPHABET_SOUP:on_patch_before_battle_start(state_logic, gauntlet_data)

    local sum_codes = determine_number_of_codes(gauntlet_data)

    if sum_codes >= NUM_REQUIRED_CODES then
        gauntlet_data.add_random_star_code_before_battle = gauntlet_data.add_random_star_code_before_battle + NUM_CONVERTED_STAR_CODE_CHIPS
        self.activated = 1
    end

end


function ALPHABET_SOUP:on_finish_battle(state_logic, gauntlet_data)
    
    if self.activated == nil then
        return
    end

    self.activated = nil

    gauntlet_data.add_random_star_code_before_battle = gauntlet_data.add_random_star_code_before_battle - NUM_CONVERTED_STAR_CODE_CHIPS

end


function ALPHABET_SOUP.new()

    local new_buff = deepcopy(ALPHABET_SOUP)
    
    
    new_buff.DESCRIPTION = new_buff:get_description(1)
    new_buff.ON_PATCH_BEFORE_BATTLE_START_CALLBACK = 1
    new_buff.FINISH_BATTLE_CALLBACK = 1
    return deepcopy(new_buff)

end


return ALPHABET_SOUP