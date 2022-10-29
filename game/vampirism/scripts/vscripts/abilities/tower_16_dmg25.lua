tower_15_return25 = class({})


LinkLuaModifier("tower_15_return25_revenge", "abilities/tower_15_return25.lua", LUA_MODIFIER_MOTION_NONE)


function tower_15_return25:GetIntrinsicModifierName()
	return "tower_15_return25_revenge"
end

--------------------------------------------------------------------------------
tower_15_return25_revenge = class({})

function tower_15_return25_revenge:IsHidden()
	return true
end

function tower_15_return25_revenge:IsPurgable()
	return false
end

function tower_15_return25_revenge:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

function tower_15_return25_revenge:OnAttackLanded(params) 
	if params.target == self:GetParent() and not params.ranged_attack and not self:GetParent():IsIllusion() then 
		self.attack_record = params.record 
	end 
end


function tower_15_return25_revenge:OnTakeDamage(params)

	if self:GetParent():PassivesDisabled() then
		return
	end

	if self.attack_record == params.record then		
		local return_damage = self:GetAbility():GetSpecialValueFor("damage_return")*0.01*params.original_damage
		
		ApplyDamage(
		{
			victim = params.attacker, 
			attacker = params.unit, 
			damage = return_damage, 
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
			ability = self:GetAbility()
		})
	end

end