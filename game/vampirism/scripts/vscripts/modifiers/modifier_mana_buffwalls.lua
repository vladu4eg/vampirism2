LinkLuaModifier("modifier_mana_buffwalls", "modifiers/modifier_mana_buffwalls.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mana_buffwalls_aura", "modifiers/modifier_mana_buffwalls.lua", LUA_MODIFIER_MOTION_NONE)
 modifier_mana_buffwalls = class({})

function  modifier_mana_buffwalls:CheckState() 
    return { [MODIFIER_STATE_BLOCK_DISABLED] = false}
end
--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------
 modifier_mana_buffwalls_aura = class({})

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
		local target = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		target:SetBaseManaRegen(target:GetManaRegen() + countStack)
	end
end

function  modifier_mana_buffwalls_aura:OnRefresh( kv )
	if IsServer() then
		local target = self:GetParent()
		local countStack = self:GetStackCount()
		target:SetBaseManaRegen(target:GetManaRegen() + countStack)
	end
end

function  modifier_mana_buffwalls_aura:OnRemoved(kv)
	if IsServer() then
		local target = self:GetParent()
		local mana = tonumber(GetUnitKV(target:GetUnitName(), "StatusManaRegen")) 
		target:SetBaseManaRegen(mana)
	end
end

function modifier_mana_buffwalls_aura:OnStackCountChanged()
	if IsServer() then
		local target = self:GetParent()
		local mana = tonumber(GetUnitKV(target:GetUnitName(), "StatusManaRegen")) 
		target:SetBaseManaRegen(mana)
		local countStack = self:GetStackCount()
		target:SetBaseManaRegen(target:GetManaRegen() + countStack)
	end
end
