/*
    File: modules/player/logic/movement.pwn
    Purpose: Contains player gameplay logic and helper functions for movement.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== SetPlayerToFacePlayer ======
stock SetPlayerToFacePlayer(playerid, targetid)
{
	new
	    Float:x[2],
	    Float:y[2],
	    Float:z[2],
	    Float:angle;

	GetPlayerPos(targetid, x[0], y[0], z[0]);
	GetPlayerPos(playerid, x[1], y[1], z[1]);

	angle = (180.0 - atan2(x[1] - x[0], y[1] - y[0]));
	SetPlayerFacingAngle(playerid, angle + (5.0 * -1));
}

// ====== SetPlayerPosEx ======
stock SetPlayerPosEx(playerid, Float:x, Float:y, Float:z, time = 2000)
{
	if (PlayerData[playerid][pFreeze])
	{
	    KillTimer(PlayerData[playerid][pFreezeTimer]);

	    PlayerData[playerid][pFreeze] = 0;
	    TogglePlayerControllable(playerid, 1);
	}
	SetPlayerPos(playerid, x, y, z + 0.5);
	TogglePlayerControllable(playerid, 0);

	PlayerData[playerid][pFreeze] = 1;
	PlayerData[playerid][pFreezeTimer] = SetTimerEx("SetPlayerToUnfreeze", time, false, "dfff", playerid, x, y, z);
	return 1;
}

forward SetPlayerToUnfreeze(playerid, Float:x, Float:y, Float:z);

// ====== SetPlayerToUnfreeze ======
public SetPlayerToUnfreeze(playerid, Float:x, Float:y, Float:z)
{
	if (!IsPlayerInRangeOfPoint(playerid, 15.0, x, y, z))
	    return 0;

	PlayerData[playerid][pFreeze] = 0;

	SetPlayerPos(playerid, x, y, z);
	TogglePlayerControllable(playerid, 1);
	return 1;
}

// ====== PlayerPlaySoundEx ======
stock PlayerPlaySoundEx(playerid, sound)
{
	new
	    Float:x,
	    Float:y,
	    Float:z;

	GetPlayerPos(playerid, x, y, z);

	foreach (new i : Player) if (IsPlayerInRangeOfPoint(i, 20.0, x, y, z)) {
	    PlayerPlaySound(i, sound, x, y, z);
	}
	return 1;
}

// ====== GetNearestPlayerInView ======
stock GetNearestPlayerInView(playerid, Float:distance = 2.0)
{
	new
	    Float:fAngle,
		Float:fPosX,
		Float:fPosY,
		Float:fPosZ;

	GetPlayerFacingAngle(playerid, fAngle);
	GetPlayerPos(playerid, fPosX, fPosY, fPosZ);

	fPosX += distance * floatsin(-fAngle, degrees);
	fPosY += distance * floatcos(-fAngle, degrees);

	foreach (new i : Player) if (IsPlayerInRangeOfPoint(i, 2.0, fPosX, fPosY, fPosZ)) {
	    return i;
	}
	return INVALID_PLAYER_ID;
}
