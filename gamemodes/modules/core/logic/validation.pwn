/*
    File: modules/core/logic/validation.pwn
    Purpose: Contains core gameplay logic and helper functions for validation.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

Core_IsNumeric(const str[])
{
	for (new i = 0, l = strlen(str); i != l; i ++)
	{
	    if (i == 0 && str[0] == '-')
			continue;

	    else if (str[i] < '0' || str[i] > '9')
			return 0;
	}
	return 1;
}

