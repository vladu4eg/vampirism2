PickTable = {}


function picktreant(keys)
	local info = {}
    info.PlayerID = keys.caster:GetPlayerOwnerID()
    info.hero = keys.caster
	Pets.DeletePet(info)
    local gold = PlayerResource:GetGold(keys.caster:GetPlayerOwnerID())
    local wood = PlayerResource:GetLumber(keys.caster:GetPlayerOwnerID())
    
    local hero = PlayerResource:ReplaceHeroWith(keys.caster:GetPlayerOwnerID(), "npc_dota_hero_treant", 0, 0)
    PlayerResource:SetGold(hero, gold)
    PlayerResource:SetLumber(hero, wood)
    UTIL_Remove(info.hero)
end
function pickchen(keys)
	local info = {}
    info.PlayerID = keys.caster:GetPlayerOwnerID()
    info.hero = keys.caster
	Pets.DeletePet(info.hero)
    local gold = PlayerResource:GetGold(keys.caster:GetPlayerOwnerID())
    local wood = PlayerResource:GetLumber(keys.caster:GetPlayerOwnerID())
    
    local hero = PlayerResource:ReplaceHeroWith(keys.caster:GetPlayerOwnerID(), "npc_dota_hero_chen", 0, 0)
    PlayerResource:SetGold(hero, gold+40)
    PlayerResource:SetLumber(hero, wood+20)
    UTIL_Remove(info.hero)
end
function picktiny(keys)
	local info = {}
    info.PlayerID = keys.caster:GetPlayerOwnerID()
    info.hero = keys.caster
	Pets.DeletePet(info)
    local gold = PlayerResource:GetGold(keys.caster:GetPlayerOwnerID())
    local wood = PlayerResource:GetLumber(keys.caster:GetPlayerOwnerID())
    
    local hero = PlayerResource:ReplaceHeroWith(keys.caster:GetPlayerOwnerID(), "npc_dota_hero_tiny", 0, 0)
    PlayerResource:SetGold(hero, gold+80)
    PlayerResource:SetLumber(hero, wood+40)
    UTIL_Remove(info.hero)
end
function pickfurion(keys)
	local info = {}
    info.PlayerID = keys.caster:GetPlayerOwnerID()
    info.hero = keys.caster
	Pets.DeletePet(info)
    local gold = PlayerResource:GetGold(keys.caster:GetPlayerOwnerID())
    local wood = PlayerResource:GetLumber(keys.caster:GetPlayerOwnerID())
    
    local hero = PlayerResource:ReplaceHeroWith(keys.caster:GetPlayerOwnerID(), "npc_dota_hero_furion", 0, 0)
    PlayerResource:SetGold(hero, gold+100)
    PlayerResource:SetLumber(hero, wood+50)
    UTIL_Remove(info.hero)
end
function pickhunter(keys)
	local info = {}
    info.PlayerID = keys.caster:GetPlayerOwnerID()
    info.hero = keys.caster
	Pets.DeletePet(info)
    local gold = PlayerResource:GetGold(keys.caster:GetPlayerOwnerID())
    local wood = PlayerResource:GetLumber(keys.caster:GetPlayerOwnerID())
    
    local hero = PlayerResource:ReplaceHeroWith(keys.caster:GetPlayerOwnerID(), "npc_dota_hero_bounty_hunter", 0, 0)
    PlayerResource:SetGold(hero, gold+200)
    PlayerResource:SetLumber(hero, wood+100)
    UTIL_Remove(info.hero)
end

-----------------------------


function pickdoom(keys)
    if PickTable[1] == nil then
        PickTable[1] = keys.caster:GetPlayerOwnerID()
        keys.caster:AddNewModifier(nil, nil, "modifier_silence", nil)   
    else 
        return false
    end
    local trollCount = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS)
    for i = 1, trollCount do
        local pID = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_BADGUYS, i)
        if PlayerResource:IsValidPlayerID(pID) then
            local hero = PlayerResource:GetSelectedHeroEntity(pID)
            if hero ~= nil then hero:RemoveAbility("pick_doom") end
        end
    end
	local info = {}
    info.PlayerID = keys.caster:GetPlayerOwnerID()
    info.hero = keys.caster
	Pets.DeletePet(info)
    local gold = PlayerResource:GetGold(keys.caster:GetPlayerOwnerID())
    local wood = PlayerResource:GetLumber(keys.caster:GetPlayerOwnerID())
    
    local hero = PlayerResource:ReplaceHeroWith(keys.caster:GetPlayerOwnerID(), "npc_dota_hero_doom_bringer", 0, 0)
    PlayerResource:SetGold(hero, gold)
    PlayerResource:SetLumber(hero, wood)
    UTIL_Remove(info.hero)
end

function picksladar(keys)
    if PickTable[2] == nil then
        PickTable[2] = keys.caster:GetPlayerOwnerID()
        keys.caster:AddNewModifier(nil, nil, "modifier_silence", nil)   
    else 
        return false
    end
    local trollCount = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS)
    for i = 1, trollCount do
        local pID = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_BADGUYS, i)
        if PlayerResource:IsValidPlayerID(pID) then
            local hero = PlayerResource:GetSelectedHeroEntity(pID)
            if hero ~= nil then hero:RemoveAbility("pick_sladar") end
        end
    end
	local info = {}
    info.PlayerID = keys.caster:GetPlayerOwnerID()
    info.hero = keys.caster
	Pets.DeletePet(info)
    local gold = PlayerResource:GetGold(keys.caster:GetPlayerOwnerID())
    local wood = PlayerResource:GetLumber(keys.caster:GetPlayerOwnerID())
    
    local hero = PlayerResource:ReplaceHeroWith(keys.caster:GetPlayerOwnerID(), "npc_dota_hero_slardar", 0, 0)
    PlayerResource:SetGold(hero, gold)
    PlayerResource:SetLumber(hero, wood)
    UTIL_Remove(info.hero)
end

function pickstalker(keys)
    if PickTable[3] == nil then
        PickTable[3] = keys.caster:GetPlayerOwnerID()
        keys.caster:AddNewModifier(nil, nil, "modifier_silence", nil)   
    else 
        return false
    end
    local trollCount = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS)
    for i = 1, trollCount do
        local pID = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_BADGUYS, i)
        if PlayerResource:IsValidPlayerID(pID) then
            local hero = PlayerResource:GetSelectedHeroEntity(pID)
            if hero ~= nil then hero:RemoveAbility("pick_stalker") end
        end
    end
	local info = {}
    info.PlayerID = keys.caster:GetPlayerOwnerID()
    info.hero = keys.caster
	Pets.DeletePet(info)
    local gold = PlayerResource:GetGold(keys.caster:GetPlayerOwnerID())
    local wood = PlayerResource:GetLumber(keys.caster:GetPlayerOwnerID())
    
    local hero = PlayerResource:ReplaceHeroWith(keys.caster:GetPlayerOwnerID(), "npc_dota_hero_night_stalker", 0, 0)
    PlayerResource:SetGold(hero, gold)
    PlayerResource:SetLumber(hero, wood)
    UTIL_Remove(info.hero)
end

function picklifestealer(keys)
    if PickTable[4] == nil then
        PickTable[4] = keys.caster:GetPlayerOwnerID()
        keys.caster:AddNewModifier(nil, nil, "modifier_silence", nil)   
    else 
        return false
    end
    local trollCount = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS)
    for i = 1, trollCount do
        local pID = PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_BADGUYS, i)
        if PlayerResource:IsValidPlayerID(pID) then
            local hero = PlayerResource:GetSelectedHeroEntity(pID)
            if hero ~= nil then hero:RemoveAbility("pick_lifestealer") end
        end
    end
	local info = {}
    info.PlayerID = keys.caster:GetPlayerOwnerID()
    info.hero = keys.caster
	Pets.DeletePet(info)
    local gold = PlayerResource:GetGold(keys.caster:GetPlayerOwnerID())
    local wood = PlayerResource:GetLumber(keys.caster:GetPlayerOwnerID())
    
    local hero = PlayerResource:ReplaceHeroWith(keys.caster:GetPlayerOwnerID(), "npc_dota_hero_life_stealer", 0, 0)
    PlayerResource:SetGold(hero, gold)
    PlayerResource:SetLumber(hero, wood)
    UTIL_Remove(info.hero)
end