--------------------
-- STBase
-- By Spacetech
--------------------

GM.Name		= "Climb"
GM.Folder	= "Climb"
GM.Author	= "Spacetech"
GM.Email 	= "Spacetech326@gmail.com"
GM.Website 	= "www.sassilization.com"

DeriveGamemode("STBase")

TEAM_CLIMB = 2
TEAM_BOTH = {TEAM_CLIMB}

function GM:CreateTeams()
	self.BaseClass.CreateTeams(self)
	
	self:TeamSetupSpeed(TEAM_CLIMB, self.CSSSpeed - 15)
	team.SetUp(TEAM_CLIMB, "Climbers", Color(20, 20, 200, 255))
	team.SetSpawnPoint(TEAM_CLIMB, {"info_player_terrorist", "info_player_counterterrorist"})
end

function GM:GetGameDescription()
	return "Climb"
end

GM.VIPSpeed = false
STGamemodes.GhostDisabled = true

STGamemodes:SetupServerDirectory( "Climb" )
STGamemodes:LoadGamemode(GM.Name)
STGamemodes.Forums:SetID(7)
