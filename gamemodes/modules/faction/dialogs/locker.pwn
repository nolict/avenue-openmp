/*
    File: modules/faction/dialogs/locker.pwn
    Purpose: Contains easyDialog callbacks for faction locker flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:Locker ======
Dialog:Locker(playerid, response, listitem, inputtext[])
{
	new factionid = PlayerData[playerid][pFaction];

	if (factionid == -1 || !IsNearFactionLocker(playerid))
		return 0;

	if (response)
	{
	    static
	        skins[8],
	        string[512];

		string[0] = 0;

	    if (FactionData[factionid][factionType] != FACTION_GANG)
	    {
	        switch (listitem)
	        {
	            case 0:
	            {
	                if (!PlayerData[playerid][pOnDuty])
	                {
	                    PlayerData[playerid][pOnDuty] = true;
	                    SetPlayerArmour(playerid, 100.0);

	                    SetFactionColor(playerid);
	                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has clocked in and is now on duty.", ReturnName(playerid, 0));
	                }
	                else
	                {
	                    PlayerData[playerid][pOnDuty] = false;
	                    SetPlayerArmour(playerid, 0.0);

	                    SetPlayerColor(playerid, DEFAULT_COLOR);
	                    SetPlayerSkin(playerid, PlayerData[playerid][pSkin]);

	                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has clocked out and is now off duty.", ReturnName(playerid, 0));
	                }
				}
				case 1:
				{
				    SetPlayerArmour(playerid, 100.0);
				    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches into the locker and takes out a vest.", ReturnName(playerid, 0));
				}
				case 2:
				{
					for (new i = 0; i < sizeof(skins); i ++)
					    skins[i] = (FactionData[factionid][factionSkins][i]) ? (FactionData[factionid][factionSkins][i]) : (19300);

					ShowModelSelectionMenu(playerid, "Choose Skin", MODEL_SELECTION_FACTION_SKIN, skins, sizeof(skins), -16.0, 0.0, -55.0);
				}
				case 3:
				{
				    for (new i = 0; i < 10; i ++)
					{
				        if (FactionData[factionid][factionWeapons][i])
							format(string, sizeof(string), "%sWeapon %d: %s\n", string, i + 1, ReturnWeaponName(FactionData[factionid][factionWeapons][i]));

						else format(string, sizeof(string), "%sEmpty Slot\n", string);
				    }
				    Dialog_Show(playerid, LockerWeapons, DIALOG_STYLE_LIST, DialogStyle_Title("Locker Weapons"), string, "Select", "Cancel");
				}
			}
	    }
	    else
	    {
	        switch (listitem)
	        {
				case 0:
				{
					for (new i = 0; i < sizeof(skins); i ++)
					    skins[i] = (FactionData[factionid][factionSkins][i]) ? (FactionData[factionid][factionSkins][i]) : (19300);

					ShowModelSelectionMenu(playerid, "Choose Skin", MODEL_SELECTION_FACTION_SKIN, skins, sizeof(skins), -16.0, 0.0, -55.0);
				}
				case 1:
				{
				    for (new i = 0; i < 10; i ++)
					{
				        if (FactionData[factionid][factionWeapons][i] && GetFactionType(playerid) != FACTION_GANG)
							format(string, sizeof(string), "%sWeapon %d: %s\n", string, i + 1, ReturnWeaponName(FactionData[factionid][factionWeapons][i]));

						else if (FactionData[factionid][factionWeapons][i] && GetFactionType(playerid) == FACTION_GANG)
							format(string, sizeof(string), "%sWeapon %d: %s (%d ammo)\n", string, i + 1, ReturnWeaponName(FactionData[factionid][factionWeapons][i]), FactionData[factionid][factionAmmo][i]);

						else format(string, sizeof(string), "%sEmpty Slot\n", string);
				    }
				    Dialog_Show(playerid, LockerWeapons, DIALOG_STYLE_LIST, DialogStyle_Title("Locker Weapons"), string, "Select", "Cancel");
				}
			}
	    }
	}
	return 1;
}

// ====== Dialog:LockerWeapons ======
Dialog:LockerWeapons(playerid, response, listitem, inputtext[])
{
	new factionid = PlayerData[playerid][pFaction];

	if (factionid == -1 || !IsNearFactionLocker(playerid))
		return 0;

	if (response)
	{
	    new
	        weaponid = FactionData[factionid][factionWeapons][listitem],
	        ammo = FactionData[factionid][factionAmmo][listitem];

	    if (weaponid)
		{
	        if (PlayerHasWeapon(playerid, weaponid))
	            return SendErrorMessage(playerid, "You have this weapon equipped already.");

	        GiveWeaponToPlayer(playerid, weaponid, ammo);
	        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid, 0), ReturnWeaponName(weaponid));

			if (GetFactionType(playerid) == FACTION_GANG)
		    {
		        FactionData[factionid][factionWeapons][listitem] = 0;
		        FactionData[factionid][factionAmmo][listitem] = 0;

		        Faction_Save(factionid);
			}
		}
		else
		{
		    if (GetFactionType(playerid) == FACTION_GANG)
		    {
		        if ((weaponid = GetWeapon(playerid)) == 0)
		            return SendErrorMessage(playerid, "You are not holding any weapon.");

		        FactionData[factionid][factionWeapons][listitem] = weaponid;
		        FactionData[factionid][factionAmmo][listitem] = GetPlayerAmmo(playerid);

		        Faction_Save(factionid);

                ResetWeapon(playerid, weaponid);
		        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out a %s and stores it in the locker.", ReturnName(playerid, 0), ReturnWeaponName(weaponid));
			}
			else
			{
			    SendErrorMessage(playerid, "The selected weapon slot is empty.");
			}
	    }
	}
	else {
	    cmd_flocker(playerid, "\1");
	}
	return 1;
}

// ====== Dialog:FactionLocker ======
Dialog:FactionLocker(playerid, response, listitem, inputtext[])
{
	if (PlayerData[playerid][pFactionEdit] == -1)
	    return 0;

	if (response)
	{
	    switch (listitem)
	    {
	        case 0:
	        {
			    static
			        Float:x,
			        Float:y,
			        Float:z;

				GetPlayerPos(playerid, x, y, z);

				FactionData[PlayerData[playerid][pFactionEdit]][factionLockerPos][0] = x;
				FactionData[PlayerData[playerid][pFactionEdit]][factionLockerPos][1] = y;
				FactionData[PlayerData[playerid][pFactionEdit]][factionLockerPos][2] = z;

				FactionData[PlayerData[playerid][pFactionEdit]][factionLockerInt] = GetPlayerInterior(playerid);
				FactionData[PlayerData[playerid][pFactionEdit]][factionLockerWorld] = GetPlayerVirtualWorld(playerid);

				Faction_Refresh(PlayerData[playerid][pFactionEdit]);
				Faction_Save(PlayerData[playerid][pFactionEdit]);
				SendServerMessage(playerid, "You have adjusted the locker position of faction ID: %d.", PlayerData[playerid][pFactionEdit]);
			}
			case 1:
			{
				static
				    string[512];

				string[0] = 0;

			    for (new i = 0; i < 10; i ++)
				{
			        if (FactionData[PlayerData[playerid][pFactionEdit]][factionWeapons][i])
						format(string, sizeof(string), "%sWeapon %d: %s\n", string, i + 1, ReturnWeaponName(FactionData[PlayerData[playerid][pFactionEdit]][factionWeapons][i]));

					else format(string, sizeof(string), "%sEmpty Slot\n", string);
			    }
			    Dialog_Show(playerid, FactionWeapons, DIALOG_STYLE_LIST, DialogStyle_Title("Locker Weapons"), string, "Select", "Cancel");
			}
		}
	}
	return 1;
}

// ====== Dialog:FactionWeapons ======
Dialog:FactionWeapons(playerid, response, listitem, inputtext[])
{
	if (PlayerData[playerid][pFactionEdit] == -1)
	    return 0;

	if (response)
	{
	    PlayerData[playerid][pSelectedSlot] = listitem;
	    Dialog_Show(playerid, FactionWeapon, DIALOG_STYLE_LIST, DialogStyle_Title("Edit Weapon"), DialogStyle_Body("Set Weapon (%d)\nSet Ammunition (%d)\nClear Slot"), "Select", "Cancel", FactionData[PlayerData[playerid][pFactionEdit]][factionWeapons][PlayerData[playerid][pSelectedSlot]], FactionData[PlayerData[playerid][pFactionEdit]][factionAmmo][PlayerData[playerid][pSelectedSlot]]);
	}
	return 1;
}

// ====== Dialog:FactionWeapon ======
Dialog:FactionWeapon(playerid, response, listitem, inputtext[])
{
	if (PlayerData[playerid][pFactionEdit] == -1)
	    return 0;

	if (response)
	{
	    switch (listitem)
	    {
	        case 0:
	        	Dialog_Show(playerid, FactionWeaponID, DIALOG_STYLE_INPUT, DialogStyle_Title("Set Weapon"), DialogStyle_Body("Current Weapon: %s (%d)\n\nPlease enter the new weapon ID for slot %d:"), "Submit", "Cancel", ReturnWeaponName(FactionData[PlayerData[playerid][pFactionEdit]][factionWeapons][PlayerData[playerid][pSelectedSlot]]), FactionData[PlayerData[playerid][pFactionEdit]][factionWeapons][PlayerData[playerid][pSelectedSlot]], PlayerData[playerid][pSelectedSlot]);

			case 1:
	            Dialog_Show(playerid, FactionWeaponAmmo, DIALOG_STYLE_INPUT, DialogStyle_Title("Set Ammunition"), DialogStyle_Body("Current Ammo: %d\n\nPlease enter the new ammunition for the weapon in slot %d:"), "Submit", "Cancel", FactionData[PlayerData[playerid][pFactionEdit]][factionAmmo][PlayerData[playerid][pSelectedSlot]], PlayerData[playerid][pSelectedSlot]);

			case 2:
			{
			    FactionData[PlayerData[playerid][pFactionEdit]][factionWeapons][PlayerData[playerid][pSelectedSlot]] = 0;
				FactionData[PlayerData[playerid][pFactionEdit]][factionAmmo][PlayerData[playerid][pSelectedSlot]] = 0;

				Faction_Save(PlayerData[playerid][pFactionEdit]);

				dialog_FactionLocker(playerid, 1, 1, "\1");
				SendServerMessage(playerid, "You have removed the weapon in slot %d.", PlayerData[playerid][pSelectedSlot] + 1);
			}
	    }
	}
	else {
	    dialog_FactionLocker(playerid, 1, 1, "\1");
	}
	return 1;
}

// ====== Dialog:FactionWeaponID ======
Dialog:FactionWeaponID(playerid, response, listitem, inputtext[])
{
	if (PlayerData[playerid][pFactionEdit] == -1)
	    return 0;

	if (response)
	{
	    new weaponid = strval(inputtext);

	    if (isnull(inputtext))
	        return Dialog_Show(playerid, FactionWeaponID, DIALOG_STYLE_INPUT, DialogStyle_Title("Set Weapon"), DialogStyle_Body("Current Weapon: %s (%d)\n\nPlease enter the new weapon ID for slot %d:"), "Submit", "Cancel", ReturnWeaponName(FactionData[PlayerData[playerid][pFactionEdit]][factionWeapons][PlayerData[playerid][pSelectedSlot]]), FactionData[PlayerData[playerid][pFactionEdit]][factionWeapons][PlayerData[playerid][pSelectedSlot]], PlayerData[playerid][pSelectedSlot]);

		if (weaponid < 0 || weaponid > 46)
		    return Dialog_Show(playerid, FactionWeaponID, DIALOG_STYLE_INPUT, DialogStyle_Title("Set Weapon"), DialogStyle_Body("Error: The weapon ID can't be below 0 or above 46.\n\nCurrent Weapon: %s (%d)\n\nPlease enter the new weapon ID for slot %d:"), "Submit", "Cancel", ReturnWeaponName(FactionData[PlayerData[playerid][pFactionEdit]][factionWeapons][PlayerData[playerid][pSelectedSlot]]), FactionData[PlayerData[playerid][pFactionEdit]][factionWeapons][PlayerData[playerid][pSelectedSlot]], PlayerData[playerid][pSelectedSlot]);

        FactionData[PlayerData[playerid][pFactionEdit]][factionWeapons][PlayerData[playerid][pSelectedSlot]] = weaponid;
        Faction_Save(PlayerData[playerid][pFactionEdit]);

		Dialog_Show(playerid, FactionWeapon, DIALOG_STYLE_LIST, DialogStyle_Title("Edit Weapon"), DialogStyle_Body("Set Weapon (%d)\nSet Ammunition (%d)\nClear Slot"), "Select", "Cancel", FactionData[PlayerData[playerid][pFactionEdit]][factionWeapons][PlayerData[playerid][pSelectedSlot]], FactionData[PlayerData[playerid][pFactionEdit]][factionAmmo][PlayerData[playerid][pSelectedSlot]]);

	    if (weaponid) {
		    SendServerMessage(playerid, "You have set the weapon in slot %d to %s.", PlayerData[playerid][pSelectedSlot] + 1, ReturnWeaponName(weaponid));
		}
		else {
		    SendServerMessage(playerid, "You have removed the weapon in slot %d.", PlayerData[playerid][pSelectedSlot] + 1);
		}
	}
	return 1;
}

// ====== Dialog:FactionWeaponAmmo ======
Dialog:FactionWeaponAmmo(playerid, response, listitem, inputtext[])
{
	if (PlayerData[playerid][pFactionEdit] == -1)
	    return 0;

	if (response)
	{
	    new ammo = strval(inputtext);

	    if (isnull(inputtext))
	        return Dialog_Show(playerid, FactionWeaponAmmo, DIALOG_STYLE_INPUT, DialogStyle_Title("Set Ammunition"), DialogStyle_Body("Current Ammo: %d\n\nPlease enter the new ammunition for the weapon in slot %d:"), "Submit", "Cancel", FactionData[PlayerData[playerid][pFactionEdit]][factionAmmo][PlayerData[playerid][pSelectedSlot]], PlayerData[playerid][pSelectedSlot]);

		if (ammo < 1 || ammo > 15000)
		    return Dialog_Show(playerid, FactionWeaponAmmo, DIALOG_STYLE_INPUT, DialogStyle_Title("Set Ammunition"), DialogStyle_Body("Error: The ammo can't be below 1 or above 15,000.\n\nCurrent Ammo: %d\n\nPlease enter the new ammunition for the weapon in slot %d:"), "Submit", "Cancel", FactionData[PlayerData[playerid][pFactionEdit]][factionAmmo][PlayerData[playerid][pSelectedSlot]], PlayerData[playerid][pSelectedSlot]);

        FactionData[PlayerData[playerid][pFactionEdit]][factionAmmo][PlayerData[playerid][pSelectedSlot]] = ammo;
        Faction_Save(PlayerData[playerid][pFactionEdit]);

		Dialog_Show(playerid, FactionWeapon, DIALOG_STYLE_LIST, DialogStyle_Title("Edit Weapon"), DialogStyle_Body("Set Weapon (%d)\nSet Ammunition (%d)\nClear Slot"), "Select", "Cancel", FactionData[PlayerData[playerid][pFactionEdit]][factionWeapons][PlayerData[playerid][pSelectedSlot]], FactionData[PlayerData[playerid][pFactionEdit]][factionAmmo][PlayerData[playerid][pSelectedSlot]]);
		SendServerMessage(playerid, "You have set the ammunition in slot %d to %d.", PlayerData[playerid][pSelectedSlot] + 1, ammo);
	}
	return 1;
}

// ====== Dialog:FactionSkin ======
Dialog:FactionSkin(playerid, response, listitem, inputtext[])
{
	if (PlayerData[playerid][pFactionEdit] == -1)
	    return 0;

	if (response)
	{
	    static
	        skins[299];

		switch (listitem)
		{
		    case 0:
		        Dialog_Show(playerid, FactionModel, DIALOG_STYLE_INPUT, DialogStyle_Title("Add by Model ID"), DialogStyle_Body("Please enter the model ID of the skin below (0-299):"), "Add", "Cancel");

			case 1:
			{
			    for (new i = 0; i < sizeof(skins); i ++)
			        skins[i] = i + 1;

				ShowModelSelectionMenu(playerid, "Add Skin", MODEL_SELECTION_ADD_SKIN, skins, sizeof(skins), -16.0, 0.0, -55.0);
			}
			case 2:
			{
			    FactionData[PlayerData[playerid][pFactionEdit]][factionSkins][PlayerData[playerid][pSelectedSlot]] = 0;

			    Faction_Save(PlayerData[playerid][pFactionEdit]);
			    SendServerMessage(playerid, "You have removed the skin ID in slot %d.", PlayerData[playerid][pSelectedSlot] + 1);
			}
		}
	}
	return 1;
}

// ====== Dialog:FactionModel ======
Dialog:FactionModel(playerid, response, listitem, inputtext[])
{
	if (PlayerData[playerid][pFactionEdit] == -1)
	    return 0;

	if (response)
	{
	    new skin = strval(inputtext);

	    if (isnull(inputtext))
	        return Dialog_Show(playerid, FactionModel, DIALOG_STYLE_INPUT, DialogStyle_Title("Add by Model ID"), DialogStyle_Body("Please enter the model ID of the skin below (0-299):"), "Add", "Cancel");

		if (skin < 0 || skin > 299)
		    return Dialog_Show(playerid, FactionModel, DIALOG_STYLE_INPUT, DialogStyle_Title("Add by Model ID"), DialogStyle_Body("Error: The skin ID can't be below 0 or above 299.\n\nPlease enter the model ID of the skin below (0-299):"), "Add", "Cancel");

        FactionData[PlayerData[playerid][pFactionEdit]][factionSkins][PlayerData[playerid][pSelectedSlot]] = skin;
		Faction_Save(PlayerData[playerid][pFactionEdit]);

		if (skin) {
		    SendServerMessage(playerid, "You have set the skin ID in slot %d to %d.", PlayerData[playerid][pSelectedSlot] + 1, skin);
		}
		else {
		    SendServerMessage(playerid, "You have removed the skin ID in slot %d.", PlayerData[playerid][pSelectedSlot] + 1);
		}
	}
	return 1;
}

