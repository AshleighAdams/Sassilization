--------------------
-- STBase
-- By Spacetech
--------------------

hook.Add("Initialize", "STGamemodes.STBunnyHop.Initialize", function()
	table.insert(GAMEMODE.HideHUD, "CHudHealth")
end)

local Level, Winner
function GM:ScoreboardStatus()
	for k,v in pairs(player.GetAll()) do
		Level, Winner = v:GetNWInt("Level", false), v:IsWinner()
		if(Level and (Level != v.Level or Winner != v.Winner)) then
			v.Level = Level
			v.Winner = Winner
			if(Winner) then
				v.WinLevel = Level
				v.ScoreboardStatus = "Winner"
			else
				v.ScoreboardStatus = self.Levels[Level].Name
			end
		end
	end
end

function GM:Think()
	self:ScoreboardStatus()
	STGamemodes:DistanceCloaking()
end

function GM:HUDPaint()
	self.BaseClass.HUDPaint(self)
end
