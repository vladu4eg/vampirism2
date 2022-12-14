LinkLuaModifier("modifier_hp_walls_proc", "modifiers/modifier_hp_walls_proc.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hp_walls_proc_aura", "modifiers/modifier_hp_walls_proc.lua", LUA_MODIFIER_MOTION_NONE)
 modifier_hp_walls_proc = class({})

function  modifier_hp_walls_proc:CheckState() 
    return { [MODIFIER_STATE_BLOCK_DISABLED] = false}
end
--------------------------------------------------------------------------------

function  modifier_hp_walls_proc:IsHidden()
    return true
end

function modifier_hp_walls_proc:GetTexture()
	return "SGI_addons_184"
end

function  modifier_hp_walls_proc:IsPurgable()
    return false
end

function  modifier_hp_walls_proc:IsStackable()
    return true
end

function  modifier_hp_walls_proc:IsPermanent()
	return false
end

--------------------------------------------------------------------------------
 modifier_hp_walls_proc_aura = class({})

function  modifier_hp_walls_proc_aura:IsHidden()
    return true
end

function  modifier_hp_walls_proc_aura:IsPurgable()
    return false
end

function  modifier_hp_walls_proc_aura:IsPermanent()
	return false
end

function  modifier_hp_walls_proc_aura:OnCreated( kv )
	if IsServer() then
		local target = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		target:SetMaxHealth(target:GetMaxHealth() * (0.2 * countStack + 1))
		target:SetBaseMaxHealth(target:GetBaseMaxHealth() * (0.2 * countStack + 1) )
		target:SetHealth(target:GetHealth() * (0.2 * countStack + 1))
	end
end

function  modifier_hp_walls_proc_aura:OnRefresh( kv )
	if IsServer() then
		local target = self:GetParent()
		local countStack = self:GetStackCount()
		target:SetMaxHealth(target:GetMaxHealth() * (0.2 * countStack + 1))
		target:SetBaseMaxHealth(target:GetBaseMaxHealth() * (0.2 * countStack + 1) )
		target:SetHealth(target:GetHealth() * (0.2 * countStack + 1))
	end
end

function  modifier_hp_walls_proc_aura:OnRemoved(kv)
	if IsServer() then
		local target = self:GetParent()
		local hp = tonumber(GetUnitKV(target:GetUnitName(), "StatusHealth")) 
		target:SetMaxHealth(hp)
		target:SetBaseMaxHealth(hp)
		target:SetHealth(hp)
	end
end

function modifier_hp_walls_proc_aura:OnStackCountChanged()
	if IsServer() then
		local target = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		local hp = tonumber(GetUnitKV(target:GetUnitName(), "StatusHealth")) 
		target:SetMaxHealth(hp)
		target:SetBaseMaxHealth(hp)
		target:SetHealth(hp)

		target:SetMaxHealth(target:GetMaxHealth() * (0.2 * countStack + 1))
		target:SetBaseMaxHealth(target:GetBaseMaxHealth() * (0.2 * countStack + 1) )
		target:SetHealth(target:GetHealth() * (0.2 * countStack + 1))
	end
end

function modifier_hp_walls_proc_aura:GetTexture()
	return "SGI_addons_184"
end
