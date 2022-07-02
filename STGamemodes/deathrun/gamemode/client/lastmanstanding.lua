--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes.LastManStanding = {}

function STGamemodes.LastManStanding.DrawOverlay()
	surface.SetDrawColor(color_white)
	surface.SetTexture(surface.GetTextureID("effects/tp_eyefx/tpeye2"))
	surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
end

usermessage.Hook("LastManStanding.Overlay", function(um)
	if um:ReadBool() then
		hook.Add("HUDPaint", "LastManStanding.Overlay", STGamemodes.LastManStanding.DrawOverlay)
	else
		hook.Remove("HUDPaint", "LastManStanding.Overlay")
	end
end)
