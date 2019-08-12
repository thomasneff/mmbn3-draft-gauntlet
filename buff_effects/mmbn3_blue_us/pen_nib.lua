local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local PenNib = {
    NAME = "Pen Nib",
    REMOVE_AFTER_ACTIVATION = 1
}

local DAMAGE_INCREASE = 0.5


function PenNib:activate(current_round)


end


function PenNib:deactivate(current_round)


end

function PenNib:get_description(current_round)

    return "Every 10th Chip used deals +" .. tostring(math.floor(DAMAGE_INCREASE * 100)) .. "% damage!"

end

function PenNib:get_brief_description()
    return PenNib.NAME .. ": " .. "every 10th Chip -> +" .. tostring(math.floor(DAMAGE_INCREASE * 100)) ..  "% damage!\n(Current: " .. tostring(self.chip_use_count) .. " / 10)"
end

function PenNib:on_chip_use(chip, current_frame, state_logic, gauntlet_data)
    
    
    self.chip_use_count = self.chip_use_count + 1


    if self.chip_use_count == 9 then
        --print ("Pen Nib activation!")
        gauntlet_data.pen_nib_bonus_damage = gauntlet_data.pen_nib_bonus_damage + DAMAGE_INCREASE
    elseif self.chip_use_count >= 10 then
        self.chip_use_count = 0
        gauntlet_data.pen_nib_bonus_damage = 0
    end

end


function PenNib.new()

    local new_PenNib = deepcopy(PenNib)
    new_PenNib.DESCRIPTION = new_PenNib:get_description(1)
    new_PenNib.ON_CHIP_USE_CALLBACK = 1
    new_PenNib.chip_use_count = 0

    return deepcopy(new_PenNib)

end


return PenNib