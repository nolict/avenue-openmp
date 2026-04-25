/*
    File: modules/player/logic/character_selection.pwn
    Purpose: Owns the temporary 3-slot world preview used before a character is loaded or created.
    Notes: Keep character create/load decisions in player logic; commands only call these helpers.
*/

#define CHARACTER_SELECTION_SLOTS (3)
#define CHARACTER_SELECTION_CAMERA_INTERVAL (30)
#define CHARACTER_SELECTION_CAMERA_STEPS (100)

enum e_CharacterSelectionData {
	csSkin,
	Float:csPosX,
	Float:csPosY,
	Float:csPosZ,
	Float:csAngle,
	Float:csCameraX,
	Float:csCameraY,
	Float:csCameraZ,
	Float:csLookX,
	Float:csLookY,
	Float:csLookZ
};

static const CharacterSelectionData[CHARACTER_SELECTION_SLOTS][e_CharacterSelectionData] = {
	{6, 1703.9722, -2245.8923, 13.5469, 81.8098, 1701.9500, -2244.5500, 14.4500, 1703.9722, -2245.8923, 14.3500},
	{29, 1682.3356, -2248.1155, 13.5619, 180.8592, 1682.3600, -2252.1000, 14.5500, 1682.3356, -2248.1155, 14.3600},
	{60, 1678.0688, -2287.5950, 13.5408, 257.7288, 1680.9000, -2288.6500, 14.5000, 1678.0688, -2287.5950, 14.3400}
};

static CharacterSelectionActors[CHARACTER_SELECTION_SLOTS] = {INVALID_ACTOR_ID, ...};
static CharacterSelectionCameraTimer[MAX_PLAYERS];
static CharacterSelectionCameraStep[MAX_PLAYERS];
static Float:CharacterSelectionCameraFrom[MAX_PLAYERS][6];
static Float:CharacterSelectionCameraTo[MAX_PLAYERS][6];
static Float:CharacterSelectionCameraCurrent[MAX_PLAYERS][6];

// ====== CharacterSelection_CreateActors ======
CharacterSelection_CreateActors()
{
	for (new i = 0; i < CHARACTER_SELECTION_SLOTS; i ++)
	{
		if (IsValidActor(CharacterSelectionActors[i]))
			continue;

		CharacterSelectionActors[i] = CreateActor(
			CharacterSelectionData[i][csSkin],
			CharacterSelectionData[i][csPosX],
			CharacterSelectionData[i][csPosY],
			CharacterSelectionData[i][csPosZ],
			CharacterSelectionData[i][csAngle]
		);
		SetActorVirtualWorld(CharacterSelectionActors[i], 0);
	}
	CharSelect_ApplyActorAnims();
	return 1;
}

forward CharSelect_ApplyActorAnims();

// ====== CharSelect_ApplyActorAnims ======
public CharSelect_ApplyActorAnims()
{
	if (IsValidActor(CharacterSelectionActors[0]))
		ApplyActorAnimation(CharacterSelectionActors[0], "SMOKING", "M_smklean_loop", 4.1, 1, 0, 0, 0, 0);

	if (IsValidActor(CharacterSelectionActors[1]))
		ApplyActorAnimation(CharacterSelectionActors[1], "DEALER", "DEALER_IDLE", 4.1, 1, 0, 0, 0, 0);

	if (IsValidActor(CharacterSelectionActors[2]))
		ApplyActorAnimation(CharacterSelectionActors[2], "PED", "IDLE_chat", 4.1, 1, 0, 0, 0, 0);

	return 1;
}

// ====== CharacterSelection_IsActive ======
CharacterSelection_IsActive(playerid)
{
	return (PlayerData[playerid][pCharacterMenu] >= 1 && PlayerData[playerid][pCharacterMenu] <= CHARACTER_SELECTION_SLOTS && !PlayerData[playerid][pCharacter]);
}

// ====== CharacterSelection_Show ======
CharacterSelection_Show(playerid, slot, bool:smooth = false)
{
	new bool:active = CharacterSelection_IsActive(playerid);

	if (slot < 1 || slot > CHARACTER_SELECTION_SLOTS)
		slot = 1;

	new oldSlot = PlayerData[playerid][pCharacterMenu];

	if (oldSlot < 1 || oldSlot > CHARACTER_SELECTION_SLOTS)
		oldSlot = slot;

	PlayerData[playerid][pCharacter] = 0;
	PlayerData[playerid][pCharacterMenu] = slot;

	if (!active)
	{
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		TogglePlayerSpectating(playerid, 1);
		CharSelect_ApplyActorAnims();
		SetTimer("CharSelect_ApplyActorAnims", 700, false);
	}

	if (smooth)
	{
		CharSelect_StartCameraMove(playerid, oldSlot, slot);
	}
	else
	{
		SetPlayerCameraPos(
			playerid,
			CharacterSelectionData[slot - 1][csCameraX],
			CharacterSelectionData[slot - 1][csCameraY],
			CharacterSelectionData[slot - 1][csCameraZ]
		);
		SetPlayerCameraLookAt(
			playerid,
			CharacterSelectionData[slot - 1][csLookX],
			CharacterSelectionData[slot - 1][csLookY],
			CharacterSelectionData[slot - 1][csLookZ]
		);
		CharSelect_SaveCurrentCamera(playerid, slot);
	}

	CharSelect_SendSlotMsg(playerid);
	return 1;
}

// ====== CharSelect_SaveCurrentCamera ======
CharSelect_SaveCurrentCamera(playerid, slot)
{
	CharacterSelectionCameraCurrent[playerid][0] = CharacterSelectionData[slot - 1][csCameraX];
	CharacterSelectionCameraCurrent[playerid][1] = CharacterSelectionData[slot - 1][csCameraY];
	CharacterSelectionCameraCurrent[playerid][2] = CharacterSelectionData[slot - 1][csCameraZ];
	CharacterSelectionCameraCurrent[playerid][3] = CharacterSelectionData[slot - 1][csLookX];
	CharacterSelectionCameraCurrent[playerid][4] = CharacterSelectionData[slot - 1][csLookY];
	CharacterSelectionCameraCurrent[playerid][5] = CharacterSelectionData[slot - 1][csLookZ];
	return 1;
}

// ====== CharSelect_StartCameraMove ======
CharSelect_StartCameraMove(playerid, oldSlot, slot)
{
	if (CharacterSelectionCameraTimer[playerid])
	{
		KillTimer(CharacterSelectionCameraTimer[playerid]);
		CharacterSelectionCameraTimer[playerid] = 0;
	}
	else
	{
		CharSelect_SaveCurrentCamera(playerid, oldSlot);
	}

	for (new i = 0; i < 6; i ++) {
		CharacterSelectionCameraFrom[playerid][i] = CharacterSelectionCameraCurrent[playerid][i];
	}

	CharacterSelectionCameraTo[playerid][0] = CharacterSelectionData[slot - 1][csCameraX];
	CharacterSelectionCameraTo[playerid][1] = CharacterSelectionData[slot - 1][csCameraY];
	CharacterSelectionCameraTo[playerid][2] = CharacterSelectionData[slot - 1][csCameraZ];
	CharacterSelectionCameraTo[playerid][3] = CharacterSelectionData[slot - 1][csLookX];
	CharacterSelectionCameraTo[playerid][4] = CharacterSelectionData[slot - 1][csLookY];
	CharacterSelectionCameraTo[playerid][5] = CharacterSelectionData[slot - 1][csLookZ];

	CharacterSelectionCameraStep[playerid] = 0;
	CharacterSelectionCameraTimer[playerid] = SetTimerEx("CharSelect_CameraTick", CHARACTER_SELECTION_CAMERA_INTERVAL, true, "d", playerid);
	return 1;
}

// ====== CharacterSelection_StopCamera ======
CharacterSelection_StopCamera(playerid)
{
	if (CharacterSelectionCameraTimer[playerid])
	{
		KillTimer(CharacterSelectionCameraTimer[playerid]);
		CharacterSelectionCameraTimer[playerid] = 0;
	}
	CharacterSelectionCameraStep[playerid] = 0;
	return 1;
}

forward CharSelect_CameraTick(playerid);

// ====== CharSelect_CameraTick ======
public CharSelect_CameraTick(playerid)
{
	if (!IsPlayerConnected(playerid) || !CharacterSelection_IsActive(playerid))
	{
		CharacterSelection_StopCamera(playerid);
		return 0;
	}

	CharacterSelectionCameraStep[playerid] ++;

	new step = CharacterSelectionCameraStep[playerid];

	if (step >= CHARACTER_SELECTION_CAMERA_STEPS)
	{
		for (new i = 0; i < 6; i ++) {
			CharacterSelectionCameraCurrent[playerid][i] = CharacterSelectionCameraTo[playerid][i];
		}

		SetPlayerCameraPos(playerid, CharacterSelectionCameraCurrent[playerid][0], CharacterSelectionCameraCurrent[playerid][1], CharacterSelectionCameraCurrent[playerid][2]);
		SetPlayerCameraLookAt(playerid, CharacterSelectionCameraCurrent[playerid][3], CharacterSelectionCameraCurrent[playerid][4], CharacterSelectionCameraCurrent[playerid][5]);
		CharacterSelection_StopCamera(playerid);
		return 1;
	}

	new Float:t = float(step) / float(CHARACTER_SELECTION_CAMERA_STEPS);
	new Float:ease = t * t * (3.0 - (2.0 * t));

	for (new i = 0; i < 6; i ++) {
		CharacterSelectionCameraCurrent[playerid][i] = CharacterSelectionCameraFrom[playerid][i] + ((CharacterSelectionCameraTo[playerid][i] - CharacterSelectionCameraFrom[playerid][i]) * ease);
	}

	SetPlayerCameraPos(playerid, CharacterSelectionCameraCurrent[playerid][0], CharacterSelectionCameraCurrent[playerid][1], CharacterSelectionCameraCurrent[playerid][2]);
	SetPlayerCameraLookAt(playerid, CharacterSelectionCameraCurrent[playerid][3], CharacterSelectionCameraCurrent[playerid][4], CharacterSelectionCameraCurrent[playerid][5]);
	return 1;
}

// ====== CharSelect_SendSlotMsg ======
CharSelect_SendSlotMsg(playerid)
{
	new slot = PlayerData[playerid][pCharacterMenu] - 1;

	if (slot < 0 || slot >= CHARACTER_SELECTION_SLOTS)
		return 0;

	if (PlayerCharacters[playerid][slot][0])
		SendServerMessage(playerid, "Character slot %d: %s. Use /next, /prev, or /select.", slot + 1, PlayerCharacters[playerid][slot]);
	else
		SendServerMessage(playerid, "Character slot %d: Empty Slot. Use /next, /prev, or /select to create.", slot + 1);

	return 1;
}

// ====== CharacterSelection_Next ======
CharacterSelection_Next(playerid)
{
	if (!CharacterSelection_IsActive(playerid))
		return SendErrorMessage(playerid, "You are not in character selection.");

	new slot = PlayerData[playerid][pCharacterMenu] + 1;

	if (slot > CHARACTER_SELECTION_SLOTS)
		slot = 1;

	return CharacterSelection_Show(playerid, slot, true);
}

// ====== CharacterSelection_Previous ======
CharacterSelection_Previous(playerid)
{
	if (!CharacterSelection_IsActive(playerid))
		return SendErrorMessage(playerid, "You are not in character selection.");

	new slot = PlayerData[playerid][pCharacterMenu] - 1;

	if (slot < 1)
		slot = CHARACTER_SELECTION_SLOTS;

	return CharacterSelection_Show(playerid, slot, true);
}

// ====== CharacterSelection_Select ======
CharacterSelection_Select(playerid)
{
	if (!CharacterSelection_IsActive(playerid))
		return SendErrorMessage(playerid, "You are not in character selection.");

	CharacterSelection_StopCamera(playerid);

	new slot = PlayerData[playerid][pCharacterMenu];

	if (slot < 1 || slot > CHARACTER_SELECTION_SLOTS)
		slot = 1;

	PlayerData[playerid][pCharacter] = slot;

	if (!PlayerCharacters[playerid][slot - 1][0])
	    return Dialog_Show(playerid, CreateChar, DIALOG_STYLE_INPUT, DialogStyle_Title("Create Character"), DialogStyle_Body("Please enter the name of your new character below:\n\nWarning: Your name must be in the Firstname_Lastname format and not exceed 20 characters."), "Create", "Cancel");

	return SQL_LoadCharacter(playerid, slot);
}
