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
	for k, Death in pairs(Deaths) do
		DrawCustomDeath(Death)
	end
end

function DrawCustomDeath(death)
	
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
	if not IsValid(death.attacker) then return end
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
end