/*
    File: modules/player/dialogs/accessories.pwn
    Purpose: Contains easyDialog callbacks for player accessories flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:EditGlasses ======
Dialog:EditGlasses(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    switch (listitem)
	    {
	        case 0:
	        {
	            if (!IsPlayerAttachedObjectSlotUsed(playerid, 0))
	            {
	                PlayerData[playerid][pToggleGlasses] = 0;
	                SetPlayerAttachedObject(playerid, 0, PlayerData[playerid][pGlasses], 2, AccessoryData[playerid][0][0], AccessoryData[playerid][0][1], AccessoryData[playerid][0][2], AccessoryData[playerid][0][3], AccessoryData[playerid][0][4], AccessoryData[playerid][0][5], AccessoryData[playerid][0][6], AccessoryData[playerid][0][7], AccessoryData[playerid][0][8]);
					ShowPlayerFooter(playerid, "You have ~g~attached~w~ your glasses.");
				}
				else
				{
				    PlayerData[playerid][pToggleGlasses] = 1;
	                RemovePlayerAttachedObject(playerid, 0);
					ShowPlayerFooter(playerid, "You have ~r~detached~w~ your glasses.");
				}
			}
			case 1:
			{
			    PlayerData[playerid][pToggleGlasses] = 0;
       			SetPlayerAttachedObject(playerid, 0, PlayerData[playerid][pGlasses], 2, AccessoryData[playerid][0][0], AccessoryData[playerid][0][1], AccessoryData[playerid][0][2], AccessoryData[playerid][0][3], AccessoryData[playerid][0][4], AccessoryData[playerid][0][5], AccessoryData[playerid][0][6], AccessoryData[playerid][0][7], AccessoryData[playerid][0][8]);

			    EditAttachedObject(playerid, 0);
			    PlayerData[playerid][pEditType] = 1;
			}
			case 2:
			{
			    RemovePlayerAttachedObject(playerid, 0);
			    PlayerData[playerid][pGlasses] = 0;
			    SendServerMessage(playerid, "You have deleted your glasses.");
			}
		}
	}
	return 1;
}

// ====== Dialog:EditHat ======
Dialog:EditHat(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    switch (listitem)
	    {
	        case 0:
	        {
	            if (!IsPlayerAttachedObjectSlotUsed(playerid, 1))
            	{
	                PlayerData[playerid][pToggleHat] = 0;
	                SetPlayerAttachedObject(playerid, 1, PlayerData[playerid][pHat], 2, AccessoryData[playerid][1][0], AccessoryData[playerid][1][1], AccessoryData[playerid][1][2], AccessoryData[playerid][1][3], AccessoryData[playerid][1][4], AccessoryData[playerid][1][5], AccessoryData[playerid][1][6], AccessoryData[playerid][1][7], AccessoryData[playerid][1][8]);
					ShowPlayerFooter(playerid, "You have ~g~attached~w~ your hat.");
				}
				else
				{
				    PlayerData[playerid][pToggleHat] = 1;
	                RemovePlayerAttachedObject(playerid, 1);
					ShowPlayerFooter(playerid, "You have ~r~detached~w~ your hat.");
				}
			}
			case 1:
			{
			    PlayerData[playerid][pToggleHat] = 0;
	            SetPlayerAttachedObject(playerid, 1, PlayerData[playerid][pHat], 2, AccessoryData[playerid][1][0], AccessoryData[playerid][1][1], AccessoryData[playerid][1][2], AccessoryData[playerid][1][3], AccessoryData[playerid][1][4], AccessoryData[playerid][1][5], AccessoryData[playerid][1][6], AccessoryData[playerid][1][7], AccessoryData[playerid][1][8]);

			    EditAttachedObject(playerid, 1);
			    PlayerData[playerid][pEditType] = 2;
			}
			case 2:
			{
			    RemovePlayerAttachedObject(playerid, 1);
			    PlayerData[playerid][pHat] = 0;
			    SendServerMessage(playerid, "You have deleted your hat.");
			}
		}
	}
	return 1;
}

// ====== Dialog:EditBandana ======
Dialog:EditBandana(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    switch (listitem)
	    {
	        case 0:
	        {
	            if (!IsPlayerAttachedObjectSlotUsed(playerid, 2))
	            {
	                PlayerData[playerid][pToggleBandana] = 0;
	                SetPlayerAttachedObject(playerid, 2, PlayerData[playerid][pBandana], 2, AccessoryData[playerid][2][0], AccessoryData[playerid][2][1], AccessoryData[playerid][2][2], AccessoryData[playerid][2][3], AccessoryData[playerid][2][4], AccessoryData[playerid][2][5], AccessoryData[playerid][2][6], AccessoryData[playerid][2][7], AccessoryData[playerid][2][8]);
					ShowPlayerFooter(playerid, "You have ~g~attached~w~ your bandana.");
				}
				else
				{
				    PlayerData[playerid][pToggleBandana] = 1;
	                RemovePlayerAttachedObject(playerid, 2);
					ShowPlayerFooter(playerid, "You have ~r~detached~w~ your bandana.");
				}
			}
			case 1:
			{
			    PlayerData[playerid][pToggleBandana] = 0;
       			SetPlayerAttachedObject(playerid, 2, PlayerData[playerid][pBandana], 2, AccessoryData[playerid][2][0], AccessoryData[playerid][2][1], AccessoryData[playerid][2][2], AccessoryData[playerid][2][3], AccessoryData[playerid][2][4], AccessoryData[playerid][2][5], AccessoryData[playerid][2][6], AccessoryData[playerid][2][7], AccessoryData[playerid][2][8]);

			    EditAttachedObject(playerid, 2);
			    PlayerData[playerid][pEditType] = 3;
			}
			case 2:
			{
			    RemovePlayerAttachedObject(playerid, 2);
			    PlayerData[playerid][pBandana] = 0;
			    SendServerMessage(playerid, "You have deleted your bandana.");
			}
		}
	}
	return 1;
}

// ====== Dialog:Accessory ======
Dialog:Accessory(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    switch (listitem)
	    {
	        case 0:
	        {
	            if (!PlayerData[playerid][pGlasses])
	                return SendErrorMessage(playerid, "You don't own a pair of glasses.");

	            Dialog_Show(playerid, EditGlasses, DIALOG_STYLE_LIST, DialogStyle_Title("Glasses"), DialogStyle_Body("Toggle Glasses\nEdit Glasses\nDelete Glasses"), "Select", "Cancel");
			}
			case 1:
			{
			    if (!PlayerData[playerid][pHat])
	                return SendErrorMessage(playerid, "You don't own a hat.");

			    Dialog_Show(playerid, EditHat, DIALOG_STYLE_LIST, DialogStyle_Title("Hat"), DialogStyle_Body("Toggle Hat\nEdit Hat\nDelete Hat"), "Select", "Cancel");
			}
			case 2:
			{
			    if (!PlayerData[playerid][pBandana])
	                return SendErrorMessage(playerid, "You don't own a bandana.");

			    Dialog_Show(playerid, EditBandana, DIALOG_STYLE_LIST, DialogStyle_Title("Bandana"), DialogStyle_Body("Toggle Bandana\nEdit Bandana\nDelete Bandana"), "Select", "Cancel");
			}
		}
	}
	return 1;
}

