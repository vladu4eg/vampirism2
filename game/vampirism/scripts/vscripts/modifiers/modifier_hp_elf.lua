LinkLuaModifier("modifier_hp_elf", "modifiers/modifier_hp_elf.lua", LUA_MODIFIER_MOTION_NONE)

 modifier_hp_elf = class({})

function  modifier_hp_elf:CheckState() 
    return { [MODIFIER_STATE_BLOCK_DISABLED] = false}
end
--------------------------------------------------------------------------------
function  modifier_hp_elf:IsAura()
	return false
end

function  modifier_hp_elf:IsHidden()
    return true
end

function  modifier_hp_elf:IsPurgable()
    return false
end

function  modifier_hp_elf:IsStackable()
    return true
end

function  modifier_hp_elf:IsPermanent()
	return false
end
function  modifier_hp_elf:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
    }
    return funcs
end

function modifier_hp_elf:GetModifierHealthBonus()
	return 4500 * self:GetStackCount()
end

function modifier_hp_elf:OnCreated( kv )
	if IsServer() then
			local caster = self:GetCaster()
			local target = self:GetParent()
			local countStack = caster:FindModifierByName("modifier_hp_elf"):GetStackCount()
			if countStack == 0 then
				countStack = 1
			end
			self:SetStackCount(countStack)
	end
end

function modifier_hp_elf:OnRefresh( kv )
	if IsServer() then
			local caster = self:GetCaster()
			local target = self:GetParent()
			local countStack = caster:FindModifierByName("modifier_hp_elf"):GetStackCount()
			self:SetStackCount(countStack)
	end
end