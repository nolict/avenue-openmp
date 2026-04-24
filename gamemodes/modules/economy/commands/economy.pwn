/*
    File: modules/economy/commands/economy.pwn
    Purpose: Contains ZCMD command handlers for economy economy features.
    Notes: Keep command parsing here and delegate reusable gameplay work to logic files.
*/

// ====== CMD:atm ======
CMD:atm(playerid, params[])
{
	if (ATM_Nearest(playerid) == -1)
	    return SendErrorMessage(playerid, "You are not in range of any ATM machine.");

	Dialog_Show(playerid, Bank, DIALOG_STYLE_LIST, DialogStyle_Title("Bank Account"), DialogStyle_Body("Bank Balance: %s"), "Select", "Cancel", FormatNumber(PlayerData[playerid][pBankMoney]), FormatNumber(PlayerData[playerid][pSavings]));
	return 1;
}


// ====== CMD:bank ======
CMD:bank(playerid, params[])
{
	if (!IsPlayerInBank(playerid))
	    return SendErrorMessage(playerid, "You are not in range of any bank.");

	Dialog_Show(playerid, Bank, DIALOG_STYLE_LIST, DialogStyle_Title("Bank Account"), DialogStyle_Body("Bank Balance: %s"), "Select", "Cancel", FormatNumber(PlayerData[playerid][pBankMoney]), FormatNumber(PlayerData[playerid][pSavings]));
	return 1;
}


// ====== CMD:pay ======
CMD:pay(playerid, params[])
{
	static
	    userid,
	    amount;

	if (sscanf(params, "ud", userid, amount))
	    return SendSyntaxMessage(playerid, "/pay [playerid/name] [amount]");

	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "That player is disconnected or not near you.");

	if (userid == playerid)
		return SendErrorMessage(playerid, "You can't give yourself money.");

	if (amount < 1)
	    return SendErrorMessage(playerid, "Please specify an amount above 1 dollar.");

	if (amount > 100 && PlayerData[playerid][pPlayingHours] < 2)
	    return SendErrorMessage(playerid, "You can't pay above $100 with less than 2 playing hours.");

	if (amount > GetMoney(playerid))
	    return SendErrorMessage(playerid, "You don't have that much money.");

	static
	    string[72];

	GiveMoney(playerid, -amount);
	GiveMoney(userid, amount);

	format(string, sizeof(string), "You have received ~g~%s~w~ from %s.", FormatNumber(amount), ReturnName(playerid, 0));
	ShowPlayerFooter(userid, string);

	format(string, sizeof(string), "You have given ~r~%s~w~ to %s.", FormatNumber(amount), ReturnName(userid, 0));
	ShowPlayerFooter(playerid, string);

	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out %s from their wallet and hands it to %s.", ReturnName(playerid, 0), FormatNumber(amount), ReturnName(userid, 0));
	Log_Write("logs/pay_log.txt", "[%s] %s (%s) has paid %s to %s (%s).", ReturnDate(), ReturnName(playerid, 0), PlayerData[playerid][pIP], FormatNumber(amount), ReturnName(userid, 0), PlayerData[userid][pIP]);
	return 1;
}

/*CMD:radio(playerid, params[])
{
	if (GetFactionType(playerid) != FACTION_POLICE && GetFactionType(playerid) != FACTION_MEDIC && GetFactionType(playerid) != FACTION_GOV)
	    return SendErrorMessage(playerid, "You must be a civil service worker.");

	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/(r)adio [radio text]");

	SendFactionMessage(PlayerData[playerid][pFaction], COLOR_RADIO, "[RADIO] %s %s: %s", Faction_GetRank(playerid), ReturnName(playerid, 0), params);
	SendNearbyMessage(playerid, 5.0, COLOR_WHITE, "[RADIO] %s: %s", ReturnName(playerid, 0), params);
	Log_Write("logs/faction_chat.txt", "[%s][Radio] %s %s: %s", ReturnDate(), Faction_GetRank(playerid), ReturnName(playerid, 0), params);
	return 1;
}*/

// ====== CMD:givecash ======
CMD:givecash(playerid, params[])
{
	static
		userid,
	    amount;

	if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "ud", userid, amount))
		return SendSyntaxMessage(playerid, "/givecash [playerid/name] [amount]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	GiveMoney(userid, amount);

	SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has given %s to %s.", ReturnName(playerid, 0), FormatNumber(amount), ReturnName(userid, 0));
 	Log_Write("logs/admin_log.txt", "[%s] %s has given %s to %s.", ReturnDate(), ReturnName(playerid, 0), FormatNumber(amount), ReturnName(userid, 0));

	return 1;
}

