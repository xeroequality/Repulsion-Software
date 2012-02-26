-- example Corona SDK/Lua demo



local cannonBase    = nil
local cannon        = nil
local cannonGroup   = nil

cannonRotation  = 0
rotateAmt       = 5
rotMin          = -40
rotMax          = 80

forceMultiplier = 20
playerPoints    = 0

function update()
    
    -- has the target fallen below the ground?
    if (target.x < 0) then
        scorePoint()
        resetTarget()
    end
end

function onTouch(event)
    print(event.x,event.y)
end

function scorePoint()
    playerPoints = playerPoints + 1
    print(playerPoints)
    scoreDisplay.text = "Points: " .. playerPoints
end

function resetTarget()
    target.bodyType = 'static'      -- turn physics off on the target
    target.x = math.random(10,300)
    target.y = math.random(100,300) + 170
end

function createCrosshair(event) -- creates crosshair when a touch event begins
    -- creates the crosshair
	local phase = event.phase
	print('Cannon touched')
	if (phase == 'began') then
		print('Cannon touched')
		if not (showCrosshair) then										-- helps ensure that only one crosshair appears
		print('show crosshair')
			crosshair = display.newImage( "crosshair.png" )				-- prints crosshair	
			crosshair.x = 60
			crosshair.y = 320
			showCrosshair = transition.to( crosshair, { alpha=1, xScale=0.5, yScale=0.5, time=200 } )
			crosshair.rotation = nil
			startRotation = function()
				crosshair.rotation = crosshair.rotation + 4
			end
			Runtime:addEventListener( "enterFrame", startRotation )
		end
	end
	interface:insert(crosshair)
    crosshair:addEventListener('touch',fire)
end

function fire( event )
	local phase = event.phase
	if "began" == phase then
		print('crosshair touched')
		print ('crosshair.x = ')
		print (crosshair.x)
		print ('crosshair.y = ')
		print (crosshair.y)
		print ('event.x = ')
		print (event.x)
		print ('event.y = ')
		print (event.y)
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
			crosshairLine:setColor( 255, 255, 255, 50 )
			crosshairLine.width = 4
			--cannonLine = display.newLine( cannon.x,cannon.y, event.x-cannon.x,event.y-cannon.y ) -- draws the line for the cannon
			--cannonLine:setColor( 255, 255, 255, 50 )
			--cannonLine.width = 8
				--cannon.rotation =(-event.x),(-event.y)
				--transition.to( cannon, { rotation =  crosshair.x - event.x, crosshair.y - event.y, time = 0} )
			
		elseif "ended" == phase or "cancelled" == phase then 						-- have this happen after collision is detected.
		display.getCurrentStage():setFocus( nil )
			crosshair.isFocus = false
			
			local stopRotation = function()
				Runtime:removeEventListener( "enterFrame", startRotation )
			end

        -- make a new image
        bullet = display.newImage('cannonball.png')             
        
        -- determine a point along the cannon barrel in world coordinates
        --cannon.x, cannon.y = cannonBarrel:localToContent(70,0)
        
        -- move the image
        bullet.x = 70
        bullet.y = 140
        
        -- apply physics to the cannonball
        physics.addBody( bullet, { density=3.0, friction=0.2, bounce=0.05, radius=15 } )
        

		print ('event.x = ')
		print (event.x)
		print ('event.y = ')
		print (event.y)
		-- fire the cannonball            
			bullet:applyForce( (event.x - crosshair.x)*forceMultiplier, (event.y - (crosshair.y+105))*forceMultiplier, bullet.x, bullet.y )

        -- make sure that the cannon is on top of the 
        --cannonGroup:toFront()
		local hideCrosshair = transition.to( crosshair, { alpha=0, xScale=1.0, yScale=1.0, time=0, onComplete=stopRotation} )
			showCrosshair = false									-- helps ensure that only one crosshair appears
		
		if ( crosshairLine ) then
			crosshairLine.parent:remove( crosshairLine ) -- erase previous line, if any
			--cannonLine.parent:remove( cannonLine ) -- erase previous line, if any
		end
    end
	end
	-- Stop further propagation of touch event
	--return true
end

-- this function creates the interface- buttons for moving the cannon and firing
-- as well as the display of points
function makeInterface()
    interface = display.newGroup()
    
    interface.rotation = 90
    interface:translate(300,5)
    
    display.getCurrentStage():insert(interface)
    
    scoreDisplay = display.newText( ("Points: " .. playerPoints), 0, 0, native.systemFont, 40 )
    scoreDisplay.rotation = 90
    scoreDisplay.x = display.contentWidth - 40
    scoreDisplay.y = display.contentHeight - 100
    scoreDisplay:setTextColor( 255,255,255 )
end

function makeCannon()
    -- create a couple of display groups
    cannonGroup = display.newGroup()
    cannonBarrel = display.newGroup()

    -- load the images
    cannon      = display.newImage('cannon_sm.png')
    cannonBase  = display.newImage('cannon_base_sm.png')
    
    -- use a separate group to offset the registration point of the barrel
    interface:insert(cannonGroup) -- makes cannon touchable, must go before the cannon barrel or translate doesn't work
	cannonBarrel:insert(cannon)
    cannon:translate(-52,-30)
    
    cannonBarrel:translate(60,0)
    cannonGroup:insert(cannonBarrel)
    cannonGroup:insert(cannonBase)
    
    -- rotate and move the cannon to the bottom-left corner
    cannonGroup.rotation = 90
    cannonGroup:translate(70,50)
    
    -- add the cannon to the stage
    display.getCurrentStage():insert(cannonGroup)
	showCrosshair = false 										-- helps ensure that only one crosshair appears
	cannonGroup:addEventListener('touch',createCrosshair)

    
end

function onCollide(event)
    -- make the target active, so that it falls
    -- actually resetting of the target happens n the update function
    target.bodyType = 'dynamic'
end

function init()
    display.setStatusBar(display.HiddenStatusBar)
    
    physics = require('physics')
    physics.start()
    physics.setGravity(-9.81, 0) 

    background  = display.newImage('brick_back.png',0,0,true)
    
    makeInterface()
    makeCannon()    
    
    target = display.newImage('target.png')
    physics.addBody(target,{ density=3.0, friction=0.5, bounce=0.05, radius=30})
    target.bodyType = 'static'
    target:addEventListener('collision',onCollide)
    
    resetTarget()
    
    Runtime:addEventListener('enterFrame',update)
    -- Runtime:addEventListener('touch',onTouch)
end

init()