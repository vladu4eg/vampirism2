LinkLuaModifier("modifier_damage_tower", "modifiers/modifier_damage_tower.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_damage_tower_aura", "modifiers/modifier_damage_tower.lua", LUA_MODIFIER_MOTION_NONE)
 modifier_damage_tower = class({})


function  modifier_damage_tower:IsAura()
	return true
end

function  modifier_damage_tower:IsHidden()
    return true
end

function  modifier_damage_tower:IsPurgable()
    return false
end

function modifier_damage_tower:GetTexture()
	return "123_b"
end

function  modifier_damage_tower:IsStackable()
    return true
end

function  modifier_damage_tower:IsPermanent()
	return false
end

function  modifier_damage_tower:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC
end

function  modifier_damage_tower:GetAuraRadius()
	return 9999999
end

function  modifier_damage_tower:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function  modifier_damage_tower:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function  modifier_damage_tower:GetModifierAura()
	return "modifier_damage_tower_aura"
end
--------------------------------------------------------------------------------
 modifier_damage_tower_aura = class({})

function  modifier_damage_tower_aura:IsAura()
	return true
end

function  modifier_damage_tower_aura:IsHidden()
    return true
end

function  modifier_damage_tower_aura:IsPurgable()
    return false
end

function  modifier_damage_tower_aura:IsPermanent()
	return false
end
function  modifier_damage_tower_aura:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
    return funcs
end

function  modifier_damage_tower_aura:GetModifierPreAttack_BonusDamage()
	local target = self:GetParent()
	return 250 * self:GetStackCount()
end


function modifier_damage_tower_aura:OnCreated( kv )
	if IsServer() then
			local caster = self:GetCaster()
			local target = self:GetParent()
			if caster:GetPlayerOwnerID() == target:GetPlayerOwnerID() and string.match(target:GetUnitName(), "tower")  then
				local countStack = caster:FindModifierByName("modifier_damage_tower"):GetStackCount()
				print(countStack)
				if countStack == 0 then
					countStack = 1
				end
				self:SetStackCount(countStack)
			end
	end
end

function modifier_damage_tower_aura:OnRefresh( kv )
	if IsServer() then
			local caster = self:GetCaster()
			local target = self:GetParent()
			if caster:GetPlayerOwnerID() == target:GetPlayerOwnerID() and string.match(target:GetUnitName(), "tower")  then
				local countStack = caster:FindModifierByName("modifier_damage_tower"):GetStackCount()
				self:SetStackCount(countStack)
			end
	end
end
