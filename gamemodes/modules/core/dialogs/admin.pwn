/*
    File: modules/core/dialogs/admin.pwn
    Purpose: Contains easyDialog callbacks for core admin flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:ServerPanel ======
Dialog:ServerPanel(playerid, response, listitem, inputtext[])
{
	if (PlayerData[playerid][pAdmin] < 6)
		return 0;

	if (response)
	{
	    switch (listitem)
	    {
			case 0:
			{
				if (g_ServerLocked)
				{
				    g_ServerLocked = false;

				    SendRconCommand("password 0");
				    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has unlocked the server.", ReturnName(playerid, 0));
				}
				else Dialog_Show(playerid, LockServer, DIALOG_STYLE_INPUT, DialogStyle_Title("Lock Server"), DialogStyle_Body("Please enter the specified password below to lock the server with:"), "Lock", "Back");
			}
			case 1:
			    Dialog_Show(playerid, SetHostname, DIALOG_STYLE_INPUT, DialogStyle_Title("Set Hostname"), DialogStyle_Body("Please enter the new server hostname below:"), "Submit", "Back");

			case 2:
			    Dialog_Show(playerid, ExecuteQuery, DIALOG_STYLE_INPUT, DialogStyle_Title("Execute Query"), DialogStyle_Body("Please specify the MySQL query to execute below:"), "Execute", "Back");
	    }
	}
	return 1;
}

// ====== Dialog:LockServer ======
Dialog:LockServer(playerid, response, listitem, inputtext[])
{
	if (PlayerData[playerid][pAdmin] < 6)
		return 0;

	if (response)
	{
	    if (isnull(inputtext) || !strcmp(inputtext, "0"))
	        return Dialog_Show(playerid, LockServer, DIALOG_STYLE_INPUT, DialogStyle_Title("Lock Server"), DialogStyle_Body("Please enter the specified password below to lock the server with:"), "Lock", "Back");

		if (strlen(inputtext) > 32)
		    return Dialog_Show(playerid, LockServer, DIALOG_STYLE_INPUT, DialogStyle_Title("Lock Server"), DialogStyle_Body("Error: Please type a password shorter than 32 characters.\n\nPlease enter the specified password below to lock the server with:"), "Lock", "Back");

		static
		    str[48];

	    format(str, sizeof(str), "password %s", inputtext);
		g_ServerLocked = true;

		SendRconCommand(str);
	    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has locked the server (password: %s).", ReturnName(playerid, 0), inputtext);
	}
	else cmd_panel(playerid, "\1");
	return 1;
}

// ====== Dialog:SetHostname ======
Dialog:SetHostname(playerid, response, listitem, inputtext[])
{
	if (PlayerData[playerid][pAdmin] < 6)
		return 0;

	if (response)
	{
	    if (isnull(inputtext))
	        return Dialog_Show(playerid, SetHostname, DIALOG_STYLE_INPUT, DialogStyle_Title("Set Hostname"), DialogStyle_Body("Please enter the new server hostname below:"), "Submit", "Back");

		static
		    str[128];

	    format(str, sizeof(str), "hostname %s", inputtext);

		SendRconCommand(str);
	    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has set the hostname to \"%s\".", ReturnName(playerid, 0), inputtext);
	}
	else cmd_panel(playerid, "\1");
	return 1;
}

// ====== Dialog:ExecuteQuery ======
Dialog:ExecuteQuery(playerid, response, listitem, inputtext[])
{
	if (PlayerData[playerid][pAdmin] < 6)
		return 0;

	if (response)
	{
        if (isnull(inputtext))
            return Dialog_Show(playerid, ExecuteQuery, DIALOG_STYLE_INPUT, DialogStyle_Title("Execute Query"), DialogStyle_Body("Please specify the MySQL query to execute below:"), "Execute", "Back");

        if (strfind(inputtext, "DELETE", true) != -1 || strfind(inputtext, "DROP", true) != -1)
            return Dialog_Show(playerid, ExecuteQuery, DIALOG_STYLE_INPUT, DialogStyle_Title("Execute Query"), DialogStyle_Body("Error: You can't execute \"DROP\" or \"DELETE\" queries.\n\nPlease specify the MySQL query to execute below:"), "Execute", "Back");

		PlayerData[playerid][pExecute] = 1;
		mysql_tquery(g_iHandle, inputtext, "OnQueryExecute", "ds", playerid, inputtext);
	}
	else cmd_panel(playerid, "\1");
	return 1;
}

