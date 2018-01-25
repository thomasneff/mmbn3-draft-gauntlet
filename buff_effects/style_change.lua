local gauntlet_data = require "gauntlet_data"
local STYLE_GENERATOR = require "defs.style_defs"
local deepcopy = require "deepcopy"
local STYLE_CHANGE = {

    NAME = "Tank",

}

local STYLE_CHANGE_PER_ROUND = {50, 100, 200, 400}

function STYLE_CHANGE:activate(current_round)

    self.old_style = gauntlet_data.mega_style
    gauntlet_data.mega_style = self.STYLE


end


function STYLE_CHANGE:deactivate(current_round)

    gauntlet_data.mega_style = self.old_style


end

function STYLE_CHANGE:get_description(current_round)

    return "MegaMan changes to " .. self.NAME .. "!"


end



function STYLE_CHANGE.new()


    local new_style_change = deepcopy(STYLE_CHANGE)
    local new_style = deepcopy(STYLE_GENERATOR.random_style())
    print("NEW NAME: ", new_style.NAME, "STYLE:", new_style.STYLE)
    new_style_change.STYLE = new_style.STYLE
    new_style_change.NAME = new_style.NAME .. "-Style"
    new_style_change.DESCRIPTION = new_style_change:get_description(1)

    return deepcopy(new_style_change)

end


return STYLE_CHANGE