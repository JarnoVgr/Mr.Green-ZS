--[==[----------------------------------------
		 Zombie HUD main
-----------------------------------------]==]
local zombieHealthIndication  = {
	{Text = "hungry as hell",Percent = 1},
	{ Text = "walk it off", Percent = 0.9 },
	{ Text = "couple of bullet holes", Percent = 0.75 },
	{ Text = "missing a limb", Percent = 0.6 },
	{ Text = "organs are hanging out", Percent = 0.45 },
	{ Text = "falling apart", Percent = 0.25 },
	{ Text = "sack of flesh", Percent = 0.1 }	
	}
table.SortByMember(zombieHealthIndication, "Percent", false)

--Textures needed
local matHealthSplash, matSplashTop = surface.GetTextureID("zombiesurvival/hud/splash_health"), surface.GetTextureID("zombiesurvival/hud/splash_top")

function hud.DrawZombieHUDImages()
	--Draw background
	--surface.SetMaterial(hud.ZombieHudBackground) 
	--surface.SetDrawColor(100, 0, 0, 260)
	--surface.DrawTexturedRect(ScaleW(450), ScaleH(-140), ScaleW(360), ScaleH(290)) --Middle
	--surface.DrawTexturedRect(ScaleW(650), ScaleH(-105), ScaleW(360), ScaleH(220)) --Right	
	--surface.DrawTexturedRect(ScaleW(280), ScaleH(-105), ScaleW(360), ScaleH(220)) --Left
end

local healthPercentageDrawn, healthStatusText = 1, zombieHealthIndication[1].Text
local lastwarntim = -1
function hud.DrawZombieHUD()
	hud.DrawBrains()

	if MySelf:IsFreeSpectating() then
		return
	end

	local healthPoints, maxHealthPoints = math.max(MySelf:Health(),0), MySelf:GetMaximumHealth()

	local startX = (ScrW()/2)

	local textX, textValueY, textKeyY = ScaleW(40), ScaleH(860), ScaleH(890)

	--Health bar begin

	--local barW, barH = ScaleW(210), ScaleH(20)
	--local barX, barY = healthTextX + ScaleW(35), ScaleH(880)+ScaleH(110)
	
	local healthPercentage, healthChanged = math.Clamp(healthPoints / maxHealthPoints, 0, 1), false
	if healthPercentage ~= healthPercentageDrawn then
		healthChanged = true
	end

	healthPercentageDrawn = math.Clamp(math.Approach(healthPercentageDrawn, healthPercentage, FrameTime() * 1.8), 0, 1) --Smooth

	--Determine health bar foreground color
	local fHealth, fMaxHealth = math.max(MySelf:Health(),0), MySelf:GetMaximumHealth()
	local iPercentage = math.Clamp(fHealth / fMaxHealth, 0, 1)
	local healthBarColor = Color(154, 30, 30, 255)
	--local healthBarBGColor = Color(70, 20, 20, 255)
	
	--Different colors
	if iPercentage > 0.65 then
		healthBarColor = Color(24, 170, 30, 225)
	--	healthBarBGColor = Color(52, 68, 15, 225)
	elseif iPercentage > 0.3 then
		healthBarColor = Color(190, 116, 24, 225)
		--healthBarBGColor = Color(86, 73, 15, 225)
	end
	
	--Flash under certain conditions
	if MySelf:IsTakingDOT() or healthPercentageDrawn < 0.3 then
		healthBarColor = Color(healthBarColor.r, healthBarColor.g, healthBarColor.b, math.abs( math.sin( CurTime() * 4 ) ) * 255)
	end	

	--Draw health points text
	local healthTextX , healthTextValueY, healthTextKeyY = ScaleW(40),ScaleH(975), ScaleH(1200)
	draw.SimpleTextOutlined("+", "hpFont",startX - ScrW()/2 + ScrW()/80, ScrH()/1.03, healthBarColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))	
	draw.SimpleTextOutlined(healthPoints, "ssNewAmmoFont24",startX - ScrW()/2 + ScrW()/45, ScrH()/1.03, healthBarColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
	
	
end

function hud.DrawBrains()
	--Calculate amount of brains required
	local requiredScore = REDEEM_KILLS
	if MySelf:HasBought("quickredemp") or MySelf:GetRank() < REDEEM_FAST_LEVEL then
		requiredScore = REDEEM_FAST_KILLS
	end

	--Divide by 2
	requiredScore = math.ceil(requiredScore / 2)

	local currentScore = math.max(0, math.ceil(MySelf:GetScore() / 2))


	local textX, textValueY, textKeyY = ScaleW(15), ScaleH(900), ScaleH(900)
end