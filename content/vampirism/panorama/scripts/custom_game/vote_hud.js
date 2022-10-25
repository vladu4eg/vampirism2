"use strict";

function ChooseTeam(team, panel) {
	var PlayerID = Players.GetLocalPlayer()
	GameEvents.SendCustomGameEventToServer("player_team_choose", { "playerID": PlayerID, "team": team });
	$("#border_creep").SetHasClass("active_border", false)
	$("#border_hero").SetHasClass("active_border", false)
	$("#" + panel).SetHasClass("active_border", true)
}

//--------------------------------------------------------------------------------------------------
// Update the state for the transition timer periodically
//--------------------------------------------------------------------------------------------------
var timer = CustomNetTables.GetTableValue( "building_settings", "team_choice_time").value;
function UpdateTimer() {
	$("#TeamChoiceWrapper").SetDialogVariableInt("countdown_timer_seconds", timer);
	if (timer-- > 0) {
		$.Schedule(1, UpdateTimer);
	}
}

(function () {
	var mapInfo = Game.GetMapInfo();
	$("#MapInfo").SetDialogVariable("map_name", mapInfo.map_display_name);
	UpdateTimer();
	Game.AutoAssignPlayersToTeams();
	



})();
