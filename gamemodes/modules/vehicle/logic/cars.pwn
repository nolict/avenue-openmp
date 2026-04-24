/*
    File: modules/vehicle/logic/cars.pwn
    Purpose: Contains vehicle gameplay logic and helper functions for cars.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== Car_GetRealID ======
stock Car_GetRealID(carid)
{
	if (carid == -1 || !CarData[carid][carExists] || CarData[carid][carVehicle] == INVALID_VEHICLE_ID)
	    return INVALID_VEHICLE_ID;

	return CarData[carid][carVehicle];
}

// ====== Car_GetID ======
stock Car_GetID(vehicleid)
{
	for (new i = 0; i != MAX_DYNAMIC_CARS; i ++) if (CarData[i][carExists] && CarData[i][carVehicle] == vehicleid) {
	    return i;
	}
	return -1;
}

// ====== Car_Spawn ======
stock Car_Spawn(carid)
{
	if (carid != -1 && CarData[carid][carExists])
	{
		if (IsValidVehicle(CarData[carid][carVehicle]))
		    DestroyVehicle(CarData[carid][carVehicle]);

		if (CarData[carid][carColor1] == -1)
		    CarData[carid][carColor1] = random(127);

		if (CarData[carid][carColor2] == -1)
		    CarData[carid][carColor2] = random(127);

        CarData[carid][carVehicle] = CreateVehicle(CarData[carid][carModel], CarData[carid][carPos][0], CarData[carid][carPos][1], CarData[carid][carPos][2], CarData[carid][carPos][3], CarData[carid][carColor1], CarData[carid][carColor2], (CarData[carid][carOwner] != 0) ? (-1) : (1200000));

        if (CarData[carid][carVehicle] != INVALID_VEHICLE_ID)
        {
            if (CarData[carid][carPaintjob] != -1)
            {
                ChangeVehiclePaintjob(CarData[carid][carVehicle], CarData[carid][carPaintjob]);
			}
			if (CarData[carid][carLocked])
			{
			    new
					engine, lights, alarm, doors, bonnet, boot, objective;

				GetVehicleParamsEx(CarData[carid][carVehicle], engine, lights, alarm, doors, bonnet, boot, objective);
			    SetVehicleParamsEx(CarData[carid][carVehicle], engine, lights, alarm, 1, bonnet, boot, objective);
			}
			for (new i = 0; i < 14; i ++)
			{
			    if (CarData[carid][carMods][i]) AddVehicleComponent(CarData[carid][carVehicle], CarData[carid][carMods][i]);
			}
   			ResetVehicle(CarData[carid][carVehicle]);
			return 1;
		}
	}
	return 0;
}

// ====== Car_Load ======
forward Car_Load();

// ====== Car_Load ======
public Car_Load()
{
	static
	    rows,
	    fields,
		str[128];

	cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i < rows; i ++) if (i < MAX_DYNAMIC_CARS)
	{
	    CarData[i][carExists] = true;
	    CarData[i][carID] = cache_get_field_int(i, "carID");
	    CarData[i][carModel] = cache_get_field_int(i, "carModel");
	    CarData[i][carOwner] = cache_get_field_int(i, "carOwner");
	    CarData[i][carPos][0] = cache_get_field_float(i, "carPosX");
	    CarData[i][carPos][1] = cache_get_field_float(i, "carPosY");
	    CarData[i][carPos][2] = cache_get_field_float(i, "carPosZ");
	    CarData[i][carPos][3] = cache_get_field_float(i, "carPosR");
	    CarData[i][carColor1] = cache_get_field_int(i, "carColor1");
	    CarData[i][carColor2] = cache_get_field_int(i, "carColor2");
	    CarData[i][carPaintjob] = cache_get_field_int(i, "carPaintjob");
	    CarData[i][carLocked] = cache_get_field_int(i, "carLocked");
	    CarData[i][carImpounded] = cache_get_field_int(i, "carImpounded");
	    CarData[i][carImpoundPrice] = cache_get_field_int(i, "carImpoundPrice");
        CarData[i][carFaction] = cache_get_field_int(i, "carFaction");

		for (new j = 0; j < 14; j ++)
		{
		    if (j < 5)
		    {
		        format(str, sizeof(str), "carWeapon%d", j + 1);
		        CarData[i][carWeapons][j] = cache_get_field_int(i, str);

		        format(str, sizeof(str), "carAmmo%d", j + 1);
		        CarData[i][carAmmo][j] = cache_get_field_int(i, str);
	        }
	        format(str, sizeof(str), "carMod%d", j + 1);
	        CarData[i][carMods][j] = cache_get_field_int(i, str);
	    }
	    Car_Spawn(i);
	}
	for (new i = 0; i < MAX_DYNAMIC_CARS; i ++) if (CarData[i][carExists]) {
		format(str, sizeof(str), "SELECT * FROM `carstorage` WHERE `ID` = '%d'", CarData[i][carID]);

		mysql_tquery(g_iHandle, str, "OnLoadCarStorage", "d", i);
	}
	return 1;
}


// ====== OnLoadCarStorage ======
forward OnLoadCarStorage(carid);

// ====== OnLoadCarStorage ======
public OnLoadCarStorage(carid)
{
	static
	    rows,
	    fields,
		str[32];

	cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i != rows; i ++) {
		CarStorage[carid][i][cItemExists] = true;
		CarStorage[carid][i][cItemID] = cache_get_field_int(i, "itemID");
		CarStorage[carid][i][cItemModel] = cache_get_field_int(i, "itemModel");
		CarStorage[carid][i][cItemQuantity] = cache_get_field_int(i, "itemQuantity");

		cache_get_field_content(i, "itemName", str, g_iHandle, sizeof(str));
		strpack(CarStorage[carid][i][cItemName], str, 32 char);
	}
	return 1;
}

// ====== Car_GetCount ======
Car_GetCount(playerid)
{
	new
		count = 0;

	for (new i = 0; i != MAX_DYNAMIC_CARS; i ++)
	{
		if (CarData[i][carExists] && CarData[i][carOwner] == PlayerData[playerid][pID])
   		{
   		    count++;
		}
	}
	return count;
}


// ====== Car_IsOwner ======
Car_IsOwner(playerid, carid)
{
	if (!PlayerData[playerid][pLogged] || PlayerData[playerid][pID] == -1)
	    return 0;

    if ((CarData[carid][carExists] && CarData[carid][carOwner] != 0) && CarData[carid][carOwner] == PlayerData[playerid][pID])
		return 1;

	return 0;
}

// ====== Car_WeaponStorage ======
Car_WeaponStorage(playerid, carid)
{
    if (!CarData[carid][carExists] || CarData[carid][carLocked])
	    return 0;

    static
	    string[164];

	string[0] = 0;

	for (new i = 0; i < 5; i ++)
	{
	    if (22 <= CarData[carid][carWeapons][i] <= 38)
	        format(string, sizeof(string), "%s%s - Ammo: %d\n", string, ReturnWeaponName(CarData[carid][carWeapons][i]), CarData[carid][carAmmo][i]);

		else
		    format(string, sizeof(string), "%s%s\n", string, (CarData[carid][carWeapons][i]) ? (ReturnWeaponName(CarData[carid][carWeapons][i])) : ("Empty Slot"));
	}
	Dialog_Show(playerid, Trunk, DIALOG_STYLE_LIST, "Car Trunk", string, "Select", "Cancel");
	return 1;
}

// ====== Car_ShowTrunk ======
Car_ShowTrunk(playerid, carid)
{
	static
	    string[MAX_CAR_STORAGE * 32],
		name[32];

	string[0] = 0;

	for (new i = 0; i != MAX_CAR_STORAGE; i ++)
	{
	    if (!CarStorage[carid][i][cItemExists])
	        format(string, sizeof(string), "%sEmpty Slot\n", string);

		else {
			strunpack(name, CarStorage[carid][i][cItemName]);

			if (CarStorage[carid][i][cItemQuantity] == 1) {
                format(string, sizeof(string), "%s%s\n", string, name);
			}
			else format(string, sizeof(string), "%s%s (%d)\n", string, name, CarStorage[carid][i][cItemQuantity]);
		}
	}
	strcat(string, "Weapon Storage");

	PlayerData[playerid][pStorageSelect] = 0;
	Dialog_Show(playerid, CarStorage, DIALOG_STYLE_LIST, "Car Storage", string, "Select", "Cancel");
	return 1;
}

// ====== Car_Create ======
Car_Create(ownerid, modelid, Float:x, Float:y, Float:z, Float:angle, color1, color2, type = 0)
{
    for (new i = 0; i != MAX_DYNAMIC_CARS; i ++)
	{
		if (!CarData[i][carExists])
   		{
   		    if (color1 == -1)
   		        color1 = random(127);

			if (color2 == -1)
			    color2 = random(127);

   		    CarData[i][carExists] = true;
            CarData[i][carModel] = modelid;
            CarData[i][carOwner] = ownerid;

            CarData[i][carPos][0] = x;
            CarData[i][carPos][1] = y;
            CarData[i][carPos][2] = z;
            CarData[i][carPos][3] = angle;

            CarData[i][carColor1] = color1;
            CarData[i][carColor2] = color2;
            CarData[i][carPaintjob] = -1;
            CarData[i][carLocked] = false;
            CarData[i][carImpounded] = -1;
            CarData[i][carImpoundPrice] = 0;
            CarData[i][carFaction] = type;

            for (new j = 0; j < 14; j ++)
			{
                if (j < 5)
				{
                    CarData[i][carWeapons][j] = 0;
                    CarData[i][carAmmo][j] = 0;
                }
                CarData[i][carMods][j] = 0;
            }
            CarData[i][carVehicle] = CreateVehicle(modelid, x, y, z, angle, color1, color2, -1);

            if (CarData[i][carVehicle] != INVALID_VEHICLE_ID) {
                ResetVehicle(CarData[i][carVehicle]);
            }
            mysql_tquery(g_iHandle, "INSERT INTO `cars` (`carModel`) VALUES(0)", "OnCarCreated", "d", i);
            return i;
		}
	}
	return -1;
}


// ====== Car_Save ======
Car_Save(carid)
{
	static
	    query[900];

	if (CarData[carid][carVehicle] != INVALID_VEHICLE_ID)
	{
	    for (new i = 0; i < 14; i ++) {
			CarData[carid][carMods][i] = GetVehicleComponentInSlot(CarData[carid][carVehicle], i);
	    }
	}
	format(query, sizeof(query), "UPDATE `cars` SET `carModel` = '%d', `carOwner` = '%d', `carPosX` = '%.4f', `carPosY` = '%.4f', `carPosZ` = '%.4f', `carPosR` = '%.4f', `carColor1` = '%d', `carColor2` = '%d', `carPaintjob` = '%d', `carLocked` = '%d'",
        CarData[carid][carModel],
        CarData[carid][carOwner],
        CarData[carid][carPos][0],
        CarData[carid][carPos][1],
        CarData[carid][carPos][2],
        CarData[carid][carPos][3],
        CarData[carid][carColor1],
        CarData[carid][carColor2],
        CarData[carid][carPaintjob],
        CarData[carid][carLocked]
	);
	format(query, sizeof(query), "%s, `carMod1` = '%d', `carMod2` = '%d', `carMod3` = '%d', `carMod4` = '%d', `carMod5` = '%d', `carMod6` = '%d', `carMod7` = '%d', `carMod8` = '%d', `carMod9` = '%d', `carMod10` = '%d', `carMod11` = '%d', `carMod12` = '%d', `carMod13` = '%d', `carMod14` = '%d'",
		query,
		CarData[carid][carMods][0],
		CarData[carid][carMods][1],
		CarData[carid][carMods][2],
		CarData[carid][carMods][3],
		CarData[carid][carMods][4],
		CarData[carid][carMods][5],
		CarData[carid][carMods][6],
		CarData[carid][carMods][7],
		CarData[carid][carMods][8],
		CarData[carid][carMods][9],
		CarData[carid][carMods][10],
		CarData[carid][carMods][11],
		CarData[carid][carMods][12],
		CarData[carid][carMods][13]
	);
	format(query, sizeof(query), "%s, `carImpounded` = '%d', `carImpoundPrice` = '%d', `carFaction` = '%d', `carWeapon1` = '%d', `carWeapon2` = '%d', `carWeapon3` = '%d', `carWeapon4` = '%d', `carWeapon5` = '%d', `carAmmo1` = '%d', `carAmmo2` = '%d', `carAmmo3` = '%d', `carAmmo4` = '%d', `carAmmo5` = '%d' WHERE `carID` = '%d'",
		query,
		CarData[carid][carImpounded],
		CarData[carid][carImpoundPrice],
		CarData[carid][carFaction],
		CarData[carid][carWeapons][0],
		CarData[carid][carWeapons][1],
		CarData[carid][carWeapons][2],
		CarData[carid][carWeapons][3],
		CarData[carid][carWeapons][4],
		CarData[carid][carAmmo][0],
		CarData[carid][carAmmo][1],
		CarData[carid][carAmmo][2],
		CarData[carid][carAmmo][3],
		CarData[carid][carAmmo][4],
		CarData[carid][carID]
	);
	return mysql_tquery(g_iHandle, query);
}

// ====== Car_Inside ======
Car_Inside(playerid)
{
	new carid;

	if (IsPlayerInAnyVehicle(playerid) && (carid = Car_GetID(GetPlayerVehicleID(playerid))) != -1)
	    return carid;

	return -1;
}
