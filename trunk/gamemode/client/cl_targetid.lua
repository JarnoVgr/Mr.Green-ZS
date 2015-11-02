-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

COLOR_FRIENDLY = COLOR_GREEN
COLOR_HEALTHY = COLOR_GREEN
COLOR_HURT = COLOR_YELLOW
COLOR_CRITICAL = COLOR_RED
COLOR_SCRATCHED = Color(100, 255, 0)

local function DrawTargetIDTurret(entity)
	local EntTeam = TEAM_HUMAN

	--Only show if same team
	if not MySelf:GetPerk("Commando") then
		if MySelf:Team() ~= EntTeam then
			return
		end
	end

	local cen = entity:LocalToWorld(entity:OBBCenter())
	local cenp = cen:ToScreen()
	
	local cem = entity:LocalToWorld(entity:OBBMaxs())
	local cemp = cem:ToScreen()
	
	--Get owner and turret name
	local name 
	local nick = ""
	local Owner = entity:GetTurretOwner()
	if IsValid(Owner) then
		name = Owner:Nick().."'s Turret"
		
		local TurretNickName = entity:GetTurretName()
		--local TurretHealth = entity:GetDTInt(1)
		--local TurretMaxHealth = entity:GetDTInt(3)
		if TurretNickName then
			nick = "'".. TurretNickName .."'"
		end
	else
		name = "Turret"
	end
	
	--local ammo = "Ammo: "..entity:GetNWInt("TurretAmmo").."/"..entity:GetNWInt("MaxTurretAmmo")
	local ammo = entity:GetDTInt(0).."|"..entity:GetDTInt(2)
	local health = entity:GetDTInt(1).."|"..entity:GetDTInt(3)
				
	col = Color(255,255,240,225)
	col2 = Color(0,0,0,225)

	draw.DrawText(nick, "Trebuchet18", cenp.x, cemp.y, col, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,col2)
	draw.DrawText("Ammunition [" .. ammo .."]", "Trebuchet18", cenp.x, cemp.y * 1.07, col, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,col2)
	draw.DrawText("Integrity [" .. health .."]", "Trebuchet18", cenp.x, cemp.y * 1.14, col, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,col2)	
	
	
	draw.DrawText("USE + RELOAD to PICKUP", "Trebuchet18", cenp.x, cemp.y * 1.28, col, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,col2)		

end

function GM:HUDDrawTargetID()
	if not IsValid(MySelf) then
		return
	end

	local trace = MySelf:GetEyeTrace()
	local entity = trace.Entity

	if not IsValid(entity) then
		return
	end
	
	if entity:IsPlayer() then
	
		--if entity:IsWraith() then
		--	local fakeNames = "Test,Test,Test,Test"	
		--end
	
		local EntTeam = entity:Team() or -1

		--Only show TargetIDs from same team
		if not MySelf:GetPerk("Commando") then
			if MySelf:Team() ~= EntTeam then
				return
			end
		end

		local EntName = entity:Name()
		local EntHealth = entity:Health() or 1
		local EntRank = entity:GetRank()

		local x, y = w * 0.5, h * 0.59
		
		local rand, rand2
		
		local col = Color(255,255,255,155)
		local col2 = Color(0,0,0,155)

		surface.SetFont("ArialBoldTwelve")
		local NameWidth, NameHeight = surface.GetTextSize(EntName)

		--Medical assistance
		local ImportantMessage
		if EntHealth < 10 then
			ImportantMessage = "Bleeding to death.."
		elseif EntHealth < 25 then 
			ImportantMessage = "Requires a Medic!"
		end

		surface.SetFont("ArialBoldSeven")
		local HealthTextWidth, HealthTextHeight = surface.GetTextSize(EntHealth)
		
		--Random background border stuff
		for k=1, 4 do
			rand = math.Rand(-2.5, 2.4)
			rand2 = math.Rand(-2.5,2.5)
			col = Color(220,10,10,155)
			if k == 4 then 
				col = Color(255,255,255,255)
				col2 = Color(0,0,0,255)
				rand = 0 
				rand2 = 0 
			end
			
			if MySelf:Team() == EntTeam then
				draw.SimpleTextOutlined(EntName, "ArialBoldTwelve",x + rand,y + rand2,col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, col2)
			else
				col = Color(220,10,10,140)
			end
			newY = y + NameHeight + 8

			--Health
			draw.SimpleTextOutlined("F", "Signs", x+rand,newY+rand2, col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, col2)
			draw.SimpleTextOutlined(EntHealth, "ArialBoldSeven", x+rand, (newY + rand2) - h*0.01, col, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER, 1, col2)
			if entity:IsBot() then --Duby: I LOVE YOU NECRO, I HAVE EVEN MADE NECRO BOTS NOW!!!
			draw.SimpleTextOutlined("Necro Bot", "ArialBoldSeven", x+rand-40, (newY+25 + rand2) - h*0.01, col, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER, 1, col2)
			end
			--Draw important player message, if any
			if ImportantMessage then
				draw.SimpleTextOutlined(ImportantMessage, "ArialBoldTwelve", x+rand, newY+rand2-100, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, col2)
			--Else, draw level
			elseif EntRank > 0 then
				newY = newY + HealthTextHeight + 2
				draw.SimpleTextOutlined("Level ".. EntRank, "ArialBoldSeven", x+rand, newY+rand2, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, col2)
			end
		end
	elseif entity:GetClass() == "zs_turret" then
		DrawTargetIDTurret(entity)
	end
end