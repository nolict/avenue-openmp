/*
    File: modules/furniture/commands/furniture.pwn
    Purpose: Contains ZCMD command handlers for furniture furniture features.
    Notes: Keep command parsing here and delegate reusable gameplay work to logic files.
*/

// ====== CMD:furniture ======
CMD:furniture(playerid, params[])
{
    static
	    houseid = -1;

	if ((houseid = House_Inside(playerid)) != -1 && House_IsOwner(playerid, houseid))
	{
        new
			count = 0,
			string[MAX_FURNITURE * 32];

        for (new i = 0; i != MAX_FURNITURE; i ++) if (count < MAX_HOUSE_FURNITURE && FurnitureData[i][furnitureExists] && FurnitureData[i][furnitureHouse] == houseid) {
    		ListedFurniture[playerid][count++] = i;

    		format(string, sizeof(string), "%s%s (%.2f meters)\n", string, FurnitureData[i][furnitureName], GetPlayerDistanceFromPoint(playerid, FurnitureData[i][furniturePos][0], FurnitureData[i][furniturePos][1], FurnitureData[i][furniturePos][2]));
		}
		if (count) {
			Dialog_Show(playerid, ListedFurniture, DIALOG_STYLE_LIST, DialogStyle_Title("Listed Furniture"), string, "Select", "Cancel");
     	}
     	else SendErrorMessage(playerid, "This house doesn't have any furniture spawned.");
	}
	else SendErrorMessage(playerid, "You are not in range of your house interior.");
	return 1;
}

