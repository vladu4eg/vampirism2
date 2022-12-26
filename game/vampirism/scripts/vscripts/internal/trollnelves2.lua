
mode = nil
require('filter')
-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function trollnelves2:_Inittrollnelves2()
  -- Setup rules
  GameRules:SetHeroRespawnEnabled(true)
  GameRules:SetUseUniversalShopMode(false)
  GameRules:SetSameHeroSelectionEnabled(true)
  GameRules:SetHeroSelectionTime(0)
  GameRules:SetStrategyTime(0)
  GameRules:SetShowcaseTime(0)
  GameRules:SetPreGameTime(PRE_GAME_TIME)
  GameRules:SetPostGameTime(120)
   -- Will finish game setup using FinishCustomGameSetup()
  GameRules:SetCustomGameSetupRemainingTime(-1)
  GameRules:SetCustomGameSetupTimeout(-1)
  GameRules:EnableCustomGameSetupAutoLaunch(false)
  GameRules:SetCustomGameSetupAutoLaunchDelay(-1)
  GameRules:SetStartingGold(0)
  GameRules:SetTreeRegrowTime(1)
  GameRules:SetUseCustomHeroXPValues(false)
  GameRules:SetGoldPerTick(0)
  GameRules:SetGoldTickTime(0)
  GameRules:SetRuneSpawnTime(0)
  GameRules:SetFirstBloodActive(false)
  GameRules:SetHideKillMessageHeaders(true)
  GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 17)
  GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 17)
  GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_1, 6)
  GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_2, 6)
  GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_3, 6)
  GameRules:SetUseBaseGoldBountyOnHeroes(true)

  -- Setup game mode
  mode = GameRules:GetGameModeEntity()     
  mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )  
  mode:SetRecommendedItemsDisabled(true)
  mode:SetBuybackEnabled(false)
  mode:SetTopBarTeamValuesVisible(false)
  mode:SetCustomHeroMaxLevel(999)
  mode:SetAnnouncerDisabled(false)
  mode:SetWeatherEffectsDisabled(true)
  mode:SetPauseEnabled(false)
  mode:SetStashPurchasingDisabled(true)
  mode:SetNeutralStashEnabled(false)
  mode:SetSendToStashEnabled(false)
  mode:SetInnateMeleeDamageBlockAmount(0)
	mode:SetInnateMeleeDamageBlockPercent(0)
	mode:SetInnateMeleeDamageBlockPerLevelAmount(0)
  mode:SetMinimumAttackSpeed(MINIMUM_ATTACK_SPEED)
  mode:SetMaximumAttackSpeed(MAXIMUM_ATTACK_SPEED)
  
  mode:SetHudCombatEventsDisabled(false)
  mode:SetUseCustomHeroLevels ( true )
  mode:SetCameraDistanceOverride(1400)
    
  mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_DAMAGE,10)
  mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_DAMAGE,10)
  mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_DAMAGE,10)

  mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP, 1200)
  mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP_REGEN, 0.0000000000000) 


  mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ARMOR, 0.1)
  mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ATTACK_SPEED,13)

  mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MANA, 0.5)
  mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MANA_REGEN,  0.00000000000)
  mode:SetBotThinkingEnabled( true )
  
  LinkLuaModifier("modifier_custom_armor", "libraries/modifiers/modifier_custom_armor.lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("modifier_generic_invisibility", "modifiers/modifier_generic_invisibility.lua", LUA_MODIFIER_MOTION_NONE)
  LinkLuaModifier("part_mod", "modifiers/parts/part_mod", LUA_MODIFIER_MOTION_NONE )
  
  -- Event Hooks
  ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(trollnelves2, 'OnGameRulesStateChange'), self)
  ListenToGameEvent('npc_spawned', Dynamic_Wrap(trollnelves2, 'OnNPCSpawned'), self)
  ListenToGameEvent('player_connect_full', Dynamic_Wrap(trollnelves2, 'OnConnectFull'), self)
  ListenToGameEvent("player_reconnected", Dynamic_Wrap(trollnelves2, 'OnPlayerReconnect'), self)
  ListenToGameEvent('entity_killed', Dynamic_Wrap(trollnelves2, 'OnEntityKilled'), self)
  ListenToGameEvent("player_disconnect", Dynamic_Wrap(trollnelves2, 'OnDisconnect'), self)
  ListenToGameEvent('player_chat', Dynamic_Wrap(chatcommand, 'OnPlayerChat'), self)
  ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(trollnelves2, 'OnItemPickedUp'), self)
  ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(trollnelves2, 'OnPlayerLevelUp'), self)
  -- ListenToGameEvent('dota_inventory_item_added', Dynamic_Wrap(trollnelves2, 'OnItemAddedInv'), self)
  ListenToGameEvent('dota_hero_inventory_item_change', Dynamic_Wrap(trollnelves2, 'OnItemStateChanged'), self)

  
  -- Panorama event listeners
  CustomGameEventManager:RegisterListener("give_resources", GiveResources)
  CustomGameEventManager:RegisterListener("choose_help_side", ChooseHelpSide)
  CustomGameEventManager:RegisterListener("player_team_choose", OnPlayerTeamChoose)
  CustomGameEventManager:RegisterListener("choose_kick_side", VoteKick)
  CustomGameEventManager:RegisterListener("votekick_start", VotekickStart)
  CustomGameEventManager:RegisterListener("flag_start", FlagStart)
  CustomGameEventManager:RegisterListener("choose_flag_side", FlagGive)
  CustomGameEventManager:RegisterListener("donate_player_take", PlayerTake )
  CustomGameEventManager:RegisterListener("SelectPart", Dynamic_Wrap(wearables, 'SelectPart'))
  CustomGameEventManager:RegisterListener("SelectSkin", Dynamic_Wrap(wearables, 'SelectSkin'))
  CustomGameEventManager:RegisterListener("BuyShopItem", Dynamic_Wrap(Shop, 'BuyShopItem'))
  CustomGameEventManager:RegisterListener("EventRewards", Dynamic_Wrap(Shop, 'EventRewards'))
  CustomGameEventManager:RegisterListener("EventBattlePass", Dynamic_Wrap(Shop, 'EventBattlePass'))
  CustomGameEventManager:RegisterListener("SetDefaultPart", Dynamic_Wrap(wearables, 'SetDefaultPart'))
  CustomGameEventManager:RegisterListener("SetDefaultPets", Dynamic_Wrap(SelectPets, 'SetDefaultPets'))
  CustomGameEventManager:RegisterListener("SetDefaultSkin", Dynamic_Wrap(wearables, 'SetDefaultSkin'))
  CustomGameEventManager:RegisterListener("UpdateTops", Dynamic_Wrap(top, 'UpdateTops'))
  
  CustomGameEventManager:RegisterListener("SelectPets", Dynamic_Wrap(SelectPets, 'SelectPets'))
  CustomGameEventManager:RegisterListener("OpenChestAnimation", Dynamic_Wrap(Shop, 'OpenChestAnimation'))

  CustomGameEventManager:RegisterListener( "SelectVO", Dynamic_Wrap(Shop,'SelectVO'))
  
  
  CustomNetTables:SetTableValue("building_settings", "team_choice_time", { value = TEAM_CHOICE_TIME })
  
  mode:SetModifyExperienceFilter( Dynamic_Wrap( trollnelves2, "ExperienceFilter" ), self )
  mode:SetModifyGoldFilter( Dynamic_Wrap( trollnelves2, "GoldFilter" ), self ) 
  mode:SetDamageFilter( Dynamic_Wrap( trollnelves2, "DamageFilter" ), self ) 
  
 -- mode:SetItemAddedToInventoryFilter(Dynamic_Wrap(trollnelves2, "ItemPickFilter"), self)


  -- Debugging setup
  local spew = 0
  if TROLLNELVES2_DEBUG_SPEW then
    spew = 1
  end
  Convars:RegisterConvar('trollnelves2_spew', tostring(spew), 'Set to 1 to start spewing trollnelves2 debug info.  Set to 0 to disable.', 0)

  -- Change random seed
  local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '0','')
  math.randomseed(tonumber(timeTxt))
  
  DebugPrint('[TROLLNELVES2] Done loading trollnelves2!\n\n')
end

-- This function is called as the first player loads and sets up the trollnelves2 parameters
function trollnelves2:_Capturetrollnelves2()
  if mode == nil then

    self:OnFirstPlayerLoaded()
  end 
end

function trollnelves2:LoadStaticContent(contentFile)
    return trollnelves2:prequire(contentFile)
end

function trollnelves2:prequire(...)
    local status, lib = pcall(require, ...)
    if (status) then return lib end
    return nil
end

function trollnelves2:ExperienceFilter( kv )
  local team = PlayerResource:GetTeam(kv.player_id_const)
  if team == 2 then
      kv.experience = 0
  end
  return true
end

local trollCountStack = {}

function trollnelves2:DamageFilter( kv )
  if kv.entindex_attacker_const ~= nil then
    local heroAttacker = EntIndexToHScript(kv.entindex_attacker_const)
    local heroKilled = EntIndexToHScript(kv.entindex_victim_const)
    local team = heroAttacker:GetTeamNumber()
    local idAttacker = heroAttacker:GetPlayerOwnerID()

    if heroAttacker:IsTroll() or heroAttacker:IsWolf() then
      if trollCountStack[idAttacker] == nil then
         trollCountStack[idAttacker] = 1
      end
      if heroAttacker:HasModifier("modifier_item_gold_blade") and math.fmod(trollCountStack[idAttacker], 10) == 0 then
        PlayerResource:ModifyGold(heroAttacker, 20)
        heroAttacker:AddExperience(100, DOTA_ModifyXP_Unspecified, false,false)
        PopupGoldGain(heroAttacker,20)
      elseif heroAttacker:HasModifier("modifier_item_gold_staff") and math.fmod(trollCountStack[idAttacker], 10) == 0 then
          PlayerResource:ModifyGold(heroAttacker, 10)
          heroAttacker:AddExperience(50, DOTA_ModifyXP_Unspecified, false,false)
          PopupGoldGain(heroAttacker,10)
      elseif heroAttacker:HasModifier("modifier_item_gold_axe") and math.fmod(trollCountStack[idAttacker], 10) == 0 then     
          PlayerResource:ModifyGold(heroAttacker, 2)
          heroAttacker:AddExperience(10, DOTA_ModifyXP_Unspecified, false,false)
          PopupGoldGain(heroAttacker,2)
      end
      trollCountStack[idAttacker] = trollCountStack[idAttacker] + 1 
    end

    if string.match(heroAttacker:GetUnitName(), "assasin") and not string.match(heroKilled:GetUnitName(), "wood_worker") then
      kv.damage = 0
    end

    if string.match(heroAttacker:GetUnitName(), "meat_carier") and not string.match(heroKilled:GetUnitName(), "npc_dota_hero_templar_assassin") then
      kv.damage = 0
    end

    
    if string.match(heroAttacker:GetUnitName(), "fel_best") and heroKilled:GetUnitName() ~= "worker_1" then
      kv.damage = 0
    end

    if (heroAttacker:IsElf() or string.match(heroAttacker:GetUnitName(), "build_worker")) and heroAttacker:GetPlayerOwnerID() == heroKilled:GetPlayerOwnerID() then
      kv.damage = 99999999999
    elseif heroAttacker:GetPlayerOwnerID() ~= heroKilled:GetPlayerOwnerID() and heroAttacker:GetTeamNumber() == heroKilled:GetTeamNumber() then 
      kv.damage = 0
    end

    if heroKilled:IsElf() and (not heroAttacker:IsTroll() and not heroAttacker:IsWolf()) then
      kv.damage = 0
    end

    if heroAttacker:IsTroll() and heroKilled:IsWolf() then
      kv.damage = 999999999999
    end

    if heroAttacker:GetUnitName() == "tower_20" and heroKilled:GetTeamNumber() == 3 then
      kv.damage = 999999999999
    end

   -- if (string.match(heroKilled:GetUnitName(), "gold_mine") or string.match(heroKilled:GetUnitName(), "wisp")) and team == DOTA_TEAM_BADGUYS then
   --   kv.damage = 10
   -- end
    return true
  end
end

function trollnelves2:GoldFilter( kv )
  local hero = PlayerResource:GetSelectedHeroEntity(kv.player_id_const)
  if hero:IsTroll() then
    local rand = RandomFloat( 0, 100 )
        if hero:HasModifier("modifier_item_golden_hand") then     
          if rand <= 25 then
            kv.gold = kv.gold + 20
          end
        elseif hero:HasModifier("modifier_item_golden_greed") then
          if rand <= 35 then
            kv.gold = kv.gold + 80
          end
        end
        PlayerResource:ModifyGold(hero,kv.gold)
  end
  return true
end

function trollnelves2:OnItemStateChanged(event)
  --print ( '[BAREBONES] OnItemStateChanged' )

    local item = EntIndexToHScript(event.item_entindex) ---@type CDOTA_Item
    local hero = EntIndexToHScript(event.hero_entindex) ---@type CDOTA_BaseNPC_Hero
    item:SetPurchaser(nil)
      if not item or not hero then return end
      local container = item:GetContainer()
      if container then
        if hero:IsElf() then
        --  UTIL_Remove(container)
        --  UTIL_Remove(item)
        end     
      end
end