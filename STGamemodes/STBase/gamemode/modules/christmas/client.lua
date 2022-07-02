--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.Christmas = {}

function IsDecember()
	return tonumber(os.date('%m')) == 12
end

local ConVar = CreateClientConVar( "st_snow", "1", true, false )
local SnowVignette = surface.GetTextureID("sassilization/snow")

if ConVar:GetInt() == 1 and IsDecember() then STGamemodes.Christmas.DisableSnow = false else STGamemodes.Christmas.DisableSnow = true end 
if(file.Exists("DisableSnow.txt", "DATA")) then file.Delete("DisableSnow.txt", "DATA") end -- Delete the txt file, no longer used.

function STGamemodes.Christmas.DrawSnowVignette()
	if (!STGamemodes.Christmas.DisableSnow) then 
		surface.SetDrawColor(Color(255, 255, 255, 100))
		surface.SetTexture(SnowVignette)
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	end 
end 

concommand.Add("st_disablesnow", function(ply, cmd, args)
	if !IsDecember() then 
		ply:ChatPrint( "Only available in December!" )
		return 
	end 

	if (!STGamemodes.Christmas.DisableSnow) then
		STGamemodes.Christmas.DisableSnow = true

		RunConsoleCommand( "st_snow", "0" )

		ply:ChatPrint("Snow: Disabled")

		hook.Remove("Think", "STGamemodes.Christmas.Snow")
	else
		STGamemodes.Christmas.DisableSnow = false
		RunConsoleCommand( "st_snow", "1" )
		ply:ChatPrint("Snow: Enabled")
		hook.Add("Think", "STGamemodes.Christmas.Snow", STGamemodes.Christmas.CreateSnow)
	end
	// STGamemodes.Store.RefreshSettings = true
end)

STGamemodes.Christmas.SnowDelay = 0

function STGamemodes.Christmas.CreateSnow() //There's probably a better way to do this but this is clientside and people can enable/disable it.
	if STValidEntity(LocalPlayer()) && !STGamemodes.Christmas.DisableSnow then
		if (STGamemodes.Christmas.SnowDelay && STGamemodes.Christmas.SnowDelay < CurTime()) then
				local Snow = EffectData()
					Snow:SetMagnitude(400)
					Snow:SetScale(6)
					Snow:SetRadius(300)
				util.Effect("st_snow", Snow)
			STGamemodes.Christmas.SnowDelay = CurTime() + 1
		end
	end
end

if IsDecember() then 
	hook.Add("Think", "STGamemodes.Christmas.Snow", STGamemodes.Christmas.CreateSnow)

	hook.Add("HUDPaint", "STGamemodes.Christmas.SnowVignette", STGamemodes.Christmas.DrawSnowVignette)
end 