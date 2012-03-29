--Modularized Version of the Pause Overlay

pauseMenu = {};

pauseMenu.switchTo = function(event)
	if event.phase == "ended" and overlay == true then
		local target = event.target;
		if target.alpha > 0 then
			if target.section == "Load" then
				--Switch to Loading Screen
				backBtn.alpha = 0;
				pauseText.alpha = 0;
				restartBtn.alpha = 0;
				exitBtn.alpha = 0;
				loadBtn.alpha = 0;
				saveBtn.alpha = 0;
				settingsBtn.alpha = 0;
				backMainBtn.alpha = 1;
				loadCBtn.alpha = 1;
				menuText.alpha = 0;
				for k = 1, 10 do
					local path = system.pathForFile( "", system.ResourceDirectory )
					local f = io.open( path.."slot"..k..".lua", "r" )
					if f ~= nil then
						slots[k].alpha = 1;
					else
						slots[k+10].alpha = 1;
					end
				end
				overlay_section = "Load";
				showInfo = false;
			end
			if target.section == "Save" then
				--Switch to Saving Screen
				backBtn.alpha = 0;
				pauseText.alpha = 0;
				restartBtn.alpha = 0;
				exitBtn.alpha = 0;
				loadBtn.alpha = 0;
				saveBtn.alpha = 0;
				settingsBtn.alpha = 0;
				backMainBtn.alpha = 1;
				overwriteBtn.alpha = 1;
				menuText.alpha = 0;
				for k = 1, 10 do
					local path = system.pathForFile( "", system.ResourceDirectory )
					local f = io.open( path.."slot"..k..".lua", "r" )
					if f ~= nil then
						slots[k].alpha = 1;
					else
						slots[k+10].alpha = 1;
					end
				end
				overlay_section = "Save";
				showInfo = false;
			end
			if target.section == "Settings" then
				local widget 	 = require( "widget" )
				widget.setTheme("theme_ios")	
				local MenuSettings = require( "settings" )
				backBtn.alpha = 0;
				pauseText.alpha = 0;
				restartBtn.alpha = 0;
				exitBtn.alpha = 0;
				loadBtn.alpha = 0;
				saveBtn.alpha = 0;
				settingsBtn.alpha = 0;
				backMainBtn.alpha = 1;
				settingsBtn.alpha = 0;
				menuText.alpha = 0;
				
				overlay_section = "Settings";

				showInfo = false;

				valueSFX = display.newText("Your Sound Effects",display.contentWidth *.50,display.contentHeight * 0.65,native.systemFont,16)  

				local sliderListener2 = function( event )
					id = "Sound Effects";
					local sliderObj2 = event.target;
					valueSFX.text=event.target.value;
					print( "New value is: " .. event.target.value )
					audio.setVolume((event.target.value/100),{channel=2})
					MenuSettings.onTestBtnRelease(event)
				end
				
				-- Create the slider widget
				mySlider2 = widget.newSlider{
					callback=sliderListener2
				}

				-- Center the slider widget on the screen:
				mySlider2.x = display.contentWidth * 0.5
				mySlider2.y = display.contentHeight * 0.6
				-- insert the slider widget into a group:
			end
			if target.section == "Main" then
				--Switch to Loading Screen
				backBtn.alpha = 1;
				pauseText.alpha = 1;
				restartBtn.alpha = 1;
				exitBtn.alpha = 1;
				loadBtn.alpha = 1;
				saveBtn.alpha = 1;
				settingsBtn.alpha = 1;
				backMainBtn.alpha = 0;
				overwriteBtn.alpha = 0;
				loadCBtn.alpha = 0;
				menuText.alpha = 0;
				for k = 1, 20 do
					slots[k].alpha = 0;
				end
				if overlay_section == "Settings" then
					mySlider2:removeSelf()
					mySlider2 = nil
					valueSFX:removeSelf()
					valueSFX=nil
				end
				overlay_section = "Main"
				
				--Destroy All Object in Overlay Group
				local num = overlayGroup.numChildren;
				while num >= 1 do
					overlayGroup:remove(num)
					num = num - 1
				end
			end
		end
	end
end

pauseMenu.displayPreview = function(slot)
	local num = overlayGroup.numChildren;
		while num >= 1 do
			overlayGroup:remove(num)
			num = num - 1
		end
	package.loaded["slot"..slot] = nil
	_G["slot"..slot] = nil
	local Play	 = require( "slot"..slot )
	local Materials = require( "materials" )
	local player = Play.structure;
	
	local str = "Slot "..slot.."\n";
	str = str.."Cost: "..player.totalCost.."\n";
	str = str.."Num of Objects: "..player.numObjects.."\n";
	
	--Show An Image of the Structure
	local max_w = 182-80; --How Much Space do We Have to Show This Image in Width
	local max_h = 100; --And Height
	local baseX = (w/2)-75+50+48+20;
	local baseY = (h/2)+68;
	--Get the Largest X and Smallest Y Offset Value
	local off_xlarge = player.x_vals[1];
	local off_ylarge = -1*player.y_vals[1];
	for i = 2,player.numObjects do
		if player.x_vals[i] > off_xlarge then
			off_xlarge = player.x_vals[i];
		end
		if (-1*player.y_vals[i]) > off_ylarge then
			off_ylarge = -1*player.y_vals[i];
		end
	end
	--Now Get the Scales
	local x_sc = 0.5; local y_sc = 0.5;
	if off_xlarge > (max_w*2) then x_sc = (max_w/off_xlarge); end
	if off_ylarge > (max_h*2) then y_sc = (max_h/off_ylarge); end
	--Now Draw the Objects
	for i = 1,player.numObjects do
		local obj = {};
		obj.type = player.types[i];
		obj = Materials.clone(obj)
		obj = display.newImage(obj.img)
		obj.type = player.types[i];
		obj = Materials.clone(obj)
		obj:scale(obj.scaleX,obj.scaleY)
		obj.rotation = player.rotations[i];
		--Figure Out the Scale Based on Its Rotation
		local r = obj.rotation
		while r > 360 do
			r = r - 360;
		end
		r = r * (math.pi/360); --Get Radians
		local s = math.abs(math.cos(r));
		local xs = (x_sc*(s))+(y_sc*(1-s));
		local ys = (x_sc*(1-s))+(y_sc*(s))
		obj:scale(xs,ys)
		
		obj.x = (player.x_vals[i]*xs)+baseX;
		obj.y = (player.y_vals[i]*ys)+baseY;
		
		overlayGroup:insert(obj);
		obj:toFront()
	end
	return str;
end

pauseMenu.confirm = function(event)
	if event.phase == "began" and (event.target).alpha > 0 and overlay_section ~= "Main" then
		showInfo = true;
		slot = (event.target).slot;
		local num = overlayGroup.numChildren;
		while num >= 1 do
			overlayGroup:remove(num)
			num = num - 1
		end
		--Get Text
		local str = "Slot "..slot.."\n";
		local f = io.open("slot"..slot..".lua","r")
		if f == nil then
			str = str.."\nNo File";
		else
			str = pauseMenu.displayPreview(slot)
		end
		menuText.text = str;
		menuText.alpha = 1;
	end
end

pauseMenu.back_to_main = function(event)
	if event.phase == "began" and backBtn.alpha > 0 then
		openView();
		--Close Overlay if Up
		if overlay == true and overlay_activity == false then
			overlay = false;
			overlay_activity = true;
			print("Here")
		end
	end
end

pauseMenu.overlay_animation = function(event)
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
				physics.pause() --Pause the Physics
				closeView();
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
				
				--Display Buttons
				backBtn.alpha = 1;
				pauseText.alpha = 1;
				restartBtn.alpha = 1;
				exitBtn.alpha = 1;
				loadBtn.alpha = 1;
				saveBtn.alpha = 1;
				settingsBtn.alpha = 1;
				
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
				
				--Remove Buttons
				backBtn.alpha = 0;
				pauseText.alpha = 0;
				restartBtn.alpha = 0;
				exitBtn.alpha = 0;
				loadBtn.alpha = 0;
				saveBtn.alpha = 0;
				settingsBtn.alpha = 0;
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
				successTime = 1;
				once = false;
				overlayrect:scale((1/r_scale),(1/r_scale));
				physics.start() --Restart the Physics
			end	
		end
	else
		once = false;
	end
end
--Runtime Listener at Bottom of enterScene

pauseMenu.createOverlay = function(group)
	--Set Up the Width and Height Variables
		w = display.contentWidth; h = display.contentHeight;
		--Overlay Animation Variables
		anim_time = 15; --How Much Time Spent for Overlay Animation (Both Ways)
		now_time = 0; --The Current Time for the Current Animation
		b = 25; iw = 96*(2/3);
		r_alpha = 0; --Overlay's Starting Alpha Value
		s_alpha = 0.7; --Shade Final Alpha Value
		r_scale = 0.75; --Overlay's Starting Scale
		nr_scale = r_scale; --Overlay's Current Scale
		once = false; --Preliminary Things Before Animating
		r_w = (5*iw)+(2*b); --Length of the Overlay Rectangle
		r_h = 256; --Height of the Overlay Rectangle
		overlay_section = "Main"; --Which Section of the Overlay are We In?
		showInfo = false; --Showing Some Text?
		slot = 0;
		
		--Make the Overlay Rectangle
		overlayshade = display.newRect(-w,0,w*3,h); --The Shady Part of the Screen
		overlayshade:setFillColor(0,0,0); overlayshade.alpha = 0;
		overlayrect = display.newImageRect("../images/overlay_grey.png",r_w,r_h);
		overlayrect.alpha = 0; overlayrect.x = (w/2); overlayrect.y = (h/2);
		overlayGroup = display.newGroup();
		
		--Buttons
		pauseText = display.newText("PAUSE",(w/2)-55,(h/2)-(r_h/2),"Arial Black",30);
		backBtn= display.newImage("../images/btn_back.png");
		backBtn.x = (w/2); backBtn.y = (h/2)+(r_h/2)-30;
		restartBtn = display.newImage("../images/btn_restart_level.png");
		restartBtn.x = (w/2); restartBtn.y = (h/2)+(r_h/2)-110;
		exitBtn = display.newImage("../images/btn_exit_level.png");
		exitBtn.x = (w/2); exitBtn.y = (h/2)+(r_h/2)-70;
		loadBtn = display.newImage("../images/btn_load.png");
		loadBtn.x = (w/2); loadBtn.y = (h/2)+(r_h/2)-150; loadBtn.section = "Load";
		saveBtn = display.newImage("../images/btn_save.png");
		saveBtn.x = (w/2); saveBtn.y = (h/2)+(r_h/2)-190; saveBtn.section = "Save";
		settingsBtn = display.newImage("../images/btn_gear.png");
		settingsBtn.x = (w/2)+150; settingsBtn.y = (h/2)+(r_h/2)-35; settingsBtn.section = "Settings";
		
		--Slots
		slots = {};
		for k = 1, 20 do
			if k <= 10 then
				slots[k] = display.newImage("../images/btn_slot"..k..".png");
				if k <= 5 then
					slots[k].x = (w/2)-75-50;
					slots[k].y = (h/2)-(r_h/2)+(k*40);
				else
					slots[k].x = (w/2)-75+50;
					slots[k].y = (h/2)-(r_h/2)+((k-5)*40);
				end
				slots[k].alpha = 0;
				slots[k].movy = "Yes";
				slots[k].slot = k;
			else
				slots[k] = display.newImage("../images/btn_nosave.png");
				if k <= 15 then
					slots[k].x = (w/2)-75-50;
					slots[k].y = (h/2)-(r_h/2)+((k-10)*40);
				else
					slots[k].x = (w/2)-75+50;
					slots[k].y = (h/2)-(r_h/2)+((k-15)*40);
				end
				slots[k].alpha = 0;
				slots[k].movy = "Yes";
				slots[k].slot = (k-10);
			end
		end
		backMainBtn = display.newImage("../images/btn_back.png");
		backMainBtn.x = (w/2)-75; backMainBtn.y = (h/2)-(r_h/2)+(6*40)-5; backMainBtn.alpha = 0; backMainBtn.section = "Main";
		overwriteBtn = display.newImage("../images/btn_overwrite.png");
		overwriteBtn.x = (w/2)+75+20; overwriteBtn.y = (h/2)-(r_h/2)+(6*40)-5;
		loadCBtn = display.newImage("../images/btn_loadconfirm.png");
		loadCBtn.x = (w/2)+75+20; loadCBtn.y = (h/2)-(r_h/2)+(6*40)-5;
		menuText = display.newText("Stuff",0,0,native.systemFont,12);
		menuText.x = (w/2)+75; menuText.y = (h/2)-80;
		
		backBtn.alpha = 0;
		pauseText.alpha = 0;
		restartBtn.alpha = 0;
		exitBtn.alpha = 0;
		loadBtn.alpha = 0;
		saveBtn.alpha = 0;
		overwriteBtn.alpha = 0;
		loadCBtn.alpha = 0;
		menuText.alpha = 0;
		settingsBtn.alpha = 0;
		
		overlayshade.movy = "Yes"; overlayrect.movy = "Yes"; saveBtn.movy = "Yes"; loadBtn.movy = "Yes"; backMainBtn.movy = "Yes";
		pauseText.movy = "Yes"; backBtn.movy = "Yes"; restartBtn.movy = "Yes"; exitBtn.movy = "Yes"; overwriteBtn.movy = "Yes"
		loadCBtn.movy = "Yes"; menuText.movy = "Yes"; settingsBtn.movy = "Yes";
		
		group:insert(overlayshade)
		group:insert(overlayrect)
		group:insert(backBtn)
		group:insert(pauseText);
		group:insert(restartBtn);
		group:insert(exitBtn);
		group:insert(loadBtn);
		group:insert(saveBtn);
		group:insert(backMainBtn);
		group:insert(overwriteBtn);
		group:insert(settingsBtn);
		group:insert(loadCBtn);
		group:insert(menuText);
		for k = 1, 20 do
			group:insert(slots[k]);
		end
		
		backMainBtn:addEventListener("touch",pauseMenu.switchTo);
		loadBtn:addEventListener("touch",pauseMenu.switchTo);
		saveBtn:addEventListener("touch",pauseMenu.switchTo);
		settingsBtn:addEventListener("touch",pauseMenu.switchTo)
		backBtn:addEventListener("touch",pauseMenu.back_to_main);
		for k = 1, 20 do
			slots[k]:addEventListener("touch",pauseMenu.confirm);
		end
		
		Runtime:addEventListener("enterFrame",pauseMenu.overlay_animation);
		
		return group;
end

pauseMenu.assertDepth = function(group)
	group:insert(overlayshade)
	group:insert(overlayrect)
	group:insert(backBtn)
	group:insert(pauseText);
	group:insert(restartBtn);
	group:insert(exitBtn);
	group:insert(loadBtn);
	group:insert(saveBtn);
	group:insert(backMainBtn);
	group:insert(overwriteBtn);
	group:insert(settingsBtn);
	group:insert(loadCBtn);
	group:insert(menuText);
	for k = 1, 20 do
		group:insert(slots[k]);
	end
	return group;
end

pauseMenu.nilEverything = function()

	--[[Delete Anything that Isn't Already Gone
	display.remove(overlayshade); display.remove(overlayrect);
	display.remove(backBtn); display.remove(pauseText); display.remove(restartBtn);
	display.remove(exitBtn); display.remove(loadBtn); display.remove(saveBtn);
	display.remove(backMainBtn); display.remove(overwriteBtn); display.remove(settingsBtn);
	display.remove(loadCBtn); display.remove(menuText);--]]
	
	--Nil the Variables
	overlayshade = nil; overlayrect = nil; backBtn = nil; pauseText = nil; restartBtn = nil;
	exitBtn = nil; loadBtn = nil; saveBtn = nil; backMainBtn = nil; overwriteBtn = nil; settingsBtn = nil;
	loadCBtn = nil; menuText = nil;
	
	for k = 1, 20 do
		--display.remove(slots[k]);
		slots[k] = nil;
	end
	
	w = nil; h = nil;
	anim_time = nil; --How Much Time Spent for Overlay Animation (Both Ways)
	now_time = nil; --The Current Time for the Current Animation
	b = nil; iw = nil;
	r_alpha = nil; --Overlay's Starting Alpha Value
	s_alpha = nil; --Shade Final Alpha Value
	r_scale = nil; --Overlay's Starting Scale
	nr_scale = nil; --Overlay's Current Scale
	once = nil; --Preliminary Things Before Animating
	r_w = nil; --Length of the Overlay Rectangle
	r_h = nil; --Height of the Overlay Rectangle
	overlay_section = nil; --Which Section of the Overlay are We In?
	showInfo = nil; --Showing Some Text?
	slot = nil;
	
	Runtime:removeEventListener("enterFrame",pauseMenu.overlay_animation);
	
	collectgarbage()
end

--Load the Enemy Base
pauseMenu.loadLevel = function()
	local Enemies = require( "enemybase" )
	local Materials = require( "materials" )
	local enemy = Enemies.level1
	objGroup = display.newGroup()
	for i=1,enemy.numObjects do
		local obj = {}
		local baseX = enemy.baseX;
		local baseY = enemy.baseY;
		obj.type = enemy.types[i]
		-- first clone: so obj.img refers to proper image
		-- second clone: to pass data to object
		obj = Materials.clone(obj)
		obj = display.newImage(obj.img)
		obj = Materials.clone(obj)
		obj:scale(obj.scaleX,obj.scaleY)
		obj.x = enemy.x_vals[i]+baseX;
		obj.y = enemy.y_vals[i]+baseY;
		obj.rotation = enemy.rotations[i]
		physics.addBody(obj, {density=obj.density,friction=obj.friction,bounce=obj.bounce,shape=obj.shape} )
		objGroup:insert(obj)
		obj:addEventListener("postCollision",hit);
	end
	return objGroup
end

return pauseMenu;