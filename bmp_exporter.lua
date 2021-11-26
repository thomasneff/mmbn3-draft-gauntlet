function bytes(x)
    local b4=x%256  x=(x-x%256)/256
    local b3=x%256  x=(x-x%256)/256
    local b2=x%256  x=(x-x%256)/256
    local b1=x%256  x=(x-x%256)/256
    return string.char(b4,b3,b2,b1)
end

function bytes2(x)
    local b4=x%256  x=(x-x%256)/256
    local b3=x%256  x=(x-x%256)/256
    local b2=x%256  x=(x-x%256)/256
    local b1=x%256  x=(x-x%256)/256
    return string.char(b4,b3)
end

local bmp_exporter = {}


function bmp_exporter.try_open_file(path, mode)

    local file = io.open(path, mode)

    ---print("Trying to open file: " .. path)

    if file == nil then
        file = io.open("Lua/mmbn3_draft_gauntlet/" .. path, mode)
    end

    if file == nil then
        file = io.open("Lua/mmbn3-draft-gauntlet-master/" .. path, mode)
    end

    if file == nil then
        file = io.open("Lua/mmbn3_draft_gauntlet/" .. path, mode)
    end

    if file == nil then
        file = io.open("../lua/" .. path, mode)
    end

    if file == nil then
        file = io.open("../bizhawk/" .. path, mode)
    end

    if file == nil then
        file = io.open("../mmbn3_draft_gauntlet/" .. path, mode)
    end

    if file == nil then
        file = io.open("../mmbn3-draft-gauntlet-master/" .. path, mode)
    end


    if file == nil then
        print("Could not read input file " .. path .. "!")
        return nil
    end

    return file
end

function bmp_exporter.export_argb_table_to_bitmap(file_name, argb_table, width_override, height_override)
    
    local width = width_override or #argb_table
    local height = height_override or #argb_table[1]
    local bitcount = 24

    local width_in_bytes = math.floor((width * bitcount + 31) / 32) * 4

    local image_size = width_in_bytes * height

    local bitmap_info_header_size = 40

    local bitmap_file_offset = 54

    local file_size = 54 + image_size

    local bitmap_planes = 1

    local file = bmp_exporter.try_open_file(file_name, "wb")

    file:write("BM")
    file:write(bytes(file_size))
    file:write(bytes(0))
    file:write(bytes(bitmap_file_offset))

    file:write(bytes(bitmap_info_header_size))
    file:write(bytes(width))
    file:write(bytes(height))
    file:write(bytes2(bitmap_planes))
    file:write(bytes2(bitcount))
    file:write(bytes(0))
    file:write(bytes(image_size))
    file:write(bytes(0))
    file:write(bytes(0))
    file:write(bytes(0))
    file:write(bytes(0))

    local padding_per_row = math.fmod(4 - math.fmod((width * 3), 4) , 4)
    --print(padding_per_row)

    for i=height, 1, -1 do
        for j=1,width do

            -- Write BGR
            file:write(string.char(argb_table[j][i] % 256))
            file:write(string.char(math.floor(argb_table[j][i] / 256) % 256))
            file:write(string.char(math.floor(argb_table[j][i] / (256 * 256)) % 256))
            --file:write(string.char(math.floor((i - 1) * 255 / height)))
            --file:write(string.char(0))
            --file:write(string.char(math.floor((j - 1) * 255 / width)))
    
            --file:write(string.char(0xFF))
            --file:write(string.char(0xFF))
            --file:write(string.char(0xFF))

        end

        for i=0, padding_per_row - 1 do
            file:write(string.char(0))
        end

        -- Add padding bytes if we didn't write a multiple of 4 bytes in that row

    end

    file:flush()
    file:close()

end

return bmp_exporter