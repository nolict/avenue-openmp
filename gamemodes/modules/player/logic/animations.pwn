/*
    File: modules/player/logic/animations.pwn
    Purpose: Contains player gameplay logic and helper functions for animations.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== ApplyAnimationEx ======
stock ApplyAnimationEx(playerid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync = 0)
{
	ApplyAnimation(playerid, animlib, animname, fDelta, loop, lockx, locky, freeze, time, forcesync);

	PlayerData[playerid][pLoopAnim] = true;
	ShowPlayerFooter(playerid, "Press ~y~SPRINT~w~ to stop the animation.");

	return 1;
}

// ====== AnimationCheck ======
stock AnimationCheck(playerid)
{
	return (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && !PlayerData[playerid][pKilled] && !PlayerData[playerid][pFreeze] && !PlayerData[playerid][pCuffed] && !PlayerData[playerid][pStunned] && !PlayerData[playerid][pFirstAid] && !PlayerData[playerid][pCrafting] && PlayerData[playerid][pGraffiti] == -1);
}

// ====== PreloadAnimations ======
stock PreloadAnimations(playerid)
{
	for (new i = 0; i < sizeof(g_aPreloadLibs); i ++) {
	    ApplyAnimation(playerid, g_aPreloadLibs[i], "null", 4.0, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}
