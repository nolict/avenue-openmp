/*
    File: modules/interface/logic/flashing.pwn
    Purpose: Contains interface gameplay logic and helper functions for flashing.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== FlashTextDraw ======
stock FlashTextDraw(playerid, PlayerText:textid, delay = 500)
{
	PlayerTextDrawHide(playerid, textid);

	SetTimerEx("FlashShowTextDraw", delay, false, "dd", playerid, _:textid);

	return 1;
}

// ====== FlashTextDrawEx ======
stock FlashTextDrawEx(playerid, PlayerText:textid, amount = 1)
{
	PlayerTextDrawHide(playerid, textid);

	SetTimerEx("FlashShowTextDrawEx", 500, false, "ddd", playerid, _:textid, amount);

	return 1;
}

forward FlashShowTextDrawEx(playerid, PlayerText:textid, amount);

// ====== FlashShowTextDrawEx ======
public FlashShowTextDrawEx(playerid, PlayerText:textid, amount)
{
    if ((IsPlayerConnected(playerid) && PlayerData[playerid][pLogged] && PlayerData[playerid][pCharacter] != 0 && PlayerData[playerid][pHospital] == -1) && IsPlayerSpawned(playerid)) {
	    PlayerTextDrawShow(playerid, textid);

	    if (amount > 0) return SetTimerEx("HideTextDrawEx", 500, false, "ddd", playerid, _:textid, amount);
	}
	return 1;
}

forward HideTextDrawEx(playerid, PlayerText:textid, amount);

// ====== HideTextDrawEx ======
public HideTextDrawEx(playerid, PlayerText:textid, amount)
{
    if ((IsPlayerConnected(playerid) && PlayerData[playerid][pLogged] && PlayerData[playerid][pCharacter] != 0 && PlayerData[playerid][pHospital] == -1) && IsPlayerSpawned(playerid)) {
	    PlayerTextDrawHide(playerid, textid);

	    if (amount > 0) return SetTimerEx("FlashShowTextDrawEx", 500, false, "ddd", playerid, _:textid, --amount);
	}
	return 1;
}

forward FlashShowTextDraw(playerid, PlayerText:textid);

// ====== FlashShowTextDraw ======
public FlashShowTextDraw(playerid, PlayerText:textid)
{
	if ((IsPlayerConnected(playerid) && PlayerData[playerid][pLogged] && PlayerData[playerid][pCharacter] != 0 && PlayerData[playerid][pHospital] == -1) && IsPlayerSpawned(playerid)) {
	    PlayerTextDrawShow(playerid, textid);
	}
	return 1;
}

