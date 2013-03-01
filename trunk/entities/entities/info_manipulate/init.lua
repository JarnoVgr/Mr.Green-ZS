ENT.Type = "point"

function ENT:AcceptInput(name, activator, caller, arg)
	if name == "toggle" then
		return true
	end
end

