local gauntlet_data = require "gauntlet_data"

function randomchoice_key(t, name) --Selects a random item from a table
    local keys = {}
    for key, value in pairs(t) do
        keys[#keys+1] = key --Store keys in another table
    end
    
    index = keys[gauntlet_data.math.random_named(name, 1, #keys)]
    return index
end

return randomchoice_key