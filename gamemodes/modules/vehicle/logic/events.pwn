/*
    File: modules/vehicle/logic/events.pwn
    Purpose: Contains vehicle gameplay logic and helper functions for events.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== OnVehicleDeath ======
public OnVehicleDeath(vehicleid)
{
	if (CoreVehicles[vehicleid][vehTemporary])
	{
	    CoreVehicles[vehicleid][vehTemporary] = false;
	    DestroyVehicle(vehicleid);
	}
	for (new i = 0; i != MAX_CRATES; i ++) if (CrateData[i][crateExists] && CrateData[i][crateVehicle] == vehicleid) {
	    Crate_Delete(i);
	}
	return 1;
}

// ====== OnVehicleRespray ======
public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	SetVehicleColor(vehicleid, color1, color2);
	return 1;
}

// ====== OnVehiclePaintjob ======
public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	SetVehiclePaintjob(vehicleid, paintjobid);
	return 1;
}

// ====== OnVehicleMod ======
public OnVehicleMod(playerid, vehicleid, componentid)
{
	new
		id = Car_GetID(vehicleid),
		slot = GetVehicleComponentType(componentid);

	if (id != -1)
	{
	    CarData[id][carMods][slot] = componentid;
	    Car_Save(id);
	}
	return 1;
}

// ====== OnVehicleSpawn ======
public OnVehicleSpawn(vehicleid)
{
	vehiclecallsign[vehicleid] = 0;
    if (CoreVehicles[vehicleid][vehTemporary])
	{
	    CoreVehicles[vehicleid][vehTemporary] = false;
	    DestroyVehicle(vehicleid);
	}
    for (new i = 0; i != MAX_CRATES; i ++) if (CrateData[i][crateExists] && CrateData[i][crateVehicle] == vehicleid) {
	    Crate_Delete(i);
	}
	if (IsValidObject(CoreVehicles[vehicleid][vehCrate]) && GetVehicleModel(vehicleid) == 530)
	    DestroyObject(CoreVehicles[vehicleid][vehCrate]);

	ResetVehicle(vehicleid);
	return 1;
}

// ====== OnRconLoginAttempt ======
public OnRconLoginAttempt(ip[], password[], success)
{
	if (!success)
	{
	    foreach (new i : Player) if (!strcmp(PlayerData[i][pIP], ip, true) && PlayerData[i][pAdmin] < 6) {
	        Kick(i);
	    }
	    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: RCON login attempt failed from \"%s\".", ip);
	    Log_Write("logs/rcon_log.txt", "[%s] RCON login attempt failed from \"%s\".", ReturnDate(), ip);
	}
	else
	{
	    foreach (new i : Player) if (!strcmp(PlayerData[i][pIP], ip, true) && PlayerData[i][pAdmin] < 6) {
	        Blacklist_Add(ip, PlayerData[i][pUsername], "Server", "Unauthorized RCON");

	        SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s was banned for logging into RCON without authorization.", ReturnName(i, 0));
	    	Log_Write("logs/rcon_log.txt", "[%s] %s (%s) was banned for an unauthorized RCON login.", ReturnDate(), ReturnName(i, 0), ip);

			break;
		}
	}
	return 1;
}

