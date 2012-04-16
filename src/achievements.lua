--The Achievements

--Format:
--{Achievement ID, Title, Description, Completed?, Variable, Boolean, Value}
local img;
local trophyText;
Trophies = {
	off = false, --Set to True if you Don't Want Achievements On
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
	numOfAchievements = 16, --Update This Number When You Add an Achievements
	currentlyAchieving = false, --Is the Thing Showing the Achievements?
	
	--Bool Can be > < = ~= >= <=
	
	Ach = {
		[1] = {ID = 001, Title = "Saving Grace", Description = "Save a Structure to a File", Completed = false, Arg = {"savedStructures"}, Bool = {">"}, Value = {0}},
		[2] = {ID = 002, Title = "A Load Off my Back", Description = "Load a Saved Structure", Completed = false, Arg = {"loadedStructures"}, Bool = {">"}, Value = {0}},
		[3] = {ID = 003, Title = "One Down", Description = "Win a Level in Single Player", Completed = false, Arg = {"levelsCompleted"}, Bool = {">"}, Value = {0}},
		[4] = {ID = 004, Title = "Self-Storage", Description = "Use All Ten Save Slots", Completed = false, Arg = {"slotsUsed"}, Bool = {"="}, Value = {10}},
		[5] = {ID = 005, Title = "It's Over 9000!", Description = "Get Over 9000 Points in Total Score", Completed = false, Arg = {"totalScore"}, Bool = {">"}, Value = {9000}},
		[6] = {ID = 006, Title = "Shopaholic", Description = "Buy Over 100 Objects", Completed = false, Arg = {"objectsBought"}, Bool = {">="}, Value = {100}},
		[7] = {ID = 007, Title = "Weapons Surplus", Description = "Buy 10 Weapons", Completed = false, Arg = {"weaponsBought"}, Bool = {">="}, Value = {10}},
		[8] = {ID = 008, Title = "Construction Site", Description = "Buy 10 Materials", Completed = false, Arg = {"materialsBought"}, Bool = {">="}, Value = {10}},
		[9] = {ID = 009, Title = "Spending Maniac", Description = "Spend Over $200000", Completed = false, Arg = {"totalSpent"}, Bool = {">="}, Value = {200000}},
		[10] = {ID = 010, Title = "Pacifist", Description = "Destroy 100 Enemy Weapons", Completed = false, Arg = {"weaponsDestroyed"}, Bool = {">="}, Value = {100}},
		[11] = {ID = 011, Title = "Demolitions", Description = "Destroy 200 Enemy Materials", Completed = false, Arg = {"materialsDestroyed"}, Bool = {">="}, Value = {200}},
		[12] = {ID = 012, Title = "Dominator", Description = "Destroy Over 500 Enemy Materials", Completed = false, Arg = {"destroyedObjects"}, Bool = {">="}, Value = {500}},
		[13] = {ID = 013, Title = "Cheapskate", Description = "Keep 95% of Your Funds After Build Phase", Completed = false, Arg = {"maxPercentageofMoneyKept"}, Bool = {">="}, Value = {95}},
		[14] = {ID = 014, Title = "A Winner is You!", Description = "Win 25 Battles", Completed = false, Arg = {"wins"}, Bool = {">="}, Value = {25}},
		[15] = {ID = 015, Title = "An Achievement Achievement?", Description = "Achieve 7 Achievements", Completed = false, Arg = {"achievementsGained"}, Bool = {">="}, Value = {7}},
		[16] = {ID = 016, Title = "One Hit Wonder", Description = "Win a Battle in One Turn", Completed = false, Arg = {"shortestNumofTurns"}, Bool = {"="}, Value = {1}}
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

	if Trophies["off"] == false then
	
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
				if success and Trophies["currentlyAchieving"] == false then
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
					trophyText = display.newText(k[i]["Title"].."\n"..k[i]["Description"].."\nAchievement #: "..k[i]["ID"].."\n"..Trophies.getValue("achievementsGained").."/"..Trophies.getValue("numOfAchievements").." Completed",30,10,150,90,native.systemFont,12);

					img:toFront(); trophyText:toFront();
					img.x = display.contentWidth-100; img.y = 50;
					trophyText.x = img.x+30; trophyText.y = 55;
					
					timerStash.newTimer = timer.performWithDelay(4000,Trophies.destroyImage,1)
					Trophies["currentlyAchieving"] = true;
				end
			end
		end
		
		--print("Achievements Gained: "..Trophies.getValue("achievementsGained"));
		
	end
end

Trophies.destroyImage = function()
	img:removeSelf();
	trophyText:removeSelf();
	img = nil;
	trophyText = nil;
	Trophies["currentlyAchieving"] = false;
end

return Trophies;