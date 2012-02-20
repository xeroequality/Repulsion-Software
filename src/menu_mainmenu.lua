--
-- Project: KatAstrophy
-- Description: 
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2012 Jason Simmons. All Rights Reserved.
-- 

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
 
----------------------------------------------------------------------------------
-- 
--      NOTE:
--      
--      Code outside of listener functions (below) will only be executed once,
--      unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------
 
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
 
-- Called when the scene's view does not exist:
function scene:createScene( event )
        local group = self.view
 
	
        -----------------------------------------------------------------------------
                
        --      CREATE display objects and add them to 'group' here.
        --      Example use-case: Restore 'group' from previously saved state.
        
        -----------------------------------------------------------------------------
        
end
 
 
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
        local group = self.view
        
        -----------------------------------------------------------------------------
                
        --      INSERT code here (e.g. start timers, load audio, start listeners, etc.)
		
		local physics = require( "physics" )
		physics.start()

		local sky = display.newImage( "../images/test_bkg_clouds.png")
		sky.x = 0
		sky.y = 0
		sky:scale(3,2)
		
		-- Make the Signs
		local SPsign = display.newImage("../images/background_SPsign.png")
		local MPsign = display.newImage("../images/background_MPsign.png")
		local settings_Sign = display.newImage("../images/background_Settingssign.png")
		local help_Sign = display.newImage("../images/background_Helpsign.png")
		cW = display.contentWidth/2;
		cH = display.contentHeight/2;
		
		SPsign.x = cW; SPsign.y = 45;
		
		MPsign.y = cH; MPsign.x = cW+115; MPsign:rotate(90)
		
		settings_Sign.x = cW; settings_Sign.y = cH+115; settings_Sign:rotate(180)
		
		help_Sign.y = cH; help_Sign.x = cW-115; help_Sign:rotate(270)
		
		-- Create the Earth
		local earth = display.newImage("../images/background_earth.png")
		earth.x = display.contentWidth/2
		earth.y = display.contentHeight/2
		
		SPangle = 0+270;
		MPangle = 90+270;
		setangle = 180+270;
		helpangle = 270+270;
		increment = 0.1;
		r = 115;
		
		MPsign:scale(0.5,0.5)
		settings_Sign:scale(0.5,0.5)
		help_Sign:scale(0.5,0.5)
		
		--[[
		function rotateStuff(event)
			earth:rotate(increment)
			
			SPangle = SPangle + increment;
			MPangle = MPangle + increment;
			setangle = setangle + increment;
			helpangle = helpangle + increment;
			if SPangle > 360 then SPangle = SPangle - 360 end
			if MPangle > 360 then MPangle = MPangle - 360 end
			if setangle > 360 then setangle = setangle - 360 end
			if helpangle > 360 then helpangle = helpangle - 360 end
			
			SPsign:rotate(increment);
			MPsign:rotate(increment);
			settings_Sign:rotate(increment);
			help_Sign:rotate(increment);
			
			-- Adjust x and y
			SPr = SPangle*(math.pi/180);
			SPsign.x = (r*math.cos(SPr))+(cW); SPsign.y = (r*math.sin(SPr))+cH;
			MPr = MPangle*(math.pi/180);
			MPsign.x = (r*math.cos(MPr))+(cW); MPsign.y = (r*math.sin(MPr))+cH;
			setr = setangle*(math.pi/180);
			settings_Sign.x = (r*math.cos(setr))+(cW); settings_Sign.y = (r*math.sin(setr))+cH;
			helpr = helpangle*(math.pi/180);
			help_Sign.x = (r*math.cos(helpr))+(cW); help_Sign.y = (r*math.sin(helpr))+cH;
		end
		
		Runtime:addEventListener("enterFrame",rotateStuff)
		--]]
		
		turning = false;
		
		function rotateStuff(event)
		
			if event.phase == "ended" and turning == false then
				distance = math.sqrt( (event.x-event.xStart)^2 + (event.y-event.yStart)^2 )
				if distance >= 25 then
				
					-- Rotate Clockwise
					if event.x > event.xStart then
						increment = 90
						turning = true;
						
					-- Rotate Counterclockwise
					else
						increment = -90
						turning = true;
						
					end
					
					if SPangle == 270 then SPsign:scale(0.5,0.5) end
					if MPangle == 270 then MPsign:scale(0.5,0.5) end
					if setangle == 270 then settings_Sign:scale(0.5,0.5) end
					if helpangle == 270 then help_Sign:scale(0.5,0.5) end
						
						
				end
			end
			
		end
		
		function rotateAnimation(event)
		
			if turning == true then
			
				inc = 10;
				if increment > 0 then
					increment = increment - inc;
				else
					increment = increment + inc;
					inc = inc * -1;
				end
		
				SPsign:rotate(inc)
				MPsign:rotate(inc)
				settings_Sign:rotate(inc)
				help_Sign:rotate(inc)
				earth:rotate(inc)
				
				SPangle = SPangle + inc;
				MPangle = MPangle + inc;
				setangle = setangle + inc;
				helpangle = helpangle + inc;
				if SPangle >= 360 then SPangle = SPangle - 360 end
				if MPangle >= 360 then MPangle = MPangle - 360 end
				if setangle >= 360 then setangle = setangle - 360 end
				if helpangle >= 360 then helpangle = helpangle - 360 end
				
				-- Adjust x and y
				SPr = SPangle*(math.pi/180);
				SPsign.x = (r*math.cos(SPr))+(cW); SPsign.y = (r*math.sin(SPr))+cH;
				MPr = MPangle*(math.pi/180);
				MPsign.x = (r*math.cos(MPr))+(cW); MPsign.y = (r*math.sin(MPr))+cH;
				setr = setangle*(math.pi/180);
				settings_Sign.x = (r*math.cos(setr))+(cW); settings_Sign.y = (r*math.sin(setr))+cH;
				helpr = helpangle*(math.pi/180);
				help_Sign.x = (r*math.cos(helpr))+(cW); help_Sign.y = (r*math.sin(helpr))+cH;
				
				if increment == 0 then
					turning = false
					
					if SPangle == 270 then SPsign:scale(2,2) end
					if MPangle == 270 then MPsign:scale(2,2) end
					if setangle == 270 then settings_Sign:scale(2,2) end
					if helpangle == 270 then help_Sign:scale(2,2) end
				end

			end
		
		end
		
		sky:addEventListener("touch",rotateStuff);
		Runtime:addEventListener("enterFrame",rotateAnimation);
		
        
end
 
 
-- Called when scene is about to move offscreen:
function scene:exitScene( event )
        local group = self.view
        
        -----------------------------------------------------------------------------
        
        --      INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
        
        -----------------------------------------------------------------------------
        
end
 
 
-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
        local group = self.view
        
        -----------------------------------------------------------------------------
        
        --      INSERT code here (e.g. remove listeners, widgets, save state, etc.)
        
        -----------------------------------------------------------------------------
        
end
 
---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
 
-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )
 
-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )
 
-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )
 
-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )
 
---------------------------------------------------------------------------------
 
return scene
