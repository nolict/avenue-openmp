/*
    File: modules/system/logic/garbage.pwn
    Purpose: Contains system gameplay logic and helper functions for garbage.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== Garbage_Create ======
stock Garbage_Create(playerid, type)
{
	for (new i = 0; i != MAX_GARBAGE_BINS; i ++) if (!GarbageData[i][garbageExists])
	{
	    switch (type) {
	        case 1: GarbageData[i][garbageModel] = 1236;
	        case 2: GarbageData[i][garbageModel] = 1300;
	    }
	    GarbageData[i][garbageExists] = true;
	    GarbageData[i][garbageCapacity] = 0;

	    GetPlayerPos(playerid, GarbageData[i][garbagePos][0], GarbageData[i][garbagePos][1], GarbageData[i][garbagePos][2]);
	    GetPlayerFacingAngle(playerid, GarbageData[i][garbagePos][3]);

		switch (type) {
		    case 1: {
		    	GarbageData[i][garbagePos][0] = GarbageData[i][garbagePos][0] + (1.8 * floatsin(-GarbageData[i][garbagePos][3], degrees));
			    GarbageData[i][garbagePos][1] = GarbageData[i][garbagePos][1] + (1.8 * floatcos(-GarbageData[i][garbagePos][3], degrees));
			}
			case 2: {
		    	GarbageData[i][garbagePos][0] = GarbageData[i][garbagePos][0] + (1.0 * floatsin(-GarbageData[i][garbagePos][3], degrees));
			    GarbageData[i][garbagePos][1] = GarbageData[i][garbagePos][1] + (1.0 * floatcos(-GarbageData[i][garbagePos][3], degrees));
			}
		}
		GarbageData[i][garbageInterior] = GetPlayerInterior(playerid);
		GarbageData[i][garbageWorld] = GetPlayerVirtualWorld(playerid);

		Garbage_Refresh(i);
		mysql_tquery(g_iHandle, "INSERT INTO `garbage` (`garbageCapacity`) VALUES(0)", "OnGarbageCreated", "d", i);
		return i;
	}
	return -1;
}

// ====== Garbage_Delete ======
stock Garbage_Delete(garbageid)
{
	if (garbageid != -1 && GarbageData[garbageid][garbageExists])
	{
	    new
	        string[64];

		format(string, sizeof(string), "DELETE FROM `garbage` WHERE `garbageID` = '%d'", GarbageData[garbageid][garbageID]);
		mysql_tquery(g_iHandle, string);

        if (IsValidDynamic3DTextLabel(GarbageData[garbageid][garbageText3D]))
	        DestroyDynamic3DTextLabel(GarbageData[garbageid][garbageText3D]);

		if (IsValidDynamicObject(GarbageData[garbageid][garbageObject]))
		    DestroyDynamicObject(GarbageData[garbageid][garbageObject]);

	    GarbageData[garbageid][garbageExists] = false;
	    GarbageData[garbageid][garbageCapacity] = 0;
	    GarbageData[garbageid][garbageID] = 0;
	}
	return 1;
}

// ====== Garbage_Nearest ======
Garbage_Nearest(playerid)
{
    for (new i = 0; i != MAX_GARBAGE_BINS; i ++) if (GarbageData[i][garbageExists] && IsPlayerInRangeOfPoint(playerid, 3.0, GarbageData[i][garbagePos][0], GarbageData[i][garbagePos][1], GarbageData[i][garbagePos][2]))
	{
		if (GetPlayerInterior(playerid) == GarbageData[i][garbageInterior] && GetPlayerVirtualWorld(playerid) == GarbageData[i][garbageWorld])
			return i;
	}
	return -1;
}

// ====== Garbage_Refresh ======
stock Garbage_Refresh(garbageid)
{
	if (garbageid != -1 && GarbageData[garbageid][garbageExists])
	{
	    if (IsValidDynamic3DTextLabel(GarbageData[garbageid][garbageText3D]))
	        DestroyDynamic3DTextLabel(GarbageData[garbageid][garbageText3D]);

		if (IsValidDynamicObject(GarbageData[garbageid][garbageObject]))
		    DestroyDynamicObject(GarbageData[garbageid][garbageObject]);

		new
			string[64];

		format(string, sizeof(string), "[Garbage %d]\n{FFFFFF}Trash Capacity: %d/20", garbageid, GarbageData[garbageid][garbageCapacity]);

		GarbageData[garbageid][garbageText3D] = CreateDynamic3DTextLabel(string, COLOR_DARKBLUE, GarbageData[garbageid][garbagePos][0], GarbageData[garbageid][garbagePos][1], GarbageData[garbageid][garbagePos][2], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, GarbageData[garbageid][garbageWorld], GarbageData[garbageid][garbageInterior]);
		GarbageData[garbageid][garbageObject] = CreateDynamicObject(GarbageData[garbageid][garbageModel], GarbageData[garbageid][garbagePos][0], GarbageData[garbageid][garbagePos][1], (GarbageData[garbageid][garbageModel] == 1236) ? (GarbageData[garbageid][garbagePos][2] - 0.4) : (GarbageData[garbageid][garbagePos][2] - 0.6), 0.0, 0.0, GarbageData[garbageid][garbagePos][3], GarbageData[garbageid][garbageWorld], GarbageData[garbageid][garbageInterior]);
	}
	return 1;
}

// ====== Garbage_Save ======
stock Garbage_Save(garbageid)
{
	new
	    query[300];

	format(query, sizeof(query), "UPDATE `garbage` SET `garbageModel` = '%d', `garbageCapacity` = '%d', `garbageX` = '%.4f', `garbageY` = '%.4f', `garbageZ` = '%.4f', `garbageA` = '%.4f', `garbageInterior` = '%d', `garbageWorld` = '%d' WHERE `garbageID` = '%d'",
        GarbageData[garbageid][garbageModel],
        GarbageData[garbageid][garbageCapacity],
        GarbageData[garbageid][garbagePos][0],
        GarbageData[garbageid][garbagePos][1],
        GarbageData[garbageid][garbagePos][2],
        GarbageData[garbageid][garbagePos][3],
        GarbageData[garbageid][garbageInterior],
        GarbageData[garbageid][garbageWorld],
        GarbageData[garbageid][garbageID]
	);
	return mysql_tquery(g_iHandle, query);
}

// ====== GetClosestGarbage ======
GetClosestGarbage(playerid)
{
	new
	    Float:fDistance[2] = {99999.0, 0.0},
	    iIndex = -1
	;
	for (new i = 0; i < MAX_GARBAGE_BINS; i ++) if (GarbageData[i][garbageExists] && GarbageData[i][garbageCapacity] > 0 && GetPlayerInterior(playerid) == GarbageData[i][garbageInterior] && GetPlayerVirtualWorld(playerid) == GarbageData[i][garbageWorld])
	{
		fDistance[1] = GetPlayerDistanceFromPoint(playerid, GarbageData[i][garbagePos][0], GarbageData[i][garbagePos][1], GarbageData[i][garbagePos][2]);

		if (fDistance[1] < fDistance[0])
		{
		    fDistance[0] = fDistance[1];
		    iIndex = i;
		}
	}
	return iIndex;
}
forward Garbage_Load();

// ====== Garbage_Load ======
public Garbage_Load()
{
    static
	    rows,
	    fields;

	cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i < rows; i ++) if (i < MAX_GARBAGE_BINS)
	{
	    GarbageData[i][garbageExists] = true;
	    GarbageData[i][garbageID] = cache_get_field_int(i, "garbageID");
	    GarbageData[i][garbageModel] = cache_get_field_int(i, "garbageModel");
	    GarbageData[i][garbageCapacity] = cache_get_field_int(i, "garbageCapacity");
	    GarbageData[i][garbagePos][0] = cache_get_field_float(i, "garbageX");
        GarbageData[i][garbagePos][1] = cache_get_field_float(i, "garbageY");
        GarbageData[i][garbagePos][2] = cache_get_field_float(i, "garbageZ");
        GarbageData[i][garbagePos][3] = cache_get_field_float(i, "garbageA");
        GarbageData[i][garbageInterior] = cache_get_field_int(i, "garbageInterior");
		GarbageData[i][garbageWorld] = cache_get_field_int(i, "garbageWorld");

		Garbage_Refresh(i);
	}
	return 1;
}

