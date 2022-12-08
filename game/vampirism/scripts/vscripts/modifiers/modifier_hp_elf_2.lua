LinkLuaModifier("modifier_hp_elf_2", "modifiers/modifier_hp_elf_2.lua", LUA_MODIFIER_MOTION_NONE)

 modifier_hp_elf_2 = class({})

function  modifier_hp_elf_2:CheckState() 
    return { [MODIFIER_STATE_BLOCK_DISABLED] = false}
end
--------------------------------------------------------------------------------
function  modifier_hp_elf_2:IsAura()
	return false
end

function  modifier_hp_elf_2:IsHidden()
    return true
end

function  modifier_hp_elf_2:IsPurgable()
    return false
end

function  modifier_hp_elf_2:IsStackable()
    return true
end

function  modifier_hp_elf_2:IsPermanent()
	return false
end
function  modifier_hp_elf_2:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
    }
    return funcs
end

function modifier_hp_elf_2:GetModifierHealthBonus()
	return 9500 * self:GetStackCount()
end

function modifier_hp_elf_2:OnCreated( kv )
	if IsServer() then
			local caster = self:GetCaster()
			local target = self:GetParent()
			local countStack = caster:FindModifierByName("modifier_hp_elf_2"):GetStackCount()
			if countStack == 0 then
				countStack = 1
			end
			self:SetStackCount(countStack)
	end
end

function modifier_hp_elf_2:OnRefresh( kv )
	if IsServer() then
			local caster = self:GetCaster()
			local target = self:GetParent()
			local countStack = caster:FindModifierByName("modifier_hp_elf_2"):GetStackCount()
			self:SetStackCount(countStack)
	end
end