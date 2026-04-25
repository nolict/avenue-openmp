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

// ====== Player_TeleportToMapMarker ======
stock Player_TeleportToMapMarker(playerid, Float:x, Float:y, Float:z)
{
	new
	    vehicleid,
	    Float:angle;

	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);

	PlayerData[playerid][pHouse] = -1;
	PlayerData[playerid][pBusiness] = -1;
	PlayerData[playerid][pEntrance] = -1;
	PlayerData[playerid][pHospitalInt] = -1;

	if (IsPlayerInAnyVehicle(playerid))
	{
	    vehicleid = GetPlayerVehicleID(playerid);

	    GetVehicleZAngle(vehicleid, angle);
	    SetVehiclePos(vehicleid, x, y, z + 3.0);
	    SetVehicleZAngle(vehicleid, angle);
	    LinkVehicleToInterior(vehicleid, 0);
	    SetVehicleVirtualWorld(vehicleid, 0);
	}
	else
	{
	    SetPlayerPos(playerid, x, y, z + 3.0);
	}

	SetCameraBehindPlayer(playerid);
	SendServerMessage(playerid, "Teleported to map marker.");
	return 1;
}
