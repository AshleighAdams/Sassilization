--------------------
-- STDeathrun
-- By Spacetech
--------------------

function GM:AddGamemodeSpecificSelectMethods( Panel, Menu )
	
	Menu:AddOption("Death", function()
		for k, v in pairs(Panel.PanelList:GetItems()) do
			if(v.Player and v.Player:IsValid()) then
				v:SetSelected(v.Player:Team()==TEAM_DEATH)
			end
		end
	end)
	Menu:AddOption("Runners", function()
		for k, v in pairs(Panel.PanelList:GetItems()) do
			if(v.Player and v.Player:IsValid()) then
				v:SetSelected(v.Player:Team()==TEAM_RUN)
			end
		end
	end)
	
end
