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
	
	-- Get category
	local strCategory = WeaponTypeToCategory[Type]
	
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

--[==[---------------------------------------------------------
        Used to get the type (string) of a weapon
---------------------------------------------------------]==]
function meta:GetType()
	if not ValidEntity ( self ) then return "none" end                          

	local name = tostring ( self:GetClass() )
		
	if GAMEMODE.HumanWeapons[ name ] == nil then return "none" end
	return GAMEMODE.HumanWeapons[ name ].Type
end

--[==[---------------------------------------------------------------------
          Use this to set the color of a weapon viewmodel
----------------------------------------------------------------------]==]
function meta:SetViewModelColor ( col )
	if SERVER then return end
	if not ValidEntity ( MySelf ) then return end
	
	-- Get Viewmodel
	local ViewModel = MySelf:GetViewModel()
	if not ValidEntity ( ViewModel ) then return end

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

-- Move all hands stuff here so it will be easier to control


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


-- 'fix' for fucked up fingers

function BoneAngDifference(weapon,bonename)
	if not bonename then return Angle(0,0,0) end
	if not PlayerModelBones[bonename] then return Angle(0,0,0) end
	
	local Checktable = {}
	Checktable["ValveBiped.Bip01_R_Finger41"] = "ValveBiped.Bip01_R_Finger4"
	Checktable["ValveBiped.Bip01_R_Finger42"] = "ValveBiped.Bip01_R_Finger41"
	Checktable["ValveBiped.Bip01_R_Finger31"] = "ValveBiped.Bip01_R_Finger3"
	Checktable["ValveBiped.Bip01_R_Finger32"] = "ValveBiped.Bip01_R_Finger31"
	Checktable["ValveBiped.Bip01_R_Finger21"] = "ValveBiped.Bip01_R_Finger2"
	Checktable["ValveBiped.Bip01_R_Finger22"] = "ValveBiped.Bip01_R_Finger21"
	Checktable["ValveBiped.Bip01_R_Finger11"] = "ValveBiped.Bip01_R_Finger1"
	Checktable["ValveBiped.Bip01_R_Finger12"] = "ValveBiped.Bip01_R_Finger12"
	Checktable["ValveBiped.Bip01_R_Finger01"] = "ValveBiped.Bip01_R_Finger0"
	Checktable["ValveBiped.Bip01_R_Finger02"] = "ValveBiped.Bip01_R_Finger01"
	
	Checktable["ValveBiped.Bip01_L_Finger4"] = "ValveBiped.Bip01_L_Hand"
	Checktable["ValveBiped.Bip01_L_Finger41"] = "ValveBiped.Bip01_L_Finger4"
	Checktable["ValveBiped.Bip01_L_Finger42"] = "ValveBiped.Bip01_L_Finger41"
	Checktable["ValveBiped.Bip01_L_Finger31"] = "ValveBiped.Bip01_L_Finger3"
	Checktable["ValveBiped.Bip01_L_Finger32"] = "ValveBiped.Bip01_L_Finger31"
	Checktable["ValveBiped.Bip01_L_Finger21"] = "ValveBiped.Bip01_L_Finger2"
	Checktable["ValveBiped.Bip01_L_Finger22"] = "ValveBiped.Bip01_L_Finger21"
	Checktable["ValveBiped.Bip01_L_Finger11"] = "ValveBiped.Bip01_L_Finger1"
	Checktable["ValveBiped.Bip01_L_Finger12"] = "ValveBiped.Bip01_L_Finger12"
	Checktable["ValveBiped.Bip01_L_Finger01"] = "ValveBiped.Bip01_L_Finger0"
	Checktable["ValveBiped.Bip01_L_Finger02"] = "ValveBiped.Bip01_L_Finger01"
	
	local vm = weapon.Owner:GetViewModel()
	
	if weapon.IgnoreThumbs then
		if string.find(bonename,"Finger0") then return Angle(0,0,0) end
	end
	
	if not Checktable[bonename] then return Angle(0,0,0) end
	
	local bone1, bone2 = vm:LookupBone(bonename), vm:LookupBone(Checktable[bonename])
	

	
	if PlayerModelBones[bonename].CSSBone then

		bone1, bone2 = vm:LookupBone(PlayerModelBones[bonename].CSSBone), vm:LookupBone(PlayerModelBones[Checktable[bonename]].CSSBone)

	end
	
	if PlayerModelBones[bonename].IWBone then

		local tempbone1, tempbone2 = vm:LookupBone(PlayerModelBones[bonename].IWBone), vm:LookupBone(PlayerModelBones[Checktable[bonename]].IWBone)
		if tempbone1 and tempbone2 then
			bone1,bone2 = tempbone1,tempbone2
		end
	end
	
	if weapon.PlayerModelBones and weapon.PlayerModelBones[bonename] then
		local tempbone1, tempbone2 = vm:LookupBone( weapon.PlayerModelBones[bonename]), vm:LookupBone( weapon.PlayerModelBones[Checktable[bonename]])
		if tempbone1 and tempbone2 then
			bone1,bone2 = tempbone1,tempbone2
		end
	end
	

	if bone1 and bone2 then
	

			local pos1, ang1 = vm:GetBonePosition( bone1 )
			local pos2, ang2 = vm:GetBonePosition( bone2 )
			
			local vmangles = vm:GetAngles()
			
			if weapon.ViewModelFlip == true then
				-- ang1.y = ang1.y*-1
				-- ang2.y = ang2.y*-1
				ang1 = ang1*-1
				ang2 = ang2*-1
				
				vmangles=vmangles*-1
			end
			
			
			
			pos1, ang1 = WorldToLocal(pos1, ang1,vm:GetPos(),vmangles)
			pos2, ang2 = WorldToLocal(pos2, ang2,vm:GetPos(),vmangles)

			if ang1 and ang2 then

				local p,y,r = 0,0,0
				
				p = math.AngleDifference(ang1.p,ang2.p) 
				y = math.AngleDifference(ang1.y,ang2.y) 
				r = math.AngleDifference(ang1.r,ang2.r)
				
				if not weapon.FlipYaw then 
					if string.find(bonename,"_R_") then
						y=-y
					end
				end
				
				-- local finalang = Angle(-p+16,y+10,r)
				local finalang = Angle(-p/1.4,y/2,r/1.3)-- 1.4, 1.6
				
				if weapon.ViewModelFlip == true then
					finalang = Angle(p/1.4,y/2,r/1.3)
				end
				
				return finalang
			end
	end
	
	return Angle(0,0,0)
	
	
end

function CalculatePlayerModelBones1(weapon,ent)

	local vm = weapon.Owner:GetViewModel()
	weapon.BuildModelPosition1 = function(s) end
		
	if not ValidEntity(vm) then return end
	weapon.BuildModelPosition1 = function(s)
	
	if s:GetModelScale() == Vector(1,1,1) then
		-- s:SetModelWorldScale(Vector(1,-1,1))
	end
	
	for i = 0, vm:GetBoneCount() - 1 do
		local name = vm:GetBoneName(i)
		if (vm:LookupBone(name)) then
			-- print(tostring(name))
			if string.find(name,"v_weapon.") then
				modelnum = 2
				break
			end
		end
	end
	
	for i = 0, s:GetBoneCount() - 1 do
				local name = s:GetBoneName(i)
				local bone = s:LookupBone(name)
					if bone then
						if weapon.UseHL2Bonemerge then 
								if string.find(name,"_L_") and weapon.ScaleDownLeftHand or string.find(name,"_R_") and weapon.ScaleDownRightHand then
									local mMatrix = s:GetBoneMatrix(bone)
									if mMatrix then
										mMatrix:Scale(Vector(0.0000001,0.0000001, 0.0000001))-- 0.00001
										mMatrix:SetTranslation(vm:GetPos()+vm:GetAngles():Forward()*(-990))-- Vector(-9999,-9999,9999)s:GetBoneMatrix(s:LookupBone("v_weapon.Right_Arm")):GetTranslation()
										s:SetBoneMatrix(bone, mMatrix)
									end
								end
						else
							if string.find(name,"v_weapon.") and (string.find(name,"wrist_") or string.find(name,"Left_") or string.find(name,"Right_") ) 
							or weapon.PlayerModelBones and table.HasValue(weapon.PlayerModelBones,name) then
								local mMatrix = s:GetBoneMatrix(bone)
								if mMatrix then
									mMatrix:Scale(Vector(0.0000001,0.0000001, 0.0000001))-- 0.00001
									mMatrix:SetTranslation(vm:GetPos()+vm:GetAngles():Forward()*(-990))-- Vector(-9999,-9999,9999)s:GetBoneMatrix(s:LookupBone("v_weapon.Right_Arm")):GetTranslation()
									s:SetBoneMatrix(bone, mMatrix)
								end
							end
						end
					end	
	end
		
	end
	
	ent.BuildBonePositions = function(...)
		weapon.BuildModelPosition1(...)
	end
	
	

end

function CalculatePlayerModelBones2(weapon,ent)

	-- figure out where is this viewmodel from
	local modelnum = 1
	
	local vm = weapon.Owner:GetViewModel()
	
	
	for i = 0, vm:GetBoneCount() - 1 do
		local name = vm:GetBoneName(i)
		if (vm:LookupBone(name)) then
			-- print(tostring(name))
			if string.find(name,"v_weapon.") or weapon.PlayerModelBones then
				modelnum = 2
				break
			end
		end
	end
	
	weapon.BuildModelPosition = function(s) end
		
	if not ValidEntity(vm) then return end
	
	if modelnum == 1 then
		if weapon.UseHL2Bonemerge then
			weapon.BuildModelPosition = function(s)
					for i = 0, s:GetBoneCount() - 1 do
					local name = s:GetBoneName(i)
					local bone = s:LookupBone(name)
						if bone then
							if PlayerModelBones[name] and PlayerModelBones[name].ScaleDown then-- 
								local mMatrix = s:GetBoneMatrix(bone)
								if mMatrix then
									mMatrix:Scale(Vector(0.0000001,0.0000001, 0.0000001))-- 0.00001
									mMatrix:SetTranslation(vm:GetPos()+vm:GetAngles():Forward()*(-990))-- Vector(-9999,-9999,9999)s:GetBoneMatrix(s:LookupBone("v_weapon.Right_Arm")):GetTranslation()
									s:SetBoneMatrix(bone, mMatrix)
								end
							end
							local mMatrix = s:GetBoneMatrix(bone)
							if mMatrix then
								if weapon.OverrideAngle and weapon.OverrideAngle[name] then
									mMatrix:Rotate(weapon.OverrideAngle[name])
								end
								if weapon.OverrideTranslation and weapon.OverrideTranslation[name] then
									mMatrix:Translate(weapon.OverrideTranslation[name])
								end
								s:SetBoneMatrix(bone, mMatrix)
							end
						end	
					end
			end
		else
		weapon.BuildModelPosition = function(s)
			for k, v in pairs( PlayerModelBones ) do
				if v.ScaleDown then
					local Bone = s:LookupBone(k)
					if Bone then
						local mMatrix = s:GetBoneMatrix(Bone)
						if mMatrix then
						-- mMatrix:Scale(Vector(1, 1, 1))
						s:SetBoneMatrix(Bone, mMatrix)
						end
						-- local BonePos2 , BoneAng2 = s:GetBonePosition( s:LookupBone("ValveBiped.Bip01_R_Clavicle") )
						-- s:SetBonePosition(Bone,BonePos2 , BoneAng2)
					end
				else
					if not v.Finger then
						local mdlbone = s:LookupBone(k)
						local vmbone = vm:LookupBone(k)
					
						
						if vmbone then
							local BonePos , BoneAng = vm:GetBonePosition( vmbone )
							local BonePos1 , BoneAng1 = vm:GetBonePosition( mdlbone )
							local mdlmatrix = s:GetBoneMatrix(mdlbone)
							local vmmatrix = vm:GetBoneMatrix(vmbone)	
							if BonePos and BoneAng then
								--if mdlbone then
								-- 	s:SetBonePosition(mdlbone,BonePos , BoneAng)
								--end
							end
							if vmmatrix then 
								if mdlmatrix then
									-- print(tostring(mdlmatrix:GetTranslation()))
									-- mdlmatrix:Scale(vmmatrix:GetScale())
									-- mdlmatrix:Rotate(vmmatrix:GetAngle())
									-- mdlmatrix:SetTranslation(vmmatrix:GetTranslation())
									s:SetBoneMatrix(mdlbone, vmmatrix)
								end
							end
						end
					else
						if weapon.RotateFingers and not string.find(k,"Finger0") then
							local mdlbone = s:LookupBone(k)
							local vmbone = vm:LookupBone(k)
							local mdlmatrix = s:GetBoneMatrix(mdlbone)
							if mdlmatrix then
								-- print(tostring(mdlmatrix:GetTranslation()))
								mdlmatrix:Rotate(weapon.RotateFingers)
								s:SetBoneMatrix(mdlbone, mdlmatrix)
							end
						end
					end
					local mMatrix = s:GetBoneMatrix(mdlbone)
						if mMatrix then
							if weapon.OverrideAngle and weapon.OverrideAngle[name] then
								mMatrix:Rotate(weapon.OverrideAngle[name])
							end
							if weapon.OverrideTranslation and weapon.OverrideTranslation[name] then
								mMatrix:Translate(weapon.OverrideTranslation[name])
							end
							s:SetBoneMatrix(mdlbone, mMatrix)
						end
				end
			end
		end
	
		end
	-- end
	
	elseif modelnum == 2 then
		weapon.BuildModelPosition = function(s)
			for k, v in pairs( PlayerModelBones ) do
				if v.ScaleDown then
				local Bone = s:LookupBone(k)
					if Bone then
						local mMatrix = s:GetBoneMatrix(Bone)
						if mMatrix then
							-- mMatrix:Scale(Vector(1, 1, 1))
							s:SetBoneMatrix(Bone, mMatrix)
						end
						local BonePos2 , BoneAng2 = s:GetBonePosition( s:LookupBone("ValveBiped.Bip01_R_Clavicle") )
						-- s:SetBonePosition(Bone,BonePos2 , BoneAng2)
					end	
				else
					if v.CSSBone then
						local mdlbone = s:LookupBone(k)
						local vmbone = vm:LookupBone(v.CSSBone)
						local name = v.CSSBone
						
						if v.IWBone then
							local tempname = v.IWBone
							if weapon.ReverseHands then
								if string.find(v.IWBone,"R_") then
									tempname = string.gsub(v.IWBone,"R_","L_")
								elseif string.find(v.IWBone,"L_") then
									tempname = string.gsub(v.IWBone,"L_","R_")
								end
							end
							local tempbone = vm:LookupBone(tempname)
							if tempbone then
								vmbone = tempbone
								name = tempname
							end
						end
						
						if weapon.PlayerModelBones and weapon.PlayerModelBones[k] then
							local tempname = weapon.PlayerModelBones[k]
							if weapon.ReverseHands then
								if string.find(weapon.PlayerModelBones[k],"R_") then
									tempname = string.gsub(weapon.PlayerModelBones[k],"R_","L_")
								elseif string.find(weapon.PlayerModelBones[k],"L_") then
									tempname = string.gsub(weapon.PlayerModelBones[k],"L_","R_")
								end
							end
							local tempbone = vm:LookupBone(tempname)
							if tempbone then
								vmbone = tempbone
								name = tempname
							end
						end

						if vmbone and mdlbone then 
							local vmmatrix = vm:GetBoneMatrix(vmbone)
							-- local vmmatrix = self.BoneTempScale[vmbone]
							-- print("Read "..tostring(self.BoneTempScale[vmbone]:GetScale()).." to "..tostring(vmmatrix:GetScale()))
							if v.Finger then
								if vmmatrix then 
								local mdlmatrix = s:GetBoneMatrix(mdlbone)	
								
								if mdlmatrix and not weapon.IgnoreFingers then
								
									if v.CSSAngle then
										-- mdlmatrix:Rotate(v.CSSAngle)
									end
									
									local mdlang = mdlmatrix:GetAngles()
									local vmang = vmmatrix:GetAngles()
									
									mdlmatrix:Rotate(BoneAngDifference(weapon,k))-- BoneAngDifference(weapon,k)
									-- s:SetBoneMatrix(mdlbone, vmmatrix)
									s:SetBoneMatrix(mdlbone, mdlmatrix)
									
									end
								end
							
							else
								if vmmatrix then 
										local mdlmatrix = s:GetBoneMatrix(mdlbone)
										-- mdlmatrix:SetAngle(vmmatrix:GetAngle())
										-- mdlmatrix:SetTranslation(vmmatrix:GetTranslation())
										
										s:SetBoneMatrix(mdlbone, vmmatrix)
										
										
										
										-- s:SetBoneMatrix(mdlbone, mdlmatrix)
										local mdlmatrix = s:GetBoneMatrix(mdlbone)
										if mdlmatrix then										
											
											
											if v.CSSScale then
												mdlmatrix:Scale(v.CSSScale)
											end
											
											if weapon.OverrideAngle and weapon.OverrideAngle[name] then
												mdlmatrix:Rotate(weapon.OverrideAngle[name])
											else
												if v.CSSAngle then
													mdlmatrix:Rotate(v.CSSAngle)
												end
											end
											if weapon.OverrideTranslation and weapon.OverrideTranslation[name] then
												mdlmatrix:Translate(weapon.OverrideTranslation[name])
											else
												if v.CSSTranslate then
													mdlmatrix:Translate(v.CSSTranslate)
												end
											end
											-- mdlmatrix:Translate(Vector(-2,-9,0))
											-- mdlmatrix:SetTranslation(mdlmatrix:GetTranslation()*10)
											
											local mdlang = mdlmatrix:GetAngles()
											local vmang = vmmatrix:GetAngles()
											
											-- print(tostring(mdlang).." | "..tostring(vmang))
											s:SetBoneMatrix(mdlbone, mdlmatrix)
										end
								end
							end
						end
				
					end
				end
			end

		end
		

		
	end
	
	ent.BuildBonePositions = function(...)
		weapon.BuildModelPosition(...)
	end
end

function RemoveNewArms(weapon)

	if not CLIENT then return end
	if (ValidEntity(weapon.Arms)) then
		weapon.Arms:Remove()
		-- print(tostring(ValidEntity(weapon.Arms)))
	end
		weapon.Arms = nil
	if (ValidEntity(weapon.Wep)) then
		weapon.Wep:Remove()
		-- print(tostring(ValidEntity(weapon.Wep)))
	end
		weapon.Wep = nil

end

---NEW----------------------------------------------------------


-- Calculate shit for our new weapon model

function CalculateWeaponBones(weapon,ent)

	local vm = weapon.Owner:GetViewModel()		
	if not ValidEntity(vm) then return end
	
	local s = ent
	
	for i = 0, s:GetBoneCount() - 1 do
		local name = s:GetBoneName(i)
		local bone = s:LookupBone(name)
		if bone then
			if weapon.UseHL2Bonemerge then 
				if string.find(name,"_L_") and weapon.ScaleDownLeftHand or string.find(name,"_R_") and weapon.ScaleDownRightHand then
					s:ManipulateBoneScale(bone,Vector(0.0000001,0.0000001, 0.0000001))
					s:ManipulateBonePosition(bone,vm:GetPos()+vm:GetAngles():Forward()*(-99999999))
				end
			else
				if string.find(name,"v_weapon.") and (string.find(name,"wrist_") or string.find(name,"Left_") or string.find(name,"Right_") ) 
				or weapon.PlayerModelBones and table.HasValue(weapon.PlayerModelBones,name) then
					s:ManipulateBoneScale(bone,Vector(0.0000001,0.0000001, 0.0000001))
					s:ManipulateBonePosition(bone,vm:GetPos()+vm:GetAngles():Forward()*(-99999999))
				end
			end
		end	
	end	

end

-- Calculate actual model 
function CalculatePlayerModelBones(weapon,ent)

	-- figure out where is this viewmodel from
	local modelnum = 1
	
	local vm = weapon.Owner:GetViewModel()
	
	
	for i = 0, vm:GetBoneCount() - 1 do
		local name = vm:GetBoneName(i)
		if (vm:LookupBone(name)) then
			-- print(tostring(name))
			if string.find(name,"v_weapon.") or weapon.PlayerModelBones then
				modelnum = 2
				break
			end
		end
	end
		
	if not ValidEntity(vm) then return end
	
	local s = ent
	
	if modelnum == 1 then
		if weapon.UseHL2Bonemerge then
					for i = 0, s:GetBoneCount() - 1 do
					local name = s:GetBoneName(i)
					local bone = s:LookupBone(name)
						if bone then
							if PlayerModelBones[name] and PlayerModelBones[name].ScaleDown then
								s:ManipulateBoneScale(bone,Vector(0.0000001,0.0000001, 0.0000001))
								s:ManipulateBonePosition(bone,vm:GetPos()+vm:GetAngles():Forward()*(-990))-- Vector(-9999,-9999,9999)s:GetBoneMatrix(s:LookupBone("v_weapon.Right_Arm")):GetTranslation()
							end
							
							if weapon.OverrideAngle and weapon.OverrideAngle[name] then
								s:ManipulateBoneAngle(bone,weapon.OverrideAngle[name])
							end
							if weapon.OverrideTranslation and weapon.OverrideTranslation[name] then
								s:ManipulateBonePosition(bone,weapon.OverrideTranslation[name])
							end
						end	
					end
		else
		
			for k, v in pairs( PlayerModelBones ) do
				if v.ScaleDown then
					local Bone = s:LookupBone(k)
					if Bone then
						local mMatrix = s:GetBoneMatrix(Bone)
						if mMatrix then
						-- mMatrix:Scale(Vector(1, 1, 1))
						-- s:SetBoneMatrix(Bone, mMatrix)
						end
						-- local BonePos2 , BoneAng2 = s:GetBonePosition( s:LookupBone("ValveBiped.Bip01_R_Clavicle") )
						-- s:SetBonePosition(Bone,BonePos2 , BoneAng2)
					end
				else
					--if not v.Finger then
						local mdlbone = s:LookupBone(k)
						local vmbone = vm:LookupBone(k)

						if vmbone then
							local vmmatrix = vm:GetBoneMatrix(vmbone)	
							if vmmatrix then 
								s:ManipulateBoneScale(mdlbone,vmmatrix:GetScale())
								s:ManipulateBoneAngles(mdlbone,vmmatrix:GetAngles())
								s:ManipulateBonePosition(mdlbone,vmmatrix:GetTranslation())
							end
						end
					--[==[else
						if weapon.RotateFingers and not string.find(k,"Finger0") then
							local mdlbone = s:LookupBone(k)
							local vmbone = vm:LookupBone(k)
							local mdlmatrix = s:GetBoneMatrix(mdlbone)
							if mdlmatrix then
								-- print(tostring(mdlmatrix:GetTranslation()))
								mdlmatrix:Rotate(weapon.RotateFingers)
								s:SetBoneMatrix(mdlbone, mdlmatrix)
							end
						end
					end
					local mMatrix = s:GetBoneMatrix(mdlbone)
						if mMatrix then
							if weapon.OverrideAngle and weapon.OverrideAngle[name] then
								mMatrix:Rotate(weapon.OverrideAngle[name])
							end
							if weapon.OverrideTranslation and weapon.OverrideTranslation[name] then
								mMatrix:Translate(weapon.OverrideTranslation[name])
							end
							s:SetBoneMatrix(mdlbone, mMatrix)
						end]==]
				end
			end	
		end
	-- end
	
	elseif modelnum == 2 then

			for k, v in pairs( PlayerModelBones ) do
				if v.ScaleDown then
				local Bone = s:LookupBone(k)
					if Bone then
					
					end	
				else
					if v.CSSBone then
						local mdlbone = s:LookupBone(k)
						local vmbone = vm:LookupBone(v.CSSBone)
						local name = v.CSSBone
						
						if v.IWBone then
							local tempname = v.IWBone
							if weapon.ReverseHands then
								if string.find(v.IWBone,"R_") then
									tempname = string.gsub(v.IWBone,"R_","L_")
								elseif string.find(v.IWBone,"L_") then
									tempname = string.gsub(v.IWBone,"L_","R_")
								end
							end
							local tempbone = vm:LookupBone(tempname)
							if tempbone then
								vmbone = tempbone
								name = tempname
							end
						end
						
						if weapon.PlayerModelBones and weapon.PlayerModelBones[k] then
							local tempname = weapon.PlayerModelBones[k]
							if weapon.ReverseHands then
								if string.find(weapon.PlayerModelBones[k],"R_") then
									tempname = string.gsub(weapon.PlayerModelBones[k],"R_","L_")
								elseif string.find(weapon.PlayerModelBones[k],"L_") then
									tempname = string.gsub(weapon.PlayerModelBones[k],"L_","R_")
								end
							end
							local tempbone = vm:LookupBone(tempname)
							if tempbone then
								vmbone = tempbone
								name = tempname
							end
						end

						if vmbone and mdlbone then 
							local vmmatrix = vm:GetBoneMatrix(vmbone)
							
							--[==[if v.Finger then
								if vmmatrix then 
									if not weapon.IgnoreFingers then
									
										if v.CSSAngle then
											-- mdlmatrix:Rotate(v.CSSAngle)
										end
										
										local mdlang = mdlmatrix:GetAngles()
										local vmang = vmmatrix:GetAngles()
										
										mdlmatrix:Rotate(BoneAngDifference(weapon,k))-- BoneAngDifference(weapon,k)
										-- s:SetBoneMatrix(mdlbone, vmmatrix)
										s:SetBoneMatrix(mdlbone, mdlmatrix)
									
									end
								end
							
							/*else]==]
								if vmmatrix then 
										
										
										-- mdlmatrix:SetAngle(vmmatrix:GetAngle())
										-- mdlmatrix:SetTranslation(vmmatrix:GetTranslation())
										
										s:ManipulateBoneScale(mdlbone,vmmatrix:GetScale())
										s:ManipulateBoneAngles(mdlbone,vmmatrix:GetAngles())
										s:ManipulateBonePosition(mdlbone,vmmatrix:GetTranslation())
		
										-- s:SetBoneMatrix(mdlbone, mdlmatrix)
										--[==[local mdlmatrix = s:GetBoneMatrix(mdlbone)
										if mdlmatrix then										
											
											
											if v.CSSScale then
												mdlmatrix:Scale(v.CSSScale)
											end
											
											if weapon.OverrideAngle and weapon.OverrideAngle[name] then
												mdlmatrix:Rotate(weapon.OverrideAngle[name])
											else
												if v.CSSAngle then
													mdlmatrix:Rotate(v.CSSAngle)
												end
											end
											if weapon.OverrideTranslation and weapon.OverrideTranslation[name] then
												mdlmatrix:Translate(weapon.OverrideTranslation[name])
											else
												if v.CSSTranslate then
													mdlmatrix:Translate(v.CSSTranslate)
												end
											end
											-- mdlmatrix:Translate(Vector(-2,-9,0))
											-- mdlmatrix:SetTranslation(mdlmatrix:GetTranslation()*10)
											
											local mdlang = mdlmatrix:GetAngles()
											local vmang = vmmatrix:GetAngles()
											
											-- print(tostring(mdlang).." | "..tostring(vmang))
											s:SetBoneMatrix(mdlbone, mdlmatrix)
										end]==]
								end
							--end
						end
					end
				end
			end
	end
end


function MakeNewArms(weapon)

	if not weapon then return end
	---
	-- set random model for first time
	local model = "models/player/group01/male_04.mdl"
	---
	if not CLIENT then return end
	
	weapon.Arms = ClientsideModel(model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
	
	if ValidEntity(weapon.Arms) then 
		
		if string.find(model,"gman") then
			weapon.Arms:SetBodygroup(1,1)
		end
		
		weapon.Arms:SetSequence("idle_all")
		
		weapon.Arms:SetPos(weapon:GetPos())
		weapon.Arms:SetAngles(weapon:GetAngles())
		weapon.Arms:SetParent(weapon) 
		weapon.Arms:SetNoDraw(true)		

	else
		weapon.Arms = nil
	end
	
	if weapon.IgnoreBonemerge then return end
	
	weapon.Wep = ClientsideModel(weapon.ViewModel, RENDER_GROUP_VIEW_MODEL_OPAQUE)
	
	if ValidEntity(weapon.Wep) then 
	
		weapon.Wep:SetPos(weapon:GetPos())
		weapon.Wep:SetAngles(weapon:GetAngles())
		weapon.Wep:SetParent(weapon) 		
		weapon.Wep:SetupBones()

		weapon.Wep:SetNoDraw(true)

	else
		weapon.Wep = nil
	end
end

function UpdateArms(weapon) 
	local vm = weapon.Owner:GetViewModel();
	
	if not vm then return end
	
	if not util.tobool(GetConVarNumber("_zs_clhands")) then return end
	if weapon.IgnoreClientsideHands then return end
	-- weapon.ViewModelFlip = true
	if ValidEntity(weapon.Arms) then
			
			if weapon.Arms:GetModel() ~= weapon.Owner:GetModel() then
				weapon.Arms:SetModel(weapon.Owner:GetModel())
				if string.find(weapon.Arms:GetModel(),"gman") then
					weapon.Arms:SetBodygroup(1,1)
				end
			end
			
			
			render.SetColorModulation(1, 1, 1)
			render.SetBlend(1)
			if weapon.ViewModelFlip == true then render.CullMode(MATERIAL_CULLMODE_CW) end
			
			weapon.Arms:SetRenderOrigin( vm:GetPos()-vm:GetAngles():Forward()*20-vm:GetAngles():Up()*60 )-- self.Arms[1]:SetRenderOrigin( EyePos() )
			weapon.Arms:SetRenderAngles( vm:GetAngles() )-- 
			weapon.Arms:SetupBones()	
			weapon.Arms:DrawModel()
			weapon.Arms:SetRenderOrigin()
			weapon.Arms:SetRenderAngles()
			
			if weapon.ViewModelFlip == true then render.CullMode(MATERIAL_CULLMODE_CCW) end
			render.SetBlend(1)
			render.SetColorModulation(1, 1, 1)
			
			if weapon.UseHL2Bonemerge then
				weapon.Arms:SetParent(vm) 
				if not weapon.Arms:IsEffectActive(EF_BONEMERGE) then
					weapon.Arms:AddEffects(EF_BONEMERGE)
				end
			end
			
			CalculatePlayerModelBones(weapon,weapon.Arms)
			-- weapon.Arms:SetParent(vm) 
	end
	if ValidEntity(weapon.Wep) then
	
			render.SetColorModulation(1, 1, 1)
			render.SetBlend(1)
		
			if weapon.ViewModelFlip == true then render.CullMode(MATERIAL_CULLMODE_CW) end
			
			weapon.Wep:SetParent(vm)
			
			weapon.Wep:SetRenderOrigin( vm:GetPos())
			weapon.Wep:SetRenderAngles( vm:GetAngles() )
			
			weapon.Wep:SetupBones()
			
			weapon.Wep:RemoveEffects(EF_BONEMERGE)
			
			weapon.Wep:DrawModel() 

			weapon.Wep:AddEffects(EF_BONEMERGE)
			
			weapon.Wep:SetRenderOrigin()
			weapon.Wep:SetRenderAngles()
			
			if weapon.ViewModelFlip == true then render.CullMode(MATERIAL_CULLMODE_CCW) end
			
			render.SetBlend(1)
			render.SetColorModulation(1, 1, 1)

			-- CalculatePlayerModelBones1(weapon,weapon.Wep)
			CalculateWeaponBones(weapon,weapon.Wep)
	end
end




--------------------------------------------------------------------

function meta:DrawCrosshair()
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then return end
	if util.tobool(GetConVarNumber("_zs_hidecrosshair")) then return end
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

	if cone <= 0 or ironsights and not ironsightscrosshair then return end

	cone = ScrH() / 76.8 * cone

	CrossHairScale = math.Approach(CrossHairScale, cone, FrameTime() * 5 + math.abs(CrossHairScale - cone) * 0.02)

	local scalebyheight = (h / 768) * 0.2

	local midarea = 40 * CrossHairScale
	local length = scalebyheight * 24 + midarea / 4

	surface.SetDrawColor(Color(255,255,255,255))
	surface.DrawRect(x - midarea - length, y - 2, length, 4)
	surface.DrawRect(x + midarea, y - 2, length, 4)
	surface.DrawRect(x - 2, y - midarea - length, 4, length)
	surface.DrawRect(x - 2, y + midarea, 4, length)

	surface.SetDrawColor(0, 0, 0, 160)
	surface.DrawOutlinedRect(x - midarea - length, y - 2, length, 4)
	surface.DrawOutlinedRect(x + midarea, y - 2, length, 4)
	surface.DrawOutlinedRect(x - 2, y - midarea - length, 4, length)
	surface.DrawOutlinedRect(x - 2, y + midarea, 4, length)
end

function meta:DrawCrosshairDot()
	local x = ScrW() * 0.5
	local y = ScrH() * 0.5

	surface.SetDrawColor(Color(255,0,0,255))
	surface.DrawRect(x - 2, y - 2, 4, 4)
	surface.SetDrawColor(0, 0, 0, 160)
	surface.DrawOutlinedRect(x - 2, y - 2, 4, 4)
end

