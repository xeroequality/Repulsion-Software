-- 
-- Abstract: Scroll View sample app
--  
-- Version: 1.0
-- 
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
--
-- Demonstrates how to make text and graphics move up and down on touch,
-- or scroll, using the scrollView.lua methods.

display.setStatusBar( display.HiddenStatusBar ) 

--import the scrolling classes
local scrollView = require("scrollView")
local util = require("util")

local background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
background:setFillColor(140, 140, 140)

-- Setup a scrollable content group
local topBoundary = display.screenOriginY
local bottomBoundary = display.screenOriginY
local scrollView = scrollView.new{ top=topBoundary, bottom=bottomBoundary }

local myText = display.newText("Move Up to Scroll", 0, 0, native.systemFontBold, 16)
myText:setTextColor(0, 0, 0)
myText.x = math.floor(display.contentWidth*0.5)
myText.y = 48
scrollView:insert(myText)

-- add some text to the scrolling screen
local lotsOfText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur imperdiet consectetur euismod. Phasellus non ipsum vel eros vestibulum consequat. Integer convallis quam id urna tristique eu viverra risus eleifend.\n\nAenean suscipit placerat venenatis. Pellentesque faucibus venenatis eleifend. Nam lorem felis, rhoncus vel rutrum quis, tincidunt in sapien. Proin eu elit tortor. Nam ut mauris pellentesque justo vulputate convallis eu vitae metus. Praesent mauris eros, hendrerit ac convallis vel, cursus quis sem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque fermentum, dui in vehicula dapibus, lorem nisi placerat turpis, quis gravida elit lectus eget nibh. Mauris molestie auctor facilisis.\n\nCurabitur lorem mi, molestie eget tincidunt quis, blandit a libero. Cras a lorem sed purus gravida rhoncus. Cras vel risus dolor, at accumsan nisi. Morbi sit amet sem purus, ut tempor mauris.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur imperdiet consectetur euismod. Phasellus non ipsum vel eros vestibulum consequat. Integer convallis quam id urna tristique eu viverra risus eleifend.\n\nAenean suscipit placerat venenatis. Pellentesque faucibus venenatis eleifend. Nam lorem felis, rhoncus vel rutrum quis, tincidunt in sapien. Proin eu elit tortor. Nam ut mauris pellentesque justo vulputate convallis eu vitae metus. Praesent mauris eros, hendrerit ac convallis vel, cursus quis sem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque fermentum, dui in vehicula dapibus, lorem nisi placerat turpis, quis gravida elit lectus eget nibh. Mauris molestie auctor facilisis.\n\nCurabitur lorem mi, molestie eget tincidunt quis, blandit a libero. Cras a lorem sed purus gravida rhoncus. Cras vel risus dolor, at accumsan nisi. Morbi sit amet sem purus, ut tempor mauris. "

local lotsOfTextObject = util.wrappedText( lotsOfText, 39, 14, native.systemFont, {0,0,0} )
scrollView:insert(lotsOfTextObject)
lotsOfTextObject.x = 24
lotsOfTextObject.y = math.floor(myText.y + myText.height)

-- Important! Add a background to the scroll view for a proper hit area
local scrollBackground = display.newRect(0, 0, display.contentWidth, scrollView.height+64)
scrollBackground:setFillColor(255, 255, 255)
scrollView:insert(1, scrollBackground)

scrollView:addScrollBar()
