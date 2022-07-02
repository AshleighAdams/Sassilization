--------------------
-- STBase
-- By Spacetech
--------------------

GM.Name		= "Deathrun"
GM.Folder	= "Deathrun"
GM.Author	= "Spacetech"
GM.Email 	= "Spacetech326@gmail.com"
GM.Website 	= "www.sassilization.com"

DeriveGamemode("STBase")

TEAM_RUN = 3
TEAM_DEATH = 2
TEAM_DEAD = 4

TEAM_BOTH = {TEAM_RUN, TEAM_DEATH}

SCOREBOARD_ORDER = {}
SCOREBOARD_ORDER[TEAM_RUN] = 3
SCOREBOARD_ORDER[TEAM_DEATH] = 2
SCOREBOARD_ORDER[TEAM_DEAD] = 1

function GM:CreateTeams()
	self.BaseClass.CreateTeams(self)
	
	self:TeamSetupSpeed(TEAM_RUN, self.CSSSpeed)
	team.SetUp(TEAM_RUN, "Run", Color(20, 20, 200, 255))
	team.SetSpawnPoint(TEAM_RUN, "info_player_counterterrorist")
	
	self:TeamSetupSpeed(TEAM_DEATH, self.CSSSpeed + 90)
	team.SetUp(TEAM_DEATH, "Death", Color(200, 20, 20, 255))
	team.SetSpawnPoint(TEAM_DEATH, "info_player_terrorist")
	
	self:TeamSetupSpeed(TEAM_DEAD, self.CSSSpeed)
	team.SetUp(TEAM_DEAD, "Dead", Color(125, 55, 145, 255))
	team.SetSpawnPoint(TEAM_DEAD, "info_player_counterterrorist")
end

function GM:GetGameDescription()
	return "Deathrun"
end

STGamemodes:SetupServerDirectory( "Deathrun" )
STGamemodes:LoadGamemode(GM.Name)
STGamemodes.Forums:SetID(6)

GM.NoDeadTag = true
