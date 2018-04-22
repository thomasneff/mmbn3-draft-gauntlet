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

    if self.STYLE >= 0x11 and self.STYLE <= 0x14 then
        gauntlet_data.cust_style_number_of_chips = 1
    else
        gauntlet_data.cust_style_number_of_chips = 0
    end

    if self.STYLE >= 0x31 and self.STYLE <= 0x34 then
        gauntlet_data.mega_WeaponLevelPlus = 0
    end


    if self.STYLE >= 0x19 and self.STYLE <= 0x1C then
        gauntlet_data.mega_chip_limit_team = 1
    end


end


function STYLE_CHANGE:deactivate(current_round)

    gauntlet_data.mega_style = self.old_style
    gauntlet_data.cust_style_mp = 0
    gauntlet_data.cust_style_number_of_chips = 0
    gauntlet_data.mega_chip_limit_team = 0

end

function STYLE_CHANGE:get_description(current_round)

    return "MegaMan changes to " .. self.NAME .. "!"


end


function STYLE_CHANGE:get_brief_description()

    local ret = self.NAME .. ": Chrg = "


    if self.STYLE >= 0x31 and self.STYLE <= 0x34 then

        ret = ret .. " Invis, "

    else

        if self.STYLE % 4 == 0 then

            ret = ret .. " WoodTorn, "

        elseif self.STYLE % 4 == 1 then

            ret = ret .. " ZapRing, "

        elseif self.STYLE % 4 == 2 then

            ret = ret .. " FlamThrwr, "

        else

            ret = ret .. " Bubbler, "

        end

    end

    if self.STYLE >= 0x11 and self.STYLE <= 0x14 then
        ret = ret .. "Custom +1!"
    end

    if self.STYLE >= 0x21 and self.STYLE <= 0x24 then
        ret = ret .. "Barrier!"
    end

    if self.STYLE >= 0x09 and self.STYLE <= 0x0C then
        ret = ret .. "Gatling-Bstr!"
    end

    if self.STYLE >= 0x19 and self.STYLE <= 0x1C then
        ret = ret .. "MegaChips +1!"
    end

    if self.STYLE >= 0x29 and self.STYLE <= 0x2C then
        ret = ret .. "Charge breaks!"
    end

    if self.STYLE >= 0x39 and self.STYLE <= 0x3C then
        ret = ret .. "Random Bugs!"
    end

    

    return ret
end

function STYLE_CHANGE.new()


    local new_style_change = deepcopy(STYLE_CHANGE)
    local new_style = deepcopy(STYLE_GENERATOR.random_style())

    new_style_change.STYLE = new_style.STYLE
    new_style_change.NAME = new_style.NAME .. "-Style"
    new_style_change.DESCRIPTION = new_style_change:get_description(1)

    return deepcopy(new_style_change)

end


return STYLE_CHANGE