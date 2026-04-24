/*
    File: modules/interface/logic/hud.pwn
    Purpose: Contains interface gameplay logic and helper functions for hud.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== ShowHungerTextdraw ======
ShowHungerTextdraw(playerid, enable)
{
	if (!enable) {
	    PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][65]);
		PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][66]);

		PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][63]);
		PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][64]);
	}
	else if (PlayerData[playerid][pHUD] && PlayerData[playerid][pJailTime] < 1) {
	    PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][65]);
		PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][66]);

		PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][63]);
		PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][64]);
	}
	return 1;
}
