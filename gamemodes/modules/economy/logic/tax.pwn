/*
    File: modules/economy/logic/tax.pwn
    Purpose: Contains economy gameplay logic and helper functions for tax.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== Tax_Percent ======
stock Tax_Percent(price)
{
	return floatround((float(price) / 100) * 85);
}

// ====== Tax_AddMoney ======
stock Tax_AddMoney(amount)
{
	g_TaxVault = g_TaxVault + amount;

	Server_Save();

	return 0;
}

// ====== Tax_AddPercent ======
stock Tax_AddPercent(price)
{
	new money = (price - Tax_Percent(price));

	g_TaxVault = g_TaxVault + money;

	Server_Save();
	return 1;
}
