/*
    File: modules/system/logic/vendors.pwn
    Purpose: Contains system gameplay logic and helper functions for vendors.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== Vendor_Create ======
stock Vendor_Create(playerid, type)
{
	for (new i = 0; i != MAX_VENDORS; i ++) if (!VendorData[i][vendorExists])
	{
	    VendorData[i][vendorExists] = true;
	    VendorData[i][vendorType] = type;

	    GetPlayerPos(playerid, VendorData[i][vendorPos][0], VendorData[i][vendorPos][1], VendorData[i][vendorPos][2]);
	    GetPlayerFacingAngle(playerid, VendorData[i][vendorPos][3]);

	    VendorData[i][vendorPos][0] = VendorData[i][vendorPos][0] + (1.5 * floatsin(-VendorData[i][vendorPos][3], degrees));
	    VendorData[i][vendorPos][1] = VendorData[i][vendorPos][1] + (1.5 * floatcos(-VendorData[i][vendorPos][3], degrees));

		VendorData[i][vendorInterior] = GetPlayerInterior(playerid);
		VendorData[i][vendorWorld] = GetPlayerVirtualWorld(playerid);

		Vendor_Refresh(i);
		mysql_tquery(g_iHandle, "INSERT INTO `vendors` (`vendorType`) VALUES(0)", "OnVendorCreated", "d", i);
		return i;
	}
	return -1;
}

// ====== Vendor_Delete ======
stock Vendor_Delete(vendorid)
{
	if (vendorid != -1 && VendorData[vendorid][vendorExists])
	{
	    new
	        string[64];

		format(string, sizeof(string), "DELETE FROM `vendors` WHERE `vendorID` = '%d'", VendorData[vendorid][vendorID]);
		mysql_tquery(g_iHandle, string);

        if (IsValidDynamic3DTextLabel(VendorData[vendorid][vendorText3D]))
	        DestroyDynamic3DTextLabel(VendorData[vendorid][vendorText3D]);

		if (IsValidDynamicObject(VendorData[vendorid][vendorObject]))
		    DestroyDynamicObject(VendorData[vendorid][vendorObject]);

	    VendorData[vendorid][vendorExists] = false;
	    VendorData[vendorid][vendorType] = 0;
	    VendorData[vendorid][vendorID] = 0;
	}
	return 1;
}

// ====== Vendor_Nearest ======
Vendor_Nearest(playerid)
{
    for (new i = 0; i != MAX_VENDORS; i ++) if (VendorData[i][vendorExists] && IsPlayerInRangeOfPoint(playerid, 2.0, VendorData[i][vendorPos][0], VendorData[i][vendorPos][1], VendorData[i][vendorPos][2]))
	{
		if (GetPlayerInterior(playerid) == VendorData[i][vendorInterior] && GetPlayerVirtualWorld(playerid) == VendorData[i][vendorWorld])
			return i;
	}
	return -1;
}

// ====== Vendor_Refresh ======
stock Vendor_Refresh(vendorid)
{
	if (vendorid != -1 && VendorData[vendorid][vendorExists])
	{
	    if (IsValidDynamic3DTextLabel(VendorData[vendorid][vendorText3D]))
	        DestroyDynamic3DTextLabel(VendorData[vendorid][vendorText3D]);

		if (IsValidDynamicObject(VendorData[vendorid][vendorObject]))
		    DestroyDynamicObject(VendorData[vendorid][vendorObject]);

		new
			string[64];

		format(string, sizeof(string), "[Vendor %d]\n{FFFFFF}Press 'F' to use this vendor.", vendorid);
		VendorData[vendorid][vendorText3D] = CreateDynamic3DTextLabel(string, COLOR_DARKBLUE, VendorData[vendorid][vendorPos][0], VendorData[vendorid][vendorPos][1], VendorData[vendorid][vendorPos][2], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, VendorData[vendorid][vendorWorld], VendorData[vendorid][vendorInterior]);

		switch (VendorData[vendorid][vendorType]) {
		    case 1: VendorData[vendorid][vendorObject] = CreateDynamicObject(1340, VendorData[vendorid][vendorPos][0], VendorData[vendorid][vendorPos][1], VendorData[vendorid][vendorPos][2], 0.0, 0.0, VendorData[vendorid][vendorPos][3] - 90.0, VendorData[vendorid][vendorWorld], VendorData[vendorid][vendorInterior]);
		    case 2: VendorData[vendorid][vendorObject] = CreateDynamicObject(1209, VendorData[vendorid][vendorPos][0], VendorData[vendorid][vendorPos][1], VendorData[vendorid][vendorPos][2] - 1.0, 0.0, 0.0, VendorData[vendorid][vendorPos][3], VendorData[vendorid][vendorWorld], VendorData[vendorid][vendorInterior]);
		}
	}
	return 1;
}

// ====== Vendor_Save ======
stock Vendor_Save(vendorid)
{
	new
	    query[300];

	format(query, sizeof(query), "UPDATE `vendors` SET `vendorType` = '%d', `vendorX` = '%.4f', `vendorY` = '%.4f', `vendorZ` = '%.4f', `vendorA` = '%.4f', `vendorInterior` = '%d', `vendorWorld` = '%d' WHERE `vendorID` = '%d'",
        VendorData[vendorid][vendorType],
        VendorData[vendorid][vendorPos][0],
        VendorData[vendorid][vendorPos][1],
        VendorData[vendorid][vendorPos][2],
        VendorData[vendorid][vendorPos][3],
        VendorData[vendorid][vendorInterior],
        VendorData[vendorid][vendorWorld],
        VendorData[vendorid][vendorID]
	);
	return mysql_tquery(g_iHandle, query);
}
forward Vendor_Load();

// ====== Vendor_Load ======
public Vendor_Load()
{
    static
	    rows,
	    fields;

	cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i < rows; i ++) if (i < MAX_VENDORS)
	{
	    VendorData[i][vendorExists] = true;
	    VendorData[i][vendorID] = cache_get_field_int(i, "vendorID");
	    VendorData[i][vendorType] = cache_get_field_int(i, "vendorType");
	    VendorData[i][vendorPos][0] = cache_get_field_float(i, "vendorX");
        VendorData[i][vendorPos][1] = cache_get_field_float(i, "vendorY");
        VendorData[i][vendorPos][2] = cache_get_field_float(i, "vendorZ");
        VendorData[i][vendorPos][3] = cache_get_field_float(i, "vendorA");
        VendorData[i][vendorInterior] = cache_get_field_int(i, "vendorInterior");
		VendorData[i][vendorWorld] = cache_get_field_int(i, "vendorWorld");

		Vendor_Refresh(i);
	}
	return 1;
}

