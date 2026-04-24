/*
    File: modules/job/dialogs/taxi.pwn
    Purpose: Contains easyDialog callbacks for job taxi flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:AcceptTaxi ======
Dialog:AcceptTaxi(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new targetid = strval(inputtext);

	    if (!IsPlayerConnected(targetid))
	        return SendErrorMessage(playerid, "The specified player has disconnected.");

		if (!PlayerData[targetid][pTaxiCalled])
		    return SendErrorMessage(playerid, "That player's call was accepted by another taxi driver.");

		static
			Float:x,
			Float:y,
			Float:z;

		GetPlayerLocationEx(targetid, x, y, z);

		PlayerData[targetid][pTaxiCalled] = 0;
		Waypoint_Set(playerid, GetPlayerLocation(targetid), x, y, z);

        SendServerMessage(playerid, "You have accepted %s's taxi call.", ReturnName(targetid, 0));
        SendServerMessage(targetid, "%s has accepted your taxi call and is on their way.", ReturnName(playerid, 0));
	}
	return 1;
}

