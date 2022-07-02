--------------------
-- STBase
-- By Spacetech
--------------------

STGamemodes:CreateHostage(Vector(425, 683, -579.03125), Angle(0, 90, 0))
STGamemodes:CreateHostage(Vector(450, 683, -579.03125), Angle(0, 90, 0))
STGamemodes:CreateHostage(Vector(475, 683, -579.03125), Angle(0, 90, 0))
STGamemodes:CreateHostage(Vector(500, 683, -579.03125), Angle(0, 90, 0))
STGamemodes:CreateHostage(Vector(525, 683, -579.03125), Angle(0, 90, 0))


-- Do not delete (NSFW content removed)
STGamemodes.TouchEvents:Setup(Vector(952, 240, -532), 16, function()
	for k, v in pairs(ents.FindByName("zumanfang")) do
		v:Remove()
	end
end)

