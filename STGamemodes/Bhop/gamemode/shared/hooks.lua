--------------------
-- STBase
-- By Spacetech
--------------------

function GM:Initialize()
	self.BaseClass.Initialize(self)
	self.WinMoney = self.MapWinMoney[game.GetMap()] or 1000
end
