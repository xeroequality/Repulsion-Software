----------------------------------------------------------
-- levelinfo.lua
-- Contains table of all iterative information for each level
-- SINGLE PLAYER ONLY (for now?)
----------------------------------------------------------
local Material = require("materials")
W = display.contentWidth
H = display.contentHeight

LevelInfo = {}

LevelInfo.level1 = {
	title = "Level 1: Los Angeles",
	desc = "Description here",
	parScore = 5000,
	wallet = 1000,
	achievementIDs = {
		001,002,003
	}
}
LevelInfo.level2 = {
	title = "Level 2: Mexico City",
	desc = "Hola Beetches!",
	parScore = 5000,
	wallet = 800,
	achievementIDs = {
		002,004,005
	}
}
LevelInfo.level3 = {
	title = "Level 3: Montreal",
	desc = "Parlez vous francais?",
	parScore = 7500,
	wallet = 1200,
	achievementIDs = {
		005
	}
}
LevelInfo.level4 = {
	title = "Level 4: New York City",
	desc = "MOVE!",
	parScore = 8000,
	wallet = 1500,
	achievementIDs = {
		006,007
	}
}
LevelInfo.level5 = {
	title = "Boss Level: UF",
	desc = "Evil Dr. Bermudez",
	parScore = 5000,
	wallet = 800,
	achievementIDs = {
		008,009,010
	}
}

return LevelInfo