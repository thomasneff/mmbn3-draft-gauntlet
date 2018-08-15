local state_logic = require "state_logic"
local GENERIC_DEFS = require "defs.generic_defs"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_DEFS = require "defs.chip_defs"

-- Setup Callbacks for battle start to patch viruses

--savestate.loadslot(1)
--CHIP_DATA.dump_entity_name_addresses()
state_logic.initialize()

--For some reason, BizHawk with VBA-Next requires an address that's 4 bytes larger. Whatever.
event.onmemoryexecute(state_logic.on_enter_battle, GENERIC_DEFS.BATTLE_START_ADDRESS + 4)

event.onmemoryexecute(state_logic.on_battle_end, GENERIC_DEFS.END_OF_GAUNTLET_BATTLE_ADDRESS)
event.onmemoryexecute(state_logic.on_cust_screen_confirm, GENERIC_DEFS.CUST_SCREEN_CONFIRM_ADDRESS + 2)
event.onmemoryexecute(state_logic.on_chip_use, GENERIC_DEFS.CHIP_USE_ADDRESS + 2)
event.onmemoryexecute(state_logic.on_battle_phase_start, GENERIC_DEFS.BATTLE_PHASE_START_CHIP_IDS_ADDRESS + 2)

event.onexit(state_logic.on_exit)
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
