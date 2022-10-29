function WaveOnAbilityPhaseStart(event)
	if IsServer() then
		self.hTarget = self:GetCursorTarget()

		if self.hTarget:GetMana() == 0 then
			SendErrorMessage(self:GetCaster():GetPlayerOwnerID(), "#error_must_target_mana_unit")
			self:GetCaster():Interrupt()
			return false
		end
		return true
	end
end

function WaveOnSpellStart(event)
	if IsServer() then
		local caster = event.caster
		local target = event.target
		local ability = event.ability

		local mana_burn = ability:GetSpecialValueFor( "mana_burn" ) 
		local damage_per_mana = ability:GetSpecialValueFor(  "damage_per_mana" )

		target:ManaBurn(caster, ability, mana_burn, damage_per_mana, DAMAGE_TYPE_MAGICAL, true)
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, target:GetOrigin() )
		target:EmitSound("Hero_NyxAssassin.ManaBurn.Target")
	end
end

