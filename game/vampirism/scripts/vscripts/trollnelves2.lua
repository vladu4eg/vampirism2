-- This is the primary trollnelves2 trollnelves2 script and should be used to assist in initializing your game mode
-- Set this to true if you want to see a complete debug output of all events/processes done by trollnelves2
-- You can also change the cvar 'trollnelves2_spew' at any time to 1 or 0 for output/no output
TROLLNELVES2_DEBUG_SPEW = false
LinkLuaModifier("modifier_movespeed_x4",
    "libraries/modifiers/modifier_movespeed_x4.lua",
LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_movespeed_x2",
    "libraries/modifiers/modifier_movespeed_x2.lua",
LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_anti_hp_mana_regen",
    "modifiers/modifier_anti_hp_mana_regen.lua",
LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_max_attackspeed",
    "modifiers/modifier_max_attackspeed.lua",
LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_antiblock",
    "libraries/modifiers/modifier_antiblock.lua",
LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_innate_controller",
    "libraries/modifiers/modifier_innate_controller.lua",
LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_hp_walls_proc", "modifiers/modifier_hp_walls_proc.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hp_wood_worker", "modifiers/modifier_hp_wood_worker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_range_tower", "modifiers/modifier_range_tower.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_regen_walls_proc", "modifiers/modifier_regen_walls_proc.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mana_buffwalls", "modifiers/modifier_mana_buffwalls.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slayers_low", "modifiers/modifier_slayers_low.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_damage_tower", "modifiers/modifier_damage_tower.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_armor_wall", "modifiers/modifier_armor_wall.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hp_reg_tower", "modifiers/modifier_hp_reg_tower.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hp_elf", "modifiers/modifier_hp_elf.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hp_walls", "modifiers/modifier_hp_walls.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slayers_max", "modifiers/modifier_slayers_max.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_range_no_miss", "modifiers/modifier_range_no_miss.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hp_elf_2", "modifiers/modifier_hp_elf_2.lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_hp_wood_worker_aura", "modifiers/modifier_hp_wood_worker_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hp_walls_proc_aura", "modifiers/modifier_hp_walls_proc_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_range_tower_aura", "modifiers/modifier_range_tower_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_regen_walls_proc_aura", "modifiers/modifier_regen_walls_proc_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mana_buffwalls_aura", "modifiers/modifier_mana_buffwalls_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slayers_low_aura", "modifiers/modifier_slayers_low_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_damage_tower_aura", "modifiers/modifier_damage_tower_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_armor_wall_aura", "modifiers/modifier_armor_wall_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hp_reg_tower_aura", "modifiers/modifier_hp_reg_tower_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hp_walls_aura", "modifiers/modifier_hp_walls_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slayers_max_aura", "modifiers/modifier_slayers_max_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_range_no_miss_aura", "modifiers/modifier_range_no_miss_aura.lua", LUA_MODIFIER_MOTION_NONE)

if trollnelves2 == nil then
    DebugPrint('[TROLLNELVES2] creating trollnelves2 game mode')
    _G.trollnelves2 = class({})
end

-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/util')
require('libraries/notifications')
require('libraries/popups')
require('libraries/team')
require('libraries/player')
require('libraries/entity')
require('libraries/animations')

require('internal/trollnelves2')
require('trigger/slayersUpLVL')
require('top')
require('settings')
require('events')
require('donate')
require('reklama')
require('chatcommand')
require('votekick')
require('drop')
require('wearables')
require('SelectPets')
require('pets')
require('flag')
require('filter')
require('speech_bubble/speech_bubble_class')
require('libraries/worldpanels')
require('PseudoRandom')

function trollnelves2:PostLoadPrecache()
    Pets:Init()
    DebugPrint("[BAREBONES] Performing Post-Load precache")
end
-- Gets called when a player chooses if he wants to be troll or not
function OnPlayerTeamChoose(eventSourceIndex, args)
    local playerID = args["playerID"]
    local vote = args["team"]
    GameRules.playerTeamChoices[playerID] = vote
end
trollPlayerID = -1
function trollnelves2:GameSetup()
    if IsServer() then
        for pID = 0, DOTA_MAX_TEAM_PLAYERS do
            if PlayerResource:IsValidPlayerID(pID) then
                PlayerResource:SetCustomTeamAssignment(pID, DOTA_TEAM_GOODGUYS)
                PlayerResource:SetSelectedHero(pID, ELF_HERO)
                GameRules.Score[pID] = 0
                GameRules.PlayersFPS[pID] = false
                local steam = tostring(PlayerResource:GetSteamID(pID))
                CustomNetTables:SetTableValue("Shop", tostring(pID), GameRules.PoolTable)
                Shop.RequestBonusTroll(pID, steam, callback)
                Shop.RequestVip(pID, steam, callback)
                Shop.RequestSkin(pID, steam, callback)
                Shop.RequestPets(pID, steam, callback)
                Shop.RequestBonus(pID, steam, callback)
                Shop.RequestVipDefaults(pID, steam, callback)
                Shop.RequestSkinDefaults(pID, steam, callback)
                Shop.RequestPetsDefaults(pID, steam, callback)
                Stats.RequestData(pID)
                Shop.RequestCoint(pID, steam, callback)
                Shop.RequestChests(pID, steam, callback)
                Shop.RequestSounds(pID, steam, callback)
                Shop.RequestRewards(pID, steam, callback)
                Shop.RequestXP(pID, steam, callback)
            end
        end
        Stats.RequestDataTop10("1", callback)
        Stats.RequestDataTop10("2", callback)
        Stats.RequestDataTop10("3", callback)
        Stats.RequestDataTop10("4", callback)
        Donate:CreateList()
        GameRules.PlayersCount = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) + PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS)
        DebugPrint("count player " .. GameRules.PlayersCount)
        Timers:CreateTimer(TEAM_CHOICE_TIME, function()
            SelectHeroes()
            GameRules:FinishCustomGameSetup()
        end)
    end
end

-- функция сортировки по первому элементу, следующие не учитываются
function mySort(a,b)
    if  a[2] > b [2] then
        return true
    end
    return false
end 

function SelectHeroes()
    local allPlayersIDs = {}
    local wannabeTrollIDs = {}
    local donateTroll = {}
    for pID = 0, DOTA_MAX_TEAM_PLAYERS do
        if PlayerResource:IsValidPlayerID(pID) then
            table.insert(allPlayersIDs, pID)
            local playerSelection = GameRules.playerTeamChoices[pID]
            if playerSelection == "troll" and PlayerResource:GetConnectionState(pID) == 2 then
                table.insert(wannabeTrollIDs, pID)
            end
            PlayerResource:SetCustomTeamAssignment(pID, DOTA_TEAM_GOODGUYS)
        end
    end
    local trollPlayerID = -1
    local sumChance = 0
    if #wannabeTrollIDs > 0 then
        if #GameRules.BonusTrollIDs > 0 then
            DebugPrint("Count Donate: " .. #GameRules.BonusTrollIDs)
            table.sort(GameRules.BonusTrollIDs, mySort)
            for _, bonus in ipairs(GameRules.BonusTrollIDs) do
                local playerID, chance = unpack(bonus)
                for j = 1, #wannabeTrollIDs do
                    if playerID == wannabeTrollIDs[j] then
                        table.insert(donateTroll, {playerID, chance})
                        sumChance = sumChance + tonumber(chance)
                    end
                end
            end
            if #donateTroll > 1 then
                table.sort(donateTroll, mySort)
                sumChance = sumChance/100
                local roll_chance = RandomFloat(0, 100)
                local check_chance_max = 0
                local check_chance_min = 0
                for _, bonus in ipairs(donateTroll) do
                    local playerID, chance = unpack(bonus)
                    check_chance_max = check_chance_max + (tonumber(chance)/sumChance)
                    if chance == 100 then
                        trollPlayerID = playerID
                        break
                    end
                    if check_chance_max > roll_chance and check_chance_min <= roll_chance then
                        trollPlayerID = playerID
                        break
                    else 
                        check_chance_min = check_chance_max  
                    end
                end
            elseif #donateTroll == 1 then 
                for _, donate in ipairs(donateTroll) do
                    local playerID, chance = unpack(donate)
                    trollPlayerID = playerID
                end
            end
        end
        if #wannabeTrollIDs > 0 and (trollPlayerID == -1 or trollPlayerID == nil) then
            trollPlayerID = wannabeTrollIDs[math.random(#wannabeTrollIDs)]
            if PlayerResource:GetConnectionState(trollPlayerID) ~= 2 then
                trollPlayerID = allPlayersIDs[math.random(#allPlayersIDs)]
            end
        end
        else
        trollPlayerID = allPlayersIDs[math.random(#allPlayersIDs)]
        if PlayerResource:GetConnectionState(trollPlayerID) ~= 2 then
            trollPlayerID = allPlayersIDs[math.random(#allPlayersIDs)]
        end
    end
    
    if not GameRules.test then
        PlayerResource:SetCustomTeamAssignment(trollPlayerID, DOTA_TEAM_BADGUYS)
        PlayerResource:SetSelectedHero(trollPlayerID, TROLL_HERO[1])
    end
    local elfCount = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
    for i = 1, elfCount do
        local pID = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS, i)
        PlayerResource:SetSelectedHero(pID, ELF_HERO)
        if GameRules.colorCounter <= #PLAYER_COLORS then
            local color = PLAYER_COLORS[GameRules.colorCounter]
            PlayerResource:SetCustomPlayerColor(pID, color[1], color[2], color[3])
            GameRules.colorCounter = GameRules.colorCounter + 1
        end
    end
end

function trollnelves2:OnHeroInGame(hero)
 --   DebugPrint("OnHeroInGame")
    if hero:GetUnitName() == "npc_dota_hero_templar_assassin" then
        return false
    end

    if hero:GetUnitName() == "npc_dota_hero_wisp" then
        local abil = hero:FindAbilityByName("dummy_passive")
        abil:SetLevel(abil:GetMaxLevel())
        PlayerResource:SetGold(hero, 0)
        PlayerResource:SetLumber(hero, 0)
        return false
    end 
    
    
    local team = hero:GetTeamNumber()
    InitializeHero(hero)
    if team == DOTA_TEAM_BADGUYS then InitializeBadHero(hero) end
    
    if hero:IsElf() then
        InitializeBuilder(hero)
        elseif hero:IsTroll() then
        InitializeTroll(hero)
        elseif hero:IsWolf() then
        InitializeWolf(hero)
    end
end



function InitializeHero(hero)
    DebugPrint("Initialize hero")
    PlayerResource:SetGold(hero, 0)
    PlayerResource:SetLumber(hero, 0)
    local playerID = hero:GetPlayerOwnerID()
    if not GameRules.startTime then
        hero:AddNewModifier(nil, nil, "modifier_stunned", nil)
    end
        if hero == nil then
            return nil
        end
        if GameRules.scores[hero:GetPlayerOwnerID()] == nil then
            GameRules.scores[hero:GetPlayerOwnerID()] = {elf = 0, troll = 0}
			GameRules.scores[hero:GetPlayerOwnerID()].elf = 0
			GameRules.scores[hero:GetPlayerOwnerID()].troll = 0
        end

        local point = tonumber(GameRules.scores[hero:GetPlayerOwnerID()].elf or 0) + tonumber(GameRules.scores[hero:GetPlayerOwnerID()].troll or 0) 
        if hero ~= nil then
            if point > 0 then 
                hero:AddExperience(point, DOTA_ModifyXP_Unspecified, false,false)
            end
        end
    hero:ClearInventory()
    -- Learn all abilities (this isn't necessary on creatures)
    
    if hero:IsElf() then
        -- Learn all abilities (this isn't necessary on creatures)
        for i = 0, hero:GetAbilityCount() - 1 do
            local ability = hero:GetAbilityByIndex(i)
            if ability then ability:SetLevel(ability:GetMaxLevel()) end
        end
        hero:SetAbilityPoints(0)
        hero:SetStashEnabled(false)
    end
    
    hero:SetDeathXP(0)
    PlayerResource:NewSelection(hero:GetPlayerOwnerID(), PlayerResource:GetSelectedHeroEntity(hero:GetPlayerOwnerID()))

end

function InitializeBadHero(hero)
    DebugPrint("Initialize bad hero")
    local playerID = hero:GetPlayerOwnerID()
    local status, nextCall = Error_debug.ErrorCheck(function() 
        hero.hpReg = 0
        hero.hpRegDebuff = 0
        Timers:CreateTimer(function()
            if hero:IsNull() then return end
            local rate = FrameTime()
            local fullHpReg = math.max(hero.hpReg - hero.hpRegDebuff, 0)
            if fullHpReg > 0 and hero:IsAlive() then
                local optimalRate = 1 / fullHpReg
                rate = optimalRate > rate and optimalRate or rate
                local ratedHpReg = fullHpReg * rate
                hero:SetHealth(hero:GetHealth() + ratedHpReg)
            end
            return rate
        end)
    end)
    local units = Entities:FindAllByClassname("npc_dota_creature")
    for _, unit in pairs(units) do
        local unit_name = unit:GetUnitName();
        if string.match(unit_name, "shop") or string.match(unit_name, "troll_hut") then
           --unit:SetControllableByPlayer(playerID, true)
        end
    end
    -- Give small flying vision around hero to see elf walls/rocks on highground
    Timers:CreateTimer(function()
        if not hero or hero:IsNull() then return end
        if hero:IsAlive() then
            AddFOWViewer(hero:GetTeamNumber(), hero:GetAbsOrigin(), 370, 0.1,
            false)
        end
        return 0.1
    end)
    if PlayerResource:GetSelectedHeroName(playerID) ~= "npc_dota_hero_wisp" then
        local abil2 = hero:FindAbilityByName("reveal_area")
        abil2:SetLevel(abil2:GetMaxLevel())
        abil2 = hero:FindAbilityByName("deniable")
        if abil2 then
            abil2:SetLevel(abil2:GetMaxLevel())
        end
        --abil2:SetLevel(abil2:GetMaxLevel())
        --abil2 = hero:FindAbilityByName("attribute_antibonuses")
        --abil2:SetLevel(abil2:GetMaxLevel())
        hero:SetBaseManaRegen(0.1)
        hero:HeroLevelUp(false)
        hero:HeroLevelUp(false)
        hero:CalculateStatBonus(true)
        GameRules.maxFood[playerID] = STARTING_MAX_FOOD
        hero.food = 0
        PlayerResource:ModifyFood(hero, 0)
        -- hero:AddNewModifier(hero, nil, "modifier_anti_hp_mana_regen", {})
        hero:AddNewModifier(hero, nil, "modifier_max_attackspeed", {})
        
        hero:AddItemByName("item_tpscroll_troll")
        --hero:AddItemByName("item_tpscroll_troll")
    end
    --hero:SetStashEnabled(false)
end

function InitializeBuilder(hero)
    DebugPrint("Initialize builder")
    local playerID = hero:GetPlayerOwnerID()
    GameRules.maxFood[playerID] = STARTING_MAX_FOOD
    hero.food = 0
    hero.wisp = 0
    hero.mine = 0
    hero.alive = true
    hero.units = {}
    hero.disabledBuildings = {}
    hero.buildings = {} -- This keeps the name and quantity of each building
    for _, buildingName in ipairs(GameRules.buildingNames) do
        hero.buildings[buildingName] = {
            startedConstructionCount = 0,
            completedConstructionCount = 0
        }
    end
    hero:SetRespawnsDisabled(true)
    
    --hero:AddItemByName("item_root_ability")
    --hero:AddItemByName("item_silence_ability")
    hero:AddItemByName("item_glyph_ability")
    --hero:AddItemByName("item_night_ability")
    hero:AddItemByName("item_blink_datadriven")
    hero:AddItemByName("item_full")
    hero:AddItemByName("item_full")
    hero:AddItemByName("item_full")
    hero:AddItemByName("item_full")



    
    if GameRules.MapSpeed == 4 then
        hero:AddItemByName("item_max_move")
    end
    hero.goldPerSecond = 0
    hero.lumberPerSecond = 0
    Timers:CreateTimer(function()
        if hero:IsNull() then return end
        PlayerResource:ModifyGold(hero, hero.goldPerSecond)
        PlayerResource:ModifyLumber(hero, hero.lumberPerSecond)
        return 1
    end)
    
    UpdateSpells(hero)
    PlayerResource:SetGold(hero, ELF_STARTING_GOLD)
    PlayerResource:SetLumber(hero, ELF_STARTING_LUMBER)
    PlayerResource:ModifyFood(hero, 0)
    PlayerResource:ModifyMine(hero, 0)
    hero:SetStashEnabled(false) 
    hero:CalculateStatBonus(true)
    local units = Entities:FindAllByClassname("npc_dota_creature")
    for _, unit in pairs(units) do
        local unit_name = unit:GetUnitName();
        if string.match(unit_name, "elf_shp") then
           -- unit:SetControllableByPlayer(playerID, true)
            unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
            unit:AddNewModifier(unit, nil, "modifier_phased", {})
        end
    end
    --hero:SetMaximumGoldBounty(0)
    --hero:SetMinimumGoldBounty(0)
    --hero:SetBountyGain(0)
end

function InitializeTroll(hero)
    local playerID = hero:GetPlayerOwnerID()
    DebugPrint("Initialize troll, playerID: ", playerID)
    GameRules.trollHero = hero
    GameRules.trollID = playerID
    
    hero.units = {}
    hero.disabledBuildings = {}
    hero.buildings = {} -- This keeps the name and quantity of each building
    hero.buildings["troll_hut_1"] = {
        startedConstructionCount = 0,
        completedConstructionCount = 0
    }
    hero.buildings["troll_hut_2"] = {
        startedConstructionCount = 0,
        completedConstructionCount = 0
    }
    hero.buildings["troll_hut_3"] = {
        startedConstructionCount = 0,
        completedConstructionCount = 0
    }
    hero.buildings["troll_hut_4"] = {
        startedConstructionCount = 0,
        completedConstructionCount = 0
    }
    hero.buildings["troll_hut_5"] = {
        startedConstructionCount = 0,
        completedConstructionCount = 0
    }
    hero.buildings["troll_hut_6"] = {
        startedConstructionCount = 0,
        completedConstructionCount = 0
    }
    hero.buildings["troll_hut_7"] = {
        startedConstructionCount = 0,
        completedConstructionCount = 0
    }
    -- hero:AddAbility("special_bonus_cooldown_reduction_50"):SetLevel(1)
    if GameRules.MapSpeed == 1 and not string.match(GetMapName(),"clanwars")  then
        hero:RemoveAbility("special_bonus_cooldown_reduction_50")
        hero:RemoveAbility("special_bonus_cooldown_reduction_30")
    elseif GameRules.MapSpeed == 2 then
        hero:RemoveAbility("special_bonus_cooldown_reduction_30")
        hero:AddNewModifier(hero, nil, "modifier_movespeed_x2", {})
    elseif GameRules.MapSpeed >= 4 and not string.match(GetMapName(),"clanwars") then
        hero:AddNewModifier(hero, nil, "modifier_movespeed_x4", {})
    end
    
    if string.match(GetMapName(),"clanwars") and GameRules.MapSpeed == 1 then
        hero:RemoveAbility("special_bonus_cooldown_reduction_50") 
        hero:AddNewModifier(hero, nil, "modifier_movespeed_x2", {})
    elseif string.match(GetMapName(),"clanwars") and GameRules.MapSpeed == 4 then
        hero:AddNewModifier(hero, nil, "modifier_movespeed_x4", {})
    end

    --if not string.match(GetMapName(),"halloween") then 
    --    hero:RemoveAbility("skeleton_king_hellfire_blast_datadriven")
    --end
    if GameRules.test2 == false then
        hero:RemoveAbility("lone_druid_spirit_bear_datadriven")
    end
    local units = Entities:FindAllByClassname("npc_dota_creature")
    for _, unit in pairs(units) do
        local unit_name = unit:GetUnitName();
        if string.match(unit_name, "shop") or
            string.match(unit_name, "troll_hut") then
            --unit:SetOwner(hero)
            --unit:SetControllableByPlayer(playerID, true)
            
            
            unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
            unit:AddNewModifier(unit, nil, "modifier_phased", {})
            if string.match(unit_name, "troll_hut") then
                unit.ancestors = {}
                ModifyStartedConstructionBuildingCount(hero, unit_name, 1)
                ModifyCompletedConstructionBuildingCount(hero, unit_name, 1)
                BuildingHelper:AddModifierBuilding(unit)
                BuildingHelper:BlockGridSquares(GetUnitKV(unit_name, "ConstructionSize"), 0, unit:GetAbsOrigin())
            end
        elseif string.match(unit_name, "npc_dota_units_base2") then
            unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
            unit:AddNewModifier(unit, nil, "modifier_phased", {})
        end
    end
    if GameRules.test2 then
        hero:AddItemByName("item_dmg_12")
        hero:AddItemByName("item_armor_12")
        hero:AddItemByName("item_hp_12")
        hero:AddItemByName("item_hp_reg_12")
        hero:AddItemByName("item_atk_spd_6")
        hero:AddItemByName("item_disable_repair_2")
        hero:AddItemByName("item_disable_repair")
    end
    hero:SetStashEnabled(false)
    hero:CalculateStatBonus(true)
end

function InitializeAngel(hero)
    DebugPrint("Initialize angel")
    hero:AddItemByName("item_blink_datadriven")
    hero:CalculateStatBonus(true)
end

function InitializeWolf(hero)
    local playerID = hero:GetPlayerOwnerID()
    DebugPrint("Initialize wolf, playerID: " .. playerID)
    -- DebugPrint("GameRules.trollID: " .. GameRules.trollID)
    local koeff = 1
    if (GameRules:GetGameTime() - GameRules.startTime) <= 600 then
        koeff = 2
    end
    local trollNetworth = math.floor(GameRules.trollHero:GetNetworth()/koeff)
    local lumber = trollNetworth / 64000 * WOLF_STARTING_RESOURCES_FRACTION
    local gold = math.floor((lumber - math.floor(lumber)) * 64000)
    lumber = math.floor(lumber)
    
    PlayerResource:SetGold(hero, math.floor(gold))
    PlayerResource:SetLumber(hero, math.floor(lumber))
    hero:CalculateStatBonus(true)
    PlayerResource:SetUnitShareMaskForPlayer(GameRules.shopTroll:GetPlayerID(), playerID, 2, true)
end

function trollnelves2:PreStart()
   -- StartCreatingMinimapBuildings()
    local gameStartTimer = PRE_GAME_TIME
    Timers:CreateTimer(function()
        if gameStartTimer > 0 then
            Notifications:ClearBottomFromAll()
            Notifications:BottomToAll({
                text = "Game starts in " .. gameStartTimer,
                style = {color = '#E62020'},
                duration = 1
            })
            gameStartTimer = gameStartTimer - 1
            if GameRules.trollHero ~= nil then
                PlayerResource:SetGold(GameRules.trollHero , 0)
            end
            return 1
        else
            if GameRules.trollHero or GameRules.test then
                Notifications:ClearBottomFromAll()
                Notifications:BottomToAll(
                    {
                        text = "Game started!",
                        style = {color = '#E62020'},
                        duration = 1
                    })
                    GameRules.startTime = GameRules:GetGameTime()
                    if IsServer() then
                        SlayerPool()
                        BuffGold()
                        FakeHeroTroll()
                        FakeHeroElf()
                        FirstGold()
                    end
                    -- Unstun the elves
                    local elfCount = PlayerResource:GetPlayerCountForTeam(
                    DOTA_TEAM_GOODGUYS)
                    for i = 1, elfCount do
                        local pID = PlayerResource:GetNthPlayerIDOnTeam(
                        DOTA_TEAM_GOODGUYS, i)
                        local playerHero = PlayerResource:GetSelectedHeroEntity(pID)
                        if playerHero then
                            playerHero:RemoveModifierByName("modifier_stunned")
                        end
                    end
                    
                    local trollSpawnTimer = TROLL_SPAWN_TIME
                    local trollHero = GameRules.trollHero
                    trollHero:AddNewModifier(nil, nil, "modifier_stunned",
                    {duration = trollSpawnTimer})
                    
                    Timers:CreateTimer(function()
                        if trollSpawnTimer > 0 then
                            Notifications:ClearBottomFromAll()
                            Notifications:BottomToAll(
                                {
                                    text = "Troll spawns in " .. trollSpawnTimer,
                                    style = {color = '#E62020'},
                                    duration = 1
                                })
                                trollSpawnTimer = trollSpawnTimer - 1
                                PlayerResource:SetGold(trollHero, TROLL_STARTING_GOLD)
                                return 1.0
                        end
                    end)
                    else
                    Notifications:ClearBottomFromAll()
                    Notifications:BottomToAll(
                        {
                            text = "Troll hasn't spawned yet!Resetting!",
                            style = {color = '#E62020'},
                            duration = 1
                        })
                        gameStartTimer = 3
                        return 1.0
            end
        end
    end)
    
    if IsServer() then
        Timers:CreateTimer(25, function() wearables:SetPart() end)
        Timers:CreateTimer(45, function() wearables:SetSkin() end)
        Timers:CreateTimer(35, function() SelectPets:SetPets() end)
        GameRules:SendCustomMessage("<font color='#00FFFF '> Number of players: " .. GameRules.PlayersCount .. "</font>" ,  0, 0)
    end 
end

function StartCreatingMinimapBuildings()
    Timers:CreateTimer(0.3, function()
        if GameRules:State_Get() > DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
            return
        end
        -- Create minimap entities for buildings that are visible and don't already have a minimap entity
        local allEntities = Entities:FindAllByClassname("npc_dota_creature")
        for _, unit in pairs(allEntities) do
            if not unit:IsNull() and IsCustomBuilding(unit) and not unit.minimapEntity and unit:GetTeamNumber() ~= DOTA_TEAM_BADGUYS and IsLocationVisible(DOTA_TEAM_BADGUYS, unit:GetAbsOrigin()) then
                unit.minimapEntity = CreateUnitByName("minimap_entity", unit:GetAbsOrigin(), false, unit:GetOwner(), unit:GetOwner(), unit:GetTeamNumber())
                unit.minimapEntity:AddNewModifier(unit.minimapEntity, nil, "modifier_minimap", {})
                unit.minimapEntity.correspondingEntity = unit
            end
        end
        -- Kill minimap entities of dead buildings when location is scouted
        local minimapEntities = Entities:FindAllByClassname("npc_dota_building")
        for k, minimapEntity in pairs(minimapEntities) do
            if not minimapEntity:IsNull() and minimapEntity.correspondingEntity == "dead" and IsLocationVisible(DOTA_TEAM_BADGUYS, minimapEntity:GetAbsOrigin()) then
                minimapEntity.correspondingEntity = nil
                minimapEntity:ForceKill(false)
                UTIL_Remove(minimapEntity)
            end
        end
        return 0.3
    end)
end

-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function trollnelves2:Inittrollnelves2()
    trollnelves2 = self
    DebugPrint('[TROLLNELVES2] Starting to load trollnelves2 trollnelves2...')
    trollnelves2:_Inittrollnelves2()
    DebugPrint('[TROLLNELVES2] Done loading trollnelves2 trollnelves2!\n\n')
end

function SetResourceValues()
    for pID = 0, DOTA_MAX_PLAYERS do
        if PlayerResource:IsValidPlayer(pID) then
            if GameRules.startTime == nil then
                GameRules.startTime = 1
            end
            CustomNetTables:SetTableValue("resources",
                tostring(pID) .. "_resource_stats", {
                    gold = PlayerResource:GetGold(pID),
                    lumber = PlayerResource:GetLumber(pID),
                    goldGained = PlayerResource:GetGoldGained(pID),
                    lumberGained = PlayerResource:GetLumberGained(pID),
                    goldGiven = PlayerResource:GetGoldGiven(pID),
                    lumberGiven = PlayerResource:GetLumberGiven(pID),
                    timePassed = GameRules:GetGameTime() - GameRules.startTime,
                    PlayerChangeScore = GameRules.Score[pID]
                })
        end
    end
end

function GetModifiedName(orgName)
    for i = 1, #TROLL_HERO do
        if string.match(orgName, TROLL_HERO[i]) then
            return "<font color='#FF0000'>The Mighty Vampire</font>"
        end
    end
        if string.match(orgName, ELF_HERO) then
        return "<font color='#00CC00'>Human</font>"
        elseif string.match(orgName, WOLF_HERO) then
        return "<font color='#800000'>Wolf</font>"
        else
        return "?"
    end
end

function SellItem(args)
    local item = EntIndexToHScript(args.itemIndex)
    if item then
        if not item:IsSellable() then
            SendErrorMessage(issuerID, "error_item_not_sellable")
        end
        local gold_cost = item:GetSpecialValueFor("gold_cost")
        local lumber_cost = item:GetSpecialValueFor("lumber_cost")
        local hero = item:GetCaster()
        UTIL_Remove(item)
        PlayerResource:ModifyGold(hero, math.floor(gold_cost/2), true)
        PlayerResource:ModifyLumber(hero, math.floor(lumber_cost/2), true)
        local player = hero:GetPlayerOwner()

        EmitSoundOnEntityForPlayer("DOTA_Item.Hand_Of_Midas", hero, hero:GetPlayerOwnerID())
    end
    
end

function UpdateSpells(unit)
    local playerID = unit:GetPlayerOwnerID()
    local hero = unit
    for a = 0, unit:GetAbilityCount() - 1 do
        local tempAbility = unit:GetAbilityByIndex(a)
        if tempAbility then
            local abilityKV = GetAbilityKV(tempAbility:GetAbilityName());
            local bIsBuilding = abilityKV and abilityKV.Building or 0
            if bIsBuilding == 1 then
                local buildingName = abilityKV.UnitName
                DisableAbilityIfMissingRequirements(playerID, hero, tempAbility, buildingName)
            end
        end
    end
    for _, value in ipairs(hero.units) do
        if string.match(value:GetUnitName(), "build_worker")  then
            for a = 0, value:GetAbilityCount() - 1 do
                local tempAbility = value:GetAbilityByIndex(a)
                if tempAbility then
                    local abilityKV = GetAbilityKV(tempAbility:GetAbilityName());
                    local bIsBuilding = abilityKV and abilityKV.Building or 0
                    if bIsBuilding == 1 then
                        local buildingName = abilityKV.UnitName
                        DisableAbilityIfMissingRequirements(playerID, hero, tempAbility, buildingName)
                    end
                end
            end
        end
    end
end





function UpdateUpgrades(building)
    if not building or building:IsNull() then return end
    
    local playerID = building:GetPlayerOwnerID()
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    for a = 0, building:GetAbilityCount() - 1 do
        local ability = building:GetAbilityByIndex(a)
        if ability and ability.upgradedUnitName then
            DisableAbilityIfMissingRequirements(playerID, hero, ability,
            ability.upgradedUnitName)
        end
    end
end

function AddUpgradeAbilities(building)
    if not building or building:IsNull() then return end
    
    local upgrades = GetUnitKV(building:GetUnitName()).Upgrades
    if upgrades and upgrades.Count then
        local playerID = building:GetPlayerOwnerID()
        local hero = PlayerResource:GetSelectedHeroEntity(playerID)
        local abilities = {}
        for a = 0, building:GetAbilityCount() - 1 do
            local tempAbility = building:GetAbilityByIndex(a)
            if tempAbility then
                table.insert(abilities, {tempAbility:GetAbilityName(), tempAbility:GetLevel()})
                building:RemoveAbility(tempAbility:GetAbilityName())
            end
        end
        
        local count = tonumber(upgrades.Count)
        for i = 1, count, 1 do
            local upgrade = upgrades[tostring(i)]
            local upgradedUnitName = upgrade.unit_name
            
            local abilityName = "upgrade_to_" .. upgradedUnitName
            local upgradeAbility = building:AddAbility(abilityName)
            upgradeAbility.upgradedUnitName = upgradedUnitName
            
            DisableAbilityIfMissingRequirements(playerID, hero, upgradeAbility, upgradedUnitName)
        end
        for _, ability in ipairs(abilities) do
            local abilityName, abilityLevel = unpack(ability)
            if not string.match(abilityName, "upgrade_to") then
                local abilityHandle = building:AddAbility(abilityName)
                abilityHandle:SetLevel(abilityLevel)
            end
        end
    end
end

function DisableAbilityIfMissingRequirements(playerID, hero, abilityHandle, unitName)
    local missingRequirements = {}
    local disableAbility = false
    local requirements = GameRules.buildingRequirements[unitName]
    if string.match(unitName,"troll_hut") then
        hero = GameRules.trollHero
    end
    if requirements then
        for _, requiredUnitName in ipairs(requirements) do
            local requiredBuildingCurrentCount = hero.buildings[requiredUnitName].completedConstructionCount
            if requiredBuildingCurrentCount < 1 then
                table.insert(missingRequirements, requiredUnitName)
                disableAbility = true
            end
        end
    end
    CustomNetTables:SetTableValue("buildings", playerID .. unitName, missingRequirements)
    
    local limit = GetUnitKV(unitName, "Limit")
    if limit ~= nil then
        local currentCount = hero.buildings[unitName].startedConstructionCount
        if currentCount >= limit then disableAbility = true end
    end
    
    
    
    if disableAbility and not GameRules.test2 then
        abilityHandle:SetLevel(0)
        hero.disabledBuildings[unitName] = true
    else
        abilityHandle:SetLevel(1)
        hero.disabledBuildings[unitName] = false
    end
end

function GetClass(unitName)
    if string.match(unitName, "rock") or string.match(unitName, "wall") then
        return "wall"
        elseif string.match(unitName, "buff") then
        return "buff"
        elseif string.match(unitName, "tower") then
        return "tower"
        elseif string.match(unitName, "tent") or string.match(unitName, "barrack") then
        return "tent"
        elseif string.match(unitName, "trader") then
        return "trader"
        elseif string.match(unitName, "workersguild") then
        return "workersguild"
        elseif string.match(unitName, "mother_of_nature") then
        return "mother_of_nature"
        elseif string.match(unitName, "research_lab") then
        return "research_lab"
        elseif string.match(unitName, "slayerstaverna") then
        return "slayerstaverna"
        elseif string.match(unitName, "house") then
        return "house"
        elseif string.match(unitName, "gold_mine") then
        return "gold_mine"
        elseif string.match(unitName, "base_twr") then
        return "base_twr"
    end
end

function SlayerPool()
    Timers:CreateTimer(function()
        for pID=0,DOTA_MAX_TEAM_PLAYERS do
            if PlayerResource:IsValidPlayerID(pID) then
                local hero = PlayerResource:GetSelectedHeroEntity(pID)
                if hero then
                    local team = hero:GetTeamNumber()
                    if team ~= nil then
                        if team == DOTA_TEAM_GOODGUYS and hero.slayer ~= nil then
                            for index, shopTrigger in ipairs(GameRules.slayerUP) do
                                if shopTrigger:IsTouching(hero.slayer) then
                                    hero.slayer:HeroLevelUp(true)
                                end
                            end
                        end
                    end
                end
            end
        end
    return 60 end)
end
local countBuffGold = 1
function BuffGold()
    Timers:CreateTimer(BUFF_GOLD_TIME, function()
        for pID=0,DOTA_MAX_TEAM_PLAYERS do
            if PlayerResource:IsValidPlayerID(pID) then
                local hero = PlayerResource:GetSelectedHeroEntity(pID)
                if hero then
                    local team = hero:GetTeamNumber()
                    if team ~= nil then
                        if team == DOTA_TEAM_BADGUYS then
                            PlayerResource:ModifyGold(hero, BUFF_GOLD_SUM_TROLL[countBuffGold], true) 
                        else
                            PlayerResource:ModifyGold(hero, BUFF_GOLD_SUM_ELF[countBuffGold], true) 
                        end
                    end
                end
            end
        end
        if countBuffGold <= 10 then
            countBuffGold = countBuffGold + 1
        else
            countBuffGold = 10
        end
        GameRules:SendCustomMessage("<font color='#009900'>HUMAN</font> got "..BUFF_GOLD_SUM_ELF[countBuffGold].." gold", 0, 0)
        GameRules:SendCustomMessage("<font color='#9A2E00'>VAMPIRE</font> got "..BUFF_GOLD_SUM_TROLL[countBuffGold].." gold", 0, 0)     
    return BUFF_GOLD_TIME end)
end

function FirstGold()
    Timers:CreateTimer(180, function()
        for pID=0,DOTA_MAX_TEAM_PLAYERS do
            if PlayerResource:IsValidPlayerID(pID) then
                local hero = PlayerResource:GetSelectedHeroEntity(pID)
                if hero then
                    local team = hero:GetTeamNumber()
                    if team ~= nil then
                        if team == DOTA_TEAM_GOODGUYS then
                            PlayerResource:ModifyGold(hero, 1, true) 
                        end
                    end
                end
            end
        end
        GameRules:SendCustomMessage("<font color='#009900'>HUMAN</font> got 1 gold", 0, 0)  
    end)
end

function FakeHeroTroll()
    --local hero = CreateUnitByName("npc_dota_hero_omniknight", Vector(0,0,0) , true, nil, nil, DOTA_TEAM_GOODGUYS)
   --local hero = CreateHeroForPlayer("npc_dota_hero_night_stalker", nil)
    GameRules.shopTroll = GameRules:AddBotPlayerWithEntityScript("npc_dota_hero_wisp", "SHOP-VAMPIRE", DOTA_TEAM_BADGUYS, "", true)
    local units = Entities:FindAllByClassname("npc_dota_creature")
    for _, unit in pairs(units) do
        local unit_name = unit:GetUnitName();
        if string.match(unit_name, "elf_shp") or string.match(unit_name, "shop") or string.match(unit_name, "troll_hut") then
            unit:SetControllableByPlayer(GameRules.shopTroll:GetPlayerOwnerID(), true)
            unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
            unit:AddNewModifier(unit, nil, "modifier_phased", {})

            if unit_name == "basic_shop_troll" then
                local abil = unit:FindAbilityByName("buy_item_armor_1")
                abil:StartCooldown(300)
                abil = unit:FindAbilityByName("buy_item_armor_2")
                abil:StartCooldown(300)
                abil = unit:FindAbilityByName("buy_item_armor_3")
                abil:StartCooldown(300)
                abil = unit:FindAbilityByName("buy_item_armor_4")
                abil:StartCooldown(300)
                
            elseif unit_name == "blood_shop_troll" then
                local abil = unit:FindAbilityByName("buy_item_gold_blade")
                abil:StartCooldown(1000)
                abil = unit:FindAbilityByName("buy_item_gold_staff")
                abil:StartCooldown(480)
                
            elseif unit_name == "black_shop_troll" then
                local abil = unit:FindAbilityByName("buy_item_burst_gem")
                abil:StartCooldown(300)
            elseif unit_name == "demonic_shop_troll" then
                local abil = unit:FindAbilityByName("buy_item_demonic_remains")
                abil:StartCooldown(360)
                abil = unit:FindAbilityByName("sell_lumber_1")
                abil:StartCooldown(180)
                abil = unit:FindAbilityByName("sell_lumber_8")
                abil:StartCooldown(180)
            elseif unit_name == "gate_shop_troll" then
                for i = 0, unit:GetAbilityCount() - 1 do
                    local ability = unit:GetAbilityByIndex(i)
                    if ability then 
                        ability:StartCooldown(600)
                    end
                end
            elseif unit_name == "recipe_shop_troll" then
                local abil = unit:FindAbilityByName("buy_item_recipe_end_game")
                abil:StartCooldown(1023)
            end

        end
    end
    for pID=0,DOTA_MAX_TEAM_PLAYERS do
        if PlayerResource:IsValidPlayerID(pID) and GameRules.shopTroll:GetPlayerID() ~= pID then
            PlayerResource:SetUnitShareMaskForPlayer(GameRules.shopTroll:GetPlayerID(), pID, 2, true)
        end
    end 
    
   --GameRules:RemoveFakeClient(hero:GetPlayerOwnerID())
   --UTIL_Remove(hero) 
end

function FakeHeroElf()
    --local hero = CreateUnitByName("npc_dota_hero_omniknight", Vector(0,0,0) , true, nil, nil, DOTA_TEAM_GOODGUYS)
   --local hero = CreateHeroForPlayer("npc_dota_hero_night_stalker", nil)
    GameRules.shopElf = GameRules:AddBotPlayerWithEntityScript("npc_dota_hero_wisp", "SHOP-HUMAN", DOTA_TEAM_GOODGUYS, "", true)
    local units = Entities:FindAllByClassname("npc_dota_creature")
    for _, unit in pairs(units) do
        local unit_name = unit:GetUnitName();
        if string.match(unit_name, "elf_shp") then
            unit:SetControllableByPlayer(GameRules.shopElf:GetPlayerOwnerID(), true)
            unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
            unit:AddNewModifier(unit, nil, "modifier_phased", {})
            if unit_name == "elf_shp_1" then
                local abil = unit:FindAbilityByName("sell_lumber_1")
                abil:StartCooldown(180)
                abil = unit:FindAbilityByName("sell_lumber_8")
                abil:StartCooldown(180)
            elseif unit_name == "elf_shp_2" then
                local abil = unit:FindAbilityByName("buy_item_armor_1")
                abil:StartCooldown(300)
                abil = unit:FindAbilityByName("buy_item_armor_2")
                abil:StartCooldown(300)
                abil = unit:FindAbilityByName("buy_item_armor_3")
                abil:StartCooldown(300)
                abil = unit:FindAbilityByName("buy_item_armor_4")
                abil:StartCooldown(300) 
                abil = unit:FindAbilityByName("sell_lumber_1")
                abil:StartCooldown(180)
                abil = unit:FindAbilityByName("sell_lumber_8")
                abil:StartCooldown(180)  
            elseif unit_name == "elf_shp_3" then
                local abil = unit:FindAbilityByName("sell_lumber_1")
                abil:StartCooldown(180)
                abil = unit:FindAbilityByName("sell_lumber_8")
                abil:StartCooldown(180)
            end
        end
    end
    for pID=0,DOTA_MAX_TEAM_PLAYERS do
        if PlayerResource:IsValidPlayerID(pID) and GameRules.shopElf:GetPlayerID() ~= pID then
            PlayerResource:SetUnitShareMaskForPlayer(GameRules.shopElf:GetPlayerID(), pID, 2, true)
        end
    end 
    
   --GameRules:RemoveFakeClient(hero:GetPlayerOwnerID())
   --UTIL_Remove(hero) 
end
