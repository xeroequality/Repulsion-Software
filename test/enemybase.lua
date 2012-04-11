----------------------------------------------------------
-- enemybase.lua
-- Contains table of values that represent the enemy's base.
----------------------------------------------------------
local Material = require("materials")
W = display.contentWidth
H = display.contentHeight

EnemyBase = {}

EnemyBase.level1 = {
	numObjects=17,
	baseX = 700,
	baseY = H-10,
	types={
		"wood_box",
		"wood_box",
		"wood_plank",
		"wood_plank",
		"wood_plank",
		"wood_plank",
		"wood_plank",
		"wood_plank",
		"wood_plank",
		"wood_box",
		"wood_box",
		"wood_box",
		"wood_box",
		"wood_plank",
		"wood_plank",
		"wood_plank",
		"wood_plank"
		
	},
	x_vals={
		-40,85,22,22,75,80,85,90,110,90,230,230,230,115,220,175,220
	},
	y_vals={
		-37,-37,-90,-90,-100,-100,-100,-100,-150,-200,-50,-100,-150,-230,-200,-240,-230
	},
	rotations={
		0,0,0,0,90,90,90,90,0,0,0,0,0,0,0,0,0
	}
}

return EnemyBase