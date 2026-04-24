/*
    File: modules/furniture/dialogs/catalog.pwn
    Purpose: Contains easyDialog callbacks for furniture catalog flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:ListedFurniture ======
Dialog:ListedFurniture(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new id = House_Inside(playerid);

	    if (id != -1 && House_IsOwner(playerid, id))
	    {
	        PlayerData[playerid][pEditFurniture] = ListedFurniture[playerid][listitem];

			Dialog_Show(playerid, FurnitureList, DIALOG_STYLE_LIST, DialogStyle_Title(FurnitureData[PlayerData[playerid][pEditFurniture]][furnitureName]), "Edit Position\nPickup Furniture\nDestroy Furniture", "Select", "Cancel");
	    }
	}
	for (new i = 0; i != MAX_FURNITURE; i ++) {
	    ListedFurniture[playerid][i] = -1;
	}
	return 1;
}

// ====== Dialog:FurnitureList ======
Dialog:FurnitureList(playerid, response, listitem, inputtext[])
{
	if (response)
	{
        new id = House_Inside(playerid);

	    if (id != -1 && House_IsOwner(playerid, id))
	    {
	   		switch (listitem)
		    {
		        case 0:
				{
					EditDynamicObject(playerid, FurnitureData[PlayerData[playerid][pEditFurniture]][furnitureObject]);
					SendServerMessage(playerid, "You are now editing the position of item \"%s\".", FurnitureData[PlayerData[playerid][pEditFurniture]][furnitureName]);
				}
				case 1:
				{
				    new item = Inventory_Add(playerid, FurnitureData[PlayerData[playerid][pEditFurniture]][furnitureName], FurnitureData[PlayerData[playerid][pEditFurniture]][furnitureModel]);

				    if (item == -1)
        				return SendErrorMessage(playerid, "You don't have any inventory slots left.");

				    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has picked up \"%s\".", ReturnName(playerid, 0), FurnitureData[PlayerData[playerid][pEditFurniture]][furnitureName]);
				    SendServerMessage(playerid, "You have picked up your \"%s\". The item was added to your inventory.", FurnitureData[PlayerData[playerid][pEditFurniture]][furnitureName]);

				    Furniture_Delete(PlayerData[playerid][pEditFurniture]);
					CancelEdit(playerid);

				    PlayerData[playerid][pEditFurniture] = -1;
				}
				case 2:
				{
				    Furniture_Delete(PlayerData[playerid][pEditFurniture]);
				    SendServerMessage(playerid, "You have destroyed furniture \"%s\".", FurnitureData[PlayerData[playerid][pEditFurniture]][furnitureName]);

				    CancelEdit(playerid);
				    PlayerData[playerid][pEditFurniture] = -1;
				}
			}
		}
		else {
			PlayerData[playerid][pEditFurniture] = -1;
		}
	}
	else {
	    PlayerData[playerid][pEditFurniture] = -1;
	}
	return 1;
}

