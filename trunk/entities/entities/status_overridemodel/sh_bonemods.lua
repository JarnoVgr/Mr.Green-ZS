-- Store all bone shit in different file
ENT.BoneMods = {}

local pairs = pairs


UndeadBuildBonePositions = {}

UndeadBuildBonePositions[10] = function(s)
	
	local Bone = s:LookupBone("ValveBiped.Bip01_Spine4")
	if Bone then
		s:ManipulateBoneAngles( Bone, Angle(0,88,-90)  )
		-- s:ManipulateBoneScale( Bone, Vector(1.4,1.4,1.4)  )
	end
	local Bone = s:LookupBone("ValveBiped.Bip01_L_UpperArm")
	if Bone then
		s:ManipulateBoneAngles( Bone, Angle(90,0,0)  )
	end
	local Bone = s:LookupBone("ValveBiped.Bip01_Spine1")
	if Bone then
	-- 	s:ManipulateBoneAngles( Bone, Angle(0,0,-90)  )
	end
	local Bone = s:LookupBone("ValveBiped.Bip01_Spine")
	if Bone then
	-- 	s:ManipulateBoneAngles( Bone, Angle(0,0,-90)  )
	end
	for i = 0, s:GetBoneCount() - 1 do
		s:ManipulateBoneScale( Bone, Vector(1.4,1.4,1.4)  )
	end
	
end


UndeadBuildBonePositions[13] = function(s)
	
	local bonemods ={
		["ValveBiped.Bip01_Spine2"] = { scale = Vector(1.45, 2.042, 1.595), pos = Vector(-1.522, 0, 0), angle = Angle(1.866, 3.476, 0) },
		["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1.613, 1.613, 1.613), pos = Vector(4.329, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1.468, 1.468, 1.468), pos = Vector(2.196, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_Head1"] = { scale = Vector(1.236, 1.236, 1.236), pos = Vector(-3.175, 6.052, -1.283), angle = Angle(-19.167, -64.113, 175.925) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1.381, 1.381, 1.381), pos = Vector(1.141, 5.885, 0), angle = Angle(17.159, 0, 0) },
		["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(0.663, 0.663, 0.663), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1.569, 1.569, 1.569), pos = Vector(4.179, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_Pelvis"] = { scale = Vector(0.476, 0.476, 0.476), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1.855, 1.855, 1.855), pos = Vector(1.363, 5.541, 4.993), angle = Angle(-33.896, 23.006, 0) },
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1.57, 1.57, 1.57), pos = Vector(5.177, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(0.519, 0.519, 0.519), pos = Vector(-6.999, 0, 0), angle = Angle(42.909, 24.655, 0) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(0.625, 0.625, 0.625), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1.195, 1.195, 1.195), pos = Vector(5.723, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1.161, 1.161, 1.161), pos = Vector(2.362, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_Spine1"] = { scale = Vector(0.356, 0.356, 0.356), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Finger32"] = { scale = Vector(1.952, 1.952, 1.952), pos = Vector(1.24, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-33.003, -33.201, 32.219) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1.33, 1.33, 1.33), pos = Vector(4.993, 0, 0), angle = Angle(0, -34.959, 0) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1.48, 1.48, 1.48), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	
		for k, v in pairs( bonemods ) do
			local bone = s:LookupBone(k)
			if (not bone) then continue end
			s:ManipulateBoneScale( bone, v.scale  )
			s:ManipulateBoneAngles( bone, v.angle  )
			s:ManipulateBonePosition( bone, v.pos  )
		end
	
end


--Hate
ENT.BoneMods["hate"] = function(s)

		local Bone = s:LookupBone("ValveBiped.Bip01_Spine4")
		if Bone then
			s:ManipulateBoneAngles( Bone, Angle(0,88,-90)  )
			s:ManipulateBoneScale( Bone, Vector(1.2,1.2,1.2)  )
		end
		local Bone = s:LookupBone("ValveBiped.Bip01_Spine2")
		if Bone then
			s:ManipulateBoneAngles( Bone, Angle(0,0,-90)  )
		end
		local Bone = s:LookupBone("ValveBiped.Bip01_Spine1")
		if Bone then
			s:ManipulateBoneAngles( Bone, Angle(0,0,-90)  )
		end
		local Bone = s:LookupBone("ValveBiped.Bip01_Spine")
		if Bone then
			s:ManipulateBoneAngles( Bone, Angle(0,0,-90)  )
		end
		for i = 0, s:GetBoneCount() - 1 do
			s:ManipulateBoneScale( Bone, Vector(1.2,1.2,1.2)  )
		end
	end
	
	
--Hate II
ENT.BoneMods["hate2"] = function(s)

	local Bone = s:LookupBone("ValveBiped.Bip01_Spine4")
			if Bone then
				local mMatrix = s:GetBoneMatrix(Bone)
				if mMatrix then
					mMatrix:Rotate(Angle(180,-141,-90))
					mMatrix:Scale(Vector(1.2,1.2,1.2))
					s:SetBoneMatrix(Bone, mMatrix)
				end
			end
		local Bone = s:LookupBone("ValveBiped.Bip01_Spine2")
			if Bone then
				local mMatrix = s:GetBoneMatrix(Bone)
				if mMatrix then
					mMatrix:Rotate(Angle(0,0,-90))
					s:SetBoneMatrix(Bone, mMatrix)
				end
			end
		local Bone = s:LookupBone("ValveBiped.Bip01_Spine1")
			if Bone then
				local mMatrix = s:GetBoneMatrix(Bone)
				if mMatrix then
					mMatrix:Rotate(Angle(0,0,-90))
					s:SetBoneMatrix(Bone, mMatrix)
				end
			end
		local Bone = s:LookupBone("ValveBiped.Bip01_Spine")
			if Bone then
				local mMatrix = s:GetBoneMatrix(Bone)
				if mMatrix then
					mMatrix:Rotate(Angle(0,0,-90))
					s:SetBoneMatrix(Bone, mMatrix)
				end
			end
		for i = 0, s:GetBoneCount() - 1 do
				local name = s:GetBoneName(i)
				local bone = s:LookupBone(name)
				if bone then
					local mMatrix = s:GetBoneMatrix(bone)
						if mMatrix then
							mMatrix:Scale(Vector(1.3,1.3,1.3))
							s:SetBoneMatrix(bone, mMatrix)
						end
				end
		end

	end


--Behemoth	
ENT.BoneMods["behe"] = function(s)
	
	local bones = {
		"_L_",
		"_R_"
	}
	
	local i = 1
		for _, bonetbl in pairs(bones) do
		local Bone = s:LookupBone("ValveBiped.Bip01"..bonetbl.."Clavicle")-- UpperArm
			if Bone then
				local mMatrix = s:GetBoneMatrix(Bone)
				if mMatrix then
					-- mMatrix:Rotate(Angle(0,88,-90))
					mMatrix:Scale(Vector(1.4*i,1.4*i,1.4*i))
					s:SetBoneMatrix(Bone, mMatrix)
				end
			end
		local Bone = s:LookupBone("ValveBiped.Bip01"..bonetbl.."UpperArm")
			if Bone then
				local mMatrix = s:GetBoneMatrix(Bone)
				if mMatrix then
					-- mMatrix:Rotate(Angle(0,88,-90))
					mMatrix:Scale(Vector(1.4*i,1.4*i,1.4*i))
					s:SetBoneMatrix(Bone, mMatrix)
				end
			end
		local Bone = s:LookupBone("ValveBiped.Bip01"..bonetbl.."ForeArm")
			if Bone then
				local mMatrix = s:GetBoneMatrix(Bone)
				if mMatrix then
					-- mMatrix:Rotate(Angle(0,88,-90))
					mMatrix:Scale(Vector(1.35*i,1.35*i,1.35*i))
					s:SetBoneMatrix(Bone, mMatrix)
				end
			end
		local Bone = s:LookupBone("ValveBiped.Bip01"..bonetbl.."Hand")
			if Bone then
				local mMatrix = s:GetBoneMatrix(Bone)
				if mMatrix then
					-- mMatrix:Rotate(Angle(0,88,-90))
					mMatrix:Scale(Vector(1.42*i,1.42*i,1.42*i))
					s:SetBoneMatrix(Bone, mMatrix)
				end
			end
		i=0.6
		end

	end
	
	--Lilith
	ENT.BoneMods["lilith"] = function(s)
	
	local bones = {
		"_L_",
		"_R_"
	}
	
	local i = 1
		for _, bonetbl in pairs(bones) do
		local Bone = s:LookupBone("ValveBiped.Bip01"..bonetbl.."Clavicle")-- UpperArm
			if Bone then
				local mMatrix = s:GetBoneMatrix(Bone)
				if mMatrix then
					-- mMatrix:Rotate(Angle(0,88,-90))
					mMatrix:Scale(Vector(1.4*i,1.4*i,1.4*i))
					s:SetBoneMatrix(Bone, mMatrix)
				end
			end
		local Bone = s:LookupBone("ValveBiped.Bip01"..bonetbl.."UpperArm")
			if Bone then
				local mMatrix = s:GetBoneMatrix(Bone)
				if mMatrix then
					-- mMatrix:Rotate(Angle(0,88,-90))
					mMatrix:Scale(Vector(1.4*i,1.4*i,1.4*i))
					s:SetBoneMatrix(Bone, mMatrix)
				end
			end
		local Bone = s:LookupBone("ValveBiped.Bip01"..bonetbl.."ForeArm")
			if Bone then
				local mMatrix = s:GetBoneMatrix(Bone)
				if mMatrix then
					-- mMatrix:Rotate(Angle(0,88,-90))
					mMatrix:Scale(Vector(1.35*i,1.35*i,1.35*i))
					s:SetBoneMatrix(Bone, mMatrix)
				end
			end
		local Bone = s:LookupBone("ValveBiped.Bip01"..bonetbl.."Hand")
			if Bone then
				local mMatrix = s:GetBoneMatrix(Bone)
				if mMatrix then
					-- mMatrix:Rotate(Angle(0,88,-90))
					mMatrix:Scale(Vector(1.42*i,1.42*i,1.42*i))
					s:SetBoneMatrix(Bone, mMatrix)
				end
			end
		i=0.6
		end

	end
ENT.BoneMods["seeker"] = function(s)
	
	for i = 0, s:GetBoneCount() - 1 do
		local name = s:GetBoneName(i)
		if not (string.find(name,"Head") or string.find(name,"Neck") or string.find(name,"Spine4") ) then
			local bone = s:LookupBone(name)
			if bone then
				local mMatrix = s:GetBoneMatrix(bone)
					if mMatrix then
						mMatrix:Scale(Vector(1.27,1.27,1.27))
						s:SetBoneMatrix(bone, mMatrix)
					end
			end
		end
	end
	
end

ENT.BoneMods["nerf"] = function(s)
	
	local bonemods ={
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1.434, 1.434, 1.434), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1.6, 1.6, 1.6), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1.6, 1.6, 1.6), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1.6, 1.6, 1.6), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_Spine1"] = { scale = Vector(0.865, 2.506, 0.754), pos = Vector(5, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_Spine4"] = { scale = Vector(1, 1, 1), pos = Vector(11.706, -8.563, 0.118), angle = Angle(0, -14.207, 180) },
		["ValveBiped.Bip01_Spine2"] = { scale = Vector(1.44, 2.194, 1.546), pos = Vector(8.381, 0, 0), angle = Angle(0, 4.736, 0) },
		["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(1.6, 1.6, 1.6), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_Spine"] = { scale = Vector(2.575, 2.099, 1.924), pos = Vector(0, 0, 0), angle = Angle(0, 34.293, 0) },
		["ValveBiped.Bip01_Pelvis"] = { scale = Vector(0.981, 1.597, 1.58), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1.085, 1.085, 1.085), pos = Vector(1.687, 0, 0), angle = Angle(38.631, 18.493, 0) },
		["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(2.25, 2.25, 2.25), pos = Vector(0.706, 3, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1.169, 1.169, 1.169), pos = Vector(1.381, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Thigh"] = { scale = Vector(1, 0.899, 1.378), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Toe0"] = { scale = Vector(1.6, 1.6, 1.6), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_Head1"] = { scale = Vector(1.55, 1.55, 1.55), pos = Vector(5, 4, 0), angle = Angle(0, -30, 180) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(2.219, 2.219, 2.219), pos = Vector(0.706, 3, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Toe0"] = { scale = Vector(1.6, 1.6, 1.6), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(1.6, 1.6, 1.6), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1.399, 1.399, 1.399), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1.6, 1.6, 1.6), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }}
	
		for k, v in pairs( bonemods ) do
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

--------------------------------------------------------------------------------------------

function ENT:SetBoneMods(t)
	if t and self.BoneMods[t] then
		-- self.BuildBonePositions = self.BoneMods[t]
		self.BoneMods[t][1](self)
		self.SetBoneMods = true
	end

end	

function ENT:ResetBoneMods()
	
	local vm = self
	
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

	