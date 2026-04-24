/*
    File: modules/job/logic/mechanic.pwn
    Purpose: Contains job gameplay logic and helper functions for mechanic.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

forward RepairCar(playerid, vehicleid);

// ====== RepairCar ======
public RepairCar(playerid, vehicleid)
{
	if (PlayerData[playerid][pJob] != JOB_MECHANIC || !IsPlayerNearHood(playerid, vehicleid)) {
		return 0;
	}
	SetVehicleHealth(vehicleid, 1000.0);
	GameTextForPlayer(playerid, " ", 1, 3);

	PlayerData[playerid][pRepairTime] = gettime() + 60;
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has successfully repaired the vehicle.", ReturnName(playerid, 0));

	return 1;
}

