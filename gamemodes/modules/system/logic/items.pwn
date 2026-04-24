/*
    File: modules/system/logic/items.pwn
    Purpose: Contains system gameplay logic and helper functions for items.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== DropPlayerItem ======
DropPlayerItem(playerid, itemid, quantity = 1)
{
	if (itemid == -1 || !InventoryData[playerid][itemid][invExists])
	    return 0;

    new
		Float:x,
  		Float:y,
    	Float:z,
		Float:angle,
		string[32];

	strunpack(string, InventoryData[playerid][itemid][invItem]);

	if (InventoryData[playerid][itemid][invQuantity] < 2)
	{
		if (!strcmp(string, "Colt 45") && PlayerData[playerid][pHoldWeapon] == 22)
			HoldWeapon(playerid, 0);

		else if (!strcmp(string, "Desert Eagle") && PlayerData[playerid][pHoldWeapon] == 24)
			HoldWeapon(playerid, 0);

		else if (!strcmp(string, "Shotgun") && PlayerData[playerid][pHoldWeapon] == 25)
			HoldWeapon(playerid, 0);

		else if (!strcmp(string, "Micro SMG") && PlayerData[playerid][pHoldWeapon] == 28)
			HoldWeapon(playerid, 0);

		else if (!strcmp(string, "MP5") && PlayerData[playerid][pHoldWeapon] == 29)
			HoldWeapon(playerid, 0);

		else if (!strcmp(string, "Tec-9") && PlayerData[playerid][pHoldWeapon] == 32)
			HoldWeapon(playerid, 0);

		else if (!strcmp(string, "AK-47") && PlayerData[playerid][pHoldWeapon] == 30)
			HoldWeapon(playerid, 0);

	 	else if (!strcmp(string, "Rifle") && PlayerData[playerid][pHoldWeapon] == 33)
		 	HoldWeapon(playerid, 0);

		else if (!strcmp(string, "Sniper") && PlayerData[playerid][pHoldWeapon] == 34)
			HoldWeapon(playerid, 0);
	}
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);

	DropItem(string, ReturnName(playerid, 0), InventoryData[playerid][itemid][invModel], quantity, x, y, z - 0.9, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
 	Inventory_Remove(playerid, string, quantity);

	ApplyAnimation(playerid, "GRENADE", "WEAPON_throwu", 4.1, 0, 0, 0, 0, 0, 1);
 	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has dropped a \"%s\".", ReturnName(playerid, 0), string);
	return 1;
}

// ====== DropItem ======
DropItem(item[], player[], model, quantity, Float:x, Float:y, Float:z, interior, world, weaponid = 0, ammo = 0)
{
	new
	    query[300];

	for (new i = 0; i != MAX_DROPPED_ITEMS; i ++) if (!DroppedItems[i][droppedModel])
	{
	    format(DroppedItems[i][droppedItem], 32, item);
	    format(DroppedItems[i][droppedPlayer], 24, player);

		DroppedItems[i][droppedModel] = model;
		DroppedItems[i][droppedQuantity] = quantity;
		DroppedItems[i][droppedWeapon] = weaponid;
  		DroppedItems[i][droppedAmmo] = ammo;
		DroppedItems[i][droppedPos][0] = x;
		DroppedItems[i][droppedPos][1] = y;
		DroppedItems[i][droppedPos][2] = z;

		DroppedItems[i][droppedInt] = interior;
		DroppedItems[i][droppedWorld] = world;

		if (IsWeaponModel(model)) {
			DroppedItems[i][droppedObject] = CreateDynamicObject(model, x, y, z, 93.7, 120.0, 120.0, world, interior);
		} else {
			DroppedItems[i][droppedObject] = CreateDynamicObject(model, x, y, z, 0.0, 0.0, 0.0, world, interior);
		}
 		DroppedItems[i][droppedText3D] = CreateDynamic3DTextLabel(item, COLOR_CYAN, x, y, z, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, world, interior);

		if (strcmp(item, "Demo Soda") != 0)
		{
	 		format(query, sizeof(query), "INSERT INTO `dropped` (`itemName`, `itemPlayer`, `itemModel`, `itemQuantity`, `itemWeapon`, `itemAmmo`, `itemX`, `itemY`, `itemZ`, `itemInt`, `itemWorld`) VALUES('%s', '%s', '%d', '%d', '%d', '%d', '%.4f', '%.4f', '%.4f', '%d', '%d')", item, player, model, quantity, weaponid, ammo, x, y, z, interior, world);
			mysql_tquery(g_iHandle, query, "OnDroppedItem", "d", i);
		}
		return i;
	}
	return -1;
}

// ====== Item_Nearest ======
Item_Nearest(playerid)
{
    for (new i = 0; i != MAX_DROPPED_ITEMS; i ++) if (DroppedItems[i][droppedModel] && IsPlayerInRangeOfPoint(playerid, 1.5, DroppedItems[i][droppedPos][0], DroppedItems[i][droppedPos][1], DroppedItems[i][droppedPos][2]))
	{
	    if (GetPlayerInterior(playerid) == DroppedItems[i][droppedInt] && GetPlayerVirtualWorld(playerid) == DroppedItems[i][droppedWorld])
	        return i;
	}
	return -1;
}

// ====== Item_SetQuantity ======
Item_SetQuantity(itemid, amount)
{
	new
	    string[64];

	if (itemid != -1 && DroppedItems[itemid][droppedModel])
	{
	    DroppedItems[itemid][droppedQuantity] = amount;

	    format(string, sizeof(string), "UPDATE `dropped` SET `itemQuantity` = %d WHERE `ID` = '%d'", amount, DroppedItems[itemid][droppedID]);
		mysql_tquery(g_iHandle, string);
	}
	return 1;
}

// ====== Item_Delete ======
Item_Delete(itemid)
{
    static
	    query[64];

    if (itemid != -1 && DroppedItems[itemid][droppedModel])
	{
        DroppedItems[itemid][droppedModel] = 0;
		DroppedItems[itemid][droppedQuantity] = 0;
	    DroppedItems[itemid][droppedPos][0] = 0.0;
	    DroppedItems[itemid][droppedPos][1] = 0.0;
	    DroppedItems[itemid][droppedPos][2] = 0.0;
	    DroppedItems[itemid][droppedInt] = 0;
	    DroppedItems[itemid][droppedWorld] = 0;

	    DestroyDynamicObject(DroppedItems[itemid][droppedObject]);
	    DestroyDynamic3DTextLabel(DroppedItems[itemid][droppedText3D]);

	    format(query, sizeof(query), "DELETE FROM `dropped` WHERE `ID` = '%d'", DroppedItems[itemid][droppedID]);
	    mysql_tquery(g_iHandle, query);
	}
	return 1;
}

// ====== PickupItem ======
PickupItem(playerid, itemid)
{
	if (itemid != -1 && DroppedItems[itemid][droppedModel])
	{
	    new id = Inventory_Add(playerid, DroppedItems[itemid][droppedItem], DroppedItems[itemid][droppedModel], DroppedItems[itemid][droppedQuantity]);

	    if (id == -1)
	        return SendErrorMessage(playerid, "You don't have any inventory slots left.");

	    Item_Delete(itemid);
	}
	return 1;
}
forward Dropped_Load();

// ====== Dropped_Load ======
public Dropped_Load()
{
	static
	    rows,
	    fields;

    cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i < rows; i ++) if (i < MAX_DROPPED_ITEMS)
	{
	    DroppedItems[i][droppedID] = cache_get_field_int(i, "ID");

		cache_get_field_content(i, "itemName", DroppedItems[i][droppedItem], g_iHandle, 32);
		cache_get_field_content(i, "itemPlayer", DroppedItems[i][droppedPlayer], g_iHandle, 24);

		DroppedItems[i][droppedModel] = cache_get_field_int(i, "itemModel");
		DroppedItems[i][droppedQuantity] = cache_get_field_int(i, "itemQuantity");
		DroppedItems[i][droppedWeapon] = cache_get_field_int(i, "itemWeapon");
		DroppedItems[i][droppedAmmo] = cache_get_field_int(i, "itemAmmo");
		DroppedItems[i][droppedPos][0] = cache_get_field_float(i, "itemX");
		DroppedItems[i][droppedPos][1] = cache_get_field_float(i, "itemY");
		DroppedItems[i][droppedPos][2] = cache_get_field_float(i, "itemZ");
		DroppedItems[i][droppedInt] = cache_get_field_int(i, "itemInt");
		DroppedItems[i][droppedWorld] = cache_get_field_int(i, "itemWorld");

		if (IsWeaponModel(DroppedItems[i][droppedModel])) {
    	   	DroppedItems[i][droppedObject] = CreateDynamicObject(DroppedItems[i][droppedModel], DroppedItems[i][droppedPos][0], DroppedItems[i][droppedPos][1], DroppedItems[i][droppedPos][2], 93.7, 120.0, 120.0, DroppedItems[i][droppedWorld], DroppedItems[i][droppedInt]);
		} else {
			DroppedItems[i][droppedObject] = CreateDynamicObject(DroppedItems[i][droppedModel], DroppedItems[i][droppedPos][0], DroppedItems[i][droppedPos][1], DroppedItems[i][droppedPos][2], 0.0, 0.0, 0.0, DroppedItems[i][droppedWorld], DroppedItems[i][droppedInt]);
		}
		DroppedItems[i][droppedText3D] = CreateDynamic3DTextLabel(DroppedItems[i][droppedItem], COLOR_CYAN, DroppedItems[i][droppedPos][0], DroppedItems[i][droppedPos][1], DroppedItems[i][droppedPos][2], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, DroppedItems[i][droppedWorld], DroppedItems[i][droppedInt]);
	}
	return 1;
}

forward FirstAidUpdate(playerid);

// ====== FirstAidUpdate ======
public FirstAidUpdate(playerid)
{
	static
	    Float:health;

	GetPlayerHealth(playerid, health);

    if (!IsPlayerInAnyVehicle(playerid) && GetPlayerAnimationIndex(playerid) != 1508)
    	ApplyAnimation(playerid, "SWAT", "gnstwall_injurd", 4.0, 1, 0, 0, 0, 0);

	if (health >= 95.0)
	{
	    SetPlayerHealth(playerid, 100.0);
	    SendServerMessage(playerid, "Your first aid kit has been used up.");

		if (!IsPlayerInAnyVehicle(playerid)) {
	        PlayerData[playerid][pLoopAnim] = true;
			ShowPlayerFooter(playerid, "Press ~y~SPRINT~w~ to stop the animation.");
		}
        PlayerData[playerid][pBleeding] = 0;
		PlayerData[playerid][pBleedTime] = 0;

		PlayerData[playerid][pFirstAid] = false;
		KillTimer(PlayerData[playerid][pAidTimer]);
	}
	else {
	    SetPlayerHealth(playerid, floatadd(health, 4.0));
	}
	return 1;
}

