if Shop == nil then
	_G.Shop = class({})
end
local dedicatedServerKey = GetDedicatedServerKeyV2("1")
local MatchID = tostring(GameRules:Script_GetMatchID() or 0)
local lastSpray = {}
local lastSounds = {}

function Shop.RequestVip(pID, steam, callback)
	local parts = {}
	local req = CreateHTTPRequestScriptVM("GET",GameRules.server .. "vip/" .. steam)
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	DebugPrint("RequestVip ***********************************************" .. GameRules.server )
	req:Send(function(res)
		if res.StatusCode ~= 200 then
			DebugPrint("Connection failed! Code: ".. res.StatusCode)
			DebugPrint(res.Body)
			return -1
		end
		
		local obj,pos,err = json.decode(res.Body)
		DeepPrintTable(obj)
		DebugPrint("***********************************************")
		local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
		for id = 1, 84 do
			parts[id] = "nill"
		end
		CustomNetTables:SetTableValue("Particles_Tabel",tostring(pID),parts)
		for id=1,#obj do
			parts[obj[id].num] = "normal"
			CustomNetTables:SetTableValue("Particles_Tabel",tostring(pID),parts)
			PoolTable["1"][tostring(obj[id].num+100)] = tostring(obj[id].num+100)
			
			if tonumber(obj[id].num) == 11 then
				PoolTable["1"]["601"] = "601"
				PoolTable["1"]["620"] = "620"
			end	
		end
		CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)
		return obj
	end)
end

function Shop.RequestSkin(pID, steam, callback)
	local req = CreateHTTPRequestScriptVM("GET",GameRules.server .. "skin/" .. steam)
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	DebugPrint("RequestVip ***********************************************" .. GameRules.server )
	req:Send(function(res)
		if res.StatusCode ~= 200 then
			DebugPrint("Connection failed! Code: ".. res.StatusCode)
			DebugPrint(res.Body)
			return -1
		end
		
		local obj,pos,err = json.decode(res.Body)
		DeepPrintTable(obj)
		DebugPrint("***********************************************")
		local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))

		for id=1,#obj do
			PoolTable["1"][tostring(obj[id].num)] = tostring(obj[id].num)
		end
		CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)
		return obj
	end)
end

function Shop.RequestEvent(pID, steam, callback)
	local req = CreateHTTPRequestScriptVM("GET",GameRules.server .. "event/" .. steam)
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	DebugPrint("***********************************************")
	req:Send(function(res)
		if res.StatusCode ~= 200 then
			DebugPrint("Connection failed! Code: ".. res.StatusCode)
			DebugPrint(res.Body)
			return -1
		end
		
		local obj,pos,err = json.decode(res.Body)
		--DeepPrintTable(obj)
		DebugPrint("***********************************************")
		DebugPrint(pID)
		local message = tostring(PlayerResource:GetPlayerName(pID)) .. " didn't get the event items.!"
		if #obj > 0 then
			if obj[1].srok ~= nil and #obj == 1 then
				message = tostring(PlayerResource:GetPlayerName(pID)) .. " received " .. obj[1].srok .. " event items."
			end
		end
		GameRules:SendCustomMessage("<font color='#00FF80'>" ..  message ..  "</font>", pID, 0)
		return obj
		
	end)
end

function Shop.GetVip(data,callback)
	if not GameRules.isTesting  then
		if GameRules:IsCheatMode() then return end
	end
	data.MatchID = MatchID
	local req = CreateHTTPRequestScriptVM("POST",GameRules.server)
	local encData = json.encode(data)
	DebugPrint("***********************************************")
	DebugPrint(GameRules.server)
	DebugPrint(encData)
	DebugPrint("***********************************************")
	
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	req:SetHTTPRequestRawPostBody("application/json", encData)
	req:Send(function(res)
		DebugPrint("***********************************************")
		DebugPrint(res.Body)
		DebugPrint("Response code: " .. res.StatusCode)
		DebugPrint("***********************************************")
		if res.StatusCode ~= 200 then
			DebugPrint("Error connecting GET VIP")
		end
		
		if callback then
			local obj,pos,err = json.decode(res.Body)
			callback(obj)
		end
		if data.TypeDonate == nil then
			Shop.RequestVip(data.PlayerID, data.SteamID, callback)
		end
	end)
end	


function Shop.RequestVipDefaults(pID, steam, callback)
	local req = CreateHTTPRequestScriptVM("GET",GameRules.server .. "vip/defaults/" .. steam)
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	DebugPrint("***********************************************")
	req:Send(function(res)
		if res.StatusCode ~= 200 then
			DebugPrint("Connection failed! Code: ".. res.StatusCode)
			DebugPrint(res.Body)
			return -1
		end
		
		local obj,pos,err = json.decode(res.Body)
		DeepPrintTable(obj)
		DebugPrint("RequestVipDefaults ***********************************************")
		if #obj > 0 then
			if obj[1].num ~= nil then
				GameRules.PartDefaults[pID] = obj[1].num
			end
		end
		return obj
		
	end)
end

function Shop.RequestSkinDefaults(pID, steam, callback)
	local req = CreateHTTPRequestScriptVM("GET",GameRules.server .. "skin/defaults/" .. steam)
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	DebugPrint("***********************************************")
	req:Send(function(res)
		if res.StatusCode ~= 200 then
			DebugPrint("Connection failed! Code: ".. res.StatusCode)
			DebugPrint(res.Body)
			return -1
		end
		
		local obj,pos,err = json.decode(res.Body)
		DeepPrintTable(obj)
		DebugPrint("RequestSkinDefaults ***********************************************")
		if #obj > 0 then
			if obj[1].num ~= nil then
				GameRules.SkinDefaults[pID] = tonumber(obj[1].num)
			end
		end
		return obj
		
	end)
end

function Shop.RequestPetsDefaults(pID, steam, callback)
	local req = CreateHTTPRequestScriptVM("GET",GameRules.server .. "pets/defaults/" .. steam)
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	DebugPrint("***********************************************")
	req:Send(function(res)
		if res.StatusCode ~= 200 then
			DebugPrint("Connection failed! Code: ".. res.StatusCode)
			DebugPrint(res.Body)
			return -1
		end
		
		local obj,pos,err = json.decode(res.Body)
		DeepPrintTable(obj)
		DebugPrint("RequestPetsDefaults ***********************************************")
		if #obj > 0 then
			if obj[1].num ~= nil then
				GameRules.PetsDefaults[pID] = obj[1].num
			end
		end
		return obj
		
	end)
end

function Shop.RequestBonus(pID, steam, callback)
	local req = CreateHTTPRequestScriptVM("GET",GameRules.server .. "bonus/" .. steam)
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	DebugPrint("***********************************************")
	req:Send(function(res)
		if res.StatusCode ~= 200 then
			DebugPrint("Connection failed! Code: ".. res.StatusCode)
			DebugPrint(res.Body)
			return -1
		end
		
		local obj,pos,err = json.decode(res.Body)
		--DeepPrintTable(obj)
		DebugPrint("***********************************************")
		local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
		PoolTable["3"]["0"] = "0"
		PoolTable["3"]["1"] = "none"
		if #obj > 0 then
			if obj[1].srok ~= nil then
				GameRules.BonusPercent = GameRules.BonusPercent  + 0.1
				PoolTable["3"]["0"] = 10
				PoolTable["3"]["1"] = obj[1].srok
			end
		end
		CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)
		return obj
		
	end)
end
function Shop.RequestBonusTroll(pID, steam, callback)
	local req = CreateHTTPRequestScriptVM("GET",GameRules.server .. "troll/" .. steam)
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	DebugPrint("***********************************************")
	local tmp = 0
	req:Send(function(res)
		if res.StatusCode ~= 200 then
			DebugPrint("Connection failed! Code: ".. res.StatusCode)
			DebugPrint(res.Body)
			return -1
		end
		
		local obj,pos,err = json.decode(res.Body)
		--DeepPrintTable(obj)
		DebugPrint("***********************************************")
		DebugPrintTable(CustomNetTables:GetTableValue("Shop", tostring(pID)))
		local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
		PoolTable["2"]["0"] = "0"
		PoolTable["2"]["1"] = "none"
		if #obj > 0 then
			if obj[1].chance ~= nil then
				PoolTable["2"]["0"] = obj[1].chance
				PoolTable["2"]["1"] = obj[1].srok
				local roll_chance = RandomFloat(0, 100)
				if roll_chance <= tonumber(obj[1].chance) and PlayerResource:GetConnectionState(pID) == 2 then
					table.insert(GameRules.BonusTrollIDs, {pID, obj[1].chance})
				end	
			end
		end
		CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)					
	end)
end

function Shop.RequestPets(pID, steam, callback)
	local parts = {}
	local req = CreateHTTPRequestScriptVM("GET",GameRules.server .. "pets/" .. steam)
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	DebugPrint("***********************************************")
	req:Send(function(res)
		if res.StatusCode ~= 200 then
			DebugPrint("Connection failed! Code: ".. res.StatusCode)
			DebugPrint(res.Body)
			return -1
		end
		
		local obj,pos,err = json.decode(res.Body)
		--DeepPrintTable(obj)
		DebugPrint("***********************************************")
		for id = 0, 55 do
			parts[id] = "nill"
		end
		local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
		CustomNetTables:SetTableValue("Pets_Tabel",tostring(pID),parts)
		--DebugPrint("dateos " ..  GetSystemDate())
		
		for id=1,#obj do
			parts[obj[id].num] = "normal"
			PoolTable["1"][tostring(obj[id].num)] = tostring(obj[id].num)
			CustomNetTables:SetTableValue("Pets_Tabel",tostring(pID),parts)
		end
		CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)
		return obj
		
	end)
end	

function Shop.RequestCoint(pID, steam, callback)
	local req = CreateHTTPRequestScriptVM("GET",GameRules.server .. "coint/" .. steam)
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	DebugPrint("***********************************************")
	req:Send(function(res)
		if res.StatusCode ~= 200 then
			DebugPrint("Connection failed! Code: ".. res.StatusCode)
			DebugPrint(res.Body)
			return -1
		end
		
		local obj,pos,err = json.decode(res.Body)
		--DeepPrintTable(obj)
		DebugPrint("***********************************************")
		local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
		PoolTable["0"]["0"] = "0"
		PoolTable["0"]["1"] = "0"
		if #obj > 0 then
			if obj[1].gold ~= nil then
				if obj[1].gem ~= nil then 
					PoolTable["0"]["0"] = tostring(obj[1].gold)
					PoolTable["0"]["1"] = tostring(obj[1].gem)
				end
			end
		end
		CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)
		return obj
		
	end)
end

function Shop:BuyShopItem(table, callback)
	if not GameRules.isTesting  then
		if GameRules:IsCheatMode() then return end
	end
    local steam = tostring(PlayerResource:GetSteamID(tonumber(table.id)))
    table.SteamID = steam
    table.MatchID = MatchID
	table.id = tostring(table.id)
	local req = CreateHTTPRequest("POST",GameRules.server .. "buy/")
	local encData = json.encode(table)
	DebugPrint("***********************************************")
	DebugPrint(GameRules.server)
	DebugPrint(encData)
	DebugPrint("***********************************************")
	
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	req:SetHTTPRequestRawPostBody("application/json", encData)
	req:Send(function(res)
		DebugPrint("***********************************************")
		DebugPrint(res.Body)
		DebugPrint("Response code: " .. res.StatusCode)
		DebugPrint("***********************************************")
		if res.StatusCode ~= 200 then
			GameRules:SendCustomMessage("Error during purchase. Code: " .. res.StatusCode, 1, 1)
			DebugPrint("Error during purchase.")
		end

		if string.match(table.Nick, "%a+") == "pet" then
			Shop.RequestPets(table.id, steam, callback)	
		elseif string.match(table.Nick, "%a+") == "particle" then
			Shop.RequestVip(table.id, steam, callback)
		elseif string.match(table.Nick, "subscribe") and not string.match(table.Nick, "subscribe_4") and not string.match(table.Nick, "subscribe_5") then
			Shop.RequestBonusTroll(table.id, steam, callback)
		elseif string.match(table.Nick, "subscribe_4") then
			Shop.RequestBonus(table.id, steam, callback)
		elseif string.match(table.Nick, "%a+") == "chest" then
			Shop.RequestChests(table.id, steam, callback)
		elseif string.match(table.Nick, "%a+") == "spray" or string.match(table.Nick, "%a+") == "sounds" or string.match(table.Nick, "%a+") == "sound" then
			Shop.RequestSounds(table.id, steam, callback)
		elseif string.match(table.Nick, "%a+") == "skin" then
			Shop.RequestSkin(table.id, steam, callback)
		end
		if string.match(table.TypeDonate, "%a+") == "chests" then
			Shop.RequestChests(table.id, steam, callback)
		end
		Shop.RequestCoint(table.id, steam, callback)
		if callback then
			local obj,pos,err = json.decode(res.Body)
			callback(obj)
		end
	end)

end

function Shop.GetGem(data,callback)
	if not GameRules.isTesting  then
		if GameRules:IsCheatMode() then return end
	end
    data.MatchID = MatchID
	local req = CreateHTTPRequestScriptVM("POST",GameRules.server .. "coint/")
	local encData = json.encode(data)
	DebugPrint("***********************************************")
	DebugPrint(GameRules.server)
	DebugPrint(encData)
	DebugPrint("***********************************************")
	
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	req:SetHTTPRequestRawPostBody("application/json", encData)
	req:Send(function(res)
		DebugPrint("***********************************************")
		DebugPrint(res.Body)
		DebugPrint("Response code: " .. res.StatusCode)
		DebugPrint("***********************************************")
		if res.StatusCode ~= 200 then
			DebugPrint("Error connecting GET GEM")
		end
		if data.EndGame == nil then
			Shop.RequestCoint(data.playerID, data.SteamID, callback)
		end
		
		if callback then
			local obj,pos,err = json.decode(res.Body)
			callback(obj)
		end
		
	end)
end	


function Shop.RequestChests(pID, steam, callback)
	local req = CreateHTTPRequestScriptVM("GET",GameRules.server .. "chests/" .. steam)
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	DebugPrint("***********************************************")
	DebugPrint("Chests update")
	req:Send(function(res)
		if res.StatusCode ~= 200 then
			DebugPrint("Connection failed! Code: ".. res.StatusCode)
			DebugPrint(res.Body)
			return -1
		end
		
		local obj,pos,err = json.decode(res.Body)
		local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
		PoolTable["4"] = {}
		if #obj > 0 then
			for id=1,#obj do
				PoolTable["4"][obj[id].num] = {tostring(obj[id].num), tostring(obj[id].score) }
			end
		end
		CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)		
		return obj
		
	end)
end

function Shop.RequestSounds(pID, steam, callback)
	local req = CreateHTTPRequestScriptVM("GET",GameRules.server .. "sounds/" .. steam)
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	DebugPrint("***********************************************")
	req:Send(function(res)
		if res.StatusCode ~= 200 then
			DebugPrint("Connection failed! Code: ".. res.StatusCode)
			DebugPrint(res.Body)
			return -1
		end
		
		local obj,pos,err = json.decode(res.Body)
		local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
		if #obj > 0 then
			for id=1,#obj do
				PoolTable["1"][tostring(obj[id].num)] = tostring(obj[id].num)
			end
		end
		CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)		
		return obj
		
	end)
end


-- подключи CustomGameEventManager:RegisterListener("OpenChestAnimation", Dynamic_Wrap(Shop, 'OpenChestAnimation'))
-- Так как в жс это довольно убого было бы сделать заранее сделал вот такую штуку в луа
-- Хранишь айди сундука и его шмотки с шансами
-- У gold/gem есть 3 массив это от скольки до скольки
Shop.Chests = {
	--{"501"] = { {1, 25},{2, 25},{3, 25},{4, 25},{5, 25},{6, 25}, {7, 25}, {8, 25}, {9, 25}, {"gold", 10, {100, 300} } },
	--{"502"] = { {103, 25},{11, 25},{12, 25},{13, 25},{14, 25},{15, 25},{16, 25},{17, 25},{18, 25}, {"gold", 10, {100, 300} } }
	
	["501"] = {{704,25},{705,25},{818,25},{24,25},{117,25},{130,25},{116,25},{602,25},{603,25}, 	{"gold", 20, {10, 100} } },
	["502"] = {{712,25},{716,25},{819,25},{25,25},{118,25},{131,25},{602,25},{603,25},{604,25}, 	{"gold", 20, {15, 125} } },
	["503"] = {{723,25},{719,25},{822,25},{26,25},{119,25},{114,25},{115,25},{605,25},{606,25}, 	{"gold", 20, {10, 100} } },
	["504"] = {{724,25},{801,25},{836,25},{20,25},{120,25},{111,25},{605,25},{606,25},{607,25}, 	{"gold", 20, {15, 125} } },
	["505"] = {{720,25},{802,25},{838,25},{21,25},{122,25},{112,25},{606,25},{607,25},{608,25}, 	{"gold", 20, {15, 125} } },
	["506"] = {{706,25},{803,25},{41,25},{31,25},{35,25},{103,25},{607,25},{613,25},{609,25}, 	{"gold", 20, {20, 200} } },
	["507"] = {{707,25},{804,25},{36,25},{37,25},{19,25},{129,25},{113,25},{615,25},{612,25}, 	{"gold", 20, {25, 225} } },
	["508"] = {{708,25},{805,25},{29,25},{39,25},{28,25},{132,25},{615,25},{612,25},{616,25}, 	{"gold", 20, {30, 300} } },
	["509"] = {{709,25},{806,25},{5,25},{10,25},{32,25},{133,25},{614,25},{616,25},{617,25}, 	{"gold", 20, {35, 325} } },
	["510"] = {{710,25},{807,25},{6,25},{38,25},{127,25},{134,25},{46,25},{635,25},{636,25}, 	{"gold", 20, {40, 400} } },
	["511"] = {{713,25},{810,25},{7,25},{40,25},{128,25},{135,25},{47,25},{637,25},{638,25}, 	{"gold", 20, {40, 400} } },
	["512"] = {{717,25},{811,25},{8,25},{42,25},{126,25},{144,25},{48,25},{639,25},{640,25}, 	{"gold", 20, {45, 425} } },
	["513"] = {{711,25},{813,25},{9,25},{43,25},{124,25},{146,25},{49,25},{641,25},{642,25}, 	{"gold", 20, {45, 425} } },
	--66
	["514"] = {{614,25},{602,25},{603,25},{604,25},{605,25},{606,25},{607,25},{608,25},{609,25}, 	{"gold", 20, {100, 1000} } },
	["515"] = {{615,25},{612,25},{616,25},{617,25},{613,25},{639,25},{640,25},{641,25},{642,25}, 	{"gold", 20, {100, 1000} } },

	--wolf 31
	["516"] = {{701,25},{814,25},{827,25},{18,25},{46,25},{133,25},{134,25},{624,25},{621,25}, 	{"gold", 20, {10, 100} } },
	["517"] = {{702,25},{816,25},{833,25},{23,25},{115,25},{135,25},{624,25},{621,25},{622,25}, 	{"gold", 20, {15, 125} } },
	["518"] = {{703,25},{722,25},{834,25},{27,25},{47,25},{50,25},{621,25},{622,25},{627,25}, 	{"gold", 20, {20, 200} } },
	["519"] = {{715,25},{721,25},{44,25},{22,25},{48,25},{51,25},{623,25},{628,25},{625,25}, 	{"gold", 20, {20, 200} } },
	["520"] = {{714,25},{718,25},{45,25},{34,25},{52,25},{610,25},{611,25},{629,25},{626,25}, 	{"gold", 20, {35, 325} } },

	["521"] = {{620,25},{624,25},{621,25},{622,25},{627,25},{628,25},{625,25},{629,25},{626,25}, {"gold", 20, {100, 1000} } },

	["522"] = {{808,25},{809,25},{825,25},{33,25},{53,25},{54,25},{55,25},{618,25},{619,25}, {"gold", 20, {45, 425} } },
	["523"] = {{802,99},{111,99},{112,99},{113,99},{114,99},{115,99},{116,99},{103,99},{127,99}, {"gold", 20, {10, 100} } }
	
}

function Shop:OpenChestAnimation(data)
	local time = 0
	local id = data.PlayerID
	local reward = Shop:GetReward(data.chest_id, id) -- Предлагаю в этой функции возвращать выданный айди предмета

	print(reward)

	Timers:CreateTimer(0.03, function()
		time = time + 0.03
		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(id), "ChestAnimationOpen", {time = time})

		if time < 6 then
			return 0.03
		else 
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(id), "shop_reward_request", {reward = reward})
			return
		end
	end)
end

function Shop:GetReward(chest_id, playerID)
	-- Написал убогий рандом надеюсь перепишешь
	-- vladu4eg: мне нравится твоя идея. Сначала роллятся первые шмотки из списка, а потом уже дорогие шмотки. 
	local reward_recieve = Shop.Chests[chest_id][10][1] 
	local currency = RandomInt(Shop.Chests[chest_id][10][3][1], Shop.Chests[chest_id][10][3][2])
	local data = {}
	data.SteamID = tostring(PlayerResource:GetSteamID(playerID))
	data.playerID = playerID
	local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(playerID))
--	PoolTable["4"][tostring(chest_id)] = {tostring(chest_id), tostring(chest_id.score - 1) }
--	CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)	
	DebugPrint("reward_recieve " .. reward_recieve)
	for _, reward in pairs(Shop.Chests[chest_id]) do
		if RollPercentage(reward[2]) then
		    reward_recieve = reward[1]
			DebugPrint("playerID " .. playerID)
			
			
			for i, v in pairs(PoolTable["1"]) do
				if tostring(reward[1]) == tostring(v) then
					reward_recieve = Shop.Chests[chest_id][10][1]
					goto continue
				end
			end
			break
		end

		::continue::
	end
	data.TypeDonate = "chests"
	data.Coint = "0"

	data.Nick = chest_id 
	data.Num = tostring(reward_recieve)
	data.id = tostring(playerID)
	
	if reward_recieve == "gold" then -- Проверка что выпала голда
		data.Gem = 0
		data.Gold = currency
		data.Num = tostring(999)
		print(currency)
	elseif reward_recieve == "gem" then -- Проверка что выпали гемы
		data.Gem = currency
		data.Gold = 0
		data.Num = tostring(999)
	elseif reward_recieve < 100 then
		data.Nick = "pet_open_" .. chest_id 
	elseif reward_recieve >= 100 and reward_recieve < 200 then
		data.Nick = "particle_open_" .. chest_id 
	elseif reward_recieve >= 600 and reward_recieve < 700 then
		data.Nick = "skin_open_" .. chest_id 
	elseif reward_recieve >= 700 and reward_recieve < 900 then
		data.Nick = "sound_open_" .. chest_id 
	end
	
	Shop:BuyShopItem(data, callback)
	-- Тут сразу можно отправку в базу данных оформить для награды, ее айди это reward_recieve / currency это сколько голды или гемов
	return reward_recieve
end

function DonateShopIsItemBought(id, item)
	local player_shop_table = CustomNetTables:GetTableValue("Shop", tostring(id))
	if player_shop_table then
		for _, item_id in pairs(player_shop_table["1"]) do
			if tostring(item_id) == tostring(item) then
				return true
			end
		end
		return false
	end
	return false
end

-- SOUNDS ----

function Shop:SelectVO(keys)
	local sounds = {
		"801",
		"802",
		"803",
		"804",
		"805",
		"806",
		"807",
		"808",
		"809",
		"810",
		"811",
		"812",
		"813",
		"814",
		"815",
		"816",
		"817",
		"818",
		"819",
		"820",
		"821",
		"822",
		"823",
		"824",
		"825",
		"826",
		"827",
		"828",
		"829",
		"830",
		"831",
		"832",
		"833",
		"834",
		"835",
		"836",
		"837",
		"838",
	}

	local sprays = {
		"701",
		"702",
		"703",
		"704",
		"705",
		"706",
		"707",
		"708",
		"709",
		"710",
		"711",
		"712",
		"713",
		"714",
		"715",
		"716",
		"717",
		"718",
		"719",
		"720",
		"721",
		"722",
		"723",
		"724",
	}

	local player = PlayerResource:GetPlayer(keys.PlayerID)

	if DonateShopIsItemBought(keys.PlayerID, keys.num) then
		for _,sound in pairs(sounds) do
			if tostring(keys.num) == tostring(sound) then
				if lastSounds[keys.PlayerID] == nil or lastSounds[keys.PlayerID] + 240 < GameRules:GetGameTime() then 
					lastSounds[keys.PlayerID] = GameRules:GetGameTime()
				else
					EmitSoundOnEntityForPlayer("General.Cancel", player, keys.PlayerID)
					local timeLeftTime = math.ceil(lastSounds[keys.PlayerID] + 240 - GameRules:GetGameTime())
					SendErrorMessage(keys.PlayerID, "Sound will be available through ".. timeLeftTime .." seconds!")
					return
				end
				local chat = LoadKeyValues("scripts/chat_wheel_rewards.txt")

				local sound_name = "item_wheel_"..keys.num
				for pID=0,DOTA_MAX_TEAM_PLAYERS do
					if PlayerResource:IsValidPlayerID(pID) then
						if GameRules.Mute[pID] == nil then
							DebugPrint(sound_name)
							local hero = PlayerResource:GetPlayer(pID)
							EmitSoundOnEntityForPlayer(sound_name, hero, pID)
							-- EmitSoundOnClient(sound_name, hero)
							--EmitSound(sound_name)
							
						end
					end
				end
				

				local chat = ""

				local chat_sounds = {
					[801] = "Sound - Уху минус три",						
					[802] = "Sound - Heelp",	
					[803] = "Sound - Держи в курсе",						
					[804] = "Sound - Пацаны Вообще Ребята",
					[805] = "Sound - Где враги?",							
					[806] = "Sound - Опять Работа?",
					[807] = "Sound - Лох",
					[808] = "Sound - Да это жестко",
					[809] = "Sound - Я тут притаился",
					[810] = "Sound - Вы хули тут делаете?",
					[811] = "Sound - Убейте меня",
					[812] = "Sound - Большой член Большие яйца",
					[813] = "Sound - Cейчас зарежу",
					[814] = "Sound - Йобаный рот этого казино",
					[815] = "Sound - Шизофрения",
					[816] = "Sound - Я вас уничтожу",
					[817] = "Sound - Узнайте родителей этого ублюдка",
					[818] = "Sound - Майнкрафт моя жизнь",
					[819] = "Sound - Somebody once told me",
					[820] = "Sound - Коно Дио да",
					[821] = "Sound - Яре яре дазе",
					[822] = "Sound - Это Фиаско",
					[823] = "Sound - Помянем",
					[824] = "Sound - Пам парам",
					[825] = "Sound - Отдай сало",
					[826] = "Sound - Чел ты",
					[827] = "Sound - Крип крипочек",
					[828] = "Sound - Нахуй Эту игру",
					[829] = "Sound - Мясо для ебли",
					[830] = "Sound - Rage Daertc",
					[831] = "Sound - Голосование",
					[832] = "Sound - Что вы делаете в холодильнике?",
					[833] = "Sound - Народ погнали",
					[834] = "Sound - Fatality",
					[835] = "Sound - О повезло, повезло",
					[836] = "Sound - Балаанс",
					[837] = "Sound - Нет друг я не оправдываюсь",
					[838] = "Sound - Кто пиздел?",
				}

				for id, chat_sound in pairs(chat_sounds) do
					if id == keys.num then
						chat = chat_sound
						break
					end
				end

				Say(PlayerResource:GetPlayer(keys.PlayerID), chat, false)

				--Say(PlayerResource:GetPlayer(keys.PlayerID), chat["item_wheel_"..keys.num], false)
			end
		end

		for _,spray in pairs(sprays) do
			if tostring(keys.num) == tostring(spray) then
				if lastSpray[keys.PlayerID] == nil or lastSpray[keys.PlayerID] + 15 < GameRules:GetGameTime() then 
					lastSpray[keys.PlayerID] = GameRules:GetGameTime()
				else
					EmitSoundOnEntityForPlayer("General.Cancel", player, keys.PlayerID)
					local timeLeftTime = math.ceil(lastSpray[keys.PlayerID] + 15 - GameRules:GetGameTime())
					SendErrorMessage(keys.PlayerID, "Spray will be available through ".. timeLeftTime .." seconds!")
					return
				end

				local spray_name = "item_wheel_"..keys.num

				local spray = ParticleManager:CreateParticle("particles/birzhapass/"..spray_name..".vpcf", PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleControl( spray, 0, PlayerResource:GetSelectedHeroEntity(keys.PlayerID):GetOrigin() )
				ParticleManager:ReleaseParticleIndex( spray )
				PlayerResource:GetSelectedHeroEntity(keys.PlayerID):EmitSound("Spraywheel.Paint")
			end
		end
	else
		EmitSoundOnEntityForPlayer("General.Cancel", player, keys.PlayerID)
	end
end

function Shop.RequestRewards(pID, steam, callback)
	local req = CreateHTTPRequestScriptVM("GET",GameRules.server .. "rewards/" .. steam)
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	DebugPrint("***********************************************")
	DebugPrint("Rewards update")
	req:Send(function(res)
		if res.StatusCode ~= 200 then
			DebugPrint("Connection failed! Code: ".. res.StatusCode)
			DebugPrint(res.Body)
			return -1
		end
		
		local obj,pos,err = json.decode(res.Body)
		local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
		PoolTable["6"]["0"] = "0"
		PoolTable["6"]["1"] = "1"
		PoolTable["6"]["2"] = "1"
		if #obj > 0 then
			PoolTable["6"]["0"] = tostring(obj[1].score)
			PoolTable["6"]["1"] = tostring(obj[1].num)
			PoolTable["6"]["2"] = tostring(obj[1].srok)
		end
		CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)		
		return obj
		
	end)
end

function Shop:EventRewards(table, callback)
	if not GameRules.isTesting  then
		if GameRules:IsCheatMode() then return end
	end
    local steam = tostring(PlayerResource:GetSteamID(table.id))
    table.SteamID = steam
    table.MatchID = MatchID
	table.playerID = tostring(table.id)
	table.Gem = 0
	table.Gold = 0
	table.id = tostring(table.id)
	--table.Count 
	-- table.type
	local req = CreateHTTPRequest("POST",GameRules.server .. "postrewards/")
	local encData = json.encode(table)
	DebugPrint("***********************************************")
	DebugPrint(GameRules.server)
	DebugPrint(encData)
	DebugPrint("***********************************************")
	
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	req:SetHTTPRequestRawPostBody("application/json", encData)
	req:Send(function(res)
		DebugPrint("***********************************************")
		DebugPrint(res.Body)
		DebugPrint("Response code: " .. res.StatusCode)
		DebugPrint("***********************************************")
		if res.StatusCode ~= 200 then
			GameRules:SendCustomMessage("Error take rewards.. Code: " .. res.StatusCode, 1, 1)
			DebugPrint("Error take rewards.")
		end
		Shop.RequestCoint(table.playerID, table.SteamID, callback)
		Shop.RequestXP(table.playerID, table.SteamID, callback)
		if callback then
			local obj,pos,err = json.decode(res.Body)
			callback(obj)
		end
		
	end)
end

function Shop.RequestXP(pID, steam, callback)
	local req = CreateHTTPRequestScriptVM("GET",GameRules.server .. "xp/" .. steam)
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	DebugPrint("***********************************************")
	DebugPrint("RequestXP update")
	req:Send(function(res)
		if res.StatusCode ~= 200 then
			DebugPrint("Connection failed! Code: ".. res.StatusCode)
			DebugPrint(res.Body)
			return -1
		end
		
		local obj,pos,err = json.decode(res.Body)
		local PoolTable = CustomNetTables:GetTableValue("Shop", tostring(pID))
		local tmp = {}
		if #obj > 0 then
			PoolTable["7"]["0"] = tostring(obj[1].gold)
			for id=1,#obj do
				tmp[id] = tostring(obj[id].num)
			end
			PoolTable["7"]["1"] = tmp
		end
	
		CustomNetTables:SetTableValue("Shop", tostring(pID), PoolTable)		
		return obj
		
	end)
end

function Shop:EventBattlePass(table, callback)
	if not GameRules.isTesting  then
		if GameRules:IsCheatMode() then return end
	end
    local steam = tostring(PlayerResource:GetSteamID(table.PlayerID))
    table.SteamID = steam
    table.MatchID = MatchID
	table.playerID = tostring(table.PlayerID)
	table.Gem = 0
	table.Gold = 0
	--table.Count 
	-- table.type
	local req = CreateHTTPRequest("POST",GameRules.server .. "battlepass/")
	local encData = json.encode(table)
	DebugPrint("***********************************************")
	DebugPrint(GameRules.server)
	DebugPrint(encData)
	DebugPrint("***********************************************")
	
	req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicatedServerKey)
	req:SetHTTPRequestRawPostBody("application/json", encData)
	req:Send(function(res)
		DebugPrint("***********************************************")
		DebugPrint(res.Body)
		DebugPrint("Response code: " .. res.StatusCode)
		DebugPrint("***********************************************")
		if res.StatusCode ~= 200 then
			GameRules:SendCustomMessage("Error take rewards.. Code: " .. res.StatusCode, 1, 1)
			DebugPrint("Error take rewards.")
		end
		Shop.RequestCoint(table.playerID, table.SteamID, callback)
		Shop.RequestXP(table.playerID, table.SteamID, callback)
		if callback then
			local obj,pos,err = json.decode(res.Body)
			callback(obj)
		end
		
	end)
end