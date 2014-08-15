

local TEAM_DIFFERENCE, GENERAL_TIMER, TEAM_TIMER = 60, 30, 40 

-- Server related news
local GENERAL_NEWS = {
"New to the Server? Press F1 and click on Beginners' Guide!",
"In need of GreenCoins? Visit MrGreenGaming.com",
"Our forums can be found on MrGreenGaming.com",
"Support the server by paying for GreenCoins. Visit MrGreenGaming.com for more info."
}

-- Human related hints
local HUMAN_HINTS = {
"Press E on Supply Crates to get weapons, ammo and health.",
"In need of new weaponry? Kill zombies and find a Supply Crate!",
-- "To see what Weapons you can get, press F2 to see your classes weapon tree!",
"SP means SkillPoints, you can get them by killing zombies!",
"Press F3 to drop your current weapon."
}

-- Undead related hints
local UNDEAD_HINTS = {
"Press F3 to open the Classes Menu. More classes will unlock as humans die.",
"Kill 4 humans to become human again."
}


--[==[---------------------------------------------------------
       Used to send server news/info to players
---------------------------------------------------------]==]
local sIndex = 1
local function DisplayNews()
	-- for k, v in pairs( player.GetAll() ) do
	-- 	v:CustomChatPrint( nil, Color(78,255,0),"[INFO] ", Color(255,255,255),GENERAL_NEWS[sIndex] )
	-- end
	GAMEMODE:HintMessage(5, {"<font=ssNewAmmoFont6.5><color=78,255,0,255>INFO: </color><color=255,255,255,255>"..GENERAL_NEWS[sIndex].."</color></font>"})
	
	sIndex = sIndex + 1
	if sIndex > #GENERAL_NEWS then
		sIndex = 1
	end
	
	-- cooldown
	GENERAL_TIMER = CurTime() + TEAM_DIFFERENCE
end

--[==[---------------------------------------------------------
       Used to send human/undead hints to players
---------------------------------------------------------]==]
local HumanIndex, ZombieIndex = 1, 1
local function DisplayHints()

	-- Send the message to coresponding teams.
	--[=[for k, v in pairs( player.GetAll() ) do
		if v:Team() == TEAM_HUMAN then
			if HUMAN_HINTS[HumanIndex] == nil then HumanIndex = 1 end
			v:CustomChatPrint( nil, Color(0, 160, 255),"[HINT] ", Color(213, 213, 213) ,HUMAN_HINTS[HumanIndex] )
		end
		
		if v:Team() == TEAM_UNDEAD then
			if UNDEAD_HINTS[ZombieIndex] == nil then ZombieIndex = 1 end
			v:CustomChatPrint( nil, Color(0, 255, 0),"[HINT] ", Color(213, 213, 213) ,UNDEAD_HINTS[ZombieIndex] )
		end
	end]=]
	
	if LocalPlayer():Team() == TEAM_HUMAN or LocalPlayer():Team() == TEAM_SPECTATOR then
		GAMEMODE:HintMessage(5, {"<font=ssNewAmmoFont6.5><color=0,160,255,255>HINT: </color><color=213,213,213,255>"..HUMAN_HINTS[HumanIndex].."</color></font>"})
		HumanIndex = HumanIndex + 1
	end
	
	if LocalPlayer() == TEAM_UNDEAD then
		GAMEMODE:HintMessage(5, {"<font=ssNewAmmoFont6.5><color=0,255,0,255>HINT: </color><color=213,213,213,255>"..UNDEAD_HINTS[ZombieIndex].."</color></font>"})
		ZombieIndex = ZombieIndex + 1
	end
	
	
	
	-- increment table hint slots for both teams
	
	
	
	-- Reset human hints
	if HumanIndex > #HUMAN_HINTS then
		HumanIndex = 1
	end
	
	-- Reset undead hints
	if ZombieIndex > #UNDEAD_HINTS then
		ZombieIndex = 1
	end
	
	-- cooldown
	TEAM_TIMER = CurTime() + TEAM_DIFFERENCE
end

--[==[---------------------------------------------------------
            Manages when and what to display
---------------------------------------------------------]==]
local function HintsThink()
	-- manage server info
	--if GENERAL_TIMER <= CurTime() then
		DisplayNews()
	--end
	
	-- manage team hints
	--if TEAM_TIMER <= CurTime() then
		DisplayHints()
	--end
end
--hook.Add ( "Think", "HintsThink", HintsThink )
timer.Create("HintsThink", 60, 0, HintsThink)