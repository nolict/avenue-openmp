/*
    File: modules/faction/dialogs/ranks.pwn
    Purpose: Contains easyDialog callbacks for faction ranks flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:GatePass ======
Dialog:GatePass(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new id = Gate_Nearest(playerid);

	    if (id == -1)
	        return 0;

        if (isnull(inputtext))
        	return Dialog_Show(playerid, GatePass, DIALOG_STYLE_INPUT, "Enter Password", "Please enter the password for this gate below:", "Submit", "Cancel");

		if (strcmp(inputtext, GateData[id][gatePass]) != 0)
  			return Dialog_Show(playerid, GatePass, DIALOG_STYLE_INPUT, "Enter Password", "Error: Incorrect password specified.\n\nPlease enter the password for this gate below:", "Submit", "Cancel");

		Gate_Operate(id);
	}
	return 1;
}

// ====== Dialog:EditRanks ======
Dialog:EditRanks(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    if (!FactionData[PlayerData[playerid][pFactionEdit]][factionExists])
			return 0;

		PlayerData[playerid][pSelectedSlot] = listitem;
		Dialog_Show(playerid, SetRankName, DIALOG_STYLE_INPUT, "Set Rank", "Rank: %s (%d)\n\nPlease enter a new name for this rank below:", "Submit", "Back", FactionRanks[PlayerData[playerid][pFactionEdit]][PlayerData[playerid][pSelectedSlot]], PlayerData[playerid][pSelectedSlot] + 1);
	}
	return 1;
}

// ====== Dialog:SetRankName ======
Dialog:SetRankName(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    if (isnull(inputtext))
			return Dialog_Show(playerid, SetRankName, DIALOG_STYLE_INPUT, "Set Rank", "Rank: %s (%d)\n\nPlease enter a new name for this rank below:", "Submit", "Back", FactionRanks[PlayerData[playerid][pFactionEdit]][PlayerData[playerid][pSelectedSlot]], PlayerData[playerid][pSelectedSlot] + 1);

	    if (strlen(inputtext) > 32)
	        return Dialog_Show(playerid, SetRankName, DIALOG_STYLE_INPUT, "Set Rank", "Error: The rank can't exceed 32 characters.\n\nRank: %s (%d)\n\nPlease enter a new name for this rank below:", "Submit", "Back", FactionRanks[PlayerData[playerid][pFactionEdit]][PlayerData[playerid][pSelectedSlot]], PlayerData[playerid][pSelectedSlot] + 1);

		format(FactionRanks[PlayerData[playerid][pFactionEdit]][PlayerData[playerid][pSelectedSlot]], 32, inputtext);
		Faction_SaveRanks(PlayerData[playerid][pFactionEdit]);

		Faction_ShowRanks(playerid, PlayerData[playerid][pFactionEdit]);
		SendServerMessage(playerid, "You have set the name of rank %d to \"%s\".", PlayerData[playerid][pSelectedSlot] + 1, inputtext);
	}
	else Faction_ShowRanks(playerid, PlayerData[playerid][pFactionEdit]);
	return 1;
}

