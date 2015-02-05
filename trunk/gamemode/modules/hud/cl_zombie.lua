--[==[----------------------------------------
		 Zombie HUD main
-----------------------------------------]==]
local zombieHealthIndication = {
	{
		Text = "Hungry as hell",
		Percent = 1
	}, {
		Text = "It's just pain..",
		Percent = 0.8
	}, {
		Text = "Not looking good..",
		Percent = 0.6
	}, {
		Text = "I want gibs",
		Percent = 0.45
	}, {
		Text = "I want gibs. NOW!",
		Percent = 0.4
	}, {
		Text = "Crawling in my skin...",
		Percent = 0.25
	}
}
table.SortByMember(zombieHealthIndication, "Percent", false)

--Textures needed
local matHealthSplash, matSplashTop = surface.GetTextureID("zombiesurvival/hud/splash_health"), surface.GetTextureID("zombiesurvival/hud/splash_top")

function hud.DrawZombieHUDImages()
	--Draw background
	surface.SetMaterial(hud.ZombieHudBackground) 
	surface.SetDrawColor(100, 0, 0, 260)
	surface.DrawTexturedRect(ScaleW(450), ScaleH(-140), ScaleW(360), ScaleH(290)) --Middle
	surface.DrawTexturedRect(ScaleW(650), ScaleH(-105), ScaleW(360), ScaleH(220)) --Right	
	surface.DrawTexturedRect(ScaleW(280), ScaleH(-105), ScaleW(360), ScaleH(220)) --Left
end

local healthPercentageDrawn, healthStatusText = 1, zombieHealthIndication[1].Text
local lastwarntim = -1
function hud.DrawZombieHUD()
	hud.DrawBrains()

	if MySelf:IsFreeSpectating() then
		return
	end

	local tw, th = surface.GetTextureSize(matHealthSplash)
	
	local x,y = 10, ScrH()-tw+190	

	surface.SetMaterial(hud.ZombieHudBackground) 
	surface.SetDrawColor(100, 0, 0, 260)
	surface.DrawTexturedRect(ScaleW(-133),ScaleH(880), ScaleW(475), ScaleH(300))

	local healthPoints, maxHealthPoints = math.max(MySelf:Health(),0), MySelf:GetMaximumHealth()
	local healthTextX , healthTextValueY, healthTextKeyY = ScaleW(40),ScaleH(975), ScaleH(1005)
	local barW, barH = ScaleW(190), ScaleH(35)
	local barX, barY = healthTextX + ScaleW(30), ScaleH(880)+ScaleH(90)
	local healthPercentage, healthChanged = math.Clamp(healthPoints / maxHealthPoints, 0, 1), false
		
	if healthPercentage ~= healthPercentageDrawn then
		healthChanged = true
	end

	healthPercentageDrawn = math.Clamp(math.Approach(healthPercentageDrawn, healthPercentage, FrameTime() * 1.8), 0, 1) --Smooth

	--Determine health bar foreground color
	local healthBarColor = Color(137, 30, 30, 255)
	if MySelf:IsTakingDOT() or healthPercentageDrawn < 0.3 then
		healthBarColor = Color(healthBarColor.r, healthBarColor.g, healthBarColor.b, math.abs( math.sin( CurTime() * 4 ) ) * 255 )
	end

	--Background
	if healthPercentageDrawn ~= 1 then
		surface.SetDrawColor(70, 20, 20, 255)
		surface.DrawRect(barX, barY, barW, barH)
	end

	--Foreground
	surface.SetDrawColor(healthBarColor)
	surface.DrawRect(barX, barY, barW * healthPercentageDrawn, barH)

	--Only update text if health changed
	if healthChanged then
		for k, v in ipairs(zombieHealthIndication) do
			if healthPercentage >= v.Percent then
				healthStatusText = v.Text
				break
			end
		end
	end
		
	--Draw health status text
	draw.SimpleText(healthStatusText, "NewZombieFont7", barX+(barW/2), barY+(barH/2), Color(250,250,250,170), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)	
	draw.SimpleText(healthPoints, "NewZombieFont23", healthTextX, healthTextValueY, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText("HP", "NewZombieFont15", healthTextX, healthTextKeyY, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)		
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

	--Background
	surface.SetMaterial(hud.ZombieHudBackground) 
	surface.SetDrawColor(100, 0, 0, 260)
	surface.DrawTexturedRect(ScaleW(-50), ScaleH(740), ScaleW(160), ScaleH(130))

	local textX, textValueY, textKeyY = ScaleW(40), ScaleH(795), ScaleH(825)
	draw.SimpleText(currentScore .." of ".. requiredScore, "NewZombieFont17", textX, textValueY, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText("BRAINS", "NewZombieFont15", textX, textKeyY, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end