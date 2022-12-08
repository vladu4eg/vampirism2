LinkLuaModifier("modifier_mana_buffwalls", "modifiers/modifier_mana_buffwalls.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mana_buffwalls_aura", "modifiers/modifier_mana_buffwalls.lua", LUA_MODIFIER_MOTION_NONE)
 modifier_mana_buffwalls = class({})

function  modifier_mana_buffwalls:CheckState() 
    return { [MODIFIER_STATE_BLOCK_DISABLED] = false}
end
--------------------------------------------------------------------------------
function  modifier_mana_buffwalls:IsAura()
	return true
end

function  modifier_mana_buffwalls:IsHidden()
    return true
end

function  modifier_mana_buffwalls:IsPurgable()
    return false
end

function  modifier_mana_buffwalls:IsStackable()
    return true
end

function  modifier_mana_buffwalls:IsPermanent()
	return false
end

function  modifier_mana_buffwalls:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC
end

function  modifier_mana_buffwalls:GetAuraRadius()
	return 9999999
end

function  modifier_mana_buffwalls:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function  modifier_mana_buffwalls:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function  modifier_mana_buffwalls:GetModifierAura()
	return "modifier_mana_buffwalls_aura"
end

--------------------------------------------------------------------------------
 modifier_mana_buffwalls_aura = class({})

function  modifier_mana_buffwalls_aura:IsAura()
	return true
end

function  modifier_mana_buffwalls_aura:IsHidden()
    return true
end

function  modifier_mana_buffwalls_aura:IsPurgable()
    return false
end

function  modifier_mana_buffwalls_aura:IsPermanent()
	return false
end

function  modifier_mana_buffwalls_aura:OnCreated( kv )
	if IsServer() then
			local caster = self:GetCaster()
			local target = self:GetParent()
			if caster:GetPlayerOwnerID() == target:GetPlayerOwnerID() and string.match(target:GetUnitName(), "buff")  then
				local countStack = caster:FindModifierByName("modifier_mana_buffwalls"):GetStackCount()
				if countStack == 0 then
					countStack = 1
				end
				target:SetBaseManaRegen(target:GetManaRegen() + countStack)
			end
	end
end

function  modifier_mana_buffwalls_aura:OnRefresh( kv )
	if IsServer() then
			local caster = self:GetCaster()
			local target = self:GetParent()
			if caster:GetPlayerOwnerID() == target:GetPlayerOwnerID() and string.match(target:GetUnitName(), "buff")  then
				local countStack = caster:FindModifierByName("modifier_mana_buffwalls"):GetStackCount()
				target:SetBaseManaRegen(target:GetManaRegen() + countStack)
			end
	end
end

function  modifier_mana_buffwalls_aura:OnRemoved(kv)
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		if caster:GetPlayerOwnerID() == target:GetPlayerOwnerID() and string.match(target:GetUnitName(), "buff")  then
			local mana = tonumber(GetUnitKV(target:GetUnitName(), "StatusManaRegen")) 
			target:SetBaseManaRegen(mana)
		end
	end
end
