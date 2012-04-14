--The Achievements

--Format:
--{Achievement ID, Title, Description, Completed?, Variable, Boolean, Value}
Trophies = {
	totalScore = 0, ---Cumulative Score
	maxScore = 0, --Highest Score Ever Gotten
	totalSpent = 0, --Total Amount of Money Spent
	maxPercentageofMoneyKept = 0, --Highest Percent of Money Leftover After Building and Won With
	savedStructures = 0, --Total Number of Structures Saved
	loadedStructures = 0, --Total Number of Structures Loaded
	destroyedObjects = 0, --Total Number of Objects Destroyed by Player
	objectsBought = 0, --Total Number of Objects Bought by the Player
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
	numOfAchievements = 4, --Update This Number When You Add an Achievements
	
	--Bool Can be > < = ~= >= <=
	
	Ach = {
		[1] = {ID = 001, Title = "Saving Grace", Description = "Save a Structure to a File", Completed = false, Arg = {"savedStructures"}, Bool = {">"}, Value = {0}},
		[2] = {ID = 002, Title = "A Load Off my Back", Description = "Load a Saved Structure", Completed = false, Arg = {"loadedStructures"}, Bool = {">"}, Value = {0}},
		[3] = {ID = 003, Title = "One Down", Description = "Win a Level in Single Player", Completed = false, Arg = {"levelsCompleted"}, Bool = {">"}, Value = {0}},
		[4] = {ID = 004, Title = "Self-Storage", Description = "Use All Ten Save Slots", Completed = false, Arg = {"slotsUsed"}, Bool = {"="}, Value = {10}}
	}
}

Trophies.update = function(u,v)
	--u is the Name of the Variable; and v is the Value
	Trophies[u] =  Trophies[u] + v;
	return Trophies[u];
end

Trophies.replace = function(u,v)
	--Same as Above, but instead of adding to the value, it assigns it.
	Trophies[u] = v;
	return Trophies[u];
end

Trophies.getValue = function(u)
	return Trophies[u];
end

Trophies.checkAchievements = function()
	local k = Trophies.Ach;
	
	--Check All Non-Completed Achievements
	for i = 1,Trophies["numOfAchievements"] do
	
		if k[i]["Completed"] == false then
		
			--Check the Variables
			local var = k[i]["Arg"]; --The Variable Name
			local bool = k[i]["Bool"]; --The Boolean Value
			local val = k[i]["Value"]; --The Value
			
			--Check the Conditions
			local success = true;
			for p = 1,#var do
				--Greater Than Case
				if bool[p] == ">" then
					if Trophies[var[p]] > val[p] then
					else
						success = false;
					end
				end
				
				--Less Than Case
				if bool[p] == "<" then
					if Trophies[var[p]] < val[p] then
					else
						success = false;
					end
				end
				
				--Equal to Case
				if bool[p] == "=" then
					if Trophies[var[p]] == val[p] then
					else
						success = false;
					end
				end
				
				--Not Equal to Case
				if bool[p] == "~=" or bool[p] == "!=" then
					if Trophies[var[p]] ~= val[p] then
					else
						success = false;
					end
				end
				
				--Greater Than or Equal to Case
				if bool[p] == ">=" then
					if Trophies[var[p]] >= val[p] then
					else
						success = false;
					end
				end
				
				--Less Than or Equal to Case
				if bool[p] == "<=" then
					if Trophies[var[p]] <= val[p] then
					else
						success = false;
					end
				end
				
			end
			
			--If This Achievement is Achieved
			if success then
				Trophies.Ach[i]["Completed"] = true;
				Trophies.update("achievementsGained",1);
				
				--Show the Success
				print("Achieved: "..k[i]["Title"]);
				print("Total Achievements: "..Trophies.getValue("achievementsGained"));
				
				--Print All Achievements
				print("");
				for u = 1,Trophies.getValue("numOfAchievements") do
					local j = Trophies.Ach[u]["Completed"];
					if j then
						j = "True";
					else
						j = "False";
					end
					print(k[u]["Title"].." -- Completed: "..j);
				end
				
				--Play that Glorious Sound
				local trophy = audio.loadSound("../sound/Trophy.wav")
				local congrats = audio.play(trophy,{channel=2})
				
				--Make the Image
				img = display.newImage("../images/achievement_template.png");
				trophyText = display.newText(k[i]["Title"].."\n"..k[i]["Description"].."\nAchievement #: "..k[i]["ID"].."\n"..Trophies.getValue("achievementsGained").."/"..Trophies.getValue("numOfAchievements").." Achievements Completed",30,10,native.systemFont,14);
				
				img.x = display.contentWidth-100; img.y = 50;
				trophyText.x = img.x+30; trophyText.y = 50;
				
				timerStash.newTimer = timer.performWithDelay(4000,Trophies.destroyImage,1)
			end
		end
	end
	
	--print("Achievements Gained: "..Trophies.getValue("achievementsGained"));
end

Trophies.destroyImage = function()
	img:removeSelf();
	trophyText:removeSelf();
	img = nil;
	trophyText = nil;
end

return Trophies;