/*
    File: modules/job/logic/mining.pwn
    Purpose: Contains job gameplay logic and helper functions for mining.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== MineTime ======
forward MineTime(playerid);

// ====== MineTime ======
public MineTime(playerid)
{
	PlayerData[playerid][pMineTime] = 0;
}
