/*
    File: modules/interface/logic/boxes.pwn
    Purpose: Contains interface gameplay logic and helper functions for boxes.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== HidePlayerBox ======
forward HidePlayerBox(playerid, PlayerText:boxid);

// ====== HidePlayerBox ======
public HidePlayerBox(playerid, PlayerText:boxid)
{
	if (!IsPlayerConnected(playerid) || !SQL_IsLogged(playerid))
	    return 0;

	PlayerTextDrawHide(playerid, boxid);
	PlayerTextDrawDestroy(playerid, boxid);

	return 1;
}

// ====== ShowPlayerBox ======
stock PlayerText:ShowPlayerBox(playerid, color)
{
	new
	    PlayerText:textid;

    textid = CreatePlayerTextDraw(playerid, 0.000000, 0.000000, "_");
	PlayerTextDrawFont(playerid, textid, 1);
	PlayerTextDrawLetterSize(playerid, textid, 0.500000, 50.000000);
	PlayerTextDrawColor(playerid, textid, -1);
	PlayerTextDrawUseBox(playerid, textid, 1);
	PlayerTextDrawBoxColor(playerid, textid, color);
	PlayerTextDrawTextSize(playerid, textid, 640.000000, 30.000000);
	PlayerTextDrawShow(playerid, textid);

	return textid;
}
