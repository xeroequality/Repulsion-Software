settings = {}


settings.onTestBtnRelease = function(event) 
    if (event.phase == 'moved') then
        print(event.phase)
        cannonfire = audio.loadSound("../sound/Single_cannon_shot.wav")
        --cannonfired = audio.play(cannonfire,{channel=2} )
        print(cannonfire)
        cannonfired = audio.play(cannonfire,{channel=2})
        print( "hello")
    end
	return true	-- indicates successful touch
end

return settings