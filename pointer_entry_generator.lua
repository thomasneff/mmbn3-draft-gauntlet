local BACKGROUND_TYPE = require "defs.battle_background_defs"
local BATTLE_MODE = require "defs.battle_mode_defs"
local FOLDER_SHUFFLE = require "defs.folder_shuffle_defs"
local BATTLE_STAGE_DEFS = require "defs.battle_stage_defs"
-- Can't change music yet unfortunately without more reverse engineering.

-- TODO_REFACTOR: we can add stuff to this template and handle the specific changes in *_utils, I guess
local pointer_entry_template = {
  -- Important - this address starts at the first entity (MegaMan, typically)
  ADDRESS = 0x0801AA60,

  UNID_BYTE_1 = 0x00, -- freezes game if != 0, possibly "Optional Folder Pointer" (http://forums.therockManexezone.com/topic/8831451/1/)
  UNID_BYTE_2 = 0x00, -- freezes game if != 0
  UNID_BYTE_3 = 0x00, -- freezes game if != 0
  UNID_BYTE_4 = 0x00, -- freezes game if != 0
  BACKGROUND_TYPE = BACKGROUND_TYPE.Undernet, -- Changes Background
  BATTLE_MODE = BATTLE_MODE.Sequential1, -- 0x05 for Sequential Battle
  FOLDER_SHUFFLE = FOLDER_SHUFFLE.Randomized, -- controls if folder is in order or randomized
  ALLOW_RUNNING = 0x01, -- if 0x01, can not run away from battle, otherwise can -> game over
  BATTLE_STAGE = 0x00, -- one out of 129 stages. I will not define them explicitly
  UNID_BYTE_8 = 0x00,
  UNID_BYTE_9 = 0xFF,
  UNID_BYTE_10 = 0xFF,
 
}

local pointer_entry_generator = {}

function pointer_entry_generator.new_from_template(battle_address, background_type, battle_stage)

    local new_pointer_entry = deepcopy(pointer_entry_template)
    new_pointer_entry.ADDRESS = battle_address
    new_pointer_entry.BACKGROUND_TYPE = background_type
    new_pointer_entry.BATTLE_STAGE = battle_stage

    return new_pointer_entry

end

return pointer_entry_generator