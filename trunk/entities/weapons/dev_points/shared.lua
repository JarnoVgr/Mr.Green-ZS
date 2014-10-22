-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "pistol"	
end

SWEP.ViewModel	= Model ( "models/weapons/v_toolgun.mdl" )
SWEP.WorldModel	= Model ( "models/weapons/w_toolgun.mdl" )

SWEP.Spawnable = false
SWEP.AdminSpawnable	= true

if CLIENT then

	SWEP.PrintName = "Developer Tool"
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
	SWEP.Author	= "Deluvas"
	SWEP.Slot = 4
	SWEP.SlotPos = 4
	SWEP.Contact = ""
    SWEP.Purpose = "Developer Tool for Mr Green ZS"
    SWEP.Instructions = ""
end

SWEP.Primary.ClipSize = -1
SWEP.Primary.Damage = 0
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 0.01
SWEP.NextReload = 3

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo	= "none"
SWEP.Secondary.Delay = 0.01

SWEP.Primary.Sound = Sound( "buttons/button15.wav" )
SWEP.Instruction = { 
	[1] = { "Left click to place spawn point for weapon/ Right click to delete it", "To save the points to file, press RELOAD and confirm" },
	[2] = { "Left click to remove an entity", "To save the map with deleted entities, press RELOAD" },
	[3] = { "Left click to add an ammo box entity/ Right click to delele it. Press Zoom button to rotate." , "To save the map with Ammo Box entities, press RELOAD" },
	[4] = { "Left click to add a custom zombie spawn" , "Right click to delete nearby spawns. To save the map with new spawnpoints, press RELOAD" },
}

-- Don't touch this
local EntsToDelete = {}
local PointsTable = {}
SWEP.AmmoBoxTable = {}
SWEP.SpawnsTable = {}

function SWEP:Initialize()

	-- Tool mode
	self:SetNetworkedInt ( "Mode", 1 )
	
	-- Ammo box switch
	self:SetDTBool ( 0, false )
end

local AmmoBoxPoints, BoxSpawnID = {}, 0
function SWEP:SpawnAmmoBox ( Switched )
	local trace = self.Owner:GetEyeTrace()
	
	local pos = trace.HitPos
	local ent = ents.Create ( "game_supplycrate" )
	ent.Switch = Switched
	ent:SetPos ( pos )
	ent:Spawn()	
	
	-- Increment that shit
	BoxSpawnID = BoxSpawnID + 1
	
	-- Set the ent's number so we know what to delete
	ent.BoxSpawnID = BoxSpawnID
		
	-- Notify the dev
	local PosTableSupply = { X = trace.HitPos.x, Y = trace.HitPos.y, Z = trace.HitPos.z, ID = BoxSpawnID, Switch = Switched }
	self.Owner:PrintMessage ( HUD_PRINTTALK, "You have created box with spawn number "..BoxSpawnID)
		
	table.insert ( self.AmmoBoxTable, PosTableSupply )
end


function SWEP:MakeZombieSpawn ()
	
	local pos = self.Owner:GetPos()
	local ang = self.Owner:GetAngles()
	-- Notify the dev
	local SpawnPos = { pos, ang}
	self.Owner:PrintMessage ( HUD_PRINTTALK, "You have created zombie spawn!")
	if SERVER then	
	table.insert ( SpawnPoints, SpawnPos )
	for k,v in ipairs ( SpawnPoints ) do
			umsg.Start( "umsg_spawns_update", self.Owner )
				umsg.Bool( ( k == 1 ) )
				umsg.Short( k )
				umsg.Vector( v[1])
				umsg.Angle( v[2] )
			umsg.End()
	end
	end
end

if CLIENT then
	usermessage.Hook( "umsg_spawns_update", function( msg )
		local First = msg:ReadBool()
		if ( First ) then
			SpawnPoints = {}
		end
		
		local Index = msg:ReadShort()
		local Pos = msg:ReadVector()
		local Ang = msg:ReadAngle()
		
		SpawnPoints[Index] = {Pos,Ang}
	end )
	
	usermessage.Hook( "umsg_spawns_clear", function( msg )
			SpawnPoints = {}
	end )
	
end


-- Hacky way to update weapon slot count
function SWEP:Equip ( NewOwner )
	if SERVER then
		local EntClass = self:GetClass()
		local PrintName = self.PrintName or "weapon"
		if NewOwner:IsPlayer() then
			if NewOwner:Team() == TEAM_HUMAN then
				local category = WeaponTypeToCategory[ self:GetType() ]
				NewOwner.CurrentWeapons[ category ] = NewOwner.CurrentWeapons[ category ] + 1
				WeaponPickupNotify ( NewOwner, PrintName )				
			end
		end
	end
end

local SpawnID = 0
function SWEP:SpawnWeapon ( HitPos )
	local ent = ents.Create ( "prop_physics_multiplayer" )
	ent:SetPos ( HitPos )
	ent:SetModel ( "models/weapons/w_rif_m4a1.mdl" )
	ent:SetCollisionGroup ( COLLISION_GROUP_DEBRIS )
	ent:Spawn()

	local Phys = ent:GetPhysicsObject()
	if IsValid ( Phys ) then
		Phys:EnableMotion ( false )
	end
	
	SpawnID = SpawnID + 1
	ent.SpawnID = SpawnID
	
	local PosTable = { X = HitPos.x, Y = HitPos.y, Z = HitPos.z, ID = SpawnID  }
	self.Owner:PrintMessage ( HUD_PRINTTALK, "You have created weapon with spawn number "..SpawnID)
		
	table.insert ( PointsTable, PosTable )
end

function SWEP:RemoveAmmoBoxFromTable( ent )
	local vPos = ent:GetPos()
	local x,y,z = vPos.x, vPos.y, vPos.z
	
	-- Find the box ID in the spawn points table and remove it
	for id, tab in pairs ( self.AmmoBoxTable ) do
		for cord,val in pairs ( tab ) do
			if self.AmmoBoxTable[id]["ID"] == ent.BoxSpawnID then
				self.AmmoBoxTable[id] = nil
				self.Owner:PrintMessage ( HUD_PRINTTALK, "You have removed box with spawn number "..ent.BoxSpawnID)
				break
			end
		end		
	end
	
	ent:Remove()
end

local SwitchTimer = 0
function SWEP:Think()
	local Owner = self.Owner
	local MaxModes, Message = 4
	
	-- Change angle for ammo box
	if Owner:KeyPressed ( IN_ZOOM ) then
		self:SetDTBool ( 0 , not self:GetDTBool ( 0 ) ) 
		
		return
	end
	
	-- Change the tool mode on space press
	if Owner:KeyPressed ( IN_USE ) then
		if SwitchTimer > CurTime() then return end
		local Mode = self:GetNetworkedInt ( "Mode" )		
		
		if Mode <= MaxModes then
			Mode = Mode + 1
		end
				
		if Mode > MaxModes then
			Mode = 1
		end
		
		-- Hacky way to set it:)
		self:SetNetworkedInt ( "Mode", Mode )
		
		-- Make it smooth
		SwitchTimer = CurTime() + 0.3
		
		return
	end
end

local function SaveWeaponPoints ( pl, cmd, args )
	if not pl:IsSuperAdmin() then return end
	if CLIENT then return end
	
	local locpath = "zslocations/".. game.GetMap() ..".txt"
	local content = "-- File generated by the Mr. Green ZS location saver\n-- www.left4green.com - www.mr-green.nl\n"
	
	for id, table in pairs ( PointsTable ) do
		for cord, val in pairs ( table ) do
			if cord ~= "ID" then
				content = content .."\ntable.insert( DropPoints"..cord..",\"".. tostring(val) .."\" ) -- inserted by "..pl:Name()
			end
		end
	end
	
	file.Write( locpath, content )
end
concommand.Add( "dev_saveweaponpoints", SaveWeaponPoints )

--[==[---------------------------------------------------------------------------------
       Saves Ammo Box Locations from the developer tool - don't touch!
----------------------------------------------------------------------------------]==]
local function SaveAmmoPoints ( pl, cmd, args )
	if not pl:IsSuperAdmin() then return end
	
	local locpath = "ammoboxlocations/".. game.GetMap() ..".txt"
	local content = "-- File generated by the Mr. Green ZS Ammo Box saver\n-- www.left4green.com - www.mr-green.nl\n print ("..[["-++++++ Loaded Ammo Box Spawn Points for this map  -+++++++"]]..")\n"
	
	local Tool = pl:GetWeapon ( "dev_points" )
	if Tool == nil then return end
	
	for id, tab in pairs ( Tool.AmmoBoxTable ) do
		for cord, val in pairs ( tab ) do
			content = content .."\ntable.insert( AmmoDropPoints."..cord..",\"".. tostring(val) .."\" ) -- inserted by "..pl:Name()
		end
	end
	
	file.Write( locpath, content )
end
if SERVER then concommand.Add( "dev_savesupply", SaveAmmoPoints ) end

local function SaveDeletedEntites ( pl, cmd, args )
	if not pl:IsSuperAdmin() then return end
	
	local locpath = "zslocations/"..game.GetMap().." (ENT_DELETE).txt"
	local content = "-- File generated by the Mr. Green ZS dev tool\n-- www.left4green.com - www.mr-green.nl\n"
	
	for id, table in pairs ( EntsToDelete ) do
		content = content .."\ntable.insert( EntsToDelete,\"".. tostring(table) .."\" ) -- inserted by "..pl:Name()
	end
	
	file.Write( locpath, content )
end
concommand.Add( "dev_savedeletedentities", SaveDeletedEntites )

local function SaveZombieSpawn ( pl, cmd, args )
	if not pl:IsSuperAdmin() then return end
	
	local locpath = "zszombiepoints/"..game.GetMap()..".txt"
	
	if #SpawnPoints <= 0 then 
		if file.Exists( locpath ) then
			file.Delete( locpath )
		end
		
		return 
	end
	
	local content = "-- File generated by the Mr. Green ZS Automatic Spawn Generation Mechanism by Deluvas, edited by NECROSSIN\n-- www.left4green.com - www.mr-green.nl\n"
	content = content.." SpawnPoints = {}\n"
	local Tool = pl:GetWeapon ( "dev_points" )
	if Tool == nil then return end
	
	for k,v in pairs ( SpawnPoints ) do
		content = content.."table.insert ( SpawnPoints, { Vector("..( v[1].x )..","..( v[1].y )..","..( v[1].z ).."), Angle("..( v[2].p )..","..( v[2].y )..","..( v[2].r )..") } ) \n"
	end
	
	file.Write( locpath, content )
end
if SERVER then concommand.Add( "dev_savezspawn", SaveZombieSpawn ) end

function SWEP:Reload()
	if self.NextReload > CurTime() then return end
	
	if CLIENT then
		if self:GetNetworkedInt ( "Mode" ) == 1 then
			gui.EnableScreenClicker ( true )
			Derma_Query("Are you sure you want to save the current weapons to spawnpoint file?", "Warning!","Yes", function() RunConsoleCommand( "dev_saveweaponpoints" ) timer.Simple ( 0.2, function () Derma_Query("You have saved the points to gmod/data/zslocations/mapname.txt", "Way to go!","Continue", function() gui.EnableScreenClicker ( false ) end ) end) end, "No", function() gui.EnableScreenClicker ( false ) end)
		end
		
		if self:GetNetworkedInt ( "Mode" ) == 2 then
			gui.EnableScreenClicker ( true )
			Derma_Query("Are you sure you want to save deleted entities to file?", "Warning!","Yes", function() RunConsoleCommand( "dev_savedeletedentities" ) timer.Simple ( 0.2, function () Derma_Query("You have saved the deleted entites gmod/data/zslocations/mapname(ENT_DELETED).txt", "Way to go!","Continue", function() gui.EnableScreenClicker ( false ) end ) end) end, "No", function() gui.EnableScreenClicker ( false ) end)
		end
		
		if self:GetNetworkedInt ( "Mode" ) == 3 then
			gui.EnableScreenClicker ( true )
			Derma_Query("Are you sure you want to save current Ammo Box positions to file?", "Warning!","Yes", function() RunConsoleCommand( "dev_savesupply" ) timer.Simple ( 0.2, function () Derma_Query("You have saved the ammo spawnpoints to gmod/data/ammolocations/mapname.txt", "Way to go!","Continue", function() gui.EnableScreenClicker ( false ) end ) end) end, "No", function() gui.EnableScreenClicker ( false ) end)
		end
		
		if self:GetNetworkedInt ( "Mode" ) == 4 then
			gui.EnableScreenClicker ( true )
			Derma_Query("Are you sure you want to save current zombie spawnpoints to file?", "Warning!","Yes", function() RunConsoleCommand( "dev_savezspawn" ) timer.Simple ( 0.2, function () Derma_Query("You have saved the zombie spawnpoints to gmod/data/zslocations/mapname.txt", "Way to go!","Continue", function() gui.EnableScreenClicker ( false ) end ) end) end, "No", function() gui.EnableScreenClicker ( false ) end)
		end
	end
	
	self.NextReload = CurTime() + 3
end

function SWEP:RemoveWeaponFromTable( weapon )
	local vPos = weapon:GetPos()
	local x,y,z = vPos.x, vPos.y, vPos.z
	
	-- Find the weapon ID in the spawn points table and remove it
	for id, table in pairs ( PointsTable ) do
		for cord,val in pairs ( table ) do
			if PointsTable[id]["ID"] == weapon.SpawnID then
				PointsTable[id] = nil
				self.Owner:PrintMessage ( HUD_PRINTTALK, "You have removed weapon with spawn number "..weapon.SpawnID)
				break
			end
		end		
	end

	-- Remove the entity
	weapon:Remove()
end

function SWEP:RemoveEntity ( Ent )
	if CLIENT then return end
	if Ent:IsPlayer() then return end
	if not IsValid ( Ent ) then return end

	-- Grav the ent index
	local EntIndex = tostring(Ent)
	
	-- Insert the ent's index to the table
	table.insert ( EntsToDelete, EntIndex )

	-- Make it not solid eventually
	Ent:SetNotSolid( true )
	Ent:SetMoveType( MOVETYPE_NONE )
	Ent:SetNoDraw( true )
	
	-- Remove it
	Ent:Remove()
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if SERVER then
		local tr = self.Owner:GetEyeTrace()
		local HitPos, Ent = tr.HitPos + tr.HitNormal * 16, tr.Entity 
		local Mode = self:GetNetworkedInt ( "Mode" )	
		
		-- Case 1: Add spawn poit for weapons
		if Mode == 1 then
			self:SpawnWeapon( HitPos )
		end
		
		-- Case 2: Remove entities and save the configuration to file
		if Mode == 2 then
			self:RemoveEntity ( Ent )				
		end
		
		-- Case 3: Add ammo boxes 
		if Mode == 3 then
			self:SpawnAmmoBox ( self:GetDTBool ( 0 ) )
		end
		
		if Mode == 4 then
			self:MakeZombieSpawn()
		end
		
		-- Weapon animation
		self.Weapon:SendWeaponAnim ( ACT_VM_PRIMARYATTACK )
	end
	
	if CLIENT then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	local tokeep = {}
	if SERVER then
		local tr = self.Owner:TraceLine( 1000, MASK_SHOT )
		local Ent = tr.Entity
		local Mode = self:GetNetworkedInt ( "Mode" )
		
		-- Case 1 : Delete weapon points
		if Mode == 1 then
			if IsValid ( Ent ) and Ent.SpawnID then
				self:RemoveWeaponFromTable( Ent )
				self.Weapon:EmitSound ( self.Primary.Sound )
				self.Weapon:SendWeaponAnim ( ACT_VM_PRIMARYATTACK )
			end
		end
		
		-- Case 3: Delete ammo crates
		if Mode == 3 then
			if IsValid ( Ent ) and Ent.BoxSpawnID then
				self:RemoveAmmoBoxFromTable( Ent )
				self.Weapon:EmitSound ( self.Primary.Sound )
				self.Weapon:SendWeaponAnim ( ACT_VM_PRIMARYATTACK )
			end
		end
		if Mode == 4 then
			if #SpawnPoints <= 0 then 
				self.Owner:ChatPrint( "-- You haven't placed any spawns yet! --" )
			end
			
		local count = 0

		
		for k, v in pairs( SpawnPoints ) do
			if v[1]:Distance( self.Owner:GetPos()) < 108 then
				count = count + 1
			else
				table.insert( tokeep,v )
			end
		end
		
		SpawnPoints = tokeep
		
		for k,v in ipairs ( SpawnPoints ) do
			umsg.Start( "umsg_spawns_update", self.Owner )
				umsg.Bool( ( k == 1 ) )
				umsg.Short( k )
				umsg.Vector( v[1])
				umsg.Angle( v[2] )
			umsg.End()
		end
		
		if #SpawnPoints == 0 then -- i dont want to rewrite full code into shared type so lets make it quick and nice
		umsg.Start( "umsg_spawns_clear", self.Owner )
		umsg.End()
		end
		
		if count == 0 then
			self.Owner:ChatPrint( "-- No spawns nearby! --" )
		else
			self.Owner:ChatPrint( "-- Deleted "..count.." nearby spawn(s) --" )
		end
		
	end
				self.Weapon:EmitSound ( self.Primary.Sound )
				self.Weapon:SendWeaponAnim ( ACT_VM_PRIMARYATTACK )
		
		end

	
	if CLIENT then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
end

if CLIENT then
	function SWEP:DrawHUD()
		if not MySelf:Alive() then return end
		if ENDROUND then return end
		
		local Mode = self:GetNetworkedInt ( "Mode" )
		local spawnlist = table.Copy( SpawnPoints )
		-- First description and aditional (2 lines)
		local AditionalDesc = self.Instruction[Mode][2]	
		local Description = "Mode Description: "..self.Instruction[Mode][1]
		if Mode == 3 then
			Description = Description..". Switch is: "..tostring( self:GetDTBool ( 0 ) )
		elseif Mode == 2 then
			local tr = MySelf:GetEyeTrace()
			if tr.Hit and tr.Entity and not tr.HitWorld then
				Description = Description..". Entity is: "..tostring( tr.Entity:GetModel() )
			end
		elseif Mode == 4 then
			Description = Description..". Amount of spawns: "..tonumber(#SpawnPoints)
		end
		
		-- Get text size
		surface.SetFont ( "ArialNine" )
		local DescWide, _ = surface.GetTextSize ( Description )
		local AdDescWide, _ = surface.GetTextSize ( AditionalDesc )
		
		-- Draw the box
		local BoxWide = math.max ( DescWide, AdDescWide ) + ScaleW(50)
		draw.RoundedBox ( 8, ScaleW(673) - BoxWide * 0.5, ScaleH(761) - ScaleH(117) * 0.5, BoxWide, ScaleH(117), Color ( 1,1,1,180 ) )
		
		draw.SimpleText ( "Tool Mode: "..Mode.." (Change mode by pressing USE)","ArialNine",ScaleW(673),ScaleH(726), Color ( 240,240,240,255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText ( Description ,"ArialNine",ScaleW(673),ScaleH(756), Color ( 240,240,240,255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText ( AditionalDesc ,"ArialNine",ScaleW(673),ScaleH(788), Color ( 240,240,240,255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		-- Draw our spawns
		if Mode == 4 then
		
			for k, v in pairs(SpawnPoints) do
			low = v[1]:ToScreen()
			top = (v[1] + Vector(0,0,90)):ToScreen()
			one = (v[1] + Vector(15,0,0)):ToScreen()
			oneend = (v[1] - Vector(15,0,0)):ToScreen()
			two = (v[1] + Vector(0,15,0)):ToScreen()
			twoend = (v[1] - Vector(0,15,0)):ToScreen()
			if v[1]:Distance( self.Owner:GetPos()) < 108 then
			surface.SetDrawColor( Color( math.cos(RealTime() * 5) * 127.5 + 127.5,math.sin(RealTime() * 5) * 127.5 + 127.5,30 ) ) -- highlight spawns that we can delete
			else
			surface.SetDrawColor( Color( 0,255,0 ) )
			end
			surface.DrawLine(low.x,low.y,top.x,top.y)
			--Draw a small cross on the ground
			surface.DrawLine(one.x,one.y,oneend.x,oneend.y)
			surface.DrawLine(two.x,two.y,twoend.x,twoend.y)
					
			end
		end
	end
end

function SWEP:Holster( weapon )
	return true
end 

function SWEP:OwnerChanged ( Owner )
	self:SetNetworkedInt ( "Mode", 1 )
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	SpawnPoints = SpawnPoints or {}
	if SERVER then
		for k,v in ipairs ( SpawnPoints ) do
			umsg.Start( "umsg_spawns_update", self.Owner )
				umsg.Bool( ( k == 1 ) )
				umsg.Short( k )
				umsg.Vector( v[1])
				umsg.Angle( v[2] )
			umsg.End()
	end
	end
	return true
end 