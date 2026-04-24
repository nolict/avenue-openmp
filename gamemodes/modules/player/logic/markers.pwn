/*
    File: modules/player/logic/markers.pwn
    Purpose: Contains player gameplay logic and helper functions for markers.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== ExpireMarker ======
forward ExpireMarker(playerid);

// ====== ExpireMarker ======
public ExpireMarker(playerid)
{
	if (!PlayerData[playerid][pMarker])
	    return 0;

    if (GetFactionType(playerid) == FACTION_GANG || (GetFactionType(playerid) != FACTION_GANG && PlayerData[playerid][pOnDuty]))
		SetFactionColor(playerid);

	else SetPlayerColor(playerid, DEFAULT_COLOR);
	return 1;
}

// ====== DisableWaypoint ======
stock DisableWaypoint(playerid)
{
    if (PlayerData[playerid][pWaypoint])
	{
 		PlayerData[playerid][pWaypoint] = 0;

 		DisablePlayerCheckpoint(playerid);
  		PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][69]);
	}
	return 1;
}
