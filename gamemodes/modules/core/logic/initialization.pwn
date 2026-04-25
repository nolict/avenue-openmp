/*
    File: modules/core/logic/initialization.pwn
    Purpose: Contains core gameplay logic and helper functions for initialization.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== OnGameModeInit ======
public OnGameModeInit()
{
	static
	    arrVirtualWorlds[2000],
		id = -1;

	WeatherRotator();

	SQL_Connect();
	ManualVehicleEngineAndLights();
	new rcon[80];
	format(rcon, sizeof(rcon), "hostname %s", SERVER_NAME);
	SendRconCommand(rcon);
	format(rcon, sizeof(rcon), "weburl %s", SERVER_URL);
	SendRconCommand(rcon);
	SetGameModeText(SERVER_REVISION);

	if (mysql_errno(g_iHandle) != 0)
	    return 0;

	Server_Load();
    mysql_tquery(g_iHandle, "SELECT * FROM `billboards`", "Billboard_Load", "");
	mysql_tquery(g_iHandle, "SELECT * FROM `houses`", "House_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `businesses`", "Business_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `dropped`", "Dropped_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `entrances`", "Entrance_Load", "");
	mysql_tquery(g_iHandle, "SELECT * FROM `cars`", "Car_Load", "");
	mysql_tquery(g_iHandle, "SELECT * FROM `jobs`", "Job_Load", "");
	mysql_tquery(g_iHandle, "SELECT * FROM `crates`", "Crate_Load", "");
	mysql_tquery(g_iHandle, "SELECT * FROM `plants`", "Plant_Load", "");
	mysql_tquery(g_iHandle, "SELECT * FROM `factions`", "Faction_Load", "");
	mysql_tquery(g_iHandle, "SELECT * FROM `arrestpoints`", "Arrest_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `gates`", "Gate_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `backpacks`", "Backpack_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `impoundlots`", "Impound_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `atm`", "ATM_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `garbage`", "Garbage_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `vendors`", "Vendor_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `gunracks`", "Rack_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `speedcameras`", "Speed_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `graffiti`", "Graffiti_Load", "");
    mysql_tquery(g_iHandle, "SELECT * FROM `detectors`", "Detector_Load", "");

    SetModelPreviewRotation(18875, 90.0, 180.0, 0.0);
    SetModelPreviewRotation(2703, -105.0, 0.0, -15.0);
    SetModelPreviewRotation(2702, 90.0, 90.0, 0.0);
    SetModelPreviewRotation(2814, -90.0, 0.0, -90.0);
    SetModelPreviewRotation(2768, -15.0, 0.0, -160.0);
    SetModelPreviewRotation(19142, -20.0, -90.0, 0.0);
    SetModelPreviewRotation(1581, 0.0, 0.0, 180.0);
    SetModelPreviewRotation(2958, -10.0, -15.0, 0.0);
    SetModelPreviewRotation(1575, 0.0, 0.0, 180.0);
    SetModelPreviewRotation(1577, 0.0, 0.0, 180.0);
    SetModelPreviewRotation(1578, 0.0, 0.0, 180.0);
    SetModelPreviewRotation(18634, 90.0, 90.0, 0.0);
    SetModelPreviewRotation(2043, 0.0, 0.0, 90.0);
    SetModelPreviewRotation(1484, -15.0, 30.0, 0.0);
    SetModelPreviewRotation(2226, 0.0, 0.0, 180.0);

	for (new i = 0; i < sizeof(arrVirtualWorlds); i ++) {
	    arrVirtualWorlds[i] = i + 7000;
	}
	CreateDynamicPickup(1581, 23, -2033.0439, -117.4885, 1035.1719);
	CreateDynamic3DTextLabel("[Driving Test]\n{FFFFFF}Type /drivingtest to start the test.", COLOR_DARKBLUE, -2033.0439, -117.4885, 1035.1719, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);

	CreateDynamicPickup(1239, 23, 1260.3976, -20.0215, 1001.0234);
	CreateDynamic3DTextLabel("[Cargo Unloading]\n{FFFFFF}Type /loadcrate to begin loading cargo.", COLOR_YELLOW, 1260.3976, -20.0215, 1001.0234, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);

    CreateDynamicPickupEx(1239, 23, 361.2687, 171.5613, 1008.3828, 100.0, arrVirtualWorlds);
	CreateDynamic3DTextLabel("[Tickets]\n{FFFFFF}Type /tickets to pay your tickets.", COLOR_DARKBLUE, 361.2687, 171.5613, 1008.3828, 10.0);

	CreateDynamicPickupEx(1239, 23, 361.8299, 173.5183, 1008.3828, 100.0, arrVirtualWorlds);
	CreateDynamic3DTextLabel("[Name Change]\n{FFFFFF}Type /changename to change your name.", COLOR_DARKBLUE, 361.8299, 173.5183, 1008.3828, 10.0);

	CreateDynamicPickupEx(1239, 23, 361.1653, 175.8127, 1008.3828, 100.0, arrVirtualWorlds);
	CreateDynamic3DTextLabel("[Car Release]\n{FFFFFF}Type /releasecar to release a vehicle.", COLOR_DARKBLUE, 361.1653, 175.8127, 1008.3828, 10.0);

	CreateDynamicPickup(1559, 23, 272.2939, 1388.8876, 11.8342);
	CreateDynamic3DTextLabel("San Andreas Prison", COLOR_DARKBLUE, 272.2939, 1388.8876, 11.1342, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1);

    CreateDynamicPickup(1559, 23, 1211.1923, -1354.3439, 797.4456);
	CreateDynamic3DTextLabel("Prison Yard", COLOR_DARKBLUE, 1211.1923, -1354.3439, 796.7456, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, PRISON_WORLD, 5);

	for (new i = 0; i < sizeof(arrBoothPositions); i ++) {
	    CreateDynamic3DTextLabel("[Shooting Range]\n{FFFFFF}Press 'F' to use this booth.", COLOR_DARKBLUE, arrBoothPositions[i][0], arrBoothPositions[i][1], arrBoothPositions[i][2], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, 7);
	}
	for (new i = 0; i < sizeof(arrHospitalSpawns); i ++) {
	    CreateDynamicMapIcon(arrHospitalSpawns[i][0], arrHospitalSpawns[i][1], arrHospitalSpawns[i][2], 22, 0);

		CreatePickup(1559, 23, arrHospitalSpawns[i][0], arrHospitalSpawns[i][1], arrHospitalSpawns[i][2] + 0.7);
		Create3DTextLabel("General Hospital", COLOR_DARKBLUE, arrHospitalSpawns[i][0], arrHospitalSpawns[i][1], arrHospitalSpawns[i][2], 15.0, 0);

		CreatePickup(1240, 23, arrHospitalDeliver[i][0], arrHospitalDeliver[i][1], arrHospitalDeliver[i][2]);
		Create3DTextLabel("[Hospital Deliver]\n{FFFFFF}/dropinjured to deliver a patient.", COLOR_DARKBLUE, arrHospitalDeliver[i][0], arrHospitalDeliver[i][1], arrHospitalDeliver[i][2], 15.0, 0);
	}
	Interface_CreateGlobalTextdraws();
	CharacterSelection_CreateActors();
	Mapping_LoadStaticWorld(arrVirtualWorlds, id);

	DisableInteriorEnterExits();
	EnableStuntBonusForAll(0);

	SetNameTagDrawDistance(10.0);
	ShowPlayerMarkers(0);

	UpdateTime();

	SetTimer("PlayerCheck", 1000, true);
	SetTimer("FuelUpdate", 50000, true);
	SetTimer("RefuelCheck", 500, true);
	SetTimer("LotteryUpdate", 2700000, true);
	SetTimer("MinuteCheck", 60000, true);
	SetTimer("WeatherRotator", 2400000, true);
	SetTimer("RandomFire", 1800000, true);

	return 1;
}
