/*
    File: modules/system/dialogs/items.pwn
    Purpose: Contains easyDialog callbacks for system items flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:GiveItem ======
Dialog:GiveItem(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    static
	        userid = -1,
			itemid = -1,
			string[32];

		if (sscanf(inputtext, "u", userid))
		    return Dialog_Show(playerid, GiveItem, DIALOG_STYLE_INPUT, "Give Item", "Please enter the name or the ID of the player:", "Submit", "Cancel");

		if (userid == INVALID_PLAYER_ID)
		    return Dialog_Show(playerid, GiveItem, DIALOG_STYLE_INPUT, "Give Item", "Error: Invalid player specified.\n\nPlease enter the name or the ID of the player:", "Submit", "Cancel");

	    if (!IsPlayerNearPlayer(playerid, userid, 6.0))
			return Dialog_Show(playerid, GiveItem, DIALOG_STYLE_INPUT, "Give Item", "Error: You are not near that player.\n\nPlease enter the name or the ID of the player:", "Submit", "Cancel");

	    if (userid == playerid)
			return Dialog_Show(playerid, GiveItem, DIALOG_STYLE_INPUT, "Give Item", "Error: You can't give items to yourself.\n\nPlease enter the name or the ID of the player:", "Submit", "Cancel");

		itemid = PlayerData[playerid][pInventoryItem];

		if (itemid == -1)
		    return 0;

		strunpack(string, InventoryData[playerid][itemid][invItem]);

		if (InventoryData[playerid][itemid][invQuantity] == 1)
		{
			if (!strcmp(string, "Backpack") && Inventory_HasItem(userid, "Backpack"))
			    return SendErrorMessage(playerid, "That player is already carrying a backpack.");

		    new id = Inventory_Add(userid, string, InventoryData[playerid][itemid][invModel]);

		    if (id == -1)
				return SendErrorMessage(playerid, "That player doesn't have anymore inventory slots.");

			if (!strcmp(string, "Backpack") && (id = GetPlayerBackpack(playerid)) != -1)
			{
			    BackpackData[id][backpackPlayer] = PlayerData[userid][pID];
				Backpack_Save(id);

				SetAccessories(userid);
			    Inventory_Remove(playerid, "Backpack");
			}
		    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out a \"%s\" and gives it to %s.", ReturnName(playerid, 0), string, ReturnName(userid, 0));
		    SendServerMessage(userid, "%s has given you \"%s\" (added to inventory).", ReturnName(playerid, 0), string);

			Inventory_Remove(playerid, string);
		    Log_Write("logs/give_log.txt", "[%s] %s (%s) has given a %s to %s (%s).", ReturnDate(), ReturnName(playerid, 0), PlayerData[playerid][pIP], string, ReturnName(userid, 0), PlayerData[userid][pIP]);
  		}
		else
		{
		    Dialog_Show(playerid, GiveQuantity, DIALOG_STYLE_INPUT, "Give Item", "Item: %s (Quantity: %d)\n\nPlease enter the amount of this item you wish to give %s:", "Give", "Cancel", string, InventoryData[playerid][itemid][invQuantity], ReturnName(userid, 0));
		    PlayerData[playerid][pGiveItem] = userid;
		}
	}
	return 1;
}

// ====== Dialog:GiveQuantity ======
Dialog:GiveQuantity(playerid, response, listitem, inputtext[])
{
	if (response && PlayerData[playerid][pGiveItem] != INVALID_PLAYER_ID)
	{
	    new
	        userid = PlayerData[playerid][pGiveItem],
	        itemid = PlayerData[playerid][pInventoryItem],
			string[32];

		strunpack(string, InventoryData[playerid][itemid][invItem]);

		if (isnull(inputtext))
			return Dialog_Show(playerid, GiveQuantity, DIALOG_STYLE_INPUT, "Give Item", "Item: %s (Quantity: %d)\n\nPlease enter the amount of this item you wish to give %s:", "Give", "Cancel", string, InventoryData[playerid][itemid][invQuantity], ReturnName(userid, 0));

		if (strval(inputtext) < 1 || strval(inputtext) > InventoryData[playerid][itemid][invQuantity])
		    return  Dialog_Show(playerid, GiveQuantity, DIALOG_STYLE_INPUT, "Give Item", "Error: You don't have that much.\n\nItem: %s (Quantity: %d)\n\nPlease enter the amount of this item you wish to give %s:", "Give", "Cancel", string, InventoryData[playerid][itemid][invQuantity], ReturnName(userid, 0));

        new id = Inventory_Add(userid, string, InventoryData[playerid][itemid][invModel], strval(inputtext));

	    if (id == -1)
			return SendErrorMessage(playerid, "That player doesn't have anymore inventory slots.");

	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out a \"%s\" and gives it to %s.", ReturnName(playerid, 0), string, ReturnName(userid, 0));
	    SendServerMessage(userid, "%s has given you \"%s\" (added to inventory).", ReturnName(playerid, 0), string);

		Inventory_Remove(playerid, string, strval(inputtext));
	    Log_Write("logs/give_log.txt", "[%s] %s (%s) has given %d %s to %s (%s).", ReturnDate(), ReturnName(playerid, 0), PlayerData[playerid][pIP], strval(inputtext), string, ReturnName(userid, 0), PlayerData[userid][pIP]);
	}
	return 1;
}

