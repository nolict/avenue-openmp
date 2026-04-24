/*
    File: modules/property/logic/nearest.pwn
    Purpose: Contains property gameplay logic and helper functions for nearest.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== GetClosestBusiness ======
GetClosestBusiness(playerid, type)
{
	new
	    Float:fDistance[2] = {99999.0, 0.0},
	    iIndex = -1
	;
	for (new i = 0; i < MAX_BUSINESSES; i ++) if (BusinessData[i][bizExists] && BusinessData[i][bizType] == type && GetPlayerInterior(playerid) == BusinessData[i][bizExterior] && GetPlayerVirtualWorld(playerid) == BusinessData[i][bizExteriorVW])
	{
		fDistance[1] = GetPlayerDistanceFromPoint(playerid, BusinessData[i][bizPos][0], BusinessData[i][bizPos][1], BusinessData[i][bizPos][2]);

		if (fDistance[1] < fDistance[0])
		{
		    fDistance[0] = fDistance[1];
		    iIndex = i;
		}
	}
	return iIndex;
}

// ====== GetClosestEntrance ======
GetClosestEntrance(playerid, type)
{
	new
	    Float:fDistance[2] = {99999.0, 0.0},
	    iIndex = -1
	;
	for (new i = 0; i < MAX_ENTRANCES; i ++) if (EntranceData[i][entranceExists] && EntranceData[i][entranceType] == type && GetPlayerInterior(playerid) == EntranceData[i][entranceExterior] && GetPlayerVirtualWorld(playerid) == EntranceData[i][entranceExteriorVW])
	{
		fDistance[1] = GetPlayerDistanceFromPoint(playerid, EntranceData[i][entrancePos][0], EntranceData[i][entrancePos][1], EntranceData[i][entrancePos][2]);

		if (fDistance[1] < fDistance[0])
		{
		    fDistance[0] = fDistance[1];
		    iIndex = i;
		}
	}
	return iIndex;
}

// ====== House_Nearest ======
House_Nearest(playerid)
{
    for (new i = 0; i != MAX_HOUSES; i ++) if (HouseData[i][houseExists] && IsPlayerInRangeOfPoint(playerid, 2.5, HouseData[i][housePos][0], HouseData[i][housePos][1], HouseData[i][housePos][2]))
	{
		if (GetPlayerInterior(playerid) == HouseData[i][houseExterior] && GetPlayerVirtualWorld(playerid) == HouseData[i][houseExteriorVW])
			return i;
	}
	return -1;
}
