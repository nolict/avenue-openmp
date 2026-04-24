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
		SendClientMessage(playerid, COLOR_SERVER, "Tekan 'Y', pilih soda bottle, lalu drop item tersebut.");
	}
	else if (PlayerData[playerid][pTutorialStage] == 4)
	{
		PlayerData[playerid][pTutorialStage] = 5;

		SendClientMessage(playerid, COLOR_SERVER, "Silakan menuju exit dan tekan 'F'.");
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

		SendServerMessage(playerid, "Ketik /tasks untuk melihat tasks yang perlu kamu selesaikan.");
	}
	else
	{
	    StartTutorial(playerid);
	}
	return 1;
}

