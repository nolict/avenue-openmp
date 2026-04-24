/*
    File: modules/vehicle/dialogs/dealership.pwn
    Purpose: Contains easyDialog callbacks for vehicle dealership flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:Trunk ======
Dialog:Trunk(playerid, response, listitem, inputtext[])
{
    new carid = Car_Nearest(playerid);

	if (CarData[carid][carImpounded] != -1)
    	return SendErrorMessage(playerid, "This vehicle is impounded and you can't use it.");

	if (carid != -1 && !CarData[carid][carLocked])
 	{
		if (response)
		{
			if (!CarData[carid][carWeapons][listitem])
			{
			    if (!GetWeapon(playerid))
			        return SendErrorMessage(playerid, "You aren't holding any weapon.");

       			if (GetWeapon(playerid) == 23 && PlayerData[playerid][pTazer])
	    			return SendErrorMessage(playerid, "You can't store a tazer into your trunk.");

                if (GetWeapon(playerid) == 25 && PlayerData[playerid][pBeanBag])
	    			return SendErrorMessage(playerid, "You can't store a beanbag shotgun into your trunk.");

				if (!Car_IsOwner(playerid, carid) && GetFactionType(playerid) == FACTION_POLICE)
        			return SendErrorMessage(playerid, "You can't store weapons since you're a police officer.");

	   			CarData[carid][carWeapons][listitem] = GetWeapon(playerid);
	            CarData[carid][carAmmo][listitem] = GetPlayerAmmo(playerid);

	            ResetWeapon(playerid, CarData[carid][carWeapons][listitem]);
	            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s stored a %s into the trunk.", ReturnName(playerid, 0), ReturnWeaponName(CarData[carid][carWeapons][listitem]));

	            Car_Save(carid);
				Car_WeaponStorage(playerid, carid);
			}
			else
			{
			    GiveWeaponToPlayer(playerid, CarData[carid][carWeapons][listitem], CarData[carid][carAmmo][listitem]);
	            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes a %s from the trunk.", ReturnName(playerid, 0), ReturnWeaponName(CarData[carid][carWeapons][listitem]));

	            CarData[carid][carWeapons][listitem] = 0;
	            CarData[carid][carAmmo][listitem] = 0;

	            Car_Save(carid);
	            Car_WeaponStorage(playerid, carid);
			}
	    }
		else {
		    Car_ShowTrunk(playerid, carid);
		}
	}
	return 1;
}

// ====== Dialog:ConfirmCarBuy ======
Dialog:ConfirmCarBuy(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new
			bizid = Business_Inside(playerid),
			carid = PlayerData[playerid][pDealerCar],
			price = DealershipCars[bizid][carid][vehPrice];

		if (bizid != -1 && BusinessData[bizid][bizExists] && BusinessData[bizid][bizType] == 5)
		{
			if (GetMoney(playerid) < price)
			    return SendErrorMessage(playerid, "You have insufficient funds for the purchase.");

			if (Car_GetCount(playerid) >= MAX_OWNABLE_CARS)
			    return SendErrorMessage(playerid, "You already have %d vehicles (server limit).", MAX_OWNABLE_CARS);

			new id = Car_Create(PlayerData[playerid][pID], DealershipCars[bizid][carid][vehModel], BusinessData[bizid][bizSpawn][0], BusinessData[bizid][bizSpawn][1], BusinessData[bizid][bizSpawn][2], BusinessData[bizid][bizSpawn][3], 1, 1);

			if (id != -1)
			{
			    Tax_AddPercent(price);

			    BusinessData[bizid][bizVault] += Tax_Percent(price);
			    Business_Save(bizid);

				SendServerMessage(playerid, "You have bought a %s for %s!", ReturnVehicleModelName(DealershipCars[bizid][carid][vehModel]), FormatNumber(price));
				GiveMoney(playerid, -price);

				ShowPlayerFooter(playerid, "~w~Vehicle ~p~purchased!");
				Log_Write("logs/car_log.txt", "[%s] %s has purchased a %s for %s.", ReturnDate(), ReturnName(playerid, 0), ReturnVehicleModelName(DealershipCars[bizid][carid][vehModel]), FormatNumber(price));
			}
		}
	}
	return 1;
}

// ====== Dialog:DealerCarPrice ======
Dialog:DealerCarPrice(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new id = PlayerData[playerid][pDealership];

	    if (id != -1 && BusinessData[id][bizExists] && BusinessData[id][bizType] == 5)
	    {
		    if (isnull(inputtext) || strval(inputtext) < 1)
		        return Dialog_Show(playerid, DealerCarPrice, DIALOG_STYLE_INPUT, "Enter Price", "Please enter a price for '%s':", "Submit", "Cancel", ReturnVehicleModelName(PlayerData[playerid][pDealerCar]));

		    Business_AddVehicle(id, PlayerData[playerid][pDealerCar], strval(inputtext));
	        Business_EditCars(playerid, id);

		    SendServerMessage(playerid, "You have added a '%s' to the dealership.", ReturnVehicleModelName(PlayerData[playerid][pDealerCar]));
		    return 1;
		}
	}
	return 1;
}

// ====== Dialog:CarPrice ======
Dialog:CarPrice(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new id = PlayerData[playerid][pDealership];

	    if (id != -1 && BusinessData[id][bizExists] && BusinessData[id][bizType] == 5)
	    {
		    if (isnull(inputtext) || strval(inputtext) < 1)
		        return Dialog_Show(playerid, CarPrice, DIALOG_STYLE_INPUT, "Set Price", "The current price for '%s' is %s.\n\nPlease enter the new price for this vehicle model below:", "Submit", "Cancel", ReturnVehicleModelName(DealershipCars[id][PlayerData[playerid][pDealerCar]][vehModel]), FormatNumber(DealershipCars[id][PlayerData[playerid][pDealerCar]][vehPrice]));

			new
			    string[128];

			DealershipCars[id][PlayerData[playerid][pDealerCar]][vehPrice] = strval(inputtext);

			format(string, sizeof(string), "UPDATE `dealervehicles` SET `vehPrice` = '%d' WHERE `ID` = '%d' AND `vehID` = '%d'", strval(inputtext), BusinessData[id][bizID], DealershipCars[id][PlayerData[playerid][pDealerCar]][vehID]);
			mysql_tquery(g_iHandle, string);

			SendServerMessage(playerid, "You have set the price of '%s' to %s.", ReturnVehicleModelName(DealershipCars[id][PlayerData[playerid][pDealerCar]][vehModel]), FormatNumber(DealershipCars[id][PlayerData[playerid][pDealerCar]][vehPrice]));
			Business_EditCars(playerid, id);
		}
		return 1;
	}
	return 1;
}

// ====== Dialog:CarOptions ======
Dialog:CarOptions(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new id = PlayerData[playerid][pDealership];

	    if (id != -1 && BusinessData[id][bizExists] && BusinessData[id][bizType] == 5)
	    {
		    if (listitem == 0)
		    {
		        Dialog_Show(playerid, CarPrice, DIALOG_STYLE_INPUT, "Set Price", "The current price for '%s' is %s.\n\nPlease enter the new price for this vehicle model below:", "Submit", "Cancel", ReturnVehicleModelName(DealershipCars[id][PlayerData[playerid][pDealerCar]][vehModel]), FormatNumber(DealershipCars[id][PlayerData[playerid][pDealerCar]][vehPrice]));
		    }
		    else if (listitem == 1)
		    {
			    new model = DealershipCars[id][PlayerData[playerid][pDealerCar]][vehModel];
			    Business_RemoveVehicle(id, model);

				SendServerMessage(playerid, "You have removed the '%s' from the dealership.", ReturnVehicleModelName(model));
				Business_EditCars(playerid, id);
			}
		}
	}
	return 1;
}

