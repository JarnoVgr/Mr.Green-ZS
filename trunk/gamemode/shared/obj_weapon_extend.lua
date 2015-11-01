-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local table = table
local math = math
local string = string
local util = util
local pairs = pairs
local team = team
local player = player
local timer = timer
local ents = ents

local meta = FindMetaTable("Weapon")
if not meta then return end

function meta:GetNextPrimaryFire()
	return self.m_NextPrimaryFire or 0
end

function meta:GetNextSecondaryFire()
	return self.m_NextSecondaryFire or 0
end

meta.OldSetNextPrimaryFire = meta.SetNextPrimaryFire
function meta:SetNextPrimaryFire(fTime)
	self.m_NextPrimaryFire = fTime
	self:OldSetNextPrimaryFire(fTime)
end

meta.OldSetNextSecondaryFire = meta.SetNextSecondaryFire
function meta:SetNextSecondaryFire(fTime)
	self.m_NextSecondaryFire = fTime
	self:OldSetNextSecondaryFire(fTime)
end

function meta:SetNextReload(fTime)
	self.m_NextReload = fTime
end

function meta:GetNextReload()
	return self.m_NextReload or 0
end

function meta:TakeCombinedPrimaryAmmo(amount)
	local ammotype = self.Primary.Ammo
	local owner = self.Owner
	local clip = self:Clip1()
	local reserves = owner:GetAmmoCount(ammotype)

	amount = math.min(reserves + clip, amount)

	local fromreserves = math.min(reserves, amount)
	if fromreserves > 0 then
		amount = amount - fromreserves
		self.Owner:RemoveAmmo(fromreserves, ammotype)
	end

	local fromclip = math.min(clip, amount)
	if fromclip > 0 then
		self:SetClip1(clip - fromclip)
	end
end

function meta:TakeCombinedSecondaryAmmo(amount)
	local ammotype = self.Secondary.Ammo
	local owner = self.Owner
	local clip = self:Clip2()
	local reserves = owner:GetAmmoCount(ammotype)

	amount = math.min(reserves + clip, amount)

	local fromreserves = math.min(reserves, amount)
	if fromreserves > 0 then
		amount = amount - fromreserves
		self.Owner:RemoveAmmo(fromreserves, ammotype)
	end

	local fromclip = math.min(clip, amount)
	if fromclip > 0 then
		self:SetClip2(clip - fromclip)
	end
end

local TranslatedAmmo = {}
TranslatedAmmo[-1] = "none"
TranslatedAmmo[0] = "none"
TranslatedAmmo[1] = "ar2"
TranslatedAmmo[2] = "alyxgun"
TranslatedAmmo[3] = "pistol"
TranslatedAmmo[4] = "smg1"
TranslatedAmmo[5] = "357"
TranslatedAmmo[6] = "xbowbolt"
TranslatedAmmo[7] = "buckshot"
TranslatedAmmo[8] = "rpg_round"
TranslatedAmmo[9] = "smg1_grenade"
TranslatedAmmo[10] = "sniperround"
TranslatedAmmo[11] = "sniperpenetratedround"
TranslatedAmmo[12] = "grenade"
TranslatedAmmo[13] = "thumper"
TranslatedAmmo[14] = "gravity"
TranslatedAmmo[14] = "battery"
TranslatedAmmo[15] = "gaussenergy"
TranslatedAmmo[16] = "combinecannon"
TranslatedAmmo[17] = "airboatgun"
TranslatedAmmo[18] = "striderminigun"
TranslatedAmmo[19] = "helicoptergun"
TranslatedAmmo[20] = "ar2altfire"
TranslatedAmmo[21] = "slam"

function meta:GetPrimaryAmmoTypeString()
	if self.Primary and self.Primary.Ammo then return self.Primary.Ammo end
	return TranslatedAmmo[self:GetPrimaryAmmoType()] or "none"
end

function meta:GetSecondaryAmmoTypeString()
	if self.Secondary and self.Secondary.Ammo then return self.Secondary.Ammo end
	return TranslatedAmmo[self:GetSecondaryAmmoType()] or "none"
end

--[==[---------------------------------------------------------------
        Returns weapon type ( only for bullet weapons )
---------------------------------------------------------------]==]
function GetWeaponTypeByAmmo ( Type ) 
	if Type == nil then return end

	-- Translation table
	local Table, WeaponType = { Pistol = { "pistol", "alyxgun", "357" }, Automatic = { "smg1", "ar2", "xbowbolt", "buckshot", "ar2altfire", "slam", "rpg_round", "smg1_grenade", "sniperround", "sniperpenetratedround", "grenade", "thumper", "battery", "gravity", "gaussenergy", "combinecannon", "airboatgun", "striderminigun","helicoptergun" } }
	for k,v in pairs ( Table ) do
		for i, j in pairs ( v ) do
			if Type == j then
				WeaponType = k
			end
		end
	end
	
	return WeaponType or "Automatic"
end

--[==[---------------------------------------------------------------
        Used to get the dps of a weapon - String input
---------------------------------------------------------------]==]
function GetWeaponDPS ( class )
	if class == nil then return 0 end
	
	if GAMEMODE.HumanWeapons[ class ] == nil then return 0 end
	return GAMEMODE.HumanWeapons[ class ].DPS
end

--[==[---------------------------------------------------------------
        Returns the category of a weapon ( slot name )
---------------------------------------------------------------]==]
function GetWeaponCategory ( class )
	if class == nil then return end
	
	-- We need the weapon type first
	local Type = GetWeaponType(class)
	
	-- Type error
	if Type == "none" or Type == nil then return end
	--print(Type)	-- tool types
	-- Get category
	local strCategory = WeaponTypeToCategory[Type]
	--print("category")
	--print(strCategory)	
	return strCategory
end

function GetWeaponClass ( weapon )
--print("weapon")
	--print(weapon)
	if weapon == nil then return end
	local class = GetWeaponWhatClass(weapon)
	--print("class")
	--print(class)
	if class == "none" or class == nil then return end
	local strCategory = WeaponClassToCategory[class]
	return strCategory
end

--[==[---------------------------------------------------------------------
        Used to get the type (string) of a weapon - String input
-----------------------------------------------------------------------]==]
function GetWeaponType ( class ) 
	if class == nil then return "none" end

	if GAMEMODE.HumanWeapons[ class ] == nil then return "none" end
	return GAMEMODE.HumanWeapons[ class ].Type
end

function GetWeaponWhatClass ( weapon ) 

	if GAMEMODE.HumanWeapons[ weapon ] == nil then return "none" end

	return GAMEMODE.HumanWeapons[weapon].HumanClass
end

--[==[---------------------------------------------------------
        Used to get the type (string) of a weapon
---------------------------------------------------------]==]
function meta:GetType()
	if not IsValid ( self ) then return "none" end                          

	local name = tostring ( self:GetClass() )
		
	if GAMEMODE.HumanWeapons[ name ] == nil then return "none" end
	
	return GAMEMODE.HumanWeapons[ name ].Type
end

function meta:GetWhatClass()
	if not IsValid ( self ) then return "none" end                          

	local name = tostring ( self:GetClass() )
		
	if GAMEMODE.HumanWeapons[ name ] == nil then return "none" end
	return GAMEMODE.HumanWeapons[ name ].HumanClass
end

--[==[---------------------------------------------------------------------
          Use this to set the color of a weapon viewmodel
----------------------------------------------------------------------]==]
function meta:SetViewModelColor ( col )
	if SERVER then return end
	if not IsValid ( MySelf ) then return end
	
	-- Get Viewmodel
	local ViewModel = MySelf:GetViewModel()
	if not IsValid ( ViewModel ) then return end

	-- Set color
	ViewModel:SetColor ( col ) 
end

function meta:GetPrimaryAmmoCount()
	return self.Owner:GetAmmoCount(self.Primary.Ammo) + self:Clip1()
end

function meta:GetSecondaryAmmoCount()
	return self.Owner:GetAmmoCount(self.Secondary.Ammo) + self:Clip2()
end

-- Moving all shit here


PlayerModelBones = {}

-- hands and such



--Right hand-------------
PlayerModelBones["ValveBiped.Bip01_L_Clavicle"] 	= {Arm = true}
PlayerModelBones["ValveBiped.Bip01_L_UpperArm"]		= {Arm = true}

PlayerModelBones["ValveBiped.Bip01_L_Forearm"] 		= {CSSBone = "v_weapon.Left_Arm",IWBone = "L_Forearm",Arm = true,CSSScale = Vector(0.72, 0.72, 0.72),CSSTranslate = Vector(--[=[-1]=]0,0,0),CSSAngle = Angle(0,0,155)}-- CSSAngle = Angle(0,0,180) Vector(0.82, 0.82, 0.82)
PlayerModelBones["ValveBiped.Bip01_L_Hand"] 		= {CSSBone = "v_weapon.Left_Hand",IWBone = "L_Wrist", CSSScale = Vector(0.68, 0.68, 0.68),CSSAngle = Angle(0,0,90),CSSTranslate = Vector(-0.13,0,0)}-- v_weapon.Left_Hand
--Fingers
PlayerModelBones["ValveBiped.Bip01_L_Finger4"] 		= {CSSBone = "v_weapon.Left_Pinky01",IWBone = "L_Pinky1",Finger = true,CSSAngle=Angle(0,-30,0)}
PlayerModelBones["ValveBiped.Bip01_L_Finger41"] 	= {CSSBone = "v_weapon.Left_Pinky02",IWBone = "L_Pinky2",Finger = true,CSSAngle=Angle(0,-40,0)}
PlayerModelBones["ValveBiped.Bip01_L_Finger42"] 	= {CSSBone = "v_weapon.Left_Pinky03",IWBone = "L_Pinky3",Finger = true,CSSAngle=Angle(0,-40,0)}
PlayerModelBones["ValveBiped.Bip01_L_Finger3"] 		= {CSSBone = "v_weapon.Left_Ring01",IWBone = "L_Ring1",Finger = true,CSSAngle=Angle(0,-30,0)}
PlayerModelBones["ValveBiped.Bip01_L_Finger31"] 	= {CSSBone = "v_weapon.Left_Ring02",IWBone = "L_Ring2",Finger = true,CSSAngle=Angle(0,-40,0)}
PlayerModelBones["ValveBiped.Bip01_L_Finger32"] 	= {CSSBone = "v_weapon.Left_Ring03",IWBone = "L_Ring3",Finger = true,CSSAngle=Angle(0,-40,0)}
PlayerModelBones["ValveBiped.Bip01_L_Finger2"] 		= {CSSBone = "v_weapon.Left_Middle01",IWBone = "L_Mid1",Finger = true,CSSAngle=Angle(0,-30,0)}
PlayerModelBones["ValveBiped.Bip01_L_Finger21"] 	= {CSSBone = "v_weapon.Left_Middle02",IWBone = "L_Mid2",Finger = true,CSSAngle=Angle(0,-40,0)}
PlayerModelBones["ValveBiped.Bip01_L_Finger22"] 	= {CSSBone = "v_weapon.Left_Middle03",IWBone = "L_Mid3",Finger = true,CSSAngle=Angle(0,-40,0)}
PlayerModelBones["ValveBiped.Bip01_L_Finger1"] 		= {CSSBone = "v_weapon.Left_Index01",IWBone = "L_Index1",Finger = true,CSSAngle=Angle(0,-30,0)}
PlayerModelBones["ValveBiped.Bip01_L_Finger11"] 	= {CSSBone = "v_weapon.Left_Index02",IWBone = "L_Index2",Finger = true,CSSAngle=Angle(0,-40,0)}
PlayerModelBones["ValveBiped.Bip01_L_Finger12"] 	= {CSSBone = "v_weapon.Left_Index03",IWBone = "L_Index3",Finger = true,CSSAngle=Angle(0,-40,0)}
PlayerModelBones["ValveBiped.Bip01_L_Finger0"] 		= {CSSBone = "v_weapon.Left_Thumb01",IWBone = "L_Thumb1",Finger = true,CSSAngle=Angle(0,10,0)}
PlayerModelBones["ValveBiped.Bip01_L_Finger01"] 	= {CSSBone = "v_weapon.Left_Thumb_02",IWBone = "L_Thumb2",Finger = true,CSSAngle=Angle(0,10,0)}
PlayerModelBones["ValveBiped.Bip01_L_Finger02"] 	= {CSSBone = "v_weapon.Left_Thumb03",IWBone = "L_Thumb3",Finger = true}
---------------------------


--LEfthand-------------
PlayerModelBones["ValveBiped.Bip01_R_Clavicle"]		= {Arm = true}
PlayerModelBones["ValveBiped.Bip01_R_UpperArm"]		= {Arm = true}

PlayerModelBones["ValveBiped.Bip01_R_Forearm"] 		= {CSSBone = "v_weapon.Right_Arm",IWBone = "R_Forearm",Arm = true, CSSScale = Vector(0.72, 0.72, 0.72),CSSTranslate = Vector(--[=[-1]=]0,0,0),CSSAngle = Angle(0,0,155)}
PlayerModelBones["ValveBiped.Bip01_R_Hand"] 		= {CSSBone = "v_weapon.Right_Hand",IWBone = "R_Wrist", CSSScale = Vector(0.68, 0.68, 0.68),CSSAngle = Angle(0,0,90),CSSTranslate = Vector(-0.13,0,0)}-- CSSAngle = Angle(0,0,90)}
PlayerModelBones["ValveBiped.Bip01_R_Finger4"] 		= {CSSBone = "v_weapon.Right_Pinky01",IWBone = "R_Pinky1", Finger = true,CSSAngle=Angle(0,-10,0)}
PlayerModelBones["ValveBiped.Bip01_R_Finger41"] 	= {CSSBone = "v_weapon.Right_Pinky02",IWBone = "R_Pinky2", Finger = true,CSSAngle=Angle(0,-10,0)}
PlayerModelBones["ValveBiped.Bip01_R_Finger42"] 	= {CSSBone = "v_weapon.Right_Pinky03",IWBone = "R_Pinky3", Finger = true,CSSAngle=Angle(0,-5,0)}
PlayerModelBones["ValveBiped.Bip01_R_Finger3"] 		= {CSSBone = "v_weapon.Right_Ring01",IWBone = "R_Ring1", Finger = true,CSSAngle=Angle(0,-10,0)}
PlayerModelBones["ValveBiped.Bip01_R_Finger31"] 	= {CSSBone = "v_weapon.Right_Ring02",IWBone = "R_Ring2", Finger = true,CSSAngle=Angle(0,-10,0)}
PlayerModelBones["ValveBiped.Bip01_R_Finger32"] 	= {CSSBone = "v_weapon.Right_Ring03",IWBone = "R_Ring3", Finger = true,CSSAngle=Angle(0,-5,0)}
PlayerModelBones["ValveBiped.Bip01_R_Finger2"] 		= {CSSBone = "v_weapon.Right_Middle01",IWBone = "R_Mid1", Finger = true,CSSAngle=Angle(0,-10,0)}
PlayerModelBones["ValveBiped.Bip01_R_Finger21"] 	= {CSSBone = "v_weapon.Right_Middle02",IWBone = "R_Mid2", Finger = true,CSSAngle=Angle(0,-10,0)}
PlayerModelBones["ValveBiped.Bip01_R_Finger22"] 	= {CSSBone = "v_weapon.Right_Middle03",IWBone = "R_Mid3", Finger = true,CSSAngle=Angle(0,-5,0)}
PlayerModelBones["ValveBiped.Bip01_R_Finger1"] 		= {CSSBone = "v_weapon.Right_Index01",IWBone = "R_Index1", Finger = true,CSSAngle=Angle(0,-10,0)}
PlayerModelBones["ValveBiped.Bip01_R_Finger11"] 	= {CSSBone = "v_weapon.Right_Index02",IWBone = "R_Index2", Finger = true,CSSAngle=Angle(0,-10,0)}
PlayerModelBones["ValveBiped.Bip01_R_Finger12"] 	= {CSSBone = "v_weapon.Right_Index03",IWBone = "R_Index1", Finger = true,CSSAngle=Angle(0,-5,0)}
PlayerModelBones["ValveBiped.Bip01_R_Finger0"] 		= {CSSBone = "v_weapon.Right_Thumb01",IWBone = "R_Thumb1", Finger = true,CSSAngle=Angle(0,0,0)}
PlayerModelBones["ValveBiped.Bip01_R_Finger01"] 	= {CSSBone = "v_weapon.Right_Thumb02",IWBone = "R_Thumb2",Finger = true,CSSAngle=Angle(0,0,0)}
PlayerModelBones["ValveBiped.Bip01_R_Finger02"] 	= {CSSBone = "v_weapon.Right_Thumb03",IWBone = "R_Thumb3", Finger = true,CSSAngle=Angle(0,0,0)}

-----------------------------

PlayerModelBones["ValveBiped.Bip01_Pelvis"]			= {ScaleDown = true}
PlayerModelBones["ValveBiped.Bip01_Spine"]			= {ScaleDown = true}
PlayerModelBones["ValveBiped.Bip01_Spine1"]			= {ScaleDown = true}
PlayerModelBones["ValveBiped.Bip01_Spine2"]			= {ScaleDown = true}
PlayerModelBones["ValveBiped.Bip01_Spine4"]			= {ScaleDown = true}
PlayerModelBones["ValveBiped.Bip01_Neck1"]			= {ScaleDown = true}
PlayerModelBones["ValveBiped.Bip01_Head1"]			= {ScaleDown = true}

PlayerModelBones["ValveBiped.Bip01_R_Thigh"]		= {ScaleDown = true}
PlayerModelBones["ValveBiped.Bip01_R_Calf"]			= {ScaleDown = true}
PlayerModelBones["ValveBiped.Bip01_R_Foot"]			= {ScaleDown = true}
PlayerModelBones["ValveBiped.Bip01_R_Toe0"]			= {ScaleDown = true}
PlayerModelBones["ValveBiped.Bip01_L_Thigh"]		= {ScaleDown = true}
PlayerModelBones["ValveBiped.Bip01_L_Calf"]			= {ScaleDown = true}
PlayerModelBones["ValveBiped.Bip01_L_Foot"]			= {ScaleDown = true}
PlayerModelBones["ValveBiped.Bip01_L_Toe0"]			= {ScaleDown = true}

PlayerModelBones["ValveBiped.forward"]			= {ScaleDown = true}
PlayerModelBones["smdimport01"]			= {ScaleDown = true}


--------------------------------------------------------------------

function meta:DrawCrosshair()
	if util.tobool(GetConVarNumber("_zs_hidecrosshair")) or self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then
		return
	end
	self:DrawCrosshairCross()
	self:DrawCrosshairDot()
end

local CrossHairScale = 1
function meta:DrawCrosshairCross()
	local x = ScrW() * 0.5
	local y = ScrH() * 0.5

	local ironsights = self.GetIronsights and self:GetIronsights()

	local owner = self.Owner

	local cone
	if ironsights then
		if owner:Crouching() then
			cone = self.ConeIronCrouching
		else
			cone = self.ConeIron
		end
	elseif 25 < self.Owner:GetVelocity():Length() then
		cone = self.ConeMoving
	else
		if self.Owner:Crouching() then
			cone = self.ConeCrouching
		else
			cone = self.Cone
		end
	end

	if cone <= 0 or ironsights and not ironsightscrosshair then
		return
	end

	cone = ScrH() / 100 * cone

	CrossHairScale = math.Approach(CrossHairScale, cone, FrameTime() * 5 + math.abs(CrossHairScale - cone) * 0.02)

	local scalebyheight = (h / 1080) * 0.2

	local midarea = 40 * CrossHairScale
	local length = scalebyheight * 1 + midarea*0.1

	surface.SetDrawColor(Color(255,175,175,220))
	surface.DrawRect(x - midarea - length, y - 1, length, 2)
	surface.DrawRect(x + midarea, y - 1, length, 2)
	surface.DrawRect(x - 1, y - midarea - length, 2, length)
	surface.DrawRect(x - 1, y + midarea, 2, length)

	surface.SetDrawColor(255, 175, 175, 220)
	surface.DrawOutlinedRect(x - midarea - length, y - 1, length, 2)
	surface.DrawOutlinedRect(x + midarea, y - 1, length, 2)
	surface.DrawOutlinedRect(x - 1, y - midarea - length, 2, length)
	surface.DrawOutlinedRect(x - 1, y + midarea, 2, length)

	surface.SetDrawColor(Color(255,0,0,200))
	surface.DrawRect(x - 2, y - 2, 4, 4)
	surface.SetDrawColor(0, 0, 0, 200)
	surface.DrawOutlinedRect(x - 2, y - 2, 4, 4)
end

function meta:DrawCrosshairDot()
	local ironsights = self.GetIronsights and self:GetIronsights()
	if not ironsights then
		return
	end
	
	local x = ScrW() * 0.5
	local y = ScrH() * 0.5

	surface.SetDrawColor(Color(255,0,0,200))
	surface.DrawRect(x - 2, y - 2, 4, 4)
	surface.SetDrawColor(0, 0, 0, 200)
	surface.DrawOutlinedRect(x - 2, y - 2, 4, 4)
end

