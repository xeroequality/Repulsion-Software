--Modularized Version of the Pause Overlay

pauseMenu = {
	bigGroup = display.newGroup(),
	overlayGroup = nil,
	unitGroup = nil,
	backBtn = nil,
	pauseText = nil,
	restartBtn = nil,
	exitBtn = nil,
	loadBtn = nil,
	saveBtn = nil,
	settingsBtn = nil,
	backMainBtn = nil,
	menuText = nil,
	loadCBtn = nil,
	overwriteBtn = nil,
	overlay_section = nil,
	overlayshade = nil,
	overlayrect = nil,
	showInfo = nil,
	valueVol = nil,
	valueSFX = nil,
	params = {
		anim_time = 15, 		--How Much Time Spent for Overlay Animation (Both Ways)
		now_time = 0, 			--The Current Time for the Current Animation
		b = 25,
		iw = 96*(2/3),
		r_alpha = 0, 			--Overlay's Starting Alpha Value
		s_alpha = 0.7, 			--Shade Final Alpha Value
		r_scale = 0.75, 		--Overlay's Starting Scale
		nr_scale = 0.75,
		once = false, 			--Preliminary Things Before Animating
		r_w = (5*96*(2/3))+(2*25), 	--Length of the Overlay Rectangle
		r_h = 256, 				--Height of the Overlay Rectangle
		slot = 0
	},
}

pauseMenu.switchTo = function(event)
	if event.phase == "ended" and overlay == true then
		local target = event.target;
		if target.alpha > 0 then
			if target.section == "Load" then
				--Switch to Loading Screen
				pauseMenu.backBtn.alpha = 0;
				pauseMenu.pauseText.alpha = 0;
				pauseMenu.restartBtn.alpha = 0;
				pauseMenu.exitBtn.alpha = 0;
				pauseMenu.loadBtn.alpha = 0;
				pauseMenu.saveBtn.alpha = 0;
				pauseMenu.settingsBtn.alpha = 0;
				pauseMenu.backMainBtn.alpha = 1;
				pauseMenu.loadCBtn.alpha = 1;
				pauseMenu.menuText.alpha = 0;
				local total = 0;
				for k = 1, 10 do
					local path = system.pathForFile( "", system.ResourceDirectory )
					local f = io.open( path.."slot"..k..".lua", "r" )
					if f ~= nil then
						slots[k].alpha = 1;
						total = total + 1;
					else
						slots[k+10].alpha = 1;
					end
				end
				Achievements.replace("slotsUsed",total);
				pauseMenu.overlay_section = "Load";
				pauseMenu.showInfo = false;
			end
			if target.section == "Save" then
				--Switch to Saving Screen
				pauseMenu.backBtn.alpha = 0;
				pauseMenu.pauseText.alpha = 0;
				pauseMenu.restartBtn.alpha = 0;
				pauseMenu.exitBtn.alpha = 0;
				pauseMenu.loadBtn.alpha = 0;
				pauseMenu.saveBtn.alpha = 0;
				pauseMenu.settingsBtn.alpha = 0;
				pauseMenu.backMainBtn.alpha = 1;
				pauseMenu.overwriteBtn.alpha = 1;
				pauseMenu.menuText.alpha = 0;
				local total = 0;
				for k = 1, 10 do
					local path = system.pathForFile( "", system.ResourceDirectory )
					local f = io.open( path.."slot"..k..".lua", "r" )
					if f ~= nil then
						slots[k].alpha = 1;
						total = total + 1;
					else
						slots[k+10].alpha = 1;
					end
				end
				Achievements.replace("slotsUsed",total);
				pauseMenu.overlay_section = "Save";
				pauseMenu.showInfo = false;
			end
			if target.section == "Settings" then
				local widget 	 = require( "widget" )
				widget.setTheme("theme_ios")	
				local MenuSettings = require( "settings" )
				pauseMenu.backBtn.alpha = 0;
				pauseMenu.pauseText.alpha = 0;
				pauseMenu.restartBtn.alpha = 0;
				pauseMenu.exitBtn.alpha = 0;
				pauseMenu.loadBtn.alpha = 0;
				pauseMenu.saveBtn.alpha = 0;
				pauseMenu.settingsBtn.alpha = 0;
				pauseMenu.backMainBtn.alpha = 1;
				pauseMenu.settingsBtn.alpha = 0;
				pauseMenu.menuText.alpha = 0;
				
				pauseMenu.overlay_section = "Settings";

				pauseMenu.showInfo = false;
				
				pauseMenu.valueVol = display.newText("Your Volume",display.contentWidth *.55,display.contentHeight * 0.25,native.systemFont,16)
				pauseMenu.bigGroup:insert(pauseMenu.valueVol)

		        local sliderListener1 = function( event )
		            id = "Volume";
		            local sliderObj1 = event.target;
		            pauseMenu.valueVol.text=event.target.value;
		            print( "New value is: " .. event.target.value )
		            audio.setVolume((event.target.value/100),{channel=3})
					MenuSettings.onTesterBtnRelease(event)
		        end
		        -- Create the slider widget
		        mySlider1 = widget.newSlider{
		            callback=sliderListener1
		        }
				pauseMenu.bigGroup:insert(mySlider1.view)
		        -- Center the slider widget on the screen:
		        mySlider1.x = display.contentWidth * 0.5
		        mySlider1.y = display.contentHeight * 0.2
		        -- insert the slider widget into a group:
		        --group:insert(pauseMenu.valueVol)
		        --group:insert( mySlider1.view)


		        --Create the slider for Sound Effects Control
				pauseMenu.valueSFX = display.newText("Your Sound Effects",display.contentWidth *.50,display.contentHeight * 0.65,native.systemFont,16)  
				pauseMenu.bigGroup:insert(pauseMenu.valueSFX)

				local sliderListener2 = function( event )
					local id = "Sound Effects";
					local sliderObj2 = event.target;
					pauseMenu.valueSFX.text=event.target.value;
					print( "New value is: " .. event.target.value )
					audio.setVolume((event.target.value/100),{channel=2})
					MenuSettings.onTestBtnRelease(event)
				end
				
				-- Create the slider widget
				mySlider2 = widget.newSlider{
					callback=sliderListener2
				}
				pauseMenu.bigGroup:insert(mySlider2.view)
				-- Center the slider widget on the screen:
				mySlider2.x = display.contentWidth * 0.5
				mySlider2.y = display.contentHeight * 0.6
				-- insert the slider widget into a group:
				
				 --group:insert(pauseMenu.valueSFX)
			     --group:insert( mySlider2.view)
			
			
			end
			if target.section == "Main" then
				--Switch to Loading Screen
				pauseMenu.backBtn.alpha = 1;
				pauseMenu.pauseText.alpha = 1;
				pauseMenu.restartBtn.alpha = 1;
				pauseMenu.exitBtn.alpha = 1;
				pauseMenu.loadBtn.alpha = 1;
				pauseMenu.saveBtn.alpha = 1;
				pauseMenu.settingsBtn.alpha = 1;
				pauseMenu.backMainBtn.alpha = 0;
				pauseMenu.overwriteBtn.alpha = 0;
				pauseMenu.loadCBtn.alpha = 0;
				pauseMenu.menuText.alpha = 0;
				for k = 1, 20 do
					slots[k].alpha = 0;
				end
				if pauseMenu.overlay_section == "Settings" then
					mySlider2:removeSelf()
					mySlider2 = nil
					pauseMenu.valueSFX:removeSelf()
					pauseMenu.valueSFX=nil
					mySlider1:removeSelf()
					mySlider1 = nil
					pauseMenu.valueVol:removeSelf()
					pauseMenu.valueVol=nil
				end
				pauseMenu.overlay_section = "Main"
				
				--Destroy All Object in Overlay Group
				local num = pauseMenu.overlayGroup.numChildren;
				while num >= 1 do
					pauseMenu.overlayGroup:remove(num)
					num = num - 1
				end
			end
		end
	end
end

pauseMenu.displayPreview = function(slot)
	local num = pauseMenu.overlayGroup.numChildren;
		while num >= 1 do
			pauseMenu.overlayGroup:remove(num)
			num = num - 1
		end
	local Play	 = require( "slot"..slot )
	local Materials = require( "materials" )
	local Units = require("units")
	local player = Play.structure;
	
	local str = "slot "..slot.."\n";
	str = str.."Cost: "..player.totalCost.."\n";
	str = str.."Num. Objects: "..player.numObjects.."\n";
	
	--Show An Image of the Structure
	local max_w = 182-80; --How Much Space do We Have to Show This Image in Width
	local max_h = 100; --And Height
	local baseX = (w/2)-75+50+48+20;
	local baseY = (h/2)+68;
	--Get the Largest X and Smallest Y Offset Value
	local off_xlarge = player.x_vals[1];
	local off_ylarge = -1*player.y_vals[1];
	for i = 1,player.numObjects do
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
		if player.id[i] < 1000 then
			local obj = Materials.clone(player.id[i])
			materialGroup:insert(obj)
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
			
			pauseMenu.overlayGroup:insert(obj);
			obj:toFront()
		else
			local obj = Units.clone(player.id[i])
			unitGroup:insert(obj)
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
			
			pauseMenu.overlayGroup:insert(obj);
			obj:toFront()

		end
	end
	return str;
end

pauseMenu.confirm = function(event)
	if event.phase == "began" and (event.target).alpha > 0 and pauseMenu.overlay_section ~= "Main" then
		pauseMenu.showInfo = true;
		pauseMenu.params.slot = (event.target).slot;
		local num = pauseMenu.overlayGroup.numChildren;
		while num >= 1 do
			pauseMenu.overlayGroup:remove(num)
			num = num - 1
		end
		--Get Text
		local str = "Slot "..pauseMenu.params.slot.."\n";
		local path = system.pathForFile( "", system.ResourceDirectory )
		local f = io.open( path.."slot"..pauseMenu.params.slot..".lua", "r" )
		if f == nil then
			str = str.."\nNo File";
		else
			str = pauseMenu.displayPreview(pauseMenu.params.slot)
		end
		pauseMenu.menuText.text = str;
		pauseMenu.menuText.alpha = 1;
	end
end

pauseMenu.back_to_main = function(event)
	if event.phase == "began" and pauseMenu.backBtn.alpha > 0 then
		local UI = require("module_item_ui");
		UI.slideUI();
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
			if pauseMenu.params.once == false then
				pauseMenu.params.once = true;
				pauseMenu.overlayshade.alpha = 0;
				pauseMenu.overlayrect.alpha = pauseMenu.params.r_alpha;
				pauseMenu.params.now_time = pauseMenu.params.anim_time;
				pauseMenu.overlayrect:scale(pauseMenu.params.r_scale,pauseMenu.params.r_scale);
				pauseMenu.params.nr_scale = (1-pauseMenu.params.r_scale)/pauseMenu.params.anim_time;
				pauseMenu.params.nr_scale = (pauseMenu.params.nr_scale+pauseMenu.params.r_scale)/pauseMenu.params.r_scale;
				physics.pause() --Pause the Physics
				require("module_item_ui").slideUI()
			end
			--Control Visibility of the Overlay Shade
			pauseMenu.overlayshade.alpha = pauseMenu.overlayshade.alpha + (pauseMenu.params.s_alpha/pauseMenu.params.anim_time)
			--Control Visibility of the Overlay Rectangle
			pauseMenu.overlayrect.alpha = pauseMenu.overlayrect.alpha + ((1-pauseMenu.params.r_alpha)/pauseMenu.params.anim_time)
			--Control Scaling of the Overlay Rectangle
			pauseMenu.overlayrect:scale(pauseMenu.params.nr_scale,pauseMenu.params.nr_scale);
			--Countdown the Timer
			pauseMenu.params.now_time = pauseMenu.params.now_time - 1;
			--Is Time Up?
			if pauseMenu.params.now_time <= 0 then
				overlay_activity = false;
				pauseMenu.params.once = false;
				pauseMenu.overlayshade.alpha = pauseMenu.params.s_alpha;
				pauseMenu.overlayrect.alpha = 1;
				
				--Display Buttons
				pauseMenu.backBtn.alpha = 1;
				pauseMenu.pauseText.alpha = 1;
				pauseMenu.restartBtn.alpha = 1;
				pauseMenu.exitBtn.alpha = 1;
				pauseMenu.loadBtn.alpha = 1;
				pauseMenu.saveBtn.alpha = 1;
				pauseMenu.settingsBtn.alpha = 1;
				
			end				
		else
		--If We Are Leaving
			--First Time Things
			if pauseMenu.params.once == false then
				pauseMenu.params.once = true;
				pauseMenu.overlayshade.alpha = pauseMenu.params.s_alpha;
				pauseMenu.overlayrect.alpha = 1;
				pauseMenu.params.now_time = pauseMenu.params.anim_time;
				pauseMenu.params.nr_scale = (1-pauseMenu.params.r_scale)/pauseMenu.params.anim_time;
				pauseMenu.params.nr_scale = (pauseMenu.params.nr_scale-pauseMenu.params.r_scale)/pauseMenu.params.r_scale;
				
				--Remove Buttons
				pauseMenu.backBtn.alpha = 0;
				pauseMenu.pauseText.alpha = 0;
				pauseMenu.restartBtn.alpha = 0;
				pauseMenu.exitBtn.alpha = 0;
				pauseMenu.loadBtn.alpha = 0;
				pauseMenu.saveBtn.alpha = 0;
				pauseMenu.settingsBtn.alpha = 0;
			end
			--Control Visibility of the Overlay Shade
			pauseMenu.overlayshade.alpha = pauseMenu.overlayshade.alpha - (pauseMenu.params.s_alpha/(pauseMenu.params.anim_time+5))
			--Control Visibility of the Overlay Rectangle
			pauseMenu.overlayrect.alpha = pauseMenu.overlayrect.alpha - ((1-pauseMenu.params.r_alpha)/(pauseMenu.params.anim_time+5))
			--Control Scaling of the Overlay Rectangle
			pauseMenu.overlayrect:scale(pauseMenu.params.nr_scale,pauseMenu.params.nr_scale);
			--Countdown the Timer
			pauseMenu.params.now_time = pauseMenu.params.now_time - 1;
			--Is Time Up?
			if pauseMenu.params.now_time <= 0 then
				overlay_activity = false;
				pauseMenu.overlayshade.alpha = 0;
				pauseMenu.overlayrect.alpha = 0;
				successTime = 1;
				pauseMenu.params.once = false;
				pauseMenu.overlayrect:scale((1/pauseMenu.params.r_scale),(1/pauseMenu.params.r_scale));
				physics.start() --Restart the Physics
			end	
		end
	else
		pauseMenu.params.once = false;
	end
end
--Runtime Listener at Bottom of enterScene

pauseMenu.createOverlay = function(group)
		--Overlay Animation Variables
		w = display.contentWidth
		h = display.contentHeight
		
		--Make the Overlay Rectangle
		pauseMenu.overlayshade = display.newRect(-w,0,w*3,h); --The Shady Part of the Screen
		pauseMenu.overlayshade:setFillColor(0,0,0); pauseMenu.overlayshade.alpha = 0;
		pauseMenu.bigGroup:insert(pauseMenu.overlayshade)
		
		pauseMenu.overlayrect = display.newImageRect("../images/overlay_grey.png",pauseMenu.params.r_w,pauseMenu.params.r_h);
		pauseMenu.overlayrect.alpha = 0; pauseMenu.overlayrect.x = (w/2); pauseMenu.overlayrect.y = (h/2);
		pauseMenu.bigGroup:insert(pauseMenu.overlayrect)
		
		pauseMenu.overlayGroup = display.newGroup();
		
		--Buttons
		pauseMenu.pauseText = display.newText("PAUSE",(w/2)-55,(h/2)-(pauseMenu.params.r_h/2),"Arial Black",30);
		pauseMenu.backBtn= display.newImage("../images/btn_back.png");
		pauseMenu.backBtn.x = (w/2); pauseMenu.backBtn.y = (h/2)+(pauseMenu.params.r_h/2)-30;
		pauseMenu.restartBtn = display.newImage("../images/btn_restart_level.png");
		pauseMenu.restartBtn.x = (w/2); pauseMenu.restartBtn.y = (h/2)+(pauseMenu.params.r_h/2)-110;
		pauseMenu.exitBtn = display.newImage("../images/btn_exit_level.png");
		pauseMenu.exitBtn.x = (w/2); pauseMenu.exitBtn.y = (h/2)+(pauseMenu.params.r_h/2)-70;
		pauseMenu.loadBtn = display.newImage("../images/btn_load.png");
		pauseMenu.loadBtn.x = (w/2); pauseMenu.loadBtn.y = (h/2)+(pauseMenu.params.r_h/2)-150; pauseMenu.loadBtn.section = "Load";
		pauseMenu.saveBtn = display.newImage("../images/btn_save.png");
		pauseMenu.saveBtn.x = (w/2); pauseMenu.saveBtn.y = (h/2)+(pauseMenu.params.r_h/2)-190; pauseMenu.saveBtn.section = "Save";
		pauseMenu.settingsBtn = display.newImage("../images/btn_gear.png");
		pauseMenu.settingsBtn.x = (w/2)+150; pauseMenu.settingsBtn.y = (h/2)+(pauseMenu.params.r_h/2)-35; pauseMenu.settingsBtn.section = "Settings";
		pauseMenu.bigGroup:insert(pauseMenu.pauseText)
		pauseMenu.bigGroup:insert(pauseMenu.backBtn)
		pauseMenu.bigGroup:insert(pauseMenu.restartBtn)
		pauseMenu.bigGroup:insert(pauseMenu.exitBtn)
		pauseMenu.bigGroup:insert(pauseMenu.loadBtn)
		pauseMenu.bigGroup:insert(pauseMenu.saveBtn)
		pauseMenu.bigGroup:insert(pauseMenu.settingsBtn)
		
		--slots
		slots = {};
		for k = 1, 20 do
			if k <= 10 then
				slots[k] = display.newImage("../images/btn_slot"..k..".png");
				pauseMenu.bigGroup:insert(slots[k])
				if k <= 5 then
					slots[k].x = (w/2)-75-50;
					slots[k].y = (h/2)-(pauseMenu.params.r_h/2)+(k*40);
				else
					slots[k].x = (w/2)-75+50;
					slots[k].y = (h/2)-(pauseMenu.params.r_h/2)+((k-5)*40);
				end
				slots[k].alpha = 0;
				slots[k].movy = "Yes";
				slots[k].static = "Yes";
				slots[k].slot = k;
			else
				slots[k] = display.newImage("../images/btn_nosave.png");
				pauseMenu.bigGroup:insert(slots[k])
				if k <= 15 then
					slots[k].x = (w/2)-75-50;
					slots[k].y = (h/2)-(pauseMenu.params.r_h/2)+((k-10)*40);
				else
					slots[k].x = (w/2)-75+50;
					slots[k].y = (h/2)-(pauseMenu.params.r_h/2)+((k-15)*40);
				end
				slots[k].alpha = 0;
				slots[k].movy = "Yes";
				slots[k].static = "Yes";
				slots[k].slot = (k-10);
			end
		end
		pauseMenu.backMainBtn = display.newImage("../images/btn_back.png");
		pauseMenu.backMainBtn.x = (w/2)-75; pauseMenu.backMainBtn.y = (h/2)-(pauseMenu.params.r_h/2)+(6*40)-5; pauseMenu.backMainBtn.alpha = 0; pauseMenu.backMainBtn.section = "Main";
		pauseMenu.overwriteBtn = display.newImage("../images/btn_overwrite.png");
		pauseMenu.overwriteBtn.x = (w/2)+75+20; pauseMenu.overwriteBtn.y = (h/2)-(pauseMenu.params.r_h/2)+(6*40)-5;
		pauseMenu.loadCBtn = display.newImage("../images/btn_loadconfirm.png");
		pauseMenu.loadCBtn.x = (w/2)+75+20; pauseMenu.loadCBtn.y = (h/2)-(pauseMenu.params.r_h/2)+(6*40)-5;
		pauseMenu.menuText = display.newText("Stuff",0,0,native.systemFont,12);
		pauseMenu.menuText.x = (w/2)+75; pauseMenu.menuText.y = (h/2)-80;
		pauseMenu.bigGroup:insert(pauseMenu.backMainBtn)
		pauseMenu.bigGroup:insert(pauseMenu.overwriteBtn)
		pauseMenu.bigGroup:insert(pauseMenu.loadCBtn)
		pauseMenu.bigGroup:insert(pauseMenu.menuText)
		
		pauseMenu.backBtn.alpha = 0;
		pauseMenu.pauseText.alpha = 0;
		pauseMenu.restartBtn.alpha = 0;
		pauseMenu.exitBtn.alpha = 0;
		pauseMenu.loadBtn.alpha = 0;
		pauseMenu.saveBtn.alpha = 0;
		pauseMenu.overwriteBtn.alpha = 0;
		pauseMenu.loadCBtn.alpha = 0;
		pauseMenu.menuText.alpha = 0;
		pauseMenu.settingsBtn.alpha = 0;
		
		pauseMenu.overlayshade.movy = "Yes"; pauseMenu.overlayrect.movy = "Yes"; pauseMenu.saveBtn.movy = "Yes"; pauseMenu.loadBtn.movy = "Yes"; pauseMenu.backMainBtn.movy = "Yes";
		pauseMenu.pauseText.movy = "Yes"; pauseMenu.backBtn.movy = "Yes"; pauseMenu.restartBtn.movy = "Yes"; pauseMenu.exitBtn.movy = "Yes"; pauseMenu.overwriteBtn.movy = "Yes"
		pauseMenu.loadCBtn.movy = "Yes"; pauseMenu.menuText.movy = "Yes"; pauseMenu.settingsBtn.movy = "Yes";
		
		pauseMenu.overlayshade.static = "Yes"; pauseMenu.overlayrect.static = "Yes"; pauseMenu.saveBtn.static = "Yes"; pauseMenu.loadBtn.static = "Yes"; pauseMenu.backMainBtn.static = "Yes";
		pauseMenu.pauseText.static = "Yes"; pauseMenu.backBtn.static = "Yes"; pauseMenu.restartBtn.static = "Yes"; pauseMenu.exitBtn.static = "Yes"; pauseMenu.overwriteBtn.static = "Yes"
		pauseMenu.loadCBtn.static = "Yes"; pauseMenu.menuText.static = "Yes"; pauseMenu.settingsBtn.static = "Yes";
		
		pauseMenu.backMainBtn:addEventListener("touch",pauseMenu.switchTo);
		pauseMenu.loadBtn:addEventListener("touch",pauseMenu.switchTo);
		pauseMenu.saveBtn:addEventListener("touch",pauseMenu.switchTo);
		pauseMenu.settingsBtn:addEventListener("touch",pauseMenu.switchTo)
		pauseMenu.backBtn:addEventListener("touch",pauseMenu.back_to_main);
		for k = 1, 20 do
			slots[k]:addEventListener("touch",pauseMenu.confirm);
		end
		
		Runtime:addEventListener("enterFrame",pauseMenu.overlay_animation);
		
		return group;
end

pauseMenu.bringMenutoFront = function(group)
	pauseMenu.overlayshade:toFront()
	pauseMenu.overlayrect:toFront()
	pauseMenu.backBtn:toFront()
	pauseMenu.pauseText:toFront()
	pauseMenu.restartBtn:toFront()
	pauseMenu.exitBtn:toFront()
	pauseMenu.loadBtn:toFront()
	pauseMenu.saveBtn:toFront()
	pauseMenu.backMainBtn:toFront()
	pauseMenu.overwriteBtn:toFront()
	pauseMenu.settingsBtn:toFront()
	pauseMenu.loadCBtn:toFront()
	pauseMenu.menuText:toFront()
	for k = 1, 20 do
		slots[k]:toFront();
	end
end

pauseMenu.destroy = function()
	Runtime:removeEventListener("enterFrame",pauseMenu.overlay_animation)
	
	local tmp = pauseMenu.overlayGroup.numChildren;
	while tmp >= 1 do
		pauseMenu.overlayGroup:remove(tmp)
		tmp = tmp - 1
	end
	if pauseMenu.backBtn ~= nil then
		pauseMenu.backBtn:removeSelf()
	end
	if pauseMenu.pauseText ~= nil then
		pauseMenu.pauseText:removeSelf()
	end
	if pauseMenu.restartBtn ~= nil then
		pauseMenu.restartBtn:removeSelf()
	end
	if pauseMenu.exitBtn ~= nil then
		pauseMenu.exitBtn:removeSelf()
	end
	if pauseMenu.loadBtn ~= nil then
		pauseMenu.loadBtn:removeSelf()
	end
	if pauseMenu.saveBtn ~= nil then
		pauseMenu.saveBtn:removeSelf()
	end
	if pauseMenu.backMainBtn ~= nil then
		pauseMenu.backMainBtn:removeSelf()
	end
	if pauseMenu.overwriteBtn ~= nil then
		pauseMenu.overwriteBtn:removeSelf()
	end
	if pauseMenu.settingsBtn ~= nil then
		pauseMenu.settingsBtn:removeSelf()
	end
	if pauseMenu.loadCBtn ~= nil then
		pauseMenu.loadCBtn:removeSelf()
	end
	if pauseMenu.menuText ~= nil then
		pauseMenu.menuText:removeSelf()
	end
	if pauseMenu.valueVol ~= nil then
		pauseMenu.valueVol:removeSelf()
	end
	if pauseMenu.valueSFX ~= nil then
		pauseMenu.valueSFX:removeSelf()
	end
	if mySlider1 ~= nil then
		mySlider1.view:removeSelf()
		mySlider1 = nil
	end
	if mySlider2 ~= nil then
		mySlider2.view:removeSelf()
		mySlider2 = nil
	end
	if pauseMenu.overlayshade ~= nil then
		pauseMenu.overlayshade:removeSelf()
	end
	if pauseMenu.overlayrect ~= nil then
		pauseMenu.overlayrect:removeSelf()
	end
	for i=1,#slots do
		if slots[k] ~= nil then
			slots[k]:removeSelf()
		end
	end
end

return pauseMenu;