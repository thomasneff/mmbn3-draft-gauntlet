local CHIP_ID = {
    Cannon	=	0x1	,
HiCannon	=	0x2	,
MCannon	=	0x3	,
AirShot1	=	0x4	,
AirShot2	=	0x5	,
AirShot3	=	0x6	,
LavaCan1	=	0x7	,
LavaCan2	=	0x8	,
LavaCan3	=	0x9	,
Volcano	=	0x72	,
ShotGun	=	0x0A	,
VGun	=	0x0B	,
SideGun	=	0x0C	,
Spreader	=	0x0D	,
Bubbler	=	0x0E	,
BubV	=	0x0F	,
BublSide	=	0x10	,
HeatShot	=	0x11	,
HeatV	=	0x12	,
HeatSide	=	0x13	,
MiniBomb	=	0x14	,
SnglBomb	=	0x15	,
DublBomb	=	0x16	,
TrplBomb	=	0x17	,
CannBall	=	0x18	,
IceBall	=	0x19	,
LavaBall	=	0x1A	,
BlkBomb1	=	0x1B	,
BlkBomb2	=	0x1C	,
BlkBomb3	=	0x1D	,
Sword	=	0x1E	,
WideSwrd	=	0x1F	,
LongSwrd	=	0x20	,
FireSwrd	=	0x21	,
AquaSwrd	=	0x22	,
ElecSwrd	=	0x23	,
BambSwrd	=	0x24	,
CustSwrd	=	0x25	,
VarSwrd	=	0x26	,
AirSwrd	=	0x2A	,
StepSwrd	=	0x27	,
StepCros	=	0x28	,
Slasher	=	0x2B	,
ShockWav	=	0x2C	,
SonicWav	=	0x2D	,
DynaWave	=	0x2E	,
BigWave	=	0x71	,
GutPunch	=	0x2F	,
GutStrgt	=	0x30	,
GutImpct	=	0x31	,
DashAtk	=	0x35	,
Burner	=	0x36	,
Condor	=	0x73	,
Burning	=	0x74	,
ZapRing1	=	0x42	,
ZapRing2	=	0x43	,
ZapRing3	=	0x44	,
IceWave1	=	0x5A	,
IceWave2	=	0x5B	,
IceWave3	=	0x5C	,
YoYo1	=	0x45	,
YoYo2	=	0x46	,
YoYo3	=	0x47	,
AirStrm1	=	0x32	,
AirStrm2	=	0x33	,
AirStrm3	=	0x34	,
Arrow1	=	0x60	,
Arrow2	=	0x61	,
Arrow3	=	0x62	,
Ratton1	=	0x3A	,
Ratton2	=	0x3B	,
Ratton3	=	0x3C	,
FireRatn	=	0x75	,
Wave	=	0x3D	,
RedWave	=	0x3E	,
MudWave	=	0x3F	,
Tornado	=	0x41	,
Spice1	=	0x48	,
Spice2	=	0x49	,
Spice3	=	0x4A	,
Shake1	=	0x6E	,
Shake2	=	0x6F	,
Shake3	=	0x70	,
NoBeam1	=	0x94	,
NoBeam2	=	0x95	,
NoBeam3	=	0x96	,
Hammer	=	0x40	,
Geyser	=	0x6B	,
Rope1	=	0x4E	,
Rope2	=	0x4F	,
Rope3	=	0x50	,
Boomer1	=	0x54	,
Boomer2	=	0x55	,
Boomer3	=	0x56	,
PoisMask	=	0x6C	,
PoisFace	=	0x6D	,
RockArm1	=	0x91	,
RockArm2	=	0x92	,
RockArm3	=	0x93	,
CrsShld1	=	0x68	,
CrsShld2	=	0x69	,
CrsShld3	=	0x6A	,
Magnum1	=	0x51	,
Magnum2	=	0x52	,
Magnum3	=	0x53	,
Plasma1	=	0x5D	,
Plasma2	=	0x5E	,
Plasma3	=	0x5F	,
RndmMetr	=	0x57	,
HoleMetr	=	0x58	,
ShotMetr	=	0x59	,
Needler1	=	0x9A	,
Needler2	=	0x9B	,
Needler3	=	0x9C	,
Totem1	=	0x37	,
Totem2	=	0x38	,
Totem3	=	0x39	,
Sensor1	=	0x65	,
Sensor2	=	0x66	,
Sensor3	=	0x67	,
MetaGel1	=	0x85	,
MetaGel2	=	0x86	,
MetaGel3	=	0x87	,
Pawn	=	0x97	,
Knight	=	0x98	,
Rook	=	0x99	,
Team1	=	0x84	,
Team2	=	0xA9	,
TimeBomb	=	0x63	,
Mine	=	0x64	,
Lance	=	0x4B	,
Snake	=	0x83	,
Guard	=	0x76	,
PanlOut1	=	0x77	,
PanlOut3	=	0x78	,
PanlGrab	=	0x81	,
AreaGrab	=	0x82	,
GrabBack	=	0x88	,
GrabRvng	=	0x89	,
RockCube	=	0x8D	,
Prism	=	0x8E	,
Wind	=	0x8F	,
Fan	=	0x90	,
Fanfare	=	0xAA	,
Discord	=	0xAB	,
Timpani	=	0xAC	,
Recov10	=	0x79	,
Recov30	=	0x7A	,
Recov50	=	0x7B	,
Recov80	=	0x7C	,
Recov120	=	0x7D	,
Recov150	=	0x7E	,
Recov200	=	0x7F	,
Recov300	=	0x80	,
Repair	=	0x9F	,
SloGauge	=	0x9D	,
FstGauge	=	0x9E	,
Panic	=	0x29	,
Geddon1	=	0x8A	,
Geddon2	=	0x8B	,
Geddon3	=	0x8C	,
CopyDmg	=	0xC2	,
Invis	=	0xA0	,
Shadow	=	0xA5	,
Mole1	=	0xA2	,
Mole2	=	0xA3	,
Mole3	=	0xA4	,
AirShoes	=	0xA8	,
Barrier	=	0xAD	,
Barr100	=	0xAE	,
Barr200	=	0xAF	,
Aura	=	0xB0	,
NrthWind	=	0xB1	,
Mettaur	=	0xA6	,
Bunny	=	0xA7	,
Spikey	=	0xBA	,
Swordy	=	0xB9	,
Jelly	=	0xBC	,
Mushy	=	0xBB	,
Momogra	=	0x4D	,
KillrEye	=	0xBD	,
Scuttlst	=	0x4C	,
Hole	=	0xA1	,
HolyPanl	=	0xB2	,
LavaStge	=	0xB3	,
IceStage	=	0xB4	,
GrassStg	=	0xB5	,
SandStge	=	0xB6	,
MetlStge	=	0xB7	,
Snctuary	=	0xB8	,
AntiDmg	=	0xBF	,
AntiSwrd	=	0xC0	,
AntiNavi	=	0xBE	,
AntiRecv	=	0xC1	,
AtkPlus10	=	0xC3	,
FirePlus30	=	0xC4	,
AquaPlus30	=	0xC5	,
ElecPlus30	=	0xC6	,
WoodPlus30	=	0xC7	,
NaviPlus20	=	0xC8	,
Muramasa	=	0xCA	,
HeroSwrd	=	0xCF	,
ZeusHamr	=	0xD0	,
StandOut	=	0xD7	,
WatrLine	=	0xD8	,
Punk        =   0x110   ,
Salamndr	=	0x111	,
Ligtning	=	0xD9	,
Fountain	=	0x112	,
GaiaSwrd	=	0xDA	,
Bolt	=	0x113	,
GaiaBlad	=	0x114	,
Meteors	=	0xD4	,
Guardian	=	0xCB	,
Anubis	=	0xCC	,
GodStone	=	0xD1	,
OldWood	=	0xD2	,
Jealousy	=	0xD6	,
Poltrgst	=	0xD5	,
LifeAura	=	0xC9	,
FullCust	=	0xD3	,
AtkPlus30	=	0xCD	,
NaviPlus40	=	0xCE	,
Roll	=	0xDB	,
RollV2	=	0xDC	,
RollV3	=	0xDD	,
GutsMan	=	0xDE	,
GutsManV2	=	0xDF	,
GutsManV3	=	0xE0	,
GutsManV4	=	0xE1	,
ProtoMan	=	0xE3	,
ProtoMnV2	=	0xE4	,
ProtoMnV3	=	0xE5	,
ProtoMnV4	=	0xE6	,
FlashMan	=	0xE8	,
FlashMnV2	=	0xE9	,
FlashMnV3	=	0xEA	,
FlashMnV4	=	0xEB	,
BeastMan	=	0xED	,
BeastMnV2	=	0xEE	,
BeastMnV3	=	0xEF	,
BeastMnV4	=	0xF0	,
BubblMan	=	0xF2	,
BubblMnV2	=	0xF3	,
BubblMnV3	=	0xF4	,
BubblMnV4	=	0xF5	,
DesrtMan	=	0xF7	,
DesrtMnV2	=	0xF8	,
DesrtMnV3	=	0xF9	,
DesrtMnV4	=	0xFA	,
PlantMan	=	0xFC	,
PlantMnV2	=	0xFD	,
PlantMnV3	=	0xFE	,
PlantMnV4	=	0xFF	,
FlamMan	=	0x101	,
FlamManV2	=	0x102	,
FlamManV3	=	0x103	,
FlamManV4	=	0x104	,
DrillMan	=	0x106	,
DrillMnV2	=	0x107	,
DrillMnV3	=	0x108	,
DrillMnV4	=	0x109	,
MetalMan	=	0x010B	,
MetalMnV2	=	0x010C	,
MetalMnV3	=	0x010D	,
MetalMnV4	=	0x010E	,
KingMan	=	0x115	,
KingManV2	=	0x116	,
KingManV3	=	0x117	,
KingManV4	=	0x118	,
MistMan	=	0x011A	,
MistManV2	=	0x011B	,
MistManV3	=	0x011C	,
MistManV4	=	0x011D	,
BowlMan	=	0x011F	,
BowlManV2	=	0x120	,
BowlManV3	=	0x121	,
BowlManV4	=	0x122	,
DarkMan	=	0x124	,
DarkManV2	=	0x125	,
DarkManV3	=	0x126	,
DarkManV4	=	0x127	,
JapanMan	=	0x129	,
JapanMnV2	=	0x12A	,
JapanMnV3	=	0x12B	,
JapanMnV4	=	0x12C	,
FoldrBak	=	0x012F	,
BassGS	=	0x138	,
DarkAura	=	0x135	,
DeltaRay	=	0x012E	,
AlphArmO	=	0x131	,
GutsManV5	=	0xE2	,
ProtoMnV5	=	0xE7	,
FlashMnV5	=	0xEC	,
BeastMnV5	=	0xF1	,
BubblMnV5	=	0xF6	,
DesrtMnV5	=	0xFB	,
PlantMnV5	=	0x100	,
FlamManV5	=	0x105	,
DrillMnV5	=	0x010A	,
MetalMnV5	=	0x010F	,
KingMnV5	=	0x119	,
MistMnV5	=	0x011E	,
BowlManV5	=	0x123	,
DarkManV5	=	0x128	,
JapanMnV5	=	0x012D	,
AlphArmS	=	0x131	,
Bass	=	0x132	,
NavRcycl	=	0x130	,
Serenade	=	0x133	,
Balance	=	0x134	,
BassPlus	=	0x137	,
ZCanon1	=	0x140	,
ZCanon2	=	0x141	,
ZCanon3	=	0x142	,
ZPunch	=	0x143	,
ZStrght	=	0x144	,
ZImpact	=	0x145	,
ZVaribl	=	0x146	,
ZYoyo1	=	0x147	,
ZYoyo2	=	0x148	,
ZYoyo3	=	0x149	,
ZStep1	=	0x014A	,
ZStep2	=	0x014B	,
TimeBomPlus	=	0x014C	,
HBurst	=	0x014D	,
BubSprd	=	0x014E	,
HeatSprd	=	0x014F	,
LifeSwrd	=	0x150	,
ElemSwrd	=	0x151	,
EvilCut	=	0x152	,
DoubleHero	=	0x153	,
HyperRat	=	0x154	,
EverCurse	=	0x155	,
GelRain	=	0x156	,
PoisPhar	=	0x157	,
BodyGrd	=	0x158	,
Barr500	=	0x159	,
BigHeart	=	0x015A	,
GtsShoot	=	0x015B	,
DeuxHero	=	0x015C	,
MomQuake	=	0x015D	,
PrixPowr	=	0x015E	,
MstrStyl	=	0x015F	
}

return CHIP_ID