--------------------
-- STBase
-- By Spacetech
--------------------

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

STGamemodes:DBConnect(false, "gameservers", "imaloser")

STGamemodes.GateKeeper:SetMaxPlayers(50)

STGamemodes.Maps:SetUp(15, 300)
STGamemodes:SetupUserCP(26780)
STGamemodes.Spectater:SetTeams(TEAM_BOTH)

GM.Weapon = "weapon_crowbar"
GM.DeathWeapon = "weapon_scythe"
