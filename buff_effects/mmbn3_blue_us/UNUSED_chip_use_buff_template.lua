local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"

local ChipUseBuff = {
    NAME = "ChipUseBuff",
}




function ChipUseBuff:activate(current_round)



end


function ChipUseBuff:deactivate(current_round)


end

function ChipUseBuff:get_description(current_round)

    return "ChipUseBuff"

end

function ChipUseBuff:get_brief_description()
    return ChipUseBuff.NAME .. ": " .. " NULL "
end

function ChipUseBuff:on_chip_use(chip, current_frame, state_logic, gauntlet_data)
    print("Used chip " .. chip.NAME)
    print("Damaging random enemy for 10!")
    state_logic.damage_random_enemy(10)

    if (self.used_chips == nil) then
        self.used_chips = {}
    end



    self.used_chips[#self.used_chips + 1] = deepcopy(chip)

    if (#self.used_chips == 5) then
        print("Used 5 chips in this battle phase - 100 damage to all!")
        state_logic.damage_all_enemies(100)
        self.used_chips = {}
    end

end

function ChipUseBuff:on_cust_screen_confirm(state_logic, gauntlet_data)

    print ("Cust screen confirmed!")
    self.used_chips = {}

end

function ChipUseBuff.new()

    local new_ChipUseBuff = deepcopy(ChipUseBuff)
    new_ChipUseBuff.DESCRIPTION = new_ChipUseBuff:get_description(1)
    new_ChipUseBuff.ON_CHIP_USE_CALLBACK = 1
    new_ChipUseBuff.ON_CUST_SCREEN_CONFIRM_CALLBACK = 1
    

    return deepcopy(new_ChipUseBuff)

end


return ChipUseBuff