--The Achievements

--Format:
--{Achievement ID, Title, Description, Completed?, Arguments}
Trophies = {
	totalScore = 0, ---Cumulative Score
	maxScore = 0, --Highest Score Ever Gotten
	totalSpent = 0, --Total Amount of Money Spent
	maxPercentageofMoneyKept = 0, --Highest Percent of Money Leftover After Building and Won With
	savedStructures = 0, --Total Number of Structures Saved
	loadedStructres = 0, --Total Number of Structures Loaded
	destroyedObjects = 0, --Total Number of Objects Destroyed by Player
	losses = 0, --Total Losses
	wins = 0, --Total Wins
	weaponsShot = 0, --Number Of Times the Player Has Shot a Weapon
	weaponsBought = 0, --Number of Weapons Bought by the Player
	weaponsDestroyed = 0, --Total Number of Enemy Weapons Destroyed by Player
	materialsBought = 0, --Number of Materials Bought by the Player
	materialsDestroyed = 0, --Total Number of Enemy Materials Destroyed by the Player
	maxCombo = 0, --Max Amount of Materials/Weapons Destroyed with One Shot
	levelsCompleted = 0, --Number of Levels Completed
	longestNumofTurns = 0, --Highest Number of Turns Taken in Any Battle
	shortestNumofTurns = 0, --Shortest Number of Turns Taken in Any Battle
	achievementsGained = 0, --Number of Achievements Received
	parScoreReached = 0, --Number of Levels Where the Par Score was Reached
	slotsUsed = 0, --Number of Save Slots that are Occupied
	
	Ach = {
		[1] = {ID = 001, Title = "Saving Grace", Description = "Save a Structure to a File", Completed = false, Bound = "savedStructures > 0"},
		[2] = {ID = 002, Title = "A Load Off my Back", Description = "Load a Saved Structure", Completed = false, Bound = "loadedStructures > 0"},
		[3] = {ID = 002, Title = "One Down", Description = "Win a Level in Single Player", Completed = false, Bound = "levelsCompleted > 0"}
	}
}

Trophies.update = function()
end

return Trophies;