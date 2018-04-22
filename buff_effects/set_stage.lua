local gauntlet_data = require "gauntlet_data"
local deepcopy = require "deepcopy"
local randomchoice = require "randomchoice"

local SET_STAGE = {

    NAME = "Tank",

}

local STAGES = {

    Holy = 0x19,
    Metal = 0x35,
    Grass = 0x36,
    Ice = 0x37,
    Magma = 0x38,
    Sand = 0x3A
}

local STAGE_NAMES = {

    [STAGES.Holy] = "Holy",
    [STAGES.Metal] = "Metal",
    [STAGES.Grass] = "Grass",
    [STAGES.Ice] = "Ice",
    [STAGES.Magma] = "Magma",
    [STAGES.Sand] = "Sand",

}


function SET_STAGE:activate(current_round)

    self.old_stage = gauntlet_data.stage
    gauntlet_data.stage = self.STAGE

end


function SET_STAGE:deactivate(current_round)
    gauntlet_data.stage = self.old_stage
end

function SET_STAGE:get_description(current_round)

    return "Start every Battle with " .. self.NAME .. "!\n(Only works on normal panels.)"


end

function SET_STAGE:get_brief_description()
    return self.NAME .. ": Normal panels -> " .. STAGE_NAMES[self.STAGE] .. "!"
end

function SET_STAGE.new()


    local new_set_stage = deepcopy(SET_STAGE)
    new_set_stage.STAGE = randomchoice(STAGES)
    new_set_stage.NAME = STAGE_NAMES[new_set_stage.STAGE] .. "-Stage"
    new_set_stage.DESCRIPTION = new_set_stage:get_description(1)

    return deepcopy(new_set_stage)

end


return SET_STAGE