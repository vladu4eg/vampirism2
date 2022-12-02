Player = Player or {}

require('libraries/team')

local goldGainedImportance = 8
local goldGivenImportance = 8
local lumberGainedImportance = 8
local lumberGivenImportance = 8
local rankImportance = 30
local rankPers = 5

if GameRules.disconnectedHeroSelects == nil then
	GameRules.disconnectedHeroSelects = {}
end

function CDOTA_PlayerResource:SetSelectedHero(playerID, heroName)
    local player = PlayerResource:GetPlayer(playerID)
	if player == nil then
        GameRules.disconnectedHeroSelects[playerID] = heroName
        return 
	end
    player:SetSelectedHero(heroName)
end

function CDOTA_PlayerResource:SetGold(hero,gold)
    local playerID = hero:GetPlayerOwnerID()
	if GameRules.MapSpeed >= 4 then
		gold = math.min(gold, math.floor(9999999 * GameRules.MultiMapSpeed))
	else
		gold = math.min(gold, math.floor(9999999 * GameRules.MultiMapSpeed)) 
	end
    GameRules.gold[playerID] = gold
	CustomGameEventManager:Send_ServerToTeam(hero:GetTeam(), "player_custom_gold_changed", {
		playerID = playerID,
		gold = PlayerResource:GetGold(playerID)
	})
end

function CDOTA_PlayerResource:ModifyGold(hero,gold,noGain)
    if GameRules.test2 then
		PlayerResource:SetGold(hero, math.floor(9999999 * GameRules.MultiMapSpeed))
		return
	end
    noGain = noGain or false
    local pID = hero:GetPlayerOwnerID()
    PlayerResource:SetGold(hero, (GameRules.gold[pID] or 0) + gold)
    if gold > 0 and not noGain then
        PlayerResource:ModifyGoldGained(pID,gold)
	end
end

function CDOTA_PlayerResource:GetGold(pID)
	return math.floor(GameRules.gold[pID] or 0)
end


function CDOTA_PlayerResource:SetLumber(hero, lumber)
    local playerID = hero:GetPlayerOwnerID()
	
	if GameRules.MapSpeed >= 4 then
		lumber = math.min(lumber, math.floor(9999999 * GameRules.MultiMapSpeed))
	else
		lumber = math.min(lumber, math.floor(9999999 * GameRules.MultiMapSpeed))
	end
	GameRules.lumber[playerID] = lumber
	CustomGameEventManager:Send_ServerToTeam(hero:GetTeam(), "player_lumber_changed", {
		playerID = playerID,
		lumber = PlayerResource:GetLumber(playerID)
	})
end

function CDOTA_PlayerResource:ModifyLumber(hero,lumber,noGain)
    if GameRules.test2 then
		PlayerResource:SetLumber(hero, math.floor(9999999 * GameRules.MultiMapSpeed))
		return
	end
    noGain = noGain or false
    local pID = hero:GetPlayerOwnerID()
    PlayerResource:SetLumber(hero, (GameRules.lumber[pID] or 0) + lumber)
    if lumber > 0 and not noGain then
		PlayerResource:ModifyLumberGained(pID, lumber)
	end
end

function CDOTA_PlayerResource:GetLumber(pID)
	return math.floor(GameRules.lumber[pID]) or 0
end


function CDOTA_PlayerResource:ModifyGoldGained(pID,amount)
	GameRules.goldGained[pID] = PlayerResource:GetGoldGained(pID) + amount
end

function CDOTA_PlayerResource:GetGoldGained(pID)
	return GameRules.goldGained[pID] or 0
end

function CDOTA_PlayerResource:ModifyGoldGiven(pID,amount)
	GameRules.goldGiven[pID] = PlayerResource:GetGoldGiven(pID) + amount
end

function CDOTA_PlayerResource:GetGoldGiven(pID)
	return GameRules.goldGiven[pID] or 0
end



function CDOTA_PlayerResource:ModifyLumberGained(pID,amount)
	GameRules.lumberGained[pID] =PlayerResource:GetLumberGained(pID) + amount
end

function CDOTA_PlayerResource:GetLumberGained(pID)
	return GameRules.lumberGained[pID] or 0
end

function CDOTA_PlayerResource:ModifyLumberGiven(pID,amount)
	GameRules.lumberGiven[pID] = PlayerResource:GetLumberGiven(pID) + amount
end

function CDOTA_PlayerResource:GetLumberGiven(pID)
	return GameRules.lumberGiven[pID] or 0
end

function CDOTA_PlayerResource:GetAllStats(pID)
	local sum = 0
	sum = sum + PlayerResource:GetGoldGained(pID) + PlayerResource:GetGoldGiven(pID) + PlayerResource:GetLumberGiven(pID) + PlayerResource:GetLumberGained(pID)
	return sum
end

function CDOTA_PlayerResource:ModifyFood(hero, food)
    food = string.match(food,"[-]?%d+") or 0
    local playerID = hero:GetPlayerOwnerID()
	local maxFoodPlayer = 300
	if hero.food ~= nil then
		if GameRules.maxFood[playerID] == nil then
			GameRules.maxFood[playerID] = STARTING_MAX_FOOD
		end
		if GameRules.maxFood[playerID] <= 300 then
			maxFoodPlayer = GameRules.maxFood[playerID]
		end
    hero.food = hero.food + food
	CustomGameEventManager:Send_ServerToTeam(hero:GetTeam(), "player_food_changed", {
		playerID = playerID,
		food = math.floor(hero.food),
		maxFood = maxFoodPlayer,
	})
	end
end

function CDOTA_PlayerResource:ModifyMine(hero, mine)
	if hero == nil then
		return
	end
    mine = string.match(mine,"[-]?%d+") or 0
    local playerID = hero:GetPlayerOwnerID()
    hero.mine = hero.mine + mine
	CustomGameEventManager:Send_ServerToTeam(hero:GetTeam(), "player_mine_changed", {
		playerID = playerID,
		mine = math.floor(hero.mine),
		maxMine = GameRules.maxMine,
	})
end

function CDOTA_PlayerResource:GetScore(pID,team)
	if PlayerResource:IsValidPlayerID(pID) then
		if team == 2 then
			return GameRules.scores[pID].elf
		elseif team == 3 then
			return GameRules.scores[pID].troll	
		else 
			return 0
		end
	end
end

function CDOTA_PlayerResource:GetType(pID)
	local heroName = PlayerResource:GetSelectedHeroName(pID)
	for i = 1, #TROLL_HERO do
		if heroName == TROLL_HERO[i] then
			return "troll"
		end
	end
    return string.match(heroName,ANGEL_HERO) and "angel"
	or string.match(heroName,WOLF_HERO) and "wolf"
	or "elf"
end

function CDOTA_PlayerResource:GetScoreBonus(pID)
	local scoreBonus = PlayerResource:GetScoreBonusGoldGained(pID) + PlayerResource:GetScoreBonusGoldGiven(pID) + PlayerResource:GetScoreBonusLumberGained(pID) + PlayerResource:GetScoreBonusLumberGiven(pID) + PlayerResource:GetScoreBonusRank(pID)
	return math.floor(scoreBonus)
end

function CDOTA_PlayerResource:GetScoreBonusGoldGained(pID)
	local team = PlayerResource:GetTeam(pID)
	local playerSum = PlayerResource:GetGoldGained(pID)
	local teamAvg = PlayerResource:GetPlayerCountForTeam(team) > 1 and (Team.GetGoldGained(team) - playerSum)/(PlayerResource:GetPlayerCountForTeam(team)-1) or playerSum
	playerSum = playerSum == 0 and 1 or playerSum
	teamAvg = teamAvg == 0 and 1 or teamAvg
	if playerSum == teamAvg then
		return 0
	end
	local sign = playerSum > teamAvg and 1 or -1
	local add = playerSum/teamAvg > 0 and 0 or 1
	playerSum = math.abs(playerSum)
	teamAvg = math.abs(teamAvg)
	local value = math.floor((math.max(playerSum,teamAvg)/math.min(playerSum,teamAvg)*goldGainedImportance/5))
	value = math.min(goldGainedImportance,value)
	return (value*sign)
	
end
function CDOTA_PlayerResource:GetScoreBonusGoldGiven(pID)
	local team = PlayerResource:GetTeam(pID)
	local playerSum = PlayerResource:GetGoldGiven(pID)
	local teamAvg = PlayerResource:GetPlayerCountForTeam(team) > 1 and (Team.GetGoldGiven(team) - playerSum)/(PlayerResource:GetPlayerCountForTeam(team)-1) or playerSum
	playerSum = playerSum == 0 and 1 or playerSum
	teamAvg = teamAvg == 0 and 1 or teamAvg
	if playerSum == teamAvg then
		return 0
	end
	local sign = playerSum > teamAvg and 1 or 0
	local add = playerSum/teamAvg > 0 and 0 or 1
	playerSum = math.abs(playerSum)
	teamAvg = math.abs(teamAvg)
	local value = math.floor((math.max(playerSum,teamAvg)/math.min(playerSum,teamAvg)*goldGivenImportance/50))
	value = math.min(goldGivenImportance,value)
	return (value*sign)
end
function CDOTA_PlayerResource:GetScoreBonusLumberGained(pID)
	local team = PlayerResource:GetTeam(pID)
	local playerSum = PlayerResource:GetLumberGained(pID)
	local teamAvg = PlayerResource:GetPlayerCountForTeam(team) > 1 and (Team.GetLumberGained(team) - playerSum)/(PlayerResource:GetPlayerCountForTeam(team)-1) or playerSum
	playerSum = playerSum == 0 and 1 or playerSum
	teamAvg = teamAvg == 0 and 1 or teamAvg
	if playerSum == teamAvg then
		return 0
	end
	local sign = playerSum > teamAvg and 1 or -1
	local add = playerSum/teamAvg > 0 and 0 or 1
	playerSum = math.abs(playerSum)
	teamAvg = math.abs(teamAvg)
	local value = math.floor((math.max(playerSum,teamAvg)/math.min(playerSum,teamAvg)*lumberGainedImportance/5))
	value = math.min(lumberGainedImportance,value)
	if team == 3 then
		return 0
	else
		return (value*sign)
	end
end
function CDOTA_PlayerResource:GetScoreBonusLumberGiven(pID)
	local team = PlayerResource:GetTeam(pID)
	local playerSum = PlayerResource:GetLumberGiven(pID)
	local teamAvg = PlayerResource:GetPlayerCountForTeam(team) > 1 and (Team.GetLumberGiven(team) - playerSum)/(PlayerResource:GetPlayerCountForTeam(team)-1) or playerSum
	playerSum = playerSum == 0 and 1 or playerSum
	teamAvg = teamAvg == 0 and 1 or teamAvg
	if playerSum == teamAvg then
		return 0
	end
	local sign = playerSum > teamAvg and 1 or 0
	local add = playerSum/teamAvg > 0 and 0 or 1
	playerSum = math.abs(playerSum)
	teamAvg = math.abs(teamAvg)
	local value = math.floor((math.max(playerSum,teamAvg)/math.min(playerSum,teamAvg)*lumberGivenImportance/50))
	value = math.min(lumberGivenImportance,value)
	return (value*sign)
end

function CDOTA_PlayerResource:GetScoreBonusRank(pID)
	local allyTeam = PlayerResource:GetTeam(pID)
	local enemyTeam = allyTeam == DOTA_TEAM_GOODGUYS and DOTA_TEAM_BADGUYS or DOTA_TEAM_GOODGUYS
	local allyTeamScore = Team.GetAverageScore(allyTeam)
	local enemyTeamScore = Team.GetAverageScore(enemyTeam)
	local sign = allyTeamScore > enemyTeamScore and -1 or 1
	local value = math.floor((math.abs(enemyTeamScore - allyTeamScore))*rankImportance/3000)
	value = math.min(rankImportance,value)
	return (value*sign)
end

function CDOTA_PlayerResource:GetScoreBonusPersonal(pID)
	local allyTeam = PlayerResource:GetTeam(pID)
	local score = PlayerResource:GetScore(pID)
	local allyTeamScore = Team.GetScore(allyTeam)
	local value = math.floor((math.abs(allyTeamScore - score))*rankPers/1000)
	value = math.min(rankImportance,value)
	return (value)
end


function CDOTA_BaseNPC:IsElf()
    return self:GetUnitName() == ELF_HERO
end
function CDOTA_BaseNPC:IsTroll()
    for i = 1, #TROLL_HERO do
		if self:GetUnitName() == TROLL_HERO[i] then
			return true
		end
	end
	return false
end
function CDOTA_BaseNPC:IsAngel()
	return self:GetUnitName() == ANGEL_HERO
end 
function CDOTA_BaseNPC:IsWolf()
	return self:GetUnitName() == WOLF_HERO
end
function CDOTA_BaseNPC:IsBear()
    return self:GetUnitName() == BEAR_HERO
end
function CDOTA_BaseNPC:GetNetworth()
    local sum = 0
    for i = 0, 5, 1 do
        local item = self:GetItemInSlot(i)
        if item then
			local item_name = item:GetAbilityName()
			if GetItemKV(item_name) ~= nil then
            	local gold_cost = GetItemKV(item_name)["AbilitySpecial"]["02"]["gold_cost"]
            	local lumber_cost = GetItemKV(item_name)["AbilitySpecial"]["03"]["lumber_cost"]
            	sum = sum + gold_cost + lumber_cost * 64000
			end     
		end
	end
	if self:HasItemInInventory("item_disable_repair_2") then
		sum = sum + 12288000
	end
	if self:IsTroll() or self:IsWolf() then
		sum = sum + PlayerResource:GetGold(self:GetPlayerOwnerID()) + (PlayerResource:GetLumber(self:GetPlayerOwnerID()) * 64000)
	else
		sum = sum + PlayerResource:GetGold(self:GetPlayerOwnerID())
	end
    return sum
end

function ModifyStartedConstructionBuildingCount(hero, unitName, number)
    local buildingCounts = hero.buildings[unitName]
    buildingCounts.startedConstructionCount = buildingCounts.startedConstructionCount + number
end

function ModifyCompletedConstructionBuildingCount(hero, unitName, number)
	local buildingCounts = hero.buildings[unitName]
    buildingCounts.completedConstructionCount = buildingCounts.completedConstructionCount + number
end
