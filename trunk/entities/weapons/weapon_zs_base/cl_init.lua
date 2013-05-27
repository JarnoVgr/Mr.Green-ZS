include("shared.lua")

SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = true
SWEP.CSMuzzleFlashes = true
SWEP.BobScale = 2
SWEP.SwayScale = 1.5
SWEP.Slot = 0
SWEP.ShowViewModel = true

SWEP.IronsightsMultiplier = 0.6

function SWEP:TranslateFOV(fov)
	return GAMEMODE.FOVLerp * fov
end

function SWEP:AdjustMouseSensitivity()
	if self:GetIronsights() then
		return GAMEMODE.FOVLerp
	end
end

function SWEP:Think()
	if self:GetIronsights() and not self.Owner:KeyDown(IN_ATTACK2) then
		self:SetIronsights(false)
	end
end

function SWEP:GetIronsightsDeltaMultiplier()
	local bIron = self:GetIronsights()
	local fIronTime = self.fIronTime or 0

	if not bIron and fIronTime < CurTime() - 0.25 then 
		return 0
	end

	local Mul = 1

	if fIronTime > CurTime() - 0.25 then
		Mul = math.Clamp((CurTime() - fIronTime) * 4, 0, 1)
		if not bIron then Mul = 1 - Mul end
	end

	return Mul
end

local ghostlerp = 0
function SWEP:GetViewModelPosition(pos, ang)
	local bIron = self:GetIronsights()

	if bIron ~= self.bLastIron then
		self.bLastIron = bIron 
		self.fIronTime = CurTime()

		if bIron then 
			self.SwayScale = 0.3
			self.BobScale = 0.1
		else 
			self.SwayScale = 2.0
			self.BobScale = 1.5
		end
	end

	local Mul = math.Clamp((CurTime() - (self.fIronTime or 0)) * 4, 0, 1)
	if not bIron then Mul = 1 - Mul end

	if Mul > 0 then
		local Offset = self.IronSightsPos
		if self.IronSightsAng then
			ang = Angle(ang.p, ang.y, ang.r)
			ang:RotateAroundAxis(ang:Right(), self.IronSightsAng.x * Mul)
			ang:RotateAroundAxis(ang:Up(), self.IronSightsAng.y * Mul)
			ang:RotateAroundAxis(ang:Forward(), self.IronSightsAng.z * Mul)
		end

		pos = pos + Offset.x * Mul * ang:Right() + Offset.y * Mul * ang:Forward() + Offset.z * Mul * ang:Up()
	end

	if ghostlerp > 0 then
		ghostlerp = math.max(0, ghostlerp - FrameTime() * 5)
	end

	if ghostlerp > 0 then
		pos = pos + 3.5 * ghostlerp * ang:Up()
		ang:RotateAroundAxis(ang:Right(), -30 * ghostlerp)
	end

	return pos, ang
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
end

function SWEP:DrawHUD()
	self:DrawCrosshair()
end

local OverrideIronSights = {}
function SWEP:CheckCustomIronSights()
	local class = self:GetClass()
	if OverrideIronSights[class] then
		if type(OverrideIronSights[class]) == "table" then
			self.IronSightsPos = OverrideIronSights[class].Pos
			self.IronSightsAng = OverrideIronSights[class].Ang
		end

		return
	end

	local filename = "ironsights/"..class..".txt"
	if file.Exists(filename, "DATA") then
		local pos = Vector(0, 0, 0)
		local ang = Vector(0, 0, 0)

		local tab = string.Explode(" ", file.Read(filename, "DATA"))
		pos.x = tonumber(tab[1]) or 0
		pos.y = tonumber(tab[2]) or 0
		pos.z = tonumber(tab[3]) or 0
		ang.x = tonumber(tab[4]) or 0
		ang.y = tonumber(tab[5]) or 0
		ang.z = tonumber(tab[6]) or 0

		OverrideIronSights[class] = {Pos = pos, Ang = ang}

		self.IronSightsPos = pos
		self.IronSightsAng = ang
	else
		OverrideIronSights[class] = true
	end
end
	
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
		
		--vm:SetRenderMode(RENDERMODE_TRANSCOLOR) 
		
		if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then 	
			vm:SetColor(Color(255,255,255,1))
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
		
		if util.tobool(GetConVarNumber("_zs_clhands")) then
			if self.AlwaysDrawViewModel then
				self.ShowViewModel = true
			else
				self.ShowViewModel = false
			end
			-- self.ViewModelFlip = false
		else
			-- self.ViewModelFlip = self.OldViewModelFlip or false
			self.ShowViewModel = self.OldShowViewModel or true
		end
		
		if (self.ShowViewModel == nil or self.ShowViewModel) then
			vm:SetColor(Color(255,255,255,255))
			--[[if vm:GetMaterial() == "Debug/hsv" then 
				vm:SetMaterial("")	
			end]]
		else
			--  we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
			vm:SetColor(Color(255,255,255,1)) 
			--[[if vm:GetMaterial() ~= "Debug/hsv" then 
				vm:SetMaterial("Debug/hsv")	
			end]]
		end
		
		vm:SetRenderMode(RENDERMODE_TRANSALPHA) 

		if self.CheckModelElements then
			self:CheckModelElements()	
		end
		
		if not self._ResetBoneMods then
			self:ResetBonePositions()
			self._ResetBoneMods = true
		end
		
		self:UpdateBonePositions(vm)
		
		
		--[[if vm.BuildBonePositions ~= self.BuildViewModelBones then
			vm.BuildBonePositions = self.BuildViewModelBones
		end]]

		--UpdateArms(self) -- testing
		
		if (not self.VElements) then
			return
		end
		
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
		
		if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then return end	
		
		
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
				if self.Owner.KnockedDown and ValidEntity(self.Owner:GetRagdollEntity()) then
					local bone1 = self.Owner:GetRagdollEntity():LookupBone("ValveBiped.Bip01_R_Hand")
					if (bone1) then
					pos1, ang1 = Vector(0,0,0), Angle(0,0,0)
					local m1 = self.Owner:GetRagdollEntity():GetBoneMatrix(bone)
						if (m1) then
							pos1, ang1 = m1:GetTranslation(), m1:GetAngles()
							--self:SetPos(pos1)
							--self:SetAngles(ang1)
							--print(tostring(pos1))
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
					
					-- set bonemods
					if self.VElementsBoneMods and self.VElementsBoneMods[k] then
						for bn,tbl in pairs(self.VElementsBoneMods[k]) do
							local bone = v.modelEnt:LookupBone(bn)
							if (not bone) then continue end
							v.modelEnt:ManipulateBoneScale( bone, tbl.scale )
							v.modelEnt:ManipulateBoneAngles( bone, tbl.angle )
							v.modelEnt:ManipulateBonePosition( bone, tbl.pos )
						end
					end
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

	function SWEP:OnRemove()
		self:RemoveModels()
		
		RemoveNewArms(self)
		
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

