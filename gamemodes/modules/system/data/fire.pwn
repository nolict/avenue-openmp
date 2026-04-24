/*
    File: modules/system/data/fire.pwn
    Purpose: Defines system data structures, constants, static arrays, or runtime storage for fire.
    Notes: Do not place command handlers, dialogs, mapping objects, or heavy gameplay flows in data files.
*/

// ====== Fire System Data ======
new g_aFireObjects[36] = {INVALID_OBJECT_ID, ...};
new g_aFireExtinguished[36];
