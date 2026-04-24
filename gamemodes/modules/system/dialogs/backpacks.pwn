/*
    File: modules/system/dialogs/backpacks.pwn
    Purpose: Contains easyDialog callbacks for system backpacks flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:BackpackLoot ======
Dialog:BackpackLoot(playerid, response, listitem, inputtext[])
{
	static id = -1;

	if (response)
	{
	    if (!strcmp(inputtext, "Take Backpack"))
	    {
	        if (Inventory_HasItem(playerid, "Backpack"))
	            return SendErrorMessage(playerid, "You can only have one backpack.");

	        id = PlayerData[playerid][pBackpackLoot];

	        BackpackData[id][backpackPlayer] = PlayerData[playerid][pID];
	        BackpackData[id][backpackPos][0] = 0.0;
	        BackpackData[id][backpackPos][1] = 0.0;
	        BackpackData[id][backpackPos][2] = 0.0;

	        DestroyDynamic3DTextLabel(BackpackData[id][backpackText3D]);
	        DestroyDynamicObject(BackpackData[id][backpackObject]);

			Backpack_Save(id);
			Inventory_Add(playerid, "Backpack", 3026);

			SetAccessories(playerid);
	        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has picked up a backpack.", ReturnName(playerid, 0));
		}
		else if ((id = BackpackListed[playerid][listitem]) != -1)
		{
			new
			    string[32];

			strcat(string, BackpackItems[id][bItemName]);

			Inventory_Add(playerid, string, BackpackItems[id][bItemModel], BackpackItems[id][bItemQuantity]);
			Backpack_Remove(BackpackItems[id][bItemBackpack], string, BackpackItems[id][bItemQuantity]);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the backpack and takes a \"%s\".", ReturnName(playerid, 0), string);
		}
	}
	return 1;
}

// ====== Dialog:BackpackDeposit ======
Dialog:BackpackDeposit(playerid, response, listitem, inputtext[])
{
	static
	    string[32];

	strunpack(string, InventoryData[playerid][PlayerData[playerid][pInventoryItem]][invItem]);

	if (response)
	{
		new amount = strval(inputtext);

		if (amount < 1 || amount > InventoryData[playerid][PlayerData[playerid][pInventoryItem]][invQuantity])
		    return Dialog_Show(playerid, BackpackDeposit, DIALOG_STYLE_INPUT, DialogStyle_Title("Backpack Deposit"), DialogStyle_Body("Item: %s (Quantity: %d)\n\nPlease enter the quantity that you wish to store for this item:"), "Store", "Back", string, InventoryData[playerid][PlayerData[playerid][pInventoryItem]][invQuantity]);

		Backpack_Add(GetPlayerBackpack(playerid), string, InventoryData[playerid][PlayerData[playerid][pInventoryItem]][invModel], amount);
		Inventory_Remove(playerid, string, amount);

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stored a \"%s\" into their backpack.", ReturnName(playerid, 0), string);
		Backpack_Open(playerid);
	}
	else Backpack_Open(playerid);
	return 1;
}

// ====== Dialog:BackpackTake ======
Dialog:BackpackTake(playerid, response, listitem, inputtext[])
{
	static
	    string[32],
		id = -1;

	if (response)
	{
		new amount = strval(inputtext);

		id = PlayerData[playerid][pStorageItem];

		strunpack(string, BackpackItems[id][bItemName]);

		if (amount < 1 || amount > BackpackItems[id][bItemQuantity])
		    return Dialog_Show(playerid, BackpackTake, DIALOG_STYLE_INPUT, DialogStyle_Title("Backpack Take"), DialogStyle_Body("Item: %s (Quantity: %d)\n\nPlease enter the quantity that you wish to take for this item:"), "Take", "Back", string, BackpackItems[id][bItemQuantity]);

		Inventory_Add(playerid, string, BackpackItems[id][bItemModel], amount);
        Backpack_Remove(GetPlayerBackpack(playerid), string, amount);

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has taken a \"%s\" from their backpack.", ReturnName(playerid, 0), string);
		Backpack_Open(playerid);
	}
	else Backpack_Open(playerid);
	return 1;
}

// ====== Dialog:BackpackOptions ======
Dialog:BackpackOptions(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new id = PlayerData[playerid][pStorageItem], string[32];

	    switch (listitem)
	    {
	        case 0:
	        {
	            strcat(string, BackpackItems[id][bItemName]);

	            if (BackpackItems[id][bItemQuantity] == 1)
	            {
	                Inventory_Add(playerid, string, BackpackItems[id][bItemModel]);
					Backpack_Remove(GetPlayerBackpack(playerid), string);

					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has taken a \"%s\" from their backpack.", ReturnName(playerid, 0), string);
					Backpack_Open(playerid);
	            }
	            else
	            {
	                Dialog_Show(playerid, BackpackTake, DIALOG_STYLE_INPUT, DialogStyle_Title("Backpack Take"), DialogStyle_Body("Item: %s (Quantity: %d)\n\nPlease enter the quantity that you wish to take for this item:"), "Take", "Back", string, BackpackItems[id][bItemQuantity]);
	            }
			}
	        case 1:
	        {
	            new itemid = Inventory_GetItemID(playerid, BackpackItems[id][bItemName]);

	            if (itemid == -1)
					return SendErrorMessage(playerid, "You don't have anymore of this item to store!");

                strunpack(string, InventoryData[playerid][itemid][invItem]);

				if (IsFurnitureItem(string))
				    return SendErrorMessage(playerid, "You can't store furniture in your backpack.");

				if (InventoryData[playerid][itemid][invQuantity] == 1)
	            {
	                Backpack_Add(GetPlayerBackpack(playerid), string, InventoryData[playerid][itemid][invModel]);
					Inventory_Remove(playerid, string);

					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stored a \"%s\" into their backpack.", ReturnName(playerid, 0), string);
					Backpack_Open(playerid);
	            }
	            else
	            {
	                PlayerData[playerid][pInventoryItem] = itemid;
	                Dialog_Show(playerid, BackpackDeposit, DIALOG_STYLE_INPUT, DialogStyle_Title("Backpack Deposit"), DialogStyle_Body("Item: %s (Quantity: %d)\n\nPlease enter the quantity that you wish to store for this item:"), "Store", "Back", string, InventoryData[playerid][PlayerData[playerid][pInventoryItem]][invQuantity]);
	            }
			}
   		}
	}
	else Backpack_Open(playerid);
	return 1;
}

// ====== Dialog:Backpack ======
Dialog:Backpack(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new id = -1, string[48];

	    if (!listitem)
		{
	        if (Backpack_GetItems(GetPlayerBackpack(playerid)) >= MAX_BACKPACK_CAPACITY)
	            return SendErrorMessage(playerid, "The backpack has reached it's capacity of %d items.", MAX_BACKPACK_CAPACITY);

	        OpenInventory(playerid);

	        PlayerData[playerid][pStorageSelect] = 3;
	    }
	    else if ((id = BackpackListed[playerid][listitem-1]) != -1) {
	        PlayerData[playerid][pStorageItem] = id;

			format(string, sizeof(string), "%s (Quantity: %d)", BackpackItems[id][bItemName], BackpackItems[id][bItemQuantity]);
	        Dialog_Show(playerid, BackpackOptions, DIALOG_STYLE_LIST, DialogStyle_Title(string), DialogStyle_Body("Take Item\nStore Item\nDrop Item"), "Select", "Back");
		}
	}
	return 1;
}

