--[==[----------------------------------------
		 Human HUD main
-----------------------------------------]==]

local healthIndication = {
	{Text = "healthy as a horse",Percent = 1},
	{ Text = "a few scratches", Percent = 0.9 },
	{ Text = "a nasty wound", Percent = 0.75 },
	{ Text = "search for help", Percent = 0.6 },
	{ Text = "you lost your guts", Percent = 0.45 },
	{ Text = "bleeding to death", Percent = 0.25 },
	{ Text = "at deaths door", Percent = 0.1 }	
	}
table.SortByMember(healthIndication, "Percent", false)

local LeftGradient = surface.GetTextureID("gui/gradient")
local Arrow = surface.GetTextureID("gui/arrow")
function hud.DrawHumanHUD()
	hud.DrawAmmoPanel()
	hud.DrawHealth()
	hud.DrawSkillPoints()
	hud.DrawObjMessages()
	hud.DrawZeroWaveMessage()
	--hud.DrawFriends()
	
	if OBJECTIVE then
		surface.SetTexture(LeftGradient)
		surface.SetDrawColor(0, 0, 0, 140)
		surface.DrawTexturedRect(0,0,ScaleW(370),ScaleH(60))
	
		draw.SimpleTextOutlined("Stage #"..GAMEMODE:GetObjStage().." of "..#Objectives, "ArialBoldFive", 10, 5, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))
		draw.SimpleTextOutlined("Objective: "..Objectives[GAMEMODE:GetObjStage()].Info, "ArialBoldFive", 10, 25, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1, Color(0,0,0,255))	
	end
end


local turretIcon = surface.GetTextureID("killicon/turret")
local healthPercentageDrawn, healthStatusText = 1, healthIndication[1].Text
function hud.DrawHealth()


	local healthPoints, maxHealthPoints = math.max(MySelf:Health(),0), MySelf:GetMaximumHealth()

	local startX = (ScrW()/2)

	local textX, textValueY, textKeyY = ScaleW(40), ScaleH(860), ScaleH(890)

	
	--Draw health points text
	local healthTextX , healthTextValueY, healthTextKeyY = ScaleW(40),ScaleH(975), ScaleH(1200)
	draw.SimpleTextOutlined("+", "hpFont",startX - ScrW()/2 + ScrW()/80, ScrH()/1.03, Color(255,255,255,170), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))	
	draw.SimpleTextOutlined(healthPoints, "ssNewAmmoFont13",startX - ScrW()/2 + ScrW()/45, ScrH()/1.03, Color(255,255,255,170), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))

	--Health bar begin

	local barW, barH = ScaleW(210), ScaleH(20)
	local barX, barY = healthTextX + ScaleW(35), ScaleH(880)+ScaleH(110)
	
	local healthPercentage, healthChanged = math.Clamp(healthPoints / maxHealthPoints, 0, 1), false
	if healthPercentage ~= healthPercentageDrawn then
		healthChanged = true
	end

	healthPercentageDrawn = math.Clamp(math.Approach(healthPercentageDrawn, healthPercentage, FrameTime() * 1.8), 0, 1) --Smooth

	--Determine health bar foreground color
	local fHealth, fMaxHealth = math.max(MySelf:Health(),0), MySelf:GetMaximumHealth()
	local iPercentage = math.Clamp(fHealth / fMaxHealth, 0, 1)
	local healthBarColor = Color(137, 30, 30, 255)
	local healthBarBGColor = Color(70, 20, 20, 255)
	
	
	--Different colors
	if iPercentage > 0.75 then
		healthBarColor = Color(24, 140, 30, 255)
		healthBarBGColor = Color(52, 68, 15, 255)
	elseif iPercentage > 0.5 then
		healthBarColor = Color(137, 116, 24, 255)
		healthBarBGColor = Color(86, 73, 15, 255)
	end

	--Flash under certain conditions
	if MySelf:IsTakingDOT() or healthPercentageDrawn < 0.3 then
		healthBarColor = Color(healthBarColor.r, healthBarColor.g, healthBarColor.b, math.abs( math.sin( CurTime() * 4 ) ) * 255)
	end

	--Background
	if healthPercentageDrawn ~= 1 then
		surface.SetDrawColor(healthBarBGColor)
		surface.DrawRect(barX, barY, barW, barH)
	end

	--Foreground
	surface.SetDrawColor(healthBarColor)
	surface.DrawRect(barX, barY, barW * healthPercentageDrawn, barH)

	--Only update text if health changed
	if healthChanged then
		for k, v in ipairs(healthIndication) do
			if healthPercentage >= v.Percent then
				healthStatusText = v.Text
				break
			end
		end
	end
	
	--Draw health status text
	draw.SimpleTextOutlined(healthStatusText, "ssNewAmmoFont5", barX+(barW/2), barY+(barH/2), Color(250,250,250,170), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
	

	--TODO: Make this look nice in the HUD
	--Duby: Ywa this causes script errors and removes the whole hud when a player has both turrets. So I am going to do something with this soon. 
--[[
	if IsValid(MySelf.MiniTurret) or IsValid(MySelf.Turret) then
		local tur = MySelf.MiniTurret or MySelf.Turret
		
		if not tur then
			return
		end

		surface.SetFont("ssNewAmmoFont13")
		local fSPTextWidth, fSPTextHeight = surface.GetTextSize(MySelf:GetScore() .." SP")
	
		ActualX = ActualX + HPBarSizeW + ScaleW(40) + fSPTextWidth
	
		local th = HPBarSizeH
	
		surface.SetDrawColor(0, 0, 0, 150)
		surface.DrawRect(ActualX, ActualY, ScaleW(80),HPBarSizeH)
		
		surface.SetTexture(turreticon)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(ActualX,ActualY,th,th)


		ActualX = ActualX + th + ScaleW(40)
				
		draw.SimpleTextOutlined(tur:GetAmmo().."/"..tur:GetMaxAmmo(), "ssNewAmmoFont6.5", ActualX, ActualY+th/2, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	end
	]]
end

local cachedEnts
local nextEntsCache
local function DrawWeaponLabels()
	if not IsEntityValid(MySelf) or ENDROUND or not MySelf.ReadySQL or not MySelf:Alive() or not MySelf:IsHuman() or IsClassesMenuOpen() or util.tobool(GetConVarNumber("zs_hidehud")) then
		return
	end

	--Cache ents
	if not nextEntsCache or nextEntsCache < CurTime() then
		cachedEnts = ents.FindByClass("weapon_*")
		nextEntsCache = CurTime() + 5
	end

	if not cachedEnts then
		return
	end
	
	--Draw weapon name labels
	
	for k, ent in pairs(cachedEnts) do
		if not ent or not IsValid(ent) or not ent:IsWeapon() or IsValid(ent:GetOwner()) or ent:GetPos():Distance( LocalPlayer():GetPos() ) > 400 then
			continue
		end

		local camPos = ent:GetPos() + Vector(0, 0, 8)

		local camAngle = ( LocalPlayer():GetPos() - ent:GetPos() ):Angle()
		camAngle.p = 0
		camAngle.y = camAngle.y + 90
		camAngle.r = camAngle.r + 90
				
		local name = ent.PrintName or ""
				
		cam.Start3D2D( camPos, camAngle, 0.2 )
		draw.SimpleTextOutlined( name, "ssNewAmmoFont5", 0, 0, Color(255,255,255,120), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,40) ) 
		cam.End3D2D()
	end
end
hook.Add("PostDrawTranslucentRenderables", "RenderWorldWeaponsLabels", DrawWeaponLabels)

function hud.DrawAmmoPanel()
	local ActiveWeapon = MySelf:GetActiveWeapon()
	if not IsValid(ActiveWeapon) then
		return
	end
	local currentClipSize, currentAmmo = MySelf:GetActiveWeapon():Clip1(), MySelf:GetAmmoCount(MySelf:GetActiveWeapon():GetPrimaryAmmoType())
		
	--Draw turret's ammo
	if ActiveWeapon:GetClass() == "weapon_zs_tools_remote" then
		for _,v in pairs (ents.FindByClass("zs_turret")) do
			if v:GetTurretOwner() and v:GetTurretOwner() == MySelf then
				currentClipSize, currentAmmo = v:GetDTInt(0),v:GetDTInt(2)
				break
			end
		end
	end
	
	if ActiveWeapon.NoHUD or currentClipSize == -1 then
		return
	end
	
	local drawX, drawY, drawW, drawH = ScaleW(1100), ScaleH(880), ScaleW(150), ScaleH(270)
		
	if currentAmmo > 0 then
		surface.SetFont("ssNewAmmoFont6.5")
		local ammoTextWide, ammoTextTall = surface.GetTextSize(currentAmmo)

		surface.SetFont("ssNewAmmoFont20")
		local clipTextWide, clipTextTall = surface.GetTextSize(currentClipSize)

		draw.SimpleTextOutlined(currentClipSize, "ssNewAmmoFont24", ScrW()-ScaleW(10)-ammoTextWide-15, ScrH()-(ScaleH(4)+clipTextTall), Color(255,255,255,230), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
		draw.SimpleTextOutlined(currentAmmo, "ssNewAmmoFont9", ScrW()-ScaleW(10)-ammoTextWide-5, ScrH()-(ScaleH(3)+clipTextTall), Color(255,255,255,230), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
	else
		draw.SimpleTextOutlined(currentClipSize, "ssNewAmmoFont24", ScrW()-ScaleW(5), ScrH()-ScaleH(5), Color(255,255,255,230), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0,0,0,255))
	end
end

function hud.DrawSkillPoints()
	
	local startX = (ScrW()/2)
	
	draw.SimpleTextOutlined("Skill Points: " .. MySelf:GetScore(), "ssNewAmmoFont7",0 + ScrW()/17.0, ScrH()/1.05, Color(255,255,255,120), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
end

function hud.DrawObjMessages()
	if not IsEntityValid ( MySelf ) or ENDROUND then
		return
	end

	if not MySelf.ReadySQL or not MySelf:Alive() or IsClassesMenuOpen() or IsSkillShopOpen() or not MySelf:IsHuman() or not OBJECTIVE then
		return
	end
	
	if Objectives[GAMEMODE:GetObjStage()].PaintObjective and #Objectives[GAMEMODE:GetObjStage()].PaintObjective > 0 then
		local objpos = Objectives[GAMEMODE:GetObjStage()].PaintObjective[2] + Vector(0,0,60)
		local arrowpos = Objectives[GAMEMODE:GetObjStage()].PaintObjective[2]
		local anim = math.Clamp(math.sin( RealTime()*3.2)*10,-20,20)
		
		local angle = (MySelf:GetPos() - objpos):Angle()
		angle.p = 0
		angle.y = angle.y + 90
		angle.r = angle.r + 90

		cam.Start3D2D(objpos,angle,0.5)
			surface.SetTexture(Arrow)
	
			
			surface.SetDrawColor(0,0, 0, 255)
			surface.DrawTexturedRectRotated(0,ScaleW(60) + anim,ScaleW(77),ScaleW(65),180)
			
			surface.SetDrawColor(255,255, 255, 255)
			surface.DrawTexturedRectRotated(0,ScaleW(60) + anim,ScaleW(60),ScaleW(60),180)
			
			
			draw.SimpleTextOutlined(Objectives[GAMEMODE:GetObjStage()].PaintObjective[1], "ArialBoldTen", 0, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
			
		cam.End3D2D()
	end
end
hook.Add("PostDrawOpaqueRenderables","hud.DrawObjMessages",hud.DrawObjMessages)



function hud.DrawZeroWaveMessage() --Duby: Lets re-add this nice feature!
	
		local curtime = CurTime()
	
		if CurTime() <= WARMUPTIME then
		
			surface.SetFont("ArialBoldSeven")
			local txtw, txth = surface.GetTextSize("Hi")
		--	draw.SimpleTextOutlined("Waiting for players... "..ToMinutesSeconds(math.max(0, WARMUPTIME - curtime)), "ArialBoldSeven", ScrW() * 0.5, ScrH() * 0.25, COLOR_GRAY,TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
			draw.SimpleTextOutlined("Go to an undead spawn area if you want to start as a ZOMBIE!", "ssNewAmmoFont7", ScrW() * 0.5, ScrH() * 0.75 - txth, COLOR_GRAY, TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER,1, Color(0,0,0,255))

			local vols = 0
			local voltab = {}
			local allplayers = player.GetAll()
			for _, gasses in pairs(ents.FindByClass("zs_poisongasses")) do
				local gaspos = gasses:GetPos()
				for _, ent in pairs(allplayers) do
				--	if ent:GetPos():Distance(gaspos) <= 272 and not table.HasValue(voltab, ent) then
					if ent:GetPos():Distance(gaspos) <= 500 and not table.HasValue(voltab, ent) then
						vols = vols + 1
						table.insert(voltab, ent)
					end
				end
			end

			for _, pl in pairs(allplayers) do
				if pl:Team() == TEAM_UNDEAD then
					vols = vols + 1
					table.insert(voltab, pl)
				end
			end

			local numplayers = #allplayers
			--local desiredzombies = math.max(1, math.ceil(numplayers * WAVE_ONE_ZOMBIES))
			local desiredzombies = math.max(UNDEAD_START_AMOUNT, math.Round(UNDEAD_START_AMOUNT * UNDEAD_START_AMOUNT_PERCENTAGE))

		--	draw.SimpleTextOutlined("Number of initial zombies this game ("..UNDEAD_START_AMOUNT * 100 .."%): "..desiredzombies, "ssNewAmmoFont7", ScrW() * 0.5, ScrH() * 0.75, COLOR_GRAY, TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
			draw.SimpleTextOutlined("Number of initial zombies this game ("..UNDEAD_START_AMOUNT.."): "..desiredzombies, "ssNewAmmoFont7", ScrW() * 0.5, ScrH() * 0.75, COLOR_GRAY, TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER,1, Color(0,0,0,255))

			draw.SimpleTextOutlined("Zombie volunteers: "..vols, "ssNewAmmoFont7", ScrW() * 0.5, ScrH() * 0.75 + txth, COLOR_GRAY, TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
			surface.SetFont("Default")
			local y = ScrH() * 0.75 + txth * 2
			txtw, txth = surface.GetTextSize("Hi")
			for _, pl in pairs(voltab) do
				if ScrH() - txth <= y then break else
					draw.SimpleTextOutlined(pl:Name(), "ArialBoldTen", ScrW() * 0.5, y, COLOR_GRAY, TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
					y = y + txth * 2
				end
			end
		end
	
end