/*
    File: modules/player/logic/tasks.pwn
    Purpose: Contains player gameplay logic and helper functions for tasks.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== IsTaskCompleted ======
stock IsTaskCompleted(playerid)
{
	if ((PlayerData[playerid][pTask] > 0) && (PlayerData[playerid][pBankTask] > 0 && PlayerData[playerid][pStoreTask] > 0 && PlayerData[playerid][pTestTask] > 0))
	    return 1;

	return 0;
}

// ====== IsTaskActive ======
stock IsTaskActive(playerid)
{
	if ((PlayerData[playerid][pTask] > 0) && (!PlayerData[playerid][pBankTask] || !PlayerData[playerid][pStoreTask] || !PlayerData[playerid][pTestTask]))
	    return 1;

	return 0;
}
