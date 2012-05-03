----------------------------------------------------------
-- levelinfo.lua
-- Contains table of all iterative information for each level
-- SINGLE PLAYER ONLY (for now?)
----------------------------------------------------------


LevelInfo = {
--ch1 =
{
	--level1 = 
	{
		title = "Level 1: Los Angeles",
		desc = "Description here",
		parScore = 5000,
		wallet = 1200,
		achievementIDs = {
			001,002,003
		},
		overlay = "../images/overlay_ch1.png",
		flagX = 125,
		flagY = 155,
		unlocked = true
	},
	--ch1level2 = 
	{
		title = "Level 2: Mexico City",
		desc = "Hola Beetches!",
		parScore = 5000,
		wallet = 2000,
		achievementIDs = {
		002,004,005
		},
		overlay = "../images/overlay_ch1.png",
		flagX = 205,
		flagY = 250,
		unlocked = true
	},
	--ch1level3 = 
	{
		title = "Level 3: Montreal",
		desc = "Parlez vous francais?",
		parScore = 7500,
		wallet = 2000,
		achievementIDs = {
		005
		},
		overlay = "../images/overlay_ch1.png",
		flagX = 345,
		flagY = 90,
		unlocked = true
	},
	--ch1level4 = 
	{
		title = "Level 4: New York City",
		desc = "MOVE!",
		parScore = 8000,
		wallet = 2500,
		achievementIDs = {
		006,007
		},
		overlay = "../images/overlay_ch1.png",
		flagX = 345,
		flagY = 115,
		unlocked = true
	},
	--ch1level5 = 
	{
		title = "Boss Level: UF",
		desc = "Evil Dr. Bermudez",
		parScore = 5000,
		wallet = 3000,
		achievementIDs = {
		008,009,010
		},
		overlay = "../images/overlay_ch1.png",
		flagX = 310,
		flagY = 195,
		unlocked = true
	}
},
--ch2=
{
 	{
		title = "Level 1: Rio de Jinero",
		desc = "tropical attack!",
		parScore = 5000,
		wallet = 5000,
		achievementIDs = {
		001,002,003
		},
		overlay = "../images/overlay_ch2.png",
		flagX = 315,
		flagY = 130,
		unlocked = true
	},
	--ch2level2 = 
	{
		title = "Level 2: Santiago",
		desc = "Hola Beetches!",
		parScore = 5000,
		wallet = 4000,
		achievementIDs = {
		002,004,005
		},
		overlay = "../images/overlay_ch2.png",
		flagX = 220,
		flagY = 180,
		unlocked = true
	},
	--ch2level3 =
 	{
		title = "Level 3: Quito",
		desc = "Parlez vous francais?",
		parScore = 7500,
		wallet = 5000,
		achievementIDs = {
		005
		},
		overlay = "../images/overlay_ch2.png",
		flagX = 195,
		flagY = 60,
		unlocked = true
	},
	--ch2level4 =
 	{
		title = "Level 4: Buenos Aires",
		desc = "MOVE!",
		parScore = 8000,
		wallet = 3500,
		achievementIDs = {
		006,007
		},
		overlay = "../images/overlay_ch2.png",
		flagX = 265,
		flagY = 180,
		unlocked = true
	},
	--ch2level5 = 
	{
		title = "Boss Level: ????",
		desc = "Que paso?",
		parScore = 5000,
		wallet = 2000,
		achievementIDs = {
		008,009,010
		},
		overlay = "../images/overlay_ch2.png",
		flagX = display.contentWidth/2,
		flagY = display.contentHeight/2,
		unlocked = true
	}
}
}

return LevelInfo