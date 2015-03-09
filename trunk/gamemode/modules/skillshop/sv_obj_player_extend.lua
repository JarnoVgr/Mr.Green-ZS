local meta = FindMetaTable("Player")
if not meta then
	return
end

--Green coin to SP conversion 
util.AddNetworkString("BoughtPointsWithCoins")

function meta:HasBoughtPointsWithCoins()
    return self.BoughtPointsWithCoins or false
end

function meta:SetBoughtPointsWithCoins(bool)
	self.BoughtPointsWithCoins = bool
	self:UpdateBoughtPointsWithCoins()
end

function meta:CanBuyPointsWithCoins(Cost)
	return not self:HasBoughtPointsWithCoins() and self:GreenCoins() >= Cost
end

function meta:UpdateBoughtPointsWithCoins()
	net.Start("BoughtPointsWithCoins")
	net.WriteBool(self:HasBoughtPointsWithCoins())
	net.Send(self)
end