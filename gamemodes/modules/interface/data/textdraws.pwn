/*
    File: modules/interface/data/textdraws.pwn
    Purpose: Defines interface data structures, constants, static arrays, or runtime storage for textdraws.
    Notes: Do not place command handlers, dialogs, mapping objects, or heavy gameplay flows in data files.
*/

// ====== Global Textdraws ======
new Text:gServerTextdraws[4];

// ====== Hunger/Thirst HUD Textdraw Indexes ======
#define INDIKATOR_LAPAR_BELAKANG	(63)
#define INDIKATOR_HAUS_BELAKANG		(64)
#define INDIKATOR_LAPAR_DEPAN		(65)
#define INDIKATOR_HAUS_DEPAN		(66)
#define HBE_BACKGROUND				(83)
#define HBE_TITLE					(84)
#define HBE_HUNGER_LABEL			(85)
#define HBE_THIRST_LABEL			(86)

#define HUNGER_THIRST_BAR_WIDTH		(61.0)
#define HUNGER_THIRST_BAR_HEIGHT	(10.0)
