/*
    File: modules/system/logic/plants.pwn
    Purpose: Contains system gameplay logic and helper functions for plants.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== Plant_Load ======
forward Plant_Load();

// ====== Plant_Load ======
public Plant_Load()
{
	static
	    rows,
	    fields;

	cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i < rows; i ++) if (i < MAX_DRUG_PLANTS)
	{
	    PlantData[i][plantExists] = true;
	    PlantData[i][plantID] = cache_get_field_int(i, "plantID");
	    PlantData[i][plantType] = cache_get_field_int(i, "plantType");
	    PlantData[i][plantDrugs] = cache_get_field_int(i, "plantDrugs");
	    PlantData[i][plantPos][0] = cache_get_field_float(i, "plantX");
	    PlantData[i][plantPos][1] = cache_get_field_float(i, "plantY");
	    PlantData[i][plantPos][2] = cache_get_field_float(i, "plantZ");
	    PlantData[i][plantPos][3] = cache_get_field_float(i, "plantA");
	    PlantData[i][plantInterior] = cache_get_field_int(i, "plantInterior");
	    PlantData[i][plantWorld] = cache_get_field_int(i, "plantWorld");

		Plant_Refresh(i);
	}
	return 1;
}

// ====== HarvestPlant ======
forward HarvestPlant(playerid, plantid);

// ====== HarvestPlant ======
public HarvestPlant(playerid, plantid)
{
	PlayerData[playerid][pHarvesting] = 0;

	if (Plant_Nearest(playerid) != plantid || GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK || !PlantData[plantid][plantExists])
	    return 0;

	switch (PlantData[plantid][plantType])
	{
	    case 1:
	    {
	        new id = Inventory_Add(playerid, "Marijuana", 1578, PlantData[plantid][plantDrugs]);

	        if (id == -1)
	            return SendErrorMessage(playerid, "You don't have any room in your inventory.");

	        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has harvested %d grams of marijuana.", ReturnName(playerid, 0), PlantData[plantid][plantDrugs]);
		}
		case 2:
	    {
	        new id = Inventory_Add(playerid, "Cocaine", 1575, PlantData[plantid][plantDrugs]);

	        if (id == -1)
	            return SendErrorMessage(playerid, "You don't have any room in your inventory.");

	        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has harvested %d grams of cocaine.", ReturnName(playerid, 0), PlantData[plantid][plantDrugs]);
		}
        case 3:
	    {
	        new id = Inventory_Add(playerid, "Heroin", 1577, PlantData[plantid][plantDrugs]);

	        if (id == -1)
	            return SendErrorMessage(playerid, "You don't have any room in your inventory.");

	        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has harvested %d grams of heroin.", ReturnName(playerid, 0), PlantData[plantid][plantDrugs]);
		}
	}
	Plant_Delete(plantid);
	return 1;
}


// ====== Plant_Nearest ======
Plant_Nearest(playerid)
{
    for (new i = 0; i != MAX_DRUG_PLANTS; i ++) if (PlantData[i][plantExists] && IsPlayerInRangeOfPoint(playerid, 4.0, PlantData[i][plantPos][0], PlantData[i][plantPos][1], PlantData[i][plantPos][2]))
	{
		if (GetPlayerInterior(playerid) == PlantData[i][plantInterior] && GetPlayerVirtualWorld(playerid) == PlantData[i][plantWorld])
			return i;
	}
	return -1;
}

// ====== Plant_Delete ======
Plant_Delete(plantid)
{
	if (plantid != -1 && PlantData[plantid][plantExists])
	{
	    new
	        string[64];

		format(string, sizeof(string), "DELETE FROM `plants` WHERE `plantID` = '%d'", PlantData[plantid][plantID]);
		mysql_tquery(g_iHandle, string);

        if (IsValidDynamic3DTextLabel(PlantData[plantid][plantText3D]))
		    DestroyDynamic3DTextLabel(PlantData[plantid][plantText3D]);

		if (IsValidDynamicObject(PlantData[plantid][plantObject]))
		    DestroyDynamicObject(PlantData[plantid][plantObject]);

	    PlantData[plantid][plantExists] = false;
		PlantData[plantid][plantID] = 0;
	    PlantData[plantid][plantDrugs] = 0;
	}
	return 1;
}

// ====== Plant_Create ======
Plant_Create(playerid, type)
{
	static
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:angle;

	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
	    for (new i = 0; i != MAX_DRUG_PLANTS; i ++) if (!PlantData[i][plantExists])
	    {
	        PlantData[i][plantExists] = true;
	        PlantData[i][plantType] = type;
	        PlantData[i][plantDrugs] = 0;

	        PlantData[i][plantPos][0] = x;
	        PlantData[i][plantPos][1] = y;
	        PlantData[i][plantPos][2] = z;
	        PlantData[i][plantPos][3] = angle;
	        PlantData[i][plantInterior] = GetPlayerInterior(playerid);
	        PlantData[i][plantWorld] = GetPlayerVirtualWorld(playerid);

	        mysql_tquery(g_iHandle, "INSERT INTO `plants` (`plantType`) VALUES(0)", "OnPlantCreated", "d", i);
	        Plant_Refresh(i);
	        return i;
		}
	}
	return -1;
}

// ====== Plant_MaxGrams ======
Plant_MaxGrams(type)
{
	new grams;

	switch (type)
	{
	    case 1: grams = 40; // Marijuana plant
	    case 2: grams = 30; // Cocaine plant
		case 3: grams = 25; // Heroin plant
		default: grams = 0;
	}
	return grams;
}

// ====== Plant_Save ======
Plant_Save(plantid)
{
	static
	    query[256];

	format(query, sizeof(query), "UPDATE `plants` SET `plantType` = '%d', `plantDrugs` = '%d', `plantX` = '%.4f', `plantY` = '%.4f', `plantZ` = '%.4f', `plantA` = '%.4f', `plantInterior` = '%d', `plantWorld` = '%d' WHERE `plantID` = '%d'",
        PlantData[plantid][plantType],
        PlantData[plantid][plantDrugs],
        PlantData[plantid][plantPos][0],
        PlantData[plantid][plantPos][1],
        PlantData[plantid][plantPos][2],
        PlantData[plantid][plantPos][3],
        PlantData[plantid][plantInterior],
        PlantData[plantid][plantWorld],
        PlantData[plantid][plantID]
	);
	return mysql_tquery(g_iHandle, query);
}

// ====== Plant_GetType ======
Plant_GetType(type)
{
	static
	    str[16];

    switch (type) {
    	case 1: str = "Marijuana";
    	case 2: str = "Cocaine";
	    case 3: str = "Heroin";
	}
	return str;
}

// ====== Plant_Refresh ======
Plant_Refresh(plantid)
{
	if (plantid != -1 && PlantData[plantid][plantExists])
	{
	    static
	        string[128];

		if (IsValidDynamicObject(PlantData[plantid][plantObject]))
		    DestroyDynamicObject(PlantData[plantid][plantObject]);

		if (IsValidDynamic3DTextLabel(PlantData[plantid][plantText3D]))
		    DestroyDynamic3DTextLabel(PlantData[plantid][plantText3D]);

		PlantData[plantid][plantObject] = CreateDynamicObject(3409, PlantData[plantid][plantPos][0], PlantData[plantid][plantPos][1], PlantData[plantid][plantPos][2] - 1.80, 0.0, 0.0, PlantData[plantid][plantPos][3], PlantData[plantid][plantWorld], PlantData[plantid][plantInterior]);

		format(string, sizeof(string), "[Plant %d]\n{FFFFFF}%s - %d/%d Grams", plantid, Plant_GetType(PlantData[plantid][plantType]), PlantData[plantid][plantDrugs], Plant_MaxGrams(PlantData[plantid][plantType]));
  		PlantData[plantid][plantText3D] = CreateDynamic3DTextLabel(string, COLOR_DARKBLUE, PlantData[plantid][plantPos][0], PlantData[plantid][plantPos][1], PlantData[plantid][plantPos][2], 10.0, INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 0, PlantData[plantid][plantWorld], PlantData[plantid][plantInterior]);
	}
	return 1;
}
