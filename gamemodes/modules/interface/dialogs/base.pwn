/*
    File: modules/interface/dialogs/base.pwn
    Purpose: Contains easyDialog callbacks for interface base flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:ShowOnly ======
Dialog:ShowOnly(playerid, response, listitem, inputtext[]) {
	playerid = INVALID_PLAYER_ID;
	response = 0;
	listitem = 0;
	inputtext[0] = '\0';
}

// ====== Dialog:ChargeList ======
Dialog:ChargeList(playerid, response, listitem, inputtext[])
{
	playerid = INVALID_PLAYER_ID;
	response = 0;
	listitem = 0;
	inputtext[0] = '\0';
}

// ====== Dialog:FactionsList ======
Dialog:FactionsList(playerid, response, listitem, inputtext[])
{
	playerid = INVALID_PLAYER_ID;
	response = 0;
	listitem = 0;
	inputtext[0] = '\0';
}

// ====== Dialog:ShowStats ======
Dialog:ShowStats(playerid, response, listitem, inputtext[])
{
	playerid = INVALID_PLAYER_ID;
	response = 0;
	listitem = 0;
	inputtext[0] = '\0';
}
