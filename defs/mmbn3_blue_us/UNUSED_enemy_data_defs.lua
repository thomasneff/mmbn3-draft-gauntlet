--This is the struct for enemy data, bytes need to be written in order.
local ENEMY_DATA = {
    HP = 0x0028, -- 3 bytes for HP, one byte for element!
    HP_NUMBER_Y_OFFSET = 0x31,
    AI = 0x01, -- 0x01 seems to be for mettaur AI, 0x0F for cannon, ... must match Sprite otherwise it's just a dot
    UNID_BYTE = 0x04, -- Seems to always be 0x04, weird stuff happens otherwise
    SPRITE = 0x01, -- Needs to match with AI value, otherwise does nothing?
    UNID_BYTE_2 = 0x18, -- Seems to always be 0x18
    PALETTE_LEVEL = 0x00, -- Switches between virus "levels" for the palette. (0x00 -> V1 palette, 0x01 -> V2 palette...)
}


return ENEMY_DATA