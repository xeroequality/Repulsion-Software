----------------------------------------------------------
-- module_overlay.lua
-- Contains table for creating/using 'buildable' overlay
----------------------------------------------------------

local Overlays = {
	good = {
		hasGood = false,
		x = 0,
		y = 0,
		width = 0,
		height = 0,
		alpha = 0,
		view = nil
	},
	bad = {
		hasBad = false,
		x = 0,
		y = 0,
		width = 0,
		height = 0,
		alpha = 0,
		view = nil
	},
}

Overlays.setGood = function(gTable)
	Overlays.good.hasGood = true
	Overlays.good.x = gTable.x
	Overlays.good.y = gTable.y
	Overlays.good.width = gTable.width
	Overlays.good.height = gTable.height
	Overlays.good.alpha = gTable.alpha
	Overlays.good.view = display.newRect(Overlays.good.x,Overlays.good.y-Overlays.good.height/2,Overlays.good.width,Overlays.good.height)
	Overlays.good.view:setFillColor(0,255,0)
	Overlays.good.view.alpha = Overlays.good.alpha
	Overlays.good.view.isVisible = false
end

Overlays.setBad = function(bTable)
	Overlays.bad.hasBad = true
	Overlays.bad.x = bTable.x
	Overlays.bad.y = bTable.y
	Overlays.bad.width = bTable.width
	Overlays.bad.height = bTable.height
	Overlays.bad.alpha = bTable.alpha
	Overlays.bad.view = display.newRect(Overlays.bad.x,Overlays.bad.y-Overlays.bad.height/2,Overlays.bad.width,Overlays.bad.height)
	Overlays.bad.view.isVisible = false
	Overlays.bad.view:setFillColor(255,0,0)
	Overlays.bad.view.alpha = Overlays.bad.alpha
end

Overlays.show = function()
	-- "good" (green) overlay
	local good = Overlays.good
	if good.hasGood then
		-- If there is already a good overlay (hidden), make it visible
		if good.view ~= nil and not good.view.isVisible then
			Overlays.good.view.isVisible = true
		else
		-- If there is not an overlay yet, make one
			Overlays.good.view = display.newRect(good.x,good.y-good.height/2,good.width,good.height)
			Overlays.good.view:setFillColor(0,255,0)
			Overlays.good.view.alpha = good.alpha
		end
	end
	-- "bad" (red) overlay
	local bad = Overlays.bad
	if bad.hasBad then
		-- If there is already a bad overlay (hidden), make it visible
		if bad.view ~= nil and not bad.view.isVisible then
			Overlays.bad.view.isVisible = true
		else
		-- If there is not an overlay yet, make one
			Overlays.bad.view = display.newRect(bad.x,bad.y-bad.height/2,bad.width,bad.height)
			Overlays.bad.view:setFillColor(255,0,0)
			Overlays.bad.view.alpha = bad.alpha
		end
	end
end

Overlays.hide = function()
	if Overlays.good.hasGood and Overlays.good.view then
		Overlays.good.view.isVisible = false
	end
	if Overlays.bad.hasBad and Overlays.bad.view  then
		Overlays.bad.view.isVisible = false
	end
end

Overlays.destroy = function()
	if Overlays.good.hasGood then
		Overlays.good.hasGood = false
		Overlays.good.view:removeSelf()
	end
	if Overlays.bad.hasBad then
		Overlays.bad.hasBad = false
		Overlays.bad.view:removeSelf()
	end
end

return Overlays