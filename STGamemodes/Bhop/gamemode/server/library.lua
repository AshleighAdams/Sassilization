--------------------
-- STBase
-- By Spacetech
--------------------

function GM:CompletedAll(ply)
	return self:GetInfo(ply, "Levels", {})[table.Count(self.Levels)] or false
end

local Winners = {}

hook.Add( "InitPostEntity", "GM.GetMapID", function() GAMEMODE:GetMapID( game.GetMap() ) end )

function GM:GetMapID( mapname )
	
	tmysql.query("SELECT id FROM bh_maps WHERE name = '"..mapname.."'", function( res, stat, err )
		if(err != 0) then
			Error(err)
		end
		if(!(res and res[1])) then
			tmysql.query("INSERT INTO main.bh_maps (name) VALUES ('"..mapname.."')", function( res, stat, err )
				self:GetMapID( mapname )
			end )
		else
			self.MapID = res[1][1]
		end
	end)

end

function GM:OnWin(ply)
	if(self:GetInfo(ply, "Winner")) then
		return
	end
	self:SetInfo(ply, "Winner", true)
	table.insert(Winners, ply)
	
	ply:EndTime()

	local TotalTime = math.Round(ply:GetTotalTime(), 2)
	local WinTotal = self:SetInfo(ply, "WinTotal", self:GetInfo(ply, "WinTotal", 0) + 1)

	local Level = self:SetInfo(ply, "WinLevel", ply.Level)
	local Levels = self:GetInfo(ply, "Levels", {})
	Levels[Level] = true
	self:SetInfo(ply, "Levels", Levels)
	
	ply:Give("st_jetpack")
	ply.CanHaveTrail = true
	ply:CreateTrail()
	ply:SetNWFloat("WinTime", TotalTime)
	
	local WinMessage = ply:CName().." made it to the end on "..self.Levels[Level].Name.." in "..STGamemodes:SecondsToFormat(TotalTime, true)
	local EmitIt = STGamemodes.WinSounds[math.random(1, table.Count(STGamemodes.WinSounds))]
	
	if(WinTotal > 1) then
		WinMessage = WinMessage.." for the "..tostring(WinTotal)..STNDRD(WinTotal).." time"
	end
	
	WinMessage = WinMessage..' Total Jumps: '..ply:GetJumpCount()..' Total Fails: '..ply:GetFailCount()
	
	
	STGamemodes.Logs:ParseLog( WinMessage.."("..game.GetMap()..")" )

	for k,v in pairs(player.GetAll()) do
		v:ChatPrint(WinMessage)
		v:EmitSound(EmitIt, 250)
	end
	
	local WinMoney = self:GetInfo(ply, "WinMoney", -1)
	if WinMoney > 0  then
		ply:GiveMoney(WinMoney)
		ply:ChatPrint("You have been given "..tostring(WinMoney).." dough")
	end

	local Record = STGamemodes.Records:CheckNew(ply, TotalTime)
	
	if self:GetInfo(ply, "NoTele", false) then
		STAchievements:AddCount(ply, "No Water")
	end
	
	if table.Count(Winners) == 1 then
		STAchievements:AddCount(ply, "Cup Winner")
	end
	
	if TotalTime <= 60 then
		STAchievements:AddCount(ply, "Bhopping Expert")
	elseif TotalTime >= 1800 then 
		STAchievements:AddCount(ply, "I Love Turtles!")
	end
	
	STAchievements:AddCount(ply, self.Levels[Level].Name)
	STAchievements:AddCount(ply, "Casual Bhopper")
	
	if( self.MapID ) then
		tmysql.query("INSERT INTO bh_times (pid, map, time, date, difficulty) VALUES ('"..ply.PlayerID.."', '"..tostring(self.MapID).."', '"..tostring(TotalTime).."', '"..tostring(os.time()).."', '"..tostring(Level).."')")
	end

	if Record then
		STGamemodes.Records:Load() -- Reload them
		STGamemodes.Records:AwardFame( ply )
	end
	
	ply:ResetJumpCount()
	ply:ResetFailCount()
end
