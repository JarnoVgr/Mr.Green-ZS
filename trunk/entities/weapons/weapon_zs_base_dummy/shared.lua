--Dummy base for tools and stuff

if( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	SWEP.Weight	= 5
	SWEP.AutoSwitchTo = true
	SWEP.AutoSwitchFrom	= true
end

if CLIENT then
	SWEP.DrawAmmo = true
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	SWEP.ShowViewModel = true
end



SWEP.Author = "NECROSSIN"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Spawnable = true
SWEP.AdminSpawnable	= true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "CombineCannon"

SWEP.DeploySpeed = 1.1

function SWEP:InitializeClientsideModels()
	
	self.VElements = {}
	self.WElements = {} 
	
end

function SWEP:Deploy()	
	
	self.Owner:StopAllLuaAnimations()
	
	self:OnDeploy()
	
	if CLIENT then
		self:ResetBonePositions()
	end
	
	-- MakeNewArms(self)
	
	if SERVER then GAMEMODE:WeaponDeployed( self.Owner, self ) return true else self:SetViewModelColor ( Color(255,255,255,255) ) 
	end
	
end

function SWEP:OnDeploy()

end

function SWEP:PrecacheModels()

	for k, v in pairs( self.VElements ) do
		if v.model then
			util.PrecacheModel(v.model)
		end
	end
	for k, v in pairs( self.WElements ) do
		if v.model then
			util.PrecacheModel(v.model)
		end
	end
end

function SWEP:Precache()
	util.PrecacheModel(self.ViewModel)
	util.PrecacheModel(self.WorldModel)
end

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
	
	if not self.NoDeployDelay then
		self:SetDeploySpeed ( self.DeploySpeed )
	end
		
    if CLIENT then
		self:InitializeClientsideModels()
		self:PrecacheModels()
		self:CreateViewModelElements()
		self:CreateWorldModelElements()
	end
	
	self:OnInitialize()
	
	
end
function SWEP:CreateViewModelElements()
	
	self:CreateModels(self.VElements)
	
	 self.BuildViewModelBones = function( s )
		if LocalPlayer():GetActiveWeapon() == self and self.ViewModelBoneMods then
			for k, v in pairs( self.ViewModelBoneMods ) do
				local bone = s:LookupBone(k)
				if (not bone) then continue end
				local m = s:GetBoneMatrix(bone)
				if (not m) then continue end
				m:Scale(v.scale)
				m:Rotate(v.angle)
				m:Translate(v.pos)
				s:SetBoneMatrix(bone, m)
			end
		end
	end   

	MakeNewArms(self)
	
end

function SWEP:UpdateBonePositions(vm)
	
	if LocalPlayer():GetActiveWeapon() == self and self.ViewModelBoneMods then
		for k, v in pairs( self.ViewModelBoneMods ) do
			local bone = vm:LookupBone(k)
			if (not bone) then continue end
			if vm:GetManipulateBoneScale(bone) ~= v.scale then
				vm:ManipulateBoneScale( bone, v.scale )
			end
			if vm:GetManipulateBoneAngles(bone) ~= v.angle then
				vm:ManipulateBoneAngles( bone, v.angle )
			end
			if vm:GetManipulateBonePosition(bone) ~= v.pos then
				vm:ManipulateBonePosition( bone, v.pos )
			end
		end
	else
		for i=0, vm:GetBoneCount() do
			if vm:GetManipulateBoneScale(i) ~= Vector(1, 1, 1) then
				vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			end
			if vm:GetManipulateBoneAngles(i) ~= Angle(0, 0, 0)  then
				vm:ManipulateBoneAngles( i, Angle(0, 0, 0)  )
			end
			if vm:GetManipulateBonePosition(i) ~= Vector(0, 0, 0) then
				vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
			end
		end
	end
	
end

function SWEP:ResetBonePositions()
	
	if not self.Owner then return end
	local vm = self.Owner.GetViewModel and self.Owner:GetViewModel()
	if not IsValid(vm) then return end
	
	if vm:GetBoneCount() then
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
	end	
end

function SWEP:CreateWorldModelElements()
	self:CreateModels(self.WElements)
end

function SWEP:CheckModelElements()
	if not self.VElements then
		timer.Simple(0,function()
			self:InitializeClientsideModels()
			self:CreateViewModelElements()
			self:CreateWorldModelElements()
		end)
	end
end

function SWEP:CheckWorldModelElements()
	if not self.WElements then
		timer.Simple(0,function()
			self:InitializeClientsideModels()
			self:CreateWorldModelElements()
		end)
	end
end

function SWEP:OnInitialize()

end

function SWEP:PrimaryAttack()
return false
end

function SWEP:SecondaryAttack()
return false
end

function SWEP:Reload()
return false
end

function SWEP:Think()
	
	if CLIENT then
		-- check existance of models
		-- self:CheckModelElements()
	end
	
	-- self:OnThink()
end

function SWEP:OnThink()

end

function SWEP:Holster()

	if CLIENT then
		self:ResetBonePositions()
		RestoreViewmodel(self.Owner)
    end
	
	self:OnHolster()
	
	return true
end

function SWEP:OnHolster()

end

function SWEP:OnRemove()
    RemoveNewArms(self)     
    if CLIENT then
		self:ResetBonePositions()
        self:RemoveModels()
		RestoreViewmodel(self.Owner)
    end
	
	self:_OnRemove()
     
end

function SWEP:_OnRemove()

end

function SWEP:Equip ( NewOwner )
	if CLIENT then return end
	
	self:OnEquip()
			
	-- Call this function to update weapon slot and others
	gamemode.Call ( "OnWeaponEquip", NewOwner, self )
end

function SWEP:OnEquip()

end

function SWEP:OnDrop()
	-- RemoveNewArms(self)
	self:_OnDrop()
end

function SWEP:_OnDrop()
end

function SWEP:OnViewModelDrawn()

end

if CLIENT then

	local render = render
	local table = table
	local pairs = pairs
	local cam = cam

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		
		self.ViewModelFOV = GetConVarNumber("_zs_wepfov") or self.ViewModelFOV
		
		if not self.Owner then return end
		if not self.Owner:IsValid() then return end
		if not self.Owner:IsPlayer() then return end
		
		local vm = self.Owner:GetViewModel()
		if not ValidEntity(vm) then return end
		
		if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then 
		
			vm:SetColor(Color(255,255,255,1))
			vm:SetRenderMode(RENDERMODE_TRANSALPHA) 
			--[[if vm:GetMaterial() ~= "Debug/hsv" then 
				vm:SetMaterial("Debug/hsv")	
			end]]		
			self:DrawWorldModel()
		
		return end
		
		if not self.OldShowViewModel then
			self.OldShowViewModel = self.ShowViewModel or true
		end
		
		if not self.OldViewModelFlip then
			self.OldViewModelFlip = self.ViewModelFlip or false
		end
		
		--[==[if util.tobool(GetConVarNumber("_zs_clhands")) then
			if self.AlwaysDrawViewModel then
				self.ShowViewModel = true
			else
				self.ShowViewModel = false
			end
			-- self.ViewModelFlip = false
		else
			-- self.ViewModelFlip = self.OldViewModelFlip or false
			self.ShowViewModel = self.OldShowViewModel or true
		end]==]
		
		-- vm:SetRenderMode(RENDERMODE_TRANSALPHA) 
		
		if (self.ShowViewModel == nil or self.ShowViewModel) then
			vm:SetColor(Color(255,255,255,255))
			vm:SetRenderMode(RENDERMODE_TRANSCOLOR) 
			--[[if vm:GetMaterial() ~= "" then 
				vm:SetMaterial("")	
			end]]
		else
			--  we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
			vm:SetColor(Color(255,255,255,1)) 
			vm:SetRenderMode(RENDERMODE_TRANSALPHA) 
			--[[if vm:GetMaterial() ~= "Debug/hsv" then 
				vm:SetMaterial("Debug/hsv")	
			end]]
		end
		
		
		
		if self.CheckModelElements then
			self:CheckModelElements()	
		end
			
			
		--[[if vm.BuildBonePositions ~= self.BuildViewModelBones then
			vm.BuildBonePositions = self.BuildViewModelBones
		end]]
		
		if not self._ResetBoneMods then
			self:ResetBonePositions()
			self._ResetBoneMods = true
		end
		
		self:UpdateBonePositions(vm)
		
		self:OnViewModelDrawn()

		--UpdateArms(self) -- testing
		
		if (not self.VElements) then return end
		
		if (not self.vRenderOrder) then
			
			--  we build a render order because sprites need to be drawn after models
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
			if (not v) then self.vRenderOrder = nil break end
		
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (not v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (not pos) then continue end
			
			if (v.type == "Model" and ValidEntity(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				local size = (v.size.x + v.size.y + v.size.z)/3
				
				model:SetAngles(ang)
				model:SetModelScale(size,0)
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() ~= v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin ~= model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) ~= v) then
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
		
		if self.Owner.IsHolding and self.Owner:IsHolding() then return end
		
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
				if self.Owner.KnockedDown and ValidEntity(self.Owner:GetRagdollEntity()) then
					local bone1 = self.Owner:GetRagdollEntity():LookupBone("ValveBiped.Bip01_R_Hand")
					if (bone1) then
					pos1, ang1 = Vector(0,0,0), Angle(0,0,0)
					local m1 = self.Owner:GetRagdollEntity():GetBoneMatrix(bone1)
						if (m1) then
							pos1, ang1 = m1:GetTranslation(), m1:GetAngles()
							-- self:SetPos(pos1)
							-- self:SetAngles(ang1)
							-- print(tostring(pos1))
						end
					end	
				end
			self:DrawModel()
		end
		
		if self.CheckWorldModelElements then
			self:CheckWorldModelElements()	
		end
		
		if (not self.WElements) then return end
		
		if (not self.wRenderOrder) then

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
			if self.Owner.KnockedDown and ValidEntity(self.Owner:GetRagdollEntity()) then
				bone_ent = self.Owner:GetRagdollEntity()
			else
				bone_ent = self.Owner
			end
		else
			--  when the weapon is dropped
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (not v) then self.wRenderOrder = nil break end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (not pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and ValidEntity(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				local size = (v.size.x + v.size.y + v.size.z)/3
				
				model:SetAngles(ang)
				model:SetModelScale(size,0)
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() ~= v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin ~= model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) ~= v) then
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
		if (tab.rel and tab.rel ~= "") then
			
			local v = basetab[tab.rel]
			
			if (not v) then return end
			
			--  Technically, if there exists an element with the same name as a bone
			--  you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (not pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (not bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (ValidEntity(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r --  Fixes mirrored models
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (not tab) then return end

		--  Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model ~= "" and (not ValidEntity(v.modelEnt) or v.createdModel ~= v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model,"GAME") ) then
				
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
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite ~= "" and (not v.spriteMaterial or v.createdSprite ~= v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt","GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				--  make sure we create a unique name based on the selected options
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

	-- function SWEP:OnRemove()
	-- 	self:RemoveModels()
		
	-- 	RemoveNewArms(self)
		
	-- end

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


