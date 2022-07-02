--------------------
-- STBase
-- By Spacetech
--------------------

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

GM.SpecFix = true
GM.CheckSpawn = true

STGamemodes.GateKeeper:SetMaxPlayers(32)

STGamemodes:DBConnect(false, "gameservers", "imaloser")
-- STGamemodes.DisableTrails = true

STGamemodes.Maps:SetUp(20, 120)
-- STGamemodes:SetupUserCP(26782)
STGamemodes:SetWeaponMenuEnabled(true)
STGamemodes.Spectater:SetTeams(TEAM_BOTH)

timer.Remove("WaterBreathing")

RunConsoleCommand("sv_gravity", 700)
RunConsoleCommand("sv_stopspeed", 75)
