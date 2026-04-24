/*

	Developer: nolict


*/

#pragma dynamic 500000
#pragma warning disable 213
#pragma warning disable 229

#define SAMP_COMPAT 1
#include <open.mp>

#undef MAX_PLAYERS
#define MAX_PLAYERS (100)

#include <YSI_Data\y_iterate>
#include <a_mysql> // R39 - download it here: http://forum.sa-mp.com/showthread.php?t=56564
#include <easyDialog>
#include <eSelection>
#include <progress2>
#include <sscanf2>
#include <streamer>
#include <zcmd>

native WP_Hash(buffer[], len, const str[]);

// ====== IsPlayerNearPlayer ======
stock IsPlayerNearPlayer(playerid, targetid, Float:radius);

// ====== CancelDrivingTest ======
stock CancelDrivingTest(playerid);

// ====== Log_Write ======
stock Log_Write(const path[], const str[], {Float,_}:...);

// ====== Business_RemoveCars ======
stock Business_RemoveCars(bizid);

// ====== Business_RemovePumps ======
stock Business_RemovePumps(bizid);


#include "modules/core/core.pwn"
#include "modules/player/player.pwn"
#include "modules/property/property.pwn"
#include "modules/vehicle/vehicle.pwn"
#include "modules/faction/faction.pwn"
#include "modules/furniture/furniture.pwn"
#include "modules/job/job.pwn"
#include "modules/system/system.pwn"
#include "modules/interface/interface.pwn"
#include "modules/mapping/mapping.pwn"
#include "modules/dynamic/dynamic.pwn"
#include "modules/economy/economy.pwn"
#include "modules/runtime.pwn"


// ====== main ======
main() {
	print("Avenue Roleplay");
}

