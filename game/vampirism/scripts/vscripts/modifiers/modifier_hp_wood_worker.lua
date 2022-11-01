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
    return false
end

function modifier_hp_wood_worker:IsPurgable()
    return false
end

function modifier_hp_wood_worker:IsPermanent()
	return true
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
function modifier_hp_wood_worker:DeclareFunctions()
	return { MODIFIER_PROPERTY_HEALTH_BONUS}
end

function modifier_hp_wood_worker:GetModifierHealthBonus()
	local caster = self:GetCaster()
	local target = self:GetParent()
	if caster:GetPlayerOwnerID() == target:GetPlayerOwnerID() then
		return 250 --self:GetStackCount() * 
	end
	
	return 551

	
end
--------------------------------------------------------------------------------
modifier_hp_wood_worker_aura = class({})

function modifier_hp_wood_worker_aura:IsAura()
	return true
end

function modifier_hp_wood_worker_aura:IsHidden()
    return false
end

function modifier_hp_wood_worker_aura:IsPurgable()
    return false
end

function modifier_hp_wood_worker_aura:IsPermanent()
	return true
end

function modifier_hp_wood_worker_aura:DeclareFunctions()
	return { MODIFIER_PROPERTY_HEALTH_BONUS,
			 MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
end

function modifier_hp_wood_worker_aura:GetModifierHealthBonus()
	local caster = self:GetCaster()
	local target = self:GetParent()
	target:SetMaxHealth(target:GetBaseMaxHealth()+1300)
	target:SetHealth(target:GetBaseMaxHealth()+1300)
	if caster:GetPlayerOwnerID() == target:GetPlayerOwnerID() then
		return 250 --self:GetStackCount() * 
	end
	
	return 551

	
end

function modifier_hp_wood_worker_aura:GetModifierPhysicalArmorBonus()
	local caster = self:GetCaster()
	local target = self:GetParent()
	if caster:GetPlayerOwnerID() == target:GetPlayerOwnerID() then
		return 250 --self:GetStackCount() * 
	end
	
	return 551

	
end

