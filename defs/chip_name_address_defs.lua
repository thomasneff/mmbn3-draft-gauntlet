local CHIP_ID = require "defs.chip_id_defs"
local TEXT_TABLE = require "defs.text_table_defs"
CHIP_NAME_ADDRESS = {
[CHIP_ID.Cannon]	=	0x7045F5	,
[CHIP_ID.HiCannon]	=	0x7045FC	,
[CHIP_ID.MCannon]	=	0x704605	,
[CHIP_ID.Airshot1]	=	0x70460E	,
[CHIP_ID.Airshot2]	=	0x704617	,
[CHIP_ID.Airshot3]	=	0x704620	,
[CHIP_ID.Lavacan1]	=	0x704629	,
[CHIP_ID.Lavacan2]	=	0x704632	,
[CHIP_ID.Lavacan3]	=	0x70463B	,
[CHIP_ID.ShotGun]	=	0x704644	,
[CHIP_ID.VGun]	=	0x70464C	,
[CHIP_ID.SideGun]	=	0x704652	,
[CHIP_ID.Spreader]	=	0x70465A	,
[CHIP_ID.Bubbler]	=	0x704663	,
[CHIP_ID.BubV]	=	0x70466B	,
[CHIP_ID.BublSide]	=	0x704671	,
[CHIP_ID.Heatshot]	=	0x70467A	,
[CHIP_ID.HeatV]	=	0x704683	,
[CHIP_ID.HeatSide]	=	0x70468A	,
[CHIP_ID.MiniBomb]	=	0x704693	,
[CHIP_ID.SnglBomb]	=	0x70469C	,
[CHIP_ID.DublBomb]	=	0x7046A5	,
[CHIP_ID.TrplBomb]	=	0x7046AE	,
[CHIP_ID.CannBall]	=	0x7046B7	,
[CHIP_ID.IceBall]	=	0x7046C0	,
[CHIP_ID.LavaBall]	=	0x7046C8	,
[CHIP_ID.BlkBomb1]	=	0x7046D1	,
[CHIP_ID.BlkBomb2]	=	0x7046DA	,
[CHIP_ID.BlkBomb3]	=	0x7046E3	,
[CHIP_ID.Sword]	=	0x7046EC	,
[CHIP_ID.WideSwrd]	=	0x7046F2	,
[CHIP_ID.LongSwrd]	=	0x7046FB	,
[CHIP_ID.FireSwrd]	=	0x704704	,
[CHIP_ID.AquaSwrd]	=	0x70470D	,
[CHIP_ID.ElecSwrd]	=	0x704716	,
[CHIP_ID.BambSwrd]	=	0x70471F	,
[CHIP_ID.CustSwrd]	=	0x704728	,
[CHIP_ID.VarSwrd]	=	0x704731	,
[CHIP_ID.StepSwrd]	=	0x704739	,
[CHIP_ID.StepCros]	=	0x704742	,
[CHIP_ID.Panic]	=	0x70474B	,
[CHIP_ID.AirSwrd]	=	0x704751	,
[CHIP_ID.Slasher]	=	0x704759	,
[CHIP_ID.ShockWav]	=	0x704761	,
[CHIP_ID.SonicWav]	=	0x70476A	,
[CHIP_ID.DynaWave]	=	0x704773	,
[CHIP_ID.GutPunch]	=	0x70477C	,
[CHIP_ID.GutStrgt]	=	0x704785	,
[CHIP_ID.GutInpct]	=	0x70478E	,
[CHIP_ID.AirStrm1]	=	0x704797	,
[CHIP_ID.AirStrm2]	=	0x7047A0	,
[CHIP_ID.AirStrm3]	=	0x7047A9	,
[CHIP_ID.DashAtk]	=	0x7047B2	,
[CHIP_ID.Burner]	=	0x7047BA	,
[CHIP_ID.Totem1]	=	0x7047C1	,
[CHIP_ID.Totem2]	=	0x7047C8	,
[CHIP_ID.Totem3]	=	0x7047CF	,
[CHIP_ID.Ratton1]	=	0x7047D6	,
[CHIP_ID.Ratton2]	=	0x7047DE	,
[CHIP_ID.Ratton3]	=	0x7047E6	,
[CHIP_ID.Wave]	=	0x7047EE	,
[CHIP_ID.RedWave]	=	0x7047F3	,
[CHIP_ID.MudWave]	=	0x7047FB	,
[CHIP_ID.Hammer]	=	0x704803	,
[CHIP_ID.Tornado]	=	0x70480A	,
[CHIP_ID.Zapring1]	=	0x704812	,
[CHIP_ID.Zapring2]	=	0x70481B	,
[CHIP_ID.Zapring3]	=	0x704824	,
[CHIP_ID.YoYo1]	=	0x70482D	,
[CHIP_ID.YoYo2]	=	0x704834	,
[CHIP_ID.YoYo3]	=	0x70483B	,
[CHIP_ID.Spice1]	=	0x704842	,
[CHIP_ID.Spice2]	=	0x704849	,
[CHIP_ID.Spice3]	=	0x704850	,
[CHIP_ID.Lance]	=	0x704857	,
[CHIP_ID.Scuttlst]	=	0x70485D	,
[CHIP_ID.Momogra]	=	0x704866	,
[CHIP_ID.Rope1]	=	0x70486E	,
[CHIP_ID.Rope2]	=	0x704874	,
[CHIP_ID.Rope3]	=	0x70487A	,
[CHIP_ID.Magnum1]	=	0x704880	,
[CHIP_ID.Magnum2]	=	0x704888	,
[CHIP_ID.Magnum3]	=	0x704890	,
[CHIP_ID.Boomer1]	=	0x704898	,
[CHIP_ID.Boomer2]	=	0x7048A0	,
[CHIP_ID.Boomer3]	=	0x7048A8	,
[CHIP_ID.RndmMetr]	=	0x7048B0	,
[CHIP_ID.HoleMetr]	=	0x7048B9	,
[CHIP_ID.ShotMetr]	=	0x7048C2	,
[CHIP_ID.IceWave1]	=	0x7048CB	,
[CHIP_ID.IceWave2]	=	0x7048D4	,
[CHIP_ID.IveWave3]	=	0x7048DD	,
[CHIP_ID.Plasma1]	=	0x7048E6	,
[CHIP_ID.Plasma2]	=	0x7048EE	,
[CHIP_ID.Plasma3]	=	0x7048F6	,
[CHIP_ID.Arrow1]	=	0x7048FE	,
[CHIP_ID.Arrow2]	=	0x704905	,
[CHIP_ID.Arrow3]	=	0x70490C	,
[CHIP_ID.TimeBomb]	=	0x704913	,
[CHIP_ID.Mine]	=	0x70491C	,
[CHIP_ID.Sensor1]	=	0x704921	,
[CHIP_ID.Sensor2]	=	0x704929	,
[CHIP_ID.Sensor3]	=	0x704931	,
[CHIP_ID.CrsShld1]	=	0x704939	,
[CHIP_ID.CrsShld2]	=	0x704942	,
[CHIP_ID.CrsShld3]	=	0x70494B	,
[CHIP_ID.Geyser]	=	0x704954	,
[CHIP_ID.PoisMask]	=	0x70495B	,
[CHIP_ID.PoisFace]	=	0x704964	,
[CHIP_ID.Shake1]	=	0x70496D	,
[CHIP_ID.Shake2]	=	0x704974	,
[CHIP_ID.Shake3]	=	0x70497B	,
[CHIP_ID.BigWave]	=	0x704982	,
[CHIP_ID.Volcanoe]	=	0x70498A	,
[CHIP_ID.Condor]	=	0x704992	,
[CHIP_ID.Burning]	=	0x704999	,
[CHIP_ID.FireRatn]	=	0x7049A1	,
[CHIP_ID.Guard]	=	0x7049AA	,
[CHIP_ID.PanlOut1]	=	0x7049B0	,
[CHIP_ID.PanlOut3]	=	0x7049B9	,
[CHIP_ID.Recov10]	=	0x7049C2	,
[CHIP_ID.Recov30]	=	0x7049CA	,
[CHIP_ID.Recov50]	=	0x7049D2	,
[CHIP_ID.Recov80]	=	0x7049DA	,
[CHIP_ID.Recov120]	=	0x7049E2	,
[CHIP_ID.Recov150]	=	0x7049EB	,
[CHIP_ID.Recov200]	=	0x7049F4	,
[CHIP_ID.Recov300]	=	0x7049FD	,
[CHIP_ID.PanlGrab]	=	0x704A06	,
[CHIP_ID.AreaGrab]	=	0x704A0F	,
[CHIP_ID.Snake]	=	0x704A18	,
[CHIP_ID.Team1]	=	0x704A1E	,
[CHIP_ID.MetaGel1]	=	0x704A24	,
[CHIP_ID.MetaGel2]	=	0x704A2D	,
[CHIP_ID.MetaGel3]	=	0x704A36	,
[CHIP_ID.GrabBack]	=	0x704A3F	,
[CHIP_ID.GrabRvng]	=	0x704A48	,
[CHIP_ID.Geddon1]	=	0x704A51	,
[CHIP_ID.Geddon2]	=	0x704A59	,
[CHIP_ID.Geddon3]	=	0x704A61	,
[CHIP_ID.RockCube]	=	0x704A69	,
[CHIP_ID.Prism]	=	0x704A72	,
[CHIP_ID.Wind]	=	0x704A78	,
[CHIP_ID.Fan]	=	0x704A7D	,
[CHIP_ID.RockArm1]	=	0x704A81	,
[CHIP_ID.RockArm2]	=	0x704A8A	,
[CHIP_ID.RockArm3]	=	0x704A93	,
[CHIP_ID.NoBeam1]	=	0x704A9C	,
[CHIP_ID.NoBeam2]	=	0x704AA4	,
[CHIP_ID.NoBeam3]	=	0x704AAC	,
[CHIP_ID.Pawn]	=	0x704AB4	,
[CHIP_ID.Knight]	=	0x704AB9	,
[CHIP_ID.Rook]	=	0x704AC0	,
[CHIP_ID.Needler1]	=	0x704AC5	,
[CHIP_ID.Needler2]	=	0x704ACE	,
[CHIP_ID.Needler3]	=	0x704AD7	,
[CHIP_ID.SloGauge]	=	0x704AE0	,
[CHIP_ID.FstGauge]	=	0x704AE9	,
[CHIP_ID.Repair]	=	0x704AF2	,
[CHIP_ID.Invis]	=	0x704AF9	,
[CHIP_ID.Hole]	=	0x704AFF	,
[CHIP_ID.Mole1]	=	0x704B04	,
[CHIP_ID.Mole2]	=	0x704B0A	,
[CHIP_ID.Mole3]	=	0x704B10	,
[CHIP_ID.Shadow]	=	0x704B16	,
[CHIP_ID.Mettaur]	=	0x704B1D	,
[CHIP_ID.Bunny]	=	0x704B25	,
[CHIP_ID.AirShoes]	=	0x704B2B	,
[CHIP_ID.Team2]	=	0x704B34	,
[CHIP_ID.Fanfare]	=	0x704B3A	,
[CHIP_ID.Discord]	=	0x704B42	,
[CHIP_ID.Timpani]	=	0x704B4A	,
[CHIP_ID.Barrier]	=	0x704B52	,
[CHIP_ID.Barr100]	=	0x704B5A	,
[CHIP_ID.Barr200]	=	0x704B62	,
[CHIP_ID.Aura]	=	0x704B6A	,
[CHIP_ID.NrthWind]	=	0x704B6F	,
[CHIP_ID.HolyPanl]	=	0x704B78	,
[CHIP_ID.LavaStge]	=	0x704B81	,
[CHIP_ID.IceStage]	=	0x704B8A	,
[CHIP_ID.GrassStg]	=	0x704B93	,
[CHIP_ID.SandStge]	=	0x704B9C	,
[CHIP_ID.MetlStge]	=	0x704BA5	,
[CHIP_ID.Snctuary]	=	0x704BAE	,
[CHIP_ID.Swordy]	=	0x704BB7	,
[CHIP_ID.Spikey]	=	0x704BBE	,
[CHIP_ID.Mushy]	=	0x704BC5	,
[CHIP_ID.Jelly]	=	0x704BCB	,
[CHIP_ID.KillrEye]	=	0x704BD1	,
[CHIP_ID.AntiNavi]	=	0x704BDA	,
[CHIP_ID.AntiDmg]	=	0x704BE3	,
[CHIP_ID.AntiSwrd]	=	0x704BEB	,
[CHIP_ID.AntiRecv]	=	0x704BF4	,
[CHIP_ID.CopyDmg]	=	0x704BFD	,
[CHIP_ID.AtkPlus10]	=	0x704C05	,
[CHIP_ID.FirePlus30]	=	0x704C0C	,
[CHIP_ID.AquaPlus30]	=	0x704C14	,
[CHIP_ID.ElecPlus30]	=	0x704C1C	,
[CHIP_ID.WoodPlus30]	=	0x704C24	,
[CHIP_ID.NaviPlus20]	=	0x704C2C	,
[CHIP_ID.LifeAura]	=	0x704C34	,
[CHIP_ID.Muramasa]	=	0x704C3D	,
[CHIP_ID.Guardian]	=	0x704C46	,
[CHIP_ID.Anubis]	=	0x704C4F	,
[CHIP_ID.AtkPlus30]	=	0x704C56	,
[CHIP_ID.NaviPlus40]	=	0x704C5D	,
[CHIP_ID.HeroSwrd]	=	0x704C65	,
[CHIP_ID.ZeusHamr]	=	0x704C6E	,
[CHIP_ID.GodStone]	=	0x704C77	,
[CHIP_ID.OldWood]	=	0x704C80	,
[CHIP_ID.FullCust]	=	0x704C88	,
[CHIP_ID.Meteors]	=	0x704C91	,
[CHIP_ID.Poltrgst]	=	0x704C99	,
[CHIP_ID.Jealousy]	=	0x704CA2	,
[CHIP_ID.StandOut]	=	0x704CAB	,
[CHIP_ID.WatrLine]	=	0x704CB4	,
[CHIP_ID.Ligtning]	=	0x704CBD	,
[CHIP_ID.GaiaSwrd]	=	0x704CC6	,
[CHIP_ID.Roll]	=	0x704CCF	,
[CHIP_ID.RollV2]	=	0x704CD4	,
[CHIP_ID.RollV3]	=	0x704CDA	,
[CHIP_ID.Gutsman]	=	0x704CE0	,
[CHIP_ID.GutsmanV2]	=	0x704CE8	,
[CHIP_ID.GutsmanV3]	=	0x704CF1	,
[CHIP_ID.GustmanV4]	=	0x704CFA	,
[CHIP_ID.GutsManV5]	=	0x704D03	,
[CHIP_ID.Protoman]	=	0x704D0C	,
[CHIP_ID.ProtomnV2]	=	0x704D15	,
[CHIP_ID.ProtomnV3]	=	0x704D1E	,
[CHIP_ID.ProtomnV4]	=	0x704D27	,
[CHIP_ID.ProtoMnV5]	=	0x704D30	,
[CHIP_ID.Flashman]	=	0x704D39	,
[CHIP_ID.FlashmnV2]	=	0x704D42	,
[CHIP_ID.FlashmnV3]	=	0x704D4B	,
[CHIP_ID.FlashmnV4]	=	0x704D54	,
[CHIP_ID.FlashMnV5]	=	0x704D5D	,
[CHIP_ID.Beastman]	=	0x704D66	,
[CHIP_ID.BeastmnV2]	=	0x704D6F	,
[CHIP_ID.BeastmnV3]	=	0x704D78	,
[CHIP_ID.BeastmnV4]	=	0x704D81	,
[CHIP_ID.BeastMnV5]	=	0x704D8A	,
[CHIP_ID.BubblMan]	=	0x704D93	,
[CHIP_ID.BubblMnV2]	=	0x704D9C	,
[CHIP_ID.BubblMnV3]	=	0x704DA5	,
[CHIP_ID.BubblMnV4]	=	0x704DAE	,
[CHIP_ID.BubblMnV5]	=	0x704DB7	,
[CHIP_ID.DesrtMan]	=	0x704DC0	,
[CHIP_ID.DesrtMnV2]	=	0x704DC9	,
[CHIP_ID.DesrtMnV3]	=	0x704DD2	,
[CHIP_ID.DesrtMnV4]	=	0x704DDB	,
[CHIP_ID.DesrtMnV5]	=	0x704DE4	,
[CHIP_ID.PlantMan]	=	0x704DED	,
[CHIP_ID.PlantMnV2]	=	0x704DF6	,
[CHIP_ID.PlantMnV3]	=	0x704DFF	,
[CHIP_ID.PlantMnV4]	=	0x704E08	,
[CHIP_ID.PlantMnV5]	=	0x704E11	,
[CHIP_ID.FlamMan]	=	0x704F1F	,
[CHIP_ID.FlamManV2]	=	0x704F27	,
[CHIP_ID.FlamManV3]	=	0x704F30	,
[CHIP_ID.FlamManV4]	=	0x704F39	,
[CHIP_ID.FlamManV5]	=	0x704F42	,
[CHIP_ID.DrillMan]	=	0x704F4B	,
[CHIP_ID.DrillMnV2]	=	0x704F54	,
[CHIP_ID.DrillMnV3]	=	0x704F5D	,
[CHIP_ID.DrillMnV4]	=	0x704F66	,
[CHIP_ID.DrillMnV5]	=	0x704F6F	,
[CHIP_ID.MetalMan]	=	0x704F78	,
[CHIP_ID.MetalMnV2]	=	0x704F81	,
[CHIP_ID.MetalMnV3]	=	0x704F8A	,
[CHIP_ID.MetalMnV4]	=	0x704F93	,
[CHIP_ID.MetalMnV5]	=	0x704F9C	,
[CHIP_ID.Salamndr]	=	0x704FA5	,
[CHIP_ID.Fountain]	=	0x704FAA	,
[CHIP_ID.Bolt]	=	0x704FB3	,
[CHIP_ID.GaiaBlad]	=	0x704FBC	,
[CHIP_ID.KingMan]	=	0x704FC1	,
[CHIP_ID.KingManV2]	=	0x704FCA	,
[CHIP_ID.KingManV3]	=	0x704FD2	,
[CHIP_ID.KingManV4]	=	0x704FDB	,
[CHIP_ID.KingMnV5]	=	0x704FE4	,
[CHIP_ID.MistMan]	=	0x704FED	,
[CHIP_ID.MistManV2]	=	0x704FF6	,
[CHIP_ID.MistManV3]	=	0x704FFE	,
[CHIP_ID.MistManV4]	=	0x705007	,
[CHIP_ID.MistMnV5]	=	0x705010	,
[CHIP_ID.BowlMan]	=	0x705019	,
[CHIP_ID.BowlManV2]	=	0x705022	,
[CHIP_ID.BowlManV3]	=	0x70502A	,
[CHIP_ID.BowlManV4]	=	0x705033	,
[CHIP_ID.BowlManV5]	=	0x70503C	,
[CHIP_ID.DarkMan]	=	0x705045	,
[CHIP_ID.DarkManV2]	=	0x70504E	,
[CHIP_ID.DarkManV3]	=	0x705056	,
[CHIP_ID.DarkManV4]	=	0x70505F	,
[CHIP_ID.DarkManV5]	=	0x705068	,
[CHIP_ID.JapanMan]	=	0x705071	,
[CHIP_ID.JapanMnV2]	=	0x70507A	,
[CHIP_ID.JapanMnV3]	=	0x705083	,
[CHIP_ID.JapanMnV4]	=	0x70508C	,
[CHIP_ID.JapanMnV5]	=	0x705095	,
[CHIP_ID.DeltaRay]	=	0x70509E	,
[CHIP_ID.FolderBak]	=	0x7050A7	,
[CHIP_ID.NavRcycl]	=	0x7050B0	,
[CHIP_ID.AlphArmOmega]	=	0x7050C2	,
[CHIP_ID.AlphArmSigma]	=	0x7050C2	,
[CHIP_ID.Bass]	=	0x7050CB	,
[CHIP_ID.Serenade]	=	0x7050D0	,
[CHIP_ID.Balance]	=	0x7050D9	,
[CHIP_ID.DarkAura]	=	0x7050E1	,
[CHIP_ID.BassGS]	=	0x7050F3	,
[CHIP_ID.BassPlus]	=	0x7050F3	,
[CHIP_ID.ZCanon1]	=	0x7050F9	,
[CHIP_ID.ZCanon2]	=	0x705100	,
[CHIP_ID.ZCanon3]	=	0x705102	,
[CHIP_ID.ZPunch]	=	0x705104	,
[CHIP_ID.ZStrght]	=	0x705106	,
[CHIP_ID.ZImpact]	=	0x705110	,
[CHIP_ID.ZVaribl]	=	0x705119	,
[CHIP_ID.ZYoyo1]	=	0x705122	,
[CHIP_ID.ZYoyo2]	=	0x70512A	,
[CHIP_ID.ZYoyo3]	=	0x705133	,
[CHIP_ID.ZStep1]	=	0x70513C	,
[CHIP_ID.ZStep2]	=	0x705145	,
[CHIP_ID.TimeBomPlus]	=	0x70514D	,
[CHIP_ID.HBurst]	=	0x705155	,
[CHIP_ID.BubSprd]	=	0x70515D	,
[CHIP_ID.HeatSprd]	=	0x705165	,
[CHIP_ID.LifeSwrd]	=	0x70516D	,
[CHIP_ID.ElemSwrd]	=	0x705176	,
[CHIP_ID.EvilCut]	=	0x70517E	,
[CHIP_ID.DoubleHero]	=	0x705186	,
[CHIP_ID.HyperRat]	=	0x70518F	,
[CHIP_ID.EverCurse]	=	0x705198	,
[CHIP_ID.GelRain]	=	0x7051A1	,
[CHIP_ID.PoisPhar]	=	0x7051A9	,
[CHIP_ID.BodyGrd]	=	0x7051B0	,
[CHIP_ID.Barr500]	=	0x7051B9	,
[CHIP_ID.BigHeart]	=	0x7051C2	,
[CHIP_ID.GtsShoot]	=	0x7051CA	,
[CHIP_ID.DeuxHero]	=	0x7051D3	,
[CHIP_ID.MomQuake]	=	0x7051DB	,
[CHIP_ID.PrixPowr]	=	0x7051E3	,
[CHIP_ID.MstrStyl]	=	0x7051EC	,
}








local BASE_OFFSET_FIRST_CHIP = 0x087045F5 -- Starts at "Cannon"

function getKeysSortedByValue(tbl, sortFunction)
  local keys = {}
  for key in pairs(tbl) do
    table.insert(keys, key)
  end

  table.sort(keys, function(a, b)
    return sortFunction(tbl[a], tbl[b])
  end)

  return keys
end

local dummy = {}

function dump_entity_name_addresses()
    
    sorted_CHIP_ID_KEYS = getKeysSortedByValue(CHIP_ID, function(a, b) return a < b end)
    local working_address = BASE_OFFSET_FIRST_CHIP
    working_address = working_address - 0x08000000
    for _, key in pairs(sorted_CHIP_ID_KEYS) do

        local current_chip_name = ""
        local current_byte = 0
        current_id = CHIP_ID[key]
        dummy[current_id] = working_address
        while current_byte ~= TEXT_TABLE.End_Of_String do

            working_address = working_address + 1
            current_byte = memory.readbyte(working_address, "ROM")

        end

        -- Skip end of string.
        working_address = working_address + 1

    end

    print("CHIP_NAME_ADDRESS = {")

    for _, key in pairs(sorted_CHIP_ID_KEYS) do
        current_id = CHIP_ID[key]
        print("[CHIP_ID."..key.."]", "=", "0x" .. bizstring.hex(dummy[current_id]), ",")
    end

    print("}")
end





return CHIP_NAME_ADDRESS