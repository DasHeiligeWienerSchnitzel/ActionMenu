//Waits until display 46 has initialised.
waitUntil {!isNull findDisplay 46};

//Creates a variable to check if the menu is already open.
missionNamespace setVariable ["RZ_radialMenuOpen", false];

//Creates a eventHandler that checks if the key 'P' has been pressed down.
(findDisplay 46) displayAddEventHandler ["KeyDown", {
    params ["_display", "_key", "_shift", "_ctrl", "_alt"];

    // P key == 25
    if (_key == 25) then {
		//Creates the radial Menu if no radial Menu already exists.
        if !(missionNamespace getVariable ["RZ_radialMenuOpen", false]) then {
            missionNamespace setVariable ["RZ_radialMenuOpen", true];
            player setVariable ["RZ_selected", ""];
            [] execVM "openRadialMenu.sqf";
        };

        true
    } else {
        false
    };
}];
