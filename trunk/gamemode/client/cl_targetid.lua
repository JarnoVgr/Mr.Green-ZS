-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local table = table
local surface = surface
local draw = draw
local math = math
local string = string
local util = util
local pairs = pairs
local team = team
local player = player
local timer = timer

COLOR_FRIENDLY = COLOR_GREEN
COLOR_HEALTHY = COLOR_GREEN
COLOR_HURT = COLOR_YELLOW
COLOR_CRITICAL = COLOR_RED
COLOR_SCRATCHED = Color(100, 255, 0)

XNameBlur = 0
XNameBlur2 = 0
YNameBlur = 0
YNameBlur2 = 0

local color_blur1 = Color(100, 20, 0, 220)
local color_blur2 = Color(100, 20, 0, 140)


function DrawTargetIDTurret ( MySelf, team )
	local vStart = MySelf:GetShootPos()
	
	local tr = {start = vStart, endpos = vStart + (MySelf:GetAimVector() * 5000),filter = MySelf,mask = MASK_SHOT}
	local trace = util.TraceLine (tr)
	
	local entity = trace.Entity
	if not ValidEntity (entity) or entity:GetClass() ~= "zs_turret" then return end
	
	local team = MySelf:Team()
	local otherteam = TEAM_HUMAN
	--local weapon = entity:GetActiveWeapon():GetPrintName() or "weapon"
	local r,g,b,a = entity:GetColor()
	local cen = entity:LocalToWorld(entity:OBBCenter())
	local cenp = cen:ToScreen()
	
	local cem = entity:LocalToWorld(entity:OBBMaxs())
	local cemp = cem:ToScreen()
	
	if team == otherteam then
		local name 
		local nick = ""
		if IsValid(entity:GetTurretOwner()) and entity:GetTurretOwner():Nick() != nil then
			name = entity:GetTurretOwner():Nick().."'s Turret"
			
			if entity:GetTurretName() then
				nick = "'"..entity:GetTurretName().."'"
			end
		else
			name = "Turret"
		end
		--local ammo = "Ammo: "..entity:GetNWInt("TurretAmmo").."/"..entity:GetNWInt("MaxTurretAmmo")
		local ammo = "Ammo: "..entity:GetDTInt(0).."/"..entity:GetDTInt(2)
		
		local rand = 0
		local rand2 = 0
		
		col = Color(255,255,255,125)
		col2 = Color(0,0,0,125)

		for k=1, 4 do
				rand = math.Rand(-2, 2)
				rand2 = math.Rand(-2,2)
				col = Color(220,10,10,125)
				if k == 4 then 
					col = Color(255,255,255,255)
					col2 = Color(0,0,0,255)
					rand = 0 
					rand2 = 0 
				end
				
				draw.SimpleTextOutlined(nick, "ArialBoldSeven", cenp.x + rand, cemp.y - 90 + rand2, col, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,col2)
				
				draw.SimpleTextOutlined(name, "ArialBoldFive", cenp.x + rand, cemp.y - 62 + rand2, col, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,col2)
				
				draw.SimpleTextOutlined(ammo, "ArialBoldFive", cenp.x + rand, cemp.y - 35 + rand2, col, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,col2)	
				
		end
	end

end

function GM:_HUDDrawTargetID(MySelf, team)
	if !IsValid(MySelf) then return end
	-- Draw target id for turrets
	DrawTargetIDTurret (MySelf, team)
	--DrawTargetIDMine (MySelf, team)
	//make it classic way
	local trace = MySelf:GetEyeTrace()
	local entity = trace.Entity
	
	if entity:IsPlayer() then
		local text = entity:Name()

		local x, y = w * 0.5, h * 0.59
		local otherteam = entity:Team() or 1
		
		local rand = 0
		local rand2 = 0
		
		col = Color(255,255,255,155)
		col2 = Color(0,0,0,155)
		
		if team == otherteam then
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
				draw.SimpleTextOutlined(text,"ArialBoldTwelve",x+rand,y+rand2,col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, col2)
			end
			surface.SetFont("ArialBoldTwelve")
			local texw, texh = surface.GetTextSize(text)
			y = y + texh + 8
			
			local entityhealth = entity:Health() or 1
			
			col = Color(255,255,255,155)
			col2 = Color(0,0,0,155)
			col3 = Color(30,30,30,255)
			for i=1, 4 do
				rand = math.Rand(-2, 2)
				rand2 = math.Rand(-2,2)
				col = Color(220,10,10,255)
				if i == 4 then 
					col = Color(255,255,255,255)
					col2 = Color(0,0,0,255)
					col3 = col
					rand = 0 
					rand2 = 0 
				end
				draw.SimpleText("F", "Signs", x+rand,y+rand2, col3, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
				draw.SimpleTextOutlined(entityhealth, "ArialBoldSeven", x+rand, y +rand2- h*0.01, col, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER, 1, col2)
			end
		end
	end
	
end

//timer.Create("ShuffleNameBlur", 0.07, 0, function()
	//XNameBlur = math.random(-3, 3)
	//XNameBlur2 = math.random(-3, 3)
	//YNameBlur = math.random(-3, 3)
	//YNameBlur2 = math.random(-3, 3)
//end)
