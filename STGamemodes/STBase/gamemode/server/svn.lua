--------------------
-- STBase
-- By Spacetech
--------------------

if true then return end 

-- require("svn_st")

STGamemodes.SVN = {}

function STGamemodes.SVN:GetSVNBuild(Directory)
	self.Revision = -1
	local File = Directory.."/.svn/entries"
	
	if(hIO) then
		if(hIO.FileExists(File)) then
			self.Revision = tonumber(string.Explode("\n", hIO.Read(File) or "")[4]) or "SVN"
		end
	else
		File = "../"..File
		if(file.Exists(File)) then
			self.Revision = tonumber(string.Explode("\n", file.Read(File) or "")[4]) or "SVN"
		end
	end
	return self.Revision
end

Msg("#########Revision: "..tostring(STGamemodes.SVN:GetSVNBuild("gamemodes/"..GM.Name)).."#########\n")

function STGamemodes.SVN:PlayerInitialSpawn(ply)
	timer.Simple(6, function()
		if(ply and ply:IsValid()) then
			ply:PrintMessage(HUD_PRINTTALK, tostring(GAMEMODE:GetGameDescription()).." Revision: "..tostring(self.Revision).. " By Spacetech\n")
		end
	end)
end
if(STGamemodes.SVN.Revision > -1) then
	hook.Add("PlayerInitialSpawn", "STGamemodes.SVN:PlayerInitialSpawn", function(ply) STGamemodes.SVN:PlayerInitialSpawn(ply) end)
end

-- if(svn_st_update) then
	-- Msg("Loaded SVN Module\n")
	-- concommand.Add("st_svnupdate", function(ply, cmd, args)
		-- if(!ply:IsAdmin()) then
			-- return
		-- end
		-- local Success = svn_st_update("C:\\Servers\\GMod Server Gamemodes")
		-- ply:ChatPrint("SVN Update: "..(Success and "Successful on All Servers" or "Failed"))
	-- end)
-- end
