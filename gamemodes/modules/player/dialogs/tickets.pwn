/*
    File: modules/player/dialogs/tickets.pwn
    Purpose: Contains easyDialog callbacks for player tickets flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:MyTickets ======
Dialog:MyTickets(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    if (!TicketData[playerid][listitem][ticketExists])
	        return SendErrorMessage(playerid, "There is no ticket in the selected slot.");

		if (GetMoney(playerid) < TicketData[playerid][listitem][ticketFee])
		    return SendErrorMessage(playerid, "You can't afford to pay this ticket.");

		GiveMoney(playerid, -TicketData[playerid][listitem][ticketFee]);
        Tax_AddMoney(TicketData[playerid][listitem][ticketFee]);

		SendServerMessage(playerid, "You have paid off a %s ticket for \"%s\".", FormatNumber(TicketData[playerid][listitem][ticketFee]), TicketData[playerid][listitem][ticketReason]);
		Ticket_Remove(playerid, listitem);
	}
	return 1;
}

