local state_logic = require "state_logic"
local GENERIC_DEFS = require "defs.generic_defs"
--local CHIP_DATA = require "defs.chip_data_defs"


-- Setup Callbacks for battle start to patch viruses

--savestate.loadslot(1)
--CHIP_DATA.dump_entity_name_addresses()
state_logic.initialize()

--For some reason, BizHawk with VBA-Next requires an address that's 4 bytes larger. Whatever.
event.onmemoryexecute(state_logic.on_enter_battle, GENERIC_DEFS.BATTLE_START_ADDRESS + 4)





while 1 do


    state_logic.main_loop()

    emu.yield()

    
end
