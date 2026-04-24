/*
    File: modules/system/logic/inventory.pwn
    Purpose: Contains system gameplay logic and helper functions for inventory.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

forward OpenInventory(playerid);

// ====== OpenInventory ======
public OpenInventory(playerid)
{
    if (!IsPlayerConnected(playerid) || !PlayerData[playerid][pCharacter])
	    return 0;

	static
	    items[MAX_INVENTORY],
		amounts[MAX_INVENTORY];

    for (new i = 0; i < PlayerData[playerid][pCapacity]; i ++)
	{
 		if (InventoryData[playerid][i][invExists]) {
   			items[i] = InventoryData[playerid][i][invModel];
   			amounts[i] = InventoryData[playerid][i][invQuantity];
		}
		else {
		    items[i] = -1;
		    amounts[i] = -1;
		}
	}
	PlayerData[playerid][pStorageSelect] = 0;
	return ShowModelSelectionMenu(playerid, "Inventory", MODEL_SELECTION_INVENTORY, items, sizeof(items), 0.0, 0.0, 0.0, 1.0, -1, true, amounts);
}


// ====== Inventory_Clear ======
stock Inventory_Clear(playerid)
{
	static
	    string[64];

	for (new i = 0; i < MAX_INVENTORY; i ++)
	{
	    if (InventoryData[playerid][i][invExists])
	    {
	        InventoryData[playerid][i][invExists] = 0;
	        InventoryData[playerid][i][invModel] = 0;
	        InventoryData[playerid][i][invQuantity] = 0;
		}
	}
	format(string, sizeof(string), "DELETE FROM `inventory` WHERE `ID` = '%d'", PlayerData[playerid][pID]);
	return mysql_tquery(g_iHandle, string);
}

// ====== Inventory_Set ======
stock Inventory_Set(playerid, item[], model, amount)
{
	new itemid = Inventory_GetItemID(playerid, item);

	if (itemid == -1 && amount > 0)
		Inventory_Add(playerid, item, model, amount);

	else if (amount > 0 && itemid != -1)
	    Inventory_SetQuantity(playerid, item, amount);

	else if (amount < 1 && itemid != -1)
	    Inventory_Remove(playerid, item, -1);

	return 1;
}

// ====== Inventory_GetItemID ======
stock Inventory_GetItemID(playerid, item[])
{
	for (new i = 0; i < MAX_INVENTORY; i ++)
	{
	    if (!InventoryData[playerid][i][invExists])
	        continue;

		if (!strcmp(InventoryData[playerid][i][invItem], item)) return i;
	}
	return -1;
}

// ====== Inventory_GetFreeID ======
stock Inventory_GetFreeID(playerid)
{
	if (Inventory_Items(playerid) >= PlayerData[playerid][pCapacity])
		return -1;

	for (new i = 0; i < MAX_INVENTORY; i ++)
	{
	    if (!InventoryData[playerid][i][invExists])
	        return i;
	}
	return -1;
}

// ====== Inventory_Items ======
stock Inventory_Items(playerid)
{
    new count;

    for (new i = 0; i != MAX_INVENTORY; i ++) if (InventoryData[playerid][i][invExists]) {
        count++;
	}
	return count;
}

// ====== Inventory_Count ======
stock Inventory_Count(playerid, item[])
{
	new itemid = Inventory_GetItemID(playerid, item);

	if (itemid != -1)
	    return InventoryData[playerid][itemid][invQuantity];

	return 0;
}

// ====== Inventory_HasItem ======
stock Inventory_HasItem(playerid, item[])
{
	return (Inventory_GetItemID(playerid, item) != -1);
}

// ====== Inventory_SetQuantity ======
stock Inventory_SetQuantity(playerid, item[], quantity)
{
	new
	    itemid = Inventory_GetItemID(playerid, item),
	    string[128];

	if (itemid != -1)
	{
	    format(string, sizeof(string), "UPDATE `inventory` SET `invQuantity` = %d WHERE `ID` = '%d' AND `invID` = '%d'", quantity, PlayerData[playerid][pID], InventoryData[playerid][itemid][invID]);
	    mysql_tquery(g_iHandle, string);

	    InventoryData[playerid][itemid][invQuantity] = quantity;
	}
	return 1;
}

// ====== Inventory_Add ======
stock Inventory_Add(playerid, item[], model, quantity = 1)
{
	new
		itemid = Inventory_GetItemID(playerid, item),
		string[128];

	if (itemid == -1)
	{
	    itemid = Inventory_GetFreeID(playerid);

	    if (itemid != -1)
	    {
	        InventoryData[playerid][itemid][invExists] = true;
	        InventoryData[playerid][itemid][invModel] = model;
	        InventoryData[playerid][itemid][invQuantity] = quantity;

	        strpack(InventoryData[playerid][itemid][invItem], item, 32 char);

			if (strcmp(item, "Demo Soda") != 0)
			{
				format(string, sizeof(string), "INSERT INTO `inventory` (`ID`, `invItem`, `invModel`, `invQuantity`) VALUES('%d', '%s', '%d', '%d')", PlayerData[playerid][pID], item, model, quantity);
				mysql_tquery(g_iHandle, string, "OnInventoryAdd", "dd", playerid, itemid);
			}
	        return itemid;
		}
		return -1;
	}
	else
	{
	    format(string, sizeof(string), "UPDATE `inventory` SET `invQuantity` = `invQuantity` + %d WHERE `ID` = '%d' AND `invID` = '%d'", quantity, PlayerData[playerid][pID], InventoryData[playerid][itemid][invID]);
	    mysql_tquery(g_iHandle, string);

	    InventoryData[playerid][itemid][invQuantity] += quantity;
	}
	return itemid;
}

// ====== Inventory_Remove ======
stock Inventory_Remove(playerid, item[], quantity = 1)
{
	new
		itemid = Inventory_GetItemID(playerid, item),
		string[128];

	if (itemid != -1)
	{
	    if (InventoryData[playerid][itemid][invQuantity] > 0)
	    {
	        InventoryData[playerid][itemid][invQuantity] -= quantity;
		}
		if (quantity == -1 || InventoryData[playerid][itemid][invQuantity] < 1)
		{
		    InventoryData[playerid][itemid][invExists] = false;
		    InventoryData[playerid][itemid][invModel] = 0;
		    InventoryData[playerid][itemid][invQuantity] = 0;

		    format(string, sizeof(string), "DELETE FROM `inventory` WHERE `ID` = '%d' AND `invID` = '%d'", PlayerData[playerid][pID], InventoryData[playerid][itemid][invID]);
	        mysql_tquery(g_iHandle, string);
		}
		else if (quantity != -1 && InventoryData[playerid][itemid][invQuantity] > 0)
		{
			format(string, sizeof(string), "UPDATE `inventory` SET `invQuantity` = `invQuantity` - %d WHERE `ID` = '%d' AND `invID` = '%d'", quantity, PlayerData[playerid][pID], InventoryData[playerid][itemid][invID]);
            mysql_tquery(g_iHandle, string);
		}
		return 1;
	}
	return 0;
}

