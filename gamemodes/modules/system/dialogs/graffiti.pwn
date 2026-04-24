/*
    File: modules/system/dialogs/graffiti.pwn
    Purpose: Contains easyDialog callbacks for system graffiti flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:GraffitiColor ======
Dialog:GraffitiColor(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new id = Graffiti_Nearest(playerid);

		if (id == -1)
		    return 0;

	    if (IsSprayingInProgress(id))
	        return SendErrorMessage(playerid, "There is another player spraying at this point already.");

	    switch (listitem)
	    {
	        case 0:
	            PlayerData[playerid][pGraffitiColor] = 0xFFFFFFFF;

	        case 1:
	            PlayerData[playerid][pGraffitiColor] = 0xFFFF0000;

	        case 2:
	            PlayerData[playerid][pGraffitiColor] = 0xFFFFFF00;

	        case 3:
	            PlayerData[playerid][pGraffitiColor] = 0xFF33CC33;

	        case 4:
	            PlayerData[playerid][pGraffitiColor] = 0xFF33CCFF;

	        case 5:
	            PlayerData[playerid][pGraffitiColor] = 0xFFFFA500;

	        case 6:
	            PlayerData[playerid][pGraffitiColor] = 0xFF1394BF;
	    }
	    Dialog_Show(playerid, GraffitiText, DIALOG_STYLE_INPUT, DialogStyle_Title("Graffiti Text"), DialogStyle_Body("Please enter the text you wish to spray below.\n\nNote: Your text input cannot exceed over 64 characters."), "Submit", "Cancel");
	}
	return 1;
}

// ====== Dialog:GraffitiText ======
Dialog:GraffitiText(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new id = Graffiti_Nearest(playerid);

		if (id == -1)
		    return 0;

	    if (isnull(inputtext))
	        return Dialog_Show(playerid, GraffitiText, DIALOG_STYLE_INPUT, DialogStyle_Title("Graffiti Text"), DialogStyle_Body("Please enter the text you wish to spray below.\n\nNote: Your text input cannot exceed over 64 characters."), "Submit", "Cancel");

		if (strlen(inputtext) > 64)
		    return Dialog_Show(playerid, GraffitiText, DIALOG_STYLE_INPUT, DialogStyle_Title("Graffiti Text"), DialogStyle_Body("Error: Your input can't exceed 64 characters.\n\nPlease enter the text you wish to spray below.\n\nNote: Your text input cannot exceed over 64 characters."), "Submit", "Cancel");

        if (IsSprayingInProgress(id))
	        return SendErrorMessage(playerid, "There is another player spraying at this point already.");

        PlayerData[playerid][pGraffiti] = id;
        PlayerData[playerid][pGraffitiTime] = 15;

		strpack(PlayerData[playerid][pGraffitiText], inputtext, 64 char);
		ApplyAnimationEx(playerid, "GRAFFITI", "spraycan_fire", 4.1, 1, 0, 0, 0, 0, 1);

		ShowPlayerFooter(playerid, "You are now spraying your ~g~graffiti.");
		GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~Spraying...~w~ please wait!", 15000, 3);

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out a can of spray paint and sprays the wall.", ReturnName(playerid, 0));
	}
	return 1;
}

