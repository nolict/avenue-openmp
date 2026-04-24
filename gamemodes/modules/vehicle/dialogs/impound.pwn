/*
    File: modules/vehicle/dialogs/impound.pwn
    Purpose: Contains easyDialog callbacks for vehicle impound flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:ReleaseCar ======
Dialog:ReleaseCar(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new
			carid = ListedVehicles[playerid][listitem],
			id = GetImpoundByID(CarData[carid][carImpounded]);

	    if (carid != -1 && id != -1 && CarData[carid][carExists] && CarData[carid][carImpounded] != -1)
	    {
	        if (GetMoney(playerid) < CarData[carid][carImpoundPrice])
	            return SendErrorMessage(playerid, "You can't afford to release this vehicle.");

            GiveMoney(playerid, -CarData[carid][carImpoundPrice]);

            CarData[carid][carPos][0] = ImpoundData[id][impoundRelease][0];
            CarData[carid][carPos][1] = ImpoundData[id][impoundRelease][1];
            CarData[carid][carPos][2] = ImpoundData[id][impoundRelease][2];
            CarData[carid][carPos][3] = ImpoundData[id][impoundRelease][3];

			SetVehiclePos(CarData[carid][carVehicle], CarData[carid][carPos][0], CarData[carid][carPos][1], CarData[carid][carPos][2]);
			SetVehicleZAngle(CarData[carid][carVehicle], CarData[carid][carPos][3]);

			SendServerMessage(playerid, "You have released your %s for %s.", ReturnVehicleModelName(CarData[carid][carModel]), FormatNumber(CarData[carid][carImpoundPrice]));

            CarData[carid][carImpounded] = -1;
            CarData[carid][carImpoundPrice] = 0;

            Car_Save(carid);
	    }
	}
	return 1;
}

