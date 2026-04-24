/*
    File: modules/player/logic/teleport.pwn
    Purpose: Contains player gameplay logic and helper functions for teleport.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== SendPlayerToPlayer ======
SendPlayerToPlayer(playerid, targetid)
{
	new
	    Float:x,
	    Float:y,
	    Float:z;

	GetPlayerPos(targetid, x, y, z);

	if (IsPlayerInAnyVehicle(playerid))
	{
	    SetVehiclePos(GetPlayerVehicleID(playerid), x, y + 2, z);
		LinkVehicleToInterior(GetPlayerVehicleID(playerid), GetPlayerInterior(targetid));
	}
	else
		SetPlayerPos(playerid, x + 1, y, z);

	SetPlayerInterior(playerid, GetPlayerInterior(targetid));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));

	PlayerData[playerid][pHouse] = PlayerData[targetid][pHouse];
	PlayerData[playerid][pBusiness] = PlayerData[targetid][pBusiness];
	PlayerData[playerid][pEntrance] = PlayerData[targetid][pEntrance];
	PlayerData[playerid][pHospitalInt]  = PlayerData[targetid][pHospitalInt];
}
