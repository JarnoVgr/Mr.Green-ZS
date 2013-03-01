-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile( "shared.lua" )
	AddCSLuaFile( "sh_table.lua" )
end

//Tables file
include ( "sh_table.lua" )

SWEP.Weight	= 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom	= true

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false

SWEP.Author = "Deluvas"
SWEP.Contact = "Deluvas"
SWEP.PrintName = "Melee Weapon"
SWEP.Purpose = "Melee Weapon Base"
SWEP.Instructions = "None"

SWEP.Spawnable = true
SWEP.AdminSpawnable	= true

//Damge and delay
SWEP.Primary.Damage	= 40
SWEP.Primary.Delay = 0.15
SWEP.Primary.Distance = 65

//Nothing useful here
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

if CLIENT then

	SWEP.VElements = {}
	SWEP.WElements = {} 
	//SWEP.ShowViewModel = true
	
end

//Deploy speed
SWEP.DeploySpeed = 0.6

//Default holdtype
SWEP.HoldType = "melee"

//Walk speed
SWEP.WalkSpeed = 200

//Decals to apply on material
SWEP.TranslateDecal = { [MAT_FLESH] = { "Impact.Flesh", Effect = "BloodImpact" }, [MAT_ANTLION] = { "Impact.Antlion" }, [MAT_BLOODYFLESH] = { "Impact.Flesh", Effect = "BloodImpact" }, [MAT_SLOSH] = { "Impact.BloodyFlesh" }, [MAT_ALIENFLESH] = { "Impact.AlienFlesh", Effect = "BloodImpact" }, [MAT_WOOD] = { "Impact.Concrete" }, [MAT_CONCRETE] = { "Impact.Concrete" },	[MAT_METAL] = { "Impact.Metal" }, [MAT_TILE] = { "Impact.Concrete" }, [MAT_VENT] = { "Impact.Metal" }, [MAT_GRATE] = { "Impact.Metal" }, [MAT_PLASTIC] = { "Impact.Metal" } }

/*-------------------------------------------
       Called on weapon initialization
-------------------------------------------*/
function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
	
	if CLIENT then
	
		self:CreateModels(self.VElements) // create viewmodels
		self:CreateModels(self.WElements) // create worldmodels
		
		// init view model bone build function
		self.BuildViewModelBones = function( s )
			if LocalPlayer():GetActiveWeapon() == self and self.ViewModelBoneMods then
				for k, v in pairs( self.ViewModelBoneMods ) do
					local bone = s:LookupBone(k)
					if (!bone) then continue end
					local m = s:GetBoneMatrix(bone)
					if (!m) then continue end
					m:Scale(v.scale)
					m:Rotate(v.angle)
					m:Translate(v.pos)
					s:SetBoneMatrix(bone, m)
				end
			end
		end
		
	end
	 self:OnInitialize() 
	
end

function SWEP:OnInitialize()
	if CLIENT then
		//MakeNewArms(self)
	end
end

/*---------------------------------------
       Is this weapon a melee
---------------------------------------*/
function SWEP:IsMelee()
	return true
end

/*------------------------------------
       Called on weapon deploy
------------------------------------*/
function SWEP:Deploy()
	if SERVER then
		if self.Owner:FlashlightIsOn() and self.Owner:GetHumanClass() != 3 then
		--	self.Owner:Flashlight( false )
		end
	end
	
	//Draw animation
	self.Weapon:SendWeaponAnim ( ACT_VM_DRAW )
	
	self.Owner:StopAllLuaAnimations()
	
	self:OnDeploy()
	
	//Deploy speed
	self.Weapon:SetNextPrimaryFire ( CurTime() + self.DeploySpeed )
	
	if SERVER then
		GAMEMODE:WeaponDeployed( self.Owner, self )
	end
	
	return true
end

function SWEP:OnDeploy()
MakeNewArms(self)
if CLIENT then

		

end
end
function SWEP:OnDrop()
RemoveNewArms(self)
end

/*------------------------------------------------------
            Called when the weapon is equiped
-------------------------------------------------------*/
function SWEP:Equip ( NewOwner )
	if CLIENT then return end
	local Pistol = NewOwner:GetPistol()
		-- Receive ammo from melee weapon? HA!
	if Pistol and Pistol:GetClass() ~= "weapon_zs_magnum" then
	NewOwner:RemoveAmmo ( 24, "pistol" )
	end
	//Call this function to update weapon slot and others
	gamemode.Call ( "OnWeaponEquip", NewOwner, self )
end

/*--------------------------------------------------
     Called on Primary Fire Attack ( +attack )
---------------------------------------------------*/
function SWEP:PrimaryAttack()
	
	if self.Owner.KnockedDown or self.Owner:IsHolding() then return end
	//Get owner
	local pl = self.Owner
	
	//Punch view
	if pl.ViewPunch then pl:ViewPunch( Angle( math.Rand( 5,10 ),math.Rand( 5,10 ),0 ) ) end
	
	//Animate anyway
	self:DoAnimation()
	
	//Cooldown 
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	//Play miss sound anyway
	if SERVER then self.Owner:EmitSound( Sound ( "weapons/iceaxe/iceaxe_swing1.wav" ) ) end
	
	//First trace done
	local trace = pl:TraceLine( self.Primary.Distance, MASK_SHOT, pl )
	if trace.Hit and ValidEntity ( trace.Entity ) or trace.HitWorld then self:DoPrimaryAttack ( trace.Entity, trace ) return end
	
	//We don't have tracehull on the client
	if CLIENT then return end
	
	//Second trace - tracehull
	local TraceHull = pl:TraceHullAttack ( pl:GetShootPos(), pl:GetShootPos() + ( pl:GetAimVector() * 18 ), Vector ( -15,-10,-18 ), Vector ( 20,20,20 ), 0, DMG_GENERIC, 0 , true )
	self.HitHull = ValidEntity ( TraceHull )
	
	//Verify tracehull entity
	if not self.HitHull then return end
	local m_Ent = TraceHull
		
	//Do a trace so that the tracehull won't push or damage objects over a wall or something
	local vStart, vEnd = self.Owner:GetShootPos(), m_Ent:GetPos() 
	local ExploitTrace = util.TraceLine ( { start = vStart, endpos = vEnd, filter = pl } )
	
	if m_Ent != ExploitTrace.Entity then return end
	
	//Attack the hull-traced entity
	self:DoPrimaryAttack ( m_Ent )
end

function SWEP:DoAnimation()
	
	//1st person animation
	if math.random ( 1,2 ) == 2 then self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER ) else self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER ) end
	
	//Thirdperson animation
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
end

function SWEP:DoPrimaryAttack ( m_Ent, tbTrace )
	
	//Get owner
	local pl, iDamage = self.Owner, self.Primary.Damage
	
	if IsEntityValid ( m_Ent ) then
	
		//Punch the prop / damage the player if the pretrace is valid
		local Phys = m_Ent:GetPhysicsObject()
			
		//Break glass
		if SERVER then
			if m_Ent:GetClass() == "func_breakable_surf" then
				m_Ent:Fire( "break", "", 0 )
			end
		end
							
		//Take damage
		if SERVER then 
			m_Ent:TakeCustomDamage ( iDamage, pl, DMG_SLASH, nil, tbTrace )
		end
		
		//Velocity to push
		local Velocity = pl:EyeAngles():Forward() * 500 * ( iDamage / 6 )
				
		//Case 2: It is a valid Physics object
		if SERVER and Phys:IsValid() and not m_Ent:IsNPC() and Phys:IsMoveable() and not m_Ent:IsPlayer() then
			if Velocity.z < 1800 then Velocity.z = 1800 end
					
			//Apply force to prop and set phys. attacker
			Phys:ApplyForceCenter( Velocity )
			Phys:ApplyForceOffset( Vector( math.Rand (-10,10),math.Rand (-10,10),math.Rand (-5,5) ),Vector( math.Rand (-10,10),math.Rand (-10,10),math.Rand (-5,5) ) )
			m_Ent:SetPhysicsAttacker( pl )
		end
	end
	
	//Decal part (hulltrace doesn't return a table)
	if not tbTrace then if SERVER then self.Owner:EmitSound( table.Random ( self.HitSounds ) ) end return end
	
	//Material trace hit
	local iMaterial = tbTrace.MatType
	if not iMaterial then return end
	
	//Sound part
	local sSound = table.Random ( self.HitSounds )
	local tbSounds = self.TranslateMaterial[iMaterial]
	sSound = table.Random ( tbSounds )
	if self.Weapon:GetClass() == "weapon_zs_melee_katana" then
	sSound = table.Random ( self.KatanaSounds )
	end
	
	//Finally emit sound
	if SERVER then 
	if sSound and ValidEntity(self.Owner) then 
	self.Owner:EmitSound( sSound ) 
	end 
	end
	
	//Play fleshie sound and decal flesh blood thing
	local tbDecals, sDecal = self.TranslateDecal[iMaterial]
	if not tbDecals then sDecal = "ManhackCut" else sDecal = tbDecals[1] end
	util.Decal( sDecal, tbTrace.HitPos + tbTrace.HitNormal * 8, tbTrace.HitPos - tbTrace.HitNormal * 8 )
	
	//Blood effect
	if self:HitFlesh ( tbTrace ) then 
		local effectdata = EffectData()
			effectdata:SetOrigin( tbTrace.HitPos )
			effectdata:SetStart( tbTrace.HitPos + tbTrace.HitNormal * 8 )
		util.Effect( "BloodImpact", effectdata )
	end
end

function SWEP:Holster()
	RemoveNewArms(self)
	 if CLIENT then
		
		RestoreViewmodel(self.Owner)
    end
	
	return true
end

function SWEP:OnRemove()
	
	// other onremove code goes here
	RemoveNewArms(self)
	if CLIENT then
		self:RemoveModels()
		
		RestoreViewmodel(self.Owner)
	end
	
end

if CLIENT then

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		
		self.ViewModelFOV = GetConVarNumber("_zs_wepfov") or self.ViewModelFOV
		
		if not self.Owner then return end
		if not self.Owner:IsValid() then return end
		if not self.Owner:IsPlayer() then return end
		local vm = self.Owner:GetViewModel()
		if !ValidEntity(vm) then return end

		if self.Owner.KnockedDown or self.Owner:IsHolding() then 
		
		vm:SetColor(255,255,255,1) 
		
		return end
		
		if (self.ShowViewModel == nil or self.ShowViewModel) then
			vm:SetColor(255,255,255,255)
		else
			// we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
			vm:SetColor(255,255,255,1) 
		end
		
		if vm.BuildBonePositions ~= self.BuildViewModelBones then
			vm.BuildBonePositions = self.BuildViewModelBones
		end
		
		UpdateArms(self)

		if (!self.VElements) then return end
		
		if (!self.vRenderOrder) then
			
			// we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
			
		end

		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
		
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model" and ValidEntity(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				model:SetModelScale(v.size)
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end

		end
		
		if (ValidEntity(self.Owner)) then
			bone_ent = self.Owner
		else
			// when the weapon is dropped
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and ValidEntity(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				model:SetModelScale(v.size)
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			// Technically, if there exists an element with the same name as a bone
			// you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngle()
			end
			
			if (ValidEntity(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r // Fixes mirrored models
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (!tab) then return end

		// Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!ValidEntity(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists ("../"..v.model) ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (ValidEntity(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("../materials/"..v.sprite..".vmt")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				// make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end

	function SWEP:OnRemove()
		self:RemoveModels()
	end

	function SWEP:RemoveModels()
		if (self.VElements) then
			for k, v in pairs( self.VElements ) do
				if (ValidEntity( v.modelEnt )) then v.modelEnt:Remove() end
			end
		end
		if (self.WElements) then
			for k, v in pairs( self.WElements ) do
				if (ValidEntity( v.modelEnt )) then v.modelEnt:Remove() end
			end
		end
		self.VElements = nil
		self.WElements = nil
	end

end

/*---------------------------------------------------------
         See if a trace hit flesh materials
----------------------------------------------------------*/
function SWEP:HitFlesh ( tbTrace ) 
	if not tbTrace then return false end
	local iMaterial = tbTrace.MatType
	return iMaterial == MAT_FLESH or iMaterial == MAT_BLOODYFLESH or iMaterial == MAT_ANTLION or iMaterial == MAT_ALIENFLESH
end

/*------------------------------------
          Called on pressed R
-------------------------------------*/
function SWEP:Reload()
	return false
end

/*------------------------------------
          Called on holstered
-------------------------------------*/

function SWEP:AddSetupBones()
		self.Owner:GetViewModel():SetupBones()
		self.Owner:GetViewModel(1):SetupBones()
end

function SWEP:SecondaryAttack()
	return false
end

//Client hud
if CLIENT then
	function SWEP:DrawHUD() MeleeWeaponDrawHUD() end
end

