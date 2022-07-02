--------------------
-- STBase
-- By Spacetech
--------------------

local sin,cos,rad = math.sin,math.cos,math.rad // makes things a bit faster

function draw.Rectangle( x, y, w, h, col, tex )

	surface.SetDrawColor(col)
	
	if texture then
		surface.SetTexture(tex)
		surface.DrawTexturedRect(x,y,w,h)
	else
		surface.DrawRect(x,y,w,h)
	end
	
end

function draw.Shape( x, y, w, h, col, sides, texture )

	if sides < 3 then return end

    // tell Sam to add this later
	
end