LinkLuaModifier("modifier_hp_walls", "modifiers/modifier_hp_walls.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hp_walls_aura", "modifiers/modifier_hp_walls.lua", LUA_MODIFIER_MOTION_NONE)
 modifier_hp_walls = class({})

function  modifier_hp_walls:CheckState() 
    return { [MODIFIER_STATE_BLOCK_DISABLED] = false}
end
--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------
 modifier_hp_walls_aura = class({})

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
		local target = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		target:SetMaxHealth(target:GetMaxHealth() + (15000 * countStack))
		target:SetBaseMaxHealth(target:GetBaseMaxHealth() + (15000 * countStack))
		target:SetHealth(target:GetHealth() + (15000 * countStack))
	end
end

function  modifier_hp_walls_aura:OnRefresh( kv )
	if IsServer() then
		local target = self:GetParent()
		local countStack = self:GetStackCount()
		target:SetMaxHealth(target:GetMaxHealth() + (15000 * countStack))
		target:SetBaseMaxHealth(target:GetBaseMaxHealth() + (15000 * countStack))
		target:SetHealth(target:GetHealth() + (15000 * countStack))
	end
end

function  modifier_hp_walls_aura:OnRemoved(kv)
	if IsServer() then
		local target = self:GetParent()
		local hp = tonumber(GetUnitKV(target:GetUnitName(), "StatusHealth")) 
		target:SetMaxHealth(hp)
		target:SetBaseMaxHealth(hp)
		target:SetHealth(hp)
	end
end

function modifier_hp_walls_aura:OnStackCountChanged()
	if IsServer() then
		local target = self:GetParent()
		local hp = tonumber(GetUnitKV(target:GetUnitName(), "StatusHealth")) 
		target:SetMaxHealth(hp)
		target:SetBaseMaxHealth(hp)
		target:SetHealth(hp)
		
		local countStack = self:GetStackCount()
		target:SetMaxHealth(target:GetMaxHealth() + (15000 * countStack))
		target:SetBaseMaxHealth(target:GetBaseMaxHealth() + (15000 * countStack))
		target:SetHealth(target:GetHealth() + (15000 * countStack))
	end

end