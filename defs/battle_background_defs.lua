
-- Taken from http://forums.therockmanexezone.com/topic/8831451/1/
local NUMBER_OF_BACKGROUNDS = 0x1D
local BACKGROUND_TYPE = {
    ACDC_Area = 0x00,
    ACDC_Square = 0x01,
    Lan_HP = 0x02,
    Yai_HP = 0x03,
    Principal_PC = 0x04,
    Zoo_Comp = 0x05,
    Hospital_Comp = 0x06,
    Tamako_HP = 0x07,
    Dex_HP = 0x08,
    Hospital_Comp_2 = 0x09,
    Generic_Comp = 0x0A,
    Virus_Breeder = 0x0B,
    Virus_Breeder_2 = 0x0C,
    SciLab_Area = 0x0D,
    SciLab_Area_2 = 0x0E,
    Mayl_HP = 0x0F,
    Undernet = 0x10,
    WWW_Comp = 0x11,
    WWW_Comp_2 = 0x12,
    WWW_Comp_3 = 0x13,
    WWW_Comp_4 = 0x14,
    Alpha = 0x15,
    Secret_Area = 0x16,
    Hades = 0x17,
    Yoka_Area = 0x18,
    Beach_Area = 0x19,
    Zoo_Comp_2 = 0x1A,
    Zoo_Comp_3 = 0x1B,
    Zoo_Comp_4 = 0x1C,
    Alpha_Battle = 0x1D
}


function BACKGROUND_TYPE.random()

    return math.random(0, NUMBER_OF_BACKGROUNDS)
end


return BACKGROUND_TYPE