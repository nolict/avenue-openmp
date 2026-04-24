/*
    File: modules/system/logic/detectors.pwn
    Purpose: Contains system gameplay logic and helper functions for detectors.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== Detector Schema ======
/*CREATE TABLE `detectors` (
	`detectorID` INT(12) AUTO_INCREMENT,
	`detectorX` FLOAT DEFAULT 0.0,
	`detectorY` FLOAT DEFAULT 0.0,
	`detectorZ` FLOAT DEFAULT 0.0,
	`detectorAngle` FLOAT DEFAULT 0.0,
	`detectorInterior` INT(12) DEFAULT 0,
	`detectorWorld` INT(12) DEFAULT 0,
	PRIMARY KEY(`detectorID`)
);*/

// ====== Detector_Delete ======
stock Detector_Delete(id)
{
    if (id != -1 && MetalDetectors[id][detectorExists])
	{
	    new
	        query[64];

	    DestroyDynamicObject(MetalDetectors[id][detectorObject][0]);
	    DestroyDynamicObject(MetalDetectors[id][detectorObject][1]);

		format(query, sizeof(query), "DELETE FROM `detectors` WHERE `detectorID` = '%d'", MetalDetectors[id][detectorID]);
		mysql_tquery(g_iHandle, query);

		MetalDetectors[id][detectorID] = 0;
		MetalDetectors[id][detectorExists] = 0;
	}
	return 1;
}

// ====== Detector_Refresh ======
stock Detector_Refresh(id)
{
	if (id != -1 && MetalDetectors[id][detectorExists])
	{
	    MetalDetectors[id][detectorObject][0] = CreateDynamicObject(2412, MetalDetectors[id][detectorPos][0], MetalDetectors[id][detectorPos][1], MetalDetectors[id][detectorPos][2] - 0.9, 0.0, 0.0, MetalDetectors[id][detectorPos][3], MetalDetectors[id][detectorWorld], MetalDetectors[id][detectorInterior]);
		MetalDetectors[id][detectorObject][1] = CreateDynamicObject(2412, MetalDetectors[id][detectorPos][0] + (1.0 * floatsin(-(MetalDetectors[id][detectorPos][3] - 90), degrees)), MetalDetectors[id][detectorPos][1] + (1.0 * floatcos(-(MetalDetectors[id][detectorPos][3] - 90), degrees)), MetalDetectors[id][detectorPos][2] - 0.9, 0.0, 0.0, MetalDetectors[id][detectorPos][3], MetalDetectors[id][detectorWorld], MetalDetectors[id][detectorInterior]);
	}
	return 1;
}

// ====== Detector_Nearest ======
stock Detector_Nearest(playerid)
{
    for (new i = 0; i < MAX_METAL_DETECTORS; i ++) if (MetalDetectors[i][detectorExists])
	{
	    if (IsPlayerInRangeOfPoint(playerid, 1.0, MetalDetectors[i][detectorPos][0], MetalDetectors[i][detectorPos][1], MetalDetectors[i][detectorPos][2]) && GetPlayerInterior(playerid) == MetalDetectors[i][detectorInterior] && GetPlayerVirtualWorld(playerid) == MetalDetectors[i][detectorWorld])
	        return i;
	}
	return -1;
}
forward Detector_Load();

// ====== Detector_Load ======
public Detector_Load()
{
	static
	    rows,
	    fields;

	cache_get_data(rows, fields, g_iHandle);

	for (new i = 0; i < rows; i ++) if (i < MAX_METAL_DETECTORS)
	{
    	MetalDetectors[i][detectorExists] = 1;
	    MetalDetectors[i][detectorID] = cache_get_field_int(i, "detectorID");
	    MetalDetectors[i][detectorPos][0] = cache_get_field_float(i, "detectorX");
	    MetalDetectors[i][detectorPos][1] = cache_get_field_float(i, "detectorY");
	    MetalDetectors[i][detectorPos][2] = cache_get_field_float(i, "detectorZ");
	    MetalDetectors[i][detectorPos][3] = cache_get_field_float(i, "detectorAngle");
	    MetalDetectors[i][detectorInterior] = cache_get_field_int(i, "detectorInterior");
	    MetalDetectors[i][detectorWorld] = cache_get_field_int(i, "detectorWorld");

		Detector_Refresh(i);
	}
	return 1;
}

