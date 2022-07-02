--------------------
-- STBase
-- By Spacetech
--------------------

GM.Levels = {}

function GM:AddLevel(Name, StayTime, MoneyMod, Col, SpeedMod, JumpPowerMod)
	self.Levels[table.Count(self.Levels) + 1] = {
		Name = Name,
		Col = Col,
		StayTime = StayTime,
		MoneyMod = MoneyMod,
		Speed = (self.CSSSpeed or 250) + (SpeedMod or 0),
		JumpPower = 210 + (JumpPowerMod or 0)
	}
end

function GM:CalcWinMoney(ply, Level, MoneyOnly)
	local Money = self.WinMoney * GAMEMODE.Levels[Level].MoneyMod
	
	if(MoneyOnly) then
		return Money
	end
	
	if(SERVER) then -- I rather trust the server with these kind of things
		local Levels = self:GetInfo(ply, "Levels", false)
		if(Levels) then
			local HighestWin = 0
			for k,v in pairs(Levels) do
				if(v == true and k > HighestWin) then
					HighestWin = k
				end
			end
			if(HighestWin > 0) then
				Money = Money - self:CalcWinMoney(ply, HighestWin, true)
			end
		end
	else
		local WinLevel = ply.WinLevel
		if(WinLevel) then
			if(WinLevel >= Level) then
				return "N/A"
			end
			Money = Money - self:CalcWinMoney(ply, WinLevel, true)
		end
	end
	
	if(ply:IsVIP()) then
		Money = Money * 1.25
	end

	Money = math.Round(Money/100)*100
	
	return math.Round(Money)
end

GM:AddLevel("Newbie", 		0.6, 	0.25,	Color(0, 255, 0, 255),		15,	15)
GM:AddLevel("Beginner", 	0.35, 	0.5,	Color(0, 255, 255, 255),	10,	10)
GM:AddLevel("Intermediate", 0.225, 	0.75,		Color(0, 0, 254, 255),		5,	5)
GM:AddLevel("Advanced", 	0.125, 	1,	Color(255, 255, 0, 255),	5,	5)
GM:AddLevel("Master",		0.08, 	1.25,	Color(255, 0, 0, 255))
GM:AddLevel("Nightmare",	0.08, 	1.5,	Color(255, 255, 255, 255))
