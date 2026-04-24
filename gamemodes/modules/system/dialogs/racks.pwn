/*
    File: modules/system/dialogs/racks.pwn
    Purpose: Contains easyDialog callbacks for system racks flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:RackWeapons ======
Dialog:RackWeapons(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new id = Rack_Nearest(playerid);

	    if (id == -1)
	        return 0;

	    if (!RackData[id][rackWeapons][listitem])
	    {
			if (!GetWeapon(playerid))
			    return SendErrorMessage(playerid, "You must be holding a weapon to store it.");

			RackData[id][rackWeapons][listitem] = GetWeapon(playerid);
			RackData[id][rackAmmo][listitem] = GetPlayerAmmo(playerid);

			ResetWeapon(playerid, GetWeapon(playerid));

			Rack_RefreshGuns(id);
			Rack_Save(id);

			ApplyAnimation(playerid, "WEAPONS", "SHP_Ar_Lift", 4.1, 0, 0, 0, 0, 0, 1);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stored a %s on the weapon rack.", ReturnName(playerid, 0), ReturnWeaponName(RackData[id][rackWeapons][listitem]));
	    }
	    else
	    {
	        GiveWeaponToPlayer(playerid, RackData[id][rackWeapons][listitem], RackData[id][rackAmmo][listitem]);
	        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has taken a %s from the weapon rack.", ReturnName(playerid, 0), ReturnWeaponName(RackData[id][rackWeapons][listitem]));

            RackData[id][rackWeapons][listitem] = 0;
			RackData[id][rackAmmo][listitem] = 0;

			Rack_RefreshGuns(id);
			Rack_Save(id);

			ApplyAnimation(playerid, "WEAPONS", "SHP_Tray_Out", 4.1, 0, 0, 0, 0, 0, 1);
	    }
	}
	return 1;
}

// ====== Dialog:TakeItems ======
Dialog:TakeItems(playerid, response, listitem, inputtext[])
{
	if (GetFactionType(playerid) != FACTION_POLICE || PlayerData[playerid][pTakeItems] == INVALID_PLAYER_ID)
	    return 0;

	if (response)
	{
	    if (!strcmp(inputtext, "Take Weapons")) {
	        ResetWeapons(PlayerData[playerid][pTakeItems]);

	        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has confiscated %s's weapons.", ReturnName(playerid, 0), ReturnName(PlayerData[playerid][pTakeItems], 0));
		}
		else if (!strcmp(inputtext, "Take Seeds")) {
		    Inventory_Remove(PlayerData[playerid][pTakeItems], "Marijuana Seeds", -1);
		    Inventory_Remove(PlayerData[playerid][pTakeItems], "Cocaine Seeds", -1);
		    Inventory_Remove(PlayerData[playerid][pTakeItems], "Heroin Opium Seeds", -1);

	        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has confiscated %s's drug seeds.", ReturnName(playerid, 0), ReturnName(PlayerData[playerid][pTakeItems], 0));
		}
		else if (!strcmp(inputtext, "Take Drugs")) {
		    Inventory_Remove(PlayerData[playerid][pTakeItems], "Marijuana", -1);
		    Inventory_Remove(PlayerData[playerid][pTakeItems], "Cocaine", -1);
		    Inventory_Remove(PlayerData[playerid][pTakeItems], "Heroin", -1);
		    Inventory_Remove(PlayerData[playerid][pTakeItems], "Steroids", -1);

	        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has confiscated %s's drugs.", ReturnName(playerid, 0), ReturnName(PlayerData[playerid][pTakeItems], 0));
		}
		else if (!strcmp(inputtext, "Take Radio")) {
		    Inventory_Remove(PlayerData[playerid][pTakeItems], "Portable Radio", -1);

		    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has confiscated %s's portable radio.", ReturnName(playerid, 0), ReturnName(PlayerData[playerid][pTakeItems], 0));
		}
		else if (!strcmp(inputtext, "Take Weapon License")) {
		    Inventory_Remove(PlayerData[playerid][pTakeItems], "Weapon License", -1);

	        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has confiscated %s's weapon license.", ReturnName(playerid, 0), ReturnName(PlayerData[playerid][pTakeItems], 0));
		}
		else if (!strcmp(inputtext, "Take Driving License")) {
		    Inventory_Remove(PlayerData[playerid][pTakeItems], "Driving License", -1);

	        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has confiscated %s's driving license.", ReturnName(playerid, 0), ReturnName(PlayerData[playerid][pTakeItems], 0));
		}
		else if (!strcmp(inputtext, "Take Backpack")) {
		    Backpack_Delete(GetPlayerBackpack(PlayerData[playerid][pTakeItems]));
		    Inventory_Remove(PlayerData[playerid][pTakeItems], "Backpack", -1);

			SetAccessories(PlayerData[playerid][pTakeItems]);
		    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has confiscated %s's backpack.", ReturnName(playerid, 0), ReturnName(PlayerData[playerid][pTakeItems], 0));
		}
	}
	return 1;
}

