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
local widget = require("widget")
local scene = storyboard.newScene()
 
----------------------------------------------------------------------------------
-- 
--      NOTE:
--      
--      Code outside of listener functions (below) will only be executed once,
--      unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------
local selectButton;
local function nextScreen()

	-- Check which Screen to Goto
	--if SPangle == 270 then storyboard.gotoScene( "menu_mainmenu_singleplayer", "fade", 200 ) end
	if SPangle == 270 then storyboard.gotoScene( "menu_splash", "fade", 200 ) end
	if MPangle == 270 then storyboard.gotoScene( "menu_mainmenu_multiplayer", "fade", 200 ) end
	if setangle == 270 then storyboard.gotoScene( "menu_mainmenu_settings", "fade", 200 ) end
	if helpangle == 270 then storyboard.gotoScene( "menu_mainmenu_aboutus", "fade", 200 ) end

	return true;

end
 
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
		
		cW = display.contentWidth/2;
		cH = display.contentHeight/2;
		pH = cH;
		w = display.contentWidth;
		h = display.contentHeight;

		local sky = display.newImage( "../images/space.png")
		local space = display.newImage("../images/space.png")
		sky.x = 0
		sky.y = h/2
		space.x = -w*2
		space.y = h/2
		
		-- Logo in Background
		pH = 50;
		local logo = display.newImage("../images/logo.png");
		logo.x = cW; logo.y = pH; logo.alpha = 0.75;
		
		up = true;
		bounce_limit = 10;
		moving = 1;
		
		-- Push the Logo Up and Down
		function bouncyLogo(event)
		
			if up == true then
				logo.y = logo.y - moving;
				if logo.y <= (pH-bounce_limit) then
					logo.y = (pH-bounce_limit)
					up = false;
				end
			else
				logo.y = logo.y + moving;
				if logo.y >= (pH+bounce_limit) then
					logo.y = (pH+bounce_limit)
					up = true;
				end
			end
		
		end
		
		function moveSpace(event)
			if sky.x >= 2*w then
				sky.x = -2*w
			end
			if space.x >= 2*w then
				space.x = -2*w
			end
			sky.x = sky.x + 1
			space.x = space.x + 1
		end
		
		Runtime:addEventListener("enterFrame",moveSpace);
		Runtime:addEventListener("enterFrame",bouncyLogo);
		
		cH = display.contentHeight+25;
		
		-- Make the Signs
		local SPsign = display.newImage("../images/background_SPsign.png")
		local MPsign = display.newImage("../images/background_MPsign.png")
		local settings_Sign = display.newImage("../images/background_Settingssign.png")
		local help_Sign = display.newImage("../images/background_Helpsign.png")
		local UFO = display.newImage("../images/background_UFO.png")
		
		UFO.x = 45; UFO.y = cH-145; UFO:scale(0.75,0.75); UFO_bottom = ((96*0.75)/2)+UFO.y;
		
		SPsign.x = cW; SPsign.y = cH-115;
		
		MPsign.y = cH; MPsign.x = cW+115; MPsign:rotate(90)
		
		settings_Sign.x = cW; settings_Sign.y = cH+115; settings_Sign:rotate(180)
		
		help_Sign.y = cH; help_Sign.x = cW-115; help_Sign:rotate(270)
		
		-- Create the Earth
		local earth = display.newImage("../images/background_earth.png")
		earth.x = display.contentWidth/2
		earth.y = cH;
		
		SPangle = 0+270;
		MPangle = 90+270;
		setangle = 180+270;
		helpangle = 270+270;
		UFOangle = 0;
		wobble_way = true;
		increment = 0.1;
		r = 115;
		
		MPsign:scale(0.5,0.5)
		settings_Sign:scale(0.5,0.5)
		help_Sign:scale(0.5,0.5)
		
		-- Wobble the UFO
		function wobble(event)
		
			if wobble_way == true then
				UFOangle = UFOangle + 3;
				if UFOangle >= 30 then wobble_way = false end
				UFO:rotate(3)
			else
				UFOangle = UFOangle - 3;
				if UFOangle <= -30 then wobble_way = true end
				UFO:rotate(-3)
			end
		
		end
		
		Runtime:addEventListener("enterFrame",wobble)
		
		-- Box Variables
		width = 200; height = 50; yStart1 = cH-230; yStart2 = cH - 180;
		xStart1 = cW-100; xStart2 = cW+100; move_speed = 10;
		sx1 = cW; ex1 = xStart2-50;
		sx2 = cW; ex2 = xStart1+50;
		sy1 = yStart1; ey1 = yStart1;
		sy2 = yStart2; ey2 = yStart2;
		
		S1 = "left"; E1 = "left"; S2 = "right"; E2 = "right";
		
		local line1 = display.newLine(sx1,sy1,ex1,ey1);
		local line2 = display.newLine(sx2,sy2,ex2,ey2);
		local line3 = display.newLine(0,0,0,0);
		local line4 = display.newLine(0,0,0,0);
		local aline1 = display.newLine(45,UFO_bottom,sx1,sy1);
		local aline2 = display.newLine(45,UFO_bottom,sx2,sy2);
		line1:setColor(0,255,0); line1.width = 3;
		line2:setColor(0,255,0); line2.width = 3;
		line3:setColor(0,255,0); line3.width = 3;
		line4:setColor(0,255,0); line4.width = 3;
		aline1:setColor(0,255,0); aline1.width = 3;
		aline2:setColor(0,255,0); aline2.width = 3;
		
		local helpText = display.newText("Protect or Conquer the World in the Single Player Campaign!",xStart1+2,yStart1+2,width-2,height-2,native.systemFont,12);
		
		-- Show the Help
		function help(event)
		
			-- Draw Them Lines
			
			-- All Lines Right Now
			line1:removeSelf(); line2:removeSelf();
			line3:removeSelf(); line4:removeSelf();
			aline1:removeSelf(); aline2:removeSelf();
			
			-- Follow the First two Points
			if S1 == "left" then
				sx1 = sx1 - move_speed;
				if sx1 <= xStart1 then sx1 = xStart1; S1 = "down"; end
			end
			if S1 == "down" then
				sy1 = sy1 + move_speed;
				if sy1 >= yStart2 then sy1 = yStart2; S1 = "right"; end
			end
			if S1 == "right" then
				sx1 = sx1 + move_speed;
				if sx1 >= xStart2 then sx1 = xStart2; S1 = "up"; end
			end
			if S1 == "up" then
				sy1 = sy1 - move_speed;
				if sy1 <= yStart1 then sy1 = yStart1; S1 = "left"; end
			end
			
			-- S2
			if S2 == "left" then
				sx2 = sx2 - move_speed;
				if sx2 <= xStart1 then sx2 = xStart1; S2 = "down"; end
			end
			if S2 == "down" then
				sy2 = sy2 + move_speed;
				if sy2 >= yStart2 then sy2 = yStart2; S2 = "right"; end
			end
			if S2 == "right" then
				sx2 = sx2 + move_speed;
				if sx2 >= xStart2 then sx2 = xStart2; S2 = "up"; end
			end
			if S2 == "up" then
				sy2 = sy2 - move_speed;
				if sy2 <= yStart1 then sy2 = yStart1; S2 = "left"; end
			end
			
			-- E1
			if E1 == "left" then
				ex1 = ex1 - move_speed;
				if ex1 <= xStart1 then ex1 = xStart1; E1 = "down"; end
			end
			if E1 == "down" then
				ey1 = ey1 + move_speed;
				if ey1 >= yStart2 then ey1 = yStart2; E1 = "right"; end
			end
			if E1 == "right" then
				ex1 = ex1 + move_speed;
				if ex1 >= xStart2 then ex1 = xStart2; E1 = "up"; end
			end
			if E1 == "up" then
				ey1 = ey1 - move_speed;
				if ey1 <= yStart1 then ey1 = yStart1; E1 = "left"; end
			end
			
			-- E2
			if E2 == "left" then
				ex2 = ex2 - move_speed;
				if ex2 <= xStart1 then ex2 = xStart1; E2 = "down"; end
			end
			if E2 == "down" then
				ey2 = ey2 + move_speed;
				if ey2 >= yStart2 then ey2 = yStart2; E2 = "right"; end
			end
			if E2 == "right" then
				ex2 = ex2+ move_speed;
				if ex2 >= xStart2 then ex2 = xStart2; E2 = "up"; end
			end
			if E2 == "up" then
				ey2 = ey2 - move_speed;
				if ey2 <= yStart1 then ey2 = yStart1; E2 = "left"; end
			end
			
			-- Assign values
			if S1 == "down" or S1 == "left" then
				line1 = display.newLine(group,sx1,yStart1,ex1,yStart1);
				line3 = display.newLine(group,xStart1,sy1,xStart1,yStart1);
			else
				line1 = display.newLine(group,sx1,yStart2,ex1,yStart2);
				line3 = display.newLine(group,xStart2,sy1,xStart2,yStart2);
			end
			if S2 == "down" or S2 == "left" then
				line2 = display.newLine(group,sx2,yStart1,ex2,yStart1);
				line4 = display.newLine(group,xStart1,sy2,xStart1,yStart1);
			else
				line2 = display.newLine(group,sx2,yStart2,ex2,yStart2);
				line4 = display.newLine(group,xStart2,sy2,xStart2,yStart2);
			end
			aline1 = display.newLine(group,45,UFO_bottom,sx1,sy1);
			aline2 = display.newLine(group,45,UFO_bottom,sx2,sy2);
			line1:setColor(0,255,0); line1.width = 3;
			line2:setColor(0,255,0); line2.width = 3;
			line3:setColor(0,255,0); line3.width = 3;
			line4:setColor(0,255,0); line4.width = 3;
			aline1:setColor(0,255,0); aline1.width = 3; aline1.alpha = 0.5;
			aline2:setColor(0,255,0); aline2.width = 3; aline2.alpha = 0.5;
			
			-- Ensure UFO is On Top
			group:insert(UFO)
			
			-- Display Text
			if SPangle == 270 then
				helpText.text = "Protect or Conquer the World in the Single Player Campaign!";
			end
			if MPangle == 270 then
				helpText.text = "Play Against a Friend and Go for the High Score!";
			end
			if setangle == 270 then
				helpText.text = "Change the Game Settings and Options Here!";
			end
			if helpangle == 270 then
				helpText.text = "Check Out the Tutorial Here or Find Out Who Made the Game!";
			end
		
		end
		
		Runtime:addEventListener("enterFrame",help)
		
		turning = false;
		fade = 1; down_fade = 0.3;
		
		local right_arrow = display.newImage("../images/background_rightarrow.png");
		local left_arrow = display.newImage("../images/background_leftarrow.png");
		right_arrow.x = cW+(cW/2); right_arrow.y = (cH-115)+15; right_arrow:scale(0.25,0.25); right_arrow:rotate(30);
		left_arrow.x = cW-(cW/2); left_arrow.y = (cH-115)+15; left_arrow:scale(0.25,0.25); left_arrow:rotate(-30);
		
		
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
					
					fade = 1;
						
						
				end
			end
			
		end
		
		function rotateAnimation(event)
		
			if turning == true then
			
				right_arrow.alpha = fade;
				left_arrow.alpha = fade;
				
				if fade > 0 then
					fade = fade - down_fade;
					if fade <= 0 then fade = 0 end
				end
			
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
				if SPangle < 0 then SPangle = SPangle + 360 end
				if MPangle < 0 then MPangle = MPangle + 360 end
				if setangle < 0 then setangle = setangle + 360 end
				if helpangle < 0 then helpangle = helpangle + 360 end
				
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
				
			else
		
				right_arrow.alpha = fade;
				left_arrow.alpha = fade;
				
				if fade < 1 then
					fade = fade + down_fade
					if fade >= 1 then fade = 1 end
				end

			end
			
		
		
		end
		
		sky:addEventListener("touch",rotateStuff);
		space:addEventListener("touch",rotateStuff);
		Runtime:addEventListener("enterFrame",rotateAnimation);
		
		nextButton = widget.newButton{
			label="Play",
			labelColor = { default={255}, over={128} },
			default="../images/buttonInActive.png",
			over="../images/buttonActive.png",
			width=96; height=96;

			onRelease = nextScreen
		}
		nextButton.view:setReferencePoint( display.CenterReferencePoint )
		nextButton.view.x = cW
		nextButton.view.y = cH-115
		nextButton.view.alpha = 0.01	
		
		group:insert(sky)
		group:insert(space)
		group:insert(logo)
		group:insert(SPsign)
		group:insert(MPsign)
		group:insert(settings_Sign)
		group:insert(help_Sign)
		group:insert(earth)
		group:insert(left_arrow)
		group:insert(right_arrow)
		group:insert(nextButton.view)
		group:insert(helpText)
		group:insert(line1); group:insert(line2); group:insert(aline1); group:insert(aline2);
		group:insert(UFO)
		
        
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
