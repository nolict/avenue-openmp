/*
    File: modules/system/logic/reports.pwn
    Purpose: Contains system gameplay logic and helper functions for reports.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

Report_GetCount(playerid)
{
	new count;

    for (new i = 0; i != MAX_REPORTS; i ++)
	{
	    if (ReportData[i][rExists] && ReportData[i][rPlayer] == playerid)
	    {
	        count++;
		}
	}
	return count;
}

Report_Clear(playerid)
{
    for (new i = 0; i != MAX_REPORTS; i ++)
	{
	    if (ReportData[i][rExists] && ReportData[i][rPlayer] == playerid)
	    {
	        Report_Remove(i);
		}
	}
	return 1;
}

Report_Add(playerid, const text[], type = 1)
{
	for (new i = 0; i != MAX_REPORTS; i ++)
	{
	    if (!ReportData[i][rExists])
	    {
	        ReportData[i][rExists] = true;
	        ReportData[i][rType] = type;
	        ReportData[i][rPlayer] = playerid;

	        strpack(ReportData[i][rText], text, 128 char);
			return i;
		}
	}
	return -1;
}

Report_Remove(reportid)
{
	if (reportid != -1 && ReportData[reportid][rExists])
	{
	    ReportData[reportid][rExists] = false;
	    ReportData[reportid][rPlayer] = INVALID_PLAYER_ID;
	}
	return 1;
}

