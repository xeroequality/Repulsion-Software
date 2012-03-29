--Modularized Version of the Pause Overlay

pauseMenu = {};

pauseMenu.createOverlay = function(group)
	--Set Up the Width and Height Variables
		local w = display.contentWidth; local h = display.contentHeight;
		--Overlay Animation Variables
		local anim_time = 15; --How Much Time Spent for Overlay Animation (Both Ways)
		local now_time = 0; --The Current Time for the Current Animation
		local b = 25; local iw = 96*(2/3);
		local r_alpha = 0; --Overlay's Starting Alpha Value
		local s_alpha = 0.7; --Shade Final Alpha Value
		local r_scale = 0.75; --Overlay's Starting Scale
		local nr_scale = r_scale; --Overlay's Current Scale
		local once = false; --Preliminary Things Before Animating
		local r_w = (5*iw)+(2*b); --Length of the Overlay Rectangle
		local r_h = 256; --Height of the Overlay Rectangle
		local overlay_section = "Main"; --Which Section of the Overlay are We In?
		local showInfo = false; --Showing Some Text?
		local slot = 0;
		
		--Make the Overlay Rectangle
		local overlayshade = display.newRect(-w,0,w*3,h); --The Shady Part of the Screen
		overlayshade:setFillColor(0,0,0); overlayshade.alpha = 0;
		local overlayrect = display.newImageRect("../images/overlay_grey.png",r_w,r_h);
		overlayrect.alpha = 0; overlayrect.x = (w/2); overlayrect.y = (h/2);
		local overlayGroup = display.newGroup();
		
		--Buttons
		local pauseText = display.newText("PAUSE",(w/2)-55,(h/2)-(r_h/2),"Arial Black",30);
		local backBtn= display.newImage("../images/btn_back.png");
		backBtn.x = (w/2); backBtn.y = (h/2)+(r_h/2)-30;
		local restartBtn = display.newImage("../images/btn_restart_level.png");
		restartBtn.x = (w/2); restartBtn.y = (h/2)+(r_h/2)-110;
		local exitBtn = display.newImage("../images/btn_exit_level.png");
		exitBtn.x = (w/2); exitBtn.y = (h/2)+(r_h/2)-70;
		local loadBtn = display.newImage("../images/btn_load.png");
		loadBtn.x = (w/2); loadBtn.y = (h/2)+(r_h/2)-150; loadBtn.section = "Load";
		local saveBtn = display.newImage("../images/btn_save.png");
		saveBtn.x = (w/2); saveBtn.y = (h/2)+(r_h/2)-190; saveBtn.section = "Save";
		local settingsBtn = display.newImage("../images/btn_gear.png");
		settingsBtn.x = (w/2)+150; settingsBtn.y = (h/2)+(r_h/2)-35;
		
		--Slots
		local slots = {};
		for k = 1, 20 do
			if k <= 10 then
				slots[k] = display.newImage("../images/btn_slot"..k..".png");
				if k <= 5 then
					slots[k].x = (w/2)-75-50;
					slots[k].y = (h/2)-(r_h/2)+(k*40);
				else
					slots[k].x = (w/2)-75+50;
					slots[k].y = (h/2)-(r_h/2)+((k-5)*40);
				end
				slots[k].alpha = 0;
				slots[k].movy = "Yes";
				slots[k].slot = k;
			else
				slots[k] = display.newImage("../images/btn_nosave.png");
				if k <= 15 then
					slots[k].x = (w/2)-75-50;
					slots[k].y = (h/2)-(r_h/2)+((k-10)*40);
				else
					slots[k].x = (w/2)-75+50;
					slots[k].y = (h/2)-(r_h/2)+((k-15)*40);
				end
				slots[k].alpha = 0;
				slots[k].movy = "Yes";
				slots[k].slot = (k-10);
			end
		end
		local backMainBtn = display.newImage("../images/btn_back.png");
		backMainBtn.x = (w/2)-75; backMainBtn.y = (h/2)-(r_h/2)+(6*40)-5; backMainBtn.alpha = 0; backMainBtn.section = "Main";
		local overwriteBtn = display.newImage("../images/btn_overwrite.png");
		overwriteBtn.x = (w/2)+75+20; overwriteBtn.y = (h/2)-(r_h/2)+(6*40)-5;
		local loadCBtn = display.newImage("../images/btn_loadconfirm.png");
		loadCBtn.x = (w/2)+75+20; loadCBtn.y = (h/2)-(r_h/2)+(6*40)-5;
		local menuText = display.newText("Stuff",0,0,native.systemFont,12);
		menuText.x = (w/2)+75; menuText.y = (h/2)-80;
		
		backBtn.alpha = 0;
		pauseText.alpha = 0;
		restartBtn.alpha = 0;
		exitBtn.alpha = 0;
		loadBtn.alpha = 0;
		saveBtn.alpha = 0;
		overwriteBtn.alpha = 0;
		loadCBtn.alpha = 0;
		menuText.alpha = 0;
		settingsBtn.alpha = 0;
		
		overlayshade.movy = "Yes"; overlayrect.movy = "Yes"; saveBtn.movy = "Yes"; loadBtn.movy = "Yes"; backMainBtn.movy = "Yes";
		pauseText.movy = "Yes"; backBtn.movy = "Yes"; restartBtn.movy = "Yes"; exitBtn.movy = "Yes"; overwriteBtn.movy = "Yes"
		loadCBtn.movy = "Yes"; menuText.movy = "Yes"; settingsBtn.movy = "Yes";
		
		group:insert(overlayshade)
		group:insert(overlayrect)
		group:insert(backBtn)
		group:insert(pauseText);
		group:insert(restartBtn);
		group:insert(exitBtn);
		group:insert(loadBtn);
		group:insert(saveBtn);
		group:insert(backMainBtn);
		group:insert(overwriteBtn);
		group:insert(settingsBtn);
		group:insert(loadCBtn);
		group:insert(menuText);
		for k = 1, 20 do
			group:insert(slots[k]);
		end
end

pauseMenu.assertDepth = function(group)
	group:insert(overlayshade)
	group:insert(overlayrect)
	group:insert(backBtn)
	group:insert(pauseText);
	group:insert(restartBtn);
	group:insert(exitBtn);
	group:insert(loadBtn);
	group:insert(saveBtn);
	group:insert(backMainBtn);
	group:insert(overwriteBtn);
	group:insert(settingsBtn);
	group:insert(loadCBtn);
	group:insert(menuText);
	for k = 1, 20 do
		group:insert(slots[k]);
	end
end

return pauseMenu;