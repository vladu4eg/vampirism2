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
		Timers:CreateTimer(1,function()
			local caster = self:GetCaster()
			local target = self:GetParent()
			local countStack = caster:FindModifierByName("modifier_hp_elf"):GetStackCount()
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

function modifier_hp_elf:OnIntervalThink()
	local target = self:GetParent()
	target:CalculateStatBonus(true)
	self:ForceRefresh()
	self:SendBuffRefreshToClients()
	target:CalculateStatBonus(true)
end