--loadingScreen.lua
--  This file provides the image that is displayed while something is loading,
--    particularly a level.
--  Need to figure out if any other code is needed to pass the actual level
--    once it has finished loading.

local bgImage = display.newImage( "../images/loadingScreen_image.png")
		bgImage.x = display.contentWidth / 2
		bgImage.y = display.contentHeight /2

		
-- ok,  so what next?		