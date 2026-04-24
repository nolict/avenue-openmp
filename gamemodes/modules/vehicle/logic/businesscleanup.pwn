/*
    File: modules/vehicle/logic/businesscleanup.pwn
    Purpose: Contains vehicle gameplay logic and helper functions for businesscleanup.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== Business_RemoveCars ======
stock Business_RemoveCars(bizid)
{
	if (BusinessData[bizid][bizExists] && BusinessData[bizid][bizType] == 5)
	{
	    static
	        string[32];

		for (new i = 0; i != MAX_DEALERSHIP_CARS; i ++)
		{
  			DealershipCars[bizid][i][vehModel] = 0;
    		DealershipCars[bizid][i][vehPrice] = 0;
		}
		format(string, sizeof(string), "DELETE FROM `dealervehicles` WHERE `ID` = '%d'", BusinessData[bizid][bizID]);
		mysql_tquery(g_iHandle, string);
	}
	return 1;
}

// ====== Business_RemovePumps ======
stock Business_RemovePumps(bizid)
{
	if (BusinessData[bizid][bizExists] && BusinessData[bizid][bizType] == 6)
	{
	    static
	        string[32];

	    foreach (new i : Player) if (PlayerData[i][pRefill] != INVALID_VEHICLE_ID && PlayerData[i][pGasStation] == bizid)
	    {
	        StopRefilling(i);
	    }
		for (new i = 0; i != MAX_GAS_PUMPS; i ++) if (PumpData[i][pumpExists] && PumpData[i][pumpBusiness] == bizid)
		{
  			DestroyDynamicObject(PumpData[i][pumpObject]);
			DestroyDynamic3DTextLabel(PumpData[i][pumpText3D]);

		    PumpData[i][pumpExists] = 0;
		    PumpData[i][pumpFuel] = 0;
		}
		format(string, sizeof(string), "DELETE FROM `pumps` WHERE `ID` = '%d'", BusinessData[bizid][bizID]);
		mysql_tquery(g_iHandle, string);
	}
	return 1;
}
