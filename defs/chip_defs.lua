local CHIP_CODE = require "defs.chip_code_defs"
local CHIP_ID = require "defs.chip_id_defs"
local deepcopy = require "deepcopy"

local CHIP = {}

local CHIP_TEMPLATE = {

    ID = CHIP_ID.Cannon, -- this is 2 bytes
    CODE = CHIP_CODE.Star -- this is as well, but only uses 1 byte.


}

function randomchoice(t) --Selects a random item from a table
    local keys = {}
    for key, value in pairs(t) do
        keys[#keys+1] = key --Store keys in another table
    end
    
    index = keys[math.random(1, #keys)]
    return t[index]
end

function CHIP.new_chip_with_code(chip_id, chip_code)

    new_chip = deepcopy(CHIP_TEMPLATE)

    new_chip.CODE = chip_code
    new_chip.ID = chip_id


    return new_chip
end


function CHIP.new_chip_with_random_code_from_list(chip_id, chip_codes)

    new_chip = deepcopy(CHIP_TEMPLATE)

    new_chip.CODE = randomchoice(chip_codes)--chip_codes[math.random(#chip_codes)]
    new_chip.ID = chip_id


    return new_chip
end


function CHIP.new_chip_with_random_code(chip_id)

    new_chip = deepcopy(CHIP_TEMPLATE)

    new_chip.CODE = randomchoice(CHIP_CODE)
    new_chip.ID = chip_id


    return new_chip
end

function CHIP.new_random_chip_with_random_code()

    new_chip = deepcopy(CHIP_TEMPLATE)

    new_chip.CODE = randomchoice(CHIP_CODE)
    new_chip.ID = randomchoice(CHIP_ID)


    return new_chip
end


return CHIP