--------------------
-- STBase
-- By Spacetech
--------------------

surface.CreateFont("SandboxLabel", {font="coolvetica", size=64, weight=500, antialias=true}) 

GM.HideHUD = {"CHudHealth", "CHudChat", "CHudBattery", "CHudSecondaryAmmo", "CHudDamageIndicator"}
RunConsoleCommand('cl_pred_optimize','1')
include("menu/ProgressBar.lua")
include("shared.lua")
