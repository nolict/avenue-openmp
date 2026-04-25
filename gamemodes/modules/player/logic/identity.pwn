/*
    File: modules/player/logic/identity.pwn
    Purpose: Contains player gameplay logic and helper functions for identity.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== ChangeName ======
stock ChangeName(playerid, name[], bool:logging = true)
{
	new
	    id = PlayerData[playerid][pCharacter] - 1,
		query[160],
		oldname[24];

	GetPlayerName(playerid, oldname, sizeof(oldname));

	if (logging)
	{
	    format(query, sizeof(query), "INSERT INTO `namechanges` (`OldName`, `NewName`, `Date`) VALUES('%s', '%s', '%s')", oldname, name, ReturnDate());
		mysql_tquery(g_iHandle, query);
	}
    format(PlayerCharacters[playerid][id], MAX_PLAYER_NAME + 1, name);
	SetPlayerName(playerid, name);

	format(query, sizeof(query), "UPDATE `characters` SET `Character` = '%s' WHERE `Character` = '%s'", name, oldname);
	mysql_tquery(g_iHandle, query);

	return 1;
}

// ====== SQL_LoadCharacter ======
SQL_LoadCharacter(playerid, characterid)
{
	if (characterid < 1 || characterid > 3)
		return 0;

	new
		query[160];

	format(query, sizeof(query), "UPDATE `characters` SET `LastLogin` = '%d' WHERE `Username` = '%s' AND `Character` = '%s'", gettime(), PlayerData[playerid][pUsername], PlayerCharacters[playerid][characterid - 1]);
	mysql_tquery(g_iHandle, query);

	format(query, sizeof(query), "SELECT * FROM `characters` WHERE `Username` = '%s' AND `Character` = '%s'", PlayerData[playerid][pUsername], PlayerCharacters[playerid][characterid - 1]);
	mysql_tquery(g_iHandle, query, "OnQueryFinished", "dd", playerid, THREAD_LOAD_CHARACTER);

	return 1;
}

// ====== ShowCharacterMenu ======
ShowCharacterMenu(playerid)
{
	if (PlayerData[playerid][pCharacter] != 0)
	{
	    PlayerData[playerid][pCharacter] = 0;

		for (new i = 0; i < 8; i ++) {
  			PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
		}
		for (new i = 71; i < 81; i ++) {
			PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
		}
	}
	CancelSelectTextDraw(playerid);
	CharacterSelection_Show(playerid, 1, false);
}

// ====== GetPlayerID ======
stock GetPlayerID(name[], underscore = 1)
{
	foreach (new i : Player) if (!strcmp(ReturnName(i, underscore), name, true)) {
	    return i;
	}
	return INVALID_PLAYER_ID;
}
