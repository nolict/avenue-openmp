/*
    File: modules/system/data/firingrange.pwn
    Purpose: Defines system data structures, constants, static arrays, or runtime storage for firingrange.
    Notes: Do not place command handlers, dialogs, mapping objects, or heavy gameplay flows in data files.
*/

// ====== Firing Range Data ======
new g_BoothUsed[MAX_BOOTHS];
new g_BoothObject[MAX_BOOTHS] = {-1, ...};

new const Float:arrBoothPositions[MAX_BOOTHS][3] = {
    {300.5000, -138.5660, 1004.0625},
    {300.5000, -137.0286, 1004.0625},
    {300.5000, -135.5336, 1004.0625},
    {300.5000, -134.0436, 1004.0625},
    {300.5000, -132.5637, 1004.0625},
    {300.5000, -131.0782, 1004.0625},
    {300.5000, -129.5582, 1004.0625},
    {300.5000, -128.0786, 1004.0625}
};
