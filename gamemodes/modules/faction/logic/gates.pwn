/*
    File: modules/faction/logic/gates.pwn
    Purpose: Contains faction gameplay logic and helper functions for gates.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== CloseGate ======
forward CloseGate(gateid, linkid, Float:fX, Float:fY, Float:fZ, Float:speed, Float:fRotX, Float:fRotY, Float:fRotZ);

// ====== CloseGate ======
public CloseGate(gateid, linkid, Float:fX, Float:fY, Float:fZ, Float:speed, Float:fRotX, Float:fRotY, Float:fRotZ)
{
	new id = -1;

	if (GateData[gateid][gateExists] && GateData[gateid][gateOpened])
 	{
	 	MoveDynamicObject(GateData[gateid][gateObject], fX, fY, fZ, speed, fRotX, fRotY, fRotZ);

	 	if ((id = GetGateByID(linkid)) != -1)
            MoveDynamicObject(GateData[id][gateObject], GateData[id][gatePos][0], GateData[id][gatePos][1], GateData[id][gatePos][2], speed, GateData[id][gatePos][3], GateData[id][gatePos][4], GateData[id][gatePos][5]);

		GateData[id][gateOpened] = 0;
		return 1;
	}
	return 0;
}

// ====== Gate_Operate ======
stock Gate_Operate(gateid)
{
	if (gateid != -1 && GateData[gateid][gateExists])
	{
	    new id = -1;

		if (!GateData[gateid][gateOpened])
		{
		    GateData[gateid][gateOpened] = true;
		    MoveDynamicObject(GateData[gateid][gateObject], GateData[gateid][gateMove][0], GateData[gateid][gateMove][1], GateData[gateid][gateMove][2], GateData[gateid][gateSpeed], GateData[gateid][gateMove][3], GateData[gateid][gateMove][4], GateData[gateid][gateMove][5]);

            if (GateData[gateid][gateTime] > 0) {
				GateData[gateid][gateTimer] = SetTimerEx("CloseGate", GateData[gateid][gateTime], false, "ddfffffff", gateid, GateData[gateid][gateLinkID], GateData[gateid][gatePos][0], GateData[gateid][gatePos][1], GateData[gateid][gatePos][2], GateData[gateid][gateSpeed], GateData[gateid][gatePos][3], GateData[gateid][gatePos][4], GateData[gateid][gatePos][5]);
			}
			if (GateData[gateid][gateLinkID] != -1 && (id = GetGateByID(GateData[gateid][gateLinkID])) != -1)
			{
			    GateData[id][gateOpened] = true;
			    MoveDynamicObject(GateData[id][gateObject], GateData[id][gateMove][0], GateData[id][gateMove][1], GateData[id][gateMove][2], GateData[id][gateSpeed], GateData[id][gateMove][3], GateData[id][gateMove][4], GateData[id][gateMove][5]);
			}
		}
		else if (GateData[gateid][gateOpened])
		{
		    GateData[gateid][gateOpened] = false;
		    MoveDynamicObject(GateData[gateid][gateObject], GateData[gateid][gatePos][0], GateData[gateid][gatePos][1], GateData[gateid][gatePos][2], GateData[gateid][gateSpeed], GateData[gateid][gatePos][3], GateData[gateid][gatePos][4], GateData[gateid][gatePos][5]);

            if (GateData[gateid][gateTime] > 0) {
				KillTimer(GateData[gateid][gateTimer]);
		    }
			if (GateData[gateid][gateLinkID] != -1 && (id = GetGateByID(GateData[gateid][gateLinkID])) != -1)
			{
			    GateData[id][gateOpened] = false;
			    MoveDynamicObject(GateData[id][gateObject], GateData[id][gatePos][0], GateData[id][gatePos][1], GateData[id][gatePos][2], GateData[id][gateSpeed], GateData[id][gatePos][3], GateData[id][gatePos][4], GateData[id][gatePos][5]);
			}
		}
	}
	return 1;
}

// ====== Gate_Create ======
stock Gate_Create(playerid)
{
	new
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:angle;

	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i < MAX_GATES; i ++) if (!GateData[i][gateExists])
		{
		    GateData[i][gateExists] = true;
			GateData[i][gateModel] = 980;
			GateData[i][gateSpeed] = 3.0;
			GateData[i][gateRadius] = 5.0;
			GateData[i][gateOpened] = 0;
			GateData[i][gateTime] = 0;

			GateData[i][gatePos][0] = x + (3.0 * floatsin(-angle, degrees));
			GateData[i][gatePos][1] = y + (3.0 * floatcos(-angle, degrees));
			GateData[i][gatePos][2] = z;
			GateData[i][gatePos][3] = 0.0;
			GateData[i][gatePos][4] = 0.0;
			GateData[i][gatePos][5] = angle;

			GateData[i][gateMove][0] = x + (3.0 * floatsin(-angle, degrees));
			GateData[i][gateMove][1] = y + (3.0 * floatcos(-angle, degrees));
			GateData[i][gateMove][2] = z - 10.0;
			GateData[i][gateMove][3] = -1000.0;
			GateData[i][gateMove][4] = -1000.0;
			GateData[i][gateMove][5] = -1000.0;

            GateData[i][gateInterior] = GetPlayerInterior(playerid);
            GateData[i][gateWorld] = GetPlayerVirtualWorld(playerid);

            GateData[i][gateLinkID] = -1;
            GateData[i][gateFaction] = -1;

            GateData[i][gatePass][0] = '\0';
            GateData[i][gateObject] = CreateDynamicObject(GateData[i][gateModel], GateData[i][gatePos][0], GateData[i][gatePos][1], GateData[i][gatePos][2], GateData[i][gatePos][3], GateData[i][gatePos][4], GateData[i][gatePos][5], GateData[i][gateWorld], GateData[i][gateInterior]);

			mysql_tquery(g_iHandle, "INSERT INTO `gates` (`gateModel`) VALUES(980)", "OnGateCreated", "d", i);
			return i;
		}
	}
	return -1;
}

// ====== Gate_Delete ======
stock Gate_Delete(gateid)
{
	if (gateid != -1 && GateData[gateid][gateExists])
	{
		new
		    query[64];

		format(query, sizeof(query), "DELETE FROM `gates` WHERE `gateID` = '%d'", GateData[gateid][gateID]);
		mysql_tquery(g_iHandle, query);

		if (IsValidDynamicObject(GateData[gateid][gateObject]))
		    DestroyDynamicObject(GateData[gateid][gateObject]);

		for (new i = 0; i != MAX_GATES; i ++) if (GateData[i][gateExists] && GateData[i][gateLinkID] == GateData[gateid][gateID]) {
		    GateData[i][gateLinkID] = -1;
		    Gate_Save(i);
		}
		if (GateData[gateid][gateOpened] && GateData[gateid][gateTime] > 0) {
		    KillTimer(GateData[gateid][gateTimer]);
		}
	    GateData[gateid][gateExists] = false;
	    GateData[gateid][gateID] = 0;
	    GateData[gateid][gateOpened] = 0;
	}
	return 1;
}

// ====== Gate_Save ======
stock Gate_Save(gateid)
{
	new
	    query[768];

	format(query, sizeof(query), "UPDATE `gates` SET `gateModel` = '%d', `gateSpeed` = '%.4f', `gateRadius` = '%.4f', `gateTime` = '%d', `gateX` = '%.4f', `gateY` = '%.4f', `gateZ` = '%.4f', `gateRX` = '%.4f', `gateRY` = '%.4f', `gateRZ` = '%.4f', `gateInterior` = '%d', `gateWorld` = '%d', `gateMoveX` = '%.4f', `gateMoveY` = '%.4f', `gateMoveZ` = '%.4f', `gateMoveRX` = '%.4f', `gateMoveRY` = '%.4f', `gateMoveRZ` = '%.4f', `gateLinkID` = '%d', `gateFaction` = '%d', `gatePass` = '%s' WHERE `gateID` = '%d'",
	    GateData[gateid][gateModel],
	    GateData[gateid][gateSpeed],
	    GateData[gateid][gateRadius],
	    GateData[gateid][gateTime],
	    GateData[gateid][gatePos][0],
	    GateData[gateid][gatePos][1],
	    GateData[gateid][gatePos][2],
	    GateData[gateid][gatePos][3],
	    GateData[gateid][gatePos][4],
	    GateData[gateid][gatePos][5],
	    GateData[gateid][gateInterior],
	    GateData[gateid][gateWorld],
	    GateData[gateid][gateMove][0],
	    GateData[gateid][gateMove][1],
	    GateData[gateid][gateMove][2],
	    GateData[gateid][gateMove][3],
	    GateData[gateid][gateMove][4],
	    GateData[gateid][gateMove][5],
	    GateData[gateid][gateLinkID],
	    GateData[gateid][gateFaction],
	    SQL_ReturnEscaped(GateData[gateid][gatePass]),
	    GateData[gateid][gateID]
	);
	return mysql_tquery(g_iHandle, query);
}
// ====== Gate_Load ======
forward Gate_Load();

// ====== Gate_Load ======
public Gate_Load()
{
    static
	    rows,
	    fields;

	cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i < rows; i ++) if (i < MAX_GATES)
	{
	    GateData[i][gateExists] = true;
	    GateData[i][gateOpened] = false;

	    GateData[i][gateID] = cache_get_field_int(i, "gateID");
	    GateData[i][gateModel] = cache_get_field_int(i, "gateModel");
	    GateData[i][gateSpeed] = cache_get_field_float(i, "gateSpeed");
	    GateData[i][gateRadius] = cache_get_field_float(i, "gateRadius");
	    GateData[i][gateTime] = cache_get_field_int(i, "gateTime");
	    GateData[i][gateInterior] = cache_get_field_int(i, "gateInterior");
	    GateData[i][gateWorld] = cache_get_field_int(i, "gateWorld");

	    GateData[i][gatePos][0] = cache_get_field_float(i, "gateX");
	    GateData[i][gatePos][1] = cache_get_field_float(i, "gateY");
	    GateData[i][gatePos][2] = cache_get_field_float(i, "gateZ");
	    GateData[i][gatePos][3] = cache_get_field_float(i, "gateRX");
	    GateData[i][gatePos][4] = cache_get_field_float(i, "gateRY");
	    GateData[i][gatePos][5] = cache_get_field_float(i, "gateRZ");

        GateData[i][gateMove][0] = cache_get_field_float(i, "gateMoveX");
	    GateData[i][gateMove][1] = cache_get_field_float(i, "gateMoveY");
	    GateData[i][gateMove][2] = cache_get_field_float(i, "gateMoveZ");
	    GateData[i][gateMove][3] = cache_get_field_float(i, "gateMoveRX");
	    GateData[i][gateMove][4] = cache_get_field_float(i, "gateMoveRY");
	    GateData[i][gateMove][5] = cache_get_field_float(i, "gateMoveRZ");

        GateData[i][gateLinkID] = cache_get_field_int(i, "gateLinkID");
	    GateData[i][gateFaction] = cache_get_field_int(i, "gateFaction");

	    cache_get_field_content(i, "gatePass", GateData[i][gatePass], g_iHandle, 32);

	    GateData[i][gateObject] = CreateDynamicObject(GateData[i][gateModel], GateData[i][gatePos][0], GateData[i][gatePos][1], GateData[i][gatePos][2], GateData[i][gatePos][3], GateData[i][gatePos][4], GateData[i][gatePos][5], GateData[i][gateWorld], GateData[i][gateInterior]);
	}
	return 1;
}


// ====== Gate_Nearest ======
Gate_Nearest(playerid)
{
    for (new i = 0; i != MAX_GATES; i ++) if (GateData[i][gateExists] && IsPlayerInRangeOfPoint(playerid, GateData[i][gateRadius], GateData[i][gatePos][0], GateData[i][gatePos][1], GateData[i][gatePos][2]))
	{
		if (GetPlayerInterior(playerid) == GateData[i][gateInterior] && GetPlayerVirtualWorld(playerid) == GateData[i][gateWorld])
			return i;
	}
	return -1;
}
