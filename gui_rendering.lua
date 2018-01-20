local gui_rendering = {}



function drawTextOutline(x_pos, y_pos, string, outline_color, color, background_color, font_size, font_family)

     -- Draw simple outline
     --gui.pixelText(x_pos - 1, y_pos, string, outline_color, "transparent")
     --gui.pixelText(x_pos + 1, y_pos, string, outline_color, "transparent")
     --gui.pixelText(x_pos, y_pos - 1, string, outline_color, "transparent")
     --gui.pixelText(x_pos, y_pos + 1, string, outline_color, "transparent")

    -- Draw main text
    --gui.pixelText(x_pos, y_pos, string, color, "transparent")
    -- Draw selected background
    --gui.drawText(x_pos + 2, y_pos, string, color, background_color, font_size, font_family)
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




-- This function is used to render the current folder for chip replacement.
-- TODO: this currently just renders fixed Cannon *. Should take the folder into account.
function gui_rendering.render_folder(folder, selected_chip_index)

    --print("RENDERING")
    --gui.clearGraphics()
    --gui.cleartext()
    local num_folder_chips = 30
    local num_chips_per_col = 15
    local num_cols = num_folder_chips / num_chips_per_col
    local base_offset_y = 0
    local base_offset_x = 4
    local offset_per_col = 100
    local offset_per_row = 10
    local x_offset = base_offset_x
    local y_offset = base_offset_y
    local chip_counter = 1
    for col_idx = 1, num_cols do
        y_offset = base_offset_y
        for chip_idx = 1,num_chips_per_col do
            --gui.pixelText(x_offset, y_offset, "Cannon *")
            if chip_counter == selected_chip_index then
                drawTextOutline(x_offset, y_offset, "BubbleManV5 *", "black", "white", "green", 10, "Arial")
            else
                drawTextOutline(x_offset, y_offset, "BubbleManV5 *", "black", "white", "transparent", 10, "Arial")
            end

            y_offset = y_offset + offset_per_row
            chip_counter = chip_counter + 1
        end
        x_offset = x_offset + offset_per_col
    end
end



return gui_rendering