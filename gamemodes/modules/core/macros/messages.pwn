/*
    File: modules/core/macros/messages.pwn
    Purpose: Contains core macros definitions and helpers for messages.
    Notes: Keep this file focused on shared infrastructure, not feature gameplay bodies.
*/

// ====== Message Macros ======

#define SendServerMessage(%0,%1) \
	SendClientMessageEx(%0, X11_LIGHT_SKY_BLUE_1, "SERVER: {FFFFFF}"%1)

#define SendCustomMessage(%0,%1,%2) \
	SendClientMessageEx(%0, X11_LIGHT_SKY_BLUE_1, %1": {FFFFFF}"%2)

#define SendSyntaxMessage(%0,%1) \
	SendClientMessageEx(%0, X11_GREY_80, "USAGE: "%1)

#define SendErrorMessage(%0,%1) \
	SendClientMessageEx(%0, X11_GREY_80, "ERROR: "%1)

#define SendAdminAction(%0,%1) \
	SendClientMessageEx(%0, X11_TOMATO, "ADMIN: "%1)

#define PermissionError(%0) \
	SendClientMessageEx(%0, X11_GREY_80, "ERROR: You don't have any permissions!")
