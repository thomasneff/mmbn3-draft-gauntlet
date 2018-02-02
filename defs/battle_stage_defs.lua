local BATTLE_STAGE_DEFS = {}

-- Taken from http://forums.therockManexezone.com/topic/8831451/1/
BATTLE_STAGE_DEFS.NUM_STAGES = 128



function BATTLE_STAGE_DEFS.random()

    return math.random(0, BATTLE_STAGE_DEFS.NUM_STAGES)

end

return BATTLE_STAGE_DEFS