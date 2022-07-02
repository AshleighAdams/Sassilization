--------------------
-- STBase
-- By Sam
--------------------

surface.CreateFont("NotificationSegoe", {font="Segoe UI", size=24, weight=100, antialias=true})

local colBlue			= Color(41,112,179,255)
local colOrange		= Color(214,143,76,255)

STNotifications.Messages = {}

local iconsheet = surface.GetTextureID("sassilization/hud/notifications002")
local tw, th = surface.GetTextureSize(iconsheet)
local maxrowicons = tw/32
local iconw = 32 -- icon width/height
local umax, vmax = iconw/tw, iconw/tw
function STNotifications:DrawIcon(x, y, icon)

	-- get the correct XY coordinate from single icon slot
	local slotX, slotY = icon, 0
	if slotX >= maxrowicons then
		repeat
			local overlap = slotX % maxrowicons
			slotX = overlap
			slotY = slotY + 1
		until slotX <= maxrowicons
	end

	-- generate 32x32 offset icon from iconsheet
	local uoffset, voffset = (slotX*iconw)/tw, (slotY*iconw)/th
	local rect = {
		[1] = { -- topleft
			["x"] = x,
			["y"] = y,
			["u"] = uoffset,
			["v"] = voffset,
		},
		[2] = { -- topright
			["x"] = x + iconw,
			["y"] = y,
			["u"] = umax + uoffset,
			["v"] = voffset,
		},
		[3] = { -- bottomright
			["x"] = x + iconw,
			["y"] = y + iconw,
			["u"] = umax + uoffset,
			["v"] = vmax + voffset,
		},
		[4] = { -- bottomleft
			["x"] = x,
			["y"] = y + iconw,
			["u"] = uoffset,
			["v"] = vmax + voffset,
		}
	}
	
	surface.SetTexture(iconsheet)
	surface.SetDrawColor(255,255,255,255)
	surface.DrawPoly(rect)

end

-- based off of Garry's code for hints
function STNotifications:DrawNotifications()

	for k, v in pairs( self.Messages ) do
		
		local H = ScrH() / 1024
		local x = v.x - 30 * H
		local y = v.y - 300 * H
		
		-- adjust size based on text
		if ( !v.w ) then -- only need to calculate this once
			surface.SetFont( "NotificationSegoe" )
			v.w, v.h = surface.GetTextSize( v.text )
		end
		
		local xoffset = 8
		local w = v.w + iconw + xoffset*2
		local h = v.h

		-- Message
		draw.Rectangle( x - w, y - 8, w, h, Color( 30, 30, 30, v.a ) )
		draw.SimpleText( v.text, "NotificationSegoe", x - xoffset, y - 8, Color(255,255,255,v.a), TEXT_ALIGN_RIGHT )
		
		-- Time bar
		local percent = math.Clamp( (v.time + v.len - SysTime()) / v.len, 0, 1 )
		draw.Rectangle( x - w, (y - 8) + h, w, 2, colBlue )
		draw.Rectangle( x - w, (y - 8) + h, w*(1-percent), 2, colOrange )
		
		-- Icon
		self:DrawIcon(x - w + 4, y - 8, v.type)
		
		local ideal_y = ScrH() - (#self.Messages - k) * (h + 6)
		local ideal_x = ScrW()
		
		local timeleft = v.len - (SysTime() - v.time)
		
		-- Cartoon style about to go thing
		if ( timeleft < 0.8  ) then
			ideal_x = ScrW() - 50
		end
		 
		-- Gone!
		if ( timeleft < 0.5  ) then
			ideal_x = ScrW() + (w+h) * 2
		end
		
		local spd = RealFrameTime() * 15
		
		v.y = v.y + v.vely * spd
		v.x = v.x + v.velx * spd
		
		local dist = ideal_y - v.y
		v.vely = v.vely + dist * spd * 1
		if (math.abs(dist) < 2 && math.abs(v.vely) < 0.1) then v.vely = 0 end
		local dist = ideal_x - v.x
		v.velx = v.velx + dist * spd * 1
		if (math.abs(dist) < 2 && math.abs(v.velx) < 0.1) then v.velx = 0 end
		
		-- Friction.. kind of FPS independant.
		v.velx = v.velx * (0.95 - RealFrameTime() * 8 )
		v.vely = v.vely * (0.95 - RealFrameTime() * 8 )
		
		if ( v.len - (SysTime() - v.time) ) < 0 then table.remove( self.Messages, k ) end

	end

end

function AddNotification( um )
	local msg	= {}
	msg.text	= um:ReadString()
	msg.type	= um:ReadShort()
	msg.delay	= um:ReadShort()
	msg.time 	= SysTime()
	msg.len		= 10
	msg.velx	= -5
	msg.vely	= 0
	msg.x		= ScrW() + 200
	msg.y		= ScrH()
	msg.a		= 200
	table.insert( STNotifications.Messages, msg )
	
	print("[ST] " .. msg.text)
end
usermessage.Hook( "STNotification", AddNotification )


hook.Add("HUDPaint", "STDrawNotifications", function()
	STNotifications:DrawNotifications()
end)
