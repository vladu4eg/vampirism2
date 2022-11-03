MAXIMUM_ATTACK_SPEED = 600
MINIMUM_ATTACK_SPEED = 20

TROLL_HERO = {"npc_dota_hero_wisp","npc_dota_hero_night_stalker","npc_dota_hero_doom_bringer","npc_dota_hero_life_stealer","npc_dota_hero_slardar"}
WOLF_HERO = "npc_dota_hero_lycan"

ELF_HERO = "npc_dota_hero_omniknight"
ANGEL_HERO = "npc_dota_hero_crystal_maiden"

BEAR_HERO = "npc_dota_hero_bear"

TEAM_CHOICE_TIME = 30
WOLF_START_SPAWN_TIME = 300 -- When the players will be able to choose wolf instead of auto chosen to angels. In seconds.
TROLL_SPAWN_TIME = 30
PRE_GAME_TIME = 40

ANGEL_RESPAWN_TIME = 10
WOLF_RESPAWN_TIME = 120
WOLF_STARTING_RESOURCES_FRACTION = 0.08 -- What percentage of troll's networth wolves should start with

ELF_STARTING_GOLD = 0
ELF_STARTING_LUMBER = 50
TROLL_STARTING_GOLD = 0
TROLL_STARTING_LUMBER = 0
TROLL_STARTING_GOLD_X4 = 350
TROLL_STARTING_GOLD_BATTLE = 20
STARTING_LUMBER_PRICE = 150
MINIMUM_LUMBER_PRICE = 10
STARTING_MAX_FOOD = 15

STARTING_MAX_WISP = 15
STARTING_MAX_MINE = 100

TIME_LIFE_WISP1_6 = 2400
TIME_LIFE_GOLD_WISP = 300

NO_CREATE_WISP = 2400

BUFF_ENIGMA_TIME = 7200
MIN_RATING_PLAYER = 10
MIN_RATING_PLAYER_CW = 5
PERC_KICK_PLAYER = 0.90
MIN_PLAYER_KICK = 8

CHANCE_NEW_PERSON = 10

TIMER_SAVER_HERO = 60

TIMER_KILL_CW = 181

EVENT_START = false
CHANCE_DROP_GEM_BARRACKS_3 = 25
SEASON_MAP = "autumn" -- name map
SEASON_ITEM = "item_autumn"           --  "item_winter_1" item_spring;  item_summer; item_autumn;

CHANCE_DROP_LUMBER = 2
RESPAWN_TREE_TIME_MIN = 20
RESPAWN_TREE_TIME_MAX = 60

BUFF_GOLD_TIME = 900
BUFF_GOLD_SUM_ELF = {30,120,250,500,1000,1500,2000,2500,3000,4000,5000}
BUFF_GOLD_SUM_TROLL = {750,1000,1500,2000,3000,4000,5000,6000,7000,8000,10000}


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
    XP_PER_LEVEL_TABLE[i] = XP_PER_LEVEL_TABLE[i-1] + i * 100 
end
  
