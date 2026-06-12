//Waits until display 46 has initialised.
waitUntil {!isNull findDisplay 46};

//Creates a variable to check if the menu is already open.
missionNamespace setVariable ["RZ_radialMenuOpen", false];

//Creates a eventHandler that checks if the key 'T' has been pressed down.
(findDisplay 46) displayAddEventHandler ["KeyDown", {
    params ["_display", "_key", "_shift", "_ctrl", "_alt"];

    // T key == 20
    if (_key == 20) then {
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

//Creates another eventHandler for when the key 'T' has been lifted.
(findDisplay 46) displayAddEventHandler ["KeyUp", {
    params ["_display", "_key", "_shift", "_ctrl", "_alt"];

    // T key == 20
    if (_key == 20) then {
        [] execVM "confirmRadialSelection.sqf";
        true
    } else {
        false
    };
}];
