function Bash(event)
	if event.caster:IsIllusion() then
		return 
	end

	local ability = event.ability
	event.target:AddNewModifier(event.caster,ability,"modifier_stunned",{duration = ability:GetSpecialValueFor("bash_stun")})
	event.target:EmitSound("DOTA_Item.MKB.Minibash")
end