/*
    File: modules/faction/dialogs/enforcement.pwn
    Purpose: Contains easyDialog callbacks for faction enforcement flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:Warrants ======
Dialog:Warrants(playerid, response, listitem, inputtext[])
{
	if (GetFactionType(playerid) != FACTION_POLICE || !IsACruiser(GetPlayerVehicleID(playerid)))
	    return 0;

	if (response)
	{
	    static
	        name[64],
			targetid = INVALID_PLAYER_ID;

		strmid(name, inputtext, 0, strfind(inputtext, "(") - 1);

		if ((targetid = GetPlayerID(name, 0)) == INVALID_PLAYER_ID)
		    return SendErrorMessage(playerid, "The player is no longer connected.");

		if (PlayerData[targetid][pWarrants] < 1)
		    return SendErrorMessage(playerid, "The player no longer has any warrants.");

		PlayerData[playerid][pMDCPlayer] = targetid;

		format(name, sizeof(name), "MDC: %s", name);
		Dialog_Show(playerid, WarrantList, DIALOG_STYLE_LIST, DialogStyle_Title(name), "Track Player\nClear Warrants", "Select", "Back");
	}
	else cmd_mdc(playerid, "\1");
	return 1;
}

// ====== Dialog:WarrantList ======
Dialog:WarrantList(playerid, response, listitem, inputtext[])
{
	if (GetFactionType(playerid) != FACTION_POLICE || !IsACruiser(GetPlayerVehicleID(playerid)) || PlayerData[playerid][pMDCPlayer] == INVALID_PLAYER_ID)
	    return 0;

	if (response)
	{
	    switch (listitem)
	    {
	        case 0:
	        {
	            SendServerMessage(playerid, "The MDC Satellite System is now trying to track %s...", ReturnName(PlayerData[playerid][pMDCPlayer], 0));
	            PlayerData[playerid][pTrackTime] = 3;
			}
			case 1:
			{
			    PlayerData[PlayerData[playerid][pMDCPlayer]][pWarrants] = 0;

			    SendServerMessage(playerid, "You have cleared %s's warrants.", ReturnName(PlayerData[playerid][pMDCPlayer], 0));
			    SendFactionMessage(PlayerData[playerid][pFaction], COLOR_RADIO, "RADIO: %s has cleared %s's active warrants.", ReturnName(playerid, 0), ReturnName(PlayerData[playerid][pMDCPlayer], 0));

			    PlayerData[playerid][pMDCPlayer] = INVALID_PLAYER_ID;
			}
	    }
	}
	else
	{
	    PlayerData[playerid][pMDCPlayer] = INVALID_PLAYER_ID;
	    dialog_MainMDC(playerid, 1, 0, "\1");
	}
	return 1;
}

// ====== Dialog:ChargeName ======
Dialog:ChargeName(playerid, response, listitem, inputtext[])
{
	if (GetFactionType(playerid) != FACTION_POLICE || !IsACruiser(GetPlayerVehicleID(playerid)))
	    return 0;

	if (response)
	{
	    new targetid;

	    if (sscanf(inputtext, "u", targetid))
	        return Dialog_Show(playerid, ChargeName, DIALOG_STYLE_INPUT, DialogStyle_Title("Place Charges"), DialogStyle_Body("Error: Please enter a valid user.\n\nPlease enter the name or ID of the player:"), "Submit", "Back");

		if (targetid == INVALID_PLAYER_ID)
		    return Dialog_Show(playerid, ChargeName, DIALOG_STYLE_INPUT, DialogStyle_Title("Place Charges"), DialogStyle_Body("Error: Invalid user specified.\n\nPlease enter the name or ID of the player:"), "Submit", "Back");

        if (PlayerData[targetid][pWarrants] > 14)
		    return Dialog_Show(playerid, ChargeName, DIALOG_STYLE_INPUT, DialogStyle_Title("Place Charges"), DialogStyle_Body("Error: The user already has 15 active warrants.\n\nPlease enter the name or ID of the player:"), "Submit", "Back");

		PlayerData[playerid][pMDCPlayer] = targetid;
		Dialog_Show(playerid, PlaceCharge, DIALOG_STYLE_INPUT, DialogStyle_Title("Place Charge"), DialogStyle_Body("Please enter the description of the crime committed by %s:"), "Submit", "Back", ReturnName(PlayerData[playerid][pMDCPlayer], 0));
	}
	else cmd_mdc(playerid, "\1");
	return 1;
}

// ====== Dialog:PlaceCharge ======
Dialog:PlaceCharge(playerid, response, listitem, inputtext[])
{
	if (GetFactionType(playerid) != FACTION_POLICE || !IsACruiser(GetPlayerVehicleID(playerid)) || PlayerData[playerid][pMDCPlayer] == INVALID_PLAYER_ID)
	    return 0;

	if (response)
	{
	    if (isnull(inputtext))
			return Dialog_Show(playerid, PlaceCharge, DIALOG_STYLE_INPUT, DialogStyle_Title("Place Charge"), DialogStyle_Body("Please enter the description of the crime committed by %s:"), "Submit", "Back", ReturnName(PlayerData[playerid][pMDCPlayer], 0));

	    PlayerData[PlayerData[playerid][pMDCPlayer]][pWarrants]++;

	    AddWarrant(PlayerData[playerid][pMDCPlayer], playerid, inputtext);
	    SendFactionMessage(PlayerData[playerid][pFaction], COLOR_RADIO, "RADIO: %s has placed a charge on %s for \"%s\".", ReturnName(playerid, 0), ReturnName(PlayerData[playerid][pMDCPlayer], 0), inputtext);

	    cmd_mdc(playerid, "\1");
	}
	else
	{
	    PlayerData[playerid][pMDCPlayer] = INVALID_PLAYER_ID;
	    cmd_mdc(playerid, "\1");
	}
	return 1;
}

// ====== Dialog:MainMDC ======
Dialog:MainMDC(playerid, response, listitem, inputtext[])
{
	if (GetFactionType(playerid) != FACTION_POLICE || !IsACruiser(GetPlayerVehicleID(playerid)))
	    return 0;

	if (response)
	{
	    switch (listitem)
	    {
	        case 0:
	        {
	            static
	                string[512];

				string[0] = 0;

				foreach (new i : Player) if (PlayerData[i][pWarrants] > 0) {
				    format(string, sizeof(string), "%s%s (%d warrants)\n", string, ReturnName(i, 0), PlayerData[i][pWarrants]);
				}
				if (!strlen(string))
				    return SendErrorMessage(playerid, "There are no active warrants.");

				Dialog_Show(playerid, Warrants, DIALOG_STYLE_LIST, DialogStyle_Title("Active Warrants"), string, "Select", "Back");
    		}
    		case 1:
    		{
    		    Dialog_Show(playerid, ChargeName, DIALOG_STYLE_INPUT, DialogStyle_Title("Place Charges"), DialogStyle_Body("Please enter the name or ID of the player:"), "Submit", "Back");
			}
			case 2:
    		{
    		    Dialog_Show(playerid, ViewCharges, DIALOG_STYLE_INPUT, DialogStyle_Title("View Charges"), DialogStyle_Body("Please enter the name or ID of the player:"), "Submit", "Back");
			}
	    }
	}
	return 1;
}

// ====== Dialog:ViewCharges ======
Dialog:ViewCharges(playerid, response, listitem, inputtext[])
{
	if (GetFactionType(playerid) != FACTION_POLICE || !IsACruiser(GetPlayerVehicleID(playerid)))
	    return 0;

	if (response)
	{
		if (isnull(inputtext) || strlen(inputtext) > 24)
		    return Dialog_Show(playerid, ViewCharges, DIALOG_STYLE_INPUT, DialogStyle_Title("View Charges"), DialogStyle_Body("Please enter the name or ID of the player:"), "Submit", "Back");

		if (Core_IsNumeric(inputtext) && IsPlayerConnected(strval(inputtext))) {
	        ViewCharges(playerid, ReturnName(strval(inputtext)));
		}
	    else if (!Core_IsNumeric(inputtext)) {
	        ViewCharges(playerid, inputtext);
		}
		else {
		    Dialog_Show(playerid, ViewCharges, DIALOG_STYLE_INPUT, DialogStyle_Title("View Charges"), DialogStyle_Body("Error: Invalid user specified.\n\nPlease enter the name or ID of the player:"), "Submit", "Back");
		}
	}
	else cmd_mdc(playerid, "\1");
	return 1;
}

