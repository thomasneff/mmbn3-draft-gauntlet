local gauntlet_data = require "gauntlet_data"
local BATTLE_STAGE_DEFS = {}

-- Taken from http://forums.therockManexezone.com/topic/8831451/1/
BATTLE_STAGE_DEFS.NUM_STAGES = 127

function BATTLE_STAGE_DEFS.is_lava_panel(x, y, battle_stage)
    
    if battle_stage == 0x0B then
        return 
        (x == 2 and y == 1) or 
        (x == 2 and y == 3) or
        (x == 5 and y == 1) or 
        (x == 5 and y == 3)
    elseif battle_stage == 0x0C then
        return 
        (x == 1 and y == 1) or 
        (x == 1 and y == 3) or
        (x == 3 and y == 1) or 
        (x == 3 and y == 3) or
        (x == 4 and y == 1) or 
        (x == 4 and y == 3) or
        (x == 6 and y == 1) or 
        (x == 6 and y == 3) 
    elseif battle_stage == 0x0D then
        return
        (x == 2 and y == 2) or
        (x == 5 and y == 2)
    elseif battle_stage == 0x5A then
        return 
        (x == 1 and y == 2) or 
        (x == 1 and y == 3) or
        (x == 3 and y == 2) or 
        (x == 4 and y == 2) or
        (x == 6 and y == 1) or 
        (x == 6 and y == 2) 
    elseif battle_stage == 0x5B then
        return 
        (x == 1 and y == 1) or 
        (x == 1 and y == 2) or
        (x == 1 and y == 3) or 
        (x == 6 and y == 1) or 
        (x == 6 and y == 2) or
        (x == 6 and y == 3)
    elseif battle_stage == 0x5C then
        return 
        (x == 2 and y == 3) or 
        (x == 3 and y == 2) or
        (x == 3 and y == 3) or 
        (x == 4 and y == 2) or 
        (x == 4 and y == 3) or
        (x == 5 and y == 3)
    elseif battle_stage == 0x5D then
        return 
        (x == 1 and y == 2) or 
        (x == 3 and y == 1) or
        (x == 4 and y == 1) or 
        (x == 4 and y == 3) 
    elseif battle_stage == 0x5F then
        return 
        (x == 1 and y == 1) or 
        (x == 2 and y == 3) or
        (x == 6 and y == 2) or 
        (x == 6 and y == 3) 
    elseif battle_stage == 0x56 then
        return 
        (x == 1 and y == 1) or 
        (x == 1 and y == 2) or
        (x == 1 and y == 3) or 
        (x == 3 and y == 1) or 
        (x == 3 and y == 2) or
        (x == 3 and y == 3) or 
        (x == 4 and y == 1) or 
        (x == 4 and y == 2) or
        (x == 4 and y == 3) or 
        (x == 6 and y == 1) or 
        (x == 6 and y == 2) or
        (x == 6 and y == 3)
    elseif battle_stage == 0x57 then
        return 
        (x == 2 and y == 1) or 
        (x == 2 and y == 2) or
        (x == 2 and y == 3) or 
        (x == 3 and y == 1) or 
        (x == 3 and y == 2) or
        (x == 3 and y == 3) or 
        (x == 4 and y == 1) or 
        (x == 4 and y == 2) or
        (x == 4 and y == 3) or 
        (x == 5 and y == 1) or 
        (x == 5 and y == 2) or
        (x == 5 and y == 3)
    elseif battle_stage == 0x58 then
        return 
        (x == 3 and y == 1) or 
        (x == 3 and y == 2) or
        (x == 3 and y == 3) or 
        (x == 4 and y == 1) or 
        (x == 4 and y == 2) or
        (x == 4 and y == 3)
    elseif battle_stage == 0x59 then
        return
        (x == 2 and y == 3) or 
        (x == 3 and y == 2) or
        (x == 3 and y == 3) or 
        (x == 4 and y == 1) or 
        (x == 4 and y == 2) or
        (x == 5 and y == 1)
    elseif battle_stage == 0x60 then
        return
        (x == 1 and y == 3) or 
        (x == 2 and y == 3) or
        (x == 3 and y == 3) or 
        (x == 4 and y == 3) or 
        (x == 5 and y == 3) or
        (x == 6 and y == 3)
    elseif battle_stage == 0x61 then
        return
        (x == 1 and y == 1) or 
        (x == 1 and y == 2) or
        (x == 2 and y == 1) or 
        (x == 5 and y == 3) or 
        (x == 6 and y == 2) or
        (x == 6 and y == 3)
    elseif battle_stage == 0x62 then
        return
        (x == 1 and y == 1) or 
        (x == 1 and y == 2) or
        (x == 1 and y == 3) or 
        (x == 2 and y == 1) or 
        (x == 3 and y == 1) or
        (x == 4 and y == 3) or 
        (x == 5 and y == 3) or
        (x == 6 and y == 1) or 
        (x == 6 and y == 2) or 
        (x == 6 and y == 3)
    elseif battle_stage == 0x63 then
        return
        (x == 2 and y == 3) or 
        (x == 3 and y == 1) or
        (x == 5 and y == 3) or 
        (x == 6 and y == 2)
    elseif battle_stage == 0x64 then
        return
        (x == 1 and y == 2) or 
        (x == 3 and y == 1) or
        (x == 3 and y == 2) or 
        (x == 4 and y == 1) or 
        (x == 4 and y == 2) or
        (x == 4 and y == 3)
    elseif battle_stage == 0x65 then
        return
        (x == 1 and y == 1) or 
        (x == 3 and y == 2) or
        (x == 3 and y == 3) or 
        (x == 4 and y == 2) or 
        (x == 4 and y == 3) or
        (x == 6 and y == 1)
    elseif battle_stage == 0x70 then
        return
        (x == 1 and y == 3) or
        (x == 6 and y == 3)
    end


    return false
end

function BATTLE_STAGE_DEFS.is_poison_panel(x, y, battle_stage)

    if battle_stage == 0x0A then
        return
        (x == 1 and y == 1) or
        (x == 1 and y == 2) or
        (x == 1 and y == 3) or
        (x == 6 and y == 1) or
        (x == 6 and y == 2) or
        (x == 6 and y == 3)
    elseif battle_stage == 0x4C then
        return
        (x == 2 and y == 1) or
        (x == 3 and y == 1) or
        (x == 3 and y == 2) or
        (x == 4 and y == 2) or
        (x == 4 and y == 3) or
        (x == 5 and y == 3)
    elseif battle_stage == 0x4D then
        return
        (x == 2 and y == 1) or
        (x == 2 and y == 2) or
        (x == 2 and y == 3) or
        (x == 3 and y == 1) or
        (x == 3 and y == 2) or
        (x == 3 and y == 3) or
        (x == 4 and y == 1) or
        (x == 4 and y == 2) or
        (x == 4 and y == 3) or
        (x == 5 and y == 1) or
        (x == 5 and y == 2) or
        (x == 5 and y == 3)
    elseif battle_stage == 0x4E then
        return
        (x == 1 and y == 2) or
        (x == 1 and y == 3) or
        (x == 2 and y == 2) or
        (x == 2 and y == 3) or
        (x == 5 and y == 1) or
        (x == 5 and y == 2) or
        (x == 6 and y == 1) or
        (x == 6 and y == 2)
    elseif battle_stage == 0x4F then
        return
        (x == 1 and y == 2) or
        (x == 2 and y == 2) or
        (x == 3 and y == 2) or
        (x == 4 and y == 2) or
        (x == 5 and y == 2) or
        (x == 6 and y == 2) 
    elseif battle_stage == 0x5E then
        return
        ((x == 2 and y == 2) or
        (x == 5 and y == 2)) == false
    elseif battle_stage == 0x08 then
        return
        (x == 2 and y == 2) or
        (x == 3 and y == 1) or
        (x == 3 and y == 2) or
        (x == 3 and y == 3) or
        (x == 4 and y == 1) or
        (x == 4 and y == 2) or
        (x == 4 and y == 3) or
        (x == 5 and y == 2)
    elseif battle_stage == 0x09 then
        return
        (x == 1 and y == 1) or
        (x == 1 and y == 2) or
        (x == 1 and y == 3) or
        (x == 2 and y == 1) or
        (x == 2 and y == 2) or
        (x == 2 and y == 3) or
        (x == 5 and y == 1) or
        (x == 5 and y == 2) or
        (x == 5 and y == 3) or
        (x == 6 and y == 1) or
        (x == 6 and y == 2) or
        (x == 6 and y == 3)
    elseif battle_stage == 0x50 then
        return
        (x == 1 and y == 3) or
        (x == 2 and y == 1) or
        (x == 3 and y == 2) or
        (x == 4 and y == 1) or
        (x == 4 and y == 3) or
        (x == 6 and y == 2) 
    elseif battle_stage == 0x51 then
        return
        (x == 1 and y == 1) or
        (x == 2 and y == 3) or
        (x == 3 and y == 1) or
        (x == 4 and y == 3) or
        (x == 5 and y == 1) or
        (x == 6 and y == 3)
    elseif battle_stage == 0x52 then
        return
        (x == 1 and y == 3) or
        (x == 2 and y == 2) or
        (x == 6 and y == 1) or
        (x == 6 and y == 2) 
    elseif battle_stage == 0x53 then
        return
        (x == 3 and y == 1) or
        (x == 3 and y == 2) or
        (x == 3 and y == 3) or
        (x == 4 and y == 1) or
        (x == 4 and y == 2) or
        (x == 4 and y == 3)
    elseif battle_stage == 0x54 then
        return
        (x == 2 and y == 1) or
        (x == 2 and y == 2) or
        (x == 5 and y == 2) or
        (x == 5 and y == 3)
    elseif battle_stage == 0x55 then
        return
        (x == 1 and y == 3) or
        (x == 2 and y == 2) or
        (x == 3 and y == 1) or
        (x == 4 and y == 3) or
        (x == 5 and y == 2) or
        (x == 6 and y == 1)
    end

    return false

end


function BATTLE_STAGE_DEFS.random()
   return gauntlet_data.math.random_named("BATTLE_DATA", 0, BATTLE_STAGE_DEFS.NUM_STAGES)
end

return BATTLE_STAGE_DEFS