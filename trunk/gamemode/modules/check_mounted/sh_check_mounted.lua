AddCSLuaFile()
if CLIENT then
	local title = "Heads up! Counter-Strike Source content not missing"
	local messages = 
	{
		NotInstalled = [[It seems you do not have Counter-Strike Source installed
	which is recommended for the content in this game to display properly.]],
		NotMounted = [[It seems you do not have Counter-Strike Source mounted. You
	can mount it by hitting escape and pressing the button with a game controller icon
	in the bottom-right corner of your screen, then checking 'Counter-Strike' and 
	eventually restarting the game!]],
		NotBought = [[It seems you haven't bought Counter-Strike Source, 
	which is recommended for the content in this game to display properly.]]
	}

	---
	-- @description Display a notification regarding Counter-Strike Source
	--  content status to the user. This occurs just after the main 
	--  loading screen.
	-- 
	hook.Add("OnPlayerReadySQL", "CheckContentStatus", function()
		local game = engine.Games["Counter-Strike"]
		local message
		
		if not engine.IsGameBought(game) then
			message = messages.NotBought 
		elseif not engine.IsGameInstalled(game) then
			message = messages.NotInstalled    
		elseif not engine.IsGameMounted(game) then
			message = messages.NotMounted 
		end
		
		if message then
			Derma_Query(message, title, "Close")
		end
	end)
end