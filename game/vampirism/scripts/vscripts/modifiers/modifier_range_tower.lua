LinkLuaModifier("modifier_range_tower", "modifiers/modifier_range_tower.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_range_tower_aura", "modifiers/modifier_range_tower.lua", LUA_MODIFIER_MOTION_NONE)
 modifier_range_tower = class({})

function  modifier_range_tower:CheckState() 
    return { [MODIFIER_STATE_BLOCK_DISABLED] = false}
end
--------------------------------------------------------------------------------

function  modifier_range_tower:IsHidden()
    return true
end

function  modifier_range_tower:IsPurgable()
    return false
end

function modifier_range_tower:GetTexture()
	return "123_b"
end

function  modifier_range_tower:IsStackable()
    return true
end

function  modifier_range_tower:IsPermanent()
	return false
end

--------------------------------------------------------------------------------
 modifier_range_tower_aura = class({})

function  modifier_range_tower_aura:IsHidden()
    return true
end

function  modifier_range_tower_aura:IsPurgable()
    return false
end

function  modifier_range_tower_aura:IsPermanent()
	return false
end

function  modifier_range_tower_aura:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    }
    return funcs
end

function  modifier_range_tower_aura:GetModifierAttackRangeBonus()
	return 100 * self:GetStackCount()
end


function modifier_range_tower_aura:OnCreated( kv )
	if IsServer() then
		local target = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		self:SetStackCount(countStack)
	end
end