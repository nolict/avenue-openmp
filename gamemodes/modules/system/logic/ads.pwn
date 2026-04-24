/*
    File: modules/system/logic/ads.pwn
    Purpose: Contains system gameplay logic and helper functions for ads.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== Advertise ======
forward Advertise(playerid);

// ====== Advertise ======
public Advertise(playerid)
{
	if (!SQL_IsLogged(playerid) || !strlen(PlayerData[playerid][pAdvertise]))
	    return 0;

	new
	    text[128];

	strunpack(text, PlayerData[playerid][pAdvertise]);

	foreach (new i : Player) if (!PlayerData[i][pDisableBC]) {
	    SendClientMessageEx(i, 0x00AA00FF, "Newspaper: %s (contact: %d)", text, PlayerData[playerid][pPhone]);
	}
	PlayerData[playerid][pAdvertise][0] = 0;
	return 1;
}
