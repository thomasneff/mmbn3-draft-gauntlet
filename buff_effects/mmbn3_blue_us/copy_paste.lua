local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local CopyPaste = {
    NAME = "COPY_PASTE.EXE",
    DOUBLE_RARITY = 1
}

local NUMBER_OF_BUFFS_DOUBLED = 3

function CopyPaste:activate(current_round)

    gauntlet_data.copy_paste_active_number_of_buffs = gauntlet_data.copy_paste_active_number_of_buffs + NUMBER_OF_BUFFS_DOUBLED

end


function CopyPaste:deactivate(current_round)

    gauntlet_data.copy_paste_active_number_of_buffs = 0

end

function CopyPaste:get_description(current_round)

    return "Activate the next " .. NUMBER_OF_BUFFS_DOUBLED .. " buffs twice!"

end

function CopyPaste:get_brief_description()
    return CopyPaste.NAME .. ": Double next " .. NUMBER_OF_BUFFS_DOUBLED .. " buffs! (" .. tostring(gauntlet_data.copy_paste_active_number_of_buffs) .. " left)"
end

function CopyPaste.new()

    local new_CopyPaste = deepcopy(CopyPaste)
    new_CopyPaste.DESCRIPTION = new_CopyPaste:get_description(1)

    return deepcopy(new_CopyPaste)

end


return CopyPaste