/*
    File: modules/system/logic/booth.pwn
    Purpose: Contains system gameplay logic and helper functions for booth.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== UpdateBooth ======
forward UpdateBooth(playerid, id);

// ====== UpdateBooth ======
public UpdateBooth(playerid, id)
{
	if (PlayerData[playerid][pRangeBooth] != id || !g_BoothUsed[id])
	    return 0;

	if (PlayerData[playerid][pTargets] == 10)
	{
	    PlayerData[playerid][pTargets] = 0;

	    switch (PlayerData[playerid][pTargetLevel]++)
	    {
	        case 0:
	        {
	            ResetPlayerWeapons(playerid);

				GivePlayerWeapon(playerid, 25, 15000);
	            SendServerMessage(playerid, "You have advanced to the next level (1/5).");
	        }
	        case 1:
	        {
	            ResetPlayerWeapons(playerid);

				GivePlayerWeapon(playerid, 28, 15000);
	            SendServerMessage(playerid, "You have advanced to the next level (2/5).");
	        }
	        case 2:
	        {
	            ResetPlayerWeapons(playerid);

				GivePlayerWeapon(playerid, 29, 15000);
	            SendServerMessage(playerid, "You have advanced to the next level (3/5).");
	        }
	        case 3:
	        {
	            ResetPlayerWeapons(playerid);

				GivePlayerWeapon(playerid, 30, 15000);
	            SendServerMessage(playerid, "You have advanced to the next level (4/5).");
	        }
	        case 4:
	        {
	            ResetPlayerWeapons(playerid);

				GivePlayerWeapon(playerid, 27, 15000);
	            SendServerMessage(playerid, "You have advanced to the next level (5/5).");
	        }
	        case 5:
	        {
	            Booth_Leave(playerid);
	            SendServerMessage(playerid, "You have completed the shooting challenge!");
	        }
	    }
	}
	Booth_Refresh(playerid);
	return 1;
}

// ====== Booth_GetPlayer ======
stock Booth_GetPlayer(id)
{
	foreach (new i : Player) if (PlayerData[i][pRangeBooth] == id) {
	    return i;
	}
	return INVALID_PLAYER_ID;
}

// ====== Booth_Leave ======
stock Booth_Leave(playerid)
{
	if (PlayerData[playerid][pRangeBooth] != -1)
	{
	    if (IsValidObject(g_BoothObject[PlayerData[playerid][pRangeBooth]])) {
	        DestroyObject(g_BoothObject[PlayerData[playerid][pRangeBooth]]);

	        g_BoothObject[PlayerData[playerid][pRangeBooth]] = -1;
	    }
    	ResetPlayerWeapons(playerid);
   		SetWeapons(playerid);

		g_BoothUsed[PlayerData[playerid][pRangeBooth]] = false;
		PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][81]);

		PlayerData[playerid][pRangeBooth] = -1;
  		PlayerData[playerid][pTargets] = 0;
  		PlayerData[playerid][pTargetLevel] = 0;
	}
	return 1;
}

// ====== Booth_Refresh ======
stock Booth_Refresh(playerid)
{
	new id = PlayerData[playerid][pRangeBooth];

	if (id == -1)
	    return 0;

	if (IsValidObject(g_BoothObject[id])) {
	    DestroyObject(g_BoothObject[id]);
	}
	g_BoothObject[id] = CreateObject(1583, arrBoothPositions[id][0] - 15.0, arrBoothPositions[id][1] + 1.5, arrBoothPositions[id][2], 0.0, 0.0, 90.0);

	return MoveObject(g_BoothObject[id], arrBoothPositions[id][0] - 1.0, arrBoothPositions[id][1] + 1.5, arrBoothPositions[id][2], (!PlayerData[playerid][pTargetLevel]) ? (2.0) : (2.0 + (PlayerData[playerid][pTargetLevel] * 1.2)));
}
