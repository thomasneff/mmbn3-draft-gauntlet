local CHIP_CODE = require "defs.chip_code_defs"
local CHIP_ID = require "defs.chip_id_defs"
local deepcopy = require "deepcopy"
local randomchoice = require "randomchoice"
local CHIP = {}

local CHIP_TEMPLATE = {

    ID = CHIP_ID.Cannon, -- this is 2 bytes
    CODE = CHIP_CODE.Asterisk -- this is as well, but only uses 1 byte.


}

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