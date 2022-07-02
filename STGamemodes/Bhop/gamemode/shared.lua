--------------------
-- STBase
-- By Spacetech
--------------------

GM.Name		= "Bunny Hop"
GM.Folder	= "Bhop"
GM.Author	= "Spacetech"
GM.Email 	= "Spacetech326@gmail.com"
GM.Website 	= "www.sassilization.com"

DeriveGamemode("STBase")

TEAM_BHOP = 2
TEAM_BOTH = {TEAM_BHOP}

function GM:CreateTeams()
	self.BaseClass.CreateTeams(self)
	
	self:TeamSetupSpeed(TEAM_BHOP, self.CSSSpeed)
	team.SetUp(TEAM_BHOP, "Hoppers", Color(20, 20, 200, 255))
	team.SetSpawnPoint(TEAM_BHOP, {"info_player_terrorist", "info_player_counterterrorist"})
end

function GM:GetGameDescription()
	return "Bunny Hop"
end

GM.VIPSpeed = false
GM.svAirAccelerate = 100

STGamemodes.GhostDisabled = true


STGamemodes:SetupServerDirectory( "Bunny Hop" )
STGamemodes:LoadGamemode("Bhop")
STGamemodes.Forums:SetID(8)
