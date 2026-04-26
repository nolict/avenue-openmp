/*
    File: modules/system/dialogs/phone.pwn
    Purpose: Contains easyDialog callbacks for system phone flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:NewContact ======
Dialog:NewContact(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    if (isnull(inputtext))
			return Dialog_Show(playerid, NewContact, DIALOG_STYLE_INPUT, DialogStyle_Title("New Contact"), DialogStyle_Body("Error: Please enter a contact name.\n\nPlease enter the name of the contact below:"), "Submit", "Back");

	    if (strlen(inputtext) > 32)
	        return Dialog_Show(playerid, NewContact, DIALOG_STYLE_INPUT, DialogStyle_Title("New Contact"), DialogStyle_Body("Error: The contact name can't exceed 32 characters.\n\nPlease enter the name of the contact below:"), "Submit", "Back");

		strpack(PlayerData[playerid][pEditingItem], inputtext, 32);

	    Dialog_Show(playerid, EnterNumber, DIALOG_STYLE_INPUT, DialogStyle_Title("Contact Number"), DialogStyle_Body("Contact Name: %s\n\nPlease enter the phone number for this contact:"), "Submit", "Back", inputtext);
	}
	else {
		ShowContacts(playerid);
	}
	return 1;
}

// ====== Dialog:ContactInfo ======
Dialog:ContactInfo(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new
			id = PlayerData[playerid][pContact],
			string[72];

		switch (listitem)
		{
		    case 0:
		    {
		        format(string, 16, "%d", ContactData[playerid][id][contactNumber]);
				cmd_call(playerid, string);
		    }
		    case 1:
		    {
		        format(string, sizeof(string), "DELETE FROM `contacts` WHERE `ID` = '%d' AND `contactID` = '%d'", PlayerData[playerid][pID], ContactData[playerid][id][contactID]);
		        mysql_tquery(g_iHandle, string);

		        SendServerMessage(playerid, "You have deleted \"%s\" from your contacts.", ContactData[playerid][id][contactName]);

		        ContactData[playerid][id][contactExists] = false;
		        ContactData[playerid][id][contactNumber] = 0;
		        ContactData[playerid][id][contactID] = 0;

		        ShowContacts(playerid);
		    }
		}
	}
	else {
	    ShowContacts(playerid);
	}
	return 1;
}

// ====== Dialog:Contacts ======
Dialog:Contacts(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    if (!listitem) {
	        Dialog_Show(playerid, NewContact, DIALOG_STYLE_INPUT, DialogStyle_Title("New Contact"), DialogStyle_Body("Please enter the name of the contact below:"), "Submit", "Back");
	    }
	    else {
		    PlayerData[playerid][pContact] = ListedContacts[playerid][listitem - 1];

	        Dialog_Show(playerid, ContactInfo, DIALOG_STYLE_LIST, DialogStyle_Title(ContactData[playerid][PlayerData[playerid][pContact]][contactName]), "Call Contact\nDelete Contact", "Select", "Back");
	    }
	}
	else {
		cmd_phone(playerid, "\1");
	}
	for (new i = 0; i != MAX_CONTACTS; i ++) {
	    ListedContacts[playerid][i] = -1;
	}
	return 1;
}

// ====== Dialog:DialNumber ======
Dialog:DialNumber(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new
	        string[16];

	    if (isnull(inputtext) || !Core_IsNumeric(inputtext))
	        return Dialog_Show(playerid, DialNumber, DIALOG_STYLE_INPUT, DialogStyle_Title("Dial Number"), DialogStyle_Body("Please enter the number that you wish to dial below:"), "Dial", "Back");

        format(string, 16, "%d", strval(inputtext));
		cmd_call(playerid, string);
	}
	else {
		cmd_phone(playerid, "\1");
	}
	return 1;
}

// ====== Dialog:SendText ======
Dialog:SendText(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new number = strval(inputtext);

	    if (isnull(inputtext) || !Core_IsNumeric(inputtext))
	        return Dialog_Show(playerid, SendText, DIALOG_STYLE_INPUT, DialogStyle_Title("Send Text Message"), DialogStyle_Body("Please enter the number that you wish to send a text message to:"), "Dial", "Back");

        if (GetNumberOwner(number) == INVALID_PLAYER_ID)
            return Dialog_Show(playerid, SendText, DIALOG_STYLE_INPUT, DialogStyle_Title("Send Text Message"), DialogStyle_Body("Error: That number is not online right now.\n\nPlease enter the number that you wish to send a text message to:"), "Dial", "Back");

		PlayerData[playerid][pContact] = GetNumberOwner(number);
		Dialog_Show(playerid, TextMessage, DIALOG_STYLE_INPUT, DialogStyle_Title("Text Message"), DialogStyle_Body("Please enter the message to send to %s:"), "Send", "Back", ReturnName(PlayerData[playerid][pContact], 0));
	}
	else {
		cmd_phone(playerid, "\1");
	}
	return 1;
}

// ====== Dialog:TextMessage ======
Dialog:TextMessage(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		if (isnull(inputtext))
			return Dialog_Show(playerid, TextMessage, DIALOG_STYLE_INPUT, DialogStyle_Title("Text Message"), DialogStyle_Body("Error: Please enter a message to send.\n\nPlease enter the message to send to %s:"), "Send", "Back", ReturnName(PlayerData[playerid][pContact], 0));

		new targetid = PlayerData[playerid][pContact];

		if (!IsPlayerConnected(targetid) || !PlayerData[targetid][pPhone])
		    return SendErrorMessage(playerid, "The specified phone number went offline.");

		GiveMoney(playerid, -1);
		ShowPlayerFooter(playerid, "You've been ~r~charged~w~ $1 to send a text.");

		SendClientMessageEx(targetid, COLOR_YELLOW, "TEXT: %s - %s (%d)", inputtext, ReturnName(playerid, 0), PlayerData[playerid][pPhone]);
		SendClientMessageEx(playerid, COLOR_YELLOW, "TEXT: %s - %s (%d)", inputtext, ReturnName(playerid, 0), PlayerData[playerid][pPhone]);

        PlayerPlaySoundEx(targetid, 21001);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out their phone and sends a text.", ReturnName(playerid, 0));
	}
	else {
        Dialog_Show(playerid, SendText, DIALOG_STYLE_INPUT, DialogStyle_Title("Send Text Message"), DialogStyle_Body("Please enter the number that you wish to send a text message to:"), "Submit", "Back");
	}
	return 1;
}

// ====== Dialog:MyPhone ======
Dialog:MyPhone(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		switch (listitem)
		{
		    case 0:
		    {
		        if (PlayerData[playerid][pPhoneOff])
		            return SendErrorMessage(playerid, "Your phone must be powered on.");

				Dialog_Show(playerid, DialNumber, DIALOG_STYLE_INPUT, DialogStyle_Title("Dial Number"), DialogStyle_Body("Please enter the number that you wish to dial below:"), "Dial", "Back");
			}
			case 1:
			{
			    if (PlayerData[playerid][pPhoneOff])
		            return SendErrorMessage(playerid, "Your phone must be powered on.");

			    ShowContacts(playerid);
			}
		    case 2:
		    {
		        if (PlayerData[playerid][pPhoneOff])
		            return SendErrorMessage(playerid, "Your phone must be powered on.");

		        Dialog_Show(playerid, SendText, DIALOG_STYLE_INPUT, DialogStyle_Title("Send Text Message"), DialogStyle_Body("Please enter the number that you wish to send a text message to:"), "Dial", "Back");
			}
			case 3:
			{
			    if (!PlayerData[playerid][pPhoneOff])
			    {
           			if (PlayerData[playerid][pCallLine] != INVALID_PLAYER_ID) {
			        	CancelCall(playerid);
					}
					PlayerData[playerid][pPhoneOff] = 1;
			        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has powered off their cellphone.", ReturnName(playerid, 0));
				}
				else
				{
				    PlayerData[playerid][pPhoneOff] = 0;
			        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has powered on their cellphone.", ReturnName(playerid, 0));
				}
			}
		}
	}
	return 1;
}

