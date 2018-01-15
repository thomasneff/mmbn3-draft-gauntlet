local battle_data_generator = require "battle_data_generator"
local pointer_entry_generator = require "pointer_entry_generator"
local BACKGROUND_TYPE = require "defs.battle_background_defs"
local BATTLE_STAGE = require "defs.battle_stage_defs"

math.randomseed(os.time())

local new_battle_data = battle_data_generator.new_from_template()

print("Test new battle data")
print(new_battle_data)

local new_pointer_entry = pointer_entry_generator.new_from_template(0x12345678, BACKGROUND_TYPE.Undernet, BATTLE_STAGE.random())

print("Test new pointer entry")
print(new_pointer_entry)
