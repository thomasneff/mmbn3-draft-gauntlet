local gui_rendering = {}
local CHIP_NAME = require "defs.chip_name_defs"
local CHIP_ICON = require "defs.chip_icon_defs"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_CODE = require "defs.chip_code_defs"


local chip_image_background_path = "chip_image_background.png"
local buff_image_background_path = "buff_background.png"

function drawTextOutline(x_pos, y_pos, string, outline_color, color, background_color, font_size, font_family)


    -- This is a hack to prevent the background/selected box from stopping before the end of the text.
    gui.drawText(x_pos, y_pos, string .. "|", background_color, background_color, font_size, font_family)
    -- Draw simple outline
    gui.drawText(x_pos - 1, y_pos, string, outline_color, "transparent", font_size, font_family)
    gui.drawText(x_pos + 1, y_pos, string, outline_color, "transparent", font_size, font_family)
    gui.drawText(x_pos, y_pos - 1, string, outline_color, "transparent", font_size, font_family)
    gui.drawText(x_pos, y_pos + 1, string, outline_color, "transparent", font_size, font_family)
    gui.drawText(x_pos - 1, y_pos - 1, string, outline_color, "transparent", font_size, font_family)
    gui.drawText(x_pos + 1, y_pos + 1, string, outline_color, "transparent", font_size, font_family)
    gui.drawText(x_pos + 1, y_pos - 1, string, outline_color, "transparent", font_size, font_family)
    gui.drawText(x_pos - 1, y_pos + 1, string, outline_color, "transparent", font_size, font_family)

    -- Draw main text
    gui.drawText(x_pos, y_pos, string, color, "transparent", font_size, font_family)
end

-- We will use this for both icons and chip images with palettes.
function render_argb_2d_array(argb_2d_array, x_offset, y_offset, width, height)

    for x = 1,width do

        for y = 1,height do

            gui.drawPixel(x + x_offset, y + y_offset, argb_2d_array[x][y])

        end

    end

end

function render_chip_with_background(chip, x_offset, y_offset, width, height, is_selected)


    -- TODO: check if Normal/Mega/GigaChip
    
    local chip_image = chip.ARGB_PICTURE
    --print("CHIP IMAGE: ", chip_image)
    local chip_damage = tostring(CHIP_DATA[chip.ID].DAMAGE)
    local chip_print_name = chip.PRINT_NAME
    local bg_size_x = 80
    local bg_size_y = 139
    -- Render green selection box
    if is_selected == true then
        gui.drawRectangle(x_offset - 5, y_offset - 5, bg_size_x + 10, bg_size_y, nil, "green")
    end
    
    gui.drawImage(chip_image_background_path, x_offset, y_offset)
    local offset_between_background_and_chip_x = 7
    local offset_between_background_and_chip_y = 5
    if chip_image ~= nil then
       render_argb_2d_array(chip_image, x_offset + offset_between_background_and_chip_x , y_offset + offset_between_background_and_chip_y, width, height)
    end



    -- Render damage and print_name
    local name_offset_x = offset_between_background_and_chip_x
    local name_offset_y = 63
    local damage_offset_x = offset_between_background_and_chip_x
    local damage_offset_y = 79
    drawTextOutline(name_offset_x + x_offset, name_offset_y + y_offset,  chip_print_name, "black", "white", "transparent", 10, "Arial")
    drawTextOutline(damage_offset_x + x_offset, damage_offset_y + y_offset, "ATK: " ..  chip_damage, "black", "lightblue", "transparent", 10, "Arial")

end

function gui_rendering.render_chip_selection(chip_list, selected_chip_index)

    -- Assume 3 chips, draw them side by side.
    local num_chips = #chip_list
    --print(chip_list)
    local offset_per_chip_x = 80
    local base_offset_x = 0
    local base_offset_y = 20
    local x_offset = base_offset_x
    local y_offset = base_offset_y
    drawTextOutline(50, 0,  "Choose a BattleChip!", "black", "white", "transparent", 14, "Arial")
    for chip_idx = 1,num_chips do


        
        render_chip_with_background(chip_list[chip_idx], x_offset, y_offset, 64, 56, chip_idx == selected_chip_index)

        x_offset = x_offset + offset_per_chip_x

    end


end

function render_buff(buff, x_offset, y_offset, is_selected)

    -- Render green selection box
    local bg_size_x = 230
    local bg_size_y = 50

    if is_selected == true then
        gui.drawRectangle(x_offset - 5, y_offset - 3, bg_size_x + 9, bg_size_y + 5, nil, "green")
    end

    gui.drawImage(buff_image_background_path, x_offset, y_offset)
    local name_offset_x = 14
    local name_offset_y = 7
    local desc_offset_x = 14
    local desc_offset_y = 20
    --print("BUFF: ", buff)
    local buff_name = buff.NAME
    local buff_description = buff.DESCRIPTION

    drawTextOutline(name_offset_x + x_offset, name_offset_y + y_offset,  buff_name, "black", "white", "transparent", 10, "Arial")
    drawTextOutline(desc_offset_x + x_offset, desc_offset_y + y_offset, buff_description, "black", "lightblue", "transparent", 10, "Arial")




end



function gui_rendering.render_buff_selection(buff_list, selected_buff_index)

    -- Assume 3 buffs, draw them side by side.
    local num_buffs = #buff_list
    --print(buff_list)
    local offset_per_buff_x = 0
    local offset_per_buff_y = 53
    local base_offset_x = 5
    local base_offset_y = 3
    local x_offset = base_offset_x
    local y_offset = base_offset_y

    for buff_idx = 1,num_buffs do


        
        render_buff(buff_list[buff_idx], x_offset, y_offset, buff_idx == selected_buff_index)

        x_offset = x_offset + offset_per_buff_x
        y_offset = y_offset + offset_per_buff_y

    end


end




-- This function is used to render the current folder for chip replacement.
-- TODO: this currently just renders fixed Cannon *. Should take the folder into account.
function gui_rendering.render_folder(folder, selected_chip_index, new_chip)

    --print("RENDERING")
    --gui.clearGraphics()
    --gui.cleartext()
    local num_folder_chips = 30
    local num_chips_per_col = 15
    local num_cols = num_folder_chips / num_chips_per_col
    local base_offset_y = 0
    local base_offset_x = 22
    local icon_spacing = 2

    local offset_per_col = 90
    local offset_per_row = 10
    local x_offset = base_offset_x
    local y_offset = base_offset_y
    local chip_counter = 1
    for col_idx = 1, num_cols do
        y_offset = base_offset_y
        for row_idx = 1,num_chips_per_col do

           
            -- Render icon.
            render_argb_2d_array(folder[chip_counter].ARGB_ICON, x_offset - CHIP_ICON.WIDTH - 2, y_offset, CHIP_ICON.WIDTH,  CHIP_ICON.HEIGHT)

            if chip_counter == selected_chip_index then
               drawTextOutline(x_offset, y_offset,  folder[chip_counter].PRINT_NAME, "black", "white", "green", 10, "Arial")
            else
               drawTextOutline(x_offset, y_offset,  folder[chip_counter].PRINT_NAME, "black", "white", "transparent", 10, "Arial")
            end

            y_offset = y_offset + offset_per_row
            chip_counter = chip_counter + 1
        end
        x_offset = x_offset + offset_per_col
    end

    -- Render new chip

    local new_chip_offset_x = 182
    local new_chip_offset_y = 80


    if new_chip.PRINT_NAME ~= nil and new_chip.PRINT_NAME ~= "" then
        -- Render icon.
        render_argb_2d_array(new_chip.ARGB_ICON, new_chip_offset_x, new_chip_offset_y - offset_per_row * 1 - CHIP_ICON.HEIGHT, CHIP_ICON.WIDTH,  CHIP_ICON.HEIGHT)
        drawTextOutline(new_chip_offset_x, new_chip_offset_y - offset_per_row * 1,  "New Chip: ", "black", "green", "transparent", 9, "Arial")
        drawTextOutline(new_chip_offset_x, new_chip_offset_y,  new_chip.PRINT_NAME, "black", "white", "transparent", 9, "Arial")
        drawTextOutline(new_chip_offset_x, new_chip_offset_y + offset_per_row * 1, "ATK: " .. tostring(CHIP_DATA[new_chip.ID].DAMAGE), "black", "lightblue", "transparent", 9, "Arial")
        drawTextOutline(new_chip_offset_x, new_chip_offset_y + offset_per_row * 2,  "B = Cancel", "black", "red", "transparent", 9, "Arial")
    end

end



return gui_rendering