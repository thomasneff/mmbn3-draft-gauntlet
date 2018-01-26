function randomchoice_key(t) --Selects a random item from a table
    local keys = {}
    for key, value in pairs(t) do
        keys[#keys+1] = key --Store keys in another table
    end
    
    index = keys[math.random(1, #keys)]
    return index
end

return randomchoice_key