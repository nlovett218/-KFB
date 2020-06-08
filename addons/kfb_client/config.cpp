#define true				1
#define false				0

#define private				0
#define protected			1
#define public				2

#define VSoft				0
#define VArmor				1
#define VAir				2

#define TEast				0
#define TWest				1
#define TGuerrila			2
#define TCivilian			3
#define TSideUnknown		4
#define TEnemy				5
#define TFriendly			6
#define TLogic				7

#define ReadAndWrite		0
#define ReadAndCreate		1
#define ReadOnly			2
#define ReadOnlyVerified	3

#include "CfgPatches.hpp"
#include "CfgExileLoadingScreen.hpp"
#include "CfgFunctions.hpp"
#include "CfgMagazines.hpp"
#include "CfgMods.hpp"
#include "CfgMusic.hpp"
#include "CfgXM8.hpp"
#include "CfgSounds.hpp"
#include "CfgMarkers.hpp"

class Attributes;							// External class reference
class RscStandardDisplay;					// External class reference
class RscProgress;							// External class reference
class RscStructuredText;					// External class reference
class RscPicture;							// External class reference
class RscButton;							// External class reference
class RscButtonMenu;						// External class reference
class RscButtonMenuOK;						// External class reference
class RscButtonMenuCancel;					// External class reference
class RscText;								// External class reference
class RscVignette;							// External class reference
class RscActiveText;						// External class reference
class RscListBox;							// External class reference
class RscListNBox;							// External class reference
class RscCombo;								// External class reference
class RscHTML;								// External class reference
class RscPictureKeepAspect;					// External class reference
class RscMapControl;						// External class reference
class RscControlsGroupNoScrollbars;			// External class reference
class RscTitle;								// External class reference
class RscControlsGroup;						// External class reference
class RscEdit;								// External class reference
class RscCheckBox;							// External class reference
class Scrollbar;							// External class reference
class ctrlStaticPicture;					// External class reference
class RscButtonMenuSteam;					// External class reference
class RscButtonTextOnly;					// External class reference

#include "RscExilePrimaryButton.hpp"
#include "RscDisplayNotFreeze.hpp"
#include "RscExileSelectSpawnLocationDialog.hpp"
#include "RscMPSetupMessage.hpp"
#include "RscExileXM8Slide.hpp"
#include "RscExileXM8Frame.hpp"
#include "RscExileXM8AppButton.hpp"
#include "RscExileXM8AppButton1x1.hpp"
#include "RscExileXM8AppButton2x1.hpp"
#include "RscExileXM8Edit.hpp"
#include "RscExileXM8Button.hpp"
#include "RscExileXM8ButtonMenu.hpp"
#include "RscExileXM8ListBox.hpp"
#include "RscExileXM8.hpp"