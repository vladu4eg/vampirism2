function Spawn(event)
	local caster = event.caster
	local playerID = caster:GetPlayerID()
	local duration = event.ability:GetSpecialValueFor("duration")
    local food = event.ability:GetSpecialValueFor("food_cost")
    PlayerResource:ModifyFood(caster,food)
	if (caster.food > GameRules.maxFood[playerID] and food ~= 0) or caster.food > 20 then
		SendErrorMessage(playerID, "error_not_enough_food")
		PlayerResource:ModifyFood(caster,-food)
		return false
	end
    
    unit = CreateUnitByName(event.name_creep, caster:GetAbsOrigin(), true, caster, caster, caster:GetTeam())
    unit:SetControllableByPlayer(playerID, true)
	if duration and duration >= 99999 then
		unit:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
	end
    event.ability:SpendCharge()
	unit:AddNewModifier(unit, nil, "modifier_phased", {Duration = 0.3})
    -- ResolveNPCPositions(unit:GetAbsOrigin(),65)
end
		