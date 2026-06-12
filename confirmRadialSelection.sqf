disableSerialization;

//Gets the selected category and its subcategory.
private _category = player getVariable ["RZ_selectedCategory", ""];
private _subCategory = player getVariable ["RZ_selectedSubCategory", ""];

//Checks if those are not empty and then creates a hint only for all players in range of 50 meters.
if (_category != "" && _subCategory != "") then {

    private _message = format ["%1: %2", _category, _subCategory];

    private _nearPlayers = allPlayers select {
        alive _x && {_x distance player <= 50}
    };

    [_message] remoteExec ["hint", _nearPlayers];
};

// Close menu
private _display = uiNamespace getVariable ["RZ_Radial_Display", displayNull];

if (!isNull _display) then {
    _display closeDisplay 1;
};

uiNamespace setVariable ["RZ_Radial_Display", displayNull];
missionNamespace setVariable ["RZ_radialMenuOpen", false];
player setVariable ["RZ_selected", ""];