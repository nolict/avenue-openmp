/*
    File: modules/core/commands/administration.pwn
    Purpose: Contains ZCMD command handlers for core administration features.
    Notes: Keep command parsing here and delegate reusable gameplay work to logic files.
*/

// ====== CMD:x ======
CMD:x(playerid, params[])
{
	new Float:x, Float:y, Float:z, Float:npos;
	if(PlayerData[playerid][pAdmin] >= 2)
	{
		if(sscanf(params, "f", npos)) return SendClientMessage(playerid, COLOR_LIGHTRED, "USAGE: /x [Cordinate]");
		GetPlayerPos(playerid, x, y, z);
		SetPlayerPos(playerid, x+npos, y, z);
		return 1;
	}
	else return SendErrorMessage(playerid, "You're not authorized.");
}

// ====== CMD:y ======
COMMAND:y(playerid, params[])
{
	new Float:x, Float:y, Float:z, Float:npos;
	if(PlayerData[playerid][pAdmin] >= 2)
	{
		if(sscanf(params, "f", npos)) return SendClientMessage(playerid, COLOR_LIGHTRED, "USAGE: /y [Cordinate]");
		GetPlayerPos(playerid, x, y, z);
		SetPlayerPos(playerid, x, y+npos, z);
		return 1;
	}
	else return SendErrorMessage(playerid, "You're not authorized.");
}

// ====== CMD:z ======
COMMAND:z(playerid, params[])
{
	new Float:x, Float:y, Float:z, Float:npos;
	if(PlayerData[playerid][pAdmin] >= 2)
	{
		if(sscanf(params, "f", npos)) return SendClientMessage(playerid, COLOR_LIGHTRED, "USAGE: /z [Cordinate]");
		GetPlayerPos(playerid, x, y, z);
		SetPlayerPos(playerid, x, y, z+npos);
		return 1;
	}
	else return SendErrorMessage(playerid, "You're not authorized.");
}
//

// ====== CMD:admin ======
CMD:admin(playerid, params[])
	return cmd_a(playerid, params);


// ====== CMD:makeadmin ======
CMD:makeadmin(playerid, params[])
{
	static
		userid,
	    level;

	if (PlayerData[playerid][pAdmin] < 6)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "ud", userid, level))
		return SendSyntaxMessage(playerid, "/makeadmin [playerid/name] [level]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	if (level < 0 || level > 6)
	    return SendErrorMessage(playerid, "Invalid admin level. Levels range from 0 to 6.");

	if (level > PlayerData[userid][pAdmin])
	{
	    SendAdminAction(playerid, "You have promoted %s to a higher admin level (%d).", ReturnName(userid, 0), level);
	    SendAdminAction(userid, "%s has promoted you to a higher admin level (%d).", ReturnName(playerid, 0), level);
	}
	else
	{
	    SendAdminAction(playerid, "You have demoted %s to a lower admin level (%d).", ReturnName(userid, 0), level);
	    SendAdminAction(userid, "%s has demoted you to a lower admin level (%d).", ReturnName(playerid, 0), level);
	}
	PlayerData[userid][pAdmin] = level;
 	Log_Write("logs/admin_log.txt", "[%s] %s has set %s's admin level to %d.", ReturnDate(), ReturnName(playerid, 0), ReturnName(userid, 0), level);

	return 1;
}


// ====== CMD:a ======
CMD:a(playerid, params[])
{
	if (!PlayerData[playerid][pAdmin])
	    return SendErrorMessage(playerid, "You are not an administrator.");

	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/a [admin text]");

	if (strlen(params) > 64) {
	    SendAdminAlert(COLOR_ADMINCHAT, "** %d Admin %s: %.64s", PlayerData[playerid][pAdmin], ReturnName(playerid, 0), params);
	    SendAdminAlert(COLOR_ADMINCHAT, "...%s **", params[64]);
	}
	else {
	    SendAdminAlert(COLOR_ADMINCHAT, "** %d Admin %s: %s **", PlayerData[playerid][pAdmin], ReturnName(playerid, 0), params);
	}
	return 1;
}


// ====== CMD:ahelp ======
CMD:ahelp(playerid, params[])
{
	if (!PlayerData[playerid][pAdmin])
	    return SendErrorMessage(playerid, "You are not an administrator.");

	if (PlayerData[playerid][pAdmin] >= 1) {
	    SendClientMessage(playerid, COLOR_YELLOW, "[LEVEL 1]:{FFFFFF} /a, /reports, /spectate, /ajail, /release, /kick, /mute, /unmute, /freeze, /unfreeze.");
	    SendClientMessage(playerid, COLOR_YELLOW, "[LEVEL 1]:{FFFFFF} /aduty, /ban, /skin /goto /aremovecall");
	}
	if (PlayerData[playerid][pAdmin] >= 2) {
	    SendClientMessage(playerid, COLOR_YELLOW, "[LEVEL 2]:{FFFFFF} /respawn, /warn, /checkstats, /shooter, /goto, /bring, /setinterior, /setvw.");
	    SendClientMessage(playerid, COLOR_YELLOW, "[LEVEL 2]:{FFFFFF} /sendto, /clearchat, /spawn, /refill, /revive, /aslap, /acceptname, /declinename, /atalk.");
	    SendClientMessage(playerid, COLOR_YELLOW, "[LEVEL 2]:{FFFFFF} /masked, /listguns, /respawncar, /respawncars, /respawnnear, /heal, /bringcar, /gotocar.");
		SendClientMessage(playerid, COLOR_YELLOW, "[LEVEL 2]:{FFFFFF} /x /y /z");
 	}
	if (PlayerData[playerid][pAdmin] >= 3) {
	    SendClientMessage(playerid, COLOR_YELLOW, "[LEVEL 3]:{FFFFFF} /unban, /blacklist, /getip, /togooc, /health, /armor, /resetweps, /arepair, /listwarns.");
	    SendClientMessage(playerid, COLOR_YELLOW, "[LEVEL 3]:{FFFFFF} /entercar, /flipcar, /veh, /destroyveh, /near, /healall, /tracenumber, /bleeding.");
	    SendClientMessage(playerid, COLOR_YELLOW, "[LEVEL 3]:{FFFFFF} /atune, /acolorcar, /apaintjob, /afire, /akillfire, /adestroybox.");
	}
	if (PlayerData[playerid][pAdmin] >= 4) {
        SendClientMessage(playerid, COLOR_YELLOW, "[LEVEL 4]:{FFFFFF} /givewep, /settester, /baninfo, /setname, /asetfaction, /asetrank, /setitem.");
        SendClientMessage(playerid, COLOR_YELLOW, "[LEVEL 4]:{FFFFFF} /asellhouse, /asellbiz, /jetpack, /setweather, /setfuel, /setcarhp, /spawnitem.");
        SendClientMessage(playerid, COLOR_YELLOW, "[LEVEL 4]:{FFFFFF} /setquantity, /destroyitem, /setplayer, /setleader, /setinventory, /givecar.");
	}
	if (PlayerData[playerid][pAdmin] >= 5) {
        SendClientMessage(playerid, COLOR_YELLOW, "[LEVEL 5]:{FFFFFF} /dynamichelp, /givecash, /clearinventory, /clearwarns, /saveall, /restart.");
	}
	if (PlayerData[playerid][pAdmin] >= 6) {
	    SendClientMessage(playerid, COLOR_YELLOW, "[LEVEL 6]:{FFFFFF} /makeadmin, /deleteaccount, /deletechar, /factionmod, /panel.");
	}
	return 1;
}


// ====== CMD:dynamichelp ======
CMD:dynamichelp(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 5)
	    return 1;

	SendClientMessage(playerid, COLOR_CLIENT, "DYNAMIC:{FFFFFF} /createhouse, /createbiz, /createentrance, /createpump, /createcrate, /createfaction.");
    SendClientMessage(playerid, COLOR_CLIENT, "DYNAMIC:{FFFFFF} /creategate, /createcar, /createatm, /createvendor, /creategarbage, /edithouse, /editbiz.");
	SendClientMessage(playerid, COLOR_CLIENT, "DYNAMIC:{FFFFFF} /bizstate, /destroybiz, /editentrance, /editfaction, /editgate, /setpump, /destroyhouse.");
	SendClientMessage(playerid, COLOR_CLIENT, "DYNAMIC:{FFFFFF} /destroypump, /destroyentrance, /destroypump, /destroycrate, /destroyfaction, /destroygate");
	SendClientMessage(playerid, COLOR_CLIENT, "DYNAMIC:{FFFFFF} /destroyatm, /destroygarbage, /createrack, /editrack, /destroyrack, /createspeed, /destroyspeed.");
	SendClientMessage(playerid, COLOR_CLIENT, "DYNAMIC:{FFFFFF} /destroyplant, /createdetector, /destroydetector. /createbillboard /destroybillboard /editbillboard");
	return 1;
}


// ====== CMD:report ======
CMD:report(playerid, params[])
{
	new reportid = -1;

	if (isnull(params))
	{
	    SendSyntaxMessage(playerid, "/report [reason]");
	    SendClientMessage(playerid, COLOR_LIGHTRED, "[WARNING]:{FFFFFF} Please only use this command for valid purposes only.");
	    return 1;
	}
	if (Report_GetCount(playerid) > 5)
	    return SendErrorMessage(playerid, "You already have 5 active reports!");

	if (PlayerData[playerid][pReportTime] >= gettime())
	    return SendErrorMessage(playerid, "You must wait %d seconds before sending another report.", PlayerData[playerid][pReportTime] - gettime());

	if ((reportid = Report_Add(playerid, params)) != -1)
	{
		ShowPlayerFooter(playerid, "Your ~g~report~w~ has been sent!");

		foreach (new i : Player)
		{
			if (PlayerData[i][pAdmin] > 0 && PlayerData[i][pAdminDuty]) {
				SendClientMessageEx(i, COLOR_LIGHTYELLOW, "[REPORT %d]: %s (ID: %d) reports: %s", reportid, ReturnName(playerid, 0), playerid, params);
			}
		}
		PlayerData[playerid][pReportTime] = gettime() + 15;
		SendServerMessage(playerid, "Your report has been sent to any admins online.");
	}
	else
	{
	    SendErrorMessage(playerid, "The report list is full. Please wait for a while.");
	}
	return 1;
}


// ====== CMD:reports ======
CMD:reports(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	new
		count,
		text[128];

	for (new i = 0; i != MAX_REPORTS; i ++)
	{
	    if (!ReportData[i][rExists])
			continue;

		strunpack(text, ReportData[i][rText]);

		SendClientMessageEx(playerid, COLOR_LIGHTYELLOW, "[RID: %d] %s (ID: %d) reported: %s", i, ReturnName(ReportData[i][rPlayer]), ReportData[i][rPlayer], text);
		count++;
	}
	if (!count)
	    return SendErrorMessage(playerid, "There are no active reports to display.");

	SendServerMessage(playerid, "Please use \"/ar RID\" or \"/dr RID\" to accept or deny a report.");
	return 1;
}


// ====== CMD:ar ======
CMD:ar(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/ar [report id] (/reports for a list)");

	new
		reportid = strval(params),
		string[64];

	if ((reportid < 0 || reportid >= MAX_REPORTS) || !ReportData[reportid][rExists])
	    return SendErrorMessage(playerid, "Invalid report ID. Reports list from 0 to %d.", MAX_REPORTS);

	format(string, sizeof(string), "You have ~g~accepted~w~ report ID: %d.", reportid);
	ShowPlayerFooter(playerid, string);

	SendAdminAction(ReportData[reportid][rPlayer], "%s (ID: %d) has accepted your report.", ReturnName(playerid, 0), playerid);
	SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has accepted %s's report.", ReturnName(playerid, 0), ReturnName(ReportData[reportid][rPlayer], 0));

	Report_Remove(reportid);
	return 1;
}


// ====== CMD:dr ======
CMD:dr(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/dr [report id] (/reports for a list)");

	new
		reportid = strval(params),
		string[64];

	if ((reportid < 0 || reportid >= MAX_REPORTS) || !ReportData[reportid][rExists])
	    return SendErrorMessage(playerid, "Invalid report ID. Reports list from 0 to %d.", MAX_REPORTS);

	format(string, sizeof(string), "You have ~r~denied~w~ report ID: %d.", reportid);
	ShowPlayerFooter(playerid, string);

	SendAdminAction(ReportData[reportid][rPlayer], "%s (ID: %d) has denied your report.", ReturnName(playerid, 0), playerid);
    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has denied %s's report.", ReturnName(playerid, 0), ReturnName(ReportData[reportid][rPlayer], 0));

    Report_Remove(reportid);
	return 1;
}


// ====== CMD:spectate ======
CMD:spectate(playerid, params[])
{
	new userid;

	if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (!isnull(params) && !strcmp(params, "off", true))
	{
	    if (GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
			return SendErrorMessage(playerid, "You are not spectating any player.");

	    PlayerSpectatePlayer(playerid, INVALID_PLAYER_ID);
	    PlayerSpectateVehicle(playerid, INVALID_VEHICLE_ID);

	    SetSpawnInfo(playerid, 0, PlayerData[playerid][pSkin], PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2], PlayerData[playerid][pPos][3], 0, 0, 0, 0, 0, 0);
	    TogglePlayerSpectating(playerid, false);

	    return SendServerMessage(playerid, "You are no longer in spectator mode.");
	}
	if (sscanf(params, "u", userid))
		return SendSyntaxMessage(playerid, "/spectate [playerid/name] - Type \"/spectate off\" to stop spectating.");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	if (GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
	{
		GetPlayerPos(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]);
		GetPlayerFacingAngle(playerid, PlayerData[playerid][pPos][3]);

		PlayerData[playerid][pInterior] = GetPlayerInterior(playerid);
		PlayerData[playerid][pWorld] = GetPlayerVirtualWorld(playerid);
	}
	SetPlayerInterior(playerid, GetPlayerInterior(userid));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(userid));

	TogglePlayerSpectating(playerid, 1);

	if (IsPlayerInAnyVehicle(userid))
	    PlayerSpectateVehicle(playerid, GetPlayerVehicleID(userid));

	else
		PlayerSpectatePlayer(playerid, userid);

	SendServerMessage(playerid, "You are now spectating %s (ID: %d).", ReturnName(userid, 0), userid);
	PlayerData[playerid][pSpectator] = userid;

	return 1;
}


// ====== CMD:ajail ======
CMD:ajail(playerid, params[])
{
	static
		userid,
		minutes,
		reason[128];

	if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "uds[128]", userid, minutes, reason))
	    return SendSyntaxMessage(playerid, "/ajail [playerid/name] [minutes] [reason]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	if (minutes < 1)
		return SendErrorMessage(playerid, "You can't jail a player for under 0 minutes.");

	if (minutes > 30 && PlayerData[playerid][pTester] && !PlayerData[playerid][pAdmin])
	    return SendErrorMessage(playerid, "Supporters can't jail players for more than 30 minutes.");

	ClearAnimations(userid);
	PlayerTextDrawShow(userid, PlayerData[userid][pTextdraws][70]);

    SetPlayerPos(userid, 197.6346, 175.3765, 1003.0234);
    SetPlayerInterior(userid, 3);

	SetPlayerVirtualWorld(userid, (playerid + 100));
 	SetPlayerFacingAngle(userid, 0.0);

	SetCameraBehindPlayer(userid);
	ResetWeapons(userid);

    ShowHungerTextdraw(userid, 0);
	ResetPlayer(userid);

	PlayerData[userid][pJailTime] = minutes * 60;
	PlayerData[userid][pPrisoned] = 0;

	SendAdminAction(playerid, "You have jailed %s for %d minutes (%s).", ReturnName(userid, 0), minutes, reason);
	SendAdminAction(userid, "%s has jailed you for %d minutes (%s).", ReturnName(playerid, 0), minutes, reason);

	SendClientMessageToAllEx(COLOR_LIGHTRED, "[ADMIN]: %s has jailed %s for %d minutes for: %s", ReturnName(playerid, 0), ReturnName(userid, 0), minutes, reason);
	Log_Write("logs/jail_log.txt", "[%s] %s has jailed %s for %d minutes, reason: %s.", ReturnDate(), ReturnName(playerid, 0), ReturnName(userid, 0), minutes, reason);
	return 1;
}


// ====== CMD:release ======
CMD:release(playerid, params[])
{
	static
	    userid;

    if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/release [playerid/name]");

    if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	if (!PlayerData[userid][pJailTime])
	    return SendErrorMessage(playerid, "You can't release a player that's not in jail.");

	PlayerData[userid][pJailTime] = 1;

	SendAdminAction(playerid, "You have released %s from jail.", ReturnName(userid, 0));
	SendAdminAction(userid, "%s has released you from jail.", ReturnName(playerid, 0));

	Log_Write("logs/jail_log.txt", "[%s] %s has released %s from jail.", ReturnDate(), ReturnName(playerid, 0), ReturnName(userid, 0));
	return 1;
}


// ====== CMD:aslap ======
CMD:aslap(playerid, params[])
{
	static
	    userid;

    if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/aslap [playerid/name]");

    if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	static
	    Float:x,
	    Float:y,
	    Float:z;

	GetPlayerPos(userid, x, y, z);
	SetPlayerPos(userid, x, y, z + 5);

	PlayerPlaySound(userid, 1130, 0.0, 0.0, 0.0);
	SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has slapped %s.", ReturnName(playerid, 0), ReturnName(userid, 0));
	return 1;
}


// ====== CMD:kick ======
CMD:kick(playerid, params[])
{
	static
	    userid,
	    reason[128];

    if (PlayerData[playerid][pAdmin] < 1 && PlayerData[playerid][pTester] < 1)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "us[128]", userid, reason))
	    return SendSyntaxMessage(playerid, "/kick [playerid/name] [reason]");

	if (userid == INVALID_PLAYER_ID || (IsPlayerConnected(userid) && PlayerData[userid][pKicked]))
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

    if (PlayerData[userid][pAdmin] > PlayerData[playerid][pAdmin])
	    return SendErrorMessage(playerid, "The specified player has higher authority.");

	SendClientMessageToAllEx(COLOR_LIGHTRED, "[ADMIN]: %s has kicked %s for: %s.", ReturnName(playerid, 0), ReturnName(userid, 0), reason);
	Log_Write("logs/kick_log.txt", "[%s] %s has kicked %s for: %s.", ReturnDate(), ReturnName(playerid, 0), ReturnName(userid, 0), reason);

	KickEx(userid);
	return 1;
}


// ====== CMD:mute ======
CMD:mute(playerid, params[])
{
    static
	    userid;

    if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/mute [playerid/name]");

    if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	if (userid == playerid)
	    return SendErrorMessage(playerid, "You can't mute yourself!");

	if (PlayerData[userid][pMuted])
	    return SendErrorMessage(playerid, "The player you're attempting to mute is muted already.");

    if (PlayerData[userid][pAdmin] > PlayerData[playerid][pAdmin])
	    return SendErrorMessage(playerid, "The specified player has higher authority.");

	PlayerData[userid][pMuted] = 1;

	SendAdminAction(playerid, "You have muted %s from using text and commands.", ReturnName(userid, 0));
	SendAdminAction(userid, "%s has muted you from using text and commands.", ReturnName(playerid, 0));

	return 1;
}


// ====== CMD:unmute ======
CMD:unmute(playerid, params[])
{
    static
	    userid;

    if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/unmute [playerid/name]");

    if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	if (!PlayerData[userid][pMuted])
	    return SendErrorMessage(playerid, "The player you're attempting to mute is not muted.");

	PlayerData[userid][pMuted] = 0;

	SendAdminAction(playerid, "You have unmuted %s from using text and commands.", ReturnName(userid, 0));
	SendAdminAction(userid, "You have been unmuted by %s.", ReturnName(playerid, 0));

	return 1;
}


// ====== CMD:freeze ======
CMD:freeze(playerid, params[])
{
	static
	    userid;

    if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/freeze [playerid/name]");

    if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	TogglePlayerControllable(userid, 0);
	SendAdminAction(playerid, "You have frozen %s's movements.", ReturnName(userid, 0));
	return 1;
}


// ====== CMD:unfreeze ======
CMD:unfreeze(playerid, params[])
{
	static
	    userid;

    if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/unfreeze [playerid/name]");

    if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

    PlayerData[playerid][pFreeze] = 0;

	TogglePlayerControllable(userid, 1);
	SendAdminAction(playerid, "You have unfrozen %s's movements.", ReturnName(userid, 0));
	return 1;
}


// ====== CMD:revive ======
CMD:revive(playerid, params[])
{
	static
	    userid;

    if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/revive [playerid/name]");

    if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	if (!PlayerData[userid][pInjured])
	    return SendErrorMessage(playerid, "You can't revive a player that's not injured.");

	ShowHungerTextdraw(userid, 1);
	PlayerData[userid][pInjured] = 0;

	ClearAnimations(userid);
	TextDrawHideForPlayer(userid, gServerTextdraws[2]);

	SendAdminAction(playerid, "You have revived %s's character.", ReturnName(userid, 0));
	SendAdminAction(userid, "%s has revived your character.", ReturnName(playerid, 0));
	return 1;
}


// ====== CMD:respawn ======
CMD:respawn(playerid, params[])
{
	static
	    userid;

    if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/respawn [playerid/name]");

    if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	if (!IsPlayerSpawned(userid))
	    return SendErrorMessage(playerid, "You can't respawn a player that's not spawned.");

	RespawnPlayer(userid);

	SendAdminAction(playerid, "You have respawned %s.", ReturnName(userid, 0));
	SendAdminAction(userid, "You have been respawned by %s.", ReturnName(playerid, 0));

	return 1;
}


// ====== CMD:refill ======
CMD:refill(playerid, params[])
{
	static
	    userid;

    if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/refill [playerid/name]");

    if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	PlayerData[userid][pHunger] = 100;
	PlayerData[userid][pThirst] = 100;

	SendAdminAction(playerid, "You have refilled %s's hunger and thirst.", ReturnName(userid, 0));
	SendAdminAction(userid, "Your hunger and thirst was refilled by %s.", ReturnName(playerid, 0));

	return 1;
}


// ====== CMD:skin ======
CMD:skin(playerid, params[])
{
	static
	    userid,
		skinid;

    if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "ud", userid, skinid))
	    return SendSyntaxMessage(playerid, "/skin [playerid/name] [skin id]");

    if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	if (skinid < 0 || skinid > 299)
	    return SendErrorMessage(playerid, "Invalid skin ID. Skins range from 0 to 299.");

	SetPlayerSkin(userid, skinid);
	PlayerData[userid][pSkin] = skinid;

	SendAdminAction(playerid, "You have set %s's skin to ID: %d.", ReturnName(userid, 0), skinid);
	SendAdminAction(userid, "%s has set your skin to ID: %d.", ReturnName(playerid, 0), skinid);

	return 1;
}


// ====== CMD:ban ======
CMD:ban(playerid, params[])
{
	static
	    userid,
		reason[128];

    if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "us[128]", userid, reason))
	    return SendSyntaxMessage(playerid, "/ban [playerid/name] [reason]");

    if (userid == INVALID_PLAYER_ID || (IsPlayerConnected(userid) && PlayerData[userid][pKicked]))
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	if (userid == playerid)
	    return SendErrorMessage(playerid, "You can't ban yourself from the server.");

    if (PlayerData[userid][pAdmin] > PlayerData[playerid][pAdmin])
	    return SendErrorMessage(playerid, "The specified player has higher authority.");

 	foreach (new i : Player) {
		if (!strcmp(PlayerData[i][pIP], PlayerData[userid][pIP]) && i != userid) {
		    KickEx(i);
		}
	}
	Dialog_Show(userid, ShowOnly, DIALOG_STYLE_MSGBOX, DialogStyle_Title("Banned"), DialogStyle_Body("Your account has been banned by the server.\n\nUsername: %s\nReason: %s\nAdmin who banned you: %s\n\nPress F8 to take a screenshot and request a ban appeal on our forums."), "Close", "", PlayerData[userid][pUsername], reason, ReturnName(playerid, 0));

	SendClientMessageToAllEx(COLOR_LIGHTRED, "[ADMIN]: %s was banned by %s for: %s.", ReturnName(userid, 0), ReturnName(playerid, 0), reason);
	Log_Write("logs/ban_log.txt", "[%s] %s was banned by %s for: %s.", ReturnDate(), ReturnName(userid, 0), ReturnName(playerid, 0), reason);

	Blacklist_Add(PlayerData[userid][pIP], PlayerData[userid][pUsername], PlayerData[playerid][pUsername], reason);
	KickEx(userid);

	return 1;
}


// ====== CMD:username ======
CMD:username(playerid, params[])
{
	if (isnull(params) || strlen(params) > 24)
		return SendSyntaxMessage(playerid, "/username [character name]");

	static
	    query[128];

	format(query, sizeof(query), "SELECT `Username` FROM `characters` WHERE `Character` = '%s'", SQL_ReturnEscaped(params));
	mysql_tquery(g_iHandle, query, "OnResolveUsername", "ds", playerid, params);

	return 1;
}


// ====== CMD:checkstats ======
CMD:checkstats(playerid, params[])
{
    static
	    userid;

    if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/checkstats [playerid/name]");

    if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	if (!PlayerData[userid][pLogged] && !PlayerData[userid][pCharacter])
	    return SendErrorMessage(playerid, "That player is not logged in yet.");

	ShowStatsForPlayer(playerid, userid);
	SendAdminAction(playerid, "You are now viewing %s's stats (type /stats to close).", ReturnName(userid, 0));
	return 1;
}


// ====== CMD:acc ======
CMD:acc(playerid, params[])
{
	new
	    string[128];

	format(string, sizeof(string), "Glasses: %s\nHat: %s\nBandana: %s", (PlayerData[playerid][pGlasses]) ? ("Yes") : ("No"), (PlayerData[playerid][pHat]) ? ("Yes") : ("No"), (PlayerData[playerid][pBandana]) ? ("Yes") : ("No"));
	Dialog_Show(playerid, Accessory, DIALOG_STYLE_LIST, DialogStyle_Title("Accessories"), string, "Select", "Cancel");

	return 1;
}


// ====== CMD:shooter ======
CMD:shooter(playerid, params[])
{
	static
	    userid;

	if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/shooter [playerid/name]");

    if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	if (PlayerData[userid][pLastShot] == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "That player hasn't been shot since they joined.");

    SendServerMessage(playerid, "%s was last shot by %s (%s).", ReturnName(userid, 0), ReturnName(PlayerData[userid][pLastShot]), GetDuration(gettime() - PlayerData[userid][pShotTime]));
    return 1;
}


// ====== CMD:goto ======
CMD:goto(playerid, params[])
{
	static
	    id,
	    type[24],
		string[64];

	if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "u", id))
 	{
	 	SendSyntaxMessage(playerid, "/goto [player or name]");
		SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} spawn, prison, house, business, entrance, job, gate, interior, billboard");
		return 1;
	}
    if (id == INVALID_PLAYER_ID)
	{
	    if (sscanf(params, "s[24]S()[64]", type, string))
		{
		    SendSyntaxMessage(playerid, "/goto [player or name]");
			SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} spawn, prison, house, business, entrance, job, gate, interior, billboard");
			return 1;
	    }
	    if (!strcmp(type, "spawn", true)) {
	        SetDefaultSpawn(playerid);

	        return SendServerMessage(playerid, "You have teleported to the default spawn.");
		}
		else if (!strcmp(type, "prison", true))
		{
	        SetPlayerPos(playerid, 283.5930, 1413.3511, 10.4078);
	        SetPlayerFacingAngle(playerid, 180.0000);

	        SetPlayerInterior(playerid, 0);
	        SetPlayerVirtualWorld(playerid, 0);

	        return SendServerMessage(playerid, "You have teleported to the prison facility.");
		}
		//
		else if (!strcmp(type, "billboard", true))
		{
		    if (sscanf(string, "d", id))
		        return SendSyntaxMessage(playerid, "/goto [billboard] [billboard ID]");

			if ((id < 0 || id >= MAX_BILLBOARDS) || !BillBoardData[id][bbExists])
			    return SendErrorMessage(playerid, "You have specified an invalid billboard ID.");

		    SetPlayerPos(playerid, BillBoardData[id][bbPos][0], BillBoardData[id][bbPos][1], BillBoardData[id][bbPos][2]);
		    SendServerMessage(playerid, "You have teleported to billboard ID: %d.", id);
		    return 1;
		}
		//
		else if (!strcmp(type, "house", true))
		{
		    if (sscanf(string, "d", id))
		        return SendSyntaxMessage(playerid, "/goto [house] [house ID]");

			if ((id < 0 || id >= MAX_HOUSES) || !HouseData[id][houseExists])
			    return SendErrorMessage(playerid, "You have specified an invalid house ID.");

		    SetPlayerPos(playerid, HouseData[id][housePos][0], HouseData[id][housePos][1], HouseData[id][housePos][2]);
		    SetPlayerInterior(playerid, HouseData[id][houseExterior]);

			SetPlayerVirtualWorld(playerid, HouseData[id][houseExteriorVW]);
		    SendServerMessage(playerid, "You have teleported to house ID: %d.", id);
		    return 1;
		}
		else if (!strcmp(type, "business", true))
		{
		    if (sscanf(string, "d", id))
		        return SendSyntaxMessage(playerid, "/goto [business] [business ID]");

			if ((id < 0 || id >= MAX_BUSINESSES) || !BusinessData[id][bizExists])
			    return SendErrorMessage(playerid, "You have specified an invalid business ID.");

		    SetPlayerPos(playerid, BusinessData[id][bizPos][0], BusinessData[id][bizPos][1], BusinessData[id][bizPos][2]);
		    SetPlayerInterior(playerid, BusinessData[id][bizExterior]);

			SetPlayerVirtualWorld(playerid, BusinessData[id][bizExteriorVW]);
		    SendServerMessage(playerid, "You have teleported to business ID: %d.", id);
		    return 1;
		}
		else if (!strcmp(type, "entrance", true))
		{
		    if (sscanf(string, "d", id))
		        return SendSyntaxMessage(playerid, "/goto [entrance] [entrance ID]");

			if ((id < 0 || id >= MAX_ENTRANCES) || !EntranceData[id][entranceExists])
			    return SendErrorMessage(playerid, "You have specified an invalid entrance ID.");

		    SetPlayerPos(playerid, EntranceData[id][entrancePos][0], EntranceData[id][entrancePos][1], EntranceData[id][entrancePos][2]);
		    SetPlayerInterior(playerid, EntranceData[id][entranceExterior]);

			SetPlayerVirtualWorld(playerid, EntranceData[id][entranceExteriorVW]);
		    SendServerMessage(playerid, "You have teleported to entrance ID: %d.", id);
		    return 1;
		}
		else if (!strcmp(type, "job", true))
		{
		    if (sscanf(string, "d", id))
		        return SendSyntaxMessage(playerid, "/goto [job] [job ID]");

			if ((id < 0 || id >= MAX_DYNAMIC_JOBS) || !JobData[id][jobExists])
			    return SendErrorMessage(playerid, "You have specified an invalid job ID.");

		    SetPlayerPos(playerid, JobData[id][jobPos][0], JobData[id][jobPos][1], JobData[id][jobPos][2]);
		    SetPlayerInterior(playerid, JobData[id][jobInterior]);

			SetPlayerVirtualWorld(playerid, JobData[id][jobWorld]);
		    SendServerMessage(playerid, "You have teleported to job ID: %d.", id);
		    return 1;
		}
		else if (!strcmp(type, "gate", true))
		{
		    if (sscanf(string, "d", id))
		        return SendSyntaxMessage(playerid, "/goto [gate] [gate ID]");

			if ((id < 0 || id >= MAX_GATES) || !GateData[id][gateExists])
			    return SendErrorMessage(playerid, "You have specified an invalid gate ID.");

		    SetPlayerPos(playerid, GateData[id][gatePos][0] - (2.5 * floatsin(-GateData[id][gatePos][3], degrees)), GateData[id][gatePos][1] - (2.5 * floatcos(-GateData[id][gatePos][3], degrees)), GateData[id][gatePos][2]);
		    SetPlayerInterior(playerid, GateData[id][gateInterior]);

			SetPlayerVirtualWorld(playerid, GateData[id][gateWorld]);
		    SendServerMessage(playerid, "You have teleported to gate ID: %d.", id);
		    return 1;
		}
		else if (!strcmp(type, "interior", true))
		{
		    static
		        str[1536];

			str[0] = '\0';

			for (new i = 0; i < sizeof(g_arrInteriorData); i ++) {
			    strcat(str, g_arrInteriorData[i][e_InteriorName]);
			    strcat(str, "\n");
		    }
		    Dialog_Show(playerid, TeleportInterior, DIALOG_STYLE_LIST, DialogStyle_Title("Teleport: Interior List"), str, "Select", "Cancel");
		    return 1;
		}
	    else return SendErrorMessage(playerid, "You have specified an invalid player.");
	}
	if (!IsPlayerSpawned(id))
		return SendErrorMessage(playerid, "You can't teleport to a player that's not spawned.");

	SendPlayerToPlayer(playerid, id);

	format(string, sizeof(string), "You have ~y~teleported~w~ to %s.", ReturnName(id, 0));
	ShowPlayerFooter(playerid, string);

	return 1;
}


// ====== CMD:send ======
CMD:send(playerid, params[])
{
	static
	    userid,
	    type[24];

	if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "us[32]", userid, type))
 	{
	 	SendSyntaxMessage(playerid, "/send [player] [name]");
		SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} spawn, prison");
		return 1;
	}
    if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

 	if (!strcmp(type, "spawn", true))
	 {
  		SetDefaultSpawn(userid);

		SendServerMessage(playerid, "You have teleported %s to the default spawn.", ReturnName(userid, 0));
		SendServerMessage(userid, "%s has teleported you to the default spawn.", ReturnName(playerid, 0));
	}
	else if (!strcmp(type, "prison", true))
	{
		SetPlayerPos(playerid, 283.5930, 1413.3511, 10.4078);
  		SetPlayerFacingAngle(playerid, 180.0000);

		SetPlayerInterior(playerid, 0);
  		SetPlayerVirtualWorld(playerid, 0);

		SendServerMessage(playerid, "You have teleported %s to the prison facility.", ReturnName(userid, 0));
		SendServerMessage(userid, "%s has teleported you to the prison facility.", ReturnName(playerid, 0));
	}
	return 1;
}


// ====== CMD:bring ======
CMD:bring(playerid, params[])
{
	static
	    userid;

	if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/bring [playerid/name]");

    if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	if (!IsPlayerSpawned(userid))
		return SendErrorMessage(playerid, "You can't teleport a player that's not spawned.");

	SendPlayerToPlayer(userid, playerid);
	SendServerMessage(playerid, "You have teleported %s to you.", ReturnName(userid, 0));
	return 1;
}


// ====== CMD:setinterior ======
CMD:setinterior(playerid, params[])
{
	static
		userid,
	    interior;

	if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "ud", userid, interior))
		return SendSyntaxMessage(playerid, "/setinterior [playerid/name] [interior]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	SetPlayerInterior(userid, interior);
	PlayerData[userid][pInterior] = interior;

	SendServerMessage(playerid, "You have set %s's interior to %d.", ReturnName(userid, 0), interior);
	return 1;
}


// ====== CMD:setvw ======
CMD:setvw(playerid, params[])
{
	static
		userid,
	    world;

	if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "ud", userid, world))
		return SendSyntaxMessage(playerid, "/setvw [playerid/name] [world]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	SetPlayerVirtualWorld(userid, world);
	PlayerData[userid][pWorld] = world;

	SendServerMessage(playerid, "You have set %s's virtual world to %d.", ReturnName(userid, 0), world);
	return 1;
}


// ====== CMD:atalk ======
CMD:atalk(playerid, params[])
{
	static
	    userid,
	    text[128];

    if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "us[128]", userid, text))
		return SendSyntaxMessage(playerid, "/atalk [playerid/name] [message]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	SendClientMessageEx(userid, COLOR_YELLOW, "[ADMIN]: %s says: %s", ReturnName(playerid, 0), text);

	if (playerid != userid) {
		SendClientMessageEx(playerid, COLOR_YELLOW, "[ADMIN]: %s says: %s", ReturnName(playerid, 0), text);
	}
	return 1;
}


// ====== CMD:sendto ======
CMD:sendto(playerid, params[])
{
	static
	    userid,
	    targetid;

    if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "uu", userid, targetid))
	    return SendSyntaxMessage(playerid, "/sendto [playerid/name] [playerid/name]");

	if (userid == INVALID_PLAYER_ID || targetid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "The specified user(s) are not connected.");

	SendPlayerToPlayer(userid, targetid);

	SendServerMessage(playerid, "You have teleported %s to %s.", ReturnName(userid, 0), ReturnName(targetid));
	SendServerMessage(userid, "%s has teleported you to %s.", ReturnName(playerid, 0), ReturnName(targetid));
	return 1;
}


// ====== CMD:unban ======
CMD:unban(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (isnull(params) || strlen(params) > 24)
	{
		SendSyntaxMessage(playerid, "/unban [username]");
		SendClientMessage(playerid, COLOR_LIGHTRED, "[NOTE]:{FFFFFF} Type \"/username\" to resolve the username from a character's name.");
	}
	else
	{
	    Blacklist_Remove(params);

	    SendServerMessage(playerid, "You have unbanned \"%s\" successfully.", params);
	    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has unbanned account \"%s\".", ReturnName(playerid, 0), params);

	    Log_Write("logs/ban_log.txt", "[%s] %s has unbanned account \"%s\".", ReturnDate(), ReturnName(playerid, 0), params);
	}
	return 1;
}


// ====== CMD:blacklist ======
CMD:blacklist(playerid, params[])
{
	static
		type[24];

    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "s[24]s[128]", type, params))
 	{
	 	SendSyntaxMessage(playerid, "/blacklist [name] [parameter]");
	 	SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} ban, banip, unbanip");
	 	return 1;
	}
	if (!strcmp(type, "ban", true))
	{
	    if (!IsValidPlayerName(params))
	        return SendErrorMessage(playerid, "The name you've entered is not in the correct format.");

		foreach (new i : Player) if (!strcmp(PlayerData[i][pUsername], params) || !strcmp(ReturnName(i), params, true)) {
		    KickEx(i);
		}
		Blacklist_Add("0.0.0.0", params, PlayerData[playerid][pUsername], "Name Ban (/blacklist)");

	    SendServerMessage(playerid, "You have banned \"%s\" successfully.", params);
	    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has banned \"%s\".", ReturnName(playerid, 0), params);

	    Log_Write("logs/ban_log.txt", "[%s] %s has banned \"%s\".", ReturnDate(), ReturnName(playerid, 0), params);
	}
	else if (!strcmp(type, "banip", true))
	{
	    if (!IsAnIP(params))
	        return SendErrorMessage(playerid, "The IP address you've entered is not in the correct format.");

		foreach (new i : Player) if (!strcmp(PlayerData[i][pIP], params)) {
		    KickEx(i);
		}
		Blacklist_Add(params, "", PlayerData[playerid][pUsername], "IP Ban (/blacklist)");

	    SendServerMessage(playerid, "You have banned IP \"%s\" successfully.", params);
	    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has banned IP \"%s\".", ReturnName(playerid, 0), params);

	    Log_Write("logs/ban_log.txt", "[%s] %s has banned IP \"%s\".", ReturnDate(), ReturnName(playerid, 0), params);
	}
	else if (!strcmp(type, "unbanip", true))
	{
	    if (!IsAnIP(params))
	        return SendErrorMessage(playerid, "The IP address you've entered is not in the correct format.");

		Blacklist_RemoveIP(params);

	    SendServerMessage(playerid, "You have unbanned IP \"%s\" successfully.", params);
	    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has unbanned IP \"%s\".", ReturnName(playerid, 0), params);

	    Log_Write("logs/ban_log.txt", "[%s] %s has unbanned IP \"%s\".", ReturnDate(), ReturnName(playerid, 0), params);
	}
	return 1;
}


// ====== CMD:getip ======
CMD:getip(playerid, params[])
{
	static
	    userid;

    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/getip [playerid/name]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	SendServerMessage(playerid, "%s's IP address is %s.", ReturnName(userid, 0), PlayerData[userid][pIP]);
	return 1;
}


// ====== CMD:togooc ======
CMD:togooc(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (!g_StatusOOC)
	{
	    SendClientMessageToAllEx(COLOR_LIGHTRED, "[ADMIN]: %s has disabled global OOC chat.", ReturnName(playerid, 0));
	    g_StatusOOC = true;
	}
	else
	{
	    SendClientMessageToAllEx(COLOR_LIGHTRED, "[ADMIN]: %s has enabled global OOC chat.", ReturnName(playerid, 0));
	    g_StatusOOC = false;
	}
	return 1;
}


// ====== CMD:health ======
CMD:health(playerid, params[])
{
	static
		userid,
	    Float:amount;

	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "uf", userid, amount))
		return SendSyntaxMessage(playerid, "/health [playerid/name] [amount]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	SetPlayerHealth(userid, amount);
	SendServerMessage(playerid, "You have set %s's health to %.2f.", ReturnName(userid, 0), amount);
	return 1;
}


// ====== CMD:armor ======
CMD:armor(playerid, params[])
{
	static
		userid,
	    Float:amount;

	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "uf", userid, amount))
		return SendSyntaxMessage(playerid, "/armor [playerid/name] [amount]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

    SetPlayerArmour(userid, amount);
	SendServerMessage(playerid, "You have set %s's armor to %.2f.", ReturnName(userid, 0), amount);
	return 1;
}


// ====== CMD:resetweps ======
CMD:resetweps(playerid, params[])
{
	static
	    userid;

    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/resetweps [playerid/name]");

    if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	ResetWeapons(userid);
	SendAdminAction(playerid, "You have reset %s's weapons.", ReturnName(userid, 0));

	return 1;
}


// ====== CMD:bringcar ======
CMD:bringcar(playerid, params[])
{
	new vehicleid;

    if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", vehicleid))
	    return SendSyntaxMessage(playerid, "/bringcar [veh]");

	if (vehicleid < 1 || vehicleid > MAX_VEHICLES || !IsValidVehicle(vehicleid))
		return SendErrorMessage(playerid, "You have specified an invalid vehicle ID.");

	static
	    Float:x,
	    Float:y,
	    Float:z;

	GetPlayerPos(playerid, x, y, z);
	SetVehiclePos(vehicleid, x + 2, y - 2, z);

 	SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
	LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));

	return 1;
}


// ====== CMD:entercar ======
CMD:entercar(playerid, params[])
{
	new vehicleid, seatid;

    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", vehicleid))
	    return SendSyntaxMessage(playerid, "/entercar [veh]");

	if (vehicleid < 1 || vehicleid > MAX_VEHICLES || !IsValidVehicle(vehicleid))
		return SendErrorMessage(playerid, "You have specified an invalid vehicle ID.");

	seatid = GetAvailableSeat(vehicleid, 0);

	if (seatid == -1)
	    return SendErrorMessage(playerid, "There are no seats left to enter.");

	PutPlayerInVehicle(playerid, vehicleid, seatid);
	return 1;
}


// ====== CMD:gotocar ======
CMD:gotocar(playerid, params[])
{
	new vehicleid;

    if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", vehicleid))
	    return SendSyntaxMessage(playerid, "/gotocar [veh]");

	if (vehicleid < 1 || vehicleid > MAX_VEHICLES || !IsValidVehicle(vehicleid))
		return SendErrorMessage(playerid, "You have specified an invalid vehicle ID.");

	static
	    Float:x,
	    Float:y,
	    Float:z;

	GetVehiclePos(vehicleid, x, y, z);
	SetPlayerPos(playerid, x, y - 2, z + 2);

	return 1;
}


// ====== CMD:respawncar ======
CMD:respawncar(playerid, params[])
{
	new vehicleid;

    if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", vehicleid))
	    return SendSyntaxMessage(playerid, "/respawncar [veh]");

	if (vehicleid < 1 || vehicleid > MAX_VEHICLES || !IsValidVehicle(vehicleid))
		return SendErrorMessage(playerid, "You have specified an invalid vehicle ID.");

	RespawnVehicle(vehicleid);
	SendServerMessage(playerid, "You have respawned vehicle ID: %d.", vehicleid);

	return 1;
}


// ====== CMD:respawncars ======
CMD:respawncars(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	new count;

	for (new i = 1; i != MAX_VEHICLES; i ++)
	{
	    if (IsValidVehicle(i) && GetVehicleDriver(i) == INVALID_PLAYER_ID)
	    {
	        RespawnVehicle(i);
			count++;
		}
	}
	if (!count)
	    return SendErrorMessage(playerid, "There are no vehicles to respawn.");

	SendServerMessage(playerid, "You have respawned %d unoccupied vehicles.", count);
	return 1;
}


// ====== CMD:respawnnear ======
CMD:respawnnear(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	new count;

	for (new i = 1; i != MAX_VEHICLES; i ++)
	{
	    static
	        Float:fX,
	        Float:fY,
	        Float:fZ;

	    if (IsValidVehicle(i) && GetVehicleDriver(i) == INVALID_PLAYER_ID)
		{
			GetVehiclePos(i, fX, fY, fZ);

			if (IsPlayerInRangeOfPoint(playerid, 50.0, fX, fY, fZ))
			{
		        RespawnVehicle(i);
				count++;
			}
		}
	}
	if (!count)
	    return SendErrorMessage(playerid, "There are no closest vehicles to respawn.");

	SendServerMessage(playerid, "You have respawned the %d closest vehicles.", count);
	return 1;
}


// ====== CMD:veh ======
CMD:veh(playerid, params[])
{
	static
	    model[32],
		color1,
		color2;

    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "s[32]I(-1)I(-1)", model, color1, color2))
	    return SendSyntaxMessage(playerid, "/veh [model id/name] <color 1> <color 2>");

	if ((model[0] = GetVehicleModelByName(model)) == 0)
	    return SendErrorMessage(playerid, "Invalid model ID.");

	static
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:a,
		vehicleid;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	vehicleid = CreateVehicle(model[0], x, y + 2, z, a, color1, color2, 0);

	if (GetPlayerInterior(playerid) != 0)
	    LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));

	if (GetPlayerVirtualWorld(playerid) != 0)
		SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));

	if (IsABoat(vehicleid) || IsAPlane(vehicleid) || IsAHelicopter(vehicleid))
	    PutPlayerInVehicle(playerid, vehicleid, 0);

	ResetVehicle(vehicleid);

	CoreVehicles[vehicleid][vehTemporary] = true;
	SendServerMessage(playerid, "You have spawned a %s (%d, %d).", ReturnVehicleModelName(model[0]), color1, color2);
	return 1;
}


// ====== CMD:destroyveh ======
CMD:destroyveh(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (!isnull(params) && !strcmp(params, "all", true))
	{
	    for (new i = 1; i != MAX_VEHICLES; i ++) if (IsValidVehicle(i) && CoreVehicles[i][vehTemporary])
		{
	        CoreVehicles[i][vehTemporary] = false;

	        DestroyVehicle(i);
	        ResetVehicle(i);
	    }
	    SendServerMessage(playerid, "You have destroyed the temporary vehicles.");
	    return 1;
	}
	else if (IsPlayerInAnyVehicle(playerid))
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

	    if (CoreVehicles[vehicleid][vehTemporary])
		{
	        CoreVehicles[vehicleid][vehTemporary] = false;
	        DestroyVehicle(vehicleid);

	        ResetVehicle(vehicleid);
	        SendServerMessage(playerid, "You have destroyed this admin vehicle.");
		}
		else
		{
		    SendErrorMessage(playerid, "You cannot destroy a non-temporary vehicle.");
		}
	}
	return 1;
}


// ====== CMD:givewep ======
CMD:givewep(playerid, params[])
{
	static
	    userid,
	    weaponid,
	    ammo;

    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "udI(500)", userid, weaponid, ammo))
	    return SendSyntaxMessage(playerid, "/givewep [playerid/name] [weaponid] [ammo]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You cannot give weapons to disconnected players.");

	if (!IsPlayerSpawned(userid))
	    return SendErrorMessage(playerid, "You cannot give weapons to unspawned players.");

	if (weaponid <= 0 || weaponid > 46 || (weaponid >= 19 && weaponid <= 21))
		return SendErrorMessage(playerid, "You have specified an invalid weapon.");

	GiveWeaponToPlayer(userid, weaponid, ammo);
	SendServerMessage(playerid, "You have gave %s a %s with %d ammo.", ReturnName(userid, 0), ReturnWeaponName(weaponid), ammo);
	return 1;
}


// ====== CMD:setplayer ======
CMD:setplayer(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	static
	    userid,
	    type[16],
	    amount[32];

	if (sscanf(params, "us[16]S()[32]", userid, type, amount))
 	{
	 	SendSyntaxMessage(playerid, "/setplayer [playerid/name] [name]");
	 	SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} gender, birthdate, origin, bank, savings, hunger, thirst, playinghours");
		SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} job, warrants, channel");
		return 1;
	}
	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	if (!strcmp(type, "gender", true))
	{
	    if (isnull(amount) || strval(amount) < 1 || strval(amount) > 2)
	        return SendSyntaxMessage(playerid, "/setplayer [playerid/name] [gender] [1: male - 2: female]");

		PlayerData[userid][pGender] = strval(amount);

		if (PlayerData[userid][pGender] == 1)
			SendServerMessage(playerid, "You have set %s's gender to male.", ReturnName(userid, 0));

		else if (PlayerData[userid][pGender] == 2)
			SendServerMessage(playerid, "You have set %s's gender to female.", ReturnName(userid, 0));
	}
	else if (!strcmp(type, "birthdate", true))
	{
	    if (isnull(amount) || strlen(amount) > 24)
	        return SendSyntaxMessage(playerid, "/setplayer [playerid/name] [birthdate] [birth date]");

		format(PlayerData[userid][pBirthdate], 24, amount);
		SendServerMessage(playerid, "You have set %s's birthdate to \"%s\".", ReturnName(userid, 0), amount);
	}
	else if (!strcmp(type, "origin", true))
	{
	    if (isnull(amount) || strlen(amount) > 32)
	        return SendSyntaxMessage(playerid, "/setplayer [playerid/name] [origin] [new origin]");

		format(PlayerData[userid][pOrigin], 32, amount);
		SendServerMessage(playerid, "You have set %s's origin to \"%s\".", ReturnName(userid, 0), amount);
	}
	else if (!strcmp(type, "bank", true))
	{
	    if (isnull(amount))
	        return SendSyntaxMessage(playerid, "/setplayer [playerid/name] [bank] [bank funds]");

		PlayerData[userid][pBankMoney] = strval(amount);
		SendServerMessage(playerid, "You have set %s's bank money to %s.", ReturnName(userid, 0), FormatNumber(strval(amount)));
	}
	else if (!strcmp(type, "savings", true))
	{
	    if (isnull(amount))
	        return SendSyntaxMessage(playerid, "/setplayer [playerid/name] [savings] [savings funds]");

		PlayerData[userid][pSavings] = strval(amount);
		SendServerMessage(playerid, "You have set %s's savings to %s.", ReturnName(userid, 0), FormatNumber(strval(amount)));
	}
	else if (!strcmp(type, "hunger", true))
	{
	    if (isnull(amount))
	        return SendSyntaxMessage(playerid, "/setplayer [playerid/name] [hunger] [amount]");

		if (strval(amount) < 0 || strval(amount) > 1000)
		    return SendErrorMessage(playerid, "You can't specify an amount below 0 or above 1,000.");

		PlayerData[userid][pHunger] = strval(amount);
		SendServerMessage(playerid, "You have set %s's hunger to %s.", ReturnName(userid, 0), FormatNumber(strval(amount), ""));
	}
	else if (!strcmp(type, "thirst", true))
	{
	    if (isnull(amount))
	        return SendSyntaxMessage(playerid, "/setplayer [playerid/name] [thirst] [amount]");

        if (strval(amount) < 0 || strval(amount) > 1000)
		    return SendErrorMessage(playerid, "You can't specify an amount below 0 or above 1,000.");

		PlayerData[userid][pThirst] = strval(amount);
		SendServerMessage(playerid, "You have set %s's thirst to %s.", ReturnName(userid, 0), FormatNumber(strval(amount), ""));
	}
	else if (!strcmp(type, "playinghours", true))
	{
	    if (isnull(amount))
	        return SendSyntaxMessage(playerid, "/setplayer [playerid/name] [playinghours] [amount]");

		PlayerData[userid][pPlayingHours] = strval(amount);
		SendServerMessage(playerid, "You have set %s's playing hours to %s.", ReturnName(userid, 0), FormatNumber(strval(amount), ""));
	}
    else if (!strcmp(type, "job", true))
	{
	    if (isnull(amount))
	        return SendSyntaxMessage(playerid, "/setplayer [playerid/name] [job] [amount]");

		if (strval(amount) < 0 || strval(amount) > 9)
		    return SendErrorMessage(playerid, "You have specified an invalid job ID.");

		PlayerData[userid][pJob] = strval(amount);
		SendServerMessage(playerid, "You have set %s's job to %s.", ReturnName(userid, 0), Job_GetName(PlayerData[userid][pJob]));
	}
    else if (!strcmp(type, "warrants", true))
	{
	    if (isnull(amount))
	        return SendSyntaxMessage(playerid, "/setplayer [playerid/name] [warrants] [amount]");

		PlayerData[userid][pWarrants] = strval(amount);
		SendServerMessage(playerid, "You have set %s's warrants to %s.", ReturnName(userid, 0), FormatNumber(strval(amount), ""));
	}
	else if (!strcmp(type, "channel", true))
	{
	    if (isnull(amount))
	        return SendSyntaxMessage(playerid, "/setplayer [playerid/name] [channel] [radio channel]");

		PlayerData[userid][pChannel] = strval(amount);
		SendServerMessage(playerid, "You have set %s's radio channel to %s.", ReturnName(userid, 0), FormatNumber(strval(amount), ""));
	}
	return 1;
}


// ====== CMD:baninfo ======
CMD:baninfo(playerid, params[])
{
    static
		string[128];

    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (isnull(params) || strlen(params) > 24)
	{
		SendSyntaxMessage(playerid, "/baninfo [username]");
		SendClientMessage(playerid, COLOR_LIGHTRED, "[NOTE]:{FFFFFF} Type \"/username\" to resolve the username from a character's name.");
	}
	else
	{
	    format(string, sizeof(string), "SELECT * FROM `blacklist` WHERE `Username` = '%s'", SQL_ReturnEscaped(params));
	    mysql_tquery(g_iHandle, string, "OnBanLookup", "ds", playerid, params);
	}
	return 1;
}


// ====== CMD:settester ======
CMD:settester(playerid, params[])
{
	static
	    userid;

    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/settester [playerid/name]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	if (PlayerData[userid][pTester])
	{
	    PlayerData[userid][pTester] = false;

	    SendAdminAction(playerid, "You have taken away %s's tester status.", ReturnName(userid, 0));
		SendAdminAction(userid, "%s has kicked you from the tester team.", ReturnName(playerid, 0));
	}
	else
	{
	    PlayerData[userid][pTester] = true;

        SendAdminAction(playerid, "You have invited %s to the tester team.", ReturnName(userid, 0));
		SendAdminAction(userid, "%s has invited you to the tester team.", ReturnName(playerid, 0));
	}
	return 1;
}


// ====== CMD:factionmod ======
CMD:factionmod(playerid, params[])
{
	static
	    userid;

    if (PlayerData[playerid][pAdmin] < 6)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/factionmod [playerid/name]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	if (PlayerData[userid][pFactionMod])
	{
	    PlayerData[userid][pFactionMod] = false;

	    SendAdminAction(playerid, "You have taken away %s's faction management status.", ReturnName(userid, 0));
		SendAdminAction(userid, "%s has kicked you from the faction management team.", ReturnName(playerid, 0));
	}
	else
	{
	    PlayerData[userid][pFactionMod] = true;

        SendAdminAction(playerid, "You have invited %s to the faction management team.", ReturnName(userid, 0));
		SendAdminAction(userid, "%s has invited you to the faction management team.", ReturnName(playerid, 0));
	}
	return 1;
}


// ====== CMD:setname ======
CMD:setname(playerid, params[])
{
	static
	    userid,
	    newname[24],
		query[128];

    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "us[24]", userid, newname))
	    return SendSyntaxMessage(playerid, "/setname [playerid/name] [new name]");

	if (userid == INVALID_PLAYER_ID)
		return SendErrorMessage(playerid, "You have specified an invalid player.");

	if (!PlayerData[userid][pLogged] && !PlayerData[userid][pCharacter])
	    return SendErrorMessage(playerid, "That player hasn't set a character yet.");

	if (!IsValidPlayerName(newname))
	    return SendErrorMessage(playerid, "You have specified an invalid name format.");

	foreach (new i : Player) if (!strcmp(ReturnName(i), newname)) {
	    return SendErrorMessage(playerid, "The specified name is in use.");
	}
	format(query, sizeof(query), "SELECT `ID` FROM `characters` WHERE `Character` = '%s'", SQL_ReturnEscaped(newname));
	mysql_tquery(g_iHandle, query, "OnNameChange", "dds", playerid, userid, newname);

	return 1;
}


// ====== CMD:clearchat ======
CMD:clearchat(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	for (new i = 0; i < 100; i ++) {
	    SendClientMessageToAll(-1, "");
	}
	return 1;
}


// ====== CMD:spawn ======
CMD:spawn(playerid, params[])
{
	static
	    Float:x,
	    Float:y,
	    Float:z,
		interior;

    if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "dfff", interior, x, y, z))
	    return SendSyntaxMessage(playerid, "/spawn [interior] [x] [y] [z]");

	SetPlayerPos(playerid, x, y, z);
	SetPlayerInterior(playerid, interior);

	return 1;
}


// ====== CMD:aojail ======
CMD:aojail(playerid, params[])
{
	if(PlayerData[playerid][pAdmin] >= 1)
	{
		new string[128], name[MAX_PLAYER_NAME], minutes;
		if(sscanf(params, "s[24]ds[64]", name, minutes)) return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /aojail [player name] [time (minutes)]");

		new tmpName[24], query[512];
		mysql_real_escape_string(name, tmpName);

		SetPVarString(playerid, "OnJailAccount", tmpName);

		format(string, sizeof(string), "Attempting to jail %s's account for %d minutes...", tmpName, minutes);
		SendClientMessageEx(playerid, COLOR_LIGHTYELLOW, string);

		format(query,sizeof(query),"UPDATE `characters` SET `JailTime` = %d WHERE `Admin` < %d AND `Username` = '%s'", minutes*60, PlayerData[playerid][pAdmin], tmpName);
		mysql_tquery(g_iHandle, query, "OnJailAccount", "i", playerid);
	}
	return 1;
}

// ====== CMD:disablecp ======
CMD:disablecp(playerid, params[])
{
	if (PlayerData[playerid][pDrivingTest])
	    return SendErrorMessage(playerid, "You can't do this during your driving test.");

	new
		vehicleid = GetPlayerVehicleID(playerid);

	PlayerData[playerid][pCP] = 0;

	if (PlayerData[playerid][pSorting] != -1)
	{
	    PlayerData[playerid][pSorting] = -1;
		PlayerData[playerid][pSortCrate] = 0;

		RemovePlayerAttachedObject(playerid, 4);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
	if (PlayerData[playerid][pMinedRock])
	{
	    PlayerData[playerid][pMinedRock] = 0;
		PlayerData[playerid][pMineCount] = 0;

		RemovePlayerAttachedObject(playerid, 4);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
	if (PlayerData[playerid][pUnloading] != -1)
	{
	    PlayerData[playerid][pUnloading] = -1;
	    PlayerData[playerid][pUnloadVehicle] = INVALID_VEHICLE_ID;
	}
	if (PlayerData[playerid][pLoading])
	{
	    PlayerData[playerid][pLoading] = 0;
	    PlayerData[playerid][pLoadType] = 0;
	}
	if (PlayerData[playerid][pLoadCrate])
 	{
  		PlayerData[playerid][pLoadCrate] = 0;

		RemovePlayerAttachedObject(playerid, 4);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
	if (IsPlayerInWarehouse(playerid) && GetVehicleModel(vehicleid) == 530 && CoreVehicles[vehicleid][vehLoadType] == 7)
	{
 		CoreVehicles[vehicleid][vehLoadType] = 0;
 		CoreVehicles[vehicleid][vehCrate] = INVALID_OBJECT_ID;

   		DestroyObject(CoreVehicles[vehicleid][vehCrate]);
	}
    DisablePlayerCheckpoint(playerid);
    SendServerMessage(playerid, "You have disabled any active checkpoints.");
    return 1;
}


// ====== CMD:restart ======
CMD:restart(playerid, params[])
{
	new time;

	if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (g_ServerRestart)
	{
	    TextDrawHideForAll(gServerTextdraws[3]);

	    g_ServerRestart = 0;
	    g_RestartTime = 0;

	    return SendClientMessageToAllEx(COLOR_LIGHTRED, "[ADMIN]: %s has postponed the server restart.", ReturnName(playerid, 0));
	}
	if (sscanf(params, "d", time))
	    return SendSyntaxMessage(playerid, "/restart [seconds]");

	if (time < 3 || time > 600)
	    return SendErrorMessage(playerid, "The specified seconds can't be below 3 or above 600.");

    TextDrawShowForAll(gServerTextdraws[3]);

	g_ServerRestart = 1;
	g_RestartTime = time;

	SendClientMessageToAllEx(COLOR_LIGHTRED, "[ADMIN]: %s has initiated a server restart in %d seconds.", ReturnName(playerid, 0), time);
	return 1;
}


// ====== CMD:properties ======
CMD:properties(playerid, params[])
{
	new count;

	for (new i = 0; i < MAX_HOUSES; i ++) if (House_IsOwner(playerid, i)) {
	    SendClientMessageEx(playerid, COLOR_LIGHTGREEN, "** House ID: %d | Address: %s | Location: %s", i, HouseData[i][houseAddress], GetLocation(HouseData[i][housePos][0], HouseData[i][housePos][1], HouseData[i][housePos][2]));

	    count++;
	}
	for (new i = 0; i < MAX_BUSINESSES; i ++) if (Business_IsOwner(playerid, i) && BusinessData[i][bizOwner] != 99999999) {
	    SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Business ID: %d | Name: %s | Location: %s", i, BusinessData[i][bizName], GetLocation(BusinessData[i][bizPos][0], BusinessData[i][bizPos][1], BusinessData[i][bizPos][2]));

	    count++;
	}
	if (!count)
	    return SendErrorMessage(playerid, "You don't own any properties.");

	return 1;
}


// ====== CMD:asellhouse ======
CMD:asellhouse(playerid, params[])
{
	new houseid = -1;

    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", houseid))
	    return SendSyntaxMessage(playerid, "/asellhouse [house ID]");

	if ((houseid < 0 || houseid >= MAX_HOUSES) || !HouseData[houseid][houseExists])
	    return SendErrorMessage(playerid, "You have specified an invalid house ID.");

	HouseData[houseid][houseOwner] = 0;

	House_Refresh(houseid);
	House_Save(houseid);

	SendServerMessage(playerid, "You have sold house ID: %d.", houseid);
	return 1;
}


// ====== CMD:asellbiz ======
CMD:asellbiz(playerid, params[])
{
	new bizid = -1;

	if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", bizid))
	    return SendSyntaxMessage(playerid, "/asellbiz [business ID]");

	if ((bizid < 0 || bizid >= MAX_HOUSES) || !BusinessData[bizid][bizExists])
	    return SendErrorMessage(playerid, "You have specified an invalid business ID.");

	BusinessData[bizid][bizOwner] = 0;

	Business_Refresh(bizid);
	Business_Save(bizid);

	SendServerMessage(playerid, "You have sold business ID: %d.", bizid);
	return 1;
}


// ====== CMD:revokeweapon ======
CMD:revokeweapon(playerid, params[])
{
	new userid;

	if (GetFactionType(playerid) != FACTION_POLICE && GetFactionType(playerid) != FACTION_GOV)
	    return SendErrorMessage(playerid, "You must be an officer or a government member.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/revokeweapon [playerid/name]");

	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "That player is disconnected or not near you.");

	if (userid == playerid)
	    return SendErrorMessage(playerid, "You can't revoke your own weapon license.");

	if (!Inventory_HasItem(userid, "Weapon License"))
	    return SendErrorMessage(playerid, "That player doesn't have a weapon license.");

	Inventory_Remove(userid, "Weapon License");

	SendServerMessage(playerid, "You have revoked %s's weapon license.", ReturnName(userid, 0));
	SendServerMessage(userid, "Your weapon license was revoked by %s.", ReturnName(playerid, 0));

	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has revoked %s's weapon license.", ReturnName(playerid, 0), ReturnName(userid, 0));
	return 1;
}


// ====== CMD:jetpack ======
CMD:jetpack(playerid, params[])
{
	new userid;

	if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "u", userid))
 	{
 	    PlayerData[playerid][pJetpack] = 1;
	 	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
	}
	else
	{
		PlayerData[userid][pJetpack] = 1;

		SetPlayerSpecialAction(userid, SPECIAL_ACTION_USEJETPACK);
		SendServerMessage(playerid, "You have spawned a jetpack for %s.", ReturnName(userid, 0));
	}
	return 1;
}


// ====== CMD:setweather ======
CMD:setweather(playerid, params[])
{
	new weatherid;

	if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", weatherid))
	    return SendSyntaxMessage(playerid, "/setweather [weather ID]");

	SetWeather(weatherid);
	SendServerMessage(playerid, "You have changed the weather to ID: %d.", weatherid);
	return 1;
}


// ====== CMD:vw ======
CMD:vw(playerid, params[]) {
	SendClientMessageEx(playerid, COLOR_CLIENT, "Current Virtual World: %d", GetPlayerVirtualWorld(playerid));

	return 1;
}


// ====== CMD:tduty ======
CMD:tduty(playerid, params[])
{
	if (!PlayerData[playerid][pTester])
	    return SendErrorMessage(playerid, "You are not a tester.");

	if (!PlayerData[playerid][pTesterDuty])
	{
		SetPlayerColor(playerid, 0xFF634700);

		PlayerData[playerid][pTesterDuty] = 1;
		SendClientMessageToAllEx(COLOR_LIGHTRED, "** %s is now on duty as a tester (/seekhelp for help).", ReturnName(playerid, 0));
	}
	else
	{
	    SetPlayerColor(playerid, DEFAULT_COLOR);

		PlayerData[playerid][pTesterDuty] = 0;
		SendServerMessage(playerid, "You are no longer on tester duty.");
	}
	return 1;
}


// ====== CMD:ah ======
CMD:ah(playerid, params[])
{
	new userid;

	if (!PlayerData[playerid][pTester])
	    return SendErrorMessage(playerid, "You are not a tester.");

	if (!PlayerData[playerid][pTesterDuty])
	    return SendErrorMessage(playerid, "You must be on tester duty to use this.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/ah [playerid/name]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	if (!PlayerData[userid][pSeekHelp])
	    return SendErrorMessage(playerid, "That player hasn't requested any help.");

	PlayerData[userid][pSeekHelp] = 0;

	SendServerMessage(userid, "%s has accepted your help request.", ReturnName(playerid, 0));
	SendTesterMessage(COLOR_LIGHTRED, "[TESTER]: %s has accepted %s's help request.", ReturnName(playerid, 0), ReturnName(userid, 0));
	return 1;
}


// ====== CMD:dh ======
CMD:dh(playerid, params[])
{
	new userid;

	if (!PlayerData[playerid][pTester])
	    return SendErrorMessage(playerid, "You are not a tester.");

	if (!PlayerData[playerid][pTesterDuty])
	    return SendErrorMessage(playerid, "You must be on tester duty to use this.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/dh [playerid/name]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	if (!PlayerData[userid][pSeekHelp])
	    return SendErrorMessage(playerid, "That player hasn't requested any help.");

	PlayerData[userid][pSeekHelp] = 0;

	SendServerMessage(userid, "%s has denied your help request.", ReturnName(playerid, 0));
	SendTesterMessage(COLOR_LIGHTRED, "[TESTER]: %s has denied %s's help request.", ReturnName(playerid, 0), ReturnName(userid, 0));
	return 1;
}


// ====== CMD:time ======
CMD:time(playerid, params[])
{
	static
	    string[128],
		month[12],
		date[6];

	getdate(date[2], date[1], date[0]);
	gettime(date[3], date[4], date[5]);

	switch (date[1]) {
	    case 1: month = "January";
	    case 2: month = "February";
	    case 3: month = "March";
	    case 4: month = "April";
	    case 5: month = "May";
	    case 6: month = "June";
	    case 7: month = "July";
	    case 8: month = "August";
	    case 9: month = "September";
	    case 10: month = "October";
	    case 11: month = "November";
	    case 12: month = "December";
	}
	format(string, sizeof(string), "%d/60 minutes until PayDay.",PlayerData[playerid][pMinutes]);
	SendClientMessage(playerid, COLOR_YELLOW, string);
	format(string, sizeof(string), "~g~%s %02d %d~n~~b~%02d:%02d:%02d", month, date[0], date[2], date[3], date[4], date[5]);
	GameTextForPlayer(playerid, string, 6000, 1);

	return 1;
}


// ====== CMD:healall ======
CMD:healall(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	foreach (new i : Player) {
	    SetPlayerHealth(i, 100.0);
	}
	SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has healed all players online.", ReturnName(playerid, 0));
	return 1;
}


// ====== CMD:saveall ======
CMD:saveall(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	foreach (new i : Player) {
		SQL_SaveCharacter(i);
	}
	SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has saved all players accounts.", ReturnName(playerid, 0));
	return 1;
}


// ====== CMD:ahide ======
CMD:ahide(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	switch (PlayerData[playerid][pAdminHide])
	{
	    case 0:
	    {
	        PlayerData[playerid][pAdminHide] = 1;
	        SendServerMessage(playerid, "You are now hidden from the admin list.");
		}
		case 1:
	    {
	        PlayerData[playerid][pAdminHide] = 0;
	        SendServerMessage(playerid, "You are now visible in the admin list.");
		}
	}
	return 1;
}

