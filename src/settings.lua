settings = {}


settings.onTestBtnRelease = function(event) 
    if (event.phase == 'moved') then
        cannonfire = audio.loadSound("../sound/Single_cannon_shot.wav")
        --cannonfired = audio.play(cannonfire,{channel=2} )
        cannonfired = audio.play(cannonfire,{channel=2})
    end
	return true	-- indicates successful touch
end

return settings