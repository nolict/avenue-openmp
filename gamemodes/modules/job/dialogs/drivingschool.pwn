/*
    File: modules/job/dialogs/drivingschool.pwn
    Purpose: Contains easyDialog callbacks for job drivingschool flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:LeaveTest ======
Dialog:LeaveTest(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    CancelDrivingTest(playerid);

	    SendErrorMessage(playerid, "You have failed the driving test since you quit.");
	}
	else
	{
	    PutPlayerInVehicle(playerid, PlayerData[playerid][pTestCar], 0);
	}
	return 1;
}

