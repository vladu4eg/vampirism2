--[[
	Author: Noya
	Date: April 5, 2015.
	FURION CAN YOU TP TOP? FURION CAN YOU TP TOP? CAN YOU TP TOP? FURION CAN YOU TP TOP? 
]]
function Teleport( event )
	local caster = event.caster
	local playerID = caster:GetPlayerOwnerID()
	local point = event.target:GetAbsOrigin()
	local hull = caster:GetHullRadius()
	if string.match(event.target:GetUnitName(), "ward") or 
	   string.match(event.target:GetUnitName(), "assasin") or 
	   string.match(event.target:GetUnitName(), "golem") or 
	   string.match(event.target:GetUnitName(), "fel_best") or 
	   event.target:GetUnitName() == "shade_2" or 
	   event.target:GetUnitName() == "sucied_boy" then
		
		SendErrorMessage(playerID, "error_no_take_ward")
		event.ability:EndCooldown()
		return
	end
	caster:SetHullRadius(1) --160
	if point == caster:GetAbsOrigin() then
		local units = Entities:FindAllByClassname("npc_dota_creature")
        for _, unit in pairs(units) do
            local unit_name = unit:GetUnitName();
            if string.match(unit_name, "hut") then
				FindClearSpaceForUnit(caster, unit:GetAbsOrigin(), true)
            end
        end
	else
		FindClearSpaceForUnit(caster, point, true)
	end
    caster:Stop() 
    EndTeleport(event,hull)   
end

function CreateTeleportParticles( event )
	local caster = event.caster
	local point = event.target:GetAbsOrigin()
	local particleName = "particles/econ/items/natures_prophet/natures_prophet_weapon_sufferwood/furion_teleport_end_sufferwood.vpcf"
	caster.teleportParticle = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(caster.teleportParticle, 1, point)	
end

function EndTeleport( event,hull )
	local caster = event.caster
	local team = caster:GetTeamNumber()
	ParticleManager:DestroyParticle(caster.teleportParticle, false)
	caster:StopSound("Hero_Furion.Teleport_Grow")
	if team == DOTA_TEAM_BADGUYS then
		caster:SetHullRadius(hull) --160
	end
end
