/*
    File: modules/property/dialogs/storage.pwn
    Purpose: Contains easyDialog callbacks for property storage flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:HouseWeapons ======
Dialog:HouseWeapons(playerid, response, listitem, inputtext[])
{
	static
	    houseid = -1;

    if ((houseid = House_Inside(playerid)) != -1 && (House_IsOwner(playerid, houseid) || GetFactionType(playerid) == FACTION_POLICE))
	{
		if (response)
		{
		    if (HouseData[houseid][houseWeapons][listitem] != 0)
		    {
				GiveWeaponToPlayer(playerid, HouseData[houseid][houseWeapons][listitem], HouseData[houseid][houseAmmo][listitem]);

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has taken a \"%s\" from their weapon storage.", ReturnName(playerid, 0), ReturnWeaponName(HouseData[houseid][houseWeapons][listitem]));
                Log_Write("logs/storage_log.txt", "[%s] %s has taken a \"%s\" from house ID: %d (owner: %s).", ReturnDate(), ReturnName(playerid, 0), ReturnWeaponName(HouseData[houseid][houseWeapons][listitem]), HouseData[houseid][houseID], (House_IsOwner(playerid, houseid)) ? ("Yes") : ("No"));

				HouseData[houseid][houseWeapons][listitem] = 0;
				HouseData[houseid][houseAmmo][listitem] = 0;

				House_Save(houseid);
				House_WeaponStorage(playerid, houseid);
			}
			else
			{
			    new
					weaponid = GetWeapon(playerid),
					ammo = GetPlayerAmmo(playerid);

			    if (!weaponid)
			        return SendErrorMessage(playerid, "You are not holding any weapon!");

       			if (weaponid == 23 && PlayerData[playerid][pTazer])
	    			return SendErrorMessage(playerid, "You can't store a tazer into your safe.");

                if (weaponid == 25 && PlayerData[playerid][pBeanBag])
	    			return SendErrorMessage(playerid, "You can't store a beanbag shotgun into your safe.");

                ResetWeapon(playerid, weaponid);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stored a \"%s\" into their weapon storage.", ReturnName(playerid, 0), ReturnWeaponName(weaponid));

				HouseData[houseid][houseWeapons][listitem] = weaponid;
				HouseData[houseid][houseAmmo][listitem] = ammo;

				House_Save(houseid);
				House_WeaponStorage(playerid, houseid);
			}
		}
		else
		{
		    House_OpenStorage(playerid, houseid);
		}
	}
	return 1;
}

// ====== Dialog:HouseDeposit ======
Dialog:HouseDeposit(playerid, response, listitem, inputtext[])
{
	static
	    houseid = -1,
	    string[32];

    if ((houseid = House_Inside(playerid)) != -1 && (House_IsOwner(playerid, houseid) || GetFactionType(playerid) == FACTION_POLICE))
	{
	    strunpack(string, InventoryData[playerid][PlayerData[playerid][pInventoryItem]][invItem]);

		if (response)
		{
			new amount = strval(inputtext);

			if (amount < 1 || amount > InventoryData[playerid][PlayerData[playerid][pInventoryItem]][invQuantity])
			    return Dialog_Show(playerid, HouseDeposit, DIALOG_STYLE_INPUT, "House Deposit", "Item: %s (Quantity: %d)\n\nPlease enter the quantity that you wish to store for this item:", "Store", "Back", string, InventoryData[playerid][PlayerData[playerid][pInventoryItem]][invQuantity]);

			House_AddItem(houseid, string, InventoryData[playerid][PlayerData[playerid][pInventoryItem]][invModel], amount);
			Inventory_Remove(playerid, string, amount);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stored a \"%s\" into their house storage.", ReturnName(playerid, 0), string);
			House_ShowItems(playerid, houseid);
		}
		else House_OpenStorage(playerid, houseid);
	}
	return 1;
}

// ====== Dialog:HouseTake ======
Dialog:HouseTake(playerid, response, listitem, inputtext[])
{
	static
	    houseid = -1,
	    string[32];

    if ((houseid = House_Inside(playerid)) != -1 && (House_IsOwner(playerid, houseid) || GetFactionType(playerid) == FACTION_POLICE))
	{
	    strunpack(string, HouseStorage[houseid][PlayerData[playerid][pStorageItem]][hItemName]);

		if (response)
		{
			new amount = strval(inputtext);

			if (amount < 1 || amount > HouseStorage[houseid][PlayerData[playerid][pStorageItem]][hItemQuantity])
			    return Dialog_Show(playerid, HouseTake, DIALOG_STYLE_INPUT, "House Take", "Item: %s (Quantity: %d)\n\nPlease enter the quantity that you wish to take for this item:", "Take", "Back", string, HouseStorage[houseid][PlayerData[playerid][pInventoryItem]][hItemQuantity]);

			new id = Inventory_Add(playerid, string, HouseStorage[houseid][PlayerData[playerid][pStorageItem]][hItemModel], amount);

			if (id == -1)
				return SendErrorMessage(playerid, "You don't have any inventory slots left.");

			House_RemoveItem(houseid, string, amount);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has taken a \"%s\" from their house storage.", ReturnName(playerid, 0), string);

			House_ShowItems(playerid, houseid);
			Log_Write("logs/storage_log.txt", "[%s] %s has taken %d \"%s\" from house ID: %d (owner: %s).", ReturnDate(), ReturnName(playerid, 0), amount, string, HouseData[houseid][houseID], (House_IsOwner(playerid, houseid)) ? ("Yes") : ("No"));
		}
		else House_OpenStorage(playerid, houseid);
	}
	return 1;
}

// ====== Dialog:HouseWithdrawCash ======
Dialog:HouseWithdrawCash(playerid, response, listitem, inputtext[])
{
    static
	    houseid = -1;

	if ((houseid = House_Inside(playerid)) != -1 && House_IsOwner(playerid, houseid))
	{
		if (response)
		{
		    new amount = strval(inputtext);

		    if (isnull(inputtext))
		        return Dialog_Show(playerid, HouseWithdrawCash, DIALOG_STYLE_INPUT, "Withdraw from safe", "Safe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", "Withdraw", "Back", FormatNumber(HouseData[houseid][houseMoney]));

			if (amount < 1 || amount > HouseData[houseid][houseMoney])
			    return Dialog_Show(playerid, HouseWithdrawCash, DIALOG_STYLE_INPUT, "Withdraw from safe", "Error: Insufficient funds.\n\nSafe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", "Withdraw", "Back", FormatNumber(HouseData[houseid][houseMoney]));

			HouseData[houseid][houseMoney] -= amount;
			GiveMoney(playerid, amount);

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %s from their house safe.", ReturnName(playerid, 0), FormatNumber(amount));
		}
		else Dialog_Show(playerid, HouseMoney, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
	}
	return 1;
}

// ====== Dialog:HouseDepositCash ======
Dialog:HouseDepositCash(playerid, response, listitem, inputtext[])
{
    static
	    houseid = -1;

	if ((houseid = House_Inside(playerid)) != -1 && House_IsOwner(playerid, houseid))
	{
		if (response)
		{
		    new amount = strval(inputtext);

		    if (isnull(inputtext))
		        return Dialog_Show(playerid, HouseDepositCash, DIALOG_STYLE_INPUT, "Deposit into safe", "Safe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", "Withdraw", "Back", FormatNumber(HouseData[houseid][houseMoney]));

			if (amount < 1 || amount > GetMoney(playerid))
			    return Dialog_Show(playerid, HouseDepositCash, DIALOG_STYLE_INPUT, "Deposit into safe", "Error: Insufficient funds.\n\nSafe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", "Withdraw", "Back", FormatNumber(HouseData[houseid][houseMoney]));

			HouseData[houseid][houseMoney] += amount;
			GiveMoney(playerid, -amount);

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %s into their house safe.", ReturnName(playerid, 0), FormatNumber(amount));
		}
		else Dialog_Show(playerid, HouseMoney, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
	}
	return 1;
}

// ====== Dialog:HouseMoney ======
Dialog:HouseMoney(playerid, response, listitem, inputtext[])
{
    static
	    houseid = -1;

	if ((houseid = House_Inside(playerid)) != -1 && House_IsOwner(playerid, houseid))
	{
		if (response)
		{
			switch (listitem)
			{
			    case 0: {
					Dialog_Show(playerid, HouseWithdrawCash, DIALOG_STYLE_INPUT, "Withdraw from safe", "Safe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", "Withdraw", "Back", FormatNumber(HouseData[houseid][houseMoney]));
				}
				case 1: {
				    Dialog_Show(playerid, HouseDepositCash, DIALOG_STYLE_INPUT, "Deposit into safe", "Safe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", "Withdraw", "Back", FormatNumber(HouseData[houseid][houseMoney]));
				}
			}
		}
		else House_OpenStorage(playerid, houseid);
	}
	return 1;
}

// ====== Dialog:HouseItems ======
Dialog:HouseItems(playerid, response, listitem, inputtext[])
{
    static
	    houseid = -1,
		string[64];

	if ((houseid = House_Inside(playerid)) != -1 && (House_IsOwner(playerid, houseid) || GetFactionType(playerid) == FACTION_POLICE))
	{
		if (response)
		{
    		if (HouseStorage[houseid][listitem][hItemExists])
			{
   				PlayerData[playerid][pStorageItem] = listitem;
   				PlayerData[playerid][pInventoryItem] = listitem;

				strunpack(string, HouseStorage[houseid][listitem][hItemName]);

				format(string, sizeof(string), "%s (Quantity: %d)", string, HouseStorage[houseid][listitem][hItemQuantity]);
				Dialog_Show(playerid, StorageOptions, DIALOG_STYLE_LIST, string, "Take Item\nStore Item", "Select", "Back");
			}
			else {
   				OpenInventory(playerid);

				PlayerData[playerid][pStorageSelect] = 1;
			}
		}
		else House_OpenStorage(playerid, houseid);
	}
	return 1;
}

// ====== Dialog:HouseStorage ======
Dialog:HouseStorage(playerid, response, listitem, inputtext[])
{
	static
	    houseid = -1;

	if ((houseid = House_Inside(playerid)) != -1 && (House_IsOwner(playerid, houseid) || GetFactionType(playerid) == FACTION_POLICE))
	{
		if (response)
		{
		    if (listitem == 0) {
		        House_ShowItems(playerid, houseid);
		    }
      		else if (listitem == 1) {
				House_WeaponStorage(playerid, houseid);
		    }
		    else if (listitem == 2) {
		        Dialog_Show(playerid, HouseMoney, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
		}
	}
	return 1;
}

// ====== Dialog:StorageOptions ======
Dialog:StorageOptions(playerid, response, listitem, inputtext[])
{
    static
	    houseid = -1,
		itemid = -1,
		backpack = -1,
		string[32];

	if ((houseid = House_Inside(playerid)) != -1 && (House_IsOwner(playerid, houseid) || GetFactionType(playerid) == FACTION_POLICE))
	{
	    itemid = PlayerData[playerid][pStorageItem];

	    strunpack(string, HouseStorage[houseid][itemid][hItemName]);

		if (response)
		{
			switch (listitem)
			{
			    case 0:
			    {
			        if (HouseStorage[houseid][itemid][hItemQuantity] == 1)
			        {
			            if (!strcmp(string, "Backpack") && Inventory_HasItem(playerid, "Backpack"))
           					return SendErrorMessage(playerid, "You already have a backpack in your inventory.");

			            new id = Inventory_Add(playerid, string, HouseStorage[houseid][itemid][hItemModel], 1);

						if (id == -1)
        					return SendErrorMessage(playerid, "You don't have any inventory slots left.");

                        if (!strcmp(string, "Backpack") && (backpack = GetHouseBackpack(houseid)) != -1)
						{
						    BackpackData[backpack][backpackHouse] = 0;
						    BackpackData[backpack][backpackPlayer] = PlayerData[playerid][pID];

						    Backpack_Save(backpack);
						    SetAccessories(playerid);
						}
			            House_RemoveItem(houseid, string);
			            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has taken a \"%s\" from their house storage.", ReturnName(playerid, 0), string);

						House_ShowItems(playerid, houseid);
						Log_Write("logs/storage_log.txt", "[%s] %s has taken \"%s\" from house ID: %d (owner: %s).", ReturnDate(), ReturnName(playerid, 0), string, HouseData[houseid][houseID], (House_IsOwner(playerid, houseid)) ? ("Yes") : ("No"));
			        }
			        else
			        {
			            Dialog_Show(playerid, HouseTake, DIALOG_STYLE_INPUT, "House Take", "Item: %s (Quantity: %d)\n\nPlease enter the quantity that you wish to take for this item:", "Take", "Back", string, HouseStorage[houseid][itemid][hItemQuantity]);
			        }
			    }
				case 1:
				{
					new id = Inventory_GetItemID(playerid, string);

					if (!strcmp(string, "Backpack")) {
					    House_ShowItems(playerid, houseid);

						return SendErrorMessage(playerid, "You can only store one backpack in your house.");
					}
					else if (id == -1) {
						House_ShowItems(playerid, houseid);

						return SendErrorMessage(playerid, "You don't have anymore of this item to store!");
					}
					else if (InventoryData[playerid][id][invQuantity] == 1)
					{
					    House_AddItem(houseid, string, InventoryData[playerid][id][invModel]);
						Inventory_Remove(playerid, string);

						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stored a \"%s\" into their house storage.", ReturnName(playerid, 0), string);
						House_ShowItems(playerid, houseid);
					}
					else if (InventoryData[playerid][id][invQuantity] > 1) {
					    PlayerData[playerid][pInventoryItem] = id;

                        Dialog_Show(playerid, HouseDeposit, DIALOG_STYLE_INPUT, "House Deposit", "Item: %s (Quantity: %d)\n\nPlease enter the quantity that you wish to store for this item:", "Store", "Back", string, InventoryData[playerid][id][invQuantity]);
					}
				}
			}
		}
		else
		{
		    House_ShowItems(playerid, houseid);
		}
	}
	return 1;
}

