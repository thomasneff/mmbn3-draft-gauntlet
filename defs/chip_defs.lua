local CHIP_CODE = require "defs.chip_code_defs"
local CHIP_ID = require "defs.chip_id_defs"
local deepcopy = require "deepcopy"
local randomchoice = require "randomchoice"
local CHIP = {}
local gauntlet_data = require "gauntlet_data"

local CHIP_TEMPLATE = {

    ID = CHIP_ID.Cannon, -- this is 2 bytes
    CODE = CHIP_CODE.Asterisk -- this is as well, but only uses 1 byte.


}

function shuffle(tbl)
    size = #tbl
    for i = size, 1, -1 do
      local rand = gauntlet_data.math.random_named("CHIP_GENERATION", size)
      tbl[i], tbl[rand] = tbl[rand], tbl[i]
    end
    return tbl
end


function CHIP.new_chip_with_code(chip_id, chip_code)

    new_chip = deepcopy(CHIP_TEMPLATE)

    new_chip.CODE = chip_code
    new_chip.ID = chip_id


    return new_chip
end


function CHIP.new_chip_with_random_code_from_list(chip_id, chip_codes)

    new_chip = deepcopy(CHIP_TEMPLATE)
    new_chip.CODE = randomchoice(chip_codes, "CHIP_GENERATION")--chip_codes[math.random(#chip_codes)]
    new_chip.ID = chip_id


    return new_chip
end


function CHIP.new_chip_with_random_code(chip_id)

    new_chip = deepcopy(CHIP_TEMPLATE)
    new_chip.CODE = randomchoice(CHIP_CODE, "CHIP_GENERATION")
    new_chip.ID = chip_id


    return new_chip
end

function CHIP.new_random_chip_with_random_code()

    new_chip = deepcopy(CHIP_TEMPLATE)

    new_chip.CODE = randomchoice(CHIP_CODE, "CHIP_GENERATION")
    new_chip.ID = randomchoice(CHIP_ID, "CHIP_GENERATION")


    return new_chip
end


function CHIP.new_chip_with_random_code_generator(chip_id)

    function gen() 

        new_chip = deepcopy(CHIP_TEMPLATE)

        new_chip.CODE = randomchoice(CHIP_CODE, "CHIP_GENERATION")
        new_chip.ID = chip_id


        return new_chip

    end

    return gen
end

function CHIP.new_random_chip_with_random_code_generator()

  

    return CHIP.new_random_chip_with_random_code
end


function CHIP.new_chip_with_random_code_from_list_generator(chip_id, chip_codes)

    function gen()
        new_chip = deepcopy(CHIP_TEMPLATE)
        new_chip.CODE = randomchoice(chip_codes, "CHIP_GENERATION")--chip_codes[math.random(#chip_codes)]
        new_chip.ID = chip_id
        return new_chip
    end


    return gen
end


function CHIP.new_chip_generator(chip_id, chip_code, chip_rarity)

    function gen()
        new_chip = deepcopy(CHIP_TEMPLATE)


        if chip_code ~= nil then
            new_chip.CODE = chip_code
        else
            new_chip.CODE = randomchoice(CHIP_CODE, "CHIP_GENERATION")
        end

        if chip_rarity ~= nil then
            new_chip.RARITY = chip_rarity
        else
            new_chip.RARITY = 0
        end

        new_chip.ID = chip_id


        return new_chip
    end


    return gen
end


function CHIP.lootbox_chips()

    local drop_chip_ids = {
        CHIP_ID.AirShot3,
        CHIP_ID.Spreader,
        CHIP_ID.CustSwrd,
        CHIP_ID.StepSwrd,
        CHIP_ID.ZapRing3,
        CHIP_ID.Magnum1,
        CHIP_ID.RandMetr,
        CHIP_ID.Boomer1,
        CHIP_ID.AquaSwrd,
        CHIP_ID.FireSwrd,
        CHIP_ID.ElecSwrd,
        CHIP_ID.BambSwrd,
        CHIP_ID.LavaCan1,
        CHIP_ID.DynaWave,
        CHIP_ID.IceWave2,
        CHIP_ID.YoYo2,
        CHIP_ID.Arrow1,
        CHIP_ID.RedWave,
        CHIP_ID.Shake2,
        CHIP_ID.RockArm2,
        CHIP_ID.Plasma2,
        CHIP_ID.Totem1,
        CHIP_ID.Sensor1,
        CHIP_ID.MetaGel1,
        CHIP_ID.Pawn,
        CHIP_ID.TimeBomb,
        CHIP_ID.Mine,
        CHIP_ID.Lance,
        CHIP_ID.Snake,
        CHIP_ID.AreaGrab,
        CHIP_ID.Recov120,
        CHIP_ID.FstGauge,
        CHIP_ID.Geddon1,
        CHIP_ID.Geddon2,
        CHIP_ID.Geddon3,
        CHIP_ID.Invis,
        CHIP_ID.Shadow,
        CHIP_ID.Mole2,
        CHIP_ID.AirShoes,
        CHIP_ID.Barr100,
        CHIP_ID.Mettaur,
        CHIP_ID.Bunny,
        CHIP_ID.Spikey,
        CHIP_ID.Swordy,
        CHIP_ID.Jelly,
        CHIP_ID.Mushy,
        CHIP_ID.Momogra,
        CHIP_ID.KillrEye,
        CHIP_ID.Scuttlst,
        CHIP_ID.Snctuary,
        CHIP_ID.AntiDmg,
        CHIP_ID.HeroSwrd,
        CHIP_ID.Guardian,
        CHIP_ID.Meteors,
        CHIP_ID.FullCust,
        CHIP_ID.AtkPlus30,
        CHIP_ID.NaviPlus40,
        CHIP_ID.RollV2
    }

    drop_chip_ids = shuffle(deepcopy(drop_chip_ids))

    local dropped_chips = {}


    for chip_idx = 1,#drop_chip_ids do
        dropped_chips[chip_idx] = CHIP.new_chip_with_code(drop_chip_ids[chip_idx], CHIP_CODE.Asterisk)
    end


    return dropped_chips

end


return CHIP