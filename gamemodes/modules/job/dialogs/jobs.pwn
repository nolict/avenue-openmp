/*
    File: modules/job/dialogs/jobs.pwn
    Purpose: Contains easyDialog callbacks for job jobs flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:JobList ======
Dialog:JobList(playerid, response, listitem, inputtext[])
{
	/*
	    case 1: str = "Courier";
		case 2: str = "Mechanic";
		case 3: str = "Taxi Driver";
		case 4: str = "Cargo Unloader";
		case 5: str = "Miner";
		case 6: str = "Food Vendor";
		case 7: str = "Garbage Man";
		case 8: str = "Weapon Smuggler";
	*/
	if (response)
	{
	    switch (listitem)
	    {
	        case 0:
	            Dialog_Show(playerid, JobHelp, DIALOG_STYLE_MSGBOX, DialogStyle_Title("Courier Job"), DialogStyle_Body("{FFFFFF}The {FF6347}Courier{FFFFFF} job allows players to deliver products to businesses.\nUse {FF6347}/startdelivery{FFFFFF} to begin loading and {FF6347}/unload{FFFFFF} to unload the goods."), "Close", "Back");

			case 1:
	            Dialog_Show(playerid, JobHelp, DIALOG_STYLE_MSGBOX, DialogStyle_Title("Mechanic Job"), DialogStyle_Body("{FFFFFF}The {FF6347}Mechanic{FFFFFF} job allows players to repair totalled vehicles.\nUse {FF6347}/hood{FFFFFF} to open the hood and {FF6347}/repair{FFFFFF} to repair the vehicle."), "Close", "Back");

            case 2:
	            Dialog_Show(playerid, JobHelp, DIALOG_STYLE_MSGBOX, DialogStyle_Title("Taxi Driver Job"), DialogStyle_Body("{FFFFFF}The {FF6347}Taxi Driver{FFFFFF} job allows players to transport other players.\nUse {FF6347}/taxi{FFFFFF} whilst inside a taxi cab to go on taxi duty."), "Close", "Back");

            case 3:
	            Dialog_Show(playerid, JobHelp, DIALOG_STYLE_MSGBOX, DialogStyle_Title("Cargo Unloader Job"), DialogStyle_Body("{FFFFFF}The {FF6347}Cargo Unloader{FFFFFF} job allows players to operate a forklift to move crates.\nUse {FF6347}/loadcrate{FFFFFF} to load a crate and deliver it to the {FF6347}marker{FFFFFF}."), "Close", "Back");

            case 4:
	            Dialog_Show(playerid, JobHelp, DIALOG_STYLE_MSGBOX, DialogStyle_Title("Miner Job"), DialogStyle_Body("{FFFFFF}The {FF6347}Miner{FFFFFF} job allows players to mine rocks from the ground.\nUse {FF6347}/mine{FFFFFF} to begin mining and {FF6347}LMB{FFFFFF} to start digging."), "Close", "Back");

        	case 5:
	            Dialog_Show(playerid, JobHelp, DIALOG_STYLE_MSGBOX, DialogStyle_Title("Food Vendor Job"), DialogStyle_Body("{FFFFFF}The {FF6347}Food Vendor{FFFFFF} job allows players to sell food items to other players.\nUse {FF6347}/sellfood{FFFFFF} whilst inside a food truck to sell a food item."), "Close", "Back");

            case 6:
	            Dialog_Show(playerid, JobHelp, DIALOG_STYLE_MSGBOX, DialogStyle_Title("Garbage Man Job"), DialogStyle_Body("{FFFFFF}The {FF6347}Garbage Man{FFFFFF} job allows players to deliver trash in return for money.\nUse {FF6347}/takebag{FFFFFF} whilst near a garbage bin to load a bag of garbage."), "Close", "Back");

            case 7:
	            Dialog_Show(playerid, JobHelp, DIALOG_STYLE_MSGBOX, DialogStyle_Title("Package Sorter Job"), DialogStyle_Body("{FFFFFF}The {FF6347}Package Sorter{FFFFFF} job allows players to sort packages for money.\nUse {FF6347}/sorting{FFFFFF} at the required location to begin sorting."), "Close", "Back");

            case 8:
	            Dialog_Show(playerid, JobHelp, DIALOG_STYLE_MSGBOX, DialogStyle_Title("Weapon Smuggler Job"), DialogStyle_Body("{FFFFFF}The {FF6347}Weapon Smuggler{FFFFFF} job allows players to smuggle weapons from weapon crates.\nUse {FF6347}/craftparts{FFFFFF} whilst carrying a weapon crate to smuggle the parts."), "Close", "Back");

	    }
	}
	return 1;
}

// ====== Dialog:JobHelp ======
Dialog:JobHelp(playerid, response, listitem, inputtext[])
{
	if (!response) cmd_joblist(playerid, "\1");
	return 1;
}

