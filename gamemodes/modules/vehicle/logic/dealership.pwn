/*
    File: modules/vehicle/logic/dealership.pwn
    Purpose: Contains vehicle gameplay logic and helper functions for dealership.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== Business_LoadCars ======
forward Business_LoadCars(bizid);

// ====== Business_LoadCars ======
public Business_LoadCars(bizid)
{
	static
	    rows,
	    fields;

	cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i != rows; i ++) {
		DealershipCars[bizid][i][vehID] = cache_get_field_int(i, "vehID");
		DealershipCars[bizid][i][vehModel] = cache_get_field_int(i, "vehModel");
		DealershipCars[bizid][i][vehPrice] = cache_get_field_int(i, "vehPrice");
	}
	return 1;
}

// ====== Business_RemoveVehicle ======
Business_RemoveVehicle(bizid, modelid)
{
	static
	    query[128];

    for (new i = 0; i != MAX_DEALERSHIP_CARS; i ++) if (DealershipCars[bizid][i][vehModel] == modelid)
	{
	    DealershipCars[bizid][i][vehModel] = 0;
	    DealershipCars[bizid][i][vehPrice] = 0;

	    format(query, sizeof(query), "DELETE FROM `dealervehicles` WHERE `ID` = '%d' AND `vehID` = '%d'", BusinessData[bizid][bizID], DealershipCars[bizid][i][vehID]);
		mysql_tquery(g_iHandle, query);

		return 1;
	}
	return 0;
}

// ====== Business_AddVehicle ======
Business_AddVehicle(bizid, modelid, price)
{
	static
	    query[128];

	for (new i = 0; i != MAX_DEALERSHIP_CARS; i ++) if (!DealershipCars[bizid][i][vehModel])
	{
	    DealershipCars[bizid][i][vehModel] = modelid;
	    DealershipCars[bizid][i][vehPrice] = price;

	    format(query, sizeof(query), "INSERT INTO `dealervehicles` (`ID`, `vehModel`, `vehPrice`) VALUES('%d', '%d', '%d')", BusinessData[bizid][bizID], modelid, price);
	    mysql_tquery(g_iHandle, query, "OnDealerCarCreated", "dd", bizid, i);

	    return 1;
	}
	return 0;
}

// ====== Business_CarMenu ======
Business_CarMenu(playerid, bizid)
{
 	static
	    cars[MAX_DEALERSHIP_CARS];

    for (new i = 0; i != MAX_DEALERSHIP_CARS; i ++)
	{
		if (!DealershipCars[bizid][i][vehModel])
			cars[i] = 19300;

		else
		    cars[i] = DealershipCars[bizid][i][vehModel];
	}
	ShowModelSelectionMenu(playerid, "Purchase Car", MODEL_SELECTION_BUY_CAR, cars, sizeof(cars), -16.0, 0.0, -55.0, 0.9, 1);
	return 1;
}

// ====== Business_EditCars ======
Business_EditCars(playerid, bizid)
{
	static
	    cars[MAX_DEALERSHIP_CARS];

    for (new i = 0; i != MAX_DEALERSHIP_CARS; i ++)
	{
		if (!DealershipCars[bizid][i][vehModel])
			cars[i] = 19300;

		else
		    cars[i] = DealershipCars[bizid][i][vehModel];
	}
	ShowModelSelectionMenu(playerid, "Dealership Cars", MODEL_SELECTION_DEALER, cars, sizeof(cars), -16.0, 0.0, -55.0, 0.9, 1);
	return 1;
}
