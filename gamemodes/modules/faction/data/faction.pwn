/*
    File: modules/faction/data/faction.pwn
    Purpose: Defines faction data structures, constants, static arrays, or runtime storage for faction.
    Notes: Do not place command handlers, dialogs, mapping objects, or heavy gameplay flows in data files.
*/

// ====== Faction Data ======
enum factionData {
	factionID,
	factionExists,
	factionName[32],
	factionColor,
	factionType,
	factionRanks,
	Float:factionLockerPos[3],
	factionLockerInt,
	factionLockerWorld,
	factionSkins[8],
	factionWeapons[10],
	factionAmmo[10],
	Text3D:factionText3D,
	factionPickup,
	Float:SpawnX,
	Float:SpawnY,
	Float:SpawnZ,
	SpawnInterior,
	SpawnVW
};
enum prisonData {
	prisonDoors[3],
	prisonCells[24],
	prisonDoorOpened[3],
	prisonCellOpened[24]
};
enum arrestPoints {
	arrestID,
	arrestExists,
	Float:arrestPos[3],
	arrestInterior,
	arrestWorld,
	Text3D:arrestText3D,
	arrestPickup
};
enum barricadeData {
	cadeExists,
	cadeType,
	Float:cadePos[3],
	cadeObject
};
enum gateData {
	gateID,
	gateExists,
	gateOpened,
	gateModel,
	Float:gateSpeed,
	Float:gateRadius,
	gateTime,
	Float:gatePos[6],
	gateInterior,
	gateWorld,
	Float:gateMove[6],
	gateLinkID,
	gateFaction,
	gatePass[32],
	gateTimer,
	gateObject
};

new FactionData[MAX_FACTIONS][factionData];
new FactionRanks[MAX_FACTIONS][15][32];
new GateData[MAX_GATES][gateData];
