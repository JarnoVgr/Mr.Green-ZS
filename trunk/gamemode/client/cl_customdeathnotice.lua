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
local cam = cam

-- Custom Deathnotice System ( Deluvas,  not yet finished )

local Deaths = { }

-- To be done
function GM:AddCustomDeathNotice ( attacker, inflictor, victim, assist )
	local Death = {}
	Deaths = {}
	
	Death.victim 	= 	victim
	Death.attacker	=	attacker
	Death.inflictor	=	inflictor
	Death.time		=	CurTime()
	Death.assist    =   assist
	
	table.insert(Deaths, Death)
end

function GM:DrawCustomDeathNotice (x, y)
	for k, Death in pairs( Deaths ) do
		DrawCustomDeath3(Death)
	end
end

function DrawCustomDeath ( x, y, death )
	--[=[local text 
	
	if death.attacker == "self" then
		text = "You have suicided! That's awful!"
	elseif death.assist and death.assist ~= "" then
		text = "You've been killed by "..death.attacker.." and "..death.assist
	else
		text = "You've been killed by "..death.attacker.."! You are dead. Not a big surprise!"
	end

	surface.SetFont ("ArialBoldNine")
	local textw, texth = surface.GetTextSize (text)
	local boxw, boxh = textw + 28, texth + 12
	
	draw.RoundedBox( 6, x, y,boxw, boxh, Color (1,1,1,210) )
	draw.SimpleText(text,"ArialBoldNine", x + (boxw/2), y + (boxh/2) ,Color (243,0,0,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)]=]
end

function DrawCustomDeath2 ( death )
	

	local text
	
	if death.attacker == "self" then return end
	
	if death.assist and death.assist ~= "" then
		text = ""..death.attacker:Name().." and "..death.assist..""
	else
		text = death.attacker:Name()
	end

	
	local wsize,hsize = ScaleW(450), ScaleH(130)
	local header = ScaleH(30)
	local xpos,ypos = ScrW()/2 - wsize/2, ScrH() - 25 - hsize
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawOutlinedRect(xpos,ypos, wsize,header)
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawOutlinedRect( xpos,ypos, wsize,hsize)
	draw.RoundedBox( 0, xpos,ypos,wsize,hsize, Color (1,1,1,200) )
	
	local textX,textY = xpos+4,ypos+3
	
	-- text goes here
	draw.SimpleTextOutlined("Killed by "..text, "ArialBoldFive", textX,textY, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT,1,Color(0,0,0,255))
	
	local font, letter = "WeaponSelectedHL2", "0"
	local Table = killicon.GetFont( death.inflictor )
	
	if Table then
		letter = Table.letter
				
		if not Table.IsHl2 and not Table.IsZS then
			font = "WeaponSelectedCSS"
		elseif not Table.IsHL2 and Table.IsZS then
			font = "WeaponSelectedZS"
		end
				
	end
	
	if killicon.GetImage( death.inflictor ) then
	
		local name = death.inflictor
		
		if GAMEMODE.HumanWeapons[name] and GAMEMODE.HumanWeapons[name].Name then
			name = GAMEMODE.HumanWeapons[name].Name
		end
		
		textX,textY = xpos+4,ypos+header+0.5*(hsize-header)/5
		
		draw.SimpleTextOutlined(name, "ArialBoldFive", textX,textY, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		local ImgTable = killicon.GetImage( death.inflictor ) 
		
		surface.SetTexture(surface.GetTextureID( ImgTable.mat ))	
		local wd,hg = surface.GetTextureSize(surface.GetTextureID( ImgTable.mat ))
		
		textX,textY = xpos+4,ypos+header+1*(hsize-header)/5
		
		surface.SetDrawColor( 255, 255, 255, 255)
		surface.DrawTexturedRect(textX,textY, wd, hg )
	
	else
		
		local name = death.inflictor
		
		if GAMEMODE.HumanWeapons[name] and GAMEMODE.HumanWeapons[name].Name then
			name = GAMEMODE.HumanWeapons[name].Name
		end
		
		textX,textY = xpos+4,ypos+header+0.5*(hsize-header)/5
		
		draw.SimpleTextOutlined(name, "ArialBoldFive", textX,textY, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
		
		surface.SetFont ( font )
		local fWide, fTall = surface.GetTextSize ( letter )
	
		textX,textY = xpos+4,ypos+header+4*(hsize-header)/5
	
		draw.SimpleTextOutlined(letter, font, textX,textY, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	
	end

	
	
end

function DrawCustomDeath3 ( death )
	
	-- PrintTable(death)
	
	local text = ""
	local text_assist = ""
	
	if death.attacker == "self" then return end
	
	-- if type(death.attacker) ~= "player" then return end
	
	
	
	if IsValid(death.attacker) and death.attacker.IsPlayer and death.attacker:IsPlayer() then
		if death.assist and death.assist ~= "" then
			text = ""..death.attacker:Name()-- .." and "..death.assist..""
			text_assist = death.assist
		else
			text = death.attacker:Name()
		end
	end
	if not ValidEntity(death.attacker) then return end
	if not death.attacker:OBBCenter() then return end
	if death.attacker:IsZombie() then return end
	
	
	local name = death.inflictor
		
	if GAMEMODE.HumanWeapons[name] and GAMEMODE.HumanWeapons[name].Name then
		name = GAMEMODE.HumanWeapons[name].Name
	end
	
	local attpos = death.attacker:LocalToWorld(death.attacker:OBBCenter())-- death.attacker:OBBCenter()
	attpos = attpos + Vector(0,0,death.attacker:OBBMaxs().z/3)
	local angle = (EyePos() - attpos):Angle()
	-- angle.p = 0
	angle.y = angle.y + 90
	angle.r = angle.r + 90

	cam.Start3D2D(attpos,angle,0.1)
	
		cam.IgnoreZ(true) -- we want to see the text even if its stuck in a wall	
		
		draw.SimpleTextOutlined("Killed by  ", "NewZombieFont27", -45-death.attacker:OBBMaxs().x, 0, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
		draw.SimpleTextOutlined(text.."  ", "NewZombieFont23", -45-death.attacker:OBBMaxs().x, 34, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
		
		if text_assist ~= "" then
			draw.SimpleTextOutlined("and  ", "NewZombieFont23", -45-death.attacker:OBBMaxs().x, 70, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
			draw.SimpleTextOutlined(text_assist.."  ", "NewZombieFont23", -45-death.attacker:OBBMaxs().x, 106, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
		end
		
		draw.SimpleTextOutlined("  with", "NewZombieFont23", 45+death.attacker:OBBMaxs().x, death.attacker:OBBMaxs().z*1.55, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
		draw.SimpleTextOutlined("  "..name, "NewZombieFont23", 45+death.attacker:OBBMaxs().x, death.attacker:OBBMaxs().z*1.55+34, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
		
		cam.IgnoreZ(false)
		
	cam.End3D2D()
	
	-- draw.SimpleTextOutlined(text, "ArialBoldTen", 50, 50, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))

end