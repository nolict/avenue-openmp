/*
    File: modules/property/logic/business.pwn
    Purpose: Contains property gameplay logic and helper functions for business.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== KickBusiness ======
forward KickBusiness(playerid, id);

// ====== KickBusiness ======
public KickBusiness(playerid, id)
{
	if (GetFactionType(playerid) != FACTION_POLICE || Business_Nearest(playerid) != id)
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
		    BusinessData[id][bizLocked] = 0;
		    Business_Save(id);

		    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has successfully kicked the door down.", ReturnName(playerid, 0));
		    ShowPlayerFooter(playerid, "Press ~y~'F'~w~ to enter the business.");
		}
	}
	return 1;
}
// ====== Business_Load ======
forward Business_Load();

// ====== Business_Load ======
public Business_Load()
{
    static
	    rows,
	    fields,
		str[64];

	cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i < rows; i ++) if (i < MAX_BUSINESSES)
	{
	    BusinessData[i][bizExists] = true;
	    BusinessData[i][bizID] = cache_get_field_int(i, "bizID");

		cache_get_field_content(i, "bizName", BusinessData[i][bizName], g_iHandle, 32);
        cache_get_field_content(i, "bizMessage", BusinessData[i][bizMessage], g_iHandle, 128);

		BusinessData[i][bizOwner] = cache_get_field_int(i, "bizOwner");
		BusinessData[i][bizType] = cache_get_field_int(i, "bizType");
		BusinessData[i][bizPrice] = cache_get_field_int(i, "bizPrice");
		BusinessData[i][bizPos][0] = cache_get_field_float(i, "bizPosX");
		BusinessData[i][bizPos][1] = cache_get_field_float(i, "bizPosY");
		BusinessData[i][bizPos][2] = cache_get_field_float(i, "bizPosZ");
		BusinessData[i][bizPos][3] = cache_get_field_float(i, "bizPosA");
		BusinessData[i][bizInt][0] = cache_get_field_float(i, "bizIntX");
		BusinessData[i][bizInt][1] = cache_get_field_float(i, "bizIntY");
		BusinessData[i][bizInt][2] = cache_get_field_float(i, "bizIntZ");
		BusinessData[i][bizInt][3] = cache_get_field_float(i, "bizIntA");
		BusinessData[i][bizSpawn][0] = cache_get_field_float(i, "bizSpawnX");
		BusinessData[i][bizSpawn][1] = cache_get_field_float(i, "bizSpawnY");
		BusinessData[i][bizSpawn][2] = cache_get_field_float(i, "bizSpawnZ");
		BusinessData[i][bizSpawn][3] = cache_get_field_float(i, "bizSpawnA");
		BusinessData[i][bizDeliver][0] = cache_get_field_float(i, "bizDeliverX");
		BusinessData[i][bizDeliver][1] = cache_get_field_float(i, "bizDeliverY");
		BusinessData[i][bizDeliver][2] = cache_get_field_float(i, "bizDeliverZ");
		BusinessData[i][bizShipment] = cache_get_field_int(i, "bizShipment");
		BusinessData[i][bizInterior] = cache_get_field_int(i, "bizInterior");
		BusinessData[i][bizExterior] = cache_get_field_int(i, "bizExterior");
		BusinessData[i][bizExteriorVW] = cache_get_field_int(i, "bizExteriorVW");
		BusinessData[i][bizLocked] = cache_get_field_int(i, "bizLocked");
		BusinessData[i][bizVault] = cache_get_field_int(i, "bizVault");
		BusinessData[i][bizProducts] = cache_get_field_int(i, "bizProducts");

		for (new j = 0; j < 20; j ++)
		{
			format(str, 32, "bizPrice%d", j + 1);
			BusinessData[i][bizPrices][j] = cache_get_field_int(i, str);
		}
		Business_Refresh(i);
	}
	for (new i = 0; i < MAX_BUSINESSES; i ++) if (BusinessData[i][bizExists])
	{
		if (BusinessData[i][bizType] == 5) {
			format(str, sizeof(str), "SELECT * FROM `dealervehicles` WHERE `ID` = '%d'", BusinessData[i][bizID]);

			mysql_tquery(g_iHandle, str, "Business_LoadCars", "d", i);
		}
		else if (BusinessData[i][bizType] == 6) {
			format(str, sizeof(str), "SELECT * FROM `pumps` WHERE `ID` = '%d'", BusinessData[i][bizID]);

			mysql_tquery(g_iHandle, str, "Pump_Load", "d", i);
		}
	}
	return 1;
}





// ====== Business_Save ======
Business_Save(bizid)
{
	static
	    query[2048];

	format(query, sizeof(query), "UPDATE `businesses` SET `bizName` = '%s', `bizMessage` = '%s', `bizOwner` = '%d', `bizType` = '%d', `bizPrice` = '%d', `bizPosX` = '%.4f', `bizPosY` = '%.4f', `bizPosZ` = '%.4f', `bizPosA` = '%.4f', `bizIntX` = '%.4f', `bizIntY` = '%.4f', `bizIntZ` = '%.4f', `bizIntA` = '%.4f', `bizInterior` = '%d', `bizExterior` = '%d', `bizExteriorVW` = '%d', `bizLocked` = '%d', `bizVault` = '%d', `bizProducts` = '%d'",
		SQL_ReturnEscaped(BusinessData[bizid][bizName]),
		SQL_ReturnEscaped(BusinessData[bizid][bizMessage]),
		BusinessData[bizid][bizOwner],
		BusinessData[bizid][bizType],
		BusinessData[bizid][bizPrice],
		BusinessData[bizid][bizPos][0],
		BusinessData[bizid][bizPos][1],
		BusinessData[bizid][bizPos][2],
		BusinessData[bizid][bizPos][3],
		BusinessData[bizid][bizInt][0],
		BusinessData[bizid][bizInt][1],
		BusinessData[bizid][bizInt][2],
		BusinessData[bizid][bizInt][3],
		BusinessData[bizid][bizInterior],
		BusinessData[bizid][bizExterior],
		BusinessData[bizid][bizExteriorVW],
		BusinessData[bizid][bizLocked],
		BusinessData[bizid][bizVault],
		BusinessData[bizid][bizProducts]
	);
	for (new i = 0; i < 20; i ++) {
		format(query, sizeof(query), "%s, `bizPrice%d` = '%d'", query, i + 1, BusinessData[bizid][bizPrices][i]);
	}
	format(query, sizeof(query), "%s, `bizSpawnX` = '%.4f', `bizSpawnY` = '%.4f', `bizSpawnZ` = '%.4f', `bizSpawnA` = '%.4f', `bizDeliverX` = '%.4f', `bizDeliverY` = '%.4f', `bizDeliverZ` = '%.4f', `bizShipment` = '%d' WHERE `bizID` = '%d'",
		query,
		BusinessData[bizid][bizSpawn][0],
		BusinessData[bizid][bizSpawn][1],
		BusinessData[bizid][bizSpawn][2],
		BusinessData[bizid][bizSpawn][3],
		BusinessData[bizid][bizDeliver][0],
		BusinessData[bizid][bizDeliver][1],
		BusinessData[bizid][bizDeliver][2],
		BusinessData[bizid][bizShipment],
		BusinessData[bizid][bizID]
	);
	return mysql_tquery(g_iHandle, query);
}

// ====== Business_Inside ======
Business_Inside(playerid)
{
	if (PlayerData[playerid][pBusiness] != -1)
	{
	    for (new i = 0; i != MAX_BUSINESSES; i ++) if (BusinessData[i][bizExists] && BusinessData[i][bizID] == PlayerData[playerid][pBusiness] && GetPlayerInterior(playerid) == BusinessData[i][bizInterior] && GetPlayerVirtualWorld(playerid) > 0) {
	        return i;
		}
	}
	return -1;
}

// ====== Business_GetCount ======
Business_GetCount(playerid)
{
	new
		count = 0;

	for (new i = 0; i != MAX_BUSINESSES; i ++)
	{
		if (BusinessData[i][bizExists] && Business_IsOwner(playerid, i))
   		{
   		    count++;
		}
	}
	return count;
}


Business_NearestDeliver(playerid)
{
    for (new i = 0; i != MAX_BUSINESSES; i ++) if (BusinessData[i][bizExists] && IsPlayerInRangeOfPoint(playerid, 5.0, BusinessData[i][bizDeliver][0], BusinessData[i][bizDeliver][1], BusinessData[i][bizDeliver][2])) {
        return i;
	}
	return -1;
}

Business_Nearest(playerid, Float:radius = 2.5)
{
    for (new i = 0; i != MAX_BUSINESSES; i ++) if (BusinessData[i][bizExists] && IsPlayerInRangeOfPoint(playerid, radius, BusinessData[i][bizPos][0], BusinessData[i][bizPos][1], BusinessData[i][bizPos][2]))
	{
		if (GetPlayerInterior(playerid) == BusinessData[i][bizExterior] && GetPlayerVirtualWorld(playerid) == BusinessData[i][bizExteriorVW])
			return i;
	}
	return -1;
}

Business_Refresh(bizid)
{
	if (bizid != -1 && BusinessData[bizid][bizExists])
	{
		if (IsValidDynamic3DTextLabel(BusinessData[bizid][bizText3D]))
		    DestroyDynamic3DTextLabel(BusinessData[bizid][bizText3D]);

		if (IsValidDynamic3DTextLabel(BusinessData[bizid][bizDeliverText3D]))
		    DestroyDynamic3DTextLabel(BusinessData[bizid][bizDeliverText3D]);

		if (IsValidDynamicPickup(BusinessData[bizid][bizPickup]))
		    DestroyDynamicPickup(BusinessData[bizid][bizPickup]);

        if (IsValidDynamicPickup(BusinessData[bizid][bizDeliverPickup]))
		    DestroyDynamicPickup(BusinessData[bizid][bizDeliverPickup]);

		static
		    string[128],
			pickup;

		if (!BusinessData[bizid][bizOwner]) {
			format(string, sizeof(string), "[%s]\n%s", FormatNumber(BusinessData[bizid][bizPrice]), BusinessData[bizid][bizName]);
            BusinessData[bizid][bizText3D] = CreateDynamic3DTextLabel(string, 0x33AA33FF, BusinessData[bizid][bizPos][0], BusinessData[bizid][bizPos][1], BusinessData[bizid][bizPos][2], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, BusinessData[bizid][bizExteriorVW], BusinessData[bizid][bizExterior]);
		}
		else
		{
			if (BusinessData[bizid][bizLocked]) {
			    format(string, sizeof(string), "%s (closed)", BusinessData[bizid][bizName]);
			}
			else {
			    format(string, sizeof(string), "%s", BusinessData[bizid][bizName]);
			}
			BusinessData[bizid][bizText3D] = CreateDynamic3DTextLabel(string, (BusinessData[bizid][bizLocked]) ? (COLOR_LIGHTRED) : (COLOR_WHITE), BusinessData[bizid][bizPos][0], BusinessData[bizid][bizPos][1], BusinessData[bizid][bizPos][2], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, BusinessData[bizid][bizExteriorVW], BusinessData[bizid][bizExterior]);
		}
		switch (BusinessData[bizid][bizType]) {
		    case 1: pickup = 1272;
		    case 2: pickup = 348;
		    case 3: pickup = 1275;
		    case 4: pickup = 19094;
		    case 5: pickup = 1274;
		    case 6: pickup = 1650;
		    case 7: pickup = 2096;
		}
		if (BusinessData[bizid][bizType] == 6) {
        	BusinessData[bizid][bizPickup] = CreateDynamicPickup(pickup, 23, BusinessData[bizid][bizPos][0], BusinessData[bizid][bizPos][1], BusinessData[bizid][bizPos][2] + 0.3, BusinessData[bizid][bizExteriorVW], BusinessData[bizid][bizExterior]);
		}
		else if (BusinessData[bizid][bizType] == 7) {
		    BusinessData[bizid][bizPickup] = CreateDynamicPickup(pickup, 23, BusinessData[bizid][bizPos][0], BusinessData[bizid][bizPos][1], BusinessData[bizid][bizPos][2] - 0.6, BusinessData[bizid][bizExteriorVW], BusinessData[bizid][bizExterior]);
		}
		else {
            BusinessData[bizid][bizPickup] = CreateDynamicPickup(pickup, 23, BusinessData[bizid][bizPos][0], BusinessData[bizid][bizPos][1], BusinessData[bizid][bizPos][2], BusinessData[bizid][bizExteriorVW], BusinessData[bizid][bizExterior]);
		}
		if (BusinessData[bizid][bizDeliver][0] != 0.0 && BusinessData[bizid][bizDeliver][0] != 0.0 && BusinessData[bizid][bizDeliver][0] != 0.0)
		{
		    format(string, sizeof(string), "%s\n\nDelivery Point", BusinessData[bizid][bizName]);

		    BusinessData[bizid][bizPickup] = CreateDynamicPickup(1239, 23, BusinessData[bizid][bizDeliver][0], BusinessData[bizid][bizDeliver][1], BusinessData[bizid][bizDeliver][2]);
		    BusinessData[bizid][bizDeliverText3D] = CreateDynamic3DTextLabel(string, COLOR_CLIENT, BusinessData[bizid][bizDeliver][0], BusinessData[bizid][bizDeliver][1], BusinessData[bizid][bizDeliver][2], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0);
		}
	}
	return 1;
}

Business_Create(playerid, type, price)
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
	    	if (!BusinessData[i][bizExists])
		    {
    	        BusinessData[i][bizExists] = true;
        	    BusinessData[i][bizOwner] = 0;
            	BusinessData[i][bizPrice] = price;
            	BusinessData[i][bizType] = type;

				format(BusinessData[i][bizName], 32, "Unnamed Business");

    	        BusinessData[i][bizPos][0] = x;
    	        BusinessData[i][bizPos][1] = y;
    	        BusinessData[i][bizPos][2] = z;
    	        BusinessData[i][bizPos][3] = angle;

    	        BusinessData[i][bizSpawn][0] = x;
    	        BusinessData[i][bizSpawn][1] = y;
    	        BusinessData[i][bizSpawn][2] = z;
    	        BusinessData[i][bizSpawn][3] = angle;

    	        BusinessData[i][bizDeliver][0] = 0.0;
    	        BusinessData[i][bizDeliver][1] = 0.0;
    	        BusinessData[i][bizDeliver][2] = 0.0;

				if (type == 1) {
                	BusinessData[i][bizInt][0] = -27.3074;
                	BusinessData[i][bizInt][1] = -30.8741;
                	BusinessData[i][bizInt][2] = 1003.5573;
                	BusinessData[i][bizInt][3] = 0.0000;
					BusinessData[i][bizInterior] = 4;

					BusinessData[i][bizPrices][0] = 75;
		            BusinessData[i][bizPrices][1] = 125;
		            BusinessData[i][bizPrices][2] = 15;
		            BusinessData[i][bizPrices][3] = 100;
		            BusinessData[i][bizPrices][4] = 3;
		            BusinessData[i][bizPrices][5] = 2;
		            BusinessData[i][bizPrices][6] = 10;
		            BusinessData[i][bizPrices][7] = 100;
		            BusinessData[i][bizPrices][8] = 20;
		            BusinessData[i][bizPrices][9] = 10;
		            BusinessData[i][bizPrices][10] = 150;
		            BusinessData[i][bizPrices][11] = 200;
		            BusinessData[i][bizPrices][12] = 160;
                    BusinessData[i][bizPrices][13] = 60;
                    BusinessData[i][bizPrices][14] = 50;
		            BusinessData[i][bizPrices][15] = 5;
		            BusinessData[i][bizPrices][16] = 10;
		            BusinessData[i][bizPrices][17] = 5;
				}
				else if (type == 2) {
                	BusinessData[i][bizInt][0] = 316.3963;
                	BusinessData[i][bizInt][1] = -169.8375;
                	BusinessData[i][bizInt][2] = 999.6010;
                	BusinessData[i][bizInt][3] = 0.0000;
					BusinessData[i][bizInterior] = 6;

                    BusinessData[i][bizPrices][0] = 50;
					BusinessData[i][bizPrices][1] = 100;
		            BusinessData[i][bizPrices][2] = 200;
		            BusinessData[i][bizPrices][3] = 400;
		            BusinessData[i][bizPrices][4] = 600;
		            BusinessData[i][bizPrices][5] = 800;
				}
				else if (type == 3) {
                	BusinessData[i][bizInt][0] = 161.4801;
                	BusinessData[i][bizInt][1] = -96.5368;
                	BusinessData[i][bizInt][2] = 1001.8047;
                	BusinessData[i][bizInt][3] = 0.0000;
					BusinessData[i][bizInterior] = 18;

					BusinessData[i][bizPrices][0] = 25;
		            BusinessData[i][bizPrices][1] = 15;
		            BusinessData[i][bizPrices][2] = 10;
		            BusinessData[i][bizPrices][3] = 10;
				}
				else if (type == 4) {
                	BusinessData[i][bizInt][0] = 363.3402;
                	BusinessData[i][bizInt][1] = -74.6679;
                	BusinessData[i][bizInt][2] = 1001.5078;
                	BusinessData[i][bizInt][3] = 315.0000;
					BusinessData[i][bizInterior] = 10;

					BusinessData[i][bizPrices][0] = 2;
		            BusinessData[i][bizPrices][1] = 5;
		            BusinessData[i][bizPrices][2] = 5;
		            BusinessData[i][bizPrices][3] = 10;
		            BusinessData[i][bizPrices][4] = 10;
		            BusinessData[i][bizPrices][5] = 15;
		            BusinessData[i][bizPrices][6] = 10;
				}
				else if (type == 5) {
				    BusinessData[i][bizInt][0] = 1494.5612;
	            	BusinessData[i][bizInt][1] = 1304.2061;
	            	BusinessData[i][bizInt][2] = 1093.2891;
	            	BusinessData[i][bizInt][3] = 0.0000;
					BusinessData[i][bizInterior] = 3;
				}
				else if (type == 6) {
                	BusinessData[i][bizInt][0] = -27.3383;
                	BusinessData[i][bizInt][1] = -57.6909;
                	BusinessData[i][bizInt][2] = 1003.5469;
                	BusinessData[i][bizInt][3] = 0.0000;
					BusinessData[i][bizInterior] = 6;

					BusinessData[i][bizPrices][0] = 75;
		            BusinessData[i][bizPrices][1] = 115;
		            BusinessData[i][bizPrices][2] = 15;
		            BusinessData[i][bizPrices][3] = 90;
		            BusinessData[i][bizPrices][4] = 3;
		            BusinessData[i][bizPrices][5] = 2;
		            BusinessData[i][bizPrices][6] = 10;
		            BusinessData[i][bizPrices][7] = 90;
		            BusinessData[i][bizPrices][8] = 20;
		            BusinessData[i][bizPrices][9] = 10;
		            BusinessData[i][bizPrices][10] = 140;
		            BusinessData[i][bizPrices][11] = 150;
                    BusinessData[i][bizPrices][12] = 50;
                    BusinessData[i][bizPrices][13] = 40;
		            BusinessData[i][bizPrices][14] = 5;
		            BusinessData[i][bizPrices][15] = 10;
		            BusinessData[i][bizPrices][16] = 5;
				}
				else if (type == 7) {
					BusinessData[i][bizInt][0] = -2240.4954;
   					BusinessData[i][bizInt][1] = 128.3774;
			   		BusinessData[i][bizInt][2] = 1035.4210;
      				BusinessData[i][bizInt][3] = 270.0000;
					BusinessData[i][bizInterior] = 6;

					BusinessData[i][bizPrices][0] = 75;
		            BusinessData[i][bizPrices][1] = 115;
		            BusinessData[i][bizPrices][2] = 15;
		            BusinessData[i][bizPrices][3] = 95;
		            BusinessData[i][bizPrices][4] = 3;
		            BusinessData[i][bizPrices][5] = 2;
		            BusinessData[i][bizPrices][6] = 10;
		            BusinessData[i][bizPrices][7] = 100;
		            BusinessData[i][bizPrices][8] = 20;
		            BusinessData[i][bizPrices][9] = 10;
		            BusinessData[i][bizPrices][10] = 140;
		            BusinessData[i][bizPrices][11] = 190;
		            BusinessData[i][bizPrices][12] = 150;
                    BusinessData[i][bizPrices][13] = 60;
                    BusinessData[i][bizPrices][14] = 50;
		            BusinessData[i][bizPrices][15] = 5;
		            BusinessData[i][bizPrices][16] = 10;
		            BusinessData[i][bizPrices][17] = 5;
				}
				BusinessData[i][bizExterior] = GetPlayerInterior(playerid);
				BusinessData[i][bizExteriorVW] = GetPlayerVirtualWorld(playerid);

				BusinessData[i][bizLocked] = true;
				BusinessData[i][bizVault] = 0;
				BusinessData[i][bizProducts] = 100;
				BusinessData[i][bizShipment] = 0;

				Business_Refresh(i);
				mysql_tquery(g_iHandle, "INSERT INTO `businesses` (`bizOwner`) VALUES(0)", "OnBusinessCreated", "d", i);
				return i;
			}
		}
	}
	return -1;
}


Business_Delete(bizid)
{
	if (bizid != -1 && BusinessData[bizid][bizExists])
	{
	    new
	        string[82];

		format(string, sizeof(string), "DELETE FROM `businesses` WHERE `bizID` = '%d'", BusinessData[bizid][bizID]);
		mysql_tquery(g_iHandle, string);

		foreach (new i : Player) if (PlayerData[i][pShipment] == bizid) {
			PlayerData[i][pShipment] = -1;
			PlayerData[i][pDeliverShipment] = 0;

			DisablePlayerCheckpoint(i);
		}
        if (IsValidDynamic3DTextLabel(BusinessData[bizid][bizText3D]))
		    DestroyDynamic3DTextLabel(BusinessData[bizid][bizText3D]);

		if (IsValidDynamicPickup(BusinessData[bizid][bizPickup]))
		    DestroyDynamicPickup(BusinessData[bizid][bizPickup]);

		Business_RemovePumps(bizid);
		Business_RemoveCars(bizid);

	    BusinessData[bizid][bizExists] = false;
	    BusinessData[bizid][bizOwner] = 0;
	    BusinessData[bizid][bizID] = 0;
	}
	return 1;
}

Business_IsOwner(playerid, bizid)
{
	if (!PlayerData[playerid][pLogged] || PlayerData[playerid][pID] == -1)
	    return 0;

	if (BusinessData[bizid][bizExists] && BusinessData[bizid][bizOwner] == 99999999 && PlayerData[playerid][pAdmin] > 0)
		return 1;

    if ((BusinessData[bizid][bizExists] && BusinessData[bizid][bizOwner] != 0) && BusinessData[bizid][bizOwner] == PlayerData[playerid][pID])
		return 1;

	return 0;
}
