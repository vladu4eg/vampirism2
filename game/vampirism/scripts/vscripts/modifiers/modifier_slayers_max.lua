LinkLuaModifier("modifier_slayers_max", "modifiers/modifier_slayers_max.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slayers_max_aura", "modifiers/modifier_slayers_max.lua", LUA_MODIFIER_MOTION_NONE)
 modifier_slayers_max = class({})

function  modifier_slayers_max:CheckState() 
    return { [MODIFIER_STATE_BLOCK_DISABLED] = false}
end
--------------------------------------------------------------------------------
function  modifier_slayers_max:IsHidden()
    return true
end

function  modifier_slayers_max:IsPurgable()
    return false
end

function  modifier_slayers_max:IsStackable()
    return true
end

function  modifier_slayers_max:IsPermanent()
	return false
end

--------------------------------------------------------------------------------
 modifier_slayers_max_aura = class({})

function  modifier_slayers_max_aura:IsHidden()
    return true
end

function  modifier_slayers_max_aura:IsPurgable()
    return false
end

function  modifier_slayers_max_aura:IsPermanent()
	return false
end

function  modifier_slayers_max_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_BONUS,
    }
    return funcs
end


function modifier_slayers_max_aura:GetModifierPreAttack_BonusDamage()
	return 10000 * self:GetStackCount()
end

function modifier_slayers_max_aura:GetModifierHealthBonus()
	return 100000 * self:GetStackCount()
end



function modifier_slayers_max_aura:OnCreated( kv )
	if IsServer() then
	local target = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		self:SetStackCount(countStack)
	end
end
