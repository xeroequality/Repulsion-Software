UPDATE: 2-27-12 10:46 PM
REVISION: Jason Simmons


MAJOR CHANGES:
---------------
- Added materials.lua. This defines the data structures for all material types and their values, allowing for easy access to it without declaring in every single level. Example usage:
	LUA CODE:
	_________________________________________
    local Materials = require( "materials" )
	
    ...
	
    local obj = {}
    obj.type = "wood_plank"
    obj = Materials.clone(obj)
    _________________________________________
	
    The variable "obj" now holds all properties of a wood plank. You can simply access them by doing obj.[property]. To view properties, look at materials.lua.

	
---------------
- Added enemybase.lua. This defines the materials used, positions, and rotations of all objects that make up an enemy's base. It is implemented with a loop in the level (ui_scrollview.lua).
	- To use this, only ONE line of code changes on each level:
	LUA CODE:
	_________________________________________
	...
	
	local enemy = EnemyBase.level1
	_________________________________________
	
	Simply change this to EnemyBase.levelN and you will store the values of level N in the variable "enemy".
	
	**NOTE: Implementation of the data for the enemy base is in enemybase.lua. This is where you change values for objects, positions, etc. The idea is to ABSTRACT all enemy base data.
	

	
MINOR CHANGES:
----------------
- Fixed scrollView to fit emulator screen better - Still needs scalability (Chris?)
- Cleaned up unnecessary variables and code as a result of changes listed above
- Player can purposely drop an item below the floor to "trash" it and get money back


Overall, reduced code by over 25% within ui_scrollview.lua.
	This is a big deal, considering this is the "level" code and it will be copy/pasted for each level in the game.
	We want the levels themselves to have as little overhead as possible to reduce memory usage and increase gameplay speed.