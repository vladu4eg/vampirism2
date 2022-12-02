if drop == nil then
	_G.drop = class({})
end
require('settings')
item_drop = {
	--{items = {"item_branches"}, chance = 5, duration = 5, limit = 3, units = {} },

	{items = {"item_lia_rune_gold"}, limit = 9999, chance = 100, duration = 60, units = 
	{"npc_dota_hero_lycan","npc_dota_hero_omniknight", "npc_dota_hero_night_stalker","npc_dota_hero_doom_bringer",
	"npc_dota_hero_life_stealer","npc_dota_hero_slardar","wood_worker_1","wood_worker_2", "wood_worker_3","wood_worker_4",
	"wood_worker_5","build_worker_1","build_worker_2"} },


	{items = {"item_vip"}, limit = 1, chance = 1, units = {"npc_dota_hero_crystal_maiden","npc_dota_hero_lycan","npc_dota_hero_omniknight"} },
	{items = {"item_get_gem"}, limit = 10, chance = 10, units = {"npc_dota_hero_crystal_maiden","npc_dota_hero_lycan","npc_dota_hero_omniknight"} },
	{items = {SEASON_ITEM}, limit = 15, chance = 500, units = {"npc_dota_hero_crystal_maiden","npc_dota_hero_lycan","npc_dota_hero_omniknight"} },
	
	{items = {"item_get_gold"}, limit = 1, chance = 5, units = {"event_line_boss_halloween"} },
	{items = {"item_event_birthday"}, limit = 1, chance = 400, units = {"event_line_boss_halloween"} },
	
	-- {items = {"item_get_gold"}, limit = 1, chance = 5, units = {"npc_dota_hero_crystal_maiden","npc_dota_hero_lycan","npc_dota_hero_omniknight","npc_dota_hero_lina","event_line_boss_halloween"} },
	{items = {"item_get_gold"}, limit = 1, chance = 50, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina"} },
	--{items = {"item_get_gold"}, limit = 1, chance = 5, units = {"barracks_3"} },

	{items = {SEASON_ITEM}, limit = 15, chance = 500, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	{items = {SEASON_ITEM}, limit = 15, chance = 450, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	{items = {SEASON_ITEM}, limit = 15, chance = 400, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	{items = {SEASON_ITEM}, limit = 15, chance = 350, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	{items = {SEASON_ITEM}, limit = 15, chance = 300, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	{items = {SEASON_ITEM}, limit = 15, chance = 250, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	{items = {SEASON_ITEM}, limit = 15, chance = 250, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	{items = {SEASON_ITEM}, limit = 15, chance = 150, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	{items = {SEASON_ITEM}, limit = 15, chance = 100, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	{items = {SEASON_ITEM}, limit = 15, chance = 50, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	
	{items = {"item_get_gem"}, limit = 1, chance = 500, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	{items = {"item_get_gem"}, limit = 1, chance = 400, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	{items = {"item_get_gem"}, limit = 1, chance = 300, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	{items = {"item_get_gem"}, limit = 1, chance = 200, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	{items = {"item_get_gem"}, limit = 1, chance = 100, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	{items = {"item_get_gem"}, limit = 1, chance = 50, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },

	{items = {"item_vip"}, limit = 1, chance = 500, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	{items = {"item_vip"}, limit = 1, chance = 450, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	{items = {"item_vip"}, limit = 1, chance = 400, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	{items = {"item_vip"}, limit = 1, chance = 350, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	{items = {"item_vip"}, limit = 1, chance = 300, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	{items = {"item_vip"}, limit = 1, chance = 250, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	
	{items = {"item_event_desert"}, limit = 1, chance = 300, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	{items = {"item_event_desert"}, limit = 1, chance = 200, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	{items = {"item_event_desert"}, limit = 1, chance = 100, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	
	{items = {"item_event_winter"}, limit = 1, chance = 300, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	{items = {"item_event_winter"}, limit = 1, chance = 200, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	{items = {"item_event_winter"}, limit = 1, chance = 100, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	
	{items = {"item_event_helheim"}, limit = 1, chance = 300, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	{items = {"item_event_helheim"}, limit = 1, chance = 200, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	{items = {"item_event_helheim"}, limit = 1, chance = 100, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },
	
	{items = {"item_event_birthday"}, limit = 1, chance = 1, units = {"npc_dota_hero_doom_bringer","npc_dota_hero_phantom_assassin","npc_dota_hero_tidehunter","npc_dota_hero_lina","event_line_boss_halloween"} },

	
	-- {items = {"item_event_birthday"}, limit = 1, chance = 2, units = {"barracks_3"} },
	--{items = {"item_lifesteal"}, limit = 200, chance = 70, units = {"npc_neutral_boss_1"} },
	--{items = {"item_dmg_14"}, limit = 200, chance = 70, units = {"npc_neutral_boss_1"} },
	--{items = {"item_reaver"}, limit = 200, chance = 70, units = {"npc_neutral_boss_1"} },
	
	--{items = {"item_soul_booster "}, limit = 200, chance = 70, units = {"npc_neutral_boss_2"} },
	--{items = {"item_mystic_staff"}, limit = 200, chance = 70, units = {"npc_neutral_boss_2"} },
	
	
	--{items = {"item_belt_of_strength","item_boots_of_elves","item_robe"}, chance = 10, limit = 5, units = {"npc_dota_neutral_kobold","npc_dota_neutral_centaur_outrunner"}},--50% drop from list with limit
	--{items = {"item_ogre_axe","item_blade_of_alacrity","item_staff_of_wizardry"}, chance = 75, units = {"npc_dota_neutral_black_dragon","npc_dota_neutral_centaur_khan"}},--75% drop from list
	--{items = {"item_clarity","item_flask"}, chance = 25, duration = 10},-- global drop 25%
	--{items = {"item_rapier"}, chance = 10, limit = 1},-- global drop 10% with limit 1
}

function drop:RollItemDrop(unit)
	local unit_name = unit:GetUnitName()
		for _,drop in ipairs(item_drop) do
			local items = drop.items or nil
			local items_num = #items
			local units = drop.units or nil -- если юниты не были определены, то срабатывает для любого
			local chance = drop.chance or 500 -- если шанс не был определен, то он равен 100
			local loot_duration = drop.duration or nil -- длительность жизни предмета на земле
			local limit = drop.limit or nil -- лимит предметов
			local item_name = items[1] -- название предмета
			local roll_chance = RandomFloat(0, 500)
			if GameRules.PlayersCount < MIN_RATING_PLAYER and item_name ~= "item_lia_rune_gold" then
				return false
			end
			if string.match(GetMapName(),"halloween") then 
				chance = 100
			end
			
			if units then 
				for _,current_name in pairs(units) do
					if current_name == unit_name then
						units = nil
						break
					end
				end
			end
			
			if units == nil and (limit == nil or limit > 0) and roll_chance < chance then
				if limit then
					drop.limit = drop.limit - 1
				end
				
				if items_num > 1 then
					item_name = items[RandomInt(1, #items)]
				end
				
				if SEASON_ITEM == item_name then
					local randTime = RandomInt( 30, 240 )
					Timers:CreateTimer(randTime, function()
						if string.match(GetMapName(),SEASON_MAP)  then
							RandomDropLoot()
						--	RandomDropLoot()
						else
							RandomDropLoot()
						end
					end);
				else
					local spawnPoint = unit:GetAbsOrigin()	
					local newItem = CreateItem( item_name, nil, nil )
					local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
					local dropRadius = RandomFloat( 50, 300 )
					
					newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
				end
				if loot_duration then
					newItem:SetContextThink( "KillLoot", function() return KillLoot( newItem, drop ) end, loot_duration )
				end
			end

		
	end
end

function KillLoot( item, drop )
	
	if drop:IsNull() then
		return
	end
	
	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, drop )
	ParticleManager:SetParticleControl( nFXIndex, 0, drop:GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	--	EmitGlobalSound("Item.PickUpWorld")
	
	UTIL_Remove( item )
	UTIL_Remove( drop )
end

function RandomDropLoot()
	local spawnPoint = Vector(-320,-320,256)
	local dropRadius = RandomFloat( 2600, 7800 )
	local randRadius = spawnPoint + RandomVector( dropRadius )
	for i = 0, 20 do
		randRadius = spawnPoint + RandomVector( dropRadius )
		local gridX = GridNav:GridPosToWorldCenterX(randRadius.x)
    	local gridY = GridNav:GridPosToWorldCenterY(randRadius.y)
		local position = Vector(gridX, gridY, 0)
		if GridNav:IsTraversable(position) then
			break	
		end
	end

	local newItem = CreateItem( SEASON_ITEM, nil, nil )
	local drop = CreateItemOnPositionForLaunch( randRadius, newItem )
	newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, randRadius )

end

function TimerRandomDrop(event)
	local unit = event.caster
	local countGift = 0
	local maxGift = RandomInt( 25, 200 )
	Timers:CreateTimer(function()
		if countGift < maxGift then
			local randTime = RandomInt( 20, 60 )
			local spawnPoint = unit:GetAbsOrigin()	
			local newItem = CreateItem( SEASON_ITEM, nil, nil )
			local dropRadius = RandomFloat( 10, 360 )
			local randRadius = spawnPoint + RandomVector( dropRadius )
			local drop = CreateItemOnPositionForLaunch( randRadius, newItem )
			newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, randRadius )
			countGift = countGift + 1
			return randTime
		end	
	end)
end

