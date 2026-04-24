/*
    File: modules/property/commands/property.pwn
    Purpose: Contains ZCMD command handlers for property property features.
    Notes: Keep command parsing here and delegate reusable gameplay work to logic files.
*/

// ====== CMD:createhouse ======
CMD:createhouse(playerid, params[])
{
	static
	    price,
	    id,
	    address[32];

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "ds[32]", price, address))
	    return SendSyntaxMessage(playerid, "/createhouse [price] [address]");

	for (new i = 0; i != MAX_HOUSES; i ++) if (HouseData[i][houseExists] && !strcmp(HouseData[i][houseAddress], address, true)) {
	    return SendErrorMessage(playerid, "The address \"%s\" is already in use (ID: %d).", address, i);
	}
	id = House_Create(playerid, address, price);

	if (id == -1)
	    return SendErrorMessage(playerid, "The server has reached the limit for houses.");

	SendServerMessage(playerid, "You have successfully created house ID: %d.", id);
	return 1;
}


// ====== CMD:destroyhouse ======
CMD:destroyhouse(playerid, params[])
{
	static
	    id = 0;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/destroyhouse [house id]");

	if ((id < 0 || id >= MAX_HOUSES) || !HouseData[id][houseExists])
	    return SendErrorMessage(playerid, "You have specified an invalid house ID.");

	House_Delete(id);
	SendServerMessage(playerid, "You have successfully destroyed house ID: %d.", id);
	return 1;
}


// ====== CMD:bizcmds ======
CMD:bizcmds(playerid, params[])
{
	SendClientMessage(playerid, COLOR_CLIENT, "BUSINESSES:{FFFFFF} /buy, /abandon, /lock, /vault, /products, /binfo, /bname, /bmessage, /bshipment.");
	return 1;
}


// ====== CMD:housecmds ======
CMD:housecmds(playerid, params[])
{
	SendClientMessage(playerid, COLOR_CLIENT, "HOUSES:{FFFFFF} /buy, /abandon, /lock, /storage, /furniture, /buyrack, /gunrack, /deleterack.");
	SendClientMessage(playerid, COLOR_CLIENT, "HOUSES:{FFFFFF} /doorbell, /switch.");
	return 1;
}


// ====== CMD:buy ======
CMD:buy(playerid, params[])
{
	static
		id = -1;

	if ((id = House_Nearest(playerid)) != -1)
	{
		if (House_GetCount(playerid) >= MAX_OWNABLE_HOUSES)
			return SendErrorMessage(playerid, "You can only own %d houses at a time.", MAX_OWNABLE_HOUSES);

		if (HouseData[id][houseOwner] != 0)
		    return SendErrorMessage(playerid, "This house is already owned at the moment.");

		if (HouseData[id][housePrice] > GetMoney(playerid))
		    return SendErrorMessage(playerid, "You have insufficient funds for the purchase.");

	    HouseData[id][houseOwner] = GetPlayerSQLID(playerid);

		House_Refresh(id);
		House_Save(id);

	    GiveMoney(playerid, -HouseData[id][housePrice]);
	    SendServerMessage(playerid, "You have purchased \"%s\" for %s!", HouseData[id][houseAddress], FormatNumber(HouseData[id][housePrice]));

		ShowPlayerFooter(playerid, "You have ~g~purchased~w~ a house!");
	    Log_Write("logs/house_log.txt", "[%s] %s has purchased house ID: %d for %s.", ReturnDate(), ReturnName(playerid), id, FormatNumber(HouseData[id][housePrice]));
	}
	else if ((id = Business_Nearest(playerid)) != -1)
	{
	    if (Business_GetCount(playerid) >= MAX_OWNABLE_BUSINESSES)
			return SendErrorMessage(playerid, "You can only own %d businesses at a time.", MAX_OWNABLE_BUSINESSES);

		if (BusinessData[id][bizOwner] != 0)
		    return SendErrorMessage(playerid, "This business is already owned at the moment.");

		if (BusinessData[id][bizPrice] > GetMoney(playerid))
		    return SendErrorMessage(playerid, "You have insufficient funds for the purchase.");

	    BusinessData[id][bizOwner] = GetPlayerSQLID(playerid);

		Business_Refresh(id);
		Business_Save(id);

	    GiveMoney(playerid, -BusinessData[id][bizPrice]);
	    SendServerMessage(playerid, "You have purchased \"%s\" for %s!", BusinessData[id][bizName], FormatNumber(BusinessData[id][bizPrice]));

		ShowPlayerFooter(playerid, "You have ~g~purchased~w~ a business!");
	    Log_Write("logs/biz_log.txt", "[%s] %s has purchased business ID: %d for %s.", ReturnDate(), ReturnName(playerid), id, FormatNumber(BusinessData[id][bizPrice]));
	}
	else if ((id = Business_Inside(playerid)) != -1)
	{
		if (BusinessData[id][bizLocked] != 0 || !BusinessData[id][bizOwner])
		    return SendErrorMessage(playerid, "This business is closed!");

		if (BusinessData[id][bizType] == 5) {
		    Business_CarMenu(playerid, id);
		} else {
			Business_PurchaseMenu(playerid, id);
		}
	}
	return 1;
}


// ====== CMD:abandon ======
CMD:abandon(playerid, params[])
{
	static
	    id = -1;

    if (!IsPlayerInAnyVehicle(playerid) && (id = House_Nearest(playerid)) != -1 && House_IsOwner(playerid, id))
	{
	    if (isnull(params) || (!isnull(params) && strcmp(params, "confirm", true) != 0))
	    {
	        SendSyntaxMessage(playerid, "/abandon [confirm]");
	        SendClientMessage(playerid, COLOR_LIGHTRED, "[WARNING]:{FFFFFF} You are about to abandon your house with no refund.");
		}
		else if (!strcmp(params, "confirm", true))
		{
			HouseData[id][houseOwner] = 0;

			House_Refresh(id);
			House_Save(id);

			SendServerMessage(playerid, "You have abandoned your house: %s.", HouseData[id][houseAddress]);
			Log_Write("logs/house_log.txt", "[%s] %s has abandoned house ID: %d.", ReturnDate(), ReturnName(playerid), id);
		}
	}
	else if (!IsPlayerInAnyVehicle(playerid) && (id = Business_Nearest(playerid)) != -1 && Business_IsOwner(playerid, id))
	{
	    if (isnull(params) || (!isnull(params) && strcmp(params, "confirm", true) != 0))
	    {
	        SendSyntaxMessage(playerid, "/abandon [confirm]");
	        SendClientMessage(playerid, COLOR_LIGHTRED, "[WARNING]:{FFFFFF} You are about to abandon your business with no refund.");
		}
		else if (!strcmp(params, "confirm", true))
		{
			BusinessData[id][bizOwner] = 0;

			Business_Refresh(id);
			Business_Save(id);

			SendServerMessage(playerid, "You have abandoned your business: %s.", BusinessData[id][bizName]);
			Log_Write("logs/biz_log.txt", "[%s] %s has abandoned business ID: %d.", ReturnDate(), ReturnName(playerid), id);
		}
	}
	else if ((id = Car_Inside(playerid)) != -1 && Car_IsOwner(playerid, id))
	{
	    if (isnull(params) || (!isnull(params) && strcmp(params, "confirm", true) != 0))
	    {
	        SendSyntaxMessage(playerid, "/abandon [confirm]");
	        SendClientMessage(playerid, COLOR_LIGHTRED, "[WARNING]:{FFFFFF} You are about to abandon your vehicle with no refund.");
		}
		else if (CarData[id][carImpounded] != -1)
    		return SendErrorMessage(playerid, "This vehicle is impounded and you can't use it.");

		else if (!strcmp(params, "confirm", true))
		{
			new
			    model = CarData[id][carModel];

			Car_Delete(id);

			SendServerMessage(playerid, "You have abandoned your %s.", ReturnVehicleModelName(model));
			Log_Write("logs/car_log.txt", "[%s] %s has abandoned their %s.", ReturnDate(), ReturnName(playerid), ReturnVehicleModelName(model));
		}
	}
	else SendErrorMessage(playerid, "You are not in range of anything you can abandon.");
	return 1;
}


// ====== CMD:switch ======
CMD:switch(playerid, params[])
{
	static
	    id = -1;

	if ((id = House_Inside(playerid)) != -1)
	{
		if (!HouseData[id][houseLights])
		{
		    foreach (new i : Player) if (House_Inside(i) == id) {
		        PlayerTextDrawHide(i, PlayerData[i][pTextdraws][62]);
		    }
		    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s flicks the light switch on.", ReturnName(playerid, 0));
		    HouseData[id][houseLights] = true;
		}
		else
		{
		    foreach (new i : Player) if (House_Inside(i) == id) {
		        PlayerTextDrawShow(i, PlayerData[i][pTextdraws][62]);
		    }
		    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s flicks the light switch off.", ReturnName(playerid, 0));
		    HouseData[id][houseLights] = false;
		}
	}
	else {
	    SendErrorMessage(playerid, "You must be in a house to use the lights.");
	}
	return 1;
}


// ====== CMD:lock ======
CMD:lock(playerid, params[])
{
	static
	    id = -1;

	if (!IsPlayerInAnyVehicle(playerid) && (id = (House_Inside(playerid) == -1) ? (House_Nearest(playerid)) : (House_Inside(playerid))) != -1 && House_IsOwner(playerid, id))
	{
		if (!HouseData[id][houseLocked])
		{
			HouseData[id][houseLocked] = true;
			House_Save(id);

			ShowPlayerFooter(playerid, "You have ~r~locked~w~ your house!");
			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
		}
		else
		{
			HouseData[id][houseLocked] = false;
			House_Save(id);

			ShowPlayerFooter(playerid, "You have ~g~unlocked~w~ your house!");
			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
		}
	}
	else if (!IsPlayerInAnyVehicle(playerid) && (id = (Business_Inside(playerid) == -1) ? (Business_Nearest(playerid)) : (Business_Inside(playerid))) != -1)
	{
		if (Business_IsOwner(playerid, id))
		{
			if (!BusinessData[id][bizLocked])
			{
				BusinessData[id][bizLocked] = true;

				Business_Refresh(id);
				Business_Save(id);

				ShowPlayerFooter(playerid, "You have ~r~locked~w~ the business!");
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			}
  			else
			{
				BusinessData[id][bizLocked] = false;

				Business_Refresh(id);
				Business_Save(id);

				ShowPlayerFooter(playerid, "You have ~g~unlocked~w~ the business!");
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			}
		}
	}
	else if (!IsPlayerInAnyVehicle(playerid) && (id = (Entrance_Inside(playerid) == -1) ? (Entrance_Nearest(playerid)) : (Entrance_Inside(playerid))) != -1)
	{
		if (strlen(EntranceData[id][entrancePass]))
		{
			Dialog_Show(playerid, EntrancePass, DIALOG_STYLE_INPUT, "Entrance Pass", "Please enter the password for this entrance:", "Submit", "Cancel");
		}
	}
	else if ((id = Car_Nearest(playerid)) != -1)
	{
	    static
	        engine,
	        lights,
	        alarm,
	        doors,
	        bonnet,
	        boot,
	        objective;

	    GetVehicleParamsEx(CarData[id][carVehicle], engine, lights, alarm, doors, bonnet, boot, objective);

	    if (Car_IsOwner(playerid, id) || (PlayerData[playerid][pFaction] != -1 && CarData[id][carFaction] == GetFactionType(playerid)))
	    {
			if (!CarData[id][carLocked])
			{
				CarData[id][carLocked] = true;
				Car_Save(id);

				ShowPlayerFooter(playerid, "You have ~r~locked~w~ the vehicle!");
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

				SetVehicleParamsEx(CarData[id][carVehicle], engine, lights, alarm, 1, bonnet, boot, objective);
			}
			else
			{
				CarData[id][carLocked] = false;
				Car_Save(id);

				ShowPlayerFooter(playerid, "You have ~g~unlocked~w~ the vehicle!");
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

				SetVehicleParamsEx(CarData[id][carVehicle], engine, lights, alarm, 0, bonnet, boot, objective);
			}
		}
	}
	else SendErrorMessage(playerid, "You are not in range of anything you can lock.");
	return 1;
}


// ====== CMD:sell ======
CMD:sell(playerid, params[])
{
	static
	    targetid,
	    type[24],
	    string[128];

	if (sscanf(params, "us[24]S()[128]", targetid, type, string))
	{
	    SendSyntaxMessage(playerid, "/sell [playerid/name] [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} house, business, vehicle");
	    return 1;
	}
	if (targetid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, targetid, 5.0))
	{
		SendErrorMessage(playerid, "The player is disconnected or not near you.");
		return 1;
	}
	if (targetid == playerid)
	{
		SendErrorMessage(playerid, "You cannot sell to yourself.");
		return 1;
	}
	if (!strcmp(type, "house", true))
	{
		static
		    price,
			houseid = -1;

		if (sscanf(string, "d", price))
			return SendSyntaxMessage(playerid, "/sell [playerid/name] [house] [price]");

		if (price < 1)
		    return SendErrorMessage(playerid, "The price you've entered cannot below the value of $1.");

		if ((houseid = House_Nearest(playerid)) != -1 && House_IsOwner(playerid, houseid)) {
			PlayerData[targetid][pHouseSeller] = playerid;
			PlayerData[targetid][pHouseOffered] = houseid;
			PlayerData[targetid][pHouseValue] = price;

		    SendServerMessage(playerid, "You have requested %s to purchase your house (%s).", ReturnName(targetid, 0), FormatNumber(price));
            SendServerMessage(targetid, "%s has offered you their house for %s (type \"/approve house\" to accept).", ReturnName(playerid, 0), FormatNumber(price));
		}
		else SendErrorMessage(playerid, "You are not in range of any of your houses.");
	}
	else if (!strcmp(type, "business", true))
	{
		static
		    price,
			bizid = -1;

		if (sscanf(string, "d", price))
			return SendSyntaxMessage(playerid, "/sell [playerid/name] [business] [price]");

		if (price < 1)
		    return SendErrorMessage(playerid, "The price you've entered cannot below the value of $1.");

		if ((bizid = Business_Nearest(playerid)) != -1 && Business_IsOwner(playerid, bizid)) {
			PlayerData[targetid][pBusinessSeller] = playerid;
			PlayerData[targetid][pBusinessOffered] = bizid;
			PlayerData[targetid][pBusinessValue] = price;

		    SendServerMessage(playerid, "You have requested %s to purchase your business (%s).", ReturnName(targetid, 0), FormatNumber(price));
            SendServerMessage(targetid, "%s has offered you their business for %s (type \"/approve business\" to accept).", ReturnName(playerid, 0), FormatNumber(price));
		}
		else SendErrorMessage(playerid, "You are not in range of any of your businesses.");
	}
	else if (!strcmp(type, "vehicle", true))
	{
		static
		    price,
			carid = -1;

		if (sscanf(string, "d", price))
			return SendSyntaxMessage(playerid, "/sell [playerid/name] [veh] [price]");

		if (price < 1)
		    return SendErrorMessage(playerid, "The price you've entered cannot below the value of $1.");

		if ((carid = Car_Inside(playerid)) != -1 && Car_IsOwner(playerid, carid)) {
			PlayerData[targetid][pCarSeller] = playerid;
			PlayerData[targetid][pCarOffered] = carid;
			PlayerData[targetid][pCarValue] = price;

		    SendServerMessage(playerid, "You have requested %s to purchase your %s (%s).", ReturnName(targetid, 0), ReturnVehicleModelName(CarData[carid][carModel]), FormatNumber(price));
            SendServerMessage(targetid, "%s has offered you their %s for %s (type \"/approve car\" to accept).", ReturnName(playerid, 0), ReturnVehicleModelName(CarData[carid][carModel]), FormatNumber(price));
		}
		else SendErrorMessage(playerid, "You are not inside any of your vehicles.");
	}
	return 1;
}


// ====== CMD:approve ======
CMD:approve(playerid, params[])
{
	if (isnull(params))
 	{
	 	SendSyntaxMessage(playerid, "/approve [name]");
		SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} house, business, car, food, faction, greet, frisk");
		return 1;
	}
	if (!strcmp(params, "house", true) && PlayerData[playerid][pHouseSeller] != INVALID_PLAYER_ID)
	{
	    new
	        sellerid = PlayerData[playerid][pHouseSeller],
	        houseid = PlayerData[playerid][pHouseOffered],
	        price = PlayerData[playerid][pHouseValue];

		if (!IsPlayerNearPlayer(playerid, sellerid, 6.0))
		    return SendErrorMessage(playerid, "You are not near that player.");

		if (GetMoney(playerid) < price)
		    return SendErrorMessage(playerid, "You have insufficient funds to purchase this house.");

		if (House_Nearest(playerid) != houseid)
		    return SendErrorMessage(playerid, "You must be near the house to purchase it.");

		if (!House_IsOwner(sellerid, houseid))
		    return SendErrorMessage(playerid, "This house offer is no longer valid.");

		SendServerMessage(playerid, "You have successfully purchased %s's house for %s.", ReturnName(sellerid, 0), FormatNumber(price));
		SendServerMessage(sellerid, "%s has successfully purchased your house for %s.", ReturnName(playerid, 0), FormatNumber(price));

		HouseData[houseid][houseOwner] = GetPlayerSQLID(playerid);
		House_Save(houseid);

		GiveMoney(playerid, -price);
		GiveMoney(playerid, price);

		Log_Write("logs/offer_log.txt", "[%s] %s (%s) has sold a house to %s (%s) for %s.", ReturnDate(), ReturnName(playerid, 0), PlayerData[playerid][pIP], ReturnName(sellerid, 0), PlayerData[sellerid][pIP], FormatNumber(price));

		PlayerData[playerid][pHouseSeller] = INVALID_PLAYER_ID;
		PlayerData[playerid][pHouseOffered] = -1;
		PlayerData[playerid][pHouseValue] = 0;
	}
	if (!strcmp(params, "business", true) && PlayerData[playerid][pBusinessSeller] != INVALID_PLAYER_ID)
	{
	    new
	        sellerid = PlayerData[playerid][pBusinessSeller],
	        bizid = PlayerData[playerid][pBusinessOffered],
	        price = PlayerData[playerid][pBusinessValue];

		if (!IsPlayerNearPlayer(playerid, sellerid, 6.0))
		    return SendErrorMessage(playerid, "You are not near that player.");

		if (GetMoney(playerid) < price)
		    return SendErrorMessage(playerid, "You have insufficient funds to purchase this business.");

		if (Business_Nearest(playerid) != bizid)
		    return SendErrorMessage(playerid, "You must be near the business to purchase it.");

		if (!Business_IsOwner(sellerid, bizid))
		    return SendErrorMessage(playerid, "This business offer is no longer valid.");

		SendServerMessage(playerid, "You have successfully purchased %s's business for %s.", ReturnName(sellerid, 0), FormatNumber(price));
		SendServerMessage(sellerid, "%s has successfully purchased your business for %s.", ReturnName(playerid, 0), FormatNumber(price));

		BusinessData[bizid][bizOwner] = GetPlayerSQLID(playerid);
		Business_Save(bizid);

		GiveMoney(playerid, -price);
		GiveMoney(playerid, price);

		Log_Write("logs/offer_log.txt", "[%s] %s (%s) has sold a business to %s (%s) for %s.", ReturnDate(), ReturnName(playerid, 0), PlayerData[playerid][pIP], ReturnName(sellerid, 0), PlayerData[sellerid][pIP], FormatNumber(price));

		PlayerData[playerid][pBusinessSeller] = INVALID_PLAYER_ID;
		PlayerData[playerid][pBusinessOffered] = -1;
		PlayerData[playerid][pBusinessValue] = 0;
	}
	if (!strcmp(params, "car", true) && PlayerData[playerid][pCarSeller] != INVALID_PLAYER_ID)
	{
	    new
	        sellerid = PlayerData[playerid][pCarSeller],
	        carid = PlayerData[playerid][pCarOffered],
	        price = PlayerData[playerid][pCarValue];

		if (!IsPlayerNearPlayer(playerid, sellerid, 6.0))
		    return SendErrorMessage(playerid, "You are not near that player.");

		if (GetMoney(playerid) < price)
		    return SendErrorMessage(playerid, "You have insufficient funds to purchase this vehicle.");

		if (Car_Nearest(playerid) != carid)
		    return SendErrorMessage(playerid, "You must be near the vehicle to purchase it.");

		if (!Car_IsOwner(sellerid, carid))
		    return SendErrorMessage(playerid, "This vehicle offer is no longer valid.");

		SendServerMessage(playerid, "You have successfully purchased %s's %s for %s.", ReturnName(sellerid, 0), ReturnVehicleModelName(CarData[carid][carModel]), FormatNumber(price));
		SendServerMessage(sellerid, "%s has successfully purchased your %s for %s.", ReturnName(playerid, 0), ReturnVehicleModelName(CarData[carid][carModel]), FormatNumber(price));

		CarData[carid][carOwner] = GetPlayerSQLID(playerid);
		Car_Save(carid);

		GiveMoney(playerid, -price);
		GiveMoney(playerid, price);

		Log_Write("logs/offer_log.txt", "[%s] %s (%s) has sold a %s to %s (%s) for %s.", ReturnDate(), ReturnName(playerid, 0), PlayerData[playerid][pIP], ReturnVehicleModelName(CarData[carid][carModel]), ReturnName(sellerid, 0), PlayerData[sellerid][pIP], FormatNumber(price));

		PlayerData[playerid][pCarSeller] = INVALID_PLAYER_ID;
		PlayerData[playerid][pCarOffered] = -1;
		PlayerData[playerid][pCarValue] = 0;
	}
	if (!strcmp(params, "food", true) && PlayerData[playerid][pFoodSeller] != INVALID_PLAYER_ID)
	{
	    new
	        sellerid = PlayerData[playerid][pFoodSeller],
			type = PlayerData[playerid][pFoodType],
	        price = PlayerData[playerid][pFoodPrice];

		if (!IsPlayerNearPlayer(playerid, sellerid, 6.0))
		    return SendErrorMessage(playerid, "You are not near that player.");

		if (GetMoney(playerid) < price)
		    return SendErrorMessage(playerid, "You have insufficient funds for the food.");

		switch (type)
		{
		    case 1:
		    {
				new id = Inventory_Add(playerid, "Water Bottle", 2958);

				if (id == -1)
				    return SendErrorMessage(playerid, "You don't have anymore room in your inventory.");

		        SendServerMessage(playerid, "You have purchased some water from %s for $%d (added to inventory).", ReturnName(sellerid, 0), price);
		        SendServerMessage(sellerid, "%s has accepted the water for $%d.", ReturnName(playerid, 0), price);
			}
			case 2:
		    {
				new id = Inventory_Add(playerid, "Soda", 1543);

				if (id == -1)
				    return SendErrorMessage(playerid, "You don't have anymore room in your inventory.");

		        SendServerMessage(playerid, "You have purchased a soda from %s for $%d (added to inventory).", ReturnName(sellerid, 0), price);
		        SendServerMessage(sellerid, "%s has accepted the soda for $%d.", ReturnName(playerid, 0), price);
			}
			case 3:
		    {
				new id = Inventory_Add(playerid, "Cooked Burger", 2703);

				if (id == -1)
				    return SendErrorMessage(playerid, "You don't have anymore room in your inventory.");

		        SendServerMessage(playerid, "You have purchased a burger from %s for $%d (added to inventory).", ReturnName(sellerid, 0), price);
		        SendServerMessage(sellerid, "%s has acceptedthe burger for $%d.", ReturnName(playerid, 0), price);
			}
			case 4:
		    {
				new id = Inventory_Add(playerid, "Cooked Pizza", 2702);

				if (id == -1)
				    return SendErrorMessage(playerid, "You don't have anymore room in your inventory.");

		        SendServerMessage(playerid, "You have purchased a slice of pizza from %s for $%d (added to inventory).", ReturnName(sellerid, 0), price);
		        SendServerMessage(sellerid, "%s has accepted the slice of pizza for $%d.", ReturnName(playerid, 0), price);
			}
			case 5:
		    {
				new id = Inventory_Add(playerid, "Chicken", 2663);

				if (id == -1)
				    return SendErrorMessage(playerid, "You don't have anymore room in your inventory.");

		        SendServerMessage(playerid, "You have purchased some chicken from %s for $%d (added to inventory).", ReturnName(sellerid, 0), price);
		        SendServerMessage(sellerid, "%s has accepted the chicken for $%d.", ReturnName(playerid, 0), price);
			}
		}
		PlayerData[playerid][pFoodSeller] = INVALID_PLAYER_ID;
		PlayerData[playerid][pFoodType] = 0;
		PlayerData[playerid][pFoodPrice] = 0;
	}
	if (!strcmp(params, "faction", true) && PlayerData[playerid][pFactionOffer] != INVALID_PLAYER_ID)
	{
	    new
	        targetid = PlayerData[playerid][pFactionOffer],
	        factionid = PlayerData[playerid][pFactionOffered];

		if (!FactionData[factionid][factionExists] || PlayerData[targetid][pFactionRank] < FactionData[PlayerData[targetid][pFaction]][factionRanks] - 1)
	   	 	return SendErrorMessage(playerid, "The faction offer is no longer available.");

		SetFaction(playerid, factionid);
		PlayerData[playerid][pFactionRank] = 1;

		SendServerMessage(playerid, "You have accepted %s's offer to join \"%s\".", ReturnName(targetid, 0), Faction_GetName(targetid));
		SendServerMessage(targetid, "%s has accepted your offer to join \"%s\".", ReturnName(playerid, 0), Faction_GetName(targetid));

        PlayerData[playerid][pFactionOffer] = INVALID_PLAYER_ID;
        PlayerData[playerid][pFactionOffered] = -1;
	}
	if (!strcmp(params, "greet", true) && PlayerData[playerid][pShakeOffer] != INVALID_PLAYER_ID)
	{
	    new
	        targetid = PlayerData[playerid][pShakeOffer],
	        type = PlayerData[playerid][pShakeType];

        if (!IsPlayerNearPlayer(playerid, targetid, 6.0))
		    return SendErrorMessage(playerid, "You are not near that player.");

		SetPlayerToFacePlayer(playerid, targetid);
		SetPlayerToFacePlayer(targetid, playerid);

		PlayerData[playerid][pShakeOffer] = INVALID_PLAYER_ID;
		PlayerData[playerid][pShakeType] = 0;

		switch (type)
		{
		    case 1:
			{
				ApplyAnimation(playerid, "GANGS", "hndshkaa", 4.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(targetid, "GANGS", "hndshkaa", 4.0, 0, 0, 0, 0, 0, 1);
			}
			case 2:
			{
				ApplyAnimation(playerid, "GANGS", "hndshkba", 4.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(targetid, "GANGS", "hndshkba", 4.0, 0, 0, 0, 0, 0, 1);
			}
			case 3:
			{
				ApplyAnimation(playerid, "GANGS", "hndshkda", 4.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(targetid, "GANGS", "hndshkda", 4.0, 0, 0, 0, 0, 0, 1);
			}
			case 4:
			{
				ApplyAnimation(playerid, "GANGS", "hndshkea", 4.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(targetid, "GANGS", "hndshkea", 4.0, 0, 0, 0, 0, 0, 1);
			}
			case 5:
			{
				ApplyAnimation(playerid, "GANGS", "hndshkfa", 4.0, 0, 0, 0, 0, 0, 1);
				ApplyAnimation(targetid, "GANGS", "hndshkfa", 4.0, 0, 0, 0, 0, 0, 1);
			}
			case 6:
			{
			    ApplyAnimation(playerid, "GANGS", "prtial_hndshk_biz_01", 4.0, 0, 0, 0, 0, 0, 1);
			    ApplyAnimation(targetid, "GANGS", "prtial_hndshk_biz_01", 4.0, 0, 0, 0, 0, 0, 1);
			}
	    }
	    SendServerMessage(playerid, "You have accepted %s's handshake.", ReturnName(targetid, 0));
	    SendServerMessage(targetid, "%s has accepted your handshake.", ReturnName(playerid, 0));
	}
	if (!strcmp(params, "frisk", true) && PlayerData[playerid][pFriskOffer] != INVALID_PLAYER_ID)
	{
	    new
			targetid = PlayerData[playerid][pFriskOffer];

	    if (!IsPlayerNearPlayer(playerid, targetid, 6.0))
		    return SendErrorMessage(playerid, "You are not near that player.");

		new
		    models[MAX_INVENTORY],
		    amount[MAX_INVENTORY];

		for (new i = 0; i < PlayerData[playerid][pCapacity]; i ++)
		{
	 		if (InventoryData[playerid][i][invExists]) {
	   			models[i] = InventoryData[playerid][i][invModel];
	   			amount[i] = InventoryData[playerid][i][invQuantity];
			}
			else {
			    models[i] = -1;
			    amount[i] = -1;
			}
		}
		PlayerData[playerid][pFriskOffer] = INVALID_PLAYER_ID;
		ShowModelSelectionMenu(targetid, ReturnName(playerid), MODEL_SELECTION_FRISK, models, sizeof(models), 0.0, 0.0, 0.0, 1.0, -1, true, amount);
	}
	return 1;
}


// ====== CMD:storage ======
CMD:storage(playerid, params[])
{
	static
	    houseid = -1;

	if ((houseid = House_Inside(playerid)) != -1 && (House_IsOwner(playerid, houseid) || GetFactionType(playerid) == FACTION_POLICE)) {
	    House_OpenStorage(playerid, houseid);
	}
	else SendErrorMessage(playerid, "You are not in range of your house interior.");
	return 1;
}


// ====== CMD:edithouse ======
CMD:edithouse(playerid, params[])
{
	static
	    id,
	    type[24],
	    string[128];

	if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/edithouse [id] [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, interior, price, address, type");
		return 1;
	}
	if ((id < 0 || id >= MAX_HOUSES) || !HouseData[id][houseExists])
	    return SendErrorMessage(playerid, "You have specified an invalid house ID.");

	if (!strcmp(type, "location", true))
	{
		GetPlayerPos(playerid, HouseData[id][housePos][0], HouseData[id][housePos][1], HouseData[id][housePos][2]);
		GetPlayerFacingAngle(playerid, HouseData[id][housePos][3]);

		HouseData[id][houseExterior] = GetPlayerInterior(playerid);
		HouseData[id][houseExteriorVW] = GetPlayerVirtualWorld(playerid);

		House_Refresh(id);
		House_Save(id);

		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the location of house ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "interior", true))
	{
	    GetPlayerPos(playerid, HouseData[id][houseInt][0], HouseData[id][houseInt][1], HouseData[id][houseInt][2]);
		GetPlayerFacingAngle(playerid, HouseData[id][houseInt][3]);

		HouseData[id][houseInterior] = GetPlayerInterior(playerid);

        foreach (new i : Player)
		{
			if (PlayerData[i][pHouse] == HouseData[id][houseID])
			{
				SetPlayerPos(i, HouseData[id][houseInt][0], HouseData[id][houseInt][1], HouseData[id][houseInt][2]);
				SetPlayerFacingAngle(i, HouseData[id][houseInt][3]);

				SetPlayerInterior(i, HouseData[id][houseInterior]);
				SetCameraBehindPlayer(i);
			}
		}
		House_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the interior spawn of house ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "price", true))
	{
	    new price;

	    if (sscanf(string, "d", price))
	        return SendSyntaxMessage(playerid, "/edithouse [id] [price] [new price]");

	    HouseData[id][housePrice] = price;

	    House_Refresh(id);
	    House_Save(id);

		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the price of house ID: %d to %s.", ReturnName(playerid, 0), id, FormatNumber(price));
	}
	else if (!strcmp(type, "address", true))
	{
	    new address[32];

	    if (sscanf(string, "s[32]", address))
	        return SendSyntaxMessage(playerid, "/edithouse [id] [address] [new address]");

	    format(HouseData[id][houseAddress], 32, address);

	    House_Refresh(id);
	    House_Save(id);

		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the address of house ID: %d to \"%s\".", ReturnName(playerid, 0), id, address);
	}
	else if (!strcmp(type, "type", true))
	{
	    new typeint;

	    if (sscanf(string, "d", typeint))
	        return SendSyntaxMessage(playerid, "/edithouse [id] [type] [interior type]");

		if (typeint < 1 || typeint > sizeof(arrHouseInteriors))
			return SendErrorMessage(playerid, "The specified type must be between 1 and %d.", sizeof(arrHouseInteriors));

	    HouseData[id][houseInt][0] = arrHouseInteriors[typeint][eHouseX];
	    HouseData[id][houseInt][1] = arrHouseInteriors[typeint][eHouseY];
	    HouseData[id][houseInt][2] = arrHouseInteriors[typeint][eHouseZ];
	    HouseData[id][houseInt][3] = arrHouseInteriors[typeint][eHouseAngle];
        HouseData[id][houseInterior] = arrHouseInteriors[typeint][eHouseInterior];

		foreach (new i : Player)
		{
			if (PlayerData[i][pHouse] == HouseData[id][houseID])
			{
				SetPlayerPos(i, HouseData[id][houseInt][0], HouseData[id][houseInt][1], HouseData[id][houseInt][2]);
				SetPlayerFacingAngle(i, HouseData[id][houseInt][3]);

				SetPlayerInterior(i, HouseData[id][houseInterior]);
				SetCameraBehindPlayer(i);
			}
		}
	    House_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the type of house ID: %d to %d.", ReturnName(playerid, 0), id, typeint);
	}
	return 1;
}


// ====== CMD:near ======
CMD:near(playerid, params[])
{
	static
	    id = -1;

    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if ((id = House_Nearest(playerid)) != -1)
	    SendServerMessage(playerid, "You are standing near house ID: %d.", id);

    if ((id = Business_Nearest(playerid)) != -1)
	    SendServerMessage(playerid, "You are standing near business ID: %d.", id);

    if ((id = Entrance_Nearest(playerid)) != -1)
	    SendServerMessage(playerid, "You are standing near entrance ID: %d.", id);

    if ((id = Job_Nearest(playerid)) != -1)
	    SendServerMessage(playerid, "You are standing near job ID: %d.", id);

    if ((id = Arrest_Nearest(playerid)) != -1)
	    SendServerMessage(playerid, "You are standing near arrest point ID: %d.", id);

    if ((id = Pump_Nearest(playerid)) != -1)
	    SendServerMessage(playerid, "You are standing near pump ID: %d.", id);

    if ((id = Crate_Nearest(playerid)) != -1)
	    SendServerMessage(playerid, "You are standing near crate ID: %d.", id);

    if ((id = Gate_Nearest(playerid)) != -1)
	    SendServerMessage(playerid, "You are standing near gate ID: %d.", id);

    if ((id = ATM_Nearest(playerid)) != -1)
	    SendServerMessage(playerid, "You are standing near ATM ID: %d.", id);

    if ((id = Garbage_Nearest(playerid)) != -1)
	    SendServerMessage(playerid, "You are standing near garbage bin ID: %d.", id);

    if ((id = Vendor_Nearest(playerid)) != -1)
	    SendServerMessage(playerid, "You are standing near vendor ID: %d.", id);

	if ((id = Rack_Nearest(playerid)) != -1)
 		SendServerMessage(playerid, "You are standing near weapon rack ID: %d.", id);

    if ((id = Speed_Nearest(playerid)) != -1)
 		SendServerMessage(playerid, "You are standing near speed camera ID: %d.", id);

    if ((id = Graffiti_Nearest(playerid)) != -1)
 		SendServerMessage(playerid, "You are standing near graffiti ID: %d.", id);

    if ((id = Detector_Nearest(playerid)) != -1)
 		SendServerMessage(playerid, "You are standing near detector ID: %d.", id);

	return 1;
}


// ====== CMD:createbiz ======
CMD:createbiz(playerid, params[])
{
    static
		type,
	    price,
	    id;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "dd", type, price))
 	{
	 	SendSyntaxMessage(playerid, "/createbiz [type] [price]");
    	SendClientMessage(playerid, COLOR_YELLOW, "[TYPES]:{FFFFFF} 1: Retail | 2: Weapons | 3: Clothes | 4: Fast Food | 5: Dealership | 6: Gas Station | 7: Furniture");
    	return 1;
	}
	if (type < 1 || type > 7)
	    return SendErrorMessage(playerid, "Invalid type specified. Types range from 1 to 7.");

	id = Business_Create(playerid, type, price);

	if (id == -1)
	    return SendErrorMessage(playerid, "The server has reached the limit for businesses.");

	SendServerMessage(playerid, "You have successfully created business ID: %d.", id);
	return 1;
}


// ====== CMD:editbiz ======
CMD:editbiz(playerid, params[])
{
	static
	    id,
	    type[24],
	    string[128];

	if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editbiz [id] [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, interior, deliver, name, price, stock, type, cars, spawn");
		return 1;
	}
	if ((id < 0 || id >= MAX_BUSINESSES) || !BusinessData[id][bizExists])
	    return SendErrorMessage(playerid, "You have specified an invalid business ID.");

	if (!strcmp(type, "location", true))
	{
 		GetPlayerPos(playerid, BusinessData[id][bizPos][0], BusinessData[id][bizPos][1], BusinessData[id][bizPos][2]);
		GetPlayerFacingAngle(playerid, BusinessData[id][bizPos][3]);

		BusinessData[id][bizExterior] = GetPlayerInterior(playerid);
		BusinessData[id][bizExteriorVW] = GetPlayerVirtualWorld(playerid);

		Business_Refresh(id);
		Business_Save(id);

		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the location of business ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "interior", true))
	{
	    GetPlayerPos(playerid, BusinessData[id][bizInt][0], BusinessData[id][bizInt][1], BusinessData[id][bizInt][2]);
		GetPlayerFacingAngle(playerid, BusinessData[id][bizInt][3]);

		BusinessData[id][bizInterior] = GetPlayerInterior(playerid);

        foreach (new i : Player)
		{
			if (PlayerData[i][pBusiness] == BusinessData[id][bizID])
			{
				SetPlayerPos(i, BusinessData[id][bizInt][0], BusinessData[id][bizInt][1], BusinessData[id][bizInt][2]);
				SetPlayerFacingAngle(i, BusinessData[id][bizInt][3]);

				SetPlayerInterior(i, BusinessData[id][bizInterior]);
				SetCameraBehindPlayer(i);
			}
		}
		Business_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the interior spawn of business ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "deliver", true))
	{
	    if (BusinessData[id][bizType] == 5)
	        return SendErrorMessage(playerid, "This business doesn't accept deliveries.");

	    if (GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
	        return SendErrorMessage(playerid, "You can only place the delivery point outside interiors.");

	    GetPlayerPos(playerid, BusinessData[id][bizDeliver][0], BusinessData[id][bizDeliver][1], BusinessData[id][bizDeliver][2]);
		Business_Refresh(id);

		Business_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the deliver point of business ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "price", true))
	{
	    new price;

	    if (sscanf(string, "d", price))
	        return SendSyntaxMessage(playerid, "/editbiz [id] [price] [new price]");

	    BusinessData[id][bizPrice] = price;

	    Business_Refresh(id);
	    Business_Save(id);

		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the price of business ID: %d to %s.", ReturnName(playerid, 0), id, FormatNumber(price));
	}
	else if (!strcmp(type, "stock", true))
	{
	    new amount;

	    if (sscanf(string, "d", amount))
	        return SendSyntaxMessage(playerid, "/editbiz [id] [stock] [product amount]");

	    BusinessData[id][bizProducts] = amount;

	    Business_Refresh(id);
	    Business_Save(id);

		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the stock of business ID: %d to %s products.", ReturnName(playerid, 0), id, FormatNumber(amount, ""));
	}
	else if (!strcmp(type, "name", true))
	{
	    new name[32];

	    if (sscanf(string, "s[32]", name))
	        return SendSyntaxMessage(playerid, "/editbiz [id] [name] [new name]");

	    format(BusinessData[id][bizName], 32, name);

	    Business_Refresh(id);
	    Business_Save(id);

		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the name of business ID: %d to \"%s\".", ReturnName(playerid, 0), id, name);
	}
	else if (!strcmp(type, "type", true))
	{
	    new typeint;

	    if (sscanf(string, "d", typeint))
	    {
	        SendSyntaxMessage(playerid, "/editbiz [id] [type] [business type]");
			SendClientMessage(playerid, COLOR_YELLOW, "[TYPES]:{FFFFFF} 1: Retail | 2: Weapons | 3: Clothes | 4: Fast Food | 5: Dealership | 6: Gas Station | 7: Furniture");
			return 1;
		}
		if (typeint < 1 || typeint > 7)
			return SendErrorMessage(playerid, "The specified type must be between 1 and 7.");

        BusinessData[id][bizType] = typeint;

        switch (typeint) {
            case 1: {
            	BusinessData[id][bizInt][0] = -27.3074;
           		BusinessData[id][bizInt][1] = -30.8741;
            	BusinessData[id][bizInt][2] = 1003.5573;
            	BusinessData[id][bizInt][3] = 0.0000;
				BusinessData[id][bizInterior] = 4;
            }
            case 2: {
            	BusinessData[id][bizInt][0] = 316.3963;
            	BusinessData[id][bizInt][1] = -169.8375;
            	BusinessData[id][bizInt][2] = 999.6010;
            	BusinessData[id][bizInt][3] = 0.0000;
				BusinessData[id][bizInterior] = 6;
			}
			case 3: {
            	BusinessData[id][bizInt][0] = 161.4801;
            	BusinessData[id][bizInt][1] = -96.5368;
            	BusinessData[id][bizInt][2] = 1001.8047;
            	BusinessData[id][bizInt][3] = 0.0000;
				BusinessData[id][bizInterior] = 18;
			}
			case 4: {
            	BusinessData[id][bizInt][0] = 363.3402;
            	BusinessData[id][bizInt][1] = -74.6679;
            	BusinessData[id][bizInt][2] = 1001.5078;
            	BusinessData[id][bizInt][3] = 315.0000;
				BusinessData[id][bizInterior] = 10;
			}
			case 5: {
            	BusinessData[id][bizInt][0] = 1494.5612;
            	BusinessData[id][bizInt][1] = 1304.2061;
            	BusinessData[id][bizInt][2] = 1093.2891;
            	BusinessData[id][bizInt][3] = 0.0000;
				BusinessData[id][bizInterior] = 3;
			}
			case 6: {
				BusinessData[id][bizInt][0] = -27.3383;
   				BusinessData[id][bizInt][1] = -57.6909;
			   	BusinessData[id][bizInt][2] = 1003.5469;
      			BusinessData[id][bizInt][3] = 0.0000;
				BusinessData[id][bizInterior] = 6;
			}
			case 7: {
				BusinessData[id][bizInt][0] = -2240.4954;
   				BusinessData[id][bizInt][1] = 128.3774;
			   	BusinessData[id][bizInt][2] = 1035.4210;
      			BusinessData[id][bizInt][3] = 270.0000;
				BusinessData[id][bizInterior] = 6;
			}
		}
		foreach (new i : Player)
		{
			if (PlayerData[i][pBusiness] == BusinessData[id][bizID])
			{
				SetPlayerPos(i, BusinessData[id][bizInt][0], BusinessData[id][bizInt][1], BusinessData[id][bizInt][2]);
				SetPlayerFacingAngle(i, BusinessData[id][bizInt][3]);

				SetPlayerInterior(i, BusinessData[id][bizInterior]);
				SetCameraBehindPlayer(i);
			}
		}
		Business_Refresh(id);

	    Business_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the type of business ID: %d to %d.", ReturnName(playerid, 0), id, typeint);
	}
	else if (!strcmp(type, "cars", true))
	{
	    if (BusinessData[id][bizType] != 5)
	        return SendErrorMessage(playerid, "This business is not a dealership!");

		PlayerData[playerid][pDealership] = id;
		Business_EditCars(playerid, id);
	}
	else if (!strcmp(type, "spawn", true))
	{
	    if (BusinessData[id][bizType] != 5)
	        return SendErrorMessage(playerid, "This business is not a dealership!");

	    if (GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
	        return SendErrorMessage(playerid, "You can only place the vehicle spawn outside interiors.");

	    GetPlayerPos(playerid, BusinessData[id][bizSpawn][0], BusinessData[id][bizSpawn][1], BusinessData[id][bizSpawn][2]);
		GetPlayerFacingAngle(playerid, BusinessData[id][bizSpawn][3]);

		BusinessData[id][bizExterior] = GetPlayerInterior(playerid);

		Business_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the vehicle spawn of business ID: %d.", ReturnName(playerid, 0), id);
	}
	return 1;
}


// ====== CMD:products ======
CMD:products(playerid, params[])
{
	static
	    bizid = -1;

	if ((bizid = Business_Inside(playerid)) != -1 && Business_IsOwner(playerid, bizid)) {
	    Business_ProductMenu(playerid, bizid);
	}
	else SendErrorMessage(playerid, "You are not in range of your business interior.");
	return 1;
}


// ====== CMD:bizstate ======
CMD:bizstate(playerid, params[])
{
	static
	    id = 0;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/bizstate [biz id]");

	if ((id < 0 || id >= MAX_BUSINESSES) || !BusinessData[id][bizExists])
	    return SendErrorMessage(playerid, "You have specified an invalid business ID.");

	BusinessData[id][bizOwner] = 99999999;

	Business_Refresh(id);
	Business_Save(id);

	SendServerMessage(playerid, "This business is now owned by the state (/bizcmds).", id);
	return 1;
}


// ====== CMD:destroybiz ======
CMD:destroybiz(playerid, params[])
{
	static
	    id = 0;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/destroybiz [biz id]");

	if ((id < 0 || id >= MAX_BUSINESSES) || !BusinessData[id][bizExists])
	    return SendErrorMessage(playerid, "You have specified an invalid business ID.");

	Business_Delete(id);
	SendServerMessage(playerid, "You have successfully destroyed business ID: %d.", id);
	return 1;
}


// ====== CMD:drink ======
CMD:drink(playerid, params[])
{
    if (PlayerData[playerid][pHospital] != -1 || PlayerData[playerid][pCuffed] || PlayerData[playerid][pInjured] || !IsPlayerSpawned(playerid))
	    return SendErrorMessage(playerid, "You can't use this command now.");

	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/drink [water/soda]");

	if (PlayerData[playerid][pDrinking])
	    return SendErrorMessage(playerid, "You are already drinking from a bottle.");

	if (!strcmp(params, "soda", true))
	{
	    if (!Inventory_HasItem(playerid, "Soda"))
	    	return SendErrorMessage(playerid, "You don't have any bottles of soda on you.");

		if (PlayerData[playerid][pThirst] > 90)
	    	return SendErrorMessage(playerid, "You are not thirsty right now.");

        PlayerData[playerid][pDrinking] = 1;
        PlayerData[playerid][pDrinkBar] = CreatePlayerProgressBar(playerid, 572.00, 440.00, 56.50, 3.20, -1429936641, 100.0);

        ShowPlayerProgressBar(playerid, PlayerData[playerid][pDrinkBar]);
        SetPlayerProgressBarValue(playerid, PlayerData[playerid][pDrinkBar], 100.0);

		Inventory_Add(playerid, "Empty Bottle", 1484);
		Inventory_Remove(playerid, "Soda");

		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK);

 		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out a bottle of soda and opens it.", ReturnName(playerid, 0));
 		ShowPlayerFooter(playerid, "Press ~y~LMB~w~ to take a sip.");
	}
	else if (!strcmp(params, "water", true))
	{
	    if (!Inventory_HasItem(playerid, "Water Bottle"))
	    	return SendErrorMessage(playerid, "You don't have any bottles of water on you.");

		if (PlayerData[playerid][pThirst] > 90)
	    	return SendErrorMessage(playerid, "You are not thirsty right now.");

        PlayerData[playerid][pDrinking] = 2;
        PlayerData[playerid][pDrinkBar] = CreatePlayerProgressBar(playerid, 572.00, 440.00, 56.50, 3.20, -1429936641, 100.0);

        ShowPlayerProgressBar(playerid, PlayerData[playerid][pDrinkBar]);
        SetPlayerProgressBarValue(playerid, PlayerData[playerid][pDrinkBar], 100.0);

		Inventory_Add(playerid, "Empty Bottle", 1484);
		Inventory_Remove(playerid, "Water Bottle");

		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK);

 		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out a bottle of water and opens it.", ReturnName(playerid, 0));
 		ShowPlayerFooter(playerid, "Press ~y~LMB~w~ to take a sip.");
	}
	return 1;
}


// ====== CMD:cook ======
CMD:cook(playerid, params[])
{
	new houseid = House_Inside(playerid);

	if (houseid == -1)
	    return SendErrorMessage(playerid, "You must be inside a house to cook meals.");

	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/cook [burger/pizza]");

    if (PlayerData[playerid][pCuffed])
	    return SendErrorMessage(playerid, "You can't use this command at the moment.");

	if (!strcmp(params, "burger", true))
	{
	    if (!Inventory_HasItem(playerid, "Frozen Burger"))
	        return SendErrorMessage(playerid, "You don't have any frozen burgers.");

		if (PlayerData[playerid][pCooking])
		    return SendErrorMessage(playerid, "You are already cooking a meal.");

		Inventory_Add(playerid, "Cardboard", 928);

		PlayerData[playerid][pCooking] = 1;
		PlayerData[playerid][pCookingTime] = 20;
		PlayerData[playerid][pCookingHouse] = houseid;

		Inventory_Remove(playerid, "Frozen Burger");
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prepares the microwave and heats up a frozen burger (20 seconds).", ReturnName(playerid, 0));
	}
	else if (!strcmp(params, "pizza", true))
	{
	    if (!Inventory_HasItem(playerid, "Frozen Pizza"))
	        return SendErrorMessage(playerid, "You don't have any boxes of frozen pizza.");

		if (PlayerData[playerid][pCooking])
		    return SendErrorMessage(playerid, "You are already cooking a meal.");

        Inventory_Add(playerid, "Cardboard", 928);

		PlayerData[playerid][pCooking] = 2;
		PlayerData[playerid][pCookingTime] = 55;
		PlayerData[playerid][pCookingHouse] = houseid;

        Inventory_Remove(playerid, "Frozen Pizza");
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s prepares the oven and heats up a frozen pizza (55 seconds).", ReturnName(playerid, 0));
	}
	return 1;
}


// ====== CMD:vest ======
CMD:vest(playerid, params[])
{
    if (PlayerData[playerid][pHospital] != -1 || PlayerData[playerid][pCuffed] || PlayerData[playerid][pInjured] || !IsPlayerSpawned(playerid))
	    return SendErrorMessage(playerid, "You can't use this command now.");

	if (!Inventory_HasItem(playerid, "Armored Vest"))
	    return SendErrorMessage(playerid, "You don't have an armored vest.");

	if (ReturnArmour(playerid) > 49)
	    return SendErrorMessage(playerid, "You already have a full vest on.");

	SetPlayerArmour(playerid, 50.0);

	Inventory_Remove(playerid, "Armored Vest");
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out a kevlar vest and puts it on.", ReturnName(playerid, 0));
	return 1;
}


// ====== CMD:vault ======
CMD:vault(playerid, params[])
{
    static
	    bizid = -1,
		type[24],
		str[12],
		amount;

	if ((bizid = Business_Inside(playerid)) != -1 && Business_IsOwner(playerid, bizid))
	{
	    if (sscanf(params, "s[24]S()[12]", type, str))
	    {
			SendSyntaxMessage(playerid, "/vault [name] (%s available)", FormatNumber(BusinessData[bizid][bizVault]));
	        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} withdraw, deposit, balance");
	        return 1;
		}
		if (!strcmp(type, "withdraw", true))
		{
		    if (sscanf(str, "d", amount))
		        return SendSyntaxMessage(playerid, "/vault [withdraw] [amount]");

			if (amount < 1 || amount > BusinessData[bizid][bizVault])
			    return SendErrorMessage(playerid, "Invalid amount specified!");

            BusinessData[bizid][bizVault] -= amount;
            Business_Save(bizid);

            GiveMoney(playerid, amount);
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %s from the business vault.", ReturnName(playerid, 0), FormatNumber(amount));
		}
		else if (!strcmp(type, "deposit", true))
		{
		    if (sscanf(str, "d", amount))
		        return SendSyntaxMessage(playerid, "/vault [deposit] [amount]");

			if (amount < 1 || amount > GetMoney(playerid))
			    return SendErrorMessage(playerid, "Invalid amount specified!");

            BusinessData[bizid][bizVault] += amount;
            Business_Save(bizid);

            GiveMoney(playerid, -amount);
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %s into the business vault.", ReturnName(playerid, 0), FormatNumber(amount));
		}
		else if (!strcmp(type, "balance", true))
		{
		    SendServerMessage(playerid, "\"%s\" has a total vault balance of: %s.", BusinessData[bizid][bizName], FormatNumber(BusinessData[bizid][bizVault]));
		}
	}
	else SendErrorMessage(playerid, "You are not in range of your business interior.");
	return 1;
}


// ====== CMD:createentrance ======
CMD:createentrance(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (isnull(params) || strlen(params) > 32)
	    return SendSyntaxMessage(playerid, "/createentrance [name]");

	new id = Entrance_Create(playerid, params);

	if (id == -1)
	    return SendErrorMessage(playerid, "The server has reached the limit for entrances.");

	SendServerMessage(playerid, "You have successfully created entrance ID: %d.", id);
	return 1;
}


// ====== CMD:editentrance ======
CMD:editentrance(playerid, params[])
{
	static
	    id,
	    type[24],
	    string[128];

	if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editentrance [id] [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, interior, password, name, locked, mapicon, type, custom, virtual");
		return 1;
	}
	if ((id < 0 || id >= MAX_ENTRANCES) || !EntranceData[id][entranceExists])
	    return SendErrorMessage(playerid, "You have specified an invalid entrance ID.");

	if (!strcmp(type, "location", true))
	{
	    GetPlayerPos(playerid, EntranceData[id][entrancePos][0], EntranceData[id][entrancePos][1], EntranceData[id][entrancePos][2]);
		GetPlayerFacingAngle(playerid, EntranceData[id][entrancePos][3]);

		EntranceData[id][entranceExterior] = GetPlayerInterior(playerid);
		EntranceData[id][entranceExteriorVW] = GetPlayerVirtualWorld(playerid);

		Entrance_Refresh(id);
		Entrance_Save(id);

		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the location of entrance ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "interior", true))
	{
	    GetPlayerPos(playerid, EntranceData[id][entranceInt][0], EntranceData[id][entranceInt][1], EntranceData[id][entranceInt][2]);
		GetPlayerFacingAngle(playerid, EntranceData[id][entranceInt][3]);

		EntranceData[id][entranceInterior] = GetPlayerInterior(playerid);

        foreach (new i : Player)
		{
			if (PlayerData[i][pEntrance] == EntranceData[id][entranceID])
			{
				SetPlayerPos(i, EntranceData[id][entranceInt][0], EntranceData[id][entranceInt][1], EntranceData[id][entranceInt][2]);
				SetPlayerFacingAngle(i, EntranceData[id][entranceInt][3]);

				SetPlayerInterior(i, EntranceData[id][entranceInterior]);
				SetCameraBehindPlayer(i);
			}
		}
		Entrance_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the interior spawn of entrance ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "custom", true))
	{
	    new status;

	    if (sscanf(string, "d", status))
	        return SendSyntaxMessage(playerid, "/editentrance [id] [custom] [0/1]");

		if (status < 0 || status > 1)
		    return SendErrorMessage(playerid, "You must specify at least 0 or 1.");

	    EntranceData[id][entranceCustom] = status;
	    Entrance_Save(id);

	    if (status) {
			SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has enabled custom interior mode for entrance ID: %d.", ReturnName(playerid, 0), id);
		}
		else {
		    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has disabled custom interior mode for entrance ID: %d.", ReturnName(playerid, 0), id);
		}
	}
	else if (!strcmp(type, "virtual", true))
	{
	    new worldid;

	    if (sscanf(string, "d", worldid))
	        return SendSyntaxMessage(playerid, "/editentrance [id] [virtual] [interior world]");

	    EntranceData[id][entranceWorld] = worldid;

		foreach (new i : Player) if (Entrance_Inside(i) == id) {
			SetPlayerVirtualWorld(i, worldid);
		}
		Entrance_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the virtual of entrance ID: %d to %d.", ReturnName(playerid, 0), id, worldid);
	}
	else if (!strcmp(type, "mapicon", true))
	{
	    new icon;

	    if (sscanf(string, "d", icon))
	        return SendSyntaxMessage(playerid, "/editentrance [id] [mapicon] [map icon]");

		if (icon < 0 || icon > 63)
		    return SendErrorMessage(playerid, "Invalid map icon! Valid map icons can be found at \"wiki.sa-mp.com/wiki/MapIcons\".");

	    EntranceData[id][entranceIcon] = icon;

	    Entrance_Refresh(id);
	    Entrance_Save(id);

		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the price of entrance ID: %d to %d.", ReturnName(playerid, 0), id, icon);
	}
	else if (!strcmp(type, "password", true))
	{
	    new password[32];

	    if (sscanf(string, "s[32]", password))
	        return SendSyntaxMessage(playerid, "/editentrance [id] [password] [entrance pass] (use 'none' to disable)");

		if (!strcmp(password, "none", true)) {
			EntranceData[id][entrancePass][0] = 0;
		}
		else {
		    format(EntranceData[id][entrancePass], 32, password);
		}
	    Entrance_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the password of entrance ID: %d to \"%s\".", ReturnName(playerid, 0), id, password);
	}
	else if (!strcmp(type, "locked", true))
	{
	    new locked;

	    if (sscanf(string, "d", locked))
	        return SendSyntaxMessage(playerid, "/editentrance [id] [locked] [locked 0/1]");

		if (locked < 0 || locked > 1)
		    return SendErrorMessage(playerid, "Invalid value. Use 0 for unlocked and 1 for locked.");

	    EntranceData[id][entranceLocked] = locked;
	    Entrance_Save(id);

	    if (locked) {
			SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has locked entrance ID: %d.", ReturnName(playerid, 0), id);
		} else {
		    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has unlocked entrance ID: %d.", ReturnName(playerid, 0), id);
		}
	}
	else if (!strcmp(type, "name", true))
	{
	    new name[32];

	    if (sscanf(string, "s[32]", name))
	        return SendSyntaxMessage(playerid, "/editentrance [id] [name] [new name]");

	    format(EntranceData[id][entranceName], 32, name);

	    Entrance_Refresh(id);
	    Entrance_Save(id);

		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the name of entrance ID: %d to \"%s\".", ReturnName(playerid, 0), id, name);
	}
	else if (!strcmp(type, "type", true))
	{
	    new typeint;

	    if (sscanf(string, "d", typeint))
	    {
	        SendSyntaxMessage(playerid, "/editentrance [id] [type] [entrance type]");
			SendClientMessage(playerid, COLOR_YELLOW, "[TYPES]:{FFFFFF} 0: None | 1: DMV | 2: Bank | 3: Warehouse | 4: City Hall | 5: Shooting Range");
			return 1;
		}
		if (typeint < 0 || typeint > 5)
			return SendErrorMessage(playerid, "The specified type must be between 0 and 5.");

		if (EntranceData[id][entranceType] == 3 && typeint != 3) {
		    DestroyForklifts(id);
		}
		else if (EntranceData[id][entranceType] != 3 && typeint == 3) {
		    CreateForklifts(id);
		}
        EntranceData[id][entranceType] = typeint;

        switch (typeint) {
            case 1: {
            	EntranceData[id][entranceInt][0] = -2029.5531;
           		EntranceData[id][entranceInt][1] = -118.8003;
            	EntranceData[id][entranceInt][2] = 1035.1719;
            	EntranceData[id][entranceInt][3] = 0.0000;
				EntranceData[id][entranceInterior] = 3;
            }
			case 2: {
            	EntranceData[id][entranceInt][0] = 1456.1918;
           		EntranceData[id][entranceInt][1] = -987.9417;
            	EntranceData[id][entranceInt][2] = 996.1050;
            	EntranceData[id][entranceInt][3] = 90.0000;
				EntranceData[id][entranceInterior] = 6;
            }
            case 3: {
                EntranceData[id][entranceInt][0] = 1291.8246;
           		EntranceData[id][entranceInt][1] = 5.8714;
            	EntranceData[id][entranceInt][2] = 1001.0078;
            	EntranceData[id][entranceInt][3] = 180.0000;
				EntranceData[id][entranceInterior] = 18;
			}
			case 4: {
			    EntranceData[id][entranceInt][0] = 390.1687;
           		EntranceData[id][entranceInt][1] = 173.8072;
            	EntranceData[id][entranceInt][2] = 1008.3828;
            	EntranceData[id][entranceInt][3] = 90.0000;
				EntranceData[id][entranceInterior] = 3;
			}
			case 5: {
			    EntranceData[id][entranceInt][0] = 304.0165;
           		EntranceData[id][entranceInt][1] = -141.9894;
            	EntranceData[id][entranceInt][2] = 1004.0625;
            	EntranceData[id][entranceInt][3] = 90.0000;
				EntranceData[id][entranceInterior] = 7;
			}
		}
		foreach (new i : Player)
		{
			if (PlayerData[i][pEntrance] == EntranceData[id][entranceID])
			{
				SetPlayerPos(i, EntranceData[id][entranceInt][0], EntranceData[id][entranceInt][1], EntranceData[id][entranceInt][2]);
				SetPlayerFacingAngle(i, EntranceData[id][entranceInt][3]);

				SetPlayerInterior(i, EntranceData[id][entranceInterior]);
				SetCameraBehindPlayer(i);
			}
		}
	    Entrance_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the type of entrance ID: %d to %d.", ReturnName(playerid, 0), id, typeint);
	}
	return 1;
}


// ====== CMD:destroyentrance ======
CMD:destroyentrance(playerid, params[])
{
	static
	    id = 0;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/destroyentrance [entrance id]");

	if ((id < 0 || id >= MAX_ENTRANCES) || !EntranceData[id][entranceExists])
	    return SendErrorMessage(playerid, "You have specified an invalid entrance ID.");

	Entrance_Delete(id);
	SendServerMessage(playerid, "You have successfully destroyed entrance ID: %d.", id);
	return 1;
}


// ====== CMD:inviteguest ======
CMD:inviteguest(playerid, params[])
{
	static
	    userid;

    if (GetFactionType(playerid) != FACTION_NEWS)
		return SendErrorMessage(playerid, "You must be part of a news faction.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/inviteguest [playerid/name]");

    if (!PlayerData[playerid][pBroadcast])
	    return SendErrorMessage(playerid, "You must be broadcasting to use this command.");

	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "That player is disconnected or not near you.");

 	if (userid == playerid)
		return SendErrorMessage(playerid, "You can't add yourself as a guest.");

	if (PlayerData[userid][pNewsGuest] == playerid)
	    return SendErrorMessage(playerid, "That player is already a guest of your broadcast.");

	if (PlayerData[userid][pNewsGuest] != INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "That player is already a guest of another broadcast.");

	PlayerData[userid][pNewsGuest] = playerid;

	SendServerMessage(playerid, "You have added %s as a broadcast guest.", ReturnName(userid, 0));
	SendServerMessage(userid, "%s has added you as a broadcast guest.", ReturnName(userid, 0));
	return 1;
}


// ====== CMD:removeguest ======
CMD:removeguest(playerid, params[])
{
	static
	    userid;

    if (GetFactionType(playerid) != FACTION_NEWS)
		return SendErrorMessage(playerid, "You must be part of a news faction.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/removeguest [playerid/name]");

    if (!PlayerData[playerid][pBroadcast])
	    return SendErrorMessage(playerid, "You must be broadcasting to use this command.");

	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "That player is disconnected or not near you.");

 	if (userid == playerid)
		return SendErrorMessage(playerid, "You can't remove yourself as a guest.");

	if (PlayerData[userid][pNewsGuest] != playerid)
	    return SendErrorMessage(playerid, "That player is not a guest of your broadcast.");

	PlayerData[userid][pNewsGuest] = INVALID_PLAYER_ID;

	SendServerMessage(playerid, "You have removed %s from your broadcast.", ReturnName(userid, 0));
	SendServerMessage(userid, "%s has removed you from their broadcast.", ReturnName(userid, 0));
	return 1;
}


// ====== CMD:doorbell ======
CMD:doorbell(playerid, params[])
{
	new id = House_Nearest(playerid);

	if (id == -1)
	    return SendErrorMessage(playerid, "You must be standing near a house.");

	foreach (new i : Player) if (House_Inside(i) == id) {
	    SendClientMessage(i, COLOR_PURPLE, "** You can hear the doorbell ringing.");
	    PlayerPlaySound(i, 20801, 0, 0, 0);
	}
	PlayerPlaySoundEx(playerid, 20801);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s rings the doorbell of the house.", ReturnName(playerid, 0));
	return 1;
}


// ====== CMD:kickdoor ======
CMD:kickdoor(playerid, params[])
{
	static
	    id = -1;

	if (GetFactionType(playerid) != FACTION_POLICE)
	    return SendErrorMessage(playerid, "You must be a police officer.");

	if ((id = House_Nearest(playerid)) != -1)
	{
	    if (!HouseData[id][houseLocked])
	        return SendErrorMessage(playerid, "This house is already unlocked.");

	    ShowPlayerFooter(playerid, "Attempting to ~r~break~w~ door...");
	    ApplyAnimation(playerid, "POLICE", "Door_Kick", 4.0, 0, 0, 0, 0, 0);

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s attempts to kick the house's door down.", ReturnName(playerid, 0));
	    SetTimerEx("KickHouse", 1500, false, "dd", playerid, id);
	}
	else if ((id = Business_Nearest(playerid)) != -1)
	{
		if (!BusinessData[id][bizLocked])
		    return SendErrorMessage(playerid, "This business is already unlocked.");

		ShowPlayerFooter(playerid, "Attempting to ~r~break~w~ door...");
        ApplyAnimation(playerid, "POLICE", "Door_Kick", 4.0, 0, 0, 0, 0, 0);

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s attempts to kick the business door down.", ReturnName(playerid, 0));
	    SetTimerEx("KickBusiness", 1500, false, "dd", playerid, id);
	}
	else {
		SendErrorMessage(playerid, "You must be in range of a house or business.");
	}
	return 1;
}

