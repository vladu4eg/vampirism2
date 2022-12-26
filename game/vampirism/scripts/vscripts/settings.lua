MAXIMUM_ATTACK_SPEED = 600
MINIMUM_ATTACK_SPEED = 20

TROLL_HERO = {"npc_dota_hero_night_stalker","npc_dota_hero_life_stealer"} -- ,"npc_dota_hero_doom_bringer","npc_dota_hero_slardar"
WOLF_HERO = "npc_dota_hero_lycan"

ELF_HERO = "npc_dota_hero_omniknight"

TEAM_CHOICE_TIME = 30
TROLL_SPAWN_TIME = 55
PRE_GAME_TIME = 40

WOLF_STARTING_RESOURCES_FRACTION = 0.3 -- What percentage of troll's networth wolves should start with

ELF_STARTING_GOLD = 0
ELF_STARTING_LUMBER = 50
TROLL_STARTING_GOLD = 0
TROLL_STARTING_LUMBER = 0

STARTING_MAX_FOOD = 20
STARTING_MAX_MINE = 9

MIN_RATING_PLAYER = 1
MIN_RATING_PLAYER_CW = 5
PERC_KICK_PLAYER = 0.90
MIN_PLAYER_KICK = 4

CHANCE_DROP_GEM_BARRACKS_3 = 25
SEASON_MAP = "winter" -- name map
SEASON_ITEM = "item_winter_1"           --  "item_winter_1" item_spring;  item_summer; item_autumn;

CHANCE_DROP_LUMBER = 2
RESPAWN_TREE_TIME_MIN = 20
RESPAWN_TREE_TIME_MAX = 60

BUFF_GOLD_TIME = 300
BUFF_GOLD_SUM_ELF = {30,60,90,120,150,180,210,240,270,300,330,360,390,420,450,480,510,540,570,600}
BUFF_GOLD_SUM_TROLL = {150,300,450,600,750,900,1050,1200,1350,1500,1650,1800,1950,2100,2250,2400,2550,2700,2850,3000}


PLAYER_COLORS = {
    {0, 102, 255}, -- синий
    {0, 255, 255}, -- голубой
    {153, 0, 204}, -- фиолетовый
    {225, 0, 255},  -- фиолетовый
    {255, 255, 0},
    {255, 153, 51},
    {51, 204, 51},
    {0, 105, 0},
    {128, 0, 0},
    {176, 0, 0},
    {60,20, 74},
	{139, 69, 19},
    {0, 0, 255},
	{0, 0, 128},
    {0, 0, 0}
}

XP_PER_LEVEL_TABLE = {}
XP_PER_LEVEL_TABLE[1] = 0
for i = 2, 100 do
    XP_PER_LEVEL_TABLE[i] = XP_PER_LEVEL_TABLE[i-1] + i * 75 
end
  
