/*
    File: modules/faction/logic/enforcement.pwn
    Purpose: Contains faction gameplay logic and helper functions for enforcement.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== SetPlayerInPrison ======
stock SetPlayerInPrison(playerid)
{
	new idx = random(sizeof(g_arrPrisonSpawns));

	SetPlayerPosEx(playerid, g_arrPrisonSpawns[idx][0], g_arrPrisonSpawns[idx][1], g_arrPrisonSpawns[idx][2] + 0.3);
	SetPlayerFacingAngle(playerid, g_arrPrisonSpawns[idx][3]);

	SetPlayerInterior(playerid, 5);
	SetPlayerVirtualWorld(playerid, PRISON_WORLD);

	ShowHungerTextdraw(playerid, 0);
	SetCameraBehindPlayer(playerid);
}

// ====== ViewCharges ======
stock ViewCharges(playerid, name[])
{
	new
	    string[128];

	format(string, sizeof(string), "SELECT * FROM `warrants` WHERE `Suspect` = '%s' ORDER BY `ID` DESC", SQL_ReturnEscaped(name));
	mysql_tquery(g_iHandle, string, "OnViewCharges", "ds", playerid, name);
	return 1;
}

// ====== AddWarrant ======
stock AddWarrant(targetid, playerid, const description[])
{
	new
	    string[255];

	format(string, sizeof(string), "INSERT INTO `warrants` (`Suspect`, `Username`, `Date`, `Description`) VALUES('%s', '%s', '%s', '%s')", ReturnName(targetid), ReturnName(playerid), ReturnDate(), SQL_ReturnEscaped(description));
	mysql_tquery(g_iHandle, string);
}
