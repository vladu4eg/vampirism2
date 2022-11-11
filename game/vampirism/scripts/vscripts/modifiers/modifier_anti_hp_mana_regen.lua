modifier_anti_hp_mana_regen = class({})

------------------------------------------------------------------------------------

function modifier_anti_hp_mana_regen:IsPurgable()
	return false
end
function modifier_anti_hp_mana_regen:IsHidden()
	return true
end
function modifier_anti_hp_mana_regen:IsDebuff() return true end

function modifier_anti_hp_mana_regen:IsPurgeException()
	return false
end
------------------------------------------------------------------------------------

function modifier_anti_hp_mana_regen:OnCreated( kv )

	if IsServer() then
		self:OnIntervalThink()
		self:StartIntervalThink(1)
	end
end

function modifier_anti_hp_mana_regen:IsPurgeException()
	return false
end

--------------------------------------------------------------------------------

function modifier_anti_hp_mana_regen:OnIntervalThink()
	if IsServer() then
        local hero = self:GetParent()
		hero:SetBaseHealthRegen(hero:GetStrength() * -0.1)
        hero:SetBaseManaRegen(hero:GetIntellect() * -0.05)
	end
end
------------------------------------------------------------------------------------