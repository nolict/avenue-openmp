/*
    File: modules/player/logic/session.pwn
    Purpose: Contains player gameplay logic and helper functions for session.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

ResetStatistics(playerid)
{
	for (new i = 0; i < 3; i ++) {
	    PlayerCharacters[playerid][i][0] = 0;

	    for (new j = 0; j < 9; j ++) {
	    	AccessoryData[playerid][i][j] = 0.0;
	    }
	}
	for (new i = 0; i != MAX_INVENTORY; i ++) {
	    InventoryData[playerid][i][invExists] = false;
	    InventoryData[playerid][i][invModel] = 0;
	    InventoryData[playerid][i][invQuantity] = 0;
	}
	for (new i = 0; i < 12; i ++) {
	    PlayerData[playerid][pGuns][i] = 0;
	    PlayerData[playerid][pAmmo][i] = 0;
	}
	for (new i = 0; i != MAX_HOUSE_FURNITURE; i ++) {
	    ListedFurniture[playerid][i] = -1;
	}
	for (new i = 0; i < MAX_LISTED_ITEMS; i ++) {
	    NearestItems[playerid][i] = -1;
	}
	for (new i = 0; i != MAX_CONTACTS; i ++) {
	    ContactData[playerid][i][contactExists] = false;
	    ContactData[playerid][i][contactID] = 0;
	    ContactData[playerid][i][contactNumber] = 0;
	    ListedContacts[playerid][i] = -1;
	}
	for (new i = 0; i != MAX_GPS_LOCATIONS; i ++) {
	    LocationData[playerid][i][locationExists] = false;
	    LocationData[playerid][i][locationID] = 0;
	}
	for (new i = 0; i != MAX_PLAYER_TICKETS; i ++) {
	    TicketData[playerid][i][ticketID] = 0;
		TicketData[playerid][i][ticketExists] = false;
		TicketData[playerid][i][ticketFee] = 0;
	}
	BoomboxData[playerid][boomboxPlaced] = 0;
	BoomboxData[playerid][boomboxPos][0] = 0.0;
	BoomboxData[playerid][boomboxPos][1] = 0.0;
	BoomboxData[playerid][boomboxPos][2] = 0.0;

	PlayerData[playerid][pID] = -1;
	PlayerData[playerid][pAccount] = 0;
	PlayerData[playerid][pLogged] = 0;
	PlayerData[playerid][pLoginAttempts] = 0;
	PlayerData[playerid][pCreated] = 0;
	PlayerData[playerid][pGender] = 1;
	PlayerData[playerid][pBirthdate][0] = 0;
	PlayerData[playerid][pOrigin][0] = 0;
	PlayerData[playerid][pSkin] = 98;
    PlayerData[playerid][pEditType] = 0;
    PlayerData[playerid][pGlasses] = 0;
    PlayerData[playerid][pHat] = 0;
    PlayerData[playerid][pBandana] = 0;
    PlayerData[playerid][pPos] = 0.0;
    PlayerData[playerid][pInterior] = 0;
    PlayerData[playerid][pWorld] = 0;
    PlayerData[playerid][pCharacter] = 0;
    PlayerData[playerid][pKilled] = 0;
    PlayerData[playerid][pHospital] = -1;
    PlayerData[playerid][pHospitalInt] = -1;
    PlayerData[playerid][pHospitalTime] = 0;
    PlayerData[playerid][pRepairTime] = 0;
    PlayerData[playerid][pMoney] = 250;
    PlayerData[playerid][pBankMoney] = 250;
    PlayerData[playerid][pSpawnPoint] = 0;
    PlayerData[playerid][pSavings] = 0;
    PlayerData[playerid][pAdmin] = 0;
	PlayerData[playerid][pShowFooter] = 0;
	PlayerData[playerid][pReportTime] = 0;
	PlayerData[playerid][pHelpTime] = 0;
	PlayerData[playerid][pSpectator] = INVALID_PLAYER_ID;
	PlayerData[playerid][pJailTime] = 0;
	PlayerData[playerid][pKicked] = 0;
	PlayerData[playerid][pMuted] = 0;
	PlayerData[playerid][pSpamCount] = 0;
	PlayerData[playerid][pCommandCount] = 0;
	PlayerData[playerid][pDisplayStats] = 0;
	PlayerData[playerid][pToggleGlasses] = 0;
	PlayerData[playerid][pToggleHat] = 0;
	PlayerData[playerid][pToggleBandana] = 0;
	PlayerData[playerid][pToggleArmor] = 0;
    PlayerData[playerid][pLastShot] = INVALID_PLAYER_ID;
    PlayerData[playerid][pShotTime] = 0;
	PlayerData[playerid][pInventoryItem] = 0;
	PlayerData[playerid][pStorageItem] = 0;
	PlayerData[playerid][pStorageSelect] = 0;
	PlayerData[playerid][pProductModify] = 0;
	PlayerData[playerid][pTester] = 0;
	PlayerData[playerid][pTutorial] = 0;
	PlayerData[playerid][pTutorialTime] = 0;
	PlayerData[playerid][pTutorialStage] = 0;
	PlayerData[playerid][pHouse] = -1;
	PlayerData[playerid][pBusiness] = -1;
	PlayerData[playerid][pEntrance] = -1;
	PlayerData[playerid][pGasPump] = -1;
	PlayerData[playerid][pGasStation] = -1;
    PlayerData[playerid][pLoading] = 0;
	PlayerData[playerid][pEditPump] = -1;
	PlayerData[playerid][pEditFurniture] = -1;
	PlayerData[playerid][pEditGate] = -1;
	PlayerData[playerid][pEditRack] = -1;
	PlayerData[playerid][pSelectFurniture] = 0;
	PlayerData[playerid][pRefill] = INVALID_VEHICLE_ID;
	PlayerData[playerid][pRefillPrice] = 0;
	PlayerData[playerid][pHouseSeller] = INVALID_PLAYER_ID;
	PlayerData[playerid][pHouseOffered] = -1;
	PlayerData[playerid][pHouseValue] = 0;
	PlayerData[playerid][pBusinessSeller] = INVALID_PLAYER_ID;
	PlayerData[playerid][pBusinessOffered] = -1;
	PlayerData[playerid][pBusinessValue] = 0;
	PlayerData[playerid][pCarSeller] = INVALID_PLAYER_ID;
	PlayerData[playerid][pCarOffered] = -1;
	PlayerData[playerid][pCarValue] = 0;
	PlayerData[playerid][pShakeOffer] = INVALID_PLAYER_ID;
	PlayerData[playerid][pShakeType] = 0;
	PlayerData[playerid][pFriskOffer] = INVALID_PLAYER_ID;
	PlayerData[playerid][pFoodSeller] = INVALID_PLAYER_ID;
	PlayerData[playerid][pFoodType] = 0;
	PlayerData[playerid][pFoodPrice] = 0;
	PlayerData[playerid][pFactionOffer] = INVALID_PLAYER_ID;
	PlayerData[playerid][pFactionOffered] = -1;
	PlayerData[playerid][pPhone] = 0;
	PlayerData[playerid][pPhoneOff] = 0;
	PlayerData[playerid][pLottery] = 0;
	PlayerData[playerid][pLotteryB] = 0;
	PlayerData[playerid][pHunger] = 100;
	PlayerData[playerid][pThirst] = 100;
	PlayerData[playerid][pHungerTime] = 0;
	PlayerData[playerid][pThirstTime] = 0;
	PlayerData[playerid][pCooking] = 0;
	PlayerData[playerid][pCookingTime] = 0;
	PlayerData[playerid][pPlayingHours] = 0;
	PlayerData[playerid][pMinutes] = 0;
	PlayerData[playerid][pArmorStatus] = 0;
	PlayerData[playerid][pArmorShown] = 0;
	PlayerData[playerid][pClothesType] = 0;
	PlayerData[playerid][pDrivingTest] = 0;
	PlayerData[playerid][pTestStage] = 0;
	PlayerData[playerid][pTestWarns] = 0;
	PlayerData[playerid][pFurnitureType] = 0;
	PlayerData[playerid][pJob] = 0;
	PlayerData[playerid][pTaxiFee] = 0;
	PlayerData[playerid][pTaxiTime] = 0;
	PlayerData[playerid][pTaxiPlayer] = INVALID_PLAYER_ID;
	PlayerData[playerid][pTaxiDuty] = 0;
	PlayerData[playerid][pFirstAid] = 0;
	PlayerData[playerid][pIncomingCall] = 0;
	PlayerData[playerid][pCallLine] = INVALID_PLAYER_ID;
	PlayerData[playerid][pMining] = 0;
	PlayerData[playerid][pMineTime] = 0;
	PlayerData[playerid][pMineCount] = 0;
	PlayerData[playerid][pMinedRock] = 0;
	PlayerData[playerid][pCarryTrash] = 0;
	PlayerData[playerid][pCarryCrate] = -1;
	PlayerData[playerid][pCrafting] = 0;
	PlayerData[playerid][pOpeningCrate] = 0;
	PlayerData[playerid][pHarvesting] = 0;
	PlayerData[playerid][pFaction] = -1;
	PlayerData[playerid][pFactionID] = -1;
	PlayerData[playerid][pFactionRank] = 0;
	PlayerData[playerid][pFactionEdit] = -1;
	PlayerData[playerid][pSelectedSlot] = -1;
	PlayerData[playerid][pOnDuty] = 0;
	PlayerData[playerid][pTazer] = 0;
	PlayerData[playerid][pBeanBag] = 0;
	PlayerData[playerid][pStunned] = 0;
	PlayerData[playerid][pCuffed] = 0;
    PlayerData[playerid][pDragged] = 0;
    PlayerData[playerid][pDraggedBy] = INVALID_PLAYER_ID;
	PlayerData[playerid][pPrisoned] = 0;
	PlayerData[playerid][pInjured] = 0;
	PlayerData[playerid][pWarrants] = 0;
    PlayerData[playerid][pMDCPlayer] = INVALID_PLAYER_ID;
    PlayerData[playerid][pTrackTime] = 0;
	PlayerData[playerid][pCP] = 0;
	PlayerData[playerid][pBroadcast] = 0;
	PlayerData[playerid][pNewsGuest] = INVALID_PLAYER_ID;
	PlayerData[playerid][pMuteTime] = 0;
	PlayerData[playerid][pTransfer] = INVALID_PLAYER_ID;
	PlayerData[playerid][pWaypoint] = 0;
	PlayerData[playerid][pWaypointPos][0] = 0.0;
	PlayerData[playerid][pWaypointPos][1] = 0.0;
	PlayerData[playerid][pWaypointPos][2] = 0.0;
	PlayerData[playerid][pFuelCan] = 0;
	PlayerData[playerid][pDisableOOC] = 0;
	PlayerData[playerid][pDisablePM] = 0;
	PlayerData[playerid][pDisableFaction] = 0;
	PlayerData[playerid][pDisableTester] = 0;
	PlayerData[playerid][pDisableBC] = 0;
	PlayerData[playerid][pNameChange][0] = 0;
	PlayerData[playerid][pDrugTime] = 0;
	PlayerData[playerid][pDrugUsed] = 0;
	PlayerData[playerid][pFingerTime] = 0;
	PlayerData[playerid][pFingerItem] = 0;
	PlayerData[playerid][pWeapon] = 0;
	PlayerData[playerid][pBackpackLoot] = -1;
	PlayerData[playerid][pChannel] = 0;
	PlayerData[playerid][pEmergency] = 0;
	PlayerData[playerid][pPlaceAd] = 0;
	PlayerData[playerid][pRangeBooth] = -1;
	PlayerData[playerid][pTargets] = 0;
	PlayerData[playerid][pTargetLevel] = 0;
	PlayerData[playerid][pVendorTime] = 0;
	PlayerData[playerid][pLoopAnim] = 0;
	PlayerData[playerid][pExecute] = 0;
	PlayerData[playerid][pBoombox] = INVALID_PLAYER_ID;
	PlayerData[playerid][pTakeItems] = INVALID_PLAYER_ID;
	PlayerData[playerid][pDrinkBar] = INVALID_PLAYER_BAR_ID;
	PlayerData[playerid][pDrinking] = 0;
	PlayerData[playerid][pDrinkTime] = 0;
	PlayerData[playerid][pTaxiCalled] = 0;
	PlayerData[playerid][pSpeedTime] = 0;
	PlayerData[playerid][pMarker] = 0;
	PlayerData[playerid][pBleeding] = 0;
	PlayerData[playerid][pBleedTime] = 0;
	PlayerData[playerid][pLoadType] = 0;
	PlayerData[playerid][pLoadCrate] = 0;
	PlayerData[playerid][pLoading] = 0;
	PlayerData[playerid][pUnloading] = -1;
	PlayerData[playerid][pUnloadVehicle] = INVALID_VEHICLE_ID;
	PlayerData[playerid][pShipment] = -1;
	PlayerData[playerid][pDeliverShipment] = 0;
	PlayerData[playerid][pHoldWeapon] = 0;
	PlayerData[playerid][pUsedMagazine] = 0;
	PlayerData[playerid][pAdvertise][0] = 0;
	PlayerData[playerid][pFreeze] = 0;
	PlayerData[playerid][pTask] = 0;
    PlayerData[playerid][pBankTask] = 0;
    PlayerData[playerid][pStoreTask] = 0;
    PlayerData[playerid][pTestTask] = 0;
    PlayerData[playerid][pSorting] = -1;
    PlayerData[playerid][pSortCrate] = 0;
    PlayerData[playerid][pHUD] = 1;
    PlayerData[playerid][pTesterDuty] = 0;
    PlayerData[playerid][pAdminDuty] = 0;
    PlayerData[playerid][pSeekHelp] = 0;
    PlayerData[playerid][pMaskID] = random(90000) + 10000;
    PlayerData[playerid][pMaskOn] = 0;
    PlayerData[playerid][pFactionMod] = 0;
    PlayerData[playerid][pCapacity] = 35;
    PlayerData[playerid][pPlayRadio] = 0;
    PlayerData[playerid][pGraffiti] = -1;
    PlayerData[playerid][pGraffitiTime] = 0;
    PlayerData[playerid][pGraffitiColor] = 0;
    PlayerData[playerid][pEditGraffiti] = -1;
    PlayerData[playerid][pAdminHide] = 0;
    PlayerData[playerid][pDetectorTime] = 0;
    PlayerData[playerid][pPicking] = 0;
    PlayerData[playerid][pPickCar] = -1;
	PlayerData[playerid][pPickTime] = 0;
    PlayerData[playerid][pNameTag] = Text3D:INVALID_3DTEXT_ID;
    ResetWarnings(playerid);
}

ResetNameTag(playerid)
{
    foreach (new i : Player) {
		ShowPlayerNameTagForPlayer(i, playerid, 1);
	}
	if (IsValidDynamic3DTextLabel(PlayerData[playerid][pNameTag]))
	    DestroyDynamic3DTextLabel(PlayerData[playerid][pNameTag]);

    PlayerData[playerid][pNameTag] = Text3D:INVALID_3DTEXT_ID;
    return 1;
}

ResetWarnings(playerid)
{
    PlayerData[playerid][pWarnings] = 0;
   	PlayerData[playerid][pWarn1][0] = 0;
    PlayerData[playerid][pWarn2][0] = 0;
}

GetNumberOwner(number)
{
	foreach (new i : Player) if (PlayerData[i][pPhone] == number && Inventory_HasItem(i, "Cellphone")) {
		return i;
	}
	return INVALID_PLAYER_ID;
}

IsPlayerInsideTaxi(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if (GetVehicleModel(vehicleid) == 420 || GetVehicleModel(vehicleid) == 438)
	{
	    foreach (new i : Player)
		{
			if ((i != playerid) && (PlayerData[i][pJob] == JOB_TAXI && PlayerData[i][pTaxiDuty] && GetPlayerState(i) == PLAYER_STATE_DRIVER) && GetPlayerVehicleID(i) == vehicleid)
				return 1;
		}
	}
	return 0;
}

SelectCharacter(playerid, id)
{
	PlayerData[playerid][pCharacter] = id;

	if (!PlayerCharacters[playerid][id - 1][0])
	    return Dialog_Show(playerid, CreateChar, DIALOG_STYLE_INPUT, DialogStyle_Title("Create Character"), DialogStyle_Body("Please enter the name of your new character below:\n\nWarning: Your name must be in the Firstname_Lastname format and not exceed 20 characters."), "Create", "Cancel");

	static
	    query[200];

	PlayerTextDrawSetString(playerid, PlayerData[playerid][pTextdraws][72], PlayerCharacters[playerid][id - 1]);

	format(query, sizeof(query), "SELECT `Skin`, `Birthdate`, `Origin`, `CreateDate`, `LastLogin` FROM `characters` WHERE `Character` = '%s'", PlayerCharacters[playerid][id - 1]);
	mysql_tquery(g_iHandle, query, "OnQueryFinished", "dd", playerid, THREAD_SHOW_CHARACTER);

	return 1;
}
