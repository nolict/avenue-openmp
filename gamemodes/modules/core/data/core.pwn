/*
    File: modules/core/data/core.pwn
    Purpose: Defines core data structures, constants, static arrays, or runtime storage for core.
    Notes: Do not place command handlers, dialogs, mapping objects, or heavy gameplay flows in data files.
*/

// ====== Core Data ======
new g_iHandle;
new TruckingCheck[MAX_PLAYERS];
new Text3D:vehicle3Dtext[MAX_VEHICLES];
new vehiclecallsign[MAX_VEHICLES];

// ====== Core Global Variables ======
new g_StatusOOC;
new g_TaxVault;
new g_ServerLocked;
new g_ServerRestart;
new g_RestartTime;
