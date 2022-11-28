LinkLuaModifier("modifier_hero_end_game", "items/end_game.lua",LUA_MODIFIER_MOTION_NONE)
function OnEquipEndGame(event)

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
