--[==[----------------------------------------
		 Zombie HUD main
-----------------------------------------]==]
local zombieHealthIndication  = {
	{Text = "hungry as hell",Percent = 1},
	{ Text = "walk it off", Percent = 0.9 },
	{ Text = "couple of bullet holes", Percent = 0.75 },
	{ Text = "you're missing a limb", Percent = 0.6 },
	{ Text = "your organs are hanging out", Percent = 0.45 },
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

	local tw, th = surface.GetTextureSize(matHealthSplash)
	
	local x,y = 10, ScrH()-tw+190	

	--surface.SetMaterial(hud.ZombieHudBackground) 
	--surface.SetDrawColor(100, 0, 0, 260)
	--surface.DrawTexturedRect(ScaleW(-133),ScaleH(880), ScaleW(475), ScaleH(300))

	local healthPoints, maxHealthPoints = math.max(MySelf:Health(),0), MySelf:GetMaximumHealth()
	local healthTextX , healthTextValueY, healthTextKeyY = ScaleW(40),ScaleH(975), ScaleH(1005)
	local barW, barH = ScaleW(210), ScaleH(20)
	local barX, barY = healthTextX + ScaleW(30), ScaleH(880)+ScaleH(110)
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
		local startX = (ScrW()/2)	
	local healthTextX , healthTextValueY, healthTextKeyY = ScaleW(40),ScaleH(975), ScaleH(1200)
	--draw.SimpleText(healthPoints, "ssNewAmmoFont13",startX - ScrW()/2 + ScrW()/80, ScrH()/1.03, Color(255,255,255,170), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)		
		
	--Draw health status text
	local healthTextX , healthTextValueY, healthTextKeyY = ScaleW(40),ScaleH(975), ScaleH(1200)
	draw.SimpleTextOutlined("+", "hpFont",startX - ScrW()/2 + ScrW()/80, ScrH()/1.03, Color(255,255,255,170), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))	
	draw.SimpleTextOutlined(healthPoints, "ssNewAmmoFont13",startX - ScrW()/2 + ScrW()/45, ScrH()/1.03, Color(255,255,255,170), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
	draw.SimpleTextOutlined(healthStatusText, "ssNewAmmoFont5", barX+(barW/2), barY+(barH/2), Color(250,250,250,170), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))	
	--draw.SimpleText("HP", "NewZombieFont15", healthTextX, healthTextKeyY, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)		
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
	--surface.SetMaterial(hud.ZombieHudBackground) 
	--surface.SetDrawColor(100, 0, 0, 260)
	--surface.DrawTexturedRect(ScaleW(-50), ScaleH(740), ScaleW(160), ScaleH(130))

	local textX, textValueY, textKeyY = ScaleW(15), ScaleH(900), ScaleH(900)
	
	
	--if requiredScore - currentScore == 1 then
	--	draw.SimpleText("Eat " .. requiredScore - currentScore .. " brain", "NewZombieFont13", textX, textValueY, Color(255,255,255,170), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)	
	--else
	--	draw.SimpleText("Eat " .. requiredScore - currentScore .. " brains", "NewZombieFont13", textX, textValueY, Color(255,255,255,170), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	--end
	--draw.SimpleText("BRAINS", "NewZombieFont10", textX, textKeyY, Color(255,255,255,200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end