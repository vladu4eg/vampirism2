require('libraries/util')
require('libraries/entity')
require('trollnelves2')
require('wearables')
require('error_debug')
--LinkLuaModifier("modifier_all_vision",
--    "libraries/modifiers/modifier_all_vision.lua",
--LUA_MODIFIER_MOTION_NONE)

--Ability for tents to give gold

function GainGoldCreate(event)
	if IsServer() then
		local caster = event.caster
		local hero = caster:GetOwner()				
		if not hero then
			return
		end
		local goldInterval = GetUnitKV(caster:GetUnitName(), "GoldInterval")
		local level = caster:GetLevel()
		local amountPerSecond = 2^(level-1) * GameRules.MapSpeed
		hero.goldPerSecond = hero.goldPerSecond + amountPerSecond
		local playerID = caster:GetPlayerOwnerID()
		local dataTable = { entityIndex = caster:GetEntityIndex(), amount = amountPerSecond, interval = goldInterval, statusAnim = GameRules.PlayersFPS[playerID] }
		CustomGameEventManager:Send_ServerToTeam(caster:GetTeamNumber(), "gold_gain_start", dataTable)
	end
end

function GainGoldDestroy(event)
	if IsServer() then
		local caster = event.caster
		local hero = caster:GetOwner()
		if not hero then
			return
		end				
		local level = caster:GetLevel()
		local amountPerSecond = 2^(level-1) * GameRules.MapSpeed
		if not hero.goldPerSecond then
			return
		end
		hero.goldPerSecond = hero.goldPerSecond - amountPerSecond
		local dataTable = { entityIndex = caster:GetEntityIndex() }
		CustomGameEventManager:Send_ServerToTeam(caster:GetTeamNumber(), "gold_gain_stop", dataTable)
	end
end

function ItemGetGem(event)
	local data = {}
	local caster = event.caster
	local playerID = caster:GetPlayerOwnerID()
	data.SteamID = tostring(PlayerResource:GetSteamID(playerID))
	data.Gem = 10
	data.Gold = 0
	data.playerID = playerID
	if GameRules.PlayersCount >= MIN_RATING_PLAYER then
		Shop.GetGem(data, callback)
		local item = caster:FindItemInInventory("item_get_gem")
		caster:RemoveItem(item)
	end
end

function ItemGetGold(event)
	local data = {}
	local caster = event.caster
	local playerID = caster:GetPlayerOwnerID()
	data.SteamID = tostring(PlayerResource:GetSteamID(playerID))
	data.Gem = 0
	data.Gold = 10
	data.playerID = playerID
	if GameRules.PlayersCount >= MIN_RATING_PLAYER then
		Shop.GetGem(data, callback)
		local item = caster:FindItemInInventory("item_get_gold")
		caster:RemoveItem(item)
	end
end

function ItemEffect(event)
	local data = {}
	local caster = event.caster
	local playerID = caster:GetPlayerOwnerID()
	data.SteamID = tostring(PlayerResource:GetSteamID(playerID))
	data.Num = "2"
	data.Srok = "01/09/2020"
	data.PlayerID = playerID
	if GameRules.PlayersCount >= MIN_RATING_PLAYER then
		Shop.GetVip(data, callback)
		local item = caster:FindItemInInventory("item_vip")
		caster:RemoveItem(item)
	end
end

function ItemEvent(event)
	local data = {}
	local caster = event.caster
	local playerID = caster:GetPlayerOwnerID()
	data.SteamID = tostring(PlayerResource:GetSteamID(playerID))
	data.Num = "3"
	data.Srok = "01/09/2020"
	data.PlayerID = playerID
	if GameRules.PlayersCount >= MIN_RATING_PLAYER then
		Shop.GetVip(data, callback)
		local item = caster:FindItemInInventory(event.ability:GetAbilityName())
		caster:RemoveItem(item)
	end
end

function ItemEventStresS(event)
	local data = {}
	local caster = event.caster
	local playerID = caster:GetPlayerOwnerID()
	data.SteamID = tostring(PlayerResource:GetSteamID(playerID))
	data.Num = "3"
	data.Srok = "01/09/2020"
	data.PlayerID = playerID
	if GameRules.PlayersCount >= MIN_RATING_PLAYER then
		Shop.GetVip(data, callback)
		local item = caster:FindItemInInventory("item_winter_stress")
		caster:RemoveItem(item)
	end
end

function ItemEventDesert(event)
	local data = {}
	local caster = event.caster
	local playerID = caster:GetPlayerOwnerID()
	data.SteamID = tostring(PlayerResource:GetSteamID(playerID))
	data.Num = "24"
	data.Srok = "01/09/2020"
	data.PlayerID = playerID
	if GameRules.PlayersCount >= MIN_RATING_PLAYER then
		Shop.GetVip(data, callback)
		local item = caster:FindItemInInventory("item_event_desert")
		caster:RemoveItem(item)
	end
end

function ItemEventWinter(event)
	local data = {}
	local caster = event.caster
	local playerID = caster:GetPlayerOwnerID()
	data.SteamID = tostring(PlayerResource:GetSteamID(playerID))
	data.Num = "18"
	data.Srok = "01/09/2020"
	
	if GameRules.PlayersCount >= MIN_RATING_PLAYER then
		Shop.GetVip(data, callback)
		local item = caster:FindItemInInventory("item_event_winter")
		caster:RemoveItem(item)
	end
end

function ItemEventHelheim(event)
	local data = {}
	local caster = event.caster
	local playerID = caster:GetPlayerOwnerID()
	data.SteamID = tostring(PlayerResource:GetSteamID(playerID))
	data.Num = "29"
	data.Srok = "01/09/2020"
	data.PlayerID = playerID
	if GameRules.PlayersCount >= MIN_RATING_PLAYER then
		Shop.GetVip(data, callback)
		local item = caster:FindItemInInventory("item_event_helheim")
		caster:RemoveItem(item)
	end
end

function ItemEventBirthday(event)
	local data = {}
	local caster = event.caster
	local playerID = caster:GetPlayerOwnerID()
	data.SteamID = tostring(PlayerResource:GetSteamID(playerID))
	data.Num = "23"
	data.Srok = "01/09/2020"
	data.PlayerID = playerID
	if GameRules.PlayersCount >= MIN_RATING_PLAYER then
		Shop.GetVip(data, callback)
		local item = caster:FindItemInInventory("item_event_birthday")
		caster:RemoveItem(item)
	end
end

function GainGoldTeamThinker(event)
	if IsServer() then
		if event.caster then
			local caster = event.caster
			local level = caster:GetLevel()
			local amount = 2^(level-1) * GameRules.MapSpeed
			for i=1,PlayerResource:GetPlayerCountForTeam(caster:GetTeamNumber()) do
				local playerID = PlayerResource:GetNthPlayerIDOnTeam(caster:GetTeamNumber(), i)
				local hero = PlayerResource:GetSelectedHeroEntity(playerID) or false
				if hero then
					PlayerResource:ModifyGold(hero,amount)
				end
			end
			PopupGoldGain(caster,amount)
		end
	end
end


function shrapnel_start_charge( keys )
	-- Only start charging at level 1
	if keys.ability:GetLevel() ~= 1 then return end
	
	-- Variables
	local caster = keys.caster
	local ability = keys.ability
	local modifierName = "modifier_shrapnel_stack_counter_datadriven"
	local maximum_charges = 2
	local charge_replenish_time = 60
	if GameRules.MapSpeed ~= 1  then
		charge_replenish_time = 30
	end
	-- Initialize stack
	caster:SetModifierStackCount( modifierName, caster, 0 )
	caster.shrapnel_charges = maximum_charges
	caster.start_charge = false
	caster.shrapnel_cooldown = 0.0
	if caster.first == nil then
		caster.first = true
	end
	

	ability:ApplyDataDrivenModifier( caster, caster, modifierName, {} )
	caster:SetModifierStackCount( modifierName, caster, maximum_charges )
	if keys.caster:GetUnitName() == "npc_dota_hero_bear" and caster.first then
		caster.first = false
		return
	end
	-- create timer to restore stack
	Timers:CreateTimer( function()
		-- Restore charge
		if caster.start_charge and caster.shrapnel_charges < maximum_charges then
			-- Calculate stacks
			if ability == nil or caster == nil then
				return nil
			end
			local next_charge = caster.shrapnel_charges + 1
			caster:RemoveModifierByName( modifierName )
			if next_charge ~= maximum_charges then
				ability:ApplyDataDrivenModifier( caster, caster, modifierName, { Duration = charge_replenish_time } )
				shrapnel_start_cooldown( caster, charge_replenish_time )
				else
				ability:ApplyDataDrivenModifier( caster, caster, modifierName, {} )
				caster.start_charge = false
			end
			caster:SetModifierStackCount( modifierName, caster, next_charge )
			
			-- Update stack
			caster.shrapnel_charges = next_charge
		end
		
		-- Check if max is reached then check every 0.5 seconds if the charge is used
		if caster.shrapnel_charges ~= maximum_charges then
			caster.start_charge = true
			return charge_replenish_time
			else
			return 0.5
		end
	end
	)
end
function shrapnel_fire( keys )
	-- Reduce stack if more than 0 else refund mana
	if keys.caster.shrapnel_charges > 0 then
		-- variables
		local caster = keys.caster
		local target = keys.target_points[1]
		local ability = keys.ability
		local casterLoc = caster:GetAbsOrigin()
		local modifierName = "modifier_shrapnel_stack_counter_datadriven"
		local dummyModifierName = "modifier_shrapnel_dummy_datadriven"
		local radius = ability:GetLevelSpecialValueFor( "radius", ( ability:GetLevel() - 1 ) )
		local maximum_charges = 2
		local charge_replenish_time = 60
		local dummy_duration = ability:GetLevelSpecialValueFor( "duration", ( ability:GetLevel() - 1 ) ) + 0.1
		local damage_delay = ability:GetLevelSpecialValueFor( "damage_delay", ( ability:GetLevel() - 1 ) ) + 0.1
		local next_charge = 0
		-- Deplete charge
		if GameRules.MapSpeed == 2  then
			charge_replenish_time = 30
			elseif GameRules.MapSpeed == 4 then
			charge_replenish_time = 15
		end
		if caster:HasModifier("modifier_troll_warlord_presence") or caster:HasModifier("modifier_troll_boots_3") then
			next_charge = caster.shrapnel_charges
			else
			next_charge = caster.shrapnel_charges - 1
		end
		if caster.shrapnel_charges == maximum_charges then
			caster:RemoveModifierByName( modifierName )
			ability:ApplyDataDrivenModifier( caster, caster, modifierName, { Duration = charge_replenish_time } )
			shrapnel_start_cooldown( caster, charge_replenish_time )
		end
		caster:SetModifierStackCount( modifierName, caster, next_charge )
		caster.shrapnel_charges = next_charge
		
		-- Check if stack is 0, display ability cooldown
		if caster.shrapnel_charges == 0 then
			-- Start Cooldown from caster.shrapnel_cooldown
			ability:StartCooldown( caster.shrapnel_cooldown )
			else
			ability:EndCooldown()
		end
		-- Deal damage
		RevealArea( keys )
	end
end
function shrapnel_start_cooldown( caster, charge_replenish_time )
	caster.shrapnel_cooldown = charge_replenish_time
	Timers:CreateTimer( function()
		local current_cooldown = caster.shrapnel_cooldown - 0.1
		if current_cooldown > 0.1 then
			caster.shrapnel_cooldown = current_cooldown
			return 0.1
			else
			return nil
		end
	end
	)
end

function RevealAreaItem( event )
	event.Radius = event.Radius/GameRules.MapSpeed
	RevealArea(event)
	local item = event.ability
end

function RevealArea( event )
	local status, nextCall = Error_debug.ErrorCheck(function() 
		local caster = event.caster
		local point = event.target_points[1]
		local visionRadius = string.match(GetMapName(),"1x1") and event.Radius*0.35 or string.match(GetMapName(),"arena") and event.Radius*0.58 or event.Radius
		local visionDuration = event.Duration
		AddFOWViewer(caster:GetTeamNumber(), point, visionRadius, visionDuration, false)
		local timeElapsed = 0
		--local unit = CreateUnitByName("npc_dota_units_base_reveal", point , true, nil, nil, caster:GetTeamNumber())

		--unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
    	--unit:AddNewModifier(unit, nil, "modifier_phased", {})
		--unit:AddNewModifier(unit, nil, "modifier_invisible", {})
		--unit:AddNewModifier(unit, nil, "modifier_invisible_truesight_immune", {})
		--unit:AddNewModifier(unit, nil, "modifier_kill", {duration = visionDuration})
		--unit:SetDayTimeVisionRange(visionRadius)
	--	unit:SetNightTimeVisionRange(visionRadius)
		Timers:CreateTimer(0.03,function()
			local units = FindUnitsInRadius(caster:GetTeamNumber(), point , nil, visionRadius , DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL  , DOTA_UNIT_TARGET_FLAG_NONE, 0 , false)
			for _,unit in pairs(units) do
				if unit ~= nil and unit:GetTeamNumber() ~= 3 then
					if unit:HasModifier("modifier_invisible") and not unit:HasModifier("modifier_invisible_truesight_immune") then -- 
						unit:RemoveModifierByName("modifier_invisible")
					end
					if unit:GetUnitName() == "event_boss_halloween" or unit:GetUnitName() == "event_line_boss_halloween" then 
						unit:AddNewModifier(unit, unit, "modifier_invisible_truesight_immune", {Duration = 60})
					end

					--if not unit:HasModifier("modifier_all_vision") then
					--	unit:AddNewModifier(unit, unit, "modifier_all_vision", {duration=5})
					--end
				end
			end
			timeElapsed = timeElapsed + 0.03
			if timeElapsed < visionDuration then
				return 0.03
			end
		end)
	end)
end

function TeleportTo (event)
	local caster = event.caster
	local hull = caster:GetHullRadius()
	for i=1,#GameRules.trollTps do
		local units = FindUnitsInRadius(caster:GetTeamNumber(), GameRules.trollTps[i] , nil, 200 , DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_NONE, 0 , false)
		if #units == 0 then
		--	caster:SetHullRadius(1) --160
			FindClearSpaceForUnit( caster , GameRules.trollTps[i] , true )
			
			break
		end
	end
	caster:AddNewModifier(caster, nil, "modifier_phased", {Duration = 1})
	--caster:SetHullRadius(hull) --160
end

function GoldOnAttack (event)
	if IsServer() and (event.unit:GetUnitName() ~= 'npc_dota_hero_doom_bringer' 
					or event.unit:GetUnitName() ~= 'npc_dota_hero_phantom_assassin'  
					or event.unit:GetUnitName() ~= 'npc_dota_hero_tidehunter'
					or event.unit:GetUnitName() ~= 'event_boss_halloween'
					or event.unit:GetUnitName() ~= 'npc_dota_hero_lina' ) then
		local caster = event.caster
		local dmg = math.floor(event.DamageDealt) * GameRules.MapSpeed
		PlayerResource:ModifyGold(caster,dmg)
		PopupGoldGain(caster,dmg)
		local target = event.unit
		caster.attackTarget = target:GetEntityIndex()
		target.attackers = target.attackers or {}
		target.attackers[caster:GetEntityIndex()] = true
		
		if caster:HasModifier("modifier_convert_gold") and PlayerResource:GetGold(caster:GetPlayerID()) >= 64000 then
			local gold = PlayerResource:GetGold(caster:GetPlayerID())
			local lumber = gold/64000 or 0
			gold = math.floor((lumber - math.floor(lumber)) * 64000) or 0
			lumber = math.floor(lumber)
			PlayerResource:SetGold(caster, gold, true)
			PlayerResource:ModifyLumber(caster, lumber, true)
		end
	end
end

function SkillOnSpellStart(event)
	if IsServer() then
		local caster = event.caster
		local playerID = caster:GetMainControllingPlayer()
		local hero = PlayerResource:GetSelectedHeroEntity(playerID)
		local ability = event.ability
		local skill_name = GetAbilityKV(ability:GetAbilityName()).SkillName
		local levelAbil = ability:GetLevel()
		if hero:FindModifierByName(skill_name) then
			if hero:FindModifierByName(skill_name):GetStackCount()+1 ~= levelAbil then
				ability:SetLevel(hero:FindModifierByName(skill_name):GetStackCount()+1)
			end	
		end
		local gold_cost = ability:GetSpecialValueFor("gold_cost")
		local lumber_cost = ability:GetSpecialValueFor("lumber_cost")
		levelAbil = ability:GetLevel()

		
		
		PlayerResource:ModifyGold(hero,-gold_cost)
		PlayerResource:ModifyLumber(hero,-lumber_cost)

		if PlayerResource:GetGold(playerID) < 0 then
			SendErrorMessage(playerID, "error_not_enough_gold")
			caster:AddNewModifier(nil, nil, "modifier_stunned", {duration=0.03})
			return false
		end
		if PlayerResource:GetLumber(playerID) < 0 then
			SendErrorMessage(playerID, "error_not_enough_lumber")
			caster:AddNewModifier(nil, nil, "modifier_stunned", {duration=0.03})
			return false
		end

		if levelAbil > ability:GetMaxLevel() then
			SendErrorMessage(playerID, "error_max_level")
			caster:AddNewModifier(nil, nil, "modifier_stunned", {duration=0.03})
			return false
		end
	end
end

function SkillOnChannelSucceeded(event)
	if IsServer() then
		local caster = event.caster
		local ability = event.ability
		local playerID = caster:GetPlayerOwnerID()
		local hero = PlayerResource:GetSelectedHeroEntity(playerID)
		local skill_name = GetAbilityKV(ability:GetAbilityName()).SkillName
		local stack = ability:GetLevel()
		hero:AddNewModifier(hero, hero, skill_name, {}):SetStackCount(stack)
		ability:SetLevel(stack+1)

		if (skill_name == "modifier_slayers_low" or skill_name == "modifier_slayers_max") and hero.slayer and not hero.slayer:GetRespawnsDisabled() then
			hero.slayer:AddNewModifier(hero.slayer, hero.slayer, skill_name .. "_aura", {}):SetStackCount(stack)
			return true	
		end

		for _, v in ipairs(hero.units) do
			if skill_name == "modifier_hp_wood_worker" and string.match(v:GetUnitName(),"wood_worker")  then
				v:AddNewModifier(v, v, skill_name .. "_aura", {}):SetStackCount(stack)
			elseif skill_name == "modifier_hp_walls_proc" and string.match(v:GetUnitName(),"rock") then
				v:AddNewModifier(v, v, skill_name .. "_aura", {}):SetStackCount(stack)
			elseif skill_name == "modifier_range_tower" and string.match(v:GetUnitName(),"tower") then
				v:AddNewModifier(v, v, skill_name .. "_aura", {}):SetStackCount(stack)
			elseif skill_name == "modifier_regen_walls_proc" and string.match(v:GetUnitName(),"rock") then
				v:AddNewModifier(v, v, skill_name .. "_aura", {}):SetStackCount(stack)	
			elseif skill_name == "modifier_mana_buffwalls" and string.match(v:GetUnitName(),"buff") then
				v:AddNewModifier(v, v, skill_name .. "_aura", {}):SetStackCount(stack)	
			elseif skill_name == "modifier_damage_tower" and string.match(v:GetUnitName(),"tower") then
				v:AddNewModifier(v, v, skill_name .. "_aura", {}):SetStackCount(stack)
			elseif skill_name == "modifier_armor_wall" and string.match(v:GetUnitName(),"rock") then
				v:AddNewModifier(v, v, skill_name .. "_aura", {}):SetStackCount(stack)
			elseif skill_name == "modifier_hp_reg_tower" and string.match(v:GetUnitName(),"tower") then
				v:AddNewModifier(v, v, skill_name .. "_aura", {}):SetStackCount(stack)
			elseif skill_name == "modifier_hp_walls" and string.match(v:GetUnitName(),"buff") then
				v:AddNewModifier(v, v, skill_name .. "_aura", {}):SetStackCount(stack)	
			elseif skill_name == "modifier_range_no_miss" and string.match(v:GetUnitName(),"tower") and tonumber(string.match(v:GetUnitName(),"%d+")) >= 9 then
				v:AddNewModifier(v, v, skill_name .. "_aura", {}):SetStackCount(stack)	
			end
		end
	end
end

function SkillOnChannelInterrupted(event)
	if IsServer() then
		local caster = event.caster
		local playerID = caster:GetPlayerOwnerID()
		local hero = PlayerResource:GetSelectedHeroEntity(playerID)
		local ability = event.ability
		local gold_cost = ability:GetSpecialValueFor("gold_cost")
		local lumber_cost = ability:GetSpecialValueFor("lumber_cost")
		PlayerResource:ModifyGold(hero,gold_cost,true)
		PlayerResource:ModifyLumber(hero,lumber_cost,true)
	end
end

function SpawnUnitOnSpellStart(event)
	if IsServer() then
		local caster = event.caster
		local playerID = caster:GetMainControllingPlayer()
		local hero = PlayerResource:GetSelectedHeroEntity(playerID)
		local ability = event.ability
		local unit_name = GetAbilityKV(ability:GetAbilityName()).UnitName
		local gold_cost = ability:GetSpecialValueFor("gold_cost")
		local lumber_cost = ability:GetSpecialValueFor("lumber_cost")
		local food = ability:GetSpecialValueFor("food_cost")
		local mine_cost = ability:GetSpecialValueFor("MineCost")
		PlayerResource:ModifyGold(hero,-gold_cost)
		PlayerResource:ModifyLumber(hero,-lumber_cost)
		PlayerResource:ModifyFood(hero,food)

		if PlayerResource:GetGold(playerID) < 0 then
			SendErrorMessage(playerID, "error_not_enough_gold")
			caster:AddNewModifier(nil, nil, "modifier_stunned", {duration=0.03})
			return false
		end
		if PlayerResource:GetLumber(playerID) < 0 then
			SendErrorMessage(playerID, "error_not_enough_lumber")
			caster:AddNewModifier(nil, nil, "modifier_stunned", {duration=0.03})
			return false
		end
		if (hero.food > GameRules.maxFood[playerID] and food ~= 0) or (hero.food > 300 and not GameRules.test2) then
			SendErrorMessage(playerID, "error_not_enough_food")
			caster:AddNewModifier(nil, nil, "modifier_stunned", {duration=0.03})
			ability:EndChannel(false)
			return false
		end
		if unit_name == "npc_dota_hero_templar_assassin" and hero.slayer then
			if not hero.slayer:GetRespawnsDisabled() then
				SendErrorMessage(playerID, "error_not_slayers_many")
				caster:AddNewModifier(nil, nil, "modifier_stunned", {duration=0.03})
				return false
			end
		end
	end
end

function SpawnUnitOnChannelSucceeded(event)
	--if IsServer() then
		local caster = event.caster
		local ability = event.ability
		local playerID = caster:GetPlayerOwnerID()
		local hero = PlayerResource:GetSelectedHeroEntity(playerID)
		local unit_name = GetAbilityKV(ability:GetAbilityName()).UnitName
		local unit_count = ability:GetSpecialValueFor("unit_count")
		if unit_name == "npc_dota_hero_templar_assassin" and not hero.slayer then
			local slayer = CreateUnitByName("npc_dota_hero_templar_assassin", caster:GetAbsOrigin() , true, hero, hero, hero:GetTeamNumber())
			hero.slayer=slayer
			FindClearSpaceForUnit(slayer, caster:GetOrigin(), false)
			slayer:SetOwner(hero)
			slayer:SetControllableByPlayer(playerID,true)
			--ability:SetHidden(true)
			local playername = PlayerResource:GetPlayerName(playerID)
			local abil2 = slayer:FindAbilityByName("slayer_blink")
        	abil2:SetLevel(abil2:GetMaxLevel())
			GameRules:SendCustomMessage("<font color='#009900'>"..playername.."</font> Create a slayer at "..ConvertToTime(GameRules:GetGameTime() - GameRules.startTime).." ", 0, 0)
			for index, shopTrigger in ipairs(GameRules.slayerUP) do
				local location = shopTrigger:GetAbsOrigin()
				MinimapEvent(hero:GetTeamNumber(), hero, location.x, location.y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 3 )
			end
			
			if hero:FindModifierByName("modifier_slayers_low")  then
				local stack = hero:FindModifierByName("modifier_slayers_low"):GetStackCount()
				slayer:AddNewModifier(slayer, slayer, "modifier_slayers_low_aura", {}):SetStackCount(stack)
			end
			if hero:FindModifierByName("modifier_slayers_max")  then
				local stack = hero:FindModifierByName("modifier_slayers_max"):GetStackCount()
				slayer:AddNewModifier(slayer, slayer, "modifier_slayers_max_aura", {}):SetStackCount(stack)
			end
			return true
		elseif unit_name == "npc_dota_hero_templar_assassin" and hero.slayer and hero.slayer:GetRespawnsDisabled() then
			hero.slayer:SetRespawnPosition(caster:GetAbsOrigin())
			hero.slayer:RespawnHero(false,false)
			hero.slayer:SetRespawnsDisabled(false)
			if hero:FindModifierByName("modifier_slayers_low")  then
				local stack = hero:FindModifierByName("modifier_slayers_low"):GetStackCount()
				hero.slayer:AddNewModifier(hero.slayer, hero.slayer, "modifier_slayers_low_aura", {}):SetStackCount(stack)
			end
			if hero:FindModifierByName("modifier_slayers_max")  then
				local stack = hero:FindModifierByName("modifier_slayers_max"):GetStackCount()
				hero.slayer:AddNewModifier(hero.slayer, hero.slayer, "modifier_slayers_max_aura", {}):SetStackCount(stack)
			end
			
			return true
		elseif unit_name == "npc_dota_hero_templar_assassin" and hero.slayer then
			SendErrorMessage(playerID, "error_not_slayers_many")
			return true
		end
		
		for a = 1,unit_count do
			local unit = CreateUnitByName(unit_name, caster:GetAbsOrigin() , true, nil, nil, hero:GetTeamNumber())
			unit:AddNewModifier(unit,nil,"modifier_phased",{duration = 0.03})
			unit:SetOwner(hero)
			table.insert(hero.units,unit)
			unit:SetControllableByPlayer(playerID, true)
			
			if string.match(unit_name,"build_worker") then
				ABILITY_Repair = unit:FindAbilityByName("repair")
				ABILITY_Repair:ToggleAutoCast()
				unit.units = {}
				unit.disabledBuildings = {}
				unit.buildings = {} -- This keeps the name and quantity of each building
				for _, buildingName in ipairs(GameRules.buildingNames) do
					unit.buildings[buildingName] = {
						startedConstructionCount = 0,
						completedConstructionCount = 0
					}
				end
				UpdateSpells(hero)
			end
			if hero:FindModifierByName("modifier_hp_wood_worker") and string.match(unit_name,"wood_worker") then
				local stack = hero:FindModifierByName("modifier_hp_wood_worker"):GetStackCount()
				unit:AddNewModifier(unit, unit, "modifier_hp_wood_worker_aura", {}):SetStackCount(stack)
			end		
		end
	--end
end


function SpawnUnitOnChannelInterrupted(event)
	if IsServer() then
		local caster = event.caster
		local playerID = caster:GetPlayerOwnerID()
		local hero = PlayerResource:GetSelectedHeroEntity(playerID)
		local ability = event.ability
		local unit_name = GetAbilityKV(ability:GetAbilityName()).UnitName
		local gold_cost = ability:GetSpecialValueFor("gold_cost")
		local lumber_cost = ability:GetSpecialValueFor("lumber_cost")
		local food = ability:GetSpecialValueFor("food_cost")
		local mine_cost = ability:GetSpecialValueFor("MineCost")
		PlayerResource:ModifyGold(hero,gold_cost,true)
		PlayerResource:ModifyLumber(hero,lumber_cost,true)
		PlayerResource:ModifyFood(hero,-food)
	end
end


THINK_INTERVAL = 0.5


function Repair(event)
	if IsServer() then
		local status, nextCall = Error_debug.ErrorCheck(function() 
		local args = {}
		args.PlayerID = event.caster:GetPlayerOwnerID()
		args.targetIndex = event.target:GetEntityIndex()
		args.queue = false
		BuildingHelper:RepairCommand(args)
		end)
	end
end

function RepairAutocast(event)
	local status, nextCall = Error_debug.ErrorCheck(function() 
	if IsServer() then
		local caster = event.caster
		local ability = event.ability
		local playerID = caster:GetPlayerOwnerID()
		local radius = event.Radius
		Timers:CreateTimer(function()
			if caster.state == "idle" and ability and not ability:IsNull() and ability:GetAutoCastState() then
				local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin() , nil, radius , DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING , DOTA_UNIT_TARGET_FLAG_NONE, 0 , false)
				for k,unit in pairs(units) do
					if IsCustomBuilding(unit) and unit:GetHealthDeficit() > 0 and unit.state == "complete" then
						BuildingHelper:AddRepairToQueue(caster, unit, true)
						caster.state = "repairing"
						break
					end
				end
			end
			return 0.5
		end)
	end
	end)
end

function GoldMineCreate(keys)
	if IsServer() then
		local caster = keys.caster
		local hero = caster:GetOwner()
		local playerID = caster:GetPlayerOwnerID()
		local amountPerSecond = GetUnitKV(caster:GetUnitName()).GoldAmount * GameRules.MapSpeed
		local maxGold = GetUnitKV(caster:GetUnitName(),"MaxGold") or 2000000
		local goldInterval = GetUnitKV(caster:GetUnitName(), "GoldInterval")
		ModifyGoldPerSecond(hero, amountPerSecond, goldInterval)
		local secondsToLive = maxGold/amountPerSecond;
		--keys.ability:StartCooldown(secondsToLive)
		
		caster.destroyTimer = Timers:CreateTimer(secondsToLive,
			function()
				caster:ForceKill(false)
			end)
			local dataTable = { entityIndex = caster:GetEntityIndex(), amount = amountPerSecond, interval = goldInterval, statusAnim = GameRules.PlayersFPS[playerID] }
			local player = hero:GetPlayerOwner()
			if player then
				CustomGameEventManager:Send_ServerToPlayer(player, "gold_gain_start", dataTable)
			end
	end
end

function GoldMineDestroy(keys)
	if IsServer() then
		local caster = keys.caster
		local hero = caster:GetOwner()
		local amountPerSecond = GetUnitKV(caster:GetUnitName()).GoldAmount * GameRules.MapSpeed
		local goldInterval = GetUnitKV(caster:GetUnitName(), "GoldInterval")
		ModifyGoldPerSecond(hero, -amountPerSecond, goldInterval)
		Timers:RemoveTimer(caster.destroyTimer)
		local dataTable = { entityIndex = caster:GetEntityIndex() }
		local player = hero:GetPlayerOwner()
		if player then
			CustomGameEventManager:Send_ServerToPlayer(player, "gold_gain_stop", dataTable)
		end
	end
end

function ModifyGoldPerSecond(hero, amount, interval) 
	hero.goldPerSecond = hero.goldPerSecond + (amount/interval)
end

function HpRegenModifier(keys)
	--print ( '[vladu4eg] HpRegenModifier' )
	local status, nextCall = Error_debug.ErrorCheck(function() 
	local caster = keys.caster
	
	if caster.hpReg == nil then
		caster.hpReg = 0
	end
	
	if caster.hpRegDebuff == nil then
		caster.hpRegDebuff = 0
	end	
	if caster and caster.hpReg then
		caster.hpReg = caster.hpReg + keys.Amount
		CustomGameEventManager:Send_ServerToAllClients("custom_hp_reg", { value=(max(caster.hpReg-caster.hpRegDebuff,0)),unit=caster:GetEntityIndex() })
	end
	if not caster:IsRealHero() then
		Timers:CreateTimer(function()
            if caster:IsNull() then return end
            local rate = FrameTime()
            local fullHpReg = math.max(caster.hpReg - caster.hpRegDebuff, 0)
            if fullHpReg > 0 and caster:IsAlive() then
                local optimalRate = 1 / fullHpReg
                rate = optimalRate > rate and optimalRate or rate
                local ratedHpReg = fullHpReg * rate
                caster:SetHealth(caster:GetHealth() + ratedHpReg)
            end
            return rate
        end)
	end
	end)
end

function HpRegenDestroy(keys)
	local status, nextCall = Error_debug.ErrorCheck(function() 
	keys.Amount = keys.Amount * (-1)
	HpRegenModifier(keys)
	end)
end



function BuyItemSlayer(event)
	local ability = event.ability
	local caster = event.caster
	local item_name = GetAbilityKV(ability:GetAbilityName()).ItemName
	local gold_cost = GetItemKV(item_name)["AbilitySpecial"]["02"]["gold_cost"];
	local lumber_cost = GetItemKV(item_name)["AbilitySpecial"]["03"]["lumber_cost"];
	local playerID = caster:GetPlayerOwnerID()
	local hero = PlayerResource:GetSelectedHeroEntity(playerID)

	if not hero.slayer then
		SendErrorMessage(playerID, "error_need_create_slayer")
		ability:EndCooldown()
		return
	end

	local origin_point = caster:GetAbsOrigin()
	local target_point = hero.slayer:GetAbsOrigin()
	local difference_vector = target_point - origin_point
	
	if difference_vector:Length2D() > 600 then  --Clamp the target point to the MaxBlinkRange range in the same direction.
		SendErrorMessage(playerID, "error_not_shop_area")
		ability:EndCooldown()
		return
	end

	if gold_cost > PlayerResource:GetGold(playerID) then
		SendErrorMessage(playerID, "error_not_enough_gold")
		ability:EndCooldown()
		return
	end
	if lumber_cost > PlayerResource:GetLumber(playerID) then
		SendErrorMessage(playerID, "error_not_enough_lumber")
		ability:EndCooldown()
		return
	end
	if hero.slayer:GetNumItemsInInventory() >= 6 then
	--	hero:DropStash()
		SendErrorMessage(playerID, "error_full_inventory")
		ability:EndCooldown()
		return		
	end
	
	PlayerResource:ModifyLumber(hero,-lumber_cost)
	PlayerResource:ModifyGold(hero,-gold_cost)
	local item = CreateItem(item_name, hero.slayer, hero.slayer)
	
	hero.slayer:AddItem(item)
end

function BuyItem(event)
	local ability = event.ability
	local caster = event.caster
	local item_name = GetAbilityKV(ability:GetAbilityName()).ItemName
	local gold_cost = GetItemKV(item_name)["AbilitySpecial"]["02"]["gold_cost"];
	local lumber_cost = GetItemKV(item_name)["AbilitySpecial"]["03"]["lumber_cost"];
	local playerID = caster.buyer
	local hero = PlayerResource:GetSelectedHeroEntity(playerID)
	local unit_name = caster:GetUnitName()
	if hero:IsElf() and not hero.slayer then
		SendErrorMessage(playerID, "error_need_create_slayer")
		ability:EndCooldown()
		return
	elseif hero.slayer then
		hero = hero.slayer
	end

	if hero:GetUnitName() == "npc_dota_hero_templar_assassin" and (string.match(unit_name, "shop") or string.match(unit_name, "troll_hut")) then
		SendErrorMessage(playerID, "error_its_shop_enemy")
		ability:EndCooldown()
		return
	end


	

	if not IsInsideShopArea(hero) 
	and item_name ~=  "item_golem_fire" 
	and item_name ~=  "item_golem_stone" 
	and item_name ~=  "item_golem_flesh" 
	and item_name ~=  "item_shade" 
	and item_name ~=  "item_assasin" 
	and item_name ~=  "item_fel_best" 
	and item_name ~=  "item_shade_2" 
	and item_name ~=  "item_sucied_boy" 
	and item_name ~=  "item_meat_carier" 
	and item_name ~=  "item_sniper" 
	and item_name ~=  "item_vamp_pudge" 
	then
		SendErrorMessage(playerID, "error_shop_out_of_range")
		ability:EndCooldown()
		return
	end
	if gold_cost > PlayerResource:GetGold(playerID) then
		SendErrorMessage(playerID, "error_not_enough_gold")
		ability:EndCooldown()
		return
	end
	if lumber_cost > PlayerResource:GetLumber(playerID) then
		SendErrorMessage(playerID, "error_not_enough_lumber")
		ability:EndCooldown()
		return
	end
	if hero:GetNumItemsInInventory() >= 9 then
	--	hero:DropStash()
		SendErrorMessage(playerID, "error_full_inventory")
		ability:EndCooldown()
		return		
	end
	if hero:FindItemInInventory("item_disable_repair_2") ~= nil and item_name == 'item_disable_repair_2'  then
		SendErrorMessage(playerID, "error_full_inventory")
		ability:EndCooldown()
		return		
	end
	if item_name == 'item_troll_boots_3' and (GameRules:GetGameTime() - GameRules.startTime) < (7200 / GameRules.MapSpeed) then
		SendErrorMessage(playerID, "error_no_time_boots")
		ability:EndCooldown()
		return	
	end
	
	if PlayerResource:GetSelectedHeroName(playerID) == "npc_dota_hero_wisp" then
		SendErrorMessage(playerID, "#error_no_buy_wisp")
		return false
	end	
	
	PlayerResource:ModifyLumber(hero,-lumber_cost)
	PlayerResource:ModifyGold(hero,-gold_cost)
	local item = CreateItem(item_name, hero, hero)
	

	
	--local units = Entities:FindAllByClassname("npc_dota_creature")
	--for _,unit in pairs(units) do
	--	local unit_name_hut = unit:GetUnitName();
	--	if unit_name_hut == "troll_hut_7" then
	--		item:SetShareability(ITEM_PARTIALLY_SHAREABLE)
	--	end
	--end
	hero:AddItem(item)
end

function IsInsideShopArea(unit) 
	for index, shopTrigger in ipairs(GameRules.shops) do
		if IsInsideBoxEntity(shopTrigger, unit) then
			return true
		end
	end
	return false
end

function IsInsideBoxEntity(box, unit)
	local boxOrigin = box:GetAbsOrigin()
	local bounds = box:GetBounds()
	local min = bounds.Mins
	local max = bounds.Maxs
	local unitOrigin = unit:GetAbsOrigin()
	local X = unitOrigin.x
	local Y = unitOrigin.y
	local minX = min.x + boxOrigin.x
	local minY = min.y + boxOrigin.y
	local maxX = max.x + boxOrigin.x
	local maxY = max.y + boxOrigin.y
	local betweenX = X >= minX and X <= maxX
	local betweenY = Y >= minY and Y <= maxY
	
	return betweenX and betweenY
end

function FountainRegen(event)
	local caster = event.caster
	local radius = event.Radius
	local units = FindUnitsInRadius(caster:GetTeamNumber() , caster:GetAbsOrigin() , nil , radius , DOTA_UNIT_TARGET_TEAM_BOTH ,  DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
	for _,unit in pairs(units) do
		unit:SetHealth(unit:GetHealth() + unit:GetMaxHealth() * 0.004)
		unit:SetMana(unit:GetMana() + unit:GetMaxMana() * 0.004)
	end
end

function BuyLumberTroll(event)
	local caster = event.caster
	local playerID = caster:GetPlayerOwnerID()
	local hero = PlayerResource:GetSelectedHeroEntity(playerID)
	local amount = event.Amount
	local price = amount * 8000
	if GameRules:GetGameTime() - GameRules.startTime < 180 then
		SendErrorMessage(caster:GetPlayerOwnerID(), "error_not_time_3_min")
		return false
	end
	if amount > 0 then
		if price > PlayerResource:GetGold(playerID) then
			SendErrorMessage(playerID, "error_not_enough_gold")
			return false
		end
	else
		if -amount > PlayerResource:GetLumber(playerID) then
			SendErrorMessage(playerID, "error_not_enough_lumber")
			return false
		end
	end
	PlayerResource:ModifyGold(hero,-price)
	PlayerResource:ModifyLumber(hero,amount)
end

function BuyGoldTroll(event)
	local caster = event.caster
	-- local playerID = caster:GetPlayerOwnerID()
	local playerID = caster.buyer
	local hero = PlayerResource:GetSelectedHeroEntity(playerID)
	local amount = event.Amount
	local price = amount * 8000
	local ability = event.ability
	if hero:IsElf() and not hero.slayer then
		SendErrorMessage(playerID, "error_need_create_slayer")
		ability:EndCooldown()
		return
	elseif hero.slayer then
		hero = hero.slayer
	end

	if not IsInsideShopArea(hero)  then
		SendErrorMessage(playerID, "error_shop_out_of_range")
		ability:EndCooldown()
		return
	end

	if GameRules:GetGameTime() - GameRules.startTime < 180 then
		SendErrorMessage(playerID, "error_not_time_3_min")
		ability:EndCooldown()
		return false
	end
	if amount > 0 then
		if price > PlayerResource:GetLumber(playerID) then
			SendErrorMessage(playerID, "error_not_enough_lumber")
			ability:EndCooldown()
			return false
		end
	end
	PlayerResource:ModifyGold(hero,amount)
	PlayerResource:ModifyLumber(hero,-price)
end

function CommitSuicide(event)
	local caster = event.caster
	--local units = FindUnitsInRadius(caster:GetTeamNumber() , caster:GetAbsOrigin() , nil , 64 , DOTA_UNIT_TARGET_TEAM_ENEMY ,  DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
	local playerID = caster:GetMainControllingPlayer()
	--if #units > 0 then
	--	SendErrorMessage(playerID, "error_enemy_nearby")
	--else
		PlayerResource:RemoveFromSelection(playerID, caster)
		BuildingHelper:ClearQueue(caster)
		caster:ForceKill(true) --This will call RemoveBuilding
		Timers:CreateTimer(10,function()
			UTIL_Remove(caster)
		end)
	--end
end

function ItemBlink(keys)
	ProjectileManager:ProjectileDodge(keys.caster)  --Disjoints disjointable incoming projectiles.
	
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, keys.caster)
	keys.caster:EmitSound("DOTA_Item.BlinkDagger.Activate")
	
	local origin_point = keys.caster:GetAbsOrigin()
	local target_point = keys.target_points[1]
	local difference_vector = target_point - origin_point
	
	if difference_vector:Length2D() > keys.MaxBlinkRange then  --Clamp the target point to the MaxBlinkRange range in the same direction.
		target_point = origin_point + (target_point - origin_point):Normalized() * keys.MaxBlinkRange
	end
	
	keys.caster:SetAbsOrigin(target_point)
	FindClearSpaceForUnit(keys.caster, target_point, false)
	
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, keys.caster)
end

function ItemBlinkDoom(keys)
	
	local origin_point = keys.caster:GetAbsOrigin()
	local target_point = keys.target_points[1]
	local difference_vector = target_point - origin_point
	local block = false
	--if difference_vector:Length2D() > keys.MaxBlinkRange then  --Clamp the target point to the MaxBlinkRange range in the same direction.
		target_point = origin_point + (target_point - origin_point):Normalized() * keys.MaxBlinkRange
	--end
	-- or not GridNav:CanFindPath(origin_point, target_point)
	if not GridNav:IsTraversable(target_point) or GridNav:IsBlocked(target_point) or GridNav:IsNearbyTree(target_point, 35, true)   then
		block = true
	end
	local units = FindUnitsInRadius(keys.caster:GetTeamNumber(), target_point , nil, 48 , DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL  , DOTA_UNIT_TARGET_FLAG_NONE, 0 , false)
	for _,unit in pairs(units) do
		if unit ~= nil then
			block = true
			break
		end
	end

	if not block then
		--local hull = keys.caster:GetHullRadius()
		--keys.caster:SetHullRadius(1)
		ProjectileManager:ProjectileDodge(keys.caster)  --Disjoints disjointable incoming projectiles.

		ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, keys.caster)
		keys.caster:EmitSound("DOTA_Item.BlinkDagger.Activate")

		--keys.caster:SetAbsOrigin(target_point)
		FindClearSpaceForUnit(keys.caster, target_point, true)
		
		ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, keys.caster)
		--keys.caster:AddNewModifier(keys.caster,nil,"modifier_phased",{duration = 0.03})
		--keys.caster:SetHullRadius(hull)
	else
		keys.ability:EndCooldown()
	end
	
end

function HealBuilding(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local heal = math.max(event.FixedHeal,(event.PercentageHeal*target:GetMaxHealth()/100))
	if target.state == "complete" then 
		if target.healed then
			heal = heal/3
		end
		if target:HasModifier("modifier_disable_repair") then
			heal = heal/2
		end
		if (target:GetHealth() + heal) > target:GetMaxHealth() then
			target:SetHealth(target:GetMaxHealth())
			else
			target:SetHealth(target:GetHealth() + heal)
		end
		target.healed = true
		Timers:CreateTimer(ability:GetCooldownTime(),function()
			target.healed = false
		end)
	end 
end

function GlyphItem(keys)
	local caster = keys.caster
	local target = caster
	local ability = keys.ability
	local time = keys.Modifier
	local playerID = caster:GetPlayerID()
	
	if string.match(GetMapName(),"clanwars") and GameRules.PlayersBase[playerID] == nil then
		SendErrorMessage(playerID, "error_need_put_flag")
		return
	end

	if target then
		target:AddNewModifier(target, target, "modifier_fountain_glyph", {Duration = time})
		FlagItem(keys)
	end
end

function PickAxe(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local time = keys.Modifier
	local playerID = caster:GetPlayerID()

	if string.match(target:GetUnitName(), "gold_mine") then
		ApplyDamage({victim = target, attacker = caster, damage = 999999, damage_type = DAMAGE_TYPE_PHYSICAL }) 
	else
		ability:EndCooldown()
	end
end

function FlagItem(keys)
	local caster = keys.caster
	local ability = keys.ability
	local baseID = BuildingHelper:IdBaseArea(caster)
	local playerID = caster:GetPlayerID()
	local koef = 1.5
	if string.match(GetMapName(),"clanwars") then
		koef = 3
	end
	if baseID ~= nil and baseID ~= GameRules.PlayersBase[playerID] then
		for pID = 0, DOTA_MAX_TEAM_PLAYERS do
			if PlayerResource:IsValidPlayerID(pID) then
				if GameRules.PlayersBase[pID] == baseID then
					ability:StartCooldown(ability:GetCooldown(1) * koef)
					return
				end
			end
		end
	end
end

function GiveResourcesRandom(event)
    local targetID = event.target
    local casterID = event.casterID
    local gold = PlayerResource:GetGold(casterID)
    local lumber = PlayerResource:GetLumber(casterID)
    if tonumber(gold) ~= nil and tonumber(lumber) ~= nil then
        if PlayerResource:GetSelectedHeroEntity(targetID) and
            PlayerResource:GetSelectedHeroEntity(targetID):GetTeam() == PlayerResource:GetSelectedHeroEntity(casterID):GetTeam() then
            local hero = PlayerResource:GetSelectedHeroEntity(targetID)
            local casterHero = PlayerResource:GetSelectedHeroEntity(casterID)
            if gold and lumber then
                if PlayerResource:GetGold(casterID) < gold or
                    PlayerResource:GetLumber(casterID) < lumber then
                    SendErrorMessage(casterID, "error_not_enough_resources")
                    return
				end
                PlayerResource:ModifyGold(casterHero, -gold, true)
                PlayerResource:ModifyLumber(casterHero, -lumber, true)
                PlayerResource:ModifyGold(hero, gold, true)
                PlayerResource:ModifyLumber(hero, lumber, true)
                PlayerResource:ModifyGoldGiven(targetID, -gold)
                PlayerResource:ModifyLumberGiven(targetID, -lumber)
                PlayerResource:ModifyGoldGiven(casterID, gold)
                PlayerResource:ModifyLumberGiven(casterID, lumber)
                if gold > 0 or lumber > 0 then
                    local text = PlayerResource:GetPlayerName(
					casterHero:GetPlayerOwnerID()) .. "(" .. GetModifiedName(casterHero:GetUnitName()) .. ") has sent "
                    if gold > 0 then
                        text = text .. "<font color='#F0BA36'>" .. gold .. "</font> gold"
					end
                    if gold > 0 and lumber > 0 then
                        text = text .. " and "
					end
                    if lumber > 0 then
                        text = text .. "<font color='#009900'>" .. lumber .. "</font> lumber"
					end
                    text = text .. " to " .. PlayerResource:GetPlayerName(hero:GetPlayerOwnerID()) .. "(" ..GetModifiedName(hero:GetUnitName()) .. ")!"
                    GameRules:SendCustomMessageToTeam(text, casterHero:GetTeamNumber(),0, 0)
				end
            else
                SendErrorMessage(event.casterID, "error_enter_only_digits")
			end
            else
            SendErrorMessage(event.casterID, "error_select_only_your_allies")
		end
        else
        SendErrorMessage(event.casterID, "error_type_only_digits")
	end
end

function DisableRepairKillWisp(keys)
	local caster = keys.caster
	local target = keys.target
	if string.match(target:GetUnitName(), "gold_mine") or string.match(target:GetUnitName(), "wisp") then
		
	else
		SendErrorMessage(event.casterID, "error_type_only_kill_wisp")
	end

end

function build_tree( event )
	local caster = event.caster
	local ability = event.ability
	local point = ability:GetCursorPosition()
	
	local treePos = Vector(point.x, point.y, 0)
    local tree -- Figure out which tree was cut
    for _, t in pairs(BuildingHelper.AllTrees) do
        local pos = t:GetAbsOrigin()
        if IsInsideBoxEntity2(point, pos) then
			BuildingHelper.TreeDummies[t:GetEntityIndex()] = nil
            UTIL_Remove(t.chopped_dummy)
			--BuildingHelper:BlockGridSquares(2, 2, pos)
		end
	end
end

function GiveWoodGoldForAttackTree (event)
	if IsServer() then
		local caster = event.caster
		local ability = event.ability
		local point = ability:GetCursorPosition()
		if BuildingHelper:IdBaseArea(caster) and BuildingHelper:IsInsideBaseArea(caster, caster, "", true) then
			PlayerResource:ModifyGold(caster, tonumber(event.Gold))
			PlayerResource:ModifyLumber(caster, tonumber(event.Wood))
			GridNav:DestroyTreesAroundPoint( point, event.Radius, false )
		else
			SendErrorMessage(caster:GetPlayerOwnerID(), "error_no_attack_tree")
		end
	end	
end

function IsInsideBoxEntity2(box, location)
    local origin = box
    local X = location.x
    local Y = location.y
    local minX = -600 + origin.x
    local minY = -600 + origin.y
    local maxX = 600 + origin.x
    local maxY = 600 + origin.y
    local betweenX = X >= minX and X <= maxX
    local betweenY = Y >= minY and Y <= maxY
    
    return betweenX and betweenY
end