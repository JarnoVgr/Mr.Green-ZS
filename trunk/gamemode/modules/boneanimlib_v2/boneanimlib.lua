if CLIENT then return end

include("sh_boneanimlib.lua")
AddCSLuaFile("cl_boneanimlib.lua")
--AddCSLuaFile("cl_animeditor.lua")
AddCSLuaFile("sh_boneanimlib.lua")



-- These are unreliable. All Lua animations should be set on both the client and server (predicted).
do
local meta = FindMetaTable("Entity")
if not meta then return end

function meta:ResetLuaAnimation(sAnimation, fTime, fPower, fTimeScale)
	--[==[umsg.Start("resetluaanim")
		umsg.Entity(self)
		umsg.String(sAnimation)
		umsg.Float(fTime or -1)
		umsg.Float(fPower or -1)
		umsg.Float(fTimeScale or -1)
	umsg.End()]==]
end

function meta:SetLuaAnimation(sAnimation, fTime, fPower, fTimeScale)
	--[==[umsg.Start("setluaanim")
		umsg.Entity(self)
		umsg.String(sAnimation)
		umsg.Float(fTime or -1)
		umsg.Float(fPower or -1)
		umsg.Float(fTimeScale or -1)
	umsg.End()]==]
end

function meta:StopLuaAnimation(sAnimation, fTime)
	--[==[umsg.Start("stopluaanim")
		umsg.Entity(self)
		umsg.String(sAnimation)
		umsg.Float(fTime or 0)
	umsg.End()]==]
end

function meta:StopLuaAnimationGroup(sAnimation, fTime)
	--[==[umsg.Start("stopluaanimgp")
		umsg.Entity(self)
		umsg.String(sAnimation)
		umsg.Float(fTime or 0)
	umsg.End()]==]
end

function meta:StopAllLuaAnimations(fTime)
	--[==[umsg.Start("stopallluaanim")
		umsg.Entity(self)
		umsg.Float(fTime or 0)
	umsg.End()]==]
end
end
