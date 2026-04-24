/*
    File: modules/core/macros/messages.pwn
    Purpose: Contains core macros definitions and helpers for messages.
    Notes: Keep this file focused on shared infrastructure, not feature gameplay bodies.
*/

// ====== Message Macros ======

#define SendServerMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_SERVER, "[SERVER]:{FFFFFF} "%1)

#define SendSyntaxMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_GREY, "[SYNTAX]:{FFFFFF} "%1)

#define SendErrorMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_LIGHTRED, "[ERROR]:{FFFFFF} "%1)

#define SendAdminAction(%0,%1) \
	SendClientMessageEx(%0, COLOR_CLIENT, "[ADMIN]:{FFFFFF} "%1)
