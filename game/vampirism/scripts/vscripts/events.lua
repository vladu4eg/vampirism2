local lastSendTime = {}
local lastTakeGoldTime = {}
require('stats')
require('clanwars')
require('shop')
require('libraries/entity')
require('drop')
require('settings')
require('error_debug')

LinkLuaModifier("modifier_death_armor",
    "libraries/modifiers/modifier_death_armor.lua",
LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_death_mana",
    "libraries/modifiers/modifier_death_mana.lua",
LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_demonic_remains_killer",
    "modifiers/modifier_demonic_remains_killer.lua",
LUA_MODIFIER_MOTION_NONE)


function trollnelves2:OnGameRulesStateChange()
   -- DebugPrint("GameRulesStateChange ******************")
    local newState = GameRules:State_Get()
    if newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
        trollnelves2:GameSetup()
        trollnelves2:PostLoadPrecache()
        elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
        self:PreStart()
    end
end

-- An NPC has spawned somewhere in game.  This includes heroes
function trollnelves2:OnNPCSpawned(keys)
   -- DebugPrint("OnNPCSpawned:")
    local npc = EntIndexToHScript(keys.entindex)
    if npc.GetPhysicalArmorValue then
        npc:AddNewModifier(npc, nil, "modifier_custom_armor", {})
    end
    if npc:IsRealHero() and npc.bFirstSpawned == nil then
        THINK_INTERVAL = 2
        npc.bFirstSpawned = true
        if IsServer() then
            trollnelves2:OnHeroInGame(npc)
        end
    end

    if npc:IsRealHero() then
        local info = {}
        info.PlayerID = npc:GetPlayerID()
        info.hero = npc
        -- local rand = RandomInt(1, 2)
        -- if rand == 1 then
        	Pets.CreatePet( info )
		-- end
        --npc:SetCustomHealthLabel("top1autumn",  123, 11, 78)
    end
    if npc:IsWolf() then
        npc:AddNewModifier(npc, nil, "modifier_phased", {Duration = 1})
        ResolveNPCPositions(npc:GetAbsOrigin(),130)
    end
end

function trollnelves2:OnPlayerReconnect(event)
    local playerID = event.PlayerID
    -- local notSelectedHero = GameRules.disconnectedHeroSelects[playerID]
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    --if notSelectedHero then
    --    hero = PlayerResource:ReplaceHeroWith(playerID, notSelectedHero, 0, 0)   
   -- end

    if hero then
        -- Send info to client]
        UpdateSpells(hero)
        hero:SetAbilityPoints(0)
        PlayerResource:ModifyGold(hero, 0)
        PlayerResource:ModifyLumber(hero, 0)
        PlayerResource:ModifyFood(hero, 0)
        PlayerResource:ModifyMine(hero, 0)
        hero:CalculateStatBonus(true)
    end
end

function trollnelves2:OnDisconnect(event)
    local playerID = event.PlayerID
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    if hero == nil then
        return
    end
    local team = hero:GetTeamNumber()
    local trollLoseTimer = 300
    local elfLoseTimer = 180
    
    if team == DOTA_TEAM_GOODGUYS then
        if hero.alive == true then
            hero.alive = false
            hero.dced = true
            local lastAlive = true
            for i = 0, PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) do
                local pID = PlayerResource:GetNthPlayerIDOnTeam(2, i)
                local hero2 = PlayerResource:GetSelectedHeroEntity(pID) or false
                if hero2 and hero2.alive then
                    lastAlive = false
                    break
                end
            end
            if lastAlive then
                Timers:CreateTimer(function()
                    if elfLoseTimer > 0 and PlayerResource:GetConnectionState(hero:GetPlayerOwnerID()) ~= 2 and PlayerResource:GetConnectionState(hero:GetPlayerOwnerID()) ~= 4 then
                        Notifications:ClearBottomFromAll()
                        Notifications:BottomToAll(
                            {
                                text = "The Elf will lose in " .. elfLoseTimer,
                                style = {color = '#E62020'},
                                duration = 1
                            })
                            elfLoseTimer = elfLoseTimer - 1
                            return 1.0
                            elseif elfLoseTimer > 0 and PlayerResource:GetConnectionState(hero:GetPlayerOwnerID()) == 2 then
                            return nil
                            elseif elfLoseTimer <= 0 or PlayerResource:GetConnectionState(hero:GetPlayerOwnerID()) == 4 then
                            GameRules:SendCustomMessage("Please do not leave the game.", 1, 1)
                            local status, nextCall = Error_debug.ErrorCheck(function() 
                                Stats.SubmitMatchData(DOTA_TEAM_BADGUYS, callback) 
                            end)
                            GameRules:SendCustomMessage("The game can be left, thanks!", 1, 1)
                            return nil
                    end
                end)
            end
        end
    elseif team == DOTA_TEAM_BADGUYS then
        hero:MoveToPosition(Vector(0, 0, 0))            
    end
end

function trollnelves2:OnConnectFull(keys)
   -- DebugPrint("OnConnectFull ******************")
  --  local entIndex = keys.index + 1
    -- The Player entity of the joining user
  --  local player = EntIndexToHScript(entIndex)
  --  local userID = keys.userid
   -- GameRules.userIds = GameRules.userIds or {}
    -- The Player ID of the joining player
   -- local playerID = player:GetPlayerID()
   -- GameRules.userIds[userID] = playerID
    trollnelves2:_Capturetrollnelves2()
end

function trollnelves2:OnItemPickedUp(keys)
   -- print('[BAREBONES] OnItemPickedUp')
 --   DeepPrintTable(keys)
    local hero = PlayerResource:GetSelectedHeroEntity(keys.PlayerID)
    local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
    local heroEntity = EntIndexToHScript(keys.HeroEntityIndex)
    local player = PlayerResource:GetPlayer(keys.PlayerID)
    local itemname = keys.itemname
    
    if heroEntity:IsElf() and not string.match(itemname,"vip") and not string.match(itemname,"event") 
        and not string.match(itemname,"autumn") and not string.match(itemname,"spring") and not string.match(itemname,"winter")  
        and not string.match(itemname,"summer") and not string.match(itemname,"gold") and not string.match(itemname,"gem") then 
            heroEntity:RemoveItem(itemEntity)
        return
    end  
    itemEntity:SetPurchaser(heroEntity)
    --[[
    if hero:GetNumItemsInInventory() > 6 then
        local spawnPoint = hero:GetAbsOrigin() + RandomFloat(50, 100)
         local newItem = CreateItem(itemname, itemEntity:GetPurchaser(), itemEntity:GetPurchaser())
        local drop = CreateItemOnPositionForLaunch(spawnPoint, newItem)
        newItem:LaunchLootInitialHeight(false, 0, 150, 0.5, spawnPoint)
        hero:RemoveItem(itemEntity)
    end
    --]]
end

function trollnelves2:OnItemAddedInv(keys)
  --  print('[BAREBONES] OnItemAddedInv')
   -- DeepPrintTable(keys)
    local hero = EntIndexToHScript(keys.inventory_parent_entindex)
    local itemEntity = EntIndexToHScript(keys.item_entindex)
    local player = PlayerResource:GetPlayer(keys.inventory_player_id)
    local itemname = keys.itemname
    if hero ~= nil then
        if hero:IsElf() and not string.match(itemname,"vip") and not string.match(itemname,"event") 
        and not string.match(itemname,"autumn") and not string.match(itemname,"spring") and not string.match(itemname,"winter")  
        and not string.match(itemname,"summer") and not string.match(itemname,"gold") and not string.match(itemname,"gem") then 
            hero:RemoveItem(itemEntity)
            return
        end  
        if hero:GetNumItemsInInventory() > 6 then
            local spawnPoint = hero:GetAbsOrigin() + RandomFloat(50, 100)
            local newItem = CreateItem(itemname, itemEntity:GetPurchaser(), itemEntity:GetPurchaser())
            local drop = CreateItemOnPositionForLaunch(spawnPoint, newItem)
            newItem:LaunchLootInitialHeight(false, 0, 150, 0.5, spawnPoint)
            hero:RemoveItem(itemEntity)
        end
    end
end

--[[
	This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
	It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function trollnelves2:OnAllPlayersLoaded()
  --  DebugPrint("[TROLLNELVES2] All Players have loaded into the game")
    
end

function trollnelves2:OnEntityKilled(keys)
    local killed = EntIndexToHScript(keys.entindex_killed)
    local attacker = EntIndexToHScript(keys.entindex_attacker)
    local killedPlayerID = killed:GetPlayerOwnerID()
    local attackerPlayerID = attacker:GetPlayerOwnerID()
    if GameRules.Bonus[attackerPlayerID] == nil then
        GameRules.Bonus[attackerPlayerID] = 0
    end
    
    local info = {}
    info.PlayerID = killedPlayerID
    info.hero = killed
    
    if killed ~= nil and killedPlayerID ~= attackerPlayerID and attacker ~= nil then
        drop:RollItemDrop(killed)
    end

    if IsBuilder(killed) then BuildingHelper:ClearQueue(killed) end
    if killed:IsRealHero() then
        
        if killed:IsElf() and killed.alive then
            for pID = 0, DOTA_MAX_TEAM_PLAYERS do
                if PlayerResource:IsValidPlayerID(pID) then
                    if GameRules.PlayersBase[pID] == GameRules.PlayersBase[killedPlayerID] and pID ~= killedPlayerID then
                        GameRules.countFlag[pID] = nil
                    end
                end
            end

            GameRules.countFlag[killedPlayerID] = nil
            GameRules.PlayersBase[killedPlayerID] = nil

            ElfKilled(killed)
            GameRules.Bonus[attackerPlayerID] = GameRules.Bonus[attackerPlayerID] + 1
            if CheckTrollVictory() then
                for pID = 0, DOTA_MAX_TEAM_PLAYERS do
                    if PlayerResource:IsValidPlayerID(pID) then
                        PlayerResource:SetCameraTarget(pID, killed)
                    end
                end
                GameRules:SendCustomMessage("Please do not leave the game.", 1, 1)
                local status, nextCall = Error_debug.ErrorCheck(function() 
                        Stats.SubmitMatchData(DOTA_TEAM_BADGUYS, callback) 
                end)
                GameRules:SendCustomMessage("The game can be left, thanks!", 1, 1)
                return
            end
            Pets.DeletePet(info)
        elseif killed:IsTroll() then
            GameRules.Bonus[attackerPlayerID] = GameRules.Bonus[attackerPlayerID] + 2
            killed:SetTimeUntilRespawn(9999999)
            local endGame = 0
            for pID=0,DOTA_MAX_TEAM_PLAYERS do
                if PlayerResource:IsValidPlayerID(pID) then
                    local hero = PlayerResource:GetSelectedHeroEntity(pID)
                    if hero then
                        if hero:IsTroll() and hero:IsAlive() then
                            return        
                        end
                    end
                end
            end
            
            for pID = 0, DOTA_MAX_TEAM_PLAYERS do
                if PlayerResource:IsValidPlayerID(pID) then
                    PlayerResource:SetCameraTarget(pID, killed)
                end
            end
            GameRules:SendCustomMessage("Please do not leave the game.", 1, 1)
            local status, nextCall = Error_debug.ErrorCheck(function() 
                Stats.SubmitMatchData(DOTA_TEAM_GOODGUYS, callback)
            end)
            GameRules:SendCustomMessage("The game can be left, thanks!", 1, 1)
        elseif killed:IsWolf() then
            killed:SetRespawnPosition(Vector(0, -640, 256))
            killed:SetTimeUntilRespawn(9999999999)
            killed:RemoveDesol2()
            if PlayerResource:GetDeaths(killedPlayerID) == 2 then
                GameRules.Bonus[attackerPlayerID] = GameRules.Bonus[attackerPlayerID] + 1
            end
           Pets.DeletePet(info)
        end
        if killed:GetUnitName() == "npc_dota_hero_templar_assassin" then
            killed:SetRespawnsDisabled(true)
        end
        if attacker and attacker:HasModifier("modifier_item_demonic_remains") then
            if  not attacker:HasModifier("modifier_demonic_remains_killer") then
                attacker:AddNewModifier(attacker, nil, "modifier_demonic_remains_killer", {}):IncrementStackCount()
            else
                attacker:FindModifierByName("modifier_demonic_remains_killer"):IncrementStackCount()
            end
        end
    else
        local hero = PlayerResource:GetSelectedHeroEntity(killedPlayerID)
        if string.match(killed:GetUnitName(),"troll_hut") then
            hero = GameRules.trollHero
        end
        if killed:GetUnitName() == "tent" and killed.state == 'complete' then
            GameRules.maxFood[killedPlayerID] = GameRules.maxFood[killedPlayerID] - 50
            PlayerResource:ModifyFood(hero, 0)
        elseif killed:GetUnitName() == "tent_2" then
            GameRules.maxFood[killedPlayerID] = GameRules.maxFood[killedPlayerID] - 100
            PlayerResource:ModifyFood(hero, 0)
        elseif killed:GetUnitName() == "tent_3" then
            GameRules.maxFood[killedPlayerID] = GameRules.maxFood[killedPlayerID] - 300
            PlayerResource:ModifyFood(hero, 0)
        end

        if attacker and attacker:HasModifier("modifier_item_demonic_remains") then
            if  not attacker:HasModifier("modifier_demonic_remains_killer") then
                attacker:AddNewModifier(attacker, nil, "modifier_demonic_remains_killer", {}):IncrementStackCount()
            else
                attacker:FindModifierByName("modifier_demonic_remains_killer"):IncrementStackCount()
            end
        end
        
        if hero and hero.units and hero.alive then -- hero.units can contain other units besides buildings
            for i = #hero.units, 1, -1 do
                if not hero.units[i]:IsNull() then
                    if hero.units[i]:GetEntityIndex() == keys.entindex_killed then
                        table.remove(hero.units, i)
                        break
                    end
                end
            end
        end
        
        local unitTable = killed:GetKeyValue()
        local gridTable = unitTable and unitTable["Grid"]
        if IsCustomBuilding(killed) or gridTable then
            -- Building Helper grid cleanup
            BuildingHelper:RemoveBuilding(killed, false)
            
            if gridTable then
                for grid_type, v in pairs(gridTable) do
                    if tobool(v.RemoveOnDeath) then
                        local location = killed:GetAbsOrigin()
                       -- BuildingHelper:print("Clearing special grid of " .. grid_type)
                        if (v.Radius) then
                            BuildingHelper:RemoveGridType(v.Radius, location,
                            grid_type, "radius")
                            elseif (v.Square) then
                            BuildingHelper:RemoveGridType(v.Square, location,
                            grid_type)
                        end
                    end
                end
            end
            
            if hero then -- Skip looping unnecessarily when elf dies
                local name = killed:GetUnitName()
                ModifyStartedConstructionBuildingCount(hero, name, -1)
                if killed.state == "complete" then
                    ModifyCompletedConstructionBuildingCount(hero, name, -1)
                end
                if killed.ancestors then
                    for _, ancestorUnitName in pairs(killed.ancestors) do
                        if name ~= ancestorUnitName then
                            ModifyStartedConstructionBuildingCount(hero,
                                ancestorUnitName,
                            -1)
                            ModifyCompletedConstructionBuildingCount(hero,
                                ancestorUnitName,
                            -1)
                        end
                    end
                end
                for _, v in ipairs(hero.units) do
                    UpdateUpgrades(v)
                end
                UpdateSpells(hero)
                if string.match(GetMapName(),"clanwars") then
                    local elf = PlayerResource:GetSelectedHeroEntity(killedPlayerID)
                    local hero = PlayerResource:GetSelectedHeroEntity(attackerPlayerID) 
                    if (string.match(name, "tent") or string.match(name, "barracks")) and hero:IsTroll() then
                        ApplyDamage({victim = elf, attacker = hero, damage = 100, damage_type = DAMAGE_TYPE_PHYSICAL })    
                    end
                end 
                if name == "flag" then
                    local hero2 = PlayerResource:GetSelectedHeroEntity(killedPlayerID)
                    local abil2 = hero2:FindAbilityByName("build_flag")
                    abil2:EndCooldown()
                    abil2:StartCooldown(300) 
                    GameRules.PlayersBase[killedPlayerID] = nil
                    GameRules.countFlag[killedPlayerID] = nil
                end
            end
            elseif killed:GetKeyValue("FoodCost") then
            local foodCost = killed:GetKeyValue("FoodCost")
            PlayerResource:ModifyFood(hero, -foodCost)
            elseif killed:GetKeyValue("MineCost") then
            local mine = killed:GetKeyValue("MineCost")
            PlayerResource:ModifyMine(hero, -mine)
            
        end
    end
end

function ElfKilled(killed)
    local killedID = killed:GetPlayerOwnerID()
    killed.alive = false
    killed.legitChooser = true
    
    PlayerResource:SetGold(killed, 0)
    PlayerResource:SetLumber(killed, 0)
    
    for i = 1, #killed.units do
        if killed.units[i] and not killed.units[i]:IsNull() then
            local unit = killed.units[i]
            unit:ForceKill(false)
        end
    end
    
    PlayerResource:SetCameraTarget(killedID, GameRules.trollHero)
    Timers:CreateTimer(3, function()
        PlayerResource:SetCameraTarget(killedID, nil)
    end)
    
    local args = {}
    args.team = DOTA_TEAM_BADGUYS
    args.playerID = killedID
    ChooseHelpSide(killedID, args)

end

function CheckTrollVictory()
    for i = 1, PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) do
        local playerID = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS,
        i)
        local hero = PlayerResource:GetSelectedHeroEntity(playerID)
        if hero and hero.alive then return false end
    end
    return true
end

function GiveResources(eventSourceIndex, event)
   -- DebugPrint("Give resources, event source index: ", eventSourceIndex)
    local targetID = event.target
    local casterID = event.casterID
    local gold = math.floor(math.abs(tonumber(event.gold)))
    local lumber = math.floor(math.abs(tonumber(event.lumber)))
    if tonumber(event.gold) ~= nil and tonumber(event.lumber) ~= nil then
        if PlayerResource:GetSelectedHeroEntity(targetID) and
            PlayerResource:GetSelectedHeroEntity(targetID):GetTeam() ==
            PlayerResource:GetSelectedHeroEntity(casterID):GetTeam() then
            local hero = PlayerResource:GetSelectedHeroEntity(targetID)
            local casterHero = PlayerResource:GetSelectedHeroEntity(casterID)
            if gold and lumber then
                if PlayerResource:GetGold(casterID) < gold or
                    PlayerResource:GetLumber(casterID) < lumber then
                    SendErrorMessage(casterID, "error_not_enough_resources")
                    return
                end
                if event.target:IsTroll() then
                    SendErrorMessage(casterID, "error_not_send_money_vamp")
                end
                if ((lastSendTime[targetID] == nil or lastSendTime[targetID] + 300 < GameRules:GetGameTime())
                and (lastTakeGoldTime[casterID] == nil or lastTakeGoldTime[casterID] + 60 < GameRules:GetGameTime())) then
                    if gold > 99 or lumber > 1 then
                        PlayerResource:ModifyGold(casterHero, -gold, true)
                        PlayerResource:ModifyLumber(casterHero, -lumber, true)
                        PlayerResource:ModifyGold(hero, gold, true)
                        PlayerResource:ModifyLumber(hero, lumber, true)
                        PlayerResource:ModifyGoldGiven(targetID, -gold)
                        PlayerResource:ModifyLumberGiven(targetID, -lumber)
                        PlayerResource:ModifyGoldGiven(casterID, gold)
                        PlayerResource:ModifyLumberGiven(casterID, lumber)
                        local text = PlayerResource:GetPlayerName(casterHero:GetPlayerOwnerID()) .. "(" .. GetModifiedName(casterHero:GetUnitName()) .. ") has sent "
                        
                        if gold > 0 then
                            text = text .. "<font color='#F0BA36'>" .. gold .. "</font> gold"
                        end
                        
                        if gold > 0 and lumber > 0 then
                           text = text .. " and "
                        end
                        
                        if lumber > 0 then
                            text = text .. "<font color='#009900'>" .. lumber .. "</font> lumber"
                        end
                        text = text .. " to " .. PlayerResource:GetPlayerName(hero:GetPlayerOwnerID()) .. "(" .. GetModifiedName(hero:GetUnitName()) .. ")!"
                        GameRules:SendCustomMessageToTeam(text, casterHero:GetTeamNumber(), 0, 0)
                        if GameRules:GetGameTime() - GameRules.startTime < 2400 then
                            lastSendTime[targetID] = GameRules:GetGameTime()
                            lastTakeGoldTime[targetID] = GameRules:GetGameTime()
                        end  
                    else
                        SendErrorMessage(casterID, "#error_enter_need_money")
                    end
                    
                elseif lastSendTime[targetID] ~= nil and lastSendTime[targetID] + 300 > GameRules:GetGameTime() then
                    local timeLeft = math.ceil(lastSendTime[targetID] + 300 - GameRules:GetGameTime())
                    SendErrorMessage(casterID, "You can send money in " .. timeLeft .. " seconds!")
                else
                    local timeLeft = math.ceil(lastTakeGoldTime[casterID] + 60 - GameRules:GetGameTime())
                    SendErrorMessage(casterID, "You can send money in " .. timeLeft .. " seconds!")
                end
            end
        else
            SendErrorMessage(casterID, "error_select_only_your_allies")
        end
    else
        SendErrorMessage(casterID, "error_type_only_digits")
    end
end

function ChooseHelpSide(eventSourceIndex, event)
  --  DebugPrint("Choose help side: " .. eventSourceIndex);
    local team = event.team
    local playerID = event.playerID
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    hero.slayer = nil
    hero.legitChooser = false
    
    local newHeroName = WOLF_HERO
    local message = "%s1 has joined the dark side and now will help " .. GetModifiedName(TROLL_HERO[1]) .. ". %s1 is now a" .. GetModifiedName(WOLF_HERO)
    local timer = 1
    local pos = Vector(0, -640, 256)
    PlayerResource:SetCustomTeamAssignment(playerID, team)
    Timers:CreateTimer(function()
        GameRules:SendCustomMessage(message, playerID, 0)
    end)
    hero:SetTimeUntilRespawn(timer)
    Timers:CreateTimer(timer, function()
        PlayerResource:ReplaceHeroWith(playerID, newHeroName, 0, 0)
        UTIL_Remove(hero)
        hero = PlayerResource:GetSelectedHeroEntity(playerID)
        PlayerResource:SetCustomTeamAssignment(playerID, team) -- A workaround for wolves sometimes getting stuck on elves team, I don't know why or how it happens.
        FindClearSpaceForUnit(hero, pos, true)
    end)
    
end

function RandomAngelLocation()
    return (GameRules.angel_spawn_points and #GameRules.angel_spawn_points and
    #GameRules.angel_spawn_points > 0) and
    GameRules.angel_spawn_points[RandomInt(1,
    #GameRules.angel_spawn_points)]:GetAbsOrigin() or
    Vector(0, 0, 0)
end

function Halloween(npc)
    if string.match(GetMapName(),"halloween") then
        wearables:RemoveWearables(npc)
        if npc:IsWolf() then
            UpdateModel(npc, "models/heroes/life_stealer/life_stealer.vmdl", 1)  
            wearables:AttachWearable(npc, "models/items/lifestealer/bloody_ripper_belt/bloody_ripper_belt.vmdl")
            wearables:AttachWearable(npc, "models/items/lifestealer/promo_bloody_ripper_back/promo_bloody_ripper_back.vmdl")
            wearables:AttachWearable(npc, "models/items/lifestealer/bloody_ripper_arms/bloody_ripper_arms.vmdl")       
            wearables:AttachWearable(npc, "models/items/lifestealer/bloody_ripper_head/bloody_ripper_head.vmdl")   
            elseif npc:IsTroll() then            
            UpdateModel(npc, "models/items/wraith_king/arcana/wraith_king_arcana.vmdl", 1)  
            wearables:AttachWearable(npc, "models/items/wraith_king/arcana/wraith_king_arcana_weapon.vmdl")
            wearables:AttachWearable(npc, "models/items/wraith_king/arcana/wraith_king_arcana_arms.vmdl")
            wearables:AttachWearable(npc, "models/items/wraith_king/arcana/wraith_king_arcana_shoulder.vmdl")
            wearables:AttachWearable(npc, "models/items/wraith_king/arcana/wraith_king_arcana_armor.vmdl")
            wearables:AttachWearable(npc, "models/items/wraith_king/arcana/wraith_king_arcana_back.vmdl")
            wearables:AttachWearable(npc, "models/items/wraith_king/arcana/wraith_king_arcana_head.vmdl")
                    
            --UpdateModel(npc, "models/heroes/pudge/pudge.vmdl", 1)  
           -- wearables:AttachWearable(npc, "models/items/pudge/blackdeath_offhand/blackdeath_offhand.vmdl")
            --wearables:AttachWearable(npc, "models/items/pudge/blackdeath_belt/blackdeath_belt.vmdl")
          --  wearables:AttachWearable(npc, "models/items/pudge/blackdeath_head/blackdeath_head.vmdl")
         --   wearables:AttachWearable(npc, "models/items/pudge/blackdeath_back/blackdeath_back.vmdl")
          --  wearables:AttachWearable(npc, "models/items/pudge/blackdeath_weapon/blackdeath_weapon.vmdl")
          --  wearables:AttachWearable(npc, "models/items/pudge/blackdeath_shoulder/blackdeath_shoulder.vmdl")
         --   wearables:AttachWearable(npc, "models/items/pudge/blackdeath_arms/blackdeath_arms.vmdl")
            elseif npc:IsElf() then
            UpdateModel(npc, "models/items/wraith_king/wk_ti8_creep/wk_ti8_creep.vmdl", 1)  
        end
    end 
end

function trollnelves2:OnPlayerLevelUp(keys)
   -- DebugPrint('[BAREBONES] OnPlayerLevelUp')
   -- DebugPrintTable(keys)
    
    --PrintTable(keys)
    
    local player = PlayerResource:GetPlayer(keys.player_id) --EntIndexToHScript(keys.player)
    local level = keys.level
    local hero = player:GetAssignedHero()  
    
    --?????????????????? ???????? ???????????? ???????? ?????? ???????? ???? ???????????? ?????? ?????? ????????
    if level > 20 and level < 126 then
        hero:SetAbilityPoints(hero:GetAbilityPoints() + 1)
    end
    --
end