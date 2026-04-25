/*
    File: modules/player/commands/player.pwn
    Purpose: Contains ZCMD command handlers for player player features.
    Notes: Keep command parsing here and delegate reusable gameplay work to logic files.
*/

// ====== CMD:next ======
CMD:next(playerid, params[])
	return CharacterSelection_Next(playerid);

// ====== CMD:prev ======
CMD:prev(playerid, params[])
	return CharacterSelection_Previous(playerid);

// ====== CMD:select ======
CMD:select(playerid, params[])
	return CharacterSelection_Select(playerid);

// ====== CMD:b ======
CMD:b(playerid, params[])
{
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/b [local OOC]");
	if (strlen(params) > 64)
	{
	    if(PlayerData[playerid][pAdminDuty] == 1)
	    {
	        SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "{33EE33}%s{FFFFFF} [%d]: (( %.64s", ReturnName(playerid, 0), playerid, params);
	    	SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "...%s ))", params[64]);
	        return 1;
		}
	    SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "%s [%d]: (( %.64s", ReturnName(playerid, 0), playerid, params);
	    SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "...%s ))", params[64]);
	}
	else
	{
	    if(PlayerData[playerid][pAdminDuty] == 1)
	    {
	        SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "{33EE33}%s{FFFFFF} [%d]: (( %s ))", ReturnName(playerid, 0), playerid, params);
			return 1;
		}
	    SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "%s [%d]: (( %s ))", ReturnName(playerid, 0), playerid, params);
	}
	//format(string, sizeof(string), "(( %s ))", params);
	//SetPlayerChatBubble(playerid, string, COLOR_WHITE, 10.0, 6000);
	return 1;
}


// ====== CMD:me ======
CMD:me(playerid, params[])
{

	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/me [action]");

	if (strlen(params) > 64) {
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s %.64s", ReturnName(playerid, 0), params);
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "...%s", params[64]);
	}
	else {
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s %s", ReturnName(playerid, 0), params);
	}
	//format(string, sizeof(string), "* %s %s", ReturnName(playerid, 0), params);
 	//SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 6000);
	return 1;
}


// ====== CMD:do ======
CMD:do(playerid, params[])
{
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/do [description]");

	if (strlen(params) > 64) {
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %.64s", params);
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "...%s (( %s ))", params[64], ReturnName(playerid, 0));
	}
	else {
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s (( %s ))", params, ReturnName(playerid, 0));
	}
	//format(string, sizeof(string), "* %s (( %s ))", params, ReturnName(playerid, 0));
 	//SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 6000);
	return 1;
}


// ====== CMD:ame ======
CMD:ame(playerid, params[])
{
	static
	    string[128];

	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/ame [action]");

	format(string, sizeof(string), "* %s %s", ReturnName(playerid, 0), params);
 	SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 10000);

 	SendClientMessageEx(playerid, COLOR_PURPLE, "* %s %s", ReturnName(playerid, 0), params);
	return 1;
}


// ====== CMD:ado ======
CMD:ado(playerid, params[])
{
    static
	    string[128];

	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/ado [description]");

	format(string, sizeof(string), "* %s (( %s ))", params, ReturnName(playerid, 0));
 	SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 10000);

 	SendClientMessageEx(playerid, COLOR_PURPLE, "* %s (( %s ))", params, ReturnName(playerid, 0));
	return 1;
}


// ====== CMD:s ======
CMD:s(playerid, params[])
{

	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/(s)hout [shout text]");

	if (strlen(params) > 64) {
	    SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "%s shouts: %.64s", ReturnName(playerid, 0), params);
	    SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "...%s!", params[64]);
	}
	else {
	    SendNearbyMessage(playerid, 30.0, COLOR_WHITE, "%s shouts: %s!", ReturnName(playerid, 0), params);
	}
 	//format(string, sizeof(string), "shouts: %s", params);
	//SetPlayerChatBubble(playerid, string, COLOR_WHITE, 30.0, 6000);
	return 1;
}


// ====== CMD:l ======
CMD:l(playerid, params[])
{


	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/(l)ow [low text]");

	if (strlen(params) > 64) {
	    SendNearbyMessage(playerid, 5.0, COLOR_WHITE, "[low] %s says: %.64s", ReturnName(playerid, 0), params);
	    SendNearbyMessage(playerid, 5.0, COLOR_WHITE, "...%s", params[64]);
	}
	else {
	    SendNearbyMessage(playerid, 5.0, COLOR_WHITE, "[low] %s says: %s", ReturnName(playerid, 0), params);
	}
 	//format(string, sizeof(string), "[low] says: %s", params);
	//SetPlayerChatBubble(playerid, string, COLOR_WHITE, 5.0, 6000);
	return 1;
}


// ====== CMD:kill ======
CMD:kill(playerid, params[])
{
	if (PlayerData[playerid][pHospital] != -1 || PlayerData[playerid][pCuffed] || PlayerData[playerid][pJailTime] > 0 || PlayerData[playerid][pDrivingTest])
	    return SendErrorMessage(playerid, "You can't kill yourself at the moment.");

	SetPlayerHealth(playerid, 0.0);
	return 1;
}


// ====== CMD:o ======
CMD:o(playerid, params[])
{
	if (g_StatusOOC && PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "An administrator has disabled global OOC chat.");

	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/o [global OOC]");

	if (PlayerData[playerid][pDisableOOC])
	    return SendErrorMessage(playerid, "You must enable OOC chat first.");

    if (strlen(params) > 64)
	{
        foreach (new i : Player) if (!PlayerData[i][pDisableOOC] && PlayerData[i][pCreated]) {
		    SendClientMessageEx(i, 0xAAC4E5FF, "(( [OOC] %s: %.64s", ReturnName(playerid, 0), params);
		    SendClientMessageEx(i, 0xAAC4E5FF, "...%s ))", params[64]);
		}
	}
	else
	{
        foreach (new i : Player) if (!PlayerData[i][pDisableOOC] && PlayerData[i][pCreated]) {
		    SendClientMessageEx(i, 0xAAC4E5FF, "(( [OOC] %s: %s ))", ReturnName(playerid, 0), params);
		}
	}
	return 1;
}


// ====== CMD:radio ======
CMD:radio(playerid, params[])
	return cmd_r(playerid, params);


// ====== CMD:ooc ======
CMD:ooc(playerid, params[])
	return cmd_o(playerid, params);


// ====== CMD:f ======
CMD:f(playerid, params[])
	return cmd_fac(playerid, params);


// ====== CMD:megaphone ======
CMD:megaphone(playerid, params[])
	return cmd_m(playerid, params);


// ====== CMD:shout ======
CMD:shout(playerid, params[])
	return cmd_s(playerid, params);


// ====== CMD:low ======
CMD:low(playerid, params[])
	return cmd_l(playerid, params);


// ====== CMD:w ======
CMD:w(playerid, params[])
	return cmd_whisper(playerid, params);



// ====== CMD:help ======
CMD:help(playerid, params[])
{
	SendClientMessage(playerid, COLOR_CLIENT, "ACCOUNT:{FFFFFF} /changepass, /lastlogged, /username, /properties.");
	SendClientMessage(playerid, COLOR_CLIENT, "GENERAL:{FFFFFF} /stats, /report, /seekhelp, /acc, /me, /do, /(s)hout, /(o)oc, /inventory, /switch.");
	SendClientMessage(playerid, COLOR_CLIENT, "GENERAL:{FFFFFF} /approve, /sell, /paint, /drink, /bank, /cook, /vest, /ammo, /usekit, /phone.");
	SendClientMessage(playerid, COLOR_CLIENT, "GENERAL:{FFFFFF} /id, /call, /hangup, /text, /drop, /flist, /crates, /fill, /pay, /gps, /open, /usedrug.");
	SendClientMessage(playerid, COLOR_CLIENT, "GENERAL:{FFFFFF} /animcmds, /backpack, /boombox, /channel, /jobcmds, /supporters, /disablecp, /stopanim.");
	SendClientMessage(playerid, COLOR_CLIENT, "GENERAL:{FFFFFF} /shakehand, /showlicense, /frisk, /toghud, /passwep, /setradio, /picklock, /resetvw.");
	SendClientMessage(playerid, COLOR_CLIENT, "PROPERTY:{FFFFFF} /buy, /abandon, /lock, /housecmds, /products, /vault, /binfo, /bizcmds.");

	if (PlayerData[playerid][pFactionMod])
	    SendClientMessage(playerid, COLOR_CLIENT, "FACTION:{FFFFFF} /createfaction, /editfaction, /destroyfaction.");

	if (PlayerData[playerid][pFaction] != -1)
	{
 		SendClientMessage(playerid, COLOR_CLIENT, "FACTION:{FFFFFF} /online, /(f)ac, /fquit, /flocker, /finvite, /fremove, /frank, /fspray.");

 		if (GetFactionType(playerid) == FACTION_POLICE) {
 		    SendClientMessage(playerid, COLOR_CLIENT, "FACTION:{FFFFFF} /tazer, /cuff, /uncuff, /drag, /detain, /mdc, /arrest, /radio, /dept, /seizeplant.");
 		    SendClientMessage(playerid, COLOR_CLIENT, "FACTION:{FFFFFF} /ticket, /spike, /roadblock, /fingerprint, /impound, /revokeweapon.");
 		    SendClientMessage(playerid, COLOR_CLIENT, "FACTION:{FFFFFF} /take, /kickdoor, /siren, /beanbag /callsign");
		}
		else if (GetFactionType(playerid) == FACTION_NEWS) {
		    SendClientMessage(playerid, COLOR_CLIENT, "FACTION:{FFFFFF} /radio, /broadcast, /bc, /inviteguest, /removeguest.");
		}
  		else if (GetFactionType(playerid) == FACTION_MEDIC) {
 		    SendClientMessage(playerid, COLOR_CLIENT, "FACTION:{FFFFFF} /radio, /dept, /bandage, /loadinjured, /dropinjured.");
		}
		else if (GetFactionType(playerid) == FACTION_GOV) {
 		    SendClientMessage(playerid, COLOR_CLIENT, "FACTION:{FFFFFF} /radio, /dept, /twithdraw, /tdeposit.");
		}
	}
	SendClientMessage(playerid, COLOR_CLIENT, "VEHICLE:{FFFFFF} /park, /lock, /abandon, /refuel, /unmod, /trunk, /listcars, /engine, /lights, /hood, /tow.");

    if (PlayerData[playerid][pTester] > 0)
	{
	    SendClientMessage(playerid, COLOR_CLIENT, "SUPPORTER:{FFFFFF} /t, /sduty, /ah, /dh, /kick");
	}
	if (PlayerData[playerid][pAdmin] > 0)
	{
	    SendClientMessage(playerid, COLOR_CLIENT, "ADMIN:{FFFFFF} /(a)dmin, /ahelp.");
	}
	return 1;
}


// ====== CMD:changepass ======
CMD:changepass(playerid, params[])
{
	Dialog_Show(playerid, ChangePassword, DIALOG_STYLE_PASSWORD, DialogStyle_Title("Change Password"), DialogStyle_Body("Please enter your existing password below:"), "Submit", "Cancel");
	return 1;
}


// ====== CMD:lastlogged ======
CMD:lastlogged(playerid, params[])
{
	if (isnull(params) || strlen(params) > 24)
	    return SendSyntaxMessage(playerid, "/lastlogged [username]");

	static
	    query[128];

	format(query, sizeof(query), "SELECT `LoginDate` FROM `accounts` WHERE `Username` = '%s'", SQL_ReturnEscaped(params));
	mysql_tquery(g_iHandle, query, "OnLoginDate", "ds", playerid, params);

 	return 1;
}


// ====== CMD:t ======
CMD:t(playerid, params[])
{
	if (!PlayerData[playerid][pTester] && !PlayerData[playerid][pAdmin])
	    return SendErrorMessage(playerid, "You are not a tester.");

	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/t [tester text]");

	if (strlen(params) > 64)
	{
	    if (PlayerData[playerid][pAdmin])
	    	SendTesterMessage(COLOR_LIGHTRED, "** Admin %s: %.64s", ReturnName(playerid, 0), params);

		else
			SendTesterMessage(COLOR_LIGHTRED, "** Tester %s: %.64s", ReturnName(playerid, 0), params);

		SendTesterMessage(COLOR_LIGHTRED, "...%s **", params[64]);
	}
	else
	{
	    if (PlayerData[playerid][pAdmin])
	        SendTesterMessage(COLOR_LIGHTRED, "** Admin %s: %s", ReturnName(playerid, 0), params);

	    else SendTesterMessage(COLOR_LIGHTRED, "** Tester %s: %s", ReturnName(playerid, 0), params);
	}
	return 1;
}


// ====== CMD:aduty ======
CMD:aduty(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (!PlayerData[playerid][pAdminDuty])
	{
		SetPlayerColor(playerid, 0x33CC3300);

		PlayerData[playerid][pAdminDuty] = 1;
		SendClientMessageToAllEx(COLOR_GREEN, "** %s is now on duty as an admin (/report for assistance).", ReturnName(playerid, 0));
	}
	else
	{
	    SetPlayerColor(playerid, DEFAULT_COLOR);

		PlayerData[playerid][pAdminDuty] = 0;
		SendServerMessage(playerid, "You are no longer on admin duty.");
	}
	return 1;
}


// ====== CMD:bleeding ======
CMD:bleeding(playerid, params[])
{
	static
	    userid;

    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/bleeding [playerid/name]");

    if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	switch (PlayerData[userid][pBleeding])
	{
	    case 0:
	    {
	        PlayerData[userid][pBleeding] = 1;
	        PlayerData[userid][pBleedTime] = 10;

            CreateBlood(userid);
			SetTimerEx("HidePlayerBox", 500, false, "dd", userid, _:ShowPlayerBox(userid, 0xFF000066));

			SendServerMessage(playerid, "You have enabled bleeding mode for %s.", ReturnName(userid, 0));
		}
		case 1:
	    {
	        PlayerData[userid][pBleeding] = 0;
	        PlayerData[userid][pBleedTime] = 0;

			SendServerMessage(playerid, "You have disabled bleeding mode for %s.", ReturnName(userid, 0));
		}
	}
	return 1;
}


// ====== CMD:stats ======
CMD:stats(playerid, params[])
{
	ShowStatsForPlayer(playerid, playerid);
	return 1;
}


// ====== CMD:usekit ======
CMD:usekit(playerid, params[])
{
	if (PlayerData[playerid][pHospital] != -1 || PlayerData[playerid][pCuffed] || PlayerData[playerid][pInjured] || !IsPlayerSpawned(playerid))
	    return SendErrorMessage(playerid, "You can't use this command now.");

	if (PlayerData[playerid][pFirstAid])
	    return SendErrorMessage(playerid, "You are already using a first aid kit.");

	if (!Inventory_HasItem(playerid, "First Aid"))
	    return SendErrorMessage(playerid, "You don't have any first aid kits on you.");

	if (ReturnHealth(playerid) > 99)
	    return SendErrorMessage(playerid, "You don't need to use a first aid kit right now.");

	if (!IsPlayerInAnyVehicle(playerid))
	    ApplyAnimation(playerid, "SWAT", "gnstwall_injurd", 4.0, 1, 0, 0, 0, 0);

    PlayerData[playerid][pFirstAid] = true;
    PlayerData[playerid][pAidTimer] = SetTimerEx("FirstAidUpdate", 1000, true, "d", playerid);

    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s opens a first aid kit and uses it.", ReturnName(playerid, 0));
    Inventory_Remove(playerid, "First Aid");

    ShowPlayerFooter(playerid, "You have used a ~g~first aid kit!");
    return 1;
}


// ====== CMD:paint ======
CMD:paint(playerid, params[])
{
	if (PlayerData[playerid][pCuffed])
	    return SendErrorMessage(playerid, "You can't use this command at the moment.");

	new vehicleid = GetNearestVehicle(playerid);

	if (vehicleid == INVALID_VEHICLE_ID)
	    return SendErrorMessage(playerid, "You are not standing near any vehicle.");

	if (!Inventory_HasItem(playerid, "Spray Can"))
	    return SendErrorMessage(playerid, "You don't have any cans of spray paint.");

	if (IsPlayerInAnyVehicle(playerid))
	    return SendErrorMessage(playerid, "You must exit the vehicle first.");

	static
 		colors[256];

	for (new i = 0; i < sizeof(colors); i ++) {
		colors[i] = i;
   	}
   	ShowColorSelectionMenu(playerid, MODEL_SELECTION_COLOR, colors);
	return 1;
}


// ====== CMD:online ======
CMD:online(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];

 	if (factionid == -1)
	    return SendErrorMessage(playerid, "You must be a faction member.");

	SendClientMessage(playerid, COLOR_SERVER, "Online Members:");

	foreach (new i : Player) if (PlayerData[i][pFaction] == factionid) {
		SendClientMessageEx(playerid, COLOR_WHITE, "[ID: %d] %s - %s (%d)", i, ReturnName(i, 0), Faction_GetRank(i), PlayerData[i][pFactionRank]);
	}
	return 1;
}


// ====== CMD:gps ======
CMD:gps(playerid, params[])
{
	if (!Inventory_HasItem(playerid, "GPS System"))
	    return SendErrorMessage(playerid, "You must have a GPS system to use this.");

	if (PlayerData[playerid][pInjured] || PlayerData[playerid][pLoading] > 0 || PlayerData[playerid][pUnloading] != -1 || PlayerData[playerid][pDeliverShipment] > 0)
	    return SendErrorMessage(playerid, "You can't use this command at the moment.");

	Dialog_Show(playerid, MainGPS, DIALOG_STYLE_LIST, DialogStyle_Title("GPS System"), DialogStyle_Body("Find House\nFind Business\nFind Entrance\nFind Job\nCustom Locations"), "Select", "Cancel");
	return 1;
}


// ====== CMD:fill ======
CMD:fill(playerid, params[])
{
	new vehicleid = GetNearestVehicle(playerid);

	if (IsPlayerInAnyVehicle(playerid) || vehicleid == INVALID_VEHICLE_ID)
	    return SendErrorMessage(playerid, "You are not standing near any vehicle.");

	if (!Inventory_HasItem(playerid, "Fuel Can"))
	    return SendErrorMessage(playerid, "You don't have any fuel cans on you.");

	if (GetEngineStatus(vehicleid))
	    return SendErrorMessage(playerid, "You must shut off the engine first.");

	if (CoreVehicles[vehicleid][vehFuel] > 95)
	    return SendErrorMessage(playerid, "This vehicle doesn't need any fuel.");

	if (PlayerData[playerid][pFuelCan])
	    return SendErrorMessage(playerid, "You are already using a can of fuel.");

    PlayerData[playerid][pFuelCan] = 1;

	Inventory_Remove(playerid, "Fuel Can");
	GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Filling vehicle...", 5200, 3);

	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s opens a can of fuel and fills the vehicle.", ReturnName(playerid, 0));
	SetTimerEx("RefillUpdate", 5000, false, "dd", playerid, vehicleid);

	return 1;
}


// ====== CMD:seekhelp ======
CMD:seekhelp(playerid, params[])
{
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/seekhelp [reason]");

    if (PlayerData[playerid][pHelpTime] >= gettime())
	    return SendErrorMessage(playerid, "You must wait %d seconds before sending another request.", PlayerData[playerid][pHelpTime] - gettime());

	PlayerData[playerid][pSeekHelp] = 1;
	SendTesterMessage(COLOR_CYAN, "[HELP]: %s (ID: %d) asks: \"%s\"", ReturnName(playerid, 0), playerid, params);

	PlayerData[playerid][pHelpTime] = gettime() + 15;
	SendServerMessage(playerid, "You have sent a help request to the tester team.");
	return 1;
}


// ====== CMD:pm ======
CMD:pm(playerid, params[])
{
	static
	    userid,
	    text[128];

	if (sscanf(params, "us[128]", userid, text))
	    return SendSyntaxMessage(playerid, "/pm [playerid/name] [message]");

	if (PlayerData[playerid][pDisablePM])
		return SendErrorMessage(playerid, "You must enable private messaging first.");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	if (userid == playerid)
	    return SendErrorMessage(playerid, "You can't private message yourself.");

	if (PlayerData[userid][pDisablePM])
	    return SendErrorMessage(playerid, "That player has disabled private messaging.");

	GameTextForPlayer(userid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~New message!", 3000, 3);
	PlayerPlaySound(userid, 1085, 0.0, 0.0, 0.0);

	SendClientMessageEx(userid, COLOR_YELLOW, "(( PM from %s (%d): %s ))", ReturnName(playerid, 0), playerid, text);
	SendClientMessageEx(playerid, COLOR_YELLOW, "(( PM to %s (%d): %s ))", ReturnName(userid, 0), userid, text);
	return 1;
}


// ====== CMD:tog ======
CMD:tog(playerid, params[])
{
	if (isnull(params))
	{
	    SendSyntaxMessage(playerid, "/tog [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} ooc, pm, faction, tester, broadcast, speedo");
	    return 1;
	}
	if (!strcmp(params, "ooc", true))
	{
	    if (!PlayerData[playerid][pDisableOOC])
	    {
	        PlayerData[playerid][pDisableOOC] = 1;
         	SendServerMessage(playerid, "You have disabled OOC chat (/tog to enable).");
		}
		else
		{
  			PlayerData[playerid][pDisableOOC] = 0;
  			SendServerMessage(playerid, "You have enabled OOC chat.");
		}
	}
	else if (!strcmp(params, "pm", true))
	{
	    if (!PlayerData[playerid][pDisablePM])
	    {
			PlayerData[playerid][pDisablePM] = 1;
   			SendServerMessage(playerid, "You have disabled private messages (/tog to enable).");
		}
		else
		{
  			PlayerData[playerid][pDisablePM] = 0;
     		SendServerMessage(playerid, "You have enabled private messages.");
		}
	}
	else if (!strcmp(params, "faction", true))
	{
	    if (PlayerData[playerid][pFaction] == -1)
	        return SendErrorMessage(playerid, "You are not part of any faction.");

	    if (!PlayerData[playerid][pDisableFaction])
	    {
	        PlayerData[playerid][pDisableFaction] = 1;
			SendServerMessage(playerid, "You have disabled faction chat (/tog to enable).");
		}
		else
		{
  			PlayerData[playerid][pDisableFaction] = 0;
     		SendServerMessage(playerid, "You have enabled faction chat.");
		}
	}
	else if (!strcmp(params, "tester", true))
	{
	    if (!PlayerData[playerid][pTester])
	        return SendErrorMessage(playerid, "You are not a tester.");

	    if (!PlayerData[playerid][pDisableTester])
	    {
	        PlayerData[playerid][pDisableTester] = 1;
			SendServerMessage(playerid, "You have disabled tester chat (/tog to enable).");
		}
		else
		{
  			PlayerData[playerid][pDisableTester] = 0;
     		SendServerMessage(playerid, "You have enabled tester chat.");
		}
	}
	else if (!strcmp(params, "broadcast", true))
	{
	    if (!PlayerData[playerid][pDisableBC])
	    {
	        PlayerData[playerid][pDisableBC] = 1;
			SendServerMessage(playerid, "You have disabled news broadcasts (/tog to enable).");
		}
		else
		{
  			PlayerData[playerid][pDisableBC] = 0;
     		SendServerMessage(playerid, "You have enabled news broadcasts.");
		}
	}
	else if (!strcmp(params, "speedo", true))
	{
	    if (!PlayerData[playerid][pDisableSpeedo])
	    {
	        for (new i = 34; i < 39; i ++) {
				PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
	    	}
	        PlayerData[playerid][pDisableSpeedo] = 1;
			SendServerMessage(playerid, "You have disabled the speedometer (/tog to enable).");
		}
		else
		{
		    if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsSpeedoVehicle(GetPlayerVehicleID(playerid)))
		    {
		        for (new i = 34; i < 39; i ++) {
					PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][i]);
	    		}
		    }
  			PlayerData[playerid][pDisableSpeedo] = 0;
     		SendServerMessage(playerid, "You have enabled the speedometer.");
		}
	}
	return 1;
}


// ====== CMD:changename ======
CMD:changename(playerid, params[])
{
	if (!IsPlayerInRangeOfPoint(playerid, 3.0, 361.8299, 173.5183, 1008.3828))
	    return SendErrorMessage(playerid, "You are not in range of city hall.");

	if (isnull(params) || strlen(params) > 24)
	    return SendSyntaxMessage(playerid, "/changename [new name]");

    if (!IsValidPlayerName(params))
	    return SendErrorMessage(playerid, "You have specified an invalid name format.");

	static
	    query[128];

	format(query, sizeof(query), "SELECT `Username` FROM `characters` WHERE `Character` = '%s'", SQL_ReturnEscaped(params));
	mysql_tquery(g_iHandle, query, "OnVerifyNameChange", "ds", playerid, params);

	return 1;
}


// ====== CMD:acceptname ======
CMD:acceptname(playerid, params[])
{
	static
	    userid;

	if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "You are not permitted to use this command.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/acceptname [playerid/name]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	if (!strlen(PlayerData[userid][pNameChange]))
	    return SendErrorMessage(playerid, "That player hasn't requested to change their name yet.");

	SendServerMessage(playerid, "You have accepted %s's name change to %s.", ReturnName(userid, 0), PlayerData[userid][pNameChange]);
    SendServerMessage(userid, "%s has accepted your name change to %s.", ReturnName(playerid, 0), PlayerData[userid][pNameChange]);

	ChangeName(userid, PlayerData[userid][pNameChange]);
	PlayerData[userid][pNameChange][0] = '\0';

	return 1;
}


// ====== CMD:declinename ======
CMD:declinename(playerid, params[])
{
	static
	    userid;

	if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "You are not permitted to use this command.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/declinename [playerid/name]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	if (!strlen(PlayerData[userid][pNameChange]))
	    return SendErrorMessage(playerid, "That player hasn't requested to change their name yet.");

	SendServerMessage(playerid, "You have declined %s's name change to %s.", ReturnName(userid, 0), PlayerData[userid][pNameChange]);
    SendServerMessage(userid, "%s has declined your name change to %s.", ReturnName(playerid, 0), PlayerData[userid][pNameChange]);

	PlayerData[userid][pNameChange][0] = '\0';

	return 1;
}


// ====== CMD:deleteaccount ======
CMD:deleteaccount(playerid, params[])
{
	static
	    query[64];

    if (PlayerData[playerid][pAdmin] < 6)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (isnull(params) || strlen(params) > 24)
	    return SendSyntaxMessage(playerid, "/deleteaccount [username]");

    if (!IsValidPlayerName(params))
	    return SendErrorMessage(playerid, "You have specified an invalid name format.");

	foreach (new i : Player) if (!strcmp(PlayerData[i][pUsername], params, true)) {
	    return SendErrorMessage(playerid, "You can't delete an online player's account.");
	}
	format(query, sizeof(query), "SELECT * FROM `characters` WHERE `Username` = '%s'", SQL_ReturnEscaped(params));
	mysql_tquery(g_iHandle, query, "OnDeleteAccount", "ds", playerid, params);

	return 1;
}


// ====== CMD:usedrug ======
CMD:usedrug(playerid, params[])
{
	if (isnull(params))
	{
	    SendSyntaxMessage(playerid, "/usedrug [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} marijuana, cocaine, heroin, steroids");
		return 1;
	}
	if (PlayerData[playerid][pDrugTime] > 0)
	    return SendErrorMessage(playerid, "Please wait until the effects have subsided first.");

	if (!strcmp(params, "marijuana", true))
	{
	    if (Inventory_Count(playerid, "Marijuana") < 2)
	        return SendErrorMessage(playerid, "You need at least 2 grams of marijuana.");

        PlayerData[playerid][pDrugTime] = 20;
		PlayerData[playerid][pDrugUsed] = 1;

		Inventory_Remove(playerid, "Marijuana", 2);
		ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 0, 1);

		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out a lighter and lights up a joint.", ReturnName(playerid, 0));
	}
	else if (!strcmp(params, "cocaine", true))
	{
	    if (Inventory_Count(playerid, "Cocaine") < 2)
	        return SendErrorMessage(playerid, "You need at least 2 grams of cocaine.");

        PlayerData[playerid][pDrugTime] = 35;
		PlayerData[playerid][pDrugUsed] = 2;

		Inventory_Remove(playerid, "Cocaine", 2);

		ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 0, 1);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out some cocaine and snorts it.", ReturnName(playerid, 0));
	}
	else if (!strcmp(params, "heroin", true))
	{
	    if (Inventory_Count(playerid, "Heroin") < 2)
	        return SendErrorMessage(playerid, "You need at least 2 grams of heroin.");

        PlayerData[playerid][pDrugTime] = 30;
		PlayerData[playerid][pDrugUsed] = 3;

		Inventory_Remove(playerid, "Heroin", 2);

		ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 0, 1);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out some heroin and injects it.", ReturnName(playerid, 0));
	}
	else if (!strcmp(params, "steroids", true))
	{
	    if (!Inventory_HasItem(playerid, "Steroids"))
	        return SendErrorMessage(playerid, "You need at least one steroid pill.");

		if (ReturnHealth(playerid) <= 5)
		    return SendErrorMessage(playerid, "Your health is too low to take steroids.");

        PlayerData[playerid][pDrugTime] = 60;
		PlayerData[playerid][pDrugUsed] = 4;

		SetPlayerHealth(playerid, ReturnHealth(playerid) - 5);
		Inventory_Remove(playerid, "Steroids", 2);

		ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.1, 0, 0, 0, 0, 0, 1);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out some steroids and swallows them.", ReturnName(playerid, 0));
	}
	return 1;
}


// ====== CMD:admins ======
CMD:admins(playerid, params[])
{
	new count = 0;

    SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");

    foreach (new i : Player) if (PlayerData[i][pAdmin] > 0 && PlayerData[i][pAdminHide] < 1)
	{
        if (PlayerData[i][pAdminDuty])
			SendClientMessageEx(playerid, COLOR_WHITE, "* %s {33CC33}(Level: %d) {33CC33}(On Duty)", ReturnName(i, 0), PlayerData[i][pAdmin]);

		else
		    SendClientMessageEx(playerid, COLOR_WHITE, "* %s {33CC33}(Level: %d) {FF6347}(Off Duty)", ReturnName(i, 0), PlayerData[i][pAdmin]);

        count++;
	}
	if (!count) {
	    SendClientMessage(playerid, COLOR_WHITE, "* No admins online.");
	}
	SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
	return 1;
}


// ====== CMD:supporters ======
CMD:supporters(playerid, params[])
{
	new count = 0;

    SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");

    foreach (new i : Player) if (PlayerData[i][pTester] > 0)
	{
        if (PlayerData[i][pTesterDuty])
			SendClientMessageEx(playerid, COLOR_WHITE, "* %s {33CC33}(On Duty)", ReturnName(i, 0));

		else SendClientMessageEx(playerid, COLOR_WHITE, "* %s {FF6347}(Off Duty)", ReturnName(i, 0));

        count++;
	}
	if (!count) {
	    SendClientMessage(playerid, COLOR_WHITE, "* No supporters online.");
	}
	SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
	return 1;
}


// ====== CMD:deletechar ======
CMD:deletechar(playerid, params[])
{
	static
	    query[128];

    if (PlayerData[playerid][pAdmin] < 6)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (isnull(params) || strlen(params) > 24)
	    return SendSyntaxMessage(playerid, "/deletechar [character name]");

    if (!IsValidPlayerName(params))
	    return SendErrorMessage(playerid, "You have specified an invalid name format.");

	format(query, sizeof(query), "SELECT `ID`, `Admin` FROM `characters` WHERE `Character` = '%s'", SQL_ReturnEscaped(params));
	mysql_tquery(g_iHandle, query, "OnDeleteCharacter", "ds", playerid, params);

	return 1;
}


// ====== CMD:tasks ======
CMD:tasks(playerid, params[])
{
	if (!IsTaskActive(playerid))
	    return 1;

	new
	    string[128];

	if (!PlayerData[playerid][pBankTask])
		strcat(string, "Visit Bank (pending)\n");

	if (!PlayerData[playerid][pStoreTask])
	    strcat(string, "Visit Store (pending)\n");

	if (!PlayerData[playerid][pTestTask])
	    strcat(string, "Visit DMV (pending)\n");

	Dialog_Show(playerid, NewTasks, DIALOG_STYLE_LIST, DialogStyle_Title("Task List"), string, "Select", "Cancel");
	return 1;
}


// ====== CMD:warnings ======
CMD:warnings(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
    SendClientMessageEx(playerid, COLOR_LIGHTRED, "Warnings (%d/3)", PlayerData[playerid][pWarnings]);

    if (PlayerData[playerid][pWarnings] >= 1 && strlen(PlayerData[playerid][pWarn1]))
        SendClientMessageEx(playerid, COLOR_WHITE, "* 1st Warning: \"%s\"", PlayerData[playerid][pWarn1]);

    if (PlayerData[playerid][pWarnings] >= 2 && strlen(PlayerData[playerid][pWarn2]))
        SendClientMessageEx(playerid, COLOR_WHITE, "* 2nd Warning: \"%s\"", PlayerData[playerid][pWarn2]);

    SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
	return 1;
}


// ====== CMD:listwarns ======
CMD:listwarns(playerid, params[])
{
	static
	    userid;

    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/listwarns [playerid/name]");

    if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

    SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
    SendClientMessageEx(playerid, COLOR_LIGHTRED, "%s's Warnings (%d/3)", ReturnName(userid, 0), PlayerData[userid][pWarnings]);

    if (PlayerData[userid][pWarnings] >= 1 && strlen(PlayerData[userid][pWarn1]))
        SendClientMessageEx(playerid, COLOR_WHITE, "* 1st Warning: \"%s\"", PlayerData[userid][pWarn1]);

    if (PlayerData[userid][pWarnings] >= 2 && strlen(PlayerData[userid][pWarn2]))
        SendClientMessageEx(playerid, COLOR_WHITE, "* 2nd Warning: \"%s\"", PlayerData[userid][pWarn2]);

    SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
	return 1;
}


// ====== CMD:warn ======
CMD:warn(playerid, params[])
{
	static
	    userid,
		reason[32];

    if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "us[32]", userid, reason))
	    return SendSyntaxMessage(playerid, "/warn [playerid/name] [reason]");

    if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	if (PlayerData[userid][pAdmin] > PlayerData[playerid][pAdmin])
	    return SendErrorMessage(playerid, "The specified player has higher authority.");

	switch (++ PlayerData[userid][pWarnings])
	{
	    case 1:
	    {
	        format(PlayerData[userid][pWarn1], 32, reason);

	        SendAdminAction(userid, "%s has warned you for \"%s\" (first warning).", ReturnName(playerid, 0), reason);
	        SendAdminAction(playerid, "You have warned %s for \"%s\" (first warning).", ReturnName(userid, 0), reason);
		}
		case 2:
	    {
	        format(PlayerData[userid][pWarn2], 32, reason);

	        SendAdminAction(userid, "%s has warned you for \"%s\" (second warning).", ReturnName(playerid, 0), reason);
	        SendAdminAction(playerid, "You have warned %s for \"%s\" (second warning).", ReturnName(userid, 0), reason);
		}
		default:
	    {
	        ResetWarnings(userid);

	        SendAdminAction(userid, "You've been banned for exceeding your warnings (\"%s\").", reason);
	        SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s was banned for 3 warnings by %s, reason: %s", ReturnName(userid, 0), ReturnName(playerid, 0), reason);

			Blacklist_Add(PlayerData[userid][pIP], PlayerData[userid][pUsername], PlayerData[playerid][pUsername], reason);
			KickEx(userid);
		}
	}
	Log_Write("logs/warn_log.txt", "[%s] %s has warned %s for %s.", ReturnDate(), ReturnName(playerid, 0), ReturnName(userid, 0), reason);
	return 1;
}


// ====== CMD:clearwarns ======
CMD:clearwarns(playerid, params[])
{
	static
	    userid;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/clearwarns [playerid/name]");

    if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	ResetWarnings(userid);

	SendAdminAction(playerid, "You have cleared %s's warnings.", ReturnName(userid, 0));
	SendAdminAction(userid, "%s has cleared your warnings.", ReturnName(playerid, 0));

	SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has cleared %s's warnings.", ReturnName(playerid, 0), ReturnName(userid, 0));
	return 1;
}


// ====== CMD:passwep ======
CMD:passwep(playerid, params[])
{
	new
	    weaponid = GetWeapon(playerid),
	    ammo = GetPlayerAmmo(playerid),
		userid;

	if (!weaponid)
	    return SendErrorMessage(playerid, "You are not holding any weapon to pass.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/passwep [playerid/name]");

	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "That player is disconnected or not near you.");

	if (userid == playerid)
		return SendErrorMessage(playerid, "You can't give yourself a weapon.");

	if (PlayerData[userid][pGuns][g_aWeaponSlots[weaponid]] != 0)
	    return SendErrorMessage(playerid, "That player has a weapon in the same slot already.");

	ResetWeapon(playerid, weaponid);
	GiveWeaponToPlayer(userid, weaponid, ammo);

	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has passed their %s to %s.", ReturnName(playerid, 0), ReturnWeaponName(weaponid), ReturnName(userid, 0));
	Log_Write("logs/give_log.txt", "[%s] %s (%s) has given a %s with %d ammo to %s (%s).", ReturnDate(), ReturnName(playerid, 0), PlayerData[playerid][pIP], ReturnWeaponName(weaponid), ammo, ReturnName(userid, 0), PlayerData[userid][pIP]);
	return 1;
}


// ====== CMD:whisper ======
CMD:whisper(playerid, params[])
{
	new userid, text[128];

    if (sscanf(params, "us[128]", userid, text))
	    return SendSyntaxMessage(playerid, "/(w)hisper [playerid/name] [text]");

	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "That player is disconnected or not near you.");

	if (userid == playerid)
		return SendErrorMessage(playerid, "You can't whisper yourself.");

    if (strlen(text) > 64) {
	    SendClientMessageEx(userid, COLOR_YELLOW, "** Whisper from %s (%d): %.64s", ReturnName(playerid, 0), playerid, text);
	    SendClientMessageEx(userid, COLOR_YELLOW, "...%s **", text[64]);

	    SendClientMessageEx(playerid, COLOR_YELLOW, "** Whisper to %s (%d): %.64s", ReturnName(userid, 0), userid, text);
	    SendClientMessageEx(playerid, COLOR_YELLOW, "...%s **", text[64]);
	}
	else {
	    SendClientMessageEx(userid, COLOR_YELLOW, "** Whisper from %s (%d): %s **", ReturnName(playerid, 0), playerid, text);
	    SendClientMessageEx(playerid, COLOR_YELLOW, "** Whisper to %s (%d): %s **", ReturnName(userid, 0), userid, text);
	}
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s mutters something in %s's ear.", ReturnName(playerid, 0), ReturnName(userid, 0));
	return 1;
}


// ====== CMD:resetvw ======
CMD:resetvw(playerid, params[])
{
	if (GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) > 0)
	{
	    SetPlayerVirtualWorld(playerid, 0);
	    SendServerMessage(playerid, "You have fixed your virtual world.");
	}
	else SendErrorMessage(playerid, "Your virtual world is not bugged right now.");
	return 1;
}


// ====== CMD:call ======
CMD:call(playerid, params[])
{
    if (!Inventory_HasItem(playerid, "Cellphone"))
	    return SendErrorMessage(playerid, "You don't have a cellphone on you.");

    if (PlayerData[playerid][pPhoneOff])
		return SendErrorMessage(playerid, "Your phone must be powered on.");

    if (PlayerData[playerid][pHospital] != -1 || PlayerData[playerid][pCuffed] || PlayerData[playerid][pInjured] || !IsPlayerSpawned(playerid))
	    return SendErrorMessage(playerid, "You can't use this command now.");

	static
	    targetid,
		number;

	if (sscanf(params, "d", number))
 	   return SendSyntaxMessage(playerid, "/call [phone number] (1222 for taxi, 911 for emergency, 222 for news, 223 for billboards)");

	if (!number)
	    return SendErrorMessage(playerid, "The specified phone number is not in service.");

	if (number == 911)
	{
		PlayerData[playerid][pEmergency] = 1;
		PlayerPlaySound(playerid, 3600, 0.0, 0.0, 0.0);

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out their cellphone and places a call.", ReturnName(playerid, 0));
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "[OPERATOR]:{FFFFFF} Which service do you require: \"police\" or \"medics\"?");
	}
	else if (number == 1222)
	{
	    PlayerData[playerid][pTaxiCalled] = 1;
	    PlayerPlaySound(playerid, 3600, 0.0, 0.0, 0.0);

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out their cellphone and places a call.", ReturnName(playerid, 0));
		SendClientMessage(playerid, COLOR_YELLOW, "[OPERATOR]:{FFFFFF} The taxi department has been notified of your call.");

        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has hung up their cellphone.", ReturnName(playerid, 0));
		SendJobMessage(3, COLOR_YELLOW, "** %s is requesting a taxi at %s (use /acceptcall to accept).", ReturnName(playerid, 0), GetPlayerLocation(playerid));
	}
	else if (number == 222)
	{
	    PlayerData[playerid][pPlaceAd] = 1;
	    PlayerPlaySound(playerid, 3600, 0.0, 0.0, 0.0);

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out their cellphone and places a call.", ReturnName(playerid, 0));

		if (PlayerData[playerid][pPlayingHours] < 4) {
            SendClientMessage(playerid, COLOR_CYAN, "[OPERATOR]:{FFFFFF} Sorry, you must play 4 hours to place an advertisement.");
		    cmd_hangup(playerid, "\1");
		}
		else if (PlayerData[playerid][pAdTime] < 1) {
			SendClientMessage(playerid, COLOR_CYAN, "[OPERATOR]:{FFFFFF} Please say \"yes\" if you wish to advertise for $500.");
		}
		else {
		    SendClientMessage(playerid, COLOR_CYAN, "[OPERATOR]:{FFFFFF} You've already advertised in the last 2 minutes. Please try again later.");
		    cmd_hangup(playerid, "\1");
		}
	}
	else if (number == 223)
	{
	    PlayerPlaySound(playerid, 3600, 0.0, 0.0, 0.0);

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out their cellphone and places a call.", ReturnName(playerid, 0));

		if (PlayerData[playerid][pPlayingHours] < 4) {
            SendClientMessage(playerid, COLOR_CYAN, "[OPERATOR]:{FFFFFF} Sorry, you must play 4 hours to rent a billboard.");
		    cmd_hangup(playerid, "\1");
		}
		SendClientMessageEx(playerid, COLOR_YELLOW, "[PHONE]:{FFFFFF} Hello, this is the Los Santos Billboard Agency, please listen to the following choices!");
		ViewBillboards(playerid);
	}
	else if ((targetid = GetNumberOwner(number)) != INVALID_PLAYER_ID)
	{
	    if (targetid == playerid)
	        return SendErrorMessage(playerid, "You can't call yourself!");

		if (PlayerData[targetid][pPhoneOff])
		    return SendErrorMessage(playerid, "The recipient has their cellphone powered off.");

		PlayerData[targetid][pIncomingCall] = 1;
		PlayerData[playerid][pIncomingCall] = 1;

		PlayerData[targetid][pCallLine] = playerid;
		PlayerData[playerid][pCallLine] = targetid;

		SendClientMessageEx(playerid, COLOR_YELLOW, "[PHONE]:{FFFFFF} Attempting to dial #%d, please wait for an answer...", number);
		SendClientMessageEx(targetid, COLOR_YELLOW, "[PHONE]:{FFFFFF} Incoming call from #%d (type \"/answer\" to answer the phone).", PlayerData[playerid][pPhone]);

        PlayerPlaySound(playerid, 3600, 0.0, 0.0, 0.0);
        PlayerPlaySoundEx(targetid, 23000);

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out their cellphone and places a call.", ReturnName(playerid, 0));
	}
	else
	{
	    SendErrorMessage(playerid, "The specified phone number is not in service.");
	}
	return 1;
}
