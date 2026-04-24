/*
    File: modules/player/dialogs/tasks.pwn
    Purpose: Contains easyDialog callbacks for player tasks flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:NewTasks ======
Dialog:NewTasks(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    if (!strcmp(inputtext, "Visit Bank (pending)"))
	    {
	        new id = GetClosestEntrance(playerid, 2);

	        if (id == -1)
	            return SendErrorMessage(playerid, "There are no banks spawned in the server.");

			SetPlayerCheckpoint(playerid, EntranceData[id][entrancePos][0], EntranceData[id][entrancePos][1], EntranceData[id][entrancePos][2], 1.0);
			SendServerMessage(playerid, "Checkpoint set to the closest bank (marked on radar).");
		}
		else if (!strcmp(inputtext, "Visit Store (pending)"))
	    {
	        new id = GetClosestBusiness(playerid, 1);

	        if (id == -1)
	            return SendErrorMessage(playerid, "There are no retail stores spawned in the server.");

			SetPlayerCheckpoint(playerid, BusinessData[id][bizPos][0], BusinessData[id][bizPos][1], BusinessData[id][bizPos][2], 1.0);
			SendServerMessage(playerid, "Checkpoint set to the closest retail store (marked on radar).");
		}
		else if (!strcmp(inputtext, "Visit DMV (pending)"))
	    {
	        new id = GetClosestEntrance(playerid, 1);

	        if (id == -1)
	            return SendErrorMessage(playerid, "There are no DMV's spawned in the server.");

			SetPlayerCheckpoint(playerid, EntranceData[id][entrancePos][0], EntranceData[id][entrancePos][1], EntranceData[id][entrancePos][2], 1.0);
			SendServerMessage(playerid, "Checkpoint set to the closest DMV (marked on radar).");
		}
	}
	return 1;
}

