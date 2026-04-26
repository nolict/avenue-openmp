/*
    File: modules/faction/commands/faction.pwn
    Purpose: Contains ZCMD command handlers for faction faction features.
    Notes: Keep command parsing here and delegate reusable gameplay work to logic files.
*/

// ====== CMD:callsign ======
CMD:callsign(playerid, params[])
{
    new vehicleid;
    vehicleid = GetPlayerVehicleID(playerid);
	new string[32];
	if(!IsPlayerInAnyVehicle(playerid)) return SendErrorMessage(playerid, "You're not in a vehicle.");
	if (GetFactionType(playerid) != FACTION_POLICE)
		return SendErrorMessage(playerid, "You must be a police officer.");
	if (!IsACruiser(GetPlayerVehicleID(playerid)))
	    return SendErrorMessage(playerid, "You must be inside a police cruiser.");
	if(vehiclecallsign[GetPlayerVehicleID(playerid)] == 1)
	{
 		Delete3DTextLabel(vehicle3Dtext[vehicleid]);
	    vehiclecallsign[vehicleid] = 0;
	    SendClientMessage(playerid, COLOR_RED, "Callsign removed.");
	    return 1;
	}
	if(sscanf(params, "s[32]",string)) return SendErrorMessage(playerid, "You must enter a callsign.");
	if(vehiclecallsign[GetPlayerVehicleID(playerid)] == 0)
	{
		vehicle3Dtext[vehicleid] = Create3DTextLabel(string, COLOR_WHITE, 0.0, 0.0, 0.0, 10.0, 0, 1);
		Attach3DTextLabelToVehicle(vehicle3Dtext[vehicleid], vehicleid, 0.0, -2.8, 0.0);
		vehiclecallsign[vehicleid] = 1;
	}
	return 1;
}



// ====== CMD:aremovecall ======
CMD:aremovecall(playerid, params[])
{
	new vehicleid;
	if (PlayerData[playerid][pAdmin] < 1)
		return SendErrorMessage(playerid, "You must be an administrator.");
	if(sscanf(params, "i", vehicleid)) return SendErrorMessage(playerid, "Must enter a vehicle ID.");
    if (vehicleid < 1 || vehicleid > MAX_VEHICLES || !IsValidVehicle(vehicleid))
		return SendErrorMessage(playerid, "You have specified an invalid vehicle ID.");
	Delete3DTextLabel(vehicle3Dtext[vehicleid]);
	return 1;
}









//


// ====== CMD:createfaction ======
CMD:createfaction(playerid, params[])
{
	static
	    id = -1,
		type,
		name[32];

    if (PlayerData[playerid][pAdmin] < 5 && !PlayerData[playerid][pFactionMod])
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "ds[32]", type, name))
	{
	    SendSyntaxMessage(playerid, "/createfaction [type] [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "TYPES: {FFFFFF}1: Police | 2: News | 3: Medical | 4: Government | 5: Gang");
		return 1;
	}
	if (type < 1 || type > 5)
	    return SendErrorMessage(playerid, "Invalid type specified. Types range from 1 to 5.");

	id = Faction_Create(name, type);

	if (id == -1)
	    return SendErrorMessage(playerid, "The server has reached the limit for factions.");

	SendServerMessage(playerid, "You have successfully created faction ID: %d.", id);
	return 1;
}


// ====== CMD:destroyfaction ======
CMD:destroyfaction(playerid, params[])
{
	static
	    id = 0;

    if (PlayerData[playerid][pAdmin] < 5 && !PlayerData[playerid][pFactionMod])
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/destroyfaction [faction id]");

	if ((id < 0 || id >= MAX_FACTIONS) || !FactionData[id][factionExists])
	    return SendErrorMessage(playerid, "You have specified an invalid faction ID.");

	Faction_Delete(id);
	SendServerMessage(playerid, "You have successfully destroyed faction ID: %d.", id);
	return 1;
}


// ====== CMD:open ======
CMD:open(playerid, params[])
{
	new id = Gate_Nearest(playerid);

	if (id != -1)
	{
		if (strlen(GateData[id][gatePass]))
		{
		    Dialog_Show(playerid, GatePass, DIALOG_STYLE_INPUT, DialogStyle_Title("Enter Password"), DialogStyle_Body("Please enter the password for this gate below:"), "Submit", "Cancel");
		}
		else
		{
		    if (GateData[id][gateFaction] != -1 && PlayerData[playerid][pFaction] != GetFactionByID(GateData[id][gateFaction]))
				return SendErrorMessage(playerid, "You can't open this gate.");

			Gate_Operate(id);

			switch (GateData[id][gateOpened])
			{
			    case 0:
				    ShowPlayerFooter(playerid, "You have ~r~closed~w~ the gate!");

                case 1:
				    ShowPlayerFooter(playerid, "You have ~g~opened~w~ the gate!");
			}
		}
	}
	else if (IsPlayerNearDynamicObject(playerid, PrisonData[prisonDoors][0]))
	{
	    if (GetFactionType(playerid) != FACTION_POLICE)
	        return SendErrorMessage(playerid, "You must be a police officer to open this door.");

	    if (!PrisonData[prisonDoorOpened][0])
		{
			SetDynamicObjectRot(PrisonData[prisonDoors][0], 0.0, 0.0, -90.0);

			PrisonData[prisonDoorOpened][0] = true;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes their key and opens the prison door.", ReturnName(playerid, 0));
		}
		else
		{
		    SetDynamicObjectRot(PrisonData[prisonDoors][0], 0.0, 0.0, 0.0);

			PrisonData[prisonDoorOpened][0] = false;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes their key and closes the prison door.", ReturnName(playerid, 0));
		}
	}
	else if (IsPlayerNearDynamicObject(playerid, PrisonData[prisonDoors][1]))
	{
	    if (GetFactionType(playerid) != FACTION_POLICE)
	        return SendErrorMessage(playerid, "You must be a police officer to open this door.");

	    if (!PrisonData[prisonDoorOpened][1])
		{
			SetDynamicObjectRot(PrisonData[prisonDoors][1], 0.0, 0.0, 0.0);

			PrisonData[prisonDoorOpened][1] = true;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes their key and opens the prison door.", ReturnName(playerid, 0));
		}
		else
		{
		    SetDynamicObjectRot(PrisonData[prisonDoors][1], 0.0, 0.0, 90.0);

			PrisonData[prisonDoorOpened][1] = false;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes their key and closes the prison door.", ReturnName(playerid, 0));
		}
	}
	else if (IsPlayerNearDynamicObject(playerid, PrisonData[prisonDoors][2]))
	{
	    if (GetFactionType(playerid) != FACTION_POLICE)
	        return SendErrorMessage(playerid, "You must be a police officer to open this door.");

	    if (!PrisonData[prisonDoorOpened][2])
		{
			SetDynamicObjectRot(PrisonData[prisonDoors][2], 0.0, 0.0, -90.0);

			PrisonData[prisonDoorOpened][2] = true;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes their key and opens the prison door.", ReturnName(playerid, 0));
		}
		else
		{
		    SetDynamicObjectRot(PrisonData[prisonDoors][2], 0.0, 0.0, 0.0);

			PrisonData[prisonDoorOpened][2] = false;
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes their key and closes the prison door.", ReturnName(playerid, 0));
		}
	}
	for (new i = 0; i < 24; i ++) if (IsPlayerNearDynamicObject(playerid, PrisonData[prisonCells][i], 3.0))
	{
	    if (GetFactionType(playerid) != FACTION_POLICE)
	        return SendErrorMessage(playerid, "You must be a police officer to open this cell.");

		if (!PrisonData[prisonCellOpened][i])
		{
			MoveDynamicObject(PrisonData[prisonCells][i], PrisonCells[i][0], PrisonCells[i][1] + 1.6, PrisonCells[i][2], 3.0);

		    PrisonData[prisonCellOpened][i] = true;
		    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes their key and opens the prison cell.", ReturnName(playerid, 0));
		}
		else
		{
		    MoveDynamicObject(PrisonData[prisonCells][i], PrisonCells[i][0], PrisonCells[i][1], PrisonCells[i][2], 3.0);

		    PrisonData[prisonCellOpened][i] = false;
		    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes their key and closes the prison cell.", ReturnName(playerid, 0));
		}
		break;
	}
	return 1;
}


// ====== CMD:drop ======
CMD:drop(playerid, params[])
{
	new weaponid = 0;

    if (IsPlayerInAnyVehicle(playerid) || !IsPlayerSpawned(playerid))
    	return SendErrorMessage(playerid, "You can't drop any weapons right now.");

	if ((weaponid = GetWeapon(playerid)) == 0)
	    return SendErrorMessage(playerid, "You can't drop a weapon unless you're holding one.");

	if (weaponid == 23 && PlayerData[playerid][pTazer])
	    return SendErrorMessage(playerid, "You can't drop a tazer.");

    if (weaponid == 25 && PlayerData[playerid][pBeanBag])
	    return SendErrorMessage(playerid, "You can't drop a beanbag shotgun.");

	static
	    Float:x,
	    Float:y,
	    Float:z,
		Float:angle;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);

	x += 1.5 * floatsin(-angle, degrees);
	y += 1.5 * floatcos(-angle, degrees);

    DropItem(ReturnWeaponName(weaponid), ReturnName(playerid, 0), GetWeaponModel(weaponid), 1, x, y, z - 1, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), weaponid, GetPlayerAmmo(playerid));
	ResetWeapon(playerid, weaponid);

    ApplyAnimation(playerid, "GRENADE", "WEAPON_throwu", 4.1, 0, 0, 0, 0, 0, 1);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out a %s and drops it on the floor.", ReturnName(playerid, 0), ReturnWeaponName(weaponid));
 	Log_Write("logs/droppick.txt", "[%s] %s has dropped a %s.", ReturnDate(), ReturnName(playerid, 0), ReturnWeaponName(weaponid));
	return 1;
}


// ====== CMD:flist ======
CMD:flist(playerid, params[])
{
	for (new i = 0; i != MAX_FACTIONS; i ++) if (FactionData[i][factionExists]) {
	    SendClientMessageEx(playerid, COLOR_WHITE, "[ID: %d] {%06x}%s", i, FactionData[i][factionColor] >>> 8, FactionData[i][factionName]);
	}
	return 1;
}


// ====== CMD:editfaction ======
CMD:editfaction(playerid, params[])
{
	static
	    id,
	    type[24],
	    string[128];

	if (PlayerData[playerid][pAdmin] < 5 && !PlayerData[playerid][pFactionMod])
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editfaction [id] [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "NAMES: {FFFFFF}name, color, type, models, locker, ranks, maxranks");
		return 1;
	}
	if ((id < 0 || id >= MAX_FACTIONS) || !FactionData[id][factionExists])
	    return SendErrorMessage(playerid, "You have specified an invalid faction ID.");

    if (!strcmp(type, "name", true))
	{
	    new name[32];

	    if (sscanf(string, "s[32]", name))
	        return SendSyntaxMessage(playerid, "/editfaction [id] [name] [new name]");

	    format(FactionData[id][factionName], 32, name);

	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "ADMIN: %s has adjusted the name of faction ID: %d to \"%s\".", ReturnName(playerid, 0), id, name);
	}
	else if (!strcmp(type, "maxranks", true))
	{
	    new ranks;

	    if (sscanf(string, "d", ranks))
	        return SendSyntaxMessage(playerid, "/editfaction [id] [maxranks] [maximum ranks]");

		if (ranks < 1 || ranks > 15)
		    return SendErrorMessage(playerid, "The specified ranks can't be below 1 or above 15.");

	    FactionData[id][factionRanks] = ranks;

	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "ADMIN: %s has adjusted the maximum ranks of faction ID: %d to %d.", ReturnName(playerid, 0), id, ranks);
	}
	else if (!strcmp(type, "ranks", true))
	{
	    Faction_ShowRanks(playerid, id);
	}
	else if (!strcmp(type, "color", true))
	{
	    new color;

	    if (sscanf(string, "h", color))
	        return SendSyntaxMessage(playerid, "/editfaction [id] [color] [hex color]");

	    FactionData[id][factionColor] = color;
	    Faction_Update(id);

	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "ADMIN: %s has adjusted the {%06x}color{FF6347} of faction ID: %d.", ReturnName(playerid, 0), color >>> 8, id);
	}
	else if (!strcmp(type, "type", true))
	{
	    new typeint;

	    if (sscanf(string, "d", typeint))
     	{
		 	SendSyntaxMessage(playerid, "/editfaction [id] [type] [faction type]");
            SendClientMessage(playerid, COLOR_YELLOW, "TYPES: {FFFFFF}1: Police | 2: News | 3: Medical | 4: Government | 5: Gang");
            return 1;
		}
		if (typeint < 1 || typeint > 5)
		    return SendErrorMessage(playerid, "Invalid type specified. Types range from 1 to 5.");

	    FactionData[id][factionType] = typeint;

	    Faction_Save(id);
		SendFactionAlert(COLOR_LIGHTRED, "ADMIN: %s has adjusted the type of faction ID: %d to %d.", ReturnName(playerid, 0), id, typeint);
	}
	else if (!strcmp(type, "models", true))
	{
	    static
	        skins[8];

		for (new i = 0; i < sizeof(skins); i ++)
		    skins[i] = (FactionData[id][factionSkins][i]) ? (FactionData[id][factionSkins][i]) : (19300);

	    PlayerData[playerid][pFactionEdit] = id;
		ShowModelSelectionMenu(playerid, "Faction Skins", MODEL_SELECTION_SKINS, skins, sizeof(skins), -16.0, 0.0, -55.0);
	}
	else if (!strcmp(type, "locker", true))
	{
        PlayerData[playerid][pFactionEdit] = id;
		Dialog_Show(playerid, FactionLocker, DIALOG_STYLE_LIST, DialogStyle_Title("Faction Locker"), DialogStyle_Body("Set Location\nLocker Weapons"), "Select", "Cancel");
	}
	return 1;
}


// ====== CMD:color ======
CMD:color(playerid, params[])
{
	static
	    color;

	if (sscanf(params, "h", color)) {
	 	SendSyntaxMessage(playerid, "/color [hex color]");
	    SendClientMessage(playerid, COLOR_YELLOW, "EXAMPLE: {FFFFFF}0xFFFFFFFF is white, 0xFF0000FF is red, etc.");
	}
	else {
	    SendClientMessageEx(playerid, color, "This is a test message, testing color 0x%06xFF.", color >>> 8);
	}
	return 1;
}


// ====== CMD:flocker ======
CMD:flocker(playerid, params[])
{
	new factionid = PlayerData[playerid][pFaction];

 	if (factionid == -1)
	    return SendErrorMessage(playerid, "You must be a faction member.");

	if (!IsNearFactionLocker(playerid))
	    return SendErrorMessage(playerid, "You are not in range of your faction's locker.");

 	if (FactionData[factionid][factionType] != FACTION_GANG)
		Dialog_Show(playerid, Locker, DIALOG_STYLE_LIST, DialogStyle_Title("Faction Locker"), DialogStyle_Body("Toggle Duty\nArmored Vest\nLocker Skins\nLocker Weapons"), "Select", "Cancel");

	else Dialog_Show(playerid, Locker, DIALOG_STYLE_LIST, DialogStyle_Title("Faction Locker"), DialogStyle_Body("Locker Skins\nLocker Weapons"), "Select", "Cancel");
	return 1;
}


// ====== CMD:setleader ======
CMD:setleader(playerid, params[])
{
	static
		userid,
		id;

    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "ud", userid, id))
	    return SendSyntaxMessage(playerid, "/setleader [playerid/name] [faction id] (Use -1 to unset)");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

    if ((id < -1 || id >= MAX_FACTIONS) || (id != -1 && !FactionData[id][factionExists]))
	    return SendErrorMessage(playerid, "You have specified an invalid faction ID.");

	if (id == -1)
	{
	    ResetFaction(userid);

	    SendServerMessage(playerid, "You have removed %s's faction leadership.", ReturnName(userid, 0));
    	SendServerMessage(userid, "%s has removed your faction leadership.", ReturnName(playerid, 0));
	}
	else
	{
		SetFaction(userid, id);
		PlayerData[userid][pFactionRank] = FactionData[id][factionRanks];

		SendServerMessage(playerid, "You have made %s the leader of \"%s\".", ReturnName(userid, 0), FactionData[id][factionName]);
    	SendServerMessage(userid, "%s has made you the leader of \"%s\".", ReturnName(playerid, 0), FactionData[id][factionName]);
	}
    return 1;
}


// ====== CMD:asetfaction ======
CMD:asetfaction(playerid, params[])
{
	static
		userid,
		id;

    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "ud", userid, id))
	    return SendSyntaxMessage(playerid, "/asetfaction [playerid/name] [faction id] (Use -1 to unset)");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

    if ((id < -1 || id >= MAX_FACTIONS) || (id != -1 && !FactionData[id][factionExists]))
	    return SendErrorMessage(playerid, "You have specified an invalid faction ID.");

	if (id == -1)
	{
	    ResetFaction(userid);

	    SendServerMessage(playerid, "You have removed %s from their faction.", ReturnName(userid, 0));
    	SendServerMessage(userid, "%s has removed you from your faction.", ReturnName(playerid, 0));
	}
	else
	{
		SetFaction(userid, id);

		if (!PlayerData[userid][pFactionRank])
	    	PlayerData[userid][pFactionRank] = 1;

		SendServerMessage(playerid, "You have set %s's faction to \"%s\".", ReturnName(userid, 0), FactionData[id][factionName]);
    	SendServerMessage(userid, "%s has set your faction to \"%s\".", ReturnName(playerid, 0), FactionData[id][factionName]);
	}
    return 1;
}


// ====== CMD:asetrank ======
CMD:asetrank(playerid, params[])
{
	static
		userid,
		rank,
		factionid;

    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "ud", userid, rank))
	    return SendSyntaxMessage(playerid, "/asetrank [playerid/name] [rank id]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	if ((factionid = PlayerData[userid][pFaction]) == -1)
	    return SendErrorMessage(playerid, "That player is not a member of any faction.");

    if (rank < 1 || rank > FactionData[factionid][factionRanks])
        return SendErrorMessage(playerid, "Invalid rank. Ranks for this faction range from 1 to %d.", FactionData[factionid][factionRanks]);

	PlayerData[userid][pFactionRank] = rank;

	SendServerMessage(playerid, "You have set %s's faction rank to %d.", ReturnName(userid, 0), rank);
    SendServerMessage(userid, "%s has set your faction rank to %d.", ReturnName(playerid, 0), rank);

    return 1;
}


// ====== CMD:fac ======
CMD:fac(playerid, params[])
{
    new factionid = PlayerData[playerid][pFaction];

 	if (factionid == -1)
	    return SendErrorMessage(playerid, "You must be a faction member.");

	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/(f)ac [message]");

    if (PlayerData[playerid][pDisableFaction])
	    return SendErrorMessage(playerid, "You must enable faction chat first.");

	SendFactionMessage(factionid, COLOR_FACTION, "(( (%d) %s %s: %s ))", PlayerData[playerid][pFactionRank], Faction_GetRank(playerid), ReturnName(playerid, 0), params);
	Log_Write("logs/faction_chat.txt", "[%s] %s %s: %s", ReturnDate(), Faction_GetRank(playerid), ReturnName(playerid, 0), params);
	return 1;
}


// ====== CMD:fquit ======
CMD:fquit(playerid, params[])
{
	if (PlayerData[playerid][pFaction] == -1)
	    return SendErrorMessage(playerid, "You must be a faction member.");

	if (GetFactionType(playerid) == FACTION_POLICE)
	{
	    SetPlayerArmour(playerid, 0);
	    ResetWeapons(playerid);
	}
	SendServerMessage(playerid, "You have quit the \"%s\" faction (rank %d).", Faction_GetName(playerid), PlayerData[playerid][pFactionRank]);
    ResetFaction(playerid);

    return 1;
}


// ====== CMD:finvite ======
CMD:finvite(playerid, params[])
{
	new
	    userid;

	if (PlayerData[playerid][pFaction] == -1)
	    return SendErrorMessage(playerid, "You must be a faction member.");

	if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "You must be at least rank %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/finvite [playerid/name]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "That player is disconnected.");

	if (PlayerData[userid][pFaction] == PlayerData[playerid][pFaction])
	    return SendErrorMessage(playerid, "That player is already part of your faction.");

    if (PlayerData[userid][pFaction] != -1)
	    return SendErrorMessage(playerid, "That player is already part of another faction.");

	PlayerData[userid][pFactionOffer] = playerid;
    PlayerData[userid][pFactionOffered] = PlayerData[playerid][pFaction];

    SendServerMessage(playerid, "You have requested %s to join \"%s\".", ReturnName(userid, 0), Faction_GetName(playerid));
    SendServerMessage(userid, "%s has offered you to join \"%s\" (type \"/approve faction\").", ReturnName(playerid, 0), Faction_GetName(playerid));

	return 1;
}


// ====== CMD:fremove ======
CMD:fremove(playerid, params[])
{
    new
	    userid;

	if (PlayerData[playerid][pFaction] == -1)
	    return SendErrorMessage(playerid, "You must be a faction member.");

	if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "You must be at least rank %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/fremove [playerid/name]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "That player is disconnected.");

	if (PlayerData[userid][pFaction] != PlayerData[playerid][pFaction])
	    return SendErrorMessage(playerid, "That player is not part of your faction.");

    SendServerMessage(playerid, "You have removed %s from \"%s\".", ReturnName(userid, 0), Faction_GetName(playerid));
    SendServerMessage(userid, "%s has removed you from the \"%s\" faction.", ReturnName(playerid, 0), Faction_GetName(playerid));

    ResetFaction(userid);

	return 1;
}


// ====== CMD:frank ======
CMD:frank(playerid, params[])
{
    new
	    userid,
		rankid;

	if (PlayerData[playerid][pFaction] == -1)
	    return SendErrorMessage(playerid, "You must be a faction member.");

	if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "You must be at least rank %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);

	if (sscanf(params, "ud", userid, rankid))
	    return SendSyntaxMessage(playerid, "/frank [playerid/name] [rank (1-%d)]", FactionData[PlayerData[playerid][pFaction]][factionRanks]);

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "That player is disconnected.");

	if (userid == playerid)
	    return SendErrorMessage(playerid, "You cannot set your own rank.");

	if (PlayerData[userid][pFaction] != PlayerData[playerid][pFaction])
	    return SendErrorMessage(playerid, "That player is not part of your faction.");

	if (rankid < 0 || rankid > FactionData[PlayerData[playerid][pFaction]][factionRanks])
	    return SendErrorMessage(playerid, "Invalid rank specified. Ranks range from 1 to %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks]);

	PlayerData[userid][pFactionRank] = rankid;

    SendServerMessage(playerid, "You have promoted %s to %s (%d).", ReturnName(userid, 0), Faction_GetRank(userid), rankid);
    SendServerMessage(userid, "%s has promoted you to %s (%d).", ReturnName(playerid, 0), Faction_GetRank(userid), rankid);

	return 1;
}


// ====== CMD:spawnpoint ======
CMD:spawnpoint(playerid, params[])
{
	new point;
	if(sscanf(params, "i", point)) return SendErrorMessage(playerid, "/spawnpoint [0-2] (0 = Airport, 1 = Faction, 2 = Last logged)");
	if(point == 0)
	{
	    SendClientMessage(playerid, COLOR_WHITE, "You've changed your spawn point to airport.");
		PlayerData[playerid][pSpawnPoint] = 0;
		return 1;
	}
	if(point == 1)
	{
	    if(PlayerData[playerid][pFactionID] == -1)
	    {
	        SendErrorMessage(playerid, "You're not apart of a faction.");
	        return 1;
		}
		SendClientMessage(playerid, COLOR_WHITE, "You've changed your spawn to faction.");
		PlayerData[playerid][pSpawnPoint] = 1;
		return 1;
	}
	if(point == 2)
	{
	    SendClientMessage(playerid, COLOR_WHITE, "You've changed your spawn to your last logged off.");
		PlayerData[playerid][pSpawnPoint] = 2;
		return 1;
	}
	return 1;
}

// ====== CMD:fspawn ======
CMD:fspawn(playerid, params[])
{
	new faction = PlayerData[playerid][pFactionID];

	if (PlayerData[playerid][pFaction] == -1)
	    return SendErrorMessage(playerid, "You must be a faction leader.");

	if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "You must be at least rank %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	FactionData[faction][SpawnX] = X;
	FactionData[faction][SpawnY] = Y;
	FactionData[faction][SpawnZ] = Z;
	FactionData[faction][SpawnInterior] = GetPlayerInterior(playerid);
	FactionData[faction][SpawnVW] = GetPlayerVirtualWorld(playerid);
	Faction_Save(faction);
	return 1;
}


// ====== CMD:tazer ======
CMD:tazer(playerid, params[])
{
	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || !IsPlayerSpawned(playerid))
	    return SendErrorMessage(playerid, "You can't use this command right now.");

	if (GetFactionType(playerid) != FACTION_POLICE)
		return SendErrorMessage(playerid, "You must be a police officer.");

	if (!PlayerData[playerid][pTazer])
	{
	    PlayerData[playerid][pTazer] = 1;
	    GetPlayerWeaponData(playerid, 2, PlayerData[playerid][pGuns][2], PlayerData[playerid][pAmmo][2]);

		GivePlayerWeapon(playerid, 23, 20000);
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out a tazer from their holster.", ReturnName(playerid, 0));
	}
	else
	{
	    PlayerData[playerid][pTazer] = 0;
		SetWeapons(playerid);

		SetPlayerArmedWeapon(playerid, PlayerData[playerid][pGuns][2]);
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s puts their tazer into their holster.", ReturnName(playerid, 0));
	}
	return 1;
}


// ====== CMD:beanbag ======
CMD:beanbag(playerid, params[])
{
	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT || !IsPlayerSpawned(playerid))
	    return SendErrorMessage(playerid, "You can't use this command right now.");

	if (GetFactionType(playerid) != FACTION_POLICE)
		return SendErrorMessage(playerid, "You must be a police officer.");

	if (!PlayerData[playerid][pBeanBag])
	{
	    PlayerData[playerid][pBeanBag] = 1;
	    GetPlayerWeaponData(playerid, 3, PlayerData[playerid][pGuns][3], PlayerData[playerid][pAmmo][3]);

		GivePlayerWeapon(playerid, 25, 20000);
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out a beanbag shotgun.", ReturnName(playerid, 0));
	}
	else
	{
	    PlayerData[playerid][pBeanBag] = 0;
		SetWeapons(playerid);

		SetPlayerArmedWeapon(playerid, PlayerData[playerid][pGuns][3]);
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s puts their beanbag shotgun away.", ReturnName(playerid, 0));
	}
	return 1;
}


// ====== CMD:cuff ======
CMD:cuff(playerid, params[])
{
    new
	    userid;

	if (GetFactionType(playerid) != FACTION_POLICE)
		return SendErrorMessage(playerid, "You must be a police officer.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/cuff [playerid/name]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "That player is disconnected.");

    if (userid == playerid)
	    return SendErrorMessage(playerid, "You cannot handcuff yourself.");

	if (!IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "You must be near this player.");

    if (PlayerData[userid][pStunned] < 0 && GetPlayerSpecialAction(userid) != SPECIAL_ACTION_HANDSUP && !IsPlayerIdle(userid))
	    return SendErrorMessage(playerid, "The player must be idle or stunned.");

	if (GetPlayerState(userid) != PLAYER_STATE_ONFOOT)
	    return SendErrorMessage(playerid, "The player must be onfoot before you can cuff them.");

    if (PlayerData[userid][pCuffed])
        return SendErrorMessage(playerid, "The player is already cuffed at the moment.");

	static
	    string[64];

	if (PlayerData[userid][pDrinking])
	{
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

		DestroyPlayerProgressBar(playerid, PlayerData[playerid][pDrinkBar]);
		PlayerData[userid][pDrinking] = 0;
	}
	if (PlayerData[userid][pHoldWeapon] > 0)
	{
	    HoldWeapon(userid, 0);
	}
    PlayerData[userid][pCuffed] = 1;
    SetPlayerSpecialAction(userid, SPECIAL_ACTION_CUFFED);

	format(string, sizeof(string), "You've been ~r~cuffed~w~ by %s.", ReturnName(playerid, 0));
    ShowPlayerFooter(userid, string);

    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s tightens a pair of handcuffs on %s's wrists.", ReturnName(playerid, 0), ReturnName(userid, 0));
    return 1;
}


// ====== CMD:uncuff ======
CMD:uncuff(playerid, params[])
{
    new
	    userid;

	if (GetFactionType(playerid) != FACTION_POLICE)
		return SendErrorMessage(playerid, "You must be a police officer.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/uncuff [playerid/name]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "That player is disconnected.");

    if (userid == playerid)
	    return SendErrorMessage(playerid, "You cannot uncuff yourself.");

    if (!IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "You must be near this player.");

    if (!PlayerData[userid][pCuffed])
        return SendErrorMessage(playerid, "The player is not cuffed at the moment.");

	static
	    string[64];

    PlayerData[userid][pCuffed] = 0;
    SetPlayerSpecialAction(userid, SPECIAL_ACTION_NONE);

	format(string, sizeof(string), "You've been ~g~uncuffed~w~ by %s.", ReturnName(playerid, 0));
    ShowPlayerFooter(userid, string);

    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s loosens the pair of handcuffs on %s's wrists.", ReturnName(playerid, 0), ReturnName(userid, 0));
    return 1;
}


// ====== CMD:drag ======
CMD:drag(playerid, params[])
{
	new
	    userid;

    if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/drag [playerid/name]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "That player is disconnected.");

    if (userid == playerid)
	    return SendErrorMessage(playerid, "You cannot drag yourself.");

	if (!IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "You must be near this player.");

    if (!PlayerData[userid][pCuffed] && !PlayerData[userid][pStunned])
        return SendErrorMessage(playerid, "The player is not cuffed or stunned.");

	if (PlayerData[userid][pDragged])
	{
	    PlayerData[userid][pDragged] = 0;
	    PlayerData[userid][pDraggedBy] = INVALID_PLAYER_ID;

	    KillTimer(PlayerData[userid][pDragTimer]);
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s releases %s from their grip.", ReturnName(playerid, 0), ReturnName(userid, 0));
	}
	else
	{
	    PlayerData[userid][pDragged] = 1;
	    PlayerData[userid][pDraggedBy] = playerid;

	    PlayerData[userid][pDragTimer] = SetTimerEx("DragUpdate", 200, true, "dd", playerid, userid);
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s grabs %s and starts dragging them.", ReturnName(playerid, 0), ReturnName(userid, 0));
	}
	return 1;
}


// ====== CMD:detain ======
CMD:detain(playerid, params[])
{
	new
		userid,
		vehicleid = GetNearestVehicle(playerid);

	if (GetFactionType(playerid) != FACTION_POLICE)
		return SendErrorMessage(playerid, "You must be a police officer.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/detain [playerid/name]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "That player is disconnected.");

    if (userid == playerid)
	    return SendErrorMessage(playerid, "You cannot detained yourself.");

    if (!IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "You must be near this player.");

    if (!PlayerData[userid][pCuffed])
        return SendErrorMessage(playerid, "The player is not cuffed at the moment.");

	if (vehicleid == INVALID_VEHICLE_ID)
	    return SendErrorMessage(playerid, "You are not near any vehicle.");

	if (GetVehicleMaxSeats(vehicleid) < 2)
  	    return SendErrorMessage(playerid, "You can't detain that player in this vehicle.");

	if (IsPlayerInVehicle(userid, vehicleid))
	{
		TogglePlayerControllable(userid, 1);

		RemoveFromVehicle(userid);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s opens the door and pulls %s out the vehicle.", ReturnName(playerid, 0), ReturnName(userid, 0));
	}
	else
	{
		new seatid = GetAvailableSeat(vehicleid, 2);

		if (seatid == -1)
		    return SendErrorMessage(playerid, "There are no more seats remaining.");

		new
		    string[64];

		format(string, sizeof(string), "You've been ~r~detained~w~ by %s.", ReturnName(playerid, 0));
		TogglePlayerControllable(userid, 0);

		StopDragging(userid);
		PutPlayerInVehicle(userid, vehicleid, seatid);

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s opens the door and places %s into the vehicle.", ReturnName(playerid, 0), ReturnName(userid, 0));
		ShowPlayerFooter(userid, string);
	}
	return 1;
}


// ====== CMD:createarrest ======
CMD:createarrest(playerid, params[])
{
	static
	    id = -1,
		Float:x,
		Float:y,
		Float:z;

	GetPlayerPos(playerid, x, y, z);

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	id = Arrest_Create(x, y, z, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));

	if (id == -1)
	    return SendErrorMessage(playerid, "The server has reached the limit for arrest points.");

	SendServerMessage(playerid, "You have successfully created arrest point ID: %d.", id);
	return 1;
}


// ====== CMD:destroyarrest ======
CMD:destroyarrest(playerid, params[])
{
	static
	    id = 0;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/destroyarrest [point id]");

	if ((id < 0 || id >= MAX_ARREST_POINTS) || !ArrestData[id][arrestExists])
	    return SendErrorMessage(playerid, "You have specified an invalid arrest point ID.");

	Arrest_Delete(id);
	SendServerMessage(playerid, "You have successfully destroyed arrest point ID: %d.", id);
	return 1;
}


// ====== CMD:mdc ======
CMD:mdc(playerid, params[])
{
    if (GetFactionType(playerid) != FACTION_POLICE)
		return SendErrorMessage(playerid, "You must be a police officer.");

	if (!IsACruiser(GetPlayerVehicleID(playerid)))
	    return SendErrorMessage(playerid, "You must be inside a police cruiser.");

	Dialog_Show(playerid, MainMDC, DIALOG_STYLE_LIST, DialogStyle_Title("Mobile Data Computer"), DialogStyle_Body("Active Warrants\nPlace Charges\nView Charges"), "Select", "Cancel");
	return 1;
}


// ====== CMD:arrest ======
CMD:arrest(playerid, params[])
{
	static
	    userid,
		time;

    if (GetFactionType(playerid) != FACTION_POLICE)
		return SendErrorMessage(playerid, "You must be a police officer.");

	if (sscanf(params, "ud", userid, time))
	    return SendSyntaxMessage(playerid, "/arrest [playerid/name] [minutes]");

	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "The player is disconnected or not near you.");

	if (time < 1 || time > 120)
	    return SendErrorMessage(playerid, "The specified time can't be below 1 or above 120.");

	if (!PlayerData[userid][pCuffed])
	    return SendErrorMessage(playerid, "The player must be cuffed before an arrest is made.");

	if (!IsPlayerNearArrest(playerid))
	    return SendErrorMessage(playerid, "You must be near an arrest point.");

	PlayerData[userid][pPrisoned] = 1;
	PlayerData[userid][pJailTime] = time * 60;

	StopDragging(userid);
	SetPlayerInPrison(userid);

	ResetWeapons(userid);
	ResetPlayer(userid);

	PlayerData[userid][pWarrants] = 0;
	PlayerData[userid][pCuffed] = 0;

	PlayerTextDrawShow(userid, PlayerData[userid][pTextdraws][70]);
    SetPlayerSpecialAction(userid, SPECIAL_ACTION_NONE);

    SendClientMessageToAllEx(COLOR_LIGHTRED, "PRISON: %s was imprisoned for %d days at San Andreas Prison.", ReturnName(userid, 0), time);
    return 1;
}


// ====== CMD:seizeplant ======
CMD:seizeplant(playerid, params[])
{
	static
	    plantid;

    if (GetFactionType(playerid) != FACTION_POLICE)
		return SendErrorMessage(playerid, "You must be a police officer.");

	if ((plantid = Plant_Nearest(playerid)) == -1)
	    return SendErrorMessage(playerid, "You are not standing near any drug plant.");

	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has seized a %s plant weighing %d grams.", ReturnName(playerid, 0), Plant_GetType(PlantData[plantid][plantType]), PlantData[plantid][plantDrugs]);
	Plant_Delete(plantid);
	return 1;
}


// ====== CMD:giveup ======
CMD:giveup(playerid, params[])
{
	if (!PlayerData[playerid][pInjured])
	    return SendErrorMessage(playerid, "You are not injured at the moment.");

	SetPlayerHealth(playerid, 0.0);
	SendServerMessage(playerid, "You have given up and accepted your death.");
	return 1;
}


// ====== CMD:loadinjured ======
CMD:loadinjured(playerid, params[])
{
	static
	    userid,
		seatid;

	if (GetFactionType(playerid) != FACTION_MEDIC)
	    return SendErrorMessage(playerid, "You must be part of a medical faction.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/loadinjured [playerid/name]");

	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 10.0))
	    return SendErrorMessage(playerid, "That player is disconnected or not near you.");

	if (userid == playerid)
	    return SendErrorMessage(playerid, "You can't load yourself into an ambulance.");

	if (!PlayerData[userid][pInjured])
	    return SendErrorMessage(playerid, "That player is not injured.");

	for (new i = 0; i != MAX_VEHICLES; i ++) if (IsPlayerNearBoot(playerid, i) && GetVehicleModel(i) == 416)
	{
	    seatid = GetAvailableSeat(i, 2);

	    if (seatid == -1)
	        return SendErrorMessage(playerid, "There is no room for the patient.");

		ClearAnimations(userid);
		PlayerData[userid][pInjured] = 2;

		PutPlayerInVehicle(userid, i, seatid);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s opens up the ambulance and loads %s on the stretcher.", ReturnName(playerid, 0), ReturnName(userid, 0));

		TogglePlayerControllable(userid, 0);
		SetPlayerHealth(userid, 100.0);
		return 1;
	}
	SendErrorMessage(playerid, "You must be near an ambulance.");
	return 1;
}


// ====== CMD:dropinjured ======
CMD:dropinjured(playerid, params[])
{
	static
	    userid;

    if (GetFactionType(playerid) != FACTION_MEDIC)
	    return SendErrorMessage(playerid, "You must be part of a medical faction.");

    if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/dropinjured [playerid/name]");

	if (userid == INVALID_PLAYER_ID || !IsPlayerInVehicle(playerid, GetPlayerVehicleID(playerid)))
	    return SendErrorMessage(playerid, "That player is disconnected or not near you.");

	if (userid == playerid)
	    return SendErrorMessage(playerid, "You can't deliver yourself to the hospital.");

	if (!PlayerData[userid][pInjured])
	    return SendErrorMessage(playerid, "That player is not injured.");

	for (new i = 0; i < sizeof(arrHospitalDeliver); i ++) if (IsPlayerInRangeOfPoint(playerid, 5.0, arrHospitalDeliver[i][0], arrHospitalDeliver[i][1], arrHospitalDeliver[i][2]))
	{
	    ClearAnimations(userid);

	    SetPlayerInterior(userid, 3);
	    SendServerMessage(playerid, "You have delivered %s to the hospital.", ReturnName(userid, 0));

	    SetPlayerPos(userid, -204.5867, -1740.7955, 675.7687);
    	SetPlayerFacingAngle(userid, 0.0000);

		TogglePlayerControllable(userid, 1);
  		SetCameraBehindPlayer(userid);

		SetPlayerVirtualWorld(userid, i + 5000);
  		PlayerData[userid][pHospitalInt] = i;

	  	PlayerData[userid][pHospital] = -1;
    	PlayerData[userid][pHospitalTime] = 0;

    	SendServerMessage(userid, "You have recovered at the nearest hospital.");

		GameTextForPlayer(userid, " ", 1, 3);
  		ShowHungerTextdraw(userid, 1);

  		PlayerData[userid][pInjured] = 0;
		TextDrawHideForPlayer(userid, gServerTextdraws[2]);
		return 1;
	}
	SendErrorMessage(playerid, "You must be near a hospital deliver location.");
	return 1;
}


// ====== CMD:m ======
CMD:m(playerid, params[])
{
	if (GetFactionType(playerid) != FACTION_POLICE && GetFactionType(playerid) != FACTION_MEDIC)
	    return SendErrorMessage(playerid, "You can't use the megaphone.");

	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/(m)egaphone [message]");

	if (strlen(params) > 64) {
	    SendNearbyMessage(playerid, 30.0, COLOR_YELLOW, "(Megaphone) %s says: %.64s", ReturnName(playerid, 0), params);
	    SendNearbyMessage(playerid, 30.0, COLOR_YELLOW, "...%s", params[64]);
	}
	else {
	    SendNearbyMessage(playerid, 30.0, COLOR_YELLOW, "(Megaphone) %s says: %s", ReturnName(playerid, 0), params);
	}
	return 1;
}


// ====== CMD:bandage ======
CMD:bandage(playerid, params[])
{
    static
	    userid;

	if (GetFactionType(playerid) != FACTION_MEDIC)
	    return SendErrorMessage(playerid, "You must be part of a medical faction.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/bandage [playerid/name]");

	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 6.0))
	    return SendErrorMessage(playerid, "That player is disconnected or not near you.");

	if (userid == playerid)
	    return SendErrorMessage(playerid, "You can't use this command for yourself.");

	if (PlayerData[userid][pFirstAid])
	    return SendErrorMessage(playerid, "That player is already being bandaged.");

    if (ReturnHealth(userid) > 99)
	    return SendErrorMessage(playerid, "That player doesn't need to be bandaged.");

    PlayerData[userid][pFirstAid] = true;
    PlayerData[userid][pAidTimer] = SetTimerEx("FirstAidUpdate", 1000, true, "d", userid);

    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s opens a first aid kit and uses a bandage on %s.", ReturnName(playerid, 0), ReturnName(userid, 0));
    return 1;
}


// ====== CMD:broadcast ======
CMD:broadcast(playerid, params[])
{
	if (GetFactionType(playerid) != FACTION_NEWS)
		return SendErrorMessage(playerid, "You must be part of a news faction.");

	if (!IsNewsVehicle(GetPlayerVehicleID(playerid)))
	    return SendErrorMessage(playerid, "You must be inside a news van or chopper.");

	if (!PlayerData[playerid][pBroadcast])
	{
	    PlayerData[playerid][pBroadcast] = true;

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has started a news broadcast.", ReturnName(playerid, 0));
	    SendServerMessage(playerid, "You have started a news broadcast (use \"/bc [text]\" to broadcast).");
	}
	else
	{
	    PlayerData[playerid][pBroadcast] = false;

		foreach (new i : Player) if (PlayerData[i][pNewsGuest] == playerid) {
		    PlayerData[i][pNewsGuest] = INVALID_PLAYER_ID;
		}
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stopped a news broadcast.", ReturnName(playerid, 0));
	    SendServerMessage(playerid, "You have stopped the news broadcast.");
	}
	return 1;
}


// ====== CMD:bc ======
CMD:bc(playerid, params[])
{
	if (GetFactionType(playerid) != FACTION_NEWS)
		return SendErrorMessage(playerid, "You must be part of a news faction.");

    if (isnull(params))
	    return SendSyntaxMessage(playerid, "/bc [broadcast text]");

	if (!IsNewsVehicle(GetPlayerVehicleID(playerid)))
	    return SendErrorMessage(playerid, "You must be inside a news van or chopper.");

	if (!PlayerData[playerid][pBroadcast])
	    return SendErrorMessage(playerid, "You must be broadcasting to use this command.");

	if (strlen(params) > 64) {
	    foreach (new i : Player) if (!PlayerData[i][pDisableBC]) {
		    SendClientMessageEx(i, COLOR_LIGHTGREEN, "NEWS: Reporter %s: %.64s", ReturnName(playerid, 0), params);
		    SendClientMessageEx(i, COLOR_LIGHTGREEN, "...%s", params[64]);
		}
	}
	else {
        foreach (new i : Player) if (!PlayerData[i][pDisableBC]) {
		    SendClientMessageEx(i, COLOR_LIGHTGREEN, "NEWS: Reporter %s: %s", ReturnName(playerid, 0), params);
		}
	}
	return 1;
}


// ====== CMD:factions ======
CMD:factions(playerid, params[])
{
	ViewFactions(playerid);
	return 1;
}

// ====== CMD:dept ======
CMD:dept(playerid, params[])
{
	if (GetFactionType(playerid) != FACTION_POLICE && GetFactionType(playerid) != FACTION_MEDIC && GetFactionType(playerid) != FACTION_GOV)
	    return SendErrorMessage(playerid, "You must be a civil service worker.");

	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/dept [department radio]");

	for (new i = 0; i != MAX_FACTIONS; i ++) if (FactionData[i][factionType] == FACTION_POLICE || FactionData[i][factionType] == FACTION_MEDIC || FactionData[i][factionType] == FACTION_GOV) {
		SendFactionMessage(i, COLOR_DEPARTMENT, "[%s] %s %s: %s", GetInitials(Faction_GetName(playerid)), Faction_GetRank(playerid), ReturnName(playerid, 0), params);
	}
	Log_Write("logs/faction_chat.txt", "[%s] [/dept] %s %s: %s", ReturnDate(), Faction_GetRank(playerid), ReturnName(playerid, 0), params);
	return 1;
}


// ====== CMD:ticket ======
CMD:ticket(playerid, params[])
{
	static
	    userid,
	    price,
	    reason[64];

	if (GetFactionType(playerid) != FACTION_POLICE)
		return SendErrorMessage(playerid, "You must be a police officer.");

	if (sscanf(params, "uds[64]", userid, price, reason))
		return SendSyntaxMessage(playerid, "/ticket [playerid/name] [price] [reason]");

	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "That player is disconnected or not near you.");

	if (userid == playerid)
	    return SendErrorMessage(playerid, "You can't write a ticket to yourself.");

	if (price < 1 || price > 1000)
	    return SendErrorMessage(playerid, "The price can't be below $1 or above $1,000.");

	new id = Ticket_Add(userid, price, reason);

	if (id != -1) {
	    SendServerMessage(playerid, "You have written %s a ticket for %s, reason: %s", ReturnName(userid, 0), FormatNumber(price), reason);
	    SendServerMessage(userid, "%s has written you a ticket for %s, reason: %s", ReturnName(playerid, 0), FormatNumber(price), reason);

	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has written up a ticket for%s.", ReturnName(playerid, 0), ReturnName(userid, 0));
	    Log_Write("logs/ticket_log.txt", "[%s] %s has written a %s ticket to %s, reason: %s", ReturnDate(), ReturnName(playerid, 0), FormatNumber(price), ReturnName(userid, 0), reason);
	}
	else {
	    SendErrorMessage(playerid, "That player already has %d outstanding tickets.", MAX_PLAYER_TICKETS);
	}
	return 1;
}


// ====== CMD:tickets ======
CMD:tickets(playerid, params[])
{
	static
	    string[MAX_PLAYER_TICKETS * 64];

	if (!IsPlayerInRangeOfPoint(playerid, 3.0, 361.2687, 171.5613, 1008.3828))
	    return SendErrorMessage(playerid, "You must be at city hall to pay your tickets.");

	string[0] = 0;

	for (new i = 0; i < MAX_PLAYER_TICKETS; i ++)
	{
	    if (TicketData[playerid][i][ticketExists])
	        format(string, sizeof(string), "%s%s (%s - %s)\n", string, TicketData[playerid][i][ticketReason], FormatNumber(TicketData[playerid][i][ticketFee]), TicketData[playerid][i][ticketDate]);

		else format(string, sizeof(string), "%sEmpty Slot\n", string);
	}
	return Dialog_Show(playerid, MyTickets, DIALOG_STYLE_LIST, DialogStyle_Title("My Tickets"), string, "Pay", "Cancel");
}


// ====== CMD:twithdraw ======
CMD:twithdraw(playerid, params[])
{
	static
	    amount;

	if (GetFactionType(playerid) != FACTION_GOV)
	    return SendErrorMessage(playerid, "You are not a government official.");

	if (sscanf(params, "d", amount))
		return SendSyntaxMessage(playerid, "/twithdraw [amount] (%s available)", FormatNumber(g_TaxVault));

	if (!IsPlayerInCityHall(playerid))
	    return SendErrorMessage(playerid, "You must be inside City Hall to do this.");

	if (amount < 1 || amount > g_TaxVault)
	    return SendErrorMessage(playerid, "Invalid amount specified.");

    if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "You must be at least rank %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);

	Tax_AddMoney(-amount);

	GiveMoney(playerid, amount);
	SendServerMessage(playerid, "You have withdrawn %s from the treasury (%s available).", FormatNumber(amount), FormatNumber(g_TaxVault));

	SendAdminAlert(COLOR_LIGHTRED, "ADMIN: %s has withdrawn %s from the treasury.", ReturnName(playerid, 0), FormatNumber(amount));
	Log_Write("logs/tax_vault.txt", "[%s] %s has withdrawn %s from the treasury.", ReturnDate(), ReturnName(playerid, 0), FormatNumber(amount));
	return 1;
}


// ====== CMD:tdeposit ======
CMD:tdeposit(playerid, params[])
{
	static
	    amount;

	if (GetFactionType(playerid) != FACTION_GOV)
	    return SendErrorMessage(playerid, "You are not a government official.");

	if (sscanf(params, "d", amount))
		return SendSyntaxMessage(playerid, "/tdeposit [amount] (%s available)", FormatNumber(g_TaxVault));

    if (!IsPlayerInCityHall(playerid))
	    return SendErrorMessage(playerid, "You must be inside City Hall to do this.");

	if (amount < 1 || amount > GetMoney(playerid))
	    return SendErrorMessage(playerid, "Invalid amount specified.");

	if (PlayerData[playerid][pFactionRank] < FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1)
	    return SendErrorMessage(playerid, "You must be at least rank %d.", FactionData[PlayerData[playerid][pFaction]][factionRanks] - 1);

	Tax_AddMoney(amount);

	GiveMoney(playerid, -amount);
	SendServerMessage(playerid, "You have deposited %s into the treasury (%s available).", FormatNumber(amount), FormatNumber(g_TaxVault));

	SendAdminAlert(COLOR_LIGHTRED, "ADMIN: %s has deposited %s into the treasury.", ReturnName(playerid, 0), FormatNumber(amount));
	Log_Write("logs/tax_vault.txt", "[%s] %s has deposited %s into the treasury.", ReturnDate(), ReturnName(playerid, 0), FormatNumber(amount));
	return 1;
}


// ====== CMD:spike ======
CMD:spike(playerid, params[])
{
	if (GetFactionType(playerid) != FACTION_POLICE)
	    return SendErrorMessage(playerid, "You are not a police officer.");

	if (isnull(params))
 	{
	 	SendSyntaxMessage(playerid, "/spike [option]");
	    SendClientMessage(playerid, COLOR_YELLOW, "OPTIONS: {FFFFFF}drop, destroy, destroyall");
		return 1;
	}
	static
        Float:fX,
        Float:fY,
        Float:fZ,
        Float:fA;

    GetPlayerPos(playerid, fX, fY, fZ);
    GetPlayerFacingAngle(playerid, fA);

	if (!strcmp(params, "drop", true))
	{
	    if (IsPlayerInAnyVehicle(playerid))
	        return SendErrorMessage(playerid, "You must exit the vehicle first.");

	    for (new i = 0; i != MAX_BARRICADES; i ++) if (!BarricadeData[i][cadeExists])
	    {
            BarricadeData[i][cadeExists] = true;
            BarricadeData[i][cadeType] = 1;

            BarricadeData[i][cadePos][0] = fX;
            BarricadeData[i][cadePos][1] = fY;
            BarricadeData[i][cadePos][2] = fZ;

            BarricadeData[i][cadeObject] = CreateDynamicObject(2899, fX, fY, fZ - 0.8, 0.0, 0.0, fA + 90.0);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has dropped a spikestrip.", ReturnName(playerid, 0));
			SendFactionMessage(PlayerData[playerid][pFaction], COLOR_RADIO, "RADIO: %s has dropped a spikestrip at %s.", ReturnName(playerid, 0), GetLocation(fX, fY, fZ));

			return 1;
		}
		SendErrorMessage(playerid, "The server has reached the limit for spikestrips.");
	}
	else if (!strcmp(params, "destroy", true))
	{
        for (new i = 0; i != MAX_BARRICADES; i ++) if (BarricadeData[i][cadeExists] && BarricadeData[i][cadeType] == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, BarricadeData[i][cadePos][0], BarricadeData[i][cadePos][1], BarricadeData[i][cadePos][2]))
	    {
            BarricadeData[i][cadeExists] = 0;
            BarricadeData[i][cadeType] = 0;

            DestroyDynamicObject(BarricadeData[i][cadeObject]);

            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has picked up a spikestrip.", ReturnName(playerid, 0));
			SendFactionMessage(PlayerData[playerid][pFaction], COLOR_RADIO, "RADIO: %s has picked up a spikestrip at %s.", ReturnName(playerid, 0), GetLocation(fX, fY, fZ));
			return 1;
		}
		SendErrorMessage(playerid, "You are not in range of any spikestrip.");
	}
	else if (!strcmp(params, "destroyall", true))
	{
        for (new i = 0; i != MAX_BARRICADES; i ++) if (BarricadeData[i][cadeExists] && BarricadeData[i][cadeType] == 1)
	    {
            BarricadeData[i][cadeExists] = 0;
            BarricadeData[i][cadeType] = 0;

			DestroyDynamicObject(BarricadeData[i][cadeObject]);
		}
		SendFactionMessage(PlayerData[playerid][pFaction], COLOR_RADIO, "RADIO: %s has destroyed all of the spikestrips.", ReturnName(playerid, 0));
	}
	return 1;
}


// ====== CMD:roadblock ======
CMD:roadblock(playerid, params[])
{
	if (GetFactionType(playerid) != FACTION_POLICE)
	    return SendErrorMessage(playerid, "You are not a police officer.");

	if (isnull(params))
 	{
	 	SendSyntaxMessage(playerid, "/roadblock [option]");
	    SendClientMessage(playerid, COLOR_YELLOW, "OPTIONS: {FFFFFF}drop, destroy, destroyall");
		return 1;
	}
	static
        Float:fX,
        Float:fY,
        Float:fZ,
        Float:fA;

    GetPlayerPos(playerid, fX, fY, fZ);
    GetPlayerFacingAngle(playerid, fA);

	if (!strcmp(params, "drop", true))
	{
	    if (IsPlayerInAnyVehicle(playerid))
	        return SendErrorMessage(playerid, "You must exit the vehicle first.");

	    for (new i = 0; i != MAX_BARRICADES; i ++) if (!BarricadeData[i][cadeExists])
	    {
            BarricadeData[i][cadeExists] = true;
            BarricadeData[i][cadeType] = 2;

            BarricadeData[i][cadePos][0] = fX;
            BarricadeData[i][cadePos][1] = fY;
            BarricadeData[i][cadePos][2] = fZ;

            BarricadeData[i][cadeObject] = CreateDynamicObject(981, fX, fY, fZ, 0.0, 0.0, fA);
            SetPlayerPos(playerid, fX + 2, fY + 2, fZ + 2);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has dropped a roadblock.", ReturnName(playerid, 0));
			SendFactionMessage(PlayerData[playerid][pFaction], COLOR_RADIO, "RADIO: %s has dropped a roadblock at %s.", ReturnName(playerid, 0), GetLocation(fX, fY, fZ));

			return 1;
		}
		SendErrorMessage(playerid, "The server has reached the limit for roadblock.");
	}
	else if (!strcmp(params, "destroy", true))
	{
        for (new i = 0; i != MAX_BARRICADES; i ++) if (BarricadeData[i][cadeExists] && BarricadeData[i][cadeType] == 2 && IsPlayerInRangeOfPoint(playerid, 5.0, BarricadeData[i][cadePos][0], BarricadeData[i][cadePos][1], BarricadeData[i][cadePos][2]))
	    {
            BarricadeData[i][cadeExists] = 0;
            BarricadeData[i][cadeType] = 0;

            DestroyDynamicObject(BarricadeData[i][cadeObject]);

            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has picked up a roadblock.", ReturnName(playerid, 0));
			SendFactionMessage(PlayerData[playerid][pFaction], COLOR_RADIO, "RADIO: %s has picked up a roadblock at %s.", ReturnName(playerid, 0), GetLocation(fX, fY, fZ));
			return 1;
		}
		SendErrorMessage(playerid, "You are not in range of any roadblock.");
	}
	else if (!strcmp(params, "destroyall", true))
	{
        for (new i = 0; i != MAX_BARRICADES; i ++) if (BarricadeData[i][cadeExists] && BarricadeData[i][cadeType] == 2)
	    {
            BarricadeData[i][cadeExists] = 0;
            BarricadeData[i][cadeType] = 0;

			DestroyDynamicObject(BarricadeData[i][cadeObject]);
		}
		SendFactionMessage(PlayerData[playerid][pFaction], COLOR_RADIO, "RADIO: %s has destroyed all of the roadblocks.", ReturnName(playerid, 0));
	}
	return 1;
}


// ====== CMD:creategate ======
CMD:creategate(playerid, params[])
{
	static
	    id = -1;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	id = Gate_Create(playerid);

	if (id == -1)
	    return SendErrorMessage(playerid, "The server has reached the limit for gates.");

	SendServerMessage(playerid, "You have successfully created gate ID: %d.", id);
	return 1;
}


// ====== CMD:destroygate ======
CMD:destroygate(playerid, params[])
{
	static
	    id = 0;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/destroygate [gate id]");

	if ((id < 0 || id >= MAX_GATES) || !GateData[id][gateExists])
	    return SendErrorMessage(playerid, "You have specified an invalid gate ID.");

	Gate_Delete(id);
	SendServerMessage(playerid, "You have successfully destroyed gate ID: %d.", id);
	return 1;
}


// ====== CMD:editgate ======
CMD:editgate(playerid, params[])
{
	static
	    id,
	    type[24],
	    string[128];

	if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editgate [id] [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "NAMES: {FFFFFF}location, speed, radius, time, model, pos, move, pass, linkid, faction");
		return 1;
	}
	if ((id < 0 || id >= MAX_GATES) || !GateData[id][gateExists])
	    return SendErrorMessage(playerid, "You have specified an invalid gate ID.");

    if (!strcmp(type, "location", true))
	{
		static
		    Float:x,
		    Float:y,
		    Float:z,
		    Float:angle;

		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);

		x += 3.0 * floatsin(-angle, degrees);
		y += 3.0 * floatcos(-angle, degrees);

		GateData[id][gatePos][0] = x;
		GateData[id][gatePos][1] = y;
		GateData[id][gatePos][2] = z;
		GateData[id][gatePos][3] = 0.0;
		GateData[id][gatePos][4] = 0.0;
		GateData[id][gatePos][5] = angle;

		SetDynamicObjectPos(GateData[id][gateObject], x, y, z);
		SetDynamicObjectRot(GateData[id][gateObject], 0.0, 0.0, angle);

		GateData[id][gateOpened] = false;

		Gate_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "ADMIN: %s has adjusted the position of gate ID: %d.", ReturnName(playerid, 0), id);
		return 1;
	}
	else if (!strcmp(type, "speed", true))
	{
	    static
	        Float:speed;

		if (sscanf(string, "f", speed))
		    return SendSyntaxMessage(playerid, "/editgate [id] [speed] [move speed]");

		if (speed < 0.0 || speed > 20.0)
		    return SendErrorMessage(playerid, "The specified speed can't be below 0 or above 20.");

        GateData[id][gateSpeed] = speed;

		Gate_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "ADMIN: %s has adjusted the speed of gate ID: %d to %.2f.", ReturnName(playerid, 0), id, speed);
		return 1;
	}
	else if (!strcmp(type, "radius", true))
	{
	    static
	        Float:radius;

		if (sscanf(string, "f", radius))
		    return SendSyntaxMessage(playerid, "/editgate [id] [radius] [open radius]");

		if (radius < 0.0 || radius > 20.0)
		    return SendErrorMessage(playerid, "The specified radius can't be below 0 or above 20.");

        GateData[id][gateRadius] = radius;

		Gate_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "ADMIN: %s has adjusted the radius of gate ID: %d to %.2f.", ReturnName(playerid, 0), id, radius);
		return 1;
	}
	else if (!strcmp(type, "time", true))
	{
	    static
	        time;

		if (sscanf(string, "d", time))
		    return SendSyntaxMessage(playerid, "/editgate [id] [time] [close time] (0 to disable)");

		if (time < 0 || time > 60000)
		    return SendErrorMessage(playerid, "The specified time can't be 0 or above 60,000 ms.");

        GateData[id][gateTime] = time;

		Gate_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "ADMIN: %s has adjusted the close time of gate ID: %d to %d.", ReturnName(playerid, 0), id, time);
		return 1;
	}
	else if (!strcmp(type, "model", true))
	{
	    static
	        model;

		if (sscanf(string, "d", model))
		    return SendSyntaxMessage(playerid, "/editgate [id] [model] [gate model]");

		if (!IsValidObjectModel(model))
		    return SendErrorMessage(playerid, "Invalid object model.");

        GateData[id][gateModel] = model;

		DestroyDynamicObject(GateData[id][gateObject]);
		GateData[id][gateObject] = CreateDynamicObject(GateData[id][gateModel], GateData[id][gatePos][0], GateData[id][gatePos][1], GateData[id][gatePos][2], GateData[id][gatePos][3], GateData[id][gatePos][4], GateData[id][gatePos][5], GateData[id][gateWorld], GateData[id][gateInterior]);

		Gate_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "ADMIN: %s has adjusted the model of gate ID: %d to %d.", ReturnName(playerid, 0), id, model);
		return 1;
	}
    else if (!strcmp(type, "pos", true))
	{
	    ResetEditing(playerid);
	   	EditDynamicObject(playerid, GateData[id][gateObject]);

		PlayerData[playerid][pEditGate] = id;
		PlayerData[playerid][pEditType] = 1;

		SendServerMessage(playerid, "You are now adjusting the position of gate ID: %d.", id);
		return 1;
	}
	else if (!strcmp(type, "move", true))
	{
	    ResetEditing(playerid);
	   	EditDynamicObject(playerid, GateData[id][gateObject]);

		PlayerData[playerid][pEditGate] = id;
		PlayerData[playerid][pEditType] = 2;

		SendServerMessage(playerid, "You are now adjusting the moving position of gate ID: %d.", id);
		return 1;
	}
	else if (!strcmp(type, "linkid", true))
	{
	    static
	        linkid = -1;

		if (sscanf(string, "d", linkid))
		    return SendSyntaxMessage(playerid, "/editgate [id] [linkid] [gate link] (-1 for none)");

        if ((linkid < -1 || linkid >= MAX_GATES) || (linkid != -1 && !GateData[linkid][gateExists]))
	    	return SendErrorMessage(playerid, "You have specified an invalid gate ID.");

        GateData[id][gateLinkID] = (linkid == -1) ? (-1) : (GateData[linkid][gateID]);
		Gate_Save(id);

		if (id == -1)
			SendAdminAlert(COLOR_LIGHTRED, "ADMIN: %s has adjusted the faction of gate ID: %d to no gate.", ReturnName(playerid, 0), id);

		else
		    SendAdminAlert(COLOR_LIGHTRED, "ADMIN: %s has adjusted the faction of gate ID: %d to ID: %d.", ReturnName(playerid, 0), id, linkid);

		return 1;
	}
	else if (!strcmp(type, "faction", true))
	{
	    static
	        factionid = -1;

		if (sscanf(string, "d", factionid))
		    return SendSyntaxMessage(playerid, "/editgate [id] [faction] [gate faction] (-1 for none)");

        if ((factionid < -1 || factionid >= MAX_FACTIONS) || (factionid != -1 && !FactionData[factionid][factionExists]))
	    	return SendErrorMessage(playerid, "You have specified an invalid faction ID.");

        GateData[id][gateFaction] = (factionid == -1) ? (-1) : (FactionData[factionid][factionID]);
		Gate_Save(id);

		if (factionid == -1)
			SendAdminAlert(COLOR_LIGHTRED, "ADMIN: %s has adjusted the faction of gate ID: %d to no faction.", ReturnName(playerid, 0), id);

		else
		    SendAdminAlert(COLOR_LIGHTRED, "ADMIN: %s has adjusted the faction of gate ID: %d to \"%s\".", ReturnName(playerid, 0), id, FactionData[factionid][factionName]);

		return 1;
	}
	else if (!strcmp(type, "pass", true))
	{
	    static
	        pass[32];

		if (sscanf(string, "s[32]", pass))
		    return SendSyntaxMessage(playerid, "/editgate [id] [pass] [gate password] (Use 'none' to disable)");

		if (!strcmp(params, "none", true))
			GateData[id][gatePass][0] = 0;

		else format(GateData[id][gatePass], 32, pass);

		Gate_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "ADMIN: %s has adjusted the password of gate ID: %d to %s.", ReturnName(playerid, 0), id, pass);
		return 1;
	}
	return 1;
}


// ====== CMD:fingerprint ======
CMD:fingerprint(playerid, params[])
{
    if (GetFactionType(playerid) != FACTION_POLICE)
		return SendErrorMessage(playerid, "You must be a police officer.");

	if (PlayerData[playerid][pFingerTime] > 0)
	    return SendErrorMessage(playerid, "You are already using the fingerprint scanner.");

    for (new i = 0; i != MAX_DROPPED_ITEMS; i ++) if (DroppedItems[i][droppedModel] && IsPlayerInRangeOfPoint(playerid, 1.5, DroppedItems[i][droppedPos][0], DroppedItems[i][droppedPos][1], DroppedItems[i][droppedPos][2])) {
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s runs the fingerprint scanner over the item.", ReturnName(playerid, 0));

        PlayerData[playerid][pFingerTime] = 3;
        PlayerData[playerid][pFingerItem] = i;

        return 1;
	}
	SendErrorMessage(playerid, "There is no item nearby.");
	return 1;
}


// ====== CMD:channel ======
CMD:channel(playerid, params[])
{
	new channel;

	if (!Inventory_HasItem(playerid, "Portable Radio"))
	    return SendErrorMessage(playerid, "You must have a portable radio.");

	if (sscanf(params, "d", channel))
 	{
	 	SendSyntaxMessage(playerid, "/channel [radio channel] (0 to disable)");

	 	if (PlayerData[playerid][pChannel] > 0)
			SendClientMessageEx(playerid, COLOR_YELLOW, "NOTE: {FFFFFF}Your current radio channel is set to %d.", PlayerData[playerid][pChannel]);

		return 1;
	}
	if (channel < 0 || channel > 999999)
	    return SendErrorMessage(playerid, "The channel can't be below 0 or above 999,999.");

	PlayerData[playerid][pChannel] = channel;

	if (channel == 0)
	    SendServerMessage(playerid, "You have disabled your portable radio.");

	else SendServerMessage(playerid, "You have set your radio's channel to %d (\"/pr [text]\" to chat).", channel);
	return 1;
}


// ====== CMD:r ======
CMD:r(playerid, params[])
{
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/r [Radio IC]");

    if (!Inventory_HasItem(playerid, "Portable Radio"))
	    return SendErrorMessage(playerid, "You must have a portable radio.");

	if (!PlayerData[playerid][pChannel])
	    return SendErrorMessage(playerid, "Your portable radio is disabled (/channel).");

	static
	    string[128];
	if(PlayerData[playerid][pChannel] == 911 && GetFactionType(playerid) != FACTION_POLICE) return SendErrorMessage(playerid, "This is police department's freqency only.");
	if (strlen(params) > 64)
	{
		format(string, sizeof(string), "** [RADIO: %d] %s: %.64s",PlayerData[playerid][pChannel],ReturnName(playerid, 0), params);
		SendRadioMessage(PlayerData[playerid][pChannel], COLOR_SERVER, string);
		format(string, sizeof(string), "...%s **",params[64]);
		SendRadioMessage(PlayerData[playerid][pChannel], COLOR_SERVER, string);
		//SendNearbyMessage(playerid, 5.0, COLOR_SERVER, "** (Radio) %s: %.64s", ReturnName(playerid, 0), params);
	    //SendNearbyMessage(playerid, 5.0, COLOR_SERVER, "...%s **", params[64]);
	}
	else {
		format(string, sizeof(string),"** [RADIO: %d] %s: %s **", PlayerData[playerid][pChannel],ReturnName(playerid, 0), params);
		SendRadioMessage(PlayerData[playerid][pChannel], COLOR_SERVER, string);
		//SendNearbyMessage(playerid, 5.0, COLOR_SERVER, "** (Radio) %s: %.64s", ReturnName(playerid, 0), params);
	}
	return 1;
}


// ====== CMD:breakcuffs ======
CMD:breakcuffs(playerid, params[])
{
	static
		userid;

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/breakcuffs [playerid/name]");

	if (!Inventory_HasItem(playerid, "Crowbar"))
	    return SendErrorMessage(playerid, "You don't have a crowbar.");

	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 6.0))
	    return SendErrorMessage(playerid, "The specified player is disconnected or not near you.");

	if (!PlayerData[userid][pCuffed])
	    return SendErrorMessage(playerid, "The specified player is not cuffed.");

	if (userid == playerid)
	    return SendErrorMessage(playerid, "You can't pick your own handcuffs.");

	SetTimerEx("BreakCuffs", 3000, false, "dd", playerid, userid);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s attempts to pick the cuffs with a crowbar.", ReturnName(playerid, 0));
	return 1;
}


// ====== CMD:setradio ======
CMD:setradio(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendErrorMessage(playerid, "You are not driving any vehicle.");

	if (!IsEngineVehicle(vehicleid))
	    return SendErrorMessage(playerid, "This vehicle doesn't have any radio.");

	Dialog_Show(playerid, Radio, DIALOG_STYLE_LIST, DialogStyle_Title("Radio Channels"), DialogStyle_Body("Cultural\nOldies\nOther\nPop\nRhythm & Blues\nRock\nTalk\nUrban\nElectric\nTurn Radio Off"), "Select", "Cancel");
	return 1;
}

