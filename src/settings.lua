settings = {}


settings.onTestBtnRelease = function(event) 
    if (event.phase == 'moved') then
        cannonfire = audio.loadSound("../sound/Single_cannon_shot.wav")
        cannonfired = audio.play(cannonfire,{channel=2})
    end
	return true	-- indicates successful touch
end

settings.onTesterBtnRelease = function(event) 
    if (event.phase == 'moved') then
         music_bg = audio.loadStream("../sound/Bounty 30.ogg")
         o_play = audio.play(music_bg,{channel=3})
    end
	return true	-- indicates successful touch
end

return settings