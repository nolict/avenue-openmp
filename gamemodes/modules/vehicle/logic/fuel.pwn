/*
    File: modules/vehicle/logic/fuel.pwn
    Purpose: Contains vehicle gameplay logic and helper functions for fuel.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== RefillUpdate ======
forward RefillUpdate(playerid, vehicleid);

// ====== RefillUpdate ======
public RefillUpdate(playerid, vehicleid)
{
	if (!PlayerData[playerid][pFuelCan] || GetNearestVehicle(playerid) != vehicleid)
	    return 0;

	CoreVehicles[vehicleid][vehFuel] = (CoreVehicles[vehicleid][vehFuel] + 15 >= 100) ? (100) : (CoreVehicles[vehicleid][vehFuel] + 15);

	PlayerData[playerid][pFuelCan] = 0;
	SendServerMessage(playerid, "You have filled up your vehicle with a can of fuel.");
	return 1;
}

// ====== IsPumpOccupied ======
stock IsPumpOccupied(pumpid)
{
	foreach (new i : Player) if (PlayerData[i][pRefill] != INVALID_VEHICLE_ID) {
	    if (PlayerData[i][pGasPump] == pumpid) return 1;
	}
	return 0;
}

// ====== StopRefilling ======
StopRefilling(playerid)
{
    PlayerData[playerid][pGasPump] = -1;
    PlayerData[playerid][pGasStation] = -1;
   	PlayerData[playerid][pRefill] = INVALID_VEHICLE_ID;
	PlayerData[playerid][pRefillPrice] = 0;
}

// ====== Pump_Nearest ======
Pump_Nearest(playerid)
{
    for (new i = 0; i != MAX_GAS_PUMPS; i ++) if (PumpData[i][pumpExists] && IsPlayerInRangeOfPoint(playerid, 4.0, PumpData[i][pumpPos][0], PumpData[i][pumpPos][1], PumpData[i][pumpPos][2]) && PumpData[i][pumpExists]) {
	    return i;
	}
	return -1;
}

// ====== Pump_Load ======
forward Pump_Load(bizid);

// ====== Pump_Load ======
public Pump_Load(bizid)
{
	static
	    rows,
	    fields,
		id = -1;

	cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i < rows; i ++) if ((id = Pump_GetFreeID()) != -1)
	{
	    PumpData[id][pumpExists] = true;
	    PumpData[id][pumpBusiness] = bizid;
	    PumpData[id][pumpID] = cache_get_field_int(i, "pumpID");
	    PumpData[id][pumpPos][0] = cache_get_field_float(i, "pumpPosX");
	    PumpData[id][pumpPos][1] = cache_get_field_float(i, "pumpPosY");
	    PumpData[id][pumpPos][2] = cache_get_field_float(i, "pumpPosZ");
	    PumpData[id][pumpPos][3] = cache_get_field_float(i, "pumpPosA");
	    PumpData[id][pumpFuel] = cache_get_field_int(i, "pumpFuel");

	    PumpData[id][pumpObject] = CreateDynamicObject(1676, PumpData[id][pumpPos][0], PumpData[id][pumpPos][1], PumpData[id][pumpPos][2], 0.0, 0.0, PumpData[id][pumpPos][3]);
	    Pump_Refresh(id);
	}
	return 1;
}

// ====== Pump_GetFreeID ======
Pump_GetFreeID()
{
	for (new i = 0; i < MAX_GAS_PUMPS; i ++) if (!PumpData[i][pumpExists]) {
	    return i;
	}
	return -1;
}

// ====== Pump_Delete ======
Pump_Delete(pumpid)
{
	if (pumpid != -1 && PumpData[pumpid][pumpExists])
	{
	    new
	        string[90];

		format(string, sizeof(string), "DELETE FROM `pumps` WHERE `ID` = '%d' AND `pumpID` = '%d'", BusinessData[PumpData[pumpid][pumpBusiness]][bizID], PumpData[pumpid][pumpID]);
		mysql_tquery(g_iHandle, string);

        if (IsValidDynamic3DTextLabel(PumpData[pumpid][pumpText3D]))
		    DestroyDynamic3DTextLabel(PumpData[pumpid][pumpText3D]);

		if (IsValidDynamicObject(PumpData[pumpid][pumpObject]))
		    DestroyDynamicObject(PumpData[pumpid][pumpObject]);

		foreach (new i : Player) if (PlayerData[i][pGasPump] == pumpid) {
		    StopRefilling(i);
		}
	    PumpData[pumpid][pumpExists] = false;
	    PumpData[pumpid][pumpFuel] = 0;
	}
	return 1;
}

// ====== Pump_Create ======
Pump_Create(playerid, bizid)
{
    static
	    Float:x,
	    Float:y,
	    Float:z,
		Float:angle,
		string[64],
		id = -1;

	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		if ((id = Pump_GetFreeID()) != -1)
  		{
	        x += 5.0 * floatsin(-angle, degrees);
	        y += 5.0 * floatcos(-angle, degrees);

			PumpData[id][pumpExists] = true;
			PumpData[id][pumpBusiness] = bizid;
			PumpData[id][pumpPos][0] = x;
			PumpData[id][pumpPos][1] = y;
			PumpData[id][pumpPos][2] = z;
			PumpData[id][pumpPos][3] = angle;
            PumpData[id][pumpFuel] = 2000;
			PumpData[id][pumpObject] = CreateDynamicObject(1676, x, y, z, 0.0, 0.0, angle);

			format(string, sizeof(string), "INSERT INTO `pumps` (`ID`) VALUES(%d)", BusinessData[bizid][bizID]);
			mysql_tquery(g_iHandle, string, "OnPumpCreated", "d", id);
			return id;
		}
	}
	return -1;
}

// ====== Pump_Refresh ======
Pump_Refresh(pumpid)
{
	if (pumpid != -1 && PumpData[pumpid][pumpExists])
	{
	    static
	        string[128];

		format(string, sizeof(string), "[Gas Pump: %d]\n{FFFFFF}Fuel Left: %d liters", pumpid, PumpData[pumpid][pumpFuel]);

        if (IsValidDynamic3DTextLabel(PumpData[pumpid][pumpText3D]))
            DestroyDynamic3DTextLabel(PumpData[pumpid][pumpText3D]);

		if (IsValidDynamicObject(PumpData[pumpid][pumpObject]))
		    DestroyDynamicObject(PumpData[pumpid][pumpObject]);

		PumpData[pumpid][pumpText3D] = CreateDynamic3DTextLabel(string, COLOR_DARKBLUE, PumpData[pumpid][pumpPos][0], PumpData[pumpid][pumpPos][1], PumpData[pumpid][pumpPos][2], 15.0);
        PumpData[pumpid][pumpObject] = CreateDynamicObject(1676, PumpData[pumpid][pumpPos][0], PumpData[pumpid][pumpPos][1], PumpData[pumpid][pumpPos][2], 0.0, 0.0, PumpData[pumpid][pumpPos][3]);
	}
	return 1;
}

// ====== Pump_Save ======
Pump_Save(pumpid)
{
	static
	    query[256];

	format(query, sizeof(query), "UPDATE `pumps` SET `pumpPosX` = '%.4f', `pumpPosY` = '%.4f', `pumpPosZ` = '%.4f', `pumpPosA` = '%.4f', `pumpFuel` = '%d' WHERE `ID` = '%d' AND `pumpID` = '%d'",
	    PumpData[pumpid][pumpPos][0],
	    PumpData[pumpid][pumpPos][1],
	    PumpData[pumpid][pumpPos][2],
		PumpData[pumpid][pumpPos][3],
	    PumpData[pumpid][pumpFuel],
	    BusinessData[PumpData[pumpid][pumpBusiness]][bizID],
	    PumpData[pumpid][pumpID]
	);
	return mysql_tquery(g_iHandle, query);
}
