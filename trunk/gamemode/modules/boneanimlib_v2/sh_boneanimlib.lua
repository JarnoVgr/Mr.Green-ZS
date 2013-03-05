--[=[

Bone Animations Library
Created by William "JetBoom" Moodhe (williammoodhe@gmail.com / www.noxiousnet.com)
Because I wanted custom, dynamic animations.
Give credit or reference if used in your creations.

]=]

TYPE_GESTURE = 0 -- Gestures are keyframed animations that use the current position and angles of the bones. They play once and then stop automatically.
TYPE_POSTURE = 1 -- Postures are static animations that use the current position and angles of the bones. They stay that way until manually stopped. Use TimeToArrive if you want to have a posture lerp.
TYPE_STANCE = 2 -- Stances are keyframed animations that use the current position and angles of the bones. They play forever until manually stopped. Use RestartFrame to specify a frame to go to if the animation ends (instead of frame 1).
TYPE_SEQUENCE = 3 -- Sequences are keyframed animations that use the reference pose. They play forever until manually stopped. Use RestartFrame to specify a frame to go to if the animation ends (instead of frame 1).
-- You can also use StartFrame to specify a starting frame for the first loop.

local Animations = {}

function GetLuaAnimations()
	return Animations
end

function RegisterLuaAnimation(sName, tInfo)
	if tInfo.FrameData then
		local BonesUsed = {}
		for iFrame, tFrame in ipairs(tInfo.FrameData) do
			for iBoneID, tBoneTable in pairs(tFrame.BoneInfo) do
				BonesUsed[iBoneID] = (BonesUsed[iBoneID] or 0) + 1
				tBoneTable.MU = tBoneTable.MU or 0
				tBoneTable.MF = tBoneTable.MF or 0
				tBoneTable.MR = tBoneTable.MR or 0
				tBoneTable.RU = tBoneTable.RU or 0
				tBoneTable.RF = tBoneTable.RF or 0
				tBoneTable.RR = tBoneTable.RR or 0
			end
		end

		if #tInfo.FrameData > 1 then
			for iBoneUsed, iTimesUsed in pairs(BonesUsed) do
				for iFrame, tFrame in ipairs(tInfo.FrameData) do
					if not tFrame.BoneInfo[iBoneUsed] then
						tFrame.BoneInfo[iBoneUsed] = {MU = 0, MF = 0, MR = 0, RU = 0, RF = 0, RR = 0}
					end
				end
			end
		end
	end
	Animations[sName] = tInfo
end

-- This copies a potential FrameData table from an entity. It's pretty experimental but can be used to copy real animations in to lua animations.
-- Only viable for making custom sequences or perhaps copying animations from one model to another.
local bonehierarchy = {
	[1] = {"ValveBiped.Bip01", -1},
	[2] = {"ValveBiped.Bip01_Pelvis", 1},
	[3] = {"ValveBiped.Bip01_L_Thigh", 2},
	[4] = {"ValveBiped.Bip01_L_Calf", 3},
	[5] = {"ValveBiped.Bip01_L_Foot", 4},
	[6] = {"ValveBiped.Bip01_L_Toe0", 5},
	[7] = {"ValveBiped.Bip01_R_Thigh", 2},
	[8] = {"ValveBiped.Bip01_R_Calf", 7},
	[9] = {"ValveBiped.Bip01_R_Foot", 8},
	[10] = {"ValveBiped.Bip01_R_Toe0", 9},
	[11] = {"ValveBiped.Bip01_Spine", 1},
	[12] = {"ValveBiped.Bip01_Spine1", 11},
	[13] = {"ValveBiped.Bip01_Spine2", 12},
	[14] = {"ValveBiped.Bip01_Spine4", 13},
	[15] = {"ValveBiped.Bip01_Neck1", 14},
	[16] = {"ValveBiped.Bip01_Head1", 15},
	[17] = {"ValveBiped.Bip01_L_Clavicle", 14},
	[18] = {"ValveBiped.Bip01_L_UpperArm", 17},
	[19] = {"ValveBiped.Bip01_L_Forearm", 18},
	[20] = {"ValveBiped.Bip01_L_Hand", 19},
	[21] = {"ValveBiped.Bip01_L_Finger2", 20},
	[22] = {"ValveBiped.Bip01_L_Finger21", 21},
	[23] = {"ValveBiped.Bip01_L_Finger22", 22},
	[24] = {"ValveBiped.Bip01_L_Finger1", 20},
	[25] = {"ValveBiped.Bip01_L_Finger11", 24},
	[26] = {"ValveBiped.Bip01_L_Finger12", 25},
	[27] = {"ValveBiped.Bip01_L_Finger0", 20},
	[28] = {"ValveBiped.Bip01_L_Finger01", 27},
	[29] = {"ValveBiped.Bip01_L_Finger02", 28},
	[30] = {"ValveBiped.Bip01_R_Clavicle", 14},
	[31] = {"ValveBiped.Bip01_R_UpperArm", 30},
	[32] = {"ValveBiped.Bip01_R_Forearm", 31},
	[33] = {"ValveBiped.Bip01_R_Hand", 32},
	[34] = {"ValveBiped.Bip01_R_Finger2", 33},
	[35] = {"ValveBiped.Bip01_R_Finger21", 34},
	[36] = {"ValveBiped.Bip01_R_Finger22", 35},
	[37] = {"ValveBiped.Bip01_R_Finger1", 33},
	[38] = {"ValveBiped.Bip01_R_Finger11", 37},
	[39] = {"ValveBiped.Bip01_R_Finger12", 38},
	[40] = {"ValveBiped.Bip01_R_Finger0", 33},
	[41] = {"ValveBiped.Bip01_R_Finger01", 40},
	[42] = {"ValveBiped.Bip01_R_Finger02", 41}
}

local absoluteangles = {
		["valvebiped.bip01_r_upperarm"] = 
				Angle(49.711448669434,
				-94.168640136719,
				176.81544494629)
		,
		["valvebiped.bip01_l_upperarm"] = 
				Angle(49.711971282959,
				94.169876098633,
				3.1844043731689)
		,
		["valvebiped.bip01_neck1"] = 
				
				Angle(-55,
				0,
				90)
		,
		["valvebiped.bip01_spine1"] = 
			
				Angle(-85,
				180,
				90)
		,
		["valvebiped.bip01_r_foot"] = 
				
				Angle(33.5,
				-3,
				-90)
		,
		["valvebiped.bip01_spine2"] = 
				
				Angle(-90,
				0,
				-90)
		,
		["valvebiped.bip01_l_toe0"] = 
				
				Angle(0,
				3,
				-90)
		,
		["valvebiped.bip01_spine"] = 
				
				Angle(-86.7,
				180,
				90)
		,
		["valvebiped.bip01_head1"] = 
				
				Angle(-80.2,
				0,
				90)
		,
		["valvebiped.bip01_l_hand"] = 
				
				Angle(43.64,
				92.4,
				92)
		,
		["valvebiped.bip01_r_thigh"] = 
				
				Angle(87,
				-174,
				95.752479553223)
		,
		["valvebiped.bip01_r_forearm"] = 
				
				Angle(49,
				-90,
				-180)
		,
		["valvebiped.bip01_l_calf"] = 
				
				Angle(85,
				176.5,
				86)
		,
		["valvebiped.bip01_r_hand"] = 
				
				Angle(43.649658203125,
				-92.428482055664,
				88.468475341797)
		,
		["valvebiped.bip01_r_calf"] = 
				
				Angle(85.057647705078,
				-176.53114318848,
				93.478614807129)
		,
		["valvebiped.bip01_l_thigh"] = 
				
				Angle(87.011680603027,
				174.25263977051,
				84.247940063477)
		,
		["valvebiped.bip01_r_clavicle"] = 
				Angle(16,
				-90,
				84)
		,
		["valvebiped.bip01_spine4"] = 
				
				Angle(-78,
				0,
				-90)
		,
		["valvebiped.bip01_l_forearm"] = 
				
				Angle(50,
				90,
				0)
		,
		["valvebiped.bip01_l_clavicle"] = 
				
				Angle(15,
				90,
				92)
		,
		["valvebiped.bip01_r_toe0"] = 
				Angle(0,
				-3,
				-94)
		,
		["valvebiped.bip01_l_foot"] = 
				
				Angle(33.485752105713,
				2.9971539974213,
				-90)
}

function GetBoneParent(bonename)
	local lowername = string.lower(bonename)
	for k, v in pairs(bonehierarchy) do
		if string.lower(v[1]) == lowername then
			local parentid = v[2]
			if bonehierarchy[parentid] then
				return bonehierarchy[parentid][1]
			end
		end
	end
end

function GetBoneParentID(boneid)
	local v = bonehierarchy[boneid]
	if v then
		return v[2]
	end
end

--[=[function GetRelativeBoneAngles(ent, bonename,
								parentangles)

	local boneindex = ent:LookupBone(bonename)
	if not boneindex then return parentangles end
	local matrix = ent:GetBoneMatrix(boneindex)
	if not matrix then return parentangles end

	local ang = matrix:GetAngles()

	if parentangles then
		ang = ang - parentangles
	end

	local parent = GetBoneParent(bonename)
	if not parent or parent == bonename then return ang end

	return GetRelativeBoneAngles(ent, parent, ang)
end]=]

-- Gets angles relative to the parent's angles.
function GetRelativeBoneAngles(ent, bonename)
	local boneindex = ent:LookupBone(bonename)
	if not boneindex then return parentangles end
	local matrix = ent:GetBoneMatrix(boneindex)
	if not matrix then return parentangles end
	local parent = GetBoneParentID(boneindex)
	if not parent or parent == boneindex then
		return Angle(0, 0, 0) -- No parent? Just return these angles.
	end

	local parentmatrix = ent:GetBoneMatrix(parentmatrix)
	if not parentmatrix then
		return Angle(0, 0, 0)
	end

	local ang = (matrix:GetTranslation() - parentmatrix:GetTranslation()):Angle()
	ang.roll = matrix:GetAngles().roll
	return ang
end

--[=[function GetRelativeBoneAngles(ent, bonename)
	local boneindex = ent:LookupBone(bonename)
	if not boneindex then return parentangles end
	local matrix = ent:GetBoneMatrix(boneindex)
	if not matrix then return parentangles end

	local parent = GetBoneParentID(boneindex)
	if not parent or parent == boneindex then
		return matrix:GetAngles() -- No parent? Just return these angles.
	end

	local parentmatrix = ent:GetBoneMatrix(parentmatrix)
	if not parentmatrix then
		return matrix:GetAngles()
	end

	local parentangles = parentmatrix:GetAngles() - (absoluteangles[string.lower(ent:GetBoneName(parent) or "")] or Angle(0, 0, 0))

	return matrix:GetAngles() - parentangles
end]=]

function CopyFrameData(ent)
	local framedata = {BoneInfo = {}, FrameRate = 1}

	for i=1, ent:GetBoneCount() - 1 do -- Bone 0 is not needed.
		local matrix = ent:GetBoneMatrix(i)
		if matrix then
			local bonename = ent:GetBoneName(i)
			local relangles = GetRelativeBoneAngles(ent, bonename)
			if relangles then
				local tab = {}
			
				tab.RR = relangles.pitch
				tab.RU = relangles.yaw
				tab.RF = relangles.roll

				framedata.BoneInfo[bonename] = tab
			end
		end
	end

	return framedata
end

RegisterLuaAnimation('aaaa2', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine'] = {
					RU = 30,
					RR = 30
				},
				['ValveBiped.Bip01_Head1'] = {
				}
			},
			FrameRate = 1
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine'] = {
					RU = -30,
					RR = -30
				},
				['ValveBiped.Bip01_Head1'] = {
					RF = 102
				}
			},
			FrameRate = 1
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Head1'] = {
					RF = -227
				},
				['ValveBiped.Bip01_Spine'] = {
				}
			},
			FrameRate = 1
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Head1'] = {
					RF = 128
				},
				['ValveBiped.Bip01_Spine'] = {
				}
			},
			FrameRate = 1
		}
	},
	RestartFrame = 1,
	Type = TYPE_STANCE
})

-- Pistol!
RegisterLuaAnimation('cast_revolver', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Clavicle'] = {
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Hand'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Clavicle'] = {
					RU = 5,
					RR = 10,
					RF = 3
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -11,
					RR = -33,
					RF = -1
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = -25,
					RR = -33,
					RF = 50
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 45,
					RR = 1,
					RF = 24
				}
			},
			FrameRate = 3.3333333333333
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Clavicle'] = {
					RU = 5,
					RR = 10,
					RF = 3
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -11,
					RR = -33,
					RF = -1
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = -20,
					RR = -60,
					RF = 68
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 45,
					RR = 4,
					RF = 24
				}
			},
			FrameRate = 3.3333333333333
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Clavicle'] = {
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Hand'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				}
			},
			FrameRate = 5
		}
	},
	Type = TYPE_GESTURE
})

-- shotgun
RegisterLuaAnimation('cast_shotgun', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Clavicle'] = {
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Hand'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Clavicle'] = {
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = 10,
					RR = -54,
					RF = 3
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = 22,
					RR = -32,
					RF = 42
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 40,
					RR = -44,
					RF = 15
				}
			},
			FrameRate = 3.3333333333333
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Clavicle'] = {
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RR = -48,
					RF = 10
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = 29,
					RR = -48,
					RF = 55
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 40,
					RR = -33,
					RF = 21
				}
			},
			FrameRate = 3.3333333333333
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Clavicle'] = {
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Hand'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				}
			},
			FrameRate = 3.3333333333333
		}
	},
	Type = TYPE_GESTURE
})

-- ar2
RegisterLuaAnimation('cast_ar2', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Clavicle'] = {
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Hand'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Clavicle'] = {
					RR = -1,
					RF = 10
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -24,
					RR = -42,
					RF = 2
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = 7,
					RR = -75,
					RF = 64
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 38,
					RR = 6,
					RF = 54
				}
			},
			FrameRate = 4
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Clavicle'] = {
					RR = -1,
					RF = 10
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -24,
					RR = -42,
					RF = 2
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = 7,
					RR = -75,
					RF = 64
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 38,
					RR = 6,
					RF = 54
				}
			},
			FrameRate = 4
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_Clavicle'] = {
				},
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Hand'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				}
			},
			FrameRate = 3.3333333333333
		}
	},
	Type = TYPE_GESTURE
})

-- smg
RegisterLuaAnimation('cast_smg', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Hand'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = 6,
					RR = -25,
					RF = -2
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = 41,
					RR = -29,
					RF = 29
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 20
				}
			},
			FrameRate = 3.3333333333333
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = 6,
					RR = -25,
					RF = -2
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = 41,
					RR = -29,
					RF = 29
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 20
				}
			},
			FrameRate = 3.3333333333333
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Hand'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				}
			},
			FrameRate = 5
		}
	},
	Type = TYPE_GESTURE
})

-- crossbow
RegisterLuaAnimation('cast_crossbow', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Hand'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -11,
					RR = -58,
					RF = -13
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = 5,
					RR = -60,
					RF = 74
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 27,
					RR = -9,
					RF = 30
				}
			},
			FrameRate = 3.3333333333333
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -11,
					RR = -58,
					RF = -13
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = 5,
					RR = -60,
					RF = 74
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = 27,
					RR = -9,
					RF = 30
				}
			},
			FrameRate = 3.3333333333333
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Hand'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				}
			},
			FrameRate = 5
		}
	},
	Type = TYPE_GESTURE
})

--[==[ EXAMPLES!

-- If your animation is only used on one model, use numbers instead of bone names (cache the lookup).
-- If it's being used on a wide array of models (including default player models) then you should use bone names.
-- You can use Callback as a function instead of MU, RR, etc. which will allow you to do some interesting things.
-- See cl_boneanimlib.lua for the full format.

STANCE: stancetest
A simple looping stance that stretches the model's spine up and down until stopped.

RegisterLuaAnimation("stancetest", {
	FrameData = {
		{
			BoneInfo = {
				["ValveBiped.Bip01_Spine"] = {
					MU = 64
				}
			},
			FrameRate = 0.25
		},
		{
			BoneInfo = {
				["ValveBiped.Bip01_Spine"] = {
					MU = -32
				}
			},
			FrameRate = 1.5
		},
		{
			BoneInfo = {
				["ValveBiped.Bip01_Spine"] = {
					MU = 32
				}
			},
			FrameRate = 4
		}
	},
	RestartFrame = 2,
	Type = TYPE_STANCE
})

--[=[
STANCE: staffholdspell
To be used with the ACT_HL2MP_IDLE_MELEE2 animation.
Player holds the staff so that their left hand is over the top of it.
]=]

RegisterLuaAnimation("staffholdspell", {
	FrameData = {
		{
			BoneInfo = {
				["ValveBiped.Bip01_R_Forearm"] = {
					RU = 40,
					RF = -40
				},
				["ValveBiped.Bip01_R_Upperarm"] = {
					RU = 40
				},
				["ValveBiped.Bip01_R_Hand"] = {
					RU = -40
				},
				["ValveBiped.Bip01_L_Forearm"] = {
					RU = 40
				},
				["ValveBiped.Bip01_L_Hand"] = {
					RU = -40
				}
			},
			FrameRate = 6
		},
		{
			BoneInfo = {
				["ValveBiped.Bip01_R_Forearm"] = {
					RU = 2,
				},
				["ValveBiped.Bip01_R_Upperarm"] = {
					RU = 1
				},
				["ValveBiped.Bip01_R_Hand"] = {
					RU = -10
				},
				["ValveBiped.Bip01_L_Forearm"] = {
					RU = 8
				},
				["ValveBiped.Bip01_L_Hand"] = {
					RU = -12
				}
			},
			FrameRate = 0.4
		},
		{
			BoneInfo = {
				["ValveBiped.Bip01_R_Forearm"] = {
					RU = -2,
				},
				["ValveBiped.Bip01_R_Upperarm"] = {
					RU = -1
				},
				["ValveBiped.Bip01_R_Hand"] = {
					RU = 10
				},
				["ValveBiped.Bip01_L_Forearm"] = {
					RU = -8
				},
				["ValveBiped.Bip01_L_Hand"] = {
					RU = 12
				}
			},
			FrameRate = 0.1
		}
	},
	RestartFrame = 2,
	Type = TYPE_STANCE,
	ShouldPlay = function(pl, sGestureName, tGestureTable, iCurFrame, tFrameData)
		local wepstatus = pl.WeaponStatus
		return wepstatus and wepstatus:IsValid() and wepstatus:GetSkin() == 1 and wepstatus.IsStaff
	end
})

]==]
