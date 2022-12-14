LinkLuaModifier("modifier_range_no_miss", "modifiers/modifier_range_no_miss.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_range_no_miss_aura", "modifiers/modifier_range_no_miss.lua", LUA_MODIFIER_MOTION_NONE)

 modifier_range_no_miss = class({})

function  modifier_range_no_miss:CheckState() 
    return { [MODIFIER_STATE_BLOCK_DISABLED] = false}
end
--------------------------------------------------------------------------------
function  modifier_range_no_miss:IsHidden()
    return false
end

function  modifier_range_no_miss:IsPurgable()
    return false
end

function  modifier_range_no_miss:IsStackable()
    return true
end

function  modifier_range_no_miss:IsPermanent()
	return false
end


--------------------------------------------------------------------------------
 modifier_range_no_miss_aura = class({})

 function  modifier_range_no_miss_aura:IsHidden()
    return false
end

function modifier_range_no_miss_aura:IsPurgable()
	return false
end

function modifier_range_no_miss_aura:GetTexture()
	return "SpellBookPage09_add_004"
end

function modifier_range_no_miss_aura:CheckState()
	local state = {
		[MODIFIER_STATE_CANNOT_MISS] = true
	}
	return state
end


