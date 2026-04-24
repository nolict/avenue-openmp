/*
    File: modules/vehicle/dialogs/tuning.pwn
    Purpose: Contains easyDialog callbacks for vehicle tuning flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:TuneVehicle ======
Dialog:TuneVehicle(playerid, response, listitem, inputtext[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if (!IsPlayerInAnyVehicle(playerid) || !IsDoorVehicle(vehicleid))
	    return 0;

	if (response)
	{
	    switch (listitem)
	    {
	        case 0:
	            ShowModelSelectionMenu(playerid, "Add Wheels", MODEL_SELECTION_WHEELS, {1025, 1073, 1074, 1075, 1076, 1077, 1078, 1079, 1080, 1081, 1082, 1083, 1084, 1085, 1096, 1097, 1098}, 17, 0.0, 0.0, 90.0);

			case 1:
			    Dialog_Show(playerid, AddNOS, DIALOG_STYLE_LIST, "Add Nitrous", "2x NOS\n5x NOS\n10x NOS", "Select", "Cancel");

			case 2:
			{
			    AddComponent(vehicleid, 1087);
			    SendServerMessage(playerid, "You have added hydraulics to this vehicle.");
			}
	    }
	}
	return 1;
}

// ====== Dialog:AddNOS ======
Dialog:AddNOS(playerid, response, listitem, inputtext[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if (!IsPlayerInAnyVehicle(playerid) || !IsDoorVehicle(vehicleid))
	    return 0;

	if (response)
	{
	    switch (listitem)
	    {
	        case 0:
			{
			    AddComponent(vehicleid, 1009);
			    SendServerMessage(playerid, "You have added 2x NOS to this vehicle.");
			}
			case 1:
			{
			    AddComponent(vehicleid, 1008);
			    SendServerMessage(playerid, "You have added 5x NOS to this vehicle.");
			}
            case 2:
			{
			    AddComponent(vehicleid, 1010);
			    SendServerMessage(playerid, "You have added 10x NOS to this vehicle.");
			}
		}
	}
	return 1;
}

