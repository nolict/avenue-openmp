/*
    File: modules/interface/logic/hud.pwn
    Purpose: Contains interface gameplay logic and helper functions for hud.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== Interface_GetHBEBarWidth ======
stock Float:Interface_GetHBEBarWidth(value)
{
	if (value < 0)
		value = 0;
	else if (value > 100)
		value = 100;

	return (float(value) / 100.0) * HUNGER_THIRST_BAR_WIDTH;
}

// ====== Interface_UpdateHungerTextdraw ======
stock Interface_UpdateHungerTextdraw(playerid)
{
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][INDIKATOR_LAPAR_DEPAN], Interface_GetHBEBarWidth(PlayerData[playerid][pHunger]), HUNGER_THIRST_BAR_HEIGHT);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][INDIKATOR_HAUS_DEPAN], Interface_GetHBEBarWidth(PlayerData[playerid][pThirst]), HUNGER_THIRST_BAR_HEIGHT);
	return 1;
}

// ====== ShowHungerTextdraw ======
ShowHungerTextdraw(playerid, enable)
{
	if (!enable) {
		PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][HBE_BACKGROUND]);
		PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][HBE_TITLE]);
		PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][HBE_HUNGER_LABEL]);
		PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][HBE_THIRST_LABEL]);
	    PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][INDIKATOR_LAPAR_BELAKANG]);
		PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][INDIKATOR_HAUS_BELAKANG]);
		PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][INDIKATOR_LAPAR_DEPAN]);
		PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][INDIKATOR_HAUS_DEPAN]);
	}
	else if (PlayerData[playerid][pHUD] && PlayerData[playerid][pJailTime] < 1 && !IsPlayerInAnyVehicle(playerid)) {
		Interface_UpdateHungerTextdraw(playerid);
		PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][HBE_BACKGROUND]);
		PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][HBE_TITLE]);
		PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][HBE_HUNGER_LABEL]);
		PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][HBE_THIRST_LABEL]);
	    PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][INDIKATOR_LAPAR_BELAKANG]);
		PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][INDIKATOR_HAUS_BELAKANG]);
		PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][INDIKATOR_LAPAR_DEPAN]);
		PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][INDIKATOR_HAUS_DEPAN]);
	}
	return 1;
}
