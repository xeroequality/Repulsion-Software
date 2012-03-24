--	-	-	-	-	-	-	-	-	-	-	-	-	-
--	Title:		Parallax Module
--	Copyright: 	Repulsion Software, 2012
--	-	-	-	-	-	-	-	-	-	-	-	-	-

-- Includes
Parallax = {}
local parallax = require( "parallax" )

local function levelScene( params )

		local levelWidth = params.Width
		local levelHeight = params.Height
		
		--Overlay Variables
		overlay = false; --Is the Overlay Up?
		overlay_activity = false; --Is There Overlay Animation Going On?
				
		------------------------------------------------
		--                  PARRALAX                  --
		------------------------------------------------
		-- Create new parallax scene
		local myScene = parallax.newScene(
		{
			width = levelWidth,
			height = levelHeight,
			bottom = levelHeight,
			left = 0,
			repeated = true,
			group = params.Group
		} )
		-- Midground Front (City Scape)
		myScene:newLayer(
		{
			image = params.Foreground_Near,
			width = params.FGN_W, height = params.FGN_H,
			bottom = levelHeight,
			left = 0,
			speed = 0.7,
			repeated = "horizontal"
		} )
		-- Midground Back (City Scape)
		myScene:newLayer(
		{
			image = params.Foreground_Far,
			width = params.FGF_W, height = params.FGF_H,
			bottom = levelHeight,
			left = -106,
			speed = 0.6,
			repeated = "horizontal"
		} )
		-- Background (Sky)
		myScene:newLayer(
		{
			image = params.Background,
			width = params.BGW, height = params.BGH,
			top = display.contentHeight - params.BGH,
			left = 0,
			speed = 0.5,
			repeated = "horizontal"
		} )

		------------------------------------------------
		-- Functions
		-----------------------------------------------

		--Shift the Scene
		local incX = 0;					-- Amount X is incrimented
		local currentX, currentY = 0; 	-- Bottom Right = (0,0)
		
		function shiftScene(event)
			if overlay == false then		
				-- Record movement of Screen by user
				if event.phase == "began" then
					incX = event.x;			
				end
				
				-- Set Input Conditions for Screen Movement
				if ((event.x - incX ~= 0) and (event.x - incX < 50) and  (event.x - incX > -50)) then

				-- Check if new screen location is within bounds
					newX = currentX - (event.x - incX);
					if ((newX >= 0) and (newX <= (levelWidth - display.contentWidth))) then

					-- Set the new currentX
					currentX = newX;
					print ("Screen Moved: oldX = " .. " newX = " .. currentX);
					
					-- Move all children by incX
						for i=2,params.Group.numChildren do
							local child = params.Group[i];
							child.x = child.x + (event.x-incX);
						end

						-- Move Paralax
						myScene.xPrev = incX;
						myScene:move(event.x - myScene.xPrev, 0)
						myScene.xPrev = event.x
					end					
				end
				
				-- Set new incX
				incX = event.x
			end
			
		end

		--------------------------------------------
		-- Events
		--------------------------------------------
		myScene:addEventListener("touch", shiftScene)
end
Parallax.levelScene = levelScene

return Parallax