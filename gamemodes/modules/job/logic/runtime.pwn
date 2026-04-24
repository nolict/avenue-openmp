/*
    File: modules/job/logic/runtime.pwn
    Purpose: Contains job gameplay logic and helper functions for runtime.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== Job_Save ======
Job_Save(jobid)
{
	static
	    query[512];

	format(query, sizeof(query), "UPDATE `jobs` SET `jobType` = '%d', `jobPosX` = '%.4f', `jobPosY` = '%.4f', `jobPosZ` = '%.4f', `jobInterior` = '%d', `jobWorld` = '%d', `jobPointX` = '%.4f', `jobPointY` = '%.4f', `jobPointZ` = '%.4f', `jobDeliverX` = '%.4f', `jobDeliverY` = '%.4f', `jobDeliverZ` = '%.4f', `jobPointInt` = '%d', `jobPointWorld` = '%d' WHERE `jobID` = '%d'",
	    JobData[jobid][jobType],
	    JobData[jobid][jobPos][0],
	    JobData[jobid][jobPos][1],
	    JobData[jobid][jobPos][2],
	    JobData[jobid][jobInterior],
	    JobData[jobid][jobWorld],
	    JobData[jobid][jobPoint][0],
	    JobData[jobid][jobPoint][1],
	    JobData[jobid][jobPoint][2],
	    JobData[jobid][jobDeliver][0],
	    JobData[jobid][jobDeliver][1],
	    JobData[jobid][jobDeliver][2],
	    JobData[jobid][jobPointInt],
	    JobData[jobid][jobPointWorld],
	    JobData[jobid][jobID]
	);
	return mysql_tquery(g_iHandle, query);
}

// ====== Job_GetName ======
Job_GetName(type)
{
	static
	    str[24];

	switch (type)
	{
	    case 1: str = "Courier";
		case 2: str = "Mechanic";
		case 3: str = "Taxi Driver";
		case 4: str = "Cargo Unloader";
		case 5: str = "Miner";
		case 6: str = "Food Vendor";
		case 7: str = "Garbage Man";
		case 8: str = "Package Sorter";
		case 9: str = "Weapon Smuggler";
	    default: str = "None";
	}
	return str;
}


// ====== Job_Refresh ======
Job_Refresh(jobid)
{
	if (jobid != -1 && JobData[jobid][jobExists])
	{
	    for (new i = 0; i < 3; i ++) {
			if (IsValidDynamic3DTextLabel(JobData[jobid][jobText3D][i]))
		    	DestroyDynamic3DTextLabel(JobData[jobid][jobText3D][i]);

			if (IsValidDynamicPickup(JobData[jobid][jobPickups][i]))
		    	DestroyDynamicPickup(JobData[jobid][jobPickups][i]);
		}
		static
		    string[90];

		format(string, sizeof(string), "[%s]\n{FFFFFF}Type /takejob to acquire this job!", Job_GetName(JobData[jobid][jobType]));

		if (JobData[jobid][jobType] == 1) {
		    JobData[jobid][jobText3D][1] = CreateDynamic3DTextLabel("[Courier]\n{FFFFFF}Type /startdelivery to start a delivery.", COLOR_DARKBLUE, JobData[jobid][jobPoint][0], JobData[jobid][jobPoint][1], JobData[jobid][jobPoint][2], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, JobData[jobid][jobPointWorld], JobData[jobid][jobPointInt]);
			JobData[jobid][jobPickups][1] = CreateDynamicPickup(1239, 23, JobData[jobid][jobPoint][0], JobData[jobid][jobPoint][1], JobData[jobid][jobPoint][2], JobData[jobid][jobPointWorld], JobData[jobid][jobPointInt]);
		}
		else if (JobData[jobid][jobType] == 5) {
		    JobData[jobid][jobText3D][1] = CreateDynamic3DTextLabel("[Mining]\n{FFFFFF}Type /mine to begin mining.", COLOR_DARKBLUE, JobData[jobid][jobPoint][0], JobData[jobid][jobPoint][1], JobData[jobid][jobPoint][2], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, JobData[jobid][jobPointWorld], JobData[jobid][jobPointInt]);
			JobData[jobid][jobPickups][1] = CreateDynamicPickup(1239, 23, JobData[jobid][jobPoint][0], JobData[jobid][jobPoint][1], JobData[jobid][jobPoint][2], JobData[jobid][jobPointWorld], JobData[jobid][jobPointInt]);

			JobData[jobid][jobText3D][2] = CreateDynamic3DTextLabel("[Mining]\n{FFFFFF}Deliver your mining rocks at this spot.", COLOR_DARKBLUE, JobData[jobid][jobDeliver][0], JobData[jobid][jobDeliver][1], JobData[jobid][jobDeliver][2], 15.0);
			JobData[jobid][jobPickups][2] = CreateDynamicPickup(1239, 23, JobData[jobid][jobDeliver][0], JobData[jobid][jobDeliver][1], JobData[jobid][jobDeliver][2]);
		}
		else if (JobData[jobid][jobType] == 7) {
		    JobData[jobid][jobText3D][1] = CreateDynamic3DTextLabel("[Garbage Dump]\n{FFFFFF}Type /dumpgarbage to dump your trash.", COLOR_DARKBLUE, JobData[jobid][jobPoint][0], JobData[jobid][jobPoint][1], JobData[jobid][jobPoint][2], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, JobData[jobid][jobPointWorld], JobData[jobid][jobPointInt]);
			JobData[jobid][jobPickups][1] = CreateDynamicPickup(1264, 23, JobData[jobid][jobPoint][0], JobData[jobid][jobPoint][1], JobData[jobid][jobPoint][2], JobData[jobid][jobPointWorld], JobData[jobid][jobPointInt]);
		}
		else if (JobData[jobid][jobType] == 8) {
			JobData[jobid][jobText3D][1] = CreateDynamic3DTextLabel("[Package Sorting]\n{FFFFFF}Type /sorting to begin sorting packages.", COLOR_DARKBLUE, JobData[jobid][jobPoint][0], JobData[jobid][jobPoint][1], JobData[jobid][jobPoint][2], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, JobData[jobid][jobPointWorld], JobData[jobid][jobPointInt]);
			JobData[jobid][jobPickups][1] = CreateDynamicPickup(1239, 23, JobData[jobid][jobPoint][0], JobData[jobid][jobPoint][1], JobData[jobid][jobPoint][2], JobData[jobid][jobPointWorld], JobData[jobid][jobPointInt]);

			JobData[jobid][jobText3D][2] = CreateDynamic3DTextLabel("[Package Sorting]\n{FFFFFF}Deliver your packages here for sorting.", COLOR_DARKBLUE, JobData[jobid][jobDeliver][0], JobData[jobid][jobDeliver][1], JobData[jobid][jobDeliver][2], 15.0);
			JobData[jobid][jobPickups][2] = CreateDynamicPickup(1239, 23, JobData[jobid][jobDeliver][0], JobData[jobid][jobDeliver][1], JobData[jobid][jobDeliver][2]);
		}
        else if (JobData[jobid][jobType] == 9) {
		    JobData[jobid][jobText3D][1] = CreateDynamic3DTextLabel("[Weapon Parts]\n{FFFFFF}Type /craftparts to craft a weapon crate.", COLOR_DARKBLUE, JobData[jobid][jobPoint][0], JobData[jobid][jobPoint][1], JobData[jobid][jobPoint][2], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, JobData[jobid][jobPointWorld], JobData[jobid][jobPointInt]);
			JobData[jobid][jobPickups][1] = CreateDynamicPickup(1239, 23, JobData[jobid][jobPoint][0], JobData[jobid][jobPoint][1], JobData[jobid][jobPoint][2], JobData[jobid][jobPointWorld], JobData[jobid][jobPointInt]);
		}
		JobData[jobid][jobText3D][0] = CreateDynamic3DTextLabel(string, COLOR_DARKBLUE, JobData[jobid][jobPos][0], JobData[jobid][jobPos][1], JobData[jobid][jobPos][2], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, JobData[jobid][jobWorld], JobData[jobid][jobInterior]);
        JobData[jobid][jobPickups][0] = CreateDynamicPickup(1239, 23, JobData[jobid][jobPos][0], JobData[jobid][jobPos][1], JobData[jobid][jobPos][2], JobData[jobid][jobWorld], JobData[jobid][jobInterior]);
	}
	return 1;
}

// ====== Job_Delete ======
Job_Delete(jobid)
{
	if (jobid != -1 && JobData[jobid][jobExists])
	{
	    new
	        string[64];

		format(string, sizeof(string), "DELETE FROM `jobs` WHERE `jobID` = '%d'", JobData[jobid][jobID]);
		mysql_tquery(g_iHandle, string);

        for (new i = 0; i < 3; i ++) {
			if (IsValidDynamic3DTextLabel(JobData[jobid][jobText3D][i]))
		    	DestroyDynamic3DTextLabel(JobData[jobid][jobText3D][i]);

			if (IsValidDynamicPickup(JobData[jobid][jobPickups][i]))
		    	DestroyDynamicPickup(JobData[jobid][jobPickups][i]);
		}
		JobData[jobid][jobExists] = false;
	    JobData[jobid][jobType] = 0;
	    JobData[jobid][jobID] = 0;
	}
	return 1;
}

// ====== Job_Create ======
Job_Create(playerid, type)
{
	static
	    Float:x,
	    Float:y,
	    Float:z;

	if (GetPlayerPos(playerid, x, y, z))
	{
		for (new i = 0; i != MAX_DYNAMIC_JOBS; i ++)
		{
	    	if (!JobData[i][jobExists])
	    	{
	        	JobData[i][jobExists] = true;
	        	JobData[i][jobType] = type;

				JobData[i][jobPos][0] = x;
	        	JobData[i][jobPos][1] = y;
	        	JobData[i][jobPos][2] = z;
	        	JobData[i][jobPoint][0] = 0.0;
	        	JobData[i][jobPoint][1] = 0.0;
	        	JobData[i][jobPoint][2] = 0.0;
	        	JobData[i][jobDeliver][0] = 0.0;
	        	JobData[i][jobDeliver][1] = 0.0;
	        	JobData[i][jobDeliver][2] = 0.0;

	        	JobData[i][jobInterior] = GetPlayerInterior(playerid);
	        	JobData[i][jobWorld] = GetPlayerVirtualWorld(playerid);

                JobData[i][jobPointInt] = 0;
                JobData[i][jobPointWorld] = 0;

	        	Job_Refresh(i);
	        	mysql_tquery(g_iHandle, "INSERT INTO `jobs` (`jobInterior`) VALUES(0)", "OnJobCreated", "d", i);

	        	return i;
	        }
	    }
	}
	return -1;
}

// ====== ForkliftUpdate ======
forward ForkliftUpdate(playerid, vehid);

// ====== ForkliftUpdate ======
public ForkliftUpdate(playerid, vehid)
{
	if (PlayerData[playerid][pJob] != JOB_UNLOADER || GetVehicleModel(vehid) != 530 || !IsPlayerInWarehouse(playerid) || !PlayerData[playerid][pLoading]) {
	    return 0;
	}
	GetVehicleHealth(vehid, CoreVehicles[vehid][vehLoadHealth]);
    PlayerData[playerid][pLoading] = 0;

	CoreVehicles[vehid][vehLoadType] = 7;
	CoreVehicles[vehid][vehCrate] = CreateObject(3798, 0.0, 0.0, 1000.0, 0.0, 0.0, 0.0);

	AttachObjectToVehicle(CoreVehicles[vehid][vehCrate], vehid, 0.0, 1.2, -0.05, 0.0, 0.0, 0.0);
	SetPlayerCheckpoint(playerid, 1306.3438, -45.3100, 1001.0313, 1.5);

	TogglePlayerControllable(playerid, 1);
	SendServerMessage(playerid, "Deliver the crate to the marker.");
	return 1;
}
