/*
    File: modules/player/logic/tickets.pwn
    Purpose: Contains player gameplay logic and helper functions for tickets.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== Ticket_Add ======
Ticket_Add(suspectid, price, reason[])
{
	new
	    string[160];

	for (new i = 0; i != MAX_PLAYER_TICKETS; i ++) if (!TicketData[suspectid][i][ticketExists])
	{
	    TicketData[suspectid][i][ticketExists] = true;
	    TicketData[suspectid][i][ticketFee] = price;

	    format(TicketData[suspectid][i][ticketDate], 36, ReturnDate());
	    format(TicketData[suspectid][i][ticketReason], 64, reason);

		format(string, sizeof(string), "INSERT INTO `tickets` (`ID`, `ticketFee`, `ticketDate`, `ticketReason`) VALUES('%d', '%d', '%s', '%s')", PlayerData[suspectid][pID], price, TicketData[suspectid][i][ticketDate], SQL_ReturnEscaped(reason));
		mysql_tquery(g_iHandle, string, "OnTicketCreated", "dd", suspectid, i);

		return i;
	}
	return -1;
}

// ====== Ticket_Remove ======
Ticket_Remove(playerid, ticketid)
{
	if (ticketid != -1 && TicketData[playerid][ticketid][ticketExists])
	{
	    new
	        string[90];

		format(string, sizeof(string), "DELETE FROM `tickets` WHERE `ID` = '%d' AND `ticketID` = '%d'", PlayerData[playerid][pID], TicketData[playerid][ticketid][ticketID]);
		mysql_tquery(g_iHandle, string);

	    TicketData[playerid][ticketid][ticketExists] = false;
	    TicketData[playerid][ticketid][ticketID] = 0;
	    TicketData[playerid][ticketid][ticketFee] = 0;
	}
	return 1;
}
