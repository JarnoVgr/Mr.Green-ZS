ENT.Type = "point"

--No bitching about that one, i dont wanne recreate all my awesome poison gas system so i will add backward compability with map gasses

if SERVER then
	AddCSLuaFile( "shared.lua" )
	
	function ENT:Initialize()
		self.Radius = self.Radius or 350
	end

	function ENT:KeyValue(key, value)
		if key == "radius" then
			self.Radius = tonumber(value)
		end
	end
	
end