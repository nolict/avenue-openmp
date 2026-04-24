/*
    File: modules/player/logic/runtime.pwn
    Purpose: Contains player gameplay logic and helper functions for runtime.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

ResetFaction(playerid)
{
    PlayerData[playerid][pFaction] = -1;
    PlayerData[playerid][pFactionID] = -1;
    PlayerData[playerid][pFactionRank] = 0;
}

forward DragUpdate(playerid, targetid);

// ====== DragUpdate ======
public DragUpdate(playerid, targetid)
{
	if (PlayerData[targetid][pDragged] && PlayerData[targetid][pDraggedBy] == playerid)
	{
	    static
	        Float:fX,
	        Float:fY,
	        Float:fZ,
			Float:fAngle;

		GetPlayerPos(playerid, fX, fY, fZ);
		GetPlayerFacingAngle(playerid, fAngle);

		fX -= 3.0 * floatsin(-fAngle, degrees);
		fY -= 3.0 * floatcos(-fAngle, degrees);

		SetPlayerPos(targetid, fX, fY, fZ);
		SetPlayerInterior(targetid, GetPlayerInterior(playerid));
		SetPlayerVirtualWorld(targetid, GetPlayerVirtualWorld(playerid));
	}
	return 1;
}

StopDragging(playerid)
{
	if (PlayerData[playerid][pDragged])
	{
	    PlayerData[playerid][pDragged] = 0;
		PlayerData[playerid][pDraggedBy] = INVALID_PLAYER_ID;
		KillTimer(PlayerData[playerid][pDragTimer]);
	}
	return 1;
}

ResetEditing(playerid)
{
    if (PlayerData[playerid][pEditFurniture] != -1)
		Furniture_Refresh(PlayerData[playerid][pEditFurniture]);

	if (PlayerData[playerid][pEditPump] != -1)
	{
		Pump_Refresh(PlayerData[playerid][pEditPump]);
		PlayerData[playerid][pGasStation] = -1;
	}
	PlayerData[playerid][pEditType] = 0;
 	PlayerData[playerid][pEditGate] = -1;
 	PlayerData[playerid][pEditRack] = -1;
	PlayerData[playerid][pEditPump] = -1;
	PlayerData[playerid][pEditFurniture] = -1;
	return 1;
}

ResetPlayer(playerid)
{
	if (PlayerData[playerid][pDrinking])
	    DestroyPlayerProgressBar(playerid, PlayerData[playerid][pDrinkBar]);

    if (PlayerData[playerid][pFirstAid])
	    KillTimer(PlayerData[playerid][pAidTimer]);

	if (PlayerData[playerid][pDrivingTest])
	    DestroyVehicle(PlayerData[playerid][pTestCar]);

	if (PlayerData[playerid][pWaypoint])
	{
        PlayerData[playerid][pWaypoint] = 0;
        PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][69]);
	}
	foreach (new i : Player) if (PlayerData[i][pDraggedBy] == playerid) {
	    StopDragging(i);
	}
	if (PlayerData[playerid][pDragged]) {
	    StopDragging(playerid);
	}
    PlayerData[playerid][pHospital] = -1;
	PlayerData[playerid][pCooking] = 0;
	PlayerData[playerid][pCookingTime] = 0;
	PlayerData[playerid][pCookingHouse] = -1;
	PlayerData[playerid][pGasPump] = -1;
	PlayerData[playerid][pCarryTrash] = 0;
	PlayerData[playerid][pGasStation] = -1;
	PlayerData[playerid][pCrafting] = 0;
	PlayerData[playerid][pOpeningCrate] = 0;
	PlayerData[playerid][pHarvesting] = 0;
	PlayerData[playerid][pDrivingTest] = 0;
	PlayerData[playerid][pFuelCan] = 0;
	PlayerData[playerid][pFingerTime] = 0;
	PlayerData[playerid][pFingerItem] = -1;
	PlayerData[playerid][pFirstAid] = 0;
	PlayerData[playerid][pDrinking] = 0;
	PlayerData[playerid][pDrinkTime] = 0;
	PlayerData[playerid][pEmergency] = 0;
	PlayerData[playerid][pPlaceAd] = 0;
	PlayerData[playerid][pAdTime] = 0;
	PlayerData[playerid][pTaxiCalled] = 0;
	PlayerData[playerid][pMining] = 0;
	PlayerData[playerid][pMinedRock] = 0;
	PlayerData[playerid][pMineTime] = 0;
	PlayerData[playerid][pBleeding] = 0;
	PlayerData[playerid][pBleedTime] = 0;
	PlayerData[playerid][pLoadType] = 0;
	PlayerData[playerid][pLoadCrate] = 0;
	PlayerData[playerid][pLoading] = 0;
	PlayerData[playerid][pUnloading] = -1;
	PlayerData[playerid][pUnloadVehicle] = INVALID_VEHICLE_ID;
	PlayerData[playerid][pUsedMagazine] = 0;
	PlayerData[playerid][pSorting] = -1;
	PlayerData[playerid][pSortCrate] = 0;
	PlayerData[playerid][pCP] = 0;
	PlayerData[playerid][pMaskOn] = 0;
	PlayerData[playerid][pHideTags] = 0;
	PlayerData[playerid][pCuffed] = 0;
	PlayerData[playerid][pGraffiti] = -1;
	PlayerData[playerid][pGraffitiTime] = 0;
	PlayerData[playerid][pPicking] = 0;
	PlayerData[playerid][pPickCar] = -1;
	PlayerData[playerid][pPickTime] = 0;

	if (Inventory_HasItem(playerid, "Mask")) {
	    Inventory_Remove(playerid, "Mask");
	}
	ResetNameTag(playerid);

	RemovePlayerAttachedObject(playerid, 4);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

	DisablePlayerCheckpoint(playerid);
	GameTextForPlayer(playerid, " ", 1, 3);

	HidePlayerFooter(playerid);
	HoldWeapon(playerid, 0);
}

ResetWeapons(playerid)
{
	ResetPlayerWeapons(playerid);

	for (new i = 0; i < 13; i ++) {
		PlayerData[playerid][pGuns][i] = 0;
		PlayerData[playerid][pAmmo][i] = 0;
	}
	return 1;
}

ResetWeapon(playerid, weaponid)
{
	ResetPlayerWeapons(playerid);

	for (new i = 0; i < 13; i ++) {
	    if (PlayerData[playerid][pGuns][i] != weaponid) {
	        GivePlayerWeapon(playerid, PlayerData[playerid][pGuns][i], PlayerData[playerid][pAmmo][i]);
		}
		else {
            PlayerData[playerid][pGuns][i] = 0;
            PlayerData[playerid][pAmmo][i] = 0;
	    }
	}
	return 1;
}

GiveWeaponToPlayer(playerid, weaponid, ammo)
{
	if (weaponid < 0 || weaponid > 46)
	    return 0;

	PlayerData[playerid][pGuns][g_aWeaponSlots[weaponid]] = weaponid;
	PlayerData[playerid][pAmmo][g_aWeaponSlots[weaponid]] += ammo;

	return GivePlayerWeapon(playerid, weaponid, ammo);
}

GiveMoney(playerid, amount)
{
	PlayerData[playerid][pMoney] += amount;
	GivePlayerMoney(playerid, amount);

	return 1;
}

GetPlayerSQLID(playerid)
{
	return (PlayerData[playerid][pID]);
}

GetMoney(playerid)
{
	return (PlayerData[playerid][pMoney]);
}



KickEx(playerid)
{
	if (PlayerData[playerid][pKicked])
	    return 0;

	PlayerData[playerid][pKicked] = 1;
	SetTimerEx("KickTimer", 200, false, "d", playerid);

	return 1;
}

forward KickTimer(playerid);

// ====== KickTimer ======
public KickTimer(playerid)
{
	if (PlayerData[playerid][pKicked])
	{
		return Kick(playerid);
	}
	return 0;
}

// ====== SetDefaultSpawn ======
stock SetDefaultSpawn(playerid)
{
    SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);


	if(PlayerData[playerid][pSpawnPoint] == 0) // Airport
	{
	    SetPlayerPos(playerid, 1642.1957, -2334.4849, 13.5469);
	    SetPlayerFacingAngle(playerid, 0.0);
	}
	if(PlayerData[playerid][pSpawnPoint] == 1) // Faction
	{
	    new faction = PlayerData[playerid][pFactionID];
	    if(PlayerData[playerid][pFactionID] == -1)
	    {
	        SendErrorMessage(playerid, "You've been set to civilian spawn.");
	        SetPlayerPos(playerid, 1642.1957, -2334.4849, 13.5469);
	    	SetPlayerFacingAngle(playerid, 0.0);
		}
		SetPlayerPos(playerid,FactionData[faction][SpawnX],FactionData[faction][SpawnY],FactionData[faction][SpawnZ]);
		SetPlayerInterior(playerid,FactionData[faction][SpawnInterior]);
		SetPlayerVirtualWorld(playerid, FactionData[faction][SpawnVW]);
	}
	if(PlayerData[playerid][pSpawnPoint] == 2)
	{
	    SetPlayerPos(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]);
	    SetPlayerFacingAngle(playerid, PlayerData[playerid][pPos][3]);
	    SetPlayerInterior(playerid, PlayerData[playerid][pInterior]);
	    SetPlayerVirtualWorld(playerid, PlayerData[playerid][pWorld]);
	}

	/*#if SERVER_CITY == 1
	    SetPlayerPos(playerid, 1642.1957, -2334.4849, 13.5469);
	    SetPlayerFacingAngle(playerid, 0.0);
	#elseif SERVER_CITY == 2
		SetPlayerPos(playerid, -2425.5615, 337.5465, 37.0018);
		SetPlayerFacingAngle(playerid, 238.0);
	#elseif SERVER_CITY == 3
	    SetPlayerPos(playerid, 1675.7245, 1447.8938, 10.7866);
	    SetPlayerFacingAngle(playerid, 270.0);
	#endif*/

	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid, 1);
	return 1;
}

// ====== RespawnPlayer ======
stock RespawnPlayer(playerid)
{
	if (IsPlayerInAnyVehicle(playerid))
	{
        new
		    Float:x,
		    Float:y,
	    	Float:z;

	    GetPlayerPos(playerid, x, y, z);
	    SetPlayerPos(playerid, x, y, z + 1);
	}
	SpawnPlayer(playerid);
	SetDefaultSpawn(playerid);
	return 1;
}



// ====== IsPlayerNearPlayer ======
stock IsPlayerNearPlayer(playerid, targetid, Float:radius)
{
	static
		Float:fX,
		Float:fY,
		Float:fZ;

	GetPlayerPos(targetid, fX, fY, fZ);

	return (GetPlayerInterior(playerid) == GetPlayerInterior(targetid) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid)) && IsPlayerInRangeOfPoint(playerid, radius, fX, fY, fZ);
}



// ====== CancelDrivingTest ======
stock CancelDrivingTest(playerid)
{
	if (PlayerData[playerid][pDrivingTest])
	{
 		SetPlayerPos(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]);
 		SetPlayerFacingAngle(playerid, PlayerData[playerid][pPos][3]);

  		SetPlayerInterior(playerid, PlayerData[playerid][pInterior]);
  		SetPlayerVirtualWorld(playerid, PlayerData[playerid][pWorld]);

		DisablePlayerCheckpoint(playerid);
  		SetCameraBehindPlayer(playerid);

		DestroyVehicle(PlayerData[playerid][pTestCar]);
  		PlayerData[playerid][pDrivingTest] = false;
	}
	return 1;
}

