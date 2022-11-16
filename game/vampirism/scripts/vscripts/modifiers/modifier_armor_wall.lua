LinkLuaModifier("modifier_armor_wall", "modifiers/modifier_armor_wall.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_armor_wall_aura", "modifiers/modifier_armor_wall.lua", LUA_MODIFIER_MOTION_NONE)
 modifier_armor_wall = class({})

function  modifier_armor_wall:CheckState() 
    return { [MODIFIER_STATE_BLOCK_DISABLED] = false}
end
--------------------------------------------------------------------------------
function  modifier_armor_wall:IsAura()
	return true
end

function  modifier_armor_wall:IsHidden()
    return false
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

function  modifier_armor_wall:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC
end

function  modifier_armor_wall:GetAuraRadius()
	return 9999999
end

function  modifier_armor_wall:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function  modifier_armor_wall:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function  modifier_armor_wall:GetModifierAura()
	return "modifier_armor_wall_aura"
end

--------------------------------------------------------------------------------
 modifier_armor_wall_aura = class({})

function  modifier_armor_wall_aura:IsAura()
	return true
end

function  modifier_armor_wall_aura:IsHidden()
    return false
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
		Timers:CreateTimer(0.5,function()
			local caster = self:GetCaster()
			local target = self:GetParent()
			if caster:GetPlayerOwnerID() == target:GetPlayerOwnerID() and string.match(target:GetUnitName(), "rock")  then
				local countStack = caster:FindModifierByName("modifier_armor_wall"):GetStackCount()
				self:SetStackCount(countStack)
				target:CalculateGenericBonuses()
				self:ForceRefresh()
				self:SendBuffRefreshToClients()
				target:CalculateGenericBonuses()
				self:StartIntervalThink( 1 )
				self:OnIntervalThink()
			end
		end)
		
	end
end

function modifier_armor_wall_aura:OnIntervalThink()
	local target = self:GetParent()
	target:CalculateGenericBonuses()
	self:ForceRefresh()
	self:SendBuffRefreshToClients()
	target:CalculateGenericBonuses()
end