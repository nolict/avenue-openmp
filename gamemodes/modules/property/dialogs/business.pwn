/*
    File: modules/property/dialogs/business.pwn
    Purpose: Contains easyDialog callbacks for property business flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:BusinessBuy ======
Dialog:BusinessBuy(playerid, response, listitem, inputtext[])
{
	static
	    bizid = -1,
		price,
		string[64];

    if ((bizid = Business_Inside(playerid)) != -1 && response)
    {
        price = BusinessData[bizid][bizPrices][listitem];

        if (GetMoney(playerid) < price)
            return SendErrorMessage(playerid, "You have insufficient funds for the purchase.");

		if (BusinessData[bizid][bizProducts] < 1)
		    return SendErrorMessage(playerid, "This business is out of stock.");

		if (BusinessData[bizid][bizType] == 1 || BusinessData[bizid][bizType] == 6)
		{
		    switch (listitem)
		    {
		        case 0:
		        {
		            if (Inventory_HasItem(playerid, "Cellphone"))
		                return SendErrorMessage(playerid, "You have a cellphone already.");

					new id = Inventory_Add(playerid, "Cellphone", 330);

					if (id == -1)
        				return SendErrorMessage(playerid, "You don't have any inventory slots left.");

					PlayerData[playerid][pPhone] = random(90000) + 10000;

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a cellphone.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);

					format(string, sizeof(string), "Your new number is ~p~%d.", PlayerData[playerid][pPhone]);
					ShowPlayerFooter(playerid, string);

					SendServerMessage(playerid, "Your new number is %d.", PlayerData[playerid][pPhone]);
				}
				case 1:
		        {
		            if (Inventory_HasItem(playerid, "GPS System"))
		                return SendErrorMessage(playerid, "You have a GPS system already.");

					new id = Inventory_Add(playerid, "GPS System", 18875);

					if (id == -1)
        				return SendErrorMessage(playerid, "You don't have any inventory slots left.");

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a GPS System.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
				case 2:
		        {
		            if (Inventory_Count(playerid, "Spray Can") >= 3)
		                return SendErrorMessage(playerid, "You have 3 spray cans, you can't buy anymore.");

					new id = Inventory_Add(playerid, "Spray Can", 365);

					if (id == -1)
        				return SendErrorMessage(playerid, "You don't have any inventory slots left.");

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a can of spray paint.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
			    case 3:
			    {
			        if (Inventory_HasItem(playerid, "Backpack"))
		                return SendErrorMessage(playerid, "You have this item already.");

					new id = Inventory_Add(playerid, "Backpack", 3026);

					if (id == -1)
        				return SendErrorMessage(playerid, "You don't have any inventory slots left.");

					if (Backpack_Create(playerid) == -1)
					    return SendErrorMessage(playerid, "The server has reached the internal limit for backpacks.");

					SetAccessories(playerid);

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a backpack.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
				case 4:
		        {
		            if (Inventory_Count(playerid, "Water Bottle") >= 10)
		                return SendErrorMessage(playerid, "You have 10 bottles of water, you can't buy anymore.");

					new id = Inventory_Add(playerid, "Water Bottle", 2958);

					if (id == -1)
        				return SendErrorMessage(playerid, "You don't have any inventory slots left.");

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a bottle of water.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
				case 5:
		        {
              		if (Inventory_Count(playerid, "Soda") >= 5)
		                return SendErrorMessage(playerid, "You have 5 bottles of soda, you can't buy anymore.");

					new id = Inventory_Add(playerid, "Soda", 1543);

					if (id == -1)
        				return SendErrorMessage(playerid, "You don't have any inventory slots left.");

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a bottle of soda.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
				case 6:
				{
				    if (PlayerData[playerid][pLottery])
				        return SendErrorMessage(playerid, "You have a lottery ticket already.");

					Dialog_Show(playerid, LotteryNumber, DIALOG_STYLE_INPUT, "Lottery Number", "Please enter your desired lottery number below (from 1-60):", "Submit", "Cancel");
				}
				case 7:
		        {
		            if (Inventory_HasItem(playerid, "Portable Radio"))
		                return SendErrorMessage(playerid, "You have this item already.");

					new id = Inventory_Add(playerid, "Portable Radio", 18868);

					if (id == -1)
        				return SendErrorMessage(playerid, "You don't have any inventory slots left.");

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a portable radio.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
				case 8:
		        {
		            if (Inventory_Count(playerid, "Fuel Can") >= 3)
		                return SendErrorMessage(playerid, "You have 3 cans of fuel, you can't buy anymore.");

					new id = Inventory_Add(playerid, "Fuel Can", 1650);

					if (id == -1)
        				return SendErrorMessage(playerid, "You don't have any inventory slots left.");

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a can of fuel.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
				case 9:
		        {
		            if (Inventory_HasItem(playerid, "Crowbar"))
		                return SendErrorMessage(playerid, "You have a crowbar already.");

					new id = Inventory_Add(playerid, "Crowbar", 18634);

					if (id == -1)
        				return SendErrorMessage(playerid, "You don't have any inventory slots left.");

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a crowbar.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
			    case 10:
		        {
		            if (Inventory_HasItem(playerid, "Boombox"))
		                return SendErrorMessage(playerid, "You have a boombox already.");

					new id = Inventory_Add(playerid, "Boombox", 2226);

					if (id == -1)
        				return SendErrorMessage(playerid, "You don't have any inventory slots left.");

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a boombox.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
			    case 11:
		        {
		            if (Inventory_HasItem(playerid, "Mask"))
		                return SendErrorMessage(playerid, "You have a mask already.");

					if (PlayerData[playerid][pPlayingHours] < 5)
					    return SendErrorMessage(playerid, "You must have at least 5 playing hours.");

					new id = Inventory_Add(playerid, "Mask", 19036);

					if (id == -1)
        				return SendErrorMessage(playerid, "You don't have any inventory slots left.");

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a mask.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
				case 12:
		        {
		            if (Inventory_Count(playerid, "First Aid") >= 3)
		                return SendErrorMessage(playerid, "You have 3 first aid kits, you can't buy anymore.");

					new id = Inventory_Add(playerid, "First Aid", 1580);

					if (id == -1)
        				return SendErrorMessage(playerid, "You don't have any inventory slots left.");

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a first aid kit.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
				case 13:
		        {
		            if (Inventory_Count(playerid, "Repair Kit") >= 3)
		                return SendErrorMessage(playerid, "You have 3 repair kits, you can't buy anymore.");

					new id = Inventory_Add(playerid, "Repair Kit", 920);

					if (id == -1)
        				return SendErrorMessage(playerid, "You don't have any inventory slots left.");

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a repair kit.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
			    case 14:
		        {
		            if (Inventory_Count(playerid, "NOS Canister") >= 5)
		                return SendErrorMessage(playerid, "You have 5 canisters, you can't buy anymore.");

					new id = Inventory_Add(playerid, "NOS Canister", 1010);

					if (id == -1)
        				return SendErrorMessage(playerid, "You don't have any inventory slots left.");

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a NOS canister.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
				case 15:
		        {
		            if (PlayerHasWeapon(playerid, 5))
		                return SendErrorMessage(playerid, "You have this item already.");

					GiveWeaponToPlayer(playerid, 5, 1);

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a baseball bat.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
				case 16:
		        {
		            if (Inventory_Count(playerid, "Frozen Pizza") >= 3)
		                return SendErrorMessage(playerid, "You have 3 frozen pizzas, you can't buy anymore.");

					new id = Inventory_Add(playerid, "Frozen Pizza", 2814);

					if (id == -1)
        				return SendErrorMessage(playerid, "You don't have any inventory slots left.");

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a box of frozen pizza.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
				case 17:
		        {
		            if (Inventory_Count(playerid, "Frozen Burger") >= 5)
		                return SendErrorMessage(playerid, "You have 5 frozen burgers, you can't buy anymore.");

					new id = Inventory_Add(playerid, "Frozen Burger", 2768);

					if (id == -1)
        				return SendErrorMessage(playerid, "You don't have any inventory slots left.");

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a frozen burger.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
			}
		}
		else if (BusinessData[bizid][bizType] == 2)
		{
		    switch (listitem)
	    	{
		        case 0:
		        {
		            if (!Inventory_HasItem(playerid, "Weapon License"))
		                return SendErrorMessage(playerid, "This store only sells to people with a weapon license.");

		            if (Inventory_Count(playerid, "Magazine") >= 10)
		                return SendErrorMessage(playerid, "You have 10 magazines, you can't buy anymore.");

					new id = Inventory_Add(playerid, "Magazine", 2039);

					if (id == -1)
        				return SendErrorMessage(playerid, "You don't have any inventory slots left.");

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a weapon magazine.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
                case 1:
		        {
		            if (!Inventory_HasItem(playerid, "Weapon License"))
		                return SendErrorMessage(playerid, "This store only sells to people with a weapon license.");

		            if (Inventory_Count(playerid, "Ammo Cartridge") >= 10)
		                return SendErrorMessage(playerid, "You have 10 ammo cartridges, you can't buy anymore.");

					new id = Inventory_Add(playerid, "Ammo Cartridge", 2358);

					if (id == -1)
        				return SendErrorMessage(playerid, "You don't have any inventory slots left.");

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received an ammo cartridge.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
				case 2:
		        {
		            if (!Inventory_HasItem(playerid, "Weapon License"))
		                return SendErrorMessage(playerid, "This store only sells to people with a weapon license.");

		            if (Inventory_Count(playerid, "Armored Vest") >= 3)
		                return SendErrorMessage(playerid, "You have 3 armored vests, you can't buy anymore.");

					new id = Inventory_Add(playerid, "Armored Vest", 19142);

					if (id == -1)
        				return SendErrorMessage(playerid, "You don't have any inventory slots left.");

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received an armored vest.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
				case 3:
				{
				    if (!Inventory_HasItem(playerid, "Weapon License"))
				        return SendErrorMessage(playerid, "A weapon license is required to purchase from this store.");

				    if (PlayerData[playerid][pPlayingHours] < 5)
				        return SendErrorMessage(playerid, "You need at least 5 playing hours.");

                    if (Inventory_Count(playerid, "Desert Eagle") > 5)
					    return SendErrorMessage(playerid, "You can't carry anymore of this weapon.");

					Inventory_Add(playerid, "Desert Eagle", 348);

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a Desert Eagle.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
				case 4:
				{
				    if (!Inventory_HasItem(playerid, "Weapon License"))
				        return SendErrorMessage(playerid, "A weapon license is required to purchase from this store.");

				    if (PlayerData[playerid][pPlayingHours] < 5)
				        return SendErrorMessage(playerid, "You need at least 5 playing hours.");

                    if (Inventory_Count(playerid, "Shotgun") > 5)
					    return SendErrorMessage(playerid, "You can't carry anymore of this weapon.");

					Inventory_Add(playerid, "Shotgun", 349);

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a Remington 870.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
				case 5:
				{
				    if (!Inventory_HasItem(playerid, "Weapon License"))
				        return SendErrorMessage(playerid, "A weapon license is required to purchase from this store.");

				    if (PlayerData[playerid][pPlayingHours] < 5)
				        return SendErrorMessage(playerid, "You need at least 5 playing hours.");

					if (Inventory_Count(playerid, "Rifle") > 5)
					    return SendErrorMessage(playerid, "You can't carry anymore of this weapon.");

					Inventory_Add(playerid, "Rifle", 357);

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a M14 Rifle.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
		    }
		}
		else if (BusinessData[bizid][bizType] == 3)
		{
		    switch (listitem)
		    {
		        case 0:
				{
				    PlayerData[playerid][pClothesType] = 1;

					switch (PlayerData[playerid][pGender])
                    {
                        case 1:
                        	ShowModelSelectionMenu(playerid, "Clothes", MODEL_SELECTION_CLOTHES, g_aMaleSkins, sizeof(g_aMaleSkins), -16.0, 0.0, -55.0);

						case 2:
                       		ShowModelSelectionMenu(playerid, "Clothes", MODEL_SELECTION_CLOTHES, g_aFemaleSkins, sizeof(g_aFemaleSkins), -16.0, 0.0, -55.0);
                    }
				}
		        case 1:
				{
				    PlayerData[playerid][pClothesType] = 2;
					ShowModelSelectionMenu(playerid, "Glasses", MODEL_SELECTION_CLOTHES, {19006, 19007, 19008, 19009, 19010, 19011, 19012, 19013, 19014, 19015, 19016, 19017, 19018, 19019, 19020, 19021, 19022, 19023, 19024, 19025, 19026, 19027, 19028, 19029, 19030, 19031, 19032, 19033, 19034, 19035}, 30, 0.0, 0.0, 90.0);
				}
			    case 2:
				{
				    PlayerData[playerid][pClothesType] = 3;
					ShowModelSelectionMenu(playerid, "Hats", MODEL_SELECTION_CLOTHES, {18926, 18927, 18928, 18929, 18930, 18931, 18932, 18933, 18934, 18935, 18944, 18945, 18946, 18947, 18948, 18949, 18950, 18951}, 18, -20.0, -90.0, 0.0);
				}
				case 3:
				{
				    PlayerData[playerid][pClothesType] = 4;
					ShowModelSelectionMenu(playerid, "Bandanas", MODEL_SELECTION_CLOTHES, {18911, 18912, 18913, 18914, 18915, 18916, 18917, 18918, 18919, 18920}, 10, 80.0, -173.0, 0.0);
				}
		    }
		}
		else if (BusinessData[bizid][bizType] == 4)
		{
			switch (listitem)
			{
			    case 0:
			    {
			        if (PlayerData[playerid][pThirst] > 90)
			            return SendErrorMessage(playerid, "You are not thirsty right now.");

					PlayerData[playerid][pThirst] = (PlayerData[playerid][pThirst] + 10 > 100) ? (100) : (PlayerData[playerid][pThirst] + 10);

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received some water.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
			    case 1:
			    {
			        if (PlayerData[playerid][pThirst] > 90)
			            return SendErrorMessage(playerid, "You are not thirsty right now.");

					PlayerData[playerid][pThirst] = (PlayerData[playerid][pThirst] + 20 > 100) ? (100) : (PlayerData[playerid][pThirst] + 20);

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received some soda.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
			    case 2:
			    {
			        if (PlayerData[playerid][pHunger] > 90)
			            return SendErrorMessage(playerid, "You are not hungry right now.");

					PlayerData[playerid][pHunger] = (PlayerData[playerid][pHunger] + 20 > 100) ? (100) : (PlayerData[playerid][pHunger] + 20);

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received some french fries.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
			    case 3:
			    {
			        if (PlayerData[playerid][pHunger] > 90)
			            return SendErrorMessage(playerid, "You are not hungry right now.");

					PlayerData[playerid][pHunger] = (PlayerData[playerid][pHunger] + 25 > 100) ? (100) : (PlayerData[playerid][pHunger] + 25);

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a cheeseburger.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
			    case 4:
			    {
			        if (PlayerData[playerid][pHunger] > 90)
			            return SendErrorMessage(playerid, "You are not hungry right now.");

					PlayerData[playerid][pHunger] = (PlayerData[playerid][pHunger] + 30 > 100) ? (100) : (PlayerData[playerid][pHunger] + 30);

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a chicken burger.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
			    case 5:
			    {
			        if (PlayerData[playerid][pHunger] > 90)
			            return SendErrorMessage(playerid, "You are not hungry right now.");

					PlayerData[playerid][pHunger] = (PlayerData[playerid][pHunger] + 25 > 100) ? (100) : (PlayerData[playerid][pHunger] + 25);

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received some chicken nuggets.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
			    case 6:
			    {
			        if (PlayerData[playerid][pHunger] > 90)
			            return SendErrorMessage(playerid, "You are not hungry right now.");

					PlayerData[playerid][pHunger] = (PlayerData[playerid][pHunger] + 20 > 100) ? (100) : (PlayerData[playerid][pHunger] + 20);

					GiveMoney(playerid, -price);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a salad.", ReturnName(playerid, 0), FormatNumber(price));

					BusinessData[bizid][bizProducts]--;
					BusinessData[bizid][bizVault] += Tax_Percent(price);

					Business_Save(bizid);
					Tax_AddPercent(price);
			    }
			}
		}
		else if (BusinessData[bizid][bizType] == 7)
		{
		    new
				items[50] = {-1, ...},
				count;

		    for (new i = 0; i < sizeof(g_aFurnitureData); i ++) if (g_aFurnitureData[i][e_FurnitureType] == listitem + 1) {
				items[count++] = g_aFurnitureData[i][e_FurnitureModel];
		    }
		    PlayerData[playerid][pFurnitureType] = listitem;

			if (listitem == 3) {
				ShowModelSelectionMenu(playerid, "Furniture", MODEL_SELECTION_FURNITURE, items, count, -12.0, 0.0, 0.0);
			}
			else {
			    ShowModelSelectionMenu(playerid, "Furniture", MODEL_SELECTION_FURNITURE, items, count);
			}
		}
	}
    return 1;
}

// ====== Dialog:LotteryNumber ======
Dialog:LotteryNumber(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new bizid = Business_Inside(playerid);

	    if (bizid != -1)
	    {
	        if (isnull(inputtext) || (strval(inputtext) < 1 || strval(inputtext) > 60)) {
	            return Dialog_Show(playerid, LotteryNumber, DIALOG_STYLE_INPUT, "Lottery Number", "Please enter your desired lottery number below (from 1-60):", "Submit", "Cancel");
			}
	        PlayerData[playerid][pLottery] = strval(inputtext);
	        PlayerData[playerid][pLotteryB] = 1;

		    GiveMoney(playerid, -BusinessData[bizid][bizPrices][6]);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has paid %s and received a lottery ticket.", ReturnName(playerid, 0), FormatNumber(BusinessData[bizid][bizPrices][6]));

			BusinessData[bizid][bizProducts]--;
			BusinessData[bizid][bizVault] += Tax_Percent(BusinessData[bizid][bizPrices][6]);

			Business_Save(bizid);
			Tax_AddPercent(BusinessData[bizid][bizPrices][6]);
		}
	}
	return 1;
}

// ====== Dialog:EditProduct ======
Dialog:EditProduct(playerid, response, listitem, inputtext[])
{
	static
	    bizid = -1;

	if ((bizid = Business_Inside(playerid)) != -1 && Business_IsOwner(playerid, bizid))
	{
		if (response)
		{
		    static
		        item[24];

		    strmid(item, inputtext, 0, strfind(inputtext, "-") - 1);
		    strpack(PlayerData[playerid][pEditingItem], item, 32 char);

            PlayerData[playerid][pProductModify] = listitem;
      		Dialog_Show(playerid, PriceSet, DIALOG_STYLE_INPUT, "Business: Set Price", "Please enter the new product price for \"%s\":", "Modify", "Back", item);
		}
	}
	return 1;
}

// ====== Dialog:PriceSet ======
Dialog:PriceSet(playerid, response, listitem, inputtext[])
{
    static
	    bizid = -1,
		item[32];

	if ((bizid = Business_Inside(playerid)) != -1 && Business_IsOwner(playerid, bizid))
	{
		if (response)
		{
		    strunpack(item, PlayerData[playerid][pEditingItem]);

			if (isnull(inputtext))
			    return Dialog_Show(playerid, PriceSet, DIALOG_STYLE_INPUT, "Business: Set Price", "Please enter the new product price for \"%s\":", "Modify", "Back", item);

			if (strval(inputtext) < 1 || strval(inputtext) > 2000)
			    return Dialog_Show(playerid, PriceSet, DIALOG_STYLE_INPUT, "Business: Set Price", "Please enter the new product price for \"%s\" ($1 to $2,000):", "Modify", "Back", item);

			BusinessData[bizid][bizPrices][PlayerData[playerid][pProductModify]] = strval(inputtext);
			Business_Save(bizid);

			SendServerMessage(playerid, "You have adjusted the price of \"%s\" to: %s!", item, FormatNumber(strval(inputtext)));
			Business_ProductMenu(playerid, bizid);
		}
		else
		{
		    Business_ProductMenu(playerid, bizid);
		}
	}
	return 1;
}

