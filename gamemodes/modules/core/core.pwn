/*
    File: modules/core/core.pwn
    Purpose: Handles core  responsibility for core.
    Notes: Keep this file focused on its folder responsibility and move unrelated code to the matching module.
*/

// Data
#include "modules/core/data/core.pwn"

// Settings
#include "modules/core/settings/database.pwn"
#include "modules/core/settings/server.pwn"

// Constants
#include "modules/core/constants/colors.pwn"
#include "modules/core/constants/ids.pwn"
#include "modules/core/constants/limits.pwn"

// Macros
#include "modules/core/macros/messages.pwn"

stock Float:cache_get_field_float(row, const field_name[]);
#include "modules/core/data/weather.pwn"
#include "modules/core/data/weapons.pwn"
#include "modules/core/data/animations.pwn"
