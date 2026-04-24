/*
    File: modules/system/dialogs/radio.pwn
    Purpose: Contains easyDialog callbacks for system radio flows.
    Notes: Keep dialog response handling here and move reusable domain operations to logic files.
*/

// ====== Dialog:Radio ======
Dialog:Radio(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    switch (listitem)
	    {
	        case 0:
	            Dialog_Show(playerid, CulturalRadio, DIALOG_STYLE_LIST, DialogStyle_Title("Cultural"), DialogStyle_Body("Classical\nInstruments"), "Select", "Cancel");

			case 1:
			    Dialog_Show(playerid, OldiesRadio, DIALOG_STYLE_LIST, DialogStyle_Title("Oldies"), DialogStyle_Body("70's\n80's\n90's"), "Select", "Cancel");

			case 2:
			    Dialog_Show(playerid, OtherRadio, DIALOG_STYLE_LIST, DialogStyle_Title("Other"), DialogStyle_Body("Dance\nGlee\nMash Ups"), "Select", "Cancel");

			case 3:
			    Dialog_Show(playerid, PopRadio, DIALOG_STYLE_LIST, DialogStyle_Title("Pop"), DialogStyle_Body("Korean\nPop\nTop Hits"), "Select", "Cancel");

			case 4:
			    Dialog_Show(playerid, RNBRadio, DIALOG_STYLE_LIST, DialogStyle_Title("Rhythm & Blues"), DialogStyle_Body("R&B\nSoul"), "Select", "Cancel");

			case 5:
				Dialog_Show(playerid, RockRadio, DIALOG_STYLE_LIST, DialogStyle_Title("Rock"), DialogStyle_Body("Alternative\nClassic\nIndie Rock\nMetal\nPunk\nRock & Roll"), "Select", "Cancel");

	        case 6:
	            Dialog_Show(playerid, TalkRadio, DIALOG_STYLE_LIST, DialogStyle_Title("Talk"), DialogStyle_Body("Comedy\nScanners"), "Select", "Cancel");

	 		case 7:
				Dialog_Show(playerid, UrbanRadio, DIALOG_STYLE_LIST, DialogStyle_Title("Urban"), DialogStyle_Body("Country\nHip-Hop"), "Select", "Cancel");

			case 8:
			    Dialog_Show(playerid, ElectricRadio, DIALOG_STYLE_LIST, DialogStyle_Title("Electric"), DialogStyle_Body("ElectricFM.com\n1Dance.fm\nDanceTime.fm"), "Select", "Cancel");

			case 9:
			{
			    new vehicleid = GetPlayerVehicleID(playerid);

			    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
			        return 0;

				StopVehicleRadio(vehicleid);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has turned off the car radio.", ReturnName(playerid, 0));
			}
	    }
	}
	return 1;
}

// ====== Dialog:UrbanRadio ======
Dialog:UrbanRadio(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
			    Dialog_Show(playerid, Country, DIALOG_STYLE_LIST, DialogStyle_Title("Country"), DialogStyle_Body("GotRadio - Today's Country\n181.fm - Highway 181\nHPR1: Traditional Classic Country\nCountry - Sky.fm"), "Play", "Cancel");

            case 1:
			    Dialog_Show(playerid, HipHop, DIALOG_STYLE_LIST, DialogStyle_Title("Hip-Hop"), DialogStyle_Body("100Hits - HipHop\nHot 108 Jamz\n181.fm - The Box\nGotRadio - Urban Jams"), "Play", "Cancel");
		}
	}
	return 1;
}

// ====== Dialog:Country ======
Dialog:Country(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
				SetVehicleRadio(vehicleid, "http://206.217.213.235:8100/");

			case 1:
			    SetVehicleRadio(vehicleid, "http://relay.181.fm:8018/");

            case 2:
			    SetVehicleRadio(vehicleid, "http://108.61.73.119:8024/");

            case 3:
			    SetVehicleRadio(vehicleid, "http://scfire-ntc-aa01.stream-aol.com/stream/1019");
		}
	}
	return 1;
}

// ====== Dialog:HipHop ======
Dialog:HipHop(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
				SetVehicleRadio(vehicleid, "http://64.56.64.67:10354/");

			case 1:
			    SetVehicleRadio(vehicleid, "http://stream-95.shoutcast.com/hot108_mp3_128kbps");

            case 2:
			    SetVehicleRadio(vehicleid, "http://108.61.73.119:8024/");

            case 3:
			    SetVehicleRadio(vehicleid, "http://108.61.73.118:8068/");
		}
	}
	return 1;
}

// ====== Dialog:ElectricRadio ======
Dialog:ElectricRadio(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
				SetVehicleRadio(vehicleid, "http://72.13.83.151/");

			case 1:
			    SetVehicleRadio(vehicleid, "http://173.192.207.51:8062/");

            case 2:
			    SetVehicleRadio(vehicleid, "http://212.83.60.202:8000/");
		}
	}
	return 1;
}

// ====== Dialog:TalkRadio ======
Dialog:TalkRadio(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
			    Dialog_Show(playerid, Comedy, DIALOG_STYLE_LIST, DialogStyle_Title("Comedy"), DialogStyle_Body("Comedy104\nAddictedToRadio.com - Comedy\n181.fm - Comedy Club"), "Play", "Cancel");

            case 1:
			    Dialog_Show(playerid, Scanners, DIALOG_STYLE_LIST, DialogStyle_Title("Scanners"), DialogStyle_Body("New Orleans Police Department\nSan Diego Police Dispatch\nLong Beach Police Dispatch\nCalifornia Highway Patrol - Los Angeles & Orange County\nLAPD - Citywide Dispatch and Hot Shots/Code 3"), "Play", "Cancel");
		}
	}
	return 1;
}

// ====== Dialog:Comedy ======
Dialog:Comedy(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
				SetVehicleRadio(vehicleid, "http://69.195.140.50:8060/");

			case 1:
			    SetVehicleRadio(vehicleid, "http://208.77.21.13:17910/");

            case 2:
			    SetVehicleRadio(vehicleid, "http://108.61.73.118:8026/");
		}
	}
	return 1;
}

// ====== Dialog:Scanners ======
Dialog:Scanners(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
				SetVehicleRadio(vehicleid, "http://www.radioreference.com/scripts/playlists/1/3877/0-5443008964.m3u");

			case 1:
			    SetVehicleRadio(vehicleid, "http://www.radioreference.com/scripts/playlists/1/6740/0-5443008116.m3u");

            case 2:
			    SetVehicleRadio(vehicleid, "http://www.radioreference.com/scripts/playlists/1/6740/0-5443008116.m3u");

            case 3:
			    SetVehicleRadio(vehicleid, "http://radioreference.com/scripts/playlists/1/10239/0-5443007068.m3u");

            case 4:
			    SetVehicleRadio(vehicleid, "http://radioreference.com/scripts/playlists/1/10239/0-5443007068.m3u");
		}
	}
	return 1;
}

// ====== Dialog:RockRadio ======
Dialog:RockRadio(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
			case 0:
			    Dialog_Show(playerid, Alternative, DIALOG_STYLE_LIST, DialogStyle_Title("Alternative"), DialogStyle_Body("GotRadio - Alternative"), "Play", "Cancel");

            case 1:
			    Dialog_Show(playerid, Classic, DIALOG_STYLE_LIST, DialogStyle_Title("Classic"), DialogStyle_Body("181.FM - Rock 181 #1\n.977 The Classic Rock\n181.fm - The Eagle\n181.fm Rock 40\n181.fm Rock 181 #2"), "Play", "Cancel");

            case 2:
			    Dialog_Show(playerid, IndieRock, DIALOG_STYLE_LIST, DialogStyle_Title("Indie Rock"), DialogStyle_Body("GotRadio - Indie Underground\nIndie Rock - LifeJive.com"), "Play", "Cancel");

            case 3:
			    Dialog_Show(playerid, Metal, DIALOG_STYLE_LIST, DialogStyle_Title("Metal"), DialogStyle_Body("GotRadio - Metal Madness\nDepressive Metal Rock radio\nDeath.F(ucking)M(etal)\nDepressive metal rock (Death)\nRepressive metal rock radio (Black)"), "Play", "Cancel");

            case 4:
			    Dialog_Show(playerid, Punk, DIALOG_STYLE_LIST, DialogStyle_Title("Punk"), DialogStyle_Body("Pop Punk - Sky.fm"), "Play", "Cancel");

            case 5:
			    Dialog_Show(playerid, RockRoll, DIALOG_STYLE_LIST, DialogStyle_Title("Rock & Roll"), DialogStyle_Body("Absolute Radio"), "Play", "Cancel");
		}
	}
	return 1;
}

// ====== Dialog:Alternative ======
Dialog:Alternative(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
				SetVehicleRadio(vehicleid, "http://206.217.213.235:8200/");
		}
	}
	return 1;
}

// ====== Dialog:Classic ======
Dialog:Classic(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
				SetVehicleRadio(vehicleid, "http://relay.181.fm:8008/");

			case 1:
			    SetVehicleRadio(vehicleid, "http://7649.live.streamtheworld.com/977_CLASSROCK_SC");

            case 2:
			    SetVehicleRadio(vehicleid, "http://relay.181.fm:8030/");

            case 3:
			    SetVehicleRadio(vehicleid, "http://uplink.181.fm:8028/");

            case 4:
			    SetVehicleRadio(vehicleid, "http://relay.181.fm:8064/");
		}
	}
	return 1;
}

// ====== Dialog:IndieRock ======
Dialog:IndieRock(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
				SetVehicleRadio(vehicleid, "http://173.244.215.163:8330/");

			case 1:
			    SetVehicleRadio(vehicleid, "http://208.53.138.125:8136/");
		}
	}
	return 1;
}

// ====== Dialog:Metal ======
Dialog:Metal(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
				SetVehicleRadio(vehicleid, "http://173.244.215.163:8340/");

			case 1:
			    SetVehicleRadio(vehicleid, "http://184.154.10.83:8390/");

            case 2:
			    SetVehicleRadio(vehicleid, "http://209.9.229.211/");

            case 3:
			    SetVehicleRadio(vehicleid, "http://184.154.185.170:8080/");

            case 4:
			    SetVehicleRadio(vehicleid, "http://65.60.19.43:8270/");
		}
	}
	return 1;
}

// ====== Dialog:Punk ======
Dialog:Punk(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
				SetVehicleRadio(vehicleid, "http://80.94.69.106:6884/");
		}
	}
	return 1;
}

// ====== Dialog:RockRoll ======
Dialog:RockRoll(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
				SetVehicleRadio(vehicleid, "http://mp3-ar-192.as34763.net/");
		}
	}
	return 1;
}

// ====== Dialog:RNBRadio ======
Dialog:RNBRadio(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
			case 0:
			    Dialog_Show(playerid, RNB, DIALOG_STYLE_LIST, DialogStyle_Title("R&B"), DialogStyle_Body("181.fm - True R&B\nDEFJay.de - 100% R&B\nGotRadio - R&B Classics\nSlow Jamz\nAddictedToRadio.com - V101 RnB AAC"), "Play", "Cancel");

            case 1:
			    Dialog_Show(playerid, SoulRadio, DIALOG_STYLE_LIST, DialogStyle_Title("Soul"), DialogStyle_Body("181.fm - Soul\nSoulful Bits"), "Play", "Cancel");
		}
	}
	return 1;
}

// ====== Dialog:RNB ======
Dialog:RNB(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
				SetVehicleRadio(vehicleid, "http://108.61.73.119:8022/");

			case 1:
			    SetVehicleRadio(vehicleid, "http://87.230.56.38/");

            case 2:
			    SetVehicleRadio(vehicleid, "http://206.217.213.236:8390/");

            case 3:
			    SetVehicleRadio(vehicleid, "http://173.193.32.153:8020/");

            case 4:
			    SetVehicleRadio(vehicleid, "http://208.77.21.15:10730/");
		}
	}
	return 1;
}

// ====== Dialog:SoulRadio ======
Dialog:SoulRadio(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
				SetVehicleRadio(vehicleid, "http://relay.181.fm:8058/");

			case 1:
			    SetVehicleRadio(vehicleid, "http://88.191.137.70/");
		}
	}
	return 1;
}

// ====== Dialog:PopRadio ======
Dialog:PopRadio(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
		        Dialog_Show(playerid, KoreanRadio, DIALOG_STYLE_LIST, DialogStyle_Title("Korean"), DialogStyle_Body("KPOP TOP 100\nGeneraction\nBig B Radio"), "Play", "Cancel");

			case 1:
			    Dialog_Show(playerid, Pop, DIALOG_STYLE_LIST, DialogStyle_Title("Pop"), DialogStyle_Body("My Tunes FM\nHot Hits IR\nGay FM"), "Play", "Cancel");

            case 2:
			    Dialog_Show(playerid, TopHits, DIALOG_STYLE_LIST, DialogStyle_Title("Top Hits"), DialogStyle_Body("ChartHits.fm - Your Hitz More Music\n181.fm The Office\n100Hitz - Top 40\n1.fm Absolute Top 40\nTop Hits Music - Sky.fm"), "Play", "Cancel");
		}
	}
	return 1;
}

// ====== Dialog:KoreanRadio ======
Dialog:KoreanRadio(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
				SetVehicleRadio(vehicleid, "http://39.119.181.57:8000/128");

			case 1:
			    SetVehicleRadio(vehicleid, "http://176.31.241.195:8700/");

            case 2:
			    SetVehicleRadio(vehicleid, "http://199.241.187.194:8060/");
		}
	}
	return 1;
}

// ====== Dialog:Pop ======
Dialog:Pop(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
				SetVehicleRadio(vehicleid, "http://77.102.253.75:8000/");

			case 1:
			    SetVehicleRadio(vehicleid, "http://50.117.26.26:1265/moon.wavestreamer.com:1265/live");

            case 2:
			    SetVehicleRadio(vehicleid, "http://80.237.211.85/");
		}
	}
	return 1;
}

// ====== Dialog:TopHits ======
Dialog:TopHits(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
				SetVehicleRadio(vehicleid, "http://79.141.174.206:22000/");

			case 1:
			    SetVehicleRadio(vehicleid, "http://108.61.73.117:8002/");

            case 2:
			    SetVehicleRadio(vehicleid, "http://206.217.213.235:8300/");

            case 3:
			    SetVehicleRadio(vehicleid, "http://205.164.62.15:7016/");

            case 4:
			    SetVehicleRadio(vehicleid, "http://stream-67.shoutcast.com/tophits_skyfm_mp3_96kbps");
		}
	}
	return 1;
}

// ====== Dialog:OtherRadio ======
Dialog:OtherRadio(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
		        Dialog_Show(playerid, DanceRadio, DIALOG_STYLE_LIST, DialogStyle_Title("Dance"), DialogStyle_Body("Dancetime.fm\nPlus Fm - Pure Dance Radio"), "Play", "Cancel");

			case 1:
			    Dialog_Show(playerid, Glee, DIALOG_STYLE_LIST, DialogStyle_Title("Glee"), DialogStyle_Body("AceRadio.net - Glee Radio"), "Play", "Cancel");

            case 2:
			    Dialog_Show(playerid, MashUps, DIALOG_STYLE_LIST, DialogStyle_Title("Mash Ups"), DialogStyle_Body("Mastermix - Base Manic Radio\nMashups\nGotRadio - Mashups\nMashup-Radio24.de\nI love mashup radio"), "Play", "Cancel");
		}
	}
	return 1;
}

// ====== Dialog:DanceRadio ======
Dialog:DanceRadio(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
				SetVehicleRadio(vehicleid, "http://87.230.53.17:8000/");

			case 1:
			    SetVehicleRadio(vehicleid, "http://87.230.82.41/");
		}
	}
	return 1;
}

// ====== Dialog:Glee ======
Dialog:Glee(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
				SetVehicleRadio(vehicleid, "http://174.36.42.110:8360/");
		}
	}
	return 1;
}

// ====== Dialog:MashUps ======
Dialog:MashUps(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
				SetVehicleRadio(vehicleid, "http://184.107.17.34:8046/");

            case 1:
				SetVehicleRadio(vehicleid, "http://67.212.166.210:8413/");

            case 2:
				SetVehicleRadio(vehicleid, "http://206.217.213.236:8530/");

            case 3:
				SetVehicleRadio(vehicleid, "http://188.138.124.98:39710/");

            case 4:
				SetVehicleRadio(vehicleid, "http://87.118.64.205:8040/");
		}
	}
	return 1;
}

// ====== Dialog:OldiesRadio ======
Dialog:OldiesRadio(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
		        Dialog_Show(playerid, 70sRadio, DIALOG_STYLE_LIST, DialogStyle_Title("70's"), DialogStyle_Body("181.fm - 70's\nAll Hit 70's\nSky.fm"), "Play", "Cancel");

			case 1:
			    Dialog_Show(playerid, 80sRadio, DIALOG_STYLE_LIST, DialogStyle_Title("80's"), DialogStyle_Body("Golden Radio Italia 80's\n181.fm - Lite 80's\n181.fm - Awesome 80's\n80's, 80's, 80's! - Sky.fm"), "Play", "Cancel");

            case 2:
			    Dialog_Show(playerid, 90sRadio, DIALOG_STYLE_LIST, DialogStyle_Title("90's"), DialogStyle_Body("GotRadio - 90's Alternative\nAddictedToRadio.com\n181.fm - Lite 90's\n181.fm - 90's Alternative\n181.fm - Star 90's"), "Play", "Cancel");
		}
	}
	return 1;
}

Dialog:70sRadio(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
				SetVehicleRadio(vehicleid, "http://108.61.73.118:8066/");

			case 1:
			    SetVehicleRadio(vehicleid, "http://stream-45.shoutcast.com/all_hit_70s_skyfm_mp3_96kbps");
		}
	}
	return 1;
}

Dialog:80sRadio(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
				SetVehicleRadio(vehicleid, "http://109.123.116.202:8040/");

			case 1:
			    SetVehicleRadio(vehicleid, "http://74.86.186.4:12114/");

			case 2:
				SetVehicleRadio(vehicleid, "http://108.61.73.118:8000/");

			case 3:
			    SetVehicleRadio(vehicleid, "http://stream-54.shoutcast.com/the80s_skyfm_mp3_96kbps");
		}
	}
	return 1;
}

Dialog:90sRadio(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
				SetVehicleRadio(vehicleid, "http://173.244.215.162:8190/");

			case 1:
			    SetVehicleRadio(vehicleid, "http://208.77.21.13:14330/");

			case 2:
				SetVehicleRadio(vehicleid, "http://74.86.186.4:12118/");

			case 3:
			    SetVehicleRadio(vehicleid, "http://108.61.73.118:8052/");

            case 4:
			    SetVehicleRadio(vehicleid, "http://108.61.73.118:8012/");
		}
	}
	return 1;
}

// ====== Dialog:CulturalRadio ======
Dialog:CulturalRadio(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
		        Dialog_Show(playerid, Classical, DIALOG_STYLE_LIST, DialogStyle_Title("Classical"), DialogStyle_Body("Mostly Classical - Sky.fm\nCalmradio.com - Mozart\n1.fm - Otto's classical\nClassical Piano - Sky.fm"), "Play", "Cancel");

			case 1:
			    Dialog_Show(playerid, Instruments, DIALOG_STYLE_LIST, DialogStyle_Title("Instruments"), DialogStyle_Body("Calmradio.com - Solo Piano & Guitar\nGotRadio - Guitar Genius\nGotRadio - Piano Perfect\nPianorama"), "Play", "Cancel");
		}
	}
	return 1;
}

// ====== Dialog:Classical ======
Dialog:Classical(playerid, response, listitem, inputtext[])
{
    if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
				SetVehicleRadio(vehicleid, "http://stream-135.shoutcast.com/classical_skyfm_mp3_96kbps");

			case 1:
			    SetVehicleRadio(vehicleid, "http://159.253.143.15:12128/");

			case 2:
			    SetVehicleRadio(vehicleid, "http://205.164.41.18:7070/");

			case 3:
			    SetVehicleRadio(vehicleid, "http://72.26.204.28:6874/");
		}
	}
	return 1;
}

// ====== Dialog:Instruments ======
Dialog:Instruments(playerid, response, listitem, inputtext[])
{
    if (response)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);

		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !IsEngineVehicle(vehicleid))
  			return 0;

		switch (listitem)
		{
		    case 0:
				SetVehicleRadio(vehicleid, "http://173.192.225.172:8200/");

			case 1:
			    SetVehicleRadio(vehicleid, "http://173.244.215.162:8020/");

			case 2:
			    SetVehicleRadio(vehicleid, "http://173.244.215.162:8050/");

			case 3:
			    SetVehicleRadio(vehicleid, "http://188.127.226.185/");
		}
	}
	return 1;
}

