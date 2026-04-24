/*
    File: modules/interface/logic/playertextdraws.pwn
    Purpose: Contains interface gameplay logic and helper functions for playertextdraws.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

forward SelectTD(playerid);

// ====== SelectTD ======
public SelectTD(playerid)
{
	if (!IsPlayerConnected(playerid))
	    return 0;

	return SelectTextDraw(playerid, -1);
}


ShowStatsForPlayer(playerid, targetid)
{
    new
	    account[24],
	    header[128],
	    string[2048],
	    value[64],
		count;

	for (new i = 0; i < MAX_INVENTORY; i ++) if (InventoryData[targetid][i][invExists]) {
	    count++;
	}
	if (PlayerData[targetid][pAdmin] > 0) account = "Admin";
	else if (PlayerData[targetid][pTester] > 0) account = "Tester";
	else account = "Player";

	for (new i = 40; i < 58; i ++)
		PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);

	CancelSelectTextDraw(playerid);
	PlayerData[playerid][pDisplayStats] = false;

	DialogStyle_Header(header, sizeof(header), ReturnName(targetid, 0), ReturnDate(), PlayerData[targetid][pID]);
	DialogStyle_Reset(string);

	DialogStyle_AddSection(string, sizeof(string), "In Character");
	DialogStyle_AddField(string, sizeof(string), "Gender", (PlayerData[targetid][pGender] == 2) ? ("Female") : ("Male"));
	DialogStyle_AddField(string, sizeof(string), "Origin", PlayerData[targetid][pOrigin]);
	DialogStyle_AddField(string, sizeof(string), "Money", FormatNumber(PlayerData[targetid][pMoney]), DIALOG_STYLE_GREEN);
	DialogStyle_AddField(string, sizeof(string), "Bank", FormatNumber(PlayerData[targetid][pBankMoney]), DIALOG_STYLE_GREEN, true);
	DialogStyle_AddField(string, sizeof(string), "Savings", FormatNumber(PlayerData[targetid][pSavings]), DIALOG_STYLE_GREEN);
	DialogStyle_AddField(string, sizeof(string), "Birthdate", PlayerData[targetid][pBirthdate]);
	DialogStyle_AddField(string, sizeof(string), "Job", Job_GetName(PlayerData[targetid][pJob]));
	DialogStyle_AddField(string, sizeof(string), "Faction", Faction_GetName(targetid), DIALOG_STYLE_LIGHT_BLUE, true);
	format(value, sizeof(value), "%d", PlayerData[targetid][pPhone]);
	DialogStyle_AddField(string, sizeof(string), "Phone Number", value);
	DialogStyle_AddField(string, sizeof(string), "Faction Rank", Faction_GetRank(targetid), DIALOG_STYLE_LIGHT_BLUE, true);

	DialogStyle_AddBlankLine(string, sizeof(string));
	DialogStyle_AddSection(string, sizeof(string), "Out of Character");
	DialogStyle_AddField(string, sizeof(string), "Username", PlayerData[targetid][pUsername]);
	format(value, sizeof(value), "%d/60", PlayerData[targetid][pMinutes]);
	DialogStyle_AddField(string, sizeof(string), "Paycheck", value, DIALOG_STYLE_YELLOW);
	format(value, sizeof(value), "%d/%d", count, MAX_INVENTORY);
	DialogStyle_AddField(string, sizeof(string), "Inventory", value, DIALOG_STYLE_YELLOW);
	DialogStyle_AddField(string, sizeof(string), "Account", account, DIALOG_STYLE_YELLOW, true);
	format(value, sizeof(value), "%d hour(s) %d minute(s)", PlayerData[targetid][pPlayingHours], PlayerData[targetid][pMinutes]);
	DialogStyle_AddField(string, sizeof(string), "Time Played", value, DIALOG_STYLE_YELLOW, true);
	format(value, sizeof(value), "%d", GetPlayerInterior(targetid));
	DialogStyle_AddField(string, sizeof(string), "Interior", value, DIALOG_STYLE_YELLOW);
	format(value, sizeof(value), "%d", GetPlayerVirtualWorld(targetid));
	DialogStyle_AddField(string, sizeof(string), "Virtual World", value, DIALOG_STYLE_YELLOW);
	format(value, sizeof(value), "%d/3", PlayerData[targetid][pWarnings]);
	DialogStyle_AddField(string, sizeof(string), "Warnings", value, DIALOG_STYLE_RED);
	DialogStyle_AddField(string, sizeof(string), "Tester", (PlayerData[targetid][pTester]) ? ("Yes") : ("No"), DIALOG_STYLE_YELLOW);
	DialogStyle_AddField(string, sizeof(string), "Admin", (PlayerData[targetid][pAdmin]) ? ("Yes") : ("No"), DIALOG_STYLE_YELLOW, true);

	Dialog_Show(playerid, ShowStats, DIALOG_STYLE_MSGBOX, header, string, "Close", "");
	return 1;
}



CreateTextDraws(playerid) {
    /*PlayerData[playerid][pTextdraws][0] = CreatePlayerTextDraw(playerid, 240.000000, 161.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][0], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][0], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][0], 0.409999, 9.699998);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][0], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][0], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][0], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][0], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][0], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][0], 0x00000088);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][0], 411.000000, 40.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][0], 0);

	PlayerData[playerid][pTextdraws][1] = CreatePlayerTextDraw(playerid, 259.000000, 161.000000, "Characters");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][1], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][1], 2);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][1], 0.480000, 1.400000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][1], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][1], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][1], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][1], 0);

	PlayerData[playerid][pTextdraws][2] = CreatePlayerTextDraw(playerid, 260.000000, 186.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][2], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][2], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][2], 0.400000, 1.500000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][2], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][2], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][2], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][2], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][2], -205);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][2], 390.000000, 20.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][2], 1);

	PlayerData[playerid][pTextdraws][3] = CreatePlayerTextDraw(playerid, 260.000000, 203.500000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][3], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][3], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][3], 0.400000, 1.500000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][3], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][3], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][3], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][3], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][3], -205);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][3], 390.000000, 20.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][3], 1);

	PlayerData[playerid][pTextdraws][4] = CreatePlayerTextDraw(playerid, 260.000000, 221.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][4], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][4], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][4], 0.400000, 1.500000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][4], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][4], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][4], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][4], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][4], -205);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][4], 390.000000, 20.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][4], 1);

	PlayerData[playerid][pTextdraws][5] = CreatePlayerTextDraw(playerid, 323.000000, 188.000000, "Empty Slot");
	PlayerTextDrawAlignment(playerid, PlayerData[playerid][pTextdraws][5], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][5], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][5], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][5], 0.310000, 0.899999);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][5], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][5], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][5], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][5], 0);

	PlayerData[playerid][pTextdraws][6] = CreatePlayerTextDraw(playerid, 323.000000, 206.000000, "Empty Slot");
	PlayerTextDrawAlignment(playerid, PlayerData[playerid][pTextdraws][6], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][6], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][6], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][6], 0.310000, 0.899999);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][6], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][6], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][6], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][6], 0);

	PlayerData[playerid][pTextdraws][7] = CreatePlayerTextDraw(playerid, 323.000000, 223.000000, "Empty Slot");
	PlayerTextDrawAlignment(playerid, PlayerData[playerid][pTextdraws][7], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][7], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][7], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][7], 0.310000, 0.899999);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][7], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][7], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][7], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][7], 0);*/

	PlayerData[playerid][pTextdraws][0] = CreatePlayerTextDraw(playerid, 239.000000, 156.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][0], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][0], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][0], 0.519999, 11.100000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][0], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][0], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][0], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][0], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][0], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][0], 102);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][0], 416.000000, 40.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][0], 0);

	PlayerData[playerid][pTextdraws][1] = CreatePlayerTextDraw(playerid, 326.000000, 158.000000, "My Characters");
	PlayerTextDrawAlignment(playerid, PlayerData[playerid][pTextdraws][1], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][1], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][1], 2);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][1], 0.330000, 1.199998);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][1], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][1], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][1], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][1], 0);

	PlayerData[playerid][pTextdraws][2] = CreatePlayerTextDraw(playerid, 263.000000, 181.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][2], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][2], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][2], 0.489998, 1.299998);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][2], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][2], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][2], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][2], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][2], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][2], -205);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][2], 393.000000, 12.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][2], 1);

	PlayerData[playerid][pTextdraws][3] = CreatePlayerTextDraw(playerid, 263.000000, 204.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][3], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][3], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][3], 0.490000, 1.299998);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][3], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][3], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][3], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][3], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][3], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][3], -205);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][3], 393.000000, 12.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][3], 1);

	PlayerData[playerid][pTextdraws][4] = CreatePlayerTextDraw(playerid, 263.000000, 227.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][4], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][4], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][4], 0.490000, 1.299996);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][4], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][4], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][4], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][4], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][4], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][4], -205);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][4], 393.000000, 12.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][4], 1);

	PlayerData[playerid][pTextdraws][5] = CreatePlayerTextDraw(playerid, 324.000000, 182.000000, "Empty Slot");
	PlayerTextDrawAlignment(playerid, PlayerData[playerid][pTextdraws][5], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][5], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][5], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][5], 0.309998, 0.999998);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][5], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][5], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][5], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][5], 0);

	PlayerData[playerid][pTextdraws][6] = CreatePlayerTextDraw(playerid, 324.000000, 205.000000, "Empty Slot");
	PlayerTextDrawAlignment(playerid, PlayerData[playerid][pTextdraws][6], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][6], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][6], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][6], 0.309998, 0.999998);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][6], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][6], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][6], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][6], 0);

	PlayerData[playerid][pTextdraws][7] = CreatePlayerTextDraw(playerid, 324.000000, 228.000000, "Empty Slot");
	PlayerTextDrawAlignment(playerid, PlayerData[playerid][pTextdraws][7], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][7], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][7], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][7], 0.309998, 0.999998);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][7], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][7], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][7], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][7], 0);

	PlayerData[playerid][pTextdraws][8] = CreatePlayerTextDraw(playerid, 0.000000, 0.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][8], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][8], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][8], 0.000000, 480.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][8], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][8], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][8], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][8], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][8], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][8], 1482184789);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][8], 640.000000, 42.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][8], 0);

	/*PlayerData[playerid][pTextdraws][8] = CreatePlayerTextDraw(playerid, 320.000000, 164.000000, "Load Character");
	PlayerTextDrawAlignment(playerid, PlayerData[playerid][pTextdraws][8], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][8], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][8], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][8], 0.350000, 0.999999);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][8], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][8], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][8], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][8], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][8], 0);

	PlayerData[playerid][pTextdraws][9] = CreatePlayerTextDraw(playerid, 320.000000, 194.000000, "Delete Character");
	PlayerTextDrawAlignment(playerid, PlayerData[playerid][pTextdraws][9], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][9], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][9], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][9], 0.350000, 0.999999);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][9], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][9], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][9], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][9], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][9], 0);

	PlayerData[playerid][pTextdraws][10] = CreatePlayerTextDraw(playerid, 320.000000, 225.000000, "Go Back");
	PlayerTextDrawAlignment(playerid, PlayerData[playerid][pTextdraws][10], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][10], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][10], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][10], 0.350000, 0.999999);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][10], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][10], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][10], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][10], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][10], 0);*/

	PlayerData[playerid][pTextdraws][11] = CreatePlayerTextDraw(playerid, 432.000000, 140.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][11], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][11], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][11], 0.800000, 8.299997);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][11], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][11], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][11], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][11], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][11], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][11], 136);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][11], 199.000000, 64.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][11], 0);

	PlayerData[playerid][pTextdraws][12] = CreatePlayerTextDraw(playerid, 235.000000, 140.000000, "Personal Identification");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][12], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][12], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][12], 0.409999, 1.499999);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][12], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][12], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][12], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][12], 0);

	PlayerData[playerid][pTextdraws][13] = CreatePlayerTextDraw(playerid, 209.000000, 159.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][13], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][13], 5);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][13], 0.240000, -0.299999);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][13], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][13], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][13], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][13], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][13], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][13], 0);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][13], 52.000000, 51.000000);
	PlayerTextDrawSetPreviewModel(playerid, PlayerData[playerid][pTextdraws][13], 98);

	PlayerData[playerid][pTextdraws][14] = CreatePlayerTextDraw(playerid, 271.000000, 159.000000, "~r~Name:~w~ Character Name");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][14], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][14], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][14], 0.270000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][14], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][14], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][14], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][14], 0);

	PlayerData[playerid][pTextdraws][15] = CreatePlayerTextDraw(playerid, 271.000000, 179.000000, "~r~Date of Birth:~w~ Please specify...");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][15], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][15], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][15], 0.240000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][15], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][15], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][15], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][15], 0);

	PlayerData[playerid][pTextdraws][16] = CreatePlayerTextDraw(playerid, 271.000000, 169.000000, "~r~Gender:~w~ Male");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][16], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][16], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][16], 0.240000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][16], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][16], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][16], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][16], 0);

	PlayerData[playerid][pTextdraws][17] = CreatePlayerTextDraw(playerid, 271.000000, 189.000000, "~r~Origin:~w~ Please specify...");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][17], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][17], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][17], 0.240000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][17], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][17], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][17], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][17], 0);

	PlayerData[playerid][pTextdraws][18] = CreatePlayerTextDraw(playerid, 368.000000, 202.000000, "Continue");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][18], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][18], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][18], 0.380000, 1.200000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][18], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][18], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][18], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][18], 0);

	PlayerData[playerid][pTextdraws][19] = CreatePlayerTextDraw(playerid, 272.000000, 171.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][19], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][19], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][19], 0.290000, 0.599999);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][19], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][19], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][19], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][19], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][19], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][19], 0);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][19], 369.000000, 28.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][19], 1);

	PlayerData[playerid][pTextdraws][20] = CreatePlayerTextDraw(playerid, 272.000000, 182.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][20], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][20], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][20], 0.290000, 0.599999);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][20], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][20], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][20], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][20], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][20], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][20], 0);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][20], 369.000000, 28.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][20], 1);

	PlayerData[playerid][pTextdraws][21] = CreatePlayerTextDraw(playerid, 272.000000, 192.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][21], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][21], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][21], 0.290000, 0.599999);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][21], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][21], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][21], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][21], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][21], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][21], 0);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][21], 369.000000, 28.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][21], 1);

	PlayerData[playerid][pTextdraws][22] = CreatePlayerTextDraw(playerid, 367.000000, 205.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][22], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][22], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][22], 0.289999, 0.699999);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][22], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][22], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][22], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][22], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][22], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][22], 0);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][22], 424.000000, 15.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][22], 1);

	PlayerData[playerid][pTextdraws][23] = CreatePlayerTextDraw(playerid, 433.000000, 150.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][23], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][23], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][23], 0.800000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][23], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][23], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][23], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][23], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][23], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][23], 136);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][23], 211.000000, 0.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][23], 0);

	PlayerData[playerid][pTextdraws][24] = CreatePlayerTextDraw(playerid, 246.000000, 149.000000, "Character Customization");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][24], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][24], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][24], 0.370000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][24], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][24], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][24], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][24], 0);

	PlayerData[playerid][pTextdraws][25] = CreatePlayerTextDraw(playerid, 433.000000, 162.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][25], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][25], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][25], 0.800000, 10.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][25], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][25], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][25], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][25], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][25], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][25], 119);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][25], 211.000000, 0.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][25], 0);

	PlayerData[playerid][pTextdraws][26] = CreatePlayerTextDraw(playerid, 291.000000, 172.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][26], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][26], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][26], 0.840000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][26], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][26], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][26], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][26], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][26], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][26], 136);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][26], 351.000000, 9.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][26], 1);

	PlayerData[playerid][pTextdraws][27] = CreatePlayerTextDraw(playerid, 303.000000, 171.500000, "Glasses");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][27], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][27], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][27], 0.290000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][27], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][27], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][27], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][27], 0);

	PlayerData[playerid][pTextdraws][28] = CreatePlayerTextDraw(playerid, 291.000000, 196.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][28], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][28], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][28], 0.840000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][28], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][28], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][28], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][28], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][28], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][28], 136);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][28], 351.000000, 9.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][28], 1);

	PlayerData[playerid][pTextdraws][29] = CreatePlayerTextDraw(playerid, 310.000000, 195.500000, "Hats");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][29], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][29], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][29], 0.290000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][29], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][29], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][29], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][29], 0);

	PlayerData[playerid][pTextdraws][30] = CreatePlayerTextDraw(playerid, 291.000000, 220.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][30], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][30], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][30], 0.840000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][30], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][30], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][30], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][30], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][30], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][30], 136);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][30], 351.000000, 9.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][30], 1);

	PlayerData[playerid][pTextdraws][31] = CreatePlayerTextDraw(playerid, 301.000000, 219.500000, "Bandana");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][31], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][31], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][31], 0.290000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][31], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][31], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][31], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][31], 0);

	PlayerData[playerid][pTextdraws][32] = CreatePlayerTextDraw(playerid, 357.000000, 237.000000, "Continue");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][32], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][32], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][32], 0.439999, 1.400000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][32], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][32], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][32], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][32], 0);

	PlayerData[playerid][pTextdraws][33] = CreatePlayerTextDraw(playerid, 356.000000, 240.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][33], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][33], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][33], 0.840000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][33], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][33], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][33], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][33], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][33], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][33], 0);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][33], 424.000000, 9.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][33], 1);

	PlayerData[playerid][pTextdraws][34] = CreatePlayerTextDraw(playerid, 623.000000, 396.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][34], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][34], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][34], 0.760000, 4.299999);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][34], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][34], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][34], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][34], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][34], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][34], 85);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][34], 512.000000, 28.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][34], 0);

	PlayerData[playerid][pTextdraws][35] = CreatePlayerTextDraw(playerid, 518.000000, 397.000000, "~r~Fuel:~w~ 0%");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][35], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][35], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][35], 0.280000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][35], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][35], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][35], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][35], 0);

	PlayerData[playerid][pTextdraws][36] = CreatePlayerTextDraw(playerid, 518.000000, 406.200012, "~r~Speed:~w~ 0 mph");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][36], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][36], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][36], 0.280000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][36], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][36], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][36], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][36], 0);

	PlayerData[playerid][pTextdraws][37] = CreatePlayerTextDraw(playerid, 518.000000, 415.500000, "~r~Damage:~w~ 0/100%");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][37], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][37], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][37], 0.280000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][37], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][37], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][37], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][37], 0);

	PlayerData[playerid][pTextdraws][38] = CreatePlayerTextDraw(playerid, 518.000000, 425.000000, "~r~Windows:~w~ Up");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][38], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][38], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][38], 0.280000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][38], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][38], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][38], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][38], 0);

    PlayerData[playerid][pTextdraws][39] = CreatePlayerTextDraw(playerid, 327.000000, 424.000000, "~r~Footer text.");
	PlayerTextDrawAlignment(playerid, PlayerData[playerid][pTextdraws][39], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][39], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][39], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][39], 0.460000, 1.400000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][39], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][39], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][39], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][39], 0);

	PlayerData[playerid][pTextdraws][40] = CreatePlayerTextDraw(playerid, 470.000000, 160.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][40], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][40], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][40], 0.570000, 12.200000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][40], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][40], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][40], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][40], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][40], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][40], 102);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][40], 190.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][40], 0);

	PlayerData[playerid][pTextdraws][41] = CreatePlayerTextDraw(playerid, 470.000000, 160.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][41], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][41], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][41], 0.910000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][41], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][41], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][41], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][41], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][41], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][41], -188);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][41], 190.000000, -9.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][41], 0);

	PlayerData[playerid][pTextdraws][42] = CreatePlayerTextDraw(playerid, 199.000000, 174.000000, "~g~Sex:~w~ Male~n~~g~Birthdate:~w~ 17/02/1993~n~~g~Origin:~w~ United States");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][42], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][42], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][42], 0.310000, 1.100000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][42], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][42], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][42], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][42], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][42], 0);

	PlayerData[playerid][pTextdraws][43] = CreatePlayerTextDraw(playerid, 195.000000, 159.500000, "Emmet Jones (ID: 4)");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][43], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][43], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][43], 0.310000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][43], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][43], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][43], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][43], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][43], 0);

	PlayerData[playerid][pTextdraws][44] = CreatePlayerTextDraw(playerid, 199.000000, 212.000000, "~g~Money:~w~ $0~n~~g~Bank:~w~ $0~n~~g~Savings:~w~ $0");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][44], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][44], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][44], 0.310000, 1.100000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][44], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][44], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][44], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][44], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][44], 0);

	PlayerData[playerid][pTextdraws][45] = CreatePlayerTextDraw(playerid, 339.000000, 174.000000, "~g~Account:~w~ Player~n~~g~Tester:~w~ No~n~~g~Admin:~w~ No");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][45], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][45], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][45], 0.310000, 1.100000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][45], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][45], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][45], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][45], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][45], 0);

	PlayerData[playerid][pTextdraws][46] = CreatePlayerTextDraw(playerid, 340.000000, 212.000000, "~g~Ping:~w~ 0~n~~g~Packetloss:~w~ 0.0%~n~~g~Time Online:~w~ 00:00:00");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][46], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][46], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][46], 0.310000, 1.100000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][46], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][46], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][46], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][46], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][46], 0);

	PlayerData[playerid][pTextdraws][47] = CreatePlayerTextDraw(playerid, 200.000000, 254.000000, "My Characters");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][47], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][47], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][47], 0.329999, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][47], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][47], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][47], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][47], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][47], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][47], -222);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][47], 278.000000, 27.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][47], 1);

	PlayerData[playerid][pTextdraws][48] = CreatePlayerTextDraw(playerid, 296.000000, 254.000000, "My Inventory");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][48], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][48], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][48], 0.329999, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][48], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][48], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][48], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][48], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][48], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][48], -222);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][48], 372.000000, 27.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][48], 1);

	PlayerData[playerid][pTextdraws][49] = CreatePlayerTextDraw(playerid, 389.000000, 254.000000, "Close Menu");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][49], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][49], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][49], 0.329999, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][49], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][49], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][49], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][49], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][49], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][49], -222);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][49], 453.000000, 27.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][49], 1);

	PlayerData[playerid][pTextdraws][50] = CreatePlayerTextDraw(playerid, 470.000000, 160.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][50], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][50], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][50], 0.569998, 8.999999);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][50], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][50], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][50], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][50], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][50], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][50], 102);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][50], 190.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][50], 0);

	PlayerData[playerid][pTextdraws][51] = CreatePlayerTextDraw(playerid, 470.000000, 160.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][51], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][51], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][51], 0.910000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][51], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][51], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][51], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][51], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][51], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][51], -188);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][51], 190.000000, -9.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][51], 0);

	PlayerData[playerid][pTextdraws][52] = CreatePlayerTextDraw(playerid, 198.000000, 177.000000, "~g~Name:~w~ Emmet Jackson~n~~g~Account:~w~ Player~n~~g~Created:~w~ 23 days ago~n~~g~Last Login:~w~ 22 days ago");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][52], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][52], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][52], 0.310000, 1.100000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][52], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][52], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][52], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][52], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][52], 0);

	PlayerData[playerid][pTextdraws][53] = CreatePlayerTextDraw(playerid, 195.000000, 159.500000, "#1: Emmet Jones");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][53], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][53], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][53], 0.310000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][53], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][53], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][53], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][53], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][53], 0);

	PlayerData[playerid][pTextdraws][54] = CreatePlayerTextDraw(playerid, 397.000000, 174.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][54], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][54], 5);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][54], 0.579999, 4.699997);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][54], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][54], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][54], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][54], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][54], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][54], 0);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][54], 53.000000, 48.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][54], 1);

	PlayerData[playerid][pTextdraws][55] = CreatePlayerTextDraw(playerid, 389.000000, 227.000000, "Close Menu");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][55], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][55], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][55], 0.329997, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][55], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][55], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][55], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][55], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][55], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][55], -222);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][55], 453.000000, 27.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][55], 1);

	PlayerData[playerid][pTextdraws][56] = CreatePlayerTextDraw(playerid, 200.000000, 227.000000, "<< Go Back");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][56], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][56], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][56], 0.329998, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][56], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][56], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][56], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][56], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][56], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][56], -222);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][56], 278.000000, 27.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][56], 1);

	PlayerData[playerid][pTextdraws][57] = CreatePlayerTextDraw(playerid, 290.000000, 227.000000, "Delete Character");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][57], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][57], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][57], 0.309998, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][57], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][57], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][57], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][57], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][57], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][57], -222);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][57], 375.000000, 27.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][57], 1);

	PlayerData[playerid][pTextdraws][58] = CreatePlayerTextDraw(playerid, 424.000000, 151.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][58], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][58], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][58], 0.600000, 8.699998);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][58], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][58], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][58], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][58], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][58], 119);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][58], 202.000000, 11.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][58], 0);

	PlayerData[playerid][pTextdraws][59] = CreatePlayerTextDraw(playerid, 206.000000, 151.000000, "Tutorial: Spawn Point");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][59], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][59], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][59], 0.319999, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][59], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][59], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][59], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][59], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][59], -205);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][59], 420.000000, 0.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][59], 0);

	PlayerData[playerid][pTextdraws][60] = CreatePlayerTextDraw(playerid, 208.000000, 164.000000, "Di sini kamu akan spawn setelah tutorial~n~selesai. Disarankan untuk meminta bantuan~n~setelah spawn.");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][60], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][60], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][60], 0.270000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][60], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][60], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][60], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][60], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][60], 0);

	PlayerData[playerid][pTextdraws][61] = CreatePlayerTextDraw(playerid, 208.000000, 197.000000, "Untuk meminta bantuan, ketik ~g~~h~/seekhelp~w~.~n~Tester akan menangani request kamu jika ada~n~yang sedang on duty.");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][61], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][61], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][61], 0.270000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][61], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][61], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][61], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][61], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][61], 0);

	PlayerData[playerid][pTextdraws][62] = CreatePlayerTextDraw(playerid, 644.000000, 1.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][62], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][62], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][62], 0.530000, 51.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][62], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][62], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][62], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][62], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][62], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][62], 119);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][62], -6.000000, 30.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][62], 0);

	PlayerData[playerid][pTextdraws][63] = CreatePlayerTextDraw(playerid, 579.000000, 122.000000, "100%");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][63], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][63], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][63], 0.290000, 0.899999);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][63], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][63], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][63], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][63], 0);

	PlayerData[playerid][pTextdraws][64] = CreatePlayerTextDraw(playerid, 579.000000, 155.000000, "100%");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][64], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][64], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][64], 0.290000, 0.899999);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][64], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][64], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][64], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][64], 0);

	PlayerData[playerid][pTextdraws][65] = CreatePlayerTextDraw(playerid, 536.000000, 108.000000, "hunger");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][65], 0);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][65], 5);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][65], 0.539999, 1.400000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][65], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][65], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][65], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][65], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][65], 0);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][65], 51.000000, 37.000000);
	PlayerTextDrawSetPreviewModel(playerid, PlayerData[playerid][pTextdraws][65], 2702);
	PlayerTextDrawSetPreviewRot(playerid, PlayerData[playerid][pTextdraws][65], 0.0000, 90.0000, 90.0000);

	PlayerData[playerid][pTextdraws][66] = CreatePlayerTextDraw(playerid, 537.000000, 140.000000, "thirst");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][66], 0);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][66], 5);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][66], 0.539999, 1.400000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][66], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][66], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][66], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][66], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][66], 0);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][66], 51.000000, 37.000000);
	PlayerTextDrawSetPreviewModel(playerid, PlayerData[playerid][pTextdraws][66], 1543);
	PlayerTextDrawSetPreviewRot(playerid, PlayerData[playerid][pTextdraws][66], 0.0000, 0.0000, 0.0000);

    PlayerData[playerid][pTextdraws][67] = CreatePlayerTextDraw(playerid, 535.000000, 172.000000, "armor");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][67], 0);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][67], 5);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][67], 0.539999, 1.399999);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][67], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][67], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][67], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][67], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][67], 0);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][67], 52.000000, 39.000000);
	PlayerTextDrawSetPreviewModel(playerid, PlayerData[playerid][pTextdraws][67], 19142);
	PlayerTextDrawSetPreviewRot(playerid, PlayerData[playerid][pTextdraws][67], -20.0, -90.0, 0.0);

	PlayerData[playerid][pTextdraws][68] = CreatePlayerTextDraw(playerid, 577.000000, 186.000000, "100%");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][68], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][68], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][68], 0.289999, 0.899999);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][68], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][68], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][68], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][68], 0);

	PlayerData[playerid][pTextdraws][69] = CreatePlayerTextDraw(playerid, 13.000000, 431.000000, "~b~Waypoint:~w~ Calculating...");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][69], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][69], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][69], 0.270000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][69], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][69], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][69], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][69], 0);

	PlayerData[playerid][pTextdraws][70] = CreatePlayerTextDraw(playerid, 499.000000, 101.000000, "~g~Prison Time:~w~ 00:00:00");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][70], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][70], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][70], 0.270000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][70], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][70], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][70], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][70], 0);

	PlayerData[playerid][pTextdraws][71] = CreatePlayerTextDraw(playerid, 240.000000, 161.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][71], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][71], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][71], 0.519999, 9.099995);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][71], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][71], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][71], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][71], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][71], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][71], 102);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][71], 421.000000, 40.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][71], 0);

	PlayerData[playerid][pTextdraws][72] = CreatePlayerTextDraw(playerid, 326.000000, 161.000000, "Richard Jackson");
	PlayerTextDrawAlignment(playerid, PlayerData[playerid][pTextdraws][72], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][72], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][72], 2);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][72], 0.330000, 1.199999);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][72], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][72], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][72], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][72], 0);

	PlayerData[playerid][pTextdraws][73] = CreatePlayerTextDraw(playerid, 233.000000, 173.000000, "skin");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][73], 0);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][73], 5);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][73], 0.619999, 1.400000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][73], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][73], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][73], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][73], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][73], 0);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][73], 59.000000, 59.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][73], 0);

	PlayerData[playerid][pTextdraws][74] = CreatePlayerTextDraw(playerid, 280.000000, 179.000000, "~b~DOB:~w~ 17/02/1998");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][74], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][74], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][74], 0.300000, 1.100000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][74], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][74], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][74], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][74], 0);

	PlayerData[playerid][pTextdraws][75] = CreatePlayerTextDraw(playerid, 280.000000, 189.500000, "~b~Origin:~w~ Texas, USA");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][75], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][75], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][75], 0.300000, 1.100000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][75], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][75], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][75], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][75], 0);

	PlayerData[playerid][pTextdraws][76] = CreatePlayerTextDraw(playerid, 280.000000, 200.000000, "~b~Creation:~w~ 2 months ago");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][76], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][76], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][76], 0.300000, 1.100000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][76], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][76], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][76], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][76], 0);

	PlayerData[playerid][pTextdraws][77] = CreatePlayerTextDraw(playerid, 281.000000, 210.000000, "~b~Played:~w~ 3 months ago");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][77], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][77], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][77], 0.300000, 1.100000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][77], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][77], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][77], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][77], 0);

	PlayerData[playerid][pTextdraws][78] = CreatePlayerTextDraw(playerid, 301.000000, 231.000000, "Spawn");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][78], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][78], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][78], 0.360000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][78], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][78], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][78], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][78], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][78], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][78], -205);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][78], 340.000000, 20.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][78], 1);

	PlayerData[playerid][pTextdraws][79] = CreatePlayerTextDraw(playerid, 345.000000, 231.000000, "Delete");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][79], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][79], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][79], 0.360000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][79], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][79], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][79], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][79], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][79], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][79], -205);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][79], 382.000000, 20.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][79], 1);

	PlayerData[playerid][pTextdraws][80] = CreatePlayerTextDraw(playerid, 387.000000, 231.000000, "Back");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][80], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][80], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][80], 0.360000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][80], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][80], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][80], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws][80], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws][80], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws][80], -205);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws][80], 415.000000, 20.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][80], 1);

	PlayerData[playerid][pTextdraws][81] = CreatePlayerTextDraw(playerid, 553.000000, 99.000000, "~b~~h~Targets:~w~ 0/10");
	PlayerTextDrawAlignment(playerid, PlayerData[playerid][pTextdraws][81], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][81], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][81], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][81], 0.390000, 1.200000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][81], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][81], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][81], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][81], 0);

	PlayerData[playerid][pTextdraws][82] = CreatePlayerTextDraw(playerid, 37.000000, 315.000000, "~b~Loaded:~w~ Retail Supplies~n~~b~Loaded Crates:~w~ 6/6");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws][82], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws][82], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws][82], 0.280000, 1.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws][82], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws][82], 1);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws][82], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws][82], 0);
}

// ====== ShowPlayerFooter ======
stock ShowPlayerFooter(playerid, string[], time = 5000) {
	if (PlayerData[playerid][pShowFooter]) {
	    PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][39]);
	    KillTimer(PlayerData[playerid][pFooterTimer]);
	}
	PlayerTextDrawSetString(playerid, PlayerData[playerid][pTextdraws][39], string);
	PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][39]);

	PlayerData[playerid][pShowFooter] = true;
	PlayerData[playerid][pFooterTimer] = SetTimerEx("HidePlayerFooter", time, false, "d", playerid);
}

forward HidePlayerFooter(playerid);

// ====== HidePlayerFooter ======
public HidePlayerFooter(playerid) {

	if (!PlayerData[playerid][pShowFooter])
	    return 0;

	PlayerData[playerid][pShowFooter] = false;
	return PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][39]);
}
