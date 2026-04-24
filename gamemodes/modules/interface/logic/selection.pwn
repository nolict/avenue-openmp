/*
    File: modules/interface/logic/selection.pwn
    Purpose: Contains interface gameplay logic and helper functions for selection.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== OnModelSelectionResponse ======
public OnModelSelectionResponse(playerid, extraid, index, modelid, response)
{
	if ((extraid >= MODEL_SELECTION_GLASSES && extraid <= MODEL_SELECTION_BANDANAS) && !PlayerData[playerid][pCreated] && !response)
	{
	    for (new i = 23; i < 34; i ++) {
    		PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][i]);
		}
		SetTimerEx("SelectTD", 100, false, "d", playerid);
		return 1;
	}
	if ((extraid == MODEL_SELECTION_INVENTORY && response) && InventoryData[playerid][index][invExists])
	{
	    new
	        name[48],
			id = -1,
			backpack = GetPlayerBackpack(playerid);

		strunpack(name, InventoryData[playerid][index][invItem]);
	    PlayerData[playerid][pInventoryItem] = index;

		switch (PlayerData[playerid][pStorageSelect])
		{
		    case 1:
		    {
		    	if ((id = House_Inside(playerid)) != -1 && House_IsOwner(playerid, id))
				{
					if (InventoryData[playerid][index][invQuantity] == 1)
					{
					    if (!strcmp(name, "Backpack") && GetHouseBackpack(id) != -1)
					        return SendErrorMessage(playerid, "You can only store one backpack in your house.");

		        		House_AddItem(id, name, InventoryData[playerid][index][invModel], 1);
		        		Inventory_Remove(playerid, name);

		        		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stored a \"%s\" into their house storage.", ReturnName(playerid, 0), name);
				 		House_ShowItems(playerid, id);

				 		if (!strcmp(name, "Backpack") && backpack != -1)
						{
					        BackpackData[backpack][backpackPlayer] = 0;
					        BackpackData[backpack][backpackHouse] = HouseData[id][houseID];

							Backpack_Save(backpack);
							SetAccessories(playerid);
					    }
		        	}
		        	else Dialog_Show(playerid, HouseDeposit, DIALOG_STYLE_INPUT, DialogStyle_Title("House Deposit"), DialogStyle_Body("Item: %s (Quantity: %d)\n\nPlease enter the quantity that you wish to store for this item:"), "Store", "Back", name, InventoryData[playerid][PlayerData[playerid][pInventoryItem]][invQuantity]);
				}
				PlayerData[playerid][pStorageSelect] = 0;
			}
			case 2:
		    {
		    	if ((id = Car_Nearest(playerid)) != -1 && !CarData[id][carLocked])
				{
					if (InventoryData[playerid][index][invQuantity] == 1)
					{
					    if (!strcmp(name, "Backpack") && GetVehicleBackpack(id) != -1)
					        return SendErrorMessage(playerid, "You can only store one backpack in your trunk.");

		        		Car_AddItem(id, name, InventoryData[playerid][index][invModel], 1);
		        		Inventory_Remove(playerid, name);

		        		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stored a \"%s\" into the trunk.", ReturnName(playerid, 0), name);
				 		Car_ShowTrunk(playerid, id);

				 		if (!strcmp(name, "Backpack") && backpack != -1)
						{
					        BackpackData[backpack][backpackPlayer] = 0;
					        BackpackData[backpack][backpackVehicle] = CarData[id][carID];

							Backpack_Save(backpack);
							SetAccessories(playerid);
					    }
		        	}
		        	else Dialog_Show(playerid, CarDeposit, DIALOG_STYLE_INPUT, DialogStyle_Title("Car Deposit"), DialogStyle_Body("Item: %s (Quantity: %d)\n\nPlease enter the quantity that you wish to store for this item:"), "Store", "Back", name, InventoryData[playerid][PlayerData[playerid][pInventoryItem]][invQuantity]);
				}
				PlayerData[playerid][pStorageSelect] = 0;
			}
			case 3:
		    {
		        if (!strcmp(name, "Backpack"))
		            return SendErrorMessage(playerid, "This item cannot be stored.");

		    	if (InventoryData[playerid][index][invQuantity] == 1)
				{
					Backpack_Add(GetPlayerBackpack(playerid), name, InventoryData[playerid][index][invModel], 1);
   					Inventory_Remove(playerid, name);

					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stored a \"%s\" into their backpack.", ReturnName(playerid, 0), name);
					Backpack_Open(playerid);
				}
   				else
	   			{
				   	Dialog_Show(playerid, BackpackDeposit, DIALOG_STYLE_INPUT, DialogStyle_Title("Backpack Deposit"), DialogStyle_Body("Item: %s (Quantity: %d)\n\nPlease enter the quantity that you wish to store for this item:"), "Store", "Back", name, InventoryData[playerid][PlayerData[playerid][pInventoryItem]][invQuantity]);
				}
				PlayerData[playerid][pStorageSelect] = 0;
			}
			default:
			{
			    if (PlayerData[playerid][pTutorialStage] == 3 && !strcmp(name, "Demo Soda", true))
			    {
			        SendClientMessage(playerid, COLOR_SERVER, "Click on the first option to use the selected item.");
			    }
		    	format(name, sizeof(name), "%s (%d)", name, InventoryData[playerid][index][invQuantity]);

		    	if (Garbage_Nearest(playerid) != -1) {
					Dialog_Show(playerid, Inventory, DIALOG_STYLE_LIST, DialogStyle_Title(name), "Use Item\nGive Item\nThrow Out", "Select", "Cancel");
				}
				else {
				    Dialog_Show(playerid, Inventory, DIALOG_STYLE_LIST, DialogStyle_Title(name), "Use Item\nGive Item\nDrop Item", "Select", "Cancel");
				}
			}
		}
	}
	if ((response) && (extraid == MODEL_SELECTION_GLASSES))
	{
	    if (modelid == 19300)
	    {
            for (new i = 23; i < 34; i ++) {
		    	PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][i]);
			}
			SelectTextDraw(playerid, -1);
			PlayerData[playerid][pGlasses] = 0;

			RemovePlayerAttachedObject(playerid, 0);
			SendServerMessage(playerid, "You have removed your glasses.");
	    }
	    else
	    {
	        PlayerData[playerid][pEditType] = 1;
	        TogglePlayerControllable(playerid, 1);

			SetPlayerAttachedObject(playerid, 0, modelid, 2, 0.094214, 0.044044, -0.007274, 89.675476, 83.514060, 0.000000);
			EditAttachedObject(playerid, 0);
		}
	}
    if ((response) && (extraid == MODEL_SELECTION_HATS))
	{
	    if (modelid == 19300)
	    {
			for (new i = 23; i < 34; i ++) {
		    	PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][i]);
			}
			SelectTextDraw(playerid, -1);
			PlayerData[playerid][pHat] = 0;

			RemovePlayerAttachedObject(playerid, 1);
			SendServerMessage(playerid, "You have removed your hat.");
	    }
	    else
	    {
		    PlayerData[playerid][pEditType] = 2;
		    TogglePlayerControllable(playerid, 1);

			SetPlayerAttachedObject(playerid, 1, modelid, 2, 0.1565, 0.0273, -0.0002, -7.9245, -1.3224, 15.0999);
			EditAttachedObject(playerid, 1);
		}
	}
	if ((response) && (extraid == MODEL_SELECTION_BANDANAS))
	{
	    if (modelid == 19300)
	    {
            for (new i = 23; i < 34; i ++) {
		    	PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][i]);
			}
			SelectTextDraw(playerid, -1);
			PlayerData[playerid][pBandana] = 0;

			RemovePlayerAttachedObject(playerid, 2);
			SendServerMessage(playerid, "You have removed your bandana.");
	    }
	    else
	    {
		    PlayerData[playerid][pEditType] = 3;
            TogglePlayerControllable(playerid, 1);

			SetPlayerAttachedObject(playerid, 2, modelid, 2, 0.099553, 0.044356, -0.000285, 89.675476, 84.277572, 0.000000);
			EditAttachedObject(playerid, 2);
		}
	}
	if ((response) && (extraid == MODEL_SELECTION_SKIN))
	{
	    PlayerData[playerid][pSkin] = modelid;

		SetSpawnInfo(playerid, 0, PlayerData[playerid][pSkin], 1684.4392, 1771.6658, 10.8203, 270.0000, 0, 0, 0, 0, 0, 0);
		TogglePlayerSpectating(playerid, 0);
	}
	if ((response) && (extraid == MODEL_SELECTION_CLOTHES))
	{
	    new
			bizid = -1,
			price;

	    if ((bizid = Business_Inside(playerid)) == -1 || BusinessData[bizid][bizType] != 3)
	        return 0;

		if (BusinessData[bizid][bizProducts] < 1)
		    return SendErrorMessage(playerid, "This business is out of stock.");

	    price = BusinessData[bizid][bizPrices][PlayerData[playerid][pClothesType] - 1];

	    if (GetMoney(playerid) < price)
	        return SendErrorMessage(playerid, "You have insufficient funds for the purchase.");

		GiveMoney(playerid, -price);

		BusinessData[bizid][bizProducts]--;
		BusinessData[bizid][bizVault] += Tax_Percent(price);

		Business_Save(bizid);
		Tax_AddPercent(price);

	    switch (PlayerData[playerid][pClothesType])
	    {
	        case 1:
	        {
	            PlayerData[playerid][pSkin] = modelid;
	            SetPlayerSkin(playerid, modelid);

	            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received some clothes.", ReturnName(playerid, 0), FormatNumber(price));
			}
			case 2:
			{
			    PlayerData[playerid][pEditType] = 1;
                PlayerData[playerid][pGlasses] = modelid;

			    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received some glasses.", ReturnName(playerid, 0), FormatNumber(price));
				RemovePlayerAttachedObject(playerid, 0);

                SetPlayerAttachedObject(playerid, 0, modelid, 2, 0.094214, 0.044044, -0.007274, 89.675476, 83.514060, 0.000000);
				EditAttachedObject(playerid, 0);
			}
			case 3:
			{
			    PlayerData[playerid][pHat] = modelid;
			    PlayerData[playerid][pEditType] = 2;

			    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a hat.", ReturnName(playerid, 0), FormatNumber(price));
                RemovePlayerAttachedObject(playerid, 1);

				SetPlayerAttachedObject(playerid, 1, modelid, 2, 0.1565, 0.0273, -0.0002, -7.9245, -1.3224, 15.0999);
				EditAttachedObject(playerid, 1);
			}
			case 4:
			{
			    PlayerData[playerid][pBandana] = modelid;
			    PlayerData[playerid][pEditType] = 3;

			    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a bandana.", ReturnName(playerid, 0), FormatNumber(price));
			    RemovePlayerAttachedObject(playerid, 2);

			    SetPlayerAttachedObject(playerid, 2, modelid, 2, 0.099553, 0.044356, -0.000285, 89.675476, 84.277572, 0.000000);
				EditAttachedObject(playerid, 2);
			}
	    }
	}
	if ((response) && (extraid == MODEL_SELECTION_DEALER))
	{
	    new id = PlayerData[playerid][pDealership];

	    if (id != -1 && BusinessData[id][bizExists] && BusinessData[id][bizType] == 5)
 	    {
	        if (!DealershipCars[id][index][vehModel])
	        {
	            Dialog_Show(playerid, AddVehicle, DIALOG_STYLE_LIST, DialogStyle_Title("Add Vehicle"), DialogStyle_Body("Add by Name\nAdd by Thumbnail"), "Select", "Cancel");
			}
			else
			{
			    PlayerData[playerid][pDealerCar] = index;
			    Dialog_Show(playerid, CarOptions, DIALOG_STYLE_LIST, DialogStyle_Title("Dealership Vehicle"), DialogStyle_Body("Set Price (%s)\nRemove Vehicle"), "Select", "Cancel", FormatNumber(DealershipCars[id][index][vehPrice]));
			}
	    }
	}
	if ((response) && (extraid == MODEL_SELECTION_DEALER_ADD))
	{
	    new id = PlayerData[playerid][pDealership];

	    if (id != -1 && BusinessData[id][bizExists] && BusinessData[id][bizType] == 5)
	    {
	        for (new i = 0; i != MAX_DEALERSHIP_CARS; i ++)
			{
				if (DealershipCars[id][i][vehModel] == modelid)
	            	return SendErrorMessage(playerid, "This vehicle is already sold at this dealership.");
			}
			PlayerData[playerid][pDealerCar] = modelid;
			Dialog_Show(playerid, DealerCarPrice, DIALOG_STYLE_INPUT, DialogStyle_Title("Enter Price"), DialogStyle_Body("Please enter a price for '%s':"), "Submit", "Cancel", ReturnVehicleModelName(PlayerData[playerid][pDealerCar]));
		}
	}
	if ((response) && (extraid == MODEL_SELECTION_BUY_CAR))
	{
	    new id = Business_Inside(playerid);

	    if (id != -1 && BusinessData[id][bizExists] && BusinessData[id][bizType] == 5)
	    {
		    if (!DealershipCars[id][index][vehModel])
		        return SendErrorMessage(playerid, "There is no model in the selected slot.");

		    if (GetMoney(playerid) < DealershipCars[id][index][vehPrice])
	    	    return SendErrorMessage(playerid, "You can't afford this vehicle (%s).", FormatNumber(DealershipCars[id][index][vehPrice]));

			PlayerData[playerid][pDealerCar] = index;
			Dialog_Show(playerid, ConfirmCarBuy, DIALOG_STYLE_MSGBOX, DialogStyle_Title("Confirm Purchase"), DialogStyle_Body("Are you sure you want to buy this '%s'?\n\nNote: This vehicle costs %s at this dealership."), "Yes", "No", ReturnVehicleModelName(modelid), FormatNumber(DealershipCars[id][index][vehPrice]));
		}
	}
	if ((response) && (extraid == MODEL_SELECTION_FURNITURE))
	{
        new
			id = Business_Inside(playerid),
			type = PlayerData[playerid][pFurnitureType],
			price;

	    if (id != -1 && BusinessData[id][bizExists] && BusinessData[id][bizType] == 7)
	    {
	        price = BusinessData[id][bizPrices][type];

	        if (GetMoney(playerid) < price)
	            return SendErrorMessage(playerid, "You have insufficient funds for the purchase.");

			if (BusinessData[id][bizProducts] < 1)
		    	return SendErrorMessage(playerid, "This business is out of stock.");

			new item = Inventory_Add(playerid, GetFurnitureNameByModel(modelid), modelid);

            if (item == -1)
   	        	return SendErrorMessage(playerid, "You don't have any inventory slots left.");

			GiveMoney(playerid, -price);
			SendServerMessage(playerid, "You have purchased a \"%s\" for %s.", GetFurnitureNameByModel(modelid), FormatNumber(price));

			BusinessData[id][bizProducts]--;
			BusinessData[id][bizVault] += Tax_Percent(price);

			Business_Save(id);
			Tax_AddPercent(price);
	    }
	}
	if ((response) && (extraid == MODEL_SELECTION_COLOR))
	{
	    new vehicleid = GetNearestVehicle(playerid);

        if (vehicleid == INVALID_VEHICLE_ID)
		    return SendErrorMessage(playerid, "You are not standing near any vehicle.");

		if (!Inventory_HasItem(playerid, "Spray Can"))
		    return SendErrorMessage(playerid, "You don't have any cans of spray paint.");

	    ApplyAnimation(playerid, "GRAFFITI", "null", 4.0, 0, 0, 0, 0, 0, 0);
		ApplyAnimation(playerid, "GRAFFITI", "spraycan_fire", 4.0, 1, 0, 0, 0, 0, 1);
        ApplyAnimation(playerid, "GRAFFITI", "spraycan_fire", 4.0, 1, 0, 0, 0, 0, 1);

		GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Spraying vehicle...", 3000, 3);
		SetTimerEx("ResprayCar", 3000, false, "ddd", playerid, vehicleid, modelid);
	}
	if ((response) && (extraid == MODEL_SELECTION_SKINS))
	{
	    Dialog_Show(playerid, FactionSkin, DIALOG_STYLE_LIST, DialogStyle_Title("Edit Skin"), DialogStyle_Body("Add by Model ID\nAdd by Thumbnail\nClear Slot"), "Select", "Cancel");
	    PlayerData[playerid][pSelectedSlot] = index;
	}
	if ((response) && (extraid == MODEL_SELECTION_ADD_SKIN))
	{
	    FactionData[PlayerData[playerid][pFactionEdit]][factionSkins][PlayerData[playerid][pSelectedSlot]] = modelid;
		Faction_Save(PlayerData[playerid][pFactionEdit]);

		SendServerMessage(playerid, "You have set the skin ID in slot %d to %d.", PlayerData[playerid][pSelectedSlot], modelid);
	}
	if ((response) && (extraid == MODEL_SELECTION_FACTION_SKIN))
	{
	    new factionid = PlayerData[playerid][pFaction];

		if (factionid == -1 || !IsNearFactionLocker(playerid))
	    	return 0;

		if (modelid == 19300)
		    return SendErrorMessage(playerid, "There is no model in the selected slot.");

  		SetPlayerSkin(playerid, modelid);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has changed their uniform.", ReturnName(playerid, 0));
	}
	if ((response) && (extraid == MODEL_SELECTION_WHEELS))
	{
        new vehicleid = GetPlayerVehicleID(playerid);

		if (!IsPlayerInAnyVehicle(playerid) || !IsDoorVehicle(vehicleid))
	    	return 0;

	    AddComponent(vehicleid, modelid);
	    SendServerMessage(playerid, "You have added the \"%s\" wheels to this vehicle.", GetWheelName(modelid));
	}
	return 1;
}
