-- This is used to find the address of an entity name. 
-- Needs testing to see if the game uses hardcoded offsets or simply looks up all end-of-strings until it finds the one with correct index.
local BASE_OFFSET_NAME_DATA = 0x087114E4 -- This is the start of the text for "MegaMan"
local BASE_OFFSET_NAME_DATA_FIRST_ENEMY = 0x087114EC -- This is the start of the text for "Mettaur"
local TEXT_TABLE = require "defs.text_table_defs"
local ENTITY_TYPE = require "defs.entity_type_defs"

local ENTITY_NAME_ADDRESS_TRANSLATOR = {
MegaMan = 0x87114e4 ,
Mettaur = 0x87114ec ,
Mettaur2 = 0x87114f4 ,
Mettaur3 = 0x87114fd ,
MettaurOmega = 0x8711506 ,
Canodumb = 0x871150f ,
Canodumb2 = 0x8711518 ,
Canodumb3 = 0x8711522 ,
CanodumbOmega = 0x871152c ,
Fishy = 0x8711535 ,
Fishy2 = 0x871153b ,
Fishy3 = 0x8711542 ,
FishyOmega = 0x8711549 ,
Swordy = 0x8711550 ,
Swordy2 = 0x8711557 ,
Swordy3 = 0x871155f ,
SwordyOmega = 0x8711567 ,
Ratty = 0x871156f ,
Ratty2 = 0x8711575 ,
Ratty3 = 0x871157c ,
RattyOmega = 0x8711583 ,
HardHead = 0x871158a ,
ColdHead = 0x8711593 ,
HotHead = 0x871159c ,
HardHeadOmega = 0x87115a4 ,
Jelly = 0x87115ad ,
HeatJelly = 0x87115b3 ,
EarthJelly = 0x87115bd ,
JellyOmega = 0x87115c7 ,
Shrimpy = 0x87115ce ,
Shrimpy2 = 0x87115d6 ,
Shrimpy3 = 0x87115df ,
ShrimpyOmega = 0x87115e8 ,
Spikey = 0x87115f1 ,
Spikey2 = 0x87115f8 ,
Spikey3 = 0x8711600 ,
SpikeyOmega = 0x8711608 ,
Bunny = 0x8711610 ,
TuffBunny = 0x8711616 ,
MegaBunny = 0x8711620 ,
BunnySP = 0x871162a ,
WindBox = 0x8711631 ,
VacuumFan = 0x8711639 ,
StormBox = 0x8711643 ,
WindBoxOmega = 0x871164c ,
PuffBall = 0x8711652 ,
PoofBall = 0x871165b ,
GoofBall = 0x8711664 ,
PuffBallOmega = 0x871166d ,
Mushy = 0x8711677 ,
Mashy = 0x871167d ,
Moshy = 0x8711683 ,
MushyOmega = 0x8711689 ,
Dominerd = 0x8711690 ,
Dominerd2 = 0x8711699 ,
Dominerd3 = 0x87116a3 ,
DominerdOmega = 0x87116ad ,
Yort = 0x87116b7 ,
Yurt = 0x87116bc ,
Yart = 0x87116c1 ,
YortOmega = 0x87116c6 ,
Shadow = 0x87116cc ,
RedDevil = 0x87116d3 ,
BlueDemon = 0x87116dc ,
ShadowOmega = 0x87116e6 ,
BrushMan = 0x87116ee ,
BrushMan2 = 0x87116f7 ,
BrushMan3 = 0x8711701 ,
BrushManOmega = 0x871170b ,
Scutz = 0x8711715 ,
Scuttle = 0x871171b ,
Scuttler = 0x8711723 ,
Scuttzer = 0x871172c ,
Scuttlest = 0x8711735 ,
ScuttleOmega = 0x871173f ,
Beetle = 0x8711748 ,
Deetle = 0x871174f ,
Geetle = 0x8711756 ,
BeetleOmega = 0x871175d ,
Metrid = 0x8711765 ,
Metrod = 0x871176c ,
Metrodo = 0x8711773 ,
MetridOmega = 0x871177b ,
SnowBlow = 0x8711783 ,
LowBlow = 0x871178c ,
MoBlow = 0x8711794 ,
SnowBlowOmega = 0x871179b ,
KillerEye = 0x87117a5 ,
DemonEye = 0x87117af ,
JokerEye = 0x87117b8 ,
KillerEyeOmega = 0x87117c1 ,
Momogra = 0x87117ca ,
Momogro = 0x87117d2 ,
Momogre = 0x87117da ,
MomograOmega = 0x87117e2 ,
Basher = 0x87117eb ,
Smasher = 0x87117f2 ,
Trasher = 0x87117fa ,
BasherOmega = 0x8711802 ,
Heavy = 0x871180a ,
Heavier = 0x8711810 ,
Heaviest = 0x8711818 ,
HeavyOmega = 0x8711821 ,
Pengi = 0x8711828 ,
Penga = 0x871182e ,
Pengon = 0x8711834 ,
PengiOmega = 0x871183b ,
Viney = 0x8711842 ,
Viner = 0x8711848 ,
Vinert = 0x871184e ,
VineyOmega = 0x8711855 ,
Slimer = 0x871185c ,
Slimey = 0x8711863 ,
Slimest = 0x871186a ,
SlimerOmega = 0x8711872 ,
EleBee = 0x871187a ,
EleWasp = 0x8711881 ,
EleHornet = 0x8711889 ,
EleBeeOmega = 0x8711893 ,
Needler = 0x871189b ,
Nailer = 0x87118a3 ,
Spiker = 0x87118aa ,
NeedlerOmega = 0x87118b1 ,
Trumpy = 0x87118ba ,
Tuby = 0x87118c1 ,
Tromby = 0x87118c6 ,
TrumpyOmega = 0x87118cd ,
QuestionMarkRed = 0x87118d5 ,
QuestionMarkBlue = 0x87118da ,
AlphaBug = 0x87118df ,
AlphaBugOmega = 0x87118e8 ,
Quaker = 0x87118f2 ,
Shaker = 0x87118f9 ,
Breaker = 0x8711900 ,
QuakerOmega = 0x8711908 ,
N_O = 0x8711910 ,
N_O_2 = 0x8711914 ,
N_O_3 = 0x871191a ,
N_O_Omega = 0x8711920 ,
Eleball = 0x8711926 ,
Elesphere = 0x871192e ,
Eleglobe = 0x8711938 ,
EleballOmega = 0x8711941 ,
Volcano = 0x871194a ,
Volcaner = 0x8711952 ,
Volcanest = 0x871195b ,
VolcanoOmega = 0x8711965 ,
Totem = 0x871196e ,
Totam = 0x8711974 ,
Totun = 0x871197a ,
TotemOmega = 0x8711980 ,
Twins = 0x8711987 ,
Twinner = 0x871198d ,
Twinnest = 0x8711995 ,
TwinsOmega = 0x871199e ,
Boomer = 0x87119a5 ,
Gloomer = 0x87119ac ,
Doomer = 0x87119b4 ,
BoomerOmega = 0x87119bb ,
Number_1 = 0x87119c3 ,
Number_2 = 0x87119cb ,
Number_3 = 0x87119d3 ,
Number_M1 = 0x87119db ,
Number_M2 = 0x87119e5 ,
Number_M3 = 0x87119ef ,
Number_G1 = 0x87119f9 ,
Number_G2 = 0x8711a03 ,
Number_G3 = 0x8711a0d ,
FlashMan = 0x8711a17 ,
FlashManAlpha = 0x8711a20 ,
FlashManBeta = 0x8711a2a ,
FlashManOmega = 0x8711a34 ,
BeastMan = 0x8711a3e ,
BeastManAlpha = 0x8711a47 ,
BeastManBeta = 0x8711a51 ,
BeastManOmega = 0x8711a5b ,
BubbleMan = 0x8711a65 ,
BubbleManAlpha = 0x8711a6f ,
BubbleManBeta = 0x8711a79 ,
BubbleManOmega = 0x8711a83 ,
DesertMan = 0x8711a8d ,
DesertManAlpha = 0x8711a97 ,
DesertManBeta = 0x8711aa1 ,
DesertManOmega = 0x8711aab ,
PlantMan = 0x8711ab5 ,
PlantManAlpha = 0x8711abe ,
PlantManBeta = 0x8711ac8 ,
PlantManOmega = 0x8711ad2 ,
FlameMan = 0x8711adc ,
FlameManAlpha = 0x8711ae4 ,
FlameManBeta = 0x8711aed ,
FlameManOmega = 0x8711af6 ,
DrillMan = 0x8711aff ,
DrillManAlpha = 0x8711b08 ,
DrillManBeta = 0x8711b12 ,
DrillManOmega = 0x8711b1c ,
Alpha = 0x8711b26 ,
AlphaOmega = 0x8711b2c ,
GutsMan = 0x8711b33 ,
GutsManAlpha = 0x8711b3b ,
GutsManBeta = 0x8711b44 ,
GutsManOmega = 0x8711b4d ,
ProtoMan = 0x8711b56 ,
ProtoManAlpha = 0x8711b5f ,
ProtoManBeta = 0x8711b69 ,
ProtoManOmega = 0x8711b73 ,
MetalMan = 0x8711b7d ,
MetalManAlpha = 0x8711b86 ,
MetalManBeta = 0x8711b90 ,
MetalManOmega = 0x8711b9a ,
Punk = 0x8711ba4 ,
PunkAlpha = 0x8711ba9 ,
PunkBeta = 0x8711baf ,
PunkOmega = 0x8711bb5 ,
KingMan = 0x8711bbb ,
KingManAlpha = 0x8711bc3 ,
KingManBeta = 0x8711bcc ,
KingManOmega = 0x8711bd5 ,
MistMan = 0x8711bde ,
MistManAlpha = 0x8711be6 ,
MistManBeta = 0x8711bef ,
MistManOmega = 0x8711bf8 ,
BowlMan = 0x8711c01 ,
BowlManAlpha = 0x8711c09 ,
BowlManBeta = 0x8711c12 ,
BowlManOmega = 0x8711c1b ,
DarkMan = 0x8711c24 ,
DarkManAlpha = 0x8711c2c ,
DarkManBeta = 0x8711c35 ,
DarkManOmega = 0x8711c3e ,
JapanMan = 0x8711c47 ,
JapanManAlpha = 0x8711c50 ,
JapanManBeta = 0x8711c5a ,
JapanManOmega = 0x8711c64 ,
Serenade = 0x8711c6e ,
SerenadeAlpha = 0x8711c77 ,
SerenadeBeta = 0x8711c81 ,
SerenadeOmega = 0x8711c8b ,
BassUnkillable = 0x8711c95 ,
Bass = 0x8711c9a ,
BassGS = 0x8711c9f ,
BassOmega = 0x8711ca6 ,


}



function dump_entity_name_addresses()
    
    local sorted_entity_keys = getKeysSortedByValue(ENTITY_TYPE, function(a, b) return a < b end)

    local current_address = BASE_OFFSET_NAME_DATA_FIRST_ENEMY
    
    ENTITY_NAME_ADDRESS_TRANSLATOR.MegaMan = 0x087114E4

    for _, key in pairs(sorted_entity_keys) do
        
        entity = ENTITY_TYPE[key]
        print(entity, ENTITY_TYPE.MegaMan)
        if entity ~= ENTITY_TYPE.MegaMan then
            print(key, ENTITY_TYPE[key])

            ENTITY_NAME_ADDRESS_TRANSLATOR[key] = current_address
            -- Read until End-Of-String is encountered.
            local current_byte = 0x00
            
            while current_byte ~= TEXT_TABLE.End_Of_String do
                current_address = current_address + 1
                current_byte = memory.readbyte(current_address)
            end

            -- Skip over the End-Of-String character for the next starting address.
            current_address = current_address + 1

        else
            -- Do nothing for the first entity.
        end
        
        
    end

    print("NAMES:")
    for _, key in pairs(sorted_entity_keys) do
        print(key, "=", string.format("0x%x", ENTITY_NAME_ADDRESS_TRANSLATOR[key]), ",")
    end
    
end

-- This was just used to dump all the addresses.
-- dump_entity_name_addresses()






return ENTITY_NAME_ADDRESS_TRANSLATOR