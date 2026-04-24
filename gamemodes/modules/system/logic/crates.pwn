/*
    File: modules/system/logic/crates.pwn
    Purpose: Contains system gameplay logic and helper functions for crates.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== Crate_Load ======
forward Crate_Load();

// ====== Crate_Load ======
public Crate_Load()
{
	static
	    rows,
	    fields;

	cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i < rows; i ++) if (i < MAX_CRATES)
	{
	    CrateData[i][crateExists] = true;
	    CrateData[i][crateID] = cache_get_field_int(i, "crateID");
	    CrateData[i][crateType] = cache_get_field_int(i, "crateType");
	    CrateData[i][cratePos][0] = cache_get_field_float(i, "crateX");
	    CrateData[i][cratePos][1] = cache_get_field_float(i, "crateY");
	    CrateData[i][cratePos][2] = cache_get_field_float(i, "crateZ");
	    CrateData[i][cratePos][3] = cache_get_field_float(i, "crateA");
	    CrateData[i][crateInterior] = cache_get_field_int(i, "crateInterior");
	    CrateData[i][crateWorld] = cache_get_field_int(i, "crateWorld");
		CrateData[i][crateVehicle] = INVALID_VEHICLE_ID;

		Crate_Refresh(i);
	}
	return 1;
}

// ====== OpenCrate ======
forward OpenCrate(playerid, crateid);

// ====== OpenCrate ======
public OpenCrate(playerid, crateid)
{
	if (Crate_Nearest(playerid) != crateid || !CrateData[crateid][crateExists] || !IsPlayerSpawned(playerid) || !PlayerData[playerid][pOpeningCrate])
	    return 0;

    PlayerData[playerid][pOpeningCrate] = 0;

	ClearAnimations(playerid);
    TogglePlayerControllable(playerid, 1);

	if (Inventory_Items(playerid) >= MAX_INVENTORY - 4)
	    return SendErrorMessage(playerid, "You don't have any room in your inventory for 4 drug packages.");

	Inventory_Add(playerid, "Cocaine Seeds", 1575, 20);
	Inventory_Add(playerid, "Marijuana Seeds", 1578, 20);
	Inventory_Add(playerid, "Heroin Opium Seeds", 1577, 10);
	Inventory_Add(playerid, "Steroids", 1241, 5);

	Crate_Delete(crateid);
	SendServerMessage(playerid, "You have found an assortment of steroids and drug seeds (added to inventory).");
	return 1;
}

// ====== CraftParts ======
forward CraftParts(playerid, crateid);

// ====== CraftParts ======
public CraftParts(playerid, crateid)
{
	if (PlayerData[playerid][pCarryCrate] != crateid || !CrateData[crateid][crateExists] || !IsPlayerSpawned(playerid) || !PlayerData[playerid][pCrafting])
	    return 0;

    PlayerData[playerid][pCrafting] = 0;
	PlayerData[playerid][pCarryCrate] = -1;

    TogglePlayerControllable(playerid, 1);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

    RemovePlayerAttachedObject(playerid, 4);
    Log_Write("logs/craft_log.txt", "[%s] %s has crafted a %s crate.", ReturnDate(), ReturnName(playerid, 0), Crate_GetType(CrateData[crateid][crateType]));

	switch (CrateData[crateid][crateType])
	{
	    case 1:
	    {
	        if (Inventory_Items(playerid) >= MAX_INVENTORY - 4)
	            return SendErrorMessage(playerid, "You don't have any room in your inventory for 4 melee parts.");

			Inventory_Add(playerid, "Golf Club", 333);
			Inventory_Add(playerid, "Knife", 335);
			Inventory_Add(playerid, "Shovel", 337);
			Inventory_Add(playerid, "Katana", 339);

			Crate_Delete(crateid);
			SendServerMessage(playerid, "You have crafted 4 melee weapons (added to inventory).");
		}
	    case 2:
	    {
	        if (Inventory_Items(playerid) >= MAX_INVENTORY - 2)
	            return SendErrorMessage(playerid, "You don't have any room in your inventory for 2 pistols.");

			Inventory_Add(playerid, "Colt 45", 346);
			Inventory_Add(playerid, "Desert Eagle", 348);

			Crate_Delete(crateid);
			SendServerMessage(playerid, "You have crafted 2 pistols from pistol parts (added to inventory).");
		}
		case 3:
	    {
	        if (Inventory_Items(playerid) >= MAX_INVENTORY - 3)
	            return SendErrorMessage(playerid, "You don't have any room in your inventory for 3 SMG's.");

			Inventory_Add(playerid, "Micro SMG", 352);
			Inventory_Add(playerid, "Tec-9", 372);
			Inventory_Add(playerid, "MP5", 353);

			Crate_Delete(crateid);
			SendServerMessage(playerid, "You have crafted 3 SMG's from SMG parts (added to inventory).");
		}
		case 4:
	    {
	        if (Inventory_Items(playerid) >= MAX_INVENTORY - 2)
	            return SendErrorMessage(playerid, "You don't have any room in your inventory for 2 shotguns.");

			Inventory_Add(playerid, "Shotgun", 349);

			Crate_Delete(crateid);
			SendServerMessage(playerid, "You have crafted a shotgun from Shotgun parts (added to inventory).");
		}
		case 5:
	    {
	        if (Inventory_Items(playerid) >= MAX_INVENTORY - 3)
	            return SendErrorMessage(playerid, "You don't have any room in your inventory for 3 Rifles.");

			Inventory_Add(playerid, "AK-47", 355);
			Inventory_Add(playerid, "Rifle", 357);
			Inventory_Add(playerid, "Sniper", 358);

			Crate_Delete(crateid);
			SendServerMessage(playerid, "You have crafted 3 rifles from Rifle parts (added to inventory).");
		}
	}
	return 1;
}


// ====== Crate_Highest ======
Crate_Highest(crateid)
{
	new
		Float:height = -1.0,
		id = -1;

    for (new i = 0; i != MAX_CRATES; i ++) if (i != id && CrateData[i][crateExists] && CrateData[i][crateVehicle] == INVALID_VEHICLE_ID && CrateData[i][cratePos][0] == CrateData[crateid][cratePos][0] && CrateData[i][cratePos][1] == CrateData[crateid][cratePos][1] && CrateData[i][cratePos][2] > CrateData[crateid][cratePos][2] && !IsCrateInUse(crateid))
	{
	    if (CrateData[i][cratePos][2] > height)
	    {
	        height = CrateData[i][cratePos][2];
	        id = i;
		}
	}
	return id;
}

// ====== Crate_Nearest ======
Crate_Nearest(playerid, Float:radius = 2.5)
{
	if (PlayerData[playerid][pCarryCrate] != -1 && CrateData[PlayerData[playerid][pCarryCrate]][crateExists])
	    return PlayerData[playerid][pCarryCrate];

    for (new i = 0; i != MAX_CRATES; i ++) if (CrateData[i][crateExists] && IsPlayerInRangeOfPoint(playerid, radius, CrateData[i][cratePos][0], CrateData[i][cratePos][1], CrateData[i][cratePos][2]))
	{
		if (GetPlayerInterior(playerid) == CrateData[i][crateInterior] && GetPlayerVirtualWorld(playerid) == CrateData[i][crateWorld])
			return i;
	}
	return -1;
}

// ====== Crate_Refresh ======
Crate_Refresh(crateid)
{
	if (crateid != -1 && CrateData[crateid][crateExists])
	{
	    static
	        string[128];

		if (IsValidDynamicObject(CrateData[crateid][crateObject]))
		    DestroyDynamicObject(CrateData[crateid][crateObject]);

		if (IsValidDynamic3DTextLabel(CrateData[crateid][crateText3D]))
		    DestroyDynamic3DTextLabel(CrateData[crateid][crateText3D]);

		CrateData[crateid][crateObject] = CreateDynamicObject(964, CrateData[crateid][cratePos][0], CrateData[crateid][cratePos][1], CrateData[crateid][cratePos][2], 0.0, 0.0, CrateData[crateid][cratePos][3], CrateData[crateid][crateWorld], CrateData[crateid][crateInterior]);

		if (CrateData[crateid][crateType] != 6) {
			format(string, sizeof(string), "[Crate %d]\n{FFFFFF}%s Parts (press 'F' to pickup)", crateid, Crate_GetType(CrateData[crateid][crateType]));
		}
		else {
		    format(string, sizeof(string), "[Crate %d]\n{FFFFFF}Drug Seeds (press 'F' to pickup)", crateid);
		}
  		CrateData[crateid][crateText3D] = CreateDynamic3DTextLabel(string, COLOR_DARKBLUE, CrateData[crateid][cratePos][0], CrateData[crateid][cratePos][1], CrateData[crateid][cratePos][2] + 0.5, 10.0, INVALID_VEHICLE_ID, INVALID_PLAYER_ID, 0, CrateData[crateid][crateWorld], CrateData[crateid][crateInterior]);
	}
	return 1;
}

// ====== Crate_Delete ======
Crate_Delete(crateid)
{
	if (crateid != -1 && CrateData[crateid][crateExists])
	{
	    new
	        string[64];

		format(string, sizeof(string), "DELETE FROM `crates` WHERE `crateID` = '%d'", CrateData[crateid][crateID]);
		mysql_tquery(g_iHandle, string);

        if (IsValidDynamic3DTextLabel(CrateData[crateid][crateText3D]))
		    DestroyDynamic3DTextLabel(CrateData[crateid][crateText3D]);

		if (IsValidDynamicObject(CrateData[crateid][crateObject]))
		    DestroyDynamicObject(CrateData[crateid][crateObject]);

		foreach (new i : Player) if (PlayerData[i][pCarryCrate] == crateid) {
		    PlayerData[i][pCarryCrate] = -1;

		    RemovePlayerAttachedObject(i, 4);
		    SetPlayerSpecialAction(i, SPECIAL_ACTION_NONE);
		}
	    CrateData[crateid][crateExists] = false;
	    CrateData[crateid][crateID] = 0;
	    CrateData[crateid][crateVehicle] = INVALID_VEHICLE_ID;
	}
	return 1;
}

// ====== Crate_Drop ======
Crate_Drop(playerid, Float:radius = 0.0)
{
    static
		Float:x,
		Float:y,
		Float:z,
		Float:angle,
		id = -1;

	if ((id = PlayerData[playerid][pCarryCrate]) != -1 && CrateData[id][crateExists])
	{
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);

		if (radius != 0.0) {
		    x += radius * floatsin(-angle, degrees);
		    y += radius * floatcos(-angle, degrees);
		}
		CrateData[id][cratePos][0] = x;
		CrateData[id][cratePos][1] = y;
		CrateData[id][cratePos][2] = z - 0.9;
		CrateData[id][cratePos][3] = angle;
		CrateData[id][crateInterior] = GetPlayerInterior(playerid);
		CrateData[id][crateWorld] = GetPlayerVirtualWorld(playerid);

		Crate_Refresh(id);
		Crate_Save(id);
	}
	PlayerData[playerid][pCarryCrate] = -1;
	RemovePlayerAttachedObject(playerid, 4);
	return 1;
}

// ====== Crate_Save ======
Crate_Save(crateid)
{
	static
	    query[255];

	format(query, sizeof(query), "UPDATE `crates` SET `crateType` = '%d', `crateX` = '%.4f', `crateY` = '%.4f', `crateZ` = '%.4f', `crateA` = '%.4f', `crateInterior` = '%d', `crateWorld` = '%d' WHERE `crateID` = '%d'",
	    CrateData[crateid][crateType],
	    CrateData[crateid][cratePos][0],
	    CrateData[crateid][cratePos][1],
	    CrateData[crateid][cratePos][2],
	    CrateData[crateid][cratePos][3],
	    CrateData[crateid][crateInterior],
	    CrateData[crateid][crateWorld],
	    CrateData[crateid][crateID]
	);
	return mysql_tquery(g_iHandle, query);
}

// ====== Crate_GetType ======
Crate_GetType(type)
{
	static
	    str[24];

	switch (type) {
	    case 1: str = "Melee";
	    case 2: str = "Pistol";
	    case 3: str = "SMG";
	    case 4: str = "Shotgun";
	    case 5: str = "Rifle";
	    case 6: str = "Drug Seeds";
	    default: str = "None";
	}
	return str;
}

// ====== Crate_Create ======
Crate_Create(playerid, type)
{
	static
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:angle;

	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
	    for (new i = 0; i != MAX_CRATES; i ++) if (!CrateData[i][crateExists])
	    {
         	if (Crate_Nearest(playerid, 2.5) != -1) {
			 	z = floatsub(z, 0.1);
	        }
            CrateData[i][crateExists] = true;
            CrateData[i][crateVehicle] = INVALID_VEHICLE_ID;
            CrateData[i][crateType] = type;

			CrateData[i][cratePos][0] = x;
   			CrateData[i][cratePos][1] = y;
            CrateData[i][cratePos][2] = z - 0.9;
            CrateData[i][cratePos][3] = angle;

            CrateData[i][crateInterior] = GetPlayerInterior(playerid);
            CrateData[i][crateWorld] = GetPlayerVirtualWorld(playerid);

            mysql_tquery(g_iHandle, "INSERT INTO `crates` (`crateInterior`) VALUES(0)", "OnCrateCreated", "d", i);
            Crate_Refresh(i);
            return i;
		}
	}
	return -1;
}
