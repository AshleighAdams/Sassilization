--------------------
-- STBase
-- By Spacetech
--------------------

local RS = {}

function RS.Start(ply, cmd, args)
	if !ply:IsSuperAdmin() and !ply:IsMapper() then
		return
	end
	
	ply.RS = ""
end
concommand.Add("rs_start", RS.Start)

function RS.Add(ply, cmd, args)
	if (!ply:IsSuperAdmin() and !ply:IsMapper()) or !ply.RS or !args[1] then
		return
	end
	
	ply.RS = ply.RS .. " " .. args[1]
end
concommand.Add("rs_add", RS.Add)

function RS.End(ply, cmd, args)
	if (!ply:IsSuperAdmin() and !ply:IsMapper()) or !ply.RS then
		return
	end	
	
	local _, err = pcall(CompileString(ply.RS, "RS_" .. ply:SteamID(), false))
	if err then
		ply:ChatPrint("Error: " .. err)
	end

	ply.RS = ""
end
concommand.Add("rs_end", RS.End)

-- Doesn't require "" around args (use '' for string literals).
function RS.Simple(ply, cmd, args)
	if (!ply:IsSuperAdmin() and !ply:IsMapper()) or !args[1] then
		return
	end
	
	local s = args[1]
	for i = 2, #args do
		if string.find(args[i], "[\'\"]") or string.find(args[i - 1], "[\'\"]") then
			s = s .. args[i]
		else
			s = s .. " " .. args[i]
		end
	end
	
	local _, err = pcall(CompileString(s, "RS_" .. ply:SteamID(), false))
	if err then
		ply:ChatPrint("Error: " .. err)
	end
end
concommand.Add("rs_simple", RS.Simple)
concommand.Add("rs", RS.Simple)
STGamemodes:AddChatCommand("rs", "rs")
