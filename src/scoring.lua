--Scoring System

score = {
	CurrentScore = 0
}

--Get the Current Score
score.getScore = function()
	return score.CurrentScore;
end

--Set the Score to a Certain Value
score.setScore = function(s)
	score.CurrentScore = score;
end

--Add (or Subtract) from the Score
score.addtoScore = function(s)
	score.CurrentScore = score.CurrentScore + s;
end

return score;