local gauntlet_data = require "gauntlet_data"
local ENTITIES = require "defs.entity_defs"
local ENTITY_TYPE = require "defs.entity_type_defs"
local deepcopy = require "deepcopy"
local NERF_VIRUS_GROUP = {

    NAME = "Cannonier",

}

local POSSIBLE_ENTITIES = {

    {
        "Mettaur",
        "Mettaur2",
        "Mettaur3",
        "MettaurOmega",
    },

    {
        "Canodumb",
        "Canodumb2",
        "Canodumb3",
        "CanodumbOmega",
    },

    {
        "Fishy",
        "Fishy2",
        "Fishy3",
        "FishyOmega",
    },

    {
        "Swordy",
        "Swordy2",
        "Swordy3",
        "SwordyOmega",
    },

    {
        "Ratty",
        "Ratty2",
        "Ratty3",
        "RattyOmega",
    },

    {
        "HardHead",
        "ColdHead",
        "HotHead",
        "HardHeadOmega",
    },

    {
        "Jelly",
        "HeatJelly",
        "EarthJelly",
        "JellyOmega",
    },

    {
        "Shrimpy",
        "Shrimpy2",
        "Shrimpy3",
        "ShrimpyOmega",
    },

    {
        "Spikey",
        "Spikey2",
        "Spikey3",
        "SpikeyOmega",
    },

    {
        "Bunny",
        "TuffBunny",
        "MegaBunny",
        "BunnyOmega",
    },

    {
        "WindBox",
        "VacuumFan",
        "StormBox",
        "WindBoxOmega",
    },

    {
        "PuffBall",
        "PoofBall",
        "GoofBall",
        "PuffBallOmega",
    },

    {
        "Mushy",
        "Mashy",
        "Moshy",
        "MushyOmega",
    },

    {
        "Dominerd",
        "Dominerd2",
        "Dominerd3",
        "DominerdOmega",
    },

    {
        "Yort",
        "Yurt",
        "Yart",
        "YortOmega",
    },

    {
        "Shadow",
        "RedDevil",
        "BlueDemon",
        "ShadowOmega",
    },

    {
        "BrushMan",
        "BrushMan2",
        "BrushMan3",
        "BrushManOmega",
    },

    {
        "Beetle",
        "Deetle",
        "Geetle",
        "BeetleOmega",
    },

    {
        "Metrid",
        "Metrod",
        "Metrodo",
        "MetridOmega",
    },

    {
        "SnowBlow",
        "LowBlow",
        "MoBlow",
        "SnowBlowOmega",
    },

    {
        "KillerEye",
        "DemonEye",
        "JokerEye",
        "KillerEyeOmega",
    },

    {
        "Momogra",
        "Momogro",
        "Momogre",
        "MomograOmega",
    },

    {
        "Basher",
        "Smasher",
        "Trasher",
        "BasherOmega",
    },

    {
        "Heavy",
        "Heavier",
        "Heaviest",
        "HeavyOmega",
    },

    {
        "Pengi",
        "Penga",
        "Pengon",
        "PengiOmega",
    },

    {
        "Viney",
        "Viner",
        "Vinert",
        "VineyOmega",
    },

    {
        "Slimer",
        "Slimey",
        "Slimest",
        "SlimerOmega",
    },

    {
        "EleBee",
        "EleWasp",
        "EleHornet",
        "EleBeeOmega",
    },
    
    {
        "Needler",
        "Nailer",
        "Spiker",
        "NeedlerOmega",
    },

    {
        "Trumpy",
        "Tuby",
        "Tromby",
        "TrumpyOmega",
    },

    {
        "QuestionMarkRed",
        "QuestionMarkBlue",
        "AlphaBug",
        "AlphaBugOmega",
    },

    {
        "Quaker",
        "Shaker",
        "Breaker",
        "QuakerOmega",
    },

    {
        "N_O",
        "N_O_2",
        "N_O_3",
        "N_O_Omega",
    },

    {
        "EleBall",
        "EleSphere",
        "EleGlobe",
        "EleBallOmega",
    },

    {
        "Volcano",
        "Volcaner",
        "Volcanest",
        "VolcanoOmega",
    },

    {
        "Totem",
        "Totam",
        "Totun",
        "TotemOmega",
    },

    {
        "Twins",
        "Twinner",
        "Twinnest",
        "TwinsOmega",
    },

    {
        "Scutz",
        "Scuttle",
        "Scuttler",
        "Scuttzer",
        "Scuttlest",
        "ScuttleOmega",
    },

    {
        "Boomer",
        "Gloomer",
        "Doomer",
        "BoomerOmega",
    },

    {
        "FlashMan",
        "FlashManAlpha",
        "FlashManBeta",
        "FlashManOmega",
    },

    {
        "BeastMan",
        "BeastManAlpha",
        "BeastManBeta",
        "BeastManOmega",
    },

    {
        "BubbleMan",
        "BubbleManAlpha",
        "BubbleManBeta",
        "BubbleManOmega",
    },

    {
        "DesertMan",
        "DesertManAlpha",
        "DesertManBeta",
        "DesertManOmega",
    },

    {
        "PlantMan",
        "PlantManAlpha",
        "PlantManBeta",
        "PlantManOmega",
    },

    {
        "FlameMan",
        "FlameManAlpha",
        "FlameManBeta",
        "FlameManOmega",
    },

    {
        "DrillMan",
        "DrillManAlpha",
        "DrillManBeta",
        "DrillManOmega",
    },

    {
        "Alpha",
        "AlphaOmega",
    },

    {
        "GutsMan",
        "GutsManAlpha",
        "GutsManBeta",
        "GutsManOmega",
    },

    {
        "ProtoMan",
        "ProtoManAlpha",
        "ProtoManBeta",
        "ProtoManOmega",
    },

    {
        "MetalMan",
        "MetalManAlpha",
        "MetalManBeta",
        "MetalManOmega",
    },

    {
        "Punk",
        "PunkAlpha",
        "PunkBeta",
        "PunkOmega",
    },

    {
        "KingMan",
        "KingManAlpha",
        "KingManBeta",
        "KingManOmega",
    },

    {
        "MistMan",
        "MistManAlpha",
        "MistManBeta",
        "MistManOmega",
    },
    
    {
        "BowlMan",
        "BowlManAlpha",
        "BowlManBeta",
        "BowlManOmega",
    },

    {
        "DarkMan",
        "DarkManAlpha",
        "DarkManBeta",
        "DarkManOmega",
    },

    {
        "JapanMan",
        "JapanManAlpha",
        "JapanManBeta",
        "JapanManOmega",
    },
    
    {
        "Serenade",
        "SerenadeAlpha",
        "SerenadeBeta",
        "SerenadeOmega",
    },
    
    {
        "Bass",
        "BassGS",
        "BassOmega",
    },
    
}



local HP_MULTIPLIER_PER_ROUND = {0.75, 0.75, 0.75, 0.75, 0.75}

function NERF_VIRUS_GROUP:activate(current_round)
    self.old_hp_table = {}
    -- This is an example for how to modify virus data.
    --print("ACTIVATE NERF")
    for key, entity in pairs(self.entity_family) do
        --print("ENTITY: ", entity)
        self.old_hp_table[entity] = ENTITIES[entity].HP_BASE
        ENTITIES[entity].HP_BASE = math.floor(ENTITIES[entity].HP_BASE * HP_MULTIPLIER_PER_ROUND[current_round])
        --print("NEW HP: ", ENTITIES[entity].HP_BASE)
    end
    
end

function NERF_VIRUS_GROUP:deactivate(current_round)

    -- This is an example for how to unmodify virus data.
    --print("DEACTIVATE NERF")
    for key, entity in pairs(self.entity_family) do
        ENTITIES[entity].HP_BASE = self.old_hp_table[entity]
        --print("NEW HP: ", ENTITIES[entity].HP_BASE)
    end
    
end


function NERF_VIRUS_GROUP:get_description(current_round)
    
    return "Decreases HP of all \"" .. ENTITIES[self.entity_family[1]].NAME .. "\"-Family \nViruses by " .. tostring((1.0 - HP_MULTIPLIER_PER_ROUND[current_round]) * 100) .. "%."


end


function NERF_VIRUS_GROUP.new()

    local new_buff = deepcopy(NERF_VIRUS_GROUP)


    --for key, entity_family in pairs(POSSIBLE_ENTITIES) do

    --    new_buff.entity_family = entity_family--POSSIBLE_ENTITIES[math.random(#POSSIBLE_ENTITIES)]
    --    print("FAMILY: ", ENTITIES[new_buff.entity_family[1]].NAME)
    --    new_buff.NAME = ENTITIES[new_buff.entity_family[1]].NAME .. "-Master"
    --    new_buff.DESCRIPTION = new_buff:get_description(1)
    --    new_buff:activate(1)
    --end

    new_buff.entity_family = POSSIBLE_ENTITIES[math.random(#POSSIBLE_ENTITIES)]
    new_buff.NAME = ENTITIES[new_buff.entity_family[1]].NAME .. "-Master"    
    new_buff.DESCRIPTION = new_buff:get_description(1)
    --print(new_buff)

    return deepcopy(new_buff)

end


return NERF_VIRUS_GROUP