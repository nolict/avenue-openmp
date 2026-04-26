/*
    File: modules/economy/dialogs/banking.pwn
    Purpose: Contains easyDialog callbacks for economy banking flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:BankAccount ======
Dialog:BankAccount(playerid, response, listitem, inputtext[])
{
	if (!IsPlayerInBank(playerid) && ATM_Nearest(playerid) == -1)
	    return 0;

	if (response)
	{
	    switch (listitem)
	    {
	        case 0:
	        {
				Dialog_Show(playerid, Withdraw, DIALOG_STYLE_INPUT, DialogStyle_Title("Withdraw funds"), DialogStyle_Body("Your bank account's balance: %s\n\nPlease enter the amount of money you wish to withdraw:"), "Withdraw", "Back", FormatNumber(PlayerData[playerid][pBankMoney]));
			}
	        case 1:
	        {
				Dialog_Show(playerid, Deposit, DIALOG_STYLE_INPUT, DialogStyle_Title("Deposit funds"), DialogStyle_Body("Your bank account's balance: %s\n\nPlease enter the amount of money you wish to deposit:"), "Deposit", "Back", FormatNumber(PlayerData[playerid][pBankMoney]));
			}
			case 2:
			{
			    Dialog_Show(playerid, Transfer, DIALOG_STYLE_INPUT, DialogStyle_Title("Make a transfer"), DialogStyle_Body("Your bank account's balance: %s\n\nPlease enter the name or ID of the player below:"), "Continue", "Back", FormatNumber(PlayerData[playerid][pBankMoney]));
			}
	    }
	}
	else
	{
	    Dialog_Show(playerid, Bank, DIALOG_STYLE_LIST, DialogStyle_Title("Bank Account"), DialogStyle_Body("Bank Balance: %s\nSavings Balance: %s"), "Select", "Cancel", FormatNumber(PlayerData[playerid][pBankMoney]), FormatNumber(PlayerData[playerid][pSavings]));
	}
	return 1;
}

// ====== Dialog:Transfer ======
Dialog:Transfer(playerid, response, listitem, inputtext[])
{
	if (!IsPlayerInBank(playerid) && ATM_Nearest(playerid) == -1)
	    return 0;

	if (response)
	{
	    static
	        userid;

		if (sscanf(inputtext, "u", userid))
		    return Dialog_Show(playerid, Transfer, DIALOG_STYLE_INPUT, DialogStyle_Title("Make a transfer"), DialogStyle_Body("Your bank account's balance: %s\n\nPlease enter the name or ID of the player below:"), "Continue", "Back", FormatNumber(PlayerData[playerid][pBankMoney]));

		if (userid == INVALID_PLAYER_ID)
		    return Dialog_Show(playerid, Transfer, DIALOG_STYLE_INPUT, DialogStyle_Title("Make a transfer"), DialogStyle_Body("Error: Invalid player specified.\n\nYour bank account's balance: %s\n\nPlease enter the name or ID of the player below:"), "Continue", "Back", FormatNumber(PlayerData[playerid][pBankMoney]));

		if (userid == playerid)
		    return Dialog_Show(playerid, Transfer, DIALOG_STYLE_INPUT, DialogStyle_Title("Make a transfer"), DialogStyle_Body("Error: You can't transfer funds to yourself.\n\nYour bank account's balance: %s\n\nPlease enter the name or ID of the player below:"), "Continue", "Back", FormatNumber(PlayerData[playerid][pBankMoney]));

		PlayerData[playerid][pTransfer] = userid;
		Dialog_Show(playerid, TransferCash, DIALOG_STYLE_INPUT, DialogStyle_Title("Make a transfer"), DialogStyle_Body("Your bank account's balance: %s\n\nPlease enter the amount of money to transfer to %s:"), "Continue", "Back", FormatNumber(PlayerData[playerid][pBankMoney]), ReturnName(PlayerData[playerid][pTransfer], 0));
	}
    else {
	    Dialog_Show(playerid, BankAccount, DIALOG_STYLE_LIST, DialogStyle_Title("Bank Account"), DialogStyle_Body("Withdraw funds\nDeposit funds\nMake a transfer"), "Select", "Back");
	}
	return 1;
}

// ====== Dialog:TransferCash ======
Dialog:TransferCash(playerid, response, listitem, inputtext[])
{
	if (!IsPlayerInBank(playerid) && ATM_Nearest(playerid) == -1)
	    return 0;

	if (response)
	{
	    new amount = strval(inputtext);

	    if (isnull(inputtext))
	        return Dialog_Show(playerid, TransferCash, DIALOG_STYLE_INPUT, DialogStyle_Title("Make a transfer"), DialogStyle_Body("Your bank account's balance: %s\n\nPlease enter the amount of money to transfer to %s:"), "Continue", "Back", FormatNumber(PlayerData[playerid][pBankMoney]), ReturnName(PlayerData[playerid][pTransfer], 0));

		if (amount < 1 || amount > PlayerData[playerid][pBankMoney])
			return Dialog_Show(playerid, TransferCash, DIALOG_STYLE_INPUT, DialogStyle_Title("Make a transfer"), DialogStyle_Body("Error: Insufficient funds!\n\nYour bank account's balance: %s\n\nPlease enter the amount of money to transfer to %s:"), "Continue", "Back", FormatNumber(PlayerData[playerid][pBankMoney]), ReturnName(PlayerData[playerid][pTransfer], 0));

		if (!strcmp(PlayerData[playerid][pIP], PlayerData[PlayerData[playerid][pTransfer]][pIP])) {
		    SendAdminAlert(COLOR_LIGHTRED, "ADMIN: %s (%s) has transferred %s to %s (%s).", ReturnName(playerid, 0), PlayerData[playerid][pIP], FormatNumber(amount), ReturnName(PlayerData[playerid][pTransfer], 0), PlayerData[playerid][pIP]);
		}
		PlayerData[playerid][pBankMoney] -= amount;
		PlayerData[PlayerData[playerid][pTransfer]][pBankMoney] += amount;

	    SendServerMessage(playerid, "You have transferred %s to %s's bank account.", FormatNumber(amount), ReturnName(PlayerData[playerid][pTransfer], 0));
	    SendServerMessage(PlayerData[playerid][pTransfer], "%s has transferred %s into your bank account.", ReturnName(playerid, 0), FormatNumber(amount));

        Dialog_Show(playerid, BankAccount, DIALOG_STYLE_LIST, DialogStyle_Title("Bank Account"), DialogStyle_Body("Withdraw funds\nDeposit funds\nMake a transfer"), "Select", "Back");
        Log_Write("logs/transfer_log.txt", "[%s] %s (%s) has transferred %s to %s (%s).", ReturnDate(), ReturnName(playerid), PlayerData[playerid][pIP], FormatNumber(amount), ReturnName(PlayerData[playerid][pTransfer]), PlayerData[PlayerData[playerid][pTransfer]][pIP]);
	}
	else {
	    Dialog_Show(playerid, BankAccount, DIALOG_STYLE_LIST, DialogStyle_Title("Bank Account"), DialogStyle_Body("Withdraw funds\nDeposit funds\nMake a transfer"), "Select", "Back");
	}
	return 1;
}

// ====== Dialog:Savings ======
Dialog:Savings(playerid, response, listitem, inputtext[])
{
	if (!IsPlayerInBank(playerid) && ATM_Nearest(playerid) == -1)
	    return 0;

	if (response)
	{
	    switch (listitem)
	    {
	        case 0:
	        {
				Dialog_Show(playerid, SavingsWithdraw, DIALOG_STYLE_INPUT, DialogStyle_Title("Withdraw funds"), DialogStyle_Body("Your savings account's balance: %s\n\nPlease enter the amount of money you wish to withdraw:"), "Withdraw", "Back", FormatNumber(PlayerData[playerid][pSavings]));
			}
	        case 1:
	        {
				Dialog_Show(playerid, SavingsDeposit, DIALOG_STYLE_INPUT, DialogStyle_Title("Deposit funds"), DialogStyle_Body("Your savings account's balance: %s\n\nPlease enter the amount of money you wish to deposit:"), "Deposit", "Back", FormatNumber(PlayerData[playerid][pSavings]));
			}
	    }
	}
	else
	{
	    Dialog_Show(playerid, Bank, DIALOG_STYLE_LIST, DialogStyle_Title("Bank Account"), DialogStyle_Body("Bank Balance: %s\nSavings Balance: %s"), "Select", "Cancel", FormatNumber(PlayerData[playerid][pBankMoney]), FormatNumber(PlayerData[playerid][pSavings]));
	}
	return 1;
}

// ====== Dialog:Withdraw ======
Dialog:Withdraw(playerid, response, listitem, inputtext[])
{
	if (!IsPlayerInBank(playerid) && ATM_Nearest(playerid) == -1)
	    return 0;

	if (response)
	{
	    new amount = strval(inputtext);

	    if (isnull(inputtext))
	        return Dialog_Show(playerid, Withdraw, DIALOG_STYLE_INPUT, DialogStyle_Title("Withdraw funds"), DialogStyle_Body("Your bank account's balance: %s\n\nPlease enter the amount of money you wish to withdraw:"), "Withdraw", "Back", FormatNumber(PlayerData[playerid][pBankMoney]));

		if (amount < 1 || amount > PlayerData[playerid][pBankMoney])
			return Dialog_Show(playerid, Withdraw, DIALOG_STYLE_INPUT, DialogStyle_Title("Withdraw funds"), DialogStyle_Body("Error: Insufficient funds!\n\nYour bank account's balance: %s\n\nPlease enter the amount of money you wish to withdraw:"), "Withdraw", "Back", FormatNumber(PlayerData[playerid][pBankMoney]));

		PlayerData[playerid][pBankMoney] -= amount;
	    GiveMoney(playerid, amount);

	    SendServerMessage(playerid, "You have withdrawn %s from your bank account.", FormatNumber(amount));
        Dialog_Show(playerid, Withdraw, DIALOG_STYLE_INPUT, DialogStyle_Title("Withdraw funds"), DialogStyle_Body("Your bank account's balance: %s\n\nPlease enter the amount of money you wish to withdraw:"), "Withdraw", "Back", FormatNumber(PlayerData[playerid][pBankMoney]));
	}
	else {
	    Dialog_Show(playerid, BankAccount, DIALOG_STYLE_LIST, DialogStyle_Title("Bank Account"), DialogStyle_Body("Withdraw funds\nDeposit funds\nMake a transfer"), "Select", "Back");
	}
	return 1;
}

// ====== Dialog:Deposit ======
Dialog:Deposit(playerid, response, listitem, inputtext[])
{
	if (!IsPlayerInBank(playerid) && ATM_Nearest(playerid) == -1)
	    return 0;

	if (response)
	{
	    new amount = strval(inputtext);

	    if (isnull(inputtext))
	        return Dialog_Show(playerid, Deposit, DIALOG_STYLE_INPUT, DialogStyle_Title("Deposit funds"), DialogStyle_Body("Your bank account's balance: %s\n\nPlease enter the amount of money you wish to deposit:"), "Deposit", "Back", FormatNumber(PlayerData[playerid][pBankMoney]));

		if (amount < 1 || amount > GetMoney(playerid))
			return Dialog_Show(playerid, Deposit, DIALOG_STYLE_INPUT, DialogStyle_Title("Deposit funds"), DialogStyle_Body("Error: You don't have that much.\n\nYour bank account's balance: %s\n\nPlease enter the amount of money you wish to deposit:"), "Deposit", "Back", FormatNumber(PlayerData[playerid][pBankMoney]));

		PlayerData[playerid][pBankMoney] += amount;
	    GiveMoney(playerid, -amount);

	    SendServerMessage(playerid, "You have deposited %s into your bank account.", FormatNumber(amount));
        Dialog_Show(playerid, Deposit, DIALOG_STYLE_INPUT, DialogStyle_Title("Deposit funds"), DialogStyle_Body("Your bank account's balance: %s\n\nPlease enter the amount of money you wish to deposit:"), "Deposit", "Back", FormatNumber(PlayerData[playerid][pBankMoney]));
	}
	else {
	    Dialog_Show(playerid, BankAccount, DIALOG_STYLE_LIST, DialogStyle_Title("Bank Account"), DialogStyle_Body("Withdraw funds\nDeposit funds\nMake a transfer"), "Select", "Back");
	}
	return 1;
}

// ====== Dialog:SavingsWithdraw ======
Dialog:SavingsWithdraw(playerid, response, listitem, inputtext[])
{
	if (!IsPlayerInBank(playerid) && ATM_Nearest(playerid) == -1)
	    return 0;

	if (response)
	{
	    new amount = strval(inputtext);

	    if (isnull(inputtext))
	        return Dialog_Show(playerid, SavingsWithdraw, DIALOG_STYLE_INPUT, DialogStyle_Title("Withdraw funds"), DialogStyle_Body("Your savings account's balance: %s\n\nPlease enter the amount of money you wish to withdraw:"), "Withdraw", "Back", FormatNumber(PlayerData[playerid][pSavings]));

		if (amount < 1 || amount > PlayerData[playerid][pSavings])
			return Dialog_Show(playerid, SavingsWithdraw, DIALOG_STYLE_INPUT, DialogStyle_Title("Withdraw funds"), DialogStyle_Body("Error: Insufficient funds!\n\nYour savings account's balance: %s\n\nPlease enter the amount of money you wish to withdraw:"), "Withdraw", "Back", FormatNumber(PlayerData[playerid][pSavings]));

		PlayerData[playerid][pSavings] -= amount;
	    GiveMoney(playerid, amount);

	    SendServerMessage(playerid, "You have withdrawn %s from your savings account.", FormatNumber(amount));
        Dialog_Show(playerid, SavingsWithdraw, DIALOG_STYLE_INPUT, DialogStyle_Title("Withdraw funds"), DialogStyle_Body("Your savings account's balance: %s\n\nPlease enter the amount of money you wish to withdraw:"), "Withdraw", "Back", FormatNumber(PlayerData[playerid][pSavings]));
	}
	else {
	    Dialog_Show(playerid, Savings, DIALOG_STYLE_LIST, DialogStyle_Title("Savings Account"), DialogStyle_Body("Withdraw funds\nDeposit funds"), "Select", "Back");
	}
	return 1;
}

// ====== Dialog:SavingsDeposit ======
Dialog:SavingsDeposit(playerid, response, listitem, inputtext[])
{
	if (!IsPlayerInBank(playerid) && ATM_Nearest(playerid) == -1)
	    return 0;

	if (response)
	{
	    new amount = strval(inputtext);

	    if (isnull(inputtext))
	        return Dialog_Show(playerid, SavingsDeposit, DIALOG_STYLE_INPUT, DialogStyle_Title("Deposit funds"), DialogStyle_Body("Your savings account's balance: %s\n\nPlease enter the amount of money you wish to deposit:"), "Deposit", "Back", FormatNumber(PlayerData[playerid][pSavings]));

		if (amount < 1 || amount > GetMoney(playerid))
			return Dialog_Show(playerid, SavingsDeposit, DIALOG_STYLE_INPUT, DialogStyle_Title("Deposit funds"), DialogStyle_Body("Error: You don't have that much.\n\nYour savings account's balance: %s\n\nPlease enter the amount of money you wish to deposit:"), "Deposit", "Back", FormatNumber(PlayerData[playerid][pSavings]));

		PlayerData[playerid][pSavings] += amount;
	    GiveMoney(playerid, -amount);

	    SendServerMessage(playerid, "You have deposited %s into your savings account.", FormatNumber(amount));
        Dialog_Show(playerid, SavingsDeposit, DIALOG_STYLE_INPUT, DialogStyle_Title("Deposit funds"), DialogStyle_Body("Your savings account's balance: %s\n\nPlease enter the amount of money you wish to deposit:"), "Deposit", "Back", FormatNumber(PlayerData[playerid][pSavings]));
	}
	else {
	    Dialog_Show(playerid, Savings, DIALOG_STYLE_LIST, DialogStyle_Title("Savings Account"), DialogStyle_Body("Withdraw funds\nDeposit funds"), "Select", "Back");
	}
	return 1;
}

// ====== Dialog:Bank ======
Dialog:Bank(playerid, response, listitem, inputtext[])
{
	if (!IsPlayerInBank(playerid) && ATM_Nearest(playerid) == -1)
	    return 0;

	if (response)
	{
	    switch (listitem)
	    {
	        case 0:
	        {
				Dialog_Show(playerid, BankAccount, DIALOG_STYLE_LIST, DialogStyle_Title("Bank Account"), DialogStyle_Body("Withdraw funds\nDeposit funds\nMake a transfer"), "Select", "Back");
			}
			case 1:
			{
				Dialog_Show(playerid, Savings, DIALOG_STYLE_LIST, DialogStyle_Title("Savings Account"), DialogStyle_Body("Withdraw funds\nDeposit funds"), "Select", "Back");
			}
		}
	}
	return 1;
}

