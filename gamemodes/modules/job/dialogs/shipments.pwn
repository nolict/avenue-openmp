/*
    File: modules/job/dialogs/shipments.pwn
    Purpose: Contains easyDialog callbacks for job shipments flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:AcceptShipment ======
Dialog:AcceptShipment(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new bizid = strval(inputtext);

		if (!BusinessData[bizid][bizExists])
		    return 0;

	    if (!BusinessData[bizid][bizShipment])
	        return SendErrorMessage(playerid, "This business is no longer requesting a shipment.");

		if (IsShipmentAccepted(bizid))
		    return SendErrorMessage(playerid, "This shipment was already accepted.");

		foreach (new i : Player) if (Business_IsOwner(i, bizid)) {
		    SendServerMessage(i, "%s has accepted your shipment request.", ReturnName(playerid, 0));
		}
		PlayerData[playerid][pShipment] = bizid;
		SendServerMessage(playerid, "You have accepted the shipment. Type /startdelivery to start a delivery.");
	}
	return 1;
}

