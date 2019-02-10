local deepcopy = require "deepcopy"
local CHIP_ID = require "defs.chip_id_defs"

local PA_DEFS = {}

-- This simply maps the "consecutive" PAs from chip -> PA ID. Since they all require 3 chips in consecutive order, this mapping is sufficient.
PA_DEFS[CHIP_ID.Cannon] = CHIP_ID.ZCanon1
PA_DEFS[CHIP_ID.HiCannon] = CHIP_ID.ZCanon2
PA_DEFS[CHIP_ID.MCannon] = CHIP_ID.ZCanon3
PA_DEFS[CHIP_ID.GutPunch] = CHIP_ID.ZPunch
PA_DEFS[CHIP_ID.GutStrgt] = CHIP_ID.ZStrght
PA_DEFS[CHIP_ID.VarSwrd] = CHIP_ID.ZVaribl
PA_DEFS[CHIP_ID.YoYo1] = CHIP_ID.ZYoyo1
PA_DEFS[CHIP_ID.YoYo2] = CHIP_ID.ZYoyo2
PA_DEFS[CHIP_ID.YoYo3] = CHIP_ID.ZYoyo3
PA_DEFS[CHIP_ID.StepSwrd] = CHIP_ID.ZStep1
PA_DEFS[CHIP_ID.StepCros] = CHIP_ID.ZStep2
PA_DEFS[CHIP_ID.Bubbler] = CHIP_ID.BubSprd
PA_DEFS[CHIP_ID.BubV] = CHIP_ID.BubSprd
PA_DEFS[CHIP_ID.BublSide] = CHIP_ID.BubSprd
PA_DEFS[CHIP_ID.HeatShot] = CHIP_ID.HeatSprd
PA_DEFS[CHIP_ID.HeatV] = CHIP_ID.HeatSprd
PA_DEFS[CHIP_ID.HeatSide] = CHIP_ID.HeatSprd
PA_DEFS[CHIP_ID.Spreader] = CHIP_ID.HBurst
PA_DEFS[CHIP_ID.TimeBomb] = CHIP_ID.TimeBomPlus
PA_DEFS[CHIP_ID.MetaGel1] = CHIP_ID.GelRain
PA_DEFS[CHIP_ID.MetaGel2] = CHIP_ID.GelRain
PA_DEFS[CHIP_ID.MetaGel3] = CHIP_ID.GelRain

return PA_DEFS