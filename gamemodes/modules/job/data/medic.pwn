/*
    File: modules/job/data/medic.pwn
    Purpose: Defines job data structures, constants, static arrays, or runtime storage for medic.
    Notes: Do not place command handlers, dialogs, mapping objects, or heavy gameplay flows in data files.
*/

// ====== Medic Job Data ======
new const Float:arrHospitalDeliver[6][3] = {
    {-2692.6580, 635.4608, 14.4531},
    {-334.9757, 1063.0171, 19.7392},
    {1579.9666, 1767.1462, 10.8203},
    {1177.8599, -1308.3982, 13.8301},
    {2024.4246, -1404.1580, 17.2020},
    {1243.9304, 331.4186, 19.5547}
};

new const Float:arrHospitalSpawns[6][4] = {
    {-2655.1240, 638.6232, 14.4531, 180.0000},
    {-318.8799, 1049.2433, 20.3403, 0.0000},
    {1607.4869, 1816.0693, 10.8203, 0.0000},
    {1172.8372, -1325.3186, 15.4000, 270.0000},
    {2034.0670, -1402.6815, 17.2938, 180.0000},
    {1241.6802, 326.4038, 19.7555, 335.0000}
};
