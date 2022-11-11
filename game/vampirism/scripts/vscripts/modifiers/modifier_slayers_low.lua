LinkLuaModifier("modifier_slayers_low", "modifiers/modifier_slayers_low.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slayers_low_aura", "modifiers/modifier_slayers_low.lua", LUA_MODIFIER_MOTION_NONE)
 modifier_slayers_low = class({})

function  modifier_slayers_low:CheckState() 
    return { [MODIFIER_STATE_BLOCK_DISABLED] = false}
end
--------------------------------------------------------------------------------
function  modifier_slayers_low:IsAura()
	return true
end

function  modifier_slayers_low:IsHidden()
    return false
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

function  modifier_slayers_low:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function  modifier_slayers_low:GetAuraRadius()
	return 9999999
end

function  modifier_slayers_low:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function  modifier_slayers_low:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function  modifier_slayers_low:GetModifierAura()
	return "modifier_slayers_low_aura"
end

--------------------------------------------------------------------------------
 modifier_slayers_low_aura = class({})

function  modifier_slayers_low_aura:IsAura()
	return true
end

function  modifier_slayers_low_aura:IsHidden()
    return false
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
    }
    return funcs
end


function modifier_slayers_low_aura:GetModifierPreAttack_BonusDamage()
	local target = self:GetParent()
	
	if target.atkdamage then
		return target.atkdamage
	else
		return 0
	end
end

function  modifier_slayers_low_aura:GetModifierAttackRangeBonus()
	local target = self:GetParent()
	
	if target.atkspeed then
		return target.atkspeed
	else
		return 0
	end
	
end


function modifier_slayers_low_aura:OnCreated( kv )
	if IsServer() then
		Timers:CreateTimer(0.5,function()
			local caster = self:GetCaster()
			local target = self:GetParent()
			print("11111111")
			print(caster:GetPlayerOwnerID())
			print(target:GetPlayerOwnerID())
			print(target:GetUnitName())
			if caster:GetPlayerOwnerID() == target:GetPlayerOwnerID() and target:GetUnitName() == "npc_dota_hero_templar_assassin"  then
				local countStack = caster:FindModifierByName("modifier_slayers_low"):GetStackCount()
				target.atkspeed = 150 + 300 * (countStack-1)
				target:SetMaxHealth(target:GetMaxHealth() + (1000 + 3000 * (countStack-1)))
				target:SetBaseMaxHealth(target:GetBaseMaxHealth() + (1000 + 3000 * (countStack-1)))
				target:SetHealth(target:GetHealth() + (1000 + 3000 * (countStack-1)))
				target.atkdamage = 100 + 300 * (countStack-1)
				
			end
		end)
		
	end
end

function modifier_slayers_low_aura:OnRemoved(kv)
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		if caster:GetPlayerOwnerID() == target:GetPlayerOwnerID() and target:GetUnitName() == "npc_dota_hero_templar_assassin"  then
			local hp = tonumber(GetUnitKV(target:GetUnitName(), "StatusHealth")) 
			target:SetMaxHealth(hp)
			target:SetBaseMaxHealth(hp)
			target:SetHealth(hp)
		end
	end
end


