/*
    File: modules/player/logic/connection.pwn
    Purpose: Contains player gameplay logic and helper functions for connection.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== TerminateConnection ======
stock TerminateConnection(playerid)
{
	if (BoomboxData[playerid][boomboxPlaced])
		Boombox_Destroy(playerid);

	if (PlayerData[playerid][pRangeBooth] != -1)
		Booth_Leave(playerid);

	if (PlayerData[playerid][pFirstAid])
	    KillTimer(PlayerData[playerid][pAidTimer]);

	if (PlayerData[playerid][pDrivingTest])
	    DestroyVehicle(PlayerData[playerid][pTestCar]);

	if (PlayerData[playerid][pShowFooter])
	    KillTimer(PlayerData[playerid][pFooterTimer]);

	if (PlayerData[playerid][pTaxiPlayer] != INVALID_PLAYER_ID)
	    LeaveTaxi(playerid, PlayerData[playerid][pTaxiPlayer]);

	if (PlayerData[playerid][pDragged])
	    KillTimer(PlayerData[playerid][pDragTimer]);

	if (PlayerData[playerid][pFreeze])
	    KillTimer(PlayerData[playerid][pFreezeTimer]);

	foreach (new i : Player)
	{
	    if (PlayerData[i][pLastShot] == playerid) {
	        PlayerData[i][pLastShot] = INVALID_PLAYER_ID;
		}
		if (PlayerData[i][pHouseSeller] == playerid) {
		    PlayerData[i][pHouseSeller] = INVALID_PLAYER_ID;
		    PlayerData[i][pHouseOffered] = -1;
		}
		if (PlayerData[i][pBusinessSeller] == playerid) {
		    PlayerData[i][pBusinessSeller] = INVALID_PLAYER_ID;
		    PlayerData[i][pBusinessOffered] = -1;
		}
		if (PlayerData[i][pCarSeller] == playerid) {
		    PlayerData[i][pCarSeller] = INVALID_PLAYER_ID;
		    PlayerData[i][pCarOffered] = -1;
		}
		if (PlayerData[i][pShakeOffer] == playerid) {
		    PlayerData[i][pShakeOffer] = INVALID_PLAYER_ID;
		    PlayerData[i][pShakeType] = 0;
		}
		if (PlayerData[i][pFriskOffer] == playerid) {
		    PlayerData[i][pFriskOffer] = INVALID_PLAYER_ID;
		}
		if (PlayerData[i][pFoodSeller] == playerid) {
		    PlayerData[i][pFoodSeller] = INVALID_PLAYER_ID;
		    PlayerData[i][pFoodType] = 0;
		}
		if (PlayerData[i][pFactionOffer] == playerid) {
		    PlayerData[i][pFactionOffer] = INVALID_PLAYER_ID;
		    PlayerData[i][pFactionOffered] = -1;
		}
		if (PlayerData[i][pDraggedBy] == playerid) {
		    KillTimer(PlayerData[i][pDragTimer]);

		    PlayerData[i][pDragged] = 0;
            PlayerData[i][pDraggedBy] = INVALID_PLAYER_ID;
		}
		if (PlayerData[i][pMDCPlayer] == playerid) {
		    PlayerData[i][pMDCPlayer] = INVALID_PLAYER_ID;
		    PlayerData[i][pTrackTime] = 0;
		}
		if (PlayerData[i][pNewsGuest] == playerid) {
		    PlayerData[i][pNewsGuest] = INVALID_PLAYER_ID;
		}
		if (PlayerData[i][pGiveItem] == playerid) {
		    PlayerData[i][pGiveItem] = INVALID_PLAYER_ID;
		}
		if (PlayerData[i][pTakeItems] == playerid) {
		    PlayerData[i][pTakeItems] = INVALID_PLAYER_ID;
		}
	}
	SQL_SaveCharacter(playerid);
	ResetNameTag(playerid);
	Report_Clear(playerid);
	ResetStatistics(playerid);
	return 1;
}
