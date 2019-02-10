local game_name = gameinfo.getromname()

-- These are global.
GAME_IDS = {
    MMBN3_BLUE_US = "mmbn3_blue_us",
    MMBN3_WHITE_US = "mmbn3_white_us",
    MMBN6_FALZAR_US = "mmbn6_falzar_us"
}

GAME_ID = nil

if string.find(game_name, "3") and string.find(game_name, "Blue") then
    GAME_ID = GAME_IDS.MMBN3_BLUE_US
    print("Detected Game: MMBN3_BLUE_US")
elseif string.find(game_name, "3") and string.find(game_name, "blue") then
    GAME_ID = GAME_IDS.MMBN3_BLUE_US
    print("Detected Game: MMBN3_BLUE_US")
elseif string.find(game_name, "6") and string.find(game_name, "Falzar") then
    GAME_ID = GAME_IDS.MMBN6_FALZAR_US
    print("Detected Game: MMBN6_FALZAR_US")
else 
    error("Error (gauntlet.lua): Unknown game.")
end


local state_logic = require "state_logic"

-- Setup Callbacks for battle start to patch viruses


--savestate.loadslot(1)
--CHIP_DATA.dump_entity_name_addresses()
state_logic.initialize()



--For some reason, BizHawk with VBA-Next requires an address that's 4 bytes larger. Whatever.

-- event.onexit(state_logic.on_exit)
-- Dump Entity drop table templates.


--local ENTITIES = require "defs.entity_defs"
--local ENTITY_TYPE = require "defs.entity_type_defs"
-- "Sorted by key" table iterator 
-- Extracted from http://www.lua.org/pil/19.3.html
 
--function pairsKeySorted(t, f)
--    local a = {}    
--    for n in pairs(t) do
--        table.insert(a, n)
--    end    
--    table.sort(a, f)
 
--    local i = 0      -- iterator variable
--    local iter = function ()   -- iterator function
--        i = i + 1
--        if a[i] == nil then
--           return nil
--        else
--            return a[i], t[a[i]]
--        end
--    end
 
--    return iter
--end

--function getKeysSortedByValue(tbl, sortFunction)
--    local keys = {}
--    for key in pairs(tbl) do
--      table.insert(keys, key)
--    end
  
--    table.sort(keys, function(a, b)
--      return sortFunction(tbl[a], tbl[b])
--    end)
  
--    return keys
--end

--local testfile = io.open("entity_drops.txt", "w")
--DROP_COMMON_CUMULATIVE_CHANCE = 70,
--    DROP_RARE_CUMULATIVE_CHANCE = 90,
--    DROP_SUPER_RARE_CUMULATIVE_CHANCE = 97,
--    DROP_ULTRA_RARE_CUMULATIVE_CHANCE = 100,
--[[local sorted_entity_types = getKeysSortedByValue(ENTITY_TYPE, function(a, b) return a < b end)
for _, key in pairs(sorted_entity_types) do



    testfile:write("-------------------------------------------------------------------------------\n")
    testfile:write("ENTITIES." .. key .. ".DROPTABLE =\n")
    testfile:write("{\n")
    testfile:write("  [1] = {\n")
    testfile:write("    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_COMMON_CUMULATIVE_CHANCE,\n")
    testfile:write("    CHIP_GEN = CHIP_DEFS.new_random_chip_with_random_code_generator()\n")
    testfile:write("  },\n")
    testfile:write("  [2] = {\n")
    testfile:write("    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_RARE_CUMULATIVE_CHANCE,\n")
    testfile:write("    CHIP_GEN = CHIP_DEFS.new_random_chip_with_random_code_generator()\n")
    testfile:write("  },\n")
    testfile:write("  [3] = {\n")
    testfile:write("    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_SUPER_RARE_CUMULATIVE_CHANCE,\n")
    testfile:write("    CHIP_GEN = CHIP_DEFS.new_random_chip_with_random_code_generator()\n")
    testfile:write("  },\n")
    testfile:write("  [4] = {\n")
    testfile:write("    CUMULATIVE_RARITY = GAUNTLET_DEFS.DROP_ULTRA_RARE_CUMULATIVE_CHANCE,\n")
    testfile:write("    CHIP_GEN = CHIP_DEFS.new_random_chip_with_random_code_generator()\n")
    testfile:write("  }\n")
    testfile:write("}\n")
    testfile:write("-------------------------------------------------------------------------------\n")
    testfile:write("\n")
 
end 

testfile:close()--]]




while 1 do


    state_logic.main_loop()

    emu.yield()

    
end
