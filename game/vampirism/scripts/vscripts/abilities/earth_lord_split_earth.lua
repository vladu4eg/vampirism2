earth_lord_split_earth = class({})
function earth_lord_split_earth:OnSpellStart()
	if IsServer() then
		self.duration = self:GetSpecialValueFor( "stun_duration" )
		self.radius = self:GetSpecialValueFor( "radius" )
		self.damage = self:GetSpecialValueFor( "stomp_damage" )
		self.caster = self:GetCaster()
		self.vPos = self.caster:GetAbsOrigin()
		local targets = FindUnitsInRadius(self.caster:GetTeamNumber(), 
												self.vPos, 
												nil, self.radius, 
												DOTA_UNIT_TARGET_TEAM_ENEMY, 
												DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
												DOTA_UNIT_TARGET_FLAG_NONE, 
												FIND_ANY_ORDER, 
												false)

		for k,v in pairs (targets) do
			if v.state ~= "complete" then
				ApplyDamage({ victim = v, attacker = self.caster, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self })
				v:AddNewModifier(self.caster, self, "modifier_stunned", {duration = self.duration})
			end
		end
		self.splitEarthParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf",PATTACH_WORLDORIGIN,caster)
		ParticleManager:SetParticleControl( self.splitEarthParticle, 0, self.vPos )
		ParticleManager:SetParticleControl( self.splitEarthParticle, 1, Vector( self.radius, 1, 1 ) )
		StartSoundEventFromPosition("Hero_Centaur.HoofStomp", self.vPos)
	end
end
