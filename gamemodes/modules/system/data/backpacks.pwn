/*
    File: modules/system/data/backpacks.pwn
    Purpose: Defines system data structures, constants, static arrays, or runtime storage for backpacks.
    Notes: Do not place command handlers, dialogs, mapping objects, or heavy gameplay flows in data files.
*/

// ====== Backpack Data ======
new BackpackData[MAX_BACKPACKS][backpackData];
new BackpackItems[MAX_BACKPACK_ITEMS][backpackItems];
new BackpackListed[MAX_PLAYERS][MAX_BACKPACK_CAPACITY];
