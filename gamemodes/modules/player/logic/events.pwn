/*
    File: modules/player/logic/events.pwn
    Purpose: Contains player gameplay logic and helper functions for events.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== OnPlayerStreamIn ======
public OnPlayerStreamIn(playerid, forplayerid)
{
    if (PlayerData[playerid][pMaskOn])
		ShowPlayerNameTagForPlayer(forplayerid, playerid, 0);
	else
	    ShowPlayerNameTagForPlayer(forplayerid, playerid, 1);

	return 1;
}

forward OnPlayerUseItem(playerid, itemid, name[]);

// ====== OnPlayerUseItem ======
public OnPlayerUseItem(playerid, itemid, name[])
{
    if (IsFurnitureItem(name))
	{
        new id = House_Inside(playerid);

        if (id == -1)
            return SendErrorMessage(playerid, "You must be inside a house to place furniture.");

		if (!House_IsOwner(playerid, id))
		    return SendErrorMessage(playerid, "You can only place furniture in your own house.");

		static
		    Float:x,
		    Float:y,
		    Float:z,
		    Float:angle;

        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, angle);

        x += 5.0 * floatsin(-angle, degrees);
        y += 5.0 * floatcos(-angle, degrees);

		if (Furniture_GetCount(id) > MAX_HOUSE_FURNITURE)
		    return SendErrorMessage(playerid, "You can only have %d furniture items in your house.", MAX_HOUSE_FURNITURE);

		new furniture = Furniture_Add(id, name, InventoryData[playerid][itemid][invModel], x, y, z, 0.0, 0.0, angle);

		if (furniture == -1)
		    return SendErrorMessage(playerid, "The server has reached the furniture limit.");

		Inventory_Remove(playerid, name);
		PlayerData[playerid][pEditFurniture] = furniture;

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deployed their \"%s\".", ReturnName(playerid, 0), name);
		EditDynamicObject(playerid, FurnitureData[furniture][furnitureObject]);
	}
	else if (!strcmp(name, "Magazine", true)) {
	    cmd_usemag(playerid, "\1");
	}
	else if (!strcmp(name, "Boombox", true)) {
	    cmd_boombox(playerid, "place");
	}
	else if (!strcmp(name, "Backpack", true)) {
	    cmd_backpack(playerid, "\1");
	}
	else if (!strcmp(name, "First Aid", true)) {
        cmd_usekit(playerid, "\1");
    }
    else if (!strcmp(name, "Cellphone", true)) {
        cmd_phone(playerid, "\1");
    }
    else if (!strcmp(name, "Portable Radio", true)) {
        SendSyntaxMessage(playerid, "Use \"/pr [text]\" to chat with your radio.");
    }
    else if (!strcmp(name, "Fuel Can", true)) {
        cmd_fill(playerid, "\1");
    }
    else if (!strcmp(name, "Repair Kit", true)) {
        cmd_repair(playerid, "\1");
    }
    else if (!strcmp(name, "NOS Canister", true)) {
        cmd_nitrous(playerid, "\1");
    }
    else if (!strcmp(name, "Spray Can", true)) {
        cmd_paint(playerid, "\1");
    }
    else if (!strcmp(name, "GPS System", true)) {
        cmd_gps(playerid, "\1");
    }
    else if (!strcmp(name, "Marijuana", true)) {
        cmd_usedrug(playerid, "marijuana");
    }
    else if (!strcmp(name, "Cocaine", true)) {
        cmd_usedrug(playerid, "cocaine");
    }
    else if (!strcmp(name, "Heroin", true)) {
        cmd_usedrug(playerid, "heroin");
    }
    else if (!strcmp(name, "Steroids", true)) {
        cmd_usedrug(playerid, "steroids");
    }
    else if (!strcmp(name, "Soda", true)) {
        cmd_drink(playerid, "soda");
    }
    else if (!strcmp(name, "Water Bottle", true)) {
        cmd_drink(playerid, "water");
    }
    else if (!strcmp(name, "Frozen Pizza", true)) {
        cmd_cook(playerid, "pizza");
    }
    else if (!strcmp(name, "Frozen Burger", true)) {
        cmd_cook(playerid, "burger");
    }
    else if (!strcmp(name, "Armored Vest", true)) {
        cmd_vest(playerid, "\1");
    }
    else if (!strcmp(name, "Ammo Cartridge", true)) {
        cmd_ammo(playerid, "\1");
    }
    else if (!strcmp(name, "Colt 45", true)) {
        EquipWeapon(playerid, "Colt 45");
    }
    else if (!strcmp(name, "Desert Eagle", true)) {
        EquipWeapon(playerid, "Desert Eagle");
    }
    else if (!strcmp(name, "Shotgun", true)) {
        EquipWeapon(playerid, "Shotgun");
    }
    else if (!strcmp(name, "Micro SMG", true)) {
        EquipWeapon(playerid, "Micro SMG");
    }
    else if (!strcmp(name, "Tec-9", true)) {
        EquipWeapon(playerid, "Tec-9");
    }
    else if (!strcmp(name, "MP5", true)) {
        EquipWeapon(playerid, "MP5");
    }
    else if (!strcmp(name, "AK-47", true)) {
        EquipWeapon(playerid, "AK-47");
    }
    else if (!strcmp(name, "Rifle", true)) {
        EquipWeapon(playerid, "Rifle");
    }
    else if (!strcmp(name, "Sniper", true)) {
        EquipWeapon(playerid, "Sniper");
    }
    else if (!strcmp(name, "Golf Club", true)) {
        EquipWeapon(playerid, "Golf Club");
    }
    else if (!strcmp(name, "Knife", true)) {
        EquipWeapon(playerid, "Knife");
    }
    else if (!strcmp(name, "Shovel", true)) {
        EquipWeapon(playerid, "Shovel");
    }
    else if (!strcmp(name, "Katana", true)) {
        EquipWeapon(playerid, "Katana");
    }
    else if (!strcmp(name, "Marijuana Seeds", true)) {
        cmd_plant(playerid, "Weed");
    }
    else if (!strcmp(name, "Cocaine Seeds", true)) {
        cmd_plant(playerid, "Cocaine");
    }
    else if (!strcmp(name, "Heroin Opium Seeds", true)) {
        cmd_plant(playerid, "Heroin");
    }
    else if (!strcmp(name, "Cooked Pizza", true))
	{
        if (PlayerData[playerid][pHunger] > 90)
            return SendErrorMessage(playerid, "You are not hungry right now.");

        if (!IsPlayerAttachedObjectSlotUsed(playerid, 4))
		{
		    SetPlayerAttachedObject(playerid, 4, 2702, 6, 0.173041, 0.049197, 0.056789, 0.000000, 274.166107, 299.057983, 1.000000, 1.000000, 1.000000);
			SetTimerEx("RemoveAttachedObject", 3000, false, "dd", playerid, 4);
		}
        PlayerData[playerid][pHunger] = (PlayerData[playerid][pHunger] + 15 > 100) ? (100) : (PlayerData[playerid][pHunger] + 15);
		Inventory_Remove(playerid, "Cooked Pizza");

		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0, 1);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes a slice of pizza and eats it.", ReturnName(playerid, 0));
    }
    else if (!strcmp(name, "Cooked Burger", true))
	{
	    if (PlayerData[playerid][pHunger] > 90)
            return SendErrorMessage(playerid, "You are not hungry right now.");

		if (!IsPlayerAttachedObjectSlotUsed(playerid, 4))
		{
		    SetPlayerAttachedObject(playerid, 4, 2703, 6, 0.078287, 0.019677, -0.001004, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
			SetTimerEx("RemoveAttachedObject", 3000, false, "dd", playerid, 4);
		}
        PlayerData[playerid][pHunger] = (PlayerData[playerid][pHunger] + 20 > 100) ? (100) : (PlayerData[playerid][pHunger] + 20);
		Inventory_Remove(playerid, "Cooked Burger");

		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.1, 0, 0, 0, 0, 0, 1);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes a cooked burger and eats it.", ReturnName(playerid, 0));
    }
    else if (!strcmp(name, "Chicken", true))
	{
	    if (PlayerData[playerid][pHunger] > 90)
            return SendErrorMessage(playerid, "You are not hungry right now.");

        PlayerData[playerid][pHunger] = (PlayerData[playerid][pHunger] + 25 > 100) ? (100) : (PlayerData[playerid][pHunger] + 25);
		Inventory_Remove(playerid, "Chicken");

		ApplyAnimation(playerid, "VENDING", "VEND_Eat_P", 4.1, 0, 0, 0, 0, 0, 1);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes a piece of chicken and eats it.", ReturnName(playerid, 0));
    }
    return 1;
}

// ====== OnPlayerWeaponShot ======
public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if ((weaponid >= 22 && weaponid <= 38) && hittype == BULLET_HIT_TYPE_OBJECT && PlayerData[playerid][pRangeBooth] != -1 && hitid == g_BoothObject[PlayerData[playerid][pRangeBooth]])
 	{
 	    static
	        string[128];

		PlayerPlaySound(playerid, 6401, 0.0, 0.0, 0.0);

		PlayerData[playerid][pTargets]++;
		DestroyObject(g_BoothObject[PlayerData[playerid][pRangeBooth]]);

		format(string, sizeof(string), "~b~Targets:~w~ %d/10", PlayerData[playerid][pTargets]);
		PlayerTextDrawSetString(playerid, PlayerData[playerid][pTextdraws][81], string);

		SetTimerEx("UpdateBooth", 3000, false, "dd", playerid, PlayerData[playerid][pRangeBooth]);
	}
	if (weaponid == 23 && PlayerData[playerid][pTazer] && GetFactionType(playerid) == FACTION_POLICE) {
	    PlayerPlaySoundEx(playerid, 6003);
	}
	if ((weaponid >= 22 && weaponid <= 38) && hittype == BULLET_HIT_TYPE_PLAYER && hitid != INVALID_PLAYER_ID)
	{
	    if (PlayerData[hitid][pRangeBooth] != -1 || PlayerData[hitid][pHospital] != -1)
	        return 0;

		if (PlayerData[hitid][pDrugUsed] == 2)
		{
		    new
				Float:damage = floatdiv(g_arrWeaponDamage[weaponid], 2),
				Float:health;

		    GetPlayerHealth(hitid, health);
		    SetPlayerHealth(hitid, floatsub(health, damage));

		    return 0;
		}
	}
	if ((22 <= weaponid <= 38) && (GetPlayerWeaponState(playerid) == WEAPONSTATE_LAST_BULLET && GetPlayerAmmo(playerid) == 1) && !IsPlayerAttachedObjectSlotUsed(playerid, 4))
 	{
  		switch (weaponid) {
 	        case 22: Inventory_Add(playerid, "Colt 45", 346);
 	        case 24: Inventory_Add(playerid, "Desert Eagle", 348);
 	        case 25: Inventory_Add(playerid, "Shotgun", 349);
 	        case 28: Inventory_Add(playerid, "Micro SMG", 352);
 	        case 29: Inventory_Add(playerid, "MP5", 353);
 	        case 30: Inventory_Add(playerid, "AK-47", 355);
 	        case 32: Inventory_Add(playerid, "Tec-9", 372);
 	        case 33: Inventory_Add(playerid, "Rifle", 357);
 	        case 34: Inventory_Add(playerid, "Sniper", 358);
		}
 	    ResetWeapon(playerid, weaponid);

 	    HoldWeapon(playerid, weaponid);
 	    SendServerMessage(playerid, "You must attach a magazine to this weapon (press 'N' to put away).");
	}
	return 1;
}

// ====== OnPlayerTakeDamage ======
public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid)
{
	if (PlayerData[playerid][pFirstAid])
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "[WARNING]:{FFFFFF} Your first aid kit is no longer in effect as you took damage.");

        PlayerData[playerid][pFirstAid] = 0;
		KillTimer(PlayerData[playerid][pAidTimer]);
	}
	return 1;
}

// ====== OnPlayerGiveDamage ======
public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid)
{
	if (damagedid != INVALID_PLAYER_ID)
	{
		PlayerData[damagedid][pLastShot] = playerid;
		PlayerData[damagedid][pShotTime] = gettime();

		if (IsBleedableWeapon(weaponid) && !PlayerData[damagedid][pBleeding] && ReturnArmour(damagedid) < 1 && PlayerData[playerid][pRangeBooth] == -1 && PlayerData[damagedid][pHospital] == -1)
		{
		    if (!PlayerHasTazer(playerid) && !PlayerHasBeanBag(playerid))
		    {
			    PlayerData[damagedid][pBleeding] = 1;
			    PlayerData[damagedid][pBleedTime] = 10;

				CreateBlood(damagedid);
			    SetTimerEx("HidePlayerBox", 500, false, "dd", damagedid, _:ShowPlayerBox(damagedid, 0xFF000066));
			}
		}
		if (PlayerData[playerid][pDrugUsed] == 4 && (weaponid >= 0 && weaponid <= 15))
		{
		    SetPlayerHealth(damagedid, ReturnHealth(damagedid) - 6);
		}
        if (GetFactionType(playerid) == FACTION_POLICE && PlayerData[playerid][pTazer] && PlayerData[damagedid][pStunned] < 1 && weaponid == 23)
        {
			if (GetPlayerState(damagedid) != PLAYER_STATE_ONFOOT)
			    return SendErrorMessage(playerid, "The player must be onfoot to be stunned.");

            if (GetPlayerDistanceFromPlayer(playerid, damagedid) > 10.0)
                return SendErrorMessage(playerid, "You must be closer to stun the player.");

            new
                string[64];

			format(string, sizeof(string), "You've been ~r~stunned~w~ by %s.", ReturnName(playerid, 0));

            PlayerData[damagedid][pStunned] = 10;
            TogglePlayerControllable(damagedid, 0);

            ApplyAnimation(damagedid, "CRACK", "crckdeth4", 4.0, 0, 0, 0, 1, 0, 1);
            ShowPlayerFooter(damagedid, string);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stunned %s with their tazer.", ReturnName(playerid, 0), ReturnName(damagedid, 0));
        }
        if (GetFactionType(playerid) == FACTION_POLICE && PlayerData[playerid][pBeanBag] && PlayerData[damagedid][pStunned] < 1 && weaponid == 25)
        {
			if (GetPlayerState(damagedid) != PLAYER_STATE_ONFOOT)
			    return SendErrorMessage(playerid, "The player must be onfoot to be stunned.");

            if (GetPlayerDistanceFromPlayer(playerid, damagedid) > 10.0)
                return SendErrorMessage(playerid, "You must be closer to shoot the player.");

            new
                string[64];

			format(string, sizeof(string), "You've been ~r~stunned~w~ by %s.", ReturnName(playerid, 0));

            PlayerData[damagedid][pStunned] = 10;
            TogglePlayerControllable(damagedid, 0);

            ApplyAnimation(damagedid, "CRACK", "crckdeth4", 4.0, 0, 0, 0, 1, 0, 1);
            ShowPlayerFooter(damagedid, string);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stunned %s with their beanbag shotgun.", ReturnName(playerid, 0), ReturnName(damagedid, 0));
        }
	}
	return 1;
}

// ====== OnPlayerDeath ======
public OnPlayerDeath(playerid, killerid, reason)
{
	if (killerid != INVALID_PLAYER_ID)
	{
	    if (1 <= reason <= 46)
			Log_Write("logs/kill_log.txt", "[%s] %s has killed %s (%s).", ReturnDate(), ReturnName(killerid), ReturnName(playerid), ReturnWeaponName(reason));

		else
			Log_Write("logs/kill_log.txt", "[%s] %s has killed %s (reason %d).", ReturnDate(), ReturnName(killerid), ReturnName(playerid), reason);

		if (reason == 50 && killerid != INVALID_PLAYER_ID)
		    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has killed %s by heli-blading.", ReturnName(killerid, 0), ReturnName(playerid, 0));

        if (reason == 29 && killerid != INVALID_PLAYER_ID && GetPlayerState(killerid) == PLAYER_STATE_DRIVER)
		    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has killed %s by driver shooting.", ReturnName(killerid, 0), ReturnName(playerid, 0));
	}
	return 1;
}

// ====== OnPlayerKeyStateChange ======
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (PlayerData[playerid][pTutorial] || PlayerData[playerid][pHospital] != -1 || !IsPlayerSpawned(playerid) || PlayerData[playerid][pCuffed] || PlayerData[playerid][pInjured])
	    return 0;

    if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED && newkeys & KEY_JUMP && !(oldkeys & KEY_JUMP))
		ApplyAnimation(playerid, "GYMNASIUM", "gym_jog_falloff", 4.0, 0, 1, 1, 0, 0, 1);

	if (newkeys & KEY_CROUCH && IsPlayerInAnyVehicle(playerid))
	{
		cmd_open(playerid, "\1");
	}
	if (newkeys & KEY_WALK && IsPlayerInRangeOfPoint(playerid, 1.5, -226.4219, 1408.4594, 26.7734) && PlayerData[playerid][pTutorialStage] == 1)
	{
	    DisablePlayerCheckpoint(playerid);

		PlayerData[playerid][pTutorialStage] = 2;
	    SendClientMessage(playerid, COLOR_SERVER, "Tekan 'N' untuk pickup item terdekat.");
	}
	if (newkeys & KEY_YES && IsPlayerSpawned(playerid))
	{
	    if (PlayerData[playerid][pJailTime] > 0)
			return SendErrorMessage(playerid, "You can't open your inventory whilst jailed.");

		if (PlayerData[playerid][pCuffed] > 0 || GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY)
		    return SendErrorMessage(playerid, "You can't open your inventory at the moment.");

		OpenInventory(playerid);
	}
	if (newkeys & KEY_SPRINT && IsPlayerSpawned(playerid) && PlayerData[playerid][pLoopAnim])
	{
	    ClearAnimations(playerid);
		HidePlayerFooter(playerid);

	    PlayerData[playerid][pLoopAnim] = false;
	}
	if (newkeys & KEY_FIRE && PlayerData[playerid][pDrinking])
	{
	    if (GetPlayerAnimationIndex(playerid) != 15 && GetPlayerAnimationIndex(playerid) != 16 && !PlayerData[playerid][pDrinkTime])
     	{
		    if (GetPlayerProgressBarValue(playerid, PlayerData[playerid][pDrinkBar]) <= 0.0)
		    {
	    	    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				DestroyPlayerProgressBar(playerid, PlayerData[playerid][pDrinkBar]);

				PlayerData[playerid][pDrinking] = 0;
				SendServerMessage(playerid, "You have finished drinking from the bottle.");
		    }
	    	else
	    	{
	    	    PlayerData[playerid][pDrinkTime] = 2;

	    	    switch (PlayerData[playerid][pDrinking])
	    	    {
					case 1: PlayerData[playerid][pThirst] = (PlayerData[playerid][pThirst] + 5 >= 100) ? (100) : (PlayerData[playerid][pThirst] + 5);
                    case 2: PlayerData[playerid][pThirst] = (PlayerData[playerid][pThirst] + 5 >= 100) ? (100) : (PlayerData[playerid][pThirst] + 5);
				}
			    SetPlayerProgressBarValue(playerid, PlayerData[playerid][pDrinkBar], GetPlayerProgressBarValue(playerid, PlayerData[playerid][pDrinkBar]) - 10.0);
			}
		}
	}
	if (newkeys & KEY_FIRE && PlayerData[playerid][pMining] && IsPlayerNearMine(playerid))
	{
	    if (PlayerData[playerid][pMineTime] > 0 || PlayerData[playerid][pMinedRock])
	        return 1;

		new id = Job_NearestPoint(playerid);

		if (id != -1)
		{
		    PlayerData[playerid][pMineTime] = 1;
		    SetTimerEx("MineTime", 400, false, "d", playerid);

		    if (PlayerData[playerid][pMineCount] < 5)
	    	{
	    	    PlayerData[playerid][pMineCount]++;

	        	ApplyAnimation(playerid, "BASEBALL", "null", 4.0, 0, 1, 1, 0, 0, 1);
            	ApplyAnimation(playerid, "BASEBALL", "BAT_4", 4.0, 0, 1, 1, 0, 0, 1);
			}
			else
			{
			    PlayerData[playerid][pMinedRock] = 1;
			    PlayerData[playerid][pMineCount] = 0;

			    RemovePlayerAttachedObject(playerid, 4);

			    ApplyAnimation(playerid, "BSKTBALL", "null", 4.0, 0, 1, 1, 0, 0, 1);
            	ApplyAnimation(playerid, "BSKTBALL", "BBALL_pickup", 4.0, 0, 1, 1, 0, 0, 1);

			    SetPlayerAttachedObject(playerid, 4, 2936, 5, 0.044377, 0.029049, 0.161334, 265.922912, 9.904896, 21.765972, 0.500000, 0.500000, 0.500000);
				SendServerMessage(playerid, "You have digged up a rock. Deliver it to the marker.");

				SetPlayerCheckpoint(playerid, JobData[id][jobDeliver][0], JobData[id][jobDeliver][1], JobData[id][jobDeliver][2], 2.5);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
			}
	    }
	}
	else if (newkeys & KEY_CTRL_BACK)
	{
	    if (PlayerData[playerid][pUsedMagazine])
	    {
	        new weaponid = PlayerData[playerid][pHoldWeapon];

	        switch (weaponid)
	        {
			    case 22:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

			        Inventory_Remove(playerid, "Colt 45");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 17);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s holds onto the weapon and cocks it.", ReturnName(playerid, 0));
				}
				case 24:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

			        Inventory_Remove(playerid, "Desert Eagle");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 7);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s holds onto the weapon and cocks it.", ReturnName(playerid, 0));
				}
				case 25:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

			        Inventory_Remove(playerid, "Shotgun");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 8);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s holds onto the weapon and pumps it.", ReturnName(playerid, 0));
				}
				case 28:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

			        Inventory_Remove(playerid, "Micro SMG");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 50);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s holds onto the weapon and cocks it.", ReturnName(playerid, 0));
				}
				case 29:
       			{
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

			        Inventory_Remove(playerid, "MP5");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 30);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s holds onto the weapon and cocks it.", ReturnName(playerid, 0));
				}
				case 32:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

			        Inventory_Remove(playerid, "Tec-9");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 50);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s holds onto the weapon and cocks it.", ReturnName(playerid, 0));
				}
				case 30:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

			        Inventory_Remove(playerid, "AK-47");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 30);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s holds onto the weapon and cocks it.", ReturnName(playerid, 0));
				}
				case 33:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

			        Inventory_Remove(playerid, "Rifle");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 5);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s holds onto the weapon and cocks it.", ReturnName(playerid, 0));
				}
		        case 34:
			    {
			        HoldWeapon(playerid, 0);
				    PlayerPlaySoundEx(playerid, 36401);

			        Inventory_Remove(playerid, "Sniper");
					PlayReloadAnimation(playerid, weaponid);

					GiveWeaponToPlayer(playerid, weaponid, 5);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s holds onto the weapon and cocks it.", ReturnName(playerid, 0));
				}
			}
			return 1;
	    }
	}
	else if (newkeys & KEY_NO && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
	    static
	        string[320];

		if (PlayerData[playerid][pTutorialStage] == 2 && IsPlayerInRangeOfPoint(playerid, 1.5, -226.4219, 1408.4594, 26.7734))
		{
		    Inventory_Add(playerid, "Demo Soda", 1543);
		    DestroyPlayerObject(playerid, PlayerData[playerid][pTutorialObject]);

            PlayerData[playerid][pTutorialStage] = 3;
 		    SendClientMessage(playerid, COLOR_SERVER, "Tekan 'Y' untuk membuka inventory dan pilih soda bottle.");
		    return 1;
		}
		if (PlayerData[playerid][pHoldWeapon] > 0)
		{
		    if (PlayerData[playerid][pUsedMagazine])
      			Inventory_Add(playerid, "Magazine", 2039);

		    HoldWeapon(playerid, 0);
		    return SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s puts away their empty weapon.", ReturnName(playerid, 0));
		}
		if (PlayerData[playerid][pLoadCrate])
		{
		    for (new i = 1; i != MAX_VEHICLES; i ++) if (IsPlayerNearBoot(playerid, i))
			{
			    if (!IsLoadableVehicle(i))
			        return SendErrorMessage(playerid, "You can't load crates into this vehicle.");

			    if (CoreVehicles[i][vehLoadType] != 0 && CoreVehicles[i][vehLoadType] != PlayerData[playerid][pLoadType])
			        return SendErrorMessage(playerid, "This vehicle is already loaded with something else.");

			    if (CoreVehicles[i][vehLoads] >= 6)
			        return SendErrorMessage(playerid, "This vehicle can only hold up to 6 crates.");

				CoreVehicles[i][vehLoads]++;
				CoreVehicles[i][vehLoadType] = PlayerData[playerid][pLoadType];

                ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0);
                SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s drops a crate into the back of the %s.", ReturnName(playerid, 0), ReturnVehicleName(i));

                if (CoreVehicles[i][vehLoads] == 6)
                {
                    DisablePlayerCheckpoint(playerid);

					if (PlayerData[playerid][pShipment] != -1)
					{
					    PlayerData[playerid][pDeliverShipment] = 1;

					    SendServerMessage(playerid, "You have loaded all the crates. Type /unload at the marker.");
					    SetPlayerCheckpoint(playerid, BusinessData[PlayerData[playerid][pShipment]][bizDeliver][0], BusinessData[PlayerData[playerid][pShipment]][bizDeliver][1], BusinessData[PlayerData[playerid][pShipment]][bizDeliver][2], 3.0);
					}
					else switch (PlayerData[playerid][pLoadType])
                    {
                    	case 1: SendServerMessage(playerid, "You have loaded all the crates. Type /unload at any retail store.");
                        case 2: SendServerMessage(playerid, "You have loaded all the crates. Type /unload at any weapon store.");
                        case 3: SendServerMessage(playerid, "You have loaded all the crates. Type /unload at any clothing store.");
                        case 4: SendServerMessage(playerid, "You have loaded all the crates. Type /unload at any fast food store.");
                        case 5: SendServerMessage(playerid, "You have loaded all the crates. Type /unload at any gas station.");
                        case 6: SendServerMessage(playerid, "You have loaded all the crates. Type /unload at any furniture store.");
					}
					PlayerData[playerid][pLoading] = 0;
					PlayerData[playerid][pLoadType] = 0;
                }
                PlayerData[playerid][pLoadCrate] = 0;

				RemovePlayerAttachedObject(playerid, 4);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

				return 1;
			}
		}
		for (new i = 0; i != MAX_BACKPACKS; i ++) if (BackpackData[i][backpackExists] && !BackpackData[i][backpackPlayer] && IsPlayerInRangeOfPoint(playerid, 2.0, BackpackData[i][backpackPos][0], BackpackData[i][backpackPos][1], BackpackData[i][backpackPos][2])) {
		    return Backpack_Items(playerid, i);
		}
        if (PlayerData[playerid][pCarryTrash])
		{
			for (new i = 1; i != MAX_VEHICLES; i ++) if (GetVehicleModel(i) == 408 && IsPlayerNearBoot(playerid, i))
			{
			    if (CoreVehicles[i][vehTrash] >= 10)
			        return SendErrorMessage(playerid, "This vehicle cannot hold anymore trash (limit: 10).");

				CoreVehicles[i][vehTrash]++;

				RemovePlayerAttachedObject(playerid, 4);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has loaded a trash bag into the Trashmaster.", ReturnName(playerid, 0));

				PlayerData[playerid][pCarryTrash] = 0;
				break;
			}
		}

		if (PlayerData[playerid][pCarryCrate] != -1)
		{
			for (new i = 1; i != MAX_VEHICLES; i ++) if (IsLoadableVehicle(i) && IsPlayerNearBoot(playerid, i))
			{
			    if (GetVehicleCrates(i) >= GetMaxCrates(i))
			        return SendErrorMessage(playerid, "This vehicle cannot hold anymore crates (limit: %d).", GetMaxCrates(i));

				CrateData[PlayerData[playerid][pCarryCrate]][crateVehicle] = i;
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

				RemovePlayerAttachedObject(playerid, 4);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has loaded a crate into the %s.", ReturnName(playerid, 0), ReturnVehicleName(i));

				PlayerData[playerid][pCarryCrate] = -1;
				ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0);
				break;
			}
		}
		else if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DUCK)
		{
		    new
				count = 0,
				id = Item_Nearest(playerid);

		    if (id != -1)
		    {
		        string = "";

		        for (new i = 0; i < MAX_DROPPED_ITEMS; i ++) if (count < MAX_LISTED_ITEMS && DroppedItems[i][droppedModel] && IsPlayerInRangeOfPoint(playerid, 1.5, DroppedItems[i][droppedPos][0], DroppedItems[i][droppedPos][1], DroppedItems[i][droppedPos][2]) && GetPlayerInterior(playerid) == DroppedItems[i][droppedInt] && GetPlayerVirtualWorld(playerid) == DroppedItems[i][droppedWorld]) {
		            NearestItems[playerid][count++] = i;

		            strcat(string, DroppedItems[i][droppedItem]);
		            strcat(string, "\n");
		        }
		        if (count == 1)
		        {
				    if (DroppedItems[id][droppedWeapon] != 0)
					{
				        if (PlayerData[playerid][pPlayingHours] < 2)
							return SendErrorMessage(playerid, "You must have at least 2 playing hours.");

    	   				GiveWeaponToPlayer(playerid, DroppedItems[id][droppedWeapon], DroppedItems[id][droppedAmmo]);

    	                Item_Delete(id);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has picked up a %s.", ReturnName(playerid, 0), ReturnWeaponName(DroppedItems[id][droppedWeapon]));
                        Log_Write("logs/droppick.txt", "[%s] %s picked up a %s.", ReturnDate(), ReturnName(playerid, 0), ReturnWeaponName(DroppedItems[id][droppedWeapon]));

					}
					else if (PickupItem(playerid, id))
					{
			    		format(string, sizeof(string), "~g~%s~w~ added to inventory!", DroppedItems[id][droppedItem]);
			    		ShowPlayerFooter(playerid, string);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has picked up a \"%s\".", ReturnName(playerid, 0), DroppedItems[id][droppedItem]);
						Log_Write("logs/droppick.txt", "[%s] %s has picked up a \"%s\".", ReturnDate(), ReturnName(playerid, 0), DroppedItems[id][droppedItem]);
					}
					else
						SendErrorMessage(playerid, "You don't have any room in your inventory.");
				}
				else Dialog_Show(playerid, PickupItems, DIALOG_STYLE_LIST, "Pickup Items", string, "Pickup", "Cancel");
			}
		}
	}
	else if (newkeys & KEY_SECONDARY_ATTACK)
	{
		static
		    id = -1;

		if ((id = Vendor_Nearest(playerid)) != -1)
		{
		    switch (VendorData[id][vendorType])
		    {
		        case 1:
		        {
					if (GetMoney(playerid) < 3)
					    return SendErrorMessage(playerid, "You must have at least 3 dollars.");

					if (PlayerData[playerid][pVendorTime] > 0)
					    return SendErrorMessage(playerid, "Please wait before purchasing from a vendor again.");

					if (Inventory_Count(playerid, "Cooked Burger") >= 5)
					    return SendErrorMessage(playerid, "You have too many burgers in your inventory already.");

					id = Inventory_Add(playerid, "Cooked Burger", 2703);

					if (id != -1)
					{
					    PlayerData[playerid][pVendorTime] = 3;

					    GiveMoney(playerid, -3);
					    ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);

					    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has purchased a burger from the vendor for $3.", ReturnName(playerid, 0));
						ShowPlayerFooter(playerid, "Your ~p~burger~w~ was added to your inventory.");
					}
				}
				case 2:
		        {
					if (GetMoney(playerid) < 2)
					    return SendErrorMessage(playerid, "You must have at least 2 dollars.");

					if (PlayerData[playerid][pVendorTime] > 0)
					    return SendErrorMessage(playerid, "Please wait before purchasing from a vendor again.");

					if (Inventory_Count(playerid, "Soda") >= 10)
					    return SendErrorMessage(playerid, "You have too many soda bottles in your inventory already.");

					id = Inventory_Add(playerid, "Soda", 1543);

					if (id != -1)
					{
                        PlayerData[playerid][pVendorTime] = 3;

					    GiveMoney(playerid, -2);
					    ApplyAnimation(playerid, "VENDING", "VEND_USE", 4.0, 0, 0, 0, 0, 0);

					    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has purchased a soda from the vendor for $2.", ReturnName(playerid, 0));
						ShowPlayerFooter(playerid, "Your ~p~soda~w~ was added to your inventory.");
					}
				}
			}
		}
		if (PlayerData[playerid][pRangeBooth] != -1)
		{
		    Booth_Leave(playerid);
		    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has left the shooting booth.", ReturnName(playerid, 0));
		}
		else for (new i = 0; i < MAX_BOOTHS; i ++) if (!g_BoothUsed[i] && IsPlayerInRangeOfPoint(playerid, 1.5, arrBoothPositions[i][0], arrBoothPositions[i][1], arrBoothPositions[i][2]))
		{
		    g_BoothUsed[i] = true;
		    PlayerData[playerid][pRangeBooth] = i;

		    UpdateWeapons(playerid);
		    ResetPlayerWeapons(playerid);

		    GivePlayerWeapon(playerid, 24, 15000);

			Booth_Refresh(playerid);
			PlayerTextDrawSetString(playerid, PlayerData[playerid][pTextdraws][81], "~b~Targets:~w~ 0/10");

			PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][81]);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has entered the shooting booth.", ReturnName(playerid, 0));
			return 1;
		}
		if (PlayerData[playerid][pTutorialStage] == 5 && IsPlayerInRangeOfPoint(playerid, 1.5, -228.8403, 1401.1831, 27.7656))
		{
		    for (new i = 0; i < 100; i ++) {
		        SendClientMessage(playerid, -1, "");
			}
		    SetDefaultSpawn(playerid);
		    Dialog_Show(playerid, TutorialConfirm, DIALOG_STYLE_MSGBOX, "Tutorial", "Apakah kamu ingin melihat main tutorial server?", "Yes", "No");
		}
		if (IsPlayerInRangeOfPoint(playerid, 2.5, -204.5334, -1735.3131, 675.7687) && PlayerData[playerid][pHospitalInt] != -1)
		{
			SetPlayerPos(playerid, arrHospitalSpawns[PlayerData[playerid][pHospitalInt]][0], arrHospitalSpawns[PlayerData[playerid][pHospitalInt]][1], arrHospitalSpawns[PlayerData[playerid][pHospitalInt]][2]);
			SetPlayerFacingAngle(playerid, arrHospitalSpawns[PlayerData[playerid][pHospitalInt]][3]);

			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);

			SetCameraBehindPlayer(playerid);
			PlayerData[playerid][pHospitalInt] = -1;
		}
		else if (IsPlayerInRangeOfPoint(playerid, 2.5, 272.2939, 1388.8876, 11.1342))
		{
		    SetPlayerPosEx(playerid, 1206.8619, -1314.3546, 797.0880);
		    SetPlayerFacingAngle(playerid, 270.0000);

		    SetPlayerInterior(playerid, 5);
		    SetPlayerVirtualWorld(playerid, PRISON_WORLD);

		    SetCameraBehindPlayer(playerid);
		}
		else if (IsPlayerInRangeOfPoint(playerid, 2.5, 1206.8619, -1314.3546, 796.7880) && GetPlayerVirtualWorld(playerid) == PRISON_WORLD && !PlayerData[playerid][pJailTime])
		{
		    if (PlayerData[playerid][pFreeze])
			{
		        TogglePlayerControllable(playerid, 1);
		        KillTimer(PlayerData[playerid][pFreezeTimer]);
			}
		    SetPlayerPos(playerid, 272.2939, 1388.8876, 11.1342);
		    SetPlayerFacingAngle(playerid, 270.0000);

		    SetPlayerInterior(playerid, 0);
		    SetPlayerVirtualWorld(playerid, 0);

		    SetCameraBehindPlayer(playerid);
		}
		else if (IsPlayerInRangeOfPoint(playerid, 2.5, 1211.1923, -1354.3439, 796.7456) && GetPlayerVirtualWorld(playerid) == PRISON_WORLD)
		{
		    if (PlayerData[playerid][pFreeze])
			{
		        TogglePlayerControllable(playerid, 1);
		        KillTimer(PlayerData[playerid][pFreezeTimer]);
			}
		    SetPlayerPos(playerid, 201.8927, 1437.1788, 10.5950);
		    SetPlayerFacingAngle(playerid, 180.0000);

		    SetPlayerInterior(playerid, 0);
		    SetPlayerVirtualWorld(playerid, 0);

		    SetCameraBehindPlayer(playerid);
		}
		else if (IsPlayerInRangeOfPoint(playerid, 2.5, 201.8927, 1437.1788, 10.5950))
		{
		    SetPlayerPosEx(playerid, 1211.1923, -1354.3439, 797.0456);
		    SetPlayerFacingAngle(playerid, 0.0000);

		    SetPlayerInterior(playerid, 5);
		    SetPlayerVirtualWorld(playerid, PRISON_WORLD);

		    SetCameraBehindPlayer(playerid);
		}
		for (new i = 0; i < sizeof(arrHospitalSpawns); i ++) if (IsPlayerInRangeOfPoint(playerid, 3.0, arrHospitalSpawns[i][0], arrHospitalSpawns[i][1], arrHospitalSpawns[i][2]))
		{
			SetPlayerPos(playerid, -204.5648, -1736.1201, 675.7687);
			SetPlayerFacingAngle(playerid, 180.0000);

			SetPlayerInterior(playerid, 3);
			SetPlayerVirtualWorld(playerid, i + 5000);

			SetCameraBehindPlayer(playerid);
			PlayerData[playerid][pHospitalInt] = i;

		    return 1;
	    }
	    if ((id = Gate_Nearest(playerid)) != -1)
		{
		    cmd_open(playerid, "\1");
		}
	    if ((id = House_Nearest(playerid)) != -1)
	    {
	        if (HouseData[id][houseLocked])
	            return SendErrorMessage(playerid, "You cannot enter a locked house.");

			SetPlayerPos(playerid, HouseData[id][houseInt][0], HouseData[id][houseInt][1], HouseData[id][houseInt][2]);
			SetPlayerFacingAngle(playerid, HouseData[id][houseInt][3]);

			SetPlayerInterior(playerid, HouseData[id][houseInterior]);
			SetPlayerVirtualWorld(playerid, HouseData[id][houseID] + 5000);

			SetCameraBehindPlayer(playerid);
			PlayerData[playerid][pHouse] = HouseData[id][houseID];
			return 1;
		}
		if ((id = House_Inside(playerid)) != -1 && IsPlayerInRangeOfPoint(playerid, 2.5, HouseData[id][houseInt][0], HouseData[id][houseInt][1], HouseData[id][houseInt][2]))
	    {
			SetPlayerPos(playerid, HouseData[id][housePos][0], HouseData[id][housePos][1], HouseData[id][housePos][2]);
			SetPlayerFacingAngle(playerid, HouseData[id][housePos][3] - 180.0);

			SetPlayerInterior(playerid, HouseData[id][houseExterior]);
			SetPlayerVirtualWorld(playerid, HouseData[id][houseExteriorVW]);

			SetCameraBehindPlayer(playerid);
			PlayerData[playerid][pHouse] = -1;
			return 1;
		}
        if ((id = Business_Nearest(playerid)) != -1)
	    {
	        if (BusinessData[id][bizLocked])
	            return SendErrorMessage(playerid, "This business is closed by the owner.");

			if (PlayerData[playerid][pTask] && !PlayerData[playerid][pStoreTask])
			{
			    PlayerData[playerid][pStoreTask] = 1;
			    Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_MSGBOX, "Retail Store", "This business is a Retail Store. You can purchase many items here using the /buy command.\nThere are many useful things that you can purchase here, which are added to your inventory.\n\nThe most useful item is the GPS System, as this device allows you to find what you need.\nYou can leave this business at any time by pressing the 'F' key at the door.", "Close", "");

			    if (IsTaskCompleted(playerid))
				{
    				PlayerData[playerid][pTask] = 0;
					ShowPlayerFooter(playerid, "You have ~g~completed~w~ all your tasks!");
				}
			}
			SetPlayerPos(playerid, BusinessData[id][bizInt][0], BusinessData[id][bizInt][1], BusinessData[id][bizInt][2]);
			SetPlayerFacingAngle(playerid, BusinessData[id][bizInt][3]);

			SetPlayerInterior(playerid, BusinessData[id][bizInterior]);
			SetPlayerVirtualWorld(playerid, BusinessData[id][bizID] + 6000);

			SetCameraBehindPlayer(playerid);
			PlayerData[playerid][pBusiness] = BusinessData[id][bizID];

			if (strlen(BusinessData[id][bizMessage]) && strcmp(BusinessData[id][bizMessage], "NULL", true)) {
			    SendClientMessage(playerid, COLOR_DARKBLUE, BusinessData[id][bizMessage]);
			}
			return 1;
		}
		if ((id = Business_Inside(playerid)) != -1 && IsPlayerInRangeOfPoint(playerid, 2.5, BusinessData[id][bizInt][0], BusinessData[id][bizInt][1], BusinessData[id][bizInt][2]))
	    {
			SetPlayerPos(playerid, BusinessData[id][bizPos][0], BusinessData[id][bizPos][1], BusinessData[id][bizPos][2]);
			SetPlayerFacingAngle(playerid, BusinessData[id][bizPos][3] - 180.0);

			SetPlayerInterior(playerid, BusinessData[id][bizExterior]);
			SetPlayerVirtualWorld(playerid, BusinessData[id][bizExteriorVW]);

			SetCameraBehindPlayer(playerid);
			PlayerData[playerid][pBusiness] = -1;
			return 1;
		}
		if ((id = Entrance_Nearest(playerid)) != -1)
	    {
	        if (EntranceData[id][entranceLocked])
	            return SendErrorMessage(playerid, "This entrance is locked at the moment.");

            if (PlayerData[playerid][pTask])
			{
				if (EntranceData[id][entranceType] == 2 && !PlayerData[playerid][pBankTask])
				{
			    	PlayerData[playerid][pBankTask] = 1;
			    	Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_MSGBOX, "Banking", "This is one of the banks of San Andreas. You can manage your bank accounts here.\nEach player has a standard bank account and a savings account for extra funds.\n\nYou can type /bank inside this building to manage either of your bank accounts.\nIf you are near any ATM machine, you can use the /atm command for your banking needs.", "Close", "");

				    if (IsTaskCompleted(playerid))
					{
				        PlayerData[playerid][pTask] = 0;
						ShowPlayerFooter(playerid, "You have ~g~completed~w~ all your tasks!");
					}
				}
				else if (EntranceData[id][entranceType] == 1 && !PlayerData[playerid][pTestTask])
				{
			    	PlayerData[playerid][pTestTask] = 1;
			    	Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_MSGBOX, "DMV", "The DMV is where a player can attempt the driving test to obtain their license.\nYou must avoid hitting obstacles, damaging the vehicle or speeding during the test.\n\nIt is legally required to possess a driving license to drive in San Andreas.\nDriving without a license can result in several consequences by law enforcement.", "Close", "");

				    if (IsTaskCompleted(playerid))
					{
				        PlayerData[playerid][pTask] = 0;
						ShowPlayerFooter(playerid, "You have ~g~completed~w~ all your tasks!");
					}
				}
			}
			if (EntranceData[id][entranceCustom])
				SetPlayerPosEx(playerid, EntranceData[id][entranceInt][0], EntranceData[id][entranceInt][1], EntranceData[id][entranceInt][2]);

			else
			    SetPlayerPos(playerid, EntranceData[id][entranceInt][0], EntranceData[id][entranceInt][1], EntranceData[id][entranceInt][2]);

			SetPlayerFacingAngle(playerid, EntranceData[id][entranceInt][3]);

			SetPlayerInterior(playerid, EntranceData[id][entranceInterior]);
			SetPlayerVirtualWorld(playerid, EntranceData[id][entranceWorld]);

			SetCameraBehindPlayer(playerid);
			PlayerData[playerid][pEntrance] = EntranceData[id][entranceID];
			return 1;
		}
		if ((id = Entrance_Inside(playerid)) != -1 && IsPlayerInRangeOfPoint(playerid, 2.5, EntranceData[id][entranceInt][0], EntranceData[id][entranceInt][1], EntranceData[id][entranceInt][2]))
	    {
	        if (EntranceData[id][entranceCustom])
				SetPlayerPosEx(playerid, EntranceData[id][entrancePos][0], EntranceData[id][entrancePos][1], EntranceData[id][entrancePos][2]);

			else
			    SetPlayerPosEx(playerid, EntranceData[id][entrancePos][0], EntranceData[id][entrancePos][1], EntranceData[id][entrancePos][2]);

			SetPlayerFacingAngle(playerid, EntranceData[id][entrancePos][3] - 180.0);

			SetPlayerInterior(playerid, EntranceData[id][entranceExterior]);
			SetPlayerVirtualWorld(playerid, EntranceData[id][entranceExteriorVW]);

			SetCameraBehindPlayer(playerid);
			PlayerData[playerid][pEntrance] = Entrance_GetLink(playerid);
			return 1;
		}
		if ((id = Crate_Nearest(playerid)) != -1 && PlayerData[playerid][pCarryCrate] == -1 && !IsCrateInUse(id))
		{
		    // If the crate is within a stack, this function below
		    // will get the highest crate on the stack.

		    if ((id = Crate_Highest(id)) == -1)
		        id = Crate_Nearest(playerid);

		    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);

            PlayerData[playerid][pCarryCrate] = id;
            SetPlayerAttachedObject(playerid, 4, 964, 1, -0.157020, 0.413313, 0.000000, 0.000000, 88.000000, 180.000000, 0.500000, 0.500000, 0.500000);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches down and picks up a crate.", ReturnName(playerid, 0));
			SendServerMessage(playerid, "You have picked up a crate. Load it in a vehicle using 'N'.");

			DestroyDynamicObject(CrateData[id][crateObject]);
			DestroyDynamic3DTextLabel(CrateData[id][crateText3D]);

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
			CrateData[id][crateObject] = INVALID_OBJECT_ID;
			return 1;
		}
		if (PlayerData[playerid][pCarryCrate] != -1 && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY && !PlayerData[playerid][pCrafting])
		{
		    ApplyAnimation(playerid, "CARRY", "null", 4.0, 0, 0, 0, 0, 0);
		    ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0);

			Crate_Drop(playerid, 1.5);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has dropped the crate.", ReturnName(playerid, 0));

			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			return 1;
		}
	}
	return 1;
}

forward PutInsideVehicle(playerid, vehicleid);

// ====== PutInsideVehicle ======
public PutInsideVehicle(playerid, vehicleid)
{
	if (!PlayerData[playerid][pDrivingTest])
	    return 0;

	RemoveFromVehicle(vehicleid);
    PutPlayerInVehicle(playerid, vehicleid, 0);
    return 1;
}

// ====== OnPlayerExitVehicle ======
public OnPlayerExitVehicle(playerid, vehicleid)
{
    if (IsPlayerNPC(playerid))
	    return 1;

	if (PlayerData[playerid][pTaxiDuty])
	{
        foreach (new i : Player) if (PlayerData[i][pTaxiPlayer] == playerid && IsPlayerInVehicle(i, GetPlayerVehicleID(playerid))) {
	        LeaveTaxi(i, playerid);
	    }
	    SetPlayerColor(playerid, DEFAULT_COLOR);

        PlayerData[playerid][pTaxiDuty] = false;
        SendServerMessage(playerid, "You are no longer on taxi duty!");
	}
    if (PlayerData[playerid][pDrivingTest])
	{
	    SetTimerEx("PutInsideVehicle", 500, false, "dd", playerid, vehicleid);
		Dialog_Show(playerid, LeaveTest, DIALOG_STYLE_MSGBOX, "Confirm Test Leave", "Warning: Are you sure you want to exit the driving test?", "Yes", "No");
	}
	if (PlayerData[playerid][pJob] == JOB_UNLOADER && GetVehicleModel(vehicleid) == 530)
	{
	    CoreVehicles[vehicleid][vehLoadType] = 0;
		DestroyObject(CoreVehicles[vehicleid][vehCrate]);

		CoreVehicles[vehicleid][vehCrate] = INVALID_OBJECT_ID;
		DisablePlayerCheckpoint(playerid);
	}
	return 1;
}

// ====== OnPlayerEnterVehicle ======
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    if (IsPlayerNPC(playerid))
	    return 1;

	if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED || GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY || PlayerData[playerid][pInjured] || PlayerData[playerid][pFirstAid]) {
	    ClearAnimations(playerid);

	    return 0;
	}
	new id = Car_GetID(vehicleid);

	if (!ispassenger && id != -1 && CarData[id][carFaction] > 0 && GetFactionType(playerid) != CarData[id][carFaction]) {
	    ClearAnimations(playerid);

	    return SendErrorMessage(playerid, "You don't have the keys to this vehicle.");
	}
	return 1;
}

// ====== OnPlayerEnterCheckpoint ======
public OnPlayerEnterCheckpoint(playerid)
{
	if (PlayerData[playerid][pTutorialStage])
	{
	    DisablePlayerCheckpoint(playerid);
		return 1;
	}
	if(TruckingCheck[playerid] >= 1 && PlayerData[playerid][pUnloading] == -1)
	{
	    if (!IsPlayerInAnyVehicle(playerid))
		{
		    SendErrorMessage(playerid, "You're not in a vehicle");
		    return 1;
		}
		new vehicleid = GetPlayerVehicleID(playerid);
		if (!IsLoadableVehicle(vehicleid))
  		{
  			SendErrorMessage(playerid, "You're not in a delivery vehicle.");
  		}
	    new string[180];
        format(string, sizeof(string), "You have earned $%d from the courier mission!", TruckingCheck[playerid]);
        GiveMoney(playerid, TruckingCheck[playerid]);
        TruckingCheck[playerid] = 0;
		SendClientMessageEx(playerid, COLOR_LIGHTYELLOW, string);
		DisablePlayerCheckpoint(playerid);
		RespawnVehicle(vehicleid);
	}
	if (PlayerData[playerid][pCP])
	{
	    DisablePlayerCheckpoint(playerid);
	    PlayerData[playerid][pCP] = 0;
	}
	if (PlayerData[playerid][pTask])
	{
	    new id = -1;

		if ((id = Entrance_Nearest(playerid)) != -1 && EntranceData[id][entranceType] == 2 && !PlayerData[playerid][pBankTask])
		    ShowPlayerFooter(playerid, "Press ~y~'F'~w~ to enter this bank.");

        if ((id = Business_Nearest(playerid)) != -1 && BusinessData[id][bizType] == 1 && !PlayerData[playerid][pStoreTask])
		    ShowPlayerFooter(playerid, "Press ~y~'F'~w~ to enter this retail store.");

        if ((id = Entrance_Nearest(playerid)) != -1 && EntranceData[id][entranceType] == 1 && !PlayerData[playerid][pTestTask])
		    ShowPlayerFooter(playerid, "Press ~y~'F'~w~ to enter this DMV.");

		DisablePlayerCheckpoint(playerid);
	}
	if (PlayerData[playerid][pDrivingTest])
	{
	    PlayerData[playerid][pTestStage]++;

	    if (PlayerData[playerid][pTestStage] < sizeof(g_arrDrivingCheckpoints)) {
			SetPlayerCheckpoint(playerid, g_arrDrivingCheckpoints[PlayerData[playerid][pTestStage]][0], g_arrDrivingCheckpoints[PlayerData[playerid][pTestStage]][1], g_arrDrivingCheckpoints[PlayerData[playerid][pTestStage]][2], 3.0);
		}
		else
		{
		    static
		        Float:health;

		    GetVehicleHealth(GetPlayerVehicleID(playerid), health);

		    if (health < 950.0)
				SendErrorMessage(playerid, "You have failed the driving test - the vehicle was damaged!");

		    else
			{
		        GiveMoney(playerid, -50);
		        ShowPlayerFooter(playerid, "You've been charged ~r~$50~w~ for the test.");

		        Inventory_Add(playerid, "Driving License", 1581);
		        SendServerMessage(playerid, "You have passed the driving test and received your license.");
		    }
  			CancelDrivingTest(playerid);
		}
	}
	else
	{
	    new
			vehicleid = GetPlayerVehicleID(playerid),
			Float:health;

		if (PlayerData[playerid][pWaypoint])
		{
		    PlayerData[playerid][pWaypoint] = 0;

		    DisablePlayerCheckpoint(playerid);
		    PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][69]);
		}
		else if (PlayerData[playerid][pJob] == JOB_COURIER && !IsPlayerInAnyVehicle(playerid))
		{
			if (PlayerData[playerid][pLoading] && !PlayerData[playerid][pLoadCrate] && Job_NearestPoint(playerid) != -1)
			{
			    PlayerData[playerid][pLoadCrate] = 1;

		        SetPlayerAttachedObject(playerid, 4, 3014, 1, 0.038192, 0.371544, 0.055191, 0.000000, 90.000000, 357.668670, 1.000000, 1.000000, 1.000000);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);

				ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
				ShowPlayerFooter(playerid, "Press ~y~'N'~w~ near a truck to load the crate.");
			}
			else if (PlayerData[playerid][pUnloading] != -1)
			{
				if (!PlayerData[playerid][pLoadCrate])
				{
				    PlayerData[playerid][pLoadCrate] = 1;
				    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);

			        SetPlayerAttachedObject(playerid, 4, 3014, 1, 0.038192, 0.371544, 0.055191, 0.000000, 90.000000, 357.668670, 1.000000, 1.000000, 1.000000);
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);

					SetPlayerCheckpoint(playerid, BusinessData[PlayerData[playerid][pUnloading]][bizPos][0], BusinessData[PlayerData[playerid][pUnloading]][bizPos][1], BusinessData[PlayerData[playerid][pUnloading]][bizPos][2], 1.0);
					ShowPlayerFooter(playerid, "Deliver the crate to the ~r~checkpoint.");

					CoreVehicles[PlayerData[playerid][pUnloadVehicle]][vehLoads]--;
				}
				else
				{
				    static
				        Float:fX,
				        Float:fY,
				        Float:fZ,
						string[64];

				    PlayerData[playerid][pLoadCrate] = 0;
				    ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 0, 0, 0, 0, 1);

				    RemovePlayerAttachedObject(playerid, 4);
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

					switch (CoreVehicles[PlayerData[playerid][pUnloadVehicle]][vehLoadType])
					{
					    case 1:
						{
							TruckingCheck[playerid] += 35;
					        //GiveMoney(playerid, 35);
					        ShowPlayerFooter(playerid, "~g~$35~w~ has been added to your check.");
					    }
					    case 2:
						{
						    TruckingCheck[playerid] += 40;
					        //GiveMoney(playerid, 40);
					        ShowPlayerFooter(playerid, "~g~$40~w~ has been added to your check.");
					    }
					    case 3:
						{
						    TruckingCheck[playerid] += 30;
					        //GiveMoney(playerid, 30);
					        ShowPlayerFooter(playerid, "~g~$30~w~ has been added to your check.");
					    }
					    case 4:
						{
						    TruckingCheck[playerid] += 35;
					        //GiveMoney(playerid, 35);
					        ShowPlayerFooter(playerid, "~g~$35~w~ has been added to your check.");
					    }
					    case 5:
						{
						    TruckingCheck[playerid] += 40;
					        //GiveMoney(playerid, 40);
					        ShowPlayerFooter(playerid, "~g~$40~w~ has been added to your check.");
					    }
					    case 6:
						{
						    TruckingCheck[playerid] += 35;
					        //GiveMoney(playerid, 35);
					        ShowPlayerFooter(playerid, "~g~$35~w~ has been added to your check.");
					    }
					}
					if (CoreVehicles[PlayerData[playerid][pUnloadVehicle]][vehLoadType] == 5)
					{
						for (new i = 0; i < MAX_GAS_PUMPS; i ++) if (PumpData[i][pumpExists] && PumpData[i][pumpBusiness] == PlayerData[playerid][pUnloading]) {
						    PumpData[i][pumpFuel] += 100;

			                format(string, sizeof(string), "[Gas Pump: %d]\n{FFFFFF}Fuel Left: %d liters", i, PumpData[i][pumpFuel]);
						    UpdateDynamic3DTextLabelText(PumpData[i][pumpText3D], COLOR_DARKBLUE, string);

						    Pump_Save(i);
						}
					}
					else
					{
						BusinessData[PlayerData[playerid][pUnloading]][bizProducts] += 20;
						Business_Save(PlayerData[playerid][pUnloading]);
					}
					if (CoreVehicles[PlayerData[playerid][pUnloadVehicle]][vehLoads] > 0)
					{
					    GetVehicleBoot(PlayerData[playerid][pUnloadVehicle], fX, fY, fZ);
					    SetPlayerCheckpoint(playerid, fX, fY, fZ, 1.0);
					}
					else
					{
					    CoreVehicles[PlayerData[playerid][pUnloadVehicle]][vehLoads] = 0;
					    CoreVehicles[PlayerData[playerid][pUnloadVehicle]][vehLoadType] = 0;

				     	PlayerData[playerid][pUnloading] = -1;
					    PlayerData[playerid][pUnloadVehicle] = INVALID_VEHICLE_ID;

						DisablePlayerCheckpoint(playerid);
					    SendServerMessage(playerid, "You have delivered all the crates from the vehicle.");
					    SendServerMessage(playerid, "Deliver your truck to the checkpoint to get paid.");
					    SetPlayerCheckpoint(playerid, 2521.0376, -2090.3279, 13.4125, 5.0);

					    if (PlayerData[playerid][pShipment] != -1)
					    {
					        foreach (new i : Player) if (Business_IsOwner(i, PlayerData[playerid][pShipment])) {
					            SendServerMessage(playerid, "%s has delivered your shipment to %s.", ReturnName(playerid, 0), BusinessData[PlayerData[playerid][pShipment]][bizName]);
							}
							BusinessData[PlayerData[playerid][pShipment]][bizShipment] = 0;
							Business_Save(PlayerData[playerid][pShipment]);

          					PlayerData[playerid][pShipment] = -1;
          					PlayerData[playerid][pDeliverShipment] = 0;
					    }
					}
				}
			}
		}
		else if (PlayerData[playerid][pJob] == JOB_MINER && PlayerData[playerid][pMinedRock] && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY)
		{
		    new money = random(20) + 5;

			SendServerMessage(playerid, "You have earned $%d for the rock.", money);
			GiveMoney(playerid, money);

			PlayerData[playerid][pMinedRock] = 0;
			PlayerData[playerid][pMineCount] = 0;

			DisablePlayerCheckpoint(playerid);
			RemovePlayerAttachedObject(playerid, 4);

			SetPlayerAttachedObject(playerid, 4, 18634, 6, 0.156547, 0.039423, 0.026570, 198.109115, 6.364907, 262.997558, 1.000000, 1.000000, 1.000000);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		}
	    else if (PlayerData[playerid][pJob] == JOB_UNLOADER && IsPlayerInWarehouse(playerid) && GetVehicleModel(vehicleid) == 530 && CoreVehicles[vehicleid][vehLoadType] == 7)
	    {
	        GetVehicleHealth(vehicleid, health);

	        CoreVehicles[vehicleid][vehLoadType] = 0;
	        DestroyObject(CoreVehicles[vehicleid][vehCrate]);

			CoreVehicles[vehicleid][vehCrate] = INVALID_OBJECT_ID;
			DisablePlayerCheckpoint(playerid);

			if (health < CoreVehicles[vehicleid][vehLoadHealth]) {
			    SendErrorMessage(playerid, "You have damaged the crate during the process.");
			}
			else {
				SendServerMessage(playerid, "You have unloaded a crate for $20.");
				GiveMoney(playerid, 20);
			}
		}
		else if (PlayerData[playerid][pJob] == JOB_SORTER && PlayerData[playerid][pSorting] != -1)
		{
		    if (PlayerData[playerid][pSortCrate])
		    {
		        PlayerData[playerid][pSortCrate] = 0;

		        RemovePlayerAttachedObject(playerid, 4);
		        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

		        ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 0, 0, 0, 0, 1);
		        SetPlayerCheckpoint(playerid, JobData[PlayerData[playerid][pSorting]][jobPoint][0], JobData[PlayerData[playerid][pSorting]][jobPoint][1], JobData[PlayerData[playerid][pSorting]][jobPoint][2], 1.0);

				GiveMoney(playerid, 10);
				ShowPlayerFooter(playerid, "You have earned ~g~$10~w~ for the package.");
			}
			else
			{
                SetPlayerAttachedObject(playerid, 4, 1220, 5, 0.137832, 0.176979, 0.151424, 96.305931, 185.363006, 20.328088, 0.699999, 0.800000, 0.699999);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);

				ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
				SetPlayerCheckpoint(playerid, JobData[PlayerData[playerid][pSorting]][jobDeliver][0], JobData[PlayerData[playerid][pSorting]][jobDeliver][1], JobData[PlayerData[playerid][pSorting]][jobDeliver][2], 1.0);

                PlayerData[playerid][pSortCrate] = 1;
				ShowPlayerFooter(playerid, "Deliver the package to the ~r~marker.");
			}
		}
	}
	return 1;
}

// ====== OnPlayerStateChange ======
public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if (IsPlayerNPC(playerid))
	    return 1;

	new vehicleid = GetPlayerVehicleID(playerid);

	if (newstate == PLAYER_STATE_WASTED && PlayerData[playerid][pJailTime] < 1)
	{
	    for (new i = 34; i < 39; i ++) {
			PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);
	    }
	    PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][82]);

	    ShowHungerTextdraw(playerid, 0);
	    PlayerData[playerid][pHealth] = 100.0;

	    ResetWeapons(playerid);
	    ResetPlayer(playerid);

	    PlayerData[playerid][pKilled] = 1;

	    if (!PlayerData[playerid][pInjured])
		{
	        PlayerData[playerid][pInjured] = 1;

	        PlayerData[playerid][pInterior] = GetPlayerInterior(playerid);
	    	PlayerData[playerid][pWorld] = GetPlayerVirtualWorld(playerid);

	    	GetPlayerPos(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]);
	    	GetPlayerFacingAngle(playerid, PlayerData[playerid][pPos][3]);
		}
		else
		{
		    TextDrawHideForPlayer(playerid, gServerTextdraws[2]);

			PlayerData[playerid][pInjured] = 0;
			PlayerData[playerid][pHospital] = GetClosestHospital(playerid);
		}
		if (PlayerData[playerid][pCallLine] != INVALID_PLAYER_ID)
		{
		    SendClientMessage(PlayerData[playerid][pCallLine], COLOR_YELLOW, "[PHONE]:{FFFFFF} The line went dead...");
		    CancelCall(playerid);
		}
		if (PlayerData[playerid][pCarryCrate] != -1)
		{
			Crate_Drop(playerid);
		}
	}
	else if (oldstate == PLAYER_STATE_DRIVER)
	{
	    if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY || GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED)
	        return RemoveFromVehicle(playerid);

	    for (new i = 34; i < 39; i ++)
			PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][i]);

		PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][82]);
	}
	else if (newstate == PLAYER_STATE_DRIVER)
	{
	    new id = Car_GetID(vehicleid);

		if (id != -1 && CarData[id][carFaction] > 0 && GetFactionType(playerid) != CarData[id][carFaction]) {
		    RemovePlayerFromVehicle(playerid);

	    	return SendErrorMessage(playerid, "You don't have the keys to this vehicle.");
		}
		if (PlayerData[playerid][pJob] == JOB_GARBAGE && GetVehicleModel(vehicleid) == 408 && CoreVehicles[vehicleid][vehTrash] > 0)
		{
		    new pointid = -1;

		    if ((pointid = GetClosestJobPoint(playerid, 7)) != -1)
		    {
			    PlayerData[playerid][pCP] = 1;
			    SetPlayerCheckpoint(playerid, JobData[pointid][jobPoint][0], JobData[pointid][jobPoint][1], JobData[pointid][jobPoint][2], 2.5);

		    	SendServerMessage(playerid, "This vehicle is loaded with %d trash bags (marker set to dump).", CoreVehicles[vehicleid][vehTrash]);
		    }
		}
		if (PlayerData[playerid][pJob] == JOB_COURIER && IsLoadableVehicle(vehicleid) && CoreVehicles[vehicleid][vehLoads] > 0)
		{
		    if (PlayerData[playerid][pLoading])
		    {
				DisablePlayerCheckpoint(playerid);
				PlayerData[playerid][pLoading] = 0;
			}
			static
			    string[64];

		    switch (CoreVehicles[vehicleid][vehLoadType])
			{
				case 1: format(string, sizeof(string), "~b~Loaded:~w~ Retail Supplies~n~~b~Loaded Crates:~w~ %d/6", CoreVehicles[vehicleid][vehLoads]);
		        case 2: format(string, sizeof(string), "~b~Loaded:~w~ Ammunition~n~~b~Loaded Crates:~w~ %d/6", CoreVehicles[vehicleid][vehLoads]);
                case 3: format(string, sizeof(string), "~b~Loaded:~w~ Clothing~n~~b~Loaded Crates:~w~ %d/6", CoreVehicles[vehicleid][vehLoads]);
                case 4: format(string, sizeof(string), "~b~Loaded:~w~ Food Supplies~n~~b~Loaded Crates:~w~ %d/6", CoreVehicles[vehicleid][vehLoads]);
                case 5: format(string, sizeof(string), "~b~Loaded:~w~ Gasoline~n~~b~Loaded Crates:~w~ %d/6", CoreVehicles[vehicleid][vehLoads]);
                case 6: format(string, sizeof(string), "~b~Loaded:~w~ Furniture~n~~b~Loaded Crates:~w~ %d/6", CoreVehicles[vehicleid][vehLoads]);
			}
		    PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][82]);
		    PlayerTextDrawSetString(playerid, PlayerData[playerid][pTextdraws][82], string);
		}
	    if (IsVehicleImpounded(vehicleid))
	    {
	        RemovePlayerFromVehicle(playerid);
	        SendErrorMessage(playerid, "This vehicle is impounded and you can't use it.");
	    }
		else if (!IsEngineVehicle(vehicleid))
		{
			SetEngineStatus(vehicleid, true);
		}
		else
		{
			if (!GetEngineStatus(vehicleid))
			{
			    if (CoreVehicles[vehicleid][vehFuel] < 1)
	    			ShowPlayerFooter(playerid, "There is no ~r~fuel~w~ in this vehicle.");

				else if (ReturnVehicleHealth(vehicleid) <= 300)
	    			ShowPlayerFooter(playerid, "This vehicle is ~r~totalled~w~ and needs repairing.");

  				else ShowPlayerFooter(playerid, "Type ~r~/engine~w~ to start the engine.");
			}
			if (IsDoorVehicle(vehicleid) && !Inventory_HasItem(playerid, "Driving License") && !PlayerData[playerid][pDrivingTest])
			{
   				SendClientMessage(playerid, COLOR_LIGHTRED, "[WARNING]:{FFFFFF} You are operating a vehicle without a driving license.");
			}
		}
	    if (IsSpeedoVehicle(vehicleid) && !PlayerData[playerid][pDisableSpeedo]) for (new i = 34; i < 39; i ++) {
			PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][i]);
		}
		SetPlayerArmedWeapon(playerid, 0);
	}
	if ((oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER) && PlayerData[playerid][pPlayRadio])
	{
	    PlayerData[playerid][pPlayRadio] = 0;
	    StopAudioStreamForPlayer(playerid);
	}
	if (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
	{
	    if (PlayerData[playerid][pBoombox] != INVALID_PLAYER_ID)
	    {
	        PlayerData[playerid][pBoombox] = INVALID_PLAYER_ID;
			StopAudioStreamForPlayer(playerid);
	    }
	    if (IsEngineVehicle(vehicleid) && CoreVehicles[vehicleid][vehRadio])
	    {
	        static
	            url[128];

			strunpack(url, CoreVehicles[vehicleid][vehURL]);

			StopAudioStreamForPlayer(playerid);
			PlayAudioStreamForPlayer(playerid, url);

			PlayerData[playerid][pPlayRadio] = 1;
		}
	    foreach (new i : Player) if (PlayerData[i][pSpectator] == playerid) {
     		PlayerSpectateVehicle(i, GetPlayerVehicleID(playerid));
		}
		if (PlayerData[playerid][pInjured] == 1)
		{
		    RemoveFromVehicle(playerid);
		}
	}
	if (newstate == PLAYER_STATE_PASSENGER)
	{
	    switch (GetPlayerWeapon(playerid))
	    {
	        case 22, 25, 28..33:
	    		SetPlayerArmedWeapon(playerid, GetPlayerWeapon(playerid));

			default:
				SetPlayerArmedWeapon(playerid, 0);
		}
	}
	else if (oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER)
	{
	    foreach (new i : Player) if (PlayerData[i][pSpectator] == playerid) {
     		PlayerSpectatePlayer(i, playerid);
		}
	}
	if (newstate == PLAYER_STATE_PASSENGER && IsPlayerInsideTaxi(playerid))
	{
	    new driverid = GetVehicleDriver(GetPlayerVehicleID(playerid));

	    PlayerData[playerid][pTaxiFee] = 5;
	    PlayerData[playerid][pTaxiTime] = 0;
	    PlayerData[playerid][pTaxiPlayer] = driverid;

	    SendServerMessage(driverid, "%s has entered your taxi as a passenger.", ReturnName(playerid, 0));
		SendServerMessage(playerid, "You have entered %s's taxi.", ReturnName(driverid, 0));
	}
 	if (oldstate == PLAYER_STATE_PASSENGER && PlayerData[playerid][pTaxiTime] != 0 && PlayerData[playerid][pTaxiPlayer] != INVALID_PLAYER_ID)
	{
	    LeaveTaxi(playerid, PlayerData[playerid][pTaxiPlayer]);
	}
	return 1;
}

// ====== OnPlayerUpdate ======
public OnPlayerUpdate(playerid)
{
	static str[64], id = -1, keys[3], vehicleid;

	if (PlayerData[playerid][pKicked])
		return 0;

	if (GetPlayerWeapon(playerid) > 1 && (PlayerData[playerid][pHoldWeapon] > 0 || PlayerData[playerid][pMining] > 0))
	    SetPlayerArmedWeapon(playerid, 0);

	if (IsPlayerInAnyVehicle(playerid))
		vehicleid = GetPlayerVehicleID(playerid);
	else
	    vehicleid = INVALID_VEHICLE_ID;

	GetPlayerKeys(playerid, keys[0], keys[1], keys[2]);

	if (GetPlayerWeapon(playerid) != PlayerData[playerid][pWeapon])
	{
	    PlayerData[playerid][pWeapon] = GetPlayerWeapon(playerid);

		if (PlayerData[playerid][pWeapon] >= 1 && PlayerData[playerid][pWeapon] <= 45 && PlayerData[playerid][pWeapon] != 40 && PlayerData[playerid][pWeapon] != 2 && PlayerData[playerid][pGuns][g_aWeaponSlots[PlayerData[playerid][pWeapon]]] != GetPlayerWeapon(playerid) && !PlayerHasTazer(playerid) && !PlayerHasBeanBag(playerid) && PlayerData[playerid][pRangeBooth] == -1 && PlayerData[playerid][pCharacter] > 0)
		{
		    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has been banned for weapon hacks (%s).", ReturnName(playerid, 0), ReturnWeaponName(PlayerData[playerid][pWeapon]));
			Log_Write("logs/cheat_log.txt", "[%s] %s was banned for weapon hacks (%s).", ReturnDate(), ReturnName(playerid), ReturnWeaponName(PlayerData[playerid][pWeapon]));

			Blacklist_Add(PlayerData[playerid][pIP], PlayerData[playerid][pUsername], "Anticheat", "Weapon Hacks");
			Kick(playerid);

			return 0;
		}
	}
	if (GetPlayerMoney(playerid) != PlayerData[playerid][pMoney])
	{
	    ResetPlayerMoney(playerid);
	    GivePlayerMoney(playerid, PlayerData[playerid][pMoney]);
	}
	if (GetPlayerScore(playerid) != PlayerData[playerid][pPlayingHours])
	{
		SetPlayerScore(playerid, PlayerData[playerid][pPlayingHours]);
	}
	if (PlayerData[playerid][pWaypoint])
	{
	    format(str, sizeof(str), "~b~Waypoint:~w~ %s (%.2f meters)", PlayerData[playerid][pLocation], GetPlayerDistanceFromPoint(playerid, PlayerData[playerid][pWaypointPos][0], PlayerData[playerid][pWaypointPos][1], PlayerData[playerid][pWaypointPos][2]));
		PlayerTextDrawSetString(playerid, PlayerData[playerid][pTextdraws][69], str);
	}
	if (PlayerData[playerid][pMaskOn])
	{
		if (!PlayerData[playerid][pHideTags])
	    {
            foreach (new i : Player) {
				ShowPlayerNameTagForPlayer(i, playerid, 0);
			}
		    format(str, sizeof(str), "Mask_#%d", PlayerData[playerid][pMaskID]);

	        PlayerData[playerid][pHideTags] = 1;
	        PlayerData[playerid][pNameTag] = CreateDynamic3DTextLabel(str, COLOR_WHITE, 0.0, 0.0, 0.2, 8.0, playerid, INVALID_VEHICLE_ID, 0, -1, -1);
	    }
	}
	if (!PlayerData[playerid][pMaskOn] && PlayerData[playerid][pHideTags])
	{
	    foreach (new i : Player) {
			ShowPlayerNameTagForPlayer(i, playerid, 1);
		}
		ResetNameTag(playerid);
	}
	if (IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
	    if (IsSpeedoVehicle(vehicleid) && !PlayerData[playerid][pDisableSpeedo])
	    {
		    static
		        Float:fDamage,
		        Float:fSpeed,
		        Float:fVelocity[3];

	  		GetVehicleHealth(vehicleid, fDamage);
	  		GetVehicleVelocity(vehicleid, fVelocity[0], fVelocity[1], fVelocity[2]);

	  		fDamage = floatdiv(1000 - fDamage, 10) * 1.42999; // 1.33334;
 	  		fSpeed = floatmul(floatsqroot((fVelocity[0] * fVelocity[0]) + (fVelocity[1] * fVelocity[1]) + (fVelocity[2] * fVelocity[2])), 100.0);

			if (fDamage < 0.0) fDamage = 0.0;
			else if (fDamage > 100.0) fDamage = 100.0;

	        format(str, sizeof(str), "~r~Fuel:~w~ %d%c", CoreVehicles[vehicleid][vehFuel], '%');
			PlayerTextDrawSetString(playerid, PlayerData[playerid][pTextdraws][35], str);

			format(str, sizeof(str), "~r~Speed:~w~ %.0f mph", fSpeed);
			PlayerTextDrawSetString(playerid, PlayerData[playerid][pTextdraws][36], str);

			format(str, sizeof(str), "~r~Damage:~w~ %.0f/100%%", (fDamage > 100.0) ? (100.0) : (fDamage));
			PlayerTextDrawSetString(playerid, PlayerData[playerid][pTextdraws][37], str);

	        format(str, sizeof(str), "~r~Windows:~w~ %s", (CoreVehicles[vehicleid][vehWindowsDown]) ? ("Down") : ("Up"));
			PlayerTextDrawSetString(playerid, PlayerData[playerid][pTextdraws][38], str);
		}
		for (new i = 0; i != MAX_BARRICADES; i ++) if (BarricadeData[i][cadeExists] && BarricadeData[i][cadeType] == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, BarricadeData[i][cadePos][0], BarricadeData[i][cadePos][1], BarricadeData[i][cadePos][2]))
		{
			static
			    tires[4];

			GetVehicleDamageStatus(vehicleid, tires[0], tires[1], tires[2], tires[3]);

			if (tires[3] != 1111) {
			    UpdateVehicleDamageStatus(vehicleid, tires[0], tires[1], tires[2], 1111);
			}
			break;
		}
	}
	switch (PlayerData[playerid][pHouseLights])
	{
	    case 0:
	    {
	        if ((id = House_Inside(playerid)) != -1 && !HouseData[id][houseLights])
			{
	        	PlayerData[playerid][pHouseLights] = true;
	            PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][62]);
	        }
	        else PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][62]);
	    }
	    case 1:
	    {
	        if ((id = House_Inside(playerid)) == -1 || (id != -1 && HouseData[id][houseLights]))
			{
	            PlayerData[playerid][pHouseLights] = false;
                PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws][62]);
	        }
	    }
	}
	if (PlayerData[playerid][pDrinking] && GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DRINK_SPRUNK && !IsPlayerInAnyVehicle(playerid))
	{
 		DestroyPlayerProgressBar(playerid, PlayerData[playerid][pDrinkBar]);
 		PlayerData[playerid][pDrinking] = 0;
	}
	if ((id = Speed_Nearest(playerid)) != -1 && GetPlayerSpeed(playerid) > SpeedData[id][speedLimit] && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsEngineVehicle(vehicleid) && !PlayerData[playerid][pSpeedTime])
	{
	    if (!IsACruiser(vehicleid) && !IsABoat(vehicleid) && !IsAPlane(vehicleid) && !IsAHelicopter(vehicleid))
	    {
	 		new price = 100 + floatround(GetPlayerSpeed(playerid) - SpeedData[id][speedLimit]);

	   		format(str, sizeof(str), "Speeding (%.0f/%.0f mph)", GetPlayerSpeed(playerid), SpeedData[id][speedLimit]);
	        SetTimerEx("HidePlayerBox", 500, false, "dd", playerid, _:ShowPlayerBox(playerid, 0xFFFFFF66));

			if (Ticket_Add(playerid, price, str) != -1)
			{
	    		format(str, sizeof(str), "You have received a ~r~%s~w~ speeding ticket.", FormatNumber(price));
	     		ShowPlayerFooter(playerid, str);
			}
			PlayerData[playerid][pSpeedTime] = 5;
		}
	}
	if (Detector_Nearest(playerid) != -1)
	{
		if (IsPlayerArmed(playerid) && gettime() > PlayerData[playerid][pDetectorTime])
		{
			PlayerData[playerid][pDetectorTime] = gettime() + 5;

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** The metal detector sounds off. (( %s ))", ReturnName(playerid, 0));
			PlayerPlaySoundEx(playerid, 43000);
		}
	}
	if ((keys[0] & KEY_FIRE) && GetPlayerWeapon(playerid) == 42)
	{
        static
	        Float:fX,
	        Float:fY,
	        Float:fZ;

	    for (new i = 0; i < sizeof(g_aFireObjects); i ++)
	    {
			GetDynamicObjectPos(g_aFireObjects[i], fX, fY, fZ);

			if ((IsValidDynamicObject(g_aFireObjects[i]) && IsPlayerInRangeOfPoint(playerid, 4.0, fX, fY, fZ)) && ++ g_aFireExtinguished[i] == 32)
   			{
   			    SetTimerEx("DestroyWater", 2000, false, "d", CreateDynamicObject(18744, fX, fY, fZ - 0.2, 0.0, 0.0, 0.0));

      			DestroyDynamicObject(g_aFireObjects[i]);
	        	g_aFireExtinguished[i] = 0;
			}
		}
	}
	if ((keys[0] & KEY_FIRE) && (GetVehicleModel(GetPlayerVehicleID(playerid)) == 407 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 544))
	{
	    static
	        Float:fX,
	        Float:fY,
	        Float:fZ,
			Float:fVector[3],
			Float:fCamera[3];

	    GetPlayerCameraFrontVector(playerid, fVector[0], fVector[1], fVector[2]);
	    GetPlayerCameraPos(playerid, fCamera[0], fCamera[1], fCamera[2]);

	    for (new i = 0; i < sizeof(g_aFireObjects); i ++)
	    {
			GetDynamicObjectPos(g_aFireObjects[i], fX, fY, fZ);

			if (IsValidDynamicObject(g_aFireObjects[i]) && IsPlayerInRangeOfPoint(playerid, 3050, fX, fY, fZ))
			{
				if (++g_aFireExtinguished[i] == 64 && DistanceCameraTargetToLocation(fCamera[0], fCamera[1], fCamera[2], fX, fY, fZ + 2.5, fVector[0], fVector[1], fVector[2]) < 12.0)
   				{
   			    	SetTimerEx("DestroyWater", 2000, false, "d", CreateDynamicObject(18744, fX, fY, fZ - 0.2, 0.0, 0.0, 0.0));

	      			DestroyDynamicObject(g_aFireObjects[i]);
		        	g_aFireExtinguished[i] = 0;
				}
		  	}
	    }
	}
	return 1;
}

// ====== OnPlayerConnect ======
public OnPlayerConnect(playerid)
{
	if (IsPlayerNPC(playerid))
	    return 1;

	if ((GetTickCount() - PlayerData[playerid][pLeaveTime]) < 2000 && !strcmp(ReturnIP(playerid), PlayerData[playerid][pLeaveIP]))
	{
	    SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s (%s) was kicked for possible rejoin hacks.", ReturnName(playerid), ReturnIP(playerid));
	    Kick(playerid);
		return 1;
	}
	new
		str[128];

	ResetPlayerWeapons(playerid);
	SetPlayerArmedWeapon(playerid, 0);

	PreloadAnimations(playerid);

	if (g_ServerRestart) {
		TextDrawShowForPlayer(playerid, gServerTextdraws[3]);
	}
	for (new i = 0; i != MAX_PLAYER_ATTACHED_OBJECTS; i ++) {
	    RemovePlayerAttachedObject(playerid, i);
	}
	// Gas pumps
	RemoveBuildingForPlayer(playerid, 1676, 1941.6563, -1767.2891, 14.1406, 6000.00);
	RemoveBuildingForPlayer(playerid, 3465, 2120.8203, 914.7188, 11.2578, 6000.00);
	RemoveBuildingForPlayer(playerid, 1686, -1610.6172, -2721.0000, 47.9297, 6000.00);

	// LS mall
	RemoveBuildingForPlayer(playerid, 6130, 1117.5859, -1490.0078, 32.7188, 10.0);
	RemoveBuildingForPlayer(playerid, 6255, 1117.5859, -1490.0078, 32.7188, 10.0);
	RemoveBuildingForPlayer(playerid, 762, 1175.3594, -1420.1875, 19.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 615, 1166.3516, -1417.6953, 13.9531, 0.25);

	// Sprunk machines
 	RemoveBuildingForPlayer(playerid, 1302, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1209, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 955, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 956, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1775, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1776, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1977, 0.0, 0.0, 0.0, 6000.0);

	// Fire station
	RemoveBuildingForPlayer(playerid, 717, 1703.9922, -1150.1484, 23.0938, 0.25);
    RemoveBuildingForPlayer(playerid, 717, 1721.2344, -1150.1484, 23.0938, 0.25);
    RemoveBuildingForPlayer(playerid, 1300, 1715.4922, -1037.9766, 23.2656, 0.25);
    RemoveBuildingForPlayer(playerid, 1294, 1734.9531, -1156.9922, 27.3516, 0.25);
    RemoveBuildingForPlayer(playerid, 717, 1738.7813, -1150.1484, 23.0938, 0.25);
    RemoveBuildingForPlayer(playerid, 1227, 1789.7734, -1116.0625, 23.8906, 0.25);
    RemoveBuildingForPlayer(playerid, 1227, 1789.9063, -1112.6406, 23.8906, 0.25);
    RemoveBuildingForPlayer(playerid, 717, 1726.0000, -1064.8828, 23.1563, 0.25);
    RemoveBuildingForPlayer(playerid, 4640, 1728.7891, -1065.0938, 24.5000, 0.25);
    RemoveBuildingForPlayer(playerid, 1300, 1730.6328, -1033.6719, 23.2656, 0.25);
    RemoveBuildingForPlayer(playerid, 4598, 1737.2031, -1052.8203, 23.3359, 0.25);
    RemoveBuildingForPlayer(playerid, 4599, 1738.1875, -1044.9922, 22.9844, 0.25);
    RemoveBuildingForPlayer(playerid, 1300, 1747.8594, -1063.2969, 23.2656, 0.25);
    RemoveBuildingForPlayer(playerid, 717, 1758.3828, -1066.3594, 23.1797, 0.25);
    RemoveBuildingForPlayer(playerid, 1300, 1758.0781, -1064.5547, 23.2656, 0.25);
    RemoveBuildingForPlayer(playerid, 717, 1765.1563, -1042.5234, 23.1797, 0.25);
    RemoveBuildingForPlayer(playerid, 1300, 1764.8594, -1040.7188, 23.2656, 0.25);
    RemoveBuildingForPlayer(playerid, 4641, 1788.5391, -1026.3516, 24.5000, 0.25);

	// Prison exterior
	RemoveBuildingForPlayer(playerid, 3682, 247.9297, 1461.8594, 33.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 3682, 192.2734, 1456.1250, 33.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 3682, 199.7578, 1397.8828, 33.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 133.7422, 1356.9922, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 166.7891, 1356.9922, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 166.7891, 1392.1563, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 133.7422, 1392.1563, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 166.7891, 1426.9141, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 133.7422, 1426.9141, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3288, 221.5703, 1374.9688, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3289, 212.0781, 1426.0313, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3290, 218.2578, 1467.5391, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3291, 246.5625, 1435.1953, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3291, 246.5625, 1410.5391, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3291, 246.5625, 1385.8906, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3291, 246.5625, 1361.2422, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3290, 190.9141, 1371.7734, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3289, 183.7422, 1444.8672, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3289, 222.5078, 1444.6953, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3289, 221.1797, 1390.2969, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3288, 223.1797, 1421.1875, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 133.7422, 1459.6406, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3289, 207.5391, 1371.2422, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3424, 220.6484, 1355.1875, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3424, 221.7031, 1404.5078, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3424, 210.4141, 1444.8438, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3424, 262.5078, 1465.2031, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3259, 220.6484, 1355.1875, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 133.7422, 1356.9922, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 166.7891, 1356.9922, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3256, 190.9141, 1371.7734, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 166.7891, 1392.1563, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 133.7422, 1392.1563, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3258, 207.5391, 1371.2422, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 205.6484, 1394.1328, 10.1172, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 205.6484, 1392.1563, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 205.6484, 1394.1328, 23.7813, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 207.3594, 1390.5703, 19.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 206.5078, 1387.8516, 27.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 3673, 199.7578, 1397.8828, 33.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 3257, 221.5703, 1374.9688, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3258, 221.1797, 1390.2969, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 203.9531, 1409.9141, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3674, 199.3828, 1407.1172, 35.8984, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 204.6406, 1409.8516, 11.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 206.5078, 1404.2344, 18.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 206.5078, 1400.6563, 22.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3259, 221.7031, 1404.5078, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 207.3594, 1409.0000, 19.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3257, 223.1797, 1421.1875, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3258, 212.0781, 1426.0313, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 166.7891, 1426.9141, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 133.7422, 1426.9141, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3255, 246.5625, 1361.2422, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3255, 246.5625, 1385.8906, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3255, 246.5625, 1410.5391, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3258, 183.7422, 1444.8672, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3259, 210.4141, 1444.8438, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3258, 222.5078, 1444.6953, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 16086, 232.2891, 1434.4844, 13.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 3673, 192.2734, 1456.1250, 33.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 3674, 183.0391, 1455.7500, 35.8984, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 133.7422, 1459.6406, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 196.0234, 1462.0156, 10.1172, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 198.0000, 1462.0156, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 196.0234, 1462.0156, 23.7813, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 180.2422, 1460.3203, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 180.3047, 1461.0078, 11.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 3256, 218.2578, 1467.5391, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 199.5859, 1463.7266, 19.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 181.1563, 1463.7266, 19.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 185.9219, 1462.8750, 18.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 202.3047, 1462.8750, 27.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 189.5000, 1462.8750, 22.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3255, 246.5625, 1435.1953, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 254.6797, 1451.8281, 27.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 253.8203, 1458.1094, 23.7813, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 255.5313, 1454.5469, 19.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 253.8203, 1456.1328, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 253.8203, 1458.1094, 10.1172, 0.25);
	RemoveBuildingForPlayer(playerid, 3259, 262.5078, 1465.2031, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 254.6797, 1468.2109, 18.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3673, 247.9297, 1461.8594, 33.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 254.6797, 1464.6328, 22.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3674, 247.5547, 1471.0938, 35.8984, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 255.5313, 1472.9766, 19.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 252.8125, 1473.8281, 11.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 252.1250, 1473.8906, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 16089, 342.1250, 1431.0938, 5.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 16090, 315.7734, 1431.0938, 5.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 16091, 289.7422, 1431.0938, 5.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 16087, 358.6797, 1430.4531, 11.6172, 0.25);
	RemoveBuildingForPlayer(playerid, 16088, 368.4297, 1431.0938, 5.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 16092, 394.1563, 1431.0938, 5.2734, 0.25);

	CancelSelectTextDraw(playerid);

	GetPlayerIp(playerid, PlayerData[playerid][pIP], 16);
	GetPlayerName(playerid, PlayerData[playerid][pUsername], MAX_PLAYER_NAME + 1);

	ResetStatistics(playerid);
	CreateTextDraws(playerid);

	format(str, sizeof(str), "SELECT * FROM `blacklist` WHERE `Username` = '%s' OR `IP` = '%s'", ReturnName(playerid), PlayerData[playerid][pIP]);
	mysql_tquery(g_iHandle, str, "OnQueryFinished", "dd", playerid, THREAD_BAN_LOOKUP);
	return 1;
}

// ====== OnPlayerDisconnect ======
public OnPlayerDisconnect(playerid, reason)
{
	PlayerData[playerid][pLeaveTime] = GetTickCount();

	format(PlayerData[playerid][pLeaveIP], 16, PlayerData[playerid][pIP]);

 	TerminateConnection(playerid);
	return 1;
}

// ====== OnPlayerRequestClass ======
public OnPlayerRequestClass(playerid, classid)
{
    if (IsPlayerNPC(playerid))
	    return 1;

	if (!PlayerData[playerid][pAccount] && !PlayerData[playerid][pKicked])
	{
	    new
	        time[3];

        gettime(time[0], time[1], time[2]);
		SetPlayerTime(playerid, time[0], time[1]);

	    PlayerData[playerid][pAccount] = 1;
	    TogglePlayerSpectating(playerid, 1);

		SetPlayerColor(playerid, DEFAULT_COLOR);
		SetTimerEx("AccountCheck", 400, false, "d", playerid); // 400 ms
	}
	return 1;
}

// ====== OnPlayerCommandReceived ======
public OnPlayerCommandReceived(playerid, cmdtext[])
{
	if (!SQL_IsLogged(playerid) || (PlayerData[playerid][pTutorial] > 0 || PlayerData[playerid][pTutorialStage] > 0 || PlayerData[playerid][pKilled] > 0 || PlayerData[playerid][pHospital] != -1))
	    return 0;

	if (PlayerData[playerid][pMuted] && strfind(cmdtext, "/unmute", true) != 0)
 	{
	    SendErrorMessage(playerid, "You are muted by the system.");
	    return 0;
	}
	if (PlayerData[playerid][pCommandCount] < 6)
	{
	    PlayerData[playerid][pCommandCount]++;

	    if (PlayerData[playerid][pCommandCount] == 6) {
	        PlayerData[playerid][pCommandCount] = 0;

	        PlayerData[playerid][pMuted] = 1;
	        PlayerData[playerid][pMuteTime] = 5;

	        SendServerMessage(playerid, "You have been muted for spamming (5 seconds).");
	        SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has been automatically muted for spamming.", ReturnName(playerid, 0));
	        return 0;
		}
	}
	return 1;
}

// ====== OnPlayerText ======
public OnPlayerText(playerid, text[])
{
	if ((!PlayerData[playerid][pLogged] && !PlayerData[playerid][pCharacter]) || PlayerData[playerid][pTutorial] > 0 || PlayerData[playerid][pTutorialStage] > 0 || PlayerData[playerid][pHospital] != -1)
	    return 0;

	if (PlayerData[playerid][pMuted])
	{
	    SendErrorMessage(playerid, "You are muted by the system.");
	    return 0;
	}
	if (PlayerData[playerid][pSpamCount] < 5)
	{
	    PlayerData[playerid][pSpamCount]++;

	    if (PlayerData[playerid][pSpamCount] == 5) {
	        PlayerData[playerid][pSpamCount] = 0;

	        PlayerData[playerid][pMuted] = 1;
	        PlayerData[playerid][pMuteTime] = 5;

	        SendServerMessage(playerid, "You have been muted for spamming (5 seconds).");
	        SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has been automatically muted for spamming.", ReturnName(playerid, 0));
	        return 0;
		}
	}
	if (PlayerData[playerid][pNewsGuest] != INVALID_PLAYER_ID && GetFactionType(PlayerData[playerid][pNewsGuest]) == FACTION_NEWS && IsPlayerInAnyVehicle(playerid) && IsNewsVehicle(GetPlayerVehicleID(playerid)))
	{
	    foreach (new i : Player) if (!PlayerData[i][pDisableBC]) {
	  		SendClientMessageEx(i, COLOR_LIGHTGREEN, "[NEWS] Guest %s: %s", ReturnName(playerid, 0), text);
		}
	   	return 0;
   	}
	else
	{
		new
			targetid = PlayerData[playerid][pCallLine];

		//SetPlayerChatBubble(playerid, text, COLOR_WHITE, 10.0, 6000);

        if (IsPlayerInAnyVehicle(playerid) && IsWindowedVehicle(GetPlayerVehicleID(playerid)) && !CoreVehicles[GetPlayerVehicleID(playerid)][vehWindowsDown])
			SendVehicleMessage(GetPlayerVehicleID(playerid), 0xBBFFEEFF, "[Vehicle] %s says: %s", ReturnName(playerid, 0), text);

		else
		{
		    if (!IsPlayerOnPhone(playerid))
				SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "%s says: %s", ReturnName(playerid, 0), text);

			else SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "(Phone) %s says: %s", ReturnName(playerid, 0), text);

			if (!IsPlayerInAnyVehicle(playerid) && !PlayerData[playerid][pInjured] && !PlayerData[playerid][pLoopAnim]) {
				ApplyAnimation(playerid, "GANGS", "prtial_gngtlkA", 4.1, 0, 1, 1, 1, strlen(text) * 100, 1);

				SetTimerEx("StopChatting", strlen(text) * 100, false, "d", playerid);
			}
		}
		switch (PlayerData[playerid][pEmergency])
		{
			case 1:
			{
				if (!strcmp(text, "police", true))
				{
				    PlayerData[playerid][pEmergency] = 2;
				    SendClientMessage(playerid, COLOR_LIGHTBLUE, "[OPERATOR]:{FFFFFF} You've been dispatched to police HQ. Please describe the crime.");
				}
				else if (!strcmp(text, "medics", true))
				{
				    PlayerData[playerid][pEmergency] = 3;
				    SendClientMessage(playerid, COLOR_HOSPITAL, "[OPERATOR]:{FFFFFF} You've been dispatched to medical HQ. Please describe the emergency.");
				}
				else SendClientMessage(playerid, COLOR_LIGHTBLUE, "[OPERATOR]:{FFFFFF} Sorry, I don't understand. Do you require \"police\" or \"medics\"?");
			}
			case 2:
			{
   				SendFactionMessageEx(FACTION_POLICE, COLOR_RADIO, "911 CALL: %s (%s)", ReturnName(playerid, 0), GetPlayerLocation(playerid));
        		SendFactionMessageEx(FACTION_POLICE, COLOR_RADIO, "DESCRIPTION: %s", text);

			    SendClientMessage(playerid, COLOR_LIGHTBLUE, "[OPERATOR]:{FFFFFF} We have alerted all units in the area.");
			    cmd_hangup(playerid, "\1");

			    SetFactionMarker(playerid, FACTION_POLICE, 0x00D700FF);
			}
			case 3:
			{
			    SendFactionMessageEx(FACTION_MEDIC, COLOR_HOSPITAL, "911 CALL: %s (%s)", ReturnName(playerid, 0), GetPlayerLocation(playerid));
       			SendFactionMessageEx(FACTION_MEDIC, COLOR_HOSPITAL, "DESCRIPTION: %s", text);

			    SendClientMessage(playerid, COLOR_HOSPITAL, "[OPERATOR]:{FFFFFF} We have alerted all units in the area.");
			    cmd_hangup(playerid, "\1");

			    SetFactionMarker(playerid, FACTION_MEDIC, 0x00D700FF);
			}
		}
		switch (PlayerData[playerid][pPlaceAd])
		{
		    case 1:
		    {
			    if (!strcmp(text, "yes", true))
		        {
		            if (GetMoney(playerid) < 500)
				    {
    	                SendClientMessage(playerid, COLOR_CYAN, "[OPERATOR]:{FFFFFF} Sorry, you have insufficient funds to advertise right now.");
					    cmd_hangup(playerid, "\1");
					}
					else
					{
						PlayerData[playerid][pPlaceAd] = 2;
						SendClientMessage(playerid, COLOR_CYAN, "[OPERATOR]:{FFFFFF} Please specify your advertisement and we'll advertise it.");
					}
				}
			}
			case 2:
			{
			    if (GetMoney(playerid) < 500)
			    {
                    SendClientMessage(playerid, COLOR_CYAN, "[OPERATOR]:{FFFFFF} Sorry, you have insufficient funds to advertise right now.");
				    cmd_hangup(playerid, "\1");
				}
				else
				{
				    GiveMoney(playerid, -500);
				    SetTimerEx("Advertise", 3000, false, "d", playerid);

                    PlayerData[playerid][pAdTime] = 120;
				    strpack(PlayerData[playerid][pAdvertise], text, 128 char);

        	        SendClientMessage(playerid, COLOR_CYAN, "[OPERATOR]:{FFFFFF} Your advertisement will be published shortly.");
				    cmd_hangup(playerid, "\1");
				}
			}
		}
		if (targetid != INVALID_PLAYER_ID && !PlayerData[playerid][pIncomingCall])
		{
			SendClientMessageEx(targetid, COLOR_YELLOW, "(Phone) %s says: %s", ReturnName(playerid, 0), text);
		}
	}
	return 0;
}

// ====== OnPlayerEditDynamicObject ======
public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if (response == EDIT_RESPONSE_FINAL)
	{
	    if (PlayerData[playerid][pEditGraffiti] != -1 && GraffitiData[PlayerData[playerid][pEditGraffiti]][graffitiExists])
	    {
			GraffitiData[PlayerData[playerid][pEditGraffiti]][graffitiPos][0] = x;
			GraffitiData[PlayerData[playerid][pEditGraffiti]][graffitiPos][1] = y;
			GraffitiData[PlayerData[playerid][pEditGraffiti]][graffitiPos][2] = z;
			GraffitiData[PlayerData[playerid][pEditGraffiti]][graffitiPos][3] = rz;

			Graffiti_Refresh(PlayerData[playerid][pEditGraffiti]);
			Graffiti_Save(PlayerData[playerid][pEditGraffiti]);
		}
	    else if (PlayerData[playerid][pEditRack] != -1 && RackData[PlayerData[playerid][pEditRack]][rackExists])
	    {
			RackData[PlayerData[playerid][pEditRack]][rackPos][0] = x;
			RackData[PlayerData[playerid][pEditRack]][rackPos][1] = y;
			RackData[PlayerData[playerid][pEditRack]][rackPos][2] = z;
			RackData[PlayerData[playerid][pEditRack]][rackPos][3] = rz;

			Rack_Refresh(PlayerData[playerid][pEditRack]);
			Rack_Save(PlayerData[playerid][pEditRack]);
		}
	    else if (PlayerData[playerid][pEditPump] != -1 && PumpData[PlayerData[playerid][pEditPump]][pumpExists])
	    {
			PumpData[PlayerData[playerid][pEditPump]][pumpPos][0] = x;
			PumpData[PlayerData[playerid][pEditPump]][pumpPos][1] = y;
			PumpData[PlayerData[playerid][pEditPump]][pumpPos][2] = z;
			PumpData[PlayerData[playerid][pEditPump]][pumpPos][3] = rz;

			Pump_Refresh(PlayerData[playerid][pEditPump]);
			Pump_Save(PlayerData[playerid][pEditPump]);

			SendServerMessage(playerid, "You have edited the position of pump ID: %d.", PlayerData[playerid][pEditPump]);
	    }
	    else if (PlayerData[playerid][pEditFurniture] != -1 && FurnitureData[PlayerData[playerid][pEditFurniture]][furnitureExists])
	    {
	        new id = House_Inside(playerid);

	        if (id != -1 && House_IsOwner(playerid, id))
			{
			    FurnitureData[PlayerData[playerid][pEditFurniture]][furniturePos][0] = x;
			    FurnitureData[PlayerData[playerid][pEditFurniture]][furniturePos][1] = y;
			    FurnitureData[PlayerData[playerid][pEditFurniture]][furniturePos][2] = z;
                FurnitureData[PlayerData[playerid][pEditFurniture]][furnitureRot][0] = rx;
                FurnitureData[PlayerData[playerid][pEditFurniture]][furnitureRot][1] = ry;
                FurnitureData[PlayerData[playerid][pEditFurniture]][furnitureRot][2] = rz;

				Furniture_Refresh(PlayerData[playerid][pEditFurniture]);
				Furniture_Save(PlayerData[playerid][pEditFurniture]);

				SendServerMessage(playerid, "You have edited the position of item \"%s\".", FurnitureData[PlayerData[playerid][pEditFurniture]][furnitureName]);
			}
	    }
	    else if (PlayerData[playerid][pEditGate] != -1 && GateData[PlayerData[playerid][pEditGate]][gateExists])
	    {
	        switch (PlayerData[playerid][pEditType])
	        {
	            case 1:
	            {
	                new id = PlayerData[playerid][pEditGate];

	                GateData[PlayerData[playerid][pEditGate]][gatePos][0] = x;
	                GateData[PlayerData[playerid][pEditGate]][gatePos][1] = y;
	                GateData[PlayerData[playerid][pEditGate]][gatePos][2] = z;
	                GateData[PlayerData[playerid][pEditGate]][gatePos][3] = rx;
	                GateData[PlayerData[playerid][pEditGate]][gatePos][4] = ry;
	                GateData[PlayerData[playerid][pEditGate]][gatePos][5] = rz;

	                DestroyDynamicObject(GateData[id][gateObject]);
					GateData[id][gateObject] = CreateDynamicObject(GateData[id][gateModel], GateData[id][gatePos][0], GateData[id][gatePos][1], GateData[id][gatePos][2], GateData[id][gatePos][3], GateData[id][gatePos][4], GateData[id][gatePos][5], GateData[id][gateWorld], GateData[id][gateInterior]);

					Gate_Save(id);
                    SendServerMessage(playerid, "You have edited the position of gate ID: %d.", id);
				}
				case 2:
	            {
	                new id = PlayerData[playerid][pEditGate];

	                GateData[PlayerData[playerid][pEditGate]][gateMove][0] = x;
	                GateData[PlayerData[playerid][pEditGate]][gateMove][1] = y;
	                GateData[PlayerData[playerid][pEditGate]][gateMove][2] = z;
	                GateData[PlayerData[playerid][pEditGate]][gateMove][3] = rx;
	                GateData[PlayerData[playerid][pEditGate]][gateMove][4] = ry;
	                GateData[PlayerData[playerid][pEditGate]][gateMove][5] = rz;

	                DestroyDynamicObject(GateData[id][gateObject]);
					GateData[id][gateObject] = CreateDynamicObject(GateData[id][gateModel], GateData[id][gatePos][0], GateData[id][gatePos][1], GateData[id][gatePos][2], GateData[id][gatePos][3], GateData[id][gatePos][4], GateData[id][gatePos][5], GateData[id][gateWorld], GateData[id][gateInterior]);

					Gate_Save(id);
                    SendServerMessage(playerid, "You have edited the moving position of gate ID: %d.", id);
				}
			}
		}
	}
	if (response == EDIT_RESPONSE_FINAL || response == EDIT_RESPONSE_CANCEL)
	{
	    if (PlayerData[playerid][pEditFurniture] != -1)
			Furniture_Refresh(PlayerData[playerid][pEditFurniture]);

	    if (PlayerData[playerid][pEditPump] != -1)
			Pump_Refresh(PlayerData[playerid][pEditPump]);

        if (PlayerData[playerid][pEditRack] != -1)
			Rack_Refresh(PlayerData[playerid][pEditRack]);

        if (PlayerData[playerid][pEditGraffiti] != -1)
			Graffiti_Refresh(PlayerData[playerid][pEditGraffiti]);

	    PlayerData[playerid][pEditType] = 0;
	    PlayerData[playerid][pEditGate] = -1;
		PlayerData[playerid][pEditPump] = -1;
		PlayerData[playerid][pGasStation] = -1;
		PlayerData[playerid][pEditFurniture] = -1;
		PlayerData[playerid][pEditGraffiti] = -1;
	}
	return 1;
}

// ====== OnPlayerSpawn ======
public OnPlayerSpawn(playerid)
{
    // Skill levels
	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 0);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 0);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 0);

	if (PlayerData[playerid][pHUD])
	{
	 	TextDrawShowForPlayer(playerid, gServerTextdraws[0]);
		TextDrawShowForPlayer(playerid, gServerTextdraws[1]);
	}
    SetPlayerSkin(playerid, PlayerData[playerid][pSkin]);
    Streamer_ToggleIdleUpdate(playerid, true);

	PlayerData[playerid][pKilled] = 0;

    if (PlayerData[playerid][pBleeding])
	{
 		PlayerData[playerid][pBleedTime] = 1;
   	}
	if (PlayerData[playerid][pJailTime] > 0)
	{
	    if (PlayerData[playerid][pPrisoned])
	    {
	        SetPlayerInPrison(playerid);
	    }
	    else
	    {
		    SetPlayerPos(playerid, 197.6346, 175.3765, 1003.0234);
		    SetPlayerInterior(playerid, 3);

		    SetPlayerVirtualWorld(playerid, (playerid + 100));
		    SetPlayerFacingAngle(playerid, 0.0);

		    SetCameraBehindPlayer(playerid);
		}
		ResetWeapons(playerid);

		PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][70]);
	    SendServerMessage(playerid, "You have %d seconds of remaining jail time.", PlayerData[playerid][pJailTime]);
	}
	else if (PlayerData[playerid][pHospital] != -1)
	{
	    PlayerData[playerid][pHospitalTime] = 0;

	    PlayerData[playerid][pHunger] = 50;
	    PlayerData[playerid][pThirst] = 50;

		SetPlayerInterior(playerid, 3);
		SetPlayerVirtualWorld(playerid, playerid + 100);

		SetPlayerPos(playerid, -211.0370, -1738.6848, 676.7153);
		SetPlayerFacingAngle(playerid, 82.0000);

		SetPlayerCameraPos(playerid, -214.236602, -1738.812133, 676.648132);
		SetPlayerCameraLookAt(playerid, -203.072738, -1738.656127, 675.768737);

        ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
        ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);

		GameTextForPlayer(playerid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~Recovering... 15", 1000, 3);
		TogglePlayerControllable(playerid, 0);
	}
	else if (!PlayerData[playerid][pCreated])
	{
    	TogglePlayerControllable(playerid, 0);
		SetPlayerPos(playerid, 216.8005, -99.8691, 1005.2578);
    	SetPlayerFacingAngle(playerid, 90.0000);

  		SetPlayerInterior(playerid, 15);
		SelectTextDraw(playerid, -1);

		for (new i = 23; i < 34; i ++) {
		    PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws][i]);
		}
	}
	else
	{
	    SetPlayerFacingAngle(playerid, PlayerData[playerid][pPos][3]);

	    SetPlayerInterior(playerid, PlayerData[playerid][pInterior]);
	    SetPlayerVirtualWorld(playerid, PlayerData[playerid][pWorld]);

		SetCameraBehindPlayer(playerid);
		SetAccessories(playerid);

        if (PlayerData[playerid][pWorld] == PRISON_WORLD)
		{
		    SetPlayerPosEx(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]);
		}
		else
		{
		    if(PlayerData[playerid][pSpawnPoint] == 3 && PlayerData[playerid][pInjured] == 0)
			{
				SetPlayerPos(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]);
			}
		}
		if (PlayerData[playerid][pInjured])
		{
		    ShowHungerTextdraw(playerid, 0);
		    SetPlayerPos(playerid, PlayerData[playerid][pPos][0], PlayerData[playerid][pPos][1], PlayerData[playerid][pPos][2]);

			TextDrawShowForPlayer(playerid, gServerTextdraws[2]);
			SendClientMessage(playerid, COLOR_LIGHTRED, "[WARNING]:{FFFFFF} You are injured and require medical attention (/call 911).");

			ApplyAnimation(playerid, "CRACK", "null", 4.0, 0, 0, 0, 1, 0, 1);
			ApplyAnimation(playerid, "CRACK", "crckdeth4", 4.0, 0, 0, 0, 1, 0, 1);
		}
		else
		{
			SetWeapons(playerid);
			ShowHungerTextdraw(playerid, 1);

			SetPlayerHealth(playerid, PlayerData[playerid][pHealth]);
			SetPlayerArmour(playerid, PlayerData[playerid][pArmorStatus]);
		}
	}
	return 1;
}
