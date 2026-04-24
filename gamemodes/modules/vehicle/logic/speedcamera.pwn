/*
    File: modules/vehicle/logic/speedcamera.pwn
    Purpose: Contains vehicle gameplay logic and helper functions for speedcamera.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== Speed_Refresh ======
stock Speed_Refresh(speedid)
{
	if (speedid != -1 && SpeedData[speedid][speedExists])
	{
	    new
	        string[64];

		if (IsValidDynamicObject(SpeedData[speedid][speedObject]))
		    DestroyDynamicObject(SpeedData[speedid][speedObject]);

		if (IsValidDynamic3DTextLabel(SpeedData[speedid][speedText3D]))
		    DestroyDynamic3DTextLabel(SpeedData[speedid][speedText3D]);

		format(string, sizeof(string), "[Camera %d]\n{FFFFFF}Speed Limit: %.0f mph", speedid, SpeedData[speedid][speedLimit]);

		SpeedData[speedid][speedText3D] = CreateDynamic3DTextLabel(string, COLOR_DARKBLUE, SpeedData[speedid][speedPos][0], SpeedData[speedid][speedPos][1], SpeedData[speedid][speedPos][2] + 2.5, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0);
        SpeedData[speedid][speedObject] = CreateDynamicObject(18880, SpeedData[speedid][speedPos][0], SpeedData[speedid][speedPos][1], SpeedData[speedid][speedPos][2], 0.0, 0.0, SpeedData[speedid][speedPos][3]);
	}
	return 1;
}

// ====== Speed_Save ======
stock Speed_Save(speedid)
{
	new
	    query[255];

	format(query, sizeof(query), "UPDATE `speedcameras` SET `speedRange` = '%.4f', `speedLimit` = '%.4f', `speedX` = '%.4f', `speedY` = '%.4f', `speedZ` = '%.4f', `speedAngle` = '%.4f' WHERE `speedID` = '%d'",
	    SpeedData[speedid][speedRange],
	    SpeedData[speedid][speedLimit],
	    SpeedData[speedid][speedPos][0],
	    SpeedData[speedid][speedPos][1],
	    SpeedData[speedid][speedPos][2],
	    SpeedData[speedid][speedPos][3],
	    SpeedData[speedid][speedID]
	);
	return mysql_tquery(g_iHandle, query);
}

// ====== Speed_Nearest ======
stock Speed_Nearest(playerid)
{
	for (new i = 0; i < MAX_SPEED_CAMERAS; i ++) if (SpeedData[i][speedExists] && IsPlayerInRangeOfPoint(playerid, SpeedData[i][speedRange], SpeedData[i][speedPos][0], SpeedData[i][speedPos][1], SpeedData[i][speedPos][2]))
	    return i;

	return -1;
}

// ====== Speed_Delete ======
stock Speed_Delete(speedid)
{
    if (speedid != -1 && SpeedData[speedid][speedExists])
	{
	    new
	        string[64];

		if (IsValidDynamicObject(SpeedData[speedid][speedObject]))
		    DestroyDynamicObject(SpeedData[speedid][speedObject]);

		if (IsValidDynamic3DTextLabel(SpeedData[speedid][speedText3D]))
		    DestroyDynamic3DTextLabel(SpeedData[speedid][speedText3D]);

		format(string, sizeof(string), "DELETE FROM `speedcameras` WHERE `speedID` = '%d'", SpeedData[speedid][speedID]);
		mysql_tquery(g_iHandle, string);

		SpeedData[speedid][speedExists] = false;
		SpeedData[speedid][speedLimit] = 0.0;
		SpeedData[speedid][speedRange] = 0.0;
		SpeedData[speedid][speedID] = 0;
	}
	return 1;
}

// ====== Speed_Create ======
stock Speed_Create(playerid, Float:limit, Float:range)
{
	new
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:angle;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);

	for (new i = 0; i < MAX_SPEED_CAMERAS; i ++) if (!SpeedData[i][speedExists])
	{
	    SpeedData[i][speedExists] = true;
	    SpeedData[i][speedRange] = range;
        SpeedData[i][speedLimit] = limit;

		SpeedData[i][speedPos][0] = x + (1.5 * floatsin(-angle, degrees));
	    SpeedData[i][speedPos][1] = y + (1.5 * floatcos(-angle, degrees));
	    SpeedData[i][speedPos][2] = z - 1.2;
	    SpeedData[i][speedPos][3] = angle;

	    Speed_Refresh(i);
	    mysql_tquery(g_iHandle, "INSERT INTO `speedcameras` (`speedRange`) VALUES(0.0)", "OnSpeedCreated", "d", i);
	    return i;
	}
	return -1;
}
forward Speed_Load();

// ====== Speed_Load ======
public Speed_Load()
{
	static
	    rows,
	    fields;

	cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i < rows; i ++) if (i < MAX_SPEED_CAMERAS)
	{
	    SpeedData[i][speedExists] = true;
	    SpeedData[i][speedID] = cache_get_field_int(i, "speedID");
	    SpeedData[i][speedRange] = cache_get_field_float(i, "speedRange");
	    SpeedData[i][speedLimit] = cache_get_field_float(i, "speedLimit");
	    SpeedData[i][speedPos][0] = cache_get_field_float(i, "speedX");
	    SpeedData[i][speedPos][1] = cache_get_field_float(i, "speedY");
	    SpeedData[i][speedPos][2] = cache_get_field_float(i, "speedZ");
	    SpeedData[i][speedPos][3] = cache_get_field_float(i, "speedAngle");

	    Speed_Refresh(i);
	}
	return 1;
}

