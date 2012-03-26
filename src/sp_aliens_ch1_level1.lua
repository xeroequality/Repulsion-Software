local storyboard = require( "storyboard" )
local widget 	 = require( "widget" )
--local levelUI 	 = require( "levelUI")
local scrollview = require( "scrollview" )
local physics 	 = require( "physics" )
local Parallax 	 = require( "module_parallax" )
local Materials  = require( "materials" )
local Enemy 	 = require( "enemybase" )
local scene 	 = storyboard.newScene()
local cannonfired
local cannonfire
----------------------------------------------------------------------------------
--      NOTE:
--      Code outside of listener functions (below) will only be executed once,
--      unless storyboard.removeScene() is called.
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local function restart(event)
	local label = "sp_aliens_ch1_level1"
	print("released button " .. label)
	storyboard.gotoScene( label, "fade", 200)
	return true	-- indicates successful touch

end
local function exitNOW(event)
	local label = "menu_sp_aliens_levelselect"
	print("released button " .. label)
	storyboard.gotoScene( label, "fade", 200)
	return true	-- indicates successful touch

end
 
-- Called when the scene's view does not exist:
function scene:createScene( event )
        local group = self.view
		physics.start()
		
 		-- Instantiate Parallax Background
		background = Parallax.levelScene(
		{
			Width = display.contentWidth * 3,
			Height = display.contentHeight,
			Group = group,
			
			Background = "../images/background_chapter1_level1_background.png",
			BGW = 1500, BGH = 320,
			
			Foreground_Far = "../images/background_chapter1_level1_foreground_F.png",
			FGF_W =750, FGF_H = 450,
			
			Foreground_Near = "../images/background_chapter1_level1_foreground_N.png",
			FGN_W = 960, FGN_H = 332,
		} )

end
 
 
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
        local group = self.view
        
        -----------------------------------------------------------------------------
        -- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
		-----------------------------------------------------------------------------
		
		--------------------------------------------
		--                PRESETS                 --
		--------------------------------------------
		local prev_music = audio.loadStream("../sound/O fortuna.mp3")
        local music_bg = audio.loadStream("../sound/Bounty 30.ogg")
        audio.fadeOut(prev_music, { time=5000 })
        --o_play = audio.play(music_bg, {channel=3,fadein=5000 } )
		physics.start()
		local slideBtn
		--------------------
		-- Material Objects
		--------------------
		local wood_plank = Materials.wood_plank
		local wood_box = Materials.wood_box
		
		---------
		-- Floor
		---------
		local floor = display.newRect(-5*W,H-10,W*11,100)
		floor:setFillColor(0)
		physics.addBody(floor, "static", {friction=0.9, bounce=0.05} )
		group:insert(floor)
		
		local levelWallet = 10000; --The Amount of Money for This Level
		local wallet = levelWallet; --The Current Amount of Money
		
		--------------------------------------------
		--              Overlays                  --
		--------------------------------------------
		local goodoverlay = display.newImage("../images/greenoverlay.png")
		goodoverlay:setReferencePoint ( display.CenterReferencePoint )
		goodoverlay.x = 160; goodoverlay.y = H/2;
		goodoverlay.alpha = .25
		goodoverlay.width = 745
		
		local badoverlay = display.newImage("../images/redoverlay.png")
		badoverlay:setReferencePoint ( display.CenterReferencePoint )
		badoverlay.x = 700; badoverlay.y = H/2;
		badoverlay.alpha = .25
		badoverlay.width = 675
		
		--------------------------------------------
		--              SCROLLVIEW                --
		--------------------------------------------
		local scroll_topBound = 0				-- Sets the top side of the 
		local scroll_bottomBound = 0
		--local x_button_padding = -6			-- Should use this to move stuff over to eliminate gap
		
		local scroll_bkg = display.newImage("../images/ui_bkg_buildmenu.png")
		scroll_bkg.x = -2
		local item1 = display.newImage("../images/ui_item_wooden_plank.png")
			item1.id=wood_plank.id
			item1:setReferencePoint(display.CenterReferencePoint)
			item1.x = 0; item1.y = 35
			item1.text = display.newText("$"..wood_plank.cost,0,0,native.systemFont,28)
			item1.text:scale(0.5,0.5)
			item1.text:setTextColor(0)
			item1.text.x=0; item1.text.y=item1.y
		local item2 = display.newImage("../images/ui_item_wooden_box.png")
			item2.id=wood_box.id
			item2:setReferencePoint(display.CenterReferencePoint)
			item2.x = 0; item2.y = H
			item2.text = display.newText("$"..wood_box.cost,0,0,native.systemFont,28)
			item2.text:scale(0.5,0.5)
			item2.text:setTextColor(0)
			item2.text.x=0; item2.text.y=item2.y

		
		local cost = {wood_plank.cost,wood_box.cost}
		
		-- Create scrollView
			-- "isOpen" is for the whether it is "out" (visible) or "in" (offscreen)
			-- Insert all items that belong to scrollView
		local scrollView = scrollview.new{ top=scroll_topBound, bottom=scroll_bottomBound }
		scrollView.isOpen = true
		scrollView:insert(scroll_bkg)
		--scrollView:insert(static_menu)
		scrollView:insert(item1)
		scrollView:insert(item1.text)
		scrollView:insert(item2)
		scrollView:insert(item2.text)

		--Overlay Variables
		overlay = false; --Is the Overlay Up?
		overlay_activity = false; --Is There Overlay Animation Going On?
		
		local play_button = display.newImage("../images/ui_play_button.png");
		play_button.x = 45+30; play_button.y = 35; play_button.static = "Yes";
		local menu_button = display.newImage("../images/ui_menu_button.png");
		menu_button.x = 115+30; menu_button.y = 35; play_button.static = "Yes";
		
		--------------------------------------------
		--             	   Slide UI               --
		--------------------------------------------
		
		-- Event for when open/close button is pressed
			-- If scrollView is "open", close it
			-- If scrollView is "closed", open it
		local function slideUI (event)
			if scrollView.isOpen then
				print("closing scrollView")
				scrollView.isOpen = false
				transition.to(static_menu, {time=300, y=-85} )
				transition.to(scrollView, {time=300, x=-85} )
				transition.to(play_button, {time=300, y=-35} )
				transition.to(menu_button, {time=300, y=-35} )

				if slideBtn then
					slideBtn:removeSelf()
					slideBtn = widget.newButton{
						default="../images/ui_btn_buildmenu_right.png",
						over="../images/ui_btn_buildmenu_right_pressed.png",
						width=35, height=35,
						onRelease=slideUI
					}
					slideBtn.y = H/2
					slideBtn.x = scroll_bkg.width-45
					transition.to(slideBtn, {time=300, x=-35} )
					transition.to( goodoverlay, { alpha=0, xScale=1.0, yScale=1.0, time=0} )
					transition.to( badoverlay, { alpha=0, xScale=1.0, yScale=1.0, time=0} )

				end
			elseif not scrollView.isOpen then
				print("opening scrollView")
				scrollView.isOpen = true
				transition.to(static_menu, {time=300, y=0} )
				transition.to(scrollView, {time=300, x=0} )
				transition.to(play_button, {time=300, y=35} )
				transition.to(menu_button, {time=300, y=35} )
				if slideBtn then
					slideBtn:removeSelf()
					slideBtn = widget.newButton{
						default="../images/ui_btn_buildmenu_left.png",
						over="../images/ui_btn_buildmenu_left_pressed.png",
						width=35, height=35,
						onRelease=slideUI
					}
					slideBtn.y = H/2
					slideBtn.x = -35
					transition.to(slideBtn, {time=300, x=scroll_bkg.width-45} )
					transition.to( goodoverlay, { alpha=.25, xScale=1.0, yScale=1.0, time=0} )
					transition.to( badoverlay, { alpha=.25, xScale=1.0, yScale=1.0, time=0} )
				end
				--Close Overlay if Up
				if overlay == true and overlay_activity == false then
					overlay = false;
					overlay_activity = true;
					print("Here")
				end
			end
			return true
		end
		
		slideBtn = widget.newButton{
			default="../images/ui_btn_buildmenu_left.png",
			over="../images/ui_btn_buildmenu_left_pressed.png",
			width=35, height=35,
			onRelease=slideUI
		}
		slideBtn.y = H/2
		slideBtn.x = scroll_bkg.width-45
		
		--------------------------------------------
		--               ITEM DRAG                --
		--------------------------------------------
		-- Event for dragging an item
		local function dragItem (event)
			local phase = event.phase
			local target = event.target
			if scrollView.isOpen and overlay == false and overlay_activity == false then						-- need an and if touch.y is less than 150 so that it doesnt work when the scrollview is above the static button area
			if phase == "began" then
				display.getCurrentStage():setFocus(target)
				target.isFocus = true
				target.x0 = event.x - target.x
				target.y0 = event.y - target.y
				-- If physics is already applied to target, make it kinematic
				if target.bodyType then
					target.bodyType = "kinematic"
					target:setLinearVelocity(0,0)
					target.angularVelocity = 0
				end
				focus = event.target;
			elseif target.isFocus then
				if phase == "moved" then
					target.x = event.x - target.x0
					target.y = event.y - target.y0
					--Player can only place item in their area
					if target.x > badoverlay.x - badoverlay.width/2 then
						wallet = wallet + target.cost
						target:removeSelf()
						return true
					end
					-- Player can remove object and add money back by dropping below floor
					--[[ GLITCHES WITH PARALLAX...
					if target.y > H then
						wallet = wallet + target.cost
						target:removeSelf()
						return true
					end
					]]
				elseif phase == "ended" or phase == "cancelled" then
					-- If it doesn't already have a bodyType, then add it to physics
					-- If it does, set it's body type to dynamic
					if not target.bodyType then
						physics.addBody(target, "dynamic", {friction=target.friction, shape=target.shape })
					else
						target.bodyType = "dynamic"
					end
					display.getCurrentStage():setFocus(nil)
					target.isFocus = false
					--target:removeEventListener(dragItem)
				end
			end
			end
			focus = target
			return true
		end
		
		local focus = 0;
		--------------------------------------------
		--              ITEM SELECT               --
		--------------------------------------------
		-- Event for selecting an item from scrollView
		local function pickItem (event)
			local phase = event.phase
			local target = event.target
			if phase == "began" then
				if wallet >= cost[target.id] then
					if target.id == 1 then
						newObj = display.newImage("../images/wood_plank.png")
						newObj.type = "wood_plank"
					elseif target.id == 2 then
						newObj = display.newImage("../images/wood_box.png")
						newObj.type = "wood_box"
					else
						print("null target")
						return true
					end
					newObj = Materials.clone(newObj)
					wallet = wallet - newObj.cost
					newObj:scale(newObj.scaleX,newObj.scaleY)
					newObj.child = "Child";
					newObj.x = event.x
					newObj.y = event.y
					newObj:addEventListener("touch",dragItem)
					display.getCurrentStage():setFocus(newObj)
				
					--Drag This Object
					display.getCurrentStage():setFocus(newObj)
					newObj.isFocus = true
					newObj.x0 = event.x - newObj.x
					newObj.y0 = event.y - newObj.y
					-- If physics is already applied to target, make it kinematic
					if newObj.bodyType then
						newObj.bodyType = "kinematic"
						newObj:setLinearVelocity(0,0)
						newObj.angularVelocity = 0
					end
					focus = newObj;
					group:insert(newObj)
					assertDepth();
				else
					print("not enough money!")
					return true
				end
			end
			if newObj.isFocus then
				if phase == "moved" then
					newObj.x = event.x - newObj.x0
					newObj.y = event.y - newObj.y0
				elseif phase == "ended" or phase == "cancelled" then
					-- If it doesn't already have a bodyType, then add it to physics
					-- If it does, set it's body type to dynamic
					if not newObj.bodyType then
						physics.addBody(newObj, "dynamic", {friction=newObj.friction, shape=newObj.shape })
					else
						newObj.bodyType = "dynamic"
					end
					display.getCurrentStage():setFocus(nil)
					newObj.isFocus = false
				end
			end
			return true
		end
		
		item1:addEventListener("touch",pickItem)
		item2:addEventListener("touch",pickItem)
		
		--------------------------------------------
		--             STATIC MENUS               --
		--------------------------------------------
		static_menu = display.newGroup()
		
		-- local static_buttons_bkg = display.newImage("../images/ui_bkg_static_buttons.png")
		-- static_buttons_bkg.x = -2				-- -2 to eliminate gap by the edge of the screen
		-- static_buttons_bkg.y = 75
		-- static_menu:insert(static_buttons_bkg)
		
		local function playUI (event)
            transition.to(scrollView, {time=300, x=-85} )
            slideBtn:removeSelf()
            transition.to(play_button, {time=300, y=-35} )
            --make it so that we cannot access it again?
            --delete it!
			print('clicked play')
            if event.phase== "ended" then
                scrollView:removeSelf()
                play_button:removeSelf()
                print(scrollView)
                print(play_button)
            end
		end
		
		local function menuUI (event)
				-- Need to create a overlay and shade effect and pause the game when the menu button is pressed
			if event.phase == "began" then
				if overlay == false and overlay_activity == false then --Put Up the Overlay
					print('clicked menu')
					overlay_activity = true;
					overlay = true;
				end
			end
		end
		
		play_button:addEventListener("tap",playUI);
		menu_button:addEventListener("touch",menuUI);
		
		--Set Up the Width and Height Variables
		local w = display.contentWidth; local h = display.contentHeight;
		--Overlay Animation Variables
		local anim_time = 15; --How Much Time Spent for Overlay Animation (Both Ways)
		local now_time = 0; --The Current Time for the Current Animation
		local b = 25; local iw = 96*(2/3);
		local r_alpha = 0; --Overlay's Starting Alpha Value
		local s_alpha = 0.7; --Shade Final Alpha Value
		local r_scale = 0.75; --Overlay's Starting Scale
		local nr_scale = r_scale; --Overlay's Current Scale
		local once = false; --Preliminary Things Before Animating
		local r_w = (5*iw)+(2*b); --Length of the Overlay Rectangle
		local r_h = 256; --Height of the Overlay Rectangle
		local overlay_section = "Main"; --Which Section of the Overlay are We In?
		local showInfo = false; --Showing Some Text?
		local slot = 0;
		
		--Make the Overlay Rectangle
		local overlayshade = display.newRect(-w,0,w*3,h); --The Shady Part of the Screen
		overlayshade:setFillColor(0,0,0); overlayshade.alpha = 0;
		local overlayrect = display.newImageRect("../images/overlay_grey.png",r_w,r_h);
		overlayrect.alpha = 0; overlayrect.x = (w/2); overlayrect.y = (h/2);
		local overlayGroup = display.newGroup();
		
		--Buttons
		local pauseText = display.newText("PAUSE",(w/2)-60,(h/2)-(r_h/2),"Arial Black",30);
		local backBtn= display.newImage("../images/btn_back.png");
		backBtn.x = (w/2); backBtn.y = (h/2)+(r_h/2)-30;
		local restartBtn = display.newImage("../images/btn_restart_level.png");
		restartBtn.x = (w/2); restartBtn.y = (h/2)+(r_h/2)-110;
		local exitBtn = display.newImage("../images/btn_exit_level.png");
		exitBtn.x = (w/2); exitBtn.y = (h/2)+(r_h/2)-70;
		local loadBtn = display.newImage("../images/btn_load.png");
		loadBtn.x = (w/2); loadBtn.y = (h/2)+(r_h/2)-150; loadBtn.section = "Load";
		local saveBtn = display.newImage("../images/btn_save.png");
		saveBtn.x = (w/2); saveBtn.y = (h/2)+(r_h/2)-190; saveBtn.section = "Save";
		local settingsBtn = display.newImage("../images/btn_gear.png");
		settingsBtn.x = (w/2)+150; settingsBtn.y = (h/2)+(r_h/2)-35;
		
		--Slots
		local slots = {};
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
		local backMainBtn = display.newImage("../images/btn_back.png");
		backMainBtn.x = (w/2)-75; backMainBtn.y = (h/2)-(r_h/2)+(6*40)-5; backMainBtn.alpha = 0; backMainBtn.section = "Main";
		local overwriteBtn = display.newImage("../images/btn_overwrite.png");
		overwriteBtn.x = (w/2)+75+20; overwriteBtn.y = (h/2)-(r_h/2)+(6*40)-5;
		local loadCBtn = display.newImage("../images/btn_loadconfirm.png");
		loadCBtn.x = (w/2)+75+20; loadCBtn.y = (h/2)-(r_h/2)+(6*40)-5;
		local menuText = display.newText("Stuff",0,0,native.systemFont,12);
		menuText.x = (w/2)+75; menuText.y = (h/2)-80;
		local successText = display.newText("",50,10,native.systemFont,20);
		local successTime = 0; --Time for the Text to Stay Up
		local maxSuccessTime = 60; --How Long Does It Stay Up?
		
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
		successText.alpha = 0;
		
		overlayshade.movy = "Yes"; overlayrect.movy = "Yes"; saveBtn.movy = "Yes"; loadBtn.movy = "Yes"; backMainBtn.movy = "Yes";
		pauseText.movy = "Yes"; backBtn.movy = "Yes"; restartBtn.movy = "Yes"; exitBtn.movy = "Yes"; overwriteBtn.movy = "Yes"
		loadCBtn.movy = "Yes"; menuText.movy = "Yes"; successText.movy = "Yes"; settingsBtn.movy = "Yes";
		
		function assertDepth()
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
			group:insert(successText);
			for k = 1, 20 do
				group:insert(slots[k]);
			end
		end
		
		local function back_to_main(event)
			if event.phase == "began" and backBtn.alpha > 0 then
				scrollView.isOpen = true
				transition.to(static_menu, {time=300, y=0} )
				transition.to(scrollView, {time=300, x=0} )
				transition.to(play_button, {time=300, y=35} )
				transition.to(menu_button, {time=300, y=35} )
				if slideBtn then
					slideBtn:removeSelf()
					slideBtn = widget.newButton{
						default="../images/ui_btn_buildmenu_left.png",
						over="../images/ui_btn_buildmenu_left_pressed.png",
						width=35, height=35,
						onRelease=slideUI
					}
					slideBtn.y = H/2
					slideBtn.x = -35
					transition.to(slideBtn, {time=300, x=scroll_bkg.width-45} )
					transition.to( goodoverlay, { alpha=.25, xScale=1.0, yScale=1.0, time=0} )
					transition.to( badoverlay, { alpha=.25, xScale=1.0, yScale=1.0, time=0} )
				end
				--Close Overlay if Up
				if overlay == true and overlay_activity == false then
					overlay = false;
					overlay_activity = true;
					print("Here")
				end
			end
		end
		local function restart_level(event)
			if event.phase == "ended" and restartBtn.alpha > 0 then
				restart()
			end
		end
		local function exit_level(event)
			if event.phase == "ended" and exitBtn.alpha > 0 then
				exitNOW()
			end
		end
		local function switchTo(event)
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
							local f = io.open("slot"..k..".lua","r")
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
							local f = io.open("slot"..k..".lua","r")
							if f ~= nil then
								slots[k].alpha = 1;
							else
								slots[k+10].alpha = 1;
							end
						end
						overlay_section = "Save";
						showInfo = false;
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
		local function save(event)
			if event.phase == "ended" then
				local target = event.target;
				if target.alpha > 0 and overlay_section == "Save" then
					index = 1;
					local xvals = {}; local yvals = {}; local num = 0; local rotation = {}; local types = {};
					--Get Total Cost
					local total = 0;
					for i = 2, group.numChildren do
						local child = group[i];
						if child.child ~= nil then
							--Save the Structure
							num = num + 1;
							xvals[index] = child.x+group[1].x;
							yvals[index] = child.y;
							rotation[index] = child.rotation;
							types[index] = child.type;
							index = index + 1;
							total = total + child.cost;
						end
					end
					--Save the Structure
					--Get the BaseX
					local basX = 0;
					local mini = xvals[1];
					for i = 2, #xvals do
						if xvals[i] < mini then mini = xvals[i] end
					end
					basX = mini;
					for i = 1, #xvals do
						xvals[i] = xvals[i] - mini;
					end
					--Get the BaseY
					local basY = 0;
					local large =  yvals[1];
					for i = 2, #yvals do
						if yvals[i] > large then large = yvals[i] end
					end
					basY = large;
					for i = 1, #yvals do
						yvals[i] = yvals[i]-large;
					end
					--Make the Array
					local supers = "";
					supers = 'local Material = require("materials")\n\n'
					supers = supers.."PlayerBase = {}\n\n";
					supers = supers.."PlayerBase.structure = {\n";
					supers = supers.."numObjects="..num..",\n";
					supers = supers.."baseX="..basX..",\n";
					supers = supers.."baseY="..basY..",\n";
					supers = supers.."totalCost="..total..",\n";
					supers = supers.."types={\n";
					for i = 1, #types do
						supers = supers..'"'..types[i]..'"'
						if i ~= #types then supers = supers..","; end
					end
					supers = supers.."\n},\n";
					supers = supers.."x_vals={\n";
					for i = 1, #xvals do
						supers = supers..xvals[i]
						if i ~= #xvals then supers = supers..","; end
					end
					supers = supers.."\n},\n";
					supers = supers.."y_vals={\n";
					for i = 1, #yvals do
						supers = supers..yvals[i]
						if i ~= #yvals then supers = supers..","; end
					end
					supers = supers.."\n},\n";
					supers = supers.."rotations={\n";
					for i = 1, #rotation do
						supers = supers..rotation[i]
						if i ~= #rotation then supers = supers..","; end
					end
					supers = supers.."\n}\n}\n\nreturn PlayerBase";
					--local path = system.pathForFile( "playerbase.lua", system.ResourceDirectory )
					local file = io.open( "slot"..slot..".lua", "w" )
					file:write( supers )
					io.close( file )
					file = nil
					slots[slot].alpha = 1;
					slots[slot+10].alpha = 0;
					successText.text = "Save Successful!";
					successTime = maxSuccessTime;
					successText:setTextColor(0,255,0);
					
					local num = overlayGroup.numChildren;
					while num >= 1 do
						overlayGroup:remove(num)
						num = num - 1
					end
					local str = "Slot "..slot.."\n";
					package.loaded["slot"..slot] = nil
					_G["slot"..slot] = nil
					local Play	 = require( "slot"..slot )
					local player = Play.structure;
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
					player = nil;
					Play = nil;
					menuText.text = str;
					menuText.alpha = 1;
				end
			end
		end
		local function load(event)
			if event.phase == "ended" then
				package.loaded["slot"..slot] = nil
				_G["slot"..slot] = nil
				local Play	 = require( "slot"..slot )
				local player = Play.structure;
				if player.totalCost <= levelWallet then
					wallet = levelWallet - player.totalCost;
					--Destroy All Children Objects Before Loading
					local num = group.numChildren;
					while num >= 1 do
						local c = group[num];
						if c.child ~= nil then
							group:remove(num)
							--c:removeSelf();
						end
						num = num - 1;
					end
					for i=1,player.numObjects do
						local obj = {}
						local baseX = player.baseX;
						local baseY = player.baseY;
						obj.type = player.types[i]
						-- first clone: so obj.img refers to proper image
						-- second clone: to pass data to object
						obj = Materials.clone(obj)
						obj = display.newImage(obj.img)
						obj.type = player.types[i]
						obj = Materials.clone(obj)
						obj.type = player.types[i]
						obj:scale(obj.scaleX,obj.scaleY)
						obj.x = player.x_vals[i]+baseX;
						obj.y = player.y_vals[i]+baseY;
						obj.rotation = player.rotations[i]
						obj.child = "Child";
						physics.addBody(obj, {density=obj.density,friction=obj.friction,bounce=obj.bounce,shape=obj.shape} )
						obj:addEventListener("touch",dragItem)
						group:insert(obj)
					end
					successText.text = "Load Successful!";
					successTime = maxSuccessTime;
					successText:setTextColor(0,255,0);
				else
					successText.text = "Not Enough Money!";
					successTime = maxSuccessTime;
					successText:setTextColor(255,0,0);
				end
				player = nil;
				Play = nil;
				assertDepth();
			end
		end
		local function confirm(event)
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
					package.loaded["slot"..slot] = nil
					_G["slot"..slot] = nil
					local Play	 = require( "slot"..slot )
					local player = Play.structure;
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
				end
				menuText.text = str;
				menuText.alpha = 1;
			end
		end
		local function success(event)
			if successTime > 0 then
				successTime = successTime - 1;
				successText.alpha = 1;
				if successTime <= 0 then
					successText.alpha = 0;
				end
			end
		end
						
		
		restartBtn:addEventListener("touch",restart_level);
		exitBtn:addEventListener("touch",exit_level);
		backBtn:addEventListener("touch",back_to_main);
		backMainBtn:addEventListener("touch",switchTo);
		loadBtn:addEventListener("touch",switchTo);
		saveBtn:addEventListener("touch",switchTo);
		for k = 1, 20 do
			slots[k]:addEventListener("touch",confirm);
		end
		overwriteBtn:addEventListener("touch",save);
		loadCBtn:addEventListener("touch",load);
		
		local function overlay_animation(event)
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
						--Close SlideView
						if scrollView.isOpen == true then
							scrollView.isOpen = false
							transition.to(static_menu, {time=300, y=-85} )
							transition.to(scrollView, {time=300, x=-85} )
							transition.to(play_button, {time=300, y=-35} )
							transition.to(menu_button, {time=300, y=-35} )

							if slideBtn then
								slideBtn:removeSelf()
								slideBtn = widget.newButton{
									default="../images/ui_btn_buildmenu_right.png",
									over="../images/ui_btn_buildmenu_right_pressed.png",
									width=35, height=35,
									onRelease=slideUI
								}
								slideBtn.y = H/2
								slideBtn.x = scroll_bkg.width-45
								transition.to(slideBtn, {time=300, x=-35} )
								transition.to( goodoverlay, { alpha=0, xScale=1.0, yScale=1.0, time=300} )
								transition.to( badoverlay, { alpha=0, xScale=1.0, yScale=1.0, time=300} )

							end
						end
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
		
		--Focus HP
		local HPText = display.newText("",0,0,native.systemFont,32);
		HPText:scale(0.5,0.5)
		HPText.x = display.contentWidth/2+120; HPText.y = 100; HPText:setTextColor(0);
		function showHP(event)
			if focus ~= 0 then
				HPText.text = "This Object's HP is "..focus.maxHP.."\nCost: "..focus.cost.."\nBasicR: "..(focus.resist).basic;
				HPText.text = HPText.text.."\nFireR: "..(focus.resist).fire.."\nWaterR: "..(focus.resist).water.."\nExplosiveR: "..(focus.resist).explosive;
				HPText.text = HPText.text.."\nElectricR: "..(focus.resist).electric;
			end
		end
		Runtime:addEventListener("enterFrame",showHP);

		
		local MONEY = display.newText("You Have $"..wallet,0,0,native.systemFont,12);
		MONEY.x = display.contentWidth/2; MONEY.y = 15;
		MONEY:setTextColor(255,0,0)
		
		function updateMONEY(event)
			MONEY.text = "You Have $"..wallet;
		end
		Runtime:addEventListener("enterFrame",updateMONEY)
		
		----------------------------------------------
		--           GENERATE ENEMY BASE            --
		----------------------------------------------
		
		--Collision
		local threshold = 1;
		function hit(event)
			if (event.other).weapon ~= nil then
				if event.force >= threshold then
					(event.target).currentHP = (event.target).currentHP - (event.force*(event.other).weapon);
					print((event.target).currentHP)
					if (event.target).currentHP <= 0 then
						(event.target):removeSelf()
					end
				end
			end
		end
		
		-- In future levels, the ONLY thing that needs to change is the first line:
		local enemy = Enemy.level1
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
		
		--objGroup:addEventListener('collision', removeball)
		group:insert(goodoverlay)
		group:insert(badoverlay)
		--group:insert(scrollView)
		-- group:insert(static_menu)
		-- group:insert(slideBtn.view)
		group:insert(cannonballGroup)
		group:insert(cannonGroup)
		group:insert(MONEY)
		group:insert(HPText)
		group:insert(objGroup)
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
		group:insert(successText);
		for k = 1, 20 do
			group:insert(slots[k]);
		end
		
		Runtime:addEventListener("enterFrame",overlay_animation)
		Runtime:addEventListener("enterFrame",success)

end

		----------------------------------------------
		--           		Cannon		            --
		----------------------------------------------
		local cannonBase    = nil
		local cannon        = nil
		cannonGroup   = nil
		--cannonballGroup = nil
		cballExists = false

		forceMultiplier = 10

		function makeCannon()
			-- create a couple of display groups
			interface = display.newGroup()
			cannonGroup = display.newGroup()
			cannonballGroup = display.newGroup()
			interface:insert(cannonGroup)
	
			-- load the images
			cannon      = display.newImage('../images/cannon_sm.png')
			cannonBase  = display.newImage('../images/cannon_base_sm.png')
	
			cannonGroup:insert(cannon)
			cannonGroup:insert(cannonBase)
			cannon:translate(8,-30)

			
			-- move the cannon to the right spot
			cannonGroup.x = 240
			cannonGroup.y = 240

			-- add the cannons to the stage and creat touch event for the crosshair
			--display.getCurrentStage():insert(cannonGroup)
			showCrosshair = false 										-- helps ensure that only one crosshair appears
			cannonGroup:addEventListener('touch',createCrosshair)
			
		end

		function createCrosshair(event) -- creates crosshair when a touch event begins
			-- creates the crosshair
			local phase = event.phase
			if (phase == 'began' and overlay == false and overlay_activity == false) then
				if not (cballExists) then
					if not (showCrosshair) then										-- helps ensure that only one crosshair appears
						crosshair = display.newImage( "../images/crosshair.png" )				-- prints crosshair	
						crosshair.x = display.contentWidth - 300
						crosshair.y = display.contentHeight - 200
						showCrosshair = transition.to( crosshair, { alpha=1, xScale=0.5, yScale=0.5, time=200 } )
						startRotation = function()
							crosshair.rotation = crosshair.rotation + 4
						end
						Runtime:addEventListener( "enterFrame", startRotation )
						interface:insert(crosshair)
						crosshair:addEventListener('touch',fire)
					end
				end
			end
		end

		function fire( event )
			local phase = event.phase
			if "began" == phase then
				display.getCurrentStage():setFocus( crosshair )
				crosshair.isFocus = true
				crosshairLine = nil
				--cannonLine = nil
			elseif crosshair.isFocus then
				if "moved" == phase then
					
					if ( crosshairLine ) then
						crosshairLine.parent:remove( crosshairLine ) -- erase previous line, if any
						--cannonLine.parent:remove( cannonLine ) -- erase previous line, if any
					end		
						
					crosshairLine = display.newLine(crosshair.x,crosshair.y, event.x,event.y) -- draws the line from the crosshair
					local cannonRotation = (180/math.pi)*math.atan((event.y-crosshair.y)/(event.x-crosshair.x)) -- rotates the cannon based on the trajectory line
					if (event.x < crosshair.x) then
						cannon.rotation = cannonRotation + 180  -- since arctan goes from -pi/2 to pi/2, this is necessary to make the cannon point backwards
					else
						cannon.rotation = cannonRotation
					end
					crosshairLine:setColor( 0, 255, 0, 200 )
					crosshairLine.width = 8
					
					--cannonLine = display.newLine( cannon.x,cannon.y, event.x-cannon.x,event.y-cannon.y ) -- draws the line for the cannon
					--cannonLine:setColor( 255, 255, 255, 50 )
					--cannonLine.width = 8
					
				elseif "ended" == phase or "cancelled" == phase then 						-- have this happen after collision is detected.
				display.getCurrentStage():setFocus( nil )
				crosshair.isFocus = false
					
				local stopRotation = function()
					Runtime:removeEventListener( "enterFrame", startRotation )
				end

				-- make a new image
				cannonball = display.newImage('../images/cannonball.png')	
				cballExists = true

				-- move the image
				cannonball.x = 300
				cannonball.y = 240
				cannonball.weapon = 200;
				cannonballGroup:insert(cannonball)

				-- apply physics to the cannonball
				physics.addBody( cannonball, { density=3.0, friction=0.2, bounce=0.05, radius=15 } )
				cannonball.isBullet = true

				-- fire the cannonball            
				cannonball:applyForce( (event.x - crosshair.x)*forceMultiplier, (event.y - (crosshair.y))*forceMultiplier, cannonball.x, cannonball.y )
				cannonfire = audio.loadSound("../sound/Single_cannon_shot.wav")
				cannonfired = audio.play(cannonfire,{channel=2} )
				-- make sure that the cannon is on top of the 
				local hideCrosshair = transition.to( crosshair, { alpha=0, xScale=1.0, yScale=1.0, time=0, onComplete=stopRotation} )
				showCrosshair = false									-- helps ensure that only one crosshair appears
				
				if ( crosshairLine ) then	
					crosshairLine.parent:remove( crosshairLine ) -- erase previous line, if any
					--cannonLine.parent:remove( cannonLine ) -- erase previous line, if any
				end
				--interface:insert(cannonballGroup)
				
				cannonball:addEventListener('collision', removeball)
				
			end

			end
		end
		
		local deleteBall = function() cannonball:removeSelf() cballExists = false end
		function removeball()
			cannonball:removeEventListener('collision', removeball)  -- makes it so it only activates on the first collision
			print('deleting the ball...')
			timer.performWithDelay(5000, deleteBall, 1)	
		end
		
		makeCannon()
 
-- Called when scene is about to move offscreen:
function scene:exitScene( event )
        local group = self.view
        
        -----------------------------------------------------------------------------
        --      INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
        -----------------------------------------------------------------------------
		--Remove the Runtime Listeners
		--scrollGroup:removeEventListener(scroll)
		
		Runtime:removeEventListener("enterFrame",overlay_animation)
		Runtime:removeEventListener("enterFrame",success)
        
		local num = group.numChildren;
		while num >= 1 do
			group:remove(num)
			num = num - 1
		end
		local num = interface.numChildren;
		while num >= 1 do
			interface:remove(num)
			num = num - 1
		end
		--[[
		local num = cannonGroup.numChildren;
		while num >= 1 do
			if cannonGroup[num] ~= nil then
				cannonGroup:remove(num)
				num = num - 1
			end
		end
		local num = cannonballGroup.numChildren;
		while num >= 1 do
			if cannonballGroup[num] ~= nil then
				cannonballGroup:remove(num)
				num = num - 1
			end
		end--]]
		
end
 
 
-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
        local group = self.view
        
        -----------------------------------------------------------------------------
        --      INSERT code here (e.g. remove listeners, widgets, save state, etc.)
        -----------------------------------------------------------------------------
		if slideBtn then
			slideBtn:removeSelf()
			slideBtn = nil
		end
		if scrollView then
			scrollView:removeSelf();
			scrollView = nil
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