local storyboard = require( "storyboard" )
local levels = require( "levelinfo" )
local widget = require( "widget" )
local scene = storyboard.newScene()

local monitorMem = function()

    collectgarbage()
    print( "MemUsage: " .. collectgarbage("count") )

    local textMem = system.getInfo( "textureMemoryUsed" ) / 1000000
    print( "TexMem:   " .. textMem )
end

--Runtime:addEventListener( "enterFrame", monitorMem )

transitionStash = {}
timerStash = {};

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
local backBtn
local levelBtn = {}

-- 'onRelease' event listener for playBtn
local function onBtnRelease(event)
	local t = event.target
	local label = t.id
	print("released button " .. label)
	storyboard.gotoScene( label, "fade", 200)
	return true
end

function scene:createScene( event )
        local group = self.view
end

function scene:enterScene( event )
        local group = self.view
		
		local W = display.contentWidth
		local H = display.contentHeight
		local offset = (W-320)/6		-- Positions objects, scaled properly
		local space1, space2, earth		-- Background images
		local bounceDown, bounceUp		-- Bouncing button functions
		local openOverlay, closeOverlay -- Overlay open/close functions
		local overlayVars = {
			img = "../images/overlay_grey.png",	-- Overlay image location
			overlay = nil,						-- Overlay display object
			isOpen = false,						-- Boolean for whether overlay is open/closed
			chapter = 1,						-- Current chapter (FOR LATER USE)
			closeBtn = nil,						-- Button to close overlay
			playBtn = nil,						-- Button to select level
			title = nil,						-- Level Info: Title
			desc = nil,							-- Level Info: Description
			parScore = nil,						-- Level Info: Par Score
			wallet = nil						-- Level Info: Wallet
		}
		
		openOverlay = function(event)
			if not overlayVars.isOpen then
				print("opening overlay")
				overlayVars.isOpen = true
				-- Create overlay image
				overlayVars.overlay = display.newImage(overlayVars.img)
				overlayVars.overlay.x = W/2
				overlayVars.overlay.y = H/2
				overlayVars.overlay:scale(0,0)
				group:insert(overlayVars.overlay)
				-- Determine which information to show based on button pressed
				local buttonPressed = event.target.level
				local levelInfo
				if buttonPressed == 1 then
					levelInfo = levels.level1
				elseif buttonPressed == 2 then
					levelInfo = levels.level2
				elseif buttonPressed == 3 then
					levelInfo = levels.level3
				elseif buttonPressed == 4 then
					levelInfo = levels.level4
				elseif buttonPressed == 5 then
					levelInfo = levels.level5
				end
				-- Function to add objects to overlay
				local function buildOverlay(event)
					print("overlay opened")
					-- Close Overlay Button
					overlayVars.closeBtn = widget.newButton{
						default="../images/background_redX.png",
						over="../images/background_redX.png",
						width=30,
						height=30,
						onRelease=closeOverlay
					}
					overlayVars.closeBtn.view.x=overlayVars.overlay.x+overlayVars.overlay.width/2-25
					overlayVars.closeBtn.view.y=overlayVars.overlay.y-overlayVars.overlay.height/2+25
					-- Play Level Button
					overlayVars.playBtn = widget.newButton{
						id="sp_aliens_ch1_level"..buttonPressed,
						default="../images/background_GO.png",
						over="../images/background_GOWhite.png",
						width=140,
						height=87,
						onRelease=onBtnRelease
					}
					overlayVars.playBtn.view.x=overlayVars.overlay.x+overlayVars.overlay.width/4+offset
					overlayVars.playBtn.view.y=overlayVars.overlay.y+overlayVars.overlay.height/4+offset
					-- Title
					overlayVars.title = display.newText(levelInfo.title,0,0,native.systemFont,40)
					overlayVars.title:setReferencePoint(display.CenterLeftReferencePoint)
					overlayVars.title:scale(0.5,0.5)
					overlayVars.title.x = overlayVars.overlay.x-overlayVars.overlay.width/2+offset
					overlayVars.title.y = overlayVars.overlay.y-overlayVars.overlay.height/2+10+offset
					-- Description
					overlayVars.desc = display.newText("Info: "..levelInfo.desc,0,0,native.systemFont,40)
					overlayVars.desc:setReferencePoint(display.CenterLeftReferencePoint)
					overlayVars.desc:scale(0.5,0.5)
					overlayVars.desc.x = overlayVars.overlay.x-overlayVars.overlay.width/2+offset
					overlayVars.desc.y = overlayVars.overlay.y-overlayVars.overlay.height/2+10+2*offset
					-- Par Score
					overlayVars.parScore = display.newText("Par Score: "..levelInfo.parScore,0,0,native.systemFont,40)
					overlayVars.parScore:setReferencePoint(display.CenterLeftReferencePoint)
					overlayVars.parScore:scale(0.5,0.5)
					overlayVars.parScore.x = overlayVars.overlay.x-overlayVars.overlay.width/2+offset
					overlayVars.parScore.y = overlayVars.overlay.y-overlayVars.overlay.height/2+10+3*offset
					-- Wallet
					overlayVars.wallet = display.newText("Bank: $"..levelInfo.wallet,0,0,native.systemFont,40)
					overlayVars.wallet:setReferencePoint(display.CenterLeftReferencePoint)
					overlayVars.wallet:scale(0.5,0.5)
					overlayVars.wallet.x = overlayVars.overlay.x-overlayVars.overlay.width/2+offset
					overlayVars.wallet.y = overlayVars.overlay.y-overlayVars.overlay.height/2+10+4*offset
					
					group:insert(overlayVars.closeBtn.view)
					group:insert(overlayVars.playBtn.view)
					group:insert(overlayVars.title)
					group:insert(overlayVars.desc)
					group:insert(overlayVars.parScore)
					group:insert(overlayVars.wallet)
				end
				-- Scale up overlay display object
				transitionStash.newTransition = transition.to(overlayVars.overlay, {time=500, xScale=1, yScale=1, onComplete=buildOverlay})
			end
		end
		
		closeOverlay = function(event)
			if overlayVars.isOpen then
				print("closing overlay")
				if overlayVars.closeBtn and overlayVars.closeBtn.view then
					overlayVars.closeBtn.view:removeSelf()
					overlayVars.closeBtn.view = nil
					overlayVars.closeBtn = nil
				end
				if overlayVars.playBtn and overlayVars.playBtn.view then
					overlayVars.playBtn.view:removeSelf()
					overlayVars.playBtn.view = nil
					overlayVars.playBtn = nil
				end
				if overlayVars.title then
					overlayVars.title:removeSelf()
					overlayVars.title = nil
				end
				if overlayVars.desc then
					overlayVars.desc:removeSelf()
					overlayVars.desc = nil
				end
				if overlayVars.parScore then
					overlayVars.parScore:removeSelf()
					overlayVars.parScore = nil
				end
				if overlayVars.wallet then
					overlayVars.wallet:removeSelf()
					overlayVars.wallet = nil
				end
				local function removeOverlay(event)
					print("overlay closed")
					overlayVars.isOpen = false
					if overlayVars.overlay then
						overlayVars.overlay:removeSelf()
						overlayVars.overlay = nil
					end
				end
				transitionStash.newTransition = transition.to(overlayVars.overlay, {time=500, xScale=0.05, yScale=0.05, onComplete=removeOverlay})
			end
		end
		
		backBtn = widget.newButton{
			id="menu_sp_main",
			labelColor = { default={255}, over={128} },
			default="../images/btn_back.png",
			over="../images/btn_back_pressed.png",
			width=96, height=32,
			onRelease = onBtnRelease
		}
		backBtn.view:setReferencePoint( display.CenterReferencePoint )
		backBtn.view.x = 30
		backBtn.view.y = H-30
		
		for i= 1,5 do
			levelBtn[i] = widget.newButton{
				id="level"..i,
				labelColor = { default={255}, over={128} },
				default="../images/btn_level"..i..".png",
				over="../images/btn_level"..i..".png",
				width=64, height=64,
				onRelease = openOverlay
			}
			levelBtn[i].view:setReferencePoint( display.CenterReferencePoint )
			levelBtn[i].view.x = 2*offset+(64+offset)*(i-1); levelBtn[i].view.y = 50
			levelBtn[i].level = i
		end

		--Make the Space Backgrounds
		local space1 = display.newImage( "../images/space.png" )
		space1:setReferencePoint ( display.CenterReferencePoint )
		space1.x = 50; space1.y = H/2
		local space2 = display.newImage("../images/space.png" )
		space2:setReferencePoint ( display.CenterReferencePoint )
		space2.x = -W*2+50; space2.y = H/2
		--Make the Earth
		local earth = display.newImageRect("../images/earth_slice.png",600,185)
		earth:setReferencePoint ( display.CenterReferencePoint )
		earth.x = W/2-10; earth.y = H-80;
		
		--Move the Space Backgrounds
		function moveSpace (event)
			if space1.x >= 2*W then
				space1.x = -2*W
			end
			if space2.x >= 2*W then
				space2.x = -2*W
			end
			space1.x = space1.x + 1
			space2.x = space2.x + 1
		end
		
		--Bouncing buttons
		bounceDown = function(event)
			for i=1,5 do
				transitionStash.newTransition = transition.to(levelBtn[i].view, {time=1000, y=levelBtn[i].view.y+10})
			end
			if bounceUp then
				timerStash.newTimer = timer.performWithDelay(1000,bounceUp,1)
			end
		end
		bounceUp = function(event)
			for i=1,5 do
				transitionStash.newTransition = transition.to(levelBtn[i].view, {time=1000, y=levelBtn[i].view.y-10})
			end
			if bounceDown then
				timerStash.newTimer = timer.performWithDelay(1000,bounceDown,1)
			end
		end
		-- Start button bouncing:
		bounceDown()
		
		--Add the Runtime Listeners
		Runtime:addEventListener("enterFrame",moveSpace)
		
		group:insert(space1)
		group:insert(space2)
		group:insert(earth)
		group:insert(backBtn.view)
		for i = 1,5 do
			group:insert(levelBtn[i].view)
		end
end

function scene:exitScene( event )
        local group = self.view
		
		--Remove the Runtime Listeners
		Runtime:removeEventListener("enterFrame",moveSpace)
		Runtime:removeEventListener( "enterFrame", monitorMem )
		
		--Cancel Functions
		openOverlay = nil;
		closeOverlay = nil;
		bounceUp = nil;
		bounceDown = nil;
		
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

function scene:destroyScene( event )
        local group = self.view

		if backBtn then
			backBtn:removeSelf()
			backBtn=nil
		end
		for i = 1,5 do
			if levelBtn[i] then
				levelBtn[i]:removeSelf()
				levelBtn[i]=nil
			end
		end
        
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )
---------------------------------------------------------------------------------
 
return scene