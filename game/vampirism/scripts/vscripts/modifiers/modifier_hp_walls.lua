LinkLuaModifier("modifier_hp_walls", "modifiers/modifier_hp_walls.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hp_walls_aura", "modifiers/modifier_hp_walls.lua", LUA_MODIFIER_MOTION_NONE)
 modifier_hp_walls = class({})

function  modifier_hp_walls:CheckState() 
    return { [MODIFIER_STATE_BLOCK_DISABLED] = false}
end
--------------------------------------------------------------------------------
function  modifier_hp_walls:IsAura()
	return true
end

function  modifier_hp_walls:IsHidden()
    return true
end

function  modifier_hp_walls:IsPurgable()
    return false
end

function  modifier_hp_walls:IsStackable()
    return true
end

function  modifier_hp_walls:IsPermanent()
	return false
end

function  modifier_hp_walls:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC
end

function  modifier_hp_walls:GetAuraRadius()
	return 9999999
end

function  modifier_hp_walls:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function  modifier_hp_walls:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function  modifier_hp_walls:GetModifierAura()
	return "modifier_hp_walls_aura"
end

--------------------------------------------------------------------------------
 modifier_hp_walls_aura = class({})

function  modifier_hp_walls_aura:IsAura()
	return true
end

function  modifier_hp_walls_aura:IsHidden()
    return true
end

function  modifier_hp_walls_aura:IsPurgable()
    return false
end

function  modifier_hp_walls_aura:IsPermanent()
	return false
end

function  modifier_hp_walls_aura:OnCreated( kv )
	if IsServer() then
		Timers:CreateTimer(1,function()
			local caster = self:GetCaster()
			local target = self:GetParent()
			if caster:GetPlayerOwnerID() == target:GetPlayerOwnerID() and string.match(target:GetUnitName(), "buff")  then
				local countStack = caster:FindModifierByName("modifier_hp_walls"):GetStackCount()
				print(countStack)
				target:SetMaxHealth(target:GetMaxHealth() + (15000 * countStack))
				target:SetBaseMaxHealth(target:GetBaseMaxHealth() + (15000 * countStack))
				target:SetHealth(target:GetHealth() + (15000 * countStack))
				--target:SetBaseDamageMin(target:GetBaseDamageMin() * dmg)	
				--target:SetBaseDamageMax(target:GetBaseDamageMax() * dmg) 
			end
		end)
		
	end
end

function  modifier_hp_walls_aura:OnRemoved(kv)
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		if caster:GetPlayerOwnerID() == target:GetPlayerOwnerID() and string.match(target:GetUnitName(), "buff")  then
			local hp = tonumber(GetUnitKV(target:GetUnitName(), "StatusHealth")) 
			target:SetMaxHealth(hp)
			target:SetBaseMaxHealth(hp)
			target:SetHealth(hp)
		end
	end
end
