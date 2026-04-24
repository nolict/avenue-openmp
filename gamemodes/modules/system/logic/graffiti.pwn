/*
    File: modules/system/logic/graffiti.pwn
    Purpose: Contains system gameplay logic and helper functions for graffiti.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== Graffiti_Refresh ======
stock Graffiti_Refresh(id)
{
	if (id != -1 && GraffitiData[id][graffitiExists])
	{
		if (IsValidDynamicMapIcon(GraffitiData[id][graffitiIcon]))
		    DestroyDynamicMapIcon(GraffitiData[id][graffitiIcon]);

		if (IsValidDynamicObject(GraffitiData[id][graffitiObject]))
			DestroyDynamicObject(GraffitiData[id][graffitiObject]);

        GraffitiData[id][graffitiIcon] = CreateDynamicMapIcon(GraffitiData[id][graffitiPos][0], GraffitiData[id][graffitiPos][1], GraffitiData[id][graffitiPos][2], 23, 0, -1, -1, -1, 100.0, MAPICON_GLOBAL);
		GraffitiData[id][graffitiObject] = CreateDynamicObject(19482, GraffitiData[id][graffitiPos][0], GraffitiData[id][graffitiPos][1], GraffitiData[id][graffitiPos][2], 0.0, 0.0, GraffitiData[id][graffitiPos][3]);

		SetDynamicObjectMaterial(GraffitiData[id][graffitiObject], 0, 0, "none", "none", 0);
		SetDynamicObjectMaterialText(GraffitiData[id][graffitiObject], 0, GraffitiData[id][graffitiText], OBJECT_MATERIAL_SIZE_256x128, "Arial", 24, 1, GraffitiData[id][graffitiColor], 0, 0);
	}
	return 1;
}

// ====== IsSprayingInProgress ======
stock IsSprayingInProgress(id)
{
	foreach (new i : Player)
	{
	    if (PlayerData[i][pGraffiti] == id && IsPlayerInRangeOfPoint(i, 5.0, GraffitiData[id][graffitiPos][0], GraffitiData[id][graffitiPos][1], GraffitiData[id][graffitiPos][2]))
	        return 1;
	}
	return 0;
}

// ====== Graffiti_Nearest ======
stock Graffiti_Nearest(playerid)
{
	for (new i = 0; i < MAX_GRAFFITI_POINTS; i ++) if (GraffitiData[i][graffitiExists] && IsPlayerInRangeOfPoint(playerid, 5.0, GraffitiData[i][graffitiPos][0], GraffitiData[i][graffitiPos][1], GraffitiData[i][graffitiPos][2]))
	    return i;

	return -1;
}

// ====== Graffiti_Delete ======
stock Graffiti_Delete(id)
{
    if (id != -1 && GraffitiData[id][graffitiExists])
	{
	    new
	        string[64];

		if (IsValidDynamicMapIcon(GraffitiData[id][graffitiIcon]))
		    DestroyDynamicMapIcon(GraffitiData[id][graffitiIcon]);

		if (IsValidDynamicObject(GraffitiData[id][graffitiObject]))
			DestroyDynamicObject(GraffitiData[id][graffitiObject]);

		format(string, sizeof(string), "DELETE FROM `graffiti` WHERE `graffitiID` = '%d'", GraffitiData[id][graffitiID]);
		mysql_tquery(g_iHandle, string);

		GraffitiData[id][graffitiExists] = false;
		GraffitiData[id][graffitiText][0] = 0;
		GraffitiData[id][graffitiID] = 0;
	}
	return 1;
}

// ====== Graffiti_Save ======
stock Graffiti_Save(id)
{
	new
	    query[384];

	format(query, sizeof(query), "UPDATE `graffiti` SET `graffitiX` = '%.4f', `graffitiY` = '%.4f', `graffitiZ` = '%.4f', `graffitiAngle` = '%.4f', `graffitiColor` = '%d', `graffitiText` = '%s' WHERE `graffitiID` = '%d'",
        GraffitiData[id][graffitiPos][0],
        GraffitiData[id][graffitiPos][1],
        GraffitiData[id][graffitiPos][2],
        GraffitiData[id][graffitiPos][3],
		GraffitiData[id][graffitiColor],
		SQL_ReturnEscaped(GraffitiData[id][graffitiText]),
		GraffitiData[id][graffitiID]
	);
	return mysql_tquery(g_iHandle, query);
}

// ====== Graffiti_Create ======
stock Graffiti_Create(Float:x, Float:y, Float:z, Float:angle)
{
	for (new i = 0; i < MAX_GRAFFITI_POINTS; i ++)
	{
	    if (!GraffitiData[i][graffitiExists])
	    {
			GraffitiData[i][graffitiExists] = 1;
			GraffitiData[i][graffitiPos][0] = x;
			GraffitiData[i][graffitiPos][1] = y;
			GraffitiData[i][graffitiPos][2] = z;
			GraffitiData[i][graffitiPos][3] = angle - 90.0;
			GraffitiData[i][graffitiColor] = 0xFFFFFFFF;

			format(GraffitiData[i][graffitiText], 32, "Graffiti");

			Graffiti_Refresh(i);
			mysql_tquery(g_iHandle, "INSERT INTO `graffiti` (`graffitiColor`) VALUES(0)", "OnGraffitiCreated", "d", i);

			return i;
		}
	}
	return -1;
}
forward Graffiti_Load();

// ====== Graffiti_Load ======
public Graffiti_Load()
{
	static
	    rows,
	    fields;

	cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i < rows; i ++) if (i < MAX_GRAFFITI_POINTS)
	{
	    cache_get_field_content(i, "graffitiText", GraffitiData[i][graffitiText], g_iHandle, 64);

    	GraffitiData[i][graffitiExists] = 1;
	    GraffitiData[i][graffitiID] = cache_get_field_int(i, "graffitiID");
	    GraffitiData[i][graffitiPos][0] = cache_get_field_float(i, "graffitiX");
	    GraffitiData[i][graffitiPos][1] = cache_get_field_float(i, "graffitiY");
	    GraffitiData[i][graffitiPos][2] = cache_get_field_float(i, "graffitiZ");
	    GraffitiData[i][graffitiPos][3] = cache_get_field_float(i, "graffitiAngle");
	    GraffitiData[i][graffitiColor] = cache_get_field_int(i, "graffitiColor");

		Graffiti_Refresh(i);
	}
	return 1;
}

