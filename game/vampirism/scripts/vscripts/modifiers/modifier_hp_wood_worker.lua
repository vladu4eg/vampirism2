LinkLuaModifier("modifier_hp_wood_worker", "modifiers/modifier_hp_wood_worker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hp_wood_worker_aura", "modifiers/modifier_hp_wood_worker.lua", LUA_MODIFIER_MOTION_NONE)
modifier_hp_wood_worker = class({})

function modifier_hp_wood_worker:CheckState() 
    return { [MODIFIER_STATE_BLOCK_DISABLED] = false}
end
--------------------------------------------------------------------------------
function modifier_hp_wood_worker:IsAura()
	return true
end

function modifier_hp_wood_worker:IsHidden()
    return true
end

function modifier_hp_wood_worker:GetTexture()
	return "WitchCraftIcons_114_b"
end

function modifier_hp_wood_worker:IsPurgable()
    return false
end

function modifier_hp_wood_worker:IsStackable()
    return true
end

function modifier_hp_wood_worker:IsPermanent()
	return false
end

function modifier_hp_wood_worker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC
end

function modifier_hp_wood_worker:GetAuraRadius()
	return 9999999
end

function modifier_hp_wood_worker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_hp_wood_worker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_hp_wood_worker:GetModifierAura()
	return "modifier_hp_wood_worker_aura"
end

--------------------------------------------------------------------------------
modifier_hp_wood_worker_aura = class({})

function modifier_hp_wood_worker_aura:IsAura()
	return true
end

function modifier_hp_wood_worker_aura:IsHidden()
    return true
end

function modifier_hp_wood_worker_aura:IsPurgable()
    return false
end

function modifier_hp_wood_worker_aura:IsPermanent()
	return false
end

function modifier_hp_wood_worker_aura:GetTexture()
	return "WitchCraftIcons_114_b"
end

function modifier_hp_wood_worker_aura:OnCreated( kv )
	if IsServer() then
			local caster = self:GetCaster()
			local target = self:GetParent()
			if caster:GetPlayerOwnerID() == target:GetPlayerOwnerID() and string.match(target:GetUnitName(), "wood_worker")  then
				local countStack = caster:FindModifierByName("modifier_hp_wood_worker"):GetStackCount()
				if countStack == 0 then
					countStack = 1
				end
				target:SetMaxHealth(target:GetMaxHealth() + (350 * countStack))
				target:SetBaseMaxHealth(target:GetBaseMaxHealth() + (350 * countStack) )
				target:SetHealth(target:GetHealth() + (350 * countStack))
				--target:SetBaseDamageMin(target:GetBaseDamageMin() * dmg)	
				--target:SetBaseDamageMax(target:GetBaseDamageMax() * dmg) 
			end	
	end
end

function modifier_hp_wood_worker_aura:OnRefresh( )
	if IsServer() then
			local caster = self:GetCaster()
			local target = self:GetParent()
			if caster:GetPlayerOwnerID() == target:GetPlayerOwnerID() and string.match(target:GetUnitName(), "wood_worker")  then
				local countStack = caster:FindModifierByName("modifier_hp_wood_worker"):GetStackCount()
				target:SetMaxHealth(target:GetMaxHealth() + (350 * countStack))
				target:SetBaseMaxHealth(target:GetBaseMaxHealth() + (350 * countStack) )
				target:SetHealth(target:GetHealth() + (350 * countStack))
				--target:SetBaseDamageMin(target:GetBaseDamageMin() * dmg)	
				--target:SetBaseDamageMax(target:GetBaseDamageMax() * dmg) 
			end	
	end
end

function modifier_hp_wood_worker_aura:OnRemoved(kv)
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		if caster:GetPlayerOwnerID() == target:GetPlayerOwnerID() and string.match(target:GetUnitName(), "wood_worker")  then
			local hp = tonumber(GetUnitKV(target:GetUnitName(), "StatusHealth")) 
			target:SetMaxHealth(hp)
			target:SetBaseMaxHealth(hp)
			target:SetHealth(hp)
		end
	end
end



