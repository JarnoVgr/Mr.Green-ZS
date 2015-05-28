local meta = FindMetaTable("Player")
if not meta then
	return
end

function meta:HasBoughtPointsWithCoins()
	return MySelf.BoughtPointsWithCoins
end

function meta:CanBuyPointsWithCoins()
	return not MySelf.BoughtPointsWithCoins and MySelf:GreenCoins() >= 40
end

function meta:SetBoughtPointsWithCoins( bool )
	MySelf.BoughtPointsWithCoins = bool
end