local storyboard = require( "storyboard" )
local widget = require( "widget" )
local scene = storyboard.newScene()
 
----------------------------------------------------------------------------------
-- 
--      NOTE:
--      
--      Code outside of listener functions (below) will only be executed once,
--      unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------
local backBtn
local levelBtn = {};

-- 'onRelease' event listener for playBtn
local function onBtnRelease(event)
	local t = event.target
	local label = t.id
	print("released button " .. label)
	storyboard.gotoScene( label, "fade", 200)
	return true	-- indicates successful touch

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
                
        -- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
		backBtn = widget.newButton{
			id="menu_sp_main",
			labelColor = { default={255}, over={128} },
			default="../images/btn_back.png",
			over="../images/btn_back_pressed.png",
			width=96, height=32,
			onRelease = onBtnRelease
		}
		backBtn.view:setReferencePoint( display.CenterReferencePoint )
		
		--Set Up the Width and Height Variables
		w = display.contentWidth; h = display.contentHeight;

		-- Make the Space Backgrounds
		local space1 = display.newImage( "../images/space.png" )
		space1:setReferencePoint ( display.CenterReferencePoint )
		space1.x = 50; space1.y = h/2
		local space2 = display.newImage("../images/space.png" )
		space2:setReferencePoint ( display.CenterReferencePoint )
		space2.x = -w*2+50; space2.y = h/2
		
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
		
		local chapter = 1; --Which Chapter Are We On?
		
		--Create Earth
		local earth = display.newImageRect("../images/earth_slice.png",600,185)
		earth:setReferencePoint ( display.CenterReferencePoint )
		earth.x = w/2-10; earth.y = h-80;
		
		--Create the Level Select Buttons
		local lvl = {};
		lvl[1] = display.newImage("../images/btn_level1.png");
		lvl[2] = display.newImage("../images/btn_level2.png");
		lvl[3] = display.newImage("../images/btn_level3.png");
		lvl[4] = display.newImage("../images/btn_level4.png");
		lvl[5] = display.newImage("../images/btn_level5.png");
		
		--GO Button
		local GO = display.newImage("../images/background_GOWhite.png");
		local overlayBack = display.newImage("../images/background_redX.png");
		GO.x = w-30; GO.y = h-50; GO.alpha = 0.5; GO:scale(0.8,0.8);
		backBtn.view.x = 30; backBtn.view.y = h-50;
		overlayBack.x = w-80; overlayBack.y = 60; overlayBack.alpha = 0; overlayBack:scale(0.8,0.8);
		
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
		
		--Place the Level Select Buttons Based on the Numbers Declared Above
		xx = xx + s + (iw/2); --First, Position of lvl1 Button
		lvl[1].x = xx; lvlpos[1] = xx;
		xx = xx + (iw/2) + b + (iw/2); --Add the Break Length and the Length of a Button
		lvl[2].x = xx; lvlpos[2] = xx;
		xx = xx + (iw/2) + b + (iw/2); --Do This Until All the Buttons are Placed
		lvl[3].x = xx; lvlpos[3] = xx;
		xx = xx + (iw/2) + b + (iw/2);
		lvl[4].x = xx; lvlpos[4] = xx;
		xx = xx + (iw/2) + b + (iw/2);
		lvl[5].x = xx; lvlpos[5] = xx;
		
		--bouncefactor denotes how far up/down them buttons bounce
		--bouncedir tells which direction the buttons are bouncing
		--bouncespeed denotes how far they bounce every frame
		local i = 0; local bouncefactor = 5; local bouncespeed = 0.5;
		local bouncedir = {"up","up","up","up","up"}
		
		--Adjust Them Buttons
		local loc = bouncefactor;
		for i = 1, 5 do
			lvl[i].y = (yy-loc);
			loc = loc - ((2*bouncefactor)/5);		
		end
		
		--Overlay Variables
		local overlay = false; --Is the Overlay Up?
		local overlay_activity = false; --Is There Overlay Animation Going On?
		local overlay_level = 1; --Which Level Did The Player Choose?
		local button = 0; --A Flag Variable
		
		--Bounce Them Buttons
		function bouncingButtons(event)	
			if overlay == false or overlay == true then			
				for i = 1, 5 do				
					if bouncedir[i] == "up" then					
						lvl[i].y = lvl[i].y - bouncespeed;
						if lvl[i].y <= (yy-bouncefactor) then
							lvl[i].y = (yy-bouncefactor);
							bouncedir[i] = "down";
						end						
					else					
						lvl[i].y = lvl[i].y + bouncespeed;
						if lvl[i].y >= (yy+bouncefactor) then
							lvl[i].y = (yy+bouncefactor);
							bouncedir[i] = "up";
						end						
					end					
				end				
			end		
		end
		
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
		--Add the Listeners to All the Level Select Buttons
		for i = 1, 5 do
			lvl[i]:addEventListener("touch",levelSelectButton);
		end
		
		--Overlay Animation Variables
		local anim_time = 25; --How Much Time Spent for Overlay Animation (Both Ways)
		local now_time = 0; --The Current Time for the Current Animation
		local r_alpha = 0; --Overlay's Starting Alpha Value
		local s_alpha = 0.7; --Shade Final Alpha Value
		local r_scale = 0.75; --Overlay's Starting Scale
		local nr_scale = r_scale; --Overlay's Current Scale
		local once = false; --Preliminary Things Before Animating
		local r_w = (5*iw)+(2*b); --Length of the Overlay Rectangle
		local r_h = 256; --Height of the Overlay Rectangle
		
		--Make the Overlay Rectangle
		local overlayshade = display.newRect(-w,0,w*3,h); --The Shady Part of the Screen
		overlayshade:setFillColor(0,0,0); overlayshade.alpha = 0;
		local overlayrect = display.newImageRect("../images/overlay_grey.png",r_w,r_h);
		overlayrect.alpha = 0; overlayrect.x = (w/2); overlayrect.y = (h/2);
		
		--Level Information
		local parScore = 0; local wallet = 0;
		local newMaterials = {}; local prohibitedMaterials = {};
		local newWeapons = {}; local prohibitedWeapons = {};
		
		--Text of the Overlay
		local oText = {};
		local oTextL = 2; --Length of Array
		oText[1] = display.newText("Par Score: ",0,0,"Comic Sans MS",20);
		oText[2] = display.newText("Wallet: ",0,0,"Comic Sans MS",20);
		oText[1].x = (w/2)-100; oText[1].y = (h/2)-100;
		oText[2].x = (w/2)-100; oText[2].y = (h/2)-50;
		for i = 1,oTextL do
			oText[i].alpha = 0;
		end
		
		--Overlay Animation (Which Switching In and Out of the Overlay
		function overlay_animation(event)		
			--Check to See If We Need to Animate
			if overlay_activity == true then			
				--Are We Going Into the Overlay?
				if overlay == true then
					--First Time Things
					if once == false then
						once = true;
						overlayshade.alpha = 0;
						overlayrect.alpha = r_alpha;
						now_time = anim_time;
						overlayrect:scale(r_scale,r_scale);
						nr_scale = (1-r_scale)/anim_time;
						nr_scale = (nr_scale+r_scale)/r_scale;
					end
					--Control Visibility of the Overlay Shade
					overlayshade.alpha = overlayshade.alpha + (s_alpha/anim_time)
					--Control Visibility of the Overlay Rectangle
					overlayrect.alpha = overlayrect.alpha + ((1-r_alpha)/anim_time)
					--Control Scaling of the Overlay Rectangle
					overlayrect:scale(nr_scale,nr_scale);
					--Countdown the Timer
					now_time = now_time - 1;
					--Is Time Up?
					if now_time <= 0 then
						overlay_activity = false;
						once = false;
						overlayshade.alpha = s_alpha;
						overlayrect.alpha = 1;
						local GO = display.newImage(group,"../images/background_GO.png");
						GO.x = w-30; GO.y = h-50; GO.alpha = 1; GO:scale(0.8,0.8);
						backBtn.view.alpha = 0; overlayBack.alpha = 1;
						
						--Get Some Info
						local path = system.pathForFile( "aliens_levelInfo.txt", system.ResourceDirectory )
						local file = io.open( path, "r" )
						local saveData;
						local str = "";
						local commencement = false; --Start Getting Some Data
						local linenum = 0;
						if button == 1 then str = "Level 1" end
						if button == 2 then str = "Level 2" end
						if button == 3 then str = "Level 3" end
						if button == 4 then str = "Level 4" end
						if button == 5 then str = "Level 5" end
						for line in file:lines() do
							saveData = line;
							
							--Find the Level Info
							if commencement == false then
								if saveData == str then commencement = true end --If This is it, then Continue
							else
								linenum = linenum + 1;
								--Read Par Score
								if linenum == 1 then parScore = saveData end
								if linenum == 2 then wallet = saveData end
								
								if savaData == "End" then commencement = false end;
							end
							
						end
						io.close( file )
						
						--Update the Text Stuff
						oText[1].text = "Par Score: "..parScore; oText[1].alpha = 1;
						oText[2].text = "Wallet: "..wallet; oText[2].alpha = 1;
					end				
				else
				--If We Are Leaving
					--First Time Things
					if once == false then
						once = true;
						overlayshade.alpha = s_alpha;
						overlayrect.alpha = 1;
						now_time = anim_time;
						nr_scale = (1-r_scale)/anim_time;
						nr_scale = (nr_scale-r_scale)/r_scale;
						overlayBack.alpha = 0;
						for i = 1,oTextL do
							oText[i].alpha = 0;
						end
					end
					--Control Visibility of the Overlay Shade
					overlayshade.alpha = overlayshade.alpha - (s_alpha/(anim_time+5))
					--Control Visibility of the Overlay Rectangle
					overlayrect.alpha = overlayrect.alpha - ((1-r_alpha)/(anim_time+5))
					--Control Scaling of the Overlay Rectangle
					overlayrect:scale(nr_scale,nr_scale);
					--Countdown the Timer
					now_time = now_time - 1;
					--Is Time Up?
					if now_time <= 0 then
						overlay_activity = false;
						overlayshade.alpha = 0;
						overlayrect.alpha = 0;
						once = false;
						local GO = display.newImage(group,"../images/background_GOWhite.png");
						GO.x = w-30; GO.y = h-50; GO.alpha = 0.5; GO:scale(0.8,0.8);
						backBtn.view.alpha = 1; overlayBack.alpha = 0;
						overlayrect:scale((1/r_scale),(1/r_scale));
					end	
				end
			else
				once = false;
			end			
		end
		
		--The Button Used to Get Out of the Overlay
		function overlayBackButton(event)
			if event.phase == "ended" and overlayBack.alpha == 1 and overlay == true then
				overlay = false;
				overlay_activity = true;
			end
		end
		
		--Display the Information onto the Overlay
		function overlayDisplay(event)
			--Is the Overlay Up and Is It Done Animating?
			if overlay == true and overlay_activity == false then
			end
		end
		
		--Add the Runtime Listeners
		Runtime:addEventListener("enterFrame",moveSpace)
		Runtime:addEventListener("enterFrame",bouncingButtons)
		Runtime:addEventListener("enterFrame",overlay_animation)
		Runtime:addEventListener("enterFrame",overlayDisplay)
		
		--Add Object Listeners
		overlayBack:addEventListener("touch",overlayBackButton)
		
		group:insert(space1)
		group:insert(space2)
		group:insert(earth)
		--Insert All the Texts and Images
		for i = 1,5 do
			group:insert(lvl[i]);
		end
		group:insert(overlayshade);
		group:insert(overlayrect);
		group:insert(GO)
		group:insert(backBtn.view)
		group:insert(overlayBack)
		
end
 
 
-- Called when scene is about to move offscreen:
function scene:exitScene( event )
        local group = self.view
        
        -----------------------------------------------------------------------------
        --      INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
        -----------------------------------------------------------------------------
		
		--Remove the Runtime Listeners
		Runtime:removeEventListener("enterFrame",moveSpace)
		Runtime:removeEventListener("enterFrame",bouncingButtons)
		Runtime:removeEventListener("enterFrame",overlay_animation)
		Runtime:removeEventListener("enterFrame",overlayDisplay)
        
		local num = group.numChildren;
		while num >= 1 do
			group:remove(num)
			num = num - 1
		end
end
 
 
-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
        local group = self.view
        
        -----------------------------------------------------------------------------
        --      INSERT code here (e.g. remove listeners, widgets, save state, etc.)
        -----------------------------------------------------------------------------
		if backBtn then
			backBtn:removeSelf()
			backBtn=nil
		end
        
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