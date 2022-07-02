--------------------
-- STBase
-- By Spacetech
--------------------

local Air = 0
usermessage.Hook("DrowningMsg", function(um)
	Air = um:ReadLong()
end)


hook.Add("HUDPaint", "Drowning Message", function()
	if (!LocalPlayer():Alive()) then return end
	if (Air > 0 && LocalPlayer():WaterLevel() > 2) then
		local AirLevel = math.Clamp(Air,0,100)
		local AirText = tostring(Air)

		draw.RoundedBox(4,ScrW()/2-100,ScrH()-130,200,20,Color(0,0,0,200))
		draw.RoundedBox(4,ScrW()/2-100+1,ScrH()-130+1,AirLevel/100*198,18,Color(43,102,204,255))

		surface.SetFont("STHUD44")
		
		local airTextWidth, airTextHeight = surface.GetTextSize(AirText)

		surface.SetTextPos(ScrW()/2-50, ScrH()-140)
		surface.SetTextColor(255, 255, 255, 255)
		surface.DrawText(AirText)
		
		surface.SetFont("STHUD20")
		
		surface.SetTextPos(ScrW()/2-50 + airTextWidth + 5, ScrH()-129)
		surface.SetTextColor(255, 255, 255, 255)
		surface.DrawText("AIR")
	end
end)

