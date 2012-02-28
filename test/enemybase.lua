----------------------------------------------------------
-- enemybase.lua
-- Contains table of values that represent the enemy's base.
----------------------------------------------------------
local Material = require("materials")
W = display.contentWidth
H = display.contentHeight

EnemyBase = {}

EnemyBase.level1 = {
	numObjects=4,
	types={
		"wood_plank", "wood_plank", "wood_box", "wood_box"
	},
	x_vals={
		800, 874, 837, 837
	},
	y_vals={
		H-47, H-47, H-121, H-195
	},
	rotations={
		90, 90, 0, 0
	}
}

return EnemyBase