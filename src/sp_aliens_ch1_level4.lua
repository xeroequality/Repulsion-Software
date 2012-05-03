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
storyboard.currentLevel = {1,4}

----------------------------------------------------------------------------------
--      NOTE:
--      Code outside of listener functions (below) will only be executed once,
--      unless storyboard.removeScene() is called.
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local function restart(event)
	storyboard.labelFile = "sp_aliens_ch1_level4"
	print("released button " .. storyboard.labelFile)
	storyboard.gotoScene ( "levelrestarter", "zoomInOutFade", 200 )
	return true	-- indicates successful touch
end

local function exitLevel(event)
	-- Notify consle we're leaving, then leave...
	print("Exiting Level...")
	storyboard.gotoScene("loading_exitLevel", "zoomInOutFade", 500)
	return true	-- indicates successful touch
end
 
-- Called when the scene's view does not exist:
function scene:createScene( event )
        local group = self.view
		physics.start()
		--physics.setDrawMode("hybrid")
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
		level = {}
		function entireLevel()
		
			local prev_music = audio.loadStream("../sound/O Fortuna.mp3")
			music_bg = audio.loadStream("../sound/Bounty 30.ogg")
			audio.fadeOut(prev_music, { time=5000 })
			o_play = audio.play(music_bg, {channel=3,fadein=5000,loops=-1 } )
			
			-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
			-- Setup Parameters for Parallax View
			-- -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
			level.params = {
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
					img = "../images/background/statue_of_liberty.png",
					width = 750,
					height = 450,
					left = 0,
					bottom = H,
					speed = 0.6
				},
				-- Define Foreground (Near) Image Parameters
				foreground = {
					-- Filename, True Image Width & Height, Starting X, Starting Y, and Speed
					img = "../images/background/ny_skyline.png",
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
			background = Parallax.levelScene(level.params)
			
			--------------------
			-- Material Objects
			--------------------

			level.levelObjs = { -- Use this to choose what is items are available in this level
				Materials.wood_plank_alien,
				Materials.wood_box_alien,
				Materials.aerogel,
				Units.repulsionBall,
				Units.energyBall,
			}
			print ('levelObjs: ' .. #level.levelObjs)

			---------
			-- Floor
			---------
			level.floorleft = -5*W
			level.floorwidth = 11*W
			Units.setFlr(level.floorleft, level.floorwidth)
			level.floor = display.newRect(level.floorleft,H-10,level.floorwidth,100)
			level.floor:setFillColor(0)
			local floorCollisionFilter = { categoryBits = 1 }
			physics.addBody(level.floor, "static", {friction=0.9, bounce=0.05, filter=floorCollisionFilter} )
			group:insert(level.floor)
			
			levelWallet = require("levelinfo")[1][4].wallet 	--The Amount of Money for This Level [chapter][level].wallet
			wallet = levelWallet 								--The Current Amount of Money
			
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
			for i=1,#level.levelObjs do
				scrollView.addItem(level.levelObjs[i])
			end

			--Overlay Variables
			overlay = false; --Is the Overlay Up?
			overlay_activity = false; --Is There Overlay Animation Going On?
			
			UI.createMenuUI();
			
			--------------------------------------------
			--             	   Slide UI               --
			--------------------------------------------		
			UI.createSlideBtn("left",false);
			
			--------------------------------------------
			--               ITEM DRAG                --
			--------------------------------------------
			local focus = 0;
			ItemUI.setFocus(focus);
			group = Pause.createOverlay(group)

			--------------------------------------------
			--              ITEM SELECT               --
			--------------------------------------------
			-- Event for selecting an item from scrollView
			-- playerGroup = display.newGroup()  -- Could be used later to hold all of the players objects
			materialGroup = display.newGroup()
			unitGroup = display.newGroup()
			group:insert(materialGroup)
			group:insert(unitGroup)
			
			for i=1,#scrollView.items do
				scrollView.items[i].view:addEventListener("touch",ItemUI.pickItem)
			end
			
			--------------------------------------------
			--             STATIC MENUS               --
			--------------------------------------------
			local function terminator()
				Pause.destroy()
				Overlays.destroy()
				Enemy.destroy()
				Score.CurrentScore = 0
				Achievements.destroyImage()
				local tmp = materialGroup.numChildren
				while tmp >= 1 do
					materialGroup:remove(tmp)
					tmp = tmp - 1
				end
				materialGroup = display.newGroup()
				tmp = unitGroup.numChildren
				while tmp >= 1 do
					unitGroup:remove(tmp)
					tmp = tmp - 1
				end
			end
			
			local function restart_level(event)
				if event.phase == "ended" and Pause.restartBtn.alpha > 0 then
					terminator()
					unitGroup = display.newGroup()
					restart(event)
				end
			end
			
			local function exit_level(event)
				if event.phase == "ended" and Pause.exitBtn.alpha > 0 then
					terminator()
					exitLevel(event)
				end
			end
			
			level.ended = false
			local function end_game(event)
				if level.ended == true then
					Runtime:removeEventListener("enterFrame",end_game)
					Achievements.destroyImage()
					local tmp = materialGroup.numChildren
					while tmp >= 1 do
						materialGroup:remove(tmp)
						tmp = tmp - 1
					end
					materialGroup = display.newGroup()
					tmp = unitGroup.numChildren
					while tmp >= 1 do
						unitGroup:remove(tmp)
						tmp = tmp - 1
					end
					Enemy.destroy()
					exitLevel()
				end
			end
			Runtime:addEventListener("enterFrame", end_game)
			
			local save = function(event)
				if event.phase == "ended" and (event.target).alpha > 0 and Pause.overlay_section == "Save" then
					IO.save(Pause.params.slot,Pause.overlay_section);
					slots[Pause.params.slot].alpha = 1;
					slots[Pause.params.slot+10].alpha = 0;
					local str = Pause.displayPreview(Pause.params.slot);
					Pause.menuText.text = str;
					Pause.menuText.alpha = 1;
				end
			end
			local load = function(event)
				if event.phase == "ended" and (event.target).alpha > 0 and Pause.overlay_section == "Load" then
					IO.load(Pause.params.slot,levelWallet);
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
			
			Pause.restartBtn:addEventListener("touch",restart_level);
			Pause.exitBtn:addEventListener("touch",exit_level);
			Pause.overwriteBtn:addEventListener("touch",save);
			Pause.loadCBtn:addEventListener("touch",load);
			
			
			
			--Focus HP
			level.HPText = display.newText("",0,0,native.systemFont,32);
			level.HPText:scale(0.5,0.5)
			level.HPText.x = display.contentWidth/2+120; level.HPText.y = 100; level.HPText:setTextColor(0);
			group:insert(level.HPText)
			local function showHP(event)
				focus = UI.getFocus();
				if focus ~= 0 then
					level.HPText.text = "This Object's HP is "..focus.maxHP.."\nCost: "..focus.cost.."\nBasicR: "..(focus.resist).basic;
					level.HPText.text = level.HPText.text.."\nFireR: "..(focus.resist).fire.."\nWaterR: "..(focus.resist).water.."\nExplosiveR: "..(focus.resist).explosive;
					level.HPText.text = level.HPText.text.."\nElectricR: "..(focus.resist).electric;
				end
			end
			Runtime:addEventListener("enterFrame",showHP);
			
			----COLLISION function in module_item.ui.lua file now-------------
			
			level.MONEY = display.newText("You Have $"..wallet,0,0,native.systemFont,24);
			level.MONEY:scale(0.5,0.5)
			level.MONEY.x = display.contentWidth/2+60; level.MONEY.y = 15;
			level.MONEY:setTextColor(255,0,0)
			level.MONEY.movy = "Yes";
			group:insert(level.MONEY)
			
			local updateMONEY = function(event)
				level.MONEY.text = "You Have $"..wallet;
			end
			Runtime:addEventListener("enterFrame",updateMONEY)
			
			level.SCORE = display.newText("Score: 0",0,0,native.systemFont,24);
			level.SCORE:scale(0.5,0.5)
			level.SCORE.x = display.contentWidth/2+60; level.SCORE.y = 30;
			level.SCORE.movy = "Yes";
			group:insert(level.SCORE)
			
			local updateSCORE = function(event)
				local s = Score.getScore();
				level.SCORE.text = "Score: "..s;
			end
			Runtime:addEventListener("enterFrame",updateSCORE);
			
			-----------------------------
			-- Load the enemy base:
			----------------------------
			local objGroup = Enemy.loadBase(Enemy.level4)
			group:insert(objGroup)
			
			
			group:insert(materialGroup)
			group:insert(unitGroup)
			
			group = Pause.bringMenutoFront(group);
			
			--Runtime for Achievement Checking
			Runtime:addEventListener("enterFrame",Achievements.checkAchievements);
		end
			
		entireLevel()

end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	--      INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	-----------------------------------------------------------------------------
	--Remove the Runtime Listeners
	Runtime:removeEventListener('enterFrame',removeballbeyondfloor)
	Runtime:removeEventListener('enterFrame',startRotation)
--	Runtime:removeEventListener("enterFrame",end_game)
	Runtime:removeEventListener("enterFrame",updateMONEY)
	Runtime:removeEventListener("enterFrame",updateSCORE);
	Runtime:removeEventListener("enterFrame",showHP)
	Runtime:removeEventListener("enterFrame",Achievements.checkAchievements);
	
	--Pause.overlayGroup:removeSelf()
	
	--[[
	level.floor:removeSelf()
	]]
	level.HPText:removeSelf()
	level.MONEY:removeSelf()
	level.SCORE:removeSelf()
	
	 
	--Cancel All Timers
	for k,v in pairs(timerStash) do
		timer.cancel( v )
		v = nil; k = nil
	end
	timerStash = {}
	
	--Cancel All Transitions
	for k,v in pairs(transitionStash) do
		transition.cancel( v )
		v = nil; k = nil
	end
	transitionStash = {}
		
		
	if scrollView ~= nil then scrollView.destroy() end
	--[[
	if UI.rotate_button ~= nil then UI.rotate_button:removeSelf() end
	if UI.menu_button ~= nil then UI.menu_button:removeSelf()  end
	if UI.play_button ~= nil then UI.play_button:removeSelf() end
	]]
	if slideBtn ~= nil then slideBtn:removeSelf() end
	
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