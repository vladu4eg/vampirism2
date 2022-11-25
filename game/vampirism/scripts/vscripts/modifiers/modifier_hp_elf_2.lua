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
    return false
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
	return 95000 * self:GetStackCount()
end

function modifier_hp_elf_2:OnCreated( kv )
	if IsServer() then
		Timers:CreateTimer(0.5,function()
			local caster = self:GetCaster()
			local target = self:GetParent()
			local countStack = caster:FindModifierByName("modifier_hp_elf_2"):GetStackCount()
			self:SetStackCount(countStack)
			target:CalculateStatBonus(true)
			self:ForceRefresh()
			self:SendBuffRefreshToClients()
			target:CalculateStatBonus(true)
			self:StartIntervalThink( 1 )
			self:OnIntervalThink()
		end)
		
	end
end

function modifier_hp_elf_2:OnIntervalThink()
	local target = self:GetParent()
	target:CalculateStatBonus(true)
	self:ForceRefresh()
	self:SendBuffRefreshToClients()
	target:CalculateStatBonus(true)
end