/*
    File: modules/vehicle/dialogs/storage.pwn
    Purpose: Contains easyDialog callbacks for vehicle storage flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:CarDeposit ======
Dialog:CarDeposit(playerid, response, listitem, inputtext[])
{
	static
	    carid = -1,
	    string[32];

    if ((carid = Car_Nearest(playerid)) != -1 && !CarData[carid][carLocked])
	{
	    strunpack(string, InventoryData[playerid][PlayerData[playerid][pInventoryItem]][invItem]);

		if (response)
		{
			new amount = strval(inputtext);

			if (amount < 1 || amount > InventoryData[playerid][PlayerData[playerid][pInventoryItem]][invQuantity])
			    return Dialog_Show(playerid, CarDeposit, DIALOG_STYLE_INPUT, "Car Deposit", "Item: %s (Quantity: %d)\n\nPlease enter the quantity that you wish to store for this item:", "Store", "Back", string, InventoryData[playerid][PlayerData[playerid][pInventoryItem]][invQuantity]);

			Car_AddItem(carid, string, InventoryData[playerid][PlayerData[playerid][pInventoryItem]][invModel], amount);
			Inventory_Remove(playerid, string, amount);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stored a \"%s\" into the trunk.", ReturnName(playerid, 0), string);
			Car_ShowTrunk(playerid, carid);
		}
		else Car_ShowTrunk(playerid, carid);
	}
	return 1;
}

// ====== Dialog:CarTake ======
Dialog:CarTake(playerid, response, listitem, inputtext[])
{
	static
	    carid = -1,
	    string[32];

    if ((carid = Car_Nearest(playerid)) != -1 && !CarData[carid][carLocked])
	{
	    strunpack(string, CarStorage[carid][PlayerData[playerid][pStorageItem]][cItemName]);

		if (response)
		{
			new amount = strval(inputtext);

			if (amount < 1 || amount > CarStorage[carid][PlayerData[playerid][pStorageItem]][cItemQuantity])
			    return Dialog_Show(playerid, CarTake, DIALOG_STYLE_INPUT, "Car Take", "Item: %s (Quantity: %d)\n\nPlease enter the quantity that you wish to take for this item:", "Take", "Back", string, CarStorage[carid][PlayerData[playerid][pInventoryItem]][cItemQuantity]);

			new id = Inventory_Add(playerid, string, CarStorage[carid][PlayerData[playerid][pStorageItem]][cItemModel], amount);

			if (id == -1)
				return SendErrorMessage(playerid, "You don't have any inventory slots left.");

			Car_RemoveItem(carid, string, amount);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has taken a \"%s\" from the trunk.", ReturnName(playerid, 0), string);
			Car_ShowTrunk(playerid, carid);
		}
		else Car_ShowTrunk(playerid, carid);
	}
	return 1;
}

// ====== Dialog:CarStorage ======
Dialog:CarStorage(playerid, response, listitem, inputtext[])
{
	static
	    carid = -1,
		string[64];

	if ((carid = Car_Nearest(playerid)) != -1 && !CarData[carid][carLocked])
	{
		if (response)
		{
		    if (listitem == MAX_CAR_STORAGE) {
    			Car_WeaponStorage(playerid, carid);
		    }
		    else if (CarStorage[carid][listitem][cItemExists])
			{
   				PlayerData[playerid][pStorageItem] = listitem;
   				PlayerData[playerid][pInventoryItem] = listitem;

				strunpack(string, CarStorage[carid][listitem][cItemName]);

				format(string, sizeof(string), "%s (Quantity: %d)", string, CarStorage[carid][listitem][cItemQuantity]);
				Dialog_Show(playerid, TrunkOptions, DIALOG_STYLE_LIST, string, "Take Item\nStore Item", "Select", "Back");
			}
			else {
   				OpenInventory(playerid);

				PlayerData[playerid][pStorageSelect] = 2;
			}
		}
	}
	return 1;
}

// ====== Dialog:TrunkOptions ======
Dialog:TrunkOptions(playerid, response, listitem, inputtext[])
{
    static
	    carid = -1,
		itemid = -1,
		backpack = -1,
		string[32];

	if ((carid = Car_Nearest(playerid)) != -1 && !CarData[carid][carLocked])
	{
	    itemid = PlayerData[playerid][pStorageItem];

	    strunpack(string, CarStorage[carid][itemid][cItemName]);

		if (response)
		{
			switch (listitem)
			{
			    case 0:
			    {
			        if (CarStorage[carid][itemid][cItemQuantity] == 1)
			        {
			            if (!strcmp(string, "Backpack") && Inventory_HasItem(playerid, "Backpack"))
			                return SendErrorMessage(playerid, "You already have a backpack in your inventory.");

			            new id = Inventory_Add(playerid, string, CarStorage[carid][itemid][cItemModel], 1);

						if (id == -1)
        					return SendErrorMessage(playerid, "You don't have any inventory slots left.");

                        if (!strcmp(string, "Backpack") && (backpack = GetVehicleBackpack(carid)) != -1)
						{
						    BackpackData[backpack][backpackVehicle] = 0;
						    BackpackData[backpack][backpackPlayer] = PlayerData[playerid][pID];

						    Backpack_Save(backpack);
						    SetAccessories(playerid);
						}
			            Car_RemoveItem(carid, string);

			            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has taken a \"%s\" from the trunk.", ReturnName(playerid, 0), string);
						Car_ShowTrunk(playerid, carid);
			        }
			        else
			        {
			            Dialog_Show(playerid, CarTake, DIALOG_STYLE_INPUT, "Car Take", "Item: %s (Quantity: %d)\n\nPlease enter the quantity that you wish to take for this item:", "Take", "Back", string, CarStorage[carid][itemid][cItemQuantity]);
			        }
			    }
				case 1:
				{
					new id = Inventory_GetItemID(playerid, string);

					if (!strcmp(string, "Backpack")) {
					    Car_ShowTrunk(playerid, carid);

						return SendErrorMessage(playerid, "You can only store one backpack in your trunk.");
					}
					else if (id == -1) {
						Car_ShowTrunk(playerid, carid);

						return SendErrorMessage(playerid, "You don't have anymore of this item to store!");
					}
					else if (InventoryData[playerid][id][invQuantity] == 1)
					{
					    Car_AddItem(carid, string, InventoryData[playerid][id][invModel], 1);
						Inventory_Remove(playerid, string);

						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stored a \"%s\" into the trunk.", ReturnName(playerid, 0), string);
						Car_ShowTrunk(playerid, carid);
					}
					else if (InventoryData[playerid][id][invQuantity] > 1) {
					    PlayerData[playerid][pInventoryItem] = id;

                        Dialog_Show(playerid, CarDeposit, DIALOG_STYLE_INPUT, "Car Deposit", "Item: %s (Quantity: %d)\n\nPlease enter the quantity that you wish to store for this item:", "Store", "Back", string, InventoryData[playerid][id][invQuantity]);
					}
				}
			}
		}
		else
		{
		    Car_ShowTrunk(playerid, carid);
		}
	}
	return 1;
}

