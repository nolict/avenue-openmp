/*
    File: modules/player/logic/weapon.pwn
    Purpose: Contains player gameplay logic and helper functions for weapon.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== PlayerHasTazer ======
stock PlayerHasTazer(playerid)
{
	return (GetPlayerWeapon(playerid) == 23 && PlayerData[playerid][pTazer]);
}

// ====== PlayerHasBeanBag ======
stock PlayerHasBeanBag(playerid)
{
	return (GetPlayerWeapon(playerid) == 25 && PlayerData[playerid][pBeanBag]);
}

// ====== HoldWeapon ======
stock HoldWeapon(playerid, weaponid)
{
	RemovePlayerAttachedObject(playerid, 4);

	PlayerData[playerid][pHoldWeapon] = weaponid;
    PlayerData[playerid][pUsedMagazine] = 0;

	if (weaponid != 0)
	{
		SetPlayerAttachedObject(playerid, 4, GetWeaponModel(weaponid), 6);
  		SetPlayerArmedWeapon(playerid, 0);
	}
	return 1;
}

// ====== GetWeapon ======
stock GetWeapon(playerid)
{
	new weaponid = GetPlayerWeapon(playerid);

	if (1 <= weaponid <= 46 && PlayerData[playerid][pGuns][g_aWeaponSlots[weaponid]] == weaponid)
 		return weaponid;

	return 0;
}

// ====== IsBleedableWeapon ======
stock IsBleedableWeapon(weaponid)
{
	switch (weaponid) {
	    case 4, 8, 9, 22..38: return 1;
	}
	return 0;
}

// ====== GetWeaponCount ======
stock GetWeaponCount(playerid)
{
	new
		count,
	    weapon,
	    ammo;

	for (new i = 0; i < 12; i ++)
	{
	    GetPlayerWeaponData(playerid, i, weapon, ammo);

	    if (weapon > 0 && ammo > 0) count++;
	}
	return count;
}

// ====== UpdateWeapons ======
stock UpdateWeapons(playerid)
{
	for (new i = 0; i < 13; i ++) if (PlayerData[playerid][pGuns][i])
    {
		if ((i == 2 && PlayerData[playerid][pTazer]) || (i == 3 && PlayerData[playerid][pBeanBag]))
		    continue;

        GetPlayerWeaponData(playerid, i, PlayerData[playerid][pGuns][i], PlayerData[playerid][pAmmo][i]);

        if (PlayerData[playerid][pGuns][i] != 0 && !PlayerData[playerid][pAmmo][i]) {
            PlayerData[playerid][pGuns][i] = 0;
		}
	}
	return 1;
}

// ====== EquipWeapon ======
stock EquipWeapon(playerid, weapon[])
{
	if (PlayerData[playerid][pPlayingHours] < 2)
	    return SendErrorMessage(playerid, "You must play at least 2 hours first.");

	if (IsPlayerInAnyVehicle(playerid))
	    return SendErrorMessage(playerid, "You must exit the vehicle first.");

	if (!strcmp(weapon, "Colt 45", true))
	{
	    if (!Inventory_HasItem(playerid, "Colt 45"))
	        return SendErrorMessage(playerid, "You don't have this weapon.");

	    if (PlayerHasWeapon(playerid, 22))
	        return SendErrorMessage(playerid, "You already have this weapon.");

		if (PlayerData[playerid][pHoldWeapon] > 0)
		    return SendErrorMessage(playerid, "You're already holding a weapon (press 'N' to put it away).");

		HoldWeapon(playerid, 22);

	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out an empty Colt 45 and holds it.", ReturnName(playerid, 0));
	    SendServerMessage(playerid, "Press 'N' to put the gun away. You must attach a magazine to use it.");
	}
	else if (!strcmp(weapon, "Desert Eagle", true))
	{
	    if (!Inventory_HasItem(playerid, "Desert Eagle"))
	        return SendErrorMessage(playerid, "You don't have this weapon.");

	    if (PlayerHasWeapon(playerid, 24))
	        return SendErrorMessage(playerid, "You already have this weapon.");

	    if (PlayerHasWeapon(playerid, 24))
	        return SendErrorMessage(playerid, "You already have this weapon.");

		if (PlayerData[playerid][pHoldWeapon] > 0)
		    return SendErrorMessage(playerid, "You're already holding a weapon (press 'N' to put it away).");

		HoldWeapon(playerid, 24);

	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out an empty Desert Eagle and holds it.", ReturnName(playerid, 0));
	    SendServerMessage(playerid, "Press 'N' to put the gun away. You must attach a magazine to use it.");
	}
	else if (!strcmp(weapon, "Shotgun", true))
	{
	    if (!Inventory_HasItem(playerid, "Shotgun"))
	        return SendErrorMessage(playerid, "You don't have this weapon.");

	    if (PlayerHasWeapon(playerid, 25))
	        return SendErrorMessage(playerid, "You already have this weapon.");

		if (PlayerData[playerid][pHoldWeapon] > 0)
		    return SendErrorMessage(playerid, "You're already holding a weapon (press 'N' to put it away).");

		HoldWeapon(playerid, 25);

	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out an empty Shotgun and holds it.", ReturnName(playerid, 0));
	    SendServerMessage(playerid, "Press 'N' to put the gun away. You must attach a magazine to use it.");
	}
	else if (!strcmp(weapon, "Micro SMG", true))
	{
	    if (!Inventory_HasItem(playerid, "Micro SMG"))
	        return SendErrorMessage(playerid, "You don't have this weapon.");

	    if (PlayerHasWeapon(playerid, 28))
	        return SendErrorMessage(playerid, "You already have this weapon.");

		if (PlayerData[playerid][pHoldWeapon] > 0)
		    return SendErrorMessage(playerid, "You're already holding a weapon (press 'N' to put it away).");

		HoldWeapon(playerid, 28);

	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out an empty Micro SMG and holds it.", ReturnName(playerid, 0));
	    SendServerMessage(playerid, "Press 'N' to put the gun away. You must attach a magazine to use it.");
	}
	else if (!strcmp(weapon, "Tec-9", true))
	{
	    if (!Inventory_HasItem(playerid, "Tec-9"))
	        return SendErrorMessage(playerid, "You don't have this weapon.");

	    if (PlayerHasWeapon(playerid, 32))
	        return SendErrorMessage(playerid, "You already have this weapon.");

		if (PlayerData[playerid][pHoldWeapon] > 0)
		    return SendErrorMessage(playerid, "You're already holding a weapon (press 'N' to put it away).");

		HoldWeapon(playerid, 32);

	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out an empty Tec-9 and holds it.", ReturnName(playerid, 0));
	    SendServerMessage(playerid, "Press 'N' to put the gun away. You must attach a magazine to use it.");
	}
	else if (!strcmp(weapon, "MP5", true))
	{
	    if (!Inventory_HasItem(playerid, "MP5"))
	        return SendErrorMessage(playerid, "You don't have this weapon.");

	    if (PlayerHasWeapon(playerid, 29))
	        return SendErrorMessage(playerid, "You already have this weapon.");

		if (PlayerData[playerid][pHoldWeapon] > 0)
		    return SendErrorMessage(playerid, "You're already holding a weapon (press 'N' to put it away).");

		HoldWeapon(playerid, 29);

	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out an empty MP5 and holds it.", ReturnName(playerid, 0));
	    SendServerMessage(playerid, "Press 'N' to put the gun away. You must attach a magazine to use it.");
	}
	else if (!strcmp(weapon, "AK-47", true))
	{
	    if (!Inventory_HasItem(playerid, "AK-47"))
	        return SendErrorMessage(playerid, "You don't have this weapon.");

	    if (PlayerHasWeapon(playerid, 30))
	        return SendErrorMessage(playerid, "You already have this weapon.");

		if (PlayerData[playerid][pHoldWeapon] > 0)
		    return SendErrorMessage(playerid, "You're already holding a weapon (press 'N' to put it away).");

		HoldWeapon(playerid, 30);

	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out an empty AK-47 and holds it.", ReturnName(playerid, 0));
	    SendServerMessage(playerid, "Press 'N' to put the gun away. You must attach a magazine to use it.");
	}
	else if (!strcmp(weapon, "Rifle", true))
	{
	    if (!Inventory_HasItem(playerid, "Rifle"))
	        return SendErrorMessage(playerid, "You don't have this weapon.");

	    if (PlayerHasWeapon(playerid, 33))
	        return SendErrorMessage(playerid, "You already have this weapon.");

		if (PlayerData[playerid][pHoldWeapon] > 0)
		    return SendErrorMessage(playerid, "You're already holding a weapon (press 'N' to put it away).");

		HoldWeapon(playerid, 33);

	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out an empty Rifle and holds it.", ReturnName(playerid, 0));
	    SendServerMessage(playerid, "Press 'N' to put the gun away. You must attach a magazine to use it.");
	}
	else if (!strcmp(weapon, "Sniper", true))
	{
	    if (!Inventory_HasItem(playerid, "Sniper"))
	        return SendErrorMessage(playerid, "You don't have this weapon.");

	    if (PlayerHasWeapon(playerid, 34))
	        return SendErrorMessage(playerid, "You already have this weapon.");

		if (PlayerData[playerid][pHoldWeapon] > 0)
		    return SendErrorMessage(playerid, "You're already holding a weapon (press 'N' to put it away).");

		HoldWeapon(playerid, 34);

	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s takes out an empty Sniper and holds it.", ReturnName(playerid, 0));
	    SendServerMessage(playerid, "Press 'N' to put the gun away. You must attach a magazine to use it.");
	}
	else if (!strcmp(weapon, "Golf Club", true))
	{
	    if (!Inventory_HasItem(playerid, "Golf Club"))
	        return SendErrorMessage(playerid, "You don't have this weapon.");

	    if (PlayerHasWeapon(playerid, 2))
	        return SendErrorMessage(playerid, "You already have this weapon.");

	    GiveWeaponToPlayer(playerid, 2, 1);

	    Inventory_Remove(playerid, "Golf Club");
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has equipped a Golf Club from their inventory.", ReturnName(playerid, 0));
	}
	else if (!strcmp(weapon, "Knife", true))
	{
	    if (!Inventory_HasItem(playerid, "Knife"))
	        return SendErrorMessage(playerid, "You don't have this weapon.");

	    if (PlayerHasWeapon(playerid, 4))
	        return SendErrorMessage(playerid, "You already have this weapon.");

	    GiveWeaponToPlayer(playerid, 4, 1);

	    Inventory_Remove(playerid, "Knife");
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has equipped a Knife from their inventory.", ReturnName(playerid, 0));
	}
	else if (!strcmp(weapon, "Shovel", true))
	{
	    if (!Inventory_HasItem(playerid, "Shovel"))
	        return SendErrorMessage(playerid, "You don't have this weapon.");

	    if (PlayerHasWeapon(playerid, 6))
	        return SendErrorMessage(playerid, "You already have this weapon.");

	    GiveWeaponToPlayer(playerid, 6, 1);

	    Inventory_Remove(playerid, "Shovel");
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has equipped a Shovel from their inventory.", ReturnName(playerid, 0));
	}
    else if (!strcmp(weapon, "Katana", true))
	{
	    if (!Inventory_HasItem(playerid, "Katana"))
	        return SendErrorMessage(playerid, "You don't have this weapon.");

	    if (PlayerHasWeapon(playerid, 8))
	        return SendErrorMessage(playerid, "You already have this weapon.");

	    GiveWeaponToPlayer(playerid, 8, 1);

	    Inventory_Remove(playerid, "Katana");
	    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has equipped a Katana from their inventory.", ReturnName(playerid, 0));
	}
	return 1;
}

// ====== IsPlayerArmed ======
stock IsPlayerArmed(playerid)
{
	new
	    weapon,
	    ammo;

	for (new i = 0; i < 13; i ++) {
	    GetPlayerWeaponData(playerid, i, weapon, ammo);

		if (ammo > 0) {
			switch (weapon) {
			    case 1, 2, 4, 6, 8, 9, 15, 22..38: return 1;
			}
		}
	}
	return 0;
}

// ====== PlayReloadAnimation ======
stock PlayReloadAnimation(playerid, weaponid)
{
	switch (weaponid)
	{
	    case 22: ApplyAnimation(playerid, "COLT45", "colt45_reload", 4.0, 0, 0, 0, 0, 0);
		case 23: ApplyAnimation(playerid, "SILENCED", "Silence_reload", 4.0, 0, 0, 0, 0, 0);
		case 24: ApplyAnimation(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0);
		case 25, 27: ApplyAnimation(playerid, "BUDDY", "buddy_reload", 4.0, 0, 0, 0, 0, 0);
		case 26: ApplyAnimation(playerid, "COLT45", "sawnoff_reload", 4.0, 0, 0, 0, 0, 0);
		case 29..31, 33, 34: ApplyAnimation(playerid, "RIFLE", "rifle_load", 4.0, 0, 0, 0, 0, 0);
		case 28, 32: ApplyAnimation(playerid, "TEC", "tec_reload", 4.0, 0, 0, 0, 0, 0);
	}
	return 1;
}

// ====== PlayerHasWeapon ======
stock PlayerHasWeapon(playerid, weaponid)
{
	new
	    weapon,
	    ammo;

	for (new i = 0; i < 13; i ++) if (PlayerData[playerid][pGuns][i] == weaponid) {
	    GetPlayerWeaponData(playerid, i, weapon, ammo);

	    if (weapon == weaponid && ammo > 0) return 1;
	}
	return 0;
}

// ====== SetWeapons ======
SetWeapons(playerid)
{
	ResetPlayerWeapons(playerid);

	for (new i = 0; i < 13; i ++) if (PlayerData[playerid][pGuns][i] > 0 && PlayerData[playerid][pAmmo][i] > 0) {
	    GivePlayerWeapon(playerid, PlayerData[playerid][pGuns][i], PlayerData[playerid][pAmmo][i]);
	}
	return 1;
}

// ====== IsWeaponModel ======
IsWeaponModel(model) {
    new const g_aWeaponModels[] = {
		0, 331, 333, 334, 335, 336, 337, 338, 339, 341, 321, 322, 323, 324,
		325, 326, 342, 343, 344, 0, 0, 0, 346, 347, 348, 349, 350, 351, 352,
		353, 355, 356, 372, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366,
		367, 368, 368, 371
    };
    for (new i = 0; i < sizeof(g_aWeaponModels); i ++) if (g_aWeaponModels[i] == model) {
        return 1;
	}
	return 0;
}

// ====== GetWeaponModel ======
GetWeaponModel(weaponid) {
    new const g_aWeaponModels[] = {
		0, 331, 333, 334, 335, 336, 337, 338, 339, 341, 321, 322, 323, 324,
		325, 326, 342, 343, 344, 0, 0, 0, 346, 347, 348, 349, 350, 351, 352,
		353, 355, 356, 372, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366,
		367, 368, 368, 371
    };
    if (1 <= weaponid <= 46)
        return g_aWeaponModels[weaponid];

	return 0;
}
