local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local ComboStacker = {
    NAME = "Combo Stacker",
}




function ComboStacker:activate(current_round)



end


function ComboStacker:deactivate(current_round)


end

function ComboStacker:get_description(current_round)

    return "Using 5 chips in 1 battle phase\ndeals 100 damage to all enemies!"

end

function ComboStacker:get_brief_description()
    return ComboStacker.NAME .. ": " .. "3 chips in turn -> 100 damage all!"
end

function ComboStacker:on_chip_use(chip, current_frame, state_logic, gauntlet_data)
    if (self.used_chips == nil) then
        self.used_chips = {}
    end

    self.used_chips[#self.used_chips + 1] = deepcopy(chip)

    if (#self.used_chips == 5) then
        state_logic.damage_all_enemies(100)
        self.used_chips = {}
    end

end

function ComboStacker:on_cust_screen_confirm(state_logic, gauntlet_data)
    self.used_chips = {}
end

function ComboStacker.new()

    local new_ComboStacker = deepcopy(ComboStacker)
    new_ComboStacker.DESCRIPTION = new_ComboStacker:get_description(1)
    new_ComboStacker.ON_CUST_SCREEN_CONFIRM_CALLBACK = 1
    new_ComboStacker.ON_CHIP_USE_CALLBACK = 1

    return deepcopy(new_ComboStacker)

end


return ComboStacker