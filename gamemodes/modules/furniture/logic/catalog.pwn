/*
    File: modules/furniture/logic/catalog.pwn
    Purpose: Contains furniture gameplay logic and helper functions for catalog.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== IsFurnitureItem ======
stock IsFurnitureItem(item[])
{
    for (new i = 0; i < sizeof(g_aFurnitureData); i ++) if (!strcmp(g_aFurnitureData[i][e_FurnitureName], item)) {
        return 1;
	}
	return 0;
}

// ====== GetFurnitureNameByModel ======
stock GetFurnitureNameByModel(model)
{
	new
	    name[32];

	for (new i = 0; i < sizeof(g_aFurnitureData); i ++) if (g_aFurnitureData[i][e_FurnitureModel] == model) {
		strcat(name, g_aFurnitureData[i][e_FurnitureName]);

		break;
	}
	return name;
}
// ====== OnLoadFurniture ======
forward OnLoadFurniture(houseid);

// ====== OnLoadFurniture ======
public OnLoadFurniture(houseid)
{
	static
	    rows,
	    fields,
		id = -1;

	cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i != rows; i ++) if ((id = Furniture_GetFreeID()) != -1) {
	    FurnitureData[id][furnitureExists] = true;
	    FurnitureData[id][furnitureHouse] = houseid;

	    cache_get_field_content(i, "furnitureName", FurnitureData[id][furnitureName], g_iHandle, 32);

	    FurnitureData[id][furnitureID] = cache_get_field_int(i, "furnitureID");
	    FurnitureData[id][furnitureModel] = cache_get_field_int(i, "furnitureModel");
	    FurnitureData[id][furniturePos][0] = cache_get_field_float(i, "furnitureX");
	    FurnitureData[id][furniturePos][1] = cache_get_field_float(i, "furnitureY");
	    FurnitureData[id][furniturePos][2] = cache_get_field_float(i, "furnitureZ");
	    FurnitureData[id][furnitureRot][0] = cache_get_field_float(i, "furnitureRX");
	    FurnitureData[id][furnitureRot][1] = cache_get_field_float(i, "furnitureRY");
	    FurnitureData[id][furnitureRot][2] = cache_get_field_float(i, "furnitureRZ");

	    Furniture_Refresh(id);
	}
	return 1;
}

// ====== Furniture_GetCount ======
Furniture_GetCount(houseid)
{
	new count;

	for (new i = 0; i < MAX_FURNITURE; i ++) if (FurnitureData[i][furnitureExists] && FurnitureData[i][furnitureHouse] == houseid) {
	    count++;
	}
	return count;
}

// ====== Furniture_GetFreeID ======
Furniture_GetFreeID()
{
	for (new i = 0; i != MAX_FURNITURE; i ++) if (!FurnitureData[i][furnitureExists]) {
	    return i;
	}
	return -1;
}

// ====== Furniture_Refresh ======
Furniture_Refresh(furnitureid)
{
	if (furnitureid != -1 && FurnitureData[furnitureid][furnitureExists])
	{
	    if (IsValidDynamicObject(FurnitureData[furnitureid][furnitureObject]))
	        DestroyDynamicObject(FurnitureData[furnitureid][furnitureObject]);

	    FurnitureData[furnitureid][furnitureObject] = CreateDynamicObject(
			FurnitureData[furnitureid][furnitureModel],
			FurnitureData[furnitureid][furniturePos][0],
			FurnitureData[furnitureid][furniturePos][1],
			FurnitureData[furnitureid][furniturePos][2],
			FurnitureData[furnitureid][furnitureRot][0],
			FurnitureData[furnitureid][furnitureRot][1],
			FurnitureData[furnitureid][furnitureRot][2],
			HouseData[FurnitureData[furnitureid][furnitureHouse]][houseID] + 5000,
			HouseData[FurnitureData[furnitureid][furnitureHouse]][houseInterior]
		);
	}
	return 1;
}

// ====== Furniture_Save ======
Furniture_Save(furnitureid)
{
	static
	    string[300];

	format(string, sizeof(string), "UPDATE `furniture` SET `furnitureModel` = '%d', `furnitureName` = '%s', `furnitureX` = '%.4f', `furnitureY` = '%.4f', `furnitureZ` = '%.4f', `furnitureRX` = '%.4f', `furnitureRY` = '%.4f', `furnitureRZ` = '%.4f' WHERE `ID` = '%d' AND `furnitureID` = '%d'",
	    FurnitureData[furnitureid][furnitureModel],
	    FurnitureData[furnitureid][furnitureName],
	    FurnitureData[furnitureid][furniturePos][0],
	    FurnitureData[furnitureid][furniturePos][1],
	    FurnitureData[furnitureid][furniturePos][2],
	    FurnitureData[furnitureid][furnitureRot][0],
	    FurnitureData[furnitureid][furnitureRot][1],
	    FurnitureData[furnitureid][furnitureRot][2],
	    HouseData[FurnitureData[furnitureid][furnitureHouse]][houseID],
	    FurnitureData[furnitureid][furnitureID]
	);
	return mysql_tquery(g_iHandle, string);
}

// ====== Furniture_Add ======
Furniture_Add(houseid, name[], modelid, Float:x, Float:y, Float:z, Float:rx = 0.0, Float:ry = 0.0, Float:rz = 0.0)
{
	static
	    string[64],
		id = -1;

 	if (houseid == -1 || !HouseData[houseid][houseExists])
	    return 0;

	if ((id = Furniture_GetFreeID()) != -1)
	{
	    FurnitureData[id][furnitureExists] = true;
	    format(FurnitureData[id][furnitureName], 32, name);

        FurnitureData[id][furnitureHouse] = houseid;
	    FurnitureData[id][furnitureModel] = modelid;
	    FurnitureData[id][furniturePos][0] = x;
	    FurnitureData[id][furniturePos][1] = y;
	    FurnitureData[id][furniturePos][2] = z;
	    FurnitureData[id][furnitureRot][0] = rx;
	    FurnitureData[id][furnitureRot][1] = ry;
	    FurnitureData[id][furnitureRot][2] = rz;

	    Furniture_Refresh(id);

		format(string, sizeof(string), "INSERT INTO `furniture` (`ID`) VALUES(%d)", HouseData[houseid][houseID]);
		mysql_tquery(g_iHandle, string, "OnFurnitureCreated", "d", id);

		return id;
	}
	return -1;
}

// ====== Furniture_Delete ======
Furniture_Delete(furnitureid)
{
	static
	    string[72];

	if (furnitureid != -1 && FurnitureData[furnitureid][furnitureExists])
	{
	    format(string, sizeof(string), "DELETE FROM `furniture` WHERE `ID` = '%d' AND `furnitureID` = '%d'", HouseData[FurnitureData[furnitureid][furnitureHouse]][houseID], FurnitureData[furnitureid][furnitureID]);
		mysql_tquery(g_iHandle, string);

		FurnitureData[furnitureid][furnitureExists] = false;
		FurnitureData[furnitureid][furnitureModel] = 0;

		DestroyDynamicObject(FurnitureData[furnitureid][furnitureObject]);
	}
	return 1;
}

// ====== House_RemoveFurniture ======
House_RemoveFurniture(houseid)
{
	if (HouseData[houseid][houseExists])
	{
	    static
	        string[64];

	    for (new i = 0; i != MAX_FURNITURE; i ++) if (FurnitureData[i][furnitureExists] && FurnitureData[i][furnitureHouse] == houseid) {
	        FurnitureData[i][furnitureExists] = false;
	        FurnitureData[i][furnitureModel] = 0;
            FurnitureData[i][furnitureHouse] = -1;

	        DestroyDynamicObject(FurnitureData[i][furnitureObject]);
		}
		format(string, sizeof(string), "DELETE FROM `furniture` WHERE `ID` = '%d'", HouseData[houseid][houseID]);
		mysql_tquery(g_iHandle, string);
	}
	return 1;
}

// ====== Business_ProductMenu ======
Business_ProductMenu(playerid, bizid)
{
	if (bizid == -1 || !BusinessData[bizid][bizExists])
	    return 0;

	static
	    string[512];

	switch (BusinessData[bizid][bizType])
	{
	    case 1, 6:
	    {
			format(string, sizeof(string), "Mobile Phone - %s\nGPS System - %s\nSpray Paint - %s\nBackpack - %s\nWater Bottle - %s\nSoda Bottle - %s\nLottery Ticket - %s\nPortable Radio - %s\nCan of Fuel - %s\nCrowbar - %s\nBoombox - %s\nMask - %s\nFirst Aid Kit - %s\nRepair Kit - %s\nNOS Canister - %s\nBaseball Bat - %s\nFrozen Pizza - %s\nFrozen Burger - %s",
				FormatNumber(BusinessData[bizid][bizPrices][0]),
				FormatNumber(BusinessData[bizid][bizPrices][1]),
				FormatNumber(BusinessData[bizid][bizPrices][2]),
				FormatNumber(BusinessData[bizid][bizPrices][3]),
				FormatNumber(BusinessData[bizid][bizPrices][4]),
				FormatNumber(BusinessData[bizid][bizPrices][5]),
				FormatNumber(BusinessData[bizid][bizPrices][6]),
				FormatNumber(BusinessData[bizid][bizPrices][7]),
				FormatNumber(BusinessData[bizid][bizPrices][8]),
				FormatNumber(BusinessData[bizid][bizPrices][9]),
				FormatNumber(BusinessData[bizid][bizPrices][10]),
				FormatNumber(BusinessData[bizid][bizPrices][11]),
				FormatNumber(BusinessData[bizid][bizPrices][12]),
				FormatNumber(BusinessData[bizid][bizPrices][13]),
				FormatNumber(BusinessData[bizid][bizPrices][14]),
				FormatNumber(BusinessData[bizid][bizPrices][15]),
				FormatNumber(BusinessData[bizid][bizPrices][16]),
				FormatNumber(BusinessData[bizid][bizPrices][17])
			);
			Dialog_Show(playerid, EditProduct, DIALOG_STYLE_LIST, "Business: Modify Item", string, "Modify", "Cancel");
		}
		case 2:
	    {
			format(string, sizeof(string), "Magazine - %s\nAmmo Cartridge - %s\nArmored Vest - %s\nDesert Eagle - %s\nRemington 870 - %s\nM14 Rifle - %s",
				FormatNumber(BusinessData[bizid][bizPrices][0]),
				FormatNumber(BusinessData[bizid][bizPrices][1]),
				FormatNumber(BusinessData[bizid][bizPrices][2]),
				FormatNumber(BusinessData[bizid][bizPrices][3]),
				FormatNumber(BusinessData[bizid][bizPrices][4]),
				FormatNumber(BusinessData[bizid][bizPrices][5])
			);
			Dialog_Show(playerid, EditProduct, DIALOG_STYLE_LIST, "Business: Modify Item", string, "Modify", "Cancel");
		}
		case 3:
	    {
			format(string, sizeof(string), "Clothes - %s\nGlasses - %s\nHats - %s\nBandana - %s",
				FormatNumber(BusinessData[bizid][bizPrices][0]),
				FormatNumber(BusinessData[bizid][bizPrices][1]),
				FormatNumber(BusinessData[bizid][bizPrices][2]),
				FormatNumber(BusinessData[bizid][bizPrices][3])
			);
			Dialog_Show(playerid, EditProduct, DIALOG_STYLE_LIST, "Business: Modify Item", string, "Modify", "Cancel");
		}
		case 4:
	    {
			format(string, sizeof(string), "Water - %s\nSoda - %s\nFrench Fries - %s\nCheeseburger - %s\nChicken Burger - %s\nChicken Nuggets - %s\nSalad - %s",
    			FormatNumber(BusinessData[bizid][bizPrices][0]),
				FormatNumber(BusinessData[bizid][bizPrices][1]),
				FormatNumber(BusinessData[bizid][bizPrices][2]),
				FormatNumber(BusinessData[bizid][bizPrices][3]),
				FormatNumber(BusinessData[bizid][bizPrices][4]),
				FormatNumber(BusinessData[bizid][bizPrices][5]),
				FormatNumber(BusinessData[bizid][bizPrices][6])
			);
			Dialog_Show(playerid, EditProduct, DIALOG_STYLE_LIST, "Business: Modify Item", string, "Modify", "Cancel");
		}
		case 7:
	    {
	        string[0] = 0;

	        for (new i = 0; i < sizeof(g_aFurnitureTypes); i ++) {
	            format(string, sizeof(string), "%s%s - %s\n", string, g_aFurnitureTypes[i], FormatNumber(BusinessData[bizid][bizPrices][i]));
			}
			Dialog_Show(playerid, EditProduct, DIALOG_STYLE_LIST, "Business: Modify Item", string, "Modify", "Cancel");
		}
	}
	return 1;
}

// ====== Business_PurchaseMenu ======
Business_PurchaseMenu(playerid, bizid)
{
	if (bizid == -1 || !BusinessData[bizid][bizExists])
	    return 0;

	static
	    string[512];

	switch (BusinessData[bizid][bizType])
	{
	    case 1, 6:
	    {
			format(string, sizeof(string), "Mobile Phone - %s\nGPS System - %s\nSpray Paint - %s\nBackpack - %s\nWater Bottle - %s\nSoda Bottle - %s\nLottery Ticket - %s\nPortable Radio - %s\nCan of Fuel - %s\nCrowbar - %s\nBoombox - %s\nMask - %s\nFirst Aid Kit - %s\nRepair Kit - %s\nNOS Canister - %s\nBaseball Bat - %s\nFrozen Pizza - %s\nFrozen Burger - %s",
				FormatNumber(BusinessData[bizid][bizPrices][0]),
				FormatNumber(BusinessData[bizid][bizPrices][1]),
				FormatNumber(BusinessData[bizid][bizPrices][2]),
				FormatNumber(BusinessData[bizid][bizPrices][3]),
				FormatNumber(BusinessData[bizid][bizPrices][4]),
				FormatNumber(BusinessData[bizid][bizPrices][5]),
				FormatNumber(BusinessData[bizid][bizPrices][6]),
				FormatNumber(BusinessData[bizid][bizPrices][7]),
				FormatNumber(BusinessData[bizid][bizPrices][8]),
				FormatNumber(BusinessData[bizid][bizPrices][9]),
				FormatNumber(BusinessData[bizid][bizPrices][10]),
				FormatNumber(BusinessData[bizid][bizPrices][11]),
				FormatNumber(BusinessData[bizid][bizPrices][12]),
				FormatNumber(BusinessData[bizid][bizPrices][13]),
				FormatNumber(BusinessData[bizid][bizPrices][14]),
				FormatNumber(BusinessData[bizid][bizPrices][15]),
				FormatNumber(BusinessData[bizid][bizPrices][16]),
				FormatNumber(BusinessData[bizid][bizPrices][17])
			);
			Dialog_Show(playerid, BusinessBuy, DIALOG_STYLE_LIST, BusinessData[bizid][bizName], string, "Purchase", "Cancel");
		}
		case 2:
	    {
			format(string, sizeof(string), "Magazine - %s\nAmmo Cartridge - %s\nArmored Vest - %s\nDesert Eagle - %s\nRemington 870 - %s\nM14 Rifle - %s",
				FormatNumber(BusinessData[bizid][bizPrices][0]),
				FormatNumber(BusinessData[bizid][bizPrices][1]),
				FormatNumber(BusinessData[bizid][bizPrices][2]),
				FormatNumber(BusinessData[bizid][bizPrices][3]),
				FormatNumber(BusinessData[bizid][bizPrices][4]),
				FormatNumber(BusinessData[bizid][bizPrices][5])
			);
			Dialog_Show(playerid, BusinessBuy, DIALOG_STYLE_LIST, BusinessData[bizid][bizName], string, "Purchase", "Cancel");
		}
		case 3:
	    {
			format(string, sizeof(string), "Clothes - %s\nGlasses - %s\nHats - %s\nBandana - %s",
				FormatNumber(BusinessData[bizid][bizPrices][0]),
				FormatNumber(BusinessData[bizid][bizPrices][1]),
				FormatNumber(BusinessData[bizid][bizPrices][2]),
				FormatNumber(BusinessData[bizid][bizPrices][3])
			);
			Dialog_Show(playerid, BusinessBuy, DIALOG_STYLE_LIST, BusinessData[bizid][bizName], string, "Purchase", "Cancel");
		}
		case 4:
		{
            format(string, sizeof(string), "Water - %s\nSoda - %s\nFrench Fries - %s\nCheeseburger - %s\nChicken Burger - %s\nChicken Nuggets - %s\nSalad - %s",
    			FormatNumber(BusinessData[bizid][bizPrices][0]),
				FormatNumber(BusinessData[bizid][bizPrices][1]),
				FormatNumber(BusinessData[bizid][bizPrices][2]),
				FormatNumber(BusinessData[bizid][bizPrices][3]),
				FormatNumber(BusinessData[bizid][bizPrices][4]),
				FormatNumber(BusinessData[bizid][bizPrices][5]),
				FormatNumber(BusinessData[bizid][bizPrices][6])
			);
			Dialog_Show(playerid, BusinessBuy, DIALOG_STYLE_LIST, BusinessData[bizid][bizName], string, "Purchase", "Cancel");
		}
		case 7:
	    {
	        string[0] = 0;

	        for (new i = 0; i < sizeof(g_aFurnitureTypes); i ++) {
	            format(string, sizeof(string), "%s%s - %s\n", string, g_aFurnitureTypes[i], FormatNumber(BusinessData[bizid][bizPrices][i]));
			}
			Dialog_Show(playerid, BusinessBuy, DIALOG_STYLE_LIST, BusinessData[bizid][bizName], string, "Purchase", "Cancel");
		}
	}
	return 1;
}
