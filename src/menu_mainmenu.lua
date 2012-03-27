local storyboard = require( "storyboard" )
local widget = require( "widget" )
local scene = storyboard.newScene()
 
----------------------------------------------------------------------------------
--      NOTE:
--      Code outside of listener functions (below) will only be executed once,
--      unless storyboard.removeScene() is called.
---------------------------------------------------------------------------------
local spBtn
local mpBtn
local settingsBtn
local aboutBtn

local function onBtnRelease(event)
	-- t refers to which button you clicked
	-- label is the "id" field of that button
	local t = event.target
	local label = t.id
	print("released button " .. label)
	storyboard.gotoScene( label, "zoomInOutFade", 250)
	return true
end
--fade and 200 before 
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
		
		local active = true;
		
		--Define the Position Variables
		local cW = display.contentWidth/2; --Half the Width of the Screen
		--local pW = display.contentWidth-150;
		pW = cW;
		local cH = display.contentHeight+25; --Half the Height of the Screen
		local pH = 50;
		local w = display.contentWidth; --The Width of the Screen
		local h = display.contentHeight;
		
		--Create the Backgrounds
		local space1 = display.newImage( "../images/space.png")
		local space2 = display.newImage("../images/space.png")
		
		space1.x = 0
		space1.y = h/2
		space2.x = -w*2
		space2.y = h/2
		
		--Set Up the Logo
		local pH = 50+40;
		local logo = display.newImage("../images/logo2.png");
		logo.x = cW; logo.y = h/6; logo.alpha = 0.75;
		
		local up = true; --Which Direction is the Logo Bouncing?
		local bounce_limit = 10; --How Far Can the Logo Bounce?
		local moving = 1; --How Fast Should the Logo Bounce?
        
        -----------------------------------------------------------------------------
        --      INSERT code here (e.g. start timers, load audio, start listeners, etc.)
		-----------------------------------------------------------------------------
		spBtn = widget.newButton{
			id="menu_sp_main",
			label="Single Player",
			labelColor = { default={255}, over={128} },
			default="../images/buttonInActive.png",
			over="../images/buttonActive.png",
			width=96, height=96,
			onRelease = onBtnRelease
		}		
		mpBtn = widget.newButton{
			id="menu_mp_main",
			label="Multiplayer",
			labelColor = { default={255}, over={128} },
			default="../images/buttonInActive.png",
			over="../images/buttonActive.png",
			width=96, height=96,
			onRelease = onBtnRelease
		}		
		settingsBtn = widget.newButton{
			id="menu_settings",
			label="Settings",
			labelColor = { default={255}, over={128} },
			default="../images/buttonInActive.png",
			over="../images/buttonActive.png",
			width=96, height=96,
			onRelease = onBtnRelease
		}        
		aboutBtn = widget.newButton{
			id="menu_about",
			label="About Us",
			labelColor = { default={255}, over={128} },
			default="../images/buttonInActive.png",
			over="../images/buttonActive.png",
			width=96, height=96,
			onRelease = onBtnRelease
		}
		
		--Single Player Button
		spBtn.view:setReferencePoint( display.CenterReferencePoint )
		spBtn.view.x = pW
		spBtn.view.y = cH-115
		spBtn.view.alpha = 0.01; --Only Visible One
		
		--Multi-Player Button
		mpBtn.view:setReferencePoint( display.CenterReferencePoint )
		mpBtn.view.x = pW
		mpBtn.view.y = cH-115
		mpBtn.view.alpha = 0
		
		--Settings Button
		settingsBtn.view:setReferencePoint( display.CenterReferencePoint )
		settingsBtn.view.x = pW
		settingsBtn.view.y = cH-115
		settingsBtn.view.alpha = 0
		
		--About Us Button
		aboutBtn.view:setReferencePoint( display.CenterReferencePoint )
		aboutBtn.view.x = pW
		aboutBtn.view.y = cH-115
		aboutBtn.view.alpha = 0
		
		--Here Are the Runtime Functions for the Main Menu
		-- Push the Logo Up and Down
		bouncyLogo = function(event)		
			--If the Scene is Ready...
			if active == true then
				--Is the Logo Moving Up or Down?
				if up == true then
					--Move the Logo Up by the Specified Speed
					logo.y = logo.y - moving;
					--If the Logo is Past it's Limit, Make It Start Going the Other Direction
					if logo.y <= (pH-bounce_limit) then
						logo.y = (pH-bounce_limit)
						up = false;
					end
				else
				--If the Logo is Moving Down...
					--Move the Logo Down by the Specified Speed
					logo.y = logo.y + moving;
					--If the Logo is Past it's Limit, Make It Start Going the Other Direction
					if logo.y >= (pH+bounce_limit) then
						logo.y = (pH+bounce_limit)
						up = true;
					end
				end				
			end		
		end
		--Move the Space Background
		moveSpace = function(event)
			--Check to See if Any of the Backgrounds Have Moved Past a Certain Point
			if space1.x >= 2*w then
				space1.x = -2*w
			end
			if space2.x >= 2*w then
				space2.x = -2*w
			end
			--Increment the Backgrounds' X Position
			space1.x = space1.x + 1
			space2.x = space2.x + 1
		end
		
		--Nyan Cat
		local n = {}; --Load All the Sprites in an Array
		n[1] = "../images/background_nyancat1.png";
		n[2] = "../images/background_nyancat2.png";
		n[3] = "../images/background_nyancat3.png";
		n[4] = "../images/background_nyancat4.png";
		n[5] = "../images/background_nyancat5.png";
		n[6] = "../images/background_nyancat6.png";
		local timer = 15; --Time Before Moving to the Next Image
		local current = 1; --Current Image
		local nyan = display.newImage(group,"../images/background_nyancat1.png"); --Load the Image Itself
		local nx = -70; --Nyan Cat's X Coordinate
		nyan.x = nx; nyan.y = 50; nyan:scale(0.1,0.1); --Placing and Scaling Nyan Cat
		nyancat = function(event)
		
			--Countdown
			timer = timer - 1;
			--When the Timer Gets to Zero...
			if timer <= 0 then
				timer = 15; --Reset the Timer and...
				current = current + 1; --Go to the Next Image
				if current > 6 then current = 1 end --If current is Past the Last Image, Reset
				
				--Remove Nyan Cat so the New Image Can Be Updated
				nyan:removeSelf();
				--And Remake It with the New Image
				nyan = display.newImage(group,n[current])
				nyan:scale(0.1,0.1)
			end
			
			--Move Nyan Cat
			nx = nx + 1;
			
			--Update Nyan Cat's Position
			nyan.x = nx; nyan.y = 50;
			
			--Check Nyan Cat's Position, If It's Past the Width of the Screen, Put It Back on the Left Side
			if nx >= (display.contentWidth+100) then nx = -100 end
			--if active == false then nyan.alpha = 0 end
			
			--Make Sure the Logo is Always on Top
			group:insert(logo)
		
		end
		
		--The Earth and the Wooden Signs
		local SPsign = display.newImage("../images/sign_sp2.png") --The Single Player Sign
		local MPsign = display.newImage("../images/sign_mp2.png") --The Multi-Player Sign
		local settings_Sign = display.newImage("../images/sign_settings2.png") --The Settings Sign
		local help_Sign = display.newImage("../images/sign_about.png") --The Help Sign
		local earth = display.newImage("../images/earth.png") --The Earth
		
		local right_arrow = display.newImage("../images/background_rightarrow.png"); --The Right Arrow; for Clockwise
		local left_arrow = display.newImage("../images/background_leftarrow.png"); --The Left Arrow; for Counterclockwise
		
		--Adjust the Positions and the Rotations
		SPsign.x = pW; SPsign.y = cH-150;					
		MPsign.y = cH; MPsign.x = pW+150; MPsign:rotate(90)
		settings_Sign.x = pW; settings_Sign.y = cH+150; settings_Sign:rotate(180)
		help_Sign.y = cH; help_Sign.x = pW-150; help_Sign:rotate(270)
		earth.x = pW; earth.y = cH;
		
		right_arrow.x = pW+(cW/2); right_arrow.y = (cH-115)+5; right_arrow:scale(0.25,0.25); right_arrow:rotate(45); right_arrow.alpha = 1;
		left_arrow.x = pW-(cW/2); left_arrow.y = (cH-115)+5; left_arrow:scale(0.25,0.25); left_arrow:rotate(-45); left_arrow.alpha = 1;
		
		--Sign Angles; 270 Degrees Means It's On Top
		local SPangle = 0+270;
		local MPangle = 90+270;
		local setangle = 180+270;
		local helpangle = 270+270;
		
		--Since the Other Signs Are Not on Top, Scale Them Down
		MPsign:scale(0.5,0.5)
		settings_Sign:scale(0.5,0.5)
		help_Sign:scale(0.5,0.5)
		
		local turning = false; --Is the World Turning Now?
		local fade = 1; local down_fade = 0.3; --How Fast do the Arrow Fade?
		local increment = 0.1; local r = 115; local distance = 0; local inc = 0;
		local SPr = 0; local MPr = 0; local setr = 0; local helpr = 0;
		
		--Rotation of the Earth
		--Is it Rotating by Moving your Finger?
		rotateStuff = function(event)
			--Once the Event Has Ended, the World Isn't Already Turning, and the Scene is Ready
			if event.phase == "ended" and turning == false and active == true then
				--Find Out How Far the Finger Swipe Was
				local distance = math.sqrt( (event.x-event.xStart)^2 + (event.y-event.yStart)^2 )
				--If It's Far Enough
				if distance >= 25 then
					--Figure Out Which Direction We Should Go
					-- Rotate Clockwise if the Final X is Past the Start
					if event.x > event.xStart then
						increment = 90 --Positive Number Means Clockwise
						turning = true;						
					-- Rotate Counterclockwise
					else
						increment = -90 --Negative Number Means CounterClockwise
						turning = true;						
					end					
					--Scale Down the Top Most Sign
					if SPangle == 270 then SPsign:scale(0.5,0.5) end
					if MPangle == 270 then MPsign:scale(0.5,0.5) end
					if setangle == 270 then settings_Sign:scale(0.5,0.5) end
					if helpangle == 270 then help_Sign:scale(0.5,0.5) end
					--Set the Fade of the Arrows
					fade = 1;						
				end
			end		
		end
		--Is it Rotating by Tapping the Arrows?
		rotateTap = function(event)
			--When the Event Starts, the World Isn't Already Turning, and the Scene is Ready
			if event.phase == "began" and turning == false and active == true then
					--Figure Out Which Arrow Was Tapped
					-- Rotate Clockwise; the Right Arrow Was Tapped
					if event.x > cW then
						increment = 90 --Positive Number Means Clockwise
						turning = true;						
					-- Rotate Counterclockwise; the Left Arrow was Tapped
					else
						increment = -90 --Negative Num
						turning = true;						
					end
					--Scale Down the Top Most Sign
					if SPangle == 270 then SPsign:scale(0.5,0.5) end
					if MPangle == 270 then MPsign:scale(0.5,0.5) end
					if setangle == 270 then settings_Sign:scale(0.5,0.5) end
					if helpangle == 270 then help_Sign:scale(0.5,0.5) end
					--Set Up the Fade of the Arrows
					fade = 1;						
			end			
		end
		--Do the Animation for Rotating!
		rotateAnimation = function(event)
			--Are We Rotating?
			if turning == true then
				--Control the Visibility of the Arrows
				right_arrow.alpha = fade;
				left_arrow.alpha = fade;
				--Slowly Let the Arrows Disappear
				if fade > 0 then
					fade = fade - down_fade;
					if fade <= 0 then fade = 0 end
				end
				--How Fast Do We Turn It?
				inc = 10;
				--Let's Adjust How Many More Degrees We Need to Go
				if increment > 0 then
					increment = increment - inc;
				else
					increment = increment + inc;
					inc = inc * -1; --Going Counterclockwise
				end
				--Rotate Everything
				SPsign:rotate(inc)
				MPsign:rotate(inc)
				settings_Sign:rotate(inc)
				help_Sign:rotate(inc)
				earth:rotate(inc)
				--Adjust the Angle Variables
				SPangle = SPangle + inc;
				MPangle = MPangle + inc;
				setangle = setangle + inc;
				helpangle = helpangle + inc;
				--Make Sure the Angle Variables Stay in the Range of [0,360]
				if SPangle >= 360 then SPangle = SPangle - 360 end
				if MPangle >= 360 then MPangle = MPangle - 360 end
				if setangle >= 360 then setangle = setangle - 360 end
				if helpangle >= 360 then helpangle = helpangle - 360 end
				if SPangle < 0 then SPangle = SPangle + 360 end
				if MPangle < 0 then MPangle = MPangle + 360 end
				if setangle < 0 then setangle = setangle + 360 end
				if helpangle < 0 then helpangle = helpangle + 360 end				
				-- Adjust x and y
				--Get the Radians from All the Angle Variables and Use Polar Coordinates to Adjust the Positions
				SPr = SPangle*(math.pi/180);
				SPsign.x = (r*math.cos(SPr))+(pW); SPsign.y = (r*math.sin(SPr))+cH-35;
				MPr = MPangle*(math.pi/180);
				MPsign.x = (r*math.cos(MPr))+(pW); MPsign.y = (r*math.sin(MPr))+cH-35;
				setr = setangle*(math.pi/180);
				settings_Sign.x = (r*math.cos(setr))+(pW); settings_Sign.y = (r*math.sin(setr))+cH-35;
				helpr = helpangle*(math.pi/180);
				help_Sign.x = (r*math.cos(helpr))+(pW); help_Sign.y = (r*math.sin(helpr))+cH-35;
				--Are We Done?
				if increment == 0 then
					turning = false --Stop Turning
					--Adjust the Button's Visiblity
					spBtn.view.alpha = 0; mpBtn.view.alpha = 0; settingsBtn.view.alpha = 0; aboutBtn.view.alpha = 0;
					--Check To See Which Sign Is On Top
					if SPangle == 270 then SPsign:scale(2,2); spBtn.view.alpha = 0.01; end
					if MPangle == 270 then MPsign:scale(2,2); mpBtn.view.alpha = 0.01; end
					if setangle == 270 then settings_Sign:scale(2,2); settingsBtn.view.alpha = 0.01; end
					if helpangle == 270 then help_Sign:scale(2,2); aboutBtn.view.alpha = 0.01; end
				end				
			else
				--Redo It's Visibility
				right_arrow.alpha = fade;
				left_arrow.alpha = fade;
				--Increase the Visibility If It's Not Fully Visible
				if fade < 1 then
					fade = fade + down_fade
					if fade >= 1 then fade = 1 end
				end
			end	
		end
		
		--UFO and It's Help Menu
		local UFO = display.newImage("../images/background_UFO.png")
		UFO.x = cW-180; UFO.y = (display.contentHeight/2)+((cH-145)*0); UFO:scale(0.75,0.75); --Position and Scale the UFO
		local UFO_bottom = ((96*0.75)/2)+UFO.y-20; --The Position Where the Lasers Will Come Out of
		
		--UFO Wobbly Variables
		local UFOangle = 0;
		local wobble_way = true;
		
		-- Wobble the UFO
		wobble = function(event)
			--Which Direction Is It Turning
			if wobble_way == true then
				--Rotate Clockwise
				UFOangle = UFOangle + 3;
				--Past 30 Degrees? Rotate the Other Way
				if UFOangle >= 30 then wobble_way = false end
				UFO:rotate(3)
			else
				--Rotate Counterclockwise
				UFOangle = UFOangle - 3;
				--Past -30 Degrees? Rotate the Other Way
				if UFOangle <= -30 then wobble_way = true end
				UFO:rotate(-3)
			end		
		end
		
		-- Box Variables
		local width = 100; local height = 60; --Height and Width of Rectangle
		local yStart1 = cH-100; local yStart2 = yStart1+height; --Top and Bottom Positions
		local xStart1 = -30; local xStart2 = xStart1+width; --Left and Right Positions
		local move_speed = 3; --Speed of the Lasers
		local sx1 = xStart1; local ex1 = xStart1+(height); --Start and End Xs for First Line
		local sx2 = xStart2; local ex2 = xStart2-(height); --Start and End Xs for Second Line
		local sy1 = yStart1; local ey1 = yStart1; --Start and End Ys for First Line
		local sy2 = yStart2; local ey2 = yStart2; --Start and End Ys for Second Line
		
		--Directions for the Lines
		local S1 = "left"; local E1 = "left"; local S2 = "right"; local E2 = "right";
		
		--Make the Lines
		line1 = display.newLine(0,0,0,0);
		line2 = display.newLine(0,0,0,0);
		line3 = display.newLine(0,0,0,0);
		line4 = display.newLine(0,0,0,0);
		aline1 = display.newLine(45,0,0,0);
		aline2 = display.newLine(45,0,0,0);
		
		--Set the Colors
		line1:setColor(0,255,0); line1.width = 3; line1.alpha = 0;
		line2:setColor(0,255,0); line2.width = 3; line2.alpha = 0;
		line3:setColor(0,255,0); line3.width = 3; line3.alpha = 0;
		line4:setColor(0,255,0); line4.width = 3; line4.alpha = 0;
		aline1:setColor(0,255,0); aline1.width = 3; aline1.alpha = 0;
		aline2:setColor(0,255,0); aline2.width = 3; aline2.alpha = 0;
		
		--Make the Help Text
		local helpText = display.newText("Protect or Conquer the World in the Single Player Campaign!",xStart1+2,yStart1+2,(2*(width-2)),(2*(height-2)),native.systemFont,24);
		helpText.alpha = 1; helpText.x = xStart1+(width/2)+2; helpText.y = yStart1+(height/2)+2;
            helpText:scale(.5,.5)
		
		-- Show the Help and Move Them Lasers
		help = function(event)
			--Is the Scene Ready?
			if active == true then		
				-- Draw Them Lines				
				-- Remove All Lines Right Now
				--[[
				line1:removeSelf(); line2:removeSelf();
				line3:removeSelf(); line4:removeSelf();
				aline1:removeSelf(); aline2:removeSelf();--]]
			    display.remove(line1); display.remove(line2);
				display.remove(line3); display.remove(line4);
				display.remove(aline1); display.remove(aline2);
				-- Follow the First Two Points (Start of First Line)
				--Figure Out Which Direction it's Going, and Adjust It
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
				-- S2 (Start of Second Line)
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
				-- E1 (End of First Line)
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
				-- E2 (End of Second Line)
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
				-- Assign values (Recreate the Lines With the New Positions)
				--First Line
				if S1 == "down" or S1 == "left" then
					if sx1 >= (xStart2-height) then
						line1 = display.newLine(group,sx1,yStart1,ex1,yStart1);
						line3 = display.newLine(group,xStart2,sy1,xStart2,sy1+(sx1-(xStart2-height)));
					else
						line1 = display.newLine(group,sx1,yStart1,ex1,yStart1);
						line3 = display.newLine(group,xStart1,sy1,xStart1,yStart1);
					end
				else
					if sx1 <= (xStart1+height) then
						line1 = display.newLine(group,sx1,yStart2,ex1,yStart2);
						line3 = display.newLine(group,xStart1,sy1,xStart1,sy1-((xStart1+height)-sx1));
					else
						line1 = display.newLine(group,sx1,yStart2,ex1,yStart2);
						line3 = display.newLine(group,xStart2,sy1,xStart2,yStart2);
					end
				end
				--Second Line
				if S2 == "down" or S2 == "left" then
					if sx2 >= (xStart2-height) then
						line2 = display.newLine(group,sx2,yStart1,ex2,yStart1);
						line4 = display.newLine(group,xStart2,sy2,xStart2,sy2+(sx2-(xStart2-height)));
					else
						line2 = display.newLine(group,sx2,yStart1,ex2,yStart1);
						line4 = display.newLine(group,xStart1,sy2,xStart1,yStart1);
					end
				else
					if sx2 <= (xStart1+height) then
						line2 = display.newLine(group,sx2,yStart2,ex2,yStart2);
						line4 = display.newLine(group,xStart1,sy2,xStart1,sy2-((xStart1+height)-sx2));
					else
						line2 = display.newLine(group,sx2,yStart2,ex2,yStart2);
						line4 = display.newLine(group,xStart2,sy2,xStart2,yStart2);
					end
				end
				--Lines that Comes from the UFO
				aline1 = display.newLine(group,UFO.x,UFO_bottom,sx1,sy1);
				aline2 = display.newLine(group,UFO.x,UFO_bottom,sx2,sy2);
				--Adjust the Colors and the Width
				line1:setColor(0,255,0); line1.width = 3;
				line2:setColor(0,255,0); line2.width = 3;
				line3:setColor(0,255,0); line3.width = 3;
				line4:setColor(0,255,0); line4.width = 3;
				aline1:setColor(0,255,0); aline1.width = 3; aline1.alpha = 0.5;
				aline2:setColor(0,255,0); aline2.width = 3; aline2.alpha = 0.5;				
				-- Ensure UFO is On Top
				group:insert(UFO)				
				-- Display Text Based on Which Sign Is On Top
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
		end
		
		
		--Add the Runtime Listeners
		Runtime:addEventListener("enterFrame",bouncyLogo)
		Runtime:addEventListener("enterFrame",moveSpace)
		Runtime:addEventListener("enterFrame",nyancat);
		Runtime:addEventListener("enterFrame",wobble)
		Runtime:addEventListener("enterFrame",rotateAnimation);
		Runtime:addEventListener("enterFrame",help)
		
		--Add the Object Listeners
		space1:addEventListener("touch",rotateStuff);
		space2:addEventListener("touch",rotateStuff);
		right_arrow:addEventListener("touch",rotateTap);
		left_arrow:addEventListener("touch",rotateTap);
		
		--Insert Objects Into the Group
		group:insert(space1)
		group:insert(space2)
		group:insert(logo)
		group:insert(UFO)
		group:insert(SPsign)
		group:insert(MPsign)
		group:insert(settings_Sign)
		group:insert(help_Sign)
		group:insert(helpText)
		--group:insert(RepLogo)
		group:insert(earth)
		group:insert(left_arrow)
		group:insert(right_arrow)
		group:insert(spBtn.view)
		group:insert(mpBtn.view)
		group:insert(settingsBtn.view)
		group:insert(aboutBtn.view)
		
end
 
 
-- Called when scene is about to move offscreen:
function scene:exitScene( event )
        local group = self.view
        
        -----------------------------------------------------------------------------
        --      INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
        -----------------------------------------------------------------------------
		
		--Remove All the Runtime Listener
		Runtime:removeEventListener("enterFrame",bouncyLogo)
		Runtime:removeEventListener("enterFrame",moveSpace)
		Runtime:removeEventListener("enterFrame",nyancat)
		Runtime:removeEventListener("enterFrame",wobble)
		Runtime:removeEventListener("enterFrame",rotateAnimation);
		Runtime:removeEventListener("enterFrame",help)
		
		--[[Remove Object Listeners
		space1:removeEventListener("touch",rotateStuff);
		space2:removeEventListener("touch",rotateStuff);
		right_arrow:removeEventListener("touch",rotateTap);
		left_arrow:removeEventListener("touch",rotateTap);--]]
		
		local num = group.numChildren;
		while num >= 1 do
			group:remove(num)
			num = num - 1
		end
		
		pW = nil;
		--Remove Functions
		bouncyLogo = nil;
		moveSpace = nil;
		nyancat = nil;
		rotateStuff = nil;
		rotateTap = nil;
		rotateAnimation = nil;
		wobble = nil;
		help = nil;
		
		line1 = nil; line2 = nil; line3 = nil; line4 = nil;
		aline1 = nil; aline2 = nil;
        
end
 
 
-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
        local group = self.view
        
        -----------------------------------------------------------------------------
        --      INSERT code here (e.g. remove listeners, widgets, save state, etc.)
        -----------------------------------------------------------------------------
        if spBtn then
			spBtn:removeSelf()	-- widgets must be manually removed
			spBtn=nil
        end
		if mpBtn then
			mpBtn:removeSelf()
			mpBtn=nil
		end
		if settingsBtn then
			settingsBtn:removeSelf()
			settingsBtn=nil
		end
		if aboutBtn then
			aboutBtn:removeSelf()
			aboutBtn=nil
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