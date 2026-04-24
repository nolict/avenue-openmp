/*
    File: modules/system/dialogs/crates.pwn
    Purpose: Contains easyDialog callbacks for system crates flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:Crates ======
Dialog:Crates(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    if (PlayerData[playerid][pCarryCrate] != -1)
	        return SendErrorMessage(playerid, "You are already carrying a crate.");

	    new id = strfind(inputtext, "#");

	    if (id != -1) {
	        id = strval(inputtext[id + 1]);

	        CrateData[id][crateVehicle] = INVALID_VEHICLE_ID;
	        PlayerData[playerid][pCarryCrate] = id;

            SetPlayerAttachedObject(playerid, 4, 964, 1, -0.157020, 0.413313, 0.000000, 0.000000, 88.000000, 180.000000, 0.500000, 0.500000, 0.500000);
            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes a crate out of the vehicle.", ReturnName(playerid, 0));
			SendServerMessage(playerid, "You have taken a %s crate out of the vehicle.", Crate_GetType(CrateData[id][crateType]));
		}
	}
	return 1;
}

