local BUFF_GROUPS_DATA = require "buff_effects.buff_groups_data"
local deepcopy = require "deepcopy"
local randomchoice = require "randomchoice"
-- Similar to entity groups, we define which buffs can appear randomly.
-- TODO: possibly add specific probabilities?

local buff_generator = {}

function buff_generator.random_buffs_from_round(current_round, number_of_buffs)



    local buffs = {}
    local buff_group = BUFF_GROUPS_DATA.BUFF_GROUPS[current_round]
    --print("BUFFS: ", number_of_buffs)
    --print("BUFF GROUP: ", buff_group)
    for i = 1,number_of_buffs do

        buffs[i] = buff_group[math.random(#buff_group)].new()
        --print("BUFFS[i]", buffs[i])
    end

    return buffs
end

function buff_generator.initialize()

    BUFF_GROUPS_DATA.initialize()

end

function buff_generator.remove_buff(buff_name)
    local new_buff_groups = {}

    for key, buff_group in pairs(BUFF_GROUPS_DATA.BUFF_GROUPS) do
        new_buff_groups[key] = {}
        for key2, buff in pairs(buff_group) do

            if buff.NAME ~= buff_name then
                new_buff_groups[key][key2] = deepcopy(buff)
            end

        end

    end
    BUFF_GROUPS_DATA.BUFF_GROUPS = deepcopy(new_buff_groups)
end


function buff_generator.activate_buff(buff, current_round)

    buff:activate(current_round)

    if buff.REMOVE_AFTER_ACTIVATION == 1 then
        buff_generator.remove_buff(buff.NAME)
    end

end



return buff_generator
