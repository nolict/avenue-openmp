/*
    File: modules/property/dialogs/entrances.pwn
    Purpose: Contains easyDialog callbacks for property entrances flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:EntrancePass ======
Dialog:EntrancePass(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new id = (Entrance_Inside(playerid) == -1) ? (Entrance_Nearest(playerid)) : (Entrance_Inside(playerid));

		if (id == -1)
		    return SendErrorMessage(playerid, "You are not in range of any entrance.");

		if (strcmp(EntranceData[id][entrancePass], inputtext) != 0)
            return SendErrorMessage(playerid, "Invalid password specified.");

	    if (!EntranceData[id][entranceLocked])
		{
			EntranceData[id][entranceLocked] = true;
			Entrance_Save(id);

			ShowPlayerFooter(playerid, "You have ~r~locked~w~ the entrance!");
			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
		}
		else
		{
			EntranceData[id][entranceLocked] = false;
			Entrance_Save(id);

			ShowPlayerFooter(playerid, "You have ~g~unlocked~w~ the entrance!");
			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
		}
	}
	return 1;
}

