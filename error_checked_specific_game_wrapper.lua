local WRAPPER = {}

function WRAPPER.get_module(base_path, game_id, file_name)

    local full_path = base_path .. "." .. game_id .. "." .. file_name

    if game_id == nil then
        error("Error (" .. full_path .. ".lua): game_id is nil: " .. tostring(game_id))
    end

    local module = require (full_path)

    if module == nil then
        error("Error (" .. full_path .. ".lua): module is nil: " .. tostring(game_id))
    end

    return module
end




return WRAPPER