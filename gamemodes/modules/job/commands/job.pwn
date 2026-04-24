/*
    File: modules/job/commands/job.pwn
    Purpose: Contains ZCMD command handlers for job job features.
    Notes: Keep command parsing here and delegate reusable gameplay work to logic files.
*/

// ====== CMD:drivingtest ======
CMD:drivingtest(playerid, params[])
{
	if (PlayerData[playerid][pDrivingTest])
	    return SendErrorMessage(playerid, "You have already started the driving test!");

	if (!IsPlayerInRangeOfPoint(playerid, 3.0, -2033.0439, -117.4885, 1035.1719))
	    return SendErrorMessage(playerid, "You are not in range of the pickup.");

	if (Inventory_HasItem(playerid, "Driving License"))
	    return SendErrorMessage(playerid, "You have your driving license already!");

	if (GetMoney(playerid) < 50)
	    return SendErrorMessage(playerid, "You don't have $50 for the driving test.");

    PlayerData[playerid][pInterior] = GetPlayerInterior(playerid);
   	PlayerData[playerid][pWorld] = GetPlayerVirtualWorld(playerid);

	GetPlayerHealth(playerid, PlayerData[playerid][pHealth]);
	GetPlayerPos(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]);
 	GetPlayerFacingAngle(playerid, PlayerData[playerid][pPos][3]);

    PlayerData[playerid][pTestCar] = CreateVehicle(410, -2047.1056, -87.7183, 34.8219, 0.1447, 1, 1, -1);
    PlayerData[playerid][pTestWarns] = 0;

	if (PlayerData[playerid][pTestCar] != INVALID_VEHICLE_ID)
	{
		PlayerData[playerid][pDrivingTest] = true;
	    PlayerData[playerid][pTestStage] = 0;

		ResetVehicle(PlayerData[playerid][pTestCar]);
	    SetPlayerVirtualWorld(playerid, (2000 + playerid));

	    SetVehicleVirtualWorld(PlayerData[playerid][pTestCar], (2000 + playerid));
		PutPlayerInVehicle(playerid, PlayerData[playerid][pTestCar], 0);

		SetPlayerCheckpoint(playerid, g_arrDrivingCheckpoints[0][0], g_arrDrivingCheckpoints[0][1], g_arrDrivingCheckpoints[0][2], 3.0);
		SendServerMessage(playerid, "You have started the driving test.");

		SetPlayerInterior(playerid, 0);
	}
	return 1;
}


// ====== CMD:createjob ======
CMD:createjob(playerid, params[])
{
	static
	    type,
		id = -1;

	if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", type))
	    return SendSyntaxMessage(playerid, "/createjob [type]");

	if (type < 1 || type > 9)
	    return SendErrorMessage(playerid, "Invalid type specified. Types range from 1 to 9.");

	id = Job_Create(playerid, type);

	if (id == -1)
	    return SendErrorMessage(playerid, "The server has reached the limit for jobs.");

	SendServerMessage(playerid, "You have successfully created job ID: %d.", id);
	return 1;
}


// ====== CMD:destroyjob ======
CMD:destroyjob(playerid, params[])
{
	static
	    id = 0;

    if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/destroyjob [job id]");

	if ((id < 0 || id >= MAX_DYNAMIC_JOBS) || !JobData[id][jobExists])
	    return SendErrorMessage(playerid, "You have specified an invalid job ID.");

	Job_Delete(id);
	SendServerMessage(playerid, "You have successfully destroyed job ID: %d.", id);
	return 1;
}


// ====== CMD:editjob ======
CMD:editjob(playerid, params[])
{
	static
	    id,
	    type[24],
	    string[128];

	if (PlayerData[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editjob [id] [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, type, point, deliver");
		return 1;
	}
	if ((id < 0 || id >= MAX_DYNAMIC_JOBS) || !JobData[id][jobExists])
	    return SendErrorMessage(playerid, "You have specified an invalid job ID.");

	if (!strcmp(type, "location", true))
	{
	    static
	        Float:x,
	        Float:y,
	        Float:z;

	    GetPlayerPos(playerid, x, y, z);

		JobData[id][jobPos][0] = x;
		JobData[id][jobPos][1] = y;
		JobData[id][jobPos][2] = z;

		JobData[id][jobInterior] = GetPlayerInterior(playerid);
		JobData[id][jobWorld] = GetPlayerVirtualWorld(playerid);

		Job_Refresh(id);
		Job_Save(id);

		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the location of job ID: %d.", ReturnName(playerid, 0), id);
	}
 	else if (!strcmp(type, "type", true))
	{
	    new typeint;

	    if (sscanf(string, "d", typeint))
	        return SendSyntaxMessage(playerid, "/edithouse [id] [type] [new type]");

        if (typeint < 1 || typeint > 9)
	    	return SendErrorMessage(playerid, "Invalid type specified. Types range from 1 to 9.");

	    JobData[id][jobType] = typeint;

	    Job_Refresh(id);
	    Job_Save(id);

		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the type of job ID: %d to %s.", ReturnName(playerid, 0), id, Job_GetName(typeint));
	}
	else if (!strcmp(type, "point", true))
	{
	    static
	        Float:x,
	        Float:y,
	        Float:z;

	    GetPlayerPos(playerid, x, y, z);

		JobData[id][jobPoint][0] = x;
		JobData[id][jobPoint][1] = y;
		JobData[id][jobPoint][2] = z;
        JobData[id][jobPointInt] = GetPlayerInterior(playerid);
        JobData[id][jobPointWorld] = GetPlayerVirtualWorld(playerid);

		Job_Refresh(id);
		Job_Save(id);

		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the point of job ID: %d.", ReturnName(playerid, 0), id);
	}
	else if (!strcmp(type, "deliver", true))
	{
	    if (GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
	        return SendErrorMessage(playerid, "You can't place the deliver point inside interiors.");

	    static
	        Float:x,
	        Float:y,
	        Float:z;

	    GetPlayerPos(playerid, x, y, z);

		JobData[id][jobDeliver][0] = x;
		JobData[id][jobDeliver][1] = y;
		JobData[id][jobDeliver][2] = z;

		Job_Refresh(id);
		Job_Save(id);

		SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the deliver point of job ID: %d.", ReturnName(playerid, 0), id);
	}
	return 1;
}


// ====== CMD:quitjob ======
CMD:quitjob(playerid, params[])
{
	if (PlayerData[playerid][pJob] != 0)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (PlayerData[playerid][pMinedRock])
		{
	    	PlayerData[playerid][pMinedRock] = 0;
			PlayerData[playerid][pMineCount] = 0;

			DisablePlayerCheckpoint(playerid);

			RemovePlayerAttachedObject(playerid, 4);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		}
		if (PlayerData[playerid][pJob] == JOB_COURIER)
		{
			if (PlayerData[playerid][pUnloading] != -1)
			{
	   		 	PlayerData[playerid][pUnloading] = -1;
	    		PlayerData[playerid][pUnloadVehicle] = INVALID_VEHICLE_ID;

	    		DisablePlayerCheckpoint(playerid);
			}
			if (PlayerData[playerid][pDeliverShipment])
			{
			    PlayerData[playerid][pShipment] = -1;
			    PlayerData[playerid][pDeliverShipment] = 0;

			    DisablePlayerCheckpoint(playerid);
			}
			if (PlayerData[playerid][pLoading])
			{
	   	 		PlayerData[playerid][pLoading] = 0;
	    		PlayerData[playerid][pLoadType] = 0;

	    		DisablePlayerCheckpoint(playerid);
			}
			if (PlayerData[playerid][pLoadCrate])
 			{
  				PlayerData[playerid][pLoadCrate] = 0;

				RemovePlayerAttachedObject(playerid, 4);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			}
		}
		if (IsPlayerInWarehouse(playerid) && GetVehicleModel(vehicleid) == 530 && CoreVehicles[vehicleid][vehLoadType] == 7)
		{
 			CoreVehicles[vehicleid][vehLoadType] = 0;
   			DestroyObject(CoreVehicles[vehicleid][vehCrate]);

			CoreVehicles[vehicleid][vehCrate] = INVALID_OBJECT_ID;
			DisablePlayerCheckpoint(playerid);
		}
		SendServerMessage(playerid, "You have quit your job as a \"%s\".", Job_GetName(PlayerData[playerid][pJob]));
		PlayerData[playerid][pJob] = 0;
	}
	else SendErrorMessage(playerid, "You don't have a job to quit.");
	return 1;
}


// ====== CMD:takejob ======
CMD:takejob(playerid, params[])
{
	static
	    id = -1;

	if ((id = Job_Nearest(playerid)) != -1)
	{
	    if (PlayerData[playerid][pJob] == JobData[id][jobType])
	        return SendErrorMessage(playerid, "You have this job already.");

	    PlayerData[playerid][pJob] = JobData[id][jobType];

	    return SendServerMessage(playerid, "You are now a %s - type \"/jobcmds\" for job commands.", Job_GetName(JobData[id][jobType]));
	}
    SendErrorMessage(playerid, "You are not in range of any job pickup.");
	return 1;
}


// ====== CMD:unload ======
CMD:unload(playerid, params[])
{
	new
		id = Business_NearestDeliver(playerid),
		vid = GetPlayerVehicleID(playerid);

	if (PlayerData[playerid][pJob] != JOB_COURIER)
	    return SendErrorMessage(playerid, "You don't have the appropriate job.");

    if (id == -1)
	    return SendErrorMessage(playerid, "You are not in range of any delivery point.");

 	if (!IsLoadableVehicle(vid))
  		return SendErrorMessage(playerid, "You are not inside any loadable vehicle.");

	if (!CoreVehicles[vid][vehLoadType] || CoreVehicles[vid][vehLoads] < 1)
	    return SendErrorMessage(playerid, "There is nothing loaded in this vehicle.");

	if (PlayerData[playerid][pUnloading] != -1)
	    return SendErrorMessage(playerid, "You are already unloading your crates.");

	if (PlayerData[playerid][pShipment] != -1 && id != PlayerData[playerid][pShipment])
	    return SendErrorMessage(playerid, "You didn't accept shipment for this business.");

	switch (CoreVehicles[vid][vehLoadType])
 	{
	 	case 1:
	 	{
	 	    if (BusinessData[id][bizType] != 1 && BusinessData[id][bizType] != 6)
	 	        return SendErrorMessage(playerid, "This business can't accept this load (wrong type).");
		}
		case 2..4:
		{
		    if (BusinessData[id][bizType] != CoreVehicles[vid][vehLoadType])
	 	        return SendErrorMessage(playerid, "This business can't accept this load (wrong type).");
		}
		case 5:
		{
		    if (BusinessData[id][bizType] != 6)
	 	        return SendErrorMessage(playerid, "This business can't accept this load (wrong type).");
		}
		case 6:
		{
		    if (BusinessData[id][bizType] != 7)
	 	        return SendErrorMessage(playerid, "This business can't accept this load (wrong type).");
		}
	}
	static
	    Float:fX,
	    Float:fY,
	    Float:fZ;

	DisableWaypoint(playerid);

	GetVehicleBoot(vid, fX, fY, fZ);
	RemovePlayerFromVehicle(playerid);

	PlayerData[playerid][pUnloading] = id;
	PlayerData[playerid][pUnloadVehicle] = vid;

	SetPlayerCheckpoint(playerid, fX, fY, fZ, 1.0);
	SendServerMessage(playerid, "Please unload the crates and deliver them to the point.");

	return 1;
}


// ====== CMD:repair ======
CMD:repair(playerid, params[])
{
	if (PlayerData[playerid][pJob] != JOB_MECHANIC)
	    return SendErrorMessage(playerid, "You don't have the appropriate job.");

	if (IsPlayerInAnyVehicle(playerid))
	    return SendErrorMessage(playerid, "You must exit the vehicle first.");

	if (!Inventory_HasItem(playerid, "Repair Kit"))
	    return SendErrorMessage(playerid, "You don't have a repair kit on you.");

	if (PlayerData[playerid][pRepairTime] > gettime())
	    return SendErrorMessage(playerid, "You must wait %d seconds before repairing again.", PlayerData[playerid][pRepairTime] - gettime());

	for (new i = 1; i != MAX_VEHICLES; i ++) if (IsValidVehicle(i) && IsPlayerNearHood(playerid, i))
	{
	    if (!IsEngineVehicle(i))
	        return SendErrorMessage(playerid, "This vehicle can't be repaired.");

	    if (!GetHoodStatus(i))
	        return SendErrorMessage(playerid, "The hood must be opened before a repair.");

        if (CoreVehicles[i][vehRepairing])
            return SendErrorMessage(playerid, "This vehicle is already being repaired.");

		Inventory_Remove(playerid, "Repair Kit");
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);

        CoreVehicles[i][vehRepairing] = true;
        SetTimerEx("RepairCar", 5000, false, "dd", playerid, i);

        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s starts to repair the vehicle.", ReturnName(playerid, 0));
		GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Repairing...~w~ Please wait", 5500, 3);
		return 1;
	}
	SendErrorMessage(playerid, "You are not in range of any vehicle's hood.");
	return 1;
}


// ====== CMD:nitrous ======
CMD:nitrous(playerid, params[])
{
	if (PlayerData[playerid][pJob] != JOB_MECHANIC)
	    return SendErrorMessage(playerid, "You don't have the appropriate job.");

	if (IsPlayerInAnyVehicle(playerid))
	    return SendErrorMessage(playerid, "You must exit the vehicle first.");

	if (!Inventory_HasItem(playerid, "NOS Canister"))
	    return SendErrorMessage(playerid, "You don't have a NOS canister on you.");

	for (new i = 1; i != MAX_VEHICLES; i ++) if (IsValidVehicle(i) && IsPlayerNearHood(playerid, i))
	{
	    if (!IsEngineVehicle(i) || IsABike(i) || IsABoat(i) || IsAPlane(i) || IsAHelicopter(i))
	        return SendErrorMessage(playerid, "You can't add nitrous to this vehicle.");

	    if (!GetHoodStatus(i))
	        return SendErrorMessage(playerid, "The hood must be opened before adding nitrous.");

		Inventory_Remove(playerid, "NOS Canister");
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);

		AddComponent(i, 1010);
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s places a NOS canister into the vehicle's engine.", ReturnName(playerid, 0));
		return 1;
	}
	SendErrorMessage(playerid, "You are not in range of any vehicle's hood.");
	return 1;
}


// ====== CMD:acceptcall ======
CMD:acceptcall(playerid, params[])
{
    if (PlayerData[playerid][pJob] != JOB_TAXI)
	    return SendErrorMessage(playerid, "You don't have the appropriate job.");

	if (!PlayerData[playerid][pTaxiDuty])
	    return SendErrorMessage(playerid, "You must be on taxi duty to accept calls.");

	Taxi_ShowCalls(playerid);
	return 1;
}


// ====== CMD:taxi ======
CMD:taxi(playerid, params[])
{
	new modelid = GetVehicleModel(GetPlayerVehicleID(playerid));

    if (PlayerData[playerid][pJob] != JOB_TAXI)
	    return SendErrorMessage(playerid, "You don't have the appropriate job.");

	if (modelid != 438 && modelid != 420)
	    return SendErrorMessage(playerid, "You must be inside a taxi.");

	if (PlayerData[playerid][pTaxiDuty])
	{
	    foreach (new i : Player) if (PlayerData[i][pTaxiPlayer] == playerid && IsPlayerInVehicle(i, GetPlayerVehicleID(playerid))) {
	        LeaveTaxi(i, playerid);
	    }
	    SetPlayerColor(playerid, DEFAULT_COLOR);

        PlayerData[playerid][pTaxiDuty] = false;
        SendServerMessage(playerid, "You are no longer on taxi duty!");
	}
	else
	{
		SetPlayerColor(playerid, 0xF5DEB300);

	    PlayerData[playerid][pTaxiDuty] = true;
	    SendClientMessageToAllEx(COLOR_GREEN, "[TAXI]: %s is now on taxi duty. Type \"/call 1222\" to call a taxi!", ReturnName(playerid, 0));
	}
	return 1;
}


// ====== CMD:mine ======
CMD:mine(playerid, params[])
{
    if (PlayerData[playerid][pJob] != JOB_MINER)
	    return SendErrorMessage(playerid, "You don't have the appropriate job.");

	if (!IsPlayerNearMine(playerid))
	    return SendErrorMessage(playerid, "You must be near the mine.");

	if (PlayerData[playerid][pMining])
	{
	    PlayerData[playerid][pMining] = false;
	    PlayerData[playerid][pMineCount] = 0;

		RemovePlayerAttachedObject(playerid, 4);
	    SendServerMessage(playerid, "You have finished your mining job.");
	}
	else
	{
	    PlayerData[playerid][pMining] = true;
        PlayerData[playerid][pMineCount] = 0;

	    SendServerMessage(playerid, "You are now mining! Use the fire key to begin digging.");
	    SetPlayerAttachedObject(playerid, 4, 18634, 6, 0.156547, 0.039423, 0.026570, 198.109115, 6.364907, 262.997558, 1.000000, 1.000000, 1.000000);
	}
	return 1;
}


// ====== CMD:sellfood ======
CMD:sellfood(playerid, params[])
{
	if (PlayerData[playerid][pJob] != JOB_FOOD_VENDOR)
	    return SendErrorMessage(playerid, "You don't have the appropriate job.");

	if (GetVehicleModel(GetPlayerVehicleID(playerid)) != 423)
 		return SendErrorMessage(playerid, "You are not inside a food truck.");

	static
	    userid,
	    food[24],
	    price;

	if (sscanf(params, "us[24]d", userid, food, price))
	{
	    SendSyntaxMessage(playerid, "/sellfood [playerid/name] [food name] [price]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} water, soda, burger, pizza, chicken");
	    return 1;
	}
	if (userid == INVALID_PLAYER_ID || !IsPlayerNearPlayer(playerid, userid, 7.0))
	    return SendErrorMessage(playerid, "That player is disconnected or not near you.");

	if (price < 1 || price > 20)
	    return SendErrorMessage(playerid, "The price can't be below $1 or above $20.");

	if (!strcmp(food, "water", true))
	{
	    PlayerData[userid][pFoodSeller] = playerid;
	    PlayerData[userid][pFoodType] = 1;
	    PlayerData[userid][pFoodPrice] = price;

		SendServerMessage(userid, "%s has offered you some water for $%d (type \"/approve food\" to accept).", ReturnName(playerid, 0), price);
		SendServerMessage(playerid, "You have offered some water to %s for $%d.", ReturnName(userid, 0), price);
	}
	else if (!strcmp(food, "soda", true))
	{
	    PlayerData[userid][pFoodSeller] = playerid;
	    PlayerData[userid][pFoodType] = 2;
	    PlayerData[userid][pFoodPrice] = price;

		SendServerMessage(userid, "%s has offered you a soda for $%d (type \"/approve food\" to accept).", ReturnName(playerid, 0), price);
		SendServerMessage(playerid, "You have offered a soda to %s for $%d.", ReturnName(userid, 0), price);
	}
	else if (!strcmp(food, "burger", true))
	{
	    PlayerData[userid][pFoodSeller] = playerid;
	    PlayerData[userid][pFoodType] = 3;
	    PlayerData[userid][pFoodPrice] = price;

		SendServerMessage(userid, "%s has offered you a burger for $%d (type \"/approve food\" to accept).", ReturnName(playerid, 0), price);
		SendServerMessage(playerid, "You have offered a burger to %s for $%d.", ReturnName(userid, 0), price);
	}
	else if (!strcmp(food, "pizza", true))
	{
	    PlayerData[userid][pFoodSeller] = playerid;
	    PlayerData[userid][pFoodType] = 4;
	    PlayerData[userid][pFoodPrice] = price;

		SendServerMessage(userid, "%s has offered you a slice of pizza for $%d (type \"/approve food\" to accept).", ReturnName(playerid, 0), price);
		SendServerMessage(playerid, "You have offered a slice of pizza to %s for $%d.", ReturnName(userid, 0), price);
	}
	else if (!strcmp(food, "chicken", true))
	{
	    PlayerData[userid][pFoodSeller] = playerid;
	    PlayerData[userid][pFoodType] = 5;
	    PlayerData[userid][pFoodPrice] = price;

		SendServerMessage(userid, "%s has offered you some chicken for $%d (type \"/approve food\" to accept).", ReturnName(playerid, 0), price);
		SendServerMessage(playerid, "You have offered some chicken to %s for $%d.", ReturnName(userid, 0), price);
	}
	return 1;
}


// ====== CMD:joblist ======
CMD:joblist(playerid, params[])
{
	Dialog_Show(playerid, JobList, DIALOG_STYLE_LIST, DialogStyle_Title("Job List"), DialogStyle_Body("Courier\nMechanic\nTaxi Driver\nCargo Unloader\nMiner\nFood Vendor\nGarbage Man\nPackage Sorter\nWeapon Smuggler"), "Select", "Cancel");
	return 1;
}


// ====== CMD:jobcmds ======
CMD:jobcmds(playerid, params[])
{
	switch (PlayerData[playerid][pJob])
	{
	    case 1: SendClientMessage(playerid, COLOR_CLIENT, "JOBS:{FFFFFF} /startdelivery, /stoploading, /unload, /shipments.");
	    case 2: SendClientMessage(playerid, COLOR_CLIENT, "JOBS:{FFFFFF} /repair, /nitrous.");
	    case 3: SendClientMessage(playerid, COLOR_CLIENT, "JOBS:{FFFFFF} /taxi, /acceptcall.");
	    case 4: SendClientMessage(playerid, COLOR_CLIENT, "JOBS:{FFFFFF} /loadcrate.");
	    case 5: SendClientMessage(playerid, COLOR_CLIENT, "JOBS:{FFFFFF} /mine.");
	    case 6: SendClientMessage(playerid, COLOR_CLIENT, "JOBS:{FFFFFF} /sellfood.");
	    case 7: SendClientMessage(playerid, COLOR_CLIENT, "JOBS:{FFFFFF} /takebag, /dumpgarbage, /findgarbage.");
	    case 8: SendClientMessage(playerid, COLOR_CLIENT, "JOBS:{FFFFFF} /sorting.");
	    case 9: SendClientMessage(playerid, COLOR_CLIENT, "JOBS:{FFFFFF} /craftparts.");
	    default: SendErrorMessage(playerid, "You are unemployed at the moment.");
	}
	return 1;
}


// ====== CMD:startdelivery ======
CMD:startdelivery(playerid, params[])
{
 	new id = Job_NearestPoint(playerid);

	if (PlayerData[playerid][pJob] != JOB_COURIER)
	    return SendErrorMessage(playerid, "You don't have the appropriate job.");

	if (id == -1 || JobData[id][jobType] != JOB_COURIER)
	    return SendErrorMessage(playerid, "You are not in range of any loading point.");

	if (PlayerData[playerid][pLoadType] > 0)
	    return SendErrorMessage(playerid, "You have already started a delivery.");

    if (IsPlayerInAnyVehicle(playerid))
    	return SendErrorMessage(playerid, "You must exit the vehicle first.");

	Dialog_Show(playerid, StartDelivery, DIALOG_STYLE_LIST, DialogStyle_Title("Select Type"), DialogStyle_Body("Retail Supplies\nAmmunition\nClothing\nFood Supplies\nGasoline\nFurniture"), "Select", "Cancel");
	return 1;
}


// ====== CMD:bshipment ======
CMD:bshipment(playerid, params[])
{
    new id = (Business_Inside(playerid) == -1) ? (Business_Nearest(playerid)) : (Business_Inside(playerid));

    if (id == -1 || !Business_IsOwner(playerid, id))
        return SendErrorMessage(playerid, "You are not in range of your business.");

	if (BusinessData[id][bizType] == 5)
	    return SendErrorMessage(playerid, "You can't request shipment for this business type.");

	if (BusinessData[id][bizShipment])
	{
	    foreach (new i : Player) if (PlayerData[i][pShipment] == id)
		{
	        CancelShipment(i);
	        SendServerMessage(i, "The shipment request has been cancelled.");
	    }
	    BusinessData[id][bizShipment] = 0;
	    Business_Save(id);

	    SendServerMessage(playerid, "Your business is no longer requesting a shipment.");
	    SendJobMessage(1, COLOR_YELLOW, "** %s is no longer requesting a shipment for %s. **", ReturnName(playerid, 0), BusinessData[id][bizName]);
	}
	else
	{
	    if (BusinessData[id][bizDeliver][0] == 0.0 && BusinessData[id][bizDeliver][1] == 0.0 && BusinessData[id][bizDeliver][2] == 0.0)
	        return SendErrorMessage(playerid, "The delivery point for your business is not set.");

	    BusinessData[id][bizShipment] = 1;
	    Business_Save(id);

	    SendServerMessage(playerid, "Your have requested a shipment for your business.");
		SendJobMessage(1, COLOR_YELLOW, "** %s is requesting a shipment for %s (/shipments to accept). **", ReturnName(playerid, 0), BusinessData[id][bizName]);
	}
	return 1;
}


// ====== CMD:cancelshipment ======
CMD:cancelshipment(playerid, params[])
{
	if (PlayerData[playerid][pJob] != JOB_COURIER)
	    return SendErrorMessage(playerid, "You don't have the appropriate job.");

	if (PlayerData[playerid][pShipment] == -1)
	    return SendErrorMessage(playerid, "You haven't accepted any shipments yet.");

	CancelShipment(playerid);
	SendServerMessage(playerid, "You have cancelled the accepted shipment.");
	return 1;
}


// ====== CMD:shipments ======
CMD:shipments(playerid, params[])
{
    if (PlayerData[playerid][pJob] != JOB_COURIER)
	    return SendErrorMessage(playerid, "You don't have the appropriate job.");

	if (PlayerData[playerid][pShipment] != -1)
	    return SendErrorMessage(playerid, "You have already accepted a shipment (type /cancelshipment to cancel it).");

	ShowShipments(playerid);
	return 1;
}


// ====== CMD:sorting ======
CMD:sorting(playerid, params[])
{
	new id = -1;

	if (PlayerData[playerid][pJob] != JOB_SORTER)
	    return SendErrorMessage(playerid, "You don't have the appropriate job.");

    if ((id = Job_NearestPoint(playerid)) == -1 || JobData[id][jobType] != JOB_SORTER)
		return SendErrorMessage(playerid, "You are not in range of the sorting facility.");

 	switch (PlayerData[playerid][pSorting])
 	{
	 	case -1:
 	    {
 	        PlayerData[playerid][pSorting] = id;
 	        PlayerData[playerid][pSortCrate] = 1;

			SendServerMessage(playerid, "You have started sorting. Please make your way to the marker.");

 	        SetPlayerAttachedObject(playerid, 4, 1220, 5, 0.137832, 0.176979, 0.151424, 96.305931, 185.363006, 20.328088, 0.699999, 0.800000, 0.699999);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);

			ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
			SetPlayerCheckpoint(playerid, JobData[id][jobDeliver][0], JobData[id][jobDeliver][1], JobData[id][jobDeliver][2], 1.0);
		}
		default:
		{
		    PlayerData[playerid][pSorting] = -1;

		    if (PlayerData[playerid][pSortCrate] != 0)
		    {
		        PlayerData[playerid][pSortCrate] = 0;

		        RemovePlayerAttachedObject(playerid, 4);
		        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
 	        }
 	        DisablePlayerCheckpoint(playerid);
 	        SendServerMessage(playerid, "You have finished sorting packages.");
 	    }
	}
	return 1;
}

