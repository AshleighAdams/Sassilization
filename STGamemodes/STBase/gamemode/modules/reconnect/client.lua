--------------------
-- STBase
-- By Spacetech
--------------------

-- Based on Flapadar's idea

local Reconnect = {}
Reconnect.Spawned = false
Reconnect.SpawnTime = false
Reconnect.CrashMove = CurTime()
Reconnect.ReconnectTime = math.min(GetConVarNumber("sv_timeout") - 6, GetConVarNumber("cl_timeout") - 6, 20) -- in seconds

usermessage.Hook("pong", function()
	Reconnect.CrashMove = CurTime() + 10
end)

hook.Add("InitPostEntity", "Reconnect.InitPostEntity", function()
	Reconnect.Spawned = true
	Reconnect.SpawnTime = CurTime() + 5
end)

hook.Add("Move", "Reconnect.Move" , function()
	Reconnect.CrashMove = CurTime() + 5
end)

hook.Add("Think", "Reconnect.Think" , function()
	if(!Reconnect.Spawned) then
		return
	end
	if(Reconnect.SpawnTime >= CurTime()) then
		return
	end
	
	if(Reconnect.Crashed) then
		if(Reconnect.CrashMove >= CurTime()) then
			Reconnect.Crashed = false
		elseif(Reconnect.AutoRetry <= CurTime() and Reconnect.CrashMove + 5 <= CurTime()) then
			RunConsoleCommand("retry")
		end
	elseif(!Reconnect.Pinging) then
		Reconnect.Pinging = true
		RunConsoleCommand("_ping")
		timer.Simple(3, function()
			Reconnect.Pinging = false
			if(Reconnect.CrashMove <= CurTime() and !LocalPlayer():IsFrozen()) then
				LocalPlayer():ChatPrint("Console: The server is currently experiencing technical difficulties...please wait..")
				Reconnect.Crashed = true
				Reconnect.AutoRetry = CurTime() + Reconnect.ReconnectTime
			end
		end)
	end
end)
