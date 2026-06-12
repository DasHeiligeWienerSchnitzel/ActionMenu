//FUNCTIONS

//Clears the subring displays
RZ_fnc_clearSubRing = {
    {
        ctrlDelete _x;
    } forEach (uiNamespace getVariable ["RZ_subRingControls", []]);

    uiNamespace setVariable ["RZ_subRingControls", []];
};

disableSerialization;

// Close old menu if it exists
if (!isNull (uiNamespace getVariable ["RZ_Radial_Display", displayNull])) then {
    (uiNamespace getVariable ["RZ_Radial_Display", displayNull]) closeDisplay 1;
};

// Create display
private _display = findDisplay 46 createDisplay "RscDisplayEmpty";
uiNamespace setVariable ["RZ_Radial_Display", _display];

//Checks if the mouse position stays nearby the selection, if gone to far
// it will remove the selection
[] spawn {
    disableSerialization;

    while {!isNull (uiNamespace getVariable ["RZ_Radial_Display", displayNull])} do {

        private _center = uiNamespace getVariable ["RZ_subRingCenter", []];

        if !(_center isEqualTo []) then {
            private _mouse = getMousePosition;

            private _dx = (_mouse select 0) - (_center select 0);
            private _dy = (_mouse select 1) - (_center select 1);

            private _dist = sqrt ((_dx * _dx) + (_dy * _dy));

            if (_dist > 0.42) then {
                call RZ_fnc_clearSubRing;
                uiNamespace setVariable ["RZ_subRingCenter", []];
                player setVariable ["RZ_selected", ""];
            };
        };

        uiSleep 0.03;
    };
};

//Always centers the mouse at initialization
setMousePosition [0.5, 0.5];

//Checks if the T key gets lifted up
_display displayAddEventHandler ["KeyUp", {
    params ["_display", "_key", "_shift", "_ctrl", "_alt"];

    if (_key == 20) then {
        [] execVM "confirmRadialSelection.sqf";
        true
    } else {
        false
    };
}];

//Checks if the display gets unloaded
_display displayAddEventHandler ["Unload", {
    missionNamespace setVariable ["RZ_radialMenuOpen", false];
    player setVariable ["RZ_selected", ""];
    uiNamespace setVariable ["RZ_Radial_Display", displayNull];
}];

// Menu data
private _items = [
    "Movement",
    "Follow",
    "Combat",
    "Contact",
    "Casualties",
	"MASCAS",
    "Warning"
];


// Layout
private _centerX = safeZoneX + safeZoneW / 2;
private _centerY = safeZoneY + safeZoneH / 2;

private _radiusX = safeZoneW * 0.22;
private _radiusY = safeZoneH * 0.28;

private _buttonW = safeZoneW * 0.10;
private _buttonH = safeZoneH * 0.045;

private _count = count _items;

// Create radial buttons
{
    private _text = _x;

    // Starts at top, then goes clockwise
    private _angle = ((360 / _count) * _forEachIndex);

    private _posX = _centerX + (sin _angle) * _radiusX - _buttonW / 2;
    private _posY = _centerY - (cos _angle) * _radiusY - _buttonH / 2;

    private _ctrl = _display ctrlCreate ["RscButton", 1000 + _forEachIndex];

    _ctrl ctrlSetText _text;
    _ctrl ctrlSetPosition [_posX, _posY, _buttonW, _buttonH];
    _ctrl ctrlSetBackgroundColor [0, 0, 0, 0.55];
    _ctrl ctrlSetTextColor [1, 1, 1, 1];
    _ctrl ctrlCommit 0;

    _ctrl setVariable ["RZ_actionText", _text];

    _ctrl ctrlAddEventHandler ["MouseEnter", {
        params ["_ctrl"];
        call RZ_fnc_clearSubRing;
		
		_ctrl ctrlSetBackgroundColor [0.15, 0.35, 0.65, 0.85];
		
		_text = _ctrl getVariable ["RZ_actionText", ""];
		
		player setVariable ["RZ_selectedCategory", _text];
		
		private _display = ctrlParent _ctrl;

		private _mainPos = ctrlPosition _ctrl;
		private _centerX = (_mainPos select 0) + (_mainPos select 2) / 2;
		private _centerY = (_mainPos select 1) + (_mainPos select 3) / 2;
		
		uiNamespace setVariable ["RZ_subRingCenter", [_centerX, _centerY]];

		private _auswahl = [];

		switch (_text) do {
			case "Contact": {_auswahl = ["N","NE","E","SE","S","SW","W","NW"]};
			case "Follow": {_auswahl = ["Lowe", "Noodles","Smoke"]};
			case "MASCAS": {_auswahl = ["1-0","1-1","1-2","1-3"]};
			case "Casualties": {_auswahl = ["1-0","1-1","1-2","1-3"]};
			case "Combat": {_auswahl = ["Hold Fire", "Watch & Shoot", "Rapid Fire", "Prep AT"]};
			case "Movement": {_auswahl = ["Mount", "Dismount", "Take Cover", "Move"]};
			case "Warning": {_auswahl = ["Mines", "Gas", "Enemy Vehicle"]};
		};

		private _count = count _auswahl;
		private _subControls = [];

		{
			private _subText = _x;

			private _angle = (360 / _count) * _forEachIndex;

			private _radiusX = safeZoneW * 0.13/1.25;
			private _radiusY = safeZoneH * 0.18/1.25;

			private _buttonW = safeZoneW * 0.06;
			private _buttonH = safeZoneH * 0.035;

			private _posX = _centerX + (sin _angle) * _radiusX - _buttonW / 2;
			private _posY = _centerY - (cos _angle) * _radiusY - _buttonH / 2;

			private _subCtrl = _display ctrlCreate ["RscButton", -1];

			_subCtrl ctrlSetText _subText;
			_subCtrl ctrlSetPosition [_posX, _posY, _buttonW, _buttonH];
			_subCtrl ctrlSetBackgroundColor [0, 0, 0, 0.55];
			_subCtrl ctrlCommit 0;
			
			_subCtrl setVariable ["RZ_actionText", _subText];
			
			_subCtrl ctrlAddEventHandler ["MouseEnter", {
				params ["_subCtrl"];
				
				_subText = _subCtrl getVariable ["RZ_actionText", ""];
				player setVariable ["RZ_selectedSubCategory", _subText];
			}];
			
			_subControls pushBack _subCtrl;
		} forEach _auswahl;
		
		uiNamespace setVariable ["RZ_subRingControls", _subControls];
    }];

    _ctrl ctrlAddEventHandler ["MouseExit", {
        params ["_ctrl"];
        _ctrl ctrlSetBackgroundColor [0, 0, 0, 0.55];
		
		player setVariable ["RZ_selected", ""];
    }];

} forEach _items;