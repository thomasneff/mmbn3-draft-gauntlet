local gauntlet_data = require "gauntlet_data"
local ENTITIES = require "defs.entity_defs"
local ENTITY_TYPE = require "defs.entity_type_defs"
local deepcopy = require "deepcopy"
local NERF_VIRUS_GROUP = {

    NAME = "Cannonier",

}

local POSSIBLE_ENTITIES = {

    [1] = {
        "Mettaur",
        "Mettaur2",
        "Mettaur3",
        "MettaurOmega",
    },

    [2] = {
        "Canodumb",
        "Canodumb2",
        "Canodumb3",
        "CanodumbOmega",
    },


}



local HP_MULTIPLIER_PER_ROUND = {0.75, 0.75, 0.75, 0.75}

function NERF_VIRUS_GROUP:activate(current_round)
    self.old_hp_table = {}
    -- This is an example for how to modify virus data.
    --print("ACTIVATE NERF")
    for key, entity in pairs(self.entity_family) do
        self.old_hp_table[entity] = ENTITIES[entity].HP_BASE
        ENTITIES[entity].HP_BASE = math.floor(ENTITIES[entity].HP_BASE * HP_MULTIPLIER_PER_ROUND[current_round])
        --print("NEW HP: ", ENTITIES[entity].HP_BASE)
    end
    
end

function NERF_VIRUS_GROUP:deactivate(current_round)

    -- This is an example for how to unmodify virus data.
    --print("DEACTIVATE NERF")
    for key, entity in pairs(self.entity_family) do
        ENTITIES[entity].HP_BASE = self.old_hp_table[entity]
        --print("NEW HP: ", ENTITIES[entity].HP_BASE)
    end
    
end


function NERF_VIRUS_GROUP:get_description(current_round)
    
    return "Decreases HP of all " .. self.entity_family[1] .. "-Family \nViruses by " .. tostring((1.0 - HP_MULTIPLIER_PER_ROUND[current_round]) * 100) .. "%."


end


function NERF_VIRUS_GROUP.new()

    local new_buff = deepcopy(NERF_VIRUS_GROUP)
    new_buff.entity_family = POSSIBLE_ENTITIES[math.random(#POSSIBLE_ENTITIES)]
    new_buff.NAME = new_buff.entity_family[1] .. "-Master"
    new_buff.DESCRIPTION = new_buff:get_description(1)

    --print(new_buff)

    return deepcopy(new_buff)

end


return NERF_VIRUS_GROUP