/*
    File: modules/core/logic/flymode.pwn
    Purpose: Admin no-clip camera movement and coordinate capture helpers.
    Notes: Uses Texture-Studio style camera attachment to an invisible dynamic object.
*/

#define FLYMODE_MOVE_SPEED          (100.0)
#define FLYMODE_ACCEL_RATE          (0.03)
#define FLYMODE_LOOK_DISTANCE       (25.0)
#define FLYMODE_MOVE_OFFSET         (6000.0)
#define FLYMODE_ANALOG_DEADZONE     (32)
#define FLYMODE_AXIS_DOMINANCE      (2)

#define FLYMODE_MOVE_NONE           (0)
#define FLYMODE_MOVE_FORWARD        (1)
#define FLYMODE_MOVE_BACK           (2)
#define FLYMODE_MOVE_LEFT           (3)
#define FLYMODE_MOVE_RIGHT          (4)
#define FLYMODE_MOVE_FORWARD_LEFT   (5)
#define FLYMODE_MOVE_FORWARD_RIGHT  (6)
#define FLYMODE_MOVE_BACK_LEFT      (7)
#define FLYMODE_MOVE_BACK_RIGHT     (8)

new bool:g_FlyMode[MAX_PLAYERS];
new STREAMER_TAG_OBJECT:g_FlyModeObject[MAX_PLAYERS];
new g_FlyModeMoveMode[MAX_PLAYERS];
new g_FlyModeOldLR[MAX_PLAYERS];
new g_FlyModeOldUD[MAX_PLAYERS];
new g_FlyModeLastMove[MAX_PLAYERS];
new g_FlyModeLastCoordTick[MAX_PLAYERS];
new Float:g_FlyModeAccel[MAX_PLAYERS];

// ====== FlyMode_Abs ======
stock FlyMode_Abs(value)
{
	return (value < 0) ? (-value) : (value);
}

// ====== FlyMode_FilterAnalog ======
stock FlyMode_FilterAnalog(&updown, &leftright)
{
	new
	    absUD = FlyMode_Abs(updown),
	    absLR = FlyMode_Abs(leftright);

	if (absUD < FLYMODE_ANALOG_DEADZONE)
	{
	    updown = 0;
	    absUD = 0;
	}
	if (absLR < FLYMODE_ANALOG_DEADZONE)
	{
	    leftright = 0;
	    absLR = 0;
	}

	if (absUD >= FLYMODE_ANALOG_DEADZONE && absLR > 0 && absUD >= absLR * FLYMODE_AXIS_DOMINANCE)
	    leftright = 0;
	else if (absLR >= FLYMODE_ANALOG_DEADZONE && absUD > 0 && absLR >= absUD * FLYMODE_AXIS_DOMINANCE)
	    updown = 0;

	return 1;
}

// ====== FlyMode_GetCameraFacing ======
stock Float:FlyMode_GetCameraFacing(Float:vx, Float:vy)
{
	new Float:angle = -atan2(vx, vy);

	if (angle < 0.0)
	    angle += 360.0;

	return angle;
}

// ====== FlyMode_GetMoveDirection ======
stock FlyMode_GetMoveDirection(updown, leftright)
{
	new direction = FLYMODE_MOVE_NONE;

	if (leftright < 0)
	{
		if (updown < 0)
		    direction = FLYMODE_MOVE_FORWARD_LEFT;
		else if (updown > 0)
		    direction = FLYMODE_MOVE_BACK_LEFT;
		else
		    direction = FLYMODE_MOVE_LEFT;
	}
	else if (leftright > 0)
	{
		if (updown < 0)
		    direction = FLYMODE_MOVE_FORWARD_RIGHT;
		else if (updown > 0)
		    direction = FLYMODE_MOVE_BACK_RIGHT;
		else
		    direction = FLYMODE_MOVE_RIGHT;
	}
	else if (updown < 0)
	    direction = FLYMODE_MOVE_FORWARD;
	else if (updown > 0)
	    direction = FLYMODE_MOVE_BACK;

	return direction;
}

// ====== FlyMode_GetNextCameraPosition ======
stock FlyMode_GetNextCameraPosition(moveMode, Float:cameraPos[3], Float:frontVector[3], &Float:x, &Float:y, &Float:z)
{
	new
	    Float:offsetX = frontVector[0] * FLYMODE_MOVE_OFFSET,
	    Float:offsetY = frontVector[1] * FLYMODE_MOVE_OFFSET,
	    Float:offsetZ = frontVector[2] * FLYMODE_MOVE_OFFSET;

	switch (moveMode)
	{
		case FLYMODE_MOVE_FORWARD:
		{
			x = cameraPos[0] + offsetX;
			y = cameraPos[1] + offsetY;
			z = cameraPos[2] + offsetZ;
		}
		case FLYMODE_MOVE_BACK:
		{
			x = cameraPos[0] - offsetX;
			y = cameraPos[1] - offsetY;
			z = cameraPos[2] - offsetZ;
		}
		case FLYMODE_MOVE_LEFT:
		{
			x = cameraPos[0] - offsetY;
			y = cameraPos[1] + offsetX;
			z = cameraPos[2];
		}
		case FLYMODE_MOVE_RIGHT:
		{
			x = cameraPos[0] + offsetY;
			y = cameraPos[1] - offsetX;
			z = cameraPos[2];
		}
		case FLYMODE_MOVE_FORWARD_LEFT:
		{
			x = cameraPos[0] + offsetX - offsetY;
			y = cameraPos[1] + offsetY + offsetX;
			z = cameraPos[2] + offsetZ;
		}
		case FLYMODE_MOVE_FORWARD_RIGHT:
		{
			x = cameraPos[0] + offsetX + offsetY;
			y = cameraPos[1] + offsetY - offsetX;
			z = cameraPos[2] + offsetZ;
		}
		case FLYMODE_MOVE_BACK_LEFT:
		{
			x = cameraPos[0] - offsetX - offsetY;
			y = cameraPos[1] - offsetY + offsetX;
			z = cameraPos[2] - offsetZ;
		}
		case FLYMODE_MOVE_BACK_RIGHT:
		{
			x = cameraPos[0] - offsetX + offsetY;
			y = cameraPos[1] - offsetY - offsetX;
			z = cameraPos[2] - offsetZ;
		}
		default:
		{
			x = cameraPos[0];
			y = cameraPos[1];
			z = cameraPos[2];
		}
	}
	return 1;
}

// ====== FlyMode_StopMovement ======
stock FlyMode_StopMovement(playerid)
{
	if (!g_FlyMode[playerid])
	    return 0;

	if (IsValidDynamicObject(g_FlyModeObject[playerid]))
	    StopDynamicObject(g_FlyModeObject[playerid]);

	g_FlyModeMoveMode[playerid] = FLYMODE_MOVE_NONE;
	g_FlyModeAccel[playerid] = 0.0;
	g_FlyModeOldLR[playerid] = 0;
	g_FlyModeOldUD[playerid] = 0;
	return 1;
}

// ====== FlyMode_MoveCamera ======
stock FlyMode_MoveCamera(playerid)
{
	new
	    Float:frontVector[3],
	    Float:cameraPos[3],
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:speed;

	if (!g_FlyMode[playerid] || !IsValidDynamicObject(g_FlyModeObject[playerid]))
	    return 0;

	GetDynamicObjectPos(g_FlyModeObject[playerid], cameraPos[0], cameraPos[1], cameraPos[2]);
	GetPlayerCameraFrontVector(playerid, frontVector[0], frontVector[1], frontVector[2]);

	if (g_FlyModeAccel[playerid] <= 1.0)
	    g_FlyModeAccel[playerid] += FLYMODE_ACCEL_RATE;

	speed = FLYMODE_MOVE_SPEED * g_FlyModeAccel[playerid];

	FlyMode_GetNextCameraPosition(g_FlyModeMoveMode[playerid], cameraPos, frontVector, x, y, z);
	MoveDynamicObject(g_FlyModeObject[playerid], x, y, z, speed, 0.0, 0.0, 0.0);

	g_FlyModeLastMove[playerid] = GetTickCount();
	return 1;
}

// ====== FlyMode_UpdateCamera ======
stock FlyMode_UpdateCamera(playerid)
{
	new
	    keys,
	    updown,
	    leftright,
	    Float:cameraPos[3],
	    Float:frontVector[3],
	    Float:facing,
	    string[128];

	if (!g_FlyMode[playerid])
	    return 0;

	GetPlayerKeys(playerid, keys, updown, leftright);
	FlyMode_FilterAnalog(updown, leftright);

	if (g_FlyModeMoveMode[playerid] && GetTickCount() - g_FlyModeLastMove[playerid] > 100)
	    FlyMode_MoveCamera(playerid);

	if (g_FlyModeOldUD[playerid] != updown || g_FlyModeOldLR[playerid] != leftright)
	{
		if ((g_FlyModeOldUD[playerid] != 0 || g_FlyModeOldLR[playerid] != 0) && updown == 0 && leftright == 0)
		    FlyMode_StopMovement(playerid);
		else
		{
			g_FlyModeMoveMode[playerid] = FlyMode_GetMoveDirection(updown, leftright);
			FlyMode_MoveCamera(playerid);
		}
	}

	g_FlyModeOldUD[playerid] = updown;
	g_FlyModeOldLR[playerid] = leftright;

	if (GetTickCount() - g_FlyModeLastCoordTick[playerid] >= 1000)
	{
	    GetDynamicObjectPos(g_FlyModeObject[playerid], cameraPos[0], cameraPos[1], cameraPos[2]);
	    GetPlayerCameraFrontVector(playerid, frontVector[0], frontVector[1], frontVector[2]);

	    facing = FlyMode_GetCameraFacing(frontVector[0], frontVector[1]);

	    format(string, sizeof(string), "~b~Flymode~w~ X %.3f Y %.3f Z %.3f A %.2f", cameraPos[0], cameraPos[1], cameraPos[2], facing);
	    ShowPlayerFooter(playerid, string, 1500);

	    g_FlyModeLastCoordTick[playerid] = GetTickCount();
	}
	return 1;
}

// ====== FlyMode_Enable ======
stock FlyMode_Enable(playerid)
{
	new Float:x, Float:y, Float:z;

	if (g_FlyMode[playerid])
	    return 0;

	if (IsPlayerInAnyVehicle(playerid))
	    RemovePlayerFromVehicle(playerid);

	GetPlayerPos(playerid, x, y, z);
	z += 1.0;

	g_FlyModeObject[playerid] = CreateDynamicObject(19300, x, y, z, 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), playerid, 300.0, 300.0);

	if (!IsValidDynamicObject(g_FlyModeObject[playerid]))
	    return SendErrorMessage(playerid, "Flymode object could not be created.");

	g_FlyMode[playerid] = true;
	g_FlyModeMoveMode[playerid] = FLYMODE_MOVE_NONE;
	g_FlyModeOldLR[playerid] = 0;
	g_FlyModeOldUD[playerid] = 0;
	g_FlyModeLastMove[playerid] = GetTickCount();
	g_FlyModeLastCoordTick[playerid] = 0;
	g_FlyModeAccel[playerid] = 0.0;

	TogglePlayerSpectating(playerid, 1);
	AttachCameraToDynamicObject(playerid, g_FlyModeObject[playerid]);
	return 1;
}

// ====== FlyMode_Disable ======
stock FlyMode_Disable(playerid)
{
	new
	    Float:vector[3],
	    Float:cameraPos[3],
	    Float:facing;

	if (!g_FlyMode[playerid])
	    return 0;

	GetPlayerCameraFrontVector(playerid, vector[0], vector[1], vector[2]);
	GetDynamicObjectPos(g_FlyModeObject[playerid], cameraPos[0], cameraPos[1], cameraPos[2]);

	facing = FlyMode_GetCameraFacing(vector[0], vector[1]);
	g_FlyMode[playerid] = false;
	g_FlyModeMoveMode[playerid] = FLYMODE_MOVE_NONE;
	g_FlyModeAccel[playerid] = 0.0;

	TogglePlayerSpectating(playerid, 0);

	if (IsValidDynamicObject(g_FlyModeObject[playerid]))
	    DestroyDynamicObject(g_FlyModeObject[playerid]);

	g_FlyModeObject[playerid] = STREAMER_TAG_OBJECT:INVALID_STREAMER_ID;

	SetPlayerPos(playerid, cameraPos[0], cameraPos[1], cameraPos[2]);
	SetPlayerFacingAngle(playerid, facing);
	SetCameraBehindPlayer(playerid);
	return 1;
}

// ====== FlyMode_PrintCoordinates ======
stock FlyMode_PrintCoordinates(playerid)
{
	new
	    Float:pos[4],
	    Float:camera[3],
	    Float:vector[3],
	    Float:facing,
	    Float:look[3];

	if (g_FlyMode[playerid])
	{
	    GetDynamicObjectPos(g_FlyModeObject[playerid], pos[0], pos[1], pos[2]);
	    GetPlayerCameraFrontVector(playerid, vector[0], vector[1], vector[2]);
	    pos[3] = FlyMode_GetCameraFacing(vector[0], vector[1]);
	}
	else
	{
	    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	    GetPlayerFacingAngle(playerid, pos[3]);
	    GetPlayerCameraFrontVector(playerid, vector[0], vector[1], vector[2]);
	}

	GetPlayerCameraPos(playerid, camera[0], camera[1], camera[2]);
	GetPlayerCameraFrontVector(playerid, vector[0], vector[1], vector[2]);
	facing = FlyMode_GetCameraFacing(vector[0], vector[1]);

	look[0] = camera[0] + (vector[0] * FLYMODE_LOOK_DISTANCE);
	look[1] = camera[1] + (vector[1] * FLYMODE_LOOK_DISTANCE);
	look[2] = camera[2] + (vector[2] * FLYMODE_LOOK_DISTANCE);

	SendClientMessageEx(playerid, COLOR_CLIENT, "POS:{FFFFFF} %.4f, %.4f, %.4f, %.4f | Int %d | VW %d", pos[0], pos[1], pos[2], pos[3], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
	SendClientMessageEx(playerid, COLOR_CLIENT, "CAM:{FFFFFF} Pos %.4f, %.4f, %.4f | Look %.4f, %.4f, %.4f | Facing %.4f", camera[0], camera[1], camera[2], look[0], look[1], look[2], facing);
	return 1;
}

// ====== FlyMode_Reset ======
stock FlyMode_Reset(playerid)
{
	if (g_FlyMode[playerid] && IsValidDynamicObject(g_FlyModeObject[playerid]))
	    DestroyDynamicObject(g_FlyModeObject[playerid]);

	g_FlyMode[playerid] = false;
	g_FlyModeObject[playerid] = STREAMER_TAG_OBJECT:INVALID_STREAMER_ID;
	g_FlyModeMoveMode[playerid] = FLYMODE_MOVE_NONE;
	g_FlyModeOldLR[playerid] = 0;
	g_FlyModeOldUD[playerid] = 0;
	g_FlyModeLastMove[playerid] = 0;
	g_FlyModeLastCoordTick[playerid] = 0;
	g_FlyModeAccel[playerid] = 0.0;
	return 1;
}
