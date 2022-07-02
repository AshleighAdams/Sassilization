--------------------
-- STBase
-- By Spacetech
--------------------

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

GM.WaitingTime		= 10
GM.IntermissionTime = 15
GM.InfectingTime	= 10

STGamemodes:DBConnect(false, "gameservers", "imaloser")

STGamemodes.GateKeeper:SetMaxPlayers(50)

STGamemodes:SetWeaponMenuEnabled(true)

STGamemodes.NearSpawnDistance = 256

STGamemodes.Maps:SetUp(30, 60)
-- STGamemodes:SetupUserCP(26780)
STGamemodes.Spectater:SetTeams(TEAM_BOTH)

STGamemodes.Weapons:RemoveAllGuns()

STGamemodes.Voice = 2
STGamemodes.VoiceUpdateClients( STGamemodes.Voice )