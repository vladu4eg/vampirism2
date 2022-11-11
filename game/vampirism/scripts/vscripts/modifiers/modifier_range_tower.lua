LinkLuaModifier("modifier_range_tower", "modifiers/modifier_range_tower.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_range_tower_aura", "modifiers/modifier_range_tower.lua", LUA_MODIFIER_MOTION_NONE)
 modifier_range_tower = class({})

function  modifier_range_tower:CheckState() 
    return { [MODIFIER_STATE_BLOCK_DISABLED] = false}
end
--------------------------------------------------------------------------------
function  modifier_range_tower:IsAura()
	return true
end

function  modifier_range_tower:IsHidden()
    return false
end

function  modifier_range_tower:IsPurgable()
    return false
end

function  modifier_range_tower:IsStackable()
    return true
end

function  modifier_range_tower:IsPermanent()
	return false
end

function  modifier_range_tower:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC
end

function  modifier_range_tower:GetAuraRadius()
	return 9999999
end

function  modifier_range_tower:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function  modifier_range_tower:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function  modifier_range_tower:GetModifierAura()
	return "modifier_range_tower_aura"
end

--------------------------------------------------------------------------------
 modifier_range_tower_aura = class({})

function  modifier_range_tower_aura:IsAura()
	return true
end

function  modifier_range_tower_aura:IsHidden()
    return false
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
	local target = self:GetParent()
	
	if target.atkspeed then
		print(target.atkspeed)
		return target.atkspeed
	else
		return 0
	end
	
end


function modifier_range_tower_aura:OnCreated( kv )
	if IsServer() then
		Timers:CreateTimer(0.5,function()
			local caster = self:GetCaster()
			local target = self:GetParent()
			if caster:GetPlayerOwnerID() == target:GetPlayerOwnerID() and string.match(target:GetUnitName(), "tower")  then
				local countStack = caster:FindModifierByName("modifier_range_tower"):GetStackCount()
				target.atkspeed = 100 * countStack
			end
		end)
		
	end
end


