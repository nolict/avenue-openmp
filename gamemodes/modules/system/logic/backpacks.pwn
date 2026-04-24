/*
    File: modules/system/logic/backpacks.pwn
    Purpose: Contains system gameplay logic and helper functions for backpacks.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== Backpack_Items ======
stock Backpack_Items(playerid, id)
{
 	if (id != -1 && BackpackData[id][backpackExists])
 	{
 	    new
	        string[MAX_BACKPACK_CAPACITY * 32],
			count = 0;

	    for (new i = 0; i < MAX_BACKPACK_ITEMS; i ++) if (BackpackItems[i][bItemExists] && BackpackItems[i][bItemBackpack] == id)
	    {
	        if (BackpackItems[i][bItemQuantity] == 1)
	            format(string, sizeof(string), "%s%s\n", string, BackpackItems[i][bItemName]);

			else format(string, sizeof(string), "%s%s (%d)\n", string, BackpackItems[i][bItemName], BackpackItems[i][bItemQuantity]);

			BackpackListed[playerid][count++] = i;
		}
		strcat(string, "Take Backpack");

		PlayerData[playerid][pBackpackLoot] = id;
		Dialog_Show(playerid, BackpackLoot, DIALOG_STYLE_LIST, DialogStyle_Title("Backpack"), string, "Select", "Cancel");
	}
	return 1;
}

// ====== Backpack_Open ======
stock Backpack_Open(playerid)
{
	new id = GetPlayerBackpack(playerid);

	if (id != -1)
	{
	    new
	        string[MAX_BACKPACK_CAPACITY * 32],
			count = 0;

		string = "Add Item\n";

	    for (new i = 0; i < MAX_BACKPACK_ITEMS; i ++) if (BackpackItems[i][bItemExists] && BackpackItems[i][bItemBackpack] == id)
	    {
	        if (BackpackItems[i][bItemQuantity] == 1)
	            format(string, sizeof(string), "%s%s\n", string, BackpackItems[i][bItemName]);

			else format(string, sizeof(string), "%s%s (%d)\n", string, BackpackItems[i][bItemName], BackpackItems[i][bItemQuantity]);

			BackpackListed[playerid][count++] = i;
		}
		Dialog_Show(playerid, Backpack, DIALOG_STYLE_LIST, DialogStyle_Title("My Backpack"), string, "Select", "Cancel");
	}
	return 1;
}

// ====== Backpack_GetItems ======
stock Backpack_GetItems(id)
{
	new count;

	for (new i = 0; i != MAX_BACKPACK_ITEMS; i ++) if (BackpackItems[i][bItemExists] && BackpackItems[i][bItemBackpack] == id) {
	    count++;
	}
	return count;
}

// ====== Backpack_GetFreeID ======
stock Backpack_GetFreeID()
{
	for (new i = 0; i != MAX_BACKPACKS; i ++) if (!BackpackData[i][backpackExists]) {
	    return i;
	}
	return -1;
}

// ====== Backpack_Refresh ======
stock Backpack_Refresh(id)
{
	if (id != -1 && BackpackData[id][backpackExists])
	{
	    if (IsValidDynamicObject(BackpackData[id][backpackObject]))
		    DestroyDynamicObject(BackpackData[id][backpackObject]);

		if (IsValidDynamic3DTextLabel(BackpackData[id][backpackText3D]))
		    DestroyDynamic3DTextLabel(BackpackData[id][backpackText3D]);

		if (!BackpackData[id][backpackPlayer]) {
	        BackpackData[id][backpackObject] = CreateDynamicObject(3026, BackpackData[id][backpackPos][0], BackpackData[id][backpackPos][1], BackpackData[id][backpackPos][2] - 0.8, -90.0, 0.0, 0.0, BackpackData[id][backpackWorld], BackpackData[id][backpackInterior]);
    	   	BackpackData[id][backpackText3D] = CreateDynamic3DTextLabel("[Backpack]\n{FFFFFF}Press 'N' to view the items.", COLOR_DARKBLUE, BackpackData[id][backpackPos][0], BackpackData[id][backpackPos][1], BackpackData[id][backpackPos][2] - 0.8, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, BackpackData[id][backpackWorld], BackpackData[id][backpackInterior]);
		}
	}
	return 1;
}

// ====== Backpack_GetItemID ======
stock Backpack_GetItemID(id, name[])
{
	for (new i = 0; i != MAX_BACKPACK_ITEMS; i ++) if (BackpackItems[i][bItemExists] && BackpackItems[i][bItemBackpack] == id && !strcmp(BackpackItems[i][bItemName], name, true)) {
	    return i;
	}
	return -1;
}

// ====== Backpack_GetFreeItem ======
stock Backpack_GetFreeItem()
{
	for (new i = 0; i != MAX_BACKPACK_ITEMS; i ++) if (!BackpackItems[i][bItemExists]) {
	    return i;
	}
	return -1;
}

// ====== Backpack_HasItem ======
stock Backpack_HasItem(id, name[])
{
	if (id != -1 && BackpackData[id][backpackExists])
		return Backpack_GetItemID(id, name) != -1;

	return 0;
}

// ====== Backpack_Count ======
stock Backpack_Count(id, name[])
{
	new itemid;

	if (id != -1 && BackpackData[id][backpackExists])
	{
		itemid = Backpack_GetItemID(id, name);

		if (itemid != -1)
		    return BackpackItems[itemid][bItemQuantity];
	}
	return 0;
}

// ====== Backpack_Add ======
stock Backpack_Add(id, name[], model, quantity = 1)
{
	new
	    query[128];

	if (id != -1 && BackpackData[id][backpackExists])
	{
	    new itemid = Backpack_GetItemID(id, name);

	    if (itemid != -1)
		{
	        format(query, sizeof(query), "UPDATE `backpackitems` SET `itemQuantity` = `itemQuantity` + %d WHERE `itemID` = '%d'", quantity, BackpackItems[itemid][bItemID]);
	        mysql_tquery(g_iHandle, query);

			return BackpackItems[itemid][bItemQuantity] += quantity;
		}
		else if ((itemid = Backpack_GetFreeItem()) != -1)
		{
		    format(BackpackItems[itemid][bItemName], 32, name);

		    BackpackItems[itemid][bItemBackpack] = id;
		    BackpackItems[itemid][bItemExists] = true;
		    BackpackItems[itemid][bItemModel] = model;
		    BackpackItems[itemid][bItemQuantity] = quantity;

	        format(query, sizeof(query), "INSERT INTO `backpackitems` (`ID`, `itemName`, `itemModel`, `itemQuantity`) VALUES('%d', '%s', '%d', '%d')", BackpackData[id][backpackID], name, model, quantity);
	        mysql_tquery(g_iHandle, query, "OnBackpackAdd", "dd", id, itemid);

	        return 1;
		}
	}
	return 0;
}

forward OnBackpackAdd(id, itemid);

// ====== OnBackpackAdd ======
public OnBackpackAdd(id, itemid)
{
    if (id == -1 || itemid == -1)
        return 0;

    BackpackItems[itemid][bItemID] = cache_insert_id(g_iHandle);
    return 1;
}

// ====== Backpack_Remove ======
stock Backpack_Remove(id, name[], quantity = 1)
{
	new
	    query[128];

	if (id != -1 && BackpackData[id][backpackExists])
	{
	    new itemid = Backpack_GetItemID(id, name);

	    if (itemid != -1)
		{
			if (BackpackItems[itemid][bItemQuantity] > 0)
			{
				BackpackItems[itemid][bItemQuantity] -= quantity;
			}
			if (BackpackItems[itemid][bItemQuantity] < 1)
			{
		        format(query, sizeof(query), "DELETE FROM `backpackitems` WHERE `itemID` = '%d'", BackpackItems[itemid][bItemID]);
		        mysql_tquery(g_iHandle, query);

			    BackpackItems[itemid][bItemBackpack] = -1;
			    BackpackItems[itemid][bItemExists] = false;
			    BackpackItems[itemid][bItemModel] = 0;
		    	BackpackItems[itemid][bItemQuantity] = 0;
		    }
			else
			{
                format(query, sizeof(query), "UPDATE `backpackitems` SET `itemQuantity` = `itemQuantity` - %d WHERE `itemID` = '%d'", quantity, BackpackItems[itemid][bItemID]);
		        mysql_tquery(g_iHandle, query);
			}
		    return 1;
		}
	}
	return 0;
}

// ====== GetHouseBackpack ======
stock GetHouseBackpack(houseid)
{
	for (new i = 0; i != MAX_BACKPACKS; i ++) if (BackpackData[i][backpackExists] && BackpackData[i][backpackHouse] == HouseData[houseid][houseID]) {
	    return i;
	}
	return -1;
}

// ====== GetVehicleBackpack ======
stock GetVehicleBackpack(carid)
{
	for (new i = 0; i != MAX_BACKPACKS; i ++) if (BackpackData[i][backpackExists] && BackpackData[i][backpackVehicle] == CarData[carid][carID]) {
	    return i;
	}
	return -1;
}

// ====== GetPlayerBackpack ======
stock GetPlayerBackpack(playerid)
{
	for (new i = 0; i != MAX_BACKPACKS; i ++) if (BackpackData[i][backpackExists] && BackpackData[i][backpackPlayer] == PlayerData[playerid][pID]) {
	    return i;
	}
	return -1;
}

// ====== Backpack_Create ======
stock Backpack_Create(playerid)
{
	new id = Backpack_GetFreeID();

	if (id != -1)
	{
		BackpackData[id][backpackExists] = true;
		BackpackData[id][backpackPlayer] = PlayerData[playerid][pID];
		BackpackData[id][backpackHouse] = 0;
		BackpackData[id][backpackVehicle] = 0;
		BackpackData[id][backpackPos][0] = 0.0;
		BackpackData[id][backpackPos][1] = 0.0;
		BackpackData[id][backpackPos][2] = 0.0;

		mysql_tquery(g_iHandle, "INSERT INTO `backpacks` (`backpackInterior`) VALUES(0)", "OnBackpackCreated", "d", id);
		return id;
	}
	return -1;
}

// ====== Backpack_Delete ======
stock Backpack_Delete(id)
{
	if (id != -1 && BackpackData[id][backpackExists])
	{
	    new
	        str[64];

		format(str, sizeof(str), "DELETE FROM `backpacks` WHERE `backpackID` = '%d'", BackpackData[id][backpackID]);
		mysql_tquery(g_iHandle, str);

		if (IsValidDynamicObject(BackpackData[id][backpackObject]))
		    DestroyDynamicObject(BackpackData[id][backpackObject]);

		if (IsValidDynamic3DTextLabel(BackpackData[id][backpackText3D]))
		    DestroyDynamic3DTextLabel(BackpackData[id][backpackText3D]);

        BackpackData[id][backpackExists] = false;
        BackpackData[id][backpackID] = 0;
        BackpackData[id][backpackPlayer] = 0;
        BackpackData[id][backpackHouse] = 0;
        BackpackData[id][backpackVehicle] = 0;
	}
	return 1;
}

// ====== Backpack_Save ======
stock Backpack_Save(id)
{
	new
	    query[256];

    format(query, sizeof(query), "UPDATE `backpacks` SET `backpackPlayer` = '%d', `backpackHouse` = '%d', `backpackVehicle` = '%d', `backpackX` = '%.4f', `backpackY` = '%.4f', `backpackZ` = '%.4f', `backpackInterior` = '%d', `backpackWorld` = '%d' WHERE `backpackID` = '%d'",
        BackpackData[id][backpackPlayer],
        BackpackData[id][backpackHouse],
        BackpackData[id][backpackVehicle],
        BackpackData[id][backpackPos][0],
        BackpackData[id][backpackPos][1],
        BackpackData[id][backpackPos][2],
        BackpackData[id][backpackInterior],
        BackpackData[id][backpackWorld],
        BackpackData[id][backpackID]
	);
	return mysql_tquery(g_iHandle, query);
}
// ====== Backpack_Load ======
forward Backpack_Load();

// ====== Backpack_Load ======
public Backpack_Load()
{
    static
	    rows,
	    fields,
		str[64];

	cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i < rows; i ++) if (i < MAX_BACKPACKS)
	{
	    BackpackData[i][backpackExists] = true;
	    BackpackData[i][backpackID] = cache_get_field_int(i, "backpackID");
	    BackpackData[i][backpackPlayer] = cache_get_field_int(i, "backpackPlayer");
	    BackpackData[i][backpackHouse] = cache_get_field_int(i, "backpackHouse");
	    BackpackData[i][backpackVehicle] = cache_get_field_int(i, "backpackVehicle");
	    BackpackData[i][backpackPos][0] = cache_get_field_float(i, "backpackX");
	    BackpackData[i][backpackPos][1] = cache_get_field_float(i, "backpackY");
	    BackpackData[i][backpackPos][2] = cache_get_field_float(i, "backpackZ");
	    BackpackData[i][backpackInterior] = cache_get_field_int(i, "backpackInterior");
	    BackpackData[i][backpackWorld] = cache_get_field_int(i, "backpackWorld");

	    if (!BackpackData[i][backpackPlayer]) {
	        Backpack_Refresh(i);
		}
	}
	for (new i = 0; i < MAX_BACKPACKS; i ++) if (BackpackData[i][backpackExists]) {
		format(str, sizeof(str), "SELECT * FROM `backpackitems` WHERE `ID` = '%d'", BackpackData[i][backpackID]);

		mysql_tquery(g_iHandle, str, "OnLoadBackpack", "d", i);
	}
	return 1;
}


// ====== OnLoadBackpack ======
forward OnLoadBackpack(id);

// ====== OnLoadBackpack ======
public OnLoadBackpack(id)
{
	static
	    rows,
	    fields,
		itemid = -1;

	cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i != rows; i ++) if ((itemid = Backpack_GetFreeItem()) != -1) {
		BackpackItems[itemid][bItemExists] = true;
		BackpackItems[itemid][bItemBackpack] = id;
		BackpackItems[itemid][bItemID] = cache_get_field_int(i, "itemID");
		BackpackItems[itemid][bItemModel] = cache_get_field_int(i, "itemModel");
		BackpackItems[itemid][bItemQuantity] = cache_get_field_int(i, "itemQuantity");

		cache_get_field_content(i, "itemName", BackpackItems[itemid][bItemName], g_iHandle, 32);
	}
	return 1;
}

// ====== House_Delete ======
House_Delete(houseid)
{
	if (houseid != -1 && HouseData[houseid][houseExists])
	{
	    new
	        string[64];

		format(string, sizeof(string), "DELETE FROM `houses` WHERE `houseID` = '%d'", HouseData[houseid][houseID]);
		mysql_tquery(g_iHandle, string);

        if (IsValidDynamic3DTextLabel(HouseData[houseid][houseText3D]))
		    DestroyDynamic3DTextLabel(HouseData[houseid][houseText3D]);

		if (IsValidDynamicPickup(HouseData[houseid][housePickup]))
		    DestroyDynamicPickup(HouseData[houseid][housePickup]);

		if (IsValidDynamicMapIcon(HouseData[houseid][houseMapIcon]))
		    DestroyDynamicMapIcon(HouseData[houseid][houseMapIcon]);

        for (new i = 0; i < MAX_BACKPACKS; i ++) if (BackpackData[i][backpackExists] && BackpackData[i][backpackHouse] == HouseData[houseid][houseID]) {
		    Backpack_Delete(i);
		}
		House_RemoveFurniture(houseid);
		House_RemoveAllItems(houseid);

	    HouseData[houseid][houseExists] = false;
	    HouseData[houseid][houseOwner] = 0;
	    HouseData[houseid][houseID] = 0;
	}
	return 1;
}

// ====== Car_Delete ======
Car_Delete(carid)
{
    if (carid != -1 && CarData[carid][carExists])
	{
	    new
	        string[64];

		format(string, sizeof(string), "DELETE FROM `cars` WHERE `carID` = '%d'", CarData[carid][carID]);
		mysql_tquery(g_iHandle, string);

		if (IsValidVehicle(CarData[carid][carVehicle]))
			DestroyVehicle(CarData[carid][carVehicle]);

		for (new i = 0; i < MAX_BACKPACKS; i ++) if (BackpackData[i][backpackExists] && BackpackData[i][backpackVehicle] == CarData[carid][carID]) {
		    Backpack_Delete(i);
		}
		Car_RemoveAllItems(carid);

        CarData[carid][carExists] = false;
	    CarData[carid][carID] = 0;
	    CarData[carid][carOwner] = 0;
	    CarData[carid][carVehicle] = 0;
	}
	return 1;
}
