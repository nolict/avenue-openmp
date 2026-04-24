/*
    File: modules/mapping/dialogs/navigation.pwn
    Purpose: Contains easyDialog callbacks for mapping navigation flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:MainGPS ======
Dialog:MainGPS(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    switch (listitem)
	    {
	        case 0:
	            Dialog_Show(playerid, FindHouse, DIALOG_STYLE_INPUT, DialogStyle_Title("Find House"), DialogStyle_Body("Please enter the address of the house below:"), "Submit", "Cancel");

			case 1:
			    Dialog_Show(playerid, FindBusiness, DIALOG_STYLE_LIST, DialogStyle_Title("Find Business"), DialogStyle_Body("Retail Store\nWeapon Store\nClothing Store\nFast Food\nDealership\nGas Station\nFurniture Store"), "Submit", "Cancel");

			case 2:
			    Dialog_Show(playerid, FindEntrance, DIALOG_STYLE_LIST, DialogStyle_Title("Find Entrance"), DialogStyle_Body("Nearest DMV\nNearest Bank\nNearest Warehouse\nNearest City Hall"), "Select", "Cancel");

			case 3:
			    Dialog_Show(playerid, FindJob, DIALOG_STYLE_LIST, DialogStyle_Title("Find Job"), DialogStyle_Body("Courier\nMechanic\nTaxi Driver\nCargo Unloader\nMiner\nFood Vendor\nGarbage Man\nPackage Sorter"), "Select", "Cancel");

			case 4:
			{
				static
				    string[MAX_GPS_LOCATIONS * 32];

				string = "Add Location\n";

				for (new i = 0; i != MAX_GPS_LOCATIONS; i ++) if (LocationData[playerid][i][locationExists]) {
				    format(string, sizeof(string), "%s%s\n", string, LocationData[playerid][i][locationName]);
				}
				Dialog_Show(playerid, CustomLocations, DIALOG_STYLE_LIST, DialogStyle_Title("Custom Locations"), string, "Select", "Back");
			}
		}
	}
	return 1;
}

// ====== Dialog:FindHouse ======
Dialog:FindHouse(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		if (isnull(inputtext) || strlen(inputtext) > 32)
		    return Dialog_Show(playerid, FindHouse, DIALOG_STYLE_INPUT, DialogStyle_Title("Find House"), DialogStyle_Body("Please enter the address of the house below:"), "Submit", "Cancel");

		for (new i = 0; i != MAX_HOUSES; i ++)
		{
			if (HouseData[i][houseExists] && !strcmp(HouseData[i][houseAddress], inputtext, true))
	    	{
         		Waypoint_Set(playerid, HouseData[i][houseAddress], HouseData[i][housePos][0], HouseData[i][housePos][1], HouseData[i][housePos][2]);
	        	return SendServerMessage(playerid, "Waypoint set to \"%s\" (marked on radar).", HouseData[i][houseAddress]);
			}
		}
        Dialog_Show(playerid, FindHouse, DIALOG_STYLE_INPUT, DialogStyle_Title("Find House"), "Error: No results found for \"%s\".\n\nPlease enter the address of the house below:", "Submit", "Cancel", inputtext);
	}
	else cmd_gps(playerid, "\1");
	return 1;
}

// ====== Dialog:FindBusiness ======
Dialog:FindBusiness(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new bizid = GetClosestBusiness(playerid, listitem + 1);

		if (bizid != -1)
		{
		    Waypoint_Set(playerid, BusinessData[bizid][bizName], BusinessData[bizid][bizPos][0], BusinessData[bizid][bizPos][1], BusinessData[bizid][bizPos][2]);
	        SendServerMessage(playerid, "Waypoint set to closest %s (marked on radar).", inputtext);
		}
		else
		{
			SendErrorMessage(playerid, "The GPS was unable to locate any business.");
		}
	}
	else cmd_gps(playerid, "\1");
	return 1;
}

// ====== Dialog:FindEntrance ======
Dialog:FindEntrance(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new id = GetClosestEntrance(playerid, listitem + 1);

		if (id != -1)
		{
		    Waypoint_Set(playerid, EntranceData[id][entranceName], EntranceData[id][entrancePos][0], EntranceData[id][entrancePos][1], EntranceData[id][entrancePos][2]);
	        SendServerMessage(playerid, "Waypoint set to %s (marked on radar).", inputtext);
		}
		else
		{
			SendErrorMessage(playerid, "The GPS was unable to locate any entrance.");
		}
	}
	else cmd_gps(playerid, "\1");
	return 1;
}

// ====== Dialog:FindJob ======
Dialog:FindJob(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		new id = GetClosestJob(playerid, listitem + 1);

		if (id != -1)
		{
		    static
				str[32];

		    format(str, 32, "%s Job", inputtext);

		    Waypoint_Set(playerid, str, JobData[id][jobPos][0], JobData[id][jobPos][1], JobData[id][jobPos][2]);
	        SendServerMessage(playerid, "Waypoint set to %s (marked on radar).", str);
		}
		else
		{
			SendErrorMessage(playerid, "The GPS was unable to locate any job.");
		}
	}
	else cmd_gps(playerid, "\1");
	return 1;
}

// ====== Dialog:CustomLocations ======
Dialog:CustomLocations(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    if (!listitem) {
			Dialog_Show(playerid, AddLocation, DIALOG_STYLE_INPUT, DialogStyle_Title("Add Location"), DialogStyle_Body("Please enter the desired name of the location below:"), "Submit", "Cancel");
	    }
	    else
		{
		    new id = Location_GetID(playerid, inputtext);

		    if (id != -1) {
		        PlayerData[playerid][pSelectedSlot] = id;

		        Dialog_Show(playerid, LocationInfo, DIALOG_STYLE_LIST, DialogStyle_Title(inputtext), "Set Waypoint\nDelete Location", "Select", "Back");
			}
		}
	}
	else cmd_gps(playerid, "\1");
	return 1;
}

// ====== Dialog:AddLocation ======
Dialog:AddLocation(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    if (isnull(inputtext))
	        return Dialog_Show(playerid, AddLocation, DIALOG_STYLE_INPUT, DialogStyle_Title("Add Location"), DialogStyle_Body("Please enter the desired name of the location below:"), "Submit", "Cancel");

		if (strlen(inputtext) > 32)
		    return Dialog_Show(playerid, AddLocation, DIALOG_STYLE_INPUT, DialogStyle_Title("Add Location"), DialogStyle_Body("Error: The name can't exceed 32 characters.\n\nPlease enter the desired name of the location below:"), "Submit", "Cancel");

		static
		    Float:fX,
		    Float:fY,
		    Float:fZ,
			id = -1;

		if ((id = House_Inside(playerid)) != -1) {
		    fX = HouseData[id][housePos][0];
		    fY = HouseData[id][housePos][1];
		    fZ = HouseData[id][housePos][2];
		}
		else if ((id = Business_Inside(playerid)) != -1) {
		    fX = BusinessData[id][bizPos][0];
		    fY = BusinessData[id][bizPos][1];
		    fZ = BusinessData[id][bizPos][2];
		}
        else if ((id = Entrance_Inside(playerid)) != -1) {
		    fX = EntranceData[id][entrancePos][0];
		    fY = EntranceData[id][entrancePos][1];
		    fZ = EntranceData[id][entrancePos][2];
		}
		else GetPlayerPos(playerid, fX, fY, fZ);

		Location_Add(playerid, inputtext, fX, fY, fZ);
		SendServerMessage(playerid, "You have added \"%s\" to your GPS.", inputtext);
	}
	else cmd_gps(playerid, "\1");
	return 1;
}

// ====== Dialog:LocationInfo ======
Dialog:LocationInfo(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new id = PlayerData[playerid][pSelectedSlot];

	    switch (listitem)
	    {
	        case 0:
	        {
	            Waypoint_Set(playerid, LocationData[playerid][id][locationName], LocationData[playerid][id][locationPos][0], LocationData[playerid][id][locationPos][1], LocationData[playerid][id][locationPos][2]);
				SendServerMessage(playerid, "Waypoint set to \"%s\" (marked on radar).", LocationData[playerid][id][locationName]);
			}
			case 1:
			{
			    SendServerMessage(playerid, "You have removed \"%s\" from your GPS.", LocationData[playerid][id][locationName]);

				Location_Delete(playerid, LocationData[playerid][id][locationName]);
				dialog_MainGPS(playerid, 1, 4, "\1");
			}
	    }
	}
	else dialog_MainGPS(playerid, 1, 4, "\1");
	return 1;
}

