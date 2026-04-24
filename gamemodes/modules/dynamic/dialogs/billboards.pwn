/*
    File: modules/dynamic/dialogs/billboards.pwn
    Purpose: Contains easyDialog callbacks for dynamic billboards flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:Billboards ======
Dialog:Billboards(playerid, response, listitem, inputtext[]) {
	if (response)
	{
	    new string[500], szString[100];
	    if(BillBoardData[listitem][bbExists] >= 1)
		{
		    if(!BillBoardData[listitem][bbOwner])
		    {
				BillboardCheckout[playerid] = listitem;
		        format(szString, sizeof(szString), "{FFFFFF}Rent Billboard - {FF8000}%i{FFFFFF} - {FF8000}$%d", listitem, BillBoardData[listitem][bbPrice]);
		        format(string, sizeof(string), "{FFFFFF}Billboard Name: {FF8000}%s{FFFFFF} ({FF8000}%i{FFFFFF})\nBillboard Price: {FF8000}$%d{FFFFFF}\n\n\n((Rent Fees are collected each payday from your bank account!))", BillBoardData[listitem][bbName], listitem, BillBoardData[listitem][bbPrice]);
		    	Dialog_Show(playerid, BillboardRent, DIALOG_STYLE_MSGBOX, szString, string, "Rent", "Cancel");
		    	return 1;
		    }
		    if(BillBoardData[listitem][bbOwner] == GetPlayerSQLID(playerid))
		    {
		    	Dialog_Show(playerid, MyBillboardMenu, DIALOG_STYLE_LIST, "Manage Billboard", "Edit Message\nUnrent Billboard", "Proceed", "Cancel");
		    	return 1;
		    }
		    else
		    {
		        SendErrorMessage(playerid, "Sorry, this billboard is already being rented!");
			}
		}
	}
	return 1;
}

// ====== Dialog:MyBillboardMenu ======
Dialog:MyBillboardMenu(playerid, response, listitem, inputtext[]) {
	if (response)
	{
	    if(listitem == 0)
	    {
	        Dialog_Show(playerid, MyBillboardMessage, DIALOG_STYLE_INPUT, "Billboard Message", "Enter in a new billboard message!\n\n(Max Chars: 230)", "Proceed", "Cancel");
	    }
	    if(listitem == 1)
	    {
	        Dialog_Show(playerid, MyBillboardUnrent, DIALOG_STYLE_MSGBOX, "Unrent Billboard", "Are you sure you wish to unrent your billboard?\n\nYou'll get half the rent fee back", "Confirm", "Cancel");
	    }
	}
	return 1;
}

// ====== Dialog:MyBillboardMessage ======
Dialog:MyBillboardMessage(playerid, response, listitem, inputtext[]) {
	if (response)
	{
	    if (isnull(inputtext))
	        return Dialog_Show(playerid, MyBillboardMessage, DIALOG_STYLE_INPUT, "Billboard Message", "Enter in a new billboard message!\n\n(Max Chars: 230)", "Proceed", "Cancel");

		if (strlen(inputtext) > 230)
	        return Dialog_Show(playerid, MyBillboardMessage, DIALOG_STYLE_INPUT, "Billboard Message", "Too many characters (Max is 230)\n\nEnter in a new billboard message!\n\n(Max Chars: 230)", "Proceed", "Cancel");

		format(BillBoardData[PlayerData[playerid][pOwnsBillboard]][bbMessage], 230, inputtext);

		Billboard_Save(PlayerData[playerid][pOwnsBillboard]);
		Billboard_Refresh(PlayerData[playerid][pOwnsBillboard]);
	}
	return 1;
}

// ====== Dialog:MyBillboardUnrent ======
Dialog:MyBillboardUnrent(playerid, response, listitem, inputtext[]) {
	if (response)
	{
		new bbid = PlayerData[playerid][pOwnsBillboard];

		GiveMoney(playerid, BillBoardData[bbid][bbPrice]/2);
		BillBoardData[bbid][bbOwner] = 0;
		format(BillBoardData[PlayerData[playerid][pOwnsBillboard]][bbMessage], 230, "Not Owned");
		Billboard_Save(bbid);
		Billboard_Refresh(bbid);
		PlayerData[playerid][pOwnsBillboard] = -1;
		SendClientMessageEx(playerid, COLOR_LIGHTYELLOW, "You have unrented your billboard");
	}
	return 1;
}

// ====== Dialog:BillboardRent ======
Dialog:BillboardRent(playerid, response, listitem, inputtext[]) {
	if (response)
	{
	    new bbid = BillboardCheckout[playerid];
	    if(PlayerData[playerid][pBankMoney] < BillBoardData[bbid][bbPrice])
	    {
	        SendErrorMessage(playerid, "You do not have enough cash in your bank account for the billboard rental fee");
	        return 1;
	    }
	    else
	    {
			PlayerData[playerid][pBankMoney] -= BillBoardData[playerid][bbPrice];
			PlayerData[playerid][pOwnsBillboard] = bbid;
			BillBoardData[bbid][bbOwner] = GetPlayerSQLID(playerid);
			Tax_AddMoney(BillBoardData[bbid][bbPrice]);
			Billboard_Save(bbid);
			Billboard_Refresh(bbid);
			SendClientMessageEx(playerid, COLOR_LIGHTYELLOW, "You have purchased a billboard, use /mybillboard to edit the message");
		}
	}
	return 1;
}

