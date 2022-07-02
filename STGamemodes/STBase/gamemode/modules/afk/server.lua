--------------------
-- STBase
-- By Spacetech
--------------------

function GM:AFKCommand(ply)
	local Command = ply:GetCurrentCommand()
	if(Command:GetMouseX() != 0 or Command:GetMouseY() != 0) then
		ply:AFKTimer()
	end
end

function STGamemodes.PlayerMeta:SetAFK(Bool)
	if(!self or !self:IsValid() or self:IsBot()) then
		return
	end
	if(self:IsAFK() == Bool) then
		return
	end

	self.AFK = Bool
	if(Bool) then
		self:ChatPrint("You are now away")
		self:GoTeam(TEAM_SPEC)
	end
end

concommand.Add( "setafk", function( ply )
	if ply:IsSuperAdmin() then
		ply:SetAFK( true )
	end
end )

function STGamemodes.PlayerMeta:IsAFK()
	return tobool(self.AFK)
end

function STGamemodes.PlayerMeta:AFKTimer()
	if(self:IsAFK()) then
		self:SetAFK(false)
		self:ChatPrint("You've returned from being away, press F3 to rejoin")
	end
		
	self.AFKCheck = CurTime()
	
	timer.Create("AFK.Timer.Set."..self:SteamID(), 120, 1, function()
		if(STValidEntity(self)) then
			self:SetAFK(true)
		end
	end)
	
	timer.Create("AFK.Timer.Set.Warning."..self:SteamID(), 105, 1, function()
		if(STValidEntity(self)) then
			self:ChatPrint("Warning: You will be marked as away if you do not move within 15 seconds.")
		end
	end)
	
	if (self:IsSuperAdmin() or self.Spencer) then
		timer.Destroy("AFK.Timer.Kick.Warning."..self:SteamID())
		timer.Destroy("AFK.Timer.Kick."..self:SteamID())
	else
		local Time = 300
		if(self:IsMod()) then
			Time = 900
		elseif(self:IsVIP()) then
			Time = 600
		end

		timer.Create("AFK.Timer.Kick.Warning."..self:SteamID(), Time - 20, 1, function()
			if(STValidEntity(self)) then
				if(self:IsAFK() and self:Team() == TEAM_SPEC) then
					self:ChatPrint("Warning: You will be kicked for being away in 20 seconds.")
				end
			end
		end )

		timer.Create("AFK.Timer.Kick."..self:SteamID(), Time, 1, function()
			if(STValidEntity(self)) then
				if(self:IsAFK() and self:Team() == TEAM_SPEC) then
					STGamemodes.SecretKick(self, "AFK/Away")
				end
			end
		end )

	end
end

hook.Add( "ShowSpare1", "AFKTimer", function( ply )
	ply:AFKTimer()
end )

------------------------------------------------------------------------------------------------------------

if(true) then
	return
end

CRASH_TIME = 15
AVERAGE_SPEED = 80
UNGODLY_SPEED = 150

hook.Add("PlayerInitialSpawn", "NoInit", function(ply)
	ply.CrashTimer = 0
	ply.MoveNumber = 0
end)

hook.Add("Move", "NoSpeed", function(ply, movedata)
	ply.MoveNumber = ply.MoveNumber + 1
end)

local collect = RealTime()

hook.Add("Think", "NoThink", function()
	if RealTime() < collect + 1 then return end
	
	local lag = RealTime() - collect
	
	for k,v in pairs(player.GetAll()) do
		if(lag < 1.5) then
			if(v.MoveNumber == 0) then
				if(v.CrashTimer == 0) then
					v.CrashTimer = RealTime()
				elseif((RealTime() - v.CrashTimer) > CRASH_TIME and !v:IsGhost() and !v:InVehicle()) then
					if(v:Alive()) then
						v.CrashTimer = 0
						v:Kill()
					else
						STGamemodes.SecretKick(v, "Crashed")
					end
				end
			elseif(v.CrashTimer != 0) then
				v.CrashTimer = 0
			end
		end
		v.MoveNumber = 0
	end
	
	collect = collect + 1
end)
