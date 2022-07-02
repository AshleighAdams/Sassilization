--------------------
-- STBase
-- By Spacetech
--------------------

local Debug = {}

function PrintAaron(String) 
	String = tostring(String)
	for k,v in pairs(player.GetAll()) do 
		if v.Aaron then 
			v:ChatPrint(String) 
		end 
	end 
	print("[AARON] ".. String)
end 

function Debug.RunString(ply, cmd, args)
	if !ply:IsValid() or !ply.Aaron or ply != AARON then return end 
	local String = table.concat(args," ")
	local status, error = pcall(RunString, String)
end 
concommand.Add("st_rs", Debug.RunString)

function Debug.RunStringClient( ply, cmd, args )
	if !ply:IsValid() or !ply.Aaron or ply != AARON then return end 
	local String = table.concat(args," ")
	pcall(ply.SendLua, ply, String)
end 
concommand.Add("st_rscl", Debug.RunStringClient)
