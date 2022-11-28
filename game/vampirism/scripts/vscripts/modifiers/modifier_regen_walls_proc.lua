LinkLuaModifier("modifier_regen_walls_proc", "modifiers/modifier_regen_walls_proc.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_regen_walls_proc_aura", "modifiers/modifier_regen_walls_proc.lua", LUA_MODIFIER_MOTION_NONE)
modifier_regen_walls_proc = class({})

function modifier_regen_walls_proc:CheckState() 
    return { [MODIFIER_STATE_BLOCK_DISABLED] = false}
end
--------------------------------------------------------------------------------
function modifier_regen_walls_proc:IsAura()
	return true
end

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

function modifier_regen_walls_proc:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC
end

function modifier_regen_walls_proc:GetAuraRadius()
	return 9999999
end

function modifier_regen_walls_proc:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_regen_walls_proc:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_regen_walls_proc:GetModifierAura()
	return "modifier_regen_walls_proc_aura"
end

--------------------------------------------------------------------------------
modifier_regen_walls_proc_aura = class({})

function modifier_regen_walls_proc_aura:IsAura()
	return true
end

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
		Timers:CreateTimer(1,function()
			local caster = self:GetCaster()
			local target = self:GetParent()
			if caster:GetPlayerOwnerID() == target:GetPlayerOwnerID() and string.match(target:GetUnitName(), "rock")  then
				if target and target.hpReg then
					target.hpReg = target.hpReg * 1.2
					CustomGameEventManager:Send_ServerToAllClients("custom_hp_reg", { value=(max(target.hpReg-target.hpRegDebuff,0)),unit=target:GetEntityIndex() })
				else
					local countStack = caster:FindModifierByName("modifier_regen_walls_proc"):GetStackCount()
					target:SetBaseHealthRegen(target:GetBaseHealthRegen() * 1.20 * countStack)
				end
			end
		end)
		
	end
end


function modifier_regen_walls_proc_aura:OnRemoved(kv)
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		if caster:GetPlayerOwnerID() == target:GetPlayerOwnerID() and string.match(target:GetUnitName(), "rock")  then
			local regen = tonumber(GetUnitKV(target:GetUnitName(), "StatusHealthRegen")) 
			target:SetBaseHealthRegen(regen)
		end
	end
end

