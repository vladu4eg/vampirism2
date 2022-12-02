LinkLuaModifier("modifier_range_no_miss", "modifiers/modifier_range_no_miss.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_range_no_miss_aura", "modifiers/modifier_range_no_miss.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_range_no_miss_state", "modifiers/modifier_range_no_miss.lua", LUA_MODIFIER_MOTION_NONE)

 modifier_range_no_miss = class({})

function  modifier_range_no_miss:CheckState() 
    return { [MODIFIER_STATE_BLOCK_DISABLED] = false}
end
--------------------------------------------------------------------------------
function  modifier_range_no_miss:IsAura()
	return true
end

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

function  modifier_range_no_miss:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC
end

function  modifier_range_no_miss:GetAuraRadius()
	return 9999999
end

function  modifier_range_no_miss:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function  modifier_range_no_miss:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function  modifier_range_no_miss:GetModifierAura()
	return "modifier_range_no_miss_aura"
end

--------------------------------------------------------------------------------
 modifier_range_no_miss_aura = class({})

function  modifier_range_no_miss_aura:IsAura()
	return true
end

function  modifier_range_no_miss_aura:IsHidden()
    return true
end

function  modifier_range_no_miss_aura:IsPurgable()
    return false
end

function  modifier_range_no_miss_aura:IsPermanent()
	return false
end



function modifier_range_no_miss_aura:OnCreated( kv )
	if IsServer() then
		Timers:CreateTimer(1,function()
			local caster = self:GetCaster()
			local target = self:GetParent()
			if caster:GetPlayerOwnerID() == target:GetPlayerOwnerID() and 
			(target:GetUnitName() == "tower_9" or target:GetUnitName() == "tower_10" or target:GetUnitName() == "tower_11" 
		  or target:GetUnitName() == "tower_9_1" or target:GetUnitName() == "tower_10_1" or target:GetUnitName() == "tower_11_1") then
				target:AddNewModifier(target, nil, "modifier_range_no_miss_state", {})
			end
		end)
		
	end
end


modifier_range_no_miss_state = class({})

function  modifier_range_no_miss_state:IsHidden()
    return false
end

function modifier_range_no_miss_state:IsPurgable()
	return false
end

function modifier_range_no_miss_state:GetTexture()
	return "SpellBookPage09_add_004"
end

function modifier_range_no_miss_aura:CheckState()
	local state = {
		[MODIFIER_STATE_CANNOT_MISS] = true
	}
	return state
end

