--[=[---------------------------------------------------------
					Unlock achievement
---------------------------------------------------------]=]
local unlockSound = "weapons/physcannon/energy_disintegrate5.wav"
local effectStack, unlockEndTime = 0, 0
local unlockDescription, achievImage
local titlePosY, descriptionPosY = 0, 0
local titleEndY, descriptionEndY = h/2 - ScaleH(100), (h/2 - ScaleH(100)) + ScaleH(40)
local dynamicAlpha, effectActive = 255, false

local function DrawUnlock()		
	local textColor = Color(255, 255, 255, dynamicAlpha)
	local borderColor = Color(0, 0, 0, dynamicAlpha)

	if titlePosY < titleEndY then
		titlePosY = math.Approach(titlePosY, titleEndY, 50 * GameSpeed())
	end
	if descriptionPosY > descriptionEndY then
		descriptionPosY = math.Approach(descriptionPosY, descriptionEndY, 60 * GameSpeed())
	end
	
	for k=1, 4 do
		local randX = -2 + math.Rand(0,4)
		local randY = -2 + math.Rand(0,4)
		textColor = Color(220, 10, 10, dynamicAlpha/1.5)
		if k == 4 then 
			textColor = Color(255, 255, 255, dynamicAlpha)
			randX = 0 
			randY = 0 
		end
		draw.SimpleTextOutlined(unlockTitle, "ArialTwelve", w/2 + randX, titlePosY + randY, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, borderColor)
		draw.SimpleTextOutlined(unlockDescription, "ArialFifteen", w/2 + randX, descriptionPosY + randY, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, borderColor)
	end

	--Fade away
	if unlockEndTime < CurTime()+1 then
		dynamicAlpha = math.Approach(dynamicAlpha, 0, 40 * GameSpeed())
	end

	--Done?
	if unlockEndTime <= CurTime() then
		effectActive = false

		hook.Remove("HUDPaint", "DrawUnlock")
	end
end

function UnlockEffect(typeId, title, description)
	if effectActive then
		local delayTime = ((unlockEndTime - CurTime()) + 0.4) + (5.1 * (effectStack))

		effectStack = effectStack + 1

		--Delay display
		timer.Simple(delayTime, function()
			effectStack = effectStack - 1

			--Force disable
			if effectActive then
				effectActive = false
				hook.Remove("HUDPaint", "DrawUnlock")
			end

			UnlockEffect(typeId, title, description)
		end)

		return
	end
	
	--Achievement type
	if typeId == 1 then
		local statID = util.GetAchievementID(title)
		unlockDescription = achievementDesc[statID].Name
		unlockTitle = "Achievement attained"

		if MySelf.DataTable then
			MySelf.DataTable["Achievements"][title] = true
		end
	--Custom type
	elseif typeId == 0 then
		unlockTitle = title
		unlockDescription = description
	--Level up
	elseif typeId == 2 then
		unlockTitle = "Level up"
		unlockDescription = "New level is ".. title
	else
		effectStack = effectStack - 1
		return
	end
		
	
	unlockEndTime = CurTime() + 5
	dynamicAlpha = 255

	titlePosY = 0
	descriptionPosY = h

	surface.PlaySound(Sound(unlockSound))
	
	effectActive = true
	hook.Add("HUDPaint", "DrawUnlock", DrawUnlock)
end