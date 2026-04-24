/*
    File: modules/system/data/phone.pwn
    Purpose: Defines system data structures, constants, static arrays, or runtime storage for phone.
    Notes: Do not place command handlers, dialogs, mapping objects, or heavy gameplay flows in data files.
*/

// ====== Phone System Data ======
new ContactData[MAX_PLAYERS][MAX_CONTACTS][contactData];
new LocationData[MAX_PLAYERS][MAX_GPS_LOCATIONS][locationData];
new ListedContacts[MAX_PLAYERS][MAX_CONTACTS];
