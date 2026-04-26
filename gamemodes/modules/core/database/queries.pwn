/*
    File: modules/core/database/queries.pwn
    Purpose: Contains core database definitions and helpers for queries.
    Notes: Keep this file focused on shared infrastructure, not feature gameplay bodies.
*/

// ====== cache_get_field_float ======
stock Float:cache_get_field_float(row, const field_name[])
{
	new
	    str[16];

	cache_get_field_content(row, field_name, str, g_iHandle, sizeof(str));
	return floatstr(str);
}

// ====== SQL_Connect ======
SQL_Connect() {
	g_iHandle = mysql_connect(SQL_HOSTNAME, SQL_USERNAME, SQL_DATABASE, SQL_PASSWORD);

	if (mysql_errno(g_iHandle) != 0) {
	    printf("SQL: Connection to \"%s\" failed! Please check the connection settings...\a", SQL_HOSTNAME);
	}
	else {
		printf("SQL: Connection to \"%s\" passed!", SQL_HOSTNAME);
	}
}

// ====== SQL_CreateAccount ======
stock SQL_CreateAccount(const username[], const password[])
{
	new
	    query[512],
	    buffer[129];

	WP_Hash(buffer, sizeof(buffer), password);

	format(query, sizeof(query), "INSERT INTO `accounts` (`Username`, `Password`, `RegisterDate`, `LoginDate`) VALUES('%s', '%s', '%s', '%s')", username, buffer, ReturnDate(), ReturnDate());
	mysql_tquery(g_iHandle, query);
}

// ====== SQL_CheckAccount ======
stock SQL_CheckAccount(playerid)
{
	new
	    query[128];

    format(query, sizeof(query), "SELECT `Username` FROM `characters` WHERE `Character` = '%s'", ReturnName(playerid));
	mysql_tquery(g_iHandle, query, "OnQueryFinished", "dd", playerid, THREAD_FIND_USERNAME);
}

// ====== SQL_AttemptLogin ======
stock SQL_AttemptLogin(playerid, const password[])
{
	new
		query[300],
		buffer[129];

	WP_Hash(buffer, sizeof(buffer), password);

	format(query, sizeof(query), "SELECT `ID` FROM `accounts` WHERE `Username` = '%s' AND `Password` = '%s'", PlayerData[playerid][pUsername], buffer);
    mysql_tquery(g_iHandle, query, "OnQueryFinished", "dd", playerid, THREAD_LOGIN);
}

// ====== SQL_IsLogged ======
stock SQL_IsLogged(playerid) {
	return (PlayerData[playerid][pLogged] && PlayerData[playerid][pCharacter] > 0);
}

// ====== SQL_ReturnEscaped ======
stock SQL_ReturnEscaped(const string[])
{
	new
	    entry[256];

	mysql_real_escape_string(string, entry, g_iHandle);
	return entry;
}

// ====== SQL_SaveCharacter ======
stock SQL_SaveCharacter(playerid)
{
	if (!PlayerData[playerid][pLogged] && !PlayerData[playerid][pCharacter])
		return 0;

	new
	    query[2048];

	if (GetPlayerState(playerid) != PLAYER_STATE_SPECTATING && !PlayerData[playerid][pDrivingTest])
	{
	    PlayerData[playerid][pInterior] = GetPlayerInterior(playerid);
	    PlayerData[playerid][pWorld] = GetPlayerVirtualWorld(playerid);

	    GetPlayerPos(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]);
	    GetPlayerFacingAngle(playerid, PlayerData[playerid][pPos][3]);

	    GetPlayerHealth(playerid, PlayerData[playerid][pHealth]);
	    GetPlayerArmour(playerid, PlayerData[playerid][pArmorStatus]);

	    if (!PlayerData[playerid][pKilled] && PlayerData[playerid][pHealth] == 0.0) {
	        PlayerData[playerid][pHealth] = 100.0;
		}
		if (PlayerData[playerid][pRangeBooth] == -1) {
			UpdateWeapons(playerid);
		}
	}
	format(query, sizeof(query), "UPDATE `characters` SET `Created` = '%d', `Gender` = '%d', `Birthdate` = '%s', `Origin` = '%s', `Skin` = '%d', `PosX` = '%.4f', `PosY` = '%.4f', `PosZ` = '%.4f', `PosA` = '%.4f', `Health` = '%.4f', `Interior` = '%d', `World` = '%d', `Hospital` = '%d', `HospitalInt` = '%d', `Money` = '%d', `BankMoney` = '%d', `OwnsBillboard` = '%d', `Savings` = '%d', `Admin` = '%d', `JailTime` = '%d', `Muted` = '%d', `Tester` = '%d'",
		PlayerData[playerid][pCreated],
		PlayerData[playerid][pGender],
		PlayerData[playerid][pBirthdate],
		PlayerData[playerid][pOrigin],
		PlayerData[playerid][pSkin],
		PlayerData[playerid][pPos][0],
		PlayerData[playerid][pPos][1],
		PlayerData[playerid][pPos][2],
		PlayerData[playerid][pPos][3],
		PlayerData[playerid][pHealth],
		PlayerData[playerid][pInterior],
		PlayerData[playerid][pWorld],
		PlayerData[playerid][pHospital],
		PlayerData[playerid][pHospitalInt],
		PlayerData[playerid][pMoney],
		PlayerData[playerid][pBankMoney],
		PlayerData[playerid][pOwnsBillboard],
		PlayerData[playerid][pSavings],
		PlayerData[playerid][pAdmin],
		PlayerData[playerid][pJailTime],
		PlayerData[playerid][pMuted],
  		PlayerData[playerid][pTester]
	);
	for (new i = 0; i < 13; i ++) {
		format(query, sizeof(query), "%s, `Gun%d` = '%d', `Ammo%d` = '%d'", query, i + 1, PlayerData[playerid][pGuns][i], i + 1, PlayerData[playerid][pAmmo][i]);
	}
	format(query, sizeof(query), "%s, `House` = '%d', `Business` = '%d', `Entrance` = '%d', `Phone` = '%d', `Lottery` = '%d', `LotteryB` = '%d', `Hunger` = '%d', `Thirst` = '%d', `PlayingHours` = '%d', `Minutes` = '%d', `ArmorStatus` = '%.4f', `Job` = '%d', `Faction` = '%d', `FactionRank` = '%d', `Prisoned` = '%d', `Injured` = '%d', `Warrants` = '%d', `Channel` = '%d', `Bleeding` = '%d', `AdminHide` = '%d', `SpawnPoint` = '%d'",
		query,
		PlayerData[playerid][pHouse],
		PlayerData[playerid][pBusiness],
		PlayerData[playerid][pEntrance],
		PlayerData[playerid][pPhone],
		PlayerData[playerid][pLottery],
		PlayerData[playerid][pLotteryB],
		PlayerData[playerid][pHunger],
		PlayerData[playerid][pThirst],
		PlayerData[playerid][pPlayingHours],
		PlayerData[playerid][pMinutes],
		PlayerData[playerid][pArmorStatus],
		PlayerData[playerid][pJob],
		PlayerData[playerid][pFactionID],
		PlayerData[playerid][pFactionRank],
		PlayerData[playerid][pPrisoned],
		PlayerData[playerid][pInjured],
		PlayerData[playerid][pWarrants],
		PlayerData[playerid][pChannel],
		PlayerData[playerid][pBleeding],
		PlayerData[playerid][pAdminHide],
		PlayerData[playerid][pSpawnPoint]
	);
	format(query, sizeof(query), "%s, `Warnings` = '%d', `Warn1` = '%s', `Warn2` = '%s', `MaskID` = '%d', `FactionMod` = '%d', `Capacity` = '%d' WHERE `ID` = '%d'",
	    query,
	    PlayerData[playerid][pWarnings],
	    SQL_ReturnEscaped(PlayerData[playerid][pWarn1]),
	    SQL_ReturnEscaped(PlayerData[playerid][pWarn2]),
	    PlayerData[playerid][pMaskID],
	    PlayerData[playerid][pFactionMod],
	    PlayerData[playerid][pCapacity],
		PlayerData[playerid][pID]
	);
	mysql_tquery(g_iHandle, query);

	SQL_SaveAccessories(playerid);
	return 1;
}

// ====== SQL_SaveAccessories ======
stock SQL_SaveAccessories(playerid)
{
    if (!PlayerData[playerid][pLogged])
		return 0;

	new
	    query[768];

    format(query, sizeof(query), "UPDATE `characters` SET `Glasses` = '%d', `Hat` = '%d', `Bandana` = '%d', `GlassesPos` = '%.4f|%.4f|%.4f|%.4f|%.4f|%.4f|%.4f|%.4f|%.4f'",
	    PlayerData[playerid][pGlasses],
	    PlayerData[playerid][pHat],
	    PlayerData[playerid][pBandana],
		AccessoryData[playerid][0][0],
        AccessoryData[playerid][0][1],
        AccessoryData[playerid][0][2],
        AccessoryData[playerid][0][3],
        AccessoryData[playerid][0][4],
        AccessoryData[playerid][0][5],
        AccessoryData[playerid][0][6],
        AccessoryData[playerid][0][7],
        AccessoryData[playerid][0][8]
	);
    format(query, sizeof(query), "%s, `HatPos` = '%.4f|%.4f|%.4f|%.4f|%.4f|%.4f|%.4f|%.4f|%.4f'",
        query,
		AccessoryData[playerid][1][0],
        AccessoryData[playerid][1][1],
        AccessoryData[playerid][1][2],
        AccessoryData[playerid][1][3],
        AccessoryData[playerid][1][4],
        AccessoryData[playerid][1][5],
        AccessoryData[playerid][1][6],
        AccessoryData[playerid][1][7],
        AccessoryData[playerid][1][8]
	);
	format(query, sizeof(query), "%s, `BandanaPos` = '%.4f|%.4f|%.4f|%.4f|%.4f|%.4f|%.4f|%.4f|%.4f' WHERE `ID` = '%d'",
	    query,
		AccessoryData[playerid][2][0],
        AccessoryData[playerid][2][1],
        AccessoryData[playerid][2][2],
        AccessoryData[playerid][2][3],
        AccessoryData[playerid][2][4],
        AccessoryData[playerid][2][5],
        AccessoryData[playerid][2][6],
        AccessoryData[playerid][2][7],
        AccessoryData[playerid][2][8],
        PlayerData[playerid][pID]
	);
	mysql_tquery(g_iHandle, query);
	return 1;
}

// ====== ViewBillboards ======
stock ViewBillboards(playerid)
{
	new
	    string[128];

	format(string, sizeof(string), "SELECT * FROM `billboards` ORDER BY `bbID` DESC");
	mysql_tquery(g_iHandle, string, "OnViewBillboards", "d", playerid);
	return 1;
}

// ====== ViewFactions ======
stock ViewFactions(playerid)
{
	new string[1040];
	for (new i = 0; i != MAX_FACTIONS; i ++) if (FactionData[i][factionExists]) {
  		format(string, sizeof(string), "%s{FFFFFF}Faction ({FFBF00}%i{FFFFFF}) | %s\n", string, i, FactionData[i][factionName]);
	}
	Dialog_Show(playerid, FactionsList, DIALOG_STYLE_MSGBOX, DialogStyle_Title("Factions List"), string, "Close", "");
	return 1;
}



Blacklist_Add(ip[], username[], banner[], reason[])
{
	static
	    string[256];

	format(string, sizeof(string), "INSERT INTO `blacklist` (`IP`, `Username`, `BannedBy`, `Reason`, `Date`) VALUES('%s', '%s', '%s', '%s', '%s')",
		SQL_ReturnEscaped(ip),
		SQL_ReturnEscaped(username),
		SQL_ReturnEscaped(banner),
		SQL_ReturnEscaped(reason),
		ReturnDate()
	);
	mysql_tquery(g_iHandle, string);
}

Blacklist_Remove(username[])
{
	static
	    string[128];

	format(string, sizeof(string), "DELETE FROM `blacklist` WHERE `Username` = '%s'", SQL_ReturnEscaped(username));
    mysql_tquery(g_iHandle, string);
}

Blacklist_RemoveIP(ip[])
{
	static
	    string[128];

    format(string, sizeof(string), "DELETE FROM `blacklist` WHERE `IP` = '%s'", SQL_ReturnEscaped(ip));
    mysql_tquery(g_iHandle, string);
}
