/*
    File: modules/system/data/system.pwn
    Purpose: Defines system data structures, constants, static arrays, or runtime storage for system.
    Notes: Do not place command handlers, dialogs, mapping objects, or heavy gameplay flows in data files.
*/

// ====== System Data ======
enum reportData {
	rExists,
	rType,
	rPlayer,
	rText[128 char]
};
enum billboardData {
	bbID,
	bbExists,
	bbName[32],
	bbMessage[230],
	bbOwner,
	bbPrice,
	bbRange,
	Float:bbPos[4],
	Text3D:bbText3D
};

new BillBoardData[MAX_BILLBOARDS][billboardData];
new BillboardCheckout[MAX_PLAYERS];
enum inventoryData {
	invExists,
	invID,
	invItem[32 char],
	invModel,
	invQuantity
};
enum droppedItems {
	droppedID,
	droppedItem[32],
	droppedPlayer[24],
	droppedModel,
	droppedQuantity,
	Float:droppedPos[3],
	droppedWeapon,
	droppedAmmo,
	droppedInt,
	droppedWorld,
	droppedObject,
	Text3D:droppedText3D
};
enum contactData {
	contactID,
	contactExists,
	contactName[32],
	contactNumber
};
enum locationData {
	locationID,
	locationExists,
	locationName[32],
	Float:locationPos[3],
};
enum crateData {
	crateID,
	crateExists,
	crateType,
 	Float:cratePos[4],
	crateInterior,
	crateWorld,
	crateObject,
	crateVehicle,
	Text3D:crateText3D
};
enum plantData {
	plantID,
	plantExists,
	plantType,
	plantDrugs,
	Float:plantPos[4],
	plantInterior,
	plantWorld,
	plantObject,
	Text3D:plantText3D
};
enum backpackData {
	backpackID,
	backpackExists,
	backpackPlayer,
	backpackHouse,
	backpackVehicle,
	Float:backpackPos[3],
	backpackInterior,
	backpackWorld,
	Text3D:backpackText3D,
	backpackObject
};
enum backpackItems {
	bItemID,
	bItemBackpack,
	bItemExists,
	bItemName[32],
	bItemModel,
	bItemQuantity
};
enum atmData {
	atmID,
	atmExists,
	Float:atmPos[4],
	atmInterior,
	atmWorld,
	atmObject,
	Text3D:atmText3D
};
enum garbageData {
	garbageID,
	garbageExists,
 	garbageModel,
	garbageCapacity,
	Float:garbagePos[4],
	garbageInterior,
	garbageWorld,
	Text3D:garbageText3D,
	garbageObject
};
enum vendorData {
	vendorID,
	vendorExists,
	vendorType,
	Float:vendorPos[4],
	vendorInterior,
	vendorWorld,
	Text3D:vendorText3D,
	vendorObject
};
enum boomboxData {
	boomboxPlaced,
	Float:boomboxPos[3],
	boomboxInterior,
	boomboxWorld,
	boomboxObject,
	boomboxURL[128 char],
	Text3D:boomboxText3D
};
enum rackData {
	rackID,
	rackExists,
	rackHouse,
	Float:rackPos[4],
	rackInterior,
	rackWorld,
	rackWeapons[4],
	rackAmmo[4],
	rackObjects[5],
	Text3D:rackText3D
};
enum graffitiData {
	graffitiID,
	graffitiExists,
	Float:graffitiPos[4],
	graffitiIcon,
	graffitiObject,
	graffitiColor,
	graffitiText[64]
};
enum detectorData {
	detectorID,
	detectorExists,
	Float:detectorPos[4],
	detectorInterior,
	detectorWorld,
	detectorObject[2]
};

// ====== World System Data ======
new NearestItems[MAX_PLAYERS][MAX_LISTED_ITEMS];
