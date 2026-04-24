/*
    File: modules/player/logic/attachments.pwn
    Purpose: Contains player gameplay logic and helper functions for attachments.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== RemoveAttachedObject ======
forward RemoveAttachedObject(playerid, slot);

// ====== RemoveAttachedObject ======
public RemoveAttachedObject(playerid, slot)
{
	if (IsPlayerConnected(playerid) && IsPlayerAttachedObjectSlotUsed(playerid, slot))
	{
	    RemovePlayerAttachedObject(playerid, slot);
	}
	return 1;
}

// ====== SetAccessories ======
SetAccessories(playerid)
{
    for (new i = 0; i != MAX_PLAYER_ATTACHED_OBJECTS; i ++) {
	    RemovePlayerAttachedObject(playerid, i);
	}
	if (PlayerData[playerid][pToggleGlasses]) RemovePlayerAttachedObject(playerid, 0);
	else if (PlayerData[playerid][pGlasses] != 0) SetPlayerAttachedObject(playerid, 0, PlayerData[playerid][pGlasses], 2, AccessoryData[playerid][0][0], AccessoryData[playerid][0][1], AccessoryData[playerid][0][2], AccessoryData[playerid][0][3], AccessoryData[playerid][0][4], AccessoryData[playerid][0][5], AccessoryData[playerid][0][6], AccessoryData[playerid][0][7], AccessoryData[playerid][0][8]);

	if (PlayerData[playerid][pToggleHat]) RemovePlayerAttachedObject(playerid, 1);
	else if (PlayerData[playerid][pHat] != 0) SetPlayerAttachedObject(playerid, 1, PlayerData[playerid][pHat], 2, AccessoryData[playerid][1][0], AccessoryData[playerid][1][1], AccessoryData[playerid][1][2], AccessoryData[playerid][1][3], AccessoryData[playerid][1][4], AccessoryData[playerid][1][5], AccessoryData[playerid][1][6], AccessoryData[playerid][1][7], AccessoryData[playerid][1][8]);

    if (PlayerData[playerid][pToggleBandana]) RemovePlayerAttachedObject(playerid, 2);
	else if (PlayerData[playerid][pBandana] != 0) SetPlayerAttachedObject(playerid, 2, PlayerData[playerid][pBandana], 2, AccessoryData[playerid][2][0], AccessoryData[playerid][2][1], AccessoryData[playerid][2][2], AccessoryData[playerid][2][3], AccessoryData[playerid][2][4], AccessoryData[playerid][2][5], AccessoryData[playerid][2][6], AccessoryData[playerid][2][7], AccessoryData[playerid][2][8]);

	if (Inventory_HasItem(playerid, "Backpack")) SetPlayerAttachedObject(playerid, 5, 3026, 1, -0.134207, -0.093048, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
	else RemovePlayerAttachedObject(playerid, 5);
}

// ====== OnPlayerEditAttachedObject ======
public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	if (response)
	{
		if (PlayerData[playerid][pEditType] != 0)
 		{
 		    AccessoryData[playerid][PlayerData[playerid][pEditType]-1][0] = fOffsetX;
       		AccessoryData[playerid][PlayerData[playerid][pEditType]-1][1] = fOffsetY;
         	AccessoryData[playerid][PlayerData[playerid][pEditType]-1][2] = fOffsetZ;

          	AccessoryData[playerid][PlayerData[playerid][pEditType]-1][3] = fRotX;
           	AccessoryData[playerid][PlayerData[playerid][pEditType]-1][4] = fRotY;
           	AccessoryData[playerid][PlayerData[playerid][pEditType]-1][5] = fRotZ;

            AccessoryData[playerid][PlayerData[playerid][pEditType]-1][6] = (fScaleX > 3.0) ? (3.0) : (fScaleX);
            AccessoryData[playerid][PlayerData[playerid][pEditType]-1][7] = (fScaleY > 3.0) ? (3.0) : (fScaleY);
			AccessoryData[playerid][PlayerData[playerid][pEditType]-1][8] = (fScaleZ > 3.0) ? (3.0) : (fScaleZ);

			switch (PlayerData[playerid][pEditType])
			{
	  			case 1:
	    		{
		            PlayerData[playerid][pEditType] = 0;
		            PlayerData[playerid][pGlasses] = modelid;

					if (!PlayerData[playerid][pCreated])
					{
		                for (new i = 23; i < 34; i ++) {
				    		PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][i]);
						}
						SelectTextDraw(playerid, -1);
						TogglePlayerControllable(playerid, 0);
					}
		            SendServerMessage(playerid, "You have confirmed your glasses.");
				}
				case 2:
	    		{
	                PlayerData[playerid][pEditType] = 0;
		            PlayerData[playerid][pHat] = modelid;

	                if (!PlayerData[playerid][pCreated])
					{
		                for (new i = 23; i < 34; i ++) {
				    		PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][i]);
						}
						SelectTextDraw(playerid, -1);
						TogglePlayerControllable(playerid, 0);
					}
		            SendServerMessage(playerid, "You have confirmed your hat.");
				}
				case 3:
	    		{
	                PlayerData[playerid][pEditType] = 0;
		            PlayerData[playerid][pBandana] = modelid;

                 	if (!PlayerData[playerid][pCreated])
					{
		                for (new i = 23; i < 34; i ++) {
				    		PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][i]);
						}
						SelectTextDraw(playerid, -1);
						TogglePlayerControllable(playerid, 0);
					}
		            SendServerMessage(playerid, "You have confirmed your bandana.");
				}
			}
	    }
	}
	else
	{
	    if (!PlayerData[playerid][pCreated])
		{
  			for (new i = 23; i < 34; i ++) {
			  	PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][i]);
			}
			SelectTextDraw(playerid, -1);

			TogglePlayerControllable(playerid, 0);
			RemovePlayerAttachedObject(playerid, PlayerData[playerid][pEditType] - 1);
		}
	}
	return 1;
}
