/*
    File: modules/faction/logic/arrest.pwn
    Purpose: Contains faction gameplay logic and helper functions for arrest.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== Arrest_Delete ======
Arrest_Delete(arrestid)
{
	if (arrestid != -1 && ArrestData[arrestid][arrestExists])
	{
	    static
	        string[64];

        if (IsValidDynamicPickup(ArrestData[arrestid][arrestPickup]))
		    DestroyDynamicPickup(ArrestData[arrestid][arrestPickup]);

		if (IsValidDynamic3DTextLabel(ArrestData[arrestid][arrestText3D]))
		    DestroyDynamic3DTextLabel(ArrestData[arrestid][arrestText3D]);

		format(string, sizeof(string), "DELETE FROM `arrestpoints` WHERE `arrestID` = '%d'", ArrestData[arrestid][arrestID]);
		mysql_tquery(g_iHandle, string);

		ArrestData[arrestid][arrestExists] = false;
		ArrestData[arrestid][arrestID] = 0;
	}
	return 1;
}

// ====== Arrest_Create ======
Arrest_Create(Float:x, Float:y, Float:z, interior, world)
{
	for (new i = 0; i < MAX_ARREST_POINTS; i ++) if (!ArrestData[i][arrestExists])
	{
	    ArrestData[i][arrestExists] = true;
	    ArrestData[i][arrestPos][0] = x;
	    ArrestData[i][arrestPos][1] = y;
	    ArrestData[i][arrestPos][2] = z;
	    ArrestData[i][arrestInterior] = interior;
	    ArrestData[i][arrestWorld] = world;

	    mysql_tquery(g_iHandle, "INSERT INTO `arrestpoints` (`arrestInterior`) VALUES(0)", "OnArrestCreated", "d", i);
		Arrest_Refresh(i);
		return i;
	}
	return -1;
}

// ====== Arrest_Save ======
Arrest_Save(arrestid)
{
	static
	    query[220];

	format(query, sizeof(query), "UPDATE `arrestpoints` SET `arrestX` = '%.4f', `arrestY` = '%.4f', `arrestZ` = '%.4f', `arrestInterior` = '%d', `arrestWorld` = '%d' WHERE `arrestID` = '%d'",
	    ArrestData[arrestid][arrestPos][0],
	    ArrestData[arrestid][arrestPos][1],
	    ArrestData[arrestid][arrestPos][2],
	    ArrestData[arrestid][arrestInterior],
	    ArrestData[arrestid][arrestWorld],
	    ArrestData[arrestid][arrestID]
	);
	return mysql_tquery(g_iHandle, query);
}

// ====== Arrest_Refresh ======
Arrest_Refresh(arrestid)
{
	if (arrestid != -1 && ArrestData[arrestid][arrestExists])
	{
	    static
	        string[64];

		if (IsValidDynamicPickup(ArrestData[arrestid][arrestPickup]))
		    DestroyDynamicPickup(ArrestData[arrestid][arrestPickup]);

		if (IsValidDynamic3DTextLabel(ArrestData[arrestid][arrestText3D]))
		    DestroyDynamic3DTextLabel(ArrestData[arrestid][arrestText3D]);

		format(string, sizeof(string), "[Arrest %d]\n{FFFFFF}/arrest to arrest the suspect.", arrestid);

		ArrestData[arrestid][arrestPickup] = CreateDynamicPickup(1247, 23, ArrestData[arrestid][arrestPos][0], ArrestData[arrestid][arrestPos][1], ArrestData[arrestid][arrestPos][2], ArrestData[arrestid][arrestWorld], ArrestData[arrestid][arrestInterior]);
  		ArrestData[arrestid][arrestText3D] = CreateDynamic3DTextLabel(string, COLOR_DARKBLUE, ArrestData[arrestid][arrestPos][0], ArrestData[arrestid][arrestPos][1], ArrestData[arrestid][arrestPos][2], 10.0, INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 0, ArrestData[arrestid][arrestWorld], ArrestData[arrestid][arrestInterior]);
	}
	return 1;
}

// ====== Arrest_Load ======
forward Arrest_Load();

// ====== Arrest_Load ======
public Arrest_Load()
{
	static
	    rows,
	    fields;

	cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i < rows; i ++) if (i < MAX_ARREST_POINTS)
	{
	    ArrestData[i][arrestExists] = true;

	    ArrestData[i][arrestID] = cache_get_field_int(i, "arrestID");
	    ArrestData[i][arrestPos][0] = cache_get_field_float(i, "arrestX");
	    ArrestData[i][arrestPos][1] = cache_get_field_float(i, "arrestY");
	    ArrestData[i][arrestPos][2] = cache_get_field_float(i, "arrestZ");
	    ArrestData[i][arrestInterior] = cache_get_field_int(i, "arrestInterior");
	    ArrestData[i][arrestWorld] = cache_get_field_int(i, "arrestWorld");

	    Arrest_Refresh(i);
	}
	return 1;
}


// ====== Arrest_Nearest ======
Arrest_Nearest(playerid)
{
    for (new i = 0; i != MAX_ARREST_POINTS; i ++) if (ArrestData[i][arrestExists] && IsPlayerInRangeOfPoint(playerid, 4.0, ArrestData[i][arrestPos][0], ArrestData[i][arrestPos][1], ArrestData[i][arrestPos][2]))
	{
		if (GetPlayerInterior(playerid) == ArrestData[i][arrestInterior] && GetPlayerVirtualWorld(playerid) == ArrestData[i][arrestWorld])
			return i;
	}
	return -1;
}

// ====== IsPlayerNearArrest ======
IsPlayerNearArrest(playerid)
{
	new
	    id = Arrest_Nearest(playerid);

	return (id != -1);
}
