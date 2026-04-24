/*
    File: modules/vehicle/commands/vehicle.pwn
    Purpose: Contains ZCMD command handlers for vehicle vehicle features.
    Notes: Keep command parsing here and delegate reusable gameplay work to logic files.
*/

// ====== CMD:engine ======
CMD:engine(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if (!IsEngineVehicle(vehicleid))
		return SendErrorMessage(playerid, "You are not in any vehicle.");

	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendErrorMessage(playerid, "You can't do this as you're not the driver.");

	if (CoreVehicles[vehicleid][vehFuel] < 1)
	    return SendErrorMessage(playerid, "The fuel tank is empty.");

	if (ReturnVehicleHealth(vehicleid) <= 300)
	    return SendErrorMessage(playerid, "This vehicle is totalled and can't be started.");

	switch (GetEngineStatus(vehicleid))
	{
	    case false:
	    {
	        SetEngineStatus(vehicleid, true);
	        ShowPlayerFooter(playerid, "You have ~g~started~w~ the engine!");
	        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s inserts the key into the ignition and starts the engine.", ReturnName(playerid, 0));
		}
		case true:
		{
		    SetEngineStatus(vehicleid, false);
		    ShowPlayerFooter(playerid, "You have ~r~stopped~w~ the engine!");
		    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s inserts the key into the ignition and stops the engine.", ReturnName(playerid, 0));
		}
	}
	return 1;
}


// ====== CMD:lights ======
CMD:lights(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if (!IsEngineVehicle(vehicleid))
		return SendErrorMessage(playerid, "You are not in any vehicle.");

	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendErrorMessage(playerid, "You can't do this as you're not the driver.");

	switch (GetLightStatus(vehicleid))
	{
	    case false:
	    {
	        SetLightStatus(vehicleid, true);
	        ShowPlayerFooter(playerid, "You have ~g~turned on~w~ the lights!");
		}
		case true:
		{
		    SetLightStatus(vehicleid, false);
		    ShowPlayerFooter(playerid, "You have ~r~turned off~w~ the lights!");
		}
	}
	return 1;
}


// ====== CMD:hood ======
CMD:hood(playerid, params[])
{
	for (new i = 1; i != MAX_VEHICLES; i ++) if (IsValidVehicle(i) && IsPlayerNearHood(playerid, i))
	{
	    if (!IsDoorVehicle(i))
	        return SendErrorMessage(playerid, "This vehicle doesn't have a hood.");

	    if (!GetHoodStatus(i))
		{
	        SetHoodStatus(i, true);

	        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has opened the hood of the vehicle.", ReturnName(playerid, 0));
	        ShowPlayerFooter(playerid, "You have ~g~opened~w~ the hood!");
		}
		else
		{
			SetHoodStatus(i, false);

	        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has closed the hood of the vehicle.", ReturnName(playerid, 0));
	        ShowPlayerFooter(playerid, "You have ~g~closed~w~ the hood!");
		}
	    return 1;
	}
	SendErrorMessage(playerid, "You are not in range of any vehicle.");
	return 1;
}


// ====== CMD:windows ======
CMD:windows(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if (!IsWindowedVehicle(vehicleid))
		return SendErrorMessage(playerid, "You are not in any vehicle with windows.");

	switch (CoreVehicles[vehicleid][vehWindowsDown])
	{
	    case false:
	    {
	        CoreVehicles[vehicleid][vehWindowsDown] = true;
	        ShowPlayerFooter(playerid, "You have ~g~rolled down~w~ the windows!");
	        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s presses a button and rolls down the windows.", ReturnName(playerid, 0));
		}
		case true:
		{
		    CoreVehicles[vehicleid][vehWindowsDown] = false;
		    ShowPlayerFooter(playerid, "You have ~r~rolled up~w~ the windows!");
		    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s presses a button and rolls up the windows.", ReturnName(playerid, 0));
		}
	}
	return 1;
}


// ====== CMD:arepair ======
CMD:arepair(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (vehicleid > 0 && isnull(params))
	{
		RepairVehicle(vehicleid);
		SendServerMessage(playerid, "You have repaired your current vehicle.");
	}
	else
	{
		if (sscanf(params, "d", vehicleid))
	    	return SendSyntaxMessage(playerid, "/arepair [vehicle ID]");

		else if (!IsValidVehicle(vehicleid))
	    	return SendErrorMessage(playerid, "You have specified an invalid vehicle ID.");

		RepairVehicle(vehicleid);
		SendServerMessage(playerid, "You have repaired vehicle ID: %d.", vehicleid);
	}
	return 1;
}


// ====== CMD:park ======
CMD:park(playerid, params[])
{
	new
	    carid = GetPlayerVehicleID(playerid);

	if (!carid)
	    return SendErrorMessage(playerid, "You must be inside your vehicle.");

    if (IsVehicleImpounded(carid))
    	return SendErrorMessage(playerid, "This vehicle is impounded and you can't use it.");

	if ((carid = Car_GetID(carid)) != -1 && Car_IsOwner(playerid, carid))
	{
	    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	        return SendErrorMessage(playerid, "You must be the driver!");

	    static
			g_arrSeatData[10] = {INVALID_PLAYER_ID, ...},
			g_arrDamage[4],
			Float:health,
			seatid;

        for (new i = 0; i < 14; i ++) {
			CarData[carid][carMods][i] = GetVehicleComponentInSlot(CarData[carid][carVehicle], i);
	    }
		GetVehicleDamageStatus(CarData[carid][carVehicle], g_arrDamage[0], g_arrDamage[1], g_arrDamage[2], g_arrDamage[3]);
		GetVehicleHealth(CarData[carid][carVehicle], health);

		foreach (new i : Player) if (IsPlayerInVehicle(i, CarData[carid][carVehicle])) {
		    seatid = GetPlayerVehicleSeat(i);

		    g_arrSeatData[seatid] = i;
		}
		GetVehiclePos(CarData[carid][carVehicle], CarData[carid][carPos][0], CarData[carid][carPos][1], CarData[carid][carPos][2]);
		GetVehicleZAngle(CarData[carid][carVehicle], CarData[carid][carPos][3]);

		Car_Spawn(carid);
		Car_Save(carid);

		SendServerMessage(playerid, "You have successfully parked your %s.", ReturnVehicleName(CarData[carid][carVehicle]));

        UpdateVehicleDamageStatus(CarData[carid][carVehicle], g_arrDamage[0], g_arrDamage[1], g_arrDamage[2], g_arrDamage[3]);
		SetVehicleHealth(CarData[carid][carVehicle], health);

		for (new i = 0; i < sizeof(g_arrSeatData); i ++) if (g_arrSeatData[i] != INVALID_PLAYER_ID) {
		    PutPlayerInVehicle(g_arrSeatData[i], CarData[carid][carVehicle], i);

		    g_arrSeatData[i] = INVALID_PLAYER_ID;
		}
	}
	else SendErrorMessage(playerid, "You are not inside anything you can park.");
	return 1;
}


// ====== CMD:createpump ======
CMD:createpump(playerid, params[])
{
	static
	    id,
		bizid = -1;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", bizid))
	    return SendSyntaxMessage(playerid, "/createpump [business id]");

	if ((bizid < 0 || bizid >= MAX_BUSINESSES) || !BusinessData[bizid][bizExists])
	    return SendErrorMessage(playerid, "You have specified an invalid business ID.");

	if (BusinessData[bizid][bizType] != 6)
	    return SendErrorMessage(playerid, "This business is not a gas station!");

    if (GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
		return SendErrorMessage(playerid, "You can only create gas pumps outside interiors.");

	id = Pump_Create(playerid, bizid);

	if (id == -1)
	    return SendErrorMessage(playerid, "The business has reached the limit for gas pumps.");

	SendServerMessage(playerid, "You have successfully created gas pump ID: %d.", id);
	EditDynamicObject(playerid, PumpData[id][pumpObject]);

	PlayerData[playerid][pEditPump] = id;
	return 1;
}


// ====== CMD:destroypump ======
CMD:destroypump(playerid, params[])
{
	static
	    id = 0;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/destroypump [pump id]");

	if ((id < 0 || id >= MAX_GAS_PUMPS) || !PumpData[id][pumpExists])
	    return SendErrorMessage(playerid, "Invalid pump ID.");

	Pump_Delete(id);
	SendServerMessage(playerid, "You have successfully destroyed pump ID: %d.", id);
	return 1;
}


// ====== CMD:setpump ======
CMD:setpump(playerid, params[])
{
	static
	    id = 0,
		amount;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "dd", id, amount))
	    return SendSyntaxMessage(playerid, "/setpump [pump id] [fuel amount]");

	if ((id < 0 || id >= MAX_GAS_PUMPS) || !PumpData[id][pumpExists])
	    return SendErrorMessage(playerid, "Invalid pump ID.");

	PumpData[id][pumpFuel] = amount;

	Pump_Refresh(id);
	Pump_Save(id);

	SendServerMessage(playerid, "You have set the fuel to %d for pump ID: %d.", amount, id);
	return 1;
}


// ====== CMD:refuel ======
CMD:refuel(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if (PlayerData[playerid][pRefill] != INVALID_VEHICLE_ID)
	{
	    BusinessData[PlayerData[playerid][pGasStation]][bizVault] += PlayerData[playerid][pRefillPrice];
		Business_Save(PlayerData[playerid][pGasStation]);

        GiveMoney(playerid, -PlayerData[playerid][pRefillPrice]);

		SendServerMessage(playerid, "You have refueled your vehicle for $%d.", PlayerData[playerid][pRefillPrice]);
        StopRefilling(playerid);

        return 1;
	}
	if (!vehicleid)
	    return SendErrorMessage(playerid, "You are not inside any vehicle!");

	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendErrorMessage(playerid, "You must be the driver of the vehicle!");

	if (GetEngineStatus(vehicleid))
	    return SendErrorMessage(playerid, "You must turn the engine off first.");

	new id = Pump_Nearest(playerid);

	if (id != -1)
	{
		if (CoreVehicles[vehicleid][vehFuel] > 95)
			return SendErrorMessage(playerid, "This vehicle doesn't need any fuel.");

		if (IsPumpOccupied(id))
		    return SendErrorMessage(playerid, "This fuel pump is already occupied.");

		if (PumpData[id][pumpFuel] < 1)
   			return SendErrorMessage(playerid, "This pump doesn't have enough fuel.");

		PlayerData[playerid][pGasPump] = id;
		PlayerData[playerid][pGasStation] = PumpData[id][pumpBusiness];

		PlayerData[playerid][pRefill] = vehicleid;
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has started refilling their vehicle.", ReturnName(playerid, 0));
	}
	else
	{
		SendErrorMessage(playerid, "You are not in range of any unused gas pump.");
	}
	return 1;
}


// ====== CMD:unmod ======
CMD:unmod(playerid, params[])
{
	new
	    carid = GetPlayerVehicleID(playerid);

	if (!carid)
	    return SendErrorMessage(playerid, "You must be inside your vehicle.");

    if (IsVehicleImpounded(carid))
    	return SendErrorMessage(playerid, "This vehicle is impounded and you can't use it.");

	if ((carid = Car_GetID(carid)) != -1 && Car_IsOwner(playerid, carid))
	{
	    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	        return SendErrorMessage(playerid, "You must be the driver!");

		for (new i = 0; i < 14; i ++) {
		    RemoveVehicleComponent(CarData[carid][carVehicle], CarData[carid][carMods][i]);

		    CarData[carid][carMods][i] = 0;
		}
		Car_Save(carid);
		SendServerMessage(playerid, "You have removed the modifications from this vehicle.");
	}
	else SendErrorMessage(playerid, "You are not inside anything you can unmodify.");
	return 1;
}


// ====== CMD:trunk ======
CMD:trunk(playerid, params[])
{
	new
	    id = -1;

	if ((id = Car_Nearest(playerid)) != -1)
	{
	    if (IsVehicleImpounded(CarData[id][carVehicle]))
	        return SendErrorMessage(playerid, "This vehicle is impounded and you can't use it.");

	    if (IsPlayerInAnyVehicle(playerid))
	        return SendErrorMessage(playerid, "You must exit the vehicle first.");

		if (!IsDoorVehicle(CarData[id][carVehicle]))
		    return SendErrorMessage(playerid, "This vehicle doesn't have a trunk.");

		if (CarData[id][carLocked])
		    return SendErrorMessage(playerid, "The vehicle's trunk is locked.");

		Car_ShowTrunk(playerid, id);
	}
	else SendErrorMessage(playerid, "You are not in range of any vehicle.");
	return 1;
}


// ====== CMD:createcar ======
CMD:createcar(playerid, params[])
{
	static
		model[32],
		color1,
		color2,
		id = -1,
		type = 0;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "s[32]I(-1)I(-1)I(0)", model, color1, color2, type))
 	{
	 	SendSyntaxMessage(playerid, "/createcar [model id/name] [color 1] [color 2] <faction>");
	 	SendClientMessage(playerid, COLOR_YELLOW, "[TYPES]:{FFFFFF} 1: Police | 2: News | 3: Medical | 4: Government");
	 	return 1;
	}
	if ((model[0] = GetVehicleModelByName(model)) == 0)
	    return SendErrorMessage(playerid, "Invalid model ID.");

	static
	    Float:x,
		Float:y,
		Float:z,
		Float:angle;

    GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);

	id = Car_Create(0, model[0], x, y, z, angle, color1, color2, type);

	if (id == -1)
	    return SendErrorMessage(playerid, "The server has reached the limit for dynamic vehicles.");

	SetPlayerPosEx(playerid, x, y, z + 2, 1000);
	SendServerMessage(playerid, "You have successfully created vehicle ID: %d.", CarData[id][carVehicle]);
	return 1;
}


// ====== CMD:destroycar ======
CMD:destroycar(playerid, params[])
{
	static
	    id = 0;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", id))
 	{
	 	if (IsPlayerInAnyVehicle(playerid))
		 	id = GetPlayerVehicleID(playerid);

		else return SendSyntaxMessage(playerid, "/destroycar [vehicle id]");
	}
	if (!IsValidVehicle(id) || Car_GetID(id) == -1)
	    return SendErrorMessage(playerid, "You have specified an invalid vehicle ID.");

	Car_Delete(Car_GetID(id));
	SendServerMessage(playerid, "You have successfully destroyed vehicle ID: %d.", id);
	return 1;
}


// ====== CMD:createimpound ======
CMD:createimpound(playerid, params[])
{
	static
	    id = -1,
		Float:x,
		Float:y,
		Float:z;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
 		return SendErrorMessage(playerid, "You can only create impound lots outside interiors.");

	GetPlayerPos(playerid, x, y, z);

	id = Impound_Create(x, y, z);

	if (id == -1)
	    return SendErrorMessage(playerid, "The server has reached the limit for impound lots.");

	SendServerMessage(playerid, "You have successfully created impound lot ID: %d.", id);
	return 1;
}


// ====== CMD:destroyimpound ======
CMD:destroyimpound(playerid, params[])
{
	static
	    id = 0;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/destroyimpound [impound id]");

	if ((id < 0 || id >= MAX_IMPOUND_LOTS) || !ImpoundData[id][impoundExists])
	    return SendErrorMessage(playerid, "You have specified an invalid impound lot ID.");

	Impound_Delete(id);
	SendServerMessage(playerid, "You have successfully destroyed impound lot ID: %d.", id);
	return 1;
}


// ====== CMD:editimpound ======
CMD:editimpound(playerid, params[])
{
	static
	    id,
	    type[24],
	    string[128];

	if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editimpound [id] [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, release");
		return 1;
	}
	if ((id < 0 || id >= MAX_IMPOUND_LOTS) || !ImpoundData[id][impoundExists])
	    return SendErrorMessage(playerid, "You have specified an invalid impound lot ID.");

	if (!strcmp(type, "location", true))
	{
	    static
	        Float:x,
	        Float:y,
	        Float:z;

	    GetPlayerPos(playerid, x, y, z);

		ImpoundData[id][impoundLot][0] = x;
		ImpoundData[id][impoundLot][1] = y;
		ImpoundData[id][impoundLot][2] = z;

		Impound_Refresh(id);
		Impound_Save(id);

		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the location of impound ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "release", true))
	{
	    static
	        Float:x,
	        Float:y,
	        Float:z,
			Float:angle;

	    GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);

		ImpoundData[id][impoundRelease][0] = x;
		ImpoundData[id][impoundRelease][1] = y;
		ImpoundData[id][impoundRelease][2] = z;
		ImpoundData[id][impoundRelease][3] = angle;

		Impound_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the release point of impound ID: %d.", ReturnName(playerid, 0), id);
	}
	return 1;
}


// ====== CMD:releasecar ======
CMD:releasecar(playerid, params[])
{
	if (!IsPlayerInRangeOfPoint(playerid, 3.0, 361.1653, 175.8127, 1008.3828))
	    return SendErrorMessage(playerid, "You must be at city hall to release a vehicle.");

	new
	    string[32 * MAX_OWNABLE_CARS],
		count;

	for (new i = 0; i < MAX_DYNAMIC_CARS; i ++) if (count < MAX_OWNABLE_CARS && CarData[i][carExists] && Car_IsOwner(playerid, i) && CarData[i][carImpounded] != -1)
	{
		format(string, sizeof(string), "%s%d: %s (%s)\n", string, count + 1, ReturnVehicleName(CarData[i][carVehicle]), FormatNumber(CarData[i][carImpoundPrice]));
        ListedVehicles[playerid][count++] = i;
	}
	if (!count)
	    SendErrorMessage(playerid, "You don't have any impounded vehicles.");

	else Dialog_Show(playerid, ReleaseCar, DIALOG_STYLE_LIST, "Release Vehicle", string, "Select", "Cancel");
	return 1;
}


// ====== CMD:tow ======
CMD:tow(playerid, params[])
{
	if (GetVehicleModel(GetPlayerVehicleID(playerid)) != 525)
	    return SendErrorMessage(playerid, "You are not driving a tow truck.");

	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendErrorMessage(playerid, "You are not the driver.");

	new vehicleid = GetVehicleFromBehind(GetPlayerVehicleID(playerid));

	if (vehicleid == INVALID_VEHICLE_ID)
	    return SendErrorMessage(playerid, "There is no vehicle in range.");

	if (!IsDoorVehicle(vehicleid) || IsAPlane(vehicleid) || IsABoat(vehicleid) || IsAHelicopter(vehicleid))
	    return SendErrorMessage(playerid, "You can't tow this vehicle.");

	AttachTrailerToVehicle(vehicleid, GetPlayerVehicleID(playerid));
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has hooked a %s onto their tow truck.", ReturnName(playerid, 0), ReturnVehicleName(vehicleid));
	return 1;
}


// ====== CMD:untow ======
CMD:untow(playerid, params[])
{
	if (GetVehicleModel(GetPlayerVehicleID(playerid)) != 525)
	    return SendErrorMessage(playerid, "You are not driving a tow truck.");

	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendErrorMessage(playerid, "You are not the driver.");

	new
	    trailerid = GetVehicleTrailer(GetPlayerVehicleID(playerid));

    if (!trailerid)
	    return SendErrorMessage(playerid, "There is no vehicle hooked onto the truck.");

	DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has unhooked the %s from the tow truck.", ReturnName(playerid, 0), ReturnVehicleName(trailerid));

	return 1;
}


// ====== CMD:impound ======
CMD:impound(playerid, params[])
{
	new
		price,
		id = Impound_Nearest(playerid),
		vehicleid = GetPlayerVehicleID(playerid);

    if (GetFactionType(playerid) != FACTION_POLICE)
		return SendErrorMessage(playerid, "You must be a police officer.");

    if (sscanf(params, "d", price))
        return SendSyntaxMessage(playerid, "/impound [price]");

	if (price < 1 || price > 1000)
	    return SendErrorMessage(playerid, "The price can't be above $1,000 or below $1.");

	if (GetVehicleModel(vehicleid) != 525)
	    return SendErrorMessage(playerid, "You are not driving a tow truck.");

	if (id == -1)
	    return SendErrorMessage(playerid, "You are not in range of any impound lot.");

	if (!GetVehicleTrailer(vehicleid))
	    return SendErrorMessage(playerid, "There is no vehicle hooked.");

 	vehicleid = Car_GetID(GetVehicleTrailer(vehicleid));

	if (vehicleid == -1)
	    return SendErrorMessage(playerid, "You can't tow this vehicle.");

	if (CarData[vehicleid][carImpounded] != -1)
	    return SendErrorMessage(playerid, "This vehicle is already impounded.");

	CarData[vehicleid][carImpounded] = ImpoundData[id][impoundID];
	CarData[vehicleid][carImpoundPrice] = price;

	Tax_AddMoney(price);

	GetVehiclePos(CarData[vehicleid][carVehicle], CarData[vehicleid][carPos][0], CarData[vehicleid][carPos][1], CarData[vehicleid][carPos][2]);
	Car_Save(vehicleid);

	SendFactionMessage(PlayerData[playerid][pFaction], COLOR_RADIO, "RADIO: %s has impounded a %s for %s.", ReturnName(playerid, 0), ReturnVehicleModelName(CarData[vehicleid][carModel]), FormatNumber(price));
 	DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));

	return 1;
}


// ====== CMD:listcars ======
CMD:listcars(playerid, params[])
{
	new
	    Float:fX,
	    Float:fY,
	    Float:fZ,
		userid,
		count;

	if (sscanf(params, "u", userid))
	{
		SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");

		for (new i = 0; i < MAX_DYNAMIC_CARS; i ++) if (Car_IsOwner(playerid, i)) {
		    GetVehiclePos(CarData[i][carVehicle], fX, fY, fZ);

		    SendClientMessageEx(playerid, COLOR_WHITE, "** ID: %d | Model: %s | Location: %s", CarData[i][carVehicle], ReturnVehicleModelName(CarData[i][carModel]), GetLocation(fX, fY, fZ));
		    count++;
		}
		if (!count)
		    SendClientMessage(playerid, COLOR_WHITE, "You don't own any vehicles.");

		SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
	}
	else if (PlayerData[playerid][pAdmin] >= 3)
	{
		if (userid == INVALID_PLAYER_ID)
	    	return SendErrorMessage(playerid, "You have specified an invalid player.");

		SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
  		SendClientMessageEx(playerid, COLOR_YELLOW, "Vehicles registered to %s (ID: %d):", ReturnName(userid, 0), userid);

		for (new i = 0; i < MAX_DYNAMIC_CARS; i ++) if (Car_IsOwner(userid, i)) {
  			GetVehiclePos(CarData[i][carVehicle], fX, fY, fZ);

			SendClientMessageEx(playerid, COLOR_WHITE, "** ID: %d | Model: %s | Location: %s", CarData[i][carVehicle], ReturnVehicleModelName(CarData[i][carModel]), GetLocation(fX, fY, fZ));
			count++;
		}
		if (!count)
		    SendClientMessage(playerid, COLOR_WHITE, "That player doesn't own any vehicles.");

		SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
	}
	return 1;
}

/*CMD:grantweapon(playerid, params[])
{
	new userid;

	if (GetFactionType(playerid) != FACTION_POLICE && GetFactionType(playerid) != FACTION_GOV)
	    return SendErrorMessage(playerid, "You must be an officer or a government member.");

	if (sscanf(params, "u", userid))
	    return SendSyntaxMessage(playerid, "/grantweapon [playerid/name]");

	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 5.0))
	    return SendErrorMessage(playerid, "That player is disconnected or not near you.");

	if (userid == playerid)
	    return SendErrorMessage(playerid, "You can't grant yourself a weapon license.");

	if (Inventory_HasItem(userid, "Weapon License"))
	    return SendErrorMessage(playerid, "That player already has a weapon license.");

	Inventory_Add(userid, "Weapon License", 1581);

	SendServerMessage(playerid, "You have granted a weapon license to %s.", ReturnName(userid, 0));
	SendServerMessage(userid, "You've been granted a weapon license by %s.", ReturnName(playerid, 0));

	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has granted %s with a weapon license.", ReturnName(playerid, 0), ReturnName(userid, 0));
	return 1;
}*/


// ====== CMD:setfuel ======
CMD:setfuel(playerid, params[])
{
	static
	    id = 0,
		amount;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "dd", id, amount))
 	{
	 	if (IsPlayerInAnyVehicle(playerid))
		{
		    id = GetPlayerVehicleID(playerid);

		    if (sscanf(params, "d", amount))
		        return SendSyntaxMessage(playerid, "/setfuel [amount]");

			if (amount < 0)
			    return SendErrorMessage(playerid, "The amount can't be below 0.");

			CoreVehicles[id][vehFuel] = amount;
			SendServerMessage(playerid, "You have set the fuel of vehicle ID: %d to %d percent.", id, amount);
			return 1;
		}
		else return SendSyntaxMessage(playerid, "/setfuel [vehicle id] [amount]");
	}
	if (!IsValidVehicle(id))
	    return SendErrorMessage(playerid, "You have specified an invalid vehicle ID.");

	if (amount < 0)
 		return SendErrorMessage(playerid, "The amount can't be below 0.");

	CoreVehicles[id][vehFuel] = amount;
	SendServerMessage(playerid, "You have set the fuel of vehicle ID: %d to %d percent.", id, amount);
	return 1;
}


// ====== CMD:setcarhp ======
CMD:setcarhp(playerid, params[])
{
	static
	    id = 0,
		Float:amount;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "df", id, amount))
 	{
	 	if (IsPlayerInAnyVehicle(playerid))
		{
		    id = GetPlayerVehicleID(playerid);

		    if (sscanf(params, "f", amount))
		        return SendSyntaxMessage(playerid, "/setcarhp [amount]");

			if (amount < 0.0)
			    return SendErrorMessage(playerid, "The amount can't be below 0.");

			SetVehicleHealth(id, amount);
			SendServerMessage(playerid, "You have set the health of vehicle ID: %d to %.1f.", id, amount);
			return 1;
		}
		else return SendSyntaxMessage(playerid, "/setcarhp [vehicle id] [amount]");
	}
	if (!IsValidVehicle(id))
	    return SendErrorMessage(playerid, "You have specified an invalid vehicle ID.");

	if (amount < 0.0)
	    return SendErrorMessage(playerid, "The amount can't be below 0.");

	SetVehicleHealth(id, amount);
	SendServerMessage(playerid, "You have set the health of vehicle ID: %d to %.1f.", id, amount);
	return 1;
}


// ====== CMD:editcar ======
CMD:editcar(playerid, params[])
{
	static
	    id,
	    type[24],
	    string[128];

	if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editcar [id] [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, faction, color1, color2");
		return 1;
	}
	if (!IsValidVehicle(id) || Car_GetID(id) == -1)
	    return SendErrorMessage(playerid, "You have specified an invalid vehicle ID.");

	id = Car_GetID(id);

	if (!strcmp(type, "location", true))
	{
 		GetPlayerPos(playerid, CarData[id][carPos][0], CarData[id][carPos][1], CarData[id][carPos][2]);
		GetPlayerFacingAngle(playerid, CarData[id][carPos][3]);

		Car_Save(id);
		Car_Spawn(id);

		SetPlayerPosEx(playerid, CarData[id][carPos][0], CarData[id][carPos][1], CarData[id][carPos][2] + 2.0, 1000);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the location of vehicle ID: %d.", ReturnName(playerid, 0), CarData[id][carVehicle]);
	}
	else if (!strcmp(type, "faction", true))
	{
	    new typeint;

	    if (sscanf(string, "d", typeint))
     	{
     	    SendSyntaxMessage(playerid, "/editcar [id] [faction] [type]");
		 	SendClientMessage(playerid, COLOR_YELLOW, "[TYPES]:{FFFFFF} 1: Police | 2: News | 3: Medical | 4: Government");
		 	return 1;
		}
		if (typeint < 0 || typeint > 4)
		    return SendErrorMessage(playerid, "The specified type can't be below 0 or above 4.");

		CarData[id][carFaction] = typeint;

		Car_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the type of vehicle ID: %d to %d.", ReturnName(playerid, 0), CarData[id][carVehicle], typeint);
	}
    else if (!strcmp(type, "color1", true))
	{
	    new color1;

	    if (sscanf(string, "d", color1))
			return SendSyntaxMessage(playerid, "/editcar [id] [color1] [color 1]");

		if (color1 < 0 || color1 > 255)
		    return SendErrorMessage(playerid, "The specified color can't be below 0 or above 255.");

		CarData[id][carColor1] = color1;
		ChangeVehicleColor(CarData[id][carVehicle], CarData[id][carColor1], CarData[id][carColor2]);

		Car_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the color 1 of vehicle ID: %d to %d.", ReturnName(playerid, 0), CarData[id][carVehicle], color1);
	}
    else if (!strcmp(type, "color2", true))
	{
	    new color2;

	    if (sscanf(string, "d", color2))
			return SendSyntaxMessage(playerid, "/editcar [id] [color2] [color 2]");

		if (color2 < 0 || color2 > 255)
		    return SendErrorMessage(playerid, "The specified color can't be below 0 or above 255.");

		CarData[id][carColor2] = color2;
		ChangeVehicleColor(CarData[id][carVehicle], CarData[id][carColor1], CarData[id][carColor2]);

		Car_Save(id);
		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the color 2 of vehicle ID: %d to %d.", ReturnName(playerid, 0), CarData[id][carVehicle], color2);
	}
	return 1;
}


// ====== CMD:atune ======
CMD:atune(playerid, params[])
{
    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (!IsPlayerInAnyVehicle(playerid))
	    return SendErrorMessage(playerid, "You are not in any vehicle.");

	if (!IsDoorVehicle(GetPlayerVehicleID(playerid)))
	    return SendErrorMessage(playerid, "You can't tune this vehicle.");

	Dialog_Show(playerid, TuneVehicle, DIALOG_STYLE_LIST, "Tune Vehicle", "Add Wheels\nAdd Nitrous\nAdd Hydraulics", "Select", "Cancel");
	return 1;
}


// ====== CMD:acolorcar ======
CMD:acolorcar(playerid, params[])
{
	static
	    color1,
	    color2;

    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (!IsPlayerInAnyVehicle(playerid))
	    return SendErrorMessage(playerid, "You are not in any vehicle.");

	if (sscanf(params, "dd", color1, color2))
	    return SendSyntaxMessage(playerid, "/acolorcar [color 1] [color 2]");

	if (color1 < 0 || color1 > 255)
	    return SendErrorMessage(playerid, "The first color can't be below 0 or above 255.");

    if (color2 < 0 || color2 > 255)
	    return SendErrorMessage(playerid, "The second color can't be below 0 or above 255.");

	SetVehicleColor(GetPlayerVehicleID(playerid), color1, color2);
	SendServerMessage(playerid, "You have changed the colors of this vehicle to %d, %d.", color1, color2);
	return 1;
}


// ====== CMD:apaintjob ======
CMD:apaintjob(playerid, params[])
{
	static
	    paintjobid;

    if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (!IsPlayerInAnyVehicle(playerid))
	    return SendErrorMessage(playerid, "You are not in any vehicle.");

	if (sscanf(params, "d", paintjobid))
	    return SendSyntaxMessage(playerid, "/apaintjob [paintjob ID] (-1 to disable)");

	if (paintjobid < -1 || paintjobid > 5)
	    return SendErrorMessage(playerid, "The specified paintjob can't be below -1 or above 5.");

	if (paintjobid == -1)
		paintjobid = 6;

	SetVehiclePaintjob(GetPlayerVehicleID(playerid), paintjobid);
	SendServerMessage(playerid, "You have changed the paintjob of this vehicle to %d.", paintjobid);
	return 1;
}


// ====== CMD:flipcar ======
CMD:flipcar(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if (PlayerData[playerid][pAdmin] < 3)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (vehicleid > 0 && isnull(params))
	{
		FlipVehicle(vehicleid);
		SendServerMessage(playerid, "You have flipped your current vehicle.");
	}
	else
	{
		if (sscanf(params, "d", vehicleid))
	    	return SendSyntaxMessage(playerid, "/flipcar [vehicle ID]");

		else if (!IsValidVehicle(vehicleid))
	    	return SendErrorMessage(playerid, "You have specified an invalid vehicle ID.");

		FlipVehicle(vehicleid);
		SendServerMessage(playerid, "You have flipped vehicle ID: %d.", vehicleid);
	}
	return 1;
}


// ====== CMD:createspeed ======
CMD:createspeed(playerid, params[])
{
	static
	    Float:limit,
	    Float:range;

	if (sscanf(params, "ff", limit, range))
		return SendSyntaxMessage(playerid, "/createspeed [speed limit] [range] (default range: 30)");

	if (limit < 5.0 || limit > 150.0)
	    return SendErrorMessage(playerid, "The speed limit can't be below 5 or above 150.");

	if (range < 5.0 || range > 50.0)
	    return SendErrorMessage(playerid, "The range can't be below 5 or above 50.");

	if (Speed_Nearest(playerid) != -1)
	    return SendErrorMessage(playerid, "You can't do this in range another speed camera.");

	new id = Speed_Create(playerid, limit, range);

	if (id == -1)
	    return SendErrorMessage(playerid, "The server has reached the limit for speed cameras.");

	SendServerMessage(playerid, "You have created speed camera ID: %d.", id);
	return 1;
}


// ====== CMD:destroyspeed ======
CMD:destroyspeed(playerid, params[])
{
	static
	    id = 0;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/destroyspeed [speed id]");

	if ((id < 0 || id >= MAX_SPEED_CAMERAS) || !SpeedData[id][speedExists])
	    return SendErrorMessage(playerid, "You have specified an invalid speed camera ID.");

	Speed_Delete(id);
	SendServerMessage(playerid, "You have successfully destroyed speed camera ID: %d.", id);
	return 1;
}


// ====== CMD:siren ======
CMD:siren(playerid, params[])
{
	if (GetFactionType(playerid) != FACTION_POLICE)
	    return SendErrorMessage(playerid, "You are not a police officer.");

	new vehicleid = GetPlayerVehicleID(playerid);

	if (!IsPlayerInAnyVehicle(playerid))
	    return SendErrorMessage(playerid, "You must be inside a vehicle.");

	switch (CoreVehicles[vehicleid][vehSirenOn])
	{
	    case 0:
	    {
			static
        		Float:fSize[3],
        		Float:fSeat[3];

		    GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, fSize[0], fSize[1], fSize[2]); // need height (z)
    		GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_FRONTSEAT, fSeat[0], fSeat[1], fSeat[2]); // need pos (x, y)

            CoreVehicles[vehicleid][vehSirenOn] = 1;
			CoreVehicles[vehicleid][vehSirenObject] = CreateDynamicObject(18646, 0.0, 0.0, 1000.0, 0.0, 0.0, 0.0);

		    AttachDynamicObjectToVehicle(CoreVehicles[vehicleid][vehSirenObject], vehicleid, -fSeat[0], fSeat[1], fSize[2] / 2.0, 0.0, 0.0, 0.0);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s attaches a portable siren to the vehicle.", ReturnName(playerid, 0));
		}
		case 1:
		{
		    CoreVehicles[vehicleid][vehSirenOn] = 0;

			DestroyDynamicObject(CoreVehicles[vehicleid][vehSirenObject]);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s detaches a portable siren from the vehicle.", ReturnName(playerid, 0));
		}
	}
	return 1;
}


// ====== CMD:givecar ======
CMD:givecar(playerid, params[])
{
	static
		userid,
	    model[32];

    if (PlayerData[playerid][pAdmin] < 4)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "us[32]", userid, model))
	    return SendSyntaxMessage(playerid, "/givecar [playerid/name] [modelid/name]");

	if (Car_GetCount(userid) >= MAX_OWNABLE_CARS)
	    return SendErrorMessage(playerid, "This player already owns the maximum amount of cars.");

    if ((model[0] = GetVehicleModelByName(model)) == 0)
	    return SendErrorMessage(playerid, "Invalid model ID.");

	static
	    Float:x,
		Float:y,
		Float:z,
		Float:angle,
		id = -1;

    GetPlayerPos(userid, x, y, z);
	GetPlayerFacingAngle(userid, angle);

	id = Car_Create(PlayerData[userid][pID], model[0], x, y + 2, z + 1, angle, random(127), random(127), 0);

	if (id == -1)
	    return SendErrorMessage(playerid, "The server has reached the limit for dynamic vehicles.");

	SendServerMessage(playerid, "You have created vehicle ID: %d for %s.", CarData[id][carVehicle], ReturnName(userid, 0));
	return 1;
}

