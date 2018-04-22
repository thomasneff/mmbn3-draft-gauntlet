local randomchoice = require "randomchoice"

-- NOTHING = 0x00
local STYLE_DEFS = {
    ELEC_GUTS   = 0x09, -- mod 4 == 1
    HEAT_GUTS   = 0x0A, -- mod 4 == 2
    AQUA_GUTS   = 0x0B, -- mod 4 == 3
    WOOD_GUTS   = 0x0C, -- mod 4 == 0
    ELEC_CUST   = 0x11,
    HEAT_CUST   = 0x12,
    AQUA_CUST   = 0x13,
    WOOD_CUST   = 0x14,
    ELEC_TEAM = 0x19, 
    HEAT_TEAM = 0x1A, 
    AQUA_TEAM = 0x1B, 
    WOOD_TEAM = 0x1C, 
    ELEC_SHIELD = 0x21,
    HEAT_SHIELD = 0x22,
    AQUA_SHIELD = 0x23,
    WOOD_SHIELD = 0x24,
    ELEC_GROUND = 0x29,
    HEAT_GROUND = 0x2A,
    AQUA_GROUND = 0x2B,
    WOOD_GROUND = 0x2C,
    ELEC_SHADOW = 0x31, 
    HEAT_SHADOW = 0x32, 
    AQUA_SHADOW = 0x33, 
    WOOD_SHADOW = 0x34, 
    ELEC_BUG    = 0x39,
    HEAT_BUG    = 0x3A,
    AQUA_BUG    = 0x3B,
    WOOD_BUG    = 0x3C,
}

local STYLE_NAMES = {
    [0x00] = "Normal",
    [STYLE_DEFS.ELEC_GUTS] = "ElecGuts",
    [STYLE_DEFS.ELEC_CUST] = "ElecCust",
    [STYLE_DEFS.ELEC_SHIELD] = "ElecShield",
    [STYLE_DEFS.ELEC_GROUND] = "ElecGround",
    [STYLE_DEFS.ELEC_SHADOW] = "ElecShadow",
    [STYLE_DEFS.ELEC_BUG] = "ElecBug",
    [STYLE_DEFS.ELEC_TEAM] = "ElecTeam",
    [STYLE_DEFS.HEAT_BUG] = "HeatBug",
    [STYLE_DEFS.HEAT_GUTS] = "HeatGuts",
    [STYLE_DEFS.HEAT_CUST] = "HeatCust",
    [STYLE_DEFS.HEAT_SHIELD] = "HeatShield",
    [STYLE_DEFS.HEAT_GROUND] = "HeatGround",
    [STYLE_DEFS.HEAT_SHADOW] = "HeatShadow",
    [STYLE_DEFS.HEAT_TEAM] = "HeatTeam",
    [STYLE_DEFS.WOOD_BUG] = "WoodBug",
    [STYLE_DEFS.WOOD_GUTS] = "WoodGuts",
    [STYLE_DEFS.WOOD_CUST] = "WoodCust",
    [STYLE_DEFS.WOOD_SHIELD] = "WoodShield",
    [STYLE_DEFS.WOOD_GROUND] = "WoodGround",
    [STYLE_DEFS.WOOD_SHADOW] = "WoodShadow",
    [STYLE_DEFS.WOOD_TEAM] = "WoodTeam",
    [STYLE_DEFS.AQUA_GUTS] = "AquaGuts",
    [STYLE_DEFS.AQUA_CUST] = "AquaCust",
    [STYLE_DEFS.AQUA_SHIELD] = "AquaShield",
    [STYLE_DEFS.AQUA_GROUND] = "AquaGround",
    [STYLE_DEFS.AQUA_SHADOW] = "AquaShadow",
    [STYLE_DEFS.AQUA_BUG] = "AquaBug",
    [STYLE_DEFS.AQUA_TEAM] = "AquaTeam",


}

local STYLE_DEFS_GENERATOR = {}


function STYLE_DEFS_GENERATOR.random_style()
    local new_style = {}
    new_style.STYLE = randomchoice(STYLE_DEFS)
    new_style.NAME = STYLE_NAMES[new_style.STYLE]
    return new_style

end



return STYLE_DEFS_GENERATOR