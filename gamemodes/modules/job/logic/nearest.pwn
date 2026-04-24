/*
    File: modules/job/logic/nearest.pwn
    Purpose: Contains job gameplay logic and helper functions for nearest.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== GetClosestJobPoint ======
GetClosestJobPoint(playerid, type)
{
	new
	    Float:fDistance[2] = {99999.0, 0.0},
	    iIndex = -1
	;
	for (new i = 0; i < MAX_DYNAMIC_JOBS; i ++) if (JobData[i][jobExists] && JobData[i][jobType] == type && GetPlayerInterior(playerid) == JobData[i][jobInterior] && GetPlayerVirtualWorld(playerid) == JobData[i][jobWorld])
	{
		fDistance[1] = GetPlayerDistanceFromPoint(playerid, JobData[i][jobPoint][0], JobData[i][jobPoint][1], JobData[i][jobPoint][2]);

		if (fDistance[1] < fDistance[0])
		{
		    fDistance[0] = fDistance[1];
		    iIndex = i;
		}
	}
	return iIndex;
}

// ====== GetClosestJob ======
GetClosestJob(playerid, type)
{
	new
	    Float:fDistance[2] = {99999.0, 0.0},
	    iIndex = -1
	;
	for (new i = 0; i < MAX_DYNAMIC_JOBS; i ++) if (JobData[i][jobExists] && JobData[i][jobType] == type && GetPlayerInterior(playerid) == JobData[i][jobInterior] && GetPlayerVirtualWorld(playerid) == JobData[i][jobWorld])
	{
		fDistance[1] = GetPlayerDistanceFromPoint(playerid, JobData[i][jobPos][0], JobData[i][jobPos][1], JobData[i][jobPos][2]);

		if (fDistance[1] < fDistance[0])
		{
		    fDistance[0] = fDistance[1];
		    iIndex = i;
		}
	}
	return iIndex;
}

// ====== GetClosestHospital ======
GetClosestHospital(playerid)
{
	new
	    Float:fDistance[2] = {99999.0, 0.0},
	    iIndex = -1
	;
	for (new i = 0; i < sizeof(arrHospitalSpawns); i ++)
	{
		fDistance[1] = GetPlayerDistanceFromPoint(playerid, arrHospitalSpawns[i][0], arrHospitalSpawns[i][1], arrHospitalSpawns[i][2]);

		if (fDistance[1] < fDistance[0])
		{
		    fDistance[0] = fDistance[1];
		    iIndex = i;
		}
	}
	return iIndex;
}
// ====== Job_Load ======
forward Job_Load();

// ====== Job_Load ======
public Job_Load()
{
	static
	    rows,
	    fields;

	cache_get_data(rows, fields, g_iHandle);

    for (new i = 0; i < rows; i ++) if (i < MAX_DYNAMIC_JOBS)
	{
	    JobData[i][jobExists] = true;
	    JobData[i][jobID] = cache_get_field_int(i, "jobID");
	    JobData[i][jobType] = cache_get_field_int(i, "jobType");
	    JobData[i][jobPos][0] = cache_get_field_float(i, "jobPosX");
	    JobData[i][jobPos][1] = cache_get_field_float(i, "jobPosY");
	    JobData[i][jobPos][2] = cache_get_field_float(i, "jobPosZ");
	    JobData[i][jobInterior] = cache_get_field_int(i, "jobInterior");
	    JobData[i][jobWorld] = cache_get_field_int(i, "jobWorld");
        JobData[i][jobPoint][0] = cache_get_field_float(i, "jobPointX");
	    JobData[i][jobPoint][1] = cache_get_field_float(i, "jobPointY");
	    JobData[i][jobPoint][2] = cache_get_field_float(i, "jobPointZ");
	    JobData[i][jobDeliver][0] = cache_get_field_float(i, "jobDeliverX");
	    JobData[i][jobDeliver][1] = cache_get_field_float(i, "jobDeliverY");
	    JobData[i][jobDeliver][2] = cache_get_field_float(i, "jobDeliverZ");
	    JobData[i][jobPointInt] = cache_get_field_int(i, "jobPointInt");
	    JobData[i][jobPointWorld] = cache_get_field_int(i, "jobPointWorld");

 	    Job_Refresh(i);
	}
	return 1;
}


// ====== Job_NearestPoint ======
Job_NearestPoint(playerid, Float:radius = 4.0)
{
    for (new i = 0; i != MAX_DYNAMIC_JOBS; i ++) if (JobData[i][jobExists] && IsPlayerInRangeOfPoint(playerid, radius, JobData[i][jobPoint][0], JobData[i][jobPoint][1], JobData[i][jobPoint][2])) {
		return i;
	}
	return -1;
}

// ====== Job_Nearest ======
Job_Nearest(playerid)
{
    for (new i = 0; i != MAX_DYNAMIC_JOBS; i ++) if (JobData[i][jobExists] && IsPlayerInRangeOfPoint(playerid, 2.5, JobData[i][jobPos][0], JobData[i][jobPos][1], JobData[i][jobPos][2]))
	{
		if (GetPlayerInterior(playerid) == JobData[i][jobInterior] && GetPlayerVirtualWorld(playerid) == JobData[i][jobWorld])
			return i;
	}
	return -1;
}

// ====== IsPlayerNearMine ======
IsPlayerNearMine(playerid)
{
	new
	    id = -1;

	if ((id = Job_NearestPoint(playerid, 10.0)) != -1 && JobData[id][jobType] == 5)
		return 1;

	return 0;
}
