LinkLuaModifier("modifier_hp_reg_tower", "modifiers/modifier_hp_reg_tower.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hp_reg_tower_aura", "modifiers/modifier_hp_reg_tower.lua", LUA_MODIFIER_MOTION_NONE)
 modifier_hp_reg_tower = class({})

function  modifier_hp_reg_tower:CheckState() 
    return { [MODIFIER_STATE_BLOCK_DISABLED] = false}
end
--------------------------------------------------------------------------------
function  modifier_hp_reg_tower:IsHidden()
    return true
end

function  modifier_hp_reg_tower:IsPurgable()
    return false
end

function  modifier_hp_reg_tower:IsStackable()
    return true
end

function  modifier_hp_reg_tower:IsPermanent()
	return false
end


--------------------------------------------------------------------------------
 modifier_hp_reg_tower_aura = class({})

function  modifier_hp_reg_tower_aura:IsHidden()
    return true
end

function  modifier_hp_reg_tower_aura:IsPurgable()
    return false
end

function  modifier_hp_reg_tower_aura:IsPermanent()
	return false
end

function  modifier_hp_reg_tower_aura:OnCreated( kv )
	if IsServer() then
		local target = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		target:SetMaxHealth(target:GetMaxHealth() + 2000 * countStack)
		target:SetBaseMaxHealth(target:GetBaseMaxHealth() + 2000 * countStack)
		target:SetHealth(target:GetHealth() + 2000 * countStack)
		target:SetBaseHealthRegen(target:GetBaseHealthRegen() + 5 * countStack)
	end
end

function  modifier_hp_reg_tower_aura:OnRefresh( kv )
	if IsServer() then
		local target = self:GetParent()
		local countStack = self:GetStackCount()
		target:SetMaxHealth(target:GetMaxHealth() + 2000 * countStack)
		target:SetBaseMaxHealth(target:GetBaseMaxHealth() + 2000 * countStack)
		target:SetHealth(target:GetHealth() + 2000 * countStack)
		target:SetBaseHealthRegen(target:GetBaseHealthRegen() + 5 * countStack)
	end
end

function  modifier_hp_reg_tower_aura:OnRemoved(kv)
	if IsServer() then
		local target = self:GetParent()
		local hp = tonumber(GetUnitKV(target:GetUnitName(), "StatusHealth"))
		local regen = tonumber(GetUnitKV(target:GetUnitName(), "StatusHealthRegen")) 
		target:SetMaxHealth(hp)
		target:SetBaseMaxHealth(hp)
		target:SetHealth(hp)
		target:SetBaseHealthRegen(regen)
	end
end

function modifier_hp_reg_tower_aura:OnStackCountChanged()
	if IsServer() then
		local target = self:GetParent()
		local hp = tonumber(GetUnitKV(target:GetUnitName(), "StatusHealth"))
		local regen = tonumber(GetUnitKV(target:GetUnitName(), "StatusHealthRegen")) 
		target:SetMaxHealth(hp)
		target:SetBaseMaxHealth(hp)
		target:SetHealth(hp)
		target:SetBaseHealthRegen(regen)

		local countStack = self:GetStackCount()
		target:SetMaxHealth(target:GetMaxHealth() + 2000 * countStack)
		target:SetBaseMaxHealth(target:GetBaseMaxHealth() + 2000 * countStack)
		target:SetHealth(target:GetHealth() + 2000 * countStack)
		target:SetBaseHealthRegen(target:GetBaseHealthRegen() + 5 * countStack)

	end
end