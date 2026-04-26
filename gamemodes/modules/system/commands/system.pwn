/*
    File: modules/system/commands/system.pwn
    Purpose: Contains ZCMD command handlers for system system features.
    Notes: Keep command parsing here and delegate reusable gameplay work to logic files.
*/

// ====== CMD:inventory ======
CMD:inventory(playerid, params[])
{
	if (PlayerData[playerid][pHospital] != -1 || PlayerData[playerid][pCuffed] || PlayerData[playerid][pInjured] || !IsPlayerSpawned(playerid))
	    return SendErrorMessage(playerid, "You can't open your inventory right now.");

	if (PlayerData[playerid][pJailTime] > 0)
		return SendErrorMessage(playerid, "You can't open your inventory whilst jailed.");

	OpenInventory(playerid);
	return 1;
}


// ====== CMD:ammo ======
CMD:ammo(playerid, params[])
{
    if (PlayerData[playerid][pHospital] != -1 || PlayerData[playerid][pCuffed] || PlayerData[playerid][pInjured] || !IsPlayerSpawned(playerid))
	    return SendErrorMessage(playerid, "You can't use this command now.");

	if (!Inventory_HasItem(playerid, "Ammo Cartridge"))
	    return SendErrorMessage(playerid, "You don't have any ammo cartridges on you.");

	new weaponid = 0;

	switch ((weaponid = GetWeapon(playerid)))
	{
		case 22, 23: GiveWeaponToPlayer(playerid, weaponid, 68);
		case 24, 27: GiveWeaponToPlayer(playerid, weaponid, 35);
	    case 25, 26: GiveWeaponToPlayer(playerid, weaponid, 20);
	    case 28, 31, 32: GiveWeaponToPlayer(playerid, weaponid, 200);
	    case 29, 30: GiveWeaponToPlayer(playerid, weaponid, 120);
	    case 33, 34: GiveWeaponToPlayer(playerid, weaponid, 20);
	    case 35..37: GiveWeaponToPlayer(playerid, weaponid, 4);
	    case 38: GiveWeaponToPlayer(playerid, weaponid, 500);
		default: return SendErrorMessage(playerid, "You cannot use an ammo cartridge on this weapon.");
	}
	PlayReloadAnimation(playerid, weaponid);
	Inventory_Remove(playerid, "Ammo Cartridge");
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has used an ammo cartridge on their %s.", ReturnName(playerid, 0), ReturnWeaponName(weaponid));
	return 1;
}


// ====== CMD:phone ======
CMD:phone(playerid, params[])
{
	if (!Inventory_HasItem(playerid, "Cellphone"))
	    return SendErrorMessage(playerid, "You don't have a cellphone on you.");

    if (PlayerData[playerid][pHospital] != -1 || PlayerData[playerid][pCuffed] || PlayerData[playerid][pInjured] || !IsPlayerSpawned(playerid))
	    return SendErrorMessage(playerid, "You can't use this command now.");

	static
	    str[32];

	format(str, sizeof(str), "Phone (#%d)", PlayerData[playerid][pPhone]);

	if (PlayerData[playerid][pPhoneOff]) {
		Dialog_Show(playerid, MyPhone, DIALOG_STYLE_LIST, DialogStyle_Title(str), DialogStyle_Body("Dial Number\nMy Contacts\nSend Text Message\nTurn On Phone"), "Select", "Cancel");
	}
	else {
	    Dialog_Show(playerid, MyPhone, DIALOG_STYLE_LIST, DialogStyle_Title(str), DialogStyle_Body("Dial Number\nMy Contacts\nSend Text Message\nTurn Off Phone"), "Select", "Cancel");
	}
	return 1;
}

// ====== CMD:sms ======
CMD:sms(playerid, params[])
	return cmd_text(playerid, params);


// ====== CMD:text ======
CMD:text(playerid, params[])
{
    if (!Inventory_HasItem(playerid, "Cellphone"))
	    return SendErrorMessage(playerid, "You don't have a cellphone on you.");

    if (PlayerData[playerid][pPhoneOff])
		return SendErrorMessage(playerid, "Your phone must be powered on.");

	static
	    targetid,
		number,
		text[128];

	if (sscanf(params, "ds[128]", number, text))
	    return SendSyntaxMessage(playerid, "/text [phone number] [message]");

	if (!number)
	    return SendErrorMessage(playerid, "The specified phone number is not in service.");

	if ((targetid = GetNumberOwner(number)) != INVALID_PLAYER_ID)
	{
	    if (targetid == playerid)
	        return SendErrorMessage(playerid, "You can't text yourself!");

		if (PlayerData[targetid][pPhoneOff])
		    return SendErrorMessage(playerid, "The recipient has their cellphone powered off.");

        GiveMoney(playerid, -1);
		ShowPlayerFooter(playerid, "You've been ~r~charged~w~ $1 to send a text.");

		SendClientMessageEx(targetid, COLOR_YELLOW, "TEXT: %s - %s (%d)", text, ReturnName(playerid, 0), PlayerData[playerid][pPhone]);
		SendClientMessageEx(playerid, COLOR_YELLOW, "TEXT: %s - %s (%d)", text, ReturnName(playerid, 0), PlayerData[playerid][pPhone]);

        PlayerPlaySoundEx(targetid, 21001);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out their phone and sends a text.", ReturnName(playerid, 0));
	}
	else
	{
	    SendErrorMessage(playerid, "The specified phone number is not in service.");
	}
	return 1;
}


// ====== CMD:answer ======
CMD:answer(playerid, params[])
{
	if (!PlayerData[playerid][pIncomingCall])
	    return SendErrorMessage(playerid, "There are no incoming calls to accept.");

	if (PlayerData[playerid][pCuffed])
	    return SendErrorMessage(playerid, "You can't use this command at the moment.");

    if (PlayerData[playerid][pPhoneOff])
    	return SendErrorMessage(playerid, "Your phone must be powered on.");

	new targetid = PlayerData[playerid][pCallLine];

	PlayerData[playerid][pIncomingCall] = 0;
	PlayerData[targetid][pIncomingCall] = 0;

	SendClientMessage(playerid, COLOR_YELLOW, "SERVER: {FFFFFF}You have answered the call.");
	SendClientMessage(targetid, COLOR_YELLOW, "SERVER: {FFFFFF}The other line has accepted the call.");

	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has accepted the incoming call.", ReturnName(playerid, 0));
	return 1;
}


// ====== CMD:hangup ======
CMD:hangup(playerid, params[])
{
	new targetid = PlayerData[playerid][pCallLine];

	if (PlayerData[playerid][pEmergency] || PlayerData[playerid][pPlaceAd])
	{
	    PlayerData[playerid][pEmergency] = 0;
	    PlayerData[playerid][pPlaceAd] = 0;

        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has hung up their cellphone.", ReturnName(playerid, 0));
        return 1;
	}
	if (targetid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "There are no calls to hangup.");

	if (PlayerData[playerid][pIncomingCall])
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "PHONE: {FFFFFF}You have declined the incoming call.");
	    SendClientMessage(targetid, COLOR_YELLOW, "PHONE: {FFFFFF}The other line has declined the call.");

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has declined the call.", ReturnName(playerid, 0));
	}
	else
	{
        SendClientMessage(playerid, COLOR_YELLOW, "PHONE: {FFFFFF}You have hung up the call.");
	    SendClientMessage(targetid, COLOR_YELLOW, "PHONE: {FFFFFF}The other line has hung up the call.");

	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has hung up their cellphone.", ReturnName(playerid, 0));
	    SendNearbyMessage(targetid, 30.0, COLOR_PURPLE, "** %s has hung up their cellphone.", ReturnName(targetid, 0));
	}
	PlayerData[playerid][pIncomingCall] = 0;
	PlayerData[targetid][pIncomingCall] = 0;

	PlayerData[playerid][pCallLine] = INVALID_PLAYER_ID;
	PlayerData[targetid][pCallLine] = INVALID_PLAYER_ID;

	return 1;
}


// ====== CMD:id ======
CMD:id(playerid, params[])
{
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/id [playerid/name]");

	if (strlen(params) < 3)
		return SendErrorMessage(playerid, "You must specify at least 3 characters.");

	new count;

	foreach (new i : Player)
	{
	    if (strfind(ReturnName(i), params, true) != -1)
	    {
	        SendClientMessageEx(playerid, COLOR_WHITE, "** %s - ID: %d", ReturnName(i), i);
	        count++;
		}
	}
	if (!count)
	    return SendErrorMessage(playerid, "No users matched the search criteria: \"%s\".", params);

	return 1;
}


// ====== CMD:binfo ======
CMD:binfo(playerid, params[])
{
    new
		id = -1;

    if ((id = (Business_Inside(playerid) == -1) ? (Business_Nearest(playerid)) : (Business_Inside(playerid))) != -1 && Business_IsOwner(playerid, id)) {
     	SendServerMessage(playerid, "ID: %d | Business: %s | Products: %d | Vault: %s", id, BusinessData[id][bizName], BusinessData[id][bizProducts], FormatNumber(BusinessData[id][bizVault]));
	}
	else SendErrorMessage(playerid, "You are not in range of your business.");
	return 1;
}


// ====== CMD:loadcrate ======
CMD:loadcrate(playerid, params[])
{
	new vehid = GetPlayerVehicleID(playerid);

	if (PlayerData[playerid][pJob] != JOB_UNLOADER)
	    return SendErrorMessage(playerid, "You don't have the appropriate job.");

	if (!IsPlayerInWarehouse(playerid))
	    return SendErrorMessage(playerid, "You must be inside a warehouse to do this.");

	if (GetVehicleModel(vehid) != 530)
	    return SendErrorMessage(playerid, "You must be inside a forklift.");

	if (CoreVehicles[vehid][vehLoadType] == 7)
	    return SendErrorMessage(playerid, "This forklift has a crate loaded already.");

	if (!IsPlayerInRangeOfPoint(playerid, 5.0, 1260.3976, -20.0215, 1001.0234))
	    return SendErrorMessage(playerid, "You must be closer to the crates.");

	if (PlayerData[playerid][pLoading])
	    return SendErrorMessage(playerid, "You are already loading a crate at the moment.");

	PlayerData[playerid][pLoading] = 1;

	GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Loading crate...", 3200, 3);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s moves the forklift towards the crate.", ReturnName(playerid, 0));

	TogglePlayerControllable(playerid, 0);
	SetTimerEx("ForkliftUpdate", 3000, false, "dd", playerid, vehid);
	return 1;
}


// ====== CMD:createcrate ======
CMD:createcrate(playerid, params[])
{
	static
	    id = -1,
		type;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", type))
	{
	    SendSyntaxMessage(playerid, "/createcrate [type]");
	    SendClientMessage(playerid, COLOR_YELLOW, "TYPES: {FFFFFF}1: Melee | 2: Pistol Parts | 3: SMG Parts | 4: Shotgun Parts | 5: Rifle Parts | 6: Drugs");
		return 1;
	}
	if (type < 1 || type > 6)
	    return SendErrorMessage(playerid, "Invalid type specified. Types range from 1 to 6.");

	id = Crate_Create(playerid, type);

	if (id == -1)
	    return SendErrorMessage(playerid, "The server has reached the limit for crates.");

	SendServerMessage(playerid, "You have successfully created crate ID: %d.", id);
	return 1;
}


// ====== CMD:destroycrate ======
CMD:destroycrate(playerid, params[])
{
	static
	    id = 0;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/destroycrate [crate id]");

	if ((id < 0 || id >= MAX_CRATES) || !CrateData[id][crateExists])
	    return SendErrorMessage(playerid, "You have specified an invalid crate ID.");

	Crate_Delete(id);
	SendServerMessage(playerid, "You have successfully destroyed crate ID: %d.", id);
	return 1;
}


// ====== CMD:crates ======
CMD:crates(playerid, params[])
{
	static
	    string[512];

	string[0] = '\0';

	for (new i = 1; i != MAX_VEHICLES; i ++) if (IsLoadableVehicle(i) && IsPlayerNearBoot(playerid, i))
	{
	    if (GetVehicleCrates(i) < 1)
	        return SendErrorMessage(playerid, "There are no crates in this vehicle.");

		for (new j = 0; j != MAX_CRATES; j ++) if (CrateData[j][crateExists] && CrateData[j][crateVehicle] == i) {
			format(string, sizeof(string), "%sCrate #%d: %s Parts\n", string, j, Crate_GetType(CrateData[j][crateType]));
		}
		PlayerData[playerid][pCrateVehicle] = i;
		return Dialog_Show(playerid, Crates, DIALOG_STYLE_LIST, DialogStyle_Title("Vehicle Crates"), string, "Take", "Cancel");
	}
	SendErrorMessage(playerid, "You are not in range of any loadable vehicle.");
	return 1;
}


// ====== CMD:craftparts ======
CMD:craftparts(playerid, params[])
{
	new id = -1;

	if (PlayerData[playerid][pJob] != JOB_WEAPON_SMUGGLER)
	    return SendErrorMessage(playerid, "You don't have the appropriate job.");

    if ((id = Job_NearestPoint(playerid)) == -1 || JobData[id][jobType] != JOB_WEAPON_SMUGGLER)
		return SendErrorMessage(playerid, "You are not in range of the craft factory.");

	if (PlayerData[playerid][pCarryCrate] == -1)
	    return SendErrorMessage(playerid, "You are not carrying any crate.");

	if (PlayerData[playerid][pCrafting])
	    return SendErrorMessage(playerid, "You are already crafting weapon parts.");

	if (CrateData[PlayerData[playerid][pCarryCrate]][crateType] < 1 || CrateData[PlayerData[playerid][pCarryCrate]][crateType] > 5)
	    return SendErrorMessage(playerid, "There are no weapon parts in this crate.");

    PlayerData[playerid][pCrafting] = 1;

	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s begins crafting their %s Parts.", ReturnName(playerid, 0), Crate_GetType(CrateData[PlayerData[playerid][pCarryCrate]][crateType]));
	GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Crafting parts...", 11000, 3);

	TogglePlayerControllable(playerid, 0);
	SetTimerEx("CraftParts", 8000, false, "dd", playerid, PlayerData[playerid][pCarryCrate]);
	return 1;
}


// ====== CMD:opencrate ======
CMD:opencrate(playerid, params[])
{
	new id = Crate_Nearest(playerid);

	if (id == -1 || CrateData[id][crateType] != 6)
	    return SendErrorMessage(playerid, "You are not in range of any drug crate.");

	if (!Inventory_HasItem(playerid, "Crowbar"))
		return SendErrorMessage(playerid, "You need a crowbar to open this crate.");

	if (PlayerData[playerid][pOpeningCrate])
	    return SendErrorMessage(playerid, "You are already opening a crate.");

	PlayerData[playerid][pOpeningCrate] = 1;

	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out a crowbar and breaks the drug crate open.", ReturnName(playerid, 0));
	GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Opening crate...", 3000, 3);

 	TogglePlayerControllable(playerid, 0);
  	ApplyAnimation(playerid, "BASEBALL", "Bat_4", 4.0, 1, 1, 1, 1, 0, 1);

	SetTimerEx("OpenCrate", 3000, false, "dd", playerid, id);
    return 1;
}


// ====== CMD:plant ======
CMD:plant(playerid, params[])
{
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/plant [weed/cocaine/heroin]");

	if (Plant_Nearest(playerid) != -1)
	    return SendErrorMessage(playerid, "You can't plant seeds near other plants.");

	if (!strcmp(params, "weed", true))
	{
	    if (Inventory_Count(playerid, "Marijuana Seeds") < 10)
	        return SendErrorMessage(playerid, "You need at least 10 marijuana seeds.");

		Inventory_Remove(playerid, "Marijuana Seeds", 10);

		Plant_Create(playerid, 1);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s plants some marijuana seeds into the ground.", ReturnName(playerid, 0));
	}
	else if (!strcmp(params, "cocaine", true))
	{
	    if (Inventory_Count(playerid, "Cocaine Seeds") < 10)
	        return SendErrorMessage(playerid, "You need at least 10 cocaine seeds.");

		Inventory_Remove(playerid, "Cocaine Seeds", 10);

		Plant_Create(playerid, 2);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s plants some cocaine seeds into the ground.", ReturnName(playerid, 0));
	}
	else if (!strcmp(params, "heroin", true))
	{
	    if (Inventory_Count(playerid, "Heroin Opium Seeds") < 10)
	        return SendErrorMessage(playerid, "You need at least 10 heroin opium seeds.");

		Inventory_Remove(playerid, "Heroin Opium Seeds", 10);

		Plant_Create(playerid, 3);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s plants some heroin opium seeds into the ground.", ReturnName(playerid, 0));
	}
	else {
	    SendSyntaxMessage(playerid, "/plant [weed/cocaine/heroin]");
	}
	return 1;
}


// ====== CMD:harvest ======
CMD:harvest(playerid, params[])
{
	new id = Plant_Nearest(playerid);

	if (id == -1)
	    return SendErrorMessage(playerid, "You must be near a drug plant.");

	if (PlantData[id][plantDrugs] < Plant_MaxGrams(PlantData[id][plantType]))
	    return SendErrorMessage(playerid, "This plant is not fully grown yet.");

	if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
	    return SendErrorMessage(playerid, "You must be crouched to harvest drug plant.");

	if (PlayerData[playerid][pHarvesting])
	    return SendErrorMessage(playerid, "You are already harvesting a plant.");

	GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~Harvesting plant...", 3100, 3);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s begins to harvest the drug plant.", ReturnName(playerid, 0));

	PlayerData[playerid][pHarvesting] = 1;
	SetTimerEx("HarvestPlant", 3000, false, "dd", playerid, id);
	return 1;
}


// ====== CMD:backpack ======
CMD:backpack(playerid, params[])
{
	if (!Inventory_HasItem(playerid, "Backpack"))
	    return SendErrorMessage(playerid, "You don't have a backpack on you.");

	Backpack_Open(playerid);
	return 1;
}


// ====== CMD:dropbackpack ======
CMD:dropbackpack(playerid, params[])
{
	new
		id = GetPlayerBackpack(playerid);

	if (!Inventory_HasItem(playerid, "Backpack") || id == -1)
	    return SendErrorMessage(playerid, "You don't have a backpack on you.");

	if (!Backpack_GetItems(id))
	    return SendErrorMessage(playerid, "You can't drop an empty backpack.");

    if (IsPlayerInAnyVehicle(playerid) || !IsPlayerSpawned(playerid))
    	return SendErrorMessage(playerid, "You can't drop your backpack right now.");

	static
	    Float:x,
	    Float:y,
	    Float:z;

	GetPlayerPos(playerid, x, y, z);

	BackpackData[id][backpackPlayer] = 0;
    BackpackData[id][backpackPos][0] = x;
    BackpackData[id][backpackPos][1] = y;
    BackpackData[id][backpackPos][2] = z;
    BackpackData[id][backpackInterior] = GetPlayerInterior(playerid);
    BackpackData[id][backpackWorld] = GetPlayerVirtualWorld(playerid);

	Backpack_Refresh(id);
	Backpack_Save(id);

	Inventory_Remove(playerid, "Backpack");
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has dropped their backpack.", ReturnName(playerid, 0));

	SetAccessories(playerid);

	return 1;
}


// ====== CMD:setitem ======
CMD:setitem(playerid, params[])
{
	static
	    userid,
		item[32],
		amount;

	if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "uds[32]", userid, amount, item))
	    return SendSyntaxMessage(playerid, "/setitem [playerid/name] [amount] [item name]");

    if (IsFurnitureItem(item))
	{
	    for (new i = 0; i < sizeof(g_aFurnitureData); i ++) if (!strcmp(g_aFurnitureData[i][e_FurnitureName], item, true))
		{
	        Inventory_Set(userid, g_aFurnitureData[i][e_FurnitureName], g_aFurnitureData[i][e_FurnitureModel], amount);

			SendServerMessage(playerid, "You have set %s's \"%s\" to %d.", ReturnName(userid, 0), item, amount);
			return 1;
		}
	}
	else for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if (!strcmp(g_aInventoryItems[i][e_InventoryItem], item, true))
	{
	    if (!strcmp(item, "Cellphone", true)) {
	        PlayerData[userid][pPhone] = random(90000) + 10000;
	    }
        Inventory_Set(userid, g_aInventoryItems[i][e_InventoryItem], g_aInventoryItems[i][e_InventoryModel], amount);

		return SendServerMessage(playerid, "You have set %s's \"%s\" to %d.", ReturnName(userid, 0), item, amount);
	}
	SendErrorMessage(playerid, "Invalid item name (use /itemlist for a list).");
	return 1;
}


// ====== CMD:itemlist ======
CMD:itemlist(playerid, params[])
{
	static
	    string[1024];

	if (!strlen(string)) {
		for (new i = 0; i < sizeof(g_aInventoryItems); i ++) {
			format(string, sizeof(string), "%s%s\n", string, g_aInventoryItems[i][e_InventoryItem]);
		}
	}
	return Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_LIST, DialogStyle_Title("List of Items"), string, "Select", "Cancel");
}


// ====== CMD:createatm ======
CMD:createatm(playerid, params[])
{
	static
	    id = -1;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	id = ATM_Create(playerid);

	if (id == -1)
	    return SendErrorMessage(playerid, "The server has reached the limit for ATM machines.");

	SendServerMessage(playerid, "You have successfully created ATM ID: %d.", id);
	return 1;
}


// ====== CMD:destroyatm ======
CMD:destroyatm(playerid, params[])
{
	static
	    id = 0;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/destroyatm [atm id]");

	if ((id < 0 || id >= MAX_ATM_MACHINES) || !ATMData[id][atmExists])
	    return SendErrorMessage(playerid, "You have specified an invalid ATM ID.");

	ATM_Delete(id);
	SendServerMessage(playerid, "You have successfully destroyed ATM ID: %d.", id);
	return 1;
}


// ====== CMD:creategarbage ======
CMD:creategarbage(playerid, params[])
{
	static
	    id = -1,
		type;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", type))
	{
	    SendSyntaxMessage(playerid, "/creategarbage [type]");
	    SendClientMessage(playerid, COLOR_YELLOW, "TYPES: {FFFFFF}1: Dumpster | 2: Trash Can");
		return 1;
	}
	if (type < 1 || type > 2)
	    return SendErrorMessage(playerid, "The specified type can't be below 1 or above 2.");

	id = Garbage_Create(playerid, type);

	if (id == -1)
	    return SendErrorMessage(playerid, "The server has reached the limit for garbage bins.");

	SendServerMessage(playerid, "You have successfully created garbage bin ID: %d.", id);
	return 1;
}


// ====== CMD:destroygarbage ======
CMD:destroygarbage(playerid, params[])
{
	static
	    id = 0;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/destroygarbage [garbage id]");

	if ((id < 0 || id >= MAX_GARBAGE_BINS) || !GarbageData[id][garbageExists])
	    return SendErrorMessage(playerid, "You have specified an invalid garbage ID.");

	Garbage_Delete(id);
	SendServerMessage(playerid, "You have successfully destroyed garbage bin ID: %d.", id);
	return 1;
}


// ====== CMD:takebag ======
CMD:takebag(playerid, params[])
{
	new
		id = Garbage_Nearest(playerid),
		string[64];

	if (PlayerData[playerid][pJob] != JOB_GARBAGE)
	    return SendErrorMessage(playerid, "You don't have the appropriate job.");

	if (id == -1)
	    return SendErrorMessage(playerid, "You are not in range of any garbage bin.");

	if (GarbageData[id][garbageCapacity] < 1)
	    return SendErrorMessage(playerid, "This garbage bin is empty.");

	if (PlayerData[playerid][pCarryTrash])
	    return SendErrorMessage(playerid, "You are already carrying a garbage bag.");

    GarbageData[id][garbageCapacity]--;
   	Garbage_Save(id);

	PlayerData[playerid][pCarryTrash] = 1;
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes a trash bag from the garbage bin.", ReturnName(playerid, 0), string);

	format(string, sizeof(string), "[Garbage %d]\n{FFFFFF}Trash Capacity: %d/20", id, GarbageData[id][garbageCapacity]);
  	UpdateDynamic3DTextLabelText(GarbageData[id][garbageText3D], COLOR_DARKBLUE, string);

  	SetPlayerAttachedObject(playerid, 4, 1264, 6, 0.000000, 0.000000, 0.000000, 0.000000, 270.000000, 90.000000, 0.500000, 0.500000, 0.500000);
	ShowPlayerFooter(playerid, "Press ~y~'N'~w~ to load the garbage bag.");

	return 1;
}


// ====== CMD:dumpgarbage ======
CMD:dumpgarbage(playerid, params[])
{
	new
		vehicleid = GetPlayerVehicleID(playerid),
		id = Job_NearestPoint(playerid, 5.0);

	if (PlayerData[playerid][pJob] != JOB_GARBAGE)
	    return SendErrorMessage(playerid, "You don't have the appropriate job.");

	if (GetVehicleModel(vehicleid) != 408)
	    return SendErrorMessage(playerid, "You must be driving a garbage truck.");

	if (id == -1 || JobData[id][jobType] != JOB_GARBAGE)
	    return SendErrorMessage(playerid, "You are not in range of any trash dump.");

	if (CoreVehicles[vehicleid][vehTrash] < 1)
	    return SendErrorMessage(playerid, "There is no trash loaded in this vehicle.");

	GiveMoney(playerid, (CoreVehicles[vehicleid][vehTrash] * 25));
	ShowPlayerFooter(playerid, "You have ~g~delivered~w~ the garbage!");

	SendServerMessage(playerid, "You have earned $%d for dumping %d bags of trash.", (CoreVehicles[vehicleid][vehTrash] * 15), CoreVehicles[vehicleid][vehTrash]);
	CoreVehicles[vehicleid][vehTrash] = 0;

	return 1;
}


// ====== CMD:createvendor ======
CMD:createvendor(playerid, params[])
{
	static
	    id = -1,
		type;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", type))
	{
	    SendSyntaxMessage(playerid, "/createvendor [type]");
	    SendClientMessage(playerid, COLOR_YELLOW, "TYPES: {FFFFFF}1: Food | 2: Soda");
		return 1;
	}
	if (type < 1 || type > 2)
	    return SendErrorMessage(playerid, "The specified type can't be below 1 or above 2.");

	id = Vendor_Create(playerid, type);

	if (id == -1)
	    return SendErrorMessage(playerid, "The server has reached the limit for vendors.");

	SendServerMessage(playerid, "You have successfully created vendor ID: %d.", id);
	return 1;
}


// ====== CMD:destroyvendor ======
CMD:destroyvendor(playerid, params[])
{
	static
	    id = 0;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/destroyvendor [vendor id]");

	if ((id < 0 || id >= MAX_VENDORS) || !VendorData[id][vendorExists])
	    return SendErrorMessage(playerid, "You have specified an invalid vendor ID.");

	Vendor_Delete(id);
	SendServerMessage(playerid, "You have successfully destroyed vendor ID: %d.", id);
	return 1;
}


// ====== CMD:dance ======
CMD:dance(playerid, params[])
{
	new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/dance [1-4]");

	if (type < 1 || type > 4)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
		case 1: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE1);
	    case 2: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE2);
	    case 3: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE3);
	    case 4: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE4);
	}
	return 1;
}


// ====== CMD:handsup ======
CMD:handsup(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_HANDSUP);
	return 1;
}


// ====== CMD:piss ======
CMD:piss(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	SetPlayerSpecialAction(playerid, 68);
	return 1;
}


// ====== CMD:animcmds ======
CMD:animcmds(playerid, params[])
{
	SendClientMessage(playerid, COLOR_CLIENT, "ANIMATION:{FFFFFF} /dance, /handsup, /bat, /slap, /bar, /wash, /lay, /workout, /blowjob, /bomb.");
	SendClientMessage(playerid, COLOR_CLIENT, "ANIMATION:{FFFFFF} /carry, /crack, /sleep, /jump, /deal, /dancing, /eating, /puke, /gsign, /chat.");
	SendClientMessage(playerid, COLOR_CLIENT, "ANIMATION:{FFFFFF} /goggles, /spray, /throw, /swipe, /office, /kiss, /knife, /cpr, /scratch, /point.");
	SendClientMessage(playerid, COLOR_CLIENT, "ANIMATION:{FFFFFF} /cheer, /wave, /strip, /smoke, /reload, /taichi, /wank, /cower, /skate, /drunk.");
	SendClientMessage(playerid, COLOR_CLIENT, "ANIMATION:{FFFFFF} /cry, /tired, /sit, /crossarms, /fucku, /walk, /piss, /stopanim.");
	return 1;
}


// ====== CMD:bat ======
CMD:bat(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/bat [1-5]");

	if (type < 1 || type > 5)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
	    case 1: ApplyAnimation(playerid, "BASEBALL", "Bat_1", 4.1, 0, 1, 1, 0, 0, 1);
	    case 2: ApplyAnimation(playerid, "BASEBALL", "Bat_2", 4.1, 0, 1, 1, 0, 0, 1);
	    case 3: ApplyAnimation(playerid, "BASEBALL", "Bat_3", 4.1, 0, 1, 1, 0, 0, 1);
	    case 4: ApplyAnimation(playerid, "BASEBALL", "Bat_4", 4.1, 0, 0, 0, 0, 0, 1);
	    case 5: ApplyAnimationEx(playerid, "BASEBALL", "Bat_IDLE", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}


// ====== CMD:slap ======
CMD:slap(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "BASEBALL", "Bat_M", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}


// ====== CMD:bar ======
CMD:bar(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/bar [1-8]");

	if (type < 1 || type > 8)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
	    case 1: ApplyAnimation(playerid, "BAR", "Barserve_bottle", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimation(playerid, "BAR", "Barserve_give", 4.1, 0, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimation(playerid, "BAR", "Barserve_glass", 4.1, 0, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimation(playerid, "BAR", "Barserve_in", 4.1, 0, 0, 0, 0, 0, 1);
	    case 5: ApplyAnimation(playerid, "BAR", "Barserve_order", 4.1, 0, 0, 0, 0, 0, 1);
	    case 6: ApplyAnimationEx(playerid, "BAR", "BARman_idle", 4.1, 1, 0, 0, 0, 0, 1);
	    case 7: ApplyAnimationEx(playerid, "BAR", "dnk_stndM_loop", 4.1, 0, 0, 0, 0, 0, 1);
	    case 8: ApplyAnimationEx(playerid, "BAR", "dnk_stndF_loop", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}


// ====== CMD:wash ======
CMD:wash(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}


// ====== CMD:lay ======
CMD:lay(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/lay [1-5]");

	if (type < 1 || type > 5)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "BEACH", "bather", 4.1, 1, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "BEACH", "Lay_Bac_Loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimationEx(playerid, "BEACH", "ParkSit_M_loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimationEx(playerid, "BEACH", "ParkSit_W_loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 5: ApplyAnimationEx(playerid, "BEACH", "SitnWait_loop_W", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}


// ====== CMD:workout ======
CMD:workout(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/workout [1-7]");

	if (type < 1 || type > 7)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
	    case 1: ApplyAnimation(playerid, "benchpress", "gym_bp_celebrate", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "benchpress", "gym_bp_down", 4.1, 0, 0, 0, 1, 0, 1);
	    case 3: ApplyAnimation(playerid, "benchpress", "gym_bp_getoff", 4.1, 0, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimationEx(playerid, "benchpress", "gym_bp_geton", 4.1, 0, 0, 0, 1, 0, 1);
	    case 5: ApplyAnimationEx(playerid, "benchpress", "gym_bp_up_A", 4.1, 0, 0, 0, 1, 0, 1);
	    case 6: ApplyAnimationEx(playerid, "benchpress", "gym_bp_up_B", 4.1, 0, 0, 0, 1, 0, 1);
	    case 7: ApplyAnimationEx(playerid, "benchpress", "gym_bp_up_smooth", 4.1, 0, 0, 0, 1, 0, 1);
	}
	return 1;
}


// ====== CMD:blowjob ======
CMD:blowjob(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/blowjob [1-4]");

	if (type < 1 || type > 4)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_W", 4.1, 1, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_P", 4.1, 1, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_STAND_LOOP_W", 4.1, 1, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_STAND_LOOP_P", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}


// ====== CMD:bomb ======
CMD:bomb(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}


// ====== CMD:carry ======
CMD:carry(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/carry [1-6]");

	if (type < 1 || type > 6)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
	    case 1: ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimation(playerid, "CARRY", "liftup05", 4.1, 0, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimation(playerid, "CARRY", "liftup105", 4.1, 0, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 0, 0, 0, 0, 1);
	    case 5: ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 0, 0, 0, 0, 1);
	    case 6: ApplyAnimation(playerid, "CARRY", "putdwn105", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}


// ====== CMD:crack ======
CMD:crack(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/crack [1-6]");

	if (type < 1 || type > 6)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "CRACK", "crckdeth1", 4.1, 0, 0, 0, 1, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "CRACK", "crckdeth2", 4.1, 1, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimationEx(playerid, "CRACK", "crckdeth3", 4.1, 0, 0, 0, 1, 0, 1);
	    case 4: ApplyAnimationEx(playerid, "CRACK", "crckidle1", 4.1, 0, 0, 0, 1, 0, 1);
	    case 5: ApplyAnimationEx(playerid, "CRACK", "crckidle2", 4.1, 0, 0, 0, 1, 0, 1);
	    case 6: ApplyAnimationEx(playerid, "CRACK", "crckidle3", 4.1, 0, 0, 0, 1, 0, 1);
	}
	return 1;
}


// ====== CMD:sleep ======
CMD:sleep(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/sleep [1-2]");

	if (type < 1 || type > 2)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "CRACK", "crckdeth4", 4.1, 0, 0, 0, 1, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "CRACK", "crckidle4", 4.1, 0, 0, 0, 1, 0, 1);
	}
	return 1;
}


// ====== CMD:jump ======
CMD:jump(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "DODGE", "Crush_Jump", 4.1, 0, 1, 1, 0, 0, 1);
	return 1;
}


// ====== CMD:deal ======
CMD:deal(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/deal [1-6]");

	if (type < 1 || type > 6)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
	    case 1: ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimation(playerid, "DEALER", "DRUGS_BUY", 4.1, 0, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE_01", 4.1, 1, 0, 0, 0, 0, 1);
	    case 5: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE_02", 4.1, 1, 0, 0, 0, 0, 1);
	    case 6: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE_03", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}


// ====== CMD:dancing ======
CMD:dancing(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/dancing [1-10]");

	if (type < 1 || type > 10)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "DANCING", "dance_loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "DANCING", "DAN_Left_A", 4.1, 1, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimationEx(playerid, "DANCING", "DAN_Right_A", 4.1, 1, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimationEx(playerid, "DANCING", "DAN_Loop_A", 4.1, 1, 0, 0, 0, 0, 1);
	    case 5: ApplyAnimationEx(playerid, "DANCING", "DAN_Up_A", 4.1, 1, 0, 0, 0, 0, 1);
	    case 6: ApplyAnimationEx(playerid, "DANCING", "DAN_Down_A", 4.1, 1, 0, 0, 0, 0, 1);
	    case 7: ApplyAnimationEx(playerid, "DANCING", "dnce_M_a", 4.1, 1, 0, 0, 0, 0, 1);
	    case 8: ApplyAnimationEx(playerid, "DANCING", "dnce_M_e", 4.1, 1, 0, 0, 0, 0, 1);
	    case 9: ApplyAnimationEx(playerid, "DANCING", "dnce_M_b", 4.1, 1, 0, 0, 0, 0, 1);
	    case 10: ApplyAnimationEx(playerid, "DANCING", "dnce_M_c", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}


// ====== CMD:eating ======
CMD:eating(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/eating [1-3]");

	if (type < 1 || type > 3)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
	    case 1: ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimation(playerid, "FOOD", "EAT_Chicken", 4.1, 0, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimation(playerid, "FOOD", "EAT_Pizza", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}


// ====== CMD:puke ======
CMD:puke(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}


// ====== CMD:gsign ======
CMD:gsign(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/gsign [1-15]");

	if (type < 1 || type > 15)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnimation(playerid, "GHANDS", "gsign1", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "GHANDS", "gsign1LH", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "GHANDS", "gsign2", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimation(playerid, "GHANDS", "gsign2LH", 4.1, 0, 0, 0, 0, 0, 1);
		case 5: ApplyAnimation(playerid, "GHANDS", "gsign3", 4.1, 0, 0, 0, 0, 0, 1);
		case 6: ApplyAnimation(playerid, "GHANDS", "gsign3LH", 4.1, 0, 0, 0, 0, 0, 1);
		case 7: ApplyAnimation(playerid, "GHANDS", "gsign4", 4.1, 0, 0, 0, 0, 0, 1);
		case 8: ApplyAnimation(playerid, "GHANDS", "gsign4LH", 4.1, 0, 0, 0, 0, 0, 1);
		case 9: ApplyAnimation(playerid, "GHANDS", "gsign5", 4.1, 0, 0, 0, 0, 0, 1);
		case 10: ApplyAnimation(playerid, "GHANDS", "gsign5", 4.1, 0, 0, 0, 0, 0, 1);
		case 11: ApplyAnimation(playerid, "GHANDS", "gsign5LH", 4.1, 0, 0, 0, 0, 0, 1);
		case 12: ApplyAnimation(playerid, "GANGS", "Invite_No", 4.1, 0, 0, 0, 0, 0, 1);
		case 13: ApplyAnimation(playerid, "GANGS", "Invite_Yes", 4.1, 0, 0, 0, 0, 0, 1);
		case 14: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkD", 4.1, 0, 0, 0, 0, 0, 1);
		case 15: ApplyAnimation(playerid, "GANGS", "smkcig_prtl", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}


// ====== CMD:chat ======
CMD:chat(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/chat [1-6]");

	if (type < 1 || type > 6)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkA", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkB", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkE", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkF", 4.1, 0, 0, 0, 0, 0, 1);
		case 5: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkG", 4.1, 0, 0, 0, 0, 0, 1);
		case 6: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkH", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}


// ====== CMD:goggles ======
CMD:goggles(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "goggles", "goggles_put_on", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}


// ====== CMD:spray ======
CMD:spray(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

 	ApplyAnimationEx(playerid, "GRAFFITI", "spraycan_fire", 4.1, 1, 0, 0, 0, 0, 1);
	return 1;
}


// ====== CMD:throw ======
CMD:throw(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "GRENADE", "WEAPON_throw", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}


// ====== CMD:swipe ======
CMD:swipe(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "HEIST9", "Use_SwipeCard", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}


// ====== CMD:office ======
CMD:office(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/office [1-6]");

	if (type < 1 || type > 6)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Bored_Loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Crash", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Drink", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Read", 4.1, 1, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Type_Loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 6: ApplyAnimationEx(playerid, "INT_OFFICE", "OFF_Sit_Watch", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}


// ====== CMD:kiss ======
CMD:kiss(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/kiss [1-6]");

	if (type < 1 || type > 6)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnimation(playerid, "KISSING", "Grlfrd_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "KISSING", "Grlfrd_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "KISSING", "Grlfrd_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimation(playerid, "KISSING", "Playa_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
		case 5: ApplyAnimation(playerid, "KISSING", "Playa_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
		case 6: ApplyAnimation(playerid, "KISSING", "Playa_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}


// ====== CMD:knife ======
CMD:knife(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/knife [1-8]");

	if (type < 1 || type > 8)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnimation(playerid, "KNIFE", "knife_1", 4.1, 0, 1, 1, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "KNIFE", "knife_2", 4.1, 0, 1, 1, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "KNIFE", "knife_3", 4.1, 0, 1, 1, 0, 0, 1);
		case 4: ApplyAnimation(playerid, "KNIFE", "knife_4", 4.1, 0, 1, 1, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "KNIFE", "WEAPON_knifeidle", 4.1, 1, 0, 0, 0, 0, 1);
		case 6: ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Player", 4.1, 0, 0, 0, 0, 0, 1);
		case 7: ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Ped_Damage", 4.1, 0, 0, 0, 0, 0, 1);
		case 8: ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Ped_Die", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}


// ====== CMD:cpr ======
CMD:cpr(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "MEDIC", "CPR", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}


// ====== CMD:scratch ======
CMD:scratch(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/scratch [1-4]");

	if (type < 1 || type > 4)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
    	case 1: ApplyAnimationEx(playerid, "SCRATCHING", "scdldlp", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "SCRATCHING", "scdlulp", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "SCRATCHING", "scdrdlp", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "SCRATCHING", "scdrulp", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}


// ====== CMD:point ======
CMD:point(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/point [1-4]");

	if (type < 1 || type > 4)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "PED", "ARRESTgun", 4.1, 0, 0, 0, 1, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "SHOP", "ROB_Loop_Threat", 4.1, 1, 0, 0, 0, 0, 1);
    	case 3: ApplyAnimationEx(playerid, "ON_LOOKERS", "point_loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "ON_LOOKERS", "Pointup_loop", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}


// ====== CMD:cheer ======
CMD:cheer(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/cheer [1-8]");

	if (type < 1 || type > 8)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnimation(playerid, "ON_LOOKERS", "shout_01", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "ON_LOOKERS", "shout_02", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "ON_LOOKERS", "shout_in", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "RIOT", "RIOT_ANGRY_B", 4.1, 1, 0, 0, 0, 0, 1);
		case 5: ApplyAnimation(playerid, "RIOT", "RIOT_CHANT", 4.1, 0, 0, 0, 0, 0, 1);
		case 6: ApplyAnimation(playerid, "RIOT", "RIOT_shout", 4.1, 0, 0, 0, 0, 0, 1);
		case 7: ApplyAnimation(playerid, "STRIP", "PUN_HOLLER", 4.1, 0, 0, 0, 0, 0, 1);
		case 8: ApplyAnimation(playerid, "OTB", "wtchrace_win", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}


// ====== CMD:strip ======
CMD:strip(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/strip [1-7]");

	if (type < 1 || type > 7)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnimationEx(playerid, "STRIP", "strip_A", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "STRIP", "strip_B", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "STRIP", "strip_C", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "STRIP", "strip_D", 4.1, 1, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "STRIP", "strip_E", 4.1, 1, 0, 0, 0, 0, 1);
		case 6: ApplyAnimationEx(playerid, "STRIP", "strip_F", 4.1, 1, 0, 0, 0, 0, 1);
		case 7: ApplyAnimationEx(playerid, "STRIP", "strip_G", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}


// ====== CMD:wave ======
CMD:wave(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/wave [1-3]");

	if (type < 1 || type > 3)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
	    case 1: ApplyAnimation(playerid, "PED", "endchat_03", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimation(playerid, "KISSING", "gfwave2", 4.1, 0, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimationEx(playerid, "ON_LOOKERS", "wave_loop", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}


// ====== CMD:smoke ======
CMD:smoke(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/smoke [1-3]");

	if (type < 1 || type > 3)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
	    case 1: ApplyAnimation(playerid, "SMOKING", "M_smk_drag", 4.1, 0, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "SMOKING", "M_smklean_loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimation(playerid, "SMOKING", "M_smkstnd_loop", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}


// ====== CMD:reload ======
CMD:reload(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/reload [1-4]");

	if (type < 1 || type > 4)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnimation(playerid, "BUDDY", "buddy_reload", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "UZI", "UZI_reload", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "COLT45", "colt45_reload", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimation(playerid, "RIFLE", "rifle_load", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}


// ====== CMD:taichi ======
CMD:taichi(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	ApplyAnimationEx(playerid, "PARK", "Tai_Chi_Loop", 4.1, 1, 0, 0, 0, 0, 1);
	return 1;
}


// ====== CMD:wank ======
CMD:wank(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/wank [1-3]");

	if (type < 1 || type > 3)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnimationEx(playerid, "PAULNMAC", "wank_loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "PAULNMAC", "wank_in", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "PAULNMAC", "wank_out", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}


// ====== CMD:cower ======
CMD:cower(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	ApplyAnimationEx(playerid, "PED", "cower", 4.1, 0, 0, 0, 1, 0, 1);
	return 1;
}


// ====== CMD:skate ======
CMD:skate(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/skate [1-2]");

	if (type < 1 || type > 2)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnimationEx(playerid, "SKATE", "skate_idle", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "SKATE", "skate_run", 4.1, 1, 1, 1, 1, 1, 1);
	}
	return 1;
}


// ====== CMD:drunk ======
CMD:drunk(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	ApplyAnimationEx(playerid, "PED", "WALK_drunk", 4.1, 1, 1, 1, 1, 1, 1);
	return 1;
}


// ====== CMD:cry ======
CMD:cry(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	ApplyAnimationEx(playerid, "GRAVEYARD", "mrnF_loop", 4.1, 1, 0, 0, 0, 0, 1);
    return 1;
}


// ====== CMD:tired ======
CMD:tired(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/tired [1-2]");

	if (type < 1 || type > 2)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "PED", "IDLE_tired", 4.1, 1, 0, 0, 0, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "FAT", "IDLE_tired", 4.1, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}


// ====== CMD:sit ======
CMD:sit(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/sit [1-6]");

	if (type < 1 || type > 6)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
		case 1: ApplyAnimationEx(playerid, "CRIB", "PED_Console_Loop", 4.1, 1, 0, 0, 0, 0);
		case 2: ApplyAnimationEx(playerid, "INT_HOUSE", "LOU_In", 4.1, 0, 0, 0, 1, 0);
		case 3: ApplyAnimationEx(playerid, "MISC", "SEAT_LR", 4.1, 1, 0, 0, 0, 0);
		case 4: ApplyAnimationEx(playerid, "MISC", "Seat_talk_01", 4.1, 1, 0, 0, 0, 0);
		case 5: ApplyAnimationEx(playerid, "MISC", "Seat_talk_02", 4.1, 1, 0, 0, 0, 0);
		case 6: ApplyAnimationEx(playerid, "ped", "SEAT_down", 4.1, 0, 0, 0, 1, 0);
	}
	return 1;
}


// ====== CMD:crossarms ======
CMD:crossarms(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/crossarms [1-4]");

	if (type < 1 || type > 4)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "COP_AMBIENT", "Coplook_loop", 4.1, 0, 1, 1, 1, 0, 1);
	    case 2: ApplyAnimationEx(playerid, "GRAVEYARD", "prst_loopa", 4.1, 1, 0, 0, 0, 0, 1);
	    case 3: ApplyAnimationEx(playerid, "GRAVEYARD", "mrnM_loop", 4.1, 1, 0, 0, 0, 0, 1);
	    case 4: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE", 4.1, 0, 1, 1, 1, 0, 1);
	}
	return 1;
}


// ====== CMD:fucku ======
CMD:fucku(playerid, params[])
{
    if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	ApplyAnimation(playerid, "PED", "fucku", 4.1, 0, 0, 0, 0, 0);
	return 1;
}


// ====== CMD:walk ======
CMD:walk(playerid, params[])
{
    new type;

	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You can't perform animations at the moment.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/walk [1-16]");

	if (type < 1 || type > 17)
	    return SendErrorMessage(playerid, "Invalid type specified.");

	switch (type) {
	    case 1: ApplyAnimationEx(playerid, "FAT", "FatWalk", 4.1, 1, 1, 1, 1, 1, 1);
	    case 2: ApplyAnimationEx(playerid, "MUSCULAR", "MuscleWalk", 4.1, 1, 1, 1, 1, 1, 1);
	    case 3: ApplyAnimationEx(playerid, "PED", "WALK_armed", 4.1, 1, 1, 1, 1, 1, 1);
	    case 4: ApplyAnimationEx(playerid, "PED", "WALK_civi", 4.1, 1, 1, 1, 1, 1, 1);
	    case 5: ApplyAnimationEx(playerid, "PED", "WALK_fat", 4.1, 1, 1, 1, 1, 1, 1);
	    case 6: ApplyAnimationEx(playerid, "PED", "WALK_fatold", 4.1, 1, 1, 1, 1, 1, 1);
	    case 7: ApplyAnimationEx(playerid, "PED", "WALK_gang1", 4.1, 1, 1, 1, 1, 1, 1);
	    case 8: ApplyAnimationEx(playerid, "PED", "WALK_gang2", 4.1, 1, 1, 1, 1, 1, 1);
	    case 9: ApplyAnimationEx(playerid, "PED", "WALK_player", 4.1, 1, 1, 1, 1, 1, 1);
	    case 10: ApplyAnimationEx(playerid, "PED", "WALK_old", 4.1, 1, 1, 1, 1, 1, 1);
	    case 11: ApplyAnimationEx(playerid, "PED", "WALK_wuzi", 4.1, 1, 1, 1, 1, 1, 1);
	    case 12: ApplyAnimationEx(playerid, "PED", "WOMAN_walkbusy", 4.1, 1, 1, 1, 1, 1, 1);
	    case 13: ApplyAnimationEx(playerid, "PED", "WOMAN_walkfatold", 4.1, 1, 1, 1, 1, 1, 1);
	    case 14: ApplyAnimationEx(playerid, "PED", "WOMAN_walknorm", 4.1, 1, 1, 1, 1, 1, 1);
	    case 15: ApplyAnimationEx(playerid, "PED", "WOMAN_walksexy", 4.1, 1, 1, 1, 1, 1, 1);
	    case 16: ApplyAnimationEx(playerid, "PED", "WOMAN_walkshop", 4.1, 1, 1, 1, 1, 1, 1);
	}
	return 1;
}


// ====== CMD:spawnitem ======
CMD:spawnitem(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/spawnitem [item name] (/itemlist for a list)");

	static
		Float:x,
		Float:y,
		Float:z;

	GetPlayerPos(playerid, x, y, z);

    for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if (!strcmp(g_aInventoryItems[i][e_InventoryItem], params, true))
	{
	    new id = DropItem(g_aInventoryItems[i][e_InventoryItem], "Admin", g_aInventoryItems[i][e_InventoryModel], 1, x, y, z - 0.9, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));

	    if (id == -1)
	        return SendErrorMessage(playerid, "The server has reached a limit for spawned items.");
        Log_Write("logs/spawnitem.txt", "[%s] %s has spawned %s", ReturnDate(), ReturnName(playerid, 0), g_aInventoryItems[i][e_InventoryItem]);
		SendServerMessage(playerid, "You have spawned a \"%s\" (type /setquantity to set the quantity).", g_aInventoryItems[i][e_InventoryItem]);
		return 1;
	}
    SendErrorMessage(playerid, "Invalid item name (use /itemlist for a list).");
	return 1;
}


// ====== CMD:setquantity ======
CMD:setquantity(playerid, params[])
{
	static
	    id = -1,
		amount;

    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if ((id = Item_Nearest(playerid)) == -1)
	    return SendErrorMessage(playerid, "You are not in range of any spawned items.");

	if (sscanf(params, "d", amount))
	    return SendSyntaxMessage(playerid, "/setquantity [amount]");

	if (amount < 1)
	    return SendErrorMessage(playerid, "The specified amount can't be below 1.");

    Item_SetQuantity(id, amount);
    Log_Write("logs/spawnitem.txt", "[%s] %s has set the quantity of %s to %d.", ReturnDate(), ReturnName(playerid, 0), DroppedItems[id][droppedItem], amount);
    SendServerMessage(playerid, "You have set the quantity of \"%s\" to %d.", DroppedItems[id][droppedItem], amount);
    return 1;
}


// ====== CMD:destroyitem ======
CMD:destroyitem(playerid, params[])
{
	static
	    id = -1;

    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if ((id = Item_Nearest(playerid)) == -1)
	    return SendErrorMessage(playerid, "You are not in range of any spawned items.");

    SendServerMessage(playerid, "You have deleted a \"%s\".", DroppedItems[id][droppedItem]);
    Item_Delete(id);
    return 1;
}


// ====== CMD:boombox ======
CMD:boombox(playerid, params[])
{
	static
	    type[24],
	    string[128];

	if (!Inventory_HasItem(playerid, "Boombox"))
	    return SendErrorMessage(playerid, "You don't have a boombox on you.");

	if (sscanf(params, "s[24]S()[128]", type, string))
	{
	    SendSyntaxMessage(playerid, "/boombox [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "NAMES: {FFFFFF}place, pickup, url");
	    return 1;
	}
	if (!strcmp(type, "place", true))
	{
	    if (BoomboxData[playerid][boomboxPlaced])
	        return SendErrorMessage(playerid, "You have placed a boombox already.");

		if (Boombox_Nearest(playerid) != INVALID_PLAYER_ID)
		    return SendErrorMessage(playerid, "You are in range of another boombox already.");

		if (IsPlayerInAnyVehicle(playerid))
		    return SendErrorMessage(playerid, "You must exit the vehicle first.");

		Boombox_Place(playerid);

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out a boombox and sets it down.", ReturnName(playerid, 0));
		SendServerMessage(playerid, "You have placed your boombox (use \"/boombox\" for options).");
	}
	else if (!strcmp(type, "pickup", true))
	{
	    if (!BoomboxData[playerid][boomboxPlaced])
	        return SendErrorMessage(playerid, "You don't have a boombox deployed.");

		if (!IsPlayerInRangeOfPoint(playerid, 3.0, BoomboxData[playerid][boomboxPos][0], BoomboxData[playerid][boomboxPos][1], BoomboxData[playerid][boomboxPos][2]))
		    return SendErrorMessage(playerid, "You are not in range of your boombox.");

		Boombox_Destroy(playerid);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has picked up their boombox.", ReturnName(playerid, 0));
	}
	else if (!strcmp(type, "url", true))
	{
	    if (sscanf(string, "s[128]", string))
	        return SendSyntaxMessage(playerid, "/boombox [url] [song url]");

        if (!BoomboxData[playerid][boomboxPlaced])
	        return SendErrorMessage(playerid, "You don't have a boombox deployed.");

		if (!IsPlayerInRangeOfPoint(playerid, 3.0, BoomboxData[playerid][boomboxPos][0], BoomboxData[playerid][boomboxPos][1], BoomboxData[playerid][boomboxPos][2]))
		    return SendErrorMessage(playerid, "You are not in range of your boombox.");

		Boombox_SetURL(playerid, string);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s turns the dial of the boombox to another station.", ReturnName(playerid, 0));
	}
	return 1;
}


// ====== CMD:adestroybox ======
CMD:adestroybox(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	foreach (new i : Player) if (BoomboxData[i][boomboxPlaced] && IsPlayerInRangeOfPoint(playerid, 3.0, BoomboxData[i][boomboxPos][0], BoomboxData[i][boomboxPos][1], BoomboxData[i][boomboxPos][2])) {
		Boombox_Destroy(i);

		SendServerMessage(playerid, "You have destroyed %s's boombox.", ReturnName(i, 0));
		return SendServerMessage(i, "%s has destroyed your boombox.", ReturnName(playerid, 0));
	}
	SendErrorMessage(playerid, "You are not in range of any boombox.");
	return 1;
}


// ====== CMD:findgarbage ======
CMD:findgarbage(playerid, params[])
{
	if (PlayerData[playerid][pJob] != JOB_GARBAGE)
	    return SendErrorMessage(playerid, "You don't have the appropriate job.");

	new id = GetClosestGarbage(playerid);

	if (id == -1)
	    return SendErrorMessage(playerid, "There are no garbage bins available.");

	PlayerData[playerid][pCP] = 1;

	SetPlayerCheckpoint(playerid, GarbageData[id][garbagePos][0], GarbageData[id][garbagePos][1], GarbageData[id][garbagePos][2], 2.5);
	SendServerMessage(playerid, "Marker set to the closest garbage bin.");
	return 1;
}


// ====== CMD:search ======
CMD:search(playerid, params[])
{
	new userid;

	if (sscanf(params, "u", userid))
	{
		SendSyntaxMessage(playerid, "/search [playerid/name]");
		SendClientMessage(playerid, COLOR_YELLOW, "HINT: {FFFFFF}Use /searchbp to search a player's backpack.");
		return 1;
	}
	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "That player is disconnected or not near you.");

	if (Inventory_HasItem(userid, "Marijuana Seeds"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Marijuana Seeds (%d)", Inventory_Count(userid, "Marijuana Seeds"));

    if (Inventory_HasItem(userid, "Cocaine Seeds"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Cocaine Seeds (%d)", Inventory_Count(userid, "Cocaine Seeds"));

    if (Inventory_HasItem(userid, "Heroin Opium Seeds"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Heroin Opium Seeds (%d)", Inventory_Count(userid, "Heroin Opium Seeds"));

	if (Inventory_HasItem(userid, "Steroids"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Steroids (%d)", Inventory_Count(userid, "Steroids"));

    if (Inventory_HasItem(userid, "Marijuana"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Marijuana (%d)", Inventory_Count(userid, "Marijuana"));

    if (Inventory_HasItem(userid, "Cocaine"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Cocaine (%d)", Inventory_Count(userid, "Cocaine"));

    if (Inventory_HasItem(userid, "Heroin"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Heroin (%d)", Inventory_Count(userid, "Heroin"));

	for (new i = 0; i < 12; i ++) if (PlayerData[userid][pGuns][i] && PlayerData[userid][pAmmo][i] > 0) {
	    SendClientMessageEx(playerid, COLOR_LIGHTRED, "** %s", ReturnWeaponName(PlayerData[userid][pGuns][i]));
	}
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s starts to search %s for illegal items.", ReturnName(playerid, 0), ReturnName(userid, 0));
	return 1;
}


// ====== CMD:searchbp ======
CMD:searchbp(playerid, params[])
{
    new userid, backpack;

	if (sscanf(params, "u", userid))
		return SendSyntaxMessage(playerid, "/searchbp [playerid/name]");

	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "That player is disconnected or not near you.");

	if (!Inventory_HasItem(userid, "Backpack") || (backpack = GetPlayerBackpack(userid)) == -1)
	    return SendErrorMessage(playerid, "That player doesn't have a backpack.");

    if (Backpack_HasItem(backpack, "Marijuana Seeds"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Marijuana Seeds (%d)", Backpack_Count(backpack, "Marijuana Seeds"));

    if (Backpack_HasItem(backpack, "Cocaine Seeds"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Cocaine Seeds (%d)", Backpack_Count(backpack, "Cocaine Seeds"));

    if (Backpack_HasItem(backpack, "Heroin Opium Seeds"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Heroin Opium Seeds (%d)", Backpack_Count(backpack, "Heroin Opium Seeds"));

	if (Backpack_HasItem(backpack, "Steroids"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Steroids (%d)", Backpack_Count(backpack, "Steroids"));

    if (Backpack_HasItem(backpack, "Marijuana"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Marijuana (%d)", Backpack_Count(backpack, "Marijuana"));

    if (Backpack_HasItem(backpack, "Cocaine"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Cocaine (%d)", Backpack_Count(backpack, "Cocaine"));

    if (Backpack_HasItem(backpack, "Heroin"))
		SendClientMessageEx(playerid, COLOR_LIGHTRED, "** Heroin (%d)", Backpack_Count(backpack, "Heroin"));

	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has searched %s's backpack for illegal items.", ReturnName(playerid, 0), ReturnName(userid, 0));
	return 1;
}


// ====== CMD:take ======
CMD:take(playerid, params[])
{
	new
	    userid,
		string[128];

    if (GetFactionType(playerid) != FACTION_POLICE)
		return SendErrorMessage(playerid, "You must be a police officer.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/take [playerid/name]");

    if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "That player is disconnected or not near you.");

	if (GetWeaponCount(userid) > 0)
		strcat(string, "Take Weapons\n");

	if (Inventory_HasItem(userid, "Marijuana Seeds") || Inventory_HasItem(userid, "Cocaine Seeds") || Inventory_HasItem(userid, "Heroin Opium Seeds"))
	    strcat(string, "Take Seeds\n");

	if (Inventory_HasItem(userid, "Marijuana") || Inventory_HasItem(userid, "Cocaine") || Inventory_HasItem(userid, "Heroin") || Inventory_HasItem(userid, "Steroids"))
	    strcat(string, "Take Drugs\n");

    if (Inventory_HasItem(userid, "Portable Radio"))
	    strcat(string, "Take Radio\n");

	if (Inventory_HasItem(userid, "Backpack") && GetPlayerBackpack(userid) != -1)
	    strcat(string, "Take Backpack\n");

    if (Inventory_HasItem(userid, "Weapon License"))
	    strcat(string, "Take Weapon License\n");

   	if (Inventory_HasItem(userid, "Driving License"))
	    strcat(string, "Take Driving License\n");

	if (!strlen(string))
	    return SendErrorMessage(playerid, "This player has no illegal items to take.");

	PlayerData[playerid][pTakeItems] = userid;
	Dialog_Show(playerid, TakeItems, DIALOG_STYLE_LIST, DialogStyle_Title("Take Items"), string, "Take", "Cancel");
	return 1;
}


// ====== CMD:buyrack ======
CMD:buyrack(playerid, params[])
{
	new houseid = House_Inside(playerid);

	if (houseid == -1 || !House_IsOwner(playerid, houseid))
	    return SendErrorMessage(playerid, "You are not in range of your house interior.");

	if (isnull(params) || (!isnull(params) && strcmp(params, "confirm", true) != 0))
		return SendSyntaxMessage(playerid, "/buyrack [confirm] ($1,000 fee)");

	if (Rack_Count(playerid) >= 4)
	    return SendErrorMessage(playerid, "Your house can only have up to 4 weapon racks.");

	if (Rack_Nearest(playerid) != -1)
	    return SendErrorMessage(playerid, "You can't use this command near another rack.");

	if (GetMoney(playerid) < 1000)
	    return SendErrorMessage(playerid, "You have insufficient funds for the purchase.");

	new id = Rack_Create(playerid, houseid);

	if (id == -1)
	    return SendErrorMessage(playerid, "The server has reached the limit for weapon racks.");

    ResetEditing(playerid);

	PlayerData[playerid][pEditRack] = id;
	EditDynamicObject(playerid, RackData[id][rackObjects][4]);

    GiveMoney(playerid, -1000);
	SendServerMessage(playerid, "You have purchased a weapon rack for $1,000.");
	return 1;
}


// ====== CMD:gunrack ======
CMD:gunrack(playerid, params[])
{
	new id = Rack_Nearest(playerid);

	if (id == -1)
	    return SendErrorMessage(playerid, "You are not in range of any weapon rack.");

	Rack_ShowGuns(playerid, id);
	return 1;
}


// ====== CMD:deleterack ======
CMD:deleterack(playerid, params[])
{
	new
		id = -1,
		houseid = House_Inside(playerid);

	if (houseid == -1 || !House_IsOwner(playerid, houseid))
	    return SendErrorMessage(playerid, "You are not in range of your house interior.");

	if ((id = Rack_Nearest(playerid)) == -1)
	    return SendErrorMessage(playerid, "You are not in range of any weapon rack.");

	Rack_Delete(id);
	SendServerMessage(playerid, "You have deleted the weapon rack from your house.");
	return 1;
}


// ====== CMD:createrack ======
CMD:createrack(playerid, params[])
{
	static
	    id = -1;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	id = Rack_Create(playerid, -1);

	if (id == -1)
	    return SendErrorMessage(playerid, "The server has reached the limit for weapon racks.");

    ResetEditing(playerid);
    PlayerData[playerid][pEditRack] = id;

	EditDynamicObject(playerid, RackData[id][rackObjects][4]);
	SendServerMessage(playerid, "You have successfully created rack ID: %d.", id);
	return 1;
}


// ====== CMD:editrack ======
CMD:editrack(playerid, params[])
{
	static
	    id = 0;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/editrack [rack id]");

	if ((id < 0 || id >= MAX_WEAPON_RACKS) || !RackData[id][rackExists])
	    return SendErrorMessage(playerid, "You have specified an invalid rack ID.");

	ResetEditing(playerid);
	PlayerData[playerid][pEditRack] = id;

	EditDynamicObject(playerid, RackData[id][rackObjects][4]);
	SendServerMessage(playerid, "You are now editing weapon rack ID: %d.", id);
	return 1;
}


// ====== CMD:destroyrack ======
CMD:destroyrack(playerid, params[])
{
	static
	    id = 0;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/destroyrack [rack id]");

	if ((id < 0 || id >= MAX_WEAPON_RACKS) || !RackData[id][rackExists])
	    return SendErrorMessage(playerid, "You have specified an invalid rack ID.");

	Rack_Delete(id);
	SendServerMessage(playerid, "You have successfully destroyed weapon rack ID: %d.", id);
	return 1;
}


// ====== CMD:tracenumber ======
CMD:tracenumber(playerid, params[])
{
	new number;

	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", number))
	    return SendSyntaxMessage(playerid, "/tracenumber [phone number]");

	if (number == 0)
	    return SendErrorMessage(playerid, "You have specified an invalid number.");

	if (GetNumberOwner(number) != INVALID_PLAYER_ID)
	    return SendServerMessage(playerid, "The phone number %d is owned by %s.", number, ReturnName(GetNumberOwner(number), 0));

	SendErrorMessage(playerid, "There is no player online with that phone number.");
	return 1;
}


// ====== CMD:showlicense ======
CMD:showlicense(playerid, params[])
{
	static
	    userid;

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/showlicense [playerid/name]");

	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "That player is disconnected or not near you.");

	if (userid == playerid)
		return SendErrorMessage(playerid, "You can't show your licenses to yourself.");

	SendClientMessage(userid, COLOR_GREY, "-----------------------------------------------------------");

	if (Inventory_HasItem(playerid, "Driving License")) SendClientMessageEx(userid, COLOR_WHITE, "* Driving License {33CC33}(Passed)");
 	else SendClientMessageEx(userid, COLOR_WHITE, "* Driving License {AA3333}(Not Passed)");

	if (Inventory_HasItem(playerid, "Weapon License")) SendClientMessageEx(userid, COLOR_WHITE, "* Weapon License {33CC33}(Passed)");
	else SendClientMessageEx(userid, COLOR_WHITE, "* Weapon License {AA3333}(Not Passed)");

	SendClientMessage(userid, COLOR_GREY, "-----------------------------------------------------------");
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out their licenses and shows them to %s.", ReturnName(playerid, 0), ReturnName(userid, 0));
	return 1;
}


// ====== CMD:stoploading ======
CMD:stoploading(playerid, params[])
{
	if (PlayerData[playerid][pJob] != JOB_COURIER)
	    return SendErrorMessage(playerid, "You don't have the appropriate job.");

	if (!PlayerData[playerid][pLoading] && !PlayerData[playerid][pLoadType])
	    return SendErrorMessage(playerid, "You are not loading any crates right now.");

	PlayerData[playerid][pLoading] = 0;
	PlayerData[playerid][pLoadType] = 0;
    PlayerData[playerid][pLoadCrate] = 0;

	RemovePlayerAttachedObject(playerid, 4);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

	DisablePlayerCheckpoint(playerid);
	SendServerMessage(playerid, "You are no longer loading crates.");

	return 1;
}


// ====== CMD:usemag ======
CMD:usemag(playerid, params[])
{
	new weaponid = PlayerData[playerid][pHoldWeapon];

	if (!weaponid)
	    return SendErrorMessage(playerid, "You are not holding any empty weapon.");

	if (!Inventory_HasItem(playerid, "Magazine"))
	    return SendErrorMessage(playerid, "You don't have any weapon magazines.");

	if (PlayerData[playerid][pUsedMagazine])
	    return SendErrorMessage(playerid, "You have already used a magazine on this weapon.");

	switch (weaponid)
	{
	    case 22:
	    {
		    PlayerPlaySoundEx(playerid, 1131);
			PlayerData[playerid][pUsedMagazine] = 1;

	        Inventory_Remove(playerid, "Magazine");
   			PlayReloadAnimation(playerid, 24);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s attaches a magazine to the weapon.", ReturnName(playerid, 0));
			ShowPlayerFooter(playerid, "Press ~y~'H'~w~ to load the weapon.");
		}
		case 24:
	    {
	        PlayerPlaySoundEx(playerid, 1131);
			PlayerData[playerid][pUsedMagazine] = 1;

	        Inventory_Remove(playerid, "Magazine");
   			PlayReloadAnimation(playerid, 24);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s attaches a magazine to the weapon.", ReturnName(playerid, 0));
			ShowPlayerFooter(playerid, "Press ~y~'H'~w~ to load the weapon.");
		}
		case 25:
	    {
	        PlayerPlaySoundEx(playerid, 1131);
			PlayerData[playerid][pUsedMagazine] = 1;

	        Inventory_Remove(playerid, "Magazine");
   			PlayReloadAnimation(playerid, 24);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s inserts some shells into the weapon.", ReturnName(playerid, 0));
			ShowPlayerFooter(playerid, "Press ~y~'H'~w~ to load the weapon.");
		}
		case 27:
	    {
	        PlayerPlaySoundEx(playerid, 1131);
			PlayerData[playerid][pUsedMagazine] = 1;

	        Inventory_Remove(playerid, "Magazine");
   			PlayReloadAnimation(playerid, 24);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s inserts some shells into the weapon.", ReturnName(playerid, 0));
			ShowPlayerFooter(playerid, "Press ~y~'H'~w~ to load the weapon.");
		}
		case 28:
	    {
	        PlayerPlaySoundEx(playerid, 1131);
			PlayerData[playerid][pUsedMagazine] = 1;

	        Inventory_Remove(playerid, "Magazine");
   			PlayReloadAnimation(playerid, 24);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s attaches a magazine to the weapon.", ReturnName(playerid, 0));
			ShowPlayerFooter(playerid, "Press ~y~'H'~w~ to load the weapon.");
		}
		case 29:
	    {
	        PlayerPlaySoundEx(playerid, 1131);
			PlayerData[playerid][pUsedMagazine] = 1;

	        Inventory_Remove(playerid, "Magazine");
   			PlayReloadAnimation(playerid, 24);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s attaches a magazine to the weapon.", ReturnName(playerid, 0));
			ShowPlayerFooter(playerid, "Press ~y~'H'~w~ to load the weapon.");
		}
		case 32:
	    {
	        PlayerPlaySoundEx(playerid, 1131);
			PlayerData[playerid][pUsedMagazine] = 1;

	        Inventory_Remove(playerid, "Magazine");
   			PlayReloadAnimation(playerid, 24);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s attaches a magazine to the weapon.", ReturnName(playerid, 0));
			ShowPlayerFooter(playerid, "Press ~y~'H'~w~ to load the weapon.");
		}
		case 30:
	    {
	        PlayerPlaySoundEx(playerid, 1131);
			PlayerData[playerid][pUsedMagazine] = 1;

	        Inventory_Remove(playerid, "Magazine");
   			PlayReloadAnimation(playerid, 24);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s attaches a magazine to the weapon.", ReturnName(playerid, 0));
			ShowPlayerFooter(playerid, "Press ~y~'H'~w~ to load the weapon.");
		}
		case 33:
	    {
	        PlayerPlaySoundEx(playerid, 1131);
			PlayerData[playerid][pUsedMagazine] = 1;

	        Inventory_Remove(playerid, "Magazine");
   			PlayReloadAnimation(playerid, 24);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s attaches a magazine to the weapon.", ReturnName(playerid, 0));
			ShowPlayerFooter(playerid, "Press ~y~'H'~w~ to load the weapon.");
		}
        case 34:
	    {
	        PlayerPlaySoundEx(playerid, 1131);
			PlayerData[playerid][pUsedMagazine] = 1;

	        Inventory_Remove(playerid, "Magazine");
   			PlayReloadAnimation(playerid, 24);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s attaches a magazine to the weapon.", ReturnName(playerid, 0));
			ShowPlayerFooter(playerid, "Press ~y~'H'~w~ to load the weapon.");
		}
		default:
		    return SendErrorMessage(playerid, "You can't attach a magazine to this weapon.");
	}
	return 1;
}


// ====== CMD:clearinventory ======
CMD:clearinventory(playerid, params[])
{
	static
	    userid;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/clearinventory [playerid/name]");

    if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "You have specified an invalid player.");

	Inventory_Clear(userid);

	SendAdminAction(playerid, "You have cleared %s's inventory from all items.", ReturnName(userid, 0));
	SendAdminAction(userid, "%s has cleared your inventory from all items.", ReturnName(playerid, 0));

	SendAdminAlert(COLOR_LIGHTRED, "ADMIN: %s has cleared %s's inventory.", ReturnName(playerid, 0), ReturnName(userid, 0));
	return 1;
}


// ====== CMD:mask ======
CMD:mask(playerid, params[])
{
	if (!Inventory_HasItem(playerid, "Mask"))
		return SendErrorMessage(playerid, "You don't have any mask.");

	switch (PlayerData[playerid][pMaskOn])
	{
		case 0:
		{
		    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out a mask and puts it on.", ReturnName(playerid, 0));
		    PlayerData[playerid][pMaskOn] = 1;
		}
		case 1:
		{
		    PlayerData[playerid][pMaskOn] = 0;
		    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes their mask off and puts it away.", ReturnName(playerid, 0));
		}
	}
	return 1;
}


// ====== CMD:masked ======
CMD:masked(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	static
	    name[24];

    SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");

    foreach (new i : Player) if (PlayerData[i][pMaskOn]) {
        GetPlayerName(i, name, sizeof(name));

        SendClientMessageEx(playerid, COLOR_WHITE, "* %s (#%d)", name, PlayerData[i][pMaskID]);
	}
	SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
	return 1;
}


// ====== CMD:listguns ======
CMD:listguns(playerid, params[])
{
	new userid;

	if (PlayerData[playerid][pAdmin] < 2)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/listguns [playerid/name]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "The specified player is disconnected.");

	new
	    weaponid,
	    ammo;

    SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
    SendClientMessageEx(playerid, COLOR_LIGHTRED, "%s's Weapons:", ReturnName(userid, 0));

	for (new i = 0; i < 13; i ++)
	{
		GetPlayerWeaponData(userid, i, weaponid, ammo);

		if (weaponid > 0)
		    SendClientMessageEx(playerid, COLOR_WHITE, "* %s (%d ammo)", ReturnWeaponName(weaponid), ammo);
	}
	SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
	return 1;
}


// ====== CMD:setinventory ======
CMD:setinventory(playerid, params[])
{
	static
	    userid,
		capacity;

    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "ud", userid, capacity))
	    return SendSyntaxMessage(playerid, "/setinventory [playerid/name] [amount]");

	if (userid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "The specified player is disconnected.");

	if (capacity < 1 || capacity > 120)
	    return SendErrorMessage(playerid, "The specified capacity can't exceed 120 items.");

	PlayerData[userid][pCapacity] = 120;

	SendServerMessage(playerid, "You have set %s's inventory capacity to %d items.", ReturnName(userid, 0), capacity);
	SendServerMessage(userid, "%s has set your inventory capacity to %d items.", ReturnName(playerid, 0), capacity);
	return 1;
}


// ====== CMD:dice ======
CMD:dice(playerid, params[])
{
	new
		number = random(6) + 1;

	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s rolls a dice landing on the number %d.", ReturnName(playerid, 0), number);
	return 1;
}


// ====== CMD:shakehand ======
CMD:shakehand(playerid, params[])
{
	static
	    userid,
	    type;

	if (sscanf(params, "ud", userid, type))
	    return SendSyntaxMessage(playerid, "/shakehand [playerid/name] [type]");

    if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 6.0))
	    return SendErrorMessage(playerid, "The specified player is disconnected or not near you.");

    if (userid == playerid)
		return SendErrorMessage(playerid, "You cannot shake your own hand.");

	if (type < 1 || type > 6)
	    return SendErrorMessage(playerid, "You must specify a type from 1 to 6.");

	PlayerData[userid][pShakeOffer] = playerid;
	PlayerData[userid][pShakeType] = type;

	SendServerMessage(userid, "%s has offered to shake your hand (type \"/approve greet\").", ReturnName(playerid, 0));
	SendServerMessage(playerid, "You have offered to shake %s's hand.", ReturnName(userid, 0));
	return 1;
}


// ====== CMD:frisk ======
CMD:frisk(playerid, params[])
{
	static
	    userid;

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/frisk [playerid/name]");

    if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 6.0))
	    return SendErrorMessage(playerid, "The specified player is disconnected or not near you.");

    if (userid == playerid)
		return SendErrorMessage(playerid, "You cannot frisk yourself.");

	PlayerData[userid][pFriskOffer] = playerid;

	SendServerMessage(userid, "%s has offered to frisk you (type \"/approve frisk\").", ReturnName(playerid, 0));
	SendServerMessage(playerid, "You have offered to frisk %s.", ReturnName(userid, 0));
	return 1;
}


// ====== CMD:creategraffiti ======
CMD:creategraffiti(playerid, params[])
{
	static
	    id = -1,
		Float:x,
		Float:y,
		Float:z,
		Float:angle;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
 		return SendErrorMessage(playerid, "You can only create graffiti points outside interiors.");

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);

	id = Graffiti_Create(x, y, z, angle);

	if (id == -1)
	    return SendErrorMessage(playerid, "The server has reached the limit for graffiti points.");

	EditDynamicObject(playerid, GraffitiData[id][graffitiObject]);

	PlayerData[playerid][pEditGraffiti] = id;
	SendServerMessage(playerid, "You have successfully created graffiti ID: %d.", id);
	return 1;
}


// ====== CMD:destroygraffiti ======
CMD:destroygraffiti(playerid, params[])
{
	static
	    id = 0;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/destroygraffiti [graffiti id]");

	if ((id < 0 || id >= MAX_GRAFFITI_POINTS) || !GraffitiData[id][graffitiExists])
	    return SendErrorMessage(playerid, "You have specified an invalid graffiti ID.");

	Graffiti_Delete(id);
	SendServerMessage(playerid, "You have successfully destroyed graffiti ID: %d.", id);
	return 1;
}


// ====== CMD:fspray ======
CMD:fspray(playerid, params[])
{
	new id = Graffiti_Nearest(playerid);

	if (id == -1)
	    return SendErrorMessage(playerid, "You are not near any graffiti point.");

	if (GetFactionType(playerid) != FACTION_GANG)
	    return SendErrorMessage(playerid, "You are not a member of an illegal faction.");

	Dialog_Show(playerid, GraffitiColor, DIALOG_STYLE_LIST, DialogStyle_Title("Select Color"), DialogStyle_Body("{FFFFFF}White\n{FF0000}Red\n{FFFF00}Yellow\n{33CC33}Green\n{33CCFF}Light Blue\n{FFA500}Orange\n{1394BF}Dark Blue"), "Select", "Cancel");
	return 1;
}


// ====== CMD:afire ======
CMD:afire(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	static
	    Float:fX,
	    Float:fY,
	    Float:fZ;

	RandomFire();

	GetDynamicObjectPos(g_aFireObjects[0], fX, fY, fZ);
	SendServerMessage(playerid, "You have created a random fire (%s).", GetLocation(fX, fY, fZ));
	return 1;
}


// ====== CMD:akillfire ======
CMD:akillfire(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	for (new i = 0; i < sizeof(g_aFireObjects); i ++)
	{
	    g_aFireExtinguished[i] = 0;

	    if (IsValidDynamicObject(g_aFireObjects[i]))
	        DestroyDynamicObject(g_aFireObjects[i]);
	}
	SendServerMessage(playerid, "You have killed the fire.");
	return 1;
}


// ====== CMD:createdetector ======
CMD:createdetector(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	static
	    query[255];

	for (new i = 0; i < MAX_METAL_DETECTORS; i ++) if (!MetalDetectors[i][detectorExists])
	{
	    MetalDetectors[i][detectorExists] = 1;
	    MetalDetectors[i][detectorInterior] = GetPlayerInterior(playerid);
	    MetalDetectors[i][detectorWorld] = GetPlayerVirtualWorld(playerid);

	    GetPlayerPos(playerid, MetalDetectors[i][detectorPos][0], MetalDetectors[i][detectorPos][1], MetalDetectors[i][detectorPos][2]);
	    GetPlayerFacingAngle(playerid, MetalDetectors[i][detectorPos][3]);

		format(query, sizeof(query), "INSERT INTO `detectors` (`detectorX`, `detectorY`, `detectorZ`, `detectorAngle`, `detectorInterior`, `detectorWorld`) VALUES('%.4f', '%.4f', '%.4f', '%.4f', '%d', '%d')", MetalDetectors[i][detectorPos][0], MetalDetectors[i][detectorPos][1], MetalDetectors[i][detectorPos][2], MetalDetectors[i][detectorPos][3], MetalDetectors[i][detectorInterior], MetalDetectors[i][detectorWorld]);
		mysql_tquery(g_iHandle, query, "OnDetectorCreated", "d", i);

	    Detector_Refresh(i);
	    SendServerMessage(playerid, "You have created metal detector ID: %d.", i);
	    return 1;
	}
	SendErrorMessage(playerid, "The server has reached a limit for metal detectors.");
	return 1;
}


// ====== CMD:destroydetector ======
CMD:destroydetector(playerid, params[])
{
	static
	    id = 0;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/destroydetector [detector id]");

	if ((id < 0 || id >= MAX_METAL_DETECTORS) || !MetalDetectors[id][detectorExists])
	    return SendErrorMessage(playerid, "You have specified an invalid detector ID.");

	Detector_Delete(id);
	SendServerMessage(playerid, "You have successfully destroyed detector ID: %d.", id);
	return 1;
}


// ====== CMD:picklock ======
CMD:picklock(playerid, params[])
{
	new id = Car_Nearest(playerid);

	if (!Inventory_HasItem(playerid, "Crowbar"))
	    return SendErrorMessage(playerid, "You don't have a crowbar.");

	if (id == -1)
	    return SendErrorMessage(playerid, "You are not in range of any vehicle.");

	if (!CarData[id][carLocked])
	    return SendErrorMessage(playerid, "This vehicle is not locked.");

	PlayerData[playerid][pPicking] = 1;
	PlayerData[playerid][pPickCar] = id;

	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out a crowbar and picks the lock.", ReturnName(playerid, 0));
	SendServerMessage(playerid, "Please wait 60 seconds while the lock is picked.");
	return 1;
}


// ====== CMD:destroyplant ======
CMD:destroyplant(playerid, params[])
{
	static
	    id = 0;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/destroyplant [plant id]");

	if ((id < 0 || id >= MAX_DRUG_PLANTS) || !PlantData[id][plantExists])
	    return SendErrorMessage(playerid, "You have specified an invalid plant ID.");

	Plant_Delete(id);
	SendServerMessage(playerid, "You have successfully destroyed plant ID: %d.", id);
	return 1;
}


// ====== CMD:stopanim ======
CMD:stopanim(playerid, params[])
{
	if (!AnimationCheck(playerid))
	    return SendErrorMessage(playerid, "You don't need to use this command right now.");

	ClearAnimations(playerid, 1);
    HidePlayerFooter(playerid);

	PlayerData[playerid][pLoopAnim] = 0;
	SendServerMessage(playerid, "You have stopped any animations.");
	return 1;
}

