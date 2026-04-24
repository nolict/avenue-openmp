/*
    File: modules/player/logic/tutorial.pwn
    Purpose: Contains player gameplay logic and helper functions for tutorial.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== StartTutorial ======
stock StartTutorial(playerid)
{
	ShowHungerTextdraw(playerid, 0);
	TogglePlayerControllable(playerid, 0);

    PlayerData[playerid][pTutorial] = 1;
    PlayerData[playerid][pTutorialTime] = 10;

	#if SERVER_CITY == 1
	    SetPlayerPos(playerid, 1806.737, -2043.505, 44.733);
	    SetPlayerCameraPos(playerid, 1806.737, -2043.505, 24.733);
		SetPlayerCameraLookAt(playerid, 1802.511, -2040.684, 22.996);
	#elseif SERVER_CITY == 2
		SetPlayerPos(playerid, -2399.519287, 321.964355, 17.035743);
		SetPlayerCameraPos(playerid, -2399.519287, 321.964355, 37.035743);
		SetPlayerCameraLookAt(playerid, -2399.951416, 322.215942, 37.015625);
	#elseif SERVER_CITY == 3
	    SetPlayerPos(playerid, 1694.187622, 1448.494506, -7.181461);
		SetPlayerCameraPos(playerid, 1694.187622, 1448.494506, 12.818538);
		SetPlayerCameraLookAt(playerid, 1693.687744, 1448.484497, 12.763537);
	#endif

	for (new i = 58; i < 62; i ++) {
	    PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][i]);
	}
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	return 1;
}
