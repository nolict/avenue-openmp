/*
    File: modules/player/dialogs/characters.pwn
    Purpose: Contains easyDialog callbacks for player characters flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:CharList ======
Dialog:CharList(playerid, response, listitem, inputtext[])
{
    SetTimerEx("SelectTD", 200, false, "d", playerid);

	if (response)
	{
		if (!PlayerCharacters[playerid][listitem][0])
		    return SendErrorMessage(playerid, "The selected character slot is empty.");

		new
		    string[160];

		format(string, sizeof(string), "SELECT `Admin`, `Skin`, `CreateDate`, `LastLogin` FROM `characters` WHERE `Username` = '%s' AND `Character` = '%s'", PlayerData[playerid][pUsername], PlayerCharacters[playerid][listitem]);
		mysql_tquery(g_iHandle, string, "OnCharacterLookup", "dds", playerid, listitem + 1, PlayerCharacters[playerid][listitem]);
	}
	return 1;
}

// ====== Dialog:RegisterScreen ======
Dialog:RegisterScreen(playerid, response, listitem, inputtext[])
{
	if (!response)
		return Kick(playerid);

	else if (isnull(inputtext))
	    return Dialog_Show(playerid, RegisterScreen, DIALOG_STYLE_PASSWORD, DialogStyle_Title("Account Registration"), DialogStyle_Body("Welcome to Avenue Roleplay, %s.\n\nNotice: Your account is not registered yet. Please enter your desired password:"), "Register", "Cancel", ReturnName(playerid));

	else
	{
		SQL_CreateAccount(PlayerData[playerid][pUsername], inputtext);

		ShowCharacterMenu(playerid);
		SendServerMessage(playerid, "Your account has been created and saved successfully.");
	}
	return 1;
}

// ====== Dialog:LoginScreen ======
Dialog:LoginScreen(playerid, response, listitem, inputtext[])
{
	if (!response)
	    return Kick(playerid);

	else if (isnull(inputtext))
	    return Dialog_Show(playerid, LoginScreen, DIALOG_STYLE_PASSWORD, DialogStyle_Title("Account Login"), DialogStyle_Body("Welcome back to Avenue Roleplay!\n\nYour account was last seen on: %s.\n\nPlease enter your password below to login to your account:"), "Login", "Cancel", PlayerData[playerid][pLoginDate]);

	else
	{
	    SQL_AttemptLogin(playerid, inputtext);
	}
	return 1;
}

// ====== Dialog:DeleteChar ======
Dialog:DeleteChar(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new query[128];

	    format(query, sizeof(query), "DELETE FROM `characters` WHERE `Username` = '%s' AND `Character` = '%s'", PlayerData[playerid][pUsername], PlayerCharacters[playerid][PlayerData[playerid][pCharacter] - 1]);
		mysql_tquery(g_iHandle, query);

		SendServerMessage(playerid, "You have deleted \"%s\" from your account.", PlayerCharacters[playerid][PlayerData[playerid][pCharacter] - 1]);
        PlayerCharacters[playerid][PlayerData[playerid][pCharacter] - 1][0] = 0;

        ShowCharacterMenu(playerid);
	}
	return 1;
}

// ====== Dialog:DeleteCharacter ======
Dialog:DeleteCharacter(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new query[128];

	    format(query, sizeof(query), "DELETE FROM `characters` WHERE `Username` = '%s' AND `Character` = '%s'", PlayerData[playerid][pUsername], PlayerCharacters[playerid][PlayerData[playerid][pCharacterMenu] - 1]);
		mysql_tquery(g_iHandle, query);

		SendServerMessage(playerid, "You have deleted \"%s\" from your account.", PlayerCharacters[playerid][PlayerData[playerid][pCharacterMenu] - 1]);
        PlayerCharacters[playerid][PlayerData[playerid][pCharacterMenu] - 1][0] = 0;

        for (new i = 50; i < 58; i ++) {
        	PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
		}
		PlayerData[playerid][pDisplayStats] = false;
		CancelSelectTextDraw(playerid);
	}
	return 1;
}

// ====== Dialog:CreateChar ======
Dialog:CreateChar(playerid, response, listitem, inputtext[])
{
	if (!response)
	    return PlayerData[playerid][pCharacter] = 0;

	else if (isnull(inputtext) || strlen(inputtext) > 20)
        return Dialog_Show(playerid, CreateChar, DIALOG_STYLE_INPUT, DialogStyle_Title("Create Character"), DialogStyle_Body("Please enter the name of your new character below:\n\nWarning: Your name must be in the Firstname_Lastname format and not exceed 20 characters."), "Create", "Cancel");

	else if (!IsValidRoleplayName(inputtext))
	    return Dialog_Show(playerid, CreateChar, DIALOG_STYLE_INPUT, DialogStyle_Title("Create Character"), DialogStyle_Body("Error: You have entered an invalid roleplay name.\n\nPlease enter the name of your new character below:\n\nWarning: Your name must be in the Firstname_Lastname format and not exceed 20 characters."), "Create", "Cancel");

	else
	{
	    static
	        query[128];

		format(query, sizeof(query), "SELECT `ID` FROM `characters` WHERE `Character` = '%s'", inputtext);
		mysql_tquery(g_iHandle, query, "OnCharacterCheck", "ds", playerid, inputtext);
	}
	return 1;
}

// ====== Dialog:Gender ======
Dialog:Gender(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    PlayerData[playerid][pGender] = listitem + 1;

	    switch (listitem) {
	        case 0: {
				PlayerTextDrawSetString(playerid, PlayerData[playerid][pTextdraws][16], "~r~Gender:~w~ Male");
				PlayerTextDrawSetPreviewModel(playerid, PlayerData[playerid][pTextdraws][13], 98);

				PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][13]);
				PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][13]);
			}
	        case 1: {
				PlayerTextDrawSetString(playerid, PlayerData[playerid][pTextdraws][16], "~r~Gender:~w~ Female");
				PlayerTextDrawSetPreviewModel(playerid, PlayerData[playerid][pTextdraws][13], 233);

				PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][13]);
				PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][13]);
			}
		}
		PlayerData[playerid][pSkin] = (listitem) ? (233) : (98);
		SetTimerEx("SelectTD", 200, false, "d", playerid);
	}
	else SetTimerEx("SelectTD", 200, false, "d", playerid);
	return 1;
}

// ====== Dialog:DateBirth ======
Dialog:DateBirth(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new
			iDay,
			iMonth,
			iYear,
			str[64];

	    static const
	        arrMonthDays[] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

	    if (sscanf(inputtext, "p</>ddd", iDay, iMonth, iYear)) {
	        Dialog_Show(playerid, DateBirth, DIALOG_STYLE_INPUT, DialogStyle_Title("Date of Birth"), DialogStyle_Body("Error: Invalid format specified!\n\nPlease enter your date of birth below (DD/MM/YYYY):"), "Submit", "Cancel");
		}
		else if (iYear < 1900 || iYear > 2014) {
		    Dialog_Show(playerid, DateBirth, DIALOG_STYLE_INPUT, DialogStyle_Title("Date of Birth"), DialogStyle_Body("Error: Invalid year specified!\n\nPlease enter your date of birth below (DD/MM/YYYY):"), "Submit", "Cancel");
		}
		else if (iMonth < 1 || iMonth > 12) {
		    Dialog_Show(playerid, DateBirth, DIALOG_STYLE_INPUT, DialogStyle_Title("Date of Birth"), DialogStyle_Body("Error: Invalid month specified!\n\nPlease enter your date of birth below (DD/MM/YYYY):"), "Submit", "Cancel");
		}
		else if (iDay < 1 || iDay > arrMonthDays[iMonth - 1]) {
		    Dialog_Show(playerid, DateBirth, DIALOG_STYLE_INPUT, DialogStyle_Title("Date of Birth"), DialogStyle_Body("Error: Invalid day specified!\n\nPlease enter your date of birth below (DD/MM/YYYY):"), "Submit", "Cancel");
		}
		else {
		    format(PlayerData[playerid][pBirthdate], 24, inputtext);

		    format(str, sizeof(str), "~r~Date of Birth:~w~ %s", inputtext);
		    PlayerTextDrawSetString(playerid, PlayerData[playerid][pTextdraws][15], str);
		}
	}
	return 1;
}

// ====== Dialog:Origin ======
Dialog:Origin(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new str[64];

	    if (isnull(inputtext) || strlen(inputtext) > 32) {
	        Dialog_Show(playerid, Origin, DIALOG_STYLE_INPUT, DialogStyle_Title("Origin"), DialogStyle_Body("Please enter the geographical origin of your character below:"), "Submit", "Cancel");
		}
		else for (new i = 0, len = strlen(inputtext); i != len; i ++) {
		    if ((inputtext[i] >= 'A' && inputtext[i] <= 'Z') || (inputtext[i] >= 'a' && inputtext[i] <= 'z') || (inputtext[i] >= '0' && inputtext[i] <= '9') || (inputtext[i] == ' ') || (inputtext[i] == ',') || (inputtext[i] == '.'))
				continue;

			else return Dialog_Show(playerid, Origin, DIALOG_STYLE_INPUT, DialogStyle_Title("Origin"), DialogStyle_Body("Error: Only letters and numbers are accepted in the origin.\n\nPlease enter the geographical origin of your character below:"), "Submit", "Cancel");
		}
		format(PlayerData[playerid][pOrigin], 32, inputtext);

  		format(str, sizeof(str), "~r~Origin:~w~ %s", inputtext);
  		PlayerTextDrawSetString(playerid, PlayerData[playerid][pTextdraws][17], str);
	}
	return 1;
}

// ====== Dialog:NewPass ======
Dialog:NewPass(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    if (isnull(inputtext))
	        return Dialog_Show(playerid, NewPass, DIALOG_STYLE_PASSWORD, DialogStyle_Title("Enter New Password"), DialogStyle_Body("Please enter your new password below.\n\nNote: Please use a strong and safe password for additional security."), "Change", "Cancel");

		static
		    buffer[129],
		    query[256];

		WP_Hash(buffer, sizeof(buffer), inputtext);
		inputtext[0] = '\0';

		format(query, sizeof(query), "UPDATE `accounts` SET `Password` = '%s' WHERE `Username` = '%s'", buffer, PlayerData[playerid][pUsername]);
		mysql_tquery(g_iHandle, query);

		SendServerMessage(playerid, "You have changed your password.");
	}
	return 1;
}

