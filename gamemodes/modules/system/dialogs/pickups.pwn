/*
    File: modules/system/dialogs/pickups.pwn
    Purpose: Contains easyDialog callbacks for system pickups flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:PickupItems ======
Dialog:PickupItems(playerid, response, listitem, inputtext[])
{
	static
	    string[64];

	if (response)
	{
	    new id = NearestItems[playerid][listitem];

		if (id != -1 && DroppedItems[id][droppedModel])
		{
		    if (DroppedItems[id][droppedWeapon] != 0)
			{
  				if (PlayerData[playerid][pPlayingHours] < 2)
					return SendErrorMessage(playerid, "You must have at least 2 playing hours.");

				GiveWeaponToPlayer(playerid, DroppedItems[id][droppedWeapon], DroppedItems[id][droppedAmmo]);

				Item_Delete(id);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has picked up a %s.", ReturnName(playerid, 0), ReturnWeaponName(DroppedItems[id][droppedWeapon]));
			}
			else if (PickupItem(playerid, id))
			{
				format(string, sizeof(string), "~g~%s~w~ added to inventory!", DroppedItems[id][droppedItem]);
 				ShowPlayerFooter(playerid, string);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has picked up a \"%s\".", ReturnName(playerid, 0), DroppedItems[id][droppedItem]);
			}
			else
				SendErrorMessage(playerid, "You don't have any room in your inventory.");
		}
		else SendErrorMessage(playerid, "This item was already picked up.");
	}
	return 1;
}

