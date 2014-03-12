local undeadDifficultyMultiplier = 1

function GM:CalculateInitialDifficulty()
	local numUndead = team.NumPlayers(TEAM_UNDEAD)
	local numSurvivors = team.NumPlayers(TEAM_SURVIVORS)
	local numTotal = numUndead+numSurvivors
	
	local difficulty = 1

	difficulty = math.Round(math.Clamp(numSurvivors / numTotal, 0, 1),3)

	--Update global-ish
	undeadDifficultyMultiplier = difficulty
	
	--Debug
	--Debug("[DIRECTOR] Calculated initial difficulty: ".. tostring(difficulty))
		
	return undeadDifficultyMultiplier
end

function GM:GetUndeadDamageMultiplier()
	local multiplier = ((1 - undeadDifficultyMultiplier) * 3)

	Debug("[DIRECTOR] Undead difficulty: ".. tostring(multiplier))

	return multiplier
end


--> 1: Harder for Undeads
--< 1: Easier for Undeads
function GM:GetUndeadDifficulty()
	--Multiply to make it more realistic
	local difficulty = (undeadDifficultyMultiplier * 2)

	Debug("[DIRECTOR] Undead difficulty: ".. tostring(difficulty))

	return difficulty
end