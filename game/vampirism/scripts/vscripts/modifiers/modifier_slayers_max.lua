LinkLuaModifier("modifier_slayers_max", "modifiers/modifier_slayers_max.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slayers_max_aura", "modifiers/modifier_slayers_max.lua", LUA_MODIFIER_MOTION_NONE)
 modifier_slayers_max = class({})

function  modifier_slayers_max:CheckState() 
    return { [MODIFIER_STATE_BLOCK_DISABLED] = false}
end
--------------------------------------------------------------------------------
function  modifier_slayers_max:IsAura()
	return true
end

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

function  modifier_slayers_max:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function  modifier_slayers_max:GetAuraRadius()
	return 9999999
end

function  modifier_slayers_max:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function  modifier_slayers_max:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function  modifier_slayers_max:GetModifierAura()
	return "modifier_slayers_max_aura"
end

--------------------------------------------------------------------------------
 modifier_slayers_max_aura = class({})

function  modifier_slayers_max_aura:IsAura()
	return true
end

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
		Timers:CreateTimer(0.5,function()
			local caster = self:GetCaster()
			local target = self:GetParent()
			print("11111111")
			print(caster:GetPlayerOwnerID())
			print(target:GetPlayerOwnerID())
			print(target:GetUnitName())
			if caster:GetPlayerOwnerID() == target:GetPlayerOwnerID() and target:GetUnitName() == "npc_dota_hero_templar_assassin"  then
				local countStack = caster:FindModifierByName("modifier_slayers_max"):GetStackCount()
				self:SetStackCount(countStack)
				target:CalculateStatBonus(true)
				self:ForceRefresh()
				self:SendBuffRefreshToClients()
				target:CalculateStatBonus(true)
				self:StartIntervalThink( 1 )
				self:OnIntervalThink()
			end
		end)
		
	end
end

function modifier_slayers_max_aura:OnIntervalThink()
	local target = self:GetParent()
	target:CalculateStatBonus(true)
	self:ForceRefresh()
	self:SendBuffRefreshToClients()
	target:CalculateStatBonus(true)
end