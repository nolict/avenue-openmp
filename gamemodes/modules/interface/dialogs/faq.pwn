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
		        Dialog_Show(playerid, FAQ1, DIALOG_STYLE_MSGBOX, inputtext, "{FFFFFF}Kamu bisa masuk dan keluar building dengan menekan key {FFFF00}'F'{FFFFFF}.", "OK", "Back");
			}
            case 1:
		    {
		        Dialog_Show(playerid, FAQ1, DIALOG_STYLE_MSGBOX, inputtext, "{FFFFFF}Kamu bisa membuka inventory dengan menekan key {FFFF00}'Y'{FFFFFF}.\nKamu juga bisa ketik {FFFF00}/inventory{FFFFFF} untuk membuka inventory.", "OK", "Back");
			}
			case 2:
		    {
		        Dialog_Show(playerid, FAQ1, DIALOG_STYLE_MSGBOX, inputtext, "{FFFFFF}Kamu bisa pickup dropped items dengan menekan key {FFFF00}'N'{FFFFFF}.\nKamu harus crouched dan dekat dengan item.", "OK", "Back");
			}
			case 3:
		    {
		        Dialog_Show(playerid, FAQ1, DIALOG_STYLE_MSGBOX, inputtext, "{FFFFFF}Icons di sisi kanan screen kamu adalah sebagai berikut:\n\n{FFFF00}Pizza Icon:{FFFFFF} Icon ini menunjukkan hunger. Angka di sampingnya adalah persentase hunger.\n{FFFF00}Bottle Icon:{FFFFFF} Icon ini menunjukkan thirst. Angka di sampingnya adalah persentase thirst.\n\nJika kamu punya armored vest, itu juga akan muncul bersama icons tersebut.", "OK", "Back");
			}
			case 4:
		    {
		        Dialog_Show(playerid, FAQ1, DIALOG_STYLE_MSGBOX, inputtext, "{FFFFFF}Kamu bisa mengisi hunger dengan cooking food lalu memakannya, atau lewat business {FFFF00}Fast Food{FFFFFF}.\nUntuk cook food, ketik {FFFF00}/cook{FFFFFF}. Kamu bisa membeli frozen food di {FFFF00}Retail Store{FFFFFF} mana pun.\n\nUntuk mengisi thirst, kamu bisa membeli drinks dari {FFFF00}Retail Store{FFFFFF} mana pun.\nSelain itu, kamu juga bisa membeli beverages di business fast food.", "OK", "Back");
			}
			case 5:
		    {
		        Dialog_Show(playerid, FAQ1, DIALOG_STYLE_MSGBOX, inputtext, "{FFFFFF}Kamu bisa mencari area tertentu di map memakai {FFFF00}GPS System{FFFFFF}.\nKamu bisa membeli GPS System di {FFFF00}Retail Store{FFFFFF} mana pun di map.", "OK", "Back");
			}
			case 6:
		    {
		        Dialog_Show(playerid, FAQ1, DIALOG_STYLE_MSGBOX, inputtext, "{FFFFFF}Kamu bisa ketik {FFFF00}/disablecp{FFFFFF} untuk menghentikan current job.\nJika kamu sedang loading crates ke truck, gunakan {FFFF00}/stoploading{FFFFFF} untuk berhenti loading.", "OK", "Back");
			}
			case 7:
		    {
		        Dialog_Show(playerid, FAQ1, DIALOG_STYLE_MSGBOX, inputtext, "{FFFFFF}Kamu harus memilih weapon dari inventory lalu tekan {FFFF00}Use Item.\n{FFFFFF}Setelah memegang weapon, kamu harus memakai magazine untuk reload.\n\nKamu bisa membeli magazines untuk weapon di {FFFF00}Weapon Shop mana pun.\n{FFFFFF}Kamu juga bisa tekan {FFFF00}'N'{FFFFFF} untuk menyimpan weapon yang sedang kamu pegang.", "OK", "Back");
			}
			case 8:
		    {
		        Dialog_Show(playerid, FAQ1, DIALOG_STYLE_MSGBOX, inputtext, "{FFFFFF}Furniture yang kamu beli akan muncul di inventory.\nTekan {FFFF00}'Y'{FFFFFF}, pilih furniture item, lalu tekan {FFFF00}Use Item{FFFFFF} untuk deploy.\n\nJika ingin edit furniture yang sudah ada, ketik {FFFF00}/furniture{FFFFFF} di dalam house.\nPilih item yang diinginkan untuk edit position atau destroy item.", "OK", "Back");
			}
			case 9:
			{
			    Dialog_Show(playerid, FAQ1, DIALOG_STYLE_MSGBOX, inputtext, "{FFFFFF}Key {FFFF00}'F'{FFFFFF} bisa dipakai untuk interact dengan banyak hal di server.\nContohnya vendors, weapon dan drug crates, gates, serta entrances.\n\nUntuk masuk house atau business, tekan key {FFFF00}'F'{FFFFFF} di dekat door.\nKamu bisa membuka inventory dengan {FFFF00}'Y'{FFFFFF} dan pickup items dengan {FFFF00}'N'{FFFFFF}.", "OK", "Back");
			}
		}
	}
	return 1;
}

