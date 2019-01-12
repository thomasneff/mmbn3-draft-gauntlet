local gauntlet_data = require "gauntlet_data"
local CHIP_DATA = require "defs.chip_data_defs"
local CHIP_ID = require "defs.chip_id_defs"
local CHIP_CODE = require "defs.chip_code_defs"
local CHIP_CODE_REVERSE = require "defs.chip_code_reverse_defs"
local CHIP_NAMES = require "defs.chip_name_defs"
local CHIP_NAME_ADDRESSES = require "defs.chip_name_address_defs"
local CHIP_NAME_UTILS = require "defs.chip_name_utils"
local mmbn3_utils = require "mmbn3_utils"
local CHIP = require "defs.chip_defs"
local ELEMENT_DEFS = require "defs.entity_element_defs"
local GENERIC_DEFS = require "defs.generic_defs"
local randomchoice = require "randomchoice"

local PROGRAMADVANCE = {

    NAME = "PROGRAMADVANCE",

}

local program_advances_1 = 
{
    ZCANON1 = {
        NAME = "Zeta Cannon",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.Cannon,
            CHIP_ID.Cannon,
            CHIP_ID.Cannon
        }
    },

    ZPUNCH = {
        NAME = "Zeta Punch",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.GutPunch,
            CHIP_ID.GutPunch,
            CHIP_ID.GutPunch
        }
    },

    ZYOYO1 = {
        NAME = "Zeta Yo-Yo 1",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.YoYo1,
            CHIP_ID.YoYo1,
            CHIP_ID.YoYo1
        }
    },

    ZSTEP1 = {
        NAME = "Zeta Step Sword",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.StepSwrd,
            CHIP_ID.StepSwrd,
            CHIP_ID.StepSwrd
        }
    },

    BUBSPRD = {
        NAME = "Bubble Spreader",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.Bubbler,
            CHIP_ID.Bubbler,
            CHIP_ID.Bubbler
        }
    },

    HEATSPRD = {
        NAME = "Heat Spreader",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.HeatShot,
            CHIP_ID.HeatShot,
            CHIP_ID.HeatShot
        }
    },

    HBURST = {
        NAME = "Hyper Burst",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.Spreader,
            CHIP_ID.Spreader,
            CHIP_ID.Spreader
        }
    },

    LIFESWRD = {
        NAME = "Life Sword",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.Sword,
            CHIP_ID.WideSwrd,
            CHIP_ID.LongSwrd
        }
    },

}

local program_advances_2 = 
{
    ZCANON2 = {
        NAME = "Zeta Hi-Cannon",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.HiCannon,
            CHIP_ID.HiCannon,
            CHIP_ID.HiCannon
        }
    },

    ZSTRGT = {
        NAME = "Zeta Straight",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.GutStrgt,
            CHIP_ID.GutStrgt,
            CHIP_ID.GutStrgt
        }
    },

    ZYOYO2 = {
        NAME = "Zeta Yo-Yo 2",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.YoYo2,
            CHIP_ID.YoYo2,
            CHIP_ID.YoYo2
        }
    },

    ZSTEP1 = {
        NAME = "Zeta Step Sword",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.StepSwrd,
            CHIP_ID.StepSwrd,
            CHIP_ID.StepSwrd
        }
    },

    BUBSPRD = {
        NAME = "Bubble Spreader",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.BubV,
            CHIP_ID.BubV,
            CHIP_ID.BubV
        }
    },

    HEATSPRD = {
        NAME = "Heat Spreader",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.HeatV,
            CHIP_ID.HeatV,
            CHIP_ID.HeatV
        }
    },

    GUTSSHOOT = {
        NAME = "Guts Shoot",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.Guard,
            CHIP_ID.DashAtk,
            CHIP_ID.GutsMan,
        }
    },

    ELEMSWRD = {
        NAME = "Element Sword",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.FireSwrd,
            CHIP_ID.AquaSwrd,
            CHIP_ID.ElecSwrd,
            CHIP_ID.BambSwrd
        }
    },

    LIFESWRD = {
        NAME = "Life Sword",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.Sword,
            CHIP_ID.WideSwrd,
            CHIP_ID.LongSwrd
        }
    },

    MOMQUAKE = {
        NAME = "Mothers Quake",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.RockCube,
            CHIP_ID.RockCube,
            CHIP_ID.GodStone
        }
    },

    GELRAIN = {
        NAME = "Gel Rain",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.MetaGel1,
            CHIP_ID.MetaGel1,
            CHIP_ID.MetaGel1
        }
    },
}

local program_advances_3 = 
{
    ZCANON3 = {
        NAME = "Zeta M-Cannon",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.MCannon,
            CHIP_ID.MCannon,
            CHIP_ID.MCannon
        }
    },

    ZIMPACT = {
        NAME = "Zeta Impact",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.GutImpct,
            CHIP_ID.GutImpct,
            CHIP_ID.GutImpct
        }
    },

    ZYOYO3 = {
        NAME = "Zeta Yo-Yo 3",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.YoYo3,
            CHIP_ID.YoYo3,
            CHIP_ID.YoYo3
        }
    },

    ZSTEP2 = {
        NAME = "Zeta Step Cross",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.StepCros,
            CHIP_ID.StepCros,
            CHIP_ID.StepCros
        }
    },

    BUBSPRD = {
        NAME = "Bubble Spreader",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.BublSide,
            CHIP_ID.BublSide,
            CHIP_ID.BublSide
        }
    },

    HEATSPRD = {
        NAME = "Heat Spreader",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.HeatSide,
            CHIP_ID.HeatSide,
            CHIP_ID.HeatSide
        }
    },

    GUTSSHOOT = {
        NAME = "Guts Shoot",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.Guard,
            CHIP_ID.DashAtk,
            CHIP_ID.GutsManV3,
        }
    },

    ELEMSWRD = {
        NAME = "Element Sword",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.FireSwrd,
            CHIP_ID.AquaSwrd,
            CHIP_ID.ElecSwrd,
            CHIP_ID.BambSwrd
        }
    },

    EVILCUT = {
        NAME = "Evil Cut",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.StepSwrd,
            CHIP_ID.HeroSwrd,
            CHIP_ID.StepCros
        }
    },

    HYPERRAT = {
        NAME = "Hyper Ratton",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.Ratton1,
            CHIP_ID.Ratton2,
            CHIP_ID.Ratton3
        }
    },

    TIMEBOMPLUS = {
        NAME = "Time Bomb +",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.TimeBomb,
            CHIP_ID.TimeBomb,
            CHIP_ID.TimeBomb
        }
    },

    GELRAIN = {
        NAME = "Gel Rain",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.MetaGel2,
            CHIP_ID.MetaGel2,
            CHIP_ID.MetaGel2
        }
    },

    EVERCRSE = {
        NAME = "Ever Curse",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.CrsShld1,
            CHIP_ID.CrsShld2,
            CHIP_ID.CrsShld3
        }
    },

    MOMQUAKE = {
        NAME = "Mothers Quake",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.RockCube,
            CHIP_ID.RockCube,
            CHIP_ID.GodStone
        }
    },

    BARRIER500 = {
        NAME = "500 Barrier",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.Barrier,
            CHIP_ID.Barr100,
            CHIP_ID.Barr200
        }
    },

    BIGHEART = {
        NAME = "Big Heart",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.HolyPanl,
            CHIP_ID.Recov300,
            CHIP_ID.RollV2
        }
    },


}

local program_advances_4 = 
{

    ZSTEP2 = {
        NAME = "Zeta Step Cross",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.StepCros,
            CHIP_ID.StepCros,
            CHIP_ID.StepCros
        }
    },

    GUTSSHOOT = {
        NAME = "Guts Shoot",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.Guard,
            CHIP_ID.DashAtk,
            CHIP_ID.GutsManV4,
        }
    },

    ELEMSWRD = {
        NAME = "Element Sword",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.FireSwrd,
            CHIP_ID.AquaSwrd,
            CHIP_ID.ElecSwrd,
            CHIP_ID.BambSwrd
        }
    },

    EVILCUT = {
        NAME = "Evil Cut",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.StepSwrd,
            CHIP_ID.HeroSwrd,
            CHIP_ID.StepCros
        }
    },

    TIMEBOMPLUS = {
        NAME = "Time Bomb +",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.TimeBomb,
            CHIP_ID.TimeBomb,
            CHIP_ID.TimeBomb
        }
    },

    GELRAIN = {
        NAME = "Gel Rain",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.MetaGel3,
            CHIP_ID.MetaGel3,
            CHIP_ID.MetaGel3
        }
    },

    BARRIER500 = {
        NAME = "500 Barrier",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.Barrier,
            CHIP_ID.Barr100,
            CHIP_ID.Barr200
        }
    },

    BIGHEART = {
        NAME = "Big Heart",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.HolyPanl,
            CHIP_ID.Recov300,
            CHIP_ID.RollV2
        }
    },

    ZVARIBL = {
        NAME = "Zeta VarSword",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.VarSwrd,
            CHIP_ID.VarSwrd,
            CHIP_ID.VarSwrd
        }
    },

    POISPHAR = {
        NAME = "Poison Pharaoh",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.PoisMask,
            CHIP_ID.PoisFace,
            CHIP_ID.Anubis
        }
    },

    BODYGRD = {
        NAME = "Body Guard",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.AntiDmg,
            CHIP_ID.AntiNavi,
            CHIP_ID.Muramasa
        }
    },

    DEUXHERO = {
        NAME = "Deux Hero",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.CustSwrd,
            CHIP_ID.VarSwrd,
            CHIP_ID.ProtoManV4
        }
    },
}

local program_advances_5 = 
{

    GELRAIN = {
        NAME = "Gel Rain",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.MetaGel3,
            CHIP_ID.MetaGel3,
            CHIP_ID.MetaGel3
        }
    },

    BIGHEART = {
        NAME = "Big Heart",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.HolyPanl,
            CHIP_ID.Recov300,
            CHIP_ID.RollV3
        }
    },

    ZVARIBL = {
        NAME = "Zeta VarSword",
        CONSECUTIVE_CODES = 1,
        CHIPS = 
        {
            CHIP_ID.VarSwrd,
            CHIP_ID.VarSwrd,
            CHIP_ID.VarSwrd
        }
    },

    POISPHAR = {
        NAME = "Poison Pharaoh",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.PoisMask,
            CHIP_ID.PoisFace,
            CHIP_ID.Anubis
        }
    },

    BODYGRD = {
        NAME = "Body Guard",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.AntiDmg,
            CHIP_ID.AntiNavi,
            CHIP_ID.Muramasa
        }
    },

    DEUXHERO = {
        NAME = "Double Hero",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.Slasher,
            CHIP_ID.CustSwrd,
            CHIP_ID.VarSwrd,
            CHIP_ID.ProtoManV5
        }
    },

    PRIXPOWR = {
        NAME = "Grand Prix Power",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.Team1,
            CHIP_ID.Team2,
            CHIP_ID.KingManV5
        }
    },

    MSTRSTYL = {
        NAME = "Master Style",
        CONSECUTIVE_CODES = 0,
        CHIPS = 
        {
            CHIP_ID.Salamndr,
            CHIP_ID.Fountain,
            CHIP_ID.Bolt,
            CHIP_ID.GaiaBlad
        }
    },
}

local PROGRAM_ADVANCES_ROUNDS = {
    program_advances_1,
    program_advances_2,
    program_advances_3,
    program_advances_4,
    program_advances_5
}

function shuffle(tbl)
    size = #tbl
    for i = size, 1, -1 do
      local rand = gauntlet_data.math.random_buff_activation(size)
      tbl[i], tbl[rand] = tbl[rand], tbl[i]
    end
    return tbl
end

function PROGRAMADVANCE:activate(current_round)

    -- Add Chips from P.A. to folder.
    self.old_folder = deepcopy(gauntlet_data.current_folder)

    local shuffle_indices = {}

    for i = 1,#gauntlet_data.current_folder do
        shuffle_indices[i] = i
    end

    -- For consecutive P.A.s, roll the random starting code
    local random_code = gauntlet_data.math.random_buff_activation(CHIP_CODE.A, CHIP_CODE.Z - #(self.CHOSEN_PA.CHIPS) + 1)

    if self.CHOSEN_PA.CONSECUTIVE_CODES == 0 then
        -- For non-consecutive P.A.s, roll the common code
        random_code = randomchoice(CHIP_CODE, "BUFF_ACTIVATION")
    end 

    shuffle_indices = shuffle(deepcopy(shuffle_indices))
    self.replaced_chips_string = ""
    for chip_idx = 1,#(self.CHOSEN_PA.CHIPS) do

        if chip_idx ~= #(self.CHOSEN_PA.CHIPS) then
            self.replaced_chips_string = self.replaced_chips_string .. gauntlet_data.current_folder[shuffle_indices[chip_idx]].PRINT_NAME .. ", "
        else
            self.replaced_chips_string = self.replaced_chips_string .. gauntlet_data.current_folder[shuffle_indices[chip_idx]].PRINT_NAME
        end
        gauntlet_data.current_folder[shuffle_indices[chip_idx]] = CHIP.new_chip_with_code(self.CHOSEN_PA.CHIPS[chip_idx], random_code)

        if self.CHOSEN_PA.CONSECUTIVE_CODES == 1 then
            random_code = random_code + 1
        end

    end

    --local string_with_special_chars = CHIP_NAME[chip.ID] .. " " .. CHIP_CODE_REVERSE[chip.CODE]

    self.current_round = current_round
end

function PROGRAMADVANCE:deactivate(current_round)
    gauntlet_data.current_folder = deepcopy(self.old_folder)
end


function PROGRAMADVANCE:get_description(current_round)

    local ret = "Add "

    for chip_idx = 1,#(self.CHOSEN_PA.CHIPS) do

        local string_with_special_chars = CHIP_NAMES[self.CHOSEN_PA.CHIPS[chip_idx]]

        string_with_special_chars = CHIP_NAME_UTILS.replace_special_chars(string_with_special_chars)

        ret = ret .. string_with_special_chars

        if chip_idx < #(self.CHOSEN_PA.CHIPS) then
            ret = ret .. ", "
        end


    end

    if self.CHOSEN_PA.CONSECUTIVE_CODES == 1 then
        ret = ret .. "\nto your current Folder! (Random ascending codes!)"
    else
        ret = ret .. "\nto your current Folder! (Random same code!)"
    end


    return ret

    
end


function PROGRAMADVANCE:get_brief_description()
    return self.NAME .. ": Add P.A. Chips, replaced ->\n  " .. self.replaced_chips_string
end

function PROGRAMADVANCE.new(current_round)

    local new_buff = deepcopy(PROGRAMADVANCE)
    -- Roll random program advance for current round
    new_buff.CHOSEN_PA = deepcopy(randomchoice(deepcopy(PROGRAM_ADVANCES_ROUNDS[current_round]), "BUFF_ACTIVATION"))
    new_buff.NAME = new_buff.CHOSEN_PA.NAME
    new_buff.DESCRIPTION = new_buff:get_description(1)

    return deepcopy(new_buff)

end


return PROGRAMADVANCE