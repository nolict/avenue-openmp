/*
    File: modules/interface/dialogs/faq.pwn
    Purpose: Contains easyDialog callbacks for interface faq flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:FAQ1 ======
Dialog:FAQ1(playerid, response, listitem, inputtext[])
{
	if (!response)
		cmd_faq(playerid, "\1");

	return 1;
}

// ====== Dialog:FAQ ======
Dialog:FAQ(playerid, response, listitem, inputtext[])
{
	if (response)
	{
		switch (listitem)
		{
		    case 0:
		    {
		        Dialog_Show(playerid, FAQ1, DIALOG_STYLE_MSGBOX, inputtext, "{FFFFFF}You can enter and exit a building by pressing the {FFFF00}'F'{FFFFFF} key.", "OK", "Back");
			}
            case 1:
		    {
		        Dialog_Show(playerid, FAQ1, DIALOG_STYLE_MSGBOX, inputtext, "{FFFFFF}You can access your inventory by pressing the {FFFF00}'Y'{FFFFFF} key.\nYou can also type {FFFF00}/inventory{FFFFFF} to access your inventory.", "OK", "Back");
			}
			case 2:
		    {
		        Dialog_Show(playerid, FAQ1, DIALOG_STYLE_MSGBOX, inputtext, "{FFFFFF}You can pickup dropped items by pressing the {FFFF00}'N'{FFFFFF} key.\nYou must be crouched and close to the item.", "OK", "Back");
			}
			case 3:
		    {
		        Dialog_Show(playerid, FAQ1, DIALOG_STYLE_MSGBOX, inputtext, "{FFFFFF}The icons on the right side of your screen are as follows:\n\n{FFFF00}Pizza Icon:{FFFFFF} This icon represents hunger. The number beside is the percentage of hunger.\n{FFFF00}Bottle Icon:{FFFFFF} This icon represents thirst. The number beside is the percentage of thirst.\n\nIf you have an armored vest, it will also show along with the icons.", "OK", "Back");
			}
			case 4:
		    {
		        Dialog_Show(playerid, FAQ1, DIALOG_STYLE_MSGBOX, inputtext, "{FFFFFF}You can refill your hunger by cooking food and eating it, or from a {FFFF00}Fast Food{FFFFFF} business.\nTo cook food, type {FFFF00}/cook{FFFFFF}. You can purchase frozen food at any {FFFF00}Retail Store{FFFFFF}.\n\nTo refill your thirst, you can purchase drinks from any {FFFF00}Retail Store{FFFFFF}.\nAdditionally, you can also purchase beverages at a fast food business.", "OK", "Back");
			}
			case 5:
		    {
		        Dialog_Show(playerid, FAQ1, DIALOG_STYLE_MSGBOX, inputtext, "{FFFFFF}You can search for certain areas around the map using a {FFFF00}GPS System{FFFFFF}.\nYou can purchase a GPS System at any {FFFF00}Retail Store{FFFFFF} around the map.", "OK", "Back");
			}
			case 6:
		    {
		        Dialog_Show(playerid, FAQ1, DIALOG_STYLE_MSGBOX, inputtext, "{FFFFFF}You can type {FFFF00}/disablecp{FFFFFF} to stop your current job.\nIf you are loading crates into a truck, use {FFFF00}/stoploading{FFFFFF} to stop loading.", "OK", "Back");
			}
			case 7:
		    {
		        Dialog_Show(playerid, FAQ1, DIALOG_STYLE_MSGBOX, inputtext, "{FFFFFF}You must select a weapon from your inventory and press {FFFF00}Use Item.\n{FFFFFF}Once you are holding a weapon, you must use a magazine to load it.\n\nYou can purchase magazines at any {FFFF00}Weapon Shop for your weapon.\n{FFFFFF}You can also press {FFFF00}'N'{FFFFFF} to put away the weapon you are holding.", "OK", "Back");
			}
			case 8:
		    {
		        Dialog_Show(playerid, FAQ1, DIALOG_STYLE_MSGBOX, inputtext, "{FFFFFF}Any furniture that you've purchased will appear inside your inventory.\nPress {FFFF00}'Y'{FFFFFF}, select the furniture item and press {FFFF00}Use Item{FFFFFF} to deploy it.\n\nIf you wish to edit existing furniture, type {FFFF00}/furniture{FFFFFF} inside your house.\nSimply select the item of choice to edit the position or destroy the item.", "OK", "Back");
			}
			case 9:
			{
			    Dialog_Show(playerid, FAQ1, DIALOG_STYLE_MSGBOX, inputtext, "{FFFFFF}The {FFFF00}'F'{FFFFFF} key will allow you to interact with a lot of things in the server.\nThese things include vendors, weapon and drug crates, gates and entrances.\n\nTo enter a house or business, simply press the {FFFF00}'F'{FFFFFF} key near the door.\nYou can open your inventory with {FFFF00}'Y'{FFFFFF} and pickup items using {FFFF00}'N'{FFFFFF}.", "OK", "Back");
			}
		}
	}
	return 1;
}

