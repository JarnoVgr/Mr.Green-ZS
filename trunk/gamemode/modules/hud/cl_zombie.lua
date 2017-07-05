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

	local textX, textY = ScaleW(40), ScrH() - ScaleH(50)

	--Health bar begin

	local barW, barH = ScaleW(220), ScaleH(40)
	local barX, barY = ScaleW(30), textY - (barH * 0.5)
	
	local healthPercentage, healthChanged = math.Clamp(healthPoints / maxHealthPoints, 0, 1), false
	if healthPercentage ~= healthPercentageDrawn then
		healthChanged = true
	end

	healthPercentageDrawn = math.Clamp(math.Approach(healthPercentageDrawn, healthPercentage, FrameTime() * 1.8), 0, 1) --Smooth

	--Determine health bar foreground color
	local fHealth, fMaxHealth = math.max(MySelf:Health(),0), MySelf:GetMaximumHealth()
	local percentage = math.Clamp((fHealth / fMaxHealth), 0.2, 1)
				
	--Different colors

	local red = 1 - percentage
	local healthFontColor = Color(250, 250, 250, 220)
	local healthBarColor = Color(255 * red, 255 * percentage, 30 * percentage, 100)
	local healthBarBGColor = Color(30 * red, 30 * percentage, 30 * percentage, 100)
	
	--Flash under certain conditions
	if MySelf:IsTakingDOT() or healthPercentageDrawn < 0.3 then
		healthBarColor = Color(healthBarColor.r, healthBarColor.g, healthBarColor.b, math.abs( math.sin( CurTime() * 4 ) ) * 255)
	end	

	surface.SetDrawColor(Color(0,0,0,60))
	surface.DrawRect(0, ScrH() - ScaleH(120), ScaleW(260), ScaleH(120))		
	
	--Background
	if healthPercentageDrawn ~= 1 then
		surface.SetDrawColor(healthBarBGColor)
		surface.DrawRect(barX, barY, barW, barH)
	end
	
	--Foreground
	surface.SetDrawColor(healthBarColor)
	surface.DrawRect(barX, barY, barW * healthPercentageDrawn, barH)
	
	draw.SimpleTextOutlined(healthPoints, "fontHuman12",textX, textY + ScaleH(2), healthFontColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,220))	
	
end
local requiredScore = 0
local spBarX = 0 + (ScrW()*0.13 * 0.5)
local spBarY = ScrH()/1.1
function hud.DrawBrains()
	
	requiredScore = REDEEM_KILLS
	if MySelf:HasBought("quickredemp") then
		requiredScore = REDEEM_FAST_KILLS
	end

	local spRatio = MySelf:GetScore() / requiredScore
	
	surface.SetDrawColor( 100, 100 , 100, 200 )
	surface.DrawOutlinedRect( spBarX, spBarY, ScrW()*0.13, ScrH()*0.01 )
	surface.SetDrawColor(0, 175, 205, 200 )
	surface.DrawRect( spBarX, spBarY, (ScrW()*0.13)*spRatio, ScrH()*0.01 )

	
	--draw.RoundedBox(0, spBarX, spBarY, ScrW()*0.13, ScrH()*0.08, Color(20, 26, 20, 150))
	
	surface.SetDrawColor(200, 200, 200, 200 )
	surface.DrawRect( spBarX, spBarY  - ScrH()*0.005, ScrW()*0.002, ScrH()*0.015 )
	surface.DrawRect( spBarX + ScrW()*0.13 - ScrW()*0.001, spBarY - ScrH()*0.005, ScrW()*0.002, ScrH()*0.015 )


	draw.SimpleText("Redemption", "HudHintTextLarge", spBarX + (ScrW()*0.13 * 0.5), spBarY * 0.985, Color( 255, 200, 200, 245 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	

	draw.SimpleText(MySelf:GetScore() .. " / " .. requiredScore, "HudHintTextSmall", spBarX + (ScrW()*0.13 * 0.5), spBarY * 1.005, Color( 255, 200, 200, 245 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		

	local textX, textValueY, textKeyY = ScaleW(15), ScaleH(900), ScaleH(900)
end