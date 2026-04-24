/*
    File: modules/vehicle/logic/traits.pwn
    Purpose: Contains vehicle gameplay logic and helper functions for traits.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== IsWindowedVehicle ======
stock IsWindowedVehicle(vehicleid)
{
	static const g_aWindowStatus[] = {
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1,
	    1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1,
	    1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1,
	    1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1,
	    1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0,
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1,
		1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0
	};
	new modelid = GetVehicleModel(vehicleid);

    if (modelid < 400 || modelid > 611)
        return 0;

    return (g_aWindowStatus[modelid - 400]);
}

// ====== IsNewsVehicle ======
stock IsNewsVehicle(vehicleid)
{
	switch (GetVehicleModel(vehicleid)) {
	    case 488, 582: return 1;
	}
	return 0;
}

// ====== IsACruiser ======
stock IsACruiser(vehicleid)
{
	switch (GetVehicleModel(vehicleid)) {
	    case 523, 427, 490, 528, 596..599, 601: return 1;
	}
	return 0;
}

// ====== IsDoorVehicle ======
stock IsDoorVehicle(vehicleid)
{
	switch (GetVehicleModel(vehicleid)) {
		case 400..424, 426..429, 431..440, 442..445, 451, 455, 456, 458, 459, 466, 467, 470, 474, 475:
		    return 1;

		case 477..480, 482, 483, 486, 489, 490..492, 494..496, 498..500, 502..508, 514..518, 524..529, 533..536:
		    return 1;

		case 540..547, 549..552, 554..562, 565..568, 573, 575, 576, 578..580, 582, 585, 587..589, 596..605, 609:
			return 1;
	}
	return 0;
}

// ====== IsSpeedoVehicle ======
stock IsSpeedoVehicle(vehicleid)
{
	if (GetVehicleModel(vehicleid) == 509 || GetVehicleModel(vehicleid) == 510 || GetVehicleModel(vehicleid) == 481 || !IsEngineVehicle(vehicleid)) {
	    return 0;
	}
	return 1;
}

// ====== IsLoadableVehicle ======
stock IsLoadableVehicle(vehicleid)
{
	new modelid = GetVehicleModel(vehicleid);

	if (GetVehicleTrailer(vehicleid))
	    modelid = GetVehicleModel(GetVehicleTrailer(vehicleid));

	switch (modelid) {
	    case 609, 403, 414, 456, 498, 499, 514, 515, 435, 591: return 1;
	}
	return 0;
}

// ====== GetMaxCrates ======
stock GetMaxCrates(vehicleid)
{
	new crates;

	switch (GetVehicleModel(vehicleid)) {
	    case 498, 609: crates = 10;
	    case 414: crates = 8;
	    case 456, 499: crates = 6;
	    case 435, 591: crates = 15;
	}
	return crates;
}

// ====== IsCrateInUse ======
stock IsCrateInUse(crateid)
{
	if (CrateData[crateid][crateVehicle] != INVALID_VEHICLE_ID && IsValidVehicle(CrateData[crateid][crateVehicle])) {
	    return 1;
	}
	foreach (new i : Player) if (PlayerData[i][pCarryCrate] == crateid && GetPlayerSpecialAction(i) == SPECIAL_ACTION_CARRY) {
	    return 1;
	}
	return 0;
}

// ====== GetVehicleCrates ======
stock GetVehicleCrates(vehicleid)
{
	if (!IsValidVehicle(vehicleid) || !IsLoadableVehicle(vehicleid))
		return 0;

	new crates;

	for (new i = 0; i != MAX_CRATES; i ++) if (CrateData[i][crateExists] && CrateData[i][crateVehicle] == vehicleid) {
	    crates++;
	}
 	return crates;
}

// ====== IsABoat ======
stock IsABoat(vehicleid)
{
	switch (GetVehicleModel(vehicleid)) {
		case 430, 446, 452, 453, 454, 472, 473, 484, 493, 595: return 1;
	}
	return 0;
}

// ====== IsABike ======
stock IsABike(vehicleid)
{
	switch (GetVehicleModel(vehicleid)) {
		case 448, 461..463, 468, 521..523, 581, 586, 481, 509, 510: return 1;
	}
	return 0;
}

// ====== IsAPlane ======
stock IsAPlane(vehicleid)
{
	switch (GetVehicleModel(vehicleid)) {
		case 460, 464, 476, 511, 512, 513, 519, 520, 553, 577, 592, 593: return 1;
	}
	return 0;
}

// ====== IsAHelicopter ======
stock IsAHelicopter(vehicleid)
{
	switch (GetVehicleModel(vehicleid)) {
		case 417, 425, 447, 465, 469, 487, 488, 497, 501, 548, 563: return 1;
	}
	return 0;
}

// ====== IsEngineVehicle ======
stock IsEngineVehicle(vehicleid)
{
	static const g_aEngineStatus[] = {
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1,
	    1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1,
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0
	};
    new modelid = GetVehicleModel(vehicleid);

    if (modelid < 400 || modelid > 611)
        return 0;

    return (g_aEngineStatus[modelid - 400]);
}

stock Float:GetPlayerSpeed(playerid)
{
	static Float:velocity[3];

	if (IsPlayerInAnyVehicle(playerid))
	    GetVehicleVelocity(GetPlayerVehicleID(playerid), velocity[0], velocity[1], velocity[2]);
	else
	    GetPlayerVelocity(GetPlayerVehicleID(playerid), velocity[0], velocity[1], velocity[2]);

	return floatsqroot((velocity[0] * velocity[0]) + (velocity[1] * velocity[1]) + (velocity[2] * velocity[2])) * 100.0;
}

// ====== GetGateByID ======
stock GetGateByID(sqlid)
{
	for (new i = 0; i != MAX_GATES; i ++) if (GateData[i][gateExists] && GateData[i][gateID] == sqlid)
	    return i;

	return -1;
}

// ====== GetHouseByID ======
stock GetHouseByID(sqlid)
{
	for (new i = 0; i != MAX_HOUSES; i ++) if (HouseData[i][houseExists] && HouseData[i][houseID] == sqlid)
	    return i;

	return -1;
}

// ====== GetBusinessByID ======
stock GetBusinessByID(sqlid)
{
	for (new i = 0; i != MAX_BUSINESSES; i ++) if (BusinessData[i][bizExists] && BusinessData[i][bizID] == sqlid)
	    return i;

	return -1;
}

// ====== GetEntranceByID ======
stock GetEntranceByID(sqlid)
{
	for (new i = 0; i != MAX_ENTRANCES; i ++) if (EntranceData[i][entranceExists] && EntranceData[i][entranceID] == sqlid)
	    return i;

	return -1;
}

// ====== GetElapsedTime ======
stock GetElapsedTime(time, &hours, &minutes, &seconds)
{
	hours = 0;
	minutes = 0;
	seconds = 0;

	if (time >= 3600)
	{
		hours = (time / 3600);
		time -= (hours * 3600);
	}
	while (time >= 60)
	{
	    minutes++;
	    time -= 60;
	}
	return (seconds = time);
}

// ====== GetDuration ======
stock GetDuration(time)
{
	new
	    str[32];

	if (time < 0 || time == gettime()) {
	    format(str, sizeof(str), "Never");
	    return str;
	}
	else if (time < 60)
		format(str, sizeof(str), "%d seconds", time);

	else if (time >= 0 && time < 60)
		format(str, sizeof(str), "%d seconds", time);

	else if (time >= 60 && time < 3600)
		format(str, sizeof(str), (time >= 120) ? ("%d minutes") : ("%d minute"), time / 60);

	else if (time >= 3600 && time < 86400)
		format(str, sizeof(str), (time >= 7200) ? ("%d hours") : ("%d hour"), time / 3600);

	else if (time >= 86400 && time < 2592000)
 		format(str, sizeof(str), (time >= 172800) ? ("%d days") : ("%d day"), time / 86400);

	else if (time >= 2592000 && time < 31536000)
 		format(str, sizeof(str), (time >= 5184000) ? ("%d months") : ("%d month"), time / 2592000);

	else if (time >= 31536000)
		format(str, sizeof(str), (time >= 63072000) ? ("%d years") : ("%d year"), time / 31536000);

	strcat(str, " ago");

	return str;
}

// ====== GetEngineStatus ======
stock GetEngineStatus(vehicleid)
{
	static
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if (engine != 1)
		return 0;

	return 1;
}

// ====== GetHoodStatus ======
stock GetHoodStatus(vehicleid)
{
	static
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if (bonnet != 1)
		return 0;

	return 1;
}

// ====== GetTrunkStatus ======
stock GetTrunkStatus(vehicleid)
{
	static
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if (boot != 1)
		return 0;

	return 1;
}

// ====== GetLightStatus ======
stock GetLightStatus(vehicleid)
{
	static
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if (lights != 1)
		return 0;

	return 1;
}

// ====== SetEngineStatus ======
stock SetEngineStatus(vehicleid, status)
{
	static
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return SetVehicleParamsEx(vehicleid, status, lights, alarm, doors, bonnet, boot, objective);
}

// ====== SetLightStatus ======
stock SetLightStatus(vehicleid, status)
{
	static
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return SetVehicleParamsEx(vehicleid, engine, status, alarm, doors, bonnet, boot, objective);
}

// ====== SetTrunkStatus ======
stock SetTrunkStatus(vehicleid, status)
{
	static
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, status, objective);
}

// ====== SetHoodStatus ======
stock SetHoodStatus(vehicleid, status)
{
	static
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, status, boot, objective);
}
