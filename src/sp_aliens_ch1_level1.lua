local storyboard 		= require( "storyboard" )
local widget 	 		= require( "widget" )
--local levelUI 	 	= require( "levelUI")
local ScrollView		= require( "module_scrollview" )
local physics			= require( "physics" )
local Parallax			= require( "module_parallax" )
local Materials			= require( "materials" )
local Units  			= require( "units" )
--local Enemy				= require( "enemybase" )
local IO	     		= require( "save_and_load" )
local Pause				= require( "pause_overlay" )
local MenuSettings 		= require( "settings" )
local scene 	 		= storyboard.newScene()
local weaponSFXed
local weaponSFX

widget.setTheme("theme_ios")	
transitionStash = {}	  	
timerStash = {};
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
		local W = display.contentWidth; local H = display.contentHeight;
        
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

		local levelObjs = { -- Use this to choose what is items are available in this level
			Materials.wood_plank,
			Materials.wood_box,
			Units.cannon
		}
		print ('levelObjs: ' .. #levelObjs)

		---------
		-- Floor
		---------
		floorleft = -5*W
		floorwidth = 11*W
		local floor = display.newRect(floorleft,H-10,floorwidth,100)
		floor:setFillColor(0)
		physics.addBody(floor, "static", {friction=0.9, bounce=0.05} )
		group:insert(floor)
		
		local levelWallet = 10000; --The Amount of Money for This Level
		local wallet = levelWallet; --The Current Amount of Money
		
		--------------------------------------------
		--              Overlays                  --
		--------------------------------------------
		local goodoverlay = display.newImage("../images/greenoverlay.png")
		goodoverlay.x = 160; goodoverlay.y = H/2;
		goodoverlay.alpha = .25
		goodoverlay.width = 745
		
		local badoverlay = display.newImage("../images/redoverlay.png")
		badoverlay.x = 700; badoverlay.y = H/2;
		badoverlay.alpha = .25
		badoverlay.width = 675
		
		--------------------------------------------
		--              SCROLLVIEW                --
		--------------------------------------------
		local scrollView = ScrollView.new{
			background="../images/ui_bkg_buildmenu.png",
			top=0,
			bottom=0
		}
		for i=1,#levelObjs do
			scrollView.addItem{
				id=levelObjs[i].id,
				cost=levelObjs[i].cost,
				img=levelObjs[i].img_ui,
				print('levelObjs[i].id ' .. levelObjs[i].id)
			}
		end

		--Overlay Variables
		overlay = false; --Is the Overlay Up?
		overlay_activity = false; --Is There Overlay Animation Going On?
		
		local play_button = display.newImage("../images/ui_play_button.png");
		play_button.x = 45+30; play_button.y = 35; play_button.static = "Yes";
		local menu_button = display.newImage("../images/ui_menu_button.png");
		menu_button.x = 115+30; menu_button.y = 35; play_button.static = "Yes";
		
		--------------------------------------------
		--             	   Slide UI               --				How is this function different than the static menus function??????
		--------------------------------------------
		
		-- Event for when open/close button is pressed
			-- If scrollView is "open", close it
			-- If scrollView is "closed", open it
		local function slideUI (event)
			if scrollView.isOpen then
				print("closing scrollView")
				scrollView.isOpen = false
				transitionStash.newTransition = transition.to(static_menu, {time=300, y=-85} )
				transitionStash.newTransition = transition.to(scrollView.scrollview, {time=300, x=-85} )
				transitionStash.newTransition = transition.to(play_button, {time=300, y=-35} )
				transitionStash.newTransition = transition.to(menu_button, {time=300, y=-35} )

				if slideBtn then
					slideBtn:removeSelf()
					slideBtn = widget.newButton{
						default="../images/ui_btn_buildmenu_right.png",
						over="../images/ui_btn_buildmenu_right_pressed.png",
						width=35, height=35,
						onRelease=slideUI
					}
					slideBtn.y = H/2
					slideBtn.x = scrollView.bkgView.width-45
					transitionStash.newTransition = transition.to(slideBtn, {time=300, x=-35} )
					transitionStash.newTransition = transition.to( goodoverlay, { alpha=0, xScale=1.0, yScale=1.0, time=0} )
					transitionStash.newTransition = transition.to( badoverlay, { alpha=0, xScale=1.0, yScale=1.0, time=0} )

				end
			elseif not scrollView.isOpen then
				print("opening scrollView")
				scrollView.isOpen = true
				transitionStash.newTransition = transition.to(static_menu, {time=300, y=0} )
				transitionStash.newTransition = transition.to(scrollView.scrollview, {time=300, x=0} )
				transitionStash.newTransition = transition.to(play_button, {time=300, y=35} )
				transitionStash.newTransition = transition.to(menu_button, {time=300, y=35} )
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
					transitionStash.newTransition = transition.to(slideBtn, {time=300, x=scrollView.bkgView.width-45} )
					transitionStash.newTransition = transition.to( goodoverlay, { alpha=.25, xScale=1.0, yScale=1.0, time=0} )
					transitionStash.newTransition = transition.to( badoverlay, { alpha=.25, xScale=1.0, yScale=1.0, time=0} )
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
		slideBtn.x = scrollView.bkgView.width-45
		
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
				elseif phase == "ended" or phase == "cancelled" then
					-- If it doesn't already have a bodyType, then add it to physics
					-- If it does, set it's body type to dynamic
					if not target.bodyType then
						physics.addBody(target, "dynamic", {friction=target.friction}) --, shape=target.shape })
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
		local playerGroup = display.newGroup()
		local materialGroup = display.newGroup()
		unitGroup = display.newGroup()
		local function pickItem (event)
			local newObj = display.newImage("")
			local phase = event.phase
			local target = event.target
			if phase == "began" then
				if wallet >= target.cost then
					if target.id < 1000 then
						newObj = Materials.clone(target.id)
						materialGroup:insert(newObj)
					elseif target.id >= 1000 then
						newObj = Units.clone(target.id)
						unitGroup:insert(newObj)
						print('#unitGroup: ' .. unitGroup.numChildren)
					else
						print("null target")
						return true
					end
					
					wallet = wallet - newObj.cost
					newObj.x = event.x
					newObj.y = event.y
					newObj:addEventListener("touch",dragItem)
					display.getCurrentStage():setFocus(newObj)

					--Drag This Object
					newObj.isFocus = true
					newObj.x0 = event.x - newObj.x
					newObj.y0 = event.y - newObj.y
					-- If physics is already applied to target, make it kinematic
					if newObj.bodyType then
						newObj.bodyType = "kinematic"
						newObj:setLinearVelocity(0,0)
						newObj.angularVelocity = 0
					end
					local focus = newObj;
					--Pause.assertDepth();
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
						physics.addBody(newObj, "dynamic", {friction=newObj.friction}) --, shape=newObj.shape })
					else
						newObj.bodyType = "dynamic"
					end
					display.getCurrentStage():setFocus(nil)
					newObj.isFocus = false
				end
			end
			return true
		end
		
		for i=1,#scrollView.items do
			scrollView.items[i].view:addEventListener("touch",pickItem)
		end
		
		--------------------------------------------
		--             STATIC MENUS               --
		--------------------------------------------
		local static_menu = display.newGroup()
		
		local function playUI (event)
            slideBtn:removeSelf()
            --make it so that we cannot access it again?
            --delete it!
			print('clicked play')
			transitionStash.newTransition = transition.to(menu_button, {time=300, x=-10} )
			scrollView.destroy()
			play_button:removeSelf()
			goodoverlay:removeSelf()
			badoverlay:removeSelf()
			scrollView = nil
			play_button = nil
			showCrosshair = false 										-- helps ensure that only one crosshair appears
			print('here')
			for i=1,unitGroup.numChildren do
				print('unitGroup: ' .. unitGroup[i].id)
				unitGroup[i]:removeEventListener("touch", dragItem)
				unitGroup[i]:addEventListener('touch',createCrosshair)
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
		
		play_button:addEventListener("touch",playUI);
		menu_button:addEventListener("touch",menuUI);
		
		group = pauseMenu.createOverlay(group);
		
		-- closeView = function()
			-- --Close SlideView
			-- if scrollView.isOpen == true then
				-- scrollView.isOpen = false
				-- transitionStash.newTransition = transition.to(static_menu, {time=300, y=-85} )
				-- transitionStash.newTransition = transition.to(scrollView.scrollview, {time=300, x=-85} )
				-- transitionStash.newTransition = transition.to(play_button, {time=300, y=-35} )
				-- transitionStash.newTransition = transition.to(menu_button, {time=300, y=-35} )

				-- if slideBtn then
					-- slideBtn:removeSelf()
					-- slideBtn = widget.newButton{
						-- default="../images/ui_btn_buildmenu_right.png",
						-- over="../images/ui_btn_buildmenu_right_pressed.png",
						-- width=35, height=35,
						-- onRelease=slideUI
					-- }
					-- slideBtn.y = H/2
					-- slideBtn.x = scrollView.bkgView.width-45
					-- transitionStash.newTransition = transition.to(slideBtn, {time=300, x=-35} )
					-- transitionStash.newTransition = transition.to( goodoverlay, { alpha=0, xScale=1.0, yScale=1.0, time=300} )
					-- transitionStash.newTransition = transition.to( badoverlay, { alpha=0, xScale=1.0, yScale=1.0, time=300} )

				-- end
			-- end
		-- end
		-- openView = function()
			-- scrollView.isOpen = true
			-- transitionStash.newTransition = transition.to(static_menu, {time=300, y=0} )
			-- transitionStash.newTransition = transition.to(scrollView.scrollview, {time=300, x=0} )
			-- transitionStash.newTransition = transition.to(play_button, {time=300, y=35} )
			-- transitionStash.newTransition = transition.to(menu_button, {time=300, y=35} )
			-- if slideBtn then
				-- slideBtn:removeSelf()
				-- slideBtn = widget.newButton{
					-- default="../images/ui_btn_buildmenu_left.png",
					-- over="../images/ui_btn_buildmenu_left_pressed.png",
					-- width=35, height=35,
					-- onRelease=slideUI
				-- }
				-- slideBtn.y = H/2
				-- slideBtn.x = -35
				-- transitionStash.newTransition = transition.to(slideBtn, {time=300, x=scrollView.bkgView.width-45} )
				-- transitionStash.newTransition = transition.to( goodoverlay, { alpha=.25, xScale=1.0, yScale=1.0, time=0} )
				-- transitionStash.newTransition = transition.to( badoverlay, { alpha=.25, xScale=1.0, yScale=1.0, time=0} )
			-- end
		-- end

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
		
		local save = function(event)
			if event.phase == "ended" and (event.target).alpha > 0 and overlay_section == "Save" then
				IO.save(slot,overlay_section,group);
				slots[slot].alpha = 1;
				slots[slot+10].alpha = 0;
				local str = Pause.displayPreview(slot);
				menuText.text = str;
				menuText.alpha = 1;
			end
		end
		local load = function(event)
			if event.phase == "ended" and (event.target).alpha > 0 and overlay_section == "Load" then
				group = IO.load(slot,group,levelWallet);
				for i = 2,group.numChildren do
					local child = group[i];
					if child.child ~= nil then
						child:addEventListener("touch",dragItem);
					end
				end
				Pause.assertDepth(group);
			end
		end
		
		restartBtn:addEventListener("touch",restart_level);
		exitBtn:addEventListener("touch",exit_level);
		overwriteBtn:addEventListener("touch",save);
		loadCBtn:addEventListener("touch",load);
		
		--Focus HP
		local HPText = display.newText("",0,0,native.systemFont,32);
		HPText:scale(0.5,0.5)
		HPText.x = display.contentWidth/2+120; HPText.y = 100; HPText:setTextColor(0);
		local function showHP(event)
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
		
		local function updateMONEY(event)
			MONEY.text = "You Have $"..wallet;
		end
		Runtime:addEventListener("enterFrame",updateMONEY)
		
		--Collision
		local threshold = 1;
		hit = function(event)
			if (event.other).weapon ~= nil then
				if event.force >= threshold then
					(event.target).currentHP = (event.target).currentHP - math.ceil((event.force*(event.other).weapon));
					print((event.target).currentHP)
					local h = (event.target).currentHP; local m = (event.target).maxHP;
					if h < 0 then h = 0; end
					local p = math.ceil(4*(h/m));
					(event.target).alpha = (p/4)
					if (event.target).currentHP <= 0 then
						(event.target):removeSelf()
					end
				end
			end
		end
		
		-- In future levels, the ONLY thing that needs to change is the first line:
		local objGroup = Pause.loadLevel();
		
		group:insert(goodoverlay)
		group:insert(badoverlay)
		--group:insert(scrollView)
		-- group:insert(static_menu)
		-- group:insert(slideBtn.view)
		group:insert(materialGroup)
		group:insert(unitGroup)
		--group:insert(projectileGroup)
		--group:insert(cannonGroup)
		group:insert(MONEY)
		group:insert(HPText)
		group:insert(objGroup)
		-- group:insert(projectile)

end

		----------------------------------------------
		--           		Cannon		            --
		----------------------------------------------

		cballExists = false
		
		forceMultiplier = 10

		createCrosshair = function(event) -- creates crosshair when a touch event begins
			-- creates the crosshair
			local phase = event.phase
			clickedUnit = event.target
			if (phase == 'began') then
				if not (cballExists) then
					if not (showCrosshair) then										-- helps ensure that only one crosshair appears
						crosshair = display.newImage( "../images/crosshair.png" )				-- prints crosshair	
						crosshair.x = display.contentWidth - 300
						crosshair.y = display.contentHeight - 200
						showCrosshair = transition.to( crosshair, { alpha=1, xScale=0.5, yScale=0.5, time=200 } )
						transitionStash.newTransition = showCrosshair;
						startRotation = function()
							crosshair.rotation = crosshair.rotation + 4
						end
						Runtime:addEventListener( "enterFrame", startRotation )
						crosshair:addEventListener('touch',fire)
					end
				end
			end
		end

		fire = function( event )
			local phase = event.phase
			if "began" == phase then
				print('clickedUnit.x: ' .. clickedUnit.x .. ' clickedUnit.y: ' .. clickedUnit.y)
				display.getCurrentStage():setFocus( crosshair )
				crosshair.isFocus = true
				crosshairLine = nil
				--cannonLine = nil
			elseif crosshair.isFocus then
				if "moved" == phase then
					
					if ( crosshairLine ) then
						crosshairLine.parent:remove( crosshairLine ) -- erase previous line, if any
					end		
						
					crosshairLine = display.newLine(crosshair.x,crosshair.y, event.x,event.y) -- draws the line from the crosshair
					local cannonRotation = (180/math.pi)*math.atan((event.y-crosshair.y)/(event.x-crosshair.x)) -- rotates the cannon based on the trajectory line
					if (event.x < crosshair.x) then
						clickedUnit[1].rotation = cannonRotation + 180  -- since arctan goes from -pi/2 to pi/2, this is necessary to make the cannon point backwards
					else
						clickedUnit[1].rotation = cannonRotation
					end
					crosshairLine:setColor( 0, 255, 0, 200 )
					crosshairLine.width = 8
					
				elseif "ended" == phase or "cancelled" == phase then 						-- have this happen after collision is detected.
				display.getCurrentStage():setFocus( nil )
				crosshair.isFocus = false
					
				local stopRotation = function()
					Runtime:removeEventListener( "enterFrame", startRotation )
				end

				-- make a new image
				projectile = display.newImage(obj.img_projectile)
				projectile:scale(clickedUnit.scaleX,clickedUnit.scaleY)
				cballExists = true

				-- move the image
				--print('Parallax.incX' .. Parallax.incX)
				projectile.x = clickedUnit.x
				projectile.y = clickedUnit.y
				projectile.weapon = 5;
				unitGroup:insert(projectile)
				print('unitGroup: ' .. unitGroup.numChildren)


				-- apply physics to the projectile
				physics.addBody( projectile, { density=3.0, friction=0.2, bounce=0.05, radius=15 } )
				projectile.isBullet = true

				-- fire the projectile            
				projectile:applyForce( (event.x - crosshair.x)*forceMultiplier, (event.y - (crosshair.y))*forceMultiplier, clickedUnit.x, clickedUnit.y )
				weaponSFX = audio.loadSound(clickedUnit.sfx)
				weaponSFXed = audio.play(weaponSFX,{channel=2} )
				-- make sure that the cannon is on top of the 
				transitionStash.newTransition = transition.to( crosshair, { alpha=0, xScale=1.0, yScale=1.0, time=0, onComplete=stopRotation} )
				showCrosshair = false									-- helps ensure that only one crosshair appears
				
				if ( crosshairLine ) then	
					crosshairLine.parent:remove( crosshairLine ) -- erase previous line, if any
				end
				
				Runtime:addEventListener('enterFrame', removeballbeyondfloor)
				projectile:addEventListener('collision', removeballcollision)
				
			end

			end
		end
		
		 local deleteBall = function()
			if (cballExists) then
				projectile:removeSelf()
				cballExists = false
				print('ball deleted')
			end
		end
		 
		 removeballbeyondfloor = function()
			 if( projectile) then
				if( projectile.x < floorleft or projectile.x > floorleft + floorwidth) then
					Runtime:removeEventListener('enterFrame', removeballbeyondfloor)
					print('deleting the ball...2')
					deleteBall()
				end      
			end
		end
		removeballcollision = function()
			projectile:removeEventListener('collision', removeballcollision)  -- makes it so it only activates on the first collision
			Runtime:removeEventListener('enterFrame', removeballbeyondfloor)
			print('deleting the ball')
			timerStash.newTimer = timer.performWithDelay(5000, deleteBall, 1)
		end
		 
-- Called when scene is about to move offscreen:
function scene:exitScene( event )
        local group = self.view
        
        -----------------------------------------------------------------------------
        --      INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
        -----------------------------------------------------------------------------
		--Remove the Runtime Listeners
		--scrollGroup:removeEventListener(scroll)
		
		Runtime:removeEventListener('enterFrame',removeballbeyondfloor)
		Runtime:removeEventListener('enterFrame',startRotation)
        
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
		local num = overlayGroup.numChildren;
		while num >= 1 do
			overlayGroup:remove(num)
			num = num - 1
		end
		overlay = nil;
		overlay_activity = nil;
		assertDepth = nil;
		makeCannon = nil;
		createCrosshair = nil;
		startRotation = nil;
		fire = nil;
		stopRotation = nil;
		deleteBall = nil;
		floorleft = nil;
		floorwidth = nil;
		removeballbeyondfloor = nil;
		removeballcollision = nil;
		shiftScene = nil;
		closeView = nil; openView = nil;
		hit = nil;
		
		-- local num = cannonGroup.numChildren;
		for i=1, unitGroup.numChildren do
			if unitGroup[i] ~= nil then
				unitGroup:remove(i)
			end
		end
		unitGroup = nil;		-- Could we just use a remove parent function that will remove the whole group and all it's contents

		for i=1, playerGroup.numChildren do
			if playerGroup[i] ~= nil then
				playerGroup:remove(i)
			end
		end
		 playerGroup = nil;
		 
		 --Nil the Whole Freakin' Overlay
		 Pause.nilEverything()
		 
		 --Cancel All Timers
		 local k, v
		 
		 for k,v in pairs(timerStash) do
			timer.cancel( v )
			v = nil; k = nil
		end
		
		timerStash = nil
		timerStash = {}
		
		--Cancel All Transitions
		local k, v
		
		for k,v in pairs(transitionStash) do
			transition.cancel( v )
			v = nil; k = nil
		end

	 transitionStash = nil
	 transitionStash = {}
		
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