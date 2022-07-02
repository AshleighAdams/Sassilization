--------------------
-- STBase
-- By Spacetech
--------------------

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

timer.Destroy("WaterBreathing")

STGamemodes:DBConnect(false, "gameservers", "imaloser")
STGamemodes.GateKeeper:SetMaxPlayers(40)

STGamemodes.Winners = {}
STGamemodes.Maps:SetUp(15, 300, 3, 25)
STGamemodes:SetupUserCP(26781)
STGamemodes.DisableTrails = true
STGamemodes.Spectater:SetTeams(TEAM_BOTH)
