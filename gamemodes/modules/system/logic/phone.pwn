/*
    File: modules/system/logic/phone.pwn
    Purpose: Contains system gameplay logic and helper functions for phone.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== IsPlayerOnPhone ======
stock IsPlayerOnPhone(playerid)
{
	if (PlayerData[playerid][pEmergency] > 0 || PlayerData[playerid][pPlaceAd] > 0 || PlayerData[playerid][pCallLine] != INVALID_PLAYER_ID)
	    return 1;

	return 0;
}

// ====== Waypoint_Set ======
Waypoint_Set(playerid, name[], Float:x, Float:y, Float:z)
{
    format(PlayerData[playerid][pLocation], 32, name);

    PlayerData[playerid][pWaypoint] = 1;
   	PlayerData[playerid][pWaypointPos][0] = x;
    PlayerData[playerid][pWaypointPos][1] = y;
   	PlayerData[playerid][pWaypointPos][2] = z;

	SetPlayerCheckpoint(playerid, x, y, z, 3.0);
	PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][69]);

	return 1;
}

// ====== Location_Add ======
Location_Add(playerid, name[], Float:x, Float:y, Float:z)
{
	new
	    query[192];

	for (new i = 0; i != MAX_GPS_LOCATIONS; i ++) if (!LocationData[playerid][i][locationExists])
	{
	    LocationData[playerid][i][locationExists] = true;
	    format(LocationData[playerid][i][locationName], 32, name);

	    LocationData[playerid][i][locationPos][0] = x;
	    LocationData[playerid][i][locationPos][1] = y;
	    LocationData[playerid][i][locationPos][2] = z;

		format(query, sizeof(query), "INSERT INTO `gps` (`ID`, `locationName`, `locationX`, `locationY`, `locationZ`) VALUES('%d', '%s', '%.4f', '%.4f', '%.4f')", PlayerData[playerid][pID], SQL_ReturnEscaped(name), x, y, z);
		mysql_tquery(g_iHandle, query, "OnLocationCreated", "dd", playerid, i);

		return i;
	}
	return -1;
}

forward OnLocationCreated(playerid, locationid);

// ====== OnLocationCreated ======
public OnLocationCreated(playerid, locationid)
{
    if (!IsPlayerConnected(playerid) || !(0 <= locationid < MAX_GPS_LOCATIONS))
        return 0;

    LocationData[playerid][locationid][locationID] = cache_insert_id(g_iHandle);
    return 1;
}

// ====== Location_GetID ======
Location_GetID(playerid, name[])
{
    for (new i = 0; i != MAX_GPS_LOCATIONS; i ++) if (LocationData[playerid][i][locationExists] && !strcmp(LocationData[playerid][i][locationName], name, true)) {
        return i;
	}
	return -1;
}

// ====== Location_Delete ======
Location_Delete(playerid, name[])
{
	new
		query[96];

    for (new i = 0; i != MAX_GPS_LOCATIONS; i ++) if (LocationData[playerid][i][locationExists] && !strcmp(LocationData[playerid][i][locationName], name))
	{
	    LocationData[playerid][i][locationExists] = false;

	    LocationData[playerid][i][locationPos][0] = 0.0;
	    LocationData[playerid][i][locationPos][1] = 0.0;
	    LocationData[playerid][i][locationPos][2] = 0.0;

	    format(query, sizeof(query), "DELETE FROM `gps` WHERE `ID` = '%d' AND `locationID` = '%d'", PlayerData[playerid][pID], LocationData[playerid][i][locationID]);
	    mysql_tquery(g_iHandle, query);
		return 1;
	}
	return 0;
}

// ====== CancelCall ======
stock CancelCall(playerid)
{
    if (PlayerData[playerid][pCallLine] != INVALID_PLAYER_ID)
	{
 		PlayerData[PlayerData[playerid][pCallLine]][pCallLine] = INVALID_PLAYER_ID;
   		PlayerData[PlayerData[playerid][pCallLine]][pIncomingCall] = 0;

		PlayerData[playerid][pCallLine] = INVALID_PLAYER_ID;
		PlayerData[playerid][pIncomingCall] = 0;
	}
	return 1;
}

// ====== ShowContacts ======
stock ShowContacts(playerid)
{
	new
	    string[32 * MAX_CONTACTS],
		count = 0;

	string = "Add Contact\n";

	for (new i = 0; i != MAX_CONTACTS; i ++) if (ContactData[playerid][i][contactExists]) {
	    format(string, sizeof(string), "%s%s - #%d\n", string, ContactData[playerid][i][contactName], ContactData[playerid][i][contactNumber]);

		ListedContacts[playerid][count++] = i;
	}
	Dialog_Show(playerid, Contacts, DIALOG_STYLE_LIST, "My Contacts", string, "Select", "Back");
	return 1;
}
