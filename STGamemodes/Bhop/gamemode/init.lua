--------------------
-- STBase
-- By Spacetech
--------------------

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

timer.Destroy("WaterBreathing")

GM.Winners = {}

STGamemodes:DBConnect(false, "gameservers", "imaloser")
STGamemodes.GateKeeper:SetMaxPlayers(40)

STGamemodes.Maps:SetUp(15, 240, 2, 15)
STGamemodes:SetupUserCP(26782)
STGamemodes.DisableTrails = true
STGamemodes.Spectater:SetTeams(TEAM_BOTH)

STGamemodes.RunGun = "st_jetpack"
STGamemodes.WeaponSpawnModel = "models/weapons/w_bugbait.mdl"
