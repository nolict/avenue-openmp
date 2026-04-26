/*
    File: modules/player/dialogs/tutorial.pwn
    Purpose: Contains easyDialog callbacks for player tutorial flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:Tutorial ======
Dialog:Tutorial(playerid, response, listitem, inputtext[])
{
	if (PlayerData[playerid][pTutorialStage] == 3)
	{
		PlayerData[playerid][pTutorialStage] = 4;
		SendServerMessage(playerid, "Press 'Y', select the soda bottle, then drop the item.");
	}
	else if (PlayerData[playerid][pTutorialStage] == 4)
	{
		PlayerData[playerid][pTutorialStage] = 5;

		SendServerMessage(playerid, "Please go to the exit and press 'F'.");
		SetPlayerCheckpoint(playerid, -228.8403, 1401.1831, 27.7656, 1.0);
	}
	return 1;
}

// ====== Dialog:TutorialConfirm ======
Dialog:TutorialConfirm(playerid, response, listitem, inputtext[])
{
    PlayerData[playerid][pTutorialStage] = 0;

	if (!response)
	{
	    PlayerData[playerid][pCreated] = 1;
	    PlayerData[playerid][pTask] = 1;

  		PlayerData[playerid][pTutorial] = 0;
		PlayerData[playerid][pTutorialTime] = 0;

		SendServerMessage(playerid, "Type /tasks to view the tasks you need to complete.");
	}
	else
	{
	    StartTutorial(playerid);
	}
	return 1;
}

