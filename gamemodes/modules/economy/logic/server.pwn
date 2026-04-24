/*
    File: modules/economy/logic/server.pwn
    Purpose: Contains economy gameplay logic and helper functions for server.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

forward LotteryUpdate();
Server_Save()
{
	new
	    File:file = fopen("server.ini", io_write),
	    str[128];

	format(str, sizeof(str), "TaxMoney = %d\n", g_TaxVault);
	return (fwrite(file, str), fclose(file));
}

Server_Load()
{
	new File:file = fopen("server.ini", io_read);

	if (file) {
		g_TaxVault = file_parse_int(file, "TaxMoney");

		fclose(file);
	}
	return 1;
}

// ====== LotteryUpdate ======
public LotteryUpdate()
{
	new
		number = random(60) + 1,
		jackpot = random(2000) + 1000;

	foreach (new i : Player)
	{
	    if(PlayerData[i][pLotteryB] == 1)
	    {
			if (PlayerData[i][pLottery] == number)
			{
				GiveMoney(i, jackpot);
				SendServerMessage(i, "You have won the lottery jackpot of %s!", FormatNumber(jackpot));
			}
			else
			{
		    	SendClientMessage(i, COLOR_WHITE, "[LOTTERY]: You didn't win the lottery draw this time.");
			}
			PlayerData[i][pLottery] = 0;
			PlayerData[i][pLotteryB] = 0;
		}
	}
	return 1;
}
