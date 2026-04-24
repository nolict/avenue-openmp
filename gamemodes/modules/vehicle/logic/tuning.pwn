/*
    File: modules/vehicle/logic/tuning.pwn
    Purpose: Contains vehicle gameplay logic and helper functions for tuning.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== GetWheelName ======
stock GetWheelName(componentid)
{
	new
		name[12];

	enum g_eWheelData {
	    g_eWheelModel,
	    g_eWheelName[12 char]
	};

	new const g_aWheelData[][g_eWheelData] = {
	    {1025, !"Offroad"},
	    {1073, !"Shadow"},
	    {1074, !"Mega"},
	    {1075, !"Rimshine"},
	    {1076, !"Wires"},
	    {1077, !"Classic"},
	    {1078, !"Twist"},
	    {1079, !"Cutter"},
	    {1080, !"Switch"},
	    {1081, !"Grove"},
	    {1082, !"Import"},
	    {1083, !"Dollar"},
	    {1084, !"Trance"},
	    {1085, !"Atomic"},
	    {1096, !"Ahab"},
	    {1097, !"Virtual"},
	    {1098, !"Access"}
	};
	for (new i = 0; i < sizeof(g_aWheelData); i ++) if (g_aWheelData[i][g_eWheelModel] == componentid) {
	    strunpack(name, g_aWheelData[i][g_eWheelName]);

	    return name;
	}
	strunpack(name, !"Unknown");
	return name;
}

// ====== SetVehicleColor ======
stock SetVehicleColor(vehicleid, color1, color2)
{
    new id = Car_GetID(vehicleid);

	if (id != -1)
	{
	    CarData[id][carColor1] = color1;
	    CarData[id][carColor2] = color2;
	    Car_Save(id);
	}
	return ChangeVehicleColor(vehicleid, color1, color2);
}

// ====== SetVehiclePaintjob ======
stock SetVehiclePaintjob(vehicleid, paintjobid)
{
    new id = Car_GetID(vehicleid);

	if (id != -1)
	{
	    CarData[id][carPaintjob] = paintjobid;
	    Car_Save(id);
	}
	return ChangeVehiclePaintjob(vehicleid, paintjobid);
}

// ====== RemoveComponent ======
stock RemoveComponent(vehicleid, componentid)
{
	if (!IsValidVehicle(vehicleid) || (componentid < 1000 || componentid > 1193))
	    return 0;

	new
		id = Car_GetID(vehicleid);

	if (id != -1)
	{
	    CarData[id][carMods][GetVehicleComponentType(componentid)] = 0;
	    Car_Save(id);
	}
	return RemoveVehicleComponent(vehicleid, componentid);
}

// ====== AddComponent ======
stock AddComponent(vehicleid, componentid)
{
	if (!IsValidVehicle(vehicleid) || (componentid < 1000 || componentid > 1193))
	    return 0;

	new
		id = Car_GetID(vehicleid);

	if (id != -1)
	{
	    CarData[id][carMods][GetVehicleComponentType(componentid)] = componentid;
	    Car_Save(id);
	}
	return AddVehicleComponent(vehicleid, componentid);
}

// ====== IsWheelModel ======
stock IsWheelModel(modelid)
{
    switch (modelid) {
		case 1025, 1073..1085, 1096..1098: return 1;
	}
    return 0;
}

// ====== IsNOSCompatible ======
stock IsNOSCompatible(modelid)
{
	switch (modelid) {
	    case 581, 523, 462, 521, 463, 522, 461, 448, 468, 586, 509, 481, 510, 472, 473, 493, 595, 484, 430, 453, 452, 446, 454, 590, 569, 537, 538, 570, 449: return 0;
	}
    return 1;
}

// ====== IsLegalComponent ======
stock IsLegalComponent(modelid, componentid)
{
    if (IsWheelModel(componentid) || (1086 <= componentid <= 1087) || (componentid >= 1008 && componentid <= 1010))
	{
	    if (!IsNOSCompatible(modelid))
			return 1;
    }
	else
	{
	    for (new i = 0; i < sizeof(g_aLegalMods); i ++)
	    {
	        if (g_aLegalMods[i][0] != modelid)
				continue;

			else for (new l = 1; l < 22; l ++) if (g_aLegalMods[i][l] == componentid) {
			    return 1;
			}
		}
	}
	return 0;
}

// ====== ResprayCar ======
forward ResprayCar(playerid, vehicleid, color);

// ====== ResprayCar ======
public ResprayCar(playerid, vehicleid, color)
{
	if (!PlayerData[playerid][pLogged] || GetNearestVehicle(playerid) != vehicleid)
	    return 0;

	Inventory_Remove(playerid, "Spray Can");
	ClearAnimations(playerid);

	SetVehicleColor(vehicleid, color, color);
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has used a can of spray paint on the %s.", ReturnName(playerid, 0), ReturnVehicleName(vehicleid));
	return 1;
}
