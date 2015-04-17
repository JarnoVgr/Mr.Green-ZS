-- Server related news
local GeneralInfo = {
	"New to the Server? Press F1 and click on Beginners' Guide.",
	"In need of GreenCoins? Visit MrGreenGaming.com for more info.",
	"Our forums can be found on MrGreenGaming.com",
	"Support the server by paying for GreenCoins. Visit MrGreenGaming.com for more info.",
	"Addicted to the chat? On our website you can chat with the players ingame.",
	"Press F4 to change some advanced gameplay options.",
	"We highly appreciate your feedback. Let us know what you think about our server.",
	"Don't hesitate to ask in the chat if you need something to be cleared up for you."
}
GeneralInfo = table.Shuffle(GeneralInfo)


-- Human related hints
local HumanHints = {
	"Press E on Supply Crates to get weapons, ammo and health.",
	"In need of new weaponry? Kill the Zombies and find a Supply Crate.",
	-- "To see what Weapons you can get, press F2 to see your classes weapon tree!",
	"SP stands for SkillPoints which you earn by killing Zombies.",
	"Press F3 to drop your current weapon."
}
HumanHints = table.Shuffle(HumanHints)

-- Undead related hints
local UndeadHints = {
	"Press F3 to open the Zombie Species menu. More classes will unlock as Humans die.",
	"Kill multiple Humans to become one of them again.",
	"Zombie Bosses spawn every now and then to give the Undead power.",
	"As more time goes on the more zombie classes unlock!",

}
UndeadHints = table.Shuffle(UndeadHints)


--[==[---------------------------------------------------------
       Used to send server news/info to players
---------------------------------------------------------]==]
local sIndex = 1
local function DisplayNews()
	chat.AddText(Color(0, 160, 255), "[INFO] ", Color(213, 213, 213), GeneralInfo[sIndex])
	
	sIndex = sIndex + 1
	if sIndex > #GeneralInfo then
		sIndex = 1
	end
end
timer.Create("DisplayNews", 80, 0, DisplayNews)

--[==[---------------------------------------------------------
       Used to send human/undead hints to players
---------------------------------------------------------]==]
local HumanIndex, ZombieIndex = 1, 1
local function DisplayHints()
	local pl = LocalPlayer()
	if not IsValid(pl) then
		return
	end

	local Team = pl:Team()
	
	if Team == TEAM_HUMAN then
		chat.AddText(Color(0, 160, 255), "[HINT] ", Color(213, 213, 213), HumanHints[HumanIndex] )

		HumanIndex = HumanIndex + 1
		if HumanIndex > #HumanHints then
			HumanIndex = 1
		end
	elseif Team == TEAM_UNDEAD then
		chat.AddText(Color(0, 255, 0), "[HINT] ", Color(213, 213, 213), UndeadHints[ZombieIndex])

		ZombieIndex = ZombieIndex + 1
		if ZombieIndex > #UndeadHints then
			ZombieIndex = 1
		end
	end
end
timer.Create("DisplayHints", 140, 0, DisplayHints)