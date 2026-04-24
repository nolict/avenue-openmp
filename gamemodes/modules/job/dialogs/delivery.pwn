/*
    File: modules/job/dialogs/delivery.pwn
    Purpose: Contains easyDialog callbacks for job delivery flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:StartDelivery ======
Dialog:StartDelivery(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new id = Job_NearestPoint(playerid);

	    if (id == -1)
	        return 0;

		PlayerData[playerid][pLoadType] = listitem + 1;
		PlayerData[playerid][pLoadCrate] = 1;
		PlayerData[playerid][pLoading] = 1;

		SendServerMessage(playerid, "You have selected \"%s\". Load the crates into a truck to begin.", inputtext);
		SetPlayerCheckpoint(playerid, JobData[id][jobPoint][0], JobData[id][jobPoint][1], JobData[id][jobPoint][2], 1.0);

        SetPlayerAttachedObject(playerid, 4, 3014, 1, 0.038192, 0.371544, 0.055191, 0.000000, 90.000000, 357.668670, 1.000000, 1.000000, 1.000000);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);

		ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
		ShowPlayerFooter(playerid, "Press ~y~'N'~w~ to load the crate.");
	}
	return 1;
}

