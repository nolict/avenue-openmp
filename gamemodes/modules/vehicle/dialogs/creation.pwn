/*
    File: modules/vehicle/dialogs/creation.pwn
    Purpose: Contains easyDialog callbacks for vehicle creation flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:AddVehicleModel ======
Dialog:AddVehicleModel(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new id = PlayerData[playerid][pDealership];

	    if (id != -1 && BusinessData[id][bizExists] && BusinessData[id][bizType] == 5)
	    {
	        if (isnull(inputtext))
	            return Dialog_Show(playerid, AddVehicleModel, DIALOG_STYLE_INPUT, DialogStyle_Title("Add Vehicle"), DialogStyle_Body("Please enter the name or the ID of the vehicle model:"), "Add", "Cancel");

			new model = GetVehicleModelByName(inputtext);

			if (!model)
			    return Dialog_Show(playerid, AddVehicleModel, DIALOG_STYLE_INPUT, DialogStyle_Title("Add Vehicle"), DialogStyle_Body("Error: Invalid model specified.\n\nPlease enter the name or the ID of the vehicle model:"), "Add", "Cancel");

        	for (new i = 0; i != MAX_DEALERSHIP_CARS; i ++)
			{
				if (DealershipCars[id][i][vehModel] == model)
	            	return Dialog_Show(playerid, AddVehicleModel, DIALOG_STYLE_INPUT, DialogStyle_Title("Add Vehicle"), DialogStyle_Body("Error: This model is already sold at this dealership.\n\nPlease enter the name or the ID of the vehicle model:"), "Add", "Cancel");
			}
			PlayerData[playerid][pDealerCar] = model;
			Dialog_Show(playerid, DealerCarPrice, DIALOG_STYLE_INPUT, DialogStyle_Title("Enter Price"), DialogStyle_Body("Please enter a price for '%s':"), "Submit", "Cancel", ReturnVehicleModelName(PlayerData[playerid][pDealerCar]));
	    }
	}
	return 1;
}

// ====== Dialog:AddVehicle ======
Dialog:AddVehicle(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new id = PlayerData[playerid][pDealership];

	    if (id != -1 && BusinessData[id][bizExists] && BusinessData[id][bizType] == 5)
	    {
			if (!listitem)
			{
				Dialog_Show(playerid, AddVehicleModel, DIALOG_STYLE_INPUT, DialogStyle_Title("Add Vehicle"), DialogStyle_Body("Please enter the name or the ID of the vehicle model:"), "Add", "Cancel");
			}
		    else
			{
				static
					cars[212];

				for (new i = 0; i < sizeof(cars); i ++)
  					cars[i] = i + 400;

				ShowModelSelectionMenu(playerid, "Add Vehicle", MODEL_SELECTION_DEALER_ADD, cars, sizeof(cars), -16.0, 0.0, -55.0);
			}
		}
	}
	return 1;
}

// ====== Dialog:EnterNumber ======
Dialog:EnterNumber(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    static
	        name[32],
			string[128];

		strunpack(name, PlayerData[playerid][pEditingItem]);

	    if (isnull(inputtext) || !Core_IsNumeric(inputtext))
	        return Dialog_Show(playerid, EnterNumber, DIALOG_STYLE_INPUT, DialogStyle_Title("Contact Number"), DialogStyle_Body("Contact Name: %s\n\nPlease enter the phone number for this contact:"), "Submit", "Back", name);

		for (new i = 0; i != MAX_CONTACTS; i ++)
		{
			if (!ContactData[playerid][i][contactExists])
			{
            	ContactData[playerid][i][contactExists] = true;
            	ContactData[playerid][i][contactNumber] = strval(inputtext);

				format(ContactData[playerid][i][contactName], 32, name);

				format(string, sizeof(string), "INSERT INTO `contacts` (`ID`, `contactName`, `contactNumber`) VALUES('%d', '%s', '%d')", PlayerData[playerid][pID], SQL_ReturnEscaped(name), ContactData[playerid][i][contactNumber]);
				mysql_tquery(g_iHandle, string, "OnContactAdd", "dd", playerid, i);

				SendServerMessage(playerid, "You have added \"%s\" to your contacts.", name);
                return 1;
			}
	    }
	    SendErrorMessage(playerid, "There is no room left for anymore contacts.");
	}
	else {
		ShowContacts(playerid);
	}
	return 1;
}

