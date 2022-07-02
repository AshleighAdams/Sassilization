--------------------
-- STBase
-- By Spacetech
--------------------

local count = 0
function Restart(ply, cmd, args)
	if(ply and ply.SendLua) then
		if(!ply:IsSuperAdmin()) then
			return
		end
		count = count + 1
		if(count < 3) then
			return
		end
	end
	
	RunConsoleCommand("changelevel", args[1] or game.GetMap())
end
concommand.Add("r", Restart)

----------------------------------------------------------------------------------------------------

local DebugUMsg = false
local Ply = false
local UMsgStart = umsg.Start
local UMsgString = umsg.String
local UMsgEnd = umsg.End

function umsg.DebugPlayer(String)
	if(!DebugUMsg) then
		return
	end
	if(Ply) then
		if(IsValid(Ply)) then
			Ply:PrintMessage(HUD_PRINTCONSOLE, tostring(String))
		else
			DebugUMsg = false
		end
	else
		print(String)
	end
end

function umsg.Start(Name, Players)
	umsg.DebugPlayer("Start | "..tostring(Name))
	return UMsgStart(Name, Players)
end

function umsg.String(String)
	umsg.DebugPlayer("String | "..tostring(string.len(String)).." | "..tostring(String))
	return UMsgString(String)
end

function umsg.End()
	umsg.DebugPlayer("End")
	return UMsgEnd()
end

concommand.Add("st_debugumsg", function(ply)
	if(ply.SendLua and !ply:IsSuperAdmin()) then
		return
	end
	DebugUMsg = !DebugUMsg
	if(ply.SendLua) then
		Ply = ply
	else
		ply = false
	end
	umsg.DebugPlayer(DebugUMsg)
end)
