/*
    File: modules/system/dialogs/inventory.pwn
    Purpose: Contains easyDialog callbacks for system inventory flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:Inventory ======
Dialog:Inventory(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new
			itemid = PlayerData[playerid][pInventoryItem],
			string[64];

	    strunpack(string, InventoryData[playerid][itemid][invItem]);

	    switch (listitem)
	    {
	        case 0:
	        {
	            if (!strcmp(string, "Demo Soda") && PlayerData[playerid][pTutorialStage] == 3)
			    {
        			PlayerData[playerid][pThirst] = 100;
        			Dialog_Show(playerid, Tutorial, DIALOG_STYLE_MSGBOX, DialogStyle_Title("Tutorial Message"), DialogStyle_Body("You have learned how to pick up items and use them correctly.\nYou just picked up a soda bottle and used it to refill your thirst.\n\nThe hunger and thirst icons are shown on the right side of your screen.\nIf hunger or thirst reaches zero percent, your character will start losing energy."), "Continue", "");
			    }
			    else
			    {
		            CallLocalFunction("OnPlayerUseItem", "dds", playerid, itemid, string);
				}
	        }
	        case 1:
	        {
	            if (!strcmp(string, "Demo Soda"))
	                return 0;

				PlayerData[playerid][pInventoryItem] = itemid;
				Dialog_Show(playerid, GiveItem, DIALOG_STYLE_INPUT, DialogStyle_Title("Give Item"), DialogStyle_Body("Please enter the name or the ID of the player:"), "Submit", "Cancel");
	        }
	        case 2:
	        {
	            new id = -1;

	            if (!strcmp(string, "Demo Soda") && PlayerData[playerid][pTutorialStage] != 4)
	                return 0;

				if (PlayerData[playerid][pTutorialStage] == 4)
				{
					Inventory_Remove(playerid, "Demo Soda");
					Dialog_Show(playerid, Tutorial, DIALOG_STYLE_MSGBOX, DialogStyle_Title("Tutorial Message"), DialogStyle_Body("You have dropped the soda bottle. You can pick up dropped items with 'N'.\nYou can also give or trade items from your inventory to other players.\n\nYou can store items in house storage or a vehicle trunk.\nYour character inventory can hold up to %d unique items at once."), "Next", "", MAX_INVENTORY);
					return 1;
				}
	            if (IsPlayerInAnyVehicle(playerid) || !IsPlayerSpawned(playerid))
	                return SendErrorMessage(playerid, "You can't drop items right now.");

				else if (!strcmp(string, "Backpack"))
					return cmd_dropbackpack(playerid, "\1");

				else if ((id = Garbage_Nearest(playerid)) != -1)
				{
				    if (GarbageData[id][garbageCapacity] >= 20)
				        return SendErrorMessage(playerid, "This garbage bin is full of trash.");

                    GarbageData[id][garbageCapacity]++;
                    Garbage_Save(id);

					Inventory_Remove(playerid, string);
                    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s throws a \"%s\" into the garbage bin.", ReturnName(playerid, 0), string);

                    format(string, sizeof(string), "[Garbage %d]\n{FFFFFF}Trash Capacity: %d/20", id, GarbageData[id][garbageCapacity]);
                    UpdateDynamic3DTextLabelText(GarbageData[id][garbageText3D], COLOR_DARKBLUE, string);
				}
				else if (InventoryData[playerid][itemid][invQuantity] == 1)
					DropPlayerItem(playerid, itemid);

				else
					Dialog_Show(playerid, DropItem, DIALOG_STYLE_INPUT, DialogStyle_Title("Drop Item"), DialogStyle_Body("Item: %s - Quantity: %d\n\nPlease specify how much of this item you wish to drop:"), "Drop", "Cancel", string, InventoryData[playerid][itemid][invQuantity]);
	        }
	    }
	}
	return 1;
}

// ====== Dialog:DropItem ======
Dialog:DropItem(playerid, response, listitem, inputtext[])
{
	new
	    itemid = PlayerData[playerid][pInventoryItem],
	    string[32];

	strunpack(string, InventoryData[playerid][itemid][invItem]);

	if (response)
	{
	    if (isnull(inputtext))
	        return Dialog_Show(playerid, DropItem, DIALOG_STYLE_INPUT, DialogStyle_Title("Drop Item"), DialogStyle_Body("Item: %s - Quantity: %d\n\nPlease specify how much of this item you wish to drop:"), "Drop", "Cancel", string, InventoryData[playerid][itemid][invQuantity]);

		if (strval(inputtext) < 1 || strval(inputtext) > InventoryData[playerid][itemid][invQuantity])
		    return Dialog_Show(playerid, DropItem, DIALOG_STYLE_INPUT, DialogStyle_Title("Drop Item"), DialogStyle_Body("Error: Insufficient amount specified.\n\nItem: %s - Quantity: %d\n\nPlease specify how much of this item you wish to drop:"), "Drop", "Cancel", string, InventoryData[playerid][itemid][invQuantity]);

		DropPlayerItem(playerid, itemid, strval(inputtext));
	}
	return 1;
}
