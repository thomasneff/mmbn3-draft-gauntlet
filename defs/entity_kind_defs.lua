
-- Taken from http://forums.therockManexezone.com/topic/746085/1/

local ENTITY_KIND = {
    MegaMan = 0x00,
    Virus = 0x01,
    Rock = 0x02,
    RockCube = 0x03,
    MetalCube = 0x04,
    IceCube = 0x05,
    Guardian = 0x06,
    BlackBomb = 0x07,
    NOTHING = 0x08,
    Flag = 0x09,
    NOTHING = 0x0A,
    MetalGear = 0x0B
}

local NON_VIRUS_ENTITIES = {
    ENTITY_KIND.RockCube,
    ENTITY_KIND.MetalCube,
    ENTITY_KIND.IceCube,
    ENTITY_KIND.Guardian,
    ENTITY_KIND.BlackBomb,
}

function ENTITY_KIND.random_non_virus_entity_kind()

    -- TODO: possibly implement probabilities of each type, as Guardian/BlackBomb can be pretty OP ;-)

    return NON_VIRUS_ENTITIES[math.random(#NON_VIRUS_ENTITIES)]
end

return ENTITY_KIND