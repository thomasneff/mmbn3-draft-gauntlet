local bmp_exporter = require "bmp_exporter"
local CHIP_PICTURE_DEFS = {}
local NUM_COLORS_PER_PALETTE = 16


function convert_gba_to_argb(gba_color)

    local red = bit.lshift(bit.band(gba_color, 31), 3)
    local green = bit.lshift(bit.band(bit.rshift(gba_color, 5), 31), 3)
    local blue = bit.lshift(bit.band(bit.rshift(gba_color, 10), 31), 3)
    local alpha = 255

    return  bit.bor(bit.bor(bit.bor(bit.lshift(alpha, 24), bit.lshift(red, 16)), bit.lshift(green, 8)), blue)


end

function get_palette_argb(palette_address)

    -- Just read words from the address until we got 16 words. We store them in a keyed table by their index
    local argb_table = {}


    local working_address = palette_address - 0x08000000
    for i = 0, NUM_COLORS_PER_PALETTE - 1 do

        local palette_val = memory.read_u16_le(working_address, "ROM")
        working_address = working_address + 2
        
        argb_table[i] = convert_gba_to_argb(palette_val)

        --print("PALETTE: ", bizstring.hex(palette_val), " = ", bizstring.hex(convert_gba_to_argb(palette_val)))
        
        
    end

    return argb_table

end


-- Notes: Each image is rendered as 8x8 tiles of 32 bytes, where each byte describes 2 pixels.
--        The render order is row wise per tile, and rows of tiles first.
--        Each tile is stored row-wise.
CHIP_PICTURE_DEFS.TILES_PER_CHIP = 64
CHIP_PICTURE_DEFS.TILES_PER_DIMENSION = 8
CHIP_PICTURE_DEFS.BYTES_PER_TILE = 32
CHIP_PICTURE_DEFS.BYTES_PER_TILE_LINE = 4
CHIP_PICTURE_DEFS.PIXELS_PER_TILE_LINE = 8
CHIP_PICTURE_DEFS.WIDTH = 64
CHIP_PICTURE_DEFS.HEIGHT = 64

function file_exists(name)
    local f=io.open(name,"r")
    if f~=nil then io.close(f) return true else return false end
end


function CHIP_PICTURE_DEFS.generate_image_cache(CHIP_DATA, CHIP_ID)

    for key, value in pairs(CHIP_ID) do

        --local file_name = "Lua/mmbn3_draft_gauntlet/chip_images/" .. value .. ".bmp"
        local file_name = "chip_images/" .. value .. ".bmp"

        if not file_exists(file_name) then
            local chip_address = CHIP_DATA[value].CHIP_PICTURE_OFFSET
            local chip_palette_address = CHIP_DATA[value].CHIP_PICTURE_PALETTE_OFFSET
            local argb_array = CHIP_PICTURE_DEFS.get_argb_2d_array_for_image_address(chip_address, chip_palette_address)

            -- TODO: generate bitmap and store it in the cache.
            bmp_exporter.export_argb_table_to_bitmap(file_name, argb_array, 64, 56)
        end

        
    end

end


function CHIP_PICTURE_DEFS.get_argb_2d_array_for_image_address(image_address, palette_address)

    local argb_array = {}

    for i = 1, CHIP_PICTURE_DEFS.WIDTH do
        argb_array[i] = {}

        for j = 1, CHIP_PICTURE_DEFS.HEIGHT do
            argb_array[i][j] = 0
        end
    end

    -- tile 1:
    local working_address = image_address
    local working_address = working_address - 0x08000000

    local current_x_offset = 0
    local current_y_offset = 1
    local byte_counter_per_line = 0
    local x_index = 1
    local y_index = 1

    local palette_table = get_palette_argb(palette_address)

    for tile_y = 0, CHIP_PICTURE_DEFS.TILES_PER_DIMENSION - 1 do

        local tile_y_offset = tile_y * CHIP_PICTURE_DEFS.PIXELS_PER_TILE_LINE

        for tile_x = 0, CHIP_PICTURE_DEFS.TILES_PER_DIMENSION - 1 do

            local tile_x_offset = (tile_x * CHIP_PICTURE_DEFS.PIXELS_PER_TILE_LINE)
            current_y_offset = 1

            for byte_index = 1, CHIP_PICTURE_DEFS.BYTES_PER_TILE do

                

                local read_byte = memory.readbyte(working_address, "ROM")
                working_address = working_address + 1
                -- Dissect the byte into high/low. Low byte is always the first one, high byte the second one.
                local color_palette_byte_1 = bit.band(read_byte, 0x0F)
                local color_palette_byte_2 = bit.rshift(bit.band(read_byte, 0xF0), 4)
                
                current_x_offset = current_x_offset + 1

                x_index = tile_x_offset + current_x_offset
                y_index = tile_y_offset + current_y_offset

                argb_array[x_index][y_index] = palette_table[color_palette_byte_1]

                current_x_offset = current_x_offset + 1

                x_index = tile_x_offset + current_x_offset
                y_index = tile_y_offset + current_y_offset

                argb_array[x_index][y_index] = palette_table[color_palette_byte_2]


                if current_x_offset >= CHIP_PICTURE_DEFS.PIXELS_PER_TILE_LINE then

                    current_x_offset = 0
                    current_y_offset = current_y_offset + 1

                end


            end

            



        end

    end

    return argb_array

end


return CHIP_PICTURE_DEFS