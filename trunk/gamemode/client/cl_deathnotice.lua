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
local killicon = killicon
local tobool = tobool


local hud_deathnotice_time = CreateConVar("hud_deathnotice_time", "6", FCVAR_REPLICATED)

local Color_Icon = Color(255, 255, 255, 255) 
local NPC_Color = Color(250, 50, 50, 255)

--killicon.AddFont("prop_physics", "HL2MPTypeDeath", "9", Color_Icon)
--killicon.AddFont("prop_physics_multiplayer", "HL2MPTypeDeath", "9", Color_Icon)
killicon.Add("prop_physics", "killicon/propkill", Color_Icon)
killicon.Add("prop_physics_multiplayer", "killicon/propkill", Color_Icon)
killicon.Add("func_physbox", "killicon/propkill", Color_Icon)
killicon.Add("zs_turret", "killicon/turret", Color_Icon)
killicon.AddFont("prop_physics_respawnable", "HL2MPTypeDeath", "9", Color_Icon)
killicon.AddFont("func_physbox", "HL2MPTypeDeath", "9", Color_Icon)
killicon.AddFont("weapon_smg1", "HL2MPTypeDeath", "/", Color_Icon)
killicon.AddFont("weapon_357", "HL2MPTypeDeath", ".", Color_Icon)
killicon.AddFont("weapon_ar2", "HL2MPTypeDeath", "2", Color_Icon)
killicon.AddFont("crossbow_bolt", "HL2MPTypeDeath", "1", Color_Icon)
killicon.AddFont("weapon_shotgun", "HL2MPTypeDeath", "0", Color_Icon)
killicon.AddFont("rpg_missile", "HL2MPTypeDeath", "3", Color_Icon)
killicon.AddFont("npc_grenade_frag", "HL2MPTypeDeath", "4", Color_Icon)
killicon.AddFont("weapon_pistol", "HL2MPTypeDeath", "-", Color_Icon)
killicon.AddFont("prop_combine_ball", "HL2MPTypeDeath", "8", Color_Icon)
killicon.AddFont("grenade_ar2", "HL2MPTypeDeath", "7", Color_Icon)
killicon.AddFont("weapon_stunstick", "HL2MPTypeDeath", "!", Color_Icon)
killicon.AddFont("weapon_slam", "HL2MPTypeDeath", "*", Color_Icon)
killicon.AddFont("weapon_crowbar", "HL2MPTypeDeath", "6", Color_Icon)
killicon.AddFont("env_explosion", "HL2MPTypeDeath", "8", Color_Icon)

killicon.AddFont("headshot", "CSKillIcons", "D", Color(255, 255, 255, 255))
killicon.Add("redeem", "killicon/redeem", color_white)
killicon.Add("env_fire", "killicon/fire", Color_Icon)
killicon.Add("env_laser","killicon/laser", Color_Icon)
killicon.AddAlias( "random","default" )

killicon.Add("weapon_zs_zombie", "killicon/zs_zombie", color_white)
killicon.Add("weapon_zs_undead_fastzombie", "killicon/zs_zombie", color_white)
killicon.Add("weapon_zs_undead_poisonzombie", "killicon/zs_zombie", color_white)
killicon.Add("projectile_poisonpuke", "killicon/zs_zombie", color_white)
killicon.Add("weapon_zs_undead_headcrab", "killicon/zs_zombie", color_white)
killicon.Add("weapon_zs_fastheadcrab", "killicon/zs_zombie", color_white)
killicon.Add("weapon_zs_undead_poisonheadcrab", "killicon/zs_zombie", color_white)
killicon.Add("weapon_zs_zombietorso", "killicon/zs_zombie", color_white)
killicon.Add("weapon_zs_undead_wraith", "killicon/zs_zombie", color_white)
killicon.Add("weapon_zs_undead_infected", "killicon/zs_zombie", color_white)
killicon.Add("weapon_zs_undead_howler", "killicon/zs_zombie", color_white)
killicon.Add("weapon_zs_undead_zombine", "killicon/zs_zombie", color_white)
killicon.Add("weapon_zs_undead_hate", "killicon/zs_zombie", Color(255, 0, 0, 255))
killicon.Add("weapon_zs_undead_hate2", "killicon/zs_zombie", Color(255, 0, 0, 255))
killicon.Add("weapon_zs_undead_behemoth", "killicon/zs_zombie", Color(255, 0, 0, 255))
killicon.Add("weapon_zs_undead_seeker", "killicon/zs_zombie", Color(255, 0, 0, 255))
killicon.Add("weapon_zs_undead_nerf", "killicon/zs_zombie", Color(255, 0, 0, 255))

-- Unowned spit projectile
killicon.AddFont( "projectile_spit", "HL2MPTypeDeath", "~", Color_Icon )

-- Player death icon or others
killicon.AddAlias( "player", "default" )
killicon.AddAlias( "suicide", "default" )

local Deaths = {}

local EntityNames = {
	["func_movelinear"] = "Car Crusher",
	["func_door"] = "Door",
	["func_rotating"] = "Rotating Door",
	["func_physbox"] = "Physics Box",
	["func_rotating"] = "Rotating Object",
	["func_wall"] = "Wall",
	["trigger_hurt"] = "Great Pain",
	["trigger_impact"] = "Heavy Impact",
	["trigger_push"] = "Mystic Force",
	["trigger_teleport"] = "Mystic Force",
	["trigger_waterydeath"] = "Fish",
	["worldspawn"] = "Death Himself",
	["env_laser"] = "Laser",
	["point_hurt"] = "Pain",
	["env_fire"] = "Fire",
	["suicide"] = "Suicidal",
	["env_explosion"] = "Explosion"
}

for k,v in pairs (EntityNames) do
	if k ~= "env_fire" and k ~= "env_laser" and k ~= "env_explosion" then
		killicon.AddAlias (k,"default")
	end
end

-- Override default ones
local Override = function() end
local Table = { "PlayerKilled", "PlayerKilledSelf", "PlayerKilledByPlayer" }
for k,v in pairs ( Table ) do
	usermessage.Hook( v, Override )
end

net.Receive("PlayerKilledByPlayerZS", function( len )
	
	local victim = net.ReadEntity()
	local inflictor = net.ReadString()
	local attacker = net.ReadEntity()
	local victimteam = net.ReadDouble()
	local attackerteam = net.ReadDouble()
	local headshot = tobool(net.ReadBit())
	local assist = net.ReadDouble()
	
	-- Check for assist
	local mAssist, sAssistName = Entity( assist )
	if IsValid( mAssist ) then sAssistName = mAssist:Name() end
	
	gamemode.Call ( "DoPlayerDeath", victim, attacker, inflictor, mAssist )

	if victim:IsValid() and attacker:IsValid() then
		GAMEMODE:AddDeathNotice( attacker:Name(), attackerteam, inflictor, victim:Name(), victimteam, headshot, sAssistName )
		
		-- You are dead, not a big surprise part
		if victim:Name() == MySelf:Name() then
			if attacker.IsPlayer() and attacker:IsPlayer() then
				GAMEMODE:AddCustomDeathNotice ( attacker, inflictor, victim:Name(), sAssistName )
			end
		end
	end
	

end)


local function RecvPlayerKilledByPlayer(message)
	local victim = message:ReadEntity()
	local inflictor = message:ReadString()
	local attacker = message:ReadEntity()
	local victimteam = message:ReadShort()
	local attackerteam = message:ReadShort()
	local headshot = message:ReadBool()
	local assist = message:ReadShort()
	
	-- Check for assist
	local mAssist, sAssistName = Entity( assist )
	if IsValid( mAssist ) then sAssistName = mAssist:Name() end
	
	gamemode.Call ( "DoPlayerDeath", victim, attacker, inflictor, mAssist )

	if victim:IsValid() and attacker:IsValid() then
		GAMEMODE:AddDeathNotice( attacker:Name(), attackerteam, inflictor, victim:Name(), victimteam, headshot, sAssistName )
		
		-- You are dead, not a big surprise part
		if victim:Name() == MySelf:Name() then
			if attacker.IsPlayer() and attacker:IsPlayer() then
				GAMEMODE:AddCustomDeathNotice ( attacker, inflictor, victim:Name(), sAssistName )
			end
		end
	end
end
usermessage.Hook("PlayerKilledByPlayerZS", RecvPlayerKilledByPlayer)

net.Receive("PlayerKilledSelfZS", function( len )
	
	local victim = net.ReadEntity()
	
	gamemode.Call ( "DoPlayerDeath", victim, victim, victim:GetActiveWeapon() )
	
	if victim:IsValid() then
		GAMEMODE:AddDeathNotice( nil, 0, "suicide", victim:Name(), victim:Team() )
		if victim:Name() == MySelf:Name() then
			-- GAMEMODE:AddCustomDeathNotice ( "self", "suicide", victim:Name(), nil )
		end
	end

end)

local function RecvPlayerKilledSelf( message )
	local victim = message:ReadEntity()
	
	gamemode.Call ( "DoPlayerDeath", victim, victim, victim:GetActiveWeapon() )
	
	if victim:IsValid() then
		GAMEMODE:AddDeathNotice( nil, 0, "suicide", victim:Name(), victim:Team() )
		if victim:Name() == MySelf:Name() then
			-- GAMEMODE:AddCustomDeathNotice ( "self", "suicide", victim:Name(), nil )
		end
	end
end
usermessage.Hook("PlayerKilledSelfZS", RecvPlayerKilledSelf)

net.Receive("PlayerRedeemed", function( len )
	
	local pl = net.ReadEntity()
	if pl:IsValid() then
		GAMEMODE:AddDeathNotice( nil, 0, "redeem", pl:Name(), TEAM_HUMAN )
		if pl == MySelf then
			MySelf:Message( "You redeemed! Be careful!" )
			pl:SetAmmoTime ( AMMO_REGENERATE_RATE )
		end
	end
	
	-- Call event
	if IsValid( pl ) then
		gamemode.Call( "OnPlayerRedeem", pl )
	end

end)

local function RecvPlayerRedeemed(message)
	local pl = message:ReadEntity()
	if pl:IsValid() then
		GAMEMODE:AddDeathNotice( nil, 0, "redeem", pl:Name(), TEAM_HUMAN )
		if pl == MySelf then
			MySelf:Message( "You redeemed! Be careful!" )
			pl:SetAmmoTime ( AMMO_REGENERATE_RATE )
		end
	end
	
	-- Call event
	if IsValid( pl ) then
		gamemode.Call( "OnPlayerRedeem", pl )
	end
end
usermessage.Hook("PlayerRedeemed", RecvPlayerRedeemed)

net.Receive("PlayerKilledZS", function( len )
	
	local victim = net.ReadEntity()
	local inflictor = net.ReadString()
	local attacker = net.ReadString()
	
	local mAttacker = ents.FindByClass ( attacker )[1]
	if attacker == "worldspawn" then mAttacker = Entity(0) end
	gamemode.Call ( "DoPlayerDeath", victim, mAttacker, nil )

	for k,v in pairs (EntityNames) do
		if attacker == k then
			attacker = EntityNames[attacker]
			break
		end
	end
	
	if victim:Name() == MySelf:Name() then
		-- GAMEMODE:AddCustomDeathNotice ( attacker, "something", victim:Name(), nil )
	end
	
	GAMEMODE:AddDeathNotice(nil, -1, "random", victim:Name(), victim:Team())

end)

local function RecvPlayerKilled(message)
	local victim = message:ReadEntity()
	local inflictor = message:ReadString()
	local attacker = message:ReadString()
	
	local mAttacker = ents.FindByClass ( attacker )[1]
	if attacker == "worldspawn" then mAttacker = Entity(0) end
	gamemode.Call ( "DoPlayerDeath", victim, mAttacker, nil )

	for k,v in pairs (EntityNames) do
		if attacker == k then
			attacker = EntityNames[attacker]
			break
		end
	end
	
	if victim:Name() == MySelf:Name() then
		-- GAMEMODE:AddCustomDeathNotice ( attacker, "something", victim:Name(), nil )
	end
	
	GAMEMODE:AddDeathNotice(nil, -1, "random", victim:Name(), victim:Team())
end
usermessage.Hook("PlayerKilledZS", RecvPlayerKilled)

local function RecvPlayerKilledNPC(message)
	local victim = "#"..message:ReadString()
	local inflictor = message:ReadString()
	local attacker = message:ReadEntity()

	if attacker:IsValid() then
		GAMEMODE:AddDeathNotice(attacker:Name(), attacker:Team(), inflictor, victim, -1)
	end
end
usermessage.Hook("PlayerKilledNPC", RecvPlayerKilledNPC)

local function RecvNPCKilledNPC(message)
	local victim = "#"..message:ReadString()
	local inflictor = message:ReadString()
	local attacker = "#"..message:ReadString()

	GAMEMODE:AddDeathNotice(attacker, -1, inflictor, victim, -1)
end
usermessage.Hook("NPCKilledNPC", RecvNPCKilledNPC)

function GM:AddDeathNotice(Victim, team1, Inflictor, Attacker, team2, headshot, assist)
   	local Death = {}
	Death.victim 	= 	Victim
	Death.attacker	=	Attacker
	Death.time		=	CurTime()
	
	Death.left		= 	Victim
	Death.right		= 	Attacker
	Death.icon		=	Inflictor
	Death.assist    =   assist
	
	if team1 == -1 then Death.color1 = table.Copy(NPC_Color)
	else Death.color1 = table.Copy( team.GetColor(team1) ) end
		
	if team2 == -1 then Death.color2 = table.Copy(NPC_Color)
	else Death.color2 = table.Copy( team.GetColor(team2) ) end
	
	if Death.left == Death.right then
		Death.left = nil
		Death.icon = "suicide"
	end
	
	Death.headshot = headshot

	table.insert(Deaths, Death)
end

function markup.DoColorText ( sText, Color )
	return "<color="..Color.r..","..Color.g..","..Color.b..","..Color.a..">"..( sText or "" ).."</color>"
end

local function DrawDeath( x, y, death, hud_deathnotice_time )
	local fadeout = ( death.time + hud_deathnotice_time ) - CurTime()

	local alpha = math.Round ( math.Clamp( fadeout * 255, 0, 255 ) )
	death.color1.a = alpha
	death.color2.a = alpha
	
	local tbTranslate = {
		["redeem"] = { "is human again!", "redeemed", "revived", "resurected" },
		["suicide"] = { "wasn't happy enough", "suicided", "went to Hell", "put an end to his misery" },
		["random"] = { "has spread his bones!", "strangely died", "died in mistery!", "is gibs now!" },
	}
	
	-- Killicon size
	local wIcon, hIcon = killicon.GetSize( death.icon )
	local wHeadshot,hHeadshot = killicon.GetSize( "headshot" )
	
	-- Side strings
	local sRightSide, sLeftSide = death.right
	if not death.Message then 
		death.Message = table.Random ( tbTranslate[death.icon] or tbTranslate["random"] ) 
	end
	
	if death.left then 
		if death.assist and death.assist ~= "" then 
			sLeftSide = death.left.." + "..death.assist 
		else 
			sLeftSide = death.left 
		end 
	else 
		sRightSide = sRightSide..markup.DoColorText ( " "..death.Message, Color ( 255,255,255,alpha ) ) 
	end

	-- Markup'd sides
	local sMarkRight, sMarkLeft, sMarkCenter = markup.DoColorText ( sRightSide, death.color2 ), markup.DoColorText ( sLeftSide, death.color1 ), markup.DoColorText ( "finished off", Color ( 255,255,255,alpha ) )
	
	-- Draw markup
	mMarkRight, mMarkLeft, mMarkCenter = markup.Parse( "<font=ChatFont>"..sMarkRight.."</font>" ), markup.Parse( "<font=ChatFont>"..sMarkLeft.."</font>" ), markup.Parse( "<font=ChatFont>"..sMarkCenter.."</font>" ) 
	local wMarkRight, hMarkRight = w * 0.98 - ( mMarkRight:GetWidth() ), y
	if death.headshot then
		wMarkLeft = wMarkRight - (wHeadshot) - ( wIcon * 1.2 ) - ( mMarkLeft:GetWidth() )
	else
		wMarkLeft = wMarkRight - ( wIcon * 1.4 ) - ( mMarkLeft:GetWidth() )
	end
		
	-- Draw victim markup
	if death.icon ~= "player" then
		mMarkRight:Draw( wMarkRight, hMarkRight )
	end
	
	-- Draw attacker w/o assist
	if death.left then 
	
		-- Case where inflictor is player
		if death.icon ~= "player" then
			if death.headshot then	
				killicon.Draw( wMarkRight - ( wHeadshot * 0.8 ), y, "headshot", alpha ) 
				killicon.Draw( wMarkRight - ( wHeadshot * 0.8 ) - ( wIcon * 0.7 ) , y, death.icon, alpha ) 
				mMarkLeft:Draw( wMarkLeft, hMarkRight )
			else
				killicon.Draw( wMarkRight - ( wIcon * 0.7 ), y, death.icon, alpha ) 
				mMarkLeft:Draw( wMarkLeft, hMarkRight )
			end
		else
			local mMarkTotal = markup.Parse( "<font=ChatFont>"..sMarkLeft.." "..sMarkCenter.." "..sMarkRight.."</font>" )
			mMarkTotal:Draw( w * 0.98 - mMarkTotal:GetWidth(), y )
		end
	end

	return y + ( hIcon * 1.4 ) * 0.70
end

function GM:DrawDeathNotice(x, y)
	local hud_deathnotice_time = hud_deathnotice_time:GetFloat()

	x = x * w
	y = y * h

	for k, Death in pairs( Deaths ) do
		if Death.time + hud_deathnotice_time > CurTime() then
			if Death.lerp then
				x = x * 0.3 + Death.lerp.x * 0.7
				y = y * 0.3 + Death.lerp.y * 0.7
			end

			Death.lerp = Death.lerp or {}
			Death.lerp.x = x
			Death.lerp.y = y
		
			y = DrawDeath( x, y, Death, hud_deathnotice_time )
		end
	end

	--  We want to maintain the order of the table so instead of removing
	--  expired entries one by one we will just clear the entire table
	--  once everything is expired.
	for k, Death in pairs(Deaths) do
		if Death.time + hud_deathnotice_time > CurTime() then
			return
		end
	end

	Deaths = {}
end
