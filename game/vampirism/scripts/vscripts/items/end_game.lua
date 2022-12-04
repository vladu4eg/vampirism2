LinkLuaModifier("modifier_hero_end_game", "items/end_game.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hero_end_game_fire", "items/end_game.lua",LUA_MODIFIER_MOTION_NONE)

function OnEquipEndGame(event)
    local caster = event.caster
    if not caster:HasModifier("modifier_hero_end_game_fire") then
        caster:AddNewModifier(caster, nil, "modifier_hero_end_game_fire", {})
    end
		for pID=0,DOTA_MAX_TEAM_PLAYERS do
            if PlayerResource:IsValidPlayerID(pID) then
                local hero = PlayerResource:GetSelectedHeroEntity(pID)
                if hero then
                    local team = hero:GetTeamNumber()
                    if team ~= nil then
                        if team == DOTA_TEAM_GOODGUYS then
                            if hero:IsRealHero() then
                                if not hero:HasModifier("modifier_hero_end_game") then
                                    hero:AddNewModifier(hero, nil, "modifier_hero_end_game", {})
                                end
                            end
                        end
                    end
                end
            end
        end
end

function OnUnequip(event)
    local caster = event.caster
    if caster:HasModifier("modifier_hero_end_game_fire") then
        caster:RemoveModifierByName("modifier_hero_end_game_fire")
    end
	for pID=0,DOTA_MAX_TEAM_PLAYERS do
        if PlayerResource:IsValidPlayerID(pID) then
            local hero = PlayerResource:GetSelectedHeroEntity(pID)
            if hero then
                local team = hero:GetTeamNumber()
                if team ~= nil then
                    if team == DOTA_TEAM_GOODGUYS then
                        if hero:IsRealHero() then
                            if hero:HasModifier("modifier_hero_end_game") then
                                hero:RemoveModifierByName("modifier_hero_end_game")
                            end
                        end
                    end
                end
            end
        end
    end
end

modifier_hero_end_game = class({})

function modifier_hero_end_game:CheckState() 
    return { [MODIFIER_STATE_BLOCK_DISABLED] = false,
             [MODIFIER_STATE_PROVIDES_VISION] = true}
end

function modifier_hero_end_game:IsHidden()
    return false
end

function modifier_hero_end_game:IsDebuff()
    return true
end

function modifier_hero_end_game:IsPurgable()
    return true
end

function modifier_hero_end_game:IsPermanent()
	return true
end
function  modifier_hero_end_game:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_BONUS,
    }
    return funcs
end
function modifier_hero_end_game:GetModifierManaBonus()
	return -10
end

modifier_hero_end_game_fire = class({})

function modifier_hero_end_game_fire:IsHidden()
    return true
end

function modifier_hero_end_game_fire:IsDebuff()
    return true
end

function modifier_hero_end_game_fire:IsPurgable()
    return true
end

function modifier_hero_end_game_fire:GetEffectName()
	return "particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf"
end

function modifier_hero_end_game_fire:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_hero_end_game_fire:OnCreated(kv)
	self.tick = 0.25
	self.damage = 1000*self.tick
	self.radius = 900
	self:StartIntervalThink(self.tick)
end

function modifier_hero_end_game_fire:OnIntervalThink()
		local ability = self:GetAbility()
		local caster = self:GetCaster()
			local targets =  FindUnitsInRadius(caster:GetTeamNumber(),
					caster:GetAbsOrigin(),
					nil,
					self.radius,
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_NONE,
					FIND_ANY_ORDER,
					false)
			
		local damageTable = {attacker = caster, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability }
			-- Deal damage to all targets passed
		for _,unit in pairs(targets) do
			damageTable.victim = unit
			ApplyDamage(damageTable)
		end
end

