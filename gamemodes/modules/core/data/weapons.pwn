/*
    File: modules/core/data/weapons.pwn
    Purpose: Defines core data structures, constants, static arrays, or runtime storage for weapons.
    Notes: Do not place command handlers, dialogs, mapping objects, or heavy gameplay flows in data files.
*/

// ====== Weapon Data ======
new const Float:g_arrWeaponDamage[] = {
    1.32, 1.32, 4.62, 4.62, 2.64, 4.62, 4.62, 4.62, 2.64, 13.53,
    4.62, 2.64, 4.62, 2.64, 4.62, 2.64, 0.00, 0.00, 0.00, 0.00,
    0.00, 0.00, 8.25, 13.2, 46.2, 49.5, 49.5, 39.6, 6.60, 8.25,
    9.90, 9.90, 6.60, 24.75, 41.25, 0.00, 0.00, 0.00, 46.2, 0.00,
    0.00, 2.64, 2.64, 0.00, 0.00, 0.00, 1.32
};

new const g_aWeaponSlots[] = {
    0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 10, 10, 8, 8, 8, 0, 0, 0, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 4, 6, 6, 7, 7, 7, 7, 8, 12, 9, 9, 9, 11, 11, 11
};
