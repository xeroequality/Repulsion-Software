----------------------------------------------------------
-- module_scrollview.lua
-- Contains table for creating a scrollView object
----------------------------------------------------------
local sv = require( "scrollview" )
local W = display.contentWidth
local H = display.contentHeight

ScrollView = {
	scrollview = nil,
	isOpen = false,
	bkgView = nil,
	bounds = {
		top = 0,
		bottom = 0,
	},
	numItems = 0,
	items = {}
}

ScrollView.new = function(svTable)
	local ScrollView = ScrollView
	ScrollView.isOpen = true
	ScrollView.bkgView = display.newImage(svTable.background)
	ScrollView.bkgView.x = 0
	ScrollView.bkgView.y = H*1.5
	ScrollView.bounds.top = svTable.top
	ScrollView.bounds.bottom = svTable.bottom
	ScrollView.scrollview = sv.new{top=ScrollView.bounds.top, bottom=ScrollView.bounds.bottom}
	ScrollView.scrollview:insert(ScrollView.bkgView)
	return ScrollView
end
ScrollView.addItem = function(itemTable)
	local item = {}
	item.view = display.newImage(itemTable.img)
	item.view.id = itemTable.id
	item.view.x = 0
	item.view.y = 50+(ScrollView.numItems)*100
	item.textView = display.newText(itemTable.text,0,0,native.systemFont,28)
	item.textView:setTextColor(0)
	item.textView:scale(0.5,0.5)
	item.textView.x = 0
	item.textView.y = 50+(ScrollView.numItems)*100
	ScrollView.numItems = ScrollView.numItems + 1
	ScrollView.items[ScrollView.numItems] = item
	ScrollView.scrollview:insert(ScrollView.items[ScrollView.numItems].view)
	ScrollView.scrollview:insert(ScrollView.items[ScrollView.numItems].textView)
end
ScrollView.destroy = function()
	for i=1,#ScrollView.items do
		ScrollView.items[i].view:removeSelf()
		ScrollView.items[i].view = nil
		ScrollView.items[i].textView:removeSelf()
		ScrollView.items[i].textView = nil
		ScrollView.items[i] = nil
	end
	ScrollView.bkgView:removeSelf()
	ScrollView.bkgView = nil
end

return ScrollView