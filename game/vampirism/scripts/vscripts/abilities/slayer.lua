-- Slayer blink, global version of human blink
function SlayerBlink( keys )
  local caster = keys.caster
  local ability = keys.ability
  local point = keys.target_points[1]
  
  local newSpace = FindGoodSpaceForUnit(caster, point, 500, nil)
  if newSpace ~= false then
    caster:SetAbsOrigin(newSpace)
  else
    FireGameEvent('custom_error_show', {player_ID = caster:GetMainControllingPlayer(), _error = "Can't blink there!"})
    ability:RefundManaCost()
    ability:EndCooldown()
  end
end


-- Slayer tracker, for finding invis units
function SlayerSummonTracker( keys )
  local caster = keys.caster
  local pID = caster:GetMainControllingPlayer()
  local time_life = keys.InvulRadius
  local countWorkers = keys.CountWorkers
  
  for i = 1, countWorkers do
			if IsServer() then
				CreateUnitByNameAsync("worker_1" , caster:GetAbsOrigin() + RandomVector( RandomFloat( 50, 200 ) ), true, nil, nil, caster:GetTeam(), function(unit)
          unit:SetControllableByPlayer(pID, true)
          unit:AddNewModifier(unit, nil, "modifier_kill", {duration = time_life})
          unit:AddNewModifier(unit,nil,"modifier_phased",{duration = 0.03})
          ABILITY_Repair = unit:FindAbilityByName("repair")
				  ABILITY_Repair:ToggleAutoCast()
				end)
			end
		end
end


-- Tracker death
function SlayerRemoveTracker( keys )
  local caster = keys.caster
   
  caster:RemoveSelf()
end

-- Slayer building invuln start
function SlayerBuildingProtection( keys )
  local caster = keys.caster
  local radius = keys.InvulRadius
  local pID = caster:GetMainControllingPlayer()
  local ability = keys.ability

  local nearby_units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin() , nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, 0, false) 
  for i, nearby in ipairs(nearby_units) do
    if nearby:GetPlayerOwnerID() == pID then
      if nearby.state == "complete" then
        nearby:AddNewModifier(nearby, nil, "modifier_fountain_glyph",{})
        print("DONE")
      end
    end
  end
end

-- Slayer building invuln end
function SlayerBuildingProtectionEnd( keys )
  local caster = keys.caster
  local radius = keys.InvulRadius
  local pID = caster:GetMainControllingPlayer()

  local nearby_units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin() , nil, radius*2, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false) 

  for i, nearby in ipairs(nearby_units) do
    if nearby:GetMainControllingPlayer() == pID then
      
      --if nearby:HasModifier("modifier_building_invulnerable") then
        print("wtf")
        PrintTable(nearby_units)
        nearby:RemoveModifierByName("modifier_fountain_glyph")
     -- end
    end
  end
end

-- Slayer Avatar
function SlayerAvatarStart( keys )
  local caster = keys.caster
  local modelscale = keys.Modelscale
  local scalefinish = 1.0 + modelscale * 1.0 / 100.0
  local scale = 1.0

  Timers:CreateTimer(0.3, function ()
    if scale < scalefinish then
      caster:SetModelScale(scale)
      scale = scale + 0.01
      return 0.03
    else
      return nil
    end
  end)
end

-- Slayer Avatar end
function SlayerAvatarEnd( keys )
  local caster = keys.caster
  local modelscale = keys.Modelscale
  local scalestart = 1.0 + modelscale * 1.0 / 100.0
  local scalefinish = 0.7

  Timers:CreateTimer(0.3, function ()
    if scalestart > scalefinish then
      caster:SetModelScale(scalestart)
      scalestart = scalestart - 0.01
      return 0.03
    else
      return nil
    end
  end)
end

