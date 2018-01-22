local CHIP_ICON_DEFS = {}


-- This assumes the default color palette used by the game.
-- The palette address for chip icons is at 0x05000340, btw.
CHIP_ICON_DEFS.CHIP_ICON_COLOR_TO_NIBBLE =
{
    Transparent = 0x0, 
    White = 0x1,
    LightGray = 0x2,
    Gray = 0x3, -- might also be transparent?
    DarkGray = 0x4, 
    DarkerGray = 0x5,
    EvenDarkerGray = 0x6,
    Black = 0x7,
    Beige = 0x8,
    AnotherGray = 0x9, -- might also be transparent?
    Yellow = 0xA,
    Orange = 0xB,
    Red = 0xC,
    Purple = 0xD,
    Blue = 0xE,
    Green = 0xF

}


-- This assumes the default color palette used by the game.
CHIP_ICON_DEFS.CHIP_ICON_PIXEL_TO_AARRGGBB =
{
    [0x0] = 0x00000000, -- might also be transparent?
    [0x1] = 0xffffffff,
    [0x2] = 0xffd8d0d0,
    [0x3] = 0xffb0a8a8, -- might also be transparent?
    [0x4] = 0xff808880, 
    [0x5] = 0xff586868,
    [0x6] = 0xff504850,
    [0x7] = 0xff282828,
    [0x8] = 0xffe8d880,
    [0x9] = 0xffa8a868, -- might also be transparent?
    [0xA] = 0xfff8f028,
    [0xB] = 0xfff8a828,
    [0xC] = 0xfff83020,
    [0xD] = 0xffa03048,
    [0xE] = 0xff5880f8,
    [0xF] = 0xff30c858

}




-- Notes: Each icon is rendered as 4 quadrants of 32 bytes, where each byte describes 2 pixels.
--        The render order is top left, top right, bottom left, bottom right.
--        Each quadrant is stored row-wise.
CHIP_ICON_DEFS.QUADRANTS_PER_CHIP = 4
CHIP_ICON_DEFS.BYTES_PER_QUADRANT = 32
CHIP_ICON_DEFS.BYTES_PER_QUADRANT_LINE = 4
CHIP_ICON_DEFS.PIXELS_PER_QUADRANT_LINE = 8
CHIP_ICON_DEFS.WIDTH = 16
CHIP_ICON_DEFS.HEIGHT = 16

function CHIP_ICON_DEFS.get_argb_2d_array_for_icon_address(icon_address)

    local argb_array = {}

    for i = 1, CHIP_ICON_DEFS.WIDTH do
        argb_array[i] = {}

        for j = 1, CHIP_ICON_DEFS.HEIGHT do
            argb_array[i][j] = 0
        end
    end

    -- Quadrant 1:
    local working_address = icon_address
    local working_address = working_address - 0x08000000

    local current_x_index = 1
    local current_y_index = 1

    for byte_index = 1, CHIP_ICON_DEFS.BYTES_PER_QUADRANT do

        local read_byte = memory.readbyte(working_address, "ROM")
        working_address = working_address + 1
        -- Dissect the byte into high/low. Low byte is always the first one, high byte the second one.
        local color_palette_byte_1 = bit.band(read_byte, 0x0F)
        local color_palette_byte_2 = bit.rshift(bit.band(read_byte, 0xF0), 4)

        argb_array[current_x_index][current_y_index] = CHIP_ICON_DEFS.CHIP_ICON_PIXEL_TO_AARRGGBB[color_palette_byte_1]

        current_x_index = current_x_index + 1

        argb_array[current_x_index][current_y_index] = CHIP_ICON_DEFS.CHIP_ICON_PIXEL_TO_AARRGGBB[color_palette_byte_2]

        current_x_index = current_x_index + 1

        if current_x_index > CHIP_ICON_DEFS.PIXELS_PER_QUADRANT_LINE then
            current_x_index = 1
            current_y_index = current_y_index + 1

        end

    end

    local current_x_index = CHIP_ICON_DEFS.PIXELS_PER_QUADRANT_LINE + 1
    local current_y_index = 1

    for byte_index = 1, CHIP_ICON_DEFS.BYTES_PER_QUADRANT do
        
        local read_byte = memory.readbyte(working_address, "ROM")
        
        working_address = working_address + 1
        -- Dissect the byte into high/low. Low byte is always the first one, high byte the second one.
        local color_palette_byte_1 = bit.band(read_byte, 0x0F)
        local color_palette_byte_2 = bit.rshift(bit.band(read_byte, 0xF0), 4)

        argb_array[current_x_index][current_y_index] = CHIP_ICON_DEFS.CHIP_ICON_PIXEL_TO_AARRGGBB[color_palette_byte_1]

        current_x_index = current_x_index + 1

        argb_array[current_x_index][current_y_index] = CHIP_ICON_DEFS.CHIP_ICON_PIXEL_TO_AARRGGBB[color_palette_byte_2]

        current_x_index = current_x_index + 1

        if current_x_index > CHIP_ICON_DEFS.WIDTH then
            current_x_index = CHIP_ICON_DEFS.PIXELS_PER_QUADRANT_LINE + 1
            current_y_index = current_y_index + 1

        end

    end

    local current_x_index = 1
    local current_y_index = CHIP_ICON_DEFS.PIXELS_PER_QUADRANT_LINE + 1

    for byte_index = 1, CHIP_ICON_DEFS.BYTES_PER_QUADRANT do

        local read_byte = memory.readbyte(working_address, "ROM")
        
        working_address = working_address + 1
        -- Dissect the byte into high/low. Low byte is always the first one, high byte the second one.
        local color_palette_byte_1 = bit.band(read_byte, 0x0F)
        local color_palette_byte_2 = bit.rshift(bit.band(read_byte, 0xF0), 4)

        argb_array[current_x_index][current_y_index] = CHIP_ICON_DEFS.CHIP_ICON_PIXEL_TO_AARRGGBB[color_palette_byte_1]

        current_x_index = current_x_index + 1

        argb_array[current_x_index][current_y_index] = CHIP_ICON_DEFS.CHIP_ICON_PIXEL_TO_AARRGGBB[color_palette_byte_2]

        current_x_index = current_x_index + 1

        if current_x_index > CHIP_ICON_DEFS.PIXELS_PER_QUADRANT_LINE then
            current_x_index = 1
            current_y_index = current_y_index + 1

        end

    end

    
    local current_x_index = CHIP_ICON_DEFS.PIXELS_PER_QUADRANT_LINE + 1
    local current_y_index = CHIP_ICON_DEFS.PIXELS_PER_QUADRANT_LINE + 1

    for byte_index = 1, CHIP_ICON_DEFS.BYTES_PER_QUADRANT do

        local read_byte = memory.readbyte(working_address, "ROM")
        --print(bizstring.hex(read_byte))
        working_address = working_address + 1
        -- Dissect the byte into high/low. Low byte is always the first one, high byte the second one.
        local color_palette_byte_1 = bit.band(read_byte, 0x0F)
        local color_palette_byte_2 = bit.rshift(bit.band(read_byte, 0xF0), 4)

        argb_array[current_x_index][current_y_index] = CHIP_ICON_DEFS.CHIP_ICON_PIXEL_TO_AARRGGBB[color_palette_byte_1]

        current_x_index = current_x_index + 1

        argb_array[current_x_index][current_y_index] = CHIP_ICON_DEFS.CHIP_ICON_PIXEL_TO_AARRGGBB[color_palette_byte_2]

        current_x_index = current_x_index + 1

        if current_x_index > CHIP_ICON_DEFS.WIDTH then
            current_x_index = CHIP_ICON_DEFS.PIXELS_PER_QUADRANT_LINE + 1
            current_y_index = current_y_index + 1

        end

    end

    for x = 1,16 do

        for y = 1,16 do

    --        print(x, y, " = ", argb_array[x][y])

        end

    end
    return argb_array

end

return CHIP_ICON_DEFS