local gui_rendering = {}
local CHIP_NAME = require "defs.chip_name_defs"
local CHIP_ICON = require "defs.chip_icon_defs"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_CODE = require "defs.chip_code_defs"


local chip_image_background_path = "chip_image_background.png"
local chip_rare_image_background_path = "chip_image_background_rare.png"
local chip_super_rare_image_background_path = "chip_image_background_super_rare.png"
local chip_ultra_rare_image_background_path = "chip_image_background_ultra_rare.png"
local chip_dark_image_background_path = "chip_image_background_dark.png"
local buff_image_background_path = "buff_background.png"
local loadout_image_background_path = "buff_background.png"
local arrow_left_path = "arrow_left.png"
local arrow_right_path = "arrow_right.png"
local arrow_up_path = "arrow_up.png"
local arrow_down_path = "arrow_down.png"

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
    if chip.RARITY == nil then
        gui.drawImage(chip_image_background_path, x_offset, y_offset)
    elseif chip.RARITY == 0 then
        gui.drawImage(chip_image_background_path, x_offset, y_offset)
    elseif chip.RARITY == 1 then
        gui.drawImage(chip_rare_image_background_path, x_offset, y_offset)
    elseif chip.RARITY == 2 then
        gui.drawImage(chip_super_rare_image_background_path, x_offset, y_offset)
    elseif chip.RARITY == 3 then
        gui.drawImage(chip_ultra_rare_image_background_path, x_offset, y_offset)
    elseif chip.RARITY == 4 then
        gui.drawImage(chip_dark_image_background_path, x_offset, y_offset)
    else
        gui.drawImage(chip_image_background_path, x_offset, y_offset)
    end
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


        if chip_idx ~= selected_chip_index then
            render_chip_with_background(chip_list[chip_idx], x_offset, y_offset, 64, 56, false)
        end
        x_offset = x_offset + offset_per_chip_x

    end
    x_offset = base_offset_x + offset_per_chip_x * (selected_chip_index - 1)
    -- We render the selected chip always last.
    render_chip_with_background(chip_list[selected_chip_index], x_offset, y_offset, 64, 56, true)



end

function render_buff(buff, x_offset, y_offset, is_selected)

    -- Render green selection box
    local bg_size_x = 230
    local bg_size_y = 50

    if is_selected == true then
        gui.drawRectangle(x_offset - 5, y_offset - 3, bg_size_x + 9, bg_size_y + 5, nil, "green")
    end

    gui.drawImage(buff_image_background_path, x_offset, y_offset)
    local name_offset_x = 10
    local name_offset_y = 7
    local desc_offset_x = 10
    local desc_offset_y = 20
    --print("BUFF: ", buff)
    local buff_name = buff.NAME
    local buff_description = buff.DESCRIPTION

    drawTextOutline(name_offset_x + x_offset, name_offset_y + y_offset,  buff_name, "black", "white", "transparent", 9, "Arial")
    drawTextOutline(desc_offset_x + x_offset, desc_offset_y + y_offset, buff_description, "black", "lightblue", "transparent", 9, "Arial")




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



function render_loadout(loadout, x_offset, y_offset, is_selected)

    -- Render green selection box
    local bg_size_x = 230
    local bg_size_y = 50

    if is_selected == true then
        gui.drawRectangle(x_offset - 5, y_offset - 3, bg_size_x + 9, bg_size_y + 5, nil, "green")
    end

    gui.drawImage(loadout_image_background_path, x_offset, y_offset)
    local name_offset_x = 10
    local name_offset_y = 7
    local desc_offset_x = 10
    local desc_offset_y = 20
    --print("loadout: ", loadout)
    local loadout_name = loadout.NAME
    local loadout_description = loadout.DESCRIPTION

    drawTextOutline(name_offset_x + x_offset, name_offset_y + y_offset,  loadout_name, "black", "white", "transparent", 9, "Arial")
    drawTextOutline(desc_offset_x + x_offset, desc_offset_y + y_offset, loadout_description, "black", "lightblue", "transparent", 9, "Arial")




end

function gui_rendering.render_loadouts(loadout_list, selected_loadout_index)

    -- Assume 3 loadouts, draw them side by side.
    local num_loadouts = #loadout_list
    --print(loadout_list)
    local offset_per_loadout_x = 0
    local offset_per_loadout_y = 53
    local base_offset_x = 5
    local base_offset_y = 3 + offset_per_loadout_y
    base_offset_y = base_offset_y - offset_per_loadout_y * (selected_loadout_index - 1)
    local x_offset = base_offset_x
    local y_offset = base_offset_y


    

    for loadout_idx = 1,num_loadouts do


        
        render_loadout(loadout_list[loadout_idx], x_offset, y_offset, loadout_idx == selected_loadout_index)

        x_offset = x_offset + offset_per_loadout_x
        y_offset = y_offset + offset_per_loadout_y

    end

    -- Render arrow guides
    if (num_loadouts - selected_loadout_index) > 1 then
        -- Render down-arrow.

        gui.drawImage(arrow_down_path, 220, 140, 16, 8)

    end

    if (selected_loadout_index) > 2 then
        -- Render down-arrow.

        gui.drawImage(arrow_up_path, 220, 10, 16, 8)

    end


end

function gui_rendering.render_gauntlet_complete()

    drawTextOutline(20, 60,  "Congratulations!", "black", "white", "transparent", 16, "Arial")
    drawTextOutline(20, 100,  "You Win!", "black", "white", "transparent", 16, "Arial")

end

-- This function is used to render the current folder for chip replacement.
-- TODO: this currently just renders fixed Cannon *. Should take the folder into account.
function gui_rendering.render_folder(folder, selected_chip_index, new_chip, gauntlet_data)

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

    local can_replace_chip = true

    if new_chip == nil or new_chip.ID == -1 then
    
    else
        local dropped_chip_data = CHIP_DATA[new_chip.ID]
        --print("DROPPED CHIP DATA: ", dropped_chip_data)
        local is_dropped_chip_mega = (dropped_chip_data.CHIP_RANKING % 4) == 1
        local is_dropped_chip_giga = (dropped_chip_data.CHIP_RANKING % 4) == 2
        local folder_chip_data = CHIP_DATA[folder[selected_chip_index].ID]
        --print("FOLDER CHIP DATA: ", folder_chip_data)
        local is_folder_chip_mega = (folder_chip_data.CHIP_RANKING % 4) == 1
        local is_folder_chip_giga = (folder_chip_data.CHIP_RANKING % 4) == 2

        local replaces_mega_chip = is_folder_chip_mega and is_dropped_chip_mega

        local replaces_giga_chip = is_folder_chip_giga and is_dropped_chip_giga

                            --print("REPLACES: ", replaces_mega_chip, replaces_giga_chip)
        if (((dropped_chip_data.CHIP_RANKING % 4) == 1 and gauntlet_data.current_number_of_mega_chips >= gauntlet_data.mega_chip_limit + gauntlet_data.mega_chip_limit_team) 
        or ((dropped_chip_data.CHIP_RANKING % 4) == 2 and gauntlet_data.current_number_of_giga_chips >= gauntlet_data.giga_chip_limit))
                                
        and replaces_mega_chip == false and replaces_giga_chip == false
        then
            can_replace_chip = false
        else

        end
    end


    



    
   
    for col_idx = 1, num_cols do
        y_offset = base_offset_y
        for row_idx = 1,num_chips_per_col do

            if folder[chip_counter] ~= nil then
                
           
                -- Render icon.
                render_argb_2d_array(folder[chip_counter].ARGB_ICON, x_offset - CHIP_ICON.WIDTH - 2, y_offset, CHIP_ICON.WIDTH,  CHIP_ICON.HEIGHT)

                if chip_counter == selected_chip_index then
                    -- Render red background if we can't add a new megachip.
                    if can_replace_chip == false then
                        drawTextOutline(x_offset, y_offset,  folder[chip_counter].PRINT_NAME, "black", "white", "red", 10, "Arial")
                    else
                        drawTextOutline(x_offset, y_offset,  folder[chip_counter].PRINT_NAME, "black", "white", "green", 10, "Arial")
                    end
                else
                    drawTextOutline(x_offset, y_offset,  folder[chip_counter].PRINT_NAME, "black", "white", "transparent", 10, "Arial")
                end

            end

            y_offset = y_offset + offset_per_row
            chip_counter = chip_counter + 1
        end
        x_offset = x_offset + offset_per_col
    end

    -- Render new chip

    local new_chip_offset_x = 178
    local new_chip_offset_y = 80

    --print(new_chip)
    if new_chip ~= nil and new_chip.PRINT_NAME ~= nil and new_chip.PRINT_NAME ~= "" and new_chip.ID ~= -1 then
        -- Render icon.
        render_argb_2d_array(new_chip.ARGB_ICON, new_chip_offset_x + 2, new_chip_offset_y - offset_per_row * 1 - CHIP_ICON.HEIGHT - 2, CHIP_ICON.WIDTH,  CHIP_ICON.HEIGHT)
        drawTextOutline(new_chip_offset_x, new_chip_offset_y - offset_per_row * 1,  "New Chip: ", "black", "green", "transparent", 9, "Arial")
        drawTextOutline(new_chip_offset_x, new_chip_offset_y,  new_chip.PRINT_NAME, "black", "white", "transparent", 9, "Arial")
        drawTextOutline(new_chip_offset_x, new_chip_offset_y + offset_per_row * 1, "ATK: " .. tostring(CHIP_DATA[new_chip.ID].DAMAGE), "black", "lightblue", "transparent", 9, "Arial")
        drawTextOutline(new_chip_offset_x, new_chip_offset_y + offset_per_row * 2,  "B = Cancel", "black", "red", "transparent", 9, "Arial")
    end

    -- Render Mega/GigaChip limits
    new_chip_offset_y = 0
    drawTextOutline(new_chip_offset_x, new_chip_offset_y,  "Mega: " , "black", "white", "transparent", 10, "Arial")
    
    drawTextOutline(new_chip_offset_x + 32, new_chip_offset_y,  tostring(gauntlet_data.current_number_of_mega_chips) 
                                                                    .. " / " .. tostring(gauntlet_data.mega_chip_limit + gauntlet_data.mega_chip_limit_team) , "black", "white", "transparent", 10, "Arial")
    
    drawTextOutline(new_chip_offset_x, new_chip_offset_y + 10,  "Giga: ", "black", "white", "transparent", 10, "Arial")
    
    drawTextOutline(new_chip_offset_x + 32, new_chip_offset_y + 10,  tostring(gauntlet_data.current_number_of_giga_chips) 
                                                                    .. " / " .. tostring(gauntlet_data.giga_chip_limit) , "black", "white", "transparent", 10, "Arial")

    -- Render Sorting mode
    drawTextOutline(new_chip_offset_x, new_chip_offset_y + 30, "Sort:", "black", "white", "transparent", 10, "Arial")
    if gauntlet_data.folder_shuffle_state == 0 then
        -- Alphabetically
        drawTextOutline(new_chip_offset_x + 32, new_chip_offset_y + 30, "ABC", "black", "orange", "transparent", 10, "Arial")


    elseif gauntlet_data.folder_shuffle_state == 1 then
        -- Code
        drawTextOutline(new_chip_offset_x + 32, new_chip_offset_y + 30, "Code", "black", "orange", "transparent", 10, "Arial")

    elseif gauntlet_data.folder_shuffle_state == 2 then
        -- ID
        drawTextOutline(new_chip_offset_x + 32, new_chip_offset_y + 30, "ID", "black", "orange", "transparent", 10, "Arial")

    elseif gauntlet_data.folder_shuffle_state == 3 then
        -- Damage
        drawTextOutline(new_chip_offset_x + 32, new_chip_offset_y + 30, "ATK", "black", "orange", "transparent", 10, "Arial")
    end




end



return gui_rendering