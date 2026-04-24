/*
    File: modules/interface/commands/interface.pwn
    Purpose: Contains ZCMD command handlers for interface interface features.
    Notes: Keep command parsing here and delegate reusable gameplay work to logic files.
*/

// ====== CMD:panel ======
CMD:panel(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 6 || !IsPlayerAdmin(playerid))
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (g_ServerLocked)
		Dialog_Show(playerid, ServerPanel, DIALOG_STYLE_LIST, "Server Panel", "Unlock Server\nSet Hostname\nExecute Query", "Select", "Cancel");

	else Dialog_Show(playerid, ServerPanel, DIALOG_STYLE_LIST, "Server Panel", "Lock Server\nSet Hostname\nExecute Query", "Select", "Cancel");
	return 1;
}


// ====== CMD:toghud ======
CMD:toghud(playerid, params[])
{
	switch (PlayerData[playerid][pHUD])
	{
	    case 0:
	    {
	        PlayerData[playerid][pDisableSpeedo] = 0;
	        PlayerData[playerid][pHUD] = 1;

	        ShowHungerTextdraw(playerid, 1);
	        SendServerMessage(playerid, "You have enabled the HUD.");

			TextDrawShowForPlayer(playerid, gServerTextdraws[0]);
			TextDrawShowForPlayer(playerid, gServerTextdraws[1]);

	        if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsSpeedoVehicle(GetPlayerVehicleID(playerid)))
		    {
		        for (new i = 34; i < 39; i ++) {
					PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][i]);
	    		}
		    }
		}
	    case 1:
	    {
	        PlayerData[playerid][pDisableSpeedo] = 1;
	        PlayerData[playerid][pHUD] = 0;

	        ShowHungerTextdraw(playerid, 0);
	        SendServerMessage(playerid, "You have disabled the HUD.");

	        TextDrawHideForPlayer(playerid, gServerTextdraws[0]);
			TextDrawHideForPlayer(playerid, gServerTextdraws[1]);

	        for (new i = 34; i < 39; i ++) {
				PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
	    	}
		}
	}
	return 1;
}

