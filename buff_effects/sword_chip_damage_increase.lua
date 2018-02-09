local gauntlet_data = require "gauntlet_data"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_ID = require "defs.chip_id_defs"
local ELEMENT_DEFS = require "defs.entity_element_defs"
local SWORD_CHIP_DAMAGE_INCREASE = {

    NAME = "Sword-Mastery",

}

local DAMAGE_INCREASE_ADD = {20, 40, 60, 80, 100}
local DAMAGE_INCREASE_MULT = {20, 40, 60, 80, 100}

function SWORD_CHIP_DAMAGE_INCREASE:activate(current_round)

    -- This is an example for how to modify chip data.
    self.old_chip_data = deepcopy(CHIP_DATA)
    
    for key, chip_data in pairs(CHIP_DATA) do

        if  key == CHIP_ID.Sword or 
            key == CHIP_ID.Swordy or
            key == CHIP_ID.WideSwrd or
            key == CHIP_ID.LongSwrd or
            key == CHIP_ID.FireSwrd or
            key == CHIP_ID.AquaSwrd or
            key == CHIP_ID.ElecSwrd or
            key == CHIP_ID.BambSwrd or
            key == CHIP_ID.CustSwrd or
            key == CHIP_ID.VarSwrd  or
            key == CHIP_ID.StepSwrd or
            key == CHIP_ID.StepCros or
            key == CHIP_ID.Slasher  or
            key == CHIP_ID.Pawn     or
            key == CHIP_ID.AntiSwrd or
            key == CHIP_ID.Muramasa or
            key == CHIP_ID.HeroSwrd or
            key == CHIP_ID.GaiaSwrd or
            key == CHIP_ID.GaiaBlad or
            key == CHIP_ID.ProtoMan or
            key == CHIP_ID.ProtoMnV2 or
            key == CHIP_ID.ProtoMnV3 or
            key == CHIP_ID.ProtoMnV4 or
            key == CHIP_ID.ProtoMnV5 or
            key == CHIP_ID.DeltaRay or
            key == CHIP_ID.LifeSwrd or
            key == CHIP_ID.ElemSwrd or
            key == CHIP_ID.ZStep1 or
            key == CHIP_ID.ZStep2 or
            key == CHIP_ID.EvilCut
        then

            if self.ADDITIVE == 1 then
                
                CHIP_DATA[key].DAMAGE = CHIP_DATA[key].DAMAGE + DAMAGE_INCREASE_ADD[current_round]
            else
                CHIP_DATA[key].DAMAGE = math.floor(CHIP_DATA[key].DAMAGE * ((100.0 + DAMAGE_INCREASE_MULT[current_round]) / 100.0))
            end
        end

    end


end

function SWORD_CHIP_DAMAGE_INCREASE:deactivate(current_round)

    -- This is an example for how to modify chip data.
    for key, chip_data in pairs(CHIP_DATA) do

        if  key == CHIP_ID.Sword or 
            key == CHIP_ID.Swordy or
            key == CHIP_ID.WideSwrd or
            key == CHIP_ID.LongSwrd or
            key == CHIP_ID.FireSwrd or
            key == CHIP_ID.AquaSwrd or
            key == CHIP_ID.ElecSwrd or
            key == CHIP_ID.BambSwrd or
            key == CHIP_ID.CustSwrd or
            key == CHIP_ID.VarSwrd  or
            key == CHIP_ID.StepSwrd or
            key == CHIP_ID.StepCros or
            key == CHIP_ID.Slasher  or
            key == CHIP_ID.Pawn     or
            key == CHIP_ID.AntiSwrd or
            key == CHIP_ID.Muramasa or
            key == CHIP_ID.HeroSwrd or
            key == CHIP_ID.GaiaSwrd or
            key == CHIP_ID.GaiaBlad or
            key == CHIP_ID.ProtoMan or
            key == CHIP_ID.ProtoMnV2 or
            key == CHIP_ID.ProtoMnV3 or
            key == CHIP_ID.ProtoMnV4 or
            key == CHIP_ID.ProtoMnV5 or
            key == CHIP_ID.DeltaRay or
            key == CHIP_ID.LifeSwrd or
            key == CHIP_ID.ElemSwrd or
            key == CHIP_ID.ZStep1 or
            key == CHIP_ID.ZStep2 or
            key == CHIP_ID.EvilCut
        then
            CHIP_DATA[key] = deepcopy(self.old_chip_data[key])
        end

    end

end


function SWORD_CHIP_DAMAGE_INCREASE:get_description(current_round)


    if self.ADDITIVE == 0 then
        return "Increases Damage of all Sword-Type\nChips by "
                 .. tostring(DAMAGE_INCREASE_MULT[current_round]) .. "%!"
    else

        return "Increases Damage of all Sword-Type\nChips by "
                 .. tostring(DAMAGE_INCREASE_ADD[current_round]) .. "!"
    
    end

end




function SWORD_CHIP_DAMAGE_INCREASE.new()

    local new_buff = deepcopy(SWORD_CHIP_DAMAGE_INCREASE)
    
    -- TODO: roll element and additive/multiplicative.
    new_buff.ADDITIVE = math.random(0, 1)

    if new_buff.ADDITIVE == 0 then
        new_buff.NAME = "Sword-Mastery (Multiplicative)"
    else

        new_buff.NAME = "Sword-Mastery (Additive)"
    
    end
    
    new_buff.DESCRIPTION = new_buff:get_description(1)
    return deepcopy(new_buff)

end


return SWORD_CHIP_DAMAGE_INCREASE