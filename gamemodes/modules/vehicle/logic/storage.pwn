/*
    File: modules/vehicle/logic/storage.pwn
    Purpose: Contains vehicle gameplay logic and helper functions for storage.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== Car_GetItemID ======
stock Car_GetItemID(carid, item[])
{
	if (carid == -1 || !CarData[carid][carExists])
	    return 0;

	for (new i = 0; i < MAX_CAR_STORAGE; i ++)
	{
	    if (!CarStorage[carid][i][cItemExists])
	        continue;

		if (!strcmp(CarStorage[carid][i][cItemName], item)) return i;
	}
	return -1;
}

// ====== Car_GetFreeID ======
stock Car_GetFreeID(carid)
{
	if (carid == -1 || !CarData[carid][carExists])
	    return 0;

	for (new i = 0; i < MAX_CAR_STORAGE; i ++)
	{
	    if (!CarStorage[carid][i][cItemExists])
	        return i;
	}
	return -1;
}

// ====== Car_AddItem ======
stock Car_AddItem(carid, item[], model, quantity = 1, slotid = -1)
{
    if (carid == -1 || !CarData[carid][carExists])
	    return 0;

	new
		itemid = Car_GetItemID(carid, item),
		string[128];

	if (itemid == -1)
	{
	    itemid = Car_GetFreeID(carid);

	    if (itemid != -1)
	    {
	        if (slotid != -1)
	            itemid = slotid;

	        CarStorage[carid][itemid][cItemExists] = true;
	        CarStorage[carid][itemid][cItemModel] = model;
	        CarStorage[carid][itemid][cItemQuantity] = quantity;

	        strpack(CarStorage[carid][itemid][cItemName], item, 32 char);

			format(string, sizeof(string), "INSERT INTO `carstorage` (`ID`, `itemName`, `itemModel`, `itemQuantity`) VALUES('%d', '%s', '%d', '%d')", CarData[carid][carID], item, model, quantity);
			mysql_tquery(g_iHandle, string, "OnCarStorageAdd", "dd", carid, itemid);

	        return itemid;
		}
		return -1;
	}
	else
	{
	    format(string, sizeof(string), "UPDATE `carstorage` SET `itemQuantity` = `itemQuantity` + %d WHERE `ID` = '%d' AND `itemID` = '%d'", quantity, CarData[carid][carID], CarStorage[carid][itemid][cItemID]);
	    mysql_tquery(g_iHandle, string);

	    CarStorage[carid][itemid][cItemQuantity] += quantity;
	}
	return itemid;
}

// ====== Car_RemoveItem ======
stock Car_RemoveItem(carid, item[], quantity = 1)
{
    if (carid == -1 || !CarData[carid][carExists])
	    return 0;

	new
		itemid = Car_GetItemID(carid, item),
		string[128];

	if (itemid != -1)
	{
	    if (CarStorage[carid][itemid][cItemQuantity] > 0)
	    {
	        CarStorage[carid][itemid][cItemQuantity] -= quantity;
		}
		if (quantity == -1 || CarStorage[carid][itemid][cItemQuantity] < 1)
		{
		    CarStorage[carid][itemid][cItemExists] = false;
		    CarStorage[carid][itemid][cItemModel] = 0;
		    CarStorage[carid][itemid][cItemQuantity] = 0;

		    format(string, sizeof(string), "DELETE FROM `carstorage` WHERE `ID` = '%d' AND `itemID` = '%d'", CarData[carid][carID], CarStorage[carid][itemid][cItemID]);
	        mysql_tquery(g_iHandle, string);
		}
		else if (quantity != -1 && CarStorage[carid][itemid][cItemQuantity] > 0)
		{
			format(string, sizeof(string), "UPDATE `carstorage` SET `itemQuantity` = `itemQuantity` - %d WHERE `ID` = '%d' AND `itemID` = '%d'", quantity, CarData[carid][carID], CarStorage[carid][itemid][cItemID]);
            mysql_tquery(g_iHandle, string);
		}
		return 1;
	}
	return 0;
}

Car_RemoveAllItems(carid)
{
	static
	    query[64];

	for (new i = 0; i != MAX_CAR_STORAGE; i ++) {
        CarStorage[carid][i][cItemExists] = false;
        CarStorage[carid][i][cItemModel] = 0;
        CarStorage[carid][i][cItemQuantity] = 0;
	}
	format(query, 64, "DELETE FROM `carstorage` WHERE `ID` = '%d'", CarData[carid][carID]);
	mysql_tquery(g_iHandle, query);

	for (new i = 0; i < 5; i ++) {
	    CarData[carid][carWeapons][i] = 0;
	    CarData[carid][carAmmo][i] = 0;
	}
	return 1;
}

