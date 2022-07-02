--------------------
-- STBase
-- By Spacetech
--------------------

function STGamemodes:AddHistory( Name, SteamID, AName, ASteamID, Action, Reason, Time )
	local Query = "name, steamid, aname, asteamid, action, date, location"
	local VALUES = "'".. Name .."', '".. SteamID .."', '".. AName .."', '".. ASteamID .."', '".. Action .."', '".. os.time() .."', '".. (STGamemodes.ServerName or "Servers") .."'"

	if Reason and Reason != "" then 
		Query = Query ..", reason"
		VALUES = VALUES ..", '".. Reason .."'"
	end 
	if Time then 
		Query = Query ..", time"
		VALUES = VALUES ..", '".. Time .."'"
	end 

	Query = "INSERT INTO sa_history (".. Query ..") VALUES (".. VALUES ..")"
	tmysql.query(Query)
end 

function STGamemodes.FlagCommand(ply, cmd, args) 
	if !ply:IsMod() then 
		return 
	end 

	local PlayerName = args[1]

	local Reason, Start = "", 1
	for k,v in pairs(args) do
		if(k > Start and k != #args) then
			Reason = Reason..v.." "
		elseif(k > Start and k == #args)then 
			Reason = Reason..v
		end
	end

	if !PlayerName or Reason == "" then 
		ply:ChatPrint("Syntax: /flag PlayerName Reason") 
		return 
	end 

	local Target = STGamemodes.FindByPartial(PlayerName) 

	if !STValidEntity(Target) then 
		ply:ChatPrint(Target) 
	elseif Target:IsMod() and !ply:IsSuperAdmin() then 
		ply:ChatPrint("You cannot flag staff nub!") 
	else 
		STGamemodes:AddHistory(Target:Name(), Target:SteamID(), ply:Name(), ply:SteamID(), "flagged", Reason)
		STGamemodes:PrintMod(STGamemodes.GetPrefix(ply).." "..ply:Name().." flagged ".. Target:CName() .." (Reason: ".. Reason ..")")
	end 
end 
concommand.Add("st_flag", STGamemodes.FlagCommand)