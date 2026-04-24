/*
    File: modules/interface/textdraws/global.pwn
    Purpose: Creates global server textdraws used for server clock, title display, injured notice, and restart timer.
    Notes: Keep global TextDrawCreate setup here. PlayerTextDraw lifecycle belongs in interface player textdraw logic.
*/

// ====== Interface_CreateGlobalTextdraws ======
stock Interface_CreateGlobalTextdraws()
{
	// Textdraws
	gServerTextdraws[0] = TextDrawCreate(547.000000, 23.000000, "12:00 PM");
	TextDrawBackgroundColor(gServerTextdraws[0], 255);
	TextDrawFont(gServerTextdraws[0], 1);
	TextDrawLetterSize(gServerTextdraws[0], 0.360000, 1.499999);
	TextDrawColor(gServerTextdraws[0], -1);
	TextDrawSetOutline(gServerTextdraws[0], 1);
	TextDrawSetProportional(gServerTextdraws[0], 1);
	TextDrawSetSelectable(gServerTextdraws[0], 0);

	gServerTextdraws[1] = TextDrawCreate(500.000000, 6.000000, "Avenue ~r~Roleplay");
	TextDrawBackgroundColor(gServerTextdraws[1], 255);
	TextDrawFont(gServerTextdraws[1], 1);
	TextDrawLetterSize(gServerTextdraws[1], 0.260000, 1.200000);
	TextDrawColor(gServerTextdraws[1], -1);
	TextDrawSetOutline(gServerTextdraws[1], 1);
	TextDrawSetProportional(gServerTextdraws[1], 1);
	TextDrawSetSelectable(gServerTextdraws[1], 0);

    gServerTextdraws[2] = TextDrawCreate(11.000000, 430.000000, "~r~You are injured!~w~ /call 911 or /giveup.");
	TextDrawBackgroundColor(gServerTextdraws[2], 255);
	TextDrawFont(gServerTextdraws[2], 1);
	TextDrawLetterSize(gServerTextdraws[2], 0.300000, 1.100000);
	TextDrawColor(gServerTextdraws[2], -1);
	TextDrawSetOutline(gServerTextdraws[2], 1);
	TextDrawSetProportional(gServerTextdraws[2], 1);
	TextDrawSetSelectable(gServerTextdraws[2], 0);

    gServerTextdraws[3] = TextDrawCreate(237.000000, 409.000000, "~r~Server Restart:~w~ 00:00");
	TextDrawBackgroundColor(gServerTextdraws[3], 255);
	TextDrawFont(gServerTextdraws[3], 1);
	TextDrawLetterSize(gServerTextdraws[3], 0.480000, 1.300000);
	TextDrawColor(gServerTextdraws[3], -1);
	TextDrawSetOutline(gServerTextdraws[3], 1);
	TextDrawSetProportional(gServerTextdraws[3], 1);
	TextDrawSetSelectable(gServerTextdraws[3], 0);

}
