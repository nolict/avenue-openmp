/*
    File: modules/system/logic/blood.pwn
    Purpose: Contains system gameplay logic and helper functions for blood.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== DestroyBlood ======
forward DestroyBlood(objectid);

// ====== DestroyBlood ======
public DestroyBlood(objectid)
{
	DestroyDynamicObject(objectid);
}

// ====== CreateBlood ======
stock CreateBlood(playerid)
{
	new
	    Float:x,
	    Float:y,
	    Float:z;

	GetPlayerPos(playerid, x, y, z);
	SetTimerEx("DestroyBlood", 1500, false, "d", CreateDynamicObject(18668, x, y, z - 1.5, 0.0, 0.0, 0.0));

	return 1;
}
