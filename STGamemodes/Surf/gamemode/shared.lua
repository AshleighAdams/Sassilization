--------------------
-- STBase
-- By Spacetech
--------------------

GM.Name		= "STSurf"
GM.Author	= "Spacetech"
GM.Email 	= "Spacetech326@gmail.com"
GM.Website 	= "www.sassilization.com"

DeriveGamemode("STBase")

TEAM_RED = 2
TEAM_BLUE = 3
TEAM_BOTH = {TEAM_RED, TEAM_BLUE}

SCOREBOARD_ORDER = {}
SCOREBOARD_ORDER[TEAM_BLUE] = 3
SCOREBOARD_ORDER[TEAM_RED] = 2

GM.VIPSpeed = false
GM.NoHealthBonus = true 

GM.SpawnProtect = 10
GM.DeadTime = 5
GM.SuicideTime = 10
GM.CSSSpeed = 220
GM.svAccelerate = 15
GM.svAirAccelerate = 100
GM.KillMoney = 50
GM.PaintTeam = true 

function GM:CreateTeams()
	self.BaseClass.CreateTeams(self)
	
	self:TeamSetupSpeed(TEAM_RED, self.CSSSpeed)
	team.SetUp(TEAM_RED, "Red", Color(255, 0, 0, 255))
	team.SetSpawnPoint(TEAM_RED, "info_player_terrorist")
	
	self:TeamSetupSpeed(TEAM_BLUE, self.CSSSpeed)
	team.SetUp(TEAM_BLUE, "Blue", Color(0, 0, 255, 255))
	team.SetSpawnPoint(TEAM_BLUE, "info_player_counterterrorist")
end

function GM:GetGameDescription()
	return "Surf"
end

STGamemodes:SetupServerDirectory( "Surf" )
STGamemodes:LoadGamemode(GM.Name)
STGamemodes.Forums:SetID(9)
