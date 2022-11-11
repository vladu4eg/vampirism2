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
    DebugPrint("GameRulesStateChange ******************")
    local newState = GameRules:State_Get()
    DebugPrint(newState)
    if newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
        trollnelves2:GameSetup()
        trollnelves2:PostLoadPrecache()
        elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
        self:PreStart()
    end
end

-- An NPC has spawned somewhere in game.  This includes heroes
function trollnelves2:OnNPCSpawned(keys)
    DebugPrint("OnNPCSpawned:")
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
    if npc:IsAngel() and PlayerResource:GetConnectionState(npc:GetPlayerOwnerID()) ~= 2 and not GameRules.test and not GameRules.test2 then
        npc:AddNewModifier(nil, nil, "modifier_disconnected", {})
    end
    if npc:IsWolf() and PlayerResource:GetConnectionState(npc:GetPlayerOwnerID()) ~= 2 and not GameRules.test and not GameRules.test2 then
        npc:AddNewModifier(nil, nil, "modifier_disconnected", {})
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
        npc:AddNewModifier(npc, nil, "modifier_death_armor", {})
    end
  --  if npc:IsAngel() then
  --      npc:AddNewModifier(npc, nil, "modifier_death_mana", {})
  --   end
    if EVENT_START then
        --Halloween(npc)  
    end
end

function trollnelves2:OnPlayerReconnect(event)
    local playerID = event.PlayerID
    if GameRules.KickList[playerID] == 1 then 
        SendToServerConsole("kick " .. PlayerResource:GetPlayerName(playerID))
        return
    end
    -- local notSelectedHero = GameRules.disconnectedHeroSelects[playerID]
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    --if notSelectedHero then
    --    hero = PlayerResource:ReplaceHeroWith(playerID, notSelectedHero, 0, 0)   
   -- end
    if hero:IsAngel() then hero:RemoveModifierByName("modifier_disconnected") end
    if hero:IsWolf() then hero:RemoveModifierByName("modifier_disconnected") end
    if hero then
        -- Send info to client]
        UpdateSpells(hero)
        hero:SetAbilityPoints(0)
        PlayerResource:ModifyGold(hero, 0)
        PlayerResource:ModifyLumber(hero, 0)
        PlayerResource:ModifyFood(hero, 0)
        PlayerResource:ModifyWisp(hero, 0)
        PlayerResource:ModifyMine(hero, 0)
        ModifyLumberPrice(0)
        hero:CalculateStatBonus(true)
        hero:RemoveModifierByName("modifier_disconnected")
        if hero:IsElf() and hero.alive == false then
            if hero.dced == true then
                hero.alive = true
                hero.dced = false
                else
                local player = PlayerResource:GetPlayer(playerID)
                if player then
                    CustomGameEventManager:Send_ServerToPlayer(player,
                        "show_helper_options",
                    {})
                end
            end
        end
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
        hero:AddNewModifier(nil, nil, "modifier_disconnected", {})
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
                                if string.match(GetMapName(),"clanwars") then
                                    Clanwars.SubmitMatchData(DOTA_TEAM_BADGUYS, callback)
                                else
                                    Stats.SubmitMatchData(DOTA_TEAM_BADGUYS, callback)
                                end    
                            end)
                            GameRules:SendCustomMessage("The game can be left, thanks!", 1, 1)
                            return nil
                    end
                end)
            end
        end
        elseif team == DOTA_TEAM_BADGUYS then
        hero:MoveToPosition(Vector(0, 0, 0))
        if hero:IsWolf() then
            hero:AddNewModifier(nil, nil, "modifier_disconnected", {})
            Timers:CreateTimer(60, function()
                if hero ~= nil and GameRules.KickList[playerID] ~= 1 then
                    if PlayerResource:GetConnectionState(hero:GetPlayerOwnerID()) ~= 2 then
                        local wolfNetworth = hero:GetNetworth()
                        local lumber = wolfNetworth / 64000 or 0
                        local gold = math.floor((lumber - math.floor(lumber)) * 64000) or 0
                        lumber = math.floor(lumber)
                        hero:ClearInventory()
                        hero:RemoveDesol2()
                        PlayerResource:ModifyGold(GameRules.trollHero, gold, true)
                        PlayerResource:ModifyLumber(GameRules.trollHero, lumber, true)
                        PlayerResource:SetGold(hero, 0, true)
                        PlayerResource:SetLumber(hero, 0, true)
                    end
                end
            end)
            
        end
    end
    if hero:IsTroll() then
        Timers:CreateTimer(function()
            if trollLoseTimer > 0 and PlayerResource:GetConnectionState(hero:GetPlayerOwnerID()) ~= 2  and PlayerResource:GetConnectionState(hero:GetPlayerOwnerID()) ~= 4 then
                Notifications:ClearBottomFromAll()
                Notifications:BottomToAll(
                    {
                        text = "The Troll will lose in " .. trollLoseTimer,
                        style = {color = '#E62020'},
                        duration = 1
                    })
                    trollLoseTimer = trollLoseTimer - 1
                    return 1.0
                    elseif trollLoseTimer > 0 and PlayerResource:GetConnectionState(hero:GetPlayerOwnerID()) == 2 then
                    return nil
                    elseif trollLoseTimer <= 0 or PlayerResource:GetConnectionState(hero:GetPlayerOwnerID()) == 4 then
                    GameRules:SendCustomMessage("Please do not leave the game.", 1, 1)
                    local status, nextCall = Error_debug.ErrorCheck(function() 
                        if string.match(GetMapName(),"clanwars") then
                            Clanwars.SubmitMatchData(DOTA_TEAM_GOODGUYS, callback)
                        else
                            Stats.SubmitMatchData(DOTA_TEAM_GOODGUYS, callback)
                        end    
                    end)
                    GameRules:SendCustomMessage("The game can be left, thanks!", 1, 1)
                    return nil
            end
        end)
    end
end

function trollnelves2:OnConnectFull(keys)
    DebugPrint("OnConnectFull ******************")
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
    print('[BAREBONES] OnItemPickedUp')
    DeepPrintTable(keys)
    local hero = PlayerResource:GetSelectedHeroEntity(keys.PlayerID)
    local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
    local player = PlayerResource:GetPlayer(keys.PlayerID)
    local itemname = keys.itemname
    
    if (hero:IsAngel() or hero:IsElf()) and (string.match(itemname,"hp") or string.match(itemname,"armor") or string.match(itemname,"dmg") or string.match(itemname,"spd") or string.match(itemname,"boots")  or string.match(itemname,"repair")) then 
        hero:RemoveItem(itemEntity)
        return
    end  
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
    print('[BAREBONES] OnItemAddedInv')
    DeepPrintTable(keys)
    local hero = EntIndexToHScript(keys.inventory_parent_entindex)
    local itemEntity = EntIndexToHScript(keys.item_entindex)
    local player = PlayerResource:GetPlayer(keys.inventory_player_id)
    local itemname = keys.itemname
    if hero ~= nil then
        if (hero:IsAngel() or hero:IsElf()) and (string.match(itemname,"hp") or string.match(itemname,"armor") or string.match(itemname,"dmg") or string.match(itemname,"spd") or string.match(itemname,"boots")  or string.match(itemname,"repair")) then 
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
    DebugPrint("[TROLLNELVES2] All Players have loaded into the game")
    
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
    
    if killed ~= nil then
        drop:RollItemDrop(killed)
    end

    if IsBuilder(killed) then BuildingHelper:ClearQueue(killed) end
    if killed:IsRealHero() then
        local bounty = -1
        
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

            bounty = ElfKilled(killed)
            GameRules.Bonus[attackerPlayerID] = GameRules.Bonus[attackerPlayerID] + 1
            if CheckTrollVictory() then
                for pID = 0, DOTA_MAX_TEAM_PLAYERS do
                    if PlayerResource:IsValidPlayerID(pID) then
                        PlayerResource:SetCameraTarget(pID, killed)
                    end
                end
                GameRules:SendCustomMessage("Please do not leave the game.", 1, 1)
                local status, nextCall = Error_debug.ErrorCheck(function() 
                    if string.match(GetMapName(),"clanwars") then
                        Clanwars.SubmitMatchData(DOTA_TEAM_BADGUYS, callback)
                    else
                        Stats.SubmitMatchData(DOTA_TEAM_BADGUYS, callback)
                    end   
                end)
                GameRules:SendCustomMessage("The game can be left, thanks!", 1, 1)
                return
            end
            Pets.DeletePet(info)
        elseif killed:IsTroll() then
            GameRules.Bonus[attackerPlayerID] = GameRules.Bonus[attackerPlayerID] + 2
            killed:SetTimeUntilRespawn(9999999)
            for pID = 0, DOTA_MAX_TEAM_PLAYERS do
                if PlayerResource:IsValidPlayerID(pID) then
                    PlayerResource:SetCameraTarget(pID, killed)
                end
            end
            GameRules:SendCustomMessage("Please do not leave the game.", 1, 1)
            local status, nextCall = Error_debug.ErrorCheck(function() 
                if string.match(GetMapName(),"clanwars") then
                    Clanwars.SubmitMatchData(DOTA_TEAM_GOODGUYS, callback)
                else
                    Stats.SubmitMatchData(DOTA_TEAM_GOODGUYS, callback)
                end  
            end)
            GameRules:SendCustomMessage("The game can be left, thanks!", 1, 1)
        elseif killed:IsWolf() then
            bounty = math.max(killed:GetNetworth() * 0.70,
            GameRules:GetGameTime())
            killed:SetRespawnPosition(Vector(0, -640, 256))
            killed:SetTimeUntilRespawn(WOLF_RESPAWN_TIME * PlayerResource:GetDeaths(killedPlayerID))
            killed:RemoveDesol2()
            if PlayerResource:GetDeaths(killedPlayerID) == 2 then
                GameRules.Bonus[attackerPlayerID] = GameRules.Bonus[attackerPlayerID] + 1
            end
           Pets.DeletePet(info)
        elseif killed:IsAngel() then
            bounty = math.max(PlayerResource:GetGold(killedPlayerID),
            GameRules:GetGameTime()) / 4
            PlayerResource:SetGold(killed, 0)
            killed:SetRespawnPosition(RandomAngelLocation())
            killed:SetTimeUntilRespawn(ANGEL_RESPAWN_TIME * PlayerResource:GetDeaths(killedPlayerID))

            Timers:CreateTimer(ANGEL_RESPAWN_TIME, function()
                killed:AddNewModifier(killed, nil, "modifier_invulnerable",
                {duration = 5})
            end)
            killed:ClearInventoryCM()
            Pets.DeletePet(info)
        end
        if bounty >= 0 and attacker ~= killed then
            local killedName = PlayerResource:GetSelectedHeroEntity(
            killedPlayerID) and
            PlayerResource:GetSelectedHeroEntity(
            killedPlayerID):GetUnitName() or
            killed:GetUnitName()
            local attackerName = PlayerResource:GetSelectedHeroEntity(
            attackerPlayerID) and
            PlayerResource:GetSelectedHeroEntity(
            attackerPlayerID):GetUnitName() or
            attacker:GetUnitName()
            bounty = math.floor(bounty)
            PlayerResource:ModifyGold(attacker, bounty)
            local message = "%s1 (" .. GetModifiedName(attackerName) ..
            ") killed " ..
            PlayerResource:GetPlayerName(killedPlayerID) ..
            " (" .. GetModifiedName(killedName) ..
            ") for <font color='#F0BA36'>" .. bounty ..
            "</font> gold!"
            GameRules:SendCustomMessage(message, attackerPlayerID, 0)
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
        if killed:GetUnitName() == "tent" then
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
                        BuildingHelper:print(
                        "Clearing special grid of " .. grid_type)
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
                -- DebugPrint("name " .. name)
                ModifyStartedConstructionBuildingCount(hero, name, -1)
                if killed.state == "complete" then
                    ModifyCompletedConstructionBuildingCount(hero, name, -1)
                end
                if killed.ancestors then
                    for _, ancestorUnitName in pairs(killed.ancestors) do
                        if name ~= ancestorUnitName then
                            -- DebugPrint("ancestorUnitName " .. ancestorUnitName)
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
            elseif killed:GetKeyValue("WispCost") then
            local wisp = killed:GetKeyValue("WispCost")
            PlayerResource:ModifyWisp(hero, -wisp)
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
    
    local bounty = PlayerResource:GetGold(killedID)/10
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
    
    if string.match(GetMapName(),"clanwars") then
        bounty = PlayerResource:GetGold(killedID) + (400 + GameRules:GetGameTime())
        UTIL_Remove(killed)
        return bounty
    end 

    args.team = DOTA_TEAM_BADGUYS
    args.playerID = killedID
    ChooseHelpSide(killedID, args)
    
    return bounty
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
    DebugPrint("Give resources, event source index: ", eventSourceIndex)
    local targetID = event.target
    local casterID = event.casterID
    local gold = math.floor(math.abs(tonumber(event.gold)))
    local lumber = math.floor(math.abs(tonumber(event.lumber)))
    if string.match(GetMapName(),"clanwars") then
        SendErrorMessage(event.casterID, "error_not_send_money_cw")
        return 
    end 
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
                if ((lastSendTime[targetID] == nil or lastSendTime[targetID] + 140 < GameRules:GetGameTime())
                and (lastTakeGoldTime[casterID] == nil or lastTakeGoldTime[casterID] + 30 < GameRules:GetGameTime())) or casterHero:IsAngel() then
                    if (gold > 99 or lumber > 1) or (casterHero:IsAngel() and (gold >= 1 or lumber >= 1 )) then
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
                    
                        if casterHero:IsAngel() == false then
                            lastSendTime[targetID] = GameRules:GetGameTime()
                            lastTakeGoldTime[targetID] = GameRules:GetGameTime()
                        end
                    elseif not casterHero:IsAngel() then
                        SendErrorMessage(casterID, "#error_enter_need_money")
                    end
                    
                elseif lastSendTime[targetID] ~= nil and lastSendTime[targetID] + 140 > GameRules:GetGameTime() then
                    local timeLeft = math.ceil(lastSendTime[targetID] + 140 - GameRules:GetGameTime())
                    SendErrorMessage(casterID, "You can send money in " .. timeLeft .. " seconds!")
                else
                    local timeLeft = math.ceil(lastTakeGoldTime[casterID] + 30 - GameRules:GetGameTime())
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
    DebugPrint("Choose help side: " .. eventSourceIndex);
    local team = event.team
    local playerID = event.playerID
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    hero.legitChooser = false
    
    local newHeroName
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
        if npc:IsAngel() then
            UpdateModel(npc, "models/heroes/death_prophet/death_prophet.vmdl", 1)  
            wearables:AttachWearable(npc, "models/items/death_prophet/drowned_siren_head/drowned_siren_head.vmdl")
            wearables:AttachWearable(npc, "models/items/death_prophet/drowned_siren_drowned_siren_skirt/drowned_siren_drowned_siren_skirt.vmdl")
            wearables:AttachWearable(npc, "models/items/death_prophet/drowned_siren_armor/drowned_siren_armor.vmdl")
            wearables:AttachWearable(npc, "models/items/death_prophet/exorcism/drowned_siren_drowned_siren_crowned_fish/drowned_siren_drowned_siren_crowned_fish.vmdl")
            wearables:AttachWearable(npc, "models/items/death_prophet/drowned_siren_misc/drowned_siren_misc.vmdl")
            elseif npc:IsWolf() then
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
    DebugPrint('[BAREBONES] OnPlayerLevelUp')
    DebugPrintTable(keys)
    
    --PrintTable(keys)
    
    local player = PlayerResource:GetPlayer(keys.player_id) --EntIndexToHScript(keys.player)
    local level = keys.level
    local hero = player:GetAssignedHero()  
    
    --времменый фикс вольво пока они сука не вернут всё как было
    if level > 20 and level < 126 then
        hero:SetAbilityPoints(hero:GetAbilityPoints() + 1)
    end
    --
end