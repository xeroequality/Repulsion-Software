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
		local chapter = 1; --Which Chapter Are We On?
        
        -----------------------------------------------------------------------------
                
        --      INSERT code here (e.g. start timers, load audio, start listeners, etc.)
		
		w = display.contentWidth; h = display.contentHeight;

		-- Make the Space Backgrounds
		local space1 = display.newImage( "../images/space.png" )
		space1:setReferencePoint ( display.CenterReferencePoint )
		space1.x = 50
		space1.y = h/2
		local space2 = display.newImage("../images/space.png" )
		--space2:setReferencePoint ( display.CenterReferencePoint )
		space2.x = -w*2+50
		space2.y = h/2
		
		--Move the Space Backgrounds
		function moveSpace (event)
			if space1.x >= 2*w then
				space1.x = -2*w
			end
			if space2.x >= 2*w then
				space2.x = -2*w
			end
			--print("space1: " .. space1.x)
			--print("space2: " .. space2.x)
			space1.x = space1.x + 1
			space2.x = space2.x + 1
		end
		
		Runtime:addEventListener("enterFrame",moveSpace);

		--Create Earth
		local earth = display.newImageRect("../images/earth_slice.png",600,185)
		earth:setReferencePoint ( display.CenterReferencePoint )
		earth.x = w/2-10; earth.y = h-80;
		
		--Create the Level Select Buttons
		local lvl = {};
		lvl[1] = display.newImage("../images/background_greenbutton.png");
		lvl[2] = display.newImage("../images/background_purplebutton.png");
		lvl[3] = display.newImage("../images/background_blackwhitebutton.png");
		lvl[4] = display.newImage("../images/background_yellowbutton.png");
		lvl[5] = display.newImage("../images/background_bossbutton.png");
		
		--Create the Level Texts Too
		local lvltext = {};
		lvltext[1] = display.newText("1",0,0,"Comic Sans MS",40);
		lvltext[2] = display.newText("2",0,0,"Comic Sans MS",40);
		lvltext[3] = display.newText("3",0,0,"Comic Sans MS",40);
		lvltext[4] = display.newText("4",0,0,"Comic Sans MS",40);
		lvltext[5] = display.newText("5",0,0,"Comic Sans MS",40);
		
		--Changing the Color
		--lvl3text:setTextColor(math.random(256)-1,math.random(256)-1,math.random(256)-1);
		--lvl4text:setTextColor(math.random(256)-1,math.random(256)-1,math.random(256)-1);
		
		lvltext[3]:setTextColor(150,33,50) --Maroon
		lvltext[4]:setTextColor(47,79,47) --Dark Green
		
		--[[
		local pp = native.getFontNames()
		i = 190;
		while i > 0 do
			print(pp[i]);
			i = i - 1;
		end--]]
		
		--Scale it So Each Image is 64x64
		lvl[1]:scale((2/3),(2/3)); lvl[2]:scale((2/3),(2/3)); lvl[3]:scale((2/3),(2/3)); lvl[4]:scale((2/3),(2/3)); lvl[5]:scale((2/3),(2/3));
		
		--s denotes how much space is between the border of the phone and the first button (also the border and the last button
		--b denotes how much space is between each button
		--iw denotes how long in width is each image
		--yy denotes the y position of all the Level Select Buttons
		--lvlpos is going to array telling us where the x locations of every button is
		-- (5 * iw) + (2 * s) + (4 * b) = (display.contentWidth)
		local s = 30; local b = 25; local iw = 96*(2/3);
		local xx = 0; local yy = 75;
		local lvlpos = {};
		
		lvl[1].y = yy; lvl[2].y = yy; lvl[3].y = yy; lvl[4].y = yy; lvl[5].y = yy;
		lvltext[1].y = yy; lvltext[2].y = yy; lvltext[3].y = yy; lvltext[4].y = yy; lvltext[5].y = yy;
		
		--Place the Level Select Buttons Based on the Numbers Declared Above
		xx = xx + s + (iw/2); --First, Position of lvl1 Button
		lvl[1].x = xx; lvltext[1].x = xx; lvlpos[1] = xx;
		xx = xx + (iw/2) + b + (iw/2); --Add the Break Length and the Length of a Button
		lvl[2].x = xx; lvltext[2].x = xx; lvlpos[2] = xx;
		xx = xx + (iw/2) + b + (iw/2); --Do This Until All the Buttons are Placed
		lvl[3].x = xx; lvltext[3].x = xx; lvlpos[3] = xx;
		xx = xx + (iw/2) + b + (iw/2);
		lvl[4].x = xx; lvltext[4].x = xx; lvlpos[4] = xx;
		xx = xx + (iw/2) + b + (iw/2);
		lvl[5].x = xx; lvltext[5].x = xx; lvlpos[5] = xx;
		
		local overlay = false; local overlay_activity = false;
		
		--bouncefactor denotes how far up/down them buttons bounce
		--bouncedir tells which direction the buttons are bouncing
		--bouncespeed denotes how far they bounce every frame
		local i = 0; local bouncefactor = 5; local bouncespeed = 0.5;
		local bouncedir = {"up","up","up","up","up"}
		
		--Adjust Them Buttons
		local loc = bouncefactor;
		for i = 1, 5 do
		
			lvl[i].y = (yy-loc); lvltext[i].y = (yy-loc);
			loc = loc - ((2*bouncefactor)/5);
		
		end
		
		--Bounce Them Buttons
		function bouncingButtons(event)	
			if overlay == false then			
				for i = 1, 5 do				
					if bouncedir[i] == "up" then					
						lvl[i].y = lvl[i].y - bouncespeed;
						lvltext[i].y = lvltext[i].y - bouncespeed;						
						if lvl[i].y <= (yy-bouncefactor) then
							lvl[i].y = (yy-bouncefactor);
							lvltext[i].y = (yy-bouncefactor);
							bouncedir[i] = "down";
						end						
					else					
						lvl[i].y = lvl[i].y + bouncespeed;
						lvltext[i].y = lvltext[i].y + bouncespeed;						
						if lvl[i].y >= (yy+bouncefactor) then
							lvl[i].y = (yy+bouncefactor);
							lvltext[i].y = (yy+bouncefactor);
							bouncedir[i] = "up";
						end						
					end					
				end				
			end		
		end
		
		Runtime:addEventListener("enterFrame",bouncingButtons);
		
		--GO Button
		local GO = display.newImage("../images/background_GOWhite.png");
		GO.x = w-50; GO.y = h-50; GO.alpha = 0.5; GO:scale(0.8,0.8);
		
		overlay = false; local overlay_activity = false; local overlay_level = 1;
		local button = 0;
		
		--Clicking On Them Level Select Buttons
		function levelSelectButton(event)
		
			--Do The Function When the Player Let's Go of Their Pressure
			if event.phase == "ended" then
			
				--Find Out Which Button Has Been Pressed
				for i = 1, 5 do				
					if event.x >= (lvlpos[i]-(iw/2)) and event.x <= (lvlpos[i]+(iw/2)) then
						button = i; --Set Button To That Level
					end				
				end
			
				--If the Overlay Isn't Up Yet
				if overlay == false and overlay_activity == false then
					--Set Up the Overlay and Make it Show The Chosen Level
					overlay = true;
					overlay_activity = true;
					overlay_level = button;
				else
				--If Not...
				
					--Check to See If The Button Pressed is the Same One
					if overlay_level ~= button then
						--If Not, Switch Overlay Image to New Level
						overlay_level = button
					else
						--If It Is, then Get Off of the Overlay
						overlay = false;
						overlay_activity = true;
					end
				
				end
			
			end
		
		end
		for i = 1, 5 do
			lvl[i]:addEventListener("touch",levelSelectButton);
		end
		
		--Overlay Animation Variables
		local anim_time = 15; --How Much Time Spent for Overlay Animation (Both Ways)
		local now_time = 0; --The Current Time for the Current Animation
		local b_dis = math.abs(yy-(iw/2)); --Distance Between the Button's Current Location and Button's Destination;
		local e_dis = math.abs((h)-(h-80)); --Distance Between the Earth's Current Location and Earth's Destination;
		local e_alpha = 0.5; --Earth Final Alpha Value
		local once = false; --Preliminary Things Before Animating
		local r_w = (5*iw)+(2*b); --Length of the Overlay Rectangle
		local r_h = 256; --Height of the Overlay Rectangle
		
		--Make the Overlay Rectangle
		local overlayrect = display.newImageRect("../images/background_brownishbox.png",r_w,r_h);
		overlayrect.alpha = 0;
		
		--Overlay Animation (Which Switching In and Out of the Overlay
		function overlay_animation(event)
		
			--Check to See If We Need to Animate
			if overlay_activity == true then
			
				--Are We Going Into the Overlay?
				if overlay == true then
				
					if once == false then
						once = true;
						for i = 1,5 do
							lvl[i].y = yy; lvltext[i].y = yy;
						end
					end
				
					now_time = now_time - 1;
					
					--Move the Buttons Up (to y = (iw/2))
					for i = 1,5 do
						lvl[i].y =  lvl[i].y - (b_dis/anim_time);
						lvltext[i].y = lvltext[i].y - (b_dis/anim_time);
					end
					
					--Fix the Earth's Alpha
					earth.alpha = earth.alpha - ((1-e_alpha)/anim_time);
					
					--Move the Earth Down
					earth.y = earth.y + (e_dis/anim_time);
					
					--Create That Rectangle
					
					--Is Time Up?
					if now_time <= 0 then
						overlay_activity = false;
						for i = 1,5 do
							lvl[i].y = (iw/2); lvltext[i].y = (iw/2);
						end
					end
				
				else
				--If We Are Leaving...
				
				end
				
			else
			
				now_time = anim_time; --Reset the Time
				once = false;
			
			end
		
		end
		Runtime:addEventListener("enterFrame",overlay_animation)
        
		
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
