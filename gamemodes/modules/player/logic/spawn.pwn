/*
    File: modules/player/logic/spawn.pwn
    Purpose: Contains player gameplay logic and helper functions for spawn.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== SpawnTimer ======
forward SpawnTimer(playerid);

// ====== SpawnTimer ======
public SpawnTimer(playerid)
{
	if (SQL_IsLogged(playerid))
	{
	    TogglePlayerControllable(playerid, 1);
	}
	return 1;
}


