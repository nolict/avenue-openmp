/*
    File: modules/vehicle/logic/runtime.pwn
    Purpose: Contains vehicle gameplay logic and helper functions for runtime.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== FlipVehicle ======
stock FlipVehicle(vehicleid)
{
	new
	    Float:fAngle;

	GetVehicleZAngle(vehicleid, fAngle);

	SetVehicleZAngle(vehicleid, fAngle);
	SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
}

// ====== StopVehicleRadio ======
stock StopVehicleRadio(vehicleid)
{
	if ((IsValidVehicle(vehicleid) && IsEngineVehicle(vehicleid)) && CoreVehicles[vehicleid][vehRadio])
	{
	    CoreVehicles[vehicleid][vehRadio] = 0;

	    foreach (new i : Player)
		{
			if (IsPlayerInVehicle(i, vehicleid))
			{
			    StopAudioStreamForPlayer(i);
			    PlayerData[i][pPlayRadio] = 0;
			}
	    }
	}
	return 1;
}

// ====== SetVehicleRadio ======
stock SetVehicleRadio(vehicleid, url[])
{
	if (IsValidVehicle(vehicleid) && IsEngineVehicle(vehicleid))
	{
        CoreVehicles[vehicleid][vehRadio] = 1;
        strpack(CoreVehicles[vehicleid][vehURL], url, 128 char);

        foreach (new i : Player)
		{
			if (IsPlayerInVehicle(i, vehicleid))
			{
			    PlayerData[i][pPlayRadio] = 1;

			    StopAudioStreamForPlayer(i);
				PlayAudioStreamForPlayer(i, url);
            }
        }
	}
	return 1;
}

// ====== ResetVehicle ======
stock ResetVehicle(vehicleid)
{
	if (1 <= vehicleid <= MAX_VEHICLES)
	{
	    if (CoreVehicles[vehicleid][vehSirenOn] && IsValidDynamicObject(CoreVehicles[vehicleid][vehSirenObject]))
	        DestroyDynamicObject(CoreVehicles[vehicleid][vehSirenObject]);

	    CoreVehicles[vehicleid][vehFuel] = 100;
		CoreVehicles[vehicleid][vehWindowsDown] = false;
		CoreVehicles[vehicleid][vehTemporary] = 0;
  		CoreVehicles[vehicleid][vehLoads] = 0;
		CoreVehicles[vehicleid][vehLoadType] = 0;
		CoreVehicles[vehicleid][vehCrate] = INVALID_OBJECT_ID;
		CoreVehicles[vehicleid][vehTrash] = 0;
		CoreVehicles[vehicleid][vehRepairing] = 0;
		CoreVehicles[vehicleid][vehSirenOn] = 0;
		CoreVehicles[vehicleid][vehRadio] = 0;
	}
	return 1;
}

// ====== RespawnVehicle ======
stock RespawnVehicle(vehicleid)
{
	new id = Car_GetID(vehicleid);

	if (id != -1)
	    Car_Spawn(id);

	else SetVehicleToRespawn(vehicleid);

	ResetVehicle(vehicleid);
	return 1;
}
// ====== IsVehicleSeatUsed ======
stock IsVehicleSeatUsed(vehicleid, seat)
{
	foreach (new i : Player) if (IsPlayerInVehicle(i, vehicleid) && GetPlayerVehicleSeat(i) == seat) {
	    return 1;
	}
	return 0;
}

// ====== RemoveFromVehicle ======
stock RemoveFromVehicle(playerid)
{
	if (IsPlayerInAnyVehicle(playerid))
	{
		static
		    Float:fX,
	    	Float:fY,
	    	Float:fZ;

		GetPlayerPos(playerid, fX, fY, fZ);
		SetPlayerPos(playerid, fX, fY, fZ + 1.5);
	}
	return 1;
}

// ====== GetAvailableSeat ======
stock GetAvailableSeat(vehicleid, start = 1)
{
	new seats = GetVehicleMaxSeats(vehicleid);

	for (new i = start; i < seats; i ++) if (!IsVehicleSeatUsed(vehicleid, i)) {
	    return i;
	}
	return -1;
}

// ====== GetVehicleFromBehind ======
stock GetVehicleFromBehind(vehicleid)
{
	static
	    Float:fCoords[7];

	GetVehiclePos(vehicleid, fCoords[0], fCoords[1], fCoords[2]);
	GetVehicleZAngle(vehicleid, fCoords[3]);

	for (new i = 1; i != MAX_VEHICLES; i ++) if (i != vehicleid && GetVehiclePos(i, fCoords[4], fCoords[5], fCoords[6]))
	{
		if (floatabs(fCoords[0] - fCoords[4]) < 6 && floatabs(fCoords[1] - fCoords[5]) < 6 && floatabs(fCoords[2] - fCoords[6]) < 6)
			return i;
	}
	return INVALID_VEHICLE_ID;
}

// ====== GetVehicleBoot ======
stock GetVehicleBoot(vehicleid, &Float:x, &Float:y, &Float:z)
{
	if (!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
	    return (x = 0.0, y = 0.0, z = 0.0), 0;

	static
	    Float:pos[7]
	;
	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
	GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);
	GetVehicleZAngle(vehicleid, pos[6]);

	x = pos[3] - (floatsqroot(pos[1] + pos[1]) * floatsin(-pos[6], degrees));
	y = pos[4] - (floatsqroot(pos[1] + pos[1]) * floatcos(-pos[6], degrees));
 	z = pos[5];

	return 1;
}

// ====== GetVehicleHood ======
stock GetVehicleHood(vehicleid, &Float:x, &Float:y, &Float:z)
{
    if (!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
	    return (x = 0.0, y = 0.0, z = 0.0), 0;

	static
	    Float:pos[7]
	;
	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
	GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);
	GetVehicleZAngle(vehicleid, pos[6]);

	x = pos[3] + (floatsqroot(pos[1] + pos[1]) * floatsin(-pos[6], degrees));
	y = pos[4] + (floatsqroot(pos[1] + pos[1]) * floatcos(-pos[6], degrees));
 	z = pos[5];

	return 1;
}


// ====== DestroyForklifts ======
DestroyForklifts(entranceid)
{
	if (entranceid != -1 && EntranceData[entranceid][entranceExists])
	{
		for (new i = 0; i < 7; i ++) if (IsValidVehicle(EntranceData[entranceid][entranceForklift][i])) {
			DestroyVehicle(EntranceData[entranceid][entranceForklift][i]);

        	EntranceData[entranceid][entranceForklift][i] = INVALID_VEHICLE_ID;
        }
        return 1;
	}
	return 0;
}

// ====== CreateForklifts ======
CreateForklifts(entranceid)
{
    if (entranceid != -1 && EntranceData[entranceid][entranceExists])
	{
        EntranceData[entranceid][entranceForklift][0] = CreateVehicle(530,1300.6760,5.8440,1000.7919,180.2377,114,1,-1); // forklift 1
		EntranceData[entranceid][entranceForklift][1] = CreateVehicle(530,1303.4263,5.8919,1000.7883,181.4835,119,1,-1); // forklift 2
		EntranceData[entranceid][entranceForklift][2] = CreateVehicle(530,1305.7365,5.7953,1000.7904,179.7971,122,1,-1); // forklift 3
		EntranceData[entranceid][entranceForklift][3] = CreateVehicle(530,1308.2925,-8.6468,1000.7963,89.4510,4,1,-1); // forklift 4
		EntranceData[entranceid][entranceForklift][4] = CreateVehicle(530,1308.2974,-10.9627,1000.7974,91.8611,13,1,-1); // forklift 5
		EntranceData[entranceid][entranceForklift][5] = CreateVehicle(530,1308.3057,-13.6396,1000.7997,90.6285,110,1,-1); // forklift 6
		EntranceData[entranceid][entranceForklift][6] = CreateVehicle(530,1308.2751,-16.5108,1000.7980,90.2175,111,1,-1); // forklift 7

		for (new i = 0; i < 7; i ++) if (IsValidVehicle(EntranceData[entranceid][entranceForklift][i])) {
			SetVehicleVirtualWorld(EntranceData[entranceid][entranceForklift][i], EntranceData[entranceid][entranceWorld]);
			LinkVehicleToInterior(EntranceData[entranceid][entranceForklift][i], 18);

			CoreVehicles[EntranceData[entranceid][entranceForklift][i]][vehFuel] = 100;
			CoreVehicles[EntranceData[entranceid][entranceForklift][i]][vehLoadType] = 0;
		}
	}
	return 1;
}


Car_Nearest(playerid)
{
	static
	    Float:fX,
	    Float:fY,
	    Float:fZ;

	for (new i = 0; i != MAX_DYNAMIC_CARS; i ++) if (CarData[i][carExists]) {
		GetVehiclePos(CarData[i][carVehicle], fX, fY, fZ);

		if (IsPlayerInRangeOfPoint(playerid, 3.0, fX, fY, fZ)) {
		    return i;
		}
	}
	return -1;
}


ReturnVehicleHealth(vehicleid)
{
	if (!IsValidVehicle(vehicleid))
	    return 0;

	static
	    Float:amount;

	GetVehicleHealth(vehicleid, amount);
	return floatround(amount, floatround_round);
}


// ====== GetVehicleMaxSeats ======
stock GetVehicleMaxSeats(vehicleid)
{
    static const g_arrMaxSeats[] = {
		4, 2, 2, 2, 4, 4, 1, 2, 2, 4, 2, 2, 2, 4, 2, 2, 4, 2, 4, 2, 4, 4, 2, 2, 2, 1, 4, 4, 4, 2,
		1, 7, 1, 2, 2, 0, 2, 7, 4, 2, 4, 1, 2, 2, 2, 4, 1, 2, 1, 0, 0, 2, 1, 1, 1, 2, 2, 2, 4, 4,
		2, 2, 2, 2, 1, 1, 4, 4, 2, 2, 4, 2, 1, 1, 2, 2, 1, 2, 2, 4, 2, 1, 4, 3, 1, 1, 1, 4, 2, 2,
		4, 2, 4, 1, 2, 2, 2, 4, 4, 2, 2, 1, 2, 2, 2, 2, 2, 4, 2, 1, 1, 2, 1, 1, 2, 2, 4, 2, 2, 1,
		1, 2, 2, 2, 2, 2, 2, 2, 2, 4, 1, 1, 1, 2, 2, 2, 2, 7, 7, 1, 4, 2, 2, 2, 2, 2, 4, 4, 2, 2,
		4, 4, 2, 1, 2, 2, 2, 2, 2, 2, 4, 4, 2, 2, 1, 2, 4, 4, 1, 0, 0, 1, 1, 2, 1, 2, 2, 1, 2, 4,
		4, 2, 4, 1, 0, 4, 2, 2, 2, 2, 0, 0, 7, 2, 2, 1, 4, 4, 4, 2, 2, 2, 2, 2, 4, 2, 0, 0, 0, 4,
		0, 0
	};
	new
	    model = GetVehicleModel(vehicleid);

	if (400 <= model <= 611)
	    return g_arrMaxSeats[model - 400];

	return 0;
}

// ====== GetNearestVehicle ======
stock GetNearestVehicle(playerid)
{
	static
	    Float:fX,
	    Float:fY,
	    Float:fZ;

	for (new i = 1; i != MAX_VEHICLES; i ++) if (IsValidVehicle(i) && GetVehiclePos(i, fX, fY, fZ))
	{
	    if (IsPlayerInRangeOfPoint(playerid, 3.5, fX, fY, fZ)) return i;
	}
	return INVALID_VEHICLE_ID;
}



// ====== IsPlayerNearBoot ======
stock IsPlayerNearBoot(playerid, vehicleid)
{
	static
		Float:fX,
		Float:fY,
		Float:fZ;

	GetVehicleBoot(vehicleid, fX, fY, fZ);

	return (GetPlayerVirtualWorld(playerid) == GetVehicleVirtualWorld(vehicleid)) && IsPlayerInRangeOfPoint(playerid, 3.5, fX, fY, fZ);
}

// ====== IsPlayerNearHood ======
stock IsPlayerNearHood(playerid, vehicleid)
{
	static
		Float:fX,
		Float:fY,
		Float:fZ;

	GetVehicleHood(vehicleid, fX, fY, fZ);

	return (GetPlayerVirtualWorld(playerid) == GetVehicleVirtualWorld(vehicleid)) && IsPlayerInRangeOfPoint(playerid, 3.0, fX, fY, fZ);
}

