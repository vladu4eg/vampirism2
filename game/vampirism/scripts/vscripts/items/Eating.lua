function Heal( event )
	local ability = event.ability
  	event.caster:Heal(event.caster:GetMaxHealth() * ability:GetLevelSpecialValueFor("heal_percentage", 1)*0.01, event.caster)	
end
