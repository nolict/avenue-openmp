/*
    File: modules/core/database/callbacks.pwn
    Purpose: Contains core database definitions and helpers for callbacks.
    Notes: Keep this file focused on shared infrastructure, not feature gameplay bodies.
*/

// ====== OnObjectMoved ======
public OnObjectMoved(objectid)
{
	for (new i = 0; i < MAX_BOOTHS; i ++) if (g_BoothUsed[i] && g_BoothObject[i] == objectid) {
	    DestroyObject(g_BoothObject[i]);

	    return SetTimerEx("UpdateBooth", 3000, false, "dd", Booth_GetPlayer(i), i);
	}
	return 1;
}

forward OnQueryExecute(playerid, query[]);

// ====== OnQueryExecute ======
public OnQueryExecute(playerid, query[])
{
	static
	    rows,
	    fields;

	cache_get_data(rows, fields, g_iHandle);

	if (strfind(query, "SELECT", true) != -1)
		Dialog_Show(playerid, ExecuteQuery, DIALOG_STYLE_INPUT, DialogStyle_Title("Execute Query"), DialogStyle_Body("Success: MySQL returned %d rows from your query.\n\nPlease specify the MySQL query to execute below:"), "Execute", "Back", rows);

	else
		Dialog_Show(playerid, ExecuteQuery, DIALOG_STYLE_INPUT, DialogStyle_Title("Execute Query"), DialogStyle_Body("Success: Query executed successfully (affected rows: %d).\n\nPlease specify the MySQL query to execute below:"), "Execute", "Back", cache_affected_rows());

	PlayerData[playerid][pExecute] = 0;
	return 1;
}

// ====== OnQueryError ======
public OnQueryError(errorid, error[], callback[], query[], connectionHandle)
{
	foreach (new i : Player)
	{
		if (PlayerData[i][pAdmin] >= 6 && PlayerData[i][pExecute])
		{
	    	PlayerData[i][pExecute] = 0;
	    	Dialog_Show(i, ExecuteQuery, DIALOG_STYLE_INPUT, DialogStyle_Title("Execute Query"), DialogStyle_Body("Error: \"%s\"\n\nPlease specify the MySQL query to execute below:"), "Execute", "Back", error);
		}
	}
 	printf("** [MySQL]: %s", error);
	Log_Write("logs/mysql_log.txt", "[%s] %s: %s", ReturnDate(), (callback[0]) ? (callback) : ("n/a"), error);
	return 1;
}

forward OnQueryFinished(extraid, threadid);

// ====== OnQueryFinished ======
public OnQueryFinished(extraid, threadid)
{
	if (!IsPlayerConnected(extraid))
	    return 0;

	static
	    rows,
	    fields
	;
	switch (threadid)
	{
	    case THREAD_CREATE_CHAR:
	    {
	        PlayerData[extraid][pID] = cache_insert_id(g_iHandle);
	        PlayerData[extraid][pLogged] = 1;

			SQL_SaveCharacter(extraid);

			PlayerData[extraid][pID] = -1;
			PlayerData[extraid][pLogged] = 0;
			SQL_LoadCharacter(extraid, PlayerData[extraid][pCharacter]);
	    }
		case THREAD_CHECK_ACCOUNT:
		{
		    cache_get_data(rows, fields, g_iHandle);

		    if (rows)
			{
			    static
			        loginDate[36];

			    cache_get_row(0, 0, loginDate, g_iHandle);

				format(PlayerData[extraid][pLoginDate], 36, loginDate);
		        Dialog_Show(extraid, LoginScreen, DIALOG_STYLE_PASSWORD, DialogStyle_Title("Account Login"), DialogStyle_Body("Welcome back to {E1997F}Avenue Roleplay{FFFFFF}!\n\nYour account was last seen on: %s.\n\nPlease enter your password below to login to your account:"), "Login", "Cancel", PlayerData[extraid][pLoginDate]);
			}
			else
			{
			    Dialog_Show(extraid, RegisterScreen, DIALOG_STYLE_PASSWORD, DialogStyle_Title("Account Registration"), DialogStyle_Body("Welcome to {E1997F}Avenue Roleplay{FFFFFF}, %s.\n\nNotice: Your account is not registered yet. Please enter your desired password:"), "Register", "Cancel", ReturnName(extraid));
			}
    	}
    	case THREAD_LOGIN:
   		{
    	    cache_get_data(rows, fields, g_iHandle);

    	    if (!rows)
    	    {
    	        PlayerData[extraid][pLoginAttempts]++;

    	        if (PlayerData[extraid][pLoginAttempts] >= 3)
    	        {
    	            SendClientMessage(extraid, COLOR_LIGHTRED, "Notice: You have been kicked for using up your login attempts.");
    	            KickEx(extraid);
				}
				else
				{
    	        	Dialog_Show(extraid, LoginScreen, DIALOG_STYLE_PASSWORD, DialogStyle_Title("Account Login"), DialogStyle_Body("Welcome back to {E1997F}Avenue Roleplay{FFFFFF}!\n\nYour account was last seen on: %s.\n\nPlease enter your password below to login to your account:"), "Login", "Cancel", PlayerData[extraid][pLoginDate]);
    	        	SendClientMessageEx(extraid, COLOR_LIGHTRED, "Notice: Incorrect password specified (%d/3 attempts).", PlayerData[extraid][pLoginAttempts]);
				}
			}
			else
			{
				static
					query[256];

				// Update the last login date.
                format(query, sizeof(query), "UPDATE `accounts` SET `IP` = '%s', `LoginDate` = '%s' WHERE `Username` = '%s'", PlayerData[extraid][pIP], ReturnDate(), PlayerData[extraid][pUsername]);
				mysql_tquery(g_iHandle, query);

    			// Load the character data.
				PlayerData[extraid][pAccount] = cache_get_field_int(0, "ID");
				PlayerData[extraid][pAdmin] = cache_get_field_int(0, "Admin");

				format(query, sizeof(query), "SELECT * FROM `characters` WHERE `Username` = '%s' LIMIT 3", PlayerData[extraid][pUsername]);
				mysql_tquery(g_iHandle, query, "OnQueryFinished", "dd", extraid, THREAD_CHARACTERS);
			}
		}
		case THREAD_CHARACTERS:
		{
			cache_get_data(rows, fields, g_iHandle);

			CharacterSelection_ResetPlayer(extraid);

			for (new i = 0; i < rows; i ++) {
			    cache_get_field_content(i, "Character", PlayerCharacters[extraid][i], g_iHandle, MAX_PLAYER_NAME);
			    CharacterSelection_SetSlotData(
			    	extraid,
			    	i,
			    	cache_get_field_int(i, "Skin"),
			    	cache_get_field_int(i, "PlayingHours"),
			    	cache_get_field_int(i, "Money"),
			    	cache_get_field_int(i, "LastLogin")
			    );
		    }
		    SendServerMessage(extraid, "You have authenticated into your account successfully.");
            ShowCharacterMenu(extraid);
		}
		case THREAD_LOAD_CHARACTER:
		{
		    static
		        string[128];

		    cache_get_data(rows, fields, g_iHandle);

			foreach (new i : Player)
			{
			    if (PlayerData[i][pCharacter] == PlayerData[extraid][pCharacter] && !strcmp(ReturnName(i), PlayerCharacters[extraid][PlayerData[extraid][pCharacter] - 1]) && i != extraid)
       			{
       			    ShowCharacterMenu(extraid);
				   	SendErrorMessage(extraid, "This character is already logged in.");
				}
			}
			switch (SetPlayerName(extraid, PlayerCharacters[extraid][PlayerData[extraid][pCharacter] - 1]))
			{
			    case -1: {
					SendClientMessageEx(extraid, COLOR_LIGHTRED, "Notice: Your character's name seems to be in use already.");
				}
				default:
				{
				    if (!rows) {
				        return 0;
					}
					static
					    query[128]
					;
			        PlayerData[extraid][pID] = cache_get_field_int(0, "ID");
			        PlayerData[extraid][pCreated] = cache_get_field_int(0, "Created");
			        PlayerData[extraid][pGender] = cache_get_field_int(0, "Gender");

					cache_get_field_content(0, "Birthdate", PlayerData[extraid][pBirthdate], g_iHandle, 24);
			        cache_get_field_content(0, "Origin", PlayerData[extraid][pOrigin], g_iHandle, 32);

			        PlayerData[extraid][pSkin] = cache_get_field_int(0, "Skin");
			        PlayerData[extraid][pPos][0] = cache_get_field_float(0, "PosX");
			        PlayerData[extraid][pPos][1] = cache_get_field_float(0, "PosY");
			        PlayerData[extraid][pPos][2] = cache_get_field_float(0, "PosZ");
			        PlayerData[extraid][pPos][3] = cache_get_field_float(0, "PosA");
			        PlayerData[extraid][pHealth] = cache_get_field_float(0, "Health");
			        PlayerData[extraid][pInterior] = cache_get_field_int(0, "Interior");
			        PlayerData[extraid][pWorld] = cache_get_field_int(0, "World");
			        PlayerData[extraid][pHospital] = cache_get_field_int(0, "Hospital");
                    PlayerData[extraid][pHospitalInt] = cache_get_field_int(0, "HospitalInt");
			        PlayerData[extraid][pMoney] = cache_get_field_int(0, "Money");
			        PlayerData[extraid][pBankMoney] = cache_get_field_int(0, "BankMoney");
			        PlayerData[extraid][pOwnsBillboard] = cache_get_field_int(0, "OwnsBillboard");
					PlayerData[extraid][pSavings] = cache_get_field_int(0, "Savings");
			        PlayerData[extraid][pJailTime] = cache_get_field_int(0, "JailTime");
			        PlayerData[extraid][pMuted] = cache_get_field_int(0, "Muted");
			        PlayerData[extraid][pTester] = cache_get_field_int(0, "Tester");
			        PlayerData[extraid][pHouse] = cache_get_field_int(0, "House");
			        PlayerData[extraid][pBusiness] = cache_get_field_int(0, "Business");
			        PlayerData[extraid][pEntrance] = cache_get_field_int(0, "Entrance");
			        PlayerData[extraid][pPhone] = cache_get_field_int(0, "Phone");
			        PlayerData[extraid][pLottery] = cache_get_field_int(0, "Lottery");
			        PlayerData[extraid][pLottery] = cache_get_field_int(0, "LotteryB");
			        PlayerData[extraid][pHunger] = cache_get_field_int(0, "Hunger");
			        PlayerData[extraid][pThirst] = cache_get_field_int(0, "Thirst");
			        PlayerData[extraid][pPlayingHours] = cache_get_field_int(0, "PlayingHours");
			        PlayerData[extraid][pMinutes] = cache_get_field_int(0, "Minutes");
			        PlayerData[extraid][pArmorStatus] = cache_get_field_float(0, "ArmorStatus");
			        PlayerData[extraid][pJob] = cache_get_field_int(0, "Job");
			        PlayerData[extraid][pFactionID] = cache_get_field_int(0, "Faction");
			        PlayerData[extraid][pFactionRank] = cache_get_field_int(0, "FactionRank");
			        PlayerData[extraid][pPrisoned] = cache_get_field_int(0, "Prisoned");
			        PlayerData[extraid][pInjured] = cache_get_field_int(0, "Injured");
			        PlayerData[extraid][pWarrants] = cache_get_field_int(0, "Warrants");
			        PlayerData[extraid][pChannel] = cache_get_field_int(0, "Channel");
			        PlayerData[extraid][pBleeding] = cache_get_field_int(0, "Bleeding");
			        PlayerData[extraid][pAdminHide] = cache_get_field_int(0, "AdminHide");
			        PlayerData[extraid][pWarnings] = cache_get_field_int(0, "Warnings");
			        PlayerData[extraid][pMaskID] = cache_get_field_int(0, "MaskID");
			        PlayerData[extraid][pFactionMod] = cache_get_field_int(0, "FactionMod");
			        PlayerData[extraid][pCapacity] = cache_get_field_int(0, "Capacity");
			        PlayerData[extraid][pSpawnPoint] = cache_get_field_int(0, "SpawnPoint");

					cache_get_field_content(0, "Warn1", PlayerData[extraid][pWarn1], g_iHandle, 32);
					cache_get_field_content(0, "Warn2", PlayerData[extraid][pWarn2], g_iHandle, 32);

			        for (new i = 0; i < 13; i ++) {
			            format(query, sizeof(query), "Gun%d", i + 1);
			            PlayerData[extraid][pGuns][i] = cache_get_field_int(0, query);

			            format(query, sizeof(query), "Ammo%d", i + 1);
			            PlayerData[extraid][pAmmo][i] = cache_get_field_int(0, query);
			        }
			        PlayerData[extraid][pGlasses] = cache_get_field_int(0, "Glasses");
					PlayerData[extraid][pHat] = cache_get_field_int(0, "Hat");
					PlayerData[extraid][pBandana] = cache_get_field_int(0, "Bandana");

					cache_get_field_content(0, "GlassesPos", string, g_iHandle);
					sscanf(string, "p<|>fffffffff", AccessoryData[extraid][0][0], AccessoryData[extraid][0][1], AccessoryData[extraid][0][2], AccessoryData[extraid][0][3], AccessoryData[extraid][0][4], AccessoryData[extraid][0][5], AccessoryData[extraid][0][6], AccessoryData[extraid][0][7], AccessoryData[extraid][0][8]);

					cache_get_field_content(0, "HatPos", string, g_iHandle);
					sscanf(string, "p<|>fffffffff", AccessoryData[extraid][1][0], AccessoryData[extraid][1][1], AccessoryData[extraid][1][2], AccessoryData[extraid][1][3], AccessoryData[extraid][1][4], AccessoryData[extraid][1][5], AccessoryData[extraid][1][6], AccessoryData[extraid][1][7], AccessoryData[extraid][1][8]);

					cache_get_field_content(0, "BandanaPos", string, g_iHandle);
					sscanf(string, "p<|>fffffffff", AccessoryData[extraid][2][0], AccessoryData[extraid][2][1], AccessoryData[extraid][2][2], AccessoryData[extraid][2][3], AccessoryData[extraid][2][4], AccessoryData[extraid][2][5], AccessoryData[extraid][2][6], AccessoryData[extraid][2][7], AccessoryData[extraid][2][8]);

					if (!PlayerData[extraid][pMaskID])
					    PlayerData[extraid][pMaskID] = random(90000) + 10000;

					if (!PlayerData[extraid][pCapacity])
					    PlayerData[extraid][pCapacity] = 35;

				    for (new i = 0; i < 81; i ++) {
				        if (i < 8 || (i >= 71 && i <= 80)) PlayerTextDrawHide(extraid, PlayerData[extraid][pTextdraws][i]);
					}
				    if (PlayerData[extraid][pTester] > 0)
			    	{
						SendClientMessage(extraid, COLOR_CYAN, "SERVER: {FFFFFF}You have logged in as a tester.");
				    }
				    if (PlayerData[extraid][pAdmin] > 0)
				    {
				        SendAdminAction(extraid, "You have logged in a level %d admin.", PlayerData[extraid][pAdmin]);
				    }
				    PlayerData[extraid][pLogged] = 1;

                    format(query, sizeof(query), "SELECT * FROM `inventory` WHERE `ID` = '%d'", PlayerData[extraid][pID]);
					mysql_tquery(g_iHandle, query, "OnQueryFinished", "dd", extraid, THREAD_LOAD_INVENTORY);

                    format(query, sizeof(query), "SELECT * FROM `contacts` WHERE `ID` = '%d'", PlayerData[extraid][pID]);
					mysql_tquery(g_iHandle, query, "OnQueryFinished", "dd", extraid, THREAD_LOAD_CONTACTS);

                    format(query, sizeof(query), "SELECT * FROM `tickets` WHERE `ID` = '%d'", PlayerData[extraid][pID]);
					mysql_tquery(g_iHandle, query, "OnQueryFinished", "dd", extraid, THREAD_LOAD_TICKETS);

                    format(query, sizeof(query), "SELECT * FROM `gps` WHERE `ID` = '%d'", PlayerData[extraid][pID]);
					mysql_tquery(g_iHandle, query, "OnQueryFinished", "dd", extraid, THREAD_LOAD_LOCATIONS);

                    if(PlayerData[extraid][pOwnsBillboard] == 0)
                    {
                        PlayerData[extraid][pOwnsBillboard] = -1;
					}
					if (PlayerData[extraid][pFactionID] != -1) {
					    PlayerData[extraid][pFaction] = GetFactionByID(PlayerData[extraid][pFactionID]);

					    if (PlayerData[extraid][pFaction] == -1) {
					        ResetFaction(extraid);
						}
					}
				    if (!PlayerData[extraid][pCreated])
				    {
				        new
				            str[48];

						format(str, sizeof(str), "~r~Name:~w~ %s", ReturnName(extraid));
				        PlayerTextDrawSetString(extraid, PlayerData[extraid][pTextdraws][14], str);

				        for (new i = 11; i < 23; i ++) {
				            PlayerTextDrawShow(extraid, PlayerData[extraid][pTextdraws][i]);
						}
						PlayerData[extraid][pSkin] = 98;

						PlayerData[extraid][pOrigin][0] = '\0';
						PlayerData[extraid][pBirthdate][0] = '\0';

						SendServerMessage(extraid, "You are now required to fill in your ID card.");
						SetPlayerInterior(extraid, 3);

						SetPlayerPos(extraid, 364.958312, 173.570709, 990.610534);
						SetPlayerCameraPos(extraid, 364.958312, 173.570709, 1010.610534);
						SetPlayerCameraLookAt(extraid, 364.458343, 173.576049, 1010.389343);
				    }
				    else
				    {
        				SetSpawnInfo(extraid, 0, PlayerData[extraid][pSkin], PlayerData[extraid][pPos][0], PlayerData[extraid][pPos][1], PlayerData[extraid][pPos][2], 0.0, 0, 0, 0, 0, 0, 0);

				        TogglePlayerSpectating(extraid, 0);
				        TogglePlayerControllable(extraid, 0);

				        CancelSelectTextDraw(extraid);
				        SetTimerEx("SpawnTimer", 1000, false, "d", extraid);
					}
				}
			}
		}
		case THREAD_VERIFY_PASS:
		{
		    cache_get_data(rows, fields, g_iHandle);

		    if (rows)
				Dialog_Show(extraid, NewPass, DIALOG_STYLE_PASSWORD, DialogStyle_Title("Enter New Password"), DialogStyle_Body("Please enter your new password below.\n\nNote: Please use a strong and safe password for additional security."), "Change", "Cancel");

			else
				SendErrorMessage(extraid, "You have entered an incorrect password.");
		}
		case THREAD_FIND_USERNAME:
		{
		    static
		        query[128];

			cache_get_data(rows, fields, g_iHandle);

			if (rows)
			{
				new
				    name[MAX_PLAYER_NAME + 1];

				cache_get_row(0, 0, name, g_iHandle);

				if (strcmp(name, PlayerData[extraid][pUsername], false) != 0)
				{
					format(PlayerData[extraid][pUsername], sizeof(name), name);
					SetPlayerName(extraid, name);
				}
		    }
		    format(query, sizeof(query), "SELECT `LoginDate` FROM `accounts` WHERE `Username` = '%s'", PlayerData[extraid][pUsername]);
			mysql_tquery(g_iHandle, query, "OnQueryFinished", "dd", extraid, THREAD_CHECK_ACCOUNT);
		}
		case THREAD_LOAD_INVENTORY:
		{
		    static
		        name[32];

		    cache_get_data(rows, fields, g_iHandle);

			for (new i = 0; i < rows && i < MAX_INVENTORY; i ++) {
			    InventoryData[extraid][i][invExists] = true;
			    InventoryData[extraid][i][invID] = cache_get_field_int(i, "invID");
			    InventoryData[extraid][i][invModel] = cache_get_field_int(i, "invModel");
                InventoryData[extraid][i][invQuantity] = cache_get_field_int(i, "invQuantity");

				cache_get_field_content(i, "invItem", name, g_iHandle, sizeof(name));
				strpack(InventoryData[extraid][i][invItem], name, 32 char);
			}
		}
		case THREAD_LOAD_CONTACTS:
		{
		    cache_get_data(rows, fields, g_iHandle);

			for (new i = 0; i < rows && i < MAX_CONTACTS; i ++) {
				cache_get_field_content(i, "contactName", ContactData[extraid][i][contactName], g_iHandle, 32);

				ContactData[extraid][i][contactExists] = true;
			    ContactData[extraid][i][contactID] = cache_get_field_int(i, "contactID");
			    ContactData[extraid][i][contactNumber] = cache_get_field_int(i, "contactNumber");
			}
		}
		case THREAD_LOAD_LOCATIONS:
		{
		    cache_get_data(rows, fields, g_iHandle);

			for (new i = 0; i < rows && i < MAX_GPS_LOCATIONS; i ++) {
				cache_get_field_content(i, "locationName", LocationData[extraid][i][locationName], g_iHandle, 32);

				LocationData[extraid][i][locationExists] = true;
			    LocationData[extraid][i][locationID] = cache_get_field_int(i, "locationID");
			    LocationData[extraid][i][locationPos][0] = cache_get_field_float(i, "locationX");
			    LocationData[extraid][i][locationPos][1] = cache_get_field_float(i, "locationY");
			    LocationData[extraid][i][locationPos][2] = cache_get_field_float(i, "locationZ");
			}
		}
		case THREAD_LOAD_TICKETS:
		{
		    cache_get_data(rows, fields, g_iHandle);

			for (new i = 0; i < rows && i < MAX_PLAYER_TICKETS; i ++) {
				cache_get_field_content(i, "ticketReason", TicketData[extraid][i][ticketReason], g_iHandle, 64);
				cache_get_field_content(i, "ticketDate", TicketData[extraid][i][ticketDate], g_iHandle, 36);

				TicketData[extraid][i][ticketExists] = true;
			    TicketData[extraid][i][ticketID] = cache_get_field_int(i, "ticketID");
			    TicketData[extraid][i][ticketFee] = cache_get_field_int(i, "ticketFee");
			}
		}
		case THREAD_BAN_LOOKUP:
		{
		    new
		        reason[128],
				date[36],
				username[24];

		    cache_get_data(rows, fields, g_iHandle);

		    if (rows) {
		        cache_get_field_content(0, "Username", username, g_iHandle);
		        cache_get_field_content(0, "Date", date, g_iHandle);
				cache_get_field_content(0, "Reason", reason, g_iHandle);

				if (!strcmp(username, "null", true) || !username[0])
				{
				    Dialog_Show(extraid, ShowOnly, DIALOG_STYLE_MSGBOX, DialogStyle_Title("Ban Notice"), DialogStyle_Body("Your IP is banned from this server.\n\nIP: %s\nDate: %s\nReason: %s\n\nTo request a ban appeal, please visit our website and submit a ban appeal."), "Close", "", PlayerData[extraid][pIP], date, reason);
					KickEx(extraid);
				}
				else
				{
				    Dialog_Show(extraid, ShowOnly, DIALOG_STYLE_MSGBOX, DialogStyle_Title("Ban Notice"), DialogStyle_Body("You are banned from this server.\n\nUsername: %s\nDate: %s\nReason: %s\n\nTo request a ban appeal, please visit our website and submit a ban appeal."), "Close", "", PlayerData[extraid][pUsername], date, reason);
					KickEx(extraid);
				}
		    }
		}
		case THREAD_SHOW_CHARACTER:
		{
			cache_get_data(rows, fields, g_iHandle);

			if (rows)
			{
			    static
			        skin;

			    skin = cache_get_field_int(0, "Skin");

				CharacterSelection_SetSlotData(
					extraid,
					PlayerData[extraid][pCharacter] - 1,
					skin,
					cache_get_field_int(0, "PlayingHours"),
					cache_get_field_int(0, "Money"),
					cache_get_field_int(0, "LastLogin")
				);

				for (new i = 0; i < 8; i ++) {
				    PlayerTextDrawHide(extraid, PlayerData[extraid][pTextdraws][i]);
				}
				CharacterSelection_Show(extraid, PlayerData[extraid][pCharacter], false);
			}
		}
	}
	return 1;
}

forward OnViewCharges(extraid, name[]);

// ====== OnViewCharges ======
public OnViewCharges(extraid, name[])
{
	if (GetFactionType(extraid) != FACTION_POLICE)
	    return 0;

	static
	    rows,
	    fields;

	cache_get_data(rows, fields, g_iHandle);

	if (!rows)
	    return SendErrorMessage(extraid, "No results found for charges on \"%s\".", name);

	static
	    string[1024],
		desc[128],
		date[36];

	string[0] = 0;

	for (new i = 0; i < rows; i ++) {
	    cache_get_field_content(i, "Description", desc, g_iHandle);
	    cache_get_field_content(i, "Date", date, g_iHandle);

	    format(string, sizeof(string), "%s%s (%s)\n", string, desc, date);
	}
	format(desc, sizeof(desc), "Charges: %s", name);
	Dialog_Show(extraid, ChargeList, DIALOG_STYLE_LIST, DialogStyle_Title(desc), string, "Close", "");
	return 1;
}

// ====== SetCameraData ======
stock SetCameraData(playerid)
{
    #if SERVER_CITY == 1
	    SetPlayerPos(playerid, 2096.8398,-1879.4764,15.000);
		SetPlayerCameraPos(playerid, 2096.8398,-1879.4764,30);
		SetPlayerCameraLookAt(playerid, 2080.5161,-1759.1907,13.5656);
	#elseif SERVER_CITY == 2
	    SetPlayerPos(playerid, -1553.776367, 844.732299, 32.268722);
		SetPlayerCameraPos(playerid, -1553.776367, 844.732299, 52.268722);
		SetPlayerCameraLookAt(playerid, -1554.276245, 844.740234, 52.250732);
    #elseif SERVER_CITY == 3
	    SetPlayerPos(playerid, 2069.442138, 977.235412, 6.572320);
		SetPlayerCameraPos(playerid, 2069.442138, 977.235412, 26.572320);
		SetPlayerCameraLookAt(playerid, 2069.452148, 977.702697, 26.557329);
	#endif

	return 1;
}

forward AccountCheck(playerid);

// ====== AccountCheck ======
public AccountCheck(playerid)
{
    //SetPlayerPos(playerid, -1988.752075, -72.294998, 38.647026);
	//SetPlayerCameraPos(playerid, -1988.752075, -72.294998, 58.647026);
	//SetPlayerCameraLookAt(playerid, -2006.489868, -72.107597, 55.977474);

	SetCameraData(playerid);
	SQL_CheckAccount(playerid);
	return 1;
}

forward OnResolveUsername(extraid, character[]);

// ====== OnResolveUsername ======
public OnResolveUsername(extraid, character[])
{
    new
		rows,
		fields,
		name[24];

	cache_get_data(rows, fields, g_iHandle);

	if (!rows)
 		return SendErrorMessage(extraid, "There is no account linked with the specified name.");

	cache_get_row(0, 0, name, g_iHandle);
	SendServerMessage(extraid, "%s's account username is: %s.", character, name);

	return 1;
}

forward OnLoginDate(extraid, username[]);

// ====== OnLoginDate ======
public OnLoginDate(extraid, username[])
{
    if (!IsPlayerConnected(extraid))
	    return 0;

	static
	    rows,
	    fields,
	    date[36];

	cache_get_data(rows, fields, g_iHandle);

	if (rows) {
	    cache_get_row(0, 0, date, g_iHandle);

	    SendServerMessage(extraid, "%s's last login was on: %s.", username, date);
	}
	else {
	    SendErrorMessage(extraid, "Invalid username specified.");
	}
	return 1;
}

forward OnCarStorageAdd(carid, itemid);

// ====== OnCarStorageAdd ======
public OnCarStorageAdd(carid, itemid)
{
	CarStorage[carid][itemid][cItemID] = cache_insert_id(g_iHandle);
	return 1;
}

forward OnStorageAdd(houseid, itemid);

// ====== OnStorageAdd ======
public OnStorageAdd(houseid, itemid)
{
	HouseStorage[houseid][itemid][hItemID] = cache_insert_id(g_iHandle);
	return 1;
}

forward OnDealerCarCreated(bizid, slotid);

// ====== OnDealerCarCreated ======
public OnDealerCarCreated(bizid, slotid)
{
	DealershipCars[bizid][slotid][vehID] = cache_insert_id(g_iHandle);
	return 1;
}

forward OnFurnitureCreated(furnitureid);

// ====== OnFurnitureCreated ======
public OnFurnitureCreated(furnitureid)
{
	FurnitureData[furnitureid][furnitureID] = cache_insert_id(g_iHandle);
	Furniture_Save(furnitureid);
	return 1;
}

forward OnContactAdd(playerid, id);

// ====== OnContactAdd ======
public OnContactAdd(playerid, id)
{
	ContactData[playerid][id][contactID] = cache_insert_id(g_iHandle);
	return 1;
}

forward OnInventoryAdd(playerid, itemid);

// ====== OnInventoryAdd ======
public OnInventoryAdd(playerid, itemid)
{
	InventoryData[playerid][itemid][invID] = cache_insert_id(g_iHandle);
	return 1;
}

forward OnBanLookup(playerid, username[]);

// ====== OnBanLookup ======
public OnBanLookup(playerid, username[])
{
	if (!IsPlayerConnected(playerid))
	    return 0;

	static
	    rows,
	    fields,
	    reason[128],
	    date[36];

	cache_get_data(rows, fields, g_iHandle);

	if (rows) {
	    cache_get_field_content(0, "Reason", reason, g_iHandle);
	    cache_get_field_content(0, "Date", date, g_iHandle);

		SendServerMessage(playerid, "%s was banned on %s, reason: %s", username, date, reason);
	}
	else {
	    SendErrorMessage(playerid, "%s is not banned from this server.", username);
	}
	return 1;
}

forward OnVerifyNameChange(playerid, newname[]);

// ====== OnVerifyNameChange ======
public OnVerifyNameChange(playerid, newname[])
{
	static
	    rows,
	    fields;

	cache_get_data(rows, fields, g_iHandle);

	if (rows)
	    return SendErrorMessage(playerid, "The specified name \"%s\" is already in use.", newname);

	foreach (new i : Player) if (!strcmp(ReturnName(i), newname, true)) {
	    return SendErrorMessage(playerid, "The specified name \"%s\" is already in use.", newname);
	}
	format(PlayerData[playerid][pNameChange], 24, newname);

	SendAdminAlert(COLOR_LIGHTRED, "ADMIN: %s is requesting a name change to %s (use \"/acceptname\" or \"/declinename\").", ReturnName(playerid, 0), newname);
	SendServerMessage(playerid, "Your name change request was sent to the admins.");

	return 1;
}

forward OnDeleteCharacter(playerid, name[]);

// ====== OnDeleteCharacter ======
public OnDeleteCharacter(playerid, name[])
{
	static
	    rows,
	    fields,
		query[128],
		id = -1;

    cache_get_data(rows, fields, g_iHandle);

	if (!rows)
	    return SendErrorMessage(playerid, "The character \"%s\" is not linked under any accounts.", name);

	if (cache_get_field_int(0, "Admin") > PlayerData[playerid][pAdmin])
	    return SendErrorMessage(playerid, "You are not authorized to delete a higher admin's character.");

	id = cache_get_field_int(0, "ID");

	if (id) {
	    format(query, sizeof(query), "DELETE FROM `contacts` WHERE `ID` = '%d'", id);
     	mysql_tquery(g_iHandle, query);

		format(query, sizeof(query), "DELETE FROM `gps` WHERE `ID` = '%d'", id);
  		mysql_tquery(g_iHandle, query);

		format(query, sizeof(query), "DELETE FROM `inventory` WHERE `ID` = '%d'", id);
		mysql_tquery(g_iHandle, query);

		format(query, sizeof(query), "DELETE FROM `tickets` WHERE `ID` = '%d'", id);
  		mysql_tquery(g_iHandle, query);

	    format(query, sizeof(query), "DELETE FROM `characters` WHERE `ID` = '%d'", id);
  		mysql_tquery(g_iHandle, query);

  		SendServerMessage(playerid, "You have deleted \"%s\" successfully.", name);
	}
	return 1;
}

forward OnDeleteAccount(playerid, name[]);

// ====== OnDeleteAccount ======
public OnDeleteAccount(playerid, name[])
{
	static
	    rows,
	    fields,
		id = -1;

	cache_get_data(rows, fields, g_iHandle);

	if (!rows)
	    return SendErrorMessage(playerid, "The username \"%s\" doesn't exist.", name);

	if (cache_get_field_int(0, "Admin") > PlayerData[playerid][pAdmin])
	    return SendErrorMessage(playerid, "You are not authorized to delete a higher admin's account.");

	static
	    query[128];

	for (new i = 0; i < rows; i ++)
	{
	    if ((id = cache_get_field_int(i, "ID")))
		{
	        format(query, sizeof(query), "DELETE FROM `contacts` WHERE `ID` = '%d'", id);
	        mysql_tquery(g_iHandle, query);

	        format(query, sizeof(query), "DELETE FROM `gps` WHERE `ID` = '%d'", id);
	        mysql_tquery(g_iHandle, query);

	        format(query, sizeof(query), "DELETE FROM `inventory` WHERE `ID` = '%d'", id);
	        mysql_tquery(g_iHandle, query);

            format(query, sizeof(query), "DELETE FROM `tickets` WHERE `ID` = '%d'", id);
	        mysql_tquery(g_iHandle, query);
		}
	}
	format(query, sizeof(query), "DELETE FROM `accounts` WHERE `Username` = '%s'", name);
    mysql_tquery(g_iHandle, query);

    format(query, sizeof(query), "DELETE FROM `characters` WHERE `Username` = '%s'", name);
    mysql_tquery(g_iHandle, query);

    SendServerMessage(playerid, "You have deleted \"%s\" from the database.", name);
    return 1;
}

forward OnNameChange(playerid, userid, newname[]);

// ====== OnNameChange ======
public OnNameChange(playerid, userid, newname[])
{
	if (!IsPlayerConnected(playerid) || !IsPlayerConnected(userid))
	    return 0;

	static
	    rows,
	    fields;

	cache_get_data(rows, fields, g_iHandle);

	if (rows)
	    return SendErrorMessage(playerid, "The specified name \"%s\" is in use.", newname);

    new
		oldname[MAX_PLAYER_NAME];

	GetPlayerName(userid, oldname, sizeof(oldname));
	ChangeName(userid, newname);

    for (new i = 0, l = strlen(oldname); i != l; i ++) {
	    if (oldname[i] == '_') oldname[i] = ' ';
	}
	for (new i = 0, l = strlen(newname); i != l; i ++) {
	    if (newname[i] == '_') newname[i] = ' ';
	}
	SendServerMessage(playerid, "You have changed %s's name to %s.", oldname, newname);
	SendServerMessage(userid, "%s has changed your name to %s.", ReturnName(playerid, 0), newname);

	Log_Write("logs/name_log.txt", "[%s] %s has changed %s's name to %s.", ReturnDate(), ReturnName(playerid), oldname, newname);
	return 1;
}

forward OnTicketCreated(playerid, ticketid);

// ====== OnTicketCreated ======
public OnTicketCreated(playerid, ticketid)
{
	TicketData[playerid][ticketid][ticketID] = cache_insert_id(g_iHandle);
	return 1;
}

forward OnRackCreated(rackid);

// ====== OnRackCreated ======
public OnRackCreated(rackid)
{
	if (rackid == -1 || !RackData[rackid][rackExists])
	    return 0;

	RackData[rackid][rackID] = cache_insert_id(g_iHandle);
	Rack_Save(rackid);

	return 1;
}

forward OnGateCreated(gateid);

// ====== OnGateCreated ======
public OnGateCreated(gateid)
{
	if (gateid == -1 || !GateData[gateid][gateExists])
	    return 0;

	GateData[gateid][gateID] = cache_insert_id(g_iHandle);
	Gate_Save(gateid);

	return 1;
}

forward OnBusinessCreated(bizid);

// ====== OnBusinessCreated ======
public OnBusinessCreated(bizid)
{
	if (bizid == -1 || !BusinessData[bizid][bizExists])
	    return 0;

	BusinessData[bizid][bizID] = cache_insert_id(g_iHandle);
	Business_Save(bizid);

	return 1;
}

forward OnEntranceCreated(entranceid);

// ====== OnEntranceCreated ======
public OnEntranceCreated(entranceid)
{
	if (entranceid == -1 || !EntranceData[entranceid][entranceExists])
	    return 0;

	EntranceData[entranceid][entranceID] = cache_insert_id(g_iHandle);
	EntranceData[entranceid][entranceWorld] = EntranceData[entranceid][entranceID] + 7000;

	Entrance_Save(entranceid);

	return 1;
}

forward OnCarCreated(carid);

// ====== OnCarCreated ======
public OnCarCreated(carid)
{
	if (carid == -1 || !CarData[carid][carExists])
	    return 0;

	CarData[carid][carID] = cache_insert_id(g_iHandle);
	Car_Save(carid);

	return 1;
}

forward OnPumpCreated(pumpid);

// ====== OnPumpCreated ======
public OnPumpCreated(pumpid)
{
    PumpData[pumpid][pumpID] = cache_insert_id(g_iHandle);
	Pump_Save(pumpid);

	return 1;
}

forward OnArrestCreated(arrestid);

// ====== OnArrestCreated ======
public OnArrestCreated(arrestid)
{
	if (arrestid == -1 || !ArrestData[arrestid][arrestExists])
	    return 0;

	ArrestData[arrestid][arrestID] = cache_insert_id(g_iHandle);
	Arrest_Save(arrestid);

	return 1;
}

forward OnPlantCreated(plantid);

// ====== OnPlantCreated ======
public OnPlantCreated(plantid)
{
	if (plantid == -1 || !PlantData[plantid][plantExists])
	    return 0;

	PlantData[plantid][plantID] = cache_insert_id(g_iHandle);
	Plant_Save(plantid);

	return 1;
}

forward OnCrateCreated(crateid);

// ====== OnCrateCreated ======
public OnCrateCreated(crateid)
{
	if (crateid == -1 || !CrateData[crateid][crateExists])
	    return 0;

	CrateData[crateid][crateID] = cache_insert_id(g_iHandle);
	Crate_Save(crateid);

	return 1;
}

forward OnFactionCreated(factionid);

// ====== OnFactionCreated ======
public OnFactionCreated(factionid)
{
	if (factionid == -1 || !FactionData[factionid][factionExists])
	    return 0;

	FactionData[factionid][factionID] = cache_insert_id(g_iHandle);

	Faction_Save(factionid);
	Faction_SaveRanks(factionid);

	return 1;
}

forward OnBackpackCreated(id);

// ====== OnBackpackCreated ======
public OnBackpackCreated(id)
{
	if (id == -1 || !BackpackData[id][backpackExists])
	    return 0;

	BackpackData[id][backpackID] = cache_insert_id(g_iHandle);
	Backpack_Save(id);

	return 1;
}

forward OnATMCreated(atmid);

// ====== OnATMCreated ======
public OnATMCreated(atmid)
{
    if (atmid == -1 || !ATMData[atmid][atmExists])
		return 0;

	ATMData[atmid][atmID] = cache_insert_id(g_iHandle);
 	ATM_Save(atmid);

	return 1;
}

forward OnImpoundCreated(impoundid);

// ====== OnImpoundCreated ======
public OnImpoundCreated(impoundid)
{
	if (impoundid == -1 || !ImpoundData[impoundid][impoundExists])
	    return 0;

	ImpoundData[impoundid][impoundID] = cache_insert_id(g_iHandle);
	Impound_Save(impoundid);

	return 1;
}

forward OnGraffitiCreated(id);

// ====== OnGraffitiCreated ======
public OnGraffitiCreated(id)
{
	GraffitiData[id][graffitiID] = cache_insert_id(g_iHandle);
	Graffiti_Save(id);

	return 1;
}

forward OnDetectorCreated(id);

// ====== OnDetectorCreated ======
public OnDetectorCreated(id)
{
	MetalDetectors[id][detectorID] = cache_insert_id(g_iHandle);
	return 1;
}

forward OnGarbageCreated(garbageid);

// ====== OnGarbageCreated ======
public OnGarbageCreated(garbageid)
{
	if (garbageid == -1 || !GarbageData[garbageid][garbageExists])
	    return 0;

	GarbageData[garbageid][garbageID] = cache_insert_id(g_iHandle);
	Garbage_Save(garbageid);

	return 1;
}

forward OnVendorCreated(vendorid);

// ====== OnVendorCreated ======
public OnVendorCreated(vendorid)
{
	if (vendorid == -1 || !VendorData[vendorid][vendorExists])
	    return 0;

	VendorData[vendorid][vendorID] = cache_insert_id(g_iHandle);
	Vendor_Save(vendorid);

	return 1;
}

forward OnSpeedCreated(speedid);

// ====== OnSpeedCreated ======
public OnSpeedCreated(speedid)
{
	if (speedid == -1 || !SpeedData[speedid][speedExists])
	    return 0;

	SpeedData[speedid][speedID] = cache_insert_id(g_iHandle);
	Speed_Save(speedid);

	return 1;
}

forward OnHouseCreated(houseid);

// ====== OnHouseCreated ======
public OnHouseCreated(houseid)
{
	if (houseid == -1 || !HouseData[houseid][houseExists])
	    return 0;

	HouseData[houseid][houseID] = cache_insert_id(g_iHandle);
	House_Save(houseid);

	return 1;
}

forward OnDroppedItem(itemid);

// ====== OnDroppedItem ======
public OnDroppedItem(itemid)
{
	if (itemid == -1 || !DroppedItems[itemid][droppedModel])
	    return 0;

	DroppedItems[itemid][droppedID] = cache_insert_id(g_iHandle);
	return 1;
}

forward OnJobCreated(jobid);

// ====== OnJobCreated ======
public OnJobCreated(jobid)
{
	if (jobid == -1 || !JobData[jobid][jobExists])
	    return 0;

	JobData[jobid][jobID] = cache_insert_id(g_iHandle);
	Job_Save(jobid);

	return 1;
}

forward OnCharacterLookup(extraid, id, character[]);

// ====== OnCharacterLookup ======
public OnCharacterLookup(extraid, id, character[])
{
	if (!IsPlayerConnected(extraid))
	    return 0;

	static
	    rows,
	    fields,
	    string[128];

	cache_get_data(rows, fields, g_iHandle);

	if (rows)
	{
	    static
	        admin,
	        skin,
	        createDate,
	        lastLogin;

		admin = cache_get_field_int(0, "Admin");
		skin = cache_get_field_int(0, "Skin");

		createDate = cache_get_field_int(0, "CreateDate");
		lastLogin = cache_get_field_int(0, "LastLogin");

		format(string, sizeof(string), "~g~Name:~w~ %s~n~~g~Account:~w~ %s~n~~g~Created:~w~ %s~n~~g~Last Login:~w~ %s", character, (admin > 0) ? ("Admin") : ("Player"), GetDuration(gettime() - createDate), GetDuration(gettime() - lastLogin));
		PlayerTextDrawSetString(extraid, PlayerData[extraid][pTextdraws][52], string);

		format(string, sizeof(string), "#%d: %s", id, character);
		PlayerTextDrawSetString(extraid, PlayerData[extraid][pTextdraws][53], string);

		PlayerTextDrawSetPreviewModel(extraid, PlayerData[extraid][pTextdraws][54], skin);

		for (new i = 40; i < 58; i ++)
  		{
    		if (i >= 50)
      			PlayerTextDrawShow(extraid, PlayerData[extraid][pTextdraws][i]);

			else if (i < 50)
   				PlayerTextDrawHide(extraid, PlayerData[extraid][pTextdraws][i]);
   		}
		SelectTextDraw(extraid, -1);

		PlayerData[extraid][pDisplayStats] = 2;
		PlayerData[extraid][pCharacterMenu] = id;
	}
	return 1;
}

forward OnCharacterCheck(extraid, character[]);

// ====== OnCharacterCheck ======
public OnCharacterCheck(extraid, character[])
{
	if (!IsPlayerConnected(extraid))
	    return 0;

	static
	    rows,
	    fields,
		query[150];

	cache_get_data(rows, fields, g_iHandle);

	if (rows)
	{
	    Dialog_Show(extraid, CreateChar, DIALOG_STYLE_INPUT, DialogStyle_Title("Create Character"), DialogStyle_Body("Error: The specified name \"%s\" is in use!\n\nPlease enter the name of your new character below:\n\nWarning: Your name must be in the Firstname_Lastname format and not exceed 24 characters."), "Create", "Cancel", character);
	}
	else
	{
		format(query, sizeof(query), "INSERT INTO `characters` (`Username`, `Character`, `CreateDate`) VALUES('%s', '%s', '%d')", PlayerData[extraid][pUsername], character, gettime());
		mysql_tquery(g_iHandle, query, "OnQueryFinished", "dd", extraid, THREAD_CREATE_CHAR);

		format(PlayerCharacters[extraid][PlayerData[extraid][pCharacter] - 1], MAX_PLAYER_NAME + 1, character);
		CharacterSelection_SetSlotData(extraid, PlayerData[extraid][pCharacter] - 1, PlayerData[extraid][pSkin], 1, PlayerData[extraid][pMoney], 0);
		SendServerMessage(extraid, "You have successfully created character \"%s\".", character);
	}
	return 1;
}
