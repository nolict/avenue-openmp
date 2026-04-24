/*
    File: modules/system/data/inventory.pwn
    Purpose: Defines system data structures, constants, static arrays, or runtime storage for inventory.
    Notes: Do not place command handlers, dialogs, mapping objects, or heavy gameplay flows in data files.
*/


// ====== Inventory System Constants ======
enum e_InventoryItems {
    e_InventoryItem[32],
    e_InventoryModel
};

new const g_aInventoryItems[][e_InventoryItems] = {
    {"Marijuana", 1578},
    {"Cocaine", 1575},
    {"Heroin", 1577},
    {"Steroids", 1241},
    {"Marijuana Seeds", 1578},
    {"Cocaine Seeds", 1575},
    {"Heroin Opium Seeds", 1577},
    {"Golf Club", 333},
    {"Knife", 335},
    {"Shovel", 337},
    {"Katana", 339},
    {"Colt 45", 346},
    {"Desert Eagle", 348},
    {"Micro SMG", 352},
    {"Tec-9", 372},
    {"MP5", 353},
    {"Shotgun", 349},
    {"AK-47", 355},
    {"Rifle", 357},
    {"Sniper", 358},
    {"Magazine", 2039},
    {"Cooked Burger", 2703},
    {"Cooked Pizza", 2702},
    {"Driving License", 1581},
    //{"Weapon License", 1581},
    {"Cellphone", 330},
    {"GPS System", 18875},
    {"Spray Can", 365},
    {"Water Bottle", 2958},
    {"Soda", 1543},
    {"Fuel Can", 1650},
    {"Crowbar", 18634},
    {"Boombox", 2226},
    {"Mask", 19036},
    {"First Aid", 1580},
    {"Repair Kit", 920},
    {"NOS Canister", 1010},
    {"Frozen Pizza", 2814},
    {"Frozen Burger", 2768},
    {"Ammo Cartridge", 2358},
    {"Armored Vest", 19142},
    {"Empty Bottle", 1484},
    {"Cardboard", 928},
    {"Chicken", 2663},
    {"Portable Radio", 18868}
};

new InventoryData[MAX_PLAYERS][MAX_INVENTORY][inventoryData];
