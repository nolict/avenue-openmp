/*
    File: modules/interface/logic/clicks.pwn
    Purpose: Contains interface gameplay logic and helper functions for clicks.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/


// ====== OnPlayerClickTextDraw ======
public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if (clickedid == Text:INVALID_TEXT_DRAW)
	{
		if (!Dialog_Opened(playerid) && PlayerData[playerid][pDisplayStats] > 0)
	    {
	        if (PlayerData[playerid][pDisplayStats] == 2) {
	        	for (new i = 50; i < 58; i ++) PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
	    	}
		    else for (new i = 40; i < 50; i ++) {
				PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
			}
			CancelSelectTextDraw(playerid);
			PlayerData[playerid][pDisplayStats] = false;
		}
	}
	return 0;
}

// ====== OnPlayerClickPlayerTextDraw ======
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	if (!Dialog_Opened(playerid))
	{
		if (!PlayerData[playerid][pCharacter])
		{
			if (playertextid == PlayerData[playerid][pTextdraws][2])
				SelectCharacter(playerid, 1);

			else if (playertextid == PlayerData[playerid][pTextdraws][3])
				SelectCharacter(playerid, 2);

			else if (playertextid == PlayerData[playerid][pTextdraws][4])
				SelectCharacter(playerid, 3);
		}
		else
		{
		    if (playertextid == PlayerData[playerid][pTextdraws][78])
				SQL_LoadCharacter(playerid, PlayerData[playerid][pCharacter]);

			else if (playertextid == PlayerData[playerid][pTextdraws][79]) {
			    Dialog_Show(playerid, DeleteChar, DIALOG_STYLE_MSGBOX, DialogStyle_Title("Delete Character"), "Warning: Are you sure you wish to delete character \"%s\"?\n\nYou will not be issued a refund for any lost property.", "Confirm", "Cancel", PlayerCharacters[playerid][PlayerData[playerid][pCharacter] - 1]);
			}
			else if (playertextid == PlayerData[playerid][pTextdraws][80]) {
			    ShowCharacterMenu(playerid);
			}
			else if (playertextid == PlayerData[playerid][pTextdraws][19]) {
			    CancelSelectTextDraw(playerid);
			    Dialog_Show(playerid, Gender, DIALOG_STYLE_LIST, DialogStyle_Title("Gender"), DialogStyle_Body("Male\nFemale"), "Select", "Cancel");
			}
			else if (playertextid == PlayerData[playerid][pTextdraws][20]) {
			    Dialog_Show(playerid, DateBirth, DIALOG_STYLE_INPUT, DialogStyle_Title("Date of Birth"), DialogStyle_Body("Please enter your date of birth below (DD/MM/YYYY):"), "Submit", "Cancel");
			}
            else if (playertextid == PlayerData[playerid][pTextdraws][21]) {
			    Dialog_Show(playerid, Origin, DIALOG_STYLE_INPUT, DialogStyle_Title("Origin"), DialogStyle_Body("Please enter the geographical origin of your character below:"), "Submit", "Cancel");
			}
			else if (playertextid == PlayerData[playerid][pTextdraws][22])
			{
			    if (!strlen(PlayerData[playerid][pBirthdate]))
			        return SendClientMessage(playerid, COLOR_LIGHTRED, "Server: You must specify a birth date.");

				else if (!strlen(PlayerData[playerid][pOrigin]))
				    return SendClientMessage(playerid, COLOR_LIGHTRED, "Server: You must specify an origin.");

				else
				{
				    for (new i = 11; i < 23; i ++) {
						PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
					}
                    switch (PlayerData[playerid][pGender])
                    {
                        case 1:
                        	ShowModelSelectionMenu(playerid, "Select Skin", MODEL_SELECTION_SKIN, g_aMaleSkins, sizeof(g_aMaleSkins), -16.0, 0.0, -55.0);

						case 2:
                       		ShowModelSelectionMenu(playerid, "Select Skin", MODEL_SELECTION_SKIN, g_aFemaleSkins, sizeof(g_aFemaleSkins), -16.0, 0.0, -55.0);
                    }
				}
			}
			else if (playertextid == PlayerData[playerid][pTextdraws][26])
			{
			    static
					arrGlasses[] = {19300, 19006, 19007, 19008, 19009, 19010, 19011, 19012, 19013, 19014, 19015, 19016, 19017, 19018, 19019, 19020, 19021, 19022, 19023, 19024, 19025, 19026, 19027, 19028, 19029, 19030, 19031, 19032, 19033, 19034, 19035};

				for (new i = 23; i < 34; i ++) {
				    PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
				}
				ShowModelSelectionMenu(playerid, "Glasses", MODEL_SELECTION_GLASSES, arrGlasses, sizeof(arrGlasses), 0.0, 0.0, 90.0);
			}
			else if (playertextid == PlayerData[playerid][pTextdraws][28])
			{
			    static
					arrHats[] = {19300, 18926, 18927, 18928, 18929, 18930, 18931, 18932, 18933, 18934, 18935, 18944, 18945, 18946, 18947, 18948, 18949, 18950, 18951};

				for (new i = 23; i < 34; i ++) {
				    PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
				}
				ShowModelSelectionMenu(playerid, "Hats", MODEL_SELECTION_HATS, arrHats, sizeof(arrHats), -20.0, -90.0, 0.0);
			}
			else if (playertextid == PlayerData[playerid][pTextdraws][30])
			{
			    static
					arrBandanas[] = {19300, 18911, 18912, 18913, 18914, 18915, 18916, 18917, 18918, 18919, 18920};

				for (new i = 23; i < 34; i ++) {
				    PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
				}
				ShowModelSelectionMenu(playerid, "Bandanas", MODEL_SELECTION_BANDANAS, arrBandanas, sizeof(arrBandanas), 0.0, 0.0, 90.0);
			}
			else if (playertextid == PlayerData[playerid][pTextdraws][33])
			{
			    for (new i = 23; i < 34; i ++) {
				    PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
				}
			    for (new i = 0; i < 100; i ++) {
			        SendClientMessage(playerid, -1, "");
			    }
			    CancelSelectTextDraw(playerid);
			    TogglePlayerControllable(playerid, 1);

				PlayerData[playerid][pTutorialStage] = 1;
			    PlayerData[playerid][pTutorialObject] = CreatePlayerObject(playerid, 1543, -226.4219, 1408.4594, 26.7734, 0.0, 0.0, 0.0);

			    SetPlayerCheckpoint(playerid, -226.4219, 1408.4594, 27.7734, 0.5);
			    SendClientMessage(playerid, COLOR_SERVER, "Silakan menuju item lalu tekan 'ALT'.");

				SetPlayerPos(playerid, -226.2436, 1400.4767, 27.7656);
				SetPlayerFacingAngle(playerid, 0.0000);

				SetPlayerInterior(playerid, 18);
				SetPlayerVirtualWorld(playerid, (playerid + 2000));

				SetCameraBehindPlayer(playerid);
				ShowHungerTextdraw(playerid, 1);

				PlayerData[playerid][pThirst] = 80;
			}
			else if (playertextid == PlayerData[playerid][pTextdraws][47])
			{
				new
					string[128];

				CancelSelectTextDraw(playerid);

				format(string, sizeof(string), "%s\n%s\n%s", (!PlayerCharacters[playerid][0][0]) ? ("Empty Slot") : (PlayerCharacters[playerid][0]), (!PlayerCharacters[playerid][1][0]) ? ("Empty Slot") : (PlayerCharacters[playerid][1]), (!PlayerCharacters[playerid][2][0]) ? ("Empty Slot") : (PlayerCharacters[playerid][2]));
				Dialog_Show(playerid, CharList, DIALOG_STYLE_LIST, DialogStyle_Title("My Characters"), string, "Select", "Cancel");
			}
			else if (playertextid == PlayerData[playerid][pTextdraws][48])
			{
				for (new i = 40; i < 50; i ++)
			        PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);

				CancelSelectTextDraw(playerid);
				PlayerData[playerid][pDisplayStats] = false;

				SetTimerEx("OpenInventory", 100, false, "d", playerid);
			}
			else if (playertextid == PlayerData[playerid][pTextdraws][49])
			{
				for (new i = 40; i < 50; i ++)
			        PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);

				CancelSelectTextDraw(playerid);
				PlayerData[playerid][pDisplayStats] = false;
			}
            else if (playertextid == PlayerData[playerid][pTextdraws][55])
			{
			    for (new i = 50; i < 58; i ++)
			        PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);

				CancelSelectTextDraw(playerid);
				PlayerData[playerid][pDisplayStats] = false;
			}
            else if (playertextid == PlayerData[playerid][pTextdraws][56])
			{
			    for (new i = 40; i < 58; i ++)
			        PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);

				CancelSelectTextDraw(playerid);
			    PlayerData[playerid][pDisplayStats] = false;
			    ShowStatsForPlayer(playerid, playerid);
			}
			else if (playertextid == PlayerData[playerid][pTextdraws][57])
			{
			    if (PlayerData[playerid][pCharacterMenu] == PlayerData[playerid][pCharacter])
			        return SendErrorMessage(playerid, "You are playing on this character, you can't delete it.");

                Dialog_Show(playerid, DeleteCharacter, DIALOG_STYLE_MSGBOX, DialogStyle_Title("Delete Character"), "Warning: Are you sure you wish to delete character \"%s\"?\n\nYou will not be issued a refund for any lost property.", "Confirm", "Cancel", PlayerCharacters[playerid][PlayerData[playerid][pCharacterMenu] - 1]);
			}
		}
	}
	return 1;
}
