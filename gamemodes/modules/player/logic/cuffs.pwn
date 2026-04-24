/*
    File: modules/player/logic/cuffs.pwn
    Purpose: Contains player gameplay logic and helper functions for cuffs.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== BreakCuffs ======
forward BreakCuffs(playerid, userid);

// ====== BreakCuffs ======
public BreakCuffs(playerid, userid)
{
	if (PlayerData[playerid][pCuffed] || PlayerData[playerid][pInjured] || !IsPlayerSpawned(playerid) || !Inventory_HasItem(playerid, "Crowbar") || !IsPlayerNearPlayer(playerid, userid, 6.0) || !PlayerData[userid][pCuffed])
	    return 1;

	if (random(2))
	{
	    ShowPlayerFooter(playerid, "You have ~r~failed~w~ to pick the cuffs.");
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has failed to pick the cuffs.", ReturnName(playerid, 0));
	}
	else
	{
	    PlayerData[userid][pCuffed] = 0;
	    SetPlayerSpecialAction(userid, SPECIAL_ACTION_NONE);

	    ShowPlayerFooter(playerid, "You have ~g~picked~w~ the cuffs.");
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has picked the cuffs from %s's wrists.", ReturnName(playerid, 0), ReturnName(userid, 0));
	}
	return 1;
}
