LinkLuaModifier("modifier_hero_killer", "items/sphere_doom.lua",LUA_MODIFIER_MOTION_NONE)
local time = 5 
function OnEquipSphereDoom(event)
    time = 5 
	Timers:CreateTimer(time, function()
		for pID=0,DOTA_MAX_TEAM_PLAYERS do
            if PlayerResource:IsValidPlayerID(pID) then
                local hero = PlayerResource:GetSelectedHeroEntity(pID)
                if hero then
                    local team = hero:GetTeamNumber()
                    if team ~= nil then
                        if team == DOTA_TEAM_BADGUYS then
                            if hero:IsRealHero() and time then
                                if  not hero:HasModifier("modifier_hero_killer") then
                                    hero:AddNewModifier(hero, nil, "modifier_hero_killer", {}):IncrementStackCount()
                                else
                                    hero:FindModifierByName("modifier_hero_killer"):IncrementStackCount()
                                end
                                hero:CalculateStatBonus(true)
                            end
                        end
                    end
                end
            end
        end
        return time
	end)
end

function OnUnequip(event)
	time = nil
end

modifier_hero_killer = class({})

function modifier_hero_killer:CheckState() 
    return { [MODIFIER_STATE_BLOCK_DISABLED] = false}
end

function modifier_hero_killer:IsHidden()
    return false
end

function modifier_hero_killer:IsPurgable()
    return true
end

function modifier_hero_killer:IsPermanent()
	return true
end

function modifier_hero_killer:DeclareFunctions()
	return { MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			 MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
             MODIFIER_PROPERTY_STATS_INTELLECT_BONUS}
end

function modifier_hero_killer:GetModifierBonusStats_Strength()
	return ( 5 * self:GetStackCount()) 
end

function modifier_hero_killer:GetModifierBonusStats_Agility()

	return (5 * self:GetStackCount()) 
end

function modifier_hero_killer:GetModifierBonusStats_Intellect()
	return (5 * self:GetStackCount()) 
end
