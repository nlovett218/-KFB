/**
 * Pre-Start
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 *
 * --------------------------
 *
 * Eichi: 
 * Do not use "with uiNameSpace do" here or you will collect mini dumps.
 * Also, do not call or spawn shit here. Serialization does not work. FSMs
 * are not executed at all. onEachFrame never fires. onDraw does not fire.
 * onLoad fires for all, onUnload only fires for some. And CT_ANIMATED_TEXTURE
 * looks ugly. If I ever have to touch this again, I will kill myself.
 *
 * 2017-05-07: Killed myself.
 *
 */

if !(hasInterFace) exitWith {false};

///////////////////////////////////////////////////////////////////////////////
// Reset loading screen data
///////////////////////////////////////////////////////////////////////////////
uiNameSpace setVariable ["ExileClient_gui_loadingScreen_reset",
{
	uiNameSpace setVariable ["ExileLoadingScreenBackgroundPicture", nil];
	uiNameSpace setVariable ["ExileLoadingScreenMapData", nil];
	uiNameSpace setVariable ["ExileLoadingScreenMissionData", nil];
	uiNameSpace setVariable ["ExileClientLoadingScreenDisplays", nil];
	uiNameSpace setVariable ["RscDisplayLoading_display", nil];
}];

///////////////////////////////////////////////////////////////////////////////
// Constructor of our loading screen
//
// Eichi: Careful! Passing the display to call or spawn DOES NOT WORK!
// I had this split into multiple functions, but serializing them is 
// obivously not possible. Means we have a big booty functio now :(
///////////////////////////////////////////////////////////////////////////////

uiNameSpace setVariable ["ExileClient_gui_loadingScreen_load",
{
	disableSerialization;

	private ["_spinnerTextControl", "_newsControl", "_cookie", "_cookieAlphabet"];
	private [ "_loadingText", "_loadingTextTemplates", "_loadingTextTemplate"];
	private ["_loadScreenMusicInit"];

	_loadScreenMusicInit = uiNamespace getVariable["KFB_loadingScreenMusicInit", false];

	params ["_display", "_displayType"];

	// Seems to be required so the core engine functions work
	uiNameSpace setVariable ["RscDisplayLoading_display", _display];

	// So BIS_fnc_progressLoadingScreen works
	RscDisplayLoading_progress = (_display displayCtrl 104);

	// Update the text to either loading map or mission
	_spinnerTextControl = _display displayCtrl 66002;

	/*if !(_loadScreenMusicInit) then {
		diag_log "Playing KFB loading screen music!";
		uiNamespace setVariable["KFB_loadingScreenMusicInit", true];
		playSound "LoadingScreenMusic";
	};*/

	switch (_displayType) do 
	{
		case "RscDisplayMultiplayerSetup":
		{
			_spinnerTextControl ctrlSetStructuredText (parseText "<t>Joining...</t>");
		};

		case "RscDisplayClient":
		{
			_spinnerTextControl ctrlSetStructuredText (parseText "<t>Connecting...</t>");
			
			/*if !(_loadScreenMusicInit) then {
				diag_log "Playing KFB loading screen music!";
				uiNamespace setVariable["KFB_loadingScreenMusicInit", true];
				playSound "LoadingScreenMusic";
				playMusic ["LoadingScreenMusic", 0];
				//removeAllMusicEventHandlers "MusicStop";
			};*/
		};

		case "RscMPSetupMessage":
		{
			_spinnerTextControl ctrlSetStructuredText (parseText "<t>Downloading...</t>");
		};

		default
		{
			// 1 out of 10 is link
			if ((floor (random 10)) < 1) then 
			{
				_loadingText = "<t>Your text here? Make a suggestion: </t><t color='#c72651'>https://discord.gg/BNKMCZC</t>";
			}
			else 
			{
				_loadingTextTemplates = getArray (configFile >> "CfgExileLoadingScreen" >> "templates");
				_loadingTextTemplate = selectRandom _loadingTextTemplates;			
				_loadingText = format ["<t>%1</t> <t size='0.5' color='#00c8ec' valign='bottom'>%2</t>", _loadingTextTemplate select 0, _loadingTextTemplate select 1];
			};

			_spinnerTextControl ctrlSetStructuredText (parseText _loadingText);
		};
	};

	///////////////////////////////////////////////////////////////////////////
	// Find out if the current mission / world is a cutscene

	private ["_isCutscene", "_cutscenes"];

	_isCutscene = true;

	// World must be set and not VR
	// Never show a loading screen for VR
	if !(worldName in ["", "VR"]) then
	{
		// As we have a world, we should be able to read the map config
		_cutscenes = [];

		{
			_cutscenes pushBackUnique (toLower _x);	
		}
		forEach getArray (configFile >> "CfgWorlds" >> worldName >> "cutscenes");

		// Add these to the test array
		_cutscenes pushBackUnique "tempmissionsp";
		_cutscenes pushBackUnique "";

		// If the mission name is empty, tempMissionSP or in the world cutscenes,
		// it is a cutscene. If not, this sets it to false
		_isCutscene = ((toLower missionName) in _cutscenes);
	};

	///////////////////////////////////////////////////////////////////////////

	private ["_backgroundPicture", "_backgroundPictureControl"];

	// If we do not have a background image yet, choose a random one
	_backgroundPicture = uiNameSpace getVariable ["ExileLoadingScreenBackgroundPicture", false];

	// Update the background picture. This is not needed to be done
	// in the loop below, since onLoad fires at least once for all 
	// of them and the background image does not depend on mission
	// or map info
	if (_backgroundPicture isEqualTo false) then 
	{
		_backgroundPicture = selectRandom 
		[
			"kfb_client\images\loading_screen01.paa",
			"kfb_client\images\loading_screen02.paa",
			"kfb_client\images\loading_screen03.paa",
			"kfb_client\images\loading_screen04.paa",
			"kfb_client\images\loading_screen05.paa",
			"kfb_client\images\loading_screen06.paa",
			"kfb_client\images\loading_screen07.paa"
		];	

		uiNameSpace setVariable ["ExileLoadingScreenBackgroundPicture", _backgroundPicture];
	};

	_backgroundPictureControl = _display displayCtrl 66000;
	_backgroundPictureControl ctrlSetText _backgroundPicture;

	///////////////////////////////////////////////////////////////////////////

	private ["_mapData", "_mapConfig", "_mapName", "_mapAuthor", "_mapPicture"];
	private ["_mapControl", "_mapNameControl", "_mapAuthorControl", "_mapPictureControl"];

	// Do we have map data already?
	_mapData = uiNameSpace getVariable ["ExileLoadingScreenMapData", false];

	if (_mapData isEqualTo false) then
	{
		// Ignore cutscenes
		if !(_isCutscene) then
		{
			// Access the map config
			_mapConfig = "";

			// Get the map name
			_mapName = "";
			
			// Fall back to the config name of this map
			if (_mapName isEqualTo "") then 
			{
				_mapName = "";
			};

			// Extract the map author...
			_mapAuthor = "";

			// ...or default to "Unknown Community Author"
			if (_mapAuthor isEqualTo "") then 
			{
				_mapAuthor = "";
			};

			// Update the map picture
			_mapPicture = "";

			// Because VR is utterly broken. It only has a white image
			if (_mapPicture isEqualTo "") then 
			{
				_mapPicture = "";
			};

			if (_mapPicture isEqualTo "") then 
			{
				_mapPicture = "";
			};

			// Default to Arma 3 logo if there is no map picture
			if (_mapPicture isEqualTo "") then 
			{
				_mapPicture = ""
			};

			// Tanoa does not have a good pictureMap
			if (worldName isEqualTo "Tanoa") then 
			{
				_mapPicture = ""
			};

			// Save the map data for later use
			_mapData = 
			[
				_mapName,
				_mapAuthor,
				_mapPicture
			];

			uiNameSpace setVariable ["ExileLoadingScreenMapData", _mapData];
		};
	};

	///////////////////////////////////////////////////////////////////////////

	private ["_missionData", "_missionName", "_missionAuthor", "_missionPicture"];
	private ["_missionControl", "_missionPictureControl", "_missionNameControl", "_missionAuthorControl"];

	_missionData = uiNameSpace getVariable ["ExileLoadingScreenMissionData", false];

	// If we do not have a mission data, try to extract it
	if (_missionData isEqualTo false) then 
	{
		// Ignore cutscenes
		if !(_isCutscene) then
		{
			// Get the defined mission name or briefing name
			_missionName = "";

			// If there is no mission name, use "Unnamed Mission"
			if (_missionName isEqualTo "") then 
			{
				_missionName = "";
			};

			// Get the defined mission author or "Unknown Community Author"
			_missionAuthor = "";

			// Try to get a community logo first
			_missionPicture = "";

			// If there is no community logo, try another, older property
			if (_missionPicture isEqualTo "") then 
			{
				_missionPicture = "";
			};

			// If that still is not defined, use our logo
			if (_missionPicture isEqualTo "") then 
			{
				_missionPicture = "";
			};

			// Keep this in mind :D
			_missionData = 
			[
				_missionName,
				_missionAuthor,
				_missionPicture
			];

			// Store the data so we can access it later (where missionConfig is not there)
			uiNameSpace setVariable ["ExileLoadingScreenMissionData", _missionData];
		};
	};

	///////////////////////////////////////////////////////////////////////////

	// Keep all involved displays in mind. onLoad does not fire
	// for all of them. "Receiving data..." for example never has
	// a onLoad...
	_loadingDisplays = uiNameSpace getVariable ["ExileClientLoadingScreenDisplays", []];
	_loadingDisplays pushBackUnique _display;

	{
		if !(isNull _x) then 
		{
			// Update the map info
			_mapControl = _x displayCtrl 66003;

			if (_mapData isEqualTo false) then 
			{
				// Hide the map, if we lack data
				_mapControl ctrlShow false;
			}
			else 
			{
				// Show the map data
				_mapControl ctrlShow false;

				// Update the map name
				_mapNameControl = _x displayCtrl 66005;
				_mapNameControl ctrlSetText (_mapData select 0);

				// Update the map author
				_mapAuthorControl = _x displayCtrl 66006;
				_mapAuthorControl ctrlSetText (_mapData select 1);

				// Update the map picture
				_mapPictureControl = _x displayCtrl 66004;
				_mapPictureControl ctrlSetText (_mapData select 2);
			};

			// Update the mission info
			_missionControl = _x displayCtrl 66007;

			// If we do not have mission data, hide the mission
			if (_missionData isEqualTo false) then 
			{
				_missionControl ctrlShow false;
			}
			else 
			{
				// Ensure it is shown if we have data
				_missionControl ctrlShow false;

				// Update the name
				_missionNameControl = _x displayCtrl 66009;
				_missionNameControl ctrlSetText (_missionData select 0);

				// Update the author
				_missionAuthorControl = _x displayCtrl 66010;
				_missionAuthorControl ctrlSetText (_missionData select 1);

				// Update the picture
				_missionPictureControl = _x displayCtrl 66008;
				_missionPictureControl ctrlSetText (_missionData select 2);
			};
		};
	}
	forEach _loadingDisplays;

	uiNameSpace setVariable ["ExileClientLoadingScreenDisplays", _loadingDisplays];
}];

///////////////////////////////////////////////////////////////////////////////
// A spawned thread to animate the spinning wheel of our loading screen
//
// -----
// 
//_animationThread = uiNameSpace getVariable ["ExileLoadingScreenSpinnerThread", scriptNull];
// 
// if (isNull _animationThread) then 
// {
// 	// We cannot pass _spinner here :(
// 	_animationThread = [] spawn (uiNameSpace getVariable ["ExileClient_gui_animateLoadingScreen", scriptNull]);
// 
// 	uiNameSpace setVariable ["ExileLoadingScreenSpinnerThread", _animationThread];
// };
// 
// uiNameSpace setVariable ["ExileLoadingScreenSpinnerThread", _animationThread];
///////////////////////////////////////////////////////////////////////////////

uiNameSpace setVariable ["ExileClient_gui_loadingScreen_animate",
{
	disableSerialization;

	private ["_spinner", "_startTime"];

	_spinner = (uiNameSpace getVariable ["RscExileLoadingScreen", controlNull]) displayCtrl 66001;
	_startTime = diag_tickTime;

	while {true} do // until terminate on unload fires
	{
		_spinner ctrlSetAngle [(diag_tickTime - _startTime) * 360, 0.5, 0.5];

		// 1/60 results in underflow = the spinner lags
		// minimum in Arma is 3ms, but this works:
		uiSleep 0.016; 
	};
}];

///////////////////////////////////////////////////////////////////////////////
// Deconstruct the loading screen
///////////////////////////////////////////////////////////////////////////////

uiNameSpace setVariable ["ExileClient_gui_loadingScreen_unload",
{
	disableSerialization;

	private ["_animationThread"];

	_animationThread = uiNameSpace getVariable ["ExileLoadingScreenSpinnerThread", scriptNull];

	if !(isNull _animationThread) then 
	{
		terminate _animationThread;
		uiNameSpace setVariable ["ExileLoadingScreenSpinnerThread", scriptNull]
	};
}];

true
