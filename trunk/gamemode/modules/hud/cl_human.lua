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

SPRequired = 100
	
local TableUpdated = 0	
local nailBarWidth = ScrW()*0.04		
function hud.DrawHumanHUD()
	hud.DrawAmmoPanel()
	hud.DrawHealth()
	hud.DrawSkillPoints()
	
	
	for _,nail in pairs (ents.FindByClass("nail")) do
		if not nail or not nail:IsValid() then
			continue
		end

		if nail:GetPos():Distance(EyePos()) > 280 then
			continue
		end
		
		local nailHealth = math.Round(nail:GetDTInt(0)*100/nail:GetDTInt(1))/100	
		surface.SetDrawColor( 245, 245 , 255, 140 )
		surface.DrawRect( nail:GetPos():ToScreen().x - nailBarWidth / 2, nail:GetPos():ToScreen().y, nailBarWidth, ScrH()*0.0075 )
		surface.SetDrawColor(255 * (1 - nailHealth), 255 * nailHealth, 0, 220 )
		surface.DrawRect( nail:GetPos():ToScreen().x - nailBarWidth / 2, nail:GetPos():ToScreen().y, nailBarWidth * nailHealth, ScrH()*0.0075 )
	

		--draw.SimpleTextOutlined("+".. math.Round(nail:GetDTInt(0)) .." / ".. math.Round(nail:GetDTInt(1)), "ArialBoldFive", nail:GetPos():ToScreen().x, nail:GetPos():ToScreen().y, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
		--draw.SimpleTextOutlined(ent, "ArialBoldFive", nail:GetPos():ToScreen().x, nail:GetPos():ToScreen().y, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))	
	end	
	--hud.DrawObjMessages()
	
	if CurTime() <= WARMUPTIME then
		--if TableUpdated < CurTime() then
			--TableUpdated = CurTime() + 3
			--hud.UpdateHumanTable()
			--local humans = team.GetPlayers(TEAM_HUMAN)		
			--table.sort(humans,hud.ZombieSpawnDistanceSort)	
		--end
		hud.DrawZeroWaveMessage()	
	end

end


local turretIcon = surface.GetTextureID("killicon/turret")
local healthPercentageDrawn, healthStatusText = 1, healthIndication[1].Text
function hud.DrawHealth()
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
	
	--Draw health points text

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
	
	--[[
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
	]]--
end
hook.Add("PostDrawTranslucentRenderables", "RenderWorldWeaponsLabels", DrawWeaponLabels)

local ammoPercentageDrawn = 0
function hud.DrawAmmoPanel()
	local ActiveWeapon = MySelf:GetActiveWeapon()
	if not IsValid(ActiveWeapon) then
		return
	end
	
	--[[
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
	]]--


--MySelf:GetAmmoCount(MySelf:GetActiveWeapon():GetPrimaryAmmoType())
	local Clip1, ClipSize, AmmoRemaining = MySelf:GetActiveWeapon():Clip1(),  MySelf:GetActiveWeapon().Primary.ClipSize, MySelf:GetAmmoCount(MySelf:GetActiveWeapon():GetPrimaryAmmoType())
	
	local Clip2, ClipSize2, AmmoRemaining2 = MySelf:GetActiveWeapon():Clip2(),  MySelf:GetActiveWeapon().Secondary.ClipSize, MySelf:GetAmmoCount(MySelf:GetActiveWeapon():GetSecondaryAmmoType())
	
	if (Clip1 == -1 and Clip2 != - 1) then
		Clip1 = Clip2
		ClipSize = ClipSize2
		AmmoRemaining = AmmoRemaining2
	end
	
	local percentage = 0
		local healthPercentage, healthChanged = 0, false
	
	if (MySelf:GetActiveWeapon().Pulse_ClipSize) then
		healthPercentage = math.Clamp(Clip1 / MySelf:GetActiveWeapon().Pulse_ClipSize, 0, 1)
		percentage = math.Clamp((Clip1 / MySelf:GetActiveWeapon().Pulse_ClipSize), 0.2, 1)
	else
		healthPercentage = math.Clamp(Clip1 / ClipSize, 0, 1)	
		percentage = math.Clamp((Clip1 / ClipSize), 0.2, 1)
	end
	

	
	if ActiveWeapon.NoHUD or Clip1 == -1 then
		return
	end	
	
	local textX, textY = (ScrW()) - (ScrW() * 0.18) , ScrH() - ScaleH(50)

	--Health bar begin

	local barW, barH = ScaleW(220), ScaleH(40)
	local barX, barY = (ScrW()) - (ScrW() * 0.19), textY - (barH * 0.5)
	
	

	if healthPercentage ~= ammoPercentageDrawn then
		healthChanged = true
	end

	ammoPercentageDrawn = math.Clamp(math.Approach(ammoPercentageDrawn, healthPercentage, FrameTime() * 1.5), 0, 1) --Smooth

	local red = 1 - percentage
	local healthFontColor = Color(250, 250, 250, 220)
	local healthBarColor = Color(255, 255 * percentage, 255 * percentage, 100)
	local healthBarBGColor = Color(30 * red, 30 * percentage, 30 * percentage, 100)

	--surface.SetDrawColor(Color(0,0,0,60))
	--surface.DrawRect(0, ScrH() - ScaleH(120), ScaleW(260), ScaleH(120))		
	
	--Draw health points text

	--Background
	if ammoPercentageDrawn ~= 1 then
		surface.SetDrawColor(healthBarBGColor)
		surface.DrawRect(barX, barY, barW, barH)
	end
	
	--Foreground
	surface.SetDrawColor(healthBarColor)
	surface.DrawRect(barX, barY, barW * ammoPercentageDrawn, barH)

	--draw.SimpleTextOutlined("+", "hpFont",textX, textY, healthFontColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))	
	
	if (MySelf:GetActiveWeapon().Pulse_ClipSize) then
		draw.SimpleTextOutlined(Clip1 .. " / " .. MySelf:GetActiveWeapon().Pulse_ClipSize, "CorpusCareThirteen",textX, textY, healthFontColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,220))	
	
	else
		draw.SimpleTextOutlined(Clip1 .. " / " .. AmmoRemaining, "CorpusCareThirteen",textX, textY, healthFontColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,220))	
	end
	--draw.SimpleTextOutlined(":" .. maxHealthPoints, "fontHuman6",textX + ScaleW(40), textY + ScaleH(10), healthFontColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER,1, Color(0,0,0,220))			

end

local SPRequired = 100

net.Receive("SPRequired", function(len)
	SPRequired = net.ReadFloat()
end)

local tier = 1
local weight = 0
net.Receive("tier", function(len)
	tier = net.ReadFloat()
end)

net.Receive("weight", function(len)
	weight = net.ReadFloat()
end)

local spBarX = 0 + (ScrW()*0.13 * 0.5)
local spBarY = ScrH()/1.1

function hud.DrawSkillPoints()

	local spRatio = math.Round(MySelf:GetScore()*100/SPRequired)/100
			
	surface.SetDrawColor( 100, 100 , 100, 200 )
	surface.DrawOutlinedRect( spBarX, spBarY, ScrW()*0.13, ScrH()*0.01 )
	surface.SetDrawColor(0, 154, 205, 200 )
	surface.DrawRect( spBarX, spBarY, (ScrW()*0.13)*spRatio, ScrH()*0.01 )

	
	--draw.RoundedBox(0, spBarX, spBarY, ScrW()*0.13, ScrH()*0.08, Color(20, 26, 20, 150))
	
	surface.SetDrawColor(200, 200, 200, 200 )
	surface.DrawRect( spBarX, spBarY  - ScrH()*0.005, ScrW()*0.002, ScrH()*0.015 )
	surface.DrawRect( spBarX + ScrW()*0.13 - ScrW()*0.001, spBarY - ScrH()*0.005, ScrW()*0.002, ScrH()*0.015 )

	
	draw.SimpleText(weight .. " KG", "HudHintTextLarge", ScrW()*0.025, spBarY * 1, Color( 255, 255, 255, 245 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	
	if tier < 5 then
		draw.SimpleText("T" .. tier .. " Weapon Drop: " .. SPRequired - MySelf:GetScore() .. " SP", "HudHintTextLarge", spBarX + (ScrW()*0.13 * 0.5), spBarY * 0.985, Color( 255, 255, 255, 245 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
	else
		draw.SimpleText("Ammo Drop: " .. SPRequired - MySelf:GetScore() .. " SP", "HudHintTextLarge", spBarX + (ScrW()*0.13 * 0.5), spBarY * 0.985, Color( 255, 255, 255, 245 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )	
	end
--draw.SimpleTextOutlined("SP for drop: " .. SPRequired - MySelf:GetScore(), "ssNewAmmoFont5.5",startX - ScrW()/2 + ScrW()/80, ScrH()/1.075, Color(255,255,255,145), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
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


function hud.UpdateHumanTable()

	local humans = team.GetPlayers(TEAM_HUMAN)			

	

		TableUpdated = CurTime() + 3
		for k,v in pairs(humans) do
			local pos = v:GetPos()
			local closest = 9999999
			for _, gasses in pairs(ents.FindByClass("zs_poisongasses")) do	
				local dist = gasses:GetPos():Distance(pos)
				if dist < closest then
					closest = dist
				end
			end
			v.GasDistance = closest	
		end


	--	
end

function hud.ZombieSpawnDistanceSort(other)
	return MySelf.GasDistance < other.GasDistance
end

function hud.DrawZeroWaveMessage()
		
		local curtime = CurTime()
		
		if CurTime() <= WARMUPTIME then
		
			surface.SetFont("ArialBoldSeven")
			local txtw, txth = surface.GetTextSize("Hi")
		--	draw.SimpleTextOutlined("Waiting for players... "..ToMinutesSeconds(math.max(0, WARMUPTIME - curtime)), "ArialBoldSeven", ScrW() * 0.5, ScrH() * 0.25, COLOR_GRAY,TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
			draw.SimpleTextOutlined("Humans closest to a zombie gas will become a zombie!", "ssNewAmmoFont7", ScrW() * 0.5, ScrH() * 0.65 - txth, Color(255,255,255,150), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER,1, Color(0,0,0,150))

			
			local vols = 0
			local gastab = {}
			
			local voltab = {}
			local allplayers = player.GetAll()
			for _, gasses in pairs(ents.FindByClass("zs_poisongasses")) do
				local gaspos = gasses:GetPos()
				for _, ent in pairs(allplayers) do
				--	if ent:GetPos():Distance(gaspos) <= 272 and not table.HasValue(voltab, ent) then
					if ent:GetPos():Distance(gaspos) <= UNDEAD_VOLUNTEER_DISTANCE and not table.HasValue(voltab, ent) then
						vols = vols + 1
						table.insert(voltab, ent)
					end
				end
			end

			local numplayers = #allplayers
			local desiredzombies = math.max(UNDEAD_START_AMOUNT, math.Round(numplayers * UNDEAD_START_AMOUNT_PERCENTAGE))
			
			local humans = team.GetPlayers(TEAM_HUMAN)	
			
			--[[
			local distance = 9999999	
	
			for _, pl in pairs(allplayers) do
				if pl:Team() == TEAM_UNDEAD then
					vols = vols + 1
					table.insert(voltab, pl)
				end
			end
			
			for i = 1, desiredzombies - vols do
				if 0 < #humans then	
					for j = 1, #humans do
					
						if humans[j].GasDistance < distance and not humans[j].ToBeZombie then
							distance = humans[j].GasDistance
							humans[j].ToBeZombie = true
						else
							humans[j].ToBeZombie = false						
						end
					end
				end
			end
		
			for j = 1, #humans do
				if humans[j].ToBeZombie then	
					draw.SimpleTextOutlined(humans[j]:Name(), "ssNewAmmoFont7", ScrW() * 0.5, ScrH() * 0.2 + txth * 2	, COLOR_GRAY, TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER,1, Color(0,0,0,220))
					humans[j].ToBeZombie = false				
				end
			end		


			--local desiredzombies = math.max(1, math.ceil(numplayers * WAVE_ONE_ZOMBIES))
			
			local y = ScrH() * 0.8 + txth * 1.25
			

			for k,v in pairs(humans) do	
				if v:Name() == LocalPlayer():Name() then
					draw.SimpleTextOutlined(v:Name().. " " ..math.Round(v.GasDistance or 0), "ssNewAmmoFont4", ScrW() * 0.013, y, COLOR_RED, TEXT_ALIGN_LEFT , TEXT_ALIGN_CENTER,1, Color(0,0,0,200))
				else
					draw.SimpleTextOutlined(v:Name().. " " ..math.Round(v.GasDistance or 0), "ssNewAmmoFont4", ScrW() * 0.013, y, COLOR_GRAY, TEXT_ALIGN_LEFT , TEXT_ALIGN_CENTER,1, Color(0,0,0,200))				
				end
				y = y + txth * 1
			end
			]]--
			
		--	draw.SimpleTextOutlined("Number of initial zombies this game ("..UNDEAD_START_AMOUNT * 100 .."%): "..desiredzombies, "ssNewAmmoFont7", ScrW() * 0.5, ScrH() * 0.75, COLOR_GRAY, TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
			draw.SimpleTextOutlined("Initial zombies this game: "..desiredzombies.."", "ssNewAmmoFont6.5", ScrW() * 0.5, ScrH() * 0.65, Color(255,255,255,150), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER,1, Color(0,0,0,150))
			y = ScrH() * 0.65 + txth * 2
			draw.SimpleTextOutlined("Volunteers: "..vols, "ssNewAmmoFont6.5", ScrW() * 0.5, ScrH() * 0.65 + txth, Color(255,255,255,150), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER,1, Color(0,0,0,150))
			surface.SetFont("Default")
			txtw, txth = surface.GetTextSize("Hi")
			for _, pl in pairs(voltab) do
				if ScrH() - txth <= y then break else
					draw.SimpleTextOutlined(pl:Name(), "ssNewAmmoFont6.5", ScrW() * 0.5, y, Color(255,255,255,150), TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER,1, Color(0,0,0,150))
					y = y + txth * 2
				end
			end			
		end
	
end



