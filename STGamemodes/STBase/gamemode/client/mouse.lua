--------------------
-- STBase
-- By Spacetech
--------------------

local TotalMice = 0
local MX, MY = false, false

function ShowMouse()
	TotalMice = TotalMice + 1
	if(MX and MY and !vgui.CursorVisible()) then
		gui.SetMousePos(MX, MY)
	end
	if(TotalMice > 0) then
		gui.EnableScreenClicker(true)
	end
end

function HideMouse()
	TotalMice = math.Max(TotalMice - 1, 0)
	MX, MY = gui.MousePos()
	if(TotalMice == 0) then
		gui.EnableScreenClicker(false)
	end
end
