/*
    File: modules/property/logic/house.pwn
    Purpose: Contains property gameplay logic and helper functions for house.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== KickHouse ======
forward KickHouse(playerid, id);

// ====== KickHouse ======
public KickHouse(playerid, id)
{
	if (GetFactionType(playerid) != FACTION_POLICE || House_Nearest(playerid) != id)
	    return 0;

	switch (random(6))
	{
	    case 0..2:
	    {
	        ShowPlayerFooter(playerid, "You have ~r~failed~w~ to kick the door down.");
	        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has failed to kick the door down.", ReturnName(playerid, 0));
		}
		default:
		{
		    HouseData[id][houseLocked] = 0;
		    House_Save(id);

		    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has successfully kicked the door down.", ReturnName(playerid, 0));
		    ShowPlayerFooter(playerid, "Press ~y~'F'~w~ to enter the house.");
		}
	}
	return 1;
}
// ====== House_Load ======
forward House_Load();

// ====== House_Load ======
public House_Load()
{
	static
	    rows,
	    fields,
		str[128];

	cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i < rows; i ++) if (i < MAX_HOUSES)
	{
		HouseData[i][houseExists] = true;
		HouseData[i][houseLights] = false;

		HouseData[i][houseID] = cache_get_field_int(i, "houseID");
		HouseData[i][houseOwner] = cache_get_field_int(i, "houseOwner");
		HouseData[i][housePrice] = cache_get_field_int(i, "housePrice");

		cache_get_field_content(i, "houseAddress", HouseData[i][houseAddress], g_iHandle, 32);

		HouseData[i][housePos][0] = cache_get_field_float(i, "housePosX");
		HouseData[i][housePos][1] = cache_get_field_float(i, "housePosY");
		HouseData[i][housePos][2] = cache_get_field_float(i, "housePosZ");
		HouseData[i][housePos][3] = cache_get_field_float(i, "housePosA");
		HouseData[i][houseInt][0] = cache_get_field_float(i, "houseIntX");
		HouseData[i][houseInt][1] = cache_get_field_float(i, "houseIntY");
		HouseData[i][houseInt][2] = cache_get_field_float(i, "houseIntZ");
		HouseData[i][houseInt][3] = cache_get_field_float(i, "houseIntA");
		HouseData[i][houseInterior] = cache_get_field_int(i, "houseInterior");
		HouseData[i][houseExterior] = cache_get_field_int(i, "houseExterior");
		HouseData[i][houseExteriorVW] = cache_get_field_int(i, "houseExteriorVW");
        HouseData[i][houseLocked] = cache_get_field_int(i, "houseLocked");
        HouseData[i][houseMoney] = cache_get_field_int(i, "houseMoney");

        for (new j = 0; j < 10; j ++)
		{
            format(str, 24, "houseWeapon%d", j + 1);
            HouseData[i][houseWeapons][j] = cache_get_field_int(i, str);

            format(str, 24, "houseAmmo%d", j + 1);
            HouseData[i][houseAmmo][j] = cache_get_field_int(i, str);
		}
		House_Refresh(i);
	}
	for (new i = 0; i < MAX_HOUSES; i ++) if (HouseData[i][houseExists]) {
		format(str, sizeof(str), "SELECT * FROM `housestorage` WHERE `ID` = '%d'", HouseData[i][houseID]);

		mysql_tquery(g_iHandle, str, "OnLoadStorage", "d", i);

		format(str, sizeof(str), "SELECT * FROM `furniture` WHERE `ID` = '%d'", HouseData[i][houseID]);

		mysql_tquery(g_iHandle, str, "OnLoadFurniture", "d", i);
	}
	return 1;
}


// ====== OnLoadStorage ======
forward OnLoadStorage(houseid);

// ====== OnLoadStorage ======
public OnLoadStorage(houseid)
{
	static
	    rows,
	    fields,
		str[32];

	cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i != rows; i ++) {
		HouseStorage[houseid][i][hItemExists] = true;
		HouseStorage[houseid][i][hItemID] = cache_get_field_int(i, "itemID");
		HouseStorage[houseid][i][hItemModel] = cache_get_field_int(i, "itemModel");
		HouseStorage[houseid][i][hItemQuantity] = cache_get_field_int(i, "itemQuantity");

		cache_get_field_content(i, "itemName", str, g_iHandle, sizeof(str));
		strpack(HouseStorage[houseid][i][hItemName], str, 32 char);
	}
	return 1;
}

// ====== House_Save ======
House_Save(houseid)
{
	static
	    query[1536];

	format(query, sizeof(query), "UPDATE `houses` SET `houseOwner` = '%d', `housePrice` = '%d', `houseAddress` = '%s', `housePosX` = '%.4f', `housePosY` = '%.4f', `housePosZ` = '%.4f', `housePosA` = '%.4f', `houseIntX` = '%.4f', `houseIntY` = '%.4f', `houseIntZ` = '%.4f', `houseIntA` = '%.4f', `houseInterior` = '%d', `houseExterior` = '%d', `houseExteriorVW` = '%d'",
	    HouseData[houseid][houseOwner],
	    HouseData[houseid][housePrice],
	    SQL_ReturnEscaped(HouseData[houseid][houseAddress]),
	    HouseData[houseid][housePos][0],
	    HouseData[houseid][housePos][1],
	    HouseData[houseid][housePos][2],
	    HouseData[houseid][housePos][3],
	    HouseData[houseid][houseInt][0],
	    HouseData[houseid][houseInt][1],
	    HouseData[houseid][houseInt][2],
	    HouseData[houseid][houseInt][3],
        HouseData[houseid][houseInterior],
        HouseData[houseid][houseExterior],
        HouseData[houseid][houseExteriorVW]
	);
	for (new i = 0; i < 10; i ++) {
		format(query, sizeof(query), "%s, `houseWeapon%d` = '%d', `houseAmmo%d` = '%d'", query, i + 1, HouseData[houseid][houseWeapons][i], i + 1, HouseData[houseid][houseAmmo][i]);
	}
	format(query, sizeof(query), "%s, `houseLocked` = '%d', `houseMoney` = '%d' WHERE `houseID` = '%d'",
	    query,
	    HouseData[houseid][houseLocked],
	    HouseData[houseid][houseMoney],
        HouseData[houseid][houseID]
	);
	return mysql_tquery(g_iHandle, query);
}

/*House_GetCount(playerid)
{
	new count = 0;

    for (new i = 0; i != MAX_HOUSES; i ++) if (HouseData[i][houseExists] && House_IsOwner(playerid, i)) {
	    count++;
	}
	return count;
}*/

// ====== House_Inside ======
House_Inside(playerid)
{
	if (PlayerData[playerid][pHouse] != -1)
	{
	    for (new i = 0; i != MAX_HOUSES; i ++) if (HouseData[i][houseExists] && HouseData[i][houseID] == PlayerData[playerid][pHouse] && GetPlayerInterior(playerid) == HouseData[i][houseInterior] && GetPlayerVirtualWorld(playerid) > 0) {
	        return i;
		}
	}
	return -1;
}

// ====== House_Refresh ======
House_Refresh(houseid)
{
	if (houseid != -1 && HouseData[houseid][houseExists])
	{
		if (IsValidDynamic3DTextLabel(HouseData[houseid][houseText3D]))
		    DestroyDynamic3DTextLabel(HouseData[houseid][houseText3D]);

		if (IsValidDynamicPickup(HouseData[houseid][housePickup]))
		    DestroyDynamicPickup(HouseData[houseid][housePickup]);

		if (IsValidDynamicMapIcon(HouseData[houseid][houseMapIcon]))
		    DestroyDynamicMapIcon(HouseData[houseid][houseMapIcon]);

		static
		    string[128];

		if (!HouseData[houseid][houseOwner]) {
			format(string, sizeof(string), "[%s]\n%s", FormatNumber(HouseData[houseid][housePrice]), HouseData[houseid][houseAddress]);
            HouseData[houseid][houseText3D] = CreateDynamic3DTextLabel(string, 0x33AA33FF, HouseData[houseid][housePos][0], HouseData[houseid][housePos][1], HouseData[houseid][housePos][2], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, HouseData[houseid][houseExteriorVW], HouseData[houseid][houseExterior]);
		}
		else {
			format(string, sizeof(string), "%s", HouseData[houseid][houseAddress]);
			HouseData[houseid][houseText3D] = CreateDynamic3DTextLabel(string, COLOR_WHITE, HouseData[houseid][housePos][0], HouseData[houseid][housePos][1], HouseData[houseid][housePos][2], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, HouseData[houseid][houseExteriorVW], HouseData[houseid][houseExterior]);
		}
        HouseData[houseid][housePickup] = CreateDynamicPickup(1273, 23, HouseData[houseid][housePos][0], HouseData[houseid][housePos][1], HouseData[houseid][housePos][2], HouseData[houseid][houseExteriorVW], HouseData[houseid][houseExterior]);
        HouseData[houseid][houseMapIcon] = CreateDynamicMapIcon(HouseData[houseid][housePos][0], HouseData[houseid][housePos][1], HouseData[houseid][housePos][2], (HouseData[houseid][houseOwner] != 0) ? (32) : (31), 0, HouseData[houseid][houseExteriorVW], HouseData[houseid][houseExterior]);
	}
	return 1;
}

// ====== House_Create ======
House_Create(playerid, address[], price)
{
	static
	    Float:x,
	    Float:y,
	    Float:z,
		Float:angle;

	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i != MAX_HOUSES; i ++)
		{
	    	if (!HouseData[i][houseExists])
		    {
    	        HouseData[i][houseExists] = true;
        	    HouseData[i][houseOwner] = 0;
            	HouseData[i][housePrice] = price;
            	HouseData[i][houseMoney] = 0;

				format(HouseData[i][houseAddress], 32, address);

    	        HouseData[i][housePos][0] = x;
    	        HouseData[i][housePos][1] = y;
    	        HouseData[i][housePos][2] = z;
    	        HouseData[i][housePos][3] = angle;

                HouseData[i][houseInt][0] = 2269.8772;
                HouseData[i][houseInt][1] = -1210.3240;
                HouseData[i][houseInt][2] = 1047.5625;
                HouseData[i][houseInt][3] = 90.0000;

				HouseData[i][houseInterior] = 10;
				HouseData[i][houseExterior] = GetPlayerInterior(playerid);
				HouseData[i][houseExteriorVW] = GetPlayerVirtualWorld(playerid);

				HouseData[i][houseLights] = false;
				HouseData[i][houseLocked] = false;

				House_Refresh(i);
				mysql_tquery(g_iHandle, "INSERT INTO `houses` (`houseOwner`) VALUES(0)", "OnHouseCreated", "d", i);
				return i;
			}
		}
	}
	return -1;
}


// ====== House_IsOwner ======
House_IsOwner(playerid, houseid)
{
	if (!PlayerData[playerid][pLogged] || PlayerData[playerid][pID] == -1)
	    return 0;

    if ((HouseData[houseid][houseExists] && HouseData[houseid][houseOwner] != 0) && HouseData[houseid][houseOwner] == PlayerData[playerid][pID])
		return 1;

	return 0;
}

// ====== House_GetCount ======
House_GetCount(playerid)
{
	new
		count = 0;

	for (new i = 0; i != MAX_HOUSES; i ++)
	{
		if (HouseData[i][houseExists] && House_IsOwner(playerid, i))
   		{
   		    count++;
		}
	}
	return count;
}
