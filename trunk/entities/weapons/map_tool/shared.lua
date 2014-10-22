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

	SWEP.PrintName = "Map Tool 2.0"
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
	SWEP.Author	= ""
	SWEP.Slot = 4
	SWEP.SlotPos = 4
	SWEP.Contact = ""
    SWEP.Purpose = ""
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


-- Don't touch this
local EntsToDelete = {}
local PointsTable = {}

SWEP.AmmoBoxTable = {}
SWEP.AmmoBoxTable2 = {}


SWEP.SpawnsTable = {}

function SWEP:Initialize()
	-- Ammo box switch
	self:SetDTBool ( 0, false )
end

local AmmoBoxPoints, BoxSpawnID = {}, 0
function SWEP:SpawnAmmoBox ( Switched )
	local trace = self.Owner:GetEyeTrace()
	
	local pos = trace.HitPos
	
	local ent = ents.Create ( "prop_physics_multiplayer" )
	ent:SetPos ( pos + vector_up*25 )
	ent:SetAngles(Angle(0,(Switched and 90 or 0),90))
	ent:SetModel ( "models/props_interiors/VendingMachineSoda01a.mdl" )
	ent:SetColor (Color(0,255,0,200))
	ent:SetMaterial("models/debug/debugwhite")
	-- ent:SetCollisionGroup ( COLLISION_GROUP_DEBRIS )
	ent.CrateDummy = true
	-- ent.CrateIndex = #self.AmmoBoxTable+1
	ent:Spawn()
	
	
	
	-- print("Spawning Crate index: "..ent.CrateIndex)

	local Phys = ent:GetPhysicsObject()
	if IsValid ( Phys ) then
		Phys:EnableMotion ( false )
	end
	
	--[==[local ent = ents.Create ( "game_supplycrate" )
	ent.Switch = Switched
	ent:SetPos ( pos )
	ent:Spawn()	]==]

	local PosTableSupply = { Pos = {trace.HitPos.x,trace.HitPos.y,trace.HitPos.z},Switch = Switched }
	-- self.AmmoBoxTable2[#self.AmmoBoxTable+1] = ent
	-- self.AmmoBoxTable[ent.CrateIndex] = PosTableSupply
	table.insert ( self.AmmoBoxTable2, ent )
	table.insert ( self.AmmoBoxTable, PosTableSupply )
	print("Added-------------------------")
	PrintTable(self.AmmoBoxTable)
end

function SWEP:RemoveAmmoBox(ent)
	
	-- local ind = ent.CrateIndex
	
	local ind = 0
	
	for i,crate in pairs(self.AmmoBoxTable2) do
		if crate == ent then
			ind = i
		end
	end
	
	print("Removing Crate index: "..ind)
	
	ent:Remove()
	
	self.AmmoBoxTable2[ind] = nil
	self.AmmoBoxTable[ind] = nil
	
	table.Resequence ( self.AmmoBoxTable )
	table.Resequence ( self.AmmoBoxTable2 )
	
	print("Removed-------------------------")
	PrintTable(self.AmmoBoxTable)
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

local SwitchTimer = 0
function SWEP:Think()

end

--[==[---------------------------------------------------------------------------------
       Saves Ammo Box Locations from the developer tool - don't touch!
----------------------------------------------------------------------------------]==]
local function SaveAmmoPoints ( pl, cmd, args )
	if not pl:IsAdmin() then return end
	
	local filename = "zombiesurvival/crates/".. game.GetMap() ..".txt"
	
	local Tool = pl:GetWeapon ( "map_tool" )
	if Tool == nil then return end
		
	file.Write( filename,util.TableToJSON(Tool.AmmoBoxTable or {}) )
end
if SERVER then concommand.Add( "dev_savesupplies", SaveAmmoPoints ) end

function SWEP:Reload()
	if self.NextReload > CurTime() then return end
	
	if CLIENT then		
			gui.EnableScreenClicker ( true )
			Derma_Query("Are you sure you want to save current Ammo Box positions to file?", "Warning!","Yes", function() RunConsoleCommand( "dev_savesupplies" ) timer.Simple ( 0.2, function () Derma_Query("You have saved the ammo spawnpoints to gmod/data/ammolocations/mapname.txt", "Way to go!","Continue", function() gui.EnableScreenClicker ( false ) end ) end) end, "No", function() gui.EnableScreenClicker ( false ) end)
	end
	
	self.NextReload = CurTime() + 3
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if SERVER then
		local tr = self.Owner:GetEyeTrace()
		local HitPos, Ent = tr.HitPos + tr.HitNormal * 16, tr.Entity 
		
		if Ent and IsValid(Ent) and Ent.CrateDummy then
			self:RemoveAmmoBox(Ent)
		else
			self:SpawnAmmoBox ( self:GetDTBool ( 0 ) )
		end
		
		-- Weapon animation
		self.Weapon:SendWeaponAnim ( ACT_VM_PRIMARYATTACK )
	end
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	
	if SERVER then
		
		self:SetDTBool ( 0 , not self:GetDTBool ( 0 ) ) 
	
	end
		
end

if CLIENT then
	function SWEP:DrawHUD()
	end
end

function SWEP:Holster( weapon )
	return true
end 

function SWEP:OwnerChanged ( Owner )

end

function SWEP:Deploy()

	if SERVER then
		local owner = self.Owner
		local effectdata = EffectData()
		effectdata:SetEntity(owner)
		effectdata:SetOrigin(owner:GetShootPos() + owner:GetAimVector() * 32)
		util.Effect("map_crate_ghost", effectdata, true, true)
		
	end
	
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	return true
end 