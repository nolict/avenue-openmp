/*
    File: modules/property/logic/storage.pwn
    Purpose: Contains property gameplay logic and helper functions for storage.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== House_WeaponStorage ======
stock House_WeaponStorage(playerid, houseid)
{
	if (houseid == -1 || !HouseData[houseid][houseExists])
	    return 0;

	static
	    string[320];

	string[0] = 0;

	for (new i = 0; i < 10; i ++)
	{
	    if (!HouseData[houseid][houseWeapons][i])
	        format(string, sizeof(string), "%sEmpty Slot\n", string);

		else
			format(string, sizeof(string), "%s%s (Ammo: %d)\n", string, ReturnWeaponName(HouseData[houseid][houseWeapons][i]), HouseData[houseid][houseAmmo][i]);
	}
	Dialog_Show(playerid, HouseWeapons, DIALOG_STYLE_LIST, "Weapon Storage", string, "Select", "Cancel");
	return 1;
}

// ====== House_ShowItems ======
stock House_ShowItems(playerid, houseid)
{
    if (houseid == -1 || !HouseData[houseid][houseExists])
	    return 0;

	static
	    string[MAX_HOUSE_STORAGE * 32],
		name[32];

	string[0] = 0;

	for (new i = 0; i != MAX_HOUSE_STORAGE; i ++)
	{
	    if (!HouseStorage[houseid][i][hItemExists])
	        format(string, sizeof(string), "%sEmpty Slot\n", string);

		else {
			strunpack(name, HouseStorage[houseid][i][hItemName]);

			if (HouseStorage[houseid][i][hItemQuantity] == 1) {
			    format(string, sizeof(string), "%s%s\n", string, name);
			}
			else format(string, sizeof(string), "%s%s (%d)\n", string, name, HouseStorage[houseid][i][hItemQuantity]);
		}
	}
	Dialog_Show(playerid, HouseItems, DIALOG_STYLE_LIST, "Item Storage", string, "Select", "Cancel");
	return 1;
}

// ====== House_OpenStorage ======
stock House_OpenStorage(playerid, houseid)
{
	if (houseid == -1 || !HouseData[houseid][houseExists])
	    return 0;

	new
		items[2],
		string[MAX_HOUSE_STORAGE * 32];

	for (new i = 0; i < MAX_HOUSE_STORAGE; i ++) if (HouseStorage[houseid][i][hItemExists]) {
	    items[0]++;
	}
	for (new i = 0; i < 10; i ++) if (HouseData[houseid][houseWeapons][i]) {
	    items[1]++;
	}
	if (!House_IsOwner(playerid, houseid))
	    format(string, sizeof(string), "Item Storage (%d/%d)\nWeapon Storage (%d/10)", items[0], MAX_HOUSE_STORAGE, items[1]);

	else
		format(string, sizeof(string), "Item Storage (%d/%d)\nWeapon Storage (%d/10)\nMoney Safe (%s)", items[0], MAX_HOUSE_STORAGE, items[1], FormatNumber(HouseData[houseid][houseMoney]));

	Dialog_Show(playerid, HouseStorage, DIALOG_STYLE_LIST, "House Storage", string, "Select", "Cancel");
	return 1;
}

// ====== House_GetItemID ======
stock House_GetItemID(houseid, item[])
{
	if (houseid == -1 || !HouseData[houseid][houseExists])
	    return 0;

	for (new i = 0; i < MAX_HOUSE_STORAGE; i ++)
	{
	    if (!HouseStorage[houseid][i][hItemExists])
	        continue;

		if (!strcmp(HouseStorage[houseid][i][hItemName], item)) return i;
	}
	return -1;
}

// ====== House_GetFreeID ======
stock House_GetFreeID(houseid)
{
	if (houseid == -1 || !HouseData[houseid][houseExists])
	    return 0;

	for (new i = 0; i < MAX_HOUSE_STORAGE; i ++)
	{
	    if (!HouseStorage[houseid][i][hItemExists])
	        return i;
	}
	return -1;
}

// ====== House_AddItem ======
stock House_AddItem(houseid, item[], model, quantity = 1, slotid = -1)
{
    if (houseid == -1 || !HouseData[houseid][houseExists])
	    return 0;

	new
		itemid = House_GetItemID(houseid, item),
		string[128];

	if (itemid == -1)
	{
	    itemid = House_GetFreeID(houseid);

	    if (itemid != -1)
	    {
	        if (slotid != -1)
	            itemid = slotid;

	        HouseStorage[houseid][itemid][hItemExists] = true;
	        HouseStorage[houseid][itemid][hItemModel] = model;
	        HouseStorage[houseid][itemid][hItemQuantity] = quantity;

	        strpack(HouseStorage[houseid][itemid][hItemName], item, 32 char);

			format(string, sizeof(string), "INSERT INTO `housestorage` (`ID`, `itemName`, `itemModel`, `itemQuantity`) VALUES('%d', '%s', '%d', '%d')", HouseData[houseid][houseID], item, model, quantity);
			mysql_tquery(g_iHandle, string, "OnStorageAdd", "dd", houseid, itemid);

	        return itemid;
		}
		return -1;
	}
	else
	{
	    format(string, sizeof(string), "UPDATE `housestorage` SET `itemQuantity` = `itemQuantity` + %d WHERE `ID` = '%d' AND `itemID` = '%d'", quantity, HouseData[houseid][houseID], HouseStorage[houseid][itemid][hItemID]);
	    mysql_tquery(g_iHandle, string);

	    HouseStorage[houseid][itemid][hItemQuantity] += quantity;
	}
	return itemid;
}

// ====== House_RemoveItem ======
stock House_RemoveItem(houseid, item[], quantity = 1)
{
    if (houseid == -1 || !HouseData[houseid][houseExists])
	    return 0;

	new
		itemid = House_GetItemID(houseid, item),
		string[128];

	if (itemid != -1)
	{
	    if (HouseStorage[houseid][itemid][hItemQuantity] > 0)
	    {
	        HouseStorage[houseid][itemid][hItemQuantity] -= quantity;
		}
		if (quantity == -1 || HouseStorage[houseid][itemid][hItemQuantity] < 1)
		{
		    HouseStorage[houseid][itemid][hItemExists] = false;
		    HouseStorage[houseid][itemid][hItemModel] = 0;
		    HouseStorage[houseid][itemid][hItemQuantity] = 0;

		    format(string, sizeof(string), "DELETE FROM `housestorage` WHERE `ID` = '%d' AND `itemID` = '%d'", HouseData[houseid][houseID], HouseStorage[houseid][itemid][hItemID]);
	        mysql_tquery(g_iHandle, string);
		}
		else if (quantity != -1 && HouseStorage[houseid][itemid][hItemQuantity] > 0)
		{
			format(string, sizeof(string), "UPDATE `housestorage` SET `itemQuantity` = `itemQuantity` - %d WHERE `ID` = '%d' AND `itemID` = '%d'", quantity, HouseData[houseid][houseID], HouseStorage[houseid][itemid][hItemID]);
            mysql_tquery(g_iHandle, string);
		}
		return 1;
	}
	return 0;
}

House_RemoveAllItems(houseid)
{
	static
	    query[64];

	for (new i = 0; i != MAX_HOUSE_STORAGE; i ++) {
        HouseStorage[houseid][i][hItemExists] = false;
        HouseStorage[houseid][i][hItemModel] = 0;
        HouseStorage[houseid][i][hItemQuantity] = 0;
	}
	format(query, 64, "DELETE FROM `housestorage` WHERE `ID` = '%d'", HouseData[houseid][houseID]);
	mysql_tquery(g_iHandle, query);

	for (new i = 0; i < 10; i ++) {
	    HouseData[houseid][houseWeapons][i] = 0;
	    HouseData[houseid][houseAmmo][i] = 0;
	}
	return 1;
}

