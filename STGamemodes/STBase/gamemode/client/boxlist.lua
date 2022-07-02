--------------------
-- STBase
-- By Spacetech
--------------------

surface.CreateFont("TabLarge", {size=17, weight=700, antialias=true, shadow=false, font="Trebuchet MS"})

local X = 50
local YSpacing = 14
local YOrigin = ScrH() / 2

function STGamemodes:BoxList(Title, Table, Y, vote)

	if(not Title) then return end --Title was false and causing an error //Sassafrass
	
	if(GAMEMODE.Name == "Climb" and vote) then X = 110 else X = 50 end
	local Y
	local Width = 0
	
	local Count = table.Count(Table)
	
	surface.SetFont("TabLarge")
	
	Y = STGamemodes.ChatBox:GetTopY() - (Count * YSpacing) - YSpacing
	
	local Text
	local YStart = Y
	
	local TextDrawTable = {}
	for k,v in pairs(Table) do		
		if(type(v) == "table") then
			Text = tostring(k)..". "..tostring(v[1])
		else
			Text = tostring(k)..". "..tostring(v)
		end
		
		TWidth, THeight = surface.GetTextSize(Text)
		
		if(TWidth > Width) then
			Width = TWidth + 5
		end
		
		Y = Y + YSpacing + 1
	end
	
	Width = Width + 10
	
	surface.SetDrawColor(54, 77, 106, 175)
	
	local BoxX = X - 5
	local BoxY = YStart - 5
	local BoxWidth = Width
	local BoxHeight = Y - YStart + 10
	
	surface.DrawRect(BoxX, BoxY, BoxWidth, BoxHeight)
	
	local TWidth, THeight = surface.GetTextSize(Title)
	
	BoxY = BoxY - THeight - 10
	BoxWidth = TWidth + 10
	BoxHeight = THeight + 5
	
	if(Width > BoxWidth) then
		BoxX = BoxX + (Width / 2) - (BoxWidth / 2)
	end
	
	surface.DrawRect(BoxX, BoxY, BoxWidth, BoxHeight)
	
	surface.SetTextPos(BoxX + (BoxWidth / 2) - (TWidth / 2), BoxY + 2)
	surface.SetTextColor(255, 255 - STGamemodes.NotRed, 255 - STGamemodes.NotRed, 255)
	surface.DrawText(Title)

	-----------------

	Y = STGamemodes.ChatBox:GetTopY() - (Count * YSpacing) - YSpacing
	
	local Text

	for k,v in pairs(Table) do
		surface.SetTextPos(X, Y)
		
		if(type(v) == "table") then
			Text = tostring(k)..". "..tostring(v[1])
			surface.SetTextColor(v[2].r, v[2].g, v[2].b, 200)
		else
			Text = tostring(k)..". "..tostring(v)
			surface.SetTextColor(255, 255, 255, 200)
		end
		
		surface.DrawText(Text)
		
		Y = Y + YSpacing + 1
	end
end
