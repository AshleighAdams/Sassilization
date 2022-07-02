--------------------
-- STBase
-- By Spacetech
--------------------

-- require("oosocks")

if(!OOSock) then
	function STGamemodes:SetupUserCP()
	end
	return
end

local sock = OOSock(IPPROTO_TCP)
sock:SetTimeout(0)

function STGamemodes:SetupUserCP(Port)
	if(!sock) then
		return
	end
	sock:Bind(Port)
	Msg("OOSock: Binded Port: "..tostring(Port).."\n")
end

local packets = {}
local ONLINEPLAYERS = {}

function packets.ONLINE(SteamID, Status)
	if(!SteamID) then
		return
	end
	local CurrentTable = ONLINEPLAYERS[SteamID]
	if(CurrentTable) then
		if(CurrentTable.Status != Status) then
			ONLINEPLAYERS[SteamID].Status = Status
		end
		ONLINEPLAYERS[SteamID].AwayTime = CurTime() + 30
	else
		local Info = tmysql.query("SELECT playername, rank, money FROM sa_misc WHERE steamid = '"..SteamID.."'", function(Info, Stat, Err)
			if(!Info or !Info[1]) then
				return
			end
			if(!Info[1][1] or !Info[1][2] or !Info[1][3]) then
				return
			end
			
			local T = {}
			T.SteamID = SteamID
			T.Name = Info[1][1]
			T.Rank = STGamemodes:NumberToRank(Info[1][2])
			T.Dough = Info[1][3]
			T.Status = Status or ""
			T.AwayTime = CurTime() + 30
			
			ONLINEPLAYERS[SteamID] = Table
			
			umsg.Start("UserCP.AddPlayer")
				umsg.String(SteamID)
				umsg.String(T.Name)
				umsg.String(T.Rank)
				umsg.Long(T.Dough)
				umsg.String(T.Status)
			umsg.End()
		end)
	end
end

function packets.OFFLINE(SteamID)
	if(!SteamID) then
		return
	end
	if(!ONLINEPLAYERS[SteamID]) then
		return
	end
	umsg.Start("UserCP.RemovePlayer")
		umsg.String(SteamID)
	umsg.End()
	ONLINEPLAYERS[SteamID] = nil
end

function CheckTeamUserCP()
	for k,v in pairs(ONLINEPLAYERS) do
		if(CurTime() > v.AwayTime) then
			packets.OFFLINE(k)
		end
	end
end
timer.Create("CheckTeamUserCP", 30, 0, function() CheckTeamUserCP() end )

function LuaSocketInitialSpawn(ply)
	timer.Simple(5, function()
		if(!ply or !ply:IsValid()) then
			return
		end
		local Timer = 0.1
		for k,v in pairs(ONLINEPLAYERS) do
			timer.Simple(Timer, function()
				umsg.Start("UserCP.AddPlayer", ply)
					umsg.String(k)
					umsg.String(v.Name)
					umsg.String(v.Rank)
					umsg.Long(v.Dough)
					umsg.String(v.Status)
				umsg.End()
			end)
			Timer = Timer + 0.1
		end
	end)
end
hook.Add("PlayerInitialSpawn", "LuaSocketInitialSpawn", LuaSocketInitialSpawn)

local Data,IP,Info,Func

hook.Add("Think", "UserCPSocket", function()
	if(!sock:Accept()) then
		return
	end
	print("Accepting")
	Data, IP = sock:ReceiveLine()
	if(!Data) then
		return
	end
	print(Data)
	Info = string.find(Data, ":")
	if(!Info) then
		return
	end
	Func = string.sub(Data, 1, Info - 1)
	Data = string.sub(Data, string.find(Data, ":") + 1)
	if(packets[Func]) then
		packets[Func](unpack(string.Explode("|", Data)))
	end
end)
