LinkLuaModifier("modifier_slayers_low", "modifiers/modifier_slayers_low.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slayers_low_aura", "modifiers/modifier_slayers_low.lua", LUA_MODIFIER_MOTION_NONE)
 modifier_slayers_low = class({})

function  modifier_slayers_low:CheckState() 
    return { [MODIFIER_STATE_BLOCK_DISABLED] = false}
end
--------------------------------------------------------------------------------

function  modifier_slayers_low:IsHidden()
    return true
end

function  modifier_slayers_low:IsPurgable()
    return false
end

function  modifier_slayers_low:IsStackable()
    return true
end

function  modifier_slayers_low:IsPermanent()
	return false
end


--------------------------------------------------------------------------------
 modifier_slayers_low_aura = class({})

function  modifier_slayers_low_aura:IsHidden()
    return true
end

function  modifier_slayers_low_aura:IsPurgable()
    return false
end

function  modifier_slayers_low_aura:IsPermanent()
	return false
end

function  modifier_slayers_low_aura:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_BONUS,
    }
    return funcs
end


function modifier_slayers_low_aura:GetModifierPreAttack_BonusDamage()
	return 100 + 300 * self:GetStackCount()
end

function modifier_slayers_low_aura:GetModifierAttackRangeBonus()
	return 150 + 300 * self:GetStackCount()
end

function modifier_slayers_low_aura:GetModifierHealthBonus()
	return 1000 + 3000 * self:GetStackCount()
end


function modifier_slayers_low_aura:OnCreated( kv )
	if IsServer() then
		local target = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		self:SetStackCount(countStack)
	end
end
