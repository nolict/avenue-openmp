/*
    File: modules/player/dialogs/account.pwn
    Purpose: Contains easyDialog callbacks for player account flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:ChangePassword ======
Dialog:ChangePassword(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    if (isnull(inputtext))
	        return cmd_changepass(playerid, "\1");

		static
		    buffer[129],
			query[256];

		WP_Hash(buffer, sizeof(buffer), inputtext);
		inputtext[0] = '\0';

		format(query, sizeof(query), "SELECT `Password` FROM `accounts` WHERE `Username` = '%s' AND `Password` = '%s'", PlayerData[playerid][pUsername], buffer);
		mysql_tquery(g_iHandle, query, "OnQueryFinished", "dd", playerid, THREAD_VERIFY_PASS);
	}
	return 1;
}
