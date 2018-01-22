local CHIP_NAME_UTILS = {}

-- This function replaces the special chars (such as Omega (\002) with their text representation.)
function CHIP_NAME_UTILS.replace_special_chars(string_param)

    local ret_string = ""
    for i = 1, #string_param do
        local c = string_param:sub(i,i)
        
        if      c == "\001" then ret_string = ret_string .. "Alpha"
        elseif  c == "\002" then ret_string = ret_string .. "Beta"
        elseif  c == "\003" then ret_string = ret_string .. "Omega"
        elseif  c == "\004" then ret_string = ret_string .. "Sigma"
        elseif  c == "\005" then ret_string = ret_string .. "V2"
        elseif  c == "\006" then ret_string = ret_string .. "V3"
        elseif  c == "\007" then ret_string = ret_string .. "V4"
        elseif  c == "\008" then ret_string = ret_string .. "V5"
        else                     ret_string = ret_string .. c end

    end

    return ret_string

end



return CHIP_NAME_UTILS

