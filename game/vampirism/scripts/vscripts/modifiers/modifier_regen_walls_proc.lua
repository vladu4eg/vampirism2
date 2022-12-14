LinkLuaModifier("modifier_regen_walls_proc", "modifiers/modifier_regen_walls_proc.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_regen_walls_proc_aura", "modifiers/modifier_regen_walls_proc.lua", LUA_MODIFIER_MOTION_NONE)
modifier_regen_walls_proc = class({})

function modifier_regen_walls_proc:CheckState() 
    return { [MODIFIER_STATE_BLOCK_DISABLED] = false}
end
--------------------------------------------------------------------------------

function modifier_regen_walls_proc:IsHidden()
    return true
end

function modifier_regen_walls_proc:GetTexture()
	return "addons_48_b"
end

function modifier_regen_walls_proc:IsPurgable()
    return false
end

function modifier_regen_walls_proc:IsStackable()
    return true
end

function modifier_regen_walls_proc:IsPermanent()
	return false
end

--------------------------------------------------------------------------------
modifier_regen_walls_proc_aura = class({})

function modifier_regen_walls_proc_aura:IsHidden()
    return true
end

function modifier_regen_walls_proc_aura:IsPurgable()
    return false
end

function modifier_regen_walls_proc_aura:IsPermanent()
	return false
end

function modifier_regen_walls_proc_aura:OnCreated( kv )
	if IsServer() then
		local target = self:GetParent()
		if target and target.hpReg then
			target.hpReg = target.hpReg * 1.2
			CustomGameEventManager:Send_ServerToAllClients("custom_hp_reg", { value=(max(target.hpReg,0)),unit=target:GetEntityIndex() })
		else
			local countStack = self:GetStackCount()
			if countStack == 0 then
				countStack = 1
			end
			target:SetBaseHealthRegen(target:GetBaseHealthRegen() * 1.20 * countStack)
		end
	end
end

function modifier_regen_walls_proc_aura:OnRefresh( kv )
	if IsServer() then
		local target = self:GetParent()
		if target and target.hpReg then
			target.hpReg = target.hpReg * 1.2
			CustomGameEventManager:Send_ServerToAllClients("custom_hp_reg", { value=(max(target.hpReg,0)),unit=target:GetEntityIndex() })
		else
			local countStack = self:GetStackCount()
			target:SetBaseHealthRegen(target:GetBaseHealthRegen() * 1.20 * countStack)
		end		
	end
end


function modifier_regen_walls_proc_aura:OnRemoved(kv)
	if IsServer() then
		local target = self:GetParent()
		local regen = tonumber(GetUnitKV(target:GetUnitName(), "StatusHealthRegen")) 
		target:SetBaseHealthRegen(regen)
	end
end

function modifier_regen_walls_proc_aura:OnStackCountChanged()
	if IsServer() then
		local target = self:GetParent()
		local regen = tonumber(GetUnitKV(target:GetUnitName(), "StatusHealthRegen")) 
		target:SetBaseHealthRegen(regen)
		if target and target.hpReg then
			target.hpReg = target.hpReg * 1.2
			CustomGameEventManager:Send_ServerToAllClients("custom_hp_reg", { value=(max(target.hpReg,0)),unit=target:GetEntityIndex() })
		else
			local countStack = self:GetStackCount()
			target:SetBaseHealthRegen(target:GetBaseHealthRegen() * 1.20 * countStack)
		end	
	end
end