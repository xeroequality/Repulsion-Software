local storyboard = require( "storyboard" )
local widget = require( "widget" )
widget.setTheme("theme_ios")
local scene = storyboard.newScene()
 
----------------------------------------------------------------------------------
--      NOTE:
--      Code outside of listener functions (below) will only be executed once,
--      unless storyboard.removeScene() is called.
---------------------------------------------------------------------------------
local backBtn
local testBtn
-- 'onRelease' event listener for playBtn
local function onBackBtnRelease()
	storyboard.gotoScene( "menu_mainmenu", "fade", 200)
	return true	-- indicates successful touch
end
function onTestBtnRelease()
    cannonfire = audio.loadSound("../sound/Single_cannon_shot.wav")
    --cannonfired = audio.play(cannonfire,{channel=2} )
    print(cannonfire)
	cannonfired = audio.play(cannonfire,{channel=2})
    print( "hello")
	return true	-- indicates successful touch
end

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
local mySlider 
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
        
        -----------------------------------------------------------------------------
        --      INSERT code here (e.g. start timers, load audio, start listeners, etc.)
		-----------------------------------------------------------------------------
		backBtn = widget.newButton{
			id="menu_mainmenu",
			labelColor = { default={255}, over={128} },
			default="../images/btn_back.png",
			over="../images/btn_back_pressed.png",
			width=80, height=40,
			onRelease = onBackBtnRelease
		}
		backBtn.view:setReferencePoint( display.CenterReferencePoint )
		backBtn.view.x = display.contentWidth*0.25
		backBtn.view.y = display.contentHeight - 200
		
		group:insert(backBtn.view)
        
		-- Create the slider for the volume control
        local valueVol = display.newText("Your Volume",display.contentWidth *.55,display.contentHeight * 0.55,"Helvetica",16)
          
        local sliderListener1 = function( event )
            id = "Volume";
            local sliderObj1 = event.target;
            valueVol.text=event.target.value;
            print( "New value is: " .. event.target.value )
            audio.setVolume((event.target.value/100),{channel=1})
        end
        -- Create the slider widget
        mySlider1 = widget.newSlider{
            callback=sliderListener1
        }
        -- Center the slider widget on the screen:
        mySlider1.x = display.contentWidth * 0.5
        mySlider1.y = display.contentHeight * 0.5
        -- insert the slider widget into a group:
        group:insert(valueVol)
        group:insert( mySlider1.view)
        
        --Create the slider for Sound Effects Control
        local valueSFX = display.newText("Your Sound Effects",display.contentWidth *.50,display.contentHeight * 0.75,"Helvetica",16)  
        
        local sliderListener2 = function( event )
            id = "Sound Effects";
            local sliderObj2 = event.target;
            valueSFX.text=event.target.value;
            print( "New value is: " .. event.target.value )
            audio.setVolume((event.target.value/100),{channel=2})
        end
        -- Create the slider widget
        mySlider2 = widget.newSlider{
            callback=sliderListener2
        }
        -- Center the slider widget on the screen:
        mySlider2.x = display.contentWidth * 0.5
        mySlider2.y = display.contentHeight * 0.7
        -- insert the slider widget into a group:
        group:insert(valueSFX)
        group:insert( mySlider2.view)
        
         testBtn = widget.newButton{
			id="tester",
			labelColor = { default={255}, over={128} },
			--default="../images/btn_back.png",
			--over="../images/btn_back_pressed.png",
			width=80, height=40,
			onRelease = onTestBtnRelease
		}
		testBtn.view:setReferencePoint( display.CenterReferencePoint )
		testBtn.view.x = display.contentWidth*0.75
		testBtn.view.y = display.contentHeight - 200
		
		group:insert(testBtn.view)


end
 
 
-- Called when scene is about to move offscreen:
function scene:exitScene( event )
        local group = self.view
        
        
        local num = group.numChildren;
		while num >= 1 do
			group:remove(num)
			num = num - 1
		end

        -----------------------------------------------------------------------------
        --      INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
        -----------------------------------------------------------------------------
        
end
 
 
-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
        local group = self.view
        
        -----------------------------------------------------------------------------
        --      INSERT code here (e.g. remove listeners, widgets, save state, etc.)
        -----------------------------------------------------------------------------
		if backBtn then
			backBtn:removeSelf()
			backBtn=nil
		end
        
        if testBtn then
			testBtn:removeSelf()
			testBtn=nil
		end
        
        if mySlider1 then
            mySlider1:removeSelf()
            mySlider1=nil
        end
        
        if mySlider2 then
            mySlider2:removeSelf()
            mySlider2=nil
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