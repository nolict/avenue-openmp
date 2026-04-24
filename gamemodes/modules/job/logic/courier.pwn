/*
    File: modules/job/logic/courier.pwn
    Purpose: Contains job gameplay logic and helper functions for courier.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== IsShipmentAccepted ======
stock IsShipmentAccepted(businessid)
{
	foreach (new i : Player) if (PlayerData[i][pJob] == JOB_COURIER && PlayerData[i][pShipment] == businessid) {
	    return 1;
	}
	return 0;
}

// ====== CancelShipment ======
stock CancelShipment(playerid)
{
    PlayerData[playerid][pShipment] = -1;

    if (PlayerData[playerid][pDeliverShipment])
    {
		PlayerData[playerid][pDeliverShipment] = 0;
		DisablePlayerCheckpoint(playerid);
	}
	return 1;
}

// ====== ShowShipments ======
stock ShowShipments(playerid)
{
    static
	    string[2048],
		type[24];

	string[0] = 0;

	for (new i = 0; i < MAX_BUSINESSES; i ++) if (BusinessData[i][bizExists] && BusinessData[i][bizShipment] && !IsShipmentAccepted(i))
	{
	    switch (BusinessData[i][bizType]) {
	        case 1: type = "Retail Supplies";
	        case 2: type = "Ammunition";
	        case 3: type = "Clothing";
	        case 4: type = "Food Supplies";
			case 6: type = "Gasoline/Retail";
			case 7: type = "Furniture";
		}
	    format(string, sizeof(string), "%s%d: %s (%s)\n", string, i, BusinessData[i][bizName], type);
	}
	if (!strlen(string)) {
	    SendErrorMessage(playerid, "There are no shipments to accept.");
	}
	else Dialog_Show(playerid, AcceptShipment, DIALOG_STYLE_LIST, "Shipments", string, "Accept", "Cancel");
	return 1;
}
