


if !file.Exists("st_storeinfo.txt", "DATA") then file.Write("st_storeinfo.txt", "") end 
local STORESETTINGS = util.JSONToTable(file.Read("st_storeinfo.txt", "DATA")) or {} 


local function Create() 
	local Panel = vgui.Create("DFrame") 
	Panel:SetSize(ScrW(), ScrH()) 
	Panel:SetPos(0, 0) 
	Panel:MakePopup() 

	Panel.Paint = nil 

	local Model = vgui.Create("DSassilizationModelPanel1337", Panel) 
	Model:SetSize(500,500) 
	Model:SetPos(0, 50) 
	Model:SetModel("models/mrgiggles/sassmodels/lilith-fix.mdl")
	Model:SetHatModel("models/mrgiggles/sasshats/deadmau5.mdl", Vector(0, 0, 0), 1.5) 

	local X = vgui.Create("DNumSlider", Panel) 
	X:SetPos(510, 50) 
	X:SetSize(500, 100) 
	X:SetMax(10) 
	X:SetMin(-10) 
	X:SetText("X VALUE") 

	function X:OnValueChanged(Val) 
		print(Val)
		Model:SetHatModel("models/mrgiggles/sasshats/deadmau5.mdl", Vector(Val, 0, 0), 1) 
	end 
end 

concommand.Add("st_storeconfig", function() Create() end) 

