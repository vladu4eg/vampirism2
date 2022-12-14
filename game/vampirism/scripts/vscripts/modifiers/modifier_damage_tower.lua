LinkLuaModifier("modifier_damage_tower", "modifiers/modifier_damage_tower.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_damage_tower_aura", "modifiers/modifier_damage_tower.lua", LUA_MODIFIER_MOTION_NONE)
modifier_damage_tower = class({})

function  modifier_damage_tower:IsHidden()
    return true
end

function  modifier_damage_tower:IsPurgable()
    return false
end

function modifier_damage_tower:GetTexture()
	return "123_b"
end

function  modifier_damage_tower:IsStackable()
    return true
end

function  modifier_damage_tower:IsPermanent()
	return false
end

--------------------------------------------------------------------------------
 modifier_damage_tower_aura = class({})

function  modifier_damage_tower_aura:IsHidden()
    return true
end

function  modifier_damage_tower_aura:IsPurgable()
    return false
end

function  modifier_damage_tower_aura:IsPermanent()
	return false
end
function  modifier_damage_tower_aura:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
    return funcs
end

function  modifier_damage_tower_aura:GetModifierPreAttack_BonusDamage()
	return 250 * self:GetStackCount()
end


function modifier_damage_tower_aura:OnCreated( kv )
	if IsServer() then
		local target = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
	end
end