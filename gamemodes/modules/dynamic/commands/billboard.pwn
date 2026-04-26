/*
    File: modules/dynamic/commands/billboard.pwn
    Purpose: Contains ZCMD command handlers for dynamic billboard features.
    Notes: Keep command parsing here and delegate reusable gameplay work to logic files.
*/

// ====== CMD:bname ======
CMD:bname(playerid, params[])
{
	new
		id = -1;

    if ((id = (Business_Inside(playerid) == -1) ? (Business_Nearest(playerid)) : (Business_Inside(playerid))) != -1 && Business_IsOwner(playerid, id))
	{
		if (isnull(params))
		    return SendSyntaxMessage(playerid, "/bname [new name]");

		if (strlen(params) > 32)
		    return SendErrorMessage(playerid, "The business name can't exceed 32 characters.");

		format(BusinessData[id][bizName], 32, params);

		Business_Refresh(id);
		Business_Save(id);

		SendServerMessage(playerid, "Business name set to: \"%s\".", params);
	}
	else SendErrorMessage(playerid, "You are not in range of your business.");
	return 1;
}


// ====== CMD:bmessage ======
CMD:bmessage(playerid, params[])
{
	new
		id = -1;

    if ((id = (Business_Inside(playerid) == -1) ? (Business_Nearest(playerid)) : (Business_Inside(playerid))) != -1 && Business_IsOwner(playerid, id))
	{
		if (isnull(params))
		    return SendSyntaxMessage(playerid, "/bmessage [message] - Use \"none\" to disable.");

		if (!strcmp(params, "none", true))
		{
		    BusinessData[id][bizMessage][0] = '\0';

			Business_Save(id);
			SendServerMessage(playerid, "You have removed the business message.");
		}
		else
		{
			format(BusinessData[id][bizMessage], 128, params);

			Business_Save(id);
			SendServerMessage(playerid, "Business message set to: \"%s\".", params);
		}
	}
	else SendErrorMessage(playerid, "You are not in range of your business.");
	return 1;
}

// ====== CMD:editbillboard ======
CMD:editbillboard(playerid, params[])
{
	static
	    id,
	    type[24],
	    string[128];

	if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editbillboard [id] [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "NAMES: {FFFFFF}location, name, price, message, owner, range");
		return 1;
	}
	if ((id < 0 || id >= MAX_BILLBOARDS) || !BillBoardData[id][bbExists])
	    return SendErrorMessage(playerid, "You have specified an invalid business ID.");

	if (!strcmp(type, "location", true))
	{
 		GetPlayerPos(playerid, BillBoardData[id][bbPos][0], BillBoardData[id][bbPos][1], BillBoardData[id][bbPos][2]);

		Billboard_Refresh(id);
		Billboard_Save(id);

		SendAdminAlert(COLOR_LIGHTRED, "ADMIN: %s has adjusted the location of billboard ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "price", true))
	{
	    new price;

	    if (sscanf(string, "d", price))
	        return SendSyntaxMessage(playerid, "/editbillboard [id] [price] [new price]");

	    BillBoardData[id][bbPrice] = price;

	    Billboard_Refresh(id);
	    Billboard_Save(id);

		SendAdminAlert(COLOR_LIGHTRED, "ADMIN: %s has adjusted the price of billboard ID: %d to %s.", ReturnName(playerid, 0), id, FormatNumber(price));
	}
	else if (!strcmp(type, "name", true))
	{
	    new name[32];

	    if (sscanf(string, "s[32]", name))
	        return SendSyntaxMessage(playerid, "/editbillboard [id] [name] [new name]");

	    format(BillBoardData[id][bbName], 32, name);

	    Billboard_Refresh(id);
	    Billboard_Save(id);

		SendAdminAlert(COLOR_LIGHTRED, "ADMIN: %s has adjusted the name of billboard ID: %d to \"%s\".", ReturnName(playerid, 0), id, name);
	}
	else if (!strcmp(type, "message", true))
	{
	    new name[32];

	    if (sscanf(string, "s[230]", name))
	        return SendSyntaxMessage(playerid, "/editbillboard [id] [message] [new message] (Max Chars: 230)");

	    format(BillBoardData[id][bbMessage], 32, name);

	    Billboard_Refresh(id);
	    Billboard_Save(id);

		SendAdminAlert(COLOR_LIGHTRED, "ADMIN: %s has adjusted the message of billboard ID: %d to \"%s\".", ReturnName(playerid, 0), id, name);
	}
	else if (!strcmp(type, "owner", true))
	{
	    new giveplayerid;

	    if (sscanf(string, "d", giveplayerid))
	        return SendSyntaxMessage(playerid, "/editbillboard [id] [(remove)owner] [playerid]");

        if (giveplayerid == INVALID_PLAYER_ID)
	    	return SendErrorMessage(playerid, "That player is disconnected.");
		BillBoardData[id][bbOwner] = GetPlayerSQLID(giveplayerid);

	    Billboard_Refresh(id);
	    Billboard_Save(id);

		SendAdminAlert(COLOR_LIGHTRED, "ADMIN: %s has adjusted the owner of billboard ID: %d", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "removeowner", true))
	{
	    if (sscanf(string, "d"))
	        return SendSyntaxMessage(playerid, "/editbillboard [id] [removeowner]");

		BillBoardData[id][bbOwner] = 0;

	    Billboard_Refresh(id);
	    Billboard_Save(id);

		SendAdminAlert(COLOR_LIGHTRED, "ADMIN: %s has removed the owner of billboard ID: %d", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "range", true))
	{
	    new range;

	    if (sscanf(string, "d", range))
	        return SendSyntaxMessage(playerid, "/editbillboard [id] [range] [new range]");

        if(range < 10)
		{
		    SendErrorMessage(playerid, "Range can only be 10-200");
		    return 1;
		}

		if(range > 200)
		{
		    SendErrorMessage(playerid, "Range can only be 10-200");
		    return 1;
		}

	    BillBoardData[id][bbRange] = range;

	    Billboard_Refresh(id);
	    Billboard_Save(id);

		SendAdminAlert(COLOR_LIGHTRED, "ADMIN: %s has adjusted the range of billboard ID: %d to %d.", ReturnName(playerid, 0), id, range);
	}
	return 1;
}


// ====== CMD:destroybillboard ======
CMD:destroybillboard(playerid, params[])
{
	static
	    id = 0;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/destroybillboard [bb id]");

	if ((id < 0 || id >= MAX_BILLBOARDS) || !BillBoardData[id][bbExists])
	    return SendErrorMessage(playerid, "You have specified an invalid billboard ID.");

	Billboard_Delete(id);
	SendServerMessage(playerid, "You have successfully destroyed billboard ID: %d.", id);
	return 1;
}


// ====== CMD:createbillboard ======
CMD:createbillboard(playerid, params[])
{
	static
	    id = -1;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	id = Billboard_Create(playerid, -1);

	if (id == -1)
	    return SendErrorMessage(playerid, "The server has reached the limit for billboards.");

	SendServerMessage(playerid, "You have successfully created billboard ID: %d.", id);
	return 1;
}


// ====== CMD:billboards ======
CMD:billboards(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] < 1)
	{
	    SendErrorMessage(playerid, "You are not authorized to use this command");
	    return 1;
	}
	ViewBillboards(playerid);
	return 1;
}


// ====== CMD:mybillboard ======
CMD:mybillboard(playerid, params[])
{
	if(PlayerData[playerid][pOwnsBillboard] == -1)
	{
	    SendErrorMessage(playerid, "You do not own a billboard");
	    return 1;
	}
    Dialog_Show(playerid, MyBillboardMenu, DIALOG_STYLE_LIST, DialogStyle_Title("Manage Billboard"), DialogStyle_Body("Edit Message\nUnrent Billboard"), "Proceed", "Cancel");
    return 1;
}
