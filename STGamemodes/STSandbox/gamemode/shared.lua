--------------------
-- STBase
-- By Spacetech
--------------------

GM.Name			= "STSandbox"
GM.Author		= "Spacetech"
GM.Email 		= "Spacetech326@gmail.com"
GM.Website 		= "www.sassilization.com"

DeriveGamemode("STBase")

TEAM_BUILDER = 2
TEAM_BOTH = {TEAM_BUILDER}

function GM:CreateTeams()
	self.BaseClass.CreateTeams(self)
	
	self:TeamSetupSpeed(TEAM_BUILDER, 400)
	team.SetUp(TEAM_BUILDER, "Builders", Color(20, 20, 200, 255))
	team.SetSpawnPoint(TEAM_BUILDER, {"info_player_start", "info_player_terrorist", "info_player_counterterrorist"})
end

function GM:GetGameDescription()
	return "Sassbox"
end

STGamemodes:SetupServerDirectory( "Sandbox" )
STGamemodes:LoadGamemode(GM.Name, "sandbox")
STGamemodes.Forums:SetID(8)
