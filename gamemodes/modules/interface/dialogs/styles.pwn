/*
    File: modules/interface/dialogs/styles.pwn
    Purpose: Shared dialog text styling helpers for reusable colored sections and fields.
    Notes: Keep this file limited to formatting helpers. Dialog response callbacks belong in dialogs/base.pwn or domain dialog files.
*/

#if !defined DIALOG_STYLE_WHITE
	#define DIALOG_STYLE_WHITE      "{FFFFFF}"
	#define DIALOG_STYLE_YELLOW     "{FFFF00}"
	#define DIALOG_STYLE_LIGHT_BLUE "{33CCFF}"
	#define DIALOG_STYLE_TOMATO     "{FF6347}"
	#define DIALOG_STYLE_GREEN      "{33CC33}"
	#define DIALOG_STYLE_RED        "{FF0000}"
#endif

// ====== DialogStyle_Reset ======
stock DialogStyle_Reset(buffer[])
{
	buffer[0] = '\0';
	return 1;
}

// ====== DialogStyle_Title ======
stock DialogStyle_Title(const text[])
{
	static
		title[128];

	format(title, sizeof(title), ""DIALOG_STYLE_YELLOW"%s", text);
	return title;
}

// ====== DialogStyle_Body ======
stock DialogStyle_Body(const text[])
{
	static
		body[2048];

	if (text[0] == '{')
		format(body, sizeof(body), "%s", text);
	else
		format(body, sizeof(body), ""DIALOG_STYLE_WHITE"%s", text);

	return body;
}

// ====== DialogStyle_Header ======
stock DialogStyle_Header(buffer[], size = sizeof(buffer), const title[], const subtitle[] = "", regid = -1)
{
	if (regid != -1 && strlen(subtitle))
		format(buffer, size, ""DIALOG_STYLE_YELLOW"%s"DIALOG_STYLE_WHITE" ("DIALOG_STYLE_LIGHT_BLUE"%s"DIALOG_STYLE_WHITE") (RegPID: %d)", title, subtitle, regid);
	else if (strlen(subtitle))
		format(buffer, size, ""DIALOG_STYLE_YELLOW"%s"DIALOG_STYLE_WHITE" ("DIALOG_STYLE_LIGHT_BLUE"%s"DIALOG_STYLE_WHITE")", title, subtitle);
	else
		format(buffer, size, ""DIALOG_STYLE_YELLOW"%s", title);

	return 1;
}

// ====== DialogStyle_AddSection ======
stock DialogStyle_AddSection(buffer[], size = sizeof(buffer), const title[])
{
	format(buffer, size, "%s"DIALOG_STYLE_TOMATO"%s"DIALOG_STYLE_WHITE"\n", buffer, title);
	return 1;
}

// ====== DialogStyle_AddField ======
stock DialogStyle_AddField(buffer[], size = sizeof(buffer), const label[], const value[], const color[] = DIALOG_STYLE_LIGHT_BLUE, bool:newline = false)
{
	format(buffer, size, "%s%s: [%s%s"DIALOG_STYLE_WHITE"]%s", buffer, label, color, value, (newline) ? ("\n") : (" | "));
	return 1;
}

// ====== DialogStyle_AddBlankLine ======
stock DialogStyle_AddBlankLine(buffer[], size = sizeof(buffer))
{
	format(buffer, size, "%s\n", buffer);
	return 1;
}
