-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

--Function table
hud = {}

include("cl_human.lua")
include("cl_human_friends.lua")
include("cl_zombie.lua")

local nextLevelKeySwitch, currentLevelKey = RealTime()+10, 0

--hud.HumanElementBackground = Material("mrgreen/hud/hudbackground.png")
--hud.HumanTopBackground = Material("mrgreen/hud/hud_background_top_h.png")
--hud.ZombieTopBackground = Material("mrgreen/hud/hud_background_top_z.png")
--hud.HumanHudBackground = Material("mrgreen/hud/hudbackgroundnew.png")
--hud.ZombieHudBackground = Material("mrgreen/hud/hudbackgroundnew_zombie.png")

local PlrData = {
	GreenCoins = 0,
	Rank = 1,
	NextRankPerc = 0,
	XPRequired = 0,
	XPCurrent = 0
}
local NextPlrDataCache = 0
local function RecachePlayerData()
	--5 seconds till next cache
	NextPlrDataCache = RealTime() + 5

	local RequiredXP = MySelf:NextRankXP()
	local CurrentXP = MySelf:GetXP()
	
	
	PlrData = {
		GreenCoins = MySelf:GreenCoins(),
		Rank = MySelf:GetRank(),
		NextRankPerc = math.Round((CurrentXP / RequiredXP) * 100),
		XPRequired = RequiredXP,
		XPCurrent = CurrentXP

	}
end

--[==[----------------------------------------
	 Initialize fonts we need
-----------------------------------------]==]
function hud.InitFonts()
	-- Health indication font
	surface.CreateFontLegacy( "Arial", ScreenScale( 7.6 ), 700, true, true, "HUDBetaHealth" ) -- 14.6
	
	-- Level font
	surface.CreateFontLegacy( "Arial", ScreenScale( 7.6 ), 700, true, true, "HUDBetaLevel" ) -- 14.6
	
	-- Level font 4:3
	surface.CreateFontLegacy( "Arial", ScreenScale( 7.3 ), 700, true, true, "HUDBetaLevelNormal" ) -- 14.6
	
	-- Kills icon font
	surface.CreateFontLegacy( "Arial", ScreenScale( 21.6 ), 700, true, true, "HUDBetaKills" ) -- 44.6

	
	-- Ammo regen icon font
	surface.CreateFontLegacy( "csd", ScreenScale( 17.6 ), 700, true, true, "HUDBetaAmmo" ) -- 36/6
	
	-- Kills and regen text font
	surface.CreateFontLegacy( "Arial", ScreenScale( 11 ), 700, true, true, "HUDBetaStats" ) -- 16

	-- Small level showout
	surface.CreateFontLegacy( "Arial", ScreenScale( 7 ), 700, true, true, "HUDBetaCorner" ) -- 14
 -- ssNewAmmoFont13 ssNewAmmoFont5 HUDBetaZombieCount HUDBetaKills HUDBetaHeader
	-- How much to survive font
	surface.CreateFontLegacy( "Arial", ScreenScale( 15 ), 700, true, true, "HUDBetaHeader" )
	-- Zombie count
	surface.CreateFontLegacy( "Arial", ScreenScale( 25 ), 700, true, true, "HUDBetaZombieCount" )

	-- Infliction percentage font
	surface.CreateFontLegacy( "Arial", ScreenScale( 10 ), 700, true, true, "HUDBetaInfliction" )

	-- Right upper box text font
	surface.CreateFontLegacy( "Arial", ScreenScale( 9.6 ), 700, true, true, "HUDBetaRightBox" )

	surface.CreateFontLegacy( "Future Rot", ScreenScale( 5.5 ), 700, true, false, "ssNewAmmoFont5" )
	surface.CreateFontLegacy( "Future Rot", ScreenScale( 6.5 ), 700, true, false, "ssNewAmmoFont7" )
	surface.CreateFontLegacy( "Future Rot", ScreenScale( 7.5 ), 700, true, false, "ssNewAmmoFont6.5" )
	surface.CreateFontLegacy( "Future Rot", ScreenScale( 8.5 ), 700, true, false, "ssNewAmmoFont9" )
	surface.CreateFontLegacy( "Future Rot", ScreenScale( 10.5 ), 700, true, false, "ssNewAmmoFont13" )
	surface.CreateFontLegacy( "Future Rot", ScreenScale( 11.5 ), 700, true, false, "ssNewAmmoFont20" )		
	surface.CreateFontLegacy( "Future Rot", ScreenScale( 12 ), 700, true, false, "ssNewAmmoFont24" )		
	surface.CreateFontLegacy( "Arial", ScreenScale( 7 ), 700, true, false, "xpFont" )	
	surface.CreateFontLegacy( "Arial", ScreenScale( 12 ), 700, true, false, "hpFont" )		
	
	--Undead HUD font
	surface.CreateFontLegacy("Face Your Fears", ScreenScale(8), 700, true, false, "NewZombieFont7",false, true)
	surface.CreateFontLegacy("Face Your Fears", ScreenScale(9), 700, true, false, "NewZombieFont10",false, true)
	surface.CreateFontLegacy("Face Your Fears", ScreenScale(12), 700, true, false, "NewZombieFont13",false, true)
	surface.CreateFontLegacy("Face Your Fears", ScreenScale(13), 700, true, false, "NewZombieFont14",false, true)
	surface.CreateFontLegacy("Face Your Fears", ScreenScale(14), 700, true, false, "NewZombieFont15",false, true)
	surface.CreateFontLegacy("Face Your Fears", ScreenScale(15), 700, true, false, "NewZombieFont17",false, true)
	surface.CreateFontLegacy("Face Your Fears", ScreenScale(18), 700, true, false, "NewZombieFont19",false, true)
	surface.CreateFontLegacy("Face Your Fears", ScreenScale(22), 700, true, false, "NewZombieFont23",false, true)
	surface.CreateFontLegacy("Face Your Fears", ScreenScale(26), 700, true, false, "NewZombieFont27",false, true)
	surface.CreateFontLegacy("Face Your Fears", ScreenScale(34), 700, true, false, "NewZombieFont35",false, true)
end
hook.Add("Initialize", "hud.InitFonts", hud.InitFonts)

local matDangerSign = surface.GetTextureID ( "zombiesurvival/hud/danger_sign" )

hud.BossBackground = surface.GetTextureID ( "zombiesurvival/hud/splash_top" )
hud.texGradDown = surface.GetTextureID("VGUI/gradient_down")
function hud.DrawBossHealth()
	if not GAMEMODE:IsBossAlive() then
		return
	end

	local Boss = GAMEMODE:GetBossZombie()
	if not IsValid(Boss) then
		return
	end

	local BW,BH = ScaleW(440), ScaleW(440)
	local BX,BY = w/2-BW/2, 20
	
	local BarW,BarH = BW*0.75, ScaleH(36)
	local BarX,BarY = w/2-BarW/2, ScaleH(120)
	
	surface.SetDrawColor( 0, 0, 0, 150)
	surface.DrawRect(BarX,BarY,BarW,BarH)
	surface.DrawRect(BarX+5, BarY+5, BarW-10, BarH-10)
	
	surface.SetDrawColor(125,29,21,255)
	
	local health = Boss:Health() or 0
		
	local TX,TY = BarX+BarW/5,BarY
	local str = (ZombieClasses[Boss:GetZombieClass()].Name or Boss:Name())
	local EndTime = GAMEMODE:GetBossEndTime()
	if CurTime() <= EndTime then
		local timeLeft = EndTime - CurTime()
		str = str .." - ".. ToMinutesSeconds(timeLeft)
	end
	draw.SimpleText(str, "NewZombieFont27", ScrW()/2,TY, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		
	local dif = math.Clamp(health / Boss:GetMaximumHealth(),0,1)
		
	surface.SetTexture(hud.texGradDown)
	surface.DrawTexturedRect(BarX+5, BarY+5, (BarW-10)*dif, BarH-10 )
end

local function DrawRoundTime(DescriptionFont, ValueFont)
	--Initialize variables
	local startX, keyStartY, valueStartY = ScrW()/2, ScaleH(20), ScaleH(50)
	local timeLeft, valueColor = 0, Color(255,255,255,255)

	local keyText
	if MySelf:IsZombie() then
		keyText = "ROUND TIME"
		
	else
		keyText = "EVACUATION TIME"
	end

	
	local requiredScore = REDEEM_KILLS
	if MySelf:HasBought("quickredemp") or MySelf:GetRank() < REDEEM_FAST_LEVEL then
		requiredScore = REDEEM_FAST_KILLS
	end

	--Divide by 2
	requiredScore = math.ceil(requiredScore / 2)

	local currentScore = math.max(0, math.ceil(MySelf:GetScore() / 2))
	
	
	
	--Preparation (warmup)
	if CurTime() <= WARMUPTIME then
		keyText = "PREPARATION TIME"
		--if MySelf:IsHuman() then --Make it Obvious that the closer you are the greater the chance!
		--	draw.SimpleText("Get close to the Undead spawn to be sacrificed", "ssNewAmmoFont5", startX, keyStartY+100, Color(255,90,90,210), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		--end
		timeLeft = math.max(0, WARMUPTIME - CurTime())

		if timeLeft < 10 then
			local glow = math.sin(CurTime() * 8) * 200 + 255

			valueColor.g, valueColor.b = glow, glow

			if lastwarntim ~= math.ceil(timeLeft) then
				lastwarntim = math.ceil(timeLeft)
				if 0 < lastwarntim then
					surface.PlaySound(Sound("mrgreen/ui/menu_countdown.wav"))
				end
			end
		end
	else
		timeLeft = math.max(0, ROUNDTIME - CurTime())
	end
	
	if MySelf:IsZombie() then
			draw.SimpleTextOutlined("GOAL", "NewZombieFont15", startX - ScrW()/2 + ScrW()/80, keyStartY, Color(255,255,255,150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))			
		if requiredScore - currentScore == 1 then
			draw.SimpleTextOutlined("Eat " .. requiredScore - currentScore .. " brain in " .. ToMinutesSeconds(timeLeft + 1), "NewZombieFont13", startX - ScrW()/2 + ScrW()/80, valueStartY, Color(255,255,255,150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))			
		else
		
			draw.SimpleTextOutlined("Eat " .. requiredScore - currentScore .. " brains in " .. ToMinutesSeconds(timeLeft + 1), "NewZombieFont13", startX - ScrW()/2 + ScrW()/80, valueStartY, Color(255,255,255,150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))	
		end
	else
	
		draw.SimpleTextOutlined(keyText, DescriptionFont, startX - ScrW()/2 + ScrW()/80, keyStartY, Color(255,255,255,150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
		draw.SimpleTextOutlined(ToMinutesSeconds(timeLeft + 1), ValueFont, startX - ScrW()/2 + ScrW()/80, valueStartY, Color(255,255,255,150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))	
	end
	--Draw time

end

local NextTeamRefresh, CachedHumans, CachedZombies = 0, 0, 0
function hud.DrawStats()
	--Recache team counts
	if RealTime() > NextTeamRefresh then
		CachedHumans = team.NumPlayers(TEAM_HUMAN)
		CachedZombies = team.NumPlayers(TEAM_UNDEAD)
		NextTeamRefresh = RealTime() + 1
	end

	--Define vars depending on team
	local TeamColor, DescriptionFont, ValueFont, ValueBigFont
	if MySelf:IsZombie() then
		TeamColor = Color(255, 0, 0, 170)
		DescriptionFont = "NewZombieFont13"
		ValueFont = "NewZombieFont13"
		ValueBigFont = "HUDBetaZombieCount"
	else
		DescriptionFont = "ssNewAmmoFont5"
		ValueFont = "ssNewAmmoFont9"
		ValueBigFont = "HUDBetaZombieCount"
	end

	--Define Y-axis positions of keys and values
	local startX, keyStartY, valueStartY = ScrW()/2, ScaleH(20), ScaleH(50)

	--Draw Survivor team count

	draw.SimpleTextOutlined("INFLICTION: ", DescriptionFont, startX - ScrW()/2 + ScrW()/80, ScaleH(90), Color(255,255,255,150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
	draw.SimpleTextOutlined(CachedHumans, DescriptionFont, ScaleW(100),  ScaleH(90), Color(120,120,230,150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
	draw.SimpleTextOutlined("i", DescriptionFont,  ScaleW(120),  ScaleH(90), Color(255,255,255,150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
	draw.SimpleTextOutlined(CachedZombies, DescriptionFont, ScaleW(130),  ScaleH(90), Color(230,120,120,150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))

	--Handle level key switching for current level and level completion percentage
	if nextLevelKeySwitch <= RealTime() then
		if currentLevelKey == 2 then
			currentLevelKey = 0
		else
			currentLevelKey = currentLevelKey+ 1
		end
		nextLevelKeySwitch = RealTime()+10		
	end

	if currentLevelKey == 0 then
		draw.SimpleTextOutlined("Next level: " .. PlrData.NextRankPerc, DescriptionFont, startX - ScrW()/2 + ScrW()/80, ScaleH(120), Color(255,255,255,130), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))	
		if PlrData.NextRankPerc >= 10 then
			draw.SimpleTextOutlined("%", "xpFont", startX - ScrW()/2 + ScrW()/10, ScaleH(119), Color(255,255,255,130), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))	
			draw.SimpleTextOutlined("("..PlrData.XPRequired - PlrData.XPCurrent .. " XP left)" , DescriptionFont, startX - ScrW()/2 + ScrW()/9, ScaleH(120), Color(255,255,255,130), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))				
		else
			draw.SimpleTextOutlined("%", "xpFont", startX - ScrW()/2 + ScrW()/11, ScaleH(119), Color(255,255,255,130), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))		
			draw.SimpleTextOutlined("("..PlrData.XPRequired - PlrData.XPCurrent .. " XP left)" , DescriptionFont, startX - ScrW()/2 + ScrW()/9.5, ScaleH(120), Color(255,255,255,130), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))							
		end
		-- 'Next Level: 50% (5000 XP left)'

	elseif currentLevelKey == 1 then
		draw.SimpleTextOutlined("GREENCOINS: "..PlrData.GreenCoins, DescriptionFont, startX - ScrW()/2 + ScrW()/80, ScaleH(120), Color(200,240,200,100), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))		
	elseif currentLevelKey == 2 then
		draw.SimpleTextOutlined("LEVEL: " ..PlrData.Rank, DescriptionFont, startX - ScrW()/2 + ScrW()/80, ScaleH(120), Color(255,255,255,130), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))		
	end

	local TopText, ValueText
	--Draw round time
	DrawRoundTime(DescriptionFont, ValueFont)
end

local function DrawHUD()
	if not IsValid(MySelf) or ENDROUND or not MySelf.ReadySQL or not MySelf:Alive() or IsClassesMenuOpen() or util.tobool(GetConVarNumber("zs_hidehud")) then
		return
	end

	--Cache
	if RealTime() >= NextPlrDataCache then
		RecachePlayerData()
	end

	--Pick HUD to display depending on team
	if MySelf:IsHuman() then
		hud.DrawStats()
		hud.DrawHumanHUD()
	elseif MySelf:IsZombie() then
		hud.DrawStats()
		hud.DrawZombieHUD()
	end

	--hud.DrawBossHealth()
end
hook.Add("HUDPaint", "hud.DrawHUD", DrawHUD)