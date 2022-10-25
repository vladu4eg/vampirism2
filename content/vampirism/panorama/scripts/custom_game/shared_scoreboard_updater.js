"use strict";

var type_panel = 3 // 1 - mini, 2 - medium, 3 - full
ChangePanelType("Maximum")

//=============================================================================
//=============================================================================
function _ScoreboardUpdater_SetTextSafe( panel, childName, textValue )
{
	if ( panel === null )
		return;
	var childPanel = panel.FindChildInLayoutFile( childName );
	if ( childPanel === null )
		return;

	childPanel.text = textValue;
}


var ui = GameUI.CustomUIConfig();
//=============================================================================
//=============================================================================
function _ScoreboardUpdater_UpdatePlayerPanel( scoreboardConfig, playersContainer, playerId, localPlayerTeamId )
{
	var playerPanelName = "_dynamic_player_" + playerId;
	var playerPanel = playersContainer.FindChild( playerPanelName );
	if ( playerPanel === null )
	{
		playerPanel = $.CreatePanel( "Panel", playersContainer, playerPanelName );
		playerPanel.SetAttributeInt( "player_id", playerId );
		playerPanel.BLoadLayout( scoreboardConfig.playerXmlName, false, false );
	}

	playerPanel.SetHasClass( "is_local_player", ( playerId == Game.GetLocalPlayerID() ) );
	playerPanel.pID = playerId;

	var isTeammate = false;

	var playerInfo = Game.GetPlayerInfo( playerId );
	var playerStatsScore = CustomNetTables.GetTableValue("scorestats",playerId.toString());



	var score_check = playerPanel.FindChildInLayoutFile( "PlayerScoreInformation" )
	var full_res_check = playerPanel.FindChildInLayoutFile( "GiveResourcesTable" )
	var kick_flag_check = playerPanel.FindChildInLayoutFile( "DopPanels" )

	if ( playerInfo )
	{
		isTeammate = ( playerInfo.player_team_id == localPlayerTeamId );





		playerPanel.SetHasClass( "player_dead", ( playerInfo.player_respawn_seconds >= 0 ) );
		playerPanel.SetHasClass( "local_player_teammate", isTeammate && ( playerId != Game.GetLocalPlayerID() ) );


		if (type_panel == 3) {
			if ($("#Legend")){
				$("#Legend").style.visibility = "visible";
			}
			if (score_check) {
				score_check.style.visibility = "visible"
			}
			if ( (!playerPanel.BHasClass("is_local_player")) && (isTeammate) ) {
				if (full_res_check) {
					full_res_check.style.visibility = "visible"
				}
				if (kick_flag_check) {
					kick_flag_check.style.visibility = "visible"
				}
			}
			else
			{
				if (kick_flag_check)
				{
					kick_flag_check.style.visibility = "collapse"
				}
				else if (full_res_check)
				{
					full_res_check.style.visibility = "collapse"
				}	
			}

		} else if (type_panel == 2) {
			if ($("#Legend")){
				$("#Legend").style.visibility = "collapse";
			}
			if (score_check) {
				score_check.style.visibility = "collapse"
			}
			if ( (!playerPanel.BHasClass("is_local_player")) && (isTeammate) ) {
				if (full_res_check) {
					full_res_check.style.visibility = "visible"
				}
				if (kick_flag_check) {
					kick_flag_check.style.visibility = "collapse"
				}
			}
			else
			{
				kick_flag_check.style.visibility = "collapse"
				full_res_check.style.visibility = "collapse"
			}
		} else if (type_panel == 1) {
			if ($("#Legend")){
				$("#Legend").style.visibility = "collapse";
			}
			if (score_check) {
				score_check.style.visibility = "collapse"
			}
			if ( (!playerPanel.BHasClass("is_local_player")) && (isTeammate) ) {
				if (full_res_check) {
					full_res_check.style.visibility = "collapse"
				}
				if (kick_flag_check) {
					kick_flag_check.style.visibility = "collapse"
				}
			}
			else
			{
				kick_flag_check.style.visibility = "collapse"
				full_res_check.style.visibility = "collapse"
			}
		}

		_ScoreboardUpdater_SetTextSafe( playerPanel, "RespawnTimer", ( playerInfo.player_respawn_seconds + 1 ) ); // value is rounded down so just add one for rounded-up
		_ScoreboardUpdater_SetTextSafe( playerPanel, "PlayerName", playerInfo.player_name );
		_ScoreboardUpdater_SetTextSafe( playerPanel, "Level", playerInfo.player_level );
		_ScoreboardUpdater_SetTextSafe( playerPanel, "Kills", playerInfo.player_kills );
		_ScoreboardUpdater_SetTextSafe( playerPanel, "Deaths", playerInfo.player_deaths );

		var goldValue = ui.playerGold[playerId];
		var lumberValue = ui.playerLumber[playerId];


		//$.Msg("Scoreboard update... playerId: ", playerId, "; goldValue: ", goldValue, "; lumberValue: ", lumberValue);


		if (isTeammate) {
			var lumber_icon = playerPanel.FindChildInLayoutFile( "GoldPanel" );
			var gold_icon = playerPanel.FindChildInLayoutFile( "LumberPanel" );
			if (lumber_icon) {
				lumber_icon.style.visibility = "visible"
			}
			if (gold_icon) {
				gold_icon.style.visibility = "visible"
			}
			_ScoreboardUpdater_SetTextSafe( playerPanel, "PlayerGoldAmount", goldValue );
			_ScoreboardUpdater_SetTextSafe( playerPanel, "PlayerLumberAmount", lumberValue );
		} else {
			var lumber_icon = playerPanel.FindChildInLayoutFile( "GoldPanel" );
			var gold_icon = playerPanel.FindChildInLayoutFile( "LumberPanel" );
			if (lumber_icon) {
				lumber_icon.style.visibility = "collapse"
			}
			if (gold_icon) {
				gold_icon.style.visibility = "collapse"
			}
		}


		//$.Msg("Setting Scoreboard resources for playerId: ", playerId, "; playerStatsScore: ", playerStatsScore, "; ");
		if(playerStatsScore)
		{
			_ScoreboardUpdater_SetTextSafe( playerPanel, "ElfScore", playerStatsScore.playerScoreElf.toString() );
			_ScoreboardUpdater_SetTextSafe( playerPanel, "TrollScore", playerStatsScore.playerScoreTroll.toString() );
		}
		////..////////////
		var playerPortrait = playerPanel.FindChildInLayoutFile( "HeroIcon" );
		if ( playerPortrait )
		{

			var portrait_path = "file://{images}/heroes/"

			if ( playerInfo.player_selected_hero !== "" )
			{
				playerPortrait.SetImage( portrait_path + playerInfo.player_selected_hero + ".png" );
			}
			else
			{
				playerPortrait.SetImage( "file://{images}/custom_game/unassigned.png" );
			}

		}

		var playerPortrait_end = playerPanel.FindChildInLayoutFile( "HeroIconEnd" );
		if ( playerPortrait_end )
		{
			if ( playerInfo.player_selected_hero !== "" )
			{
				playerPortrait_end.SetImage( "file://{images}/heroes/icons/" + playerInfo.player_selected_hero + ".png" );
			}
		}

		if ( playerInfo.player_selected_hero_id == -1 )
		{
			_ScoreboardUpdater_SetTextSafe( playerPanel, "HeroName", $.Localize( "#DOTA_Scoreboard_Picking_Hero" ) )
		}
		else
		{
			_ScoreboardUpdater_SetTextSafe( playerPanel, "HeroName", $.Localize( "#"+playerInfo.player_selected_hero ) )
		}

		var heroNameAndDescription = playerPanel.FindChildInLayoutFile( "HeroNameAndDescription" );
		if ( heroNameAndDescription )
		{
			if ( playerInfo.player_selected_hero_id == -1 )
			{
				heroNameAndDescription.SetDialogVariable( "hero_name", $.Localize( "#DOTA_Scoreboard_Picking_Hero" ) );
			}
			else
			{
				heroNameAndDescription.SetDialogVariable( "hero_name", $.Localize( "#"+playerInfo.player_selected_hero ) );
			}
			heroNameAndDescription.SetDialogVariableInt( "hero_level",  playerInfo.player_level );
		}
		playerPanel.SetHasClass( "player_connection_abandoned", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_ABANDONED );
		playerPanel.SetHasClass( "player_connection_failed", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_FAILED );
		playerPanel.SetHasClass( "player_connection_disconnected", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_DISCONNECTED );

		var playerAvatar = playerPanel.FindChildInLayoutFile( "AvatarImage" );
		if ( playerAvatar )
		{
			playerAvatar.steamid = playerInfo.player_steamid;
		}

		var playerColorBar = playerPanel.FindChildInLayoutFile( "PlayerColorBar" );
		if ( playerColorBar !== null )
		{
			if ( GameUI.CustomUIConfig().team_colors )
			{
				var teamColor = GameUI.CustomUIConfig().team_colors[ playerInfo.player_team_id ];
				if ( teamColor )
				{
					playerColorBar.style.backgroundColor = teamColor;
				}
			}
			else
			{
				var playerColor = "#000000";
				playerColorBar.style.backgroundColor = playerColor;
			}
		}
	}

	var playerItemsContainer = playerPanel.FindChildInLayoutFile( "PlayerItemsContainer" );
	if ( playerItemsContainer )
	{
		var playerItems = Game.GetPlayerItems( playerId );
		if ( playerItems )
		{
	//		$.Msg( "playerItems = ", playerItems );
			for ( var i = playerItems.inventory_slot_min; i < playerItems.inventory_slot_max; ++i )
			{
				var itemPanelName = "_dynamic_item_" + i;
				var itemPanel = playerItemsContainer.FindChild( itemPanelName );
				if ( itemPanel === null )
				{
					itemPanel = $.CreatePanel( "Image", playerItemsContainer, itemPanelName );
					itemPanel.AddClass( "PlayerItem" );
				}

				var itemInfo = playerItems.inventory[i];
				if ( itemInfo )
				{
					var item_image_name = "file://{images}/items/" + itemInfo.item_name.replace( "item_", "" ) + ".png"
					if ( itemInfo.item_name.indexOf( "recipe" ) >= 0 )
					{
						item_image_name = "file://{images}/items/recipe.png"
					}
					itemPanel.SetImage( item_image_name );
				}
				else
				{
					itemPanel.SetImage( "" );
				}
			}
		}
	}
}


//=============================================================================
//=============================================================================
function _ScoreboardUpdater_UpdateTeamPanel( scoreboardConfig, containerPanel, teamDetails, teamsInfo ) {
	if ( !containerPanel )
		return;

	var teamId = teamDetails.team_id;
//	$.Msg( "_ScoreboardUpdater_UpdateTeamPanel: ", teamId );

	//$.Msg("ID - " + teamId);
	var teamPanelName = "_dynamic_team_" + teamId;
	var teamPanel = containerPanel.FindChild( teamPanelName );
	if ( teamPanel === null )
	{
//		$.Msg( "UpdateTeamPanel.Create: ", teamPanelName, " = ", scoreboardConfig.teamXmlName );
		teamPanel = $.CreatePanel( "Panel", containerPanel, teamPanelName );
		teamPanel.SetAttributeInt( "team_id", teamId );
		teamPanel.BLoadLayout( scoreboardConfig.teamXmlName, false, false );

		var logo_xml = GameUI.CustomUIConfig().team_logo_xml;
		if ( logo_xml )
		{
			var teamLogoPanel = teamPanel.FindChildInLayoutFile( "TeamLogo" );
			if ( teamLogoPanel )
			{
				teamLogoPanel.SetAttributeInt( "team_id", teamId );
				teamLogoPanel.BLoadLayout( logo_xml, false, false );
			}
		}
	}

	var localPlayerTeamId = -1;
	var localPlayer = Game.GetLocalPlayerInfo();
	if ( localPlayer )
	{
		localPlayerTeamId = localPlayer.player_team_id;
	}
	teamPanel.SetHasClass( "local_player_team", localPlayerTeamId == teamId );
	teamPanel.SetHasClass( "not_local_player_team", localPlayerTeamId != teamId );

	var teamPlayers = Game.GetPlayerIDsOnTeam( teamId )
	var playersContainer = teamPanel.FindChildInLayoutFile( "PlayersContainer" );
	if ( playersContainer )
	{
		for( var i = 0;i<16;i++){
			var playerPanel = playersContainer.FindChild("_dynamic_player_" + i);
			if(playerPanel){
				//$.Msg("Found " + playerPanel.id + " in team " + teamId);
				if(teamPlayers.indexOf(i) == -1){
					playerPanel.style.visibility = "collapse";
					playerPanel.RemoveAndDeleteChildren();
				}
			}
		}
		for ( var playerId of teamPlayers )
		{
			_ScoreboardUpdater_UpdatePlayerPanel( scoreboardConfig, playersContainer, playerId, localPlayerTeamId )
		}
	}

	teamPanel.SetHasClass( "no_players", (teamPlayers.length == 0) );
	teamPanel.SetHasClass( "one_player", (teamPlayers.length == 1) );

	if ( teamsInfo.max_team_players < teamPlayers.length )
	{
		teamsInfo.max_team_players = teamPlayers.length;
	}

	_ScoreboardUpdater_SetTextSafe( teamPanel, "TeamName", $.Localize("#" +  teamDetails.team_name ) )

	if ( GameUI.CustomUIConfig().team_colors )
	{
		var teamColor = GameUI.CustomUIConfig().team_colors[ teamId ];
		var teamColorPanel = teamPanel.FindChildInLayoutFile( "TeamColor" );

		teamColor = teamColor.replace( ";", "" );

		if ( teamColorPanel )
		{
			teamNamePanel.style.backgroundColor = teamColor + ";";
		}

		var teamColor_GradentFromTransparentLeft = teamPanel.FindChildInLayoutFile( "TeamColor_GradentFromTransparentLeft" );
		if ( teamColor_GradentFromTransparentLeft )
		{
			var gradientText = 'gradient( linear, 0% 0%, 800% 0%, from( #00000000 ), to( ' + teamColor + ' ) );';
//			$.Msg( gradientText );
			teamColor_GradentFromTransparentLeft.style.backgroundColor = gradientText;
		}
	}

	return teamPanel;
}

//=============================================================================
//=============================================================================
function _ScoreboardUpdater_ReorderTeam( scoreboardConfig, teamsParent, teamPanel, teamId, newPlace, prevPanel )
{
//	$.Msg( "UPDATE: ", GameUI.CustomUIConfig().teamsPrevPlace );
	var oldPlace = null;
	if ( GameUI.CustomUIConfig().teamsPrevPlace.length > teamId )
	{
		oldPlace = GameUI.CustomUIConfig().teamsPrevPlace[ teamId ];
	}
	GameUI.CustomUIConfig().teamsPrevPlace[ teamId ] = newPlace;

	if ( newPlace != oldPlace )
	{
//		$.Msg( "Team ", teamId, " : ", oldPlace, " --> ", newPlace );
		teamPanel.RemoveClass( "team_getting_worse" );
		teamPanel.RemoveClass( "team_getting_better" );
		if ( newPlace > oldPlace )
		{
			teamPanel.AddClass( "team_getting_worse" );
		}
		else if ( newPlace < oldPlace )
		{
			teamPanel.AddClass( "team_getting_better" );
		}
	}

	teamsParent.MoveChildAfter( teamPanel, prevPanel );
}

// sort / reorder as necessary
function compareFunc( a, b ) // GameUI.CustomUIConfig().sort_teams_compare_func;
{
	if ( a.team_score < b.team_score ) {
		return 1; // [ B, A ]
	}
	if ( a.team_score > b.team_score ) {
		return -1; // [ A, B ]
	}
	return 0;
};

function stableCompareFunc( a, b ) {
	var unstableCompare = compareFunc( a, b );
	if ( unstableCompare !== 0 ) {
		return unstableCompare;
	}

	if ( GameUI.CustomUIConfig().teamsPrevPlace.length <= a.team_id ) {
		return 0;
	}

	if ( GameUI.CustomUIConfig().teamsPrevPlace.length <= b.team_id ) {
		return 0;
	}

//			$.Msg( GameUI.CustomUIConfig().teamsPrevPlace );

	var a_prev = GameUI.CustomUIConfig().teamsPrevPlace[ a.team_id ];
	var b_prev = GameUI.CustomUIConfig().teamsPrevPlace[ b.team_id ];
	if ( a_prev < b_prev ) // [ A, B ]
	{
		return -1; // [ A, B ]
		}
	else if ( a_prev > b_prev ) // [ B, A ]
	{
		return 1; // [ B, A ]
	}
	else
	{
		return 0;
	}
}

//=============================================================================
//=============================================================================
function _ScoreboardUpdater_UpdateAllTeamsAndPlayers( scoreboardConfig, teamsContainer ) {
	var teamsList = [];
	for ( var teamId of Game.GetAllTeamIDs() )
	{
		teamsList.push( Game.GetTeamDetails( teamId ) );
	}

	// update/create team panels
	var teamsInfo = { max_team_players: 0 };
	var panelsByTeam = [];
	for ( var i = 0; i < teamsList.length; ++i )
	{
		var teamPanel = _ScoreboardUpdater_UpdateTeamPanel( scoreboardConfig, teamsContainer, teamsList[i], teamsInfo );
		if ( teamPanel )
		{
			panelsByTeam[ teamsList[i].team_id ] = teamPanel;
		}
	}

	if ( teamsList.length > 1 ) {
		// sort
		if ( scoreboardConfig.shouldSort )
		{
			teamsList.sort( stableCompareFunc );
		}

		// reorder the panels based on the sort
		var prevPanel = panelsByTeam[ teamsList[0].team_id ];
		for ( var i = 0; i < teamsList.length; ++i ) {
			var teamId = teamsList[i].team_id;
			var teamPanel = panelsByTeam[ teamId ];
			_ScoreboardUpdater_ReorderTeam( scoreboardConfig, teamsContainer, teamPanel, teamId, i, prevPanel );
			prevPanel = teamPanel;
		}
	}
}


//=============================================================================
//=============================================================================
function ScoreboardUpdater_InitializeScoreboard( scoreboardConfig, scoreboardPanel )
{
	GameUI.CustomUIConfig().teamsPrevPlace = [];
	if ( typeof(scoreboardConfig.shouldSort) === 'undefined')
	{
		// default to true
		scoreboardConfig.shouldSort = true;
	}
	_ScoreboardUpdater_UpdateAllTeamsAndPlayers( scoreboardConfig, scoreboardPanel );
	return { scoreboardConfig, scoreboardPanel };
}


//=============================================================================
//=============================================================================
function ScoreboardUpdater_SetScoreboardActive( scoreboardHandle, isActive )
{
	if ( scoreboardHandle.scoreboardConfig === null || scoreboardHandle.scoreboardPanel === null )
	{
		return;
	}

	if ( isActive )
	{
		_ScoreboardUpdater_UpdateAllTeamsAndPlayers( scoreboardHandle.scoreboardConfig, scoreboardHandle.scoreboardPanel );
	}
}

//=============================================================================
//=============================================================================
function ScoreboardUpdater_GetTeamPanel( scoreboardHandle, teamId )
{
	if ( scoreboardHandle.scoreboardPanel === null )
	{
		return;
	}

	var teamPanelName = "_dynamic_team_" + teamId;
	return scoreboardHandle.scoreboardPanel.FindChild( teamPanelName );
}

//=============================================================================
//=============================================================================
function ScoreboardUpdater_GetSortedTeamInfoList( scoreboardHandle )
{
	var teamsList = [];
	for ( var teamId of Game.GetAllTeamIDs() )
	{
		teamsList.push( Game.GetTeamDetails( teamId ) );
	}

	if ( teamsList.length > 1 )
	{
		teamsList.sort( stableCompareFunc );
	}

	return teamsList;
}





function ChangePanelType(PanelType) {

	if ($("#MinType")) {
		$("#MinType").style.brightness = "1";
	}
	if ($("#MedType")) {
		$("#MedType").style.brightness = "1";
	}
	if ($("#MaxType")) {
		$("#MaxType").style.brightness = "1";
	}
	
	
	

	




	if (PanelType == "Mini") {
		if ($("#MinType")) {
			$("#MinType").style.brightness = "4";
		}
		type_panel = 1
	} else if (PanelType == "Medium") {
		if ($("#MedType")) {
			$("#MedType").style.brightness = "4";
		}
		type_panel = 2
	} else if (PanelType == "Maximum") {
		if ($("#MaxType")) {
			$("#MaxType").style.brightness = "4";
		}
		type_panel = 3
	}
}