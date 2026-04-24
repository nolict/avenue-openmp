/*
    File: modules/job/logic/taxi.pwn
    Purpose: Contains job gameplay logic and helper functions for taxi.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== Taxi_ShowCalls ======
stock Taxi_ShowCalls(playerid)
{
    static
	    string[2048];

	string[0] = 0;

	foreach (new i : Player) if (PlayerData[i][pTaxiCalled]) {
	    format(string, sizeof(string), "%s%d: %s (%s)\n", string, i, ReturnName(i, 0), GetPlayerLocation(i));
	}
	if (!strlen(string)) {
	    SendErrorMessage(playerid, "There are no taxi calls to accept.");
	}
	else Dialog_Show(playerid, AcceptTaxi, DIALOG_STYLE_LIST, DialogStyle_Title("Taxi Calls"), string, "Accept", "Cancel");
	return 1;
}

// ====== LeaveTaxi ======
stock LeaveTaxi(playerid, driverid)
{
	if (driverid != INVALID_PLAYER_ID && IsPlayerConnected(driverid))
	{
	    GiveMoney(playerid, -PlayerData[playerid][pTaxiFee]);
   		GiveMoney(driverid, PlayerData[playerid][pTaxiFee]);

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid $%d to the taxi driver.", ReturnName(playerid, 0), PlayerData[playerid][pTaxiFee]);

	    PlayerData[playerid][pTaxiFee] = 0;
	    PlayerData[playerid][pTaxiTime] = 0;
	    PlayerData[playerid][pTaxiPlayer] = INVALID_PLAYER_ID;
	}
	return 1;
}
