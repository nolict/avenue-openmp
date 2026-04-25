/*
    File: modules/core/logic/timers.pwn
    Purpose: Contains core gameplay logic and helper functions for timers.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

forward WeatherRotator();

// ====== RestartCheck ======
stock RestartCheck()
{
	static
	    time[3],
		string[32];

	if (g_ServerRestart == 1 && !g_RestartTime)
	{
		foreach (new i : Player) {
		    SQL_SaveCharacter(i);
		    SetPlayerName(i, PlayerData[i][pUsername]);
		}
		SendRconCommand("gmx");
	}
	else if (g_ServerRestart == 1) {
		GetElapsedTime(g_RestartTime--, time[0], time[1], time[2]);

		format(string, 32, "~r~Server Restart:~w~ %02d:%02d", time[1], time[2]);
	    TextDrawSetString(gServerTextdraws[3], string);
	}
	return 1;
}

// ====== TotalledCheck ======
stock TotalledCheck()
{
	static
	    Float:fHealth;

	for (new i = 1; i != MAX_VEHICLES; i ++) if (IsValidVehicle(i) && GetVehicleHealth(i, fHealth) && fHealth < 300.0) {
	    SetVehicleHealth(i, 300.0);
	    SetEngineStatus(i, false);
	}
	return 1;
}

forward MinuteCheck();

// ====== MinuteCheck ======
public MinuteCheck()
{
	static
	    Float:hp;

    foreach (new i : Player)
	{
	    if (!PlayerData[i][pLogged] && !PlayerData[i][pCharacter])
	        continue;

        PlayerData[i][pMinutes]++;

        if (PlayerData[i][pMinutes] >= 60)
       	{
       	    new paycheck = random(100) + 100;

        	PlayerData[i][pMinutes] = 0;

			PlayerData[i][pPlayingHours]++;
			PlayerData[i][pBankMoney] += paycheck;

			if(PlayerData[i][pOwnsBillboard] >= 0)
			{
			    if(PlayerData[i][pBankMoney] >= BillBoardData[PlayerData[i][pOwnsBillboard]][bbPrice])
			    {
				    SendClientMessage(i, COLOR_GREY, "-----------------------------------------------------------");
	         		SendClientMessageEx(i, COLOR_WHITE, "Your {33CC33}%s{FFFFFF} paycheck was added to your bank account.", FormatNumber(paycheck));
	         		SendClientMessageEx(i, COLOR_WHITE, "{33CC33}%s{FFFFFF} has been deducted from your bank account for billboard fees", FormatNumber(BillBoardData[PlayerData[i][pOwnsBillboard]][bbPrice]));
					SendClientMessage(i, COLOR_GREY, "-----------------------------------------------------------");
					PlayerData[i][pBankMoney] -= BillBoardData[PlayerData[i][pOwnsBillboard]][bbPrice];
					Tax_AddMoney(BillBoardData[PlayerData[i][pOwnsBillboard]][bbPrice]);
					return 1;
				}
                if(PlayerData[i][pBankMoney] < BillBoardData[PlayerData[i][pOwnsBillboard]][bbPrice])
			    {
			        SendClientMessage(i, COLOR_GREY, "-----------------------------------------------------------");
	         		SendClientMessageEx(i, COLOR_WHITE, "Your {33CC33}%s{FFFFFF} paycheck was added to your bank account.", FormatNumber(paycheck));
	         		SendClientMessageEx(i, COLOR_LIGHTRED, "You cannot afford to pay for your billboard anymore, therefor it has been unrented");
					SendClientMessage(i, COLOR_GREY, "-----------------------------------------------------------");
					BillBoardData[PlayerData[i][pOwnsBillboard]][bbOwner] = 0;
					Billboard_Save(PlayerData[i][pOwnsBillboard]);
					Billboard_Refresh(PlayerData[i][pOwnsBillboard]);
					PlayerData[i][pOwnsBillboard] = -1;
				}
				return 1;
			}

         	SendClientMessage(i, COLOR_GREY, "-----------------------------------------------------------");
         	SendClientMessageEx(i, COLOR_WHITE, "Your {33CC33}%s{FFFFFF} paycheck was added to your bank account.", FormatNumber(paycheck));
			SendClientMessage(i, COLOR_GREY, "-----------------------------------------------------------");
		}

		if (PlayerData[i][pInjured])
		{
		    GetPlayerHealth(i, hp);
		    SetPlayerHealth(i, hp - 10.0);
		}
	}
	for (new i = 0; i != MAX_DRUG_PLANTS; i ++) if (PlantData[i][plantExists] && PlantData[i][plantDrugs] < Plant_MaxGrams(PlantData[i][plantType])) {
	    PlantData[i][plantDrugs]++;

	    Plant_Refresh(i);
	    Plant_Save(i);
	}
	return 1;
}

forward PlayerCheck();

// ====== PlayerCheck ======
public PlayerCheck()
{
	static
		str[128],
		Float:health,
		id = -1;

	TotalledCheck();
	RestartCheck();

	foreach (new i : Player)
	{
	    if (!PlayerData[i][pLogged] && !PlayerData[i][pCharacter])
	        continue;

		if (PlayerData[i][pTutorial] > 0)
		{
		    PlayerData[i][pTutorialTime]--;

		    if (PlayerData[i][pTutorialTime] < 1)
		    {
		        switch (PlayerData[i][pTutorial])
		        {
		            case 1:
		            {
		                PlayerData[i][pTutorial] = 2;
		                PlayerData[i][pTutorialTime] = 10;

		                PlayerTextDrawSetString(i, PlayerData[i][pTextdraws][59], "Tutorial: Driving School");
		                PlayerTextDrawSetString(i, PlayerData[i][pTextdraws][60], "This is the ~g~~h~Driving School~w~. You can take~n~your driving test here. To pass, you must~n~avoid the obstacles.");
		                PlayerTextDrawSetString(i, PlayerData[i][pTextdraws][61], "A driving license is required to drive~n~legally in this state. Reckless driving~n~or driving unlicensed can alert police!");

						#if SERVER_CITY == 1
                            SetPlayerPos(i, 1967.677978, -1991.190795, -3.260505);
							InterpolateCameraPos(i, 1642.303344, -2327.007568, 15.672925, 1967.677978, -1991.190795, 16.739494, 2000);
							InterpolateCameraLookAt(i, 1642.292968, -2327.523193, 15.546875, 1968.177246, -1991.205078, 16.651542, 2000);
                        #elseif SERVER_CITY == 2
			                SetPlayerPos(i, -2026.765991, -84.237663, 21.766628);
							InterpolateCameraPos(i, -2399.519287, 321.964355, 37.035743, -2026.765991, -84.237663, 41.766628, 2000);
							InterpolateCameraLookAt(i, -2399.951416, 322.215942, 37.015625, -2026.787597, -84.917533, 41.520622, 2000);
						#elseif SERVER_CITY == 3
			                SetPlayerPos(i, 1168.088500, 1381.582641, -3.185750);
							InterpolateCameraPos(i, 1711.642089, 1448.227294, 13.340233, 1168.088500, 1381.582641, 16.814249, 2000);
							InterpolateCameraLookAt(i, 1711.144897, 1448.224365, 13.289665, 1168.084472, 1381.082641, 16.674325, 2000);
						#endif
			        }
                    case 2:
		            {
		                PlayerData[i][pTutorial] = 3;
		                PlayerData[i][pTutorialTime] = 10;

		                PlayerTextDrawSetString(i, PlayerData[i][pTextdraws][59], "Tutorial: Dealership");
		                PlayerTextDrawSetString(i, PlayerData[i][pTextdraws][60], "This is the ~g~~h~Dealership~w~. You can buy~n~a privately owned vehicle for yourself~n~at a listed price.");
		                PlayerTextDrawSetString(i, PlayerData[i][pTextdraws][61], "Remember to ~b~~h~/park~w~ your vehicle! Your vehicle~n~can be impounded if it is not parked~n~properly.");

						#if SERVER_CITY == 1
						    SetPlayerPos(i, 546.784729, -1256.438354, 15.406070);
							InterpolateCameraPos(i, 1967.677978, -1991.190795, 16.739494, 546.784729, -1256.438354, 35.406070, 2000);
							InterpolateCameraLookAt(i, 1968.177246, -1991.205078, 16.651542, 546.749816, -1256.937133, 35.216030, 2000);
						#elseif SERVER_CITY == 2
			                SetPlayerPos(i, -2006.275146, 287.903869, 28.095851);
							InterpolateCameraPos(i, -2026.765991, -84.237663, 41.766628, -2006.275146, 287.903869, 48.095851, 2000);
							InterpolateCameraLookAt(i, -2026.787597, -84.917533, 41.520622, -2005.739257, 287.892669, 47.936939, 2000);
						#elseif SERVER_CITY == 3
                   			SetPlayerPos(i, 1635.780761, 1828.321289, 5.649860);
							InterpolateCameraPos(i, 1168.088500, 1381.582641, 16.814249, 1635.780761, 1828.321289, 25.649860, 2000);
							InterpolateCameraLookAt(i, 1168.084472, 1381.082641, 16.674325, 1636.280517, 1828.325683, 25.5048842, 2000);
						#endif
				    }
		            case 3:
		            {
		                PlayerData[i][pTutorial] = 4;
		                PlayerData[i][pTutorialTime] = 10;

		                PlayerTextDrawSetString(i, PlayerData[i][pTextdraws][59], "Tutorial: Jobs");
		                PlayerTextDrawSetString(i, PlayerData[i][pTextdraws][60], "There are many job options around the city,~n~and this one is the ~r~~h~Courier~w~ job.");
		                PlayerTextDrawSetString(i, PlayerData[i][pTextdraws][61], "Many other jobs can also earn income.~n~Use ~g~~h~/joblist~w~ to find the job~n~you want!");

						#if SERVER_CITY == 1
						    SetPlayerPos(i, 2420.203857, -2089.423095, -1.058326);
							InterpolateCameraPos(i, 556.450866, -1260.044677, 20.433259, 2420.203857, -2089.423095, 18.941673, 2000);
							InterpolateCameraLookAt(i, 556.276916, -1260.619628, 20.427263, 2420.703613, -2089.426269, 18.879707, 2000);
						#elseif SERVER_CITY == 2
			                SetPlayerPos(i, -1683.220336, -7.236631, -4.830643);
							InterpolateCameraPos(i, -2006.275146, 287.903869, 48.095851, -1683.220336, -7.236631, 15.169356, 2000);
							InterpolateCameraLookAt(i, -2005.739257, 287.892669, 47.936939, -1682.866577, -6.893327, 15.087323, 2000);
						#elseif SERVER_CITY == 3
			                SetPlayerPos(i, 1012.894348, 2137.586425, -4.546604);
							InterpolateCameraPos(i, 1635.780761, 1828.321289, 25.649860, 1012.894348, 2137.586425, 15.453395, 2000);
							InterpolateCameraLookAt(i, 1636.280517, 1828.325683, 25.504884, 1013.393859, 2137.540283, 15.364944, 2000);
						#endif
			        }
		            case 4:
		            {
		                PlayerData[i][pTutorial] = 5;
		                PlayerData[i][pTutorialTime] = 10;

		                PlayerTextDrawSetString(i, PlayerData[i][pTextdraws][59], "Tutorial: Real Estate");
		                PlayerTextDrawSetString(i, PlayerData[i][pTextdraws][60], "There are many real estate opportunities~n~in San Andreas. To buy a house, type ~g~~h~/buy~n~~w~near the house icon.");
		                PlayerTextDrawSetString(i, PlayerData[i][pTextdraws][61], "You can also buy furniture and store~n~items in your house. Type ~g~~h~/help~w~ to view~n~the house command list.");

						#if SERVER_CITY == 1
						    SetPlayerPos(i, 1149.126586, -744.422912, 84.984420);
							InterpolateCameraPos(i, 2420.203857, -2089.423095, 18.941673, 1149.126586, -744.422912, 104.984420, 2000);
							InterpolateCameraLookAt(i, 2420.703613, -2089.426269, 18.879707, 1148.626708, -744.411132, 104.823509, 2000);
						#elseif SERVER_CITY == 2
			                SetPlayerPos(i, -2507.954101, 1125.971801, 44.563232);
							InterpolateCameraPos(i, 1683.220336, -7.236631, 15.169356, -2507.954101, 1125.971801, 64.563232, 2000);
							InterpolateCameraLookAt(i, -1682.866577, -6.893327, 15.087323, -2507.928710, 1126.796386, 64.145462, 2000);
						#elseif SERVER_CITY == 3
			                SetPlayerPos(i, 1380.143676, 2532.807373, -2.440540);
							InterpolateCameraPos(i, 1012.894348, 2137.586425, 15.453395, 1380.143676, 2532.807373, 17.559459, 2000);
							InterpolateCameraLookAt(i, 1013.393859, 2137.540283, 15.364944, 1380.643676, 2532.810302, 17.450519, 2000);
						#endif
			        }
		            case 5:
		            {
		                PlayerData[i][pTutorial] = 6;
		                PlayerData[i][pTutorialTime] = 10;

		                PlayerTextDrawSetString(i, PlayerData[i][pTextdraws][59], "Tutorial: Businesses");
		                PlayerTextDrawSetString(i, PlayerData[i][pTextdraws][60], "Businesses can also be a source of income.~n~You can manage business assets, including~n~prices and custom messages.");//and even~n~hire employees to work for you!");
		                PlayerTextDrawSetString(i, PlayerData[i][pTextdraws][61], "This business is a ~p~~h~Retail Store~w~. You can buy~n~items with the ~g~~h~/buy~w~ command. Type ~g~~h~/help~n~~w~for more commands.");

						#if SERVER_CITY == 1
                            SetPlayerPos(i, 1315.212036, -916.465942, 24.322559);
							InterpolateCameraPos(i, 1149.126586, -744.422912, 104.984420, 1315.212036, -916.465942, 44.322559, 2000);
							InterpolateCameraLookAt(i, 1148.626708, -744.411132, 104.82350, 1315.211059, -915.965942, 44.212619, 2000);
						#elseif SERVER_CITY == 2
			                SetPlayerPos(i, -2442.177734, 726.758605, 21.054706);
							InterpolateCameraPos(i, -2507.954101, 1125.971801, 64.563232, -2442.177734, 726.758605, 41.054706, 2000);
							InterpolateCameraLookAt(i, -2507.928710, 1126.796386, 64.145462, -2442.179931, 727.221496, 40.933773, 2000);
						#elseif SERVER_CITY == 3
                   			SetPlayerPos(i, 2160.811035, 1992.461425, -1.797470);
							InterpolateCameraPos(i, 1380.143676, 2532.807373, 17.559459, 2160.811035, 1992.461425, 18.202529, 2000);
							InterpolateCameraLookAt(i, 1380.643676, 2532.810302, 17.450519, 2161.310546, 1992.449707, 18.108432, 2000);
						#endif
			        }
			        case 6:
		            {
		                PlayerData[i][pTutorial] = 7;
		                PlayerData[i][pTutorialTime] = 10;

		                PlayerTextDrawSetString(i, PlayerData[i][pTextdraws][59], "Tutorial: Hunger and Thirst");
		                PlayerTextDrawSetString(i, PlayerData[i][pTextdraws][60], "Hunger and thirst meters are shown on~n~the right side of the screen. Over time,~n~your character will get hungry.");
		                PlayerTextDrawSetString(i, PlayerData[i][pTextdraws][61], "This business is ~y~Fast Food~w~. You can buy~n~food here. You can also buy food and~n~drinks at a ~y~Retail Store.");

						SetPlayerInterior(i, 10);
						SetPlayerPos(i, 365.013977, -73.615165, 983.073730);
						SetPlayerCameraPos(i, 365.013977, -73.615165, 1003.073730);
						SetPlayerCameraLookAt(i, 365.426818, -73.318977, 1003.007812);
			        }
		            case 7:
		            {
		                PlayerData[i][pTutorial] = 8;
		                PlayerData[i][pTutorialTime] = 10;

						SetPlayerInterior(i, 0);
		                PlayerTextDrawSetString(i, PlayerData[i][pTextdraws][59], "Tutorial: Closing");
		                PlayerTextDrawSetString(i, PlayerData[i][pTextdraws][60], "This tutorial is complete. If you need help,~n~use the ~g~~h~/seekhelp~n~~w~command and wait patiently.");
		                PlayerTextDrawSetString(i, PlayerData[i][pTextdraws][61], "Thank you for playing on our server!~n~You will spawn shortly.");

						#if SERVER_CITY == 1
                            SetPlayerPos(i, 1226.481567, -1144.220336, 31.174240);
							InterpolateCameraPos(i, 1202.077392, -929.400634, 47.784023, 1226.481567, -1144.220336, 51.174240, 2000);
							InterpolateCameraLookAt(i, 1202.008300, -928.905456, 47.673583, 1225.981567, -1144.216186, 51.160247, 2000);
						#elseif SERVER_CITY == 2
			                SetPlayerPos(i, -2016.094970, -306.215942, 55.449806);
							InterpolateCameraPos(i, -2336.783935, -187.118865, 44.045051, -2016.094970, -306.215942, 75.449806, 2000);
							InterpolateCameraLookAt(i, -2336.785400, -186.618865, 43.885139, -2016.088867, -305.735107, 75.390838, 2000);
						#elseif SERVER_CITY == 3
			                SetPlayerPos(i, 2115.572753, 2113.175292, 6.203048);
							InterpolateCameraPos(i, 1871.407104, 2052.714599, 20.308364, 2115.572753, 2113.175292, 26.203048, 2000);
							InterpolateCameraLookAt(i, 1871.404663, 2053.214599, 20.169441, 2115.072753, 2113.184326, 26.153575, 2000);
						#endif
			        }
		            case 8:
		            {
		                for (new j = 58; j < 62; j ++) {
		                    PlayerTextDrawHide(i, PlayerData[i][pTextdraws][j]);
						}
						SetDefaultSpawn(i);
		                ShowHungerTextdraw(i, 1);

		                PlayerData[i][pCreated] = 1;
		                PlayerData[i][pTask] = 1;

		                PlayerData[i][pTutorial] = 0;
		                PlayerData[i][pTutorialTime] = 0;

		                SendServerMessage(i, "Type /tasks to view the tasks you need to complete.");
		            }
		        }
		    }
		}
		if (GetPlayerSpecialAction(i) == SPECIAL_ACTION_USEJETPACK && !PlayerData[i][pJetpack])
		{
	    	SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has spawned a jetpack using hacks.", ReturnName(i, 0));
	    	Log_Write("logs/cheat_log.txt", "[%s] %s has spawned a jetpack using hacks.", ReturnDate(), ReturnName(i, 0));
		}
		if (GetPlayerSpeed(i) > 210 && PlayerData[i][pAdmin] < 1)
		{
		    if (!IsAPlane(GetPlayerVehicleID(i)) && GetPlayerState(i) != PLAYER_STATE_PASSENGER)
		    {
		        SendAdminAlert(COLOR_LIGHTRED, "[ADMIN]: %s has possibly used speed hacks (%.0f mph).", ReturnName(i, 0), GetPlayerSpeed(i));
		        Log_Write("logs/cheat_log.txt", "[%s] %s has possibly used speed hacks (%.0f mph).", ReturnDate(), ReturnName(i, 0), GetPlayerSpeed(i));
			}
		}
		if(PlayerData[i][pChannel] == 911 && GetFactionType(i) != FACTION_POLICE)
		{
		    PlayerData[i][pChannel] = 0;
		}
		if (PlayerData[i][pPicking])
		{
			if ((id = PlayerData[i][pPickCar]) != -1)
			{
			    if (Car_Nearest(i) != id)
			    {
			        PlayerData[i][pPicking] = 0;
			        PlayerData[i][pPickCar] = -1;
			        PlayerData[i][pPickTime] = 0;
				}
				else
				{
				    PlayerData[i][pPickTime]++;

				    format(str, sizeof(str), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~Picking... %d", 60 - PlayerData[i][pPickTime]);
					GameTextForPlayer(i, str, 1000, 3);

					if (PlayerData[i][pPickTime] >= 60)
					{
                        static
					        engine, lights, alarm, doors, bonnet, boot, objective;

	    				GetVehicleParamsEx(CarData[id][carVehicle], engine, lights, alarm, doors, bonnet, boot, objective);
					    SetVehicleParamsEx(CarData[id][carVehicle], engine, lights, alarm, 0, bonnet, boot, objective);

                        PlayerData[i][pPicking] = 0;
                        PlayerData[i][pPickCar] = -1;
                        PlayerData[i][pPickTime] = 0;

                        CarData[id][carLocked] = 0;
						Car_Save(id);

					    SendNearbyMessage(i, 30.0, COLOR_PURPLE, "** %s has picked the lock of the vehicle.", ReturnName(i, 0));
					    ShowPlayerFooter(i, "You have ~g~unlocked~w~ the vehicle!");
					}
				}
		    }
		}
		if (!PlayerData[i][pKilled] && PlayerData[i][pHospital] != -1)
		{
			PlayerData[i][pHospitalTime]++;

			format(str, sizeof(str), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~Recovering... %d", 15 - PlayerData[i][pHospitalTime]);
			GameTextForPlayer(i, str, 1000, 3);

			ApplyAnimation(i, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);

			if (PlayerData[i][pHospitalTime] >= 15)
			{
       			SetPlayerPos(i, -204.5867, -1740.7955, 675.7687);
			    SetPlayerFacingAngle(i, 0.0000);

			    TogglePlayerControllable(i, 1);
			    SetCameraBehindPlayer(i);

			    SetPlayerVirtualWorld(i, PlayerData[i][pHospital] + 5000);
			    SendServerMessage(i, "You have recovered at the nearest hospital.");

			    GameTextForPlayer(i, " ", 1, 3);
			    ShowHungerTextdraw(i, 1);

			    PlayerData[i][pHospitalInt] = PlayerData[i][pHospital];
			    PlayerData[i][pHospital] = -1;
			    PlayerData[i][pHospitalTime] = 0;
			}
		}
		else if (PlayerData[i][pMuted] && PlayerData[i][pMuteTime] > 0)
		{
		    PlayerData[i][pMuteTime]--;

		    if (!PlayerData[i][pMuteTime])
		    {
				PlayerData[i][pMuted] = 0;
				PlayerData[i][pMuteTime] = 0;
		    }
		}
		else if (PlayerData[i][pGraffiti] != -1 && PlayerData[i][pGraffitiTime] > 0)
		{
			if (Graffiti_Nearest(i) != PlayerData[i][pGraffiti])
			{
			    PlayerData[i][pGraffiti] = -1;
                PlayerData[i][pGraffitiTime] = 0;
			}
			else
			{
	            PlayerData[i][pGraffitiTime]--;

	            if (PlayerData[i][pGraffitiTime] < 1)
				{
				    strunpack(str, PlayerData[i][pGraffitiText]);
	                format(GraffitiData[PlayerData[i][pGraffiti]][graffitiText], 64, str);

				    GraffitiData[PlayerData[i][pGraffiti]][graffitiColor] = PlayerData[i][pGraffitiColor];

					Graffiti_Refresh(PlayerData[i][pGraffiti]);
				    Graffiti_Save(PlayerData[i][pGraffiti]);

				    ClearAnimations(i, 1);
					SendNearbyMessage(i, 30.0, COLOR_PURPLE, "** %s puts their can of spray paint away.", ReturnName(i, 0));

	                PlayerData[i][pGraffiti] = -1;
	                PlayerData[i][pGraffitiTime] = 0;
				}
			}
		}
		else if (PlayerData[i][pSpamCount] > 0)
		{
		    PlayerData[i][pSpamCount]--;
		}
		else if (PlayerData[i][pCommandCount] > 0)
		{
		    PlayerData[i][pCommandCount]--;
		}
		else if (PlayerData[i][pVendorTime] > 0)
		{
		    PlayerData[i][pVendorTime]--;
		}
		else if (PlayerData[i][pDrinkTime] > 0)
		{
		    PlayerData[i][pDrinkTime]--;
		}
		else if (PlayerData[i][pAdTime] > 0)
		{
		    PlayerData[i][pAdTime]--;
		}
		else if (PlayerData[i][pSpeedTime] > 0)
		{
		    PlayerData[i][pSpeedTime]--;
		}
		else if (PlayerData[i][pBleeding] && PlayerData[i][pBleedTime] > 0)
		{
		    if (--PlayerData[i][pBleedTime] == 0)
		    {
		        SetPlayerHealth(i, ReturnHealth(i) - 3.0);
			    PlayerData[i][pBleedTime] = 10;

			    CreateBlood(i);
			    SetTimerEx("HidePlayerBox", 500, false, "dd", i, _:ShowPlayerBox(i, 0xFF000066));
			}
		}
		else if (PlayerData[i][pFingerTime] > 0)
		{
		    PlayerData[i][pFingerTime]--;

		    if (!PlayerData[i][pFingerTime] && DroppedItems[PlayerData[i][pFingerItem]][droppedModel] && IsPlayerInRangeOfPoint(i, 1.5, DroppedItems[PlayerData[i][pFingerItem]][droppedPos][0], DroppedItems[PlayerData[i][pFingerItem]][droppedPos][1], DroppedItems[PlayerData[i][pFingerItem]][droppedPos][2]))
		    {
		        SendServerMessage(i, "The fingerprint scanner has detected a match: %s.", DroppedItems[PlayerData[i][pFingerItem]][droppedPlayer]);
                PlayerData[i][pFingerItem] = -1;
			}
		}
		else if (PlayerData[i][pDrugUsed] != 0 && PlayerData[i][pDrugTime] > 0)
		{
		    if (--PlayerData[i][pDrugTime] && 1 <= PlayerData[i][pDrugUsed] <= 3 && GetPlayerDrunkLevel(i) < 5000) {
		        SetPlayerDrunkLevel(i, 10000);

				PlayerTextDrawShow(i, PlayerData[i][pTextdraws][8]);

				if (PlayerData[i][pDrugUsed] == 3) {
				    SetPlayerWeather(i, -67);
				    SetPlayerTime(i, 12, 12); // Set the time (the drug weather is buggy at night)
				}
			}
		    if (1 <= PlayerData[i][pDrugUsed] <= 3 && ReturnHealth(i) <= 95) {
		    	SetPlayerHealth(i, ReturnHealth(i) + 5);
			}
		    if (!PlayerData[i][pDrugTime])
		    {
		        new
	        		time[3];

        		gettime(time[0], time[1], time[2]);
				SetPlayerTime(i, time[0], time[1]);

		        SetPlayerDrunkLevel(i, 500);
				PlayerTextDrawHide(i, PlayerData[i][pTextdraws][8]);

				PlayerData[i][pDrugUsed] = 0;
		        SendServerMessage(i, "The effects from the drugs have subsided.");
		    }
		}
		else if (PlayerData[i][pStunned] > 0)
		{
            PlayerData[i][pStunned]--;

			if (GetPlayerAnimationIndex(i) != 388)
            	ApplyAnimation(i, "CRACK", "crckdeth4", 4.0, 0, 0, 0, 1, 0, 1);

            if (!PlayerData[i][pStunned])
            {
                TogglePlayerControllable(i, 1);
                ShowPlayerFooter(i, "You are no longer ~r~stunned.");
			}
		}
		else if (PlayerData[i][pJailTime] > 0)
		{
		    static
		        hours,
		        minutes,
		        seconds;

		    PlayerData[i][pJailTime]--;

			GetElapsedTime(PlayerData[i][pJailTime], hours, minutes, seconds);

			format(str, sizeof(str), "~g~Prison Time:~w~ %02d:%02d:%02d", hours, minutes, seconds);
			PlayerTextDrawSetString(i, PlayerData[i][pTextdraws][70], str);

		    if (!PlayerData[i][pJailTime])
		    {
		        PlayerData[i][pPrisoned] = 0;

		        SetDefaultSpawn(i);
		        ShowHungerTextdraw(i, 1);

				SendServerMessage(i, "You have been released from jail.");
		        PlayerTextDrawHide(i, PlayerData[i][pTextdraws][70]);
			}
		}
		else if (PlayerData[i][pTrackTime] > 0 && IsPlayerConnected(PlayerData[i][pMDCPlayer]) && GetFactionType(i) == FACTION_POLICE)
		{
		    PlayerData[i][pTrackTime]--;

		    if (!PlayerData[i][pTrackTime])
		    {
		        if ((id = House_Inside(PlayerData[i][pMDCPlayer])) != -1)
				{
				    PlayerData[i][pCP] = 1;

				    SetPlayerCheckpoint(i, HouseData[id][housePos][0], HouseData[id][housePos][1], HouseData[id][housePos][2], 3.0);
		            SendServerMessage(i, "%s's last reported location was at \"%s\" (marked on radar).", ReturnName(PlayerData[i][pMDCPlayer], 0), HouseData[id][houseAddress]);
		        }
		        else if ((id = Business_Inside(PlayerData[i][pMDCPlayer])) != -1)
		        {
		            PlayerData[i][pCP] = 1;

		            SetPlayerCheckpoint(i, BusinessData[id][bizPos][0], BusinessData[id][bizPos][1], BusinessData[id][bizPos][2], 3.0);
		            SendServerMessage(i, "%s's last reported location was at \"%s\" (marked on radar).", ReturnName(PlayerData[i][pMDCPlayer], 0), BusinessData[id][bizName]);
		        }
		        else if (GetPlayerInterior(PlayerData[i][pMDCPlayer]) == 0)
		        {
		            static
		                Float:fX,
		                Float:fY,
		                Float:fZ;

		            GetPlayerPos(PlayerData[i][pMDCPlayer], fX, fY, fZ);
		            PlayerData[i][pCP] = 1;

                    SetPlayerCheckpoint(i, fX, fY, fZ, 3.0);
		            SendServerMessage(i, "%s's last reported location was at \"%s\" (marked on radar).", ReturnName(PlayerData[i][pMDCPlayer], 0), GetLocation(fX, fY, fZ));
		        }
		        else
		        {
		            SendServerMessage(i, "Unable to locate %s; the target is out of range (inside an interior).", ReturnName(PlayerData[i][pMDCPlayer], 0));
				}
			}
		}
		else if (PlayerData[i][pCooking] && IsPlayerSpawned(i))
		{
		    PlayerData[i][pCookingTime]--;

		    if (House_Inside(i) == PlayerData[i][pCookingHouse])
		    {
			    format(str, sizeof(str), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~b~~h~Cooking...~w~ %d seconds", PlayerData[i][pCookingTime]);
			    GameTextForPlayer(i, str, 1200, 3);
			}
		    if (PlayerData[i][pCookingTime] < 1)
		    {
		        if (House_Inside(i) != PlayerData[i][pCookingHouse])
		        {
		            SendServerMessage(i, "You have left your food unattended and burned it.");
		        }
		        else
				{
					switch (PlayerData[i][pCooking])
		        	{
                    	case 1:
		            	{
		               	    id = Inventory_Add(i, "Cooked Burger", 2703, 1);

		               	    if (id == -1)
		               	        return SendErrorMessage(i, "You don't have any inventory slots left.");

		                	SendNearbyMessage(i, 30.0, COLOR_PURPLE, "** The microwave beeps, you can smell a burger! (( %s ))", ReturnName(i, 0));
		                	SendServerMessage(i, "The cooked burger was added to your inventory.");
		            	}
			            case 2:
			            {
			                id = Inventory_Add(i, "Cooked Pizza", 2702, 6);

			                if (id == -1)
		               	        return SendErrorMessage(i, "You don't have any inventory slots left.");

		    	            SendNearbyMessage(i, 30.0, COLOR_PURPLE, "** The oven beeps, you can smell pizza! (( %s ))", ReturnName(i, 0));
		    	            SendServerMessage(i, "The cooked pizza was added to your inventory.");
		        	    }
					}
				}
                PlayerData[i][pCooking] = 0;
                PlayerData[i][pCookingTime] = 0;
                PlayerData[i][pCookingHouse] = -1;
		    }
		}
		else if (PlayerData[i][pDrivingTest] && IsPlayerInVehicle(i, PlayerData[i][pTestCar]))
		{
		    if (!IsPlayerInRangeOfPoint(i, 100.0, g_arrDrivingCheckpoints[PlayerData[i][pTestStage]][0], g_arrDrivingCheckpoints[PlayerData[i][pTestStage]][1], g_arrDrivingCheckpoints[PlayerData[i][pTestStage]][2]))
			{
		        CancelDrivingTest(i);
				SendClientMessage(i, COLOR_LIGHTRED, "[WARNING]:{FFFFFF} You have failed the test due to leaving the test area.");
    		}
			else if (GetPlayerSpeed(i) >= 55.0)
   			{
				if (++PlayerData[i][pTestWarns] < 3)
				{
    				SendClientMessageEx(i, COLOR_LIGHTRED, "[WARNING]:{FFFFFF} You are going too fast, slow down! (%d/3)", PlayerData[i][pTestWarns]);
        		}
	       		else
				{
    				CancelDrivingTest(i);
        			SendClientMessage(i, COLOR_LIGHTRED, "[WARNING]:{FFFFFF} You have failed the test due to excessive speeding!");
			    }
			}
		}
		else if (IsPlayerInsideTaxi(i))
		{
		    PlayerData[i][pTaxiTime]++;

		    if (PlayerData[i][pTaxiTime] == 15)
		    {
		        PlayerData[i][pTaxiTime] = 0;
		        PlayerData[i][pTaxiFee] += 10;
		    }
		    format(str, sizeof(str), "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~$%d...~w~ %d seconds", PlayerData[i][pTaxiFee], PlayerData[i][pTaxiTime]);

			GameTextForPlayer(i, str, 1100, 3);
			GameTextForPlayer(GetVehicleDriver(GetPlayerVehicleID(i)), str, 1100, 3);
		}
		if (PlayerData[i][pCreated] && !PlayerData[i][pTutorial] && !PlayerData[i][pJailTime] && !PlayerData[i][pInjured] && PlayerData[i][pHospital] == -1 && PlayerData[i][pCreated] && IsPlayerSpawned(i))
		{
		    GetPlayerHealth(i, health);

		    if (++ PlayerData[i][pHungerTime] >= 300)
			{
				if (PlayerData[i][pHunger] > 0)
				{
    	        	PlayerData[i][pHunger]--;
    		    }
        		else if (PlayerData[i][pHunger] <= 0)
				{
    	        	SetPlayerHealth(i, health - 10);
        	    	FlashTextDraw(i, PlayerData[i][pTextdraws][INDIKATOR_LAPAR_DEPAN]);
        		}
        		PlayerData[i][pHungerTime] = 0;
        	}
	        if (++ PlayerData[i][pThirstTime] >= 280)
			{
				if (PlayerData[i][pThirst] > 0)
				{
    	        	PlayerData[i][pThirst]--;
				}
				else if (PlayerData[i][pThirst] <= 0)
				{
		        	SetPlayerHealth(i, health - 5);
        	    	FlashTextDraw(i, PlayerData[i][pTextdraws][INDIKATOR_HAUS_DEPAN]);
        		}
        		PlayerData[i][pThirstTime] = 0;
			}
		}
		if ((id = Boombox_Nearest(i)) != INVALID_PLAYER_ID && PlayerData[i][pBoombox] != id && strlen(BoomboxData[id][boomboxURL]) && !IsPlayerInAnyVehicle(i))
		{
		    strunpack(str, BoomboxData[id][boomboxURL]);
		    PlayerData[i][pBoombox] = id;

		    StopAudioStreamForPlayer(i);
		    PlayAudioStreamForPlayer(i, str, BoomboxData[id][boomboxPos][0], BoomboxData[id][boomboxPos][1], BoomboxData[id][boomboxPos][2], 30.0, 1);
		}
		else if (PlayerData[i][pBoombox] != INVALID_PLAYER_ID && !IsPlayerInRangeOfPoint(i, 30.0, BoomboxData[PlayerData[i][pBoombox]][boomboxPos][0], BoomboxData[PlayerData[i][pBoombox]][boomboxPos][1], BoomboxData[PlayerData[i][pBoombox]][boomboxPos][2]))
		{
		    PlayerData[i][pBoombox] = INVALID_PLAYER_ID;
		    StopAudioStreamForPlayer(i);
		}
		if (PlayerData[i][pInjured] == 1 && GetPlayerAnimationIndex(i) != 388)
		{
			ApplyAnimation(i, "CRACK", "crckdeth4", 4.0, 0, 0, 0, 1, 0, 1);
		}
        if (PlayerData[i][pHealthTime] > 0)
        {
            PlayerData[i][pHealthTime]--;
		}
		if (PlayerData[i][pRangeBooth] != -1 && !IsPlayerInRangeOfPoint(i, 3.0, arrBoothPositions[PlayerData[i][pRangeBooth]][0], arrBoothPositions[PlayerData[i][pRangeBooth]][1], arrBoothPositions[PlayerData[i][pRangeBooth]][2]))
		{
			Booth_Leave(i);
		}
		Interface_UpdateHungerTextdraw(i);
	}
	return 1;
}

forward UpdateTime();

// ====== UpdateTime ======
public UpdateTime()
{
	static
	    time[3],
	    string[32];

	gettime(time[0], time[1], time[2]);

	if (time[0] >= 12)
		format(string, 32, "%02d:%02d PM", (time[0] == 12) ? (12) : (time[0] - 12), time[1]);

	else if (time[0] < 12)
		format(string, 32, "%02d:%02d AM", (time[0] == 0) ? (12) : (time[0]), time[1]);

	TextDrawSetString(gServerTextdraws[0], string);

	foreach (new i : Player) if (PlayerData[i][pDrugUsed] != 3) {
		SetPlayerTime(i, time[0], time[1]);
	}
	SetTimer("UpdateTime", 30000, false);
}

forward RefuelCheck();

// ====== RefuelCheck ======
public RefuelCheck()
{
	new
	    string[128];

	foreach (new i : Player)
	{
	    if (!PlayerData[i][pLogged] || PlayerData[i][pRefill] == INVALID_VEHICLE_ID)
	        continue;

        if (PlayerData[i][pRefill] != INVALID_VEHICLE_ID && PlayerData[i][pGasPump] != -1)
		{
		    PlayerData[i][pRefillPrice]++;

		    CoreVehicles[PlayerData[i][pRefill]][vehFuel] ++;
		    PumpData[PlayerData[i][pGasPump]][pumpFuel] --;

		    if (PumpData[PlayerData[i][pGasPump]][pumpExists])
			{
			    format(string, sizeof(string), "[Gas Pump: %d]\n{FFFFFF}Fuel Left: %d liters", PlayerData[i][pGasPump], PumpData[PlayerData[i][pGasPump]][pumpFuel]);
			    UpdateDynamic3DTextLabelText(PumpData[PlayerData[i][pGasPump]][pumpText3D], COLOR_DARKBLUE, string);
			}
			if (CoreVehicles[PlayerData[i][pRefill]][vehFuel] >= 100 || GetEngineStatus(PlayerData[i][pRefill]) || !PumpData[PlayerData[i][pGasPump]][pumpExists] || PumpData[PlayerData[i][pGasPump]][pumpFuel] < 0)
			{
			    CoreVehicles[PlayerData[i][pRefill]][vehFuel] = 100;

			    GiveMoney(i, -PlayerData[i][pRefillPrice]);
			    SendServerMessage(i, "You have refilled your vehicle for $%d.", PlayerData[i][pRefillPrice]);

			    if (PumpData[PlayerData[i][pGasPump]][pumpExists])
				{
					if (PumpData[PlayerData[i][pGasPump]][pumpFuel] < 0)
						PumpData[PlayerData[i][pGasPump]][pumpFuel] = 0;

					BusinessData[PlayerData[i][pGasStation]][bizVault] += PlayerData[i][pRefillPrice];
					Business_Save(PlayerData[i][pGasStation]);

					Pump_Save(PlayerData[i][pGasPump]);
				}
				StopRefilling(i);
			}
		}
	}
	return 1;
}

forward FuelUpdate();

// ====== FuelUpdate ======
public FuelUpdate()
{
	for (new i = 1; i != MAX_VEHICLES; i ++) if (IsEngineVehicle(i) && GetEngineStatus(i))
	{
	    if (CoreVehicles[i][vehFuel] > 0)
	    {
	        CoreVehicles[i][vehFuel]--;

			if (CoreVehicles[i][vehFuel] >= 1 && CoreVehicles[i][vehFuel] <= 5)
			{
			    SendClientMessage(GetVehicleDriver(i), COLOR_LIGHTRED, "[WARNING]:{FFFFFF} This vehicle is low on fuel. You must visit a fuel station!");
			}
		}
		if (CoreVehicles[i][vehFuel] <= 0)
		{
		    CoreVehicles[i][vehFuel] = 0;
		    SetEngineStatus(i, false);
		}
	}
}


// ====== WeatherRotator ======
public WeatherRotator()
{
	new index = random(sizeof(g_aWeatherRotations));

	SetWeather(g_aWeatherRotations[index]);
}
