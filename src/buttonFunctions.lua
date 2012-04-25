--Button Functions

function restart(event)
	local label = "sp_aliens_ch1_level1"
	print("released button " .. label)
	storyboard.gotoScene( label, "zoomInOutFade", 200)
	return true	-- indicates successful touch

end
function exitNOW(event)
	local label = "menu_sp_aliens_levelselect"
	print("released button " .. label)
	storyboard.gotoScene( label, "zoomInOutFade", 200)
	return true	-- indicates successful touch
end