/*
    File: modules/vehicle/logic/impound.pwn
    Purpose: Contains vehicle gameplay logic and helper functions for impound.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== IsVehicleImpounded ======
stock IsVehicleImpounded(vehicleid)
{
    new id = Car_GetID(vehicleid);

	if (id != -1 && CarData[id][carImpounded] != -1 && CarData[id][carImpoundPrice] > 0)
	    return 1;

	return 0;
}

// ====== Impound_Delete ======
stock Impound_Delete(impoundid)
{
    if (impoundid != -1 && ImpoundData[impoundid][impoundExists])
	{
	    new
	        query[64];

		format(query, sizeof(query), "DELETE FROM `impoundlots` WHERE `impoundID` = '%d'", ImpoundData[impoundid][impoundID]);
		mysql_tquery(g_iHandle, query);

        if (IsValidDynamic3DTextLabel(ImpoundData[impoundid][impoundText3D]))
		    DestroyDynamic3DTextLabel(ImpoundData[impoundid][impoundText3D]);

	    if (IsValidDynamicPickup(ImpoundData[impoundid][impoundPickup]))
		    DestroyDynamicPickup(ImpoundData[impoundid][impoundPickup]);

		for (new i = 0; i < MAX_DYNAMIC_CARS; i ++) if (CarData[i][carExists] && CarData[i][carImpounded] == ImpoundData[impoundid][impoundID]) {
		    CarData[i][carImpounded] = 0;
		    CarData[i][carImpoundPrice] = 0;
		    Car_Save(i);
		}
        ImpoundData[impoundid][impoundExists] = false;
        ImpoundData[impoundid][impoundID] = 0;
	}
	return 1;
}

// ====== GetImpoundByID ======
stock GetImpoundByID(sqlid)
{
	for (new i = 0; i < MAX_IMPOUND_LOTS; i ++) if (ImpoundData[i][impoundExists] && ImpoundData[i][impoundID] == sqlid) {
	    return i;
	}
	return -1;
}

// ====== Impound_Nearest ======
stock Impound_Nearest(playerid)
{
	for (new i = 0; i < MAX_IMPOUND_LOTS; i ++) if (ImpoundData[i][impoundExists] && IsPlayerInRangeOfPoint(playerid, 20.0, ImpoundData[i][impoundLot][0], ImpoundData[i][impoundLot][1], ImpoundData[i][impoundLot][2])) {
	    return i;
	}
	return -1;
}

// ====== Impound_Create ======
stock Impound_Create(Float:x, Float:y, Float:z)
{
	for (new i = 0; i != MAX_IMPOUND_LOTS; i ++) if (!ImpoundData[i][impoundExists])
	{
	    ImpoundData[i][impoundExists] = true;
	    ImpoundData[i][impoundLot][0] = x;
	    ImpoundData[i][impoundLot][1] = y;
	    ImpoundData[i][impoundLot][2] = z;
	    ImpoundData[i][impoundRelease][0] = 0.0;
	    ImpoundData[i][impoundRelease][1] = 0.0;
	    ImpoundData[i][impoundRelease][2] = 0.0;

		mysql_tquery(g_iHandle, "INSERT INTO `impoundlots` (`impoundLotX`) VALUES('0.0')", "OnImpoundCreated", "d", i);
		Impound_Refresh(i);

		return i;
	}
	return -1;
}

// ====== Impound_Refresh ======
stock Impound_Refresh(impoundid)
{
	if (impoundid != -1 && ImpoundData[impoundid][impoundExists])
	{
	    new
	        string[64];

		if (IsValidDynamic3DTextLabel(ImpoundData[impoundid][impoundText3D]))
		    DestroyDynamic3DTextLabel(ImpoundData[impoundid][impoundText3D]);

	    if (IsValidDynamicPickup(ImpoundData[impoundid][impoundPickup]))
		    DestroyDynamicPickup(ImpoundData[impoundid][impoundPickup]);

		format(string, sizeof(string), "[Impound %d]\n{FFFFFF}/impound to impound a vehicle.", impoundid);
        ImpoundData[impoundid][impoundText3D] = CreateDynamic3DTextLabel(string, COLOR_DARKBLUE, ImpoundData[impoundid][impoundLot][0], ImpoundData[impoundid][impoundLot][1], ImpoundData[impoundid][impoundLot][2], 20.0);
        ImpoundData[impoundid][impoundPickup] = CreateDynamicPickup(1239, 23, ImpoundData[impoundid][impoundLot][0], ImpoundData[impoundid][impoundLot][1], ImpoundData[impoundid][impoundLot][2]);
	}
	return 1;
}

// ====== Impound_Save ======
stock Impound_Save(impoundid)
{
	new
		query[300];

	format(query, sizeof(query), "UPDATE `impoundlots` SET `impoundLotX` = '%.4f', `impoundLotY` = '%.4f', `impoundLotZ` = '%.4f', `impoundReleaseX` = '%.4f', `impoundReleaseY` = '%.4f', `impoundReleaseZ` = '%.4f', `impoundReleaseA` = '%.4f' WHERE `impoundID` = '%d'",
        ImpoundData[impoundid][impoundLot][0],
        ImpoundData[impoundid][impoundLot][1],
        ImpoundData[impoundid][impoundLot][2],
        ImpoundData[impoundid][impoundRelease][0],
        ImpoundData[impoundid][impoundRelease][1],
        ImpoundData[impoundid][impoundRelease][2],
        ImpoundData[impoundid][impoundRelease][3],
        ImpoundData[impoundid][impoundID]
	);
	return mysql_tquery(g_iHandle, query);
}
forward Impound_Load();

// ====== Impound_Load ======
public Impound_Load()
{
	static
	    rows,
	    fields;

	cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i < rows; i ++) if (i < MAX_IMPOUND_LOTS)
	{
	    ImpoundData[i][impoundExists] = true;
	    ImpoundData[i][impoundID] = cache_get_field_int(i, "impoundID");
	    ImpoundData[i][impoundLot][0] = cache_get_field_float(i, "impoundLotX");
        ImpoundData[i][impoundLot][1] = cache_get_field_float(i, "impoundLotY");
        ImpoundData[i][impoundLot][2] = cache_get_field_float(i, "impoundLotZ");
        ImpoundData[i][impoundRelease][0] = cache_get_field_float(i, "impoundReleaseX");
        ImpoundData[i][impoundRelease][1] = cache_get_field_float(i, "impoundReleaseY");
        ImpoundData[i][impoundRelease][2] = cache_get_field_float(i, "impoundReleaseZ");
        ImpoundData[i][impoundRelease][3] = cache_get_field_float(i, "impoundReleaseA");

		Impound_Refresh(i);
	}
	return 1;
}

