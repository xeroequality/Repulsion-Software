local storyboard 		= require( "storyboard" )
local widget 	 		= require( "widget" )
local ScrollView		= require( "module_scrollview" )
local physics			= require( "physics" )
local Parallax			= require( "module_parallax" )
local Overlays 			= require( "module_overlays" )
local Materials			= require( "materials" )
local Units  			= require( "units" )
local Enemy				= require( "enemybase" )
local IO	     		= require( "save_and_load" )
local Pause				= require( "pause_overlay" )
local MenuSettings 		= require( "settings" )
local ItemUI		    = require( "module_item_ui" )
	  Score				= require( "scoring" )
      Achievements		= require( "achievements" )
local scene 	 		= storyboard.newScene()

widget.setTheme("theme_ios")	
transitionStash = {}	  	
timerStash = {};
local music_bg;

----------------------------------------------------------------------------------
--      NOTE:
--      Code outside of listener functions (below) will only be executed once,
--      unless storyboard.removeScene() is called.
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local function restart(event)
	
	
	storyboard.labelFile = "sp_aliens_ch1_level2"
	print("released button " .. storyboard.labelFile)
	storyboard.gotoScene ( "levelrestarter", "zoomInOutFade", 200 )
	return true	-- indicates successful touch

end
 
-- Called when the scene's view does not exist:
function scene:createScene( event )
        local group = self.view
		physics.start()
		-- physics.setDrawMode("hybrid")

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
		local W = display.contentWidth
		local H = display.contentHeight
        
        -----------------------------------------------------------------------------
        -- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
		-----------------------------------------------------------------------------
		
		--------------------------------------------
		--                PRESETS                 --
		--------------------------------------------
		local prev_music = audio.loadStream("../sound/O Fortuna.mp3")
        music_bg = audio.loadStream("../sound/Bounty 30.ogg")
        audio.fadeOut(prev_music, { time=5000 })
        o_play = audio.play(music_bg, {channel=3,fadein=5000,loops=-1 } )
		--------------------
		-- Material Objects
		--------------------

		local levelObjs = { -- Use this to choose what is items are available in this level
			Materials.wood_plank_alien,
			Materials.wood_box_alien,
			Units.energyBall
		}
		print ('levelObjs: ' .. #levelObjs)

		---------
		-- Floor
		---------
		local floorleft = -5*W
		local floorwidth = 11*W
		Units.setFlr(floorleft, floorwidth)
		local floor = display.newRect(floorleft,H-10,floorwidth,100)
		floor:setFillColor(0)
		local floorCollisionFilter = { categoryBits = 1 }
		physics.addBody(floor, "static", {friction=0.9, bounce=0.05, filter=floorCollisionFilter} )
		group:insert(floor)
		
		levelWallet = 2000; --The Amount of Money for This Level
		wallet = levelWallet; --The Current Amount of Money
		
		--------------------------------------------
		--              Overlays                  --
		--------------------------------------------
		Overlays.setGood{
			x=-100,
			y=H/2,
			width=500,
			height=H,
			alpha=0.25
		}
		Overlays.setBad{
			x=400,
			y=H/2,
			width=1100,
			height=H,
			alpha=0.25
		}
		Overlays.show()
		group:insert(Overlays.good.view)
		group:insert(Overlays.bad.view)
		UI.setOverlayModule(Overlays)
		
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
		group = Pause.createOverlay(group);

		--------------------------------------------
		--              ITEM SELECT               --
		--------------------------------------------
		-- Event for selecting an item from scrollView
		-- playerGroup = display.newGroup()  -- Could be used later to hold all of the players objects
		materialGroup = display.newGroup()
		unitGroup = display.newGroup()
		-- group:insert(materialGroup);
		-- group:insert(unitGroup);
		
		for i=1,#scrollView.items do
			scrollView.items[i].view:addEventListener("touch",ItemUI.pickItem)
		end
		
		--------------------------------------------
		--             STATIC MENUS               --
		--------------------------------------------
		--local static_menu = display.newGroup()
		
		local function restart_level(event)
			if event.phase == "ended" and restartBtn.alpha > 0 then
				restart(event)
			end
		end
		
		local function exit_level(event)
			if event.phase == "ended" and exitBtn.alpha > 0 then
				-- Notify consle we're leaving, then leave...
				print("Exiting Level...")
				storyboard.gotoScene("loading_exitLevel", "zoomInOutFade", 500)
				return true	-- indicates successful touch
			end
		end
		
		local save = function(event)
			if event.phase == "ended" and (event.target).alpha > 0 and overlay_section == "Save" then
				IO.save(slot,overlay_section);
				slots[slot].alpha = 1;
				slots[slot+10].alpha = 0;
				local str = Pause.displayPreview(slot);
				menuText.text = str;
				menuText.alpha = 1;
			end
		end
		local load = function(event)
			if event.phase == "ended" and (event.target).alpha > 0 and overlay_section == "Load" then
				IO.load(slot,levelWallet);
				--Add Listeners to New Materials
				for i = 1,materialGroup.numChildren do
					local child = materialGroup[i];
					if child.child ~= nil then
						child:addEventListener("touch",ItemUI.dragItem);
					end
				end
				--Add Listeners to New Unit
				for i = 1,unitGroup.numChildren do
					local child = unitGroup[i];
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
		
        ----COLLISION function in module_item.ui.lua file now-------------
		
		local MONEY = display.newText("You Have $"..wallet,0,0,native.systemFont,12);
		MONEY.x = display.contentWidth/2+60; MONEY.y = 15;
		MONEY:setTextColor(255,0,0)
		MONEY.movy = "Yes";
		
		updateMONEY = function(event)
			MONEY.text = "You Have $"..wallet;
		end
		Runtime:addEventListener("enterFrame",updateMONEY)
		
		local SCORE = display.newText("Score: 0",0,0,native.systemFont,12);
		SCORE.x = display.contentWidth/2+60; SCORE.y = 30;
		SCORE.movy = "Yes";
		
		updateSCORE = function(event)
			local s = Score.getScore();
			SCORE.text = "Score: "..s;
		end
		Runtime:addEventListener("enterFrame",updateSCORE);
		
		-- In future levels, the ONLY thing that needs to change is the first line:
		local objGroup = Enemy.loadBase(Enemy.level2)
		
		--group:insert(goodoverlay)
		--group:insert(badoverlay)
		group:insert(HPText)
		--group:insert(scrollView)
		-- group:insert(static_menu)
		-- group:insert(slideBtn.view)
		group:insert(materialGroup)
		group:insert(unitGroup)
		--group:insert(projectileGroup)
		--group:insert(cannonGroup)
		-- group:insert(play_button)
		-- group:insert(rotate_button)
		-- group:insert(menu_button)
		group:insert(MONEY)
		group:insert(SCORE)
		group:insert(objGroup)
		-- group:insert(projectile)
		
		group = Pause.bringMenutoFront(group);
		
		--Runtime for Achievement Checking
		Runtime:addEventListener("enterFrame",Achievements.checkAchievements);

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
	Runtime:removeEventListener("enterFrame",updateSCORE);
	Runtime:removeEventListener("enterFrame",showHP)
	Runtime:removeEventListener("enterFrame",Achievements.checkAchievements);
	
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
	group:removeSelf()
	overlayGroup:removeSelf()
	overlay = nil
	overlay_activity = nil
	bringMenutoFront = nil
	makeCannon = nil
	createCrosshair = nil
	startRotation = nil
	fire = nil
	stopRotation = nil
	deleteBall = nil
	floorleft = nil
	floorwidth = nil
	removeballbeyondfloor = nil
	removeballcollision = nil
	shiftScene = nil
	closeView = nil
	openView = nil
	hit = nil
	background = nil
	focus = nil
	wallet = nil
	levelWallet = nil
	updateMONEY = nil
	-- playerGroup = nil
	materialGroup = nil
	unitGroup = nil
	Score = nil;
	
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
		
		
	if (scrollView ~= nil) then scrollView.destroy(); scrollView = nil end
	if (rotate_button ~= nil) then rotate_button:removeSelf(); rotate_button = nil end
	if (menu_button ~= nil) then menu_button:removeSelf(); menu_button = nil end
	if (play_button ~= nil) then play_button:removeSelf(); play_button = nil end
	if (slideBtn ~= nil) then slideBtn:removeSelf(); slideBtn = nil end
	
	print("ExitScene Finished")
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