/*
    File: modules/system/logic/racks.pwn
    Purpose: Contains system gameplay logic and helper functions for racks.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

Rack_Save(rackid)
{
	static
	    query[512];

	format(query, sizeof(query), "UPDATE `gunracks` SET `rackHouse` = '%d', `rackX` = '%.4f', `rackY` = '%.4f', `rackZ` = '%.4f', `rackA` = '%.4f', `rackInterior` = '%d', `rackWorld` = '%d', `rackWeapon1` = '%d', `rackWeapon2` = '%d', `rackWeapon3` = '%d', `rackWeapon4` = '%d', `rackAmmo1` = '%d', `rackAmmo2` = '%d', `rackAmmo3` = '%d', `rackAmmo4` = '%d' WHERE `rackID` = '%d'",
	    RackData[rackid][rackHouse],
	    RackData[rackid][rackPos][0],
	    RackData[rackid][rackPos][1],
	    RackData[rackid][rackPos][2],
	    RackData[rackid][rackPos][3],
	    RackData[rackid][rackInterior],
	    RackData[rackid][rackWorld],
	    RackData[rackid][rackWeapons][0],
	    RackData[rackid][rackWeapons][1],
	    RackData[rackid][rackWeapons][2],
	    RackData[rackid][rackWeapons][3],
	    RackData[rackid][rackAmmo][0],
	    RackData[rackid][rackAmmo][1],
	    RackData[rackid][rackAmmo][2],
	    RackData[rackid][rackAmmo][3],
	    RackData[rackid][rackID]
	);
	return mysql_tquery(g_iHandle, query);
}

Rack_Nearest(playerid)
{
	for (new i = 0; i != MAX_WEAPON_RACKS; i ++) if (RackData[i][rackExists] && IsPlayerInRangeOfPoint(playerid, 3.0, RackData[i][rackPos][0], RackData[i][rackPos][1], RackData[i][rackPos][2]))
	{
		if (GetPlayerInterior(playerid) == RackData[i][rackInterior] && GetPlayerVirtualWorld(playerid) == RackData[i][rackWorld])
		    return i;
	}
	return -1;
}

Rack_Count(houseid)
{
	new count;

	for (new i = 0; i != MAX_WEAPON_RACKS; i ++) if (RackData[i][rackExists] && RackData[i][rackHouse] == HouseData[houseid][houseID]) {
	    count++;
	}
	return count;
}

Rack_ShowGuns(playerid, rackid)
{
	if (rackid != -1 && RackData[rackid][rackExists])
	{
	    new
	        string[128];

		for (new i = 0; i < 4; i ++)
		{
		    if (!RackData[rackid][rackWeapons][i])
		        format(string, sizeof(string), "%s%d: Empty Slot\n", string, i + 1);

			else format(string, sizeof(string), "%s%d: %s - %d bullets\n", string, i + 1, ReturnWeaponName(RackData[rackid][rackWeapons][i]), RackData[rackid][rackAmmo][i]);
		}
		Dialog_Show(playerid, RackWeapons, DIALOG_STYLE_LIST, DialogStyle_Title("Weapon Rack"), string, "Select", "Cancel");
	}
	return 1;
}

Rack_Delete(rackid)
{
    if (rackid != -1 && RackData[rackid][rackExists])
	{
	    static
	        string[64];

	    format(string, sizeof(string), "DELETE FROM `gunracks` WHERE `rackID` = '%d'", RackData[rackid][rackID]);
	    mysql_tquery(g_iHandle, string);

        for (new i = 0; i < 5; i ++) if (IsValidDynamicObject(RackData[rackid][rackObjects][i])) {
			DestroyDynamicObject(RackData[rackid][rackObjects][i]);
		}
		if (IsValidDynamic3DTextLabel(RackData[rackid][rackText3D])) {
		    DestroyDynamic3DTextLabel(RackData[rackid][rackText3D]);
		}
		RackData[rackid][rackExists] = false;
		RackData[rackid][rackID] = 0;
		RackData[rackid][rackHouse] = 0;
	}
	return 1;
}

Rack_Create(playerid, houseid)
{
	static
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:angle;

	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i != MAX_WEAPON_RACKS; i ++) if (!RackData[i][rackExists])
		{
		    x += 1.5 * floatsin(-angle, degrees);
		    y += 1.5 * floatcos(-angle, degrees);

		    RackData[i][rackExists] = true;
		    RackData[i][rackHouse] = (houseid == -1) ? (-1) : (HouseData[houseid][houseID]);

		    RackData[i][rackPos][0] = x;
		    RackData[i][rackPos][1] = y;
		    RackData[i][rackPos][2] = z;
		    RackData[i][rackPos][3] = angle;
		    RackData[i][rackInterior] = GetPlayerInterior(playerid);
		    RackData[i][rackWorld] = GetPlayerVirtualWorld(playerid);

		    Rack_Refresh(i);
		    mysql_tquery(g_iHandle, "INSERT INTO `gunracks` (`rackHouse`) VALUES(0)", "OnRackCreated", "d", i);

		    return i;
		}
	}
	return -1;
}

Rack_RefreshGuns(rackid)
{
    if (rackid != -1 && RackData[rackid][rackExists])
	{
    	new
			Float:x,
	        Float:y,
			Float:z;

		z = RackData[rackid][rackPos][2] + 2.19;

		for (new i = 0; i < 4; i ++) if (IsValidDynamicObject(RackData[rackid][rackObjects][i])) {
		    DestroyDynamicObject(RackData[rackid][rackObjects][i]);

			RackData[rackid][rackObjects][i] = INVALID_OBJECT_ID;
		}
		for (new i = 0; i < 4; i ++)
		{
		    if (RackData[rackid][rackWeapons][i])
			{
				x = RackData[rackid][rackPos][0] - (0.2 * floatsin(-RackData[rackid][rackPos][3], degrees) + (0.45 * floatsin(-RackData[rackid][rackPos][3] - 90, degrees)));
				y = RackData[rackid][rackPos][1] - (0.2 * floatcos(-RackData[rackid][rackPos][3], degrees) + (0.45 * floatcos(-RackData[rackid][rackPos][3] - 90, degrees)));

		        RackData[rackid][rackObjects][i] = CreateDynamicObject(GetWeaponModel(RackData[rackid][rackWeapons][i]), x, y, z, 94.7, 93.7, (22 <= RackData[rackid][rackWeapons][i] <= 38) ? (RackData[rackid][rackPos][3] + 90.0) : (RackData[rackid][rackPos][3]), RackData[rackid][rackWorld], RackData[rackid][rackInterior]);
			}
			else
			{
			    RackData[rackid][rackObjects][i] = INVALID_OBJECT_ID;
			}
			z = z - 0.69;
		}
	}
	return 1;
}

Rack_Refresh(rackid)
{
	if (rackid != -1 && RackData[rackid][rackExists])
	{
	    static
	        str[64];

		if (IsValidDynamicObject(RackData[rackid][rackObjects][4])) {
		    DestroyDynamicObject(RackData[rackid][rackObjects][4]);
		}
		if (IsValidDynamic3DTextLabel(RackData[rackid][rackText3D])) {
		    DestroyDynamic3DTextLabel(RackData[rackid][rackText3D]);
		}
		format(str, sizeof(str), "[Rack %d]\n{FFFFFF}/gunrack to use this rack.", rackid);
		RackData[rackid][rackText3D] = CreateDynamic3DTextLabel(str, COLOR_DARKBLUE, RackData[rackid][rackPos][0], RackData[rackid][rackPos][1], RackData[rackid][rackPos][2] + 1.2, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, RackData[rackid][rackWorld], RackData[rackid][rackInterior]);

		Rack_RefreshGuns(rackid);
        RackData[rackid][rackObjects][4] = CreateDynamicObject(2475, RackData[rackid][rackPos][0], RackData[rackid][rackPos][1], RackData[rackid][rackPos][2], 0.0, 0.0, RackData[rackid][rackPos][3], RackData[rackid][rackWorld], RackData[rackid][rackInterior]);
	}
	return 1;
}

forward Rack_Load();

// ====== Rack_Load ======
public Rack_Load()
{
    static
	    rows,
	    fields,
		str[24];

	cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i < rows; i ++) if (i < MAX_WEAPON_RACKS)
	{
	    RackData[i][rackExists] = true;
	    RackData[i][rackID] = cache_get_field_int(i, "rackID");
	    RackData[i][rackHouse] = cache_get_field_int(i, "rackHouse");
     	RackData[i][rackPos][0] = cache_get_field_float(i, "rackX");
        RackData[i][rackPos][1] = cache_get_field_float(i, "rackY");
        RackData[i][rackPos][2] = cache_get_field_float(i, "rackZ");
        RackData[i][rackPos][3] = cache_get_field_float(i, "rackA");
        RackData[i][rackInterior] = cache_get_field_int(i, "rackInterior");
		RackData[i][rackWorld] = cache_get_field_int(i, "rackWorld");

		for (new j = 0; j < 4; j ++) {
		    format(str, 24, "rackWeapon%d", j + 1);
		    RackData[i][rackWeapons][j] = cache_get_field_int(i, str);

            format(str, 24, "rackAmmo%d", j + 1);
		    RackData[i][rackAmmo][j] = cache_get_field_int(i, str);
		}
		Rack_Refresh(i);
	}
	return 1;
}

