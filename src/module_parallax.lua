--	-	-	-	-	-	-	-	-	-	-	-	-	-
--	Title:		Parallax Module
--	Copyright: 	Repulsion Software, 2012
--	-	-	-	-	-	-	-	-	-	-	-	-	-
local parallax = require( "parallax" )


local Parallax = {
	group = nil,
	width = 0,
	height = 0,
	left = 0,
	bottom = 0,
	repeated = false,
	background = {
		img = nil,
		width = 0,
		height = 0,
		left = 0,
		bottom = 0,
		speed = 0
	},
	midground = {
		img = nil,
		width = 0,
		height = 0,
		left = 0,
		bottom = 0,
		speed = 0
	},
	foreground = {
		img = nil,
		width = 0,
		height = 0,
		left = 0,
		bottom = 0,
		speed = 0
	}
}
local function levelScene( params )

		Parallax.group = params.group or nil
		Parallax.width = params.width or display.contentWidth
		Parallax.height = params.height or display.contentHeight
		Parallax.left = params.left or 0
		Parallax.bottom = params.bottom or display.contentHeight
		Parallax.repeated = params.repeated or true
		Parallax.background.img = params.background.img or nil
		Parallax.background.width = params.background.width or nil
		Parallax.background.height = params.background.height or nil
		Parallax.background.left = params.background.left or nil
		Parallax.background.bottom = params.background.bottom or nil
		Parallax.background.speed = params.background.speed or nil
		Parallax.midground.img = params.midground.img or nil
		Parallax.midground.width = params.midground.width or nil
		Parallax.midground.height = params.midground.height or nil
		Parallax.midground.left = params.midground.left or nil
		Parallax.midground.bottom = params.midground.bottom or nil
		Parallax.midground.speed = params.midground.speed or nil
		Parallax.foreground.img = params.foreground.img or nil
		Parallax.foreground.width = params.foreground.width or nil
		Parallax.foreground.height = params.foreground.height or nil
		Parallax.foreground.left = params.foreground.left or nil
		Parallax.foreground.bottom = params.foreground.bottom or nil
		Parallax.foreground.speed = params.foreground.speed or nil
				
		------------------------------------------------
		--                  PARRALAX                  --
		------------------------------------------------
		-- Create new parallax scene
		local myScene = parallax.newScene(
		{
			width = Parallax.width,
			height = Parallax.height,
			bottom = Parallax.height,
			left = Parallax.left,
			repeated = Parallax.repeated,
			group = Parallax.group
		} )
		local fg = Parallax.foreground
		local mg = Parallax.midground
		local bg = Parallax.background
		myScene:newLayer(
		{
			image = fg.img,
			width = fg.width,
			height = fg.height,
			bottom = fg.bottom,
			left = fg.left,
			speed = fg.speed,
			repeated = "horizontal"
		} )
		myScene:newLayer(
		{
			image = mg.img,
			width = mg.width,
			height = mg.height,
			bottom = mg.bottom,
			left = mg.left,
			speed = mg.speed,
			repeated = "horizontal"
		} )
		myScene:newLayer(
		{
			image = bg.img,
			width = bg.width,
			height = bg.height,
			bottom = bg.bottom,
			left = bg.left,
			speed = bg.speed,
			repeated = "horizontal"
		} )

		------------------------------------------------
		-- Functions
		-----------------------------------------------

		--Shift the Scene
		local incX = 0;					-- Amount X is incrimented
		local currentX, currentY = 0; 	-- Bottom Right = (0,0)
		local trans = nil				-- Screen post-touch move
		
		local shiftScene = function(event)
			-- Record movement of Screen by user
			if event.phase == "began" then
				incX = event.x;
				if not transition == nil then
					transition.cancel(trans)
					trans = nil
				end
			end
			
			-- Set Input Conditions for Screen Movement
			if ((event.x - incX ~= 0) and (event.x - incX < 50) and  (event.x - incX > -50)) then
			-- Check if new screen location is within bounds
				newX = currentX - (event.x - incX);
				if newX >= 0 and newX <= Parallax.width then
					currentX = newX;
					-- Move all children by incX
					for i=1,params.group.numChildren do
						local child = params.group[i];
						if child.movy == nil then
							child.x = child.x + (event.x-incX)
						end
					end

					-- Move Parallax
					myScene.xPrev = incX;
					myScene:move(event.x - myScene.xPrev, 0)
					myScene.xPrev = event.x
				end					
			end
			-- Set new incX
			incX = event.x
			--print(currentX)
			--[[
			if event.phase == "ended" or "cancelled" then
				if currentX <= Parallax.width/2 then
					trans = transition.to(myScene, {x})
				else
					trans = transition.to(myScene, {x})
				end
			end
			]]
		end

		myScene:addEventListener("touch", shiftScene)
end
Parallax.levelScene = levelScene

return Parallax