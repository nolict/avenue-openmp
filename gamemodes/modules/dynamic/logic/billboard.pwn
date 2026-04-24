/*
    File: modules/dynamic/logic/billboard.pwn
    Purpose: Contains dynamic gameplay logic and helper functions for billboard.
    Notes: Keep UI, commands, dialogs, and static world placement in their matching folders.
*/

// ====== GetBillboardByID ======
stock GetBillboardByID(sqlid)
{
    for (new i = 0; i != MAX_BILLBOARDS; i ++) if (BillBoardData[i][bbExists] && BillBoardData[i][bbID] == sqlid)
        return i;

    return -1;
}

// ====== Billboard_Save ======
Billboard_Save(bbid)
{
    static query[2048];
    format(query, sizeof(query), "UPDATE `billboards` SET `bbName` = '%s', `bbMessage` = '%s', `bbOwner` = '%d', `bbPrice` = '%d', `bbRange` = '%d', `bbPosX` = '%.4f', `bbPosY` = '%.4f', `bbPosZ` = '%.4f' WHERE `bbID` = '%d'",
        SQL_ReturnEscaped(BillBoardData[bbid][bbName]),
        SQL_ReturnEscaped(BillBoardData[bbid][bbMessage]),
        BillBoardData[bbid][bbOwner],
        BillBoardData[bbid][bbPrice],
        BillBoardData[bbid][bbRange],
        BillBoardData[bbid][bbPos][0],
        BillBoardData[bbid][bbPos][1],
        BillBoardData[bbid][bbPos][2],
        BillBoardData[bbid][bbID]
    );
    return mysql_tquery(g_iHandle, query);
}

// ====== Billboard_Refresh ======
Billboard_Refresh(bizid)
{
    if (bizid != -1 && BillBoardData[bizid][bbExists])
    {
        if (IsValidDynamic3DTextLabel(BillBoardData[bizid][bbText3D]))
            DestroyDynamic3DTextLabel(BillBoardData[bizid][bbText3D]);

        static
            string[128];

        if (!BillBoardData[bizid][bbOwner]) {
            format(string, sizeof(string), "[%i] - [%s]\n%s", bizid, FormatNumber(BillBoardData[bizid][bbPrice]), BillBoardData[bizid][bbName]);
            BillBoardData[bizid][bbText3D] = CreateDynamic3DTextLabel(string, 0x33AA33FF, BillBoardData[bizid][bbPos][0], BillBoardData[bizid][bbPos][1], BillBoardData[bizid][bbPos][2], BillBoardData[bizid][bbRange], INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0);
        }
        else if (BillBoardData[bizid][bbOwner]) {
            format(string, sizeof(string), "[%i]\n%s\n%s", bizid, BillBoardData[bizid][bbName], BillBoardData[bizid][bbMessage]);
            BillBoardData[bizid][bbText3D] = CreateDynamic3DTextLabel(string, 0x33AA33FF, BillBoardData[bizid][bbPos][0], BillBoardData[bizid][bbPos][1], BillBoardData[bizid][bbPos][2], BillBoardData[bizid][bbRange], INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0);
        }
    }
    return 1;
}

// ====== Billboard_Create ======
Billboard_Create(playerid, price)
{
    static
        Float:x,
        Float:y,
        Float:z;

    if (GetPlayerPos(playerid, x, y, z))
    {
        for (new i = 0; i != MAX_BILLBOARDS; i ++)
        {
            if (!BillBoardData[i][bbExists])
            {
                BillBoardData[i][bbExists] = true;
                BillBoardData[i][bbOwner] = 0;
                BillBoardData[i][bbPrice] = price;
                BillBoardData[i][bbRange] = 10;

                format(BillBoardData[i][bbName], 32, "Unnamed Billboard");

                BillBoardData[i][bbPos][0] = x;
                BillBoardData[i][bbPos][1] = y;
                BillBoardData[i][bbPos][2] = z;

                Billboard_Refresh(i);
                mysql_tquery(g_iHandle, "INSERT INTO `billboards` (`bbOwner`) VALUES(0)", "OnBillboardCreated", "d", i);
                return i;
            }
        }
    }
    return -1;
}

// ====== Billboard_Delete ======
Billboard_Delete(bizid)
{
    if (bizid != -1 && BillBoardData[bizid][bbExists])
    {
        new
            string[82];

        format(string, sizeof(string), "DELETE FROM `billboards` WHERE `bbID` = '%d'", BillBoardData[bizid][bbID]);
        mysql_tquery(g_iHandle, string);

        if (IsValidDynamic3DTextLabel(BillBoardData[bizid][bbText3D]))
            DestroyDynamic3DTextLabel(BillBoardData[bizid][bbText3D]);

        BillBoardData[bizid][bbExists] = false;
        BillBoardData[bizid][bbOwner] = 0;
        BillBoardData[bizid][bbID] = 0;
    }
    return 1;
}

// ====== OnBillboardCreated ======
forward OnBillboardCreated(bizid);

// ====== OnBillboardCreated ======
public OnBillboardCreated(bizid)
{
    if (bizid == -1 || !BillBoardData[bizid][bbExists])
        return 0;

    BillBoardData[bizid][bbID] = cache_insert_id(g_iHandle);
    Billboard_Save(bizid);

    return 1;
}

// ====== Billboard_Load ======
forward Billboard_Load();

// ====== Billboard_Load ======
public Billboard_Load()
{
    new
        rows,
        fields;

    cache_get_data(rows, fields, g_iHandle);

    for (new i = 0; i < rows; i ++) if (i < MAX_BILLBOARDS)
    {
        BillBoardData[i][bbExists] = true;
        BillBoardData[i][bbID] = cache_get_field_int(i, "bbID");

        cache_get_field_content(i, "bbName", BillBoardData[i][bbName], g_iHandle, 32);
        cache_get_field_content(i, "bbMessage", BillBoardData[i][bbMessage], g_iHandle, 230);

        BillBoardData[i][bbOwner] = cache_get_field_int(i, "bbOwner");
        BillBoardData[i][bbPrice] = cache_get_field_int(i, "bbPrice");
        BillBoardData[i][bbRange] = cache_get_field_int(i, "bbRange");
        BillBoardData[i][bbPos][0] = cache_get_field_float(i, "bbPosX");
        BillBoardData[i][bbPos][1] = cache_get_field_float(i, "bbPosY");
        BillBoardData[i][bbPos][2] = cache_get_field_float(i, "bbPosZ");
        Billboard_Refresh(i);
    }
    return 1;
}

// ====== OnViewBillboards ======
forward OnViewBillboards(extraid, name[]);

// ====== OnViewBillboards ======
public OnViewBillboards(extraid, name[])
{
    new
        string[1024],
        desc[128],
        rows,
        fields;

    cache_get_data(rows, fields, g_iHandle);

    if (!rows)
        return SendErrorMessage(extraid, "No billboards found!");

    for (new i = 0; i < rows; i ++) {
        cache_get_field_content(i, "bbName", desc, g_iHandle, sizeof(desc));

        format(string, sizeof(string), "%s{FFFFFF}Billboard ({FFBF00}%i{FFFFFF}) | %s | $%d\n", string, i, desc, BillBoardData[i][bbPrice]);
    }
    format(desc, sizeof(desc), "Los Santos Billboards Agency", name);
    Dialog_Show(extraid, Billboards, DIALOG_STYLE_LIST, DialogStyle_Title(desc), string, "Close", "");
    return 1;
}
