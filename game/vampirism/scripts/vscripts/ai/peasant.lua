Debug_Peasant = false

function PlayAttackAnimation( event )
	local caster = event.caster
	StartAnimation(caster, {duration=0.9, activity=ACT_DOTA_ATTACK , rate=1.0})
end

function StopAnimation( event )
	local caster = event.caster
	EndAnimation(caster)
end

-- Lumber gathering

function Gather( event )
	if not IsServer then
		return
	end

	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local target_class = target:GetClassname()

	-- Initialize variable to keep track of how much resource is the unit carrying
	if not caster.lumber_gathered then
		caster.lumber_gathered = 0
	end

	-- Intialize the variable to stop the return (workaround for ExecuteFromOrder being good and MoveToNPC now working after a Stop)
	caster.manual_order = false

	if target_class == "ent_dota_tree" then
		--caster:MoveToPosition(GetMoveToTreePosition( caster, target ))
		caster:MoveToPosition(target:GetAbsOrigin())
		caster.target_tree = target
	end

	caster:RemoveModifierByName("modifier_gathering_lumber")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_gathering_lumber", {})

	-- Visual fake toggle
	if ability:GetToggleState() == false then
		ability:ToggleAbility()
	end
end

-- Toggles Off Gather
function ToggleOffGather( event )
	if not IsServer then
		return
	end
	local caster = event.caster
	local gather_ability = caster:FindAbilityByName("gather_lumber_worker")

	--print(caster.lastOrder)

	if caster.lastOrder ~= DOTA_UNIT_ORDER_CAST_NO_TARGET 
	and caster.lastOrder ~= DOTA_UNIT_ORDER_MOVE_ITEM then
		if event["arg"] then
			caster:RemoveModifierByName(event["arg"])
		end

		caster:RemoveModifierByName("modifier_ability_gather_lumber_no_col")
		
		caster.target_tree.worker = nil

		if gather_ability:GetToggleState() == true then
			gather_ability:ToggleAbility()

		end
	end
end

-- Toggles Off Return because of an order (e.g. Stop)
function ToggleOffReturn( event )
	if not IsServer then
		return
	end
	local caster = event.caster
	local return_ability = caster:FindAbilityByName("return_resources")
	
	if caster.lastOrder ~= DOTA_UNIT_ORDER_CAST_NO_TARGET
	and caster.lastOrder ~= DOTA_UNIT_ORDER_MOVE_ITEM then
		caster:RemoveModifierByName("modifier_returning_resources_on_order_cancel")

		if return_ability:GetToggleState() == true then 
			return_ability:ToggleAbility()
			if Debug_Peasant then
				--print("Toggled Off Return")
			end
		end
	end
end

function CheckTreePosition( event )
	if not IsServer then
		return
	end
	local caster = event.caster
	local target = caster.target_tree -- Index tree so we know which target to start with
	local ability = event.ability
	local target_class = target:GetClassname()

	if target_class == "ent_dota_tree" then
		--caster:MoveToPosition(GetMoveToTreePosition( caster, target ))
		caster:MoveToPosition(target:GetAbsOrigin())
	end

	local distance = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Length()
	local collision = distance <= 170
	if not collision then
	elseif not caster:HasModifier("modifier_chopping_wood") then

		--caster:MoveToPosition(GetMoveToTreePosition( caster, target ))

		caster:RemoveModifierByName("modifier_gathering_lumber")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_chopping_wood", {})
	end
end

function GatherLumber( event )
	if not IsServer then
		return
	end
	local caster = event.caster
	local ability = event.ability
	local hero = PlayerResource:GetSelectedHeroEntity(caster:GetPlayerOwnerID())
	if caster == nil then
		return
	end
	local lumberGain = tonumber(GetUnitKV(caster:GetUnitName(), "LumberAmount") * GameRules.MapSpeed) 
	local lumberInterval = tonumber(GetUnitKV(caster:GetUnitName(), "LumberInterval")) 

	local max_lumber_carried = lumberGain / lumberInterval
	local single_chop = lumberGain
	
	

	local return_ability = caster:FindAbilityByName("return_resources")

	caster.lumber_gathered = caster.lumber_gathered + single_chop
 
	-- Increase up to the max, or cancel
	if caster.lumber_gathered < max_lumber_carried then
	else
		PlayerResource:ModifyLumber(hero,caster.lumber_gathered,true)
		PopupLumber(caster,math.floor(caster.lumber_gathered),true)
		caster.lumber_gathered = 0
	end
end


function ReturnResources( event )
	if not IsServer then
		return
	end
	local caster = event.caster
	local ability = event.ability

	if caster.lumber_gathered and caster.lumber_gathered > 0 then
		-- Find where to return the resources
		local building = FindClosestResourceDeposit( caster )
		if building == nil then return end
		if Debug_Peasant then
			print("Returning "..caster.lumber_gathered.." Lumber back to "..building:GetUnitName())
		end

		-- Set On, Wait one frame, as OnOrder gets executed before this is applied.
		Timers:CreateTimer(0.03, function() 
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_returning_resources_on_order_cancel", {})
			if ability:GetToggleState() == false then
				ability:ToggleAbility()

				if Debug_Peasant then
					print("Return Ability Toggled On")
				end
			end
		end)

		ExecuteOrderFromTable({ UnitIndex = caster:GetEntityIndex(), OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION, TargetIndex = building:GetEntityIndex(), Position = GetMoveToTreePosition( caster, building ), Queue = false}) 

		caster.target_building = building
	end
end

function CheckBuildingPosition( event )
	if not IsServer then
		return
	end
	local caster = event.caster
	local target = caster.target_building -- Index building so we know which target to start with
	local ability = event.ability

	local hero = PlayerResource:GetSelectedHeroEntity(caster:GetPlayerOwnerID())

	if not target or not caster or not caster.target_building then
		return
	end

	if target:IsNull() or caster:IsNull() or caster.target_building:IsNull() then
		return
	end

	local distance = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Length()
	local collision = distance <= (caster.target_building:GetHullRadius()+155)
	if collision and hero then
		local pID = hero:GetPlayerID()
		caster:RemoveModifierByName("modifier_returning_resources")
		caster:RemoveModifierByName("modifier_returning_resources_on_order_cancel")
		if Debug_Peasant then
			print("Removed modifier_returning_resources")
		end

		if caster.lumber_gathered > 0 then
			if Debug_Peasant then
				print("Reached building, give resources")
			end
 
			local lumber_gathered = caster.lumber_gathered
			caster.lumber_gathered = 0

			--
			if caster:HasAbility("petri_class_lumberjack") == true then
			    lumber_gathered = lumber_gathered * 2
			end
			--
		    
		   	-- EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "KVN.GatherWood", caster)
		   	caster:EmitSound("KVN.GatherWood")

			PlayerResource:ModifyLumber(hero,lumber_gathered,true)
			
		end

-- Return Ability Off
		if ability:ToggleAbility() == true then
			ability:ToggleAbility()
			if Debug_Peasant then
				print("Return Ability Toggled Off")
			end
		end

		-- Gather Ability
		local gather_ability = caster:FindAbilityByName("gather_lumber_worker")
		if gather_ability:ToggleAbility() == false then
			-- Fake toggle On
			gather_ability:ToggleAbility() 
			if Debug_Peasant then
				print("Gather Ability Toggled On")
			end
		end
		caster:CastAbilityOnTarget(caster.target_tree, gather_ability, pID)
		if Debug_Peasant then
			print("Casting ability to target tree")
		end
	end
end

function FindClosestResourceDeposit( caster )
	if not IsServer then
		return
	end
	local position = caster:GetAbsOrigin()

	local buildings = Entities:FindAllByClassname("npc_dota_creature*") 
	local sawmills = {}
	for _,building in pairs(buildings) do
		if building:GetUnitName() == "workersguild_1" or building:GetUnitName() == "workersguild_2" or building:GetUnitName() == "workersguild_3"  or building:GetUnitName() == "workersguild_4" or building:GetUnitName() == "workersguild_5"  then
			table.insert(sawmills, building)
		end
	end

	local distance = 9999
	local closest_building = nil

	if sawmills then
		-- print(table.getn(sawmills))
		if Debug_Peasant then
			print("barrack found")
		end
		for _,building in pairs(sawmills) do
			if building:GetPlayerOwnerID() == caster:GetPlayerOwnerID() then
				local this_distance = (position - building:GetAbsOrigin()):Length()
				if this_distance < distance then
					distance = this_distance
					closest_building = building
				end
			end
		end
		return closest_building

	end

end

function ReleaseTree( event )
	local caster = event.caster
	if caster.target_tree.worker ~= nil then
		caster.target_tree.worker = nil
	end
end

-- Misc

function Spawn( t )
	if not IsServer then
		return
	end
	local pID = thisEntity:GetPlayerOwnerID()
	local ability = thisEntity:FindAbilityByName("gather_lumber_worker")


	thisEntity.spawnPosition = thisEntity:GetAbsOrigin()

	Timers:CreateTimer(0.2, function()
		local trees = GridNav:GetAllTreesAroundPoint(thisEntity:GetAbsOrigin(), 750, true)

		local distance = 9999
		local z = 10
		local closest_tree = nil
		local position = thisEntity:GetAbsOrigin()

		if trees then
			for k, v in pairs(trees) do
				local this_distance = (position - v:GetAbsOrigin()):Length()
				local this_z = math.abs(v:GetAbsOrigin()["3"] - position["3"])

				if this_z < 10 and this_distance < distance  then
					distance = this_distance
					z = this_z

					closest_tree = v
				end
			end

			if closest_tree ~= nil then closest_tree.worker = thisEntity end
			thisEntity:CastAbilityOnTarget(closest_tree, ability,pID)
		end
	end)
end

function Suicide( keys )
	local caster = keys.caster
	local ability = keys.ability

	--if caster:GetUnitName() == "npc_petri_cop_trap" and caster:HasAbility("petri_building") and caster:GetPlayerOwner() and caster:GetPlayerOwner():GetAssignedHero() then
	--	caster:GetPlayerOwner():GetAssignedHero().cogK = caster:GetPlayerOwner():GetAssignedHero().cogK - 1
	--end
	
	caster:Kill(ability, caster)
end