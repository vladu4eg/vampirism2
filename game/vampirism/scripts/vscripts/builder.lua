require('libraries/util')
require('trollnelves2')
require('stats')
require('wearables')
require('drop')
require('error_debug')
require('settings')
LinkLuaModifier("modifier_all_vision",
   "libraries/modifiers/modifier_all_vision.lua", LUA_MODIFIER_MOTION_NONE)
CheckBarak3 = false
-- A build ability is used (not yet confirmed)
function Build( event )
    local caster = event.caster
    local ability = event.ability
    local ability_name = ability:GetAbilityName()
    local building_name = ability:GetAbilityKeyValues()['UnitName']
    local hero = caster:IsRealHero() and caster or caster:GetOwner()
    local playerID = hero:GetPlayerOwnerID()
    local gold_cost = ability:GetSpecialValueFor("gold_cost")
    local lumber_cost = ability:GetSpecialValueFor("lumber_cost")
	local mine_cost = ability:GetSpecialValueFor("MineCost")

    DebugPrint("--------------------------------------------------------------------")
    DebugPrint(caster:GetEntityIndex())
    local status, nextCall = Error_debug.ErrorCheck(function()
    -- Makes a building dummy and starts panorama ghosting
    BuildingHelper:AddBuilding(event)
    
    -- Additional checks to confirm a valid building position can be performed here
    event:OnPreConstruction(function(vPos)
        
        -- Check for minimum height if defined
        if not BuildingHelper:MeetsHeightCondition(vPos) then
            SendErrorMessage(playerID, "error_invalid_build_position")
            return false
        end

       -- if building_name == "flag" and GameRules.PlayersBase[playerID] ~= nil then
      --      SendErrorMessage(playerID, "error_place_is_flag")
      --      return false 
     --   end
        
        -- If not enough resources to queue, stop
        if PlayerResource:GetGold(playerID) < gold_cost then
            SendErrorMessage(playerID, "error_not_enough_gold")
            return false
        end
        if PlayerResource:GetLumber(playerID) < lumber_cost then
            SendErrorMessage(playerID, "error_not_enough_lumber")
            return false
        end

        if mine_cost ~= nil then
            if mine_cost ~= 0 then
            DebugPrint(mine_cost)
            DebugPrint(hero.mine)
            DebugPrint(GameRules.maxMine )
            if hero.mine > GameRules.maxMine  then
                SendErrorMessage(playerID, "error_not_enough_mine")
                caster:AddNewModifier(nil, nil, "modifier_stunned", {duration=0.03})
                return false
            else
                PlayerResource:ModifyMine(hero, mine_cost)
            end
            end
        end

        return true
    end)
    
    -- Position for a building was confirmed and valid
    event:OnBuildingPosChosen(function(vPos)
        PlayerResource:ModifyGold(hero,-gold_cost)
        PlayerResource:ModifyLumber(hero,-lumber_cost)
        EmitSoundOnEntityForPlayer("DOTA_Item.ObserverWard.Activate", hero, hero:GetPlayerOwnerID())
    end)
    
    -- The construction failed and was never confirmed due to the gridnav being blocked in the attempted area
    event:OnConstructionFailed(function()
        --local playerTable = BuildingHelper:GetPlayerTable(playerID)
        --local name = playerTable.activeBuilding or " "
        --BuildingHelper:print("Failed placement of " .. name)
    end)
    
    -- Cancelled due to ClearQueue
    event:OnConstructionCancelled(function(work)
        local name = work.name
        BuildingHelper:print("Cancelled construction of " .. name)
        -- Refund resources for this cancelled work
        if work.refund and work.refund == true and not work.repair then
            PlayerResource:ModifyGold(hero,gold_cost,true)
            PlayerResource:ModifyLumber(hero,lumber_cost,true)
            PlayerResource:ModifyMine(hero, -mine_cost)
        end
    end)
    
     
        -- A building unit was created
        event:OnConstructionStarted(function(unit)
            BuildingHelper:print("Started construction of " .. unit:GetUnitName() .. " " .. unit:GetEntityIndex())
            unit.gold_cost = gold_cost
            unit.lumber_cost = lumber_cost
            unit:AddNewModifier(unit,nil,"modifier_phased",{}) 
            -- If it's an item-ability and has charges, remove a charge or remove the item if no charges left
            if ability.GetCurrentCharges and not ability:IsPermanent() then
                local charges = ability:GetCurrentCharges()
                charges = charges-1
                if charges == 0 then
                    ability:RemoveSelf()
                    else
                    ability:SetCurrentCharges(charges)
                end
            end
            --unit:RemoveModifierByName("modifier_invulnerable")
            unit:AddNewModifier(nil, nil, "modifier_stunned", {})
            
            if  caster.work then
                FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
                caster:AddNewModifier(caster, nil, "modifier_phased", {duration=0.03})
            end
               
            local unitName = unit:GetUnitName()
            ModifyStartedConstructionBuildingCount(hero, unitName, 1)
            table.insert(hero.units, unit)
            AddUpgradeAbilities(unit)
            UpdateSpells(hero)
            local item = CreateItem("item_building_cancel", unit, unit)
            if building_name ~= "flag" then
                unit:AddItem(item)
            elseif building_name == "flag" then 
            --    unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
                unit:AddNewModifier(unit, nil, "modifier_phased", {})
                local hero = PlayerResource:GetSelectedHeroEntity(playerID)
                local abil = hero:FindAbilityByName("build_flag")
                abil:StartCooldown(999999) 
                -- unit:SetCustomHealthLabel(tostring(PlayerResource:GetPlayerName(playerID)) ,  255, 255, 255)
            end
            
            for i=0, unit:GetAbilityCount()-1 do
                local ability = unit:GetAbilityByIndex(i)
                if ability then
                    local constructionStartModifiers = GetAbilityKV(ability:GetAbilityName(), "ConstructionStartModifiers")
                    if constructionStartModifiers then
                        for k,modifier in pairs(constructionStartModifiers) do
                            ability:ApplyDataDrivenModifier(unit, unit, modifier, {})
                        end
                    end
                end
            end

        end)
    
    
    
    
    -- A building finished construction
    event:OnConstructionCompleted(function(unit)
        BuildingHelper:print("Completed construction of " .. unit:GetUnitName() .. " " .. unit:GetEntityIndex() .. " " .. tostring(unit))
        unit.state = "complete"
        unit.ancestors = {}
        local item = unit:GetItemInSlot(0)
        if item then
            UTIL_Remove(item)
        end
        
        local unitName = unit:GetUnitName()
        ModifyCompletedConstructionBuildingCount(hero, unitName, 1)
        
        UpdateSpells(hero)
        for _, value in ipairs(hero.units) do
            UpdateUpgrades(value)
        end
        
        -- Give the unit their original attack capability
        unit:RemoveModifierByName("modifier_stunned")
        local itemBuildingDestroy = CreateItem("item_building_destroy", nil, nil)
       -- if building_name ~= "flag"  then
            unit:AddItem(itemBuildingDestroy)
            if building_name == "flag" then 
             --   unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
                unit:AddNewModifier(unit, nil, "modifier_phased", {})
                local hero = PlayerResource:GetSelectedHeroEntity(playerID)
                local abil = hero:FindAbilityByName("build_flag")
                abil:StartCooldown(999999) 
            end
        unit.attackers = {}
        
        for i=0, unit:GetAbilityCount()-1 do
            local buildingAbility = unit:GetAbilityByIndex(i)
            if buildingAbility then
                local constructionCompleteModifiers = GetAbilityKV(buildingAbility:GetAbilityName(), "ConstructionCompleteModifiers")
                if constructionCompleteModifiers then
                    for k,modifier in pairs(constructionCompleteModifiers) do
                        buildingAbility:ApplyDataDrivenModifier(unit, unit, modifier, {})
                    end
                end
            end
        end
        
        local player = unit:GetPlayerOwner()
        if player then
            CustomGameEventManager:Send_ServerToPlayer(player, "unit_upgrade_complete", { })
        end
        if building_name == "tent" then
            GameRules.maxFood[playerID] = GameRules.maxFood[playerID] + 50
            PlayerResource:ModifyFood(hero, 0)
        end
        if (string.match(building_name, "tent") or string.match(building_name, "barracks")) and string.match(GetMapName(),"clanwars") and GameRules.tent[playerID] ~= nil then
            --local hero2 = PlayerResource:GetSelectedHeroEntity(playerID)
            --if hero2:HasModifier("modifier_kill") then
           --     hero2:AddNewModifier(hero2, hero2, "modifier_kill", {duration = 9999999})
           -- end
           GameRules.tent[playerID] = nil
           hero:AddNewModifier(hero, hero, "modifier_all_vision", {Duration=10})
           hero:AddNewModifier(hero, hero, "modifier_creep_slow", {Duration=10})
        end

        if building_name == "slayerstaverna_1" and hero.slayer then
            local ability = unit:FindAbilityByName("train_npc_dota_hero_templar_assassin")
            --ability:SetHidden(true)
        end
        if string.match(building_name,"%d+") then
            if string.match(building_name,"tower") and tonumber(string.match(building_name,"%d+")) >= 5 then
                unit:ReduceMana(1000)
            end
        end

    end)
    
    -- These callbacks will only fire when the state between below half health/above half health changes.
    -- i.e. it won't fire multiple times unnecessarily.
    event:OnBelowHalfHealth(function(unit)
        --BuildingHelper:print("" .. unit:GetUnitName() .. " is below half health.")
    end)
    
    event:OnAboveHalfHealth(function(unit)
        --BuildingHelper:print("" ..unit:GetUnitName().. " is above half health.")        
    end)
	
    --	if building_name == "tent" and BuildingHelper:IsInsideBaseArea(hero) == false then
	--	local check = false
	--	DebugPrint("Test1")
    --		for _,base in ipairs(playersBase) do
	--		local numBase, pID = unpack(base)
	--		DebugPrint("Test1.2")
	--		if pID == playerID then
	--			check = true
	--			DebugPrint("Test2")
	--		end
	--	end
	--	DebugPrint("Test3.1")
    --		DebugPrint(IdBaseArea(hero))
    --if check == false and IdBaseArea(hero) ~= nil then
	--		table.insert(playersBase,{IdBaseArea(hero),playerID})
	--		DebugPrint("Test3.2")
	--	end
    --	end
end)
end

-- Called when the Cancel ability-item is used
function CancelBuilding( keys )
    DebugPrint("Trying to cancel!")
    local building = keys.unit
    local hero = building:GetOwner()
    
    BuildingHelper:print("CancelBuilding "..building:GetUnitName().." "..building:GetEntityIndex())
    
    -- Refund here
   -- PlayerResource:ModifyGold(hero,building.gold_cost,true)
   -- PlayerResource:ModifyLumber(hero,building.lumber_cost,true)
    
    building:ForceKill(true)
    Timers:CreateTimer(0.1,function()
        UTIL_Remove(building)    
    end)
end

function DestroyBuilding( keys )
    local building = keys.unit
    local units = FindUnitsInRadius(building:GetTeamNumber() , building:GetAbsOrigin() , nil , 1200 , DOTA_UNIT_TARGET_TEAM_ENEMY ,  DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
    local ownerID = building:GetPlayerOwnerID()
    local playerID = building:GetMainControllingPlayer()
    local hero = building:GetOwner()
    local heroDeleter = PlayerResource:GetSelectedHeroEntity(playerID)

	local origin_point = heroDeleter:GetAbsOrigin()
	local target_point = building:GetAbsOrigin()
	local difference_vector = target_point - origin_point
	
    if #units > 0 and difference_vector:Length2D() > 800 then
        SendErrorMessage(playerID, "error_enemy_nearby")
    elseif PlayerResource:GetConnectionState(ownerID) == 3 then
        SendErrorMessage(playerID, "error_not_destroy_building")
    else
        if building:GetUnitName() == "flag" then
            for pID = 0, DOTA_MAX_TEAM_PLAYERS do
                if PlayerResource:IsValidPlayerID(pID) then
                    if GameRules.PlayersBase[pID] == GameRules.PlayersBase[playerID] and pID ~= playerID then
                      --  GameRules.PlayersBase[pID] = nil
                        GameRules.countFlag[pID] = nil
                    --    local hero2 = PlayerResource:GetSelectedHeroEntity(pID)
                    --    local abil2 = hero:FindAbilityByName("build_flag")
                   --     abil2:StartCooldown(300) 
                    end
                end
            end
            
            local abil2 = hero:FindAbilityByName("build_flag")
            abil2:EndCooldown()
            abil2:StartCooldown(300) 
            GameRules.PlayersBase[ownerID] = nil
            GameRules.countFlag[ownerID] = nil
            if string.match(GetMapName(),"clanwars") then
                hero:AddNewModifier(hero, hero, "modifier_all_vision", {Duration=10})
                hero:AddNewModifier(hero, hero, "modifier_creep_slow", {Duration=10})
                --hero:AddNewModifier(hero, hero, "modifier_silencer_last_word_disarm", {Duration=20})
            end
        end
        
        building:ForceKill(false)
    end
    
end

function UpgradeBuilding( event )
    local building = event.caster
    local NewBuildingName = event.NewName
    local playerID = building:GetPlayerOwnerID()
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    local upgrades = GetUnitKV(building:GetUnitName(),"Upgrades")
    local buildTime = GetUnitKV(NewBuildingName,"BuildTime")
  --  local baseID = BuildingHelper:IdBaseArea(building)
  --  if baseID ~= nil and baseID ~= GameRules.PlayersBase[playerID] and GameRules.PlayersBase[playerID] ~= nil then
  --      SendErrorMessage(playerID, "error_not_upgrade_flag_base")
  --      return false
  --  end
    if not string.match(NewBuildingName,"troll_hut") then
        if not BuildingHelper:IsInsideBaseArea(building, building, NewBuildingName, true) and string.match(GetMapName(),"clanwars") then
            CancelBuilding(event)
            SendErrorMessage(playerID, "error_not_upgrade_flag_base")
            return false
        end
    end
    if GameRules.MapSpeed == 4 and NewBuildingName ~= "tower_19" and NewBuildingName ~= "tower_19_1" and NewBuildingName ~= "tower_19_2" and not string.match(NewBuildingName,"rock") then
        buildTime = buildTime/4
    end
    
    local gold_cost
    local lumber_cost
    local parts = CustomNetTables:GetTableValue("Particles_Tabel",tostring(building:GetPlayerOwnerID()))
    
    -- I do it like this so you are able to have two buildings upgrade into the same upgraded building with different prices and only having one ability
    local count = tonumber(upgrades.Count)
    for i = 1, count, 1 do
        local upgrade = upgrades[tostring(i)]
        local upgraded_unit_name = upgrade.unit_name
        if upgraded_unit_name == NewBuildingName then
            gold_cost = upgrade.gold_cost
            lumber_cost = upgrade.lumber_cost
        end
    end
    if gold_cost > PlayerResource:GetGold(playerID) then
        SendErrorMessage(playerID, "error_not_enough_gold")
        return false
    end
    if lumber_cost > PlayerResource:GetLumber(playerID) then
        SendErrorMessage(playerID, "error_not_enough_lumber")
        return false
    end

    -- if GameRules.MapSpeed >= 4 and NewBuildingName == 'tower_19' then
    --    SendErrorMessage(playerID, "error_not_upgrade_tower19_x4")
    --     return false
    --  end
	building:AddNewModifier(nil, nil, "modifier_stunned", {}) 
	
    local newBuilding
    --local status, nextCall = Error_debug.ErrorCheck(function() 
        newBuilding = BuildingHelper:UpgradeBuilding(building,NewBuildingName)
   -- end)
    local newBuildingName = newBuilding:GetUnitName()
    newBuilding.state = "complete"
    if newBuilding:GetUnitName() == "tent_2" then
        GameRules.maxFood[playerID] = GameRules.maxFood[playerID] + 100 
        PlayerResource:ModifyFood(hero, 0)
    elseif newBuilding:GetUnitName() == "tent_3" then
        GameRules.maxFood[playerID] = GameRules.maxFood[playerID] + 300 
        PlayerResource:ModifyFood(hero, 0)
    end
    if string.match(NewBuildingName,"%d+") then
        if string.match(NewBuildingName,"tower") and tonumber(string.match(NewBuildingName,"%d+")) >= 5 then
            newBuilding:ReduceMana(1000)
        end
    end

    

    
    newBuilding.ancestors = building.ancestors
    table.insert(newBuilding.ancestors,building:GetUnitName())
    for _, ancestorUnitName in pairs(newBuilding.ancestors) do
        ModifyStartedConstructionBuildingCount(hero, ancestorUnitName, 1)
        ModifyCompletedConstructionBuildingCount(hero, ancestorUnitName, 1)
    end
    table.insert(hero.units, newBuilding)
    ModifyStartedConstructionBuildingCount(hero, newBuildingName, 1)
    
    local ability = event.ability
    local skips = GetAbilityKV(ability:GetAbilityName(),"SkipRequirements")
    if skips then
        for _, skipUnitName in pairs(skips) do
            ModifyStartedConstructionBuildingCount(hero, skipUnitName, 1)
            ModifyCompletedConstructionBuildingCount(hero, skipUnitName, 1)
        end
    end
    
    PlayerResource:ModifyGold(hero,-gold_cost)
    PlayerResource:ModifyLumber(hero,-lumber_cost)
    
    AddUpgradeAbilities(newBuilding)
    for i=0, newBuilding:GetAbilityCount()-1 do
        local newBuildingAbility = newBuilding:GetAbilityByIndex(i)
        if newBuildingAbility then
            local constructionCompleteModifiers = GetAbilityKV(newBuildingAbility:GetAbilityName(), "ConstructionCompleteModifiers")
            if constructionCompleteModifiers then
                for _, modifier in pairs(constructionCompleteModifiers) do
                    newBuildingAbility:ApplyDataDrivenModifier(newBuilding, newBuilding, modifier, {})
                end
            end
            local constructionStartModifiers = GetAbilityKV(newBuildingAbility:GetAbilityName(), "ConstructionStartModifiers")
            if constructionStartModifiers then
                for _, modifier in pairs(constructionStartModifiers) do
                    newBuildingAbility:ApplyDataDrivenModifier(newBuilding, newBuilding, modifier, {})
                end
            end
        end
    end
    local position = newBuilding:GetAbsOrigin()
    building:ForceKill(true)
    newBuilding.construction_size = BuildingHelper:GetConstructionSize(newBuildingName)
    if not string.match(newBuilding:GetUnitName(),"troll_hut") then
        newBuilding.blockers = BuildingHelper:BlockGridSquares(newBuilding.construction_size, BuildingHelper:GetBlockPathingSize(newBuildingName), position)
        elseif newBuilding:GetUnitName() == "troll_hut_7" then
        hero:AddAbility("lone_druid_spirit_bear_datadriven")
        local abil = hero:FindAbilityByName("lone_druid_spirit_bear_datadriven")
        abil:SetLevel(abil:GetMaxLevel())
        GameRules.MultiMapSpeed = 2
    end
    
    if newBuildingName == "barracks_3" and (not CheckBarak3 or string.match(GetMapName(),"clanwars")) then
        if GameRules.Bonus[playerID] == nil then
            GameRules.Bonus[playerID] = 0
        end
        GameRules.Bonus[playerID] = GameRules.Bonus[playerID] + 2
        CheckBarak3 = true
        local roll_chance = RandomFloat(0, 500)
        if roll_chance <= CHANCE_DROP_GEM_BARRACKS_3 then
            local spawnPoint = newBuilding:GetAbsOrigin()	
            local newItem = CreateItem( "item_get_gem", nil, nil )
            local dropRadius = RandomFloat( 250, 450 )
            local randRadius = spawnPoint + RandomVector( dropRadius )
            CreateItemOnPositionForLaunch( randRadius, newItem )
            newItem:LaunchLootInitialHeight( false, 0, 250, 0.5, randRadius ) 
        end
    end

    if string.match(newBuildingName,"gold_mine") then
        PlayerResource:ModifyMine(hero, 1)
    end
    --if (GameRules.scores[playerID].elf + GameRules.scores[playerID].troll) == 0 and not string.match(newBuildingName,"tower") then
    --    PlayerResource:ModifyGold(hero, (2 * (math.floor(GameRules:GetGameTime()/60)+1)))
    --end
    Timers:CreateTimer(buildTime,function()
        if newBuilding:IsNull() or not newBuilding:IsAlive() then
            return
        end
        
        newBuilding:RemoveModifierByName("modifier_stunned")
        newBuilding:StopAnimation() --Animation stop
        if not string.match(newBuildingName,"troll_hut") and newBuildingName ~= "tower_19" and newBuildingName ~= "tower_19_1" and newBuildingName ~= "tower_19_2" then
            local item = CreateItem("item_building_destroy", nil, nil)
            newBuilding:AddItem(item)
        end
        ModifyCompletedConstructionBuildingCount(hero, newBuildingName, 1)
        UpdateSpells(hero)
        for _, value in ipairs(hero.units) do
            UpdateUpgrades(value)
        end

    end)
end

