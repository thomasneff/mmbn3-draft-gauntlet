local bizhawk_io_wrapper = {}
-- This is a wrapper for BizHawk with VBA-Next that automatically selects the correct memory domain.
function bizhawk_io_wrapper.writebyte(address, value)
    --print("DOMAINS")
    --print(memory.getmemorydomainlist())

    if address == GENERIC_DEFS_UNDEFINED_ADDRESS or value == GENERIC_DEFS_UNDEFINED_VALUE then
        -- Return. This can be used to disable features that are not implemented yet.
        print("writebyte: address or value is undefined: " .. tostring(address) .. ", " .. tostring(value))
        return
    end

    if address == nil or value == nil then
        error("writebyte: address or value equals nil: " .. tostring(address) .. ", " .. tostring(value))
        return
    end

    if address >= 0x08000000 then
        address = address - 0x08000000
        memory.writebyte(address, value, "ROM")
    elseif address >= 0x02000000 then
        address = address - 0x02000000
        memory.writebyte(address, value, "EWRAM")
    end
    --print("Written " .. bizstring.hex(value) .. " to address " .. bizstring.hex(address))
    
    --print("Read-Check " .. bizstring.hex(memory.readbyte(address,"ROM")) .. " from address " .. bizstring.hex(address))
end

-- This is a wrapper for BizHawk with VBA-Next that automatically selects the correct memory domain.
function bizhawk_io_wrapper.readbyte(address)

    if address == GENERIC_DEFS_UNDEFINED_ADDRESS then
        -- Return. This can be used to disable features that are not implemented yet.
        print("readbyte: address is undefined: " .. tostring(address))
        return
    end

    if address == nil then
        print("readbyte: address equals nil: " .. tostring(address))
        return
    end

    if address >= 0x08000000 then
        address = address - 0x08000000
        return memory.readbyte(address, "ROM")
    elseif address >= 0x02000000 then
        address = address - 0x02000000
        return memory.readbyte(address, "EWRAM")
    end
end

function bizhawk_io_wrapper.readword(address)

    if address == GENERIC_DEFS_UNDEFINED_ADDRESS then
        -- Return. This can be used to disable features that are not implemented yet.
        print("readword: address is undefined: " .. tostring(address))
        return
    end

    if address == nil then
        print("readword: address equals nil: " .. tostring(address))
        return
    end

    if address >= 0x08000000 then
        address = address - 0x08000000
        return memory.read_u16_le(address, "ROM")
    elseif address >= 0x02000000 then
        address = address - 0x02000000
        return memory.read_u16_le(address, "EWRAM")
    end
end

-- This is a wrapper for BizHawk with VBA-Next that automatically selects the correct memory domain.
function bizhawk_io_wrapper.writeword(address, value)

    if address == GENERIC_DEFS_UNDEFINED_ADDRESS or value == GENERIC_DEFS_UNDEFINED_VALUE then
        -- Return. This can be used to disable features that are not implemented yet.
        print("writeword: address or value is undefined: " .. tostring(address) .. ", " .. tostring(value))
        return
    end

    if address == nil or value == nil then
        error("writeword: address or value equals nil: " .. tostring(address) .. ", " .. tostring(value))
        return
    end

    if address >= 0x08000000 then
        address = address - 0x08000000
        memory.write_u16_le(address, value, "ROM")
    elseif address >= 0x02000000 then
        address = address - 0x02000000
        memory.write_u16_le(address, value, "EWRAM")    
    end
end

-- This is a wrapper for BizHawk with VBA-Next that automatically selects the correct memory domain.
function bizhawk_io_wrapper.writedword(address, value)

    if address == GENERIC_DEFS_UNDEFINED_ADDRESS or value == GENERIC_DEFS_UNDEFINED_VALUE then
        -- Return. This can be used to disable features that are not implemented yet.
        print("writedword: address or value is undefined: " .. tostring(address) .. ", " .. tostring(value))
        return
    end

    if address == nil or value == nil then
        error("writedword: address or value equals nil: " .. tostring(address) .. ", " .. tostring(value))
        return
    end

    if address >= 0x08000000 then
        address = address - 0x08000000
        memory.write_u32_le(address, value, "ROM")
    elseif address >= 0x02000000 then
        address = address - 0x02000000
        memory.write_u32_le(address, value, "EWRAM")
    end

end


return bizhawk_io_wrapper