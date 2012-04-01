--Saving and Loading Functions

save_and_load = {}

		--local successText = display.newText("",50,10,native.systemFont,20);
		--local successTime = 0; --Time for the Text to Stay Up
		--local maxSuccessTime = 60; --How Long Does It Stay Up?

save_and_load.save = function(slot,overlay_section,group)
	if true then
		if true and overlay_section == "Save" then
			local index = 1;
			local xvals = {}; local yvals = {}; local num = 0; local rotation = {}; local types = {}; local scX = {}; local scY = {};
			--Get Total Cost
			local total = 0;
			for i = 1, group.numChildren do
				local child = group[i];
				if child.child ~= nil then
					--Save the Structure
					num = num + 1;
					xvals[index] = child.x+group[1].x;
					yvals[index] = child.y;
					rotation[index] = child.rotation;
					types[index] = child.id;
					scX[index] = child.xScale;
					scY[index] = child.yScale;
					index = index + 1;
					total = total + child.cost;
				end
			end
			print(index)
			--Save the Structure
			--Get the BaseX
			local basX = 0;
			local mini = xvals[1];
			for i = 2, #xvals do
				if xvals[i] < mini then mini = xvals[i] end
			end
			basX = mini;
			for i = 1, #xvals do
				xvals[i] = xvals[i] - mini;
			end
			--Get the BaseY
			local basY = 0;
			local large =  yvals[1];
			for i = 2, #yvals do
				if yvals[i] > large then large = yvals[i] end
			end
			basY = large;
			for i = 1, #yvals do
				yvals[i] = yvals[i]-large;
			end
			--Make the Array
			local supers = "";
			supers = 'local Material = require("materials")\n\n'
			supers = supers.."PlayerBase = {}\n\n";
			supers = supers.."PlayerBase.structure = {\n";
			supers = supers.."numObjects="..num..",\n";
			supers = supers.."baseX="..basX..",\n";
			supers = supers.."baseY="..basY..",\n";
			supers = supers.."totalCost="..total..",\n";
			supers = supers.."id={\n";
			for i = 1, #types do
				supers = supers..types[i]
				if i ~= #types then supers = supers..","; end
			end
			supers = supers.."\n},\n";
			supers = supers.."x_vals={\n";
			for i = 1, #xvals do
				supers = supers..xvals[i]
				if i ~= #xvals then supers = supers..","; end
			end
			supers = supers.."\n},\n";
			supers = supers.."y_vals={\n";
			for i = 1, #yvals do
				supers = supers..yvals[i]
				if i ~= #yvals then supers = supers..","; end
			end
			supers = supers.."\n},\n";
			supers = supers.."scaleX={\n";
			for i = 1, #scX do
				supers = supers..scX[i]
				if i ~= #scX then supers = supers..","; end
			end
			supers = supers.."\n},\n";
			supers = supers.."scaleY={\n";
			for i = 1, #scY do
				supers = supers..scY[i]
				if i ~= #scY then supers = supers..","; end
			end
			supers = supers.."\n},\n";
			supers = supers.."rotations={\n";
			for i = 1, #rotation do
				supers = supers..rotation[i]
				if i ~= #rotation then supers = supers..","; end
			end
			supers = supers.."\n}\n}\n\nreturn PlayerBase";
			--local path = system.pathForFile( "playerbase.lua", system.ResourceDirectory )
			local path = system.pathForFile( "", system.ResourceDirectory )
			local file = io.open( path.."slot"..slot..".lua", "w" )
			file:write( supers )
			io.close( file )
			file = nil
			local successText = display.newText("",50,10,native.systemFont,20);
			local function deleteText()
				successText:removeSelf()
			end
			successText.text = "Load Successful!";
			successTime = maxSuccessTime;
			successText:setTextColor(0,255,0);
			timer.performWithDelay(3000,deleteText,1);
		end
	end
end
save_and_load.load = function(slot,group,levelWallet)
	if true then
		local Play	 = require( "slot"..slot )
		local player = Play.structure;
		local Materials = require( "materials" )
		if player.totalCost <= levelWallet then
			local wallet = levelWallet - player.totalCost;
			--Destroy All Children Objects Before Loading
			local num = group.numChildren;
			while num >= 1 do
				local c = group[num];
				if c.child ~= nil then
					group:remove(num)
					--c:removeSelf();
				end
				num = num - 1;
			end
			for i=1,player.numObjects do
				local baseX = player.baseX;
				local baseY = player.baseY;
				-- first clone: so obj.img refers to proper image
				-- second clone: to pass data to object
				obj = Materials.clone(player.id[i])
				--obj:scale(obj.scaleX,obj.scaleY)
				obj.x = player.x_vals[i]+baseX;
				obj.y = player.y_vals[i]+baseY
				obj.id = player.id[i];
				obj.rotation = player.rotations[i]
				obj.child = "Child";
				physics.addBody(obj, {density=obj.density,friction=obj.friction,bounce=obj.bounce,shape=obj.shape} )
				group:insert(obj)
			end
			local successText = display.newText("",50,10,native.systemFont,20);
			local function deleteText()
				successText:removeSelf()
			end
			successText.text = "Load Successful!";
			successTime = maxSuccessTime;
			successText:setTextColor(0,255,0);
			timer.performWithDelay(3000,deleteText,1);
		else
			local successText = display.newText("",50,10,native.systemFont,20);
			local function deleteText()
				successText:removeSelf()
			end
			successText.text = "Not Enough Money!";
			successTime = maxSuccessTime;
			successText:setTextColor(255,0,0);
			timer.performWithDelay(3000,deleteText,1);
		end
		return group;
	end
end
		
return save_and_load