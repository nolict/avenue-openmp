/*
    File: modules/system/logic/atms.pwn
    Purpose: Contains system gameplay logic and helper functions for atms.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== ATM_Delete ======
stock ATM_Delete(atmid)
{
	if (atmid != -1 && ATMData[atmid][atmExists])
	{
	    new
	        string[64];

		format(string, sizeof(string), "DELETE FROM `atm` WHERE `atmID` = '%d'", ATMData[atmid][atmID]);
		mysql_tquery(g_iHandle, string);

        if (IsValidDynamicObject(ATMData[atmid][atmObject]))
	        DestroyDynamicObject(ATMData[atmid][atmObject]);

	    if (IsValidDynamic3DTextLabel(ATMData[atmid][atmText3D]))
	        DestroyDynamic3DTextLabel(ATMData[atmid][atmText3D]);

	    ATMData[atmid][atmExists] = false;
	    ATMData[atmid][atmID] = 0;
	}
	return 1;
}

// ====== ATM_Nearest ======
ATM_Nearest(playerid)
{
    for (new i = 0; i != MAX_ATM_MACHINES; i ++) if (ATMData[i][atmExists] && IsPlayerInRangeOfPoint(playerid, 2.5, ATMData[i][atmPos][0], ATMData[i][atmPos][1], ATMData[i][atmPos][2]))
	{
		if (GetPlayerInterior(playerid) == ATMData[i][atmInterior] && GetPlayerVirtualWorld(playerid) == ATMData[i][atmWorld])
			return i;
	}
	return -1;
}

// ====== ATM_Create ======
stock ATM_Create(playerid)
{
    new
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:angle;

	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i < MAX_ATM_MACHINES; i ++) if (!ATMData[i][atmExists])
		{
		    ATMData[i][atmExists] = true;

		    x += 1.0 * floatsin(-angle, degrees);
			y += 1.0 * floatcos(-angle, degrees);

            ATMData[i][atmPos][0] = x;
            ATMData[i][atmPos][1] = y;
            ATMData[i][atmPos][2] = z;
            ATMData[i][atmPos][3] = angle;

            ATMData[i][atmInterior] = GetPlayerInterior(playerid);
            ATMData[i][atmWorld] = GetPlayerVirtualWorld(playerid);

			ATM_Refresh(i);
			mysql_tquery(g_iHandle, "INSERT INTO `atm` (`atmInterior`) VALUES(0)", "OnATMCreated", "d", i);

			return i;
		}
	}
	return -1;
}

// ====== ATM_Refresh ======
stock ATM_Refresh(atmid)
{
	if (atmid != -1 && ATMData[atmid][atmExists])
	{
	    if (IsValidDynamicObject(ATMData[atmid][atmObject]))
	        DestroyDynamicObject(ATMData[atmid][atmObject]);

	    if (IsValidDynamic3DTextLabel(ATMData[atmid][atmText3D]))
	        DestroyDynamic3DTextLabel(ATMData[atmid][atmText3D]);

		new
	        string[64];

		format(string, sizeof(string), "[ATM %d]\n{FFFFFF}/atm to use this machine.", atmid);

		ATMData[atmid][atmObject] = CreateDynamicObject(2942, ATMData[atmid][atmPos][0], ATMData[atmid][atmPos][1], ATMData[atmid][atmPos][2] - 0.4, 0.0, 0.0, ATMData[atmid][atmPos][3], ATMData[atmid][atmWorld], ATMData[atmid][atmInterior]);
        ATMData[atmid][atmText3D] = CreateDynamic3DTextLabel(string, COLOR_DARKBLUE, ATMData[atmid][atmPos][0], ATMData[atmid][atmPos][1], ATMData[atmid][atmPos][2], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, ATMData[atmid][atmWorld], ATMData[atmid][atmInterior]);

		return 1;
	}
	return 0;
}

// ====== ATM_Save ======
stock ATM_Save(atmid)
{
	new
	    query[200];

	format(query, sizeof(query), "UPDATE `atm` SET `atmX` = '%.4f', `atmY` = '%.4f', `atmZ` = '%.4f', `atmA` = '%.4f', `atmInterior` = '%d', `atmWorld` = '%d' WHERE `atmID` = '%d'",
	    ATMData[atmid][atmPos][0],
	    ATMData[atmid][atmPos][1],
	    ATMData[atmid][atmPos][2],
	    ATMData[atmid][atmPos][3],
	    ATMData[atmid][atmInterior],
	    ATMData[atmid][atmWorld],
	    ATMData[atmid][atmID]
	);
	return mysql_tquery(g_iHandle, query);
}
forward ATM_Load();

// ====== ATM_Load ======
public ATM_Load()
{
    static
	    rows,
	    fields;

	cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i < rows; i ++) if (i < MAX_ATM_MACHINES)
	{
	    ATMData[i][atmExists] = true;
	    ATMData[i][atmID] = cache_get_field_int(i, "atmID");
	    ATMData[i][atmPos][0] = cache_get_field_float(i, "atmX");
        ATMData[i][atmPos][1] = cache_get_field_float(i, "atmY");
        ATMData[i][atmPos][2] = cache_get_field_float(i, "atmZ");
        ATMData[i][atmPos][3] = cache_get_field_float(i, "atmA");
        ATMData[i][atmInterior] = cache_get_field_int(i, "atmInterior");
		ATMData[i][atmWorld] = cache_get_field_int(i, "atmWorld");

		ATM_Refresh(i);
	}
	return 1;
}

