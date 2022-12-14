LinkLuaModifier("modifier_armor_wall", "modifiers/modifier_armor_wall.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_armor_wall_aura", "modifiers/modifier_armor_wall.lua", LUA_MODIFIER_MOTION_NONE)
 modifier_armor_wall = class({})

function  modifier_armor_wall:CheckState() 
    return { [MODIFIER_STATE_BLOCK_DISABLED] = false}
end
--------------------------------------------------------------------------------

function  modifier_armor_wall:IsHidden()
    return true
end

function  modifier_armor_wall:IsPurgable()
    return false
end

function  modifier_armor_wall:IsStackable()
    return true
end

function  modifier_armor_wall:IsPermanent()
	return false
end

--------------------------------------------------------------------------------
 modifier_armor_wall_aura = class({})

function  modifier_armor_wall_aura:IsHidden()
    return true
end

function  modifier_armor_wall_aura:IsPurgable()
    return false
end

function  modifier_armor_wall_aura:IsPermanent()
	return false
end

function  modifier_armor_wall_aura:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
    return funcs
end

function  modifier_armor_wall_aura:GetModifierPhysicalArmorBonus()
	return self:GetParent():GetPhysicalArmorBaseValue() * self:GetStackCount()
end


function modifier_armor_wall_aura:OnCreated( kv )
	if IsServer() then
	end
end
