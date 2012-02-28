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
	baseX = 700,
	baseY = H-10,
	types={
		"wood_plank", "wood_plank", "wood_box", "wood_box"
	},
	x_vals={
		0,74,37,37
	},
	y_vals={
		-37,-37,-111,-185
	},
	rotations={
		90, 90, 0, 0
	}
}

return EnemyBase