local storyboard 		= require( "storyboard" )
local widget 	 		= require( "widget" )
--local levelUI 	 	= require( "levelUI")
local ScrollView		= require( "module_scrollview" )
local physics			= require( "physics" )
local Parallax			= require( "module_parallax" )
local Materials			= require( "materials" )
local Units  			= require( "units" )
local Enemy				= require( "enemybase" )
local IO	     		= require( "save_and_load" )
local Pause				= require( "pause_overlay" )
local MenuSettings 		= require( "settings" )
local ItemUI		    = require( "module_item_ui" )
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

		-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
		-- Setup Parameters for Parallax View
		-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
		local params = {
			-- Define Desired Level Width, Height, and Group Association
			width = W,
			height = H,
			group = group,
			
			-- Define Background Image Parameters
			background = {
				-- Filename, True Image Width & Height, Starting X, Starting Y, and Speed
				img = "../images/background_chapter1_level1_background.png",
				width = 1500,
				height = H,
				left = 0,
				bottom = H,
				speed = 0.5
			},
			-- Define Foreground (Back) Image Parameters
			midground = {
				-- Filename, True Image Width & Height, Starting X, Starting Y, and Speed
				img = "../images/background_chapter1_level1_foreground_F.png",
				width = 750,
				height = 450,
				left = 0,
				bottom = H,
				speed = 0.6
			},
			-- Define Foreground (Near) Image Parameters
			foreground = {
				-- Filename, True Image Width & Height, Starting X, Starting Y, and Speed
				img = "../images/background_chapter1_level1_foreground_N.png",
				width = 960,
				height = 332,
				left = 0,
				bottom = H,
				speed = 0.7
			}
		}
		
		-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
		-- Instantiate Parallax and Pass-In Parameters
		-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
		background = Parallax.levelScene(params)
		

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
			Materials.glass_sheet,
			Materials.granite_slab,
			Materials.glass_tri,
			Materials.wood_plank_alien,
			Materials.wood_box_alien,
			Materials.aerogel,
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
		
		local levelWallet = 50000; --The Amount of Money for This Level
		wallet = levelWallet; --The Current Amount of Money
		
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
		scrollView = ScrollView.new{
			background="../images/ui_bkg_buildmenu.png",
			top=0,
			bottom=0
		}
		for i=1,#levelObjs do
			scrollView.addItem(levelObjs[i])
		end

		--Overlay Variables
		overlay = false; --Is the Overlay Up?
		overlay_activity = false; --Is There Overlay Animation Going On?
		
		UI.createMenuUI();
		
		--------------------------------------------
		--             	   Slide UI               --				How is this function different than the static menus function??????
		--------------------------------------------		
		UI.createSlideBtn("left",false);
		
		--------------------------------------------
		--               ITEM DRAG                --
		--------------------------------------------
		local focus = 0;
		ItemUI.setFocus(focus);
		

		--------------------------------------------
		--              ITEM SELECT               --
		--------------------------------------------
		-- Event for selecting an item from scrollView
		playerGroup = display.newGroup()
		materialGroup = display.newGroup()
		unitGroup = display.newGroup()
		
		for i=1,#scrollView.items do
			scrollView.items[i].view:addEventListener("touch",ItemUI.pickItem)
		end
		
		--------------------------------------------
		--             STATIC MENUS               --
		--------------------------------------------
		local static_menu = display.newGroup()
		
		group = Pause.createOverlay(group);
		group = Pause.bringMenutoFront(group);

		local function restart_level(event)
			if event.phase == "ended" and restartBtn.alpha > 0 then
				restart()
			end
		end
		local function exit_level(event)
			if event.phase == "ended" and exitBtn.alpha > 0 then
				scrollView.destroy()
				exitNOW()
			end
		end
		
		local save = function(event)
			if event.phase == "ended" and (event.target).alpha > 0 and overlay_section == "Save" then
				IO.save(slot,overlay_section,materialGroup);
				slots[slot].alpha = 1;
				slots[slot+10].alpha = 0;
				local str = Pause.displayPreview(slot);
				menuText.text = str;
				menuText.alpha = 1;
			end
		end
		local load = function(event)
			if event.phase == "ended" and (event.target).alpha > 0 and overlay_section == "Load" then
				materialGroup = IO.load(slot,materialGroup,levelWallet);
				for i = 1,materialGroup.numChildren do
					local child = materialGroup[i];
					if child.child ~= nil then
						child:addEventListener("touch",ItemUI.dragItem);
					end
				end
				focus = materialGroup[1];
				group = Pause.bringMenutoFront(group);
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
			focus = UI.getFocus();
			if focus ~= 0 then
				HPText.text = "This Object's HP is "..focus.maxHP.."\nCost: "..focus.cost.."\nBasicR: "..(focus.resist).basic;
				HPText.text = HPText.text.."\nFireR: "..(focus.resist).fire.."\nWaterR: "..(focus.resist).water.."\nExplosiveR: "..(focus.resist).explosive;
				HPText.text = HPText.text.."\nElectricR: "..(focus.resist).electric;
			end
		end
		Runtime:addEventListener("enterFrame",showHP);

		
		local MONEY = display.newText("You Have $"..wallet,0,0,native.systemFont,12);
		MONEY.x = display.contentWidth/2+60; MONEY.y = 15;
		MONEY:setTextColor(255,0,0)
		MONEY.movy = "Yes";
		
		updateMONEY = function(event)
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
		local objGroup = Enemy.loadBase(Enemy.level1)
		
		group:insert(goodoverlay)
		group:insert(badoverlay)
		group:insert(HPText)
		--group:insert(scrollView)
		-- group:insert(static_menu)
		-- group:insert(slideBtn.view)
		group:insert(materialGroup)
		group:insert(unitGroup)
		--group:insert(projectileGroup)
		--group:insert(cannonGroup)
		group:insert(play_button)
		group:insert(rotate_button)
		group:insert(menu_button)
		group:insert(MONEY)
		group:insert(objGroup)
		-- group:insert(projectile)
		
		group = Pause.bringMenutoFront(group);

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
	Runtime:removeEventListener("enterFrame",updateMONEY)
	Runtime:removeEventListener("enterFrame",showHP)
	
	local num = group.numChildren;
	while num >= 1 do
		group:remove(num)
		num = num - 1
	end
	local num = overlayGroup.numChildren;
	while num >= 1 do
		overlayGroup:remove(num)
		num = num - 1
	end
	group:removeSelf();
	overlayGroup:removeSelf();
	overlay = nil;
	overlay_activity = nil;
	bringMenutoFront = nil;
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
	background = nil;
	focus = nil;
	wallet = nil;
	updateMONEY = nil;
	
	playerGroup = nil; materialGroup = nil; unitGroup = nil;
	
	--if play_button then play_button:removeSelf(); play_button = nil; end
	--if rotate_button then rotate_button:removeSelf(); rotate_button = nil; end
	--if menu_button then menu_button:removeSelf(); menu_button = nil; end
	
	--[[package.loaded["widget"] = nil
	_G["widget"] = nil
	package.loaded["module_scrollview"] = nil
	_G["module_scrollview"] = nil
	package.loaded["physics"] = nil
	_G["physics"] = nil
	package.loaded["module_parallax"] = nil
	_G["module_parallax"] = nil
	package.loaded["materials"] = nil
	_G["materials"] = nil
	package.loaded["units"] = nil
	_G["units"] = nil
	package.loaded["enemybase"] = nil
	_G["enemybase"] = nil
	package.loaded["save_and_load"] = nil
	_G["save_and_load"] = nil
	package.loaded["pause_overlay"] = nil
	_G["pause_overlay"] = nil
	package.loaded["settings"] = nil
	_G["settings"] = nil
	package.loaded["scrollview"] = nil
	_G["scrollview"] = nil
	package.loaded["parallax"] = nil
	_G["parallax"] = nil--]]
	
	--[[local num = cannonGroup.numChildren;
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
	 playerGroup = nil;--]]
	 
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
			scrollView.destroy();
			scrollView = nil
		end
		if rotate_button then
			rotate_button:removeSelf();
			rotate_button = nil;
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