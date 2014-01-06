--Thanks to JetBoom from Nox

AddCSLuaFile()

if _FIXEDEMITTERS_ or not CLIENT then return end
_FIXEDEMITTERS_ = true

local _GLOBAL_PARTICLE_EMITTER_use3D
local _GLOBAL_PARTICLE_EMITTER_use2D
local PARTICLE_EMITTER = ParticleEmitter

function ParticleEmitter( _pos, _use3D )
	if ( _use3D ) then
		if ( !_GLOBAL_PARTICLE_EMITTER_use3D ) then
			_GLOBAL_PARTICLE_EMITTER_use3D = PARTICLE_EMITTER( _pos, true );
		else
			_GLOBAL_PARTICLE_EMITTER_use3D:SetPos( _pos );
		end

		return _GLOBAL_PARTICLE_EMITTER_use3D;
	else
		if ( !_GLOBAL_PARTICLE_EMITTER_use2D ) then
			_GLOBAL_PARTICLE_EMITTER_use2D = PARTICLE_EMITTER( _pos, false );
		else
			_GLOBAL_PARTICLE_EMITTER_use2D:SetPos( _pos );
		end

		return _GLOBAL_PARTICLE_EMITTER_use2D;
	end
end

local meta = FindMetaTable("CLuaEmitter")
if not meta then return end

local oldadd = meta.Add
function meta:Add(a, b, c)
	self:SetPos(b)

	return oldadd(self, a, b, c)
end

--[[local OldParticleEmitter = ParticleEmitter

local function ForwardFunc(from, funcname)
	from[funcname] = function(me, a, b, c, d, e, f)
		if not me.Emitter and me.EmitterVars then
			me.Emitter = OldParticleEmitter(unpack(me.EmitterVars))
		end

		return me.Emitter[funcname](me.Emitter, a, b, c, d, e, f)
	end
end

local wrapper = {}

ForwardFunc(wrapper, "Add")
ForwardFunc(wrapper, "Draw")
ForwardFunc(wrapper, "GetNumActiveParticles")
ForwardFunc(wrapper, "SetBBox")
ForwardFunc(wrapper, "SetNearClip")
ForwardFunc(wrapper, "SetNoDraw")
ForwardFunc(wrapper, "SetParticleCullRadius")
ForwardFunc(wrapper, "SetPos")

function wrapper:Finish()
	if self.Emitter then self.Emitter:Finish() end
	self.Emitter = nil
end

local meta = {}
function meta:__gc()
	if self.Emitter then self.Emitter:Finish() end
	self.Emitter = nil
end

function ParticleEmitter(...)
	local e = {}
	for k, v in pairs(wrapper) do e[k] = v end
	e.EmitterVars = {...}
	e.Emitter = OldParticleEmitter(...)
	setmetatable(e, meta)
	return e
end
]]
